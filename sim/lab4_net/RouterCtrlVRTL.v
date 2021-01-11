//=========================================================================
// Router Control Unit
//=========================================================================

`ifndef LAB4_NET_ROUTER_CTRL_V
`define LAB4_NET_ROUTER_CTRL_V

`include "vc/net-msgs.v"

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
`include "vc/arbiters.v"

module lab4_net_RouterCtrlVRTL
(
  input  logic       clk,
  input  logic       reset,
  
  input  logic [1:0] router_id,

  output logic       out0_val,
  input  logic       out0_rdy,

  output logic       out1_val,
  input  logic       out1_rdy,

  output logic       out2_val,
  input  logic       out2_rdy,

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Define additional ports
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  // Control signals
  input  logic [1:0] inq_dest0,
  input  logic [1:0] inq_dest1,
  input  logic [1:0] inq_dest2,
  input  logic [2:0] inq_val,
  output logic [2:0] inq_rdy,
  output logic [1:0] sel0,
  output logic [1:0] sel1,
  output logic [1:0] sel2
);

  localparam p_ninterfaces = 3;
  
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Implement control unit
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Reset handling
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''  
 
  logic [2:0] cs_inq_rdy;
  logic [1:0] cs_sel_itfc0;
  logic [1:0] cs_sel_itfc1;
  logic [1:0] cs_sel_itfc2;
  logic       cs_out0_val;
  logic       cs_out1_val;
  logic       cs_out2_val;
  
  always_comb begin
    if (reset) begin
      inq_rdy  = 3'd0;
      sel0     = 2'bx;
      sel1     = 2'bx;
      sel2     = 2'bx;
      out0_val = 1'b0;
      out1_val = 1'b0;
      out2_val = 1'b0;
    end
    else begin
      inq_rdy  = cs_inq_rdy;
      sel0     = cs_sel_itfc0;
      sel1     = cs_sel_itfc1;
      sel2     = cs_sel_itfc2;
      out0_val = cs_out0_val;
      out1_val = cs_out1_val;
      out2_val = cs_out2_val;
    end
  end

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Routing logic
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
  logic [1:0] in0_target_itfc;
  logic [1:0] in1_target_itfc;
  logic [1:0] in2_target_itfc;

  localparam TARGET_ITFC0       = 2'b00;
  localparam TARGET_ITFC1       = 2'b01;
  localparam TARGET_ITFC2       = 2'b10;
  localparam ROUTE_CLKWISE      = 2'b10;
  localparam ROUTE_ANTI_CLKWISE = 2'b00;
  localparam ROUTE_ABOVE        = 2'b01;
  // Routing Algorithm: Odd/Even
  function [1:0] route_dir;
    input logic [1:0] dest;
    input logic [1:0] router_id;
    logic             router_id_even;
    assign                          router_id_even = (router_id[0] == 0);
    if      (dest == router_id)     route_dir      = ROUTE_ABOVE;
    else if (dest == router_id-1)   route_dir      = ROUTE_ANTI_CLKWISE;
    else if (dest == router_id+1)   route_dir      = ROUTE_CLKWISE;
    else if (router_id_even)        route_dir      = ROUTE_ANTI_CLKWISE;
    else                            route_dir      = ROUTE_CLKWISE;  
  endfunction
  // Routing direction - Target interface map
  task choose_interface(
    input  logic [1:0] dest,
    input  logic [1:0] router_id,
    output logic [1:0] target_itfc
  );
  begin
    case (route_dir(dest, router_id))
      ROUTE_ABOVE:        target_itfc = TARGET_ITFC1;
      ROUTE_CLKWISE:      target_itfc = TARGET_ITFC2;
      ROUTE_ANTI_CLKWISE: target_itfc = TARGET_ITFC0;
      default:            target_itfc = 2'bxx;
    endcase
  end
  endtask

  always_comb begin
    choose_interface(inq_dest0, router_id, in0_target_itfc);
    choose_interface(inq_dest1, router_id, in1_target_itfc);
    choose_interface(inq_dest2, router_id, in2_target_itfc);
  end

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Arbiter logic
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
  // grants
  localparam GRANT_NONE    = 3'b000;
  localparam GRANT_MSG0    = 3'b001;
  localparam GRANT_MSG1    = 3'b010;
  localparam GRANT_MSG2    = 3'b100;

  // "BUSES" for encapsulation purpose
  logic [2:0][2:0]  grants;
  logic [2:0][2:0]  reqs;
  logic [2:0]       ens;
  logic [2:0]       out_vals;
  logic [2:0]       out_rdys;

  // "SCALARS" of the logic
  logic [2:0]       grants0;
  logic [2:0]       grants1;
  logic [2:0]       grants2;
  logic [2:0]       reqs0;
  logic [2:0]       reqs1;
  logic [2:0]       reqs2;
  logic             en0;
  logic             en1;
  logic             en2;

  // connecting the "BUSES" with "SCALARS"
  assign grants0      = grants[0];
  assign grants1      = grants[1];
  assign grants2      = grants[2];
  assign reqs0        = reqs[0];
  assign reqs1        = reqs[1];
  assign reqs2        = reqs[2];
  assign en0          = ens[0];
  assign en1          = ens[1];
  assign en2          = ens[2];
  assign out_vals[0]  = out0_val;
  assign out_vals[1]  = out1_val;
  assign out_vals[2]  = out2_val;
  assign out_rdys[0]  = out0_rdy;
  assign out_rdys[1]  = out1_rdy;
  assign out_rdys[2]  = out2_rdy;

  // instantiating arbiters
  genvar i;
  generate
  for (i = 0; i < p_ninterfaces; i = i + 1) begin : ARBITERS_DEF
    assign reqs[i][0] = (in0_target_itfc == i[1:0] && inq_val[0]);
    assign reqs[i][1] = (in1_target_itfc == i[1:0] && inq_val[1]);
    assign reqs[i][2] = (in2_target_itfc == i[1:0] && inq_val[2]);
    assign ens[i]     = out_vals[i] && out_rdys[i];

    vc_RoundRobinArbEn #( p_ninterfaces ) arbiter
    (
      .clk(clk),
      .reset(reset),
      .en(ens[i]),        // 1 = update priorities
      .reqs(reqs[i]),    // 1 = making a req, 0 = no req
      .grants(grants[i])   // (one-hot) 1 is req won grant
    );
  end
  endgenerate

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Logic for 3 ways
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
  // sel
  localparam SEL_MSG0      = 2'b00;
  localparam SEL_MSG1      = 2'b01;
  localparam SEL_MSG2      = 2'b10;
  localparam SEL_MSGX      = 2'bxx;
  
  // valid helper
  localparam VAL_DEST      = 1'b1;    // depends on destination
  localparam VAL_NONE      = 1'b0;    // nothing is valid
  localparam VAL_X         = 1'bx;   
  
  // "BUSES" for encapsulation purpose
  logic [2:0][1:0] cs_sel_itfcs;
  logic [2:0][1:0] itfc_dests;
  logic [2:0]      val_sel_itfcs;
  logic [2:0]      cs_out_vals;
  logic [2:0][2:0] inq_way_rdys;
  
  // "SCALARS"
  logic [1:0]      itfc0_dest;
  logic            val_sel_itfc0;
  logic [2:0]      inq_way0_rdy;
  logic [1:0]      itfc1_dest;
  logic            val_sel_itfc1;
  logic [2:0]      inq_way1_rdy;
  logic [1:0]      itfc2_dest;
  logic            val_sel_itfc2;
  logic [2:0]      inq_way2_rdy;

  // connecting the "BUSES" with "SCALARS"
  assign cs_sel_itfc0   = cs_sel_itfcs[0];
  assign cs_sel_itfc1   = cs_sel_itfcs[1];
  assign cs_sel_itfc2   = cs_sel_itfcs[2];
  assign itfc0_dest     = itfc_dests[0];
  assign itfc1_dest     = itfc_dests[1];
  assign itfc2_dest     = itfc_dests[2];
  assign val_sel_itfc0  = val_sel_itfcs[0];
  assign val_sel_itfc1  = val_sel_itfcs[1];
  assign val_sel_itfc2  = val_sel_itfcs[2];
  assign cs_out0_val    = cs_out_vals[0];
  assign cs_out1_val    = cs_out_vals[1];
  assign cs_out2_val    = cs_out_vals[2];
  assign inq_way0_rdy   = inq_way_rdys[0];
  assign inq_way1_rdy   = inq_way_rdys[1];
  assign inq_way2_rdy   = inq_way_rdys[2];

  // generate the logic for 3 ways, sel, out_val, and helper for inq_rdy
  genvar j;
  generate
  for (j = 0; j < p_ninterfaces; j = j + 1) begin : WAYS_LOGIC
    // deciding sel0/1/2, itfc0/1/2_dest, val_sel_0/1/2
    task cs0(
      input logic [1:0] cs0_sel,
      input logic [1:0] cs0_dest,
      input logic       cs0_val_sel
    );
    begin
      cs_sel_itfcs[j]        = cs0_sel;
      itfc_dests[j]          = cs0_dest;
      val_sel_itfcs[j]       = cs0_val_sel;
    end
    endtask
    // arbitration results -> sel & helper for out_val
    always_comb begin
      case (grants[j])
        //                 cs_sel     itfc0_dest  val_sel_0      
        GRANT_MSG0:    cs0(SEL_MSG0,  inq_dest0,  VAL_DEST);
        GRANT_MSG1:    cs0(SEL_MSG1,  inq_dest1,  VAL_DEST);
        GRANT_MSG2:    cs0(SEL_MSG2,  inq_dest2,  VAL_DEST);
        GRANT_NONE:    cs0(SEL_MSGX,  2'bxx,      VAL_NONE);
        default :      cs0(SEL_MSGX,  2'bxx,      VAL_X);
      endcase
    end
    // valid when winning arbitration
    assign cs_out_vals[j]     = (val_sel_itfcs[j] == VAL_DEST) ? 1'b1 : 1'b0;
    // inquire ready when winning arbitration and router out interface ready
    assign inq_way_rdys[j][0] = (grants[j] == GRANT_MSG0) && out_rdys[j];
    assign inq_way_rdys[j][1] = (grants[j] == GRANT_MSG1) && out_rdys[j];
    assign inq_way_rdys[j][2] = (grants[j] == GRANT_MSG2) && out_rdys[j];
  end
  endgenerate
  // inq_rdy if ready in either way
  assign cs_inq_rdy = inq_way0_rdy | inq_way1_rdy | inq_way2_rdy;

endmodule

`endif /* LAB4_NET_ROUTER_CTRL_V */
