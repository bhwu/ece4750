//=========================================================================
// Baseline Blocking Cache
//=========================================================================

`ifndef LAB3_MEM_BLOCKING_CACHE_BASE_V
`define LAB3_MEM_BLOCKING_CACHE_BASE_V

`include "vc/mem-msgs.v"
`include "vc/trace.v"

`include "lab3_mem/BlockingCacheBaseCtrlVRTL.v"
`include "lab3_mem/BlockingCacheBaseDpathVRTL.v"

// Note on p_num_banks:
// In a multi-banked cache design, cache lines are interleaved to
// different cache banks, so that consecutive cache lines correspond to a
// different bank. The following is the addressing structure in our
// four-banked data caches:
//
// +--------------------------+--------------+--------+--------+--------+
// |        22b               |     4b       |   2b   |   2b   |   2b   |
// |        tag               |   index      |bank idx| offset | subwd  |
// +--------------------------+--------------+--------+--------+--------+
//
// We will compose a four-banked cache in lab5, the multi-core lab

module lab3_mem_BlockingCacheBaseVRTL
#(
  parameter p_num_banks    = 0               // Total number of cache banks
)
(
  input  logic           clk,
  input  logic           reset,

  // Cache Request

  input  mem_req_4B_t    cachereq_msg,
  input  logic           cachereq_val,
  output logic           cachereq_rdy,

  // Cache Response

  output mem_resp_4B_t   cacheresp_msg,
  output logic           cacheresp_val,
  input  logic           cacheresp_rdy,

  // Memory Request

  output mem_req_16B_t   memreq_msg,
  output logic           memreq_val,
  input  logic           memreq_rdy,

  // Memory Response

  input  mem_resp_16B_t  memresp_msg,
  input  logic           memresp_val,
  output logic           memresp_rdy
);

  localparam size = 256; // Number of bytes in the cache
  localparam dbw  = 32;  // Short name for data bitwidth
  localparam abw  = 32;  // Short name for addr bitwidth
  localparam clw  = 128; // Short name for cacheline bitwidth

  // calculate the index shift amount based on number of banks

  localparam c_idx_shamt = $clog2( p_num_banks );

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Define wires
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  // ------------- Control signals CTRL -> Data Path ------------------ //
  // Cache request & memory response interface
  logic                        cachereq_en;
  logic                        memresp_en;
  // Mux signal
  logic                        write_data_mux_sel;
  // Array enable signals
  logic                        tag_array_ren;
  logic                        tag_array_wen;
  logic                        data_array_ren;
  logic                        data_array_wen;
  logic [15:0]                 data_array_wben;
  // reg enables and mux signals after arrays
  logic                        read_data_reg_en;
  logic                        evict_addr_reg_en;
  logic [1:0]                  read_word_mux_sel;
  logic                        memreq_addr_mux_sel;
  // Cache response & memory request interface
  logic [2:0]                  cacheresp_type;
  logic                        hit;
  logic [2:0]                  memreq_type;
  logic                        cacheresp_data_mux_sel;
  // ------------- Control signals Data Path -> CTRL ------------------ //
  // Cache request & memory response interface
  logic [2:0]                  cachereq_type;
  // Addr signal
  logic [31:0]                 cachereq_addr;
  // tag_match
  logic                        tag_match;
  // Index
  logic [3:0]                   idx;
  
  //----------------------------------------------------------------------
  // Control
  //----------------------------------------------------------------------

  lab3_mem_BlockingCacheBaseCtrlVRTL
  #(
    .p_idx_shamt            (c_idx_shamt)
  )
  ctrl
  (
   .clk               (clk),
   .reset             (reset),

   // Cache Request

   .cachereq_val      (cachereq_val),
   .cachereq_rdy      (cachereq_rdy),

   // Cache Response

   .cacheresp_val     (cacheresp_val),
   .cacheresp_rdy     (cacheresp_rdy),

   // Memory Request

   .memreq_val        (memreq_val),
   .memreq_rdy        (memreq_rdy),

   // Memory Response

   .memresp_val       (memresp_val),
   .memresp_rdy       (memresp_rdy),

   //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
   // LAB TASK: Connect control unit
   //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

   // ------------- Control signals CTRL -> Data Path ------------------ //
   // Cache request & memory response interface
   .cachereq_en(cachereq_en),
   .memresp_en(memresp_en),
   // Mux signal
   .write_data_mux_sel(write_data_mux_sel),
   // Array enable signals
   .tag_array_ren(tag_array_ren),
   .tag_array_wen(tag_array_wen),
   .data_array_ren(data_array_ren),
   .data_array_wen(data_array_wen),
   .data_array_wben(data_array_wben),
   // reg enables and mux signals after arrays
   .read_data_reg_en(read_data_reg_en),
   .evict_addr_reg_en(evict_addr_reg_en),
   .read_word_mux_sel(read_word_mux_sel),
   .memreq_addr_mux_sel(memreq_addr_mux_sel),
   // Cache response & memory request interface
   .cacheresp_type(cacheresp_type),
   .hit(hit),
   .memreq_type(memreq_type),
   .cacheresp_data_mux_sel(cacheresp_data_mux_sel),
   // ------------- Control signals Data Path -> CTRL ------------------ //
   // Cache request & memory response interface
   .cachereq_type(cachereq_type),
   // Addr signal
   .cachereq_addr(cachereq_addr),
   // tag_match
   .tag_match(tag_match),
   // Index
   .idx(idx)
  );

  //----------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  lab3_mem_BlockingCacheBaseDpathVRTL
  #(
    .p_idx_shamt            (c_idx_shamt)
  )
  dpath
  (
   .clk               (clk),
   .reset             (reset),

   // Cache Request

   .cachereq_msg      (cachereq_msg),

   // Cache Response

   .cacheresp_msg     (cacheresp_msg),

   // Memory Request

   .memreq_msg        (memreq_msg),

   // Memory Response

   .memresp_msg       (memresp_msg),

   //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
   // LAB TASK: Connect data path
   //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

   // ------------- Control signals CTRL -> Data Path ------------------ //
   // Cache request & memory response interface
   .cachereq_en(cachereq_en),
   .memresp_en(memresp_en),
   // Mux signal
   .write_data_mux_sel(write_data_mux_sel),
   // Array enable signals
   .tag_array_ren(tag_array_ren),
   .tag_array_wen(tag_array_wen),
   .data_array_ren(data_array_ren),
   .data_array_wen(data_array_wen),
   .data_array_wben(data_array_wben),
   // reg enables and mux signals after arrays
   .read_data_reg_en(read_data_reg_en),
   .evict_addr_reg_en(evict_addr_reg_en),
   .read_word_mux_sel(read_word_mux_sel),
   .memreq_addr_mux_sel(memreq_addr_mux_sel),
   // Cache response & memory request interface
   .cacheresp_type(cacheresp_type),
   .hit(hit),
   .memreq_type(memreq_type),
   .cacheresp_data_mux_sel(cacheresp_data_mux_sel),
   // ------------- Control signals Data Path -> CTRL ------------------ //
   // Cache request & memory response interface
   .cachereq_type(cachereq_type),
   // Addr signal
   .cachereq_addr(cachereq_addr),
   // tag_match
   .tag_match(tag_match),
   // Index
   .idx(idx)
  );


  //----------------------------------------------------------------------
  // Line tracing
  //----------------------------------------------------------------------
  vc_MemReqMsg4BTrace cachereq_msg_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (cachereq_val),
    .rdy   (cachereq_rdy),
    .msg   (cachereq_msg)
  );

  vc_MemRespMsg4BTrace cacheresp_msg_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (cacheresp_val),
    .rdy   (cacheresp_rdy),
    .msg   (cacheresp_msg)
  );

  vc_MemReqMsg16BTrace memreq_msg_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (memreq_val),
    .rdy   (memreq_rdy),
    .msg   (memreq_msg)
  );

  vc_MemRespMsg16BTrace memresp_msg_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (memresp_val),
    .rdy   (memresp_rdy),
    .msg   (memresp_msg)
  );

  `ifndef SYNTHESIS
  logic [`VC_TRACE_NBITS-1:0] str;
 
  `VC_TRACE_BEGIN
  begin

     case ( ctrl.state_reg )

       ctrl.STATE_IDLE:                   vc_trace.append_str( trace_str, "(I )" );
       ctrl.STATE_TAG_CHECK:              vc_trace.append_str( trace_str, "(TC)" );
       ctrl.STATE_INIT_DATA_ACCESS:       vc_trace.append_str( trace_str, "(IN)" );
       ctrl.STATE_WAIT:                   vc_trace.append_str( trace_str, "(W )" );
       ctrl.STATE_READ_DATA_ACCESS:       vc_trace.append_str( trace_str, "(RD)" );
       ctrl.STATE_WRITE_DATA_ACCESS:      vc_trace.append_str( trace_str, "(WD)" );
       ctrl.STATE_REFILL_REQUEST:         vc_trace.append_str( trace_str, "(RR)" );
       ctrl.STATE_REFILL_WAIT:            vc_trace.append_str( trace_str, "(RW)" );
       ctrl.STATE_REFILL_UPDATE:          vc_trace.append_str( trace_str, "(RU)" );
       ctrl.STATE_EVICT_PREPARE:          vc_trace.append_str( trace_str, "(EP)" );
       ctrl.STATE_EVICT_REQUEST:          vc_trace.append_str( trace_str, "(ER)" );
       ctrl.STATE_EVICT_WAIT:             vc_trace.append_str( trace_str, "(EW)" );

       default:                           vc_trace.append_str( trace_str, "(? )" );

     endcase

    //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    // LAB TASK: Add line tracing
    //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    // vc_trace.append_str( trace_str, "cache response valid " );
    // $sformat( str, "%x ", ctrl.cacheresp_val );
    // vc_trace.append_str( trace_str, str ); 

    vc_trace.append_str( trace_str, " cachereq_addr_shifted " );
    $sformat( str, "%x ", dpath.cachereq_addr_shifted );
    vc_trace.append_str( trace_str, str );  
    
    vc_trace.append_str( trace_str, " tag " );
    $sformat( str, "%x ", dpath.cachereq_addr[31:4] );
    vc_trace.append_str( trace_str, str );  
    
    vc_trace.append_str( trace_str, " idx " );
    $sformat( str, "%x ", dpath.idx );
    vc_trace.append_str( trace_str, str );  
           
    vc_trace.append_str( trace_str, " hit " );
    $sformat( str, "%x ", ctrl.hit );
    vc_trace.append_str( trace_str, str );  


  end
  `VC_TRACE_END
  
  `endif /* SYNTHESIS */

endmodule

`endif
