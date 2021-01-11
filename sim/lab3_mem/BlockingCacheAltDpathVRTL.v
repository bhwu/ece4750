//=========================================================================
// Alternative Blocking Cache Datapath
//=========================================================================

`ifndef LAB3_MEM_BLOCKING_CACHE_ALT_DPATH_V
`define LAB3_MEM_BLOCKING_CACHE_ALT_DPATH_V

`include "vc/mem-msgs.v"

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
`include "vc/regs.v"
`include "vc/muxes.v"
`include "vc/srams.v"
`include "vc/arithmetic.v"

module lab3_mem_BlockingCacheAltDpathVRTL
#(
  parameter p_idx_shamt    = 0
)
(
  input  logic                        clk,
  input  logic                        reset,

  // Cache Request

  input  mem_req_4B_t                 cachereq_msg,

  // Cache Response

  output mem_resp_4B_t                cacheresp_msg,

  // Memory Request

  output mem_req_16B_t                memreq_msg,

  // Memory Response

  input  mem_resp_16B_t               memresp_msg,

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Add dpath signals
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // ------------- Control signals CTRL -> Data Path ------------------ //
  
  // Cache request & memory response interface
  input logic                         cachereq_en,
  input logic                         memresp_en,
  // Mux signal
  input logic                         write_data_mux_sel,
  // Array enable signals
  input logic                         tag_array_ren,
  input logic                         tag_array_wen0,
  input logic                         tag_array_wen1,
  input logic                         data_array_ren,
  input logic                         data_array_wen,
  input logic [15:0]                  data_array_wben,
  // reg enables and mux signals after arrays
  input logic                         read_data_mux_sel,
  input logic                         read_data_reg_en,
  input logic                         evict_addr_reg_en,
  input logic [1:0]                   read_word_mux_sel,
  input logic                         memreq_addr_mux_sel,
  // Cache response & memory request interface
  input logic [2:0]                   cacheresp_type,
  input logic                         hit,
  input logic [2:0]                   memreq_type,
  input logic                         cacheresp_data_mux_sel,
  input logic                         mkaddr_mux_sel,
  input logic                         victim,
  // ------------- Control signals Data Path -> CTRL ------------------ //
  // Cache request & memory response interface
  output logic [2:0]                  cachereq_type,
  // Addr signal
  output logic [31:0]                 cachereq_addr,
  // tag_match
  output logic                        tag_match0,
  output logic                        tag_match1,
  // Index
  output logic [2:0]                  idx
);

  // local parameters not meant to be set from outside
  localparam size = 256;             // Cache size in bytes
  localparam dbw  = 32;              // Short name for data bitwidth
  localparam abw  = 32;              // Short name for addr bitwidth
  localparam o    = 8;               // Short name for opaque bitwidth
  localparam clw  = 128;             // Short name for cacheline bitwidth
  localparam nbl  = size*8/clw;      // Number of blocks in the cache
  localparam nby  = nbl/2;           // Number of blocks per way
  localparam idw  = $clog2(nby);     // Short name for index bitwidth
  localparam ofw  = $clog2(clw/8);   // Short name for the offset bitwidth
  // In this lab, to simplify things, we always use all bits except for the
  // offset in the tag, rather than storing the "normal" 24 bits. This way,
  // when implementing a multi-banked cache, we don't need to worry about
  // re-inserting the bank id into the address of a cacheline.
  localparam tgw  = abw - ofw;       // Short name for the tag bitwidth

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Implement Dpath
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  // Cache Request
  localparam cachereq_type_bits    = 3;
  localparam cachereq_opaque_bits  = 8;
  localparam cachereq_addr_bits    = 32;
  localparam cachereq_len_bits     = 2;
  localparam cachereq_data_bits    = 32;

  // Cache Response
  localparam cacheresp_type_bits   = 3;
  localparam cacheresp_opaque_bits = 8;
  localparam cacheresp_test_bits   = 2;
  localparam cacheresp_len_bits    = 2;
  localparam cacheresp_data_bits   = 32;
  // Memory Request
  localparam memreq_type_bits      = 3;
  localparam memreq_opaque_bits    = 8;
  localparam memreq_addr_bits      = 32;
  localparam memreq_len_bits       = 4;
  localparam memreq_data_bits      = 128;
  // Memory Response
  localparam memresp_type_bits     = 3;
  localparam memresp_opaque_bits   = 8;
  localparam memresp_test_bits     = 2;
  localparam memresp_len_bits      = 4;
  localparam memresp_data_bits     = 128;

  //----------------------------------------------------------------------
  // Left Registers
  //----------------------------------------------------------------------
  logic [cachereq_opaque_bits - 1 : 0] cachereq_opaque_reg_out;
  vc_EnReg
  #(
    cachereq_opaque_bits
  )
  cachereq_opaque_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(cachereq_opaque_reg_out),     // Data output
    .d(cachereq_msg.opaque),     // Data input
    .en(cachereq_en)     // Enable input
  );

  logic [cachereq_type_bits - 1 : 0] cachereq_type_reg_out;
  assign cachereq_type = cachereq_type_reg_out;
  vc_EnReg
  #(
    cachereq_type_bits
  )
  cachereq_type_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(cachereq_type_reg_out),     // Data output
    .d(cachereq_msg.type_),     // Data input
    .en(cachereq_en)     // Enable input
  );

  logic [cachereq_addr_bits - 1 : 0] cachereq_addr_reg_out;
  assign cachereq_addr = cachereq_addr_reg_out;
  vc_EnReg
  #(
    cachereq_addr_bits
  )
  cachereq_addr_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(cachereq_addr_reg_out),     // Data output
    .d(cachereq_msg.addr),     // Data input
    .en(cachereq_en)     // Enable input
  );

  logic [cachereq_data_bits - 1 : 0] cachereq_data_reg_out;
  vc_EnReg
  #(
    cachereq_data_bits
  )
  cachereq_data_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(cachereq_data_reg_out),     // Data output
    .d(cachereq_msg.data),     // Data input
    .en(cachereq_en)     // Enable input
  );

  // memery response interface registers
  logic [memresp_data_bits - 1 : 0] memresp_data_reg_out;
  vc_EnReg
  #(
    memresp_data_bits
  )
  memresp_data_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(memresp_data_reg_out),     // Data output
    .d(memresp_msg.data),     // Data input
    .en(memresp_en)     // Enable input
  );

  //----------------------------------------------------------------------
  // Replication unit, mux, tag array and data array & reg
  //----------------------------------------------------------------------  

  // Wires setup
  logic [27:0] addr_31_to_4;
  logic [31:0] cachereq_addr_shifted;
  assign cachereq_addr_shifted = cachereq_addr >> p_idx_shamt;
  assign idx                   = cachereq_addr_shifted[6:4];
  assign addr_31_to_4          = cachereq_addr[31:4];

  // Replication unit
  localparam repl_out_bits = 4 * cachereq_data_bits;
  logic [repl_out_bits - 1 : 0] repl_out;
  assign     repl_out     = {4{cachereq_data_reg_out}};
  
  // Mux
  logic [ repl_out_bits - 1 : 0] data_array_mux_out;
  vc_Mux2
  #(
    repl_out_bits
  )
  data_array_mux
  (
    .in0(repl_out), 
    .in1(memresp_data_reg_out),
    .sel(write_data_mux_sel),
    .out(data_array_mux_out)
  );

  // Tag array
  localparam tag_array_data_nbits  = 28;
  localparam tag_array_num_entries = 8;
  logic [tag_array_data_nbits - 1 : 0] tag_array0_read_data_out;
  
  vc_CombinationalBitSRAM_1rw
  #(
    tag_array_data_nbits,
    tag_array_num_entries
  )
  tag_array0
  (
    .clk(clk),
    .reset(reset),

    // Read port (combinational read)
    .read_en(tag_array_ren),
    .read_addr(idx),
    .read_data(tag_array0_read_data_out),

    // Write port (sampled on the rising clock edge)
    .write_en(tag_array_wen0),
    .write_addr(idx),
    .write_data(addr_31_to_4)
  );

  // Tag array
  logic [tag_array_data_nbits - 1 : 0] tag_array1_read_data_out;
  
  vc_CombinationalBitSRAM_1rw
  #(
    tag_array_data_nbits,
    tag_array_num_entries
  )
  tag_array1
  (
    .clk(clk),
    .reset(reset),

    // Read port (combinational read)
    .read_en(tag_array_ren),
    .read_addr(idx),
    .read_data(tag_array1_read_data_out),

    // Write port (sampled on the rising clock edge)
    .write_en(tag_array_wen1),
    .write_addr(idx),
    .write_data(addr_31_to_4)
  );
  
  // Data array
  localparam data_array_data_nbits  = 128;
  localparam data_array_num_entries = 16;
  logic [data_array_data_nbits - 1 : 0] data_array_read_data_out;

  vc_CombinationalSRAM_1rw
  #(
    data_array_data_nbits,
    data_array_num_entries
  )
  data_array
  (
    .clk(clk),
    .reset(reset),

    // Read port (combinational read)
    .read_en(data_array_ren),
    .read_addr({victim, idx}),
    .read_data(data_array_read_data_out),

    // Write port (sampled on the rising clock edge)
    .write_en(data_array_wen),
    .write_byte_en(data_array_wben),
    .write_addr({victim, idx}),
    .write_data(data_array_mux_out)
  );

  // data array out, read_data_reg
  logic [data_array_data_nbits - 1 : 0] read_data_reg_out;
  vc_EnReg
  #(
    data_array_data_nbits
  )
  read_data_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(read_data_reg_out),     // Data output
    .d(data_array_read_data_out),     // Data input
    .en(read_data_reg_en)     // Enable input
  );
  
  // Mux to select read_data_reg_out & data_array_read_data_out
  logic [data_array_data_nbits - 1 : 0] read_data_mux_out;
  vc_Mux2
  #(
    data_array_data_nbits
  )
  read_data_mux
  (
    .in0(data_array_read_data_out), 
    .in1(read_data_reg_out),
    .sel(read_data_mux_sel),
    .out(read_data_mux_out)
  );

  //----------------------------------------------------------------------
  // cmp, mkaddr, evict_addr_reg, muxes
  //----------------------------------------------------------------------  
  
  // Comparator
  vc_EqComparator
  #(
    tag_array_data_nbits
  )
  cmp0
  (
    .in0(addr_31_to_4),
    .in1(tag_array0_read_data_out),
    .out(tag_match0)
  );

  // Comparator
  vc_EqComparator
  #(
    tag_array_data_nbits
  )
  cmp1
  (
    .in0(addr_31_to_4),
    .in1(tag_array1_read_data_out),
    .out(tag_match1)
  );

  // Make address
  localparam mkaddr_nbits = 32;
  logic [mkaddr_nbits - 1 : 0] evict_addr_reg_in;
  logic [mkaddr_nbits - 1 : 0] memreq_addr_mux_in1;
  assign evict_addr_reg_in   = {mkaddr_mux_out, 4'h0};
  assign memreq_addr_mux_in1 = {addr_31_to_4, 4'h0};

  // Evict address register
  logic [mkaddr_nbits - 1 : 0] evict_addr_reg_out;
  vc_EnReg
  #(
    mkaddr_nbits
  )
  evict_addr_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(evict_addr_reg_out),     // Data output
    .d(evict_addr_reg_in),     // Data input
    .en(evict_addr_reg_en)     // Enable input
  );

  // Muxes
  logic [27:0] mkaddr_mux_out;
  vc_Mux2
  #(
    28
  )
  mkaddr_mux
  (
    .in0(tag_array0_read_data_out), 
    .in1(tag_array1_read_data_out),
    .sel(mkaddr_mux_sel),
    .out(mkaddr_mux_out)
  );
  
  logic [mkaddr_nbits - 1 : 0] memreq_addr_mux_out;
  vc_Mux2
  #(
    mkaddr_nbits
  )
  memreq_addr_mux
  (
    .in0(evict_addr_reg_out), 
    .in1(memreq_addr_mux_in1),
    .sel(memreq_addr_mux_sel),
    .out(memreq_addr_mux_out)
  );

  localparam read_word_mux_nbits = data_array_data_nbits / 4;
  logic [read_word_mux_nbits - 1 : 0] read_word_mux_out;
  vc_Mux4
  #(
    read_word_mux_nbits
  )
  read_word_mux
  (
    .in0(read_data_mux_out[31:0]), 
    .in1(read_data_mux_out[63:32]), 
    .in2(read_data_mux_out[95:64]), 
    .in3(read_data_mux_out[127:96]),
    .sel(read_word_mux_sel),
    .out(read_word_mux_out)
  );

  logic [read_word_mux_nbits - 1 : 0] cacheresp_data_mux_out;
  vc_Mux2
  #(
    read_word_mux_nbits
  )
  cacheresp_data_mux
  (
    .in0(32'd0), 
    .in1(read_word_mux_out), 
    .sel(cacheresp_data_mux_sel),
    .out(cacheresp_data_mux_out)
  );

  //----------------------------------------------------------------------
  // cache response & memory request interface
  //----------------------------------------------------------------------
  
  // Cache response
  assign cacheresp_msg.opaque = cachereq_opaque_reg_out;
  assign cacheresp_msg.type_  = cacheresp_type;
  assign cacheresp_msg.len    = 2'h0;
  assign cacheresp_msg.test   = {1'b0,hit};
  assign cacheresp_msg.data   = cacheresp_data_mux_out;

  // Memory request
  assign memreq_msg.type_     = memreq_type; 
  assign memreq_msg.len       = 4'h0; 
  assign memreq_msg.addr      = memreq_addr_mux_out; 
  assign memreq_msg.data      = read_data_reg_out; 
  assign memreq_msg.opaque    = 8'd0; 
endmodule

`endif
