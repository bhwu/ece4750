//=========================================================================
// Router datapath
//=========================================================================

`ifndef LAB4_NET_ROUTER_DPATH_V
`define LAB4_NET_ROUTER_DPATH_V

`include "vc/net-msgs.v"

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
`include "vc/queues.v"
`include "vc/crossbars.v"

module lab4_net_RouterDpathVRTL
#(
  parameter p_payload_nbits = 32
)
(
  input  logic                           clk,
  input  logic                           reset,

  input  net_hdr_t                       in0_msg_hdr,
  input  logic     [p_payload_nbits-1:0] in0_msg_payload,
  input  logic                           in0_val,
  output logic                           in0_rdy,

  input  net_hdr_t                       in1_msg_hdr,
  input  logic     [p_payload_nbits-1:0] in1_msg_payload,
  input  logic                           in1_val,
  output logic                           in1_rdy,

  input  net_hdr_t                       in2_msg_hdr,
  input  logic     [p_payload_nbits-1:0] in2_msg_payload,
  input  logic                           in2_val,
  output logic                           in2_rdy,

  output net_hdr_t                       out0_msg_hdr,
  output logic     [p_payload_nbits-1:0] out0_msg_payload,

  output net_hdr_t                       out1_msg_hdr,
  output logic     [p_payload_nbits-1:0] out1_msg_payload,

  output net_hdr_t                       out2_msg_hdr,
  output logic     [p_payload_nbits-1:0] out2_msg_payload,
  
  // Control signals
  output logic     [1:0]                 inq_dest0,
  output logic     [1:0]                 inq_dest1,
  output logic     [1:0]                 inq_dest2,
  output logic     [2:0]                 inq_val,
  input  logic     [2:0]                 inq_rdy,
  input  logic     [1:0]                 sel0,
  input  logic     [1:0]                 sel1,
  input  logic     [1:0]                 sel2

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Define additional ports
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
);

  localparam c_nports       = 3;
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
  logic [c_nports-1:0][msg_nbits-1:0]        q_in_msg;
  logic [c_nports-1:0][msg_nbits-1:0]        q_out_msg;
  logic [c_nports:0]                         in_val;
  logic [c_nports-1:0]                       in_rdy;
  logic [c_nports-1:0][inputQ_num_msgs-1:0]  free_entries;

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Combine queue input headers and payloads            
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  assign q_in_msg[0][dest_s:dest_e]       = in0_msg_hdr.dest;
  assign q_in_msg[0][src_s:src_e]         = in0_msg_hdr.src;
  assign q_in_msg[0][opq_s:opq_e]         = in0_msg_hdr.opaque;
  assign q_in_msg[0][p_payload_nbits-1:0] = in0_msg_payload;

  assign q_in_msg[1][dest_s:dest_e]       = in1_msg_hdr.dest;
  assign q_in_msg[1][src_s:src_e]         = in1_msg_hdr.src;
  assign q_in_msg[1][opq_s:opq_e]         = in1_msg_hdr.opaque;
  assign q_in_msg[1][p_payload_nbits-1:0] = in1_msg_payload;

  assign q_in_msg[2][dest_s:dest_e]       = in2_msg_hdr.dest;
  assign q_in_msg[2][src_s:src_e]         = in2_msg_hdr.src;
  assign q_in_msg[2][opq_s:opq_e]         = in2_msg_hdr.opaque;
  assign q_in_msg[2][p_payload_nbits-1:0] = in2_msg_payload;

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Combine queue input val/rdy signals
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  assign in_val[0] = in0_val;
  assign in_val[1] = in1_val;
  assign in_val[2] = in2_val;

  assign in0_rdy = in_rdy[0];
  assign in1_rdy = in_rdy[1];
  assign in2_rdy = in_rdy[2];
 
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
      .enq_msg         (q_in_msg[k]),

      .deq_val         (inq_val[k]),
      .deq_rdy         (inq_rdy[k]),
      .deq_msg         (q_out_msg[k]),

      .num_free_entries(free_entries[k])
    );
  end
  endgenerate

  assign inq_dest0 = q_out_msg[0][dest_s:dest_e];
  assign inq_dest1 = q_out_msg[1][dest_s:dest_e];
  assign inq_dest2 = q_out_msg[2][dest_s:dest_e];

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Define Crossbar interface logic 
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // *crossbar inputs are queue outputs*
  logic [c_nports-1:0][msg_nbits-1:0] out_msg;

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Crossbar
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  vc_Crossbar3#(msg_nbits) cross_bar
  (
    .in0(q_out_msg[0]),
    .in1(q_out_msg[1]),
    .in2(q_out_msg[2]),

    .sel0(sel0),
    .sel1(sel1),
    .sel2(sel2),

    .out0(out_msg[0]),
    .out1(out_msg[1]),
    .out2(out_msg[2])
  );
 
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Separate crossbar output headers and payloads            
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  assign out0_msg_hdr.dest   = out_msg[0][dest_s:dest_e];
  assign out0_msg_hdr.src    = out_msg[0][src_s:src_e];
  assign out0_msg_hdr.opaque = out_msg[0][opq_s:opq_e];
  assign out0_msg_payload    = out_msg[0][p_payload_nbits-1:0];

  assign out1_msg_hdr.dest   = out_msg[1][dest_s:dest_e];
  assign out1_msg_hdr.src    = out_msg[1][src_s:src_e];
  assign out1_msg_hdr.opaque = out_msg[1][opq_s:opq_e];
  assign out1_msg_payload    = out_msg[1][p_payload_nbits-1:0];

  assign out2_msg_hdr.dest   = out_msg[2][dest_s:dest_e];
  assign out2_msg_hdr.src    = out_msg[2][src_s:src_e];
  assign out2_msg_hdr.opaque = out_msg[2][opq_s:opq_e];
  assign out2_msg_payload    = out_msg[2][p_payload_nbits-1:0];




endmodule

`endif /* LAB4_NET_ROUTER_DPATH_V */
