//=========================================================================
// Ring-based network
//=========================================================================

`ifndef LAB4_NET_RING_NET_V
`define LAB4_NET_RING_NET_V

`include "vc/net-msgs.v"
`include "lab4_net/RouterVRTL.v"

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
`include "vc/queues.v"

// Helper macros to calculate previous and next router ids

`define PREV(i_) ( ( i_ + c_num_ports - 1 ) % c_num_ports )
`define NEXT(i_) i_

module lab4_net_RingNetVRTL
#(
  parameter p_payload_nbits = 32
)
(
  input logic clk,
  input logic reset,

  input  net_hdr_t [c_nports-1:0]                      in_msg_hdr,
  input  logic     [c_nports-1:0][p_payload_nbits-1:0] in_msg_payload,
  input  logic     [c_nports-1:0]                      in_val,
  output logic     [c_nports-1:0]                      in_rdy,

  output net_hdr_t [c_nports-1:0]                      out_msg_hdr,
  output logic     [c_nports-1:0][p_payload_nbits-1:0] out_msg_payload,
  output logic     [c_nports-1:0]                      out_val,
  input  logic     [c_nports-1:0]                      out_rdy
);
  // c_nports included for convenience to avoid having magic numbers, but 
  // your design does not need to support other values of c_nports.
  localparam c_nports = 4;
  localparam dest_src_nbits  = $clog2(c_nports);
  localparam opq_nbits       = 8;
  localparam hdr_nbits       = opq_nbits + dest_src_nbits + dest_src_nbits;
  localparam msg_nbits       = hdr_nbits + p_payload_nbits;
  localparam dest_s          = msg_nbits-1;
  localparam dest_e          = msg_nbits-dest_src_nbits;
  localparam src_s           = msg_nbits-1-dest_src_nbits;
  localparam src_e           = msg_nbits-dest_src_nbits-dest_src_nbits;
  localparam opq_s           = p_payload_nbits + opq_nbits - 1;
  localparam opq_e           = p_payload_nbits;
 
 

  //----------------------------------------------------------------------
  // Define Router Interface
  //----------------------------------------------------------------------
  net_hdr_t [c_nports-1:0]                      r_west_in_hdr;     // input 0 of the routers
  logic     [c_nports-1:0][p_payload_nbits-1:0] r_west_in_payload;
  logic     [c_nports-1:0]                      r_west_in_val;
  logic     [c_nports-1:0]                      r_west_in_rdy;

  net_hdr_t [c_nports-1:0]                      r_west_out_hdr;    // output 0 of the routers
  logic     [c_nports-1:0][p_payload_nbits-1:0] r_west_out_payload;
  logic     [c_nports-1:0]                      r_west_out_val;
  logic     [c_nports-1:0]                      r_west_out_rdy;

  net_hdr_t [c_nports-1:0]                      r_east_in_hdr;     // input 2 of the routers
  logic     [c_nports-1:0][p_payload_nbits-1:0] r_east_in_payload;
  logic     [c_nports-1:0]                      r_east_in_val;
  logic     [c_nports-1:0]                      r_east_in_rdy;

  net_hdr_t [c_nports-1:0]                      r_east_out_hdr;    // output 2 of the routers
  logic     [c_nports-1:0][p_payload_nbits-1:0] r_east_out_payload;
  logic     [c_nports-1:0]                      r_east_out_val;
  logic     [c_nports-1:0]                      r_east_out_rdy;

  //----------------------------------------------------------------------
  // Define Routers
  //----------------------------------------------------------------------
  genvar i;  
  generate
    for(i=0; i< c_nports; i=i+1) begin: ROUTER
      lab4_net_RouterVRTL 
      #(
      .p_payload_nbits(p_payload_nbits)
      )
      router
      (
        .clk              (clk),
        .reset            (reset),
        .router_id        (i[1:0]),
        
        .in0_msg_hdr      (r_west_in_hdr[i]), 
        .in0_msg_payload  (r_west_in_payload[i]),
        .in0_val          (r_west_in_val[i]),
        .in0_rdy          (r_west_in_rdy[i]),

        .out0_msg_hdr     (r_west_out_hdr[i]),
        .out0_msg_payload (r_west_out_payload[i]),
        .out0_val         (r_west_out_val[i]),
        .out0_rdy         (r_west_out_rdy[i]),

        .in1_msg_hdr      (in_msg_hdr[i]), 
        .in1_msg_payload  (in_msg_payload[i]),
        .in1_val          (in_val[i]),
        .in1_rdy          (in_rdy[i]),

        .out1_msg_hdr     (out_msg_hdr[i]),
        .out1_msg_payload (out_msg_payload[i]),
        .out1_val         (out_val[i]),
        .out1_rdy         (out_rdy[i]),

        .in2_msg_hdr      (r_east_in_hdr[i]), 
        .in2_msg_payload  (r_east_in_payload[i]),
        .in2_val          (r_east_in_val[i]),
        .in2_rdy          (r_east_in_rdy[i]),

        .out2_msg_hdr     (r_east_out_hdr[i]),
        .out2_msg_payload (r_east_out_payload[i]),
        .out2_val         (r_east_out_val[i]),
        .out2_rdy         (r_east_out_rdy[i])
      );
    end
  endgenerate
  
  //----------------------------------------------------------------------
  // Define Queues Interface 
  //----------------------------------------------------------------------
  logic [c_nports-1:0][msg_nbits-1:0] r_east_in;
  logic [c_nports-1:0][msg_nbits-1:0] r_east_out;
  logic [c_nports-1:0][msg_nbits-1:0] r_west_in;
  logic [c_nports-1:0][msg_nbits-1:0] r_west_out;

       
  genvar j; 
  generate
    for(j=0; j<c_nports; j=j+1) begin: R_OUT_COMBINE
      always_comb begin
      
        r_west_in_hdr[j].dest               =  r_west_in[j][dest_s:dest_e];
        r_west_in_hdr[j].src                =  r_west_in[j][src_s:src_e];
        r_west_in_hdr[j].opaque             =  r_west_in[j][opq_s:opq_e];
        r_west_in_payload[j]                =  r_west_in[j][p_payload_nbits-1:0];

        r_west_out[j][dest_s:dest_e]        =  r_west_out_hdr[j].dest;
        r_west_out[j][src_s:src_e]          =  r_west_out_hdr[j].src;
        r_west_out[j][opq_s:opq_e]          =  r_west_out_hdr[j].opaque;
        r_west_out[j][p_payload_nbits-1:0]  =  r_west_out_payload[j];

        r_east_in_hdr[j].dest               =  r_east_in[j][dest_s:dest_e];
        r_east_in_hdr[j].src                =  r_east_in[j][src_s:src_e];
        r_east_in_hdr[j].opaque             =  r_east_in[j][opq_s:opq_e];
        r_east_in_payload[j]                =  r_east_in[j][p_payload_nbits-1:0];

        r_east_out[j][dest_s:dest_e]        =  r_east_out_hdr[j].dest;
        r_east_out[j][src_s:src_e]          =  r_east_out_hdr[j].src;
        r_east_out[j][opq_s:opq_e]          =  r_east_out_hdr[j].opaque;
        r_east_out[j][p_payload_nbits-1:0]  =  r_east_out_payload[j];
      
      end
    end
  endgenerate
  

  //----------------------------------------------------------------------
  // Define West-Pointing Queues 
  //----------------------------------------------------------------------
  genvar k;  
  generate
    for(k=0; k<c_nports; k=k+1) begin: QUEUES_DEF_WEST
      integer temp1 = k+3;
      logic [1:0] prev;
      assign prev = temp1[1:0];
      vc_Queue#(.p_msg_nbits(msg_nbits)) queues_west
      (
         .clk             (clk),
         .reset           (reset),
         .enq_val         (r_west_out_val[k]),
         .enq_rdy         (r_west_out_rdy[k]),
         .enq_msg         (r_west_out[k]),

         .deq_val         (r_east_in_val[prev]),
         .deq_rdy         (r_east_in_rdy[prev]),
         .deq_msg         (r_east_in[prev]),

         .num_free_entries()
      );
    end
  endgenerate
  

  //----------------------------------------------------------------------
  // Define East-Pointing Queues 
  //----------------------------------------------------------------------
  genvar l; 
  generate
    for(l=0; l<c_nports; l=l+1) begin: QUEUES_DEF_EAST
      integer temp2 = l+1;
      logic [1:0] next;
      assign next = temp2[1:0];
      vc_Queue#(.p_msg_nbits(msg_nbits)) queues_east
      (
         .clk             (clk),
         .reset           (reset),
         .enq_val         (r_east_out_val[l]),
         .enq_rdy         (r_east_out_rdy[l]),
         .enq_msg         (r_east_out[l]),

         .deq_val         (r_west_in_val[next]),
         .deq_rdy         (r_west_in_rdy[next]),
         .deq_msg         (r_west_in[next]),

         .num_free_entries()
      );
    end
  endgenerate
  

  //----------------------------------------------------------------------
  // Line tracing
  //----------------------------------------------------------------------
  genvar m;
  generate
  for (m = 0; m < c_nports; m = m + 1) begin: HEADER
    vc_NetHdrTrace in_hdr_trace
    (
      .clk   (clk),
      .reset (reset),
      .val   (in_val[m]),
      .rdy   (in_rdy[m]),
      .hdr   (in_msg_hdr[m])
    );

    vc_NetHdrTrace out_hdr_trace
    (
      .clk   (clk),
      .reset (reset),
      .val   (out_val[m]),
      .rdy   (out_rdy[m]),
      .hdr   (out_msg_hdr[m])
    );
  end
  endgenerate

  logic [6*8-1:0] in_str;
  logic [6*8-1:0] out_str;

  `VC_TRACE_BEGIN
  begin
    ROUTER[0].router.line_trace( trace_str );
    ROUTER[1].router.line_trace( trace_str );
    ROUTER[2].router.line_trace( trace_str );
    ROUTER[3].router.line_trace( trace_str );
  end
  `VC_TRACE_END

endmodule

`endif /* LAB4_NET_RING_NET_V */
