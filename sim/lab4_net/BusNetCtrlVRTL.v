`ifndef LAB4_NET_BUS_NET_CTRL_V
`define LAB4_NET_BUS_NET_CTRL_V

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
`include "vc/arbiters.v"

module lab4_net_BusNetCtrlVRTL
(
  input  logic                                 clk,
  input  logic                                 reset,

  output logic [c_nports-1:0]                  out_val,
  input  logic [c_nports-1:0]                  out_rdy,

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Define additional ports
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  // control signals
  input  logic [1:0]                           inq_dest0,
  input  logic [1:0]                           inq_dest1,
  input  logic [1:0]                           inq_dest2,
  input  logic [1:0]                           inq_dest3,
  input  logic [3:0]                           inq_val,
  output logic [3:0]                           inq_rdy,
  output logic [1:0]                           sel
);
  // c_nports included for convenience to avoid having magic numbers, but 
  // your design does not need to support other values of c_nports.
  localparam c_nports = 4;

  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Implement control unit
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  always_comb begin
    if (reset) begin
      sel     = 2'bx;
      inq_rdy = 4'd0;
      out_val = 4'd0;
    end
    else begin
      sel     = cs_sel;
      inq_rdy = cs_inq_rdy;
      out_val = cs_out_val;
    end
  end

  logic [c_nports-1:0] grants;
  vc_RoundRobinArbEn #( c_nports ) arbiter
  (
    .clk(clk),
    .reset(reset),
    .en(en),        // 1 = update priorities
    .reqs(inq_val),    // 1 = making a req, 0 = no req
    .grants(grants)   // (one-hot) 1 is req won grant
  );

  
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // sel, dest, out_val, inq_rdy, en
  //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
  // grants
  localparam GRANT_NONE    = 4'b0000;
  localparam GRANT_MSG0    = 4'b0001;
  localparam GRANT_MSG1    = 4'b0010;
  localparam GRANT_MSG2    = 4'b0100;
  localparam GRANT_MSG3    = 4'b1000;
  // sel
  localparam SEL_MSG0      = 2'b00;
  localparam SEL_MSG1      = 2'b01;
  localparam SEL_MSG2      = 2'b10;
  localparam SEL_MSG3      = 2'b11;
  localparam SEL_MSGX      = 2'bxx;
  // valid helper
  localparam VAL_DEST      = 1'b1;    // depends on destination
  localparam VAL_NONE      = 1'b0;    // nothing is valid
  localparam VAL_X         = 1'bx;   
  // out_val
  localparam OUT_VAL_NONE  = 4'b0000; 
  localparam OUT_VAL_MSG0  = 4'b0001;
  localparam OUT_VAL_MSG1  = 4'b0010;
  localparam OUT_VAL_MSG2  = 4'b0100;
  localparam OUT_VAL_MSG3  = 4'b1000; 
  localparam OUT_VAL_X     = 4'dx;
  // dest
  localparam DEST_MSG0     = 2'b00;
  localparam DEST_MSG1     = 2'b01;
  localparam DEST_MSG2     = 2'b10;
  localparam DEST_MSG3     = 2'b11;
  localparam DEST_MSGX     = 2'bxx;
  // inq_rdy
  localparam INQ_NONE    = 4'b0000;
  localparam INQ_MSG0    = 4'b0001;
  localparam INQ_MSG1    = 4'b0010;
  localparam INQ_MSG2    = 4'b0100;
  localparam INQ_MSG3    = 4'b1000;
  localparam INQ_X       = 4'dx;


  task cs0(
    input logic [1:0] cs0_sel,
    input logic [1:0] cs0_dest,
    input logic       cs0_val_sel,
  );
  begin
    cs_sel     = cs0_sel;
    cs_dest    = cs0_dest;
    cs_val_sel = cs0_val_sel;
  end
  endtask

  logic [1:0] cs_sel;
  logic [1:0] cs_dest;
  logic       cs_val_sel;
  always_comb begin
    case (grants)
      //                     cs_sel     cs_dest     cs_val_sel    
      GRANT_MSG0:        cs0(SEL_MSG0,  inq_dest0,  VAL_DEST );
      GRANT_MSG1:        cs0(SEL_MSG1,  inq_dest1,  VAL_DEST );
      GRANT_MSG2:        cs0(SEL_MSG2,  inq_dest2,  VAL_DEST );
      GRANT_MSG3:        cs0(SEL_MSG3,  inq_dest3,  VAL_DEST );
      GRANT_NONE:        cs0(SEL_MSGX,  2'bxx,      VAL_NONE );
      default :          cs0(SEL_MSGX,  2'bxx,      VAL_X    );
    endcase
  end

  // out_val
  logic [3:0] cs_out_val;
  always_comb begin
    if (cs_val_sel == VAL_NONE) begin
      cs_out_val = OUT_VAL_NONE;
    end
    else begin
      case (cs_dest)
        DEST_MSG0:       cs_out_val = OUT_VAL_MSG0;
        DEST_MSG1:       cs_out_val = OUT_VAL_MSG1;
        DEST_MSG2:       cs_out_val = OUT_VAL_MSG2;
        DEST_MSG3:       cs_out_val = OUT_VAL_MSG3;
        default  :       cs_out_val = OUT_VAL_X;
      endcase      
    end
  end

  // en & inq_rdy
  logic [3:0] cs_inq_rdy;
  logic       en;
  assign en = ((cs_out_val & out_rdy) == 4'd0) ? 1'b0 : 1'b1;
  assign cs_inq_rdy[0] = (grants == GRANT_MSG0) && out_rdy[inq_dest0];
  assign cs_inq_rdy[1] = (grants == GRANT_MSG1) && out_rdy[inq_dest1];
  assign cs_inq_rdy[2] = (grants == GRANT_MSG2) && out_rdy[inq_dest2];
  assign cs_inq_rdy[3] = (grants == GRANT_MSG3) && out_rdy[inq_dest3];

endmodule

`endif /* LAB4_NET_BUS_NET_CTRL_V */
