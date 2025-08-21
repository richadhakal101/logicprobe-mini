module uart_tx #(parameter CLK_HZ=12_000_000, BAUD=115200)(
  input  wire clk, input wire rst,
  input  wire tx_start, input wire [7:0] tx_data,
  output reg  tx, output reg busy
);
  localparam DIV = CLK_HZ/BAUD;
  reg [15:0] cnt=0; reg [3:0] biti=0; reg [9:0] sh=10'h3FF;
  always @(posedge clk) begin
    if (rst) begin tx<=1; busy<=0; cnt<=0; biti<=0; sh<=10'h3FF; end
    else if (!busy && tx_start) begin sh<={1'b1,tx_data,1'b0}; busy<=1; cnt<=0; biti<=0; tx<=0;
    end else if (busy) begin
      if (cnt==DIV-1) begin cnt<=0; tx<=sh[biti]; biti<=biti+1; if (biti==9) busy<=0; end
      else cnt<=cnt+1;
    end
  end
endmodule
