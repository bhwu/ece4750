//=========================================================================
// Alternative Blocking Cache Control Unit
//=========================================================================

`ifndef LAB3_MEM_BLOCKING_CACHE_ALT_CTRL_V
`define LAB3_MEM_BLOCKING_CACHE_ALT_CTRL_V

`include "vc/mem-msgs.v"
`include "vc/assert.v"

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

module lab3_mem_BlockingCacheAltCtrlVRTL
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
  // LAB TASK: Add control signals
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // ------------- Control signals CTRL -> Data Path ------------------ //
  
  // Cache request & memory response interface
  output logic                        cachereq_en,
  output logic                        memresp_en,
  // Mux signal
  output logic                        write_data_mux_sel,
  // Array enable signals
  output logic                        tag_array_ren,
  output logic                        tag_array_wen0,
  output logic                        tag_array_wen1,  
  output logic                        data_array_ren,
  output logic                        data_array_wen,
  output logic [15:0]                 data_array_wben,
  // reg enables and mux signals after arrays
  output logic                        read_data_mux_sel,
  output logic                        read_data_reg_en,
  output logic                        evict_addr_reg_en,
  output logic [1:0]                  read_word_mux_sel,
  output logic                        memreq_addr_mux_sel,
  // Cache response & memory request interface
  output logic [2:0]                  cacheresp_type,
  output logic                        hit,
  output logic [2:0]                  memreq_type,
  output logic                        cacheresp_data_mux_sel, 
  output logic                        mkaddr_mux_sel,   
  output logic                        victim,
  // ------------- Control signals Data Path -> CTRL ------------------ //
  // Cache request & memory response interface
  input logic [2:0]                   cachereq_type,
  // Addr signal
  input logic [31:0]                  cachereq_addr,
  // tag_match
  input  logic                        tag_match0,
  input  logic                        tag_match1,
  // Index
  input  logic [2:0]                  idx
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
  // LAB TASK: Implement Control Unit
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //----------------------------------------------------------------------
  //Valid & Dirty Handling, Hit reg, Victim, Used
  //----------------------------------------------------------------------
  
  // valid
  logic [7:0]  valid0;
  logic [7:0]  valid_next0;
  logic [7:0]  valid1;
  logic [7:0]  valid_next1;
  logic        valid_act;
  // dirty
  logic [7:0]  dirty0;
  logic [7:0]  dirty_next0;
  logic [7:0]  dirty1;
  logic [7:0]  dirty_next1;
  logic [1:0]  dirty_act;
  // hit
  logic        hit0;
  logic        hit_next0;
  logic        hit1;
  logic        hit_next1;
  logic        hit_act;
  // victim
  logic        victim;
  logic        victim_next;
  logic        victim_act;
  // used
  logic [7:0]  used;
  logic [7:0]  used_next;
  logic        used_act;
  
  

  always_comb begin
    // valid
    valid_next0 = (valid_act && vtm0) ? (valid0 | idx_line) : valid0;
    valid_next1 = (valid_act && vtm1) ? (valid1 | idx_line) : valid1;
    // hit
    hit_next0   = hit_act   ? hit_val0 : hit0;
    hit_next1   = hit_act   ? hit_val1 : hit1;
    // dirty way0
    if      (dirty_act == d_mark  && vtm0)  dirty_next0 = dirty0 | idx_line ;
    else if (dirty_act == d_keep  && vtm0)  dirty_next0 = dirty0;
    else if (dirty_act == d_clean && vtm0)  dirty_next0 = dirty0 & (idx_line ^ 8'hff);
    // dirty way1
    if      (dirty_act == d_mark  && vtm1)  dirty_next1 = dirty1 | idx_line ;
    else if (dirty_act == d_keep  && vtm1)  dirty_next1 = dirty1;
    else if (dirty_act == d_clean && vtm1)  dirty_next1 = dirty1 & (idx_line ^ 8'hff);
    // victim
    if(victim_act) begin
      if(hit_val0 && tag_match0)      victim_next    = 0;
      else if(hit_val1 && tag_match1) victim_next    = 1;
      else                            victim_next    = !used[idx];
     end
     else                             victim_next    = victim;
  end 
  
  assign hit = hit0 || hit1;
  assign used_next[idx] = used_act ? victim : used[idx]; 
    
  always_ff @(posedge clk) begin
    if(reset) begin
      valid0     <= 8'd0;
      valid1     <= 8'd0;
      dirty0     <= 8'd0;
      dirty1     <= 8'd0;
      hit0       <= 1'b0;
      hit1       <= 1'b0;
      victim     <= 1'b0;
      used       <= 8'd0;
    end
    else begin
      valid0     <= valid_next0;
      valid1     <= valid_next1;
      dirty0     <= dirty_next0;
      dirty1     <= dirty_next1;
      hit0       <= hit_next0;
      hit1       <= hit_next1;
      victim     <= victim_next;
      used       <= used_next;
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
      STATE_IDLE:               if(cachereq_val)                            state_next = STATE_TAG_CHECK;
                                else                                        state_next = STATE_IDLE;
      STATE_TAG_CHECK:          if(cachereq_type == mem_init)               state_next = STATE_INIT_DATA_ACCESS;
                                else if((hit_val0 || hit_val1) && cachereq_type == mem_rd) 
                                                                            state_next = STATE_READ_DATA_ACCESS;
                                else if((hit_val0 || hit_val1) && cachereq_type == mem_wr) 
                                                                            state_next = STATE_WRITE_DATA_ACCESS;
                                else if((!dirty0[idx] && victim_next == 0) || (!dirty1[idx] && victim_next == 1))                        
                                                                            state_next = STATE_REFILL_REQUEST;
                                else if((dirty0[idx] && victim_next == 0)  || (dirty1[idx] && victim_next == 1))                         
                                                                            state_next = STATE_EVICT_PREPARE;
                                else                                        state_next = STATE_TAG_CHECK;     
      
      STATE_INIT_DATA_ACCESS:   if(cacheresp_rdy)                           
                                begin
                                  if(cachereq_val)                          state_next = STATE_TAG_CHECK;
                                  else                                      state_next = STATE_IDLE;
                                end
                                else                                        state_next = STATE_INIT_DATA_ACCESS;
                                
      STATE_READ_DATA_ACCESS:   if(cacheresp_rdy)                           
                                begin
                                  if(cachereq_val)                          state_next = STATE_TAG_CHECK;
                                  else                                      state_next = STATE_IDLE;
                                end
                                else                                        state_next = STATE_READ_DATA_ACCESS;                                            
      
      STATE_WRITE_DATA_ACCESS:  if(cacheresp_rdy)                           
                                begin
                                  if(cachereq_val)                          state_next = STATE_TAG_CHECK;
                                  else                                      state_next = STATE_IDLE;
                                end
                                else                                        state_next = STATE_WRITE_DATA_ACCESS;
      
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
  
  localparam rd_array    = 1'b0;
  localparam rd_reg      = 1'b1;

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
    input logic        cs_tag_array_wen0,
    input logic        cs_tag_array_wen1,
    input logic        cs_data_array_ren,
    input logic        cs_data_array_wen,
    input logic [15:0] cs_data_array_wben,
    // reg enables and mux signals after arrays
    input logic        cs_read_data_mux_sel,
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
    input logic [1:0]  cs_dirty_act,
    input logic        cs_victim_act,
    input logic        cs_used_act,
    input logic        cs_mkaddr_mux_sel
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
    tag_array_wen0         = cs_tag_array_wen0;
    tag_array_wen1         = cs_tag_array_wen1;
    data_array_ren         = cs_data_array_ren;
    data_array_wen         = cs_data_array_wen;
    data_array_wben        = cs_data_array_wben;
    // reg enables and mux signals after arrays
    read_data_mux_sel      = cs_read_data_mux_sel;
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
    // Victim
    victim_act             = cs_victim_act; 
    // Use
    used_act               = cs_used_act;
    // makeaddr_mux_sel
    mkaddr_mux_sel         = cs_mkaddr_mux_sel;      
  end
  endtask
  
  // Helper Combinational logics
  logic [15:0] w_byte_en;
  logic [7:0]  idx_line;
  logic [2:0]  crq_t;
  logic        rsp_is_rd;
  logic        req_is_wr;
  logic        req_not_init;
  logic [1:0]  offset;
  logic        hit_val0;
  logic        hit_val1;
  logic        vtm0;
  logic        vtm1;
  logic        eot;

  always_comb begin
    if     (offset == 2'b00) w_byte_en = 16'h000f;
    else if(offset == 2'b01) w_byte_en = 16'h00f0;
    else if(offset == 2'b10) w_byte_en = 16'h0f00;
    else                     w_byte_en = 16'hf000;
  end

  assign  idx_line      = (8'd1    << idx);
  assign  crq_t         = cachereq_type;
  assign  offset        = cachereq_addr[3:2];
  assign  rsp_is_rd     = (cacheresp_type == mem_rd) ? resp_data : gnd;
  assign  req_is_wr     = (cachereq_type  == mem_wr);
  assign  req_not_init  = (cachereq_type  != mem_init);    
  assign  hit_val0      = tag_match0 && req_not_init && valid0[idx];
  assign  hit_val1      = tag_match1 && req_not_init && valid1[idx];
  assign  vtm0          = (victim == 0);
  assign  vtm1          = (victim == 1);
  // end of transcation
  assign  eot           = cacheresp_rdy && cacheresp_val;
  
  
  always_comb begin
    case(state_reg)
      //                       cache   memresp  wr_data     tag   tag   tag   data   data  data       rd_data   rd_data  evict  rd_word    memreq       cache      hit      memreq  cache    cache      mem       mem        resp_d      val    dirty     victim  used   makeaddr
      //                       req_en  en       mux_sel     ren   wen0  wen1  ren    wen   wben       mux_sel   reg_en   en     mux_sel    addr_sel     resp_type           type    req_rdy  resp_val   req_val   resp_rdy   mux_sel                                     mux_sel
      STATE_IDLE:              cs(1,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  1,       0,         0,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_TAG_CHECK:         cs(0,   0,       wd_mux_x,   1,    0,    0,    0,     0,    w_none,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     mark,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep ,  mark,   keep,  1'bx );
      STATE_INIT_DATA_ACCESS:  cs(eot, 0,       wd_mux_rp,  0,    vtm0, vtm1, 0,     1,    w_byte_en, dmux_x,   0,       0,     offset,    mm_mux_x,    crq_t,     keep,    mem_x,  eot,     1,         0,        0,         dmux_x,     mark,  d_keep ,  keep,   mark,  1'bx );
      STATE_READ_DATA_ACCESS:  cs(eot, 0,       wd_mux_x,   0,    vtm0, vtm1, 1,     0,    w_none,    rd_array, 1,       0,     offset,    mm_mux_x,    crq_t,     keep,    mem_x,  eot,     1,         0,        0,         resp_data,  mark,  d_keep ,  keep,   mark,  1'bx );
      STATE_WRITE_DATA_ACCESS: cs(eot, 0,       wd_mux_rp,  0,    vtm0, vtm1, 0,     1,    w_byte_en, dmux_x,   0,       0,     offset,    mm_mux_x,    crq_t,     keep,    mem_x,  eot,     1,         0,        0,         dmux_x,     mark,  d_mark ,  keep,   mark,  1'bx );
      STATE_REFILL_REQUEST:    cs(0,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_mk,   mem_x,     keep,    mem_rd, 0,       0,         1,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_REFILL_WAIT:       cs(0,   1,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        1,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_REFILL_UPDATE:     cs(0,   0,       wd_mux_reg, 0,    0,    0,    0,     1,    w_line,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_EVICT_PREPARE:     cs(0,   0,       wd_mux_x,   1,    0,    0,    1,     0,    w_none,    dmux_x,   1,       1,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_clean,  keep,   keep,  vtm1 );
      STATE_EVICT_REQUEST:     cs(0,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    1,        0,       0,     rw_mux_x,  mm_mux_reg,  mem_x,     keep,    mem_wr, 0,       0,         1,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_EVICT_WAIT:        cs(0,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    1,        0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        1,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      default:                 cs(0,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    1,        0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     0,       mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      
    endcase
  end
  
endmodule

`endif
