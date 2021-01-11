//=========================================================================
// Baseline Blocking Cache Control
//=========================================================================

`ifndef LAB3_MEM_BLOCKING_CACHE_BASE_CTRL_V
`define LAB3_MEM_BLOCKING_CACHE_BASE_CTRL_V

`include "vc/mem-msgs.v"
`include "vc/assert.v"

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

module lab3_mem_BlockingCacheBaseCtrlVRTL
#(
  parameter p_idx_shamt    = 0
)
(
  input  logic                        clk,
  input  logic                        reset,

  // Cache Request

  input  logic                        cachereq_val,
  output logic                        cachereq_rdy,

  // Cache Response

  output logic                        cacheresp_val,
  input  logic                        cacheresp_rdy,

  // Memory Request

  output logic                        memreq_val,
  input  logic                        memreq_rdy,

  // Memory Response

  input  logic                        memresp_val,
  output logic                        memresp_rdy,

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Define additional ports
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 
  // ------------- Control signals CTRL -> Data Path ------------------ //
  
  // Cache request & memory response interface
  output logic                        cachereq_en,
  output logic                        memresp_en,
  // Mux signal
  output logic                        write_data_mux_sel,
  // Array enable signals
  output logic                        tag_array_ren,
  output logic                        tag_array_wen,
  output logic                        data_array_ren,
  output logic                        data_array_wen,
  output logic [15:0]                 data_array_wben,
  // reg enables and mux signals after arrays
  output logic                        read_data_reg_en,
  output logic                        evict_addr_reg_en,
  output logic [1:0]                  read_word_mux_sel,
  output logic                        memreq_addr_mux_sel,
  // Cache response & memory request interface
  output logic [2:0]                  cacheresp_type,
  output logic                        hit,
  output logic [2:0]                  memreq_type,
  output logic                        cacheresp_data_mux_sel,  
  // ------------- Control signals Data Path -> CTRL ------------------ //
  // Cache request & memory response interface
  input logic [2:0]                   cachereq_type,
  // Addr signal
  input logic [31:0]                  cachereq_addr,
  // tag_match
  input  logic                        tag_match,
  // Index
  input  logic [3:0]                  idx  
 );

  // local parameters not meant to be set from outside
  localparam size = 256;             // Cache size in bytes
  localparam dbw  = 32;              // Short name for data bitwidth
  localparam abw  = 32;              // Short name for addr bitwidth
  localparam o    = 8;               // Short name for opaque bitwidth
  localparam clw  = 128;             // Short name for cacheline bitwidth
  localparam nbl  = size*8/clw;      // Number of blocks in the cache
  localparam nby  = nbl;             // Number of blocks per way
  localparam idw  = $clog2(nby);     // Short name for index bitwidth
  localparam ofw  = $clog2(clw/8);   // Short name for the offset bitwidth
  // In this lab, to simplify things, we always use all bits except for the
  // offset in the tag, rather than storing the "normal" 24 bits. This way,
  // when implementing a multi-banked cache, we don't need to worry about
  // re-inserting the bank id into the address of a cacheline.
  localparam tgw  = abw - ofw;       // Short name for the tag bitwidth

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Implement control unit
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //----------------------------------------------------------------------
  //Valid & Dirty Handling, Hit reg
  //----------------------------------------------------------------------
  logic [15:0] valid;
  logic [15:0] valid_next;
  logic        valid_act;
  logic [15:0] dirty;
  logic [15:0] dirty_next;
  logic [1:0]  dirty_act;
  logic        hit_next;
  logic        hit_act;
  
  always_comb begin
    valid_next = valid_act ? (valid | idx_line) : valid;
    hit_next   = hit_act   ? hit_val : hit;
    if      (dirty_act == d_mark)  dirty_next = dirty | idx_line ;
    else if (dirty_act == d_keep)  dirty_next = dirty;
    else if (dirty_act == d_clean) dirty_next = dirty & (idx_line ^ 16'hffff);
  end 
  
  always_ff @(posedge clk) begin
    if(reset) begin
      valid     <= 16'd0;
      dirty     <= 16'd0;
      hit       <= 1'b0;
    end
    else begin
      valid     <= valid_next;
      dirty     <= dirty_next;
      hit       <= hit_next;
    end
  end    
  
  // parameters for states
  localparam STATE_IDLE               = 4'd0;
  localparam STATE_TAG_CHECK          = 4'd1;
  localparam STATE_INIT_DATA_ACCESS   = 4'd2;
  localparam STATE_WAIT               = 4'd3;
  localparam STATE_READ_DATA_ACCESS   = 4'd4;
  localparam STATE_WRITE_DATA_ACCESS  = 4'd5;
  localparam STATE_REFILL_REQUEST     = 4'd6;
  localparam STATE_REFILL_WAIT        = 4'd7;
  localparam STATE_REFILL_UPDATE      = 4'd8;
  localparam STATE_EVICT_PREPARE      = 4'd9;
  localparam STATE_EVICT_REQUEST      = 4'd10;
  localparam STATE_EVICT_WAIT         = 4'd11;

  //----------------------------------------------------------------------
  //State
  //----------------------------------------------------------------------
  
  logic [3:0]  state_reg;
  logic [3:0]  state_next;

  always_ff @(posedge clk) begin
    if(reset) begin
      state_reg <= STATE_IDLE;
    end
    else begin
      state_reg <= state_next;
    end
  end
  
  //----------------------------------------------------------------------
  //State Transitions
  //----------------------------------------------------------------------
  
  always_comb begin
    state_next = state_reg;
    case(state_reg)
      STATE_IDLE:               if(cachereq_rdy && cachereq_val)            state_next = STATE_TAG_CHECK;
                                else                                        state_next = STATE_IDLE;
      STATE_TAG_CHECK:          if(cachereq_type == mem_init)               state_next = STATE_INIT_DATA_ACCESS;
                                else if(hit_val && cachereq_type == mem_rd) state_next = STATE_READ_DATA_ACCESS;
                                else if(hit_val && cachereq_type == mem_wr) state_next = STATE_WRITE_DATA_ACCESS;
                                else if(!dirty[idx])                        state_next = STATE_REFILL_REQUEST;
                                else if(dirty[idx])                         state_next = STATE_EVICT_PREPARE;
                                else                                        state_next = STATE_TAG_CHECK;     
      STATE_INIT_DATA_ACCESS:                                               state_next = STATE_WAIT;
      STATE_READ_DATA_ACCESS:                                               state_next = STATE_WAIT;
      STATE_WRITE_DATA_ACCESS:                                              state_next = STATE_WAIT;
      STATE_REFILL_REQUEST:     if(memreq_rdy)                              state_next = STATE_REFILL_WAIT;
                                else                                        state_next = STATE_REFILL_REQUEST;                          
      STATE_REFILL_WAIT:        if(memresp_val)                             state_next = STATE_REFILL_UPDATE;
                                else                                        state_next = STATE_REFILL_WAIT;
      STATE_REFILL_UPDATE:      if(cachereq_type      == mem_rd)            state_next = STATE_READ_DATA_ACCESS;
                                else if(cachereq_type == mem_wr)            state_next = STATE_WRITE_DATA_ACCESS;
                                else                                        state_next = STATE_REFILL_UPDATE; 
      STATE_EVICT_PREPARE:                                                  state_next = STATE_EVICT_REQUEST;
      STATE_EVICT_REQUEST:      if(memreq_rdy)                              state_next = STATE_EVICT_WAIT;
                                else                                        state_next = STATE_EVICT_REQUEST;
      STATE_EVICT_WAIT:         if(memresp_val)                             state_next = STATE_REFILL_REQUEST;
                                else                                        state_next = STATE_EVICT_WAIT;
      STATE_WAIT:               if(cacheresp_rdy)                           state_next = STATE_IDLE;
                                else                                        state_next = STATE_WAIT;
      
      default:                                                              state_next = 4'bxxxx;
    endcase
  end

  //----------------------------------------------------------------------
  //State Outputs
  //----------------------------------------------------------------------
  
  // ----------------------- Local Parameters ------------------------- //
  localparam wd_mux_rp   = 1'b0;
  localparam wd_mux_reg  = 1'b1;
  localparam wd_mux_x    = 1'bx;

  localparam rw_mux_w3   = 2'b11;
  localparam rw_mux_w2   = 2'b10;
  localparam rw_mux_w1   = 2'b01;
  localparam rw_mux_w0   = 2'b00;
  localparam rw_mux_x    = 2'bxx;

  localparam mm_mux_reg  = 1'b0;
  localparam mm_mux_mk   = 1'b1;
  localparam mm_mux_x    = 1'bx;

  localparam mem_init    = 3'd2;
  localparam mem_rd      = 3'd0;
  localparam mem_wr      = 3'd1;
  localparam mem_x       = 3'dx;

  localparam gnd         = 1'b0;
  localparam resp_data   = 1'b1;
  localparam dmux_x      = 1'bx;
  
  localparam w_line      = 16'hffff;
  localparam w_word0     = 16'h000f;
  localparam w_word1     = 16'h00f0;
  localparam w_word2     = 16'h0f00;
  localparam w_word3     = 16'hf000;
  localparam w_none      = 16'h0000;
  localparam w_wordx     = 16'dx;  
  
  localparam keep        = 1'b0;
  localparam mark        = 1'b1;
  
  localparam d_clean     = 2'b00;
  localparam d_keep      = 2'b01;
  localparam d_mark      = 2'b10;
  
  task cs
  (
    // control signal table inputs
    input logic        cs_cachereq_en,
    input logic        cs_memresp_en,
    // Mux signal
    input logic        cs_write_data_mux_sel,
    // Array enable signals
    input logic        cs_tag_array_ren,
    input logic        cs_tag_array_wen,
    input logic        cs_data_array_ren,
    input logic        cs_data_array_wen,
    input logic [15:0] cs_data_array_wben,
    // reg enables and mux signals after arrays
    input logic        cs_read_data_reg_en,
    input logic        cs_evict_addr_reg_en,
    input logic [1:0]  cs_read_word_mux_sel,
    input logic        cs_memreq_addr_mux_sel,
    // Cache response & memory request interface
    input logic [2:0]  cs_cacheresp_type,
    input logic        cs_hit_act,
    input logic [2:0]  cs_memreq_type,
    input logic        cs_cachereq_rdy,
    input logic        cs_cacheresp_val,
    input logic        cs_memreq_val,
    input logic        cs_memresp_rdy,
    input logic        cs_cacheresp_data_mux_sel,
    // Valid & Dirty
    input logic        cs_valid_act,
    input logic [1:0]  cs_dirty_act
  );
  begin
    // blocking assignment
    // Cache request & memory response interface
    cachereq_en            = cs_cachereq_en;
    memresp_en             = cs_memresp_en;
    // Mux signal
    write_data_mux_sel     = cs_write_data_mux_sel;
    // Array enable signals
    tag_array_ren          = cs_tag_array_ren;
    tag_array_wen          = cs_tag_array_wen;
    data_array_ren         = cs_data_array_ren;
    data_array_wen         = cs_data_array_wen;
    data_array_wben        = cs_data_array_wben;
    // reg enables and mux signals after arrays
    read_data_reg_en       = cs_read_data_reg_en;
    evict_addr_reg_en      = cs_evict_addr_reg_en;
    read_word_mux_sel      = cs_read_word_mux_sel;
    memreq_addr_mux_sel    = cs_memreq_addr_mux_sel;
    // Cache response & memory request interface
    cacheresp_type         = cs_cacheresp_type;
    hit_act                = cs_hit_act;
    memreq_type            = cs_memreq_type;
    // val&rdy interface
    cachereq_rdy           = cs_cachereq_rdy;
    cacheresp_val          = cs_cacheresp_val;
    memreq_val             = cs_memreq_val;
    memresp_rdy            = cs_memresp_rdy;
    // Cache response data mux sel
    cacheresp_data_mux_sel = cs_cacheresp_data_mux_sel;
    // Valid & Dirty
    valid_act              = cs_valid_act;
    dirty_act              = cs_dirty_act;        
  end
  endtask
  
  // Helper Combinational logics
  logic [15:0] w_byte_en;
  logic [15:0] idx_line;
  logic [2:0]  crq_t;
  logic        rsp_is_rd;
  logic        req_is_wr;
  logic        req_not_init;
  logic [1:0]  offset;
  logic        hit_val;

  always_comb begin
    if     (offset == 2'b00) w_byte_en = 16'h000f;
    else if(offset == 2'b01) w_byte_en = 16'h00f0;
    else if(offset == 2'b10) w_byte_en = 16'h0f00;
    else                     w_byte_en = 16'hf000;
  end

  assign  idx_line      = (16'd1    << idx);
  assign  crq_t         = cachereq_type;
  assign  offset        = cachereq_addr[3:2];
  assign  rsp_is_rd     = (cacheresp_type == mem_rd) ? resp_data : gnd;
  assign  req_is_wr     = (cachereq_type  == mem_wr);
  assign  req_not_init  = (cachereq_type  != mem_init);    
  assign  hit_val       = tag_match && req_not_init && valid[idx];
  
  always_comb begin
    case(state_reg)
      //                       cache   memresp  wr_data     tag   tag   data   data  data       rd_data  evict  rd_word    memreq       cache      hit      memreq  cache    cache      mem       mem        resp_d      val    dirty
      //                       req_en  en       mux_sel     ren   wen   ren    wen   wben       reg_en   en     mux_sel    addr_sel     resp_type           type    req_rdy  resp_val   req_val   resp_rdy   mux_sel
      STATE_IDLE:              cs(1,   0,       wd_mux_x,   0,    0,    0,     0,    w_none,    0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  1,       0,         0,        0,         dmux_x,     keep,  d_keep );
      STATE_TAG_CHECK:         cs(0,   0,       wd_mux_x,   1,    0,    0,     0,    w_none,    0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     mark,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep );
      STATE_INIT_DATA_ACCESS:  cs(0,   0,       wd_mux_rp,  0,    1,    0,     1,    w_byte_en, 0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep );
      STATE_READ_DATA_ACCESS:  cs(0,   0,       wd_mux_x,   0,    1,    1,     0,    w_none,    1,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep );
      STATE_WRITE_DATA_ACCESS: cs(0,   0,       wd_mux_rp,  0,    1,    0,     1,    w_byte_en, 0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_mark );
      STATE_REFILL_REQUEST:    cs(0,   0,       wd_mux_x,   0,    0,    0,     0,    w_none,    0,       0,     rw_mux_x,  mm_mux_mk,   mem_x,     keep,    mem_rd, 0,       0,         1,        0,         dmux_x,     keep,  d_keep );
      STATE_REFILL_WAIT:       cs(0,   1,       wd_mux_x,   0,    0,    0,     0,    w_none,    0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        1,         dmux_x,     keep,  d_keep );
      STATE_REFILL_UPDATE:     cs(0,   0,       wd_mux_reg, 0,    0,    0,     1,    w_line,    0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep );
      STATE_EVICT_PREPARE:     cs(0,   0,       wd_mux_x,   1,    0,    1,     0,    w_none,    1,       1,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_clean);
      STATE_EVICT_REQUEST:     cs(0,   0,       wd_mux_x,   0,    0,    0,     0,    w_none,    0,       0,     rw_mux_x,  mm_mux_reg,  mem_x,     keep,    mem_wr, 0,       0,         1,        0,         dmux_x,     keep,  d_keep );
      STATE_EVICT_WAIT:        cs(0,   0,       wd_mux_x,   0,    0,    0,     0,    w_none,    0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        1,         dmux_x,     keep,  d_keep );
      STATE_WAIT:              cs(0,   0,       wd_mux_x,   0,    0,    0,     0,    w_none,    0,       0,     offset,    mm_mux_x,    crq_t,     keep,    mem_x,  0,       1,         0,        0,         rsp_is_rd,  mark,  d_keep );
      default:                 cs(0,   0,       wd_mux_x,   0,    0,    0,     0,    w_none,    0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     0,       mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep );
      
    endcase
  end
  
endmodule

`endif
