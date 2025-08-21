module trigger #(parameter AW=10)(
  input  wire             clk, input wire rst,
  input  wire [7:0]       din_sync,
  input  wire [AW-1:0]    wptr,
  output reg              armed,
  output reg              trig,
  output reg [AW-1:0]     wptr_at_trig
);
  reg d0,d0p;
  always @(posedge clk) begin
    if (rst) begin armed<=1; trig<=0; d0<=0; d0p<=0; end
    else begin
      d0p<=d0; d0<=din_sync[0];
      trig<=0;
      if (armed && d0 && !d0p) begin trig<=1; wptr_at_trig<=wptr; armed<=0; end
    end
  end
endmodule
