module bram_dp #(parameter AW=10)(
  input  wire                   clk,
  //write port
  input  wire [AW-1:0]         waddr,
  input  wire                  we,
  input  wire [7:0]            din,
  // read port
  input  wire [AW-1:0]         raddr,
  output reg  [7:0]            dout
);
  reg [7:0] mem[(1<<AW)-1:0];
  always @(posedge clk) begin
    if (we) mem[waddr] <= din;
    dout <= mem[raddr];
  end
endmodule
