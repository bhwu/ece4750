`ifndef LAB4_NET_BUS_NET_DPATH_V
`define LAB4_NET_BUS_NET_DPATH_V

`include "vc/net-msgs.v"
`include "vc/buses.v"
`include "vc/queues.v"

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

module lab4_net_BusNetDpathVRTL
#(
  parameter p_payload_nbits = 32
)
(
  input  logic                                         clk,
  input  logic                                         reset,

  // left side ports
  input  logic     [c_nports-1:0]                      in_val,
  output logic     [c_nports-1:0]                      in_rdy,
  input  net_hdr_t [c_nports-1:0]                      in_msg_hdr,
  input  logic     [c_nports-1:0][p_payload_nbits-1:0] in_msg_payload,

  // right side ports
  output net_hdr_t [c_nports-1:0]                      out_msg_hdr,
  output logic     [c_nports-1:0][p_payload_nbits-1:0] out_msg_payload,
  
  // control signals
  output logic     [1:0]                               inq_dest0,
  output logic     [1:0]                               inq_dest1,
  output logic     [1:0]                               inq_dest2,
  output logic     [1:0]                               inq_dest3,
  output logic     [3:0]                               inq_val,
  input  logic     [3:0]                               inq_rdy,
  input  logic     [1:0]                               sel
  
  );
  // c_nports included for convenience to avoid having magic numbers, but 
  // your design does not need to support other values of c_nports.
  localparam c_nports       = 4;
  localparam dest_src_nbits = $clog2(c_nports);
  localparam opq_nbits      = 8;
  localparam msg_nbits      = p_payload_nbits + opq_nbits + dest_src_nbits + dest_src_nbits;
  localparam dest_s         = msg_nbits-1;
  localparam dest_e         = msg_nbits-dest_src_nbits;
  localparam src_s          = msg_nbits-1-dest_src_nbits;
  localparam src_e          = msg_nbits-dest_src_nbits-dest_src_nbits;
  localparam opq_s          = p_payload_nbits + opq_nbits - 1;
  localparam opq_e          = p_payload_nbits;
  localparam inputQ_num_msgs = 2;

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Define queues interface logic
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  logic [c_nports-1:0][msg_nbits-1:0]        q_in_msgs;
  logic [c_nports-1:0][msg_nbits-1:0]        q_out_msgs;
  logic [c_nports-1:0][inputQ_num_msgs-1:0]  free_entries;


  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Combine input headers and payloads into queue input
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
  genvar j;
  generate
  for (j=0; j< c_nports; j = j+1) begin: QUEUES_IN
    assign q_in_msgs[j][dest_s:dest_e]       = in_msg_hdr[j].dest;
    assign q_in_msgs[j][src_s:src_e]         = in_msg_hdr[j].src;
    assign q_in_msgs[j][opq_s:opq_e]         = in_msg_hdr[j].opaque;
    assign q_in_msgs[j][p_payload_nbits-1:0] = in_msg_payload[j];
  end
  endgenerate

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Input Queues
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  genvar k;
  generate
  for (k=0; k< c_nports; k = k+1) begin: QUEUES_DEF
    vc_Queue#(.p_msg_nbits(msg_nbits)) queue
    (
      .clk             (clk),
      .reset           (reset),

      .enq_val         (in_val[k]),
      .enq_rdy         (in_rdy[k]),
      .enq_msg         (q_in_msgs[k]),

      .deq_val         (inq_val[k]),
      .deq_rdy         (inq_rdy[k]),
      .deq_msg         (q_out_msgs[k]),

      .num_free_entries(free_entries[k])
    );
  end
  endgenerate

  assign inq_dest0 = q_out_msgs[0][dest_s:dest_e];
  assign inq_dest1 = q_out_msgs[1][dest_s:dest_e];
  assign inq_dest2 = q_out_msgs[2][dest_s:dest_e];
  assign inq_dest3 = q_out_msgs[3][dest_s:dest_e];

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Define Bus interface logic
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // *bus inputs are queue outputs*
  logic [c_nports-1:0][msg_nbits-1:0] bus_out;
 
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Bus
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
  vc_Bus#(.p_width(msg_nbits)) bus
  (
    .sel    (sel),
    .in_    (q_out_msgs),
    .out    (bus_out)
  );

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Separate bus output headers and payloads
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  genvar i;
  generate
  for (i=0; i < c_nports; i = i+1) begin: BUS_OUTS
    assign out_msg_hdr[i].dest                     = bus_out[i][dest_s:dest_e];
    assign out_msg_hdr[i].src                      = bus_out[i][src_s:src_e];
    assign out_msg_hdr[i].opaque                   = bus_out[i][opq_s:opq_e];
    assign out_msg_payload[i][p_payload_nbits-1:0] = bus_out[i][p_payload_nbits-1:0];
  end
  endgenerate

endmodule

`endif /* LAB4_NET_BUS_NET_DPATH_V */
