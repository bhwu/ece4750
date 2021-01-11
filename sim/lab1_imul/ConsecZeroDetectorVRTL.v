module lab1_imul_ConsecZeroDetectorVRTL
(
  input  logic [3:0] number_4b,
  output logic [2:0] shift_bits
);

always @(*) begin
  casez(number_4b)
    4'b???1: shift_bits = 3'd1;
    4'b??10: shift_bits = 3'd2;
    4'b?100: shift_bits = 3'd3;
    4'b1000: shift_bits = 3'd4;
    4'b0000: shift_bits = 3'd5;
  endcase
end
endmodule
