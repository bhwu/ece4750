//=========================================================================
// Integer Multiplier Variable-Latency Implementation
//=========================================================================

`ifndef LAB1_IMUL_INT_MUL_ALT_V
`define LAB1_IMUL_INT_MUL_ALT_V

`include "vc/trace.v"
`include "lab1_imul/ConsecZeroDetectorVRTL.v"
`include "vc/regs.v"
`include "vc/muxes.v"
`include "vc/arithmetic.v"

// ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// Define datapath and control unit here.
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
module lab1_imul_IntMulAltCtrl
(
  input  logic clk,
  input  logic reset,
  
  //Dataflow signals  
  input  logic req_val,
  output logic req_rdy,
  output logic resp_val,
  input  logic resp_rdy,
  
  //Control signals  
  output logic b_mux_sel,      //sel signal for mux in front of b_reg
  output logic a_mux_sel,      //sel signal for mux in front of a_reg
  output logic result_mux_sel, //sel signal for mux in front of result_reg
  output logic result_en,      //enable for result_reg
  output logic add_mux_sel,    //sel signal for mux after Add

  
  //Data signals  
  input  logic         b_lsb,        //least significant bit of b
  input  logic [2:0]   shift_bits    //the amount of bits to be shifted this cycle
);
  
  //----------------------------------------------------------------------
  //State Definitions
  //----------------------------------------------------------------------
  localparam STATE_IDLE = 2'd0;
  localparam STATE_CALC = 2'd1;
  localparam STATE_DONE = 2'd2;
  
  //----------------------------------------------------------------------
  //Counter Handling
  //----------------------------------------------------------------------

  localparam p_count_nbits = 6;
  
  logic [p_count_nbits-1:0] count;
  logic [p_count_nbits-1:0] count_plus_shifted;
  logic [p_count_nbits-1:0] count_next; 

  vc_SimpleAdder#(p_count_nbits) adderCount
  (
    .in0  (count),
    .in1  ({3'b0, shift_bits}),
    .out  (count_plus_shifted)
  );
  
  vc_Reg#( p_count_nbits ) count_reg
  (
    .clk(clk),
    .q(count),                // Data output
    .d(count_next)            // Data input
  );

  
  //----------------------------------------------------------------------
  //State
  //----------------------------------------------------------------------
  logic [1:0] state_reg;
  logic [1:0] state_next;
  
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
	  STATE_IDLE: if(req_rdy && req_val)     state_next = STATE_CALC;
	  STATE_CALC: if(count >= 31)            state_next = STATE_DONE;
	  STATE_DONE: if(resp_rdy && resp_val)   state_next = STATE_IDLE;
	  default:                               state_next = 2'bxx;
    endcase
  end

  //----------------------------------------------------------------------
  //State Outputs
  //----------------------------------------------------------------------
  localparam b_x = 1'dx;
  localparam b_shift = 1'd0; //input from the shifter
  localparam b_req = 1'd1;   //input from the request
  
  localparam a_x = 1'dx;
  localparam a_shift = 1'd0; //input from the shifter
  localparam a_req = 1'd1;   //input from the request
  
  localparam res_x = 1'dx;
  localparam res_add = 1'd0; //input from the add_mux
  localparam res_0 = 1'd1;   //input 0
  
  localparam add_x = 1'dx;
  localparam add_add = 1'd0; //input from the adder
  localparam add_res = 1'd1; //input from the result_reg
  
  task cs
  (
    input logic                     cs_req_rdy,
    input logic                     cs_resp_val,
    input logic                     cs_b_mux_sel,
    input logic                     cs_a_mux_sel,
    input logic                     cs_result_mux_sel,
    input logic                     cs_add_mux_sel,
    input logic                     cs_result_en,
    input logic [p_count_nbits-1:0] cs_count_next,
  );
  begin
    req_rdy        = cs_req_rdy;
    resp_val       = cs_resp_val;
    b_mux_sel      = cs_b_mux_sel;
    a_mux_sel      = cs_a_mux_sel;
    result_mux_sel = cs_result_mux_sel;
    add_mux_sel    = cs_add_mux_sel;
    result_en      = cs_result_en;
    count_next     = cs_count_next;
  end
  endtask
  
  logic add_and_shift;
  logic shift_only;
  
  assign add_and_shift =  (b_lsb == 1);
  assign shift_only    =  (b_lsb == 0);
  
  always_comb begin
    case(state_reg)
      //             req  resp  b mux    a mux    res mux   add mux  result  count  
      //             rdy  val   sel      sel      sel       sel      en      next
      STATE_IDLE: cs(1,   0,    b_req,   a_req,   res_0,    add_res, 1,      0                  );
      STATE_CALC: if(add_and_shift)
                  cs(0,   0,    b_shift, a_shift, res_add,  add_add, 1,      count_plus_shifted );
                  else
                  cs(0,   0,    b_shift, a_shift, res_add,  add_res, 1,      count_plus_shifted );
      STATE_DONE: cs(0,   1,    b_x,     a_x,     res_x,    add_x,   0,      0                  );
      default:    cs('x, 'x,    b_x,     a_x,     res_x,    add_x,  'x,     'x                  );
    endcase
  end
  
endmodule

module lab1_imul_IntMulAltDpath
(
  input  logic        clk,
  input  logic        reset,

  // Data signals

  input  logic [63:0] req_msg,
  output logic [31:0] resp_msg,
  
  // Control signals
  
  input  logic        a_mux_sel,
  input  logic        b_mux_sel,
  input  logic        result_mux_sel,
  input  logic        result_en,
  input  logic        add_mux_sel,
  
  // Status signals
  
  output logic        b_lsb,
  output logic  [2:0] shift_bits
  
);
  
  localparam c_nbits = 32;
  
  // split out the input operand
  
  logic [c_nbits-1:0] req_msg_a = req_msg[63:32];
  logic [c_nbits-1:0] req_msg_b = req_msg[31:0];
  
  // B Mux 
  
  logic [c_nbits-1:0] b_shift_out;
  logic [c_nbits-1:0] b_mux_out;
  
  vc_Mux2#(c_nbits) b_mux
  (
    .sel  (b_mux_sel),
    .in1  (req_msg_b),
    .in0  (b_shift_out),
    .out  (b_mux_out)
  );
  
  // A Mux
  
  logic [c_nbits-1:0] a_shift_out;
  logic [c_nbits-1:0] a_mux_out;
  
  vc_Mux2#(c_nbits) a_mux
  (
    .sel  (a_mux_sel),
    .in1  (req_msg_a),
    .in0  (a_shift_out),
    .out  (a_mux_out)
  );
  
  // B Reg
  
  logic [c_nbits-1:0] b_reg_out;
  
  vc_Reg#(c_nbits) b_reg
  (
    .clk  (clk),
    .d    (b_mux_out),
    .q    (b_reg_out)
  ); 
  
  assign b_lsb = b_reg_out[0];
  
  // A Reg
  
  logic [c_nbits-1:0] a_reg_out;
  
  vc_Reg#(c_nbits) a_reg
  (
    .clk  (clk),
    .d    (a_mux_out),
    .q    (a_reg_out)
  ); 
  
  // 4-bit detector
  logic [3:0] number_4b;
  assign number_4b = b_reg_out[4:1];
  
  lab1_imul_ConsecZeroDetectorVRTL detector4b
  (
    .number_4b  (number_4b),
    .shift_bits (shift_bits)
  );
  
  // A left shift
  
  vc_LeftLogicalShifter#(c_nbits,3) a_shift
  (
    .in    (a_reg_out),
    .shamt (shift_bits),
    .out   (a_shift_out)
  );
  
  // B right shift
  
  vc_RightLogicalShifter#(c_nbits,3) b_shift
  (
    .in    (b_reg_out),
    .shamt (shift_bits),
    .out   (b_shift_out)
  );
  
  // Result mux 
  
  logic [c_nbits-1:0] add_mux_out;
  logic [c_nbits-1:0] result_mux_out;
  
  vc_Mux2#(c_nbits) result_mux
  (
    .sel  (result_mux_sel),
    .in0  (add_mux_out),
    .in1  (0),
    .out  (result_mux_out)
  );

  
  // Result reg
  
  logic [c_nbits-1:0] result_reg_out;
  
  vc_EnReg#(c_nbits) result_reg
  (
    .clk   (clk),
    .reset (reset),
    .en    (result_en),
    .d     (result_mux_out),
    .q     (result_reg_out)
  );
  
  // Adder
  
  logic [c_nbits-1:0] adder_out;
  
  vc_SimpleAdder#(c_nbits) adder0
  (
    .in0  (a_reg_out),
    .in1  (result_reg_out),
    .out  (adder_out)
  );
  
  // Adder_mux
  
  vc_Mux2#(c_nbits) add_mux
  (
    .sel   (add_mux_sel),
    .in0   (adder_out),
    .in1   (result_reg_out),
    .out   (add_mux_out)
  );
  
  // output
  
  assign resp_msg = result_reg_out;
  
endmodule


//=========================================================================
// Integer Multiplier Variable-Latency Implementation
//=========================================================================

module lab1_imul_IntMulAltVRTL
(
  input  logic        clk,
  input  logic        reset,

  input  logic        req_val,
  output logic        req_rdy,
  input  logic [63:0] req_msg,

  output logic        resp_val,
  input  logic        resp_rdy,
  output logic [31:0] resp_msg
);

  // ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Instantiate datapath and control models here and then connect them
  // together.
  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
  //Control signals  
  logic b_mux_sel;
  logic a_mux_sel;
  logic result_mux_sel;
  logic add_mux_sel;
  logic result_en;
  
  //Data signals  
  logic       b_lsb;
  logic [2:0] shift_bits;
  
  lab1_imul_IntMulAltDpath dpath
  (
    .*
  );
  lab1_imul_IntMulAltCtrl ctrl
  (
    .*
  );
  
  //----------------------------------------------------------------------
  // Line Tracing
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS

  logic [`VC_TRACE_NBITS-1:0] str;
  `VC_TRACE_BEGIN
  begin

    $sformat( str, "%x", req_msg );
    vc_trace.append_val_rdy_str( trace_str, req_val, req_rdy, str );

    vc_trace.append_str( trace_str, "(" );

    // ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
    // Add additional line tracing using the helper tasks for
    // internal state including the current FSM state.
    // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	vc_trace.append_str( trace_str, " shift_bits: " );
	$sformat( str, "%d", shift_bits );
	vc_trace.append_str( trace_str, str );
	vc_trace.append_str( trace_str, " count: " );
	$sformat( str, "%d", ctrl.count );
	vc_trace.append_str( trace_str, str );
	vc_trace.append_str( trace_str, " state_reg: " );
	$sformat( str, "%d", ctrl.state_reg );
	vc_trace.append_str( trace_str, str );
	vc_trace.append_str( trace_str, " result_reg_out: " );
	$sformat( str, "%d", dpath.result_reg_out );
	vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, ")" );

    $sformat( str, "%x", resp_msg );
    vc_trace.append_val_rdy_str( trace_str, resp_val, resp_rdy, str );

  end
  `VC_TRACE_END

  `endif /* SYNTHESIS */

endmodule

`endif /* LAB1_IMUL_INT_MUL_ALT_V */
