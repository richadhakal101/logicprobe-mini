module clock_div #(parameter DIV=100)(
  input  wire clk, input wire rst,
  output reg  tick
);
  reg [$clog2(DIV)-1:0] cnt=0;
  always @(posedge clk) begin
    if (rst) begin cnt<=0; tick<=0; end
    else begin
      tick <= 0;
      if (cnt==DIV-1) begin cnt<=0; tick<=1; end
      else cnt<=cnt+1;
    end
  end
endmodule
