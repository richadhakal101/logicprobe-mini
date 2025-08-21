module sync8(input clk, input [7:0] din, output reg [7:0] dout);
  reg [7:0] s1;
  always @(posedge clk) begin s1 <= din; dout <= s1; end
endmodule
