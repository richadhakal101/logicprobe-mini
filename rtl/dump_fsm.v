`include "pkg_defs.vh"
module dump_fsm #(parameter AW=`AW)(
  input  wire clk, input wire rst,
  input  wire start_dump,
  input  wire [AW-1:0] start_addr,
  input  wire [15:0]   count,
  // BRAM read
  output reg  [AW-1:0] raddr,
  input  wire [7:0]    rdata,
  // UART
  output reg           tx_start,
  output reg  [7:0]    tx_data,
  input  wire          tx_busy,
  output reg           busy
);
  localparam S_IDLE=0,S_H0=1,S_H1=2,S_HV=3,S_HM=4,S_HP=5,S_HQ=6,S_HC=7,S_PAY=8,S_DONE=9;
  reg [3:0] s=0; reg [15:0] i=0;
  always @(posedge clk) begin
    if (rst) begin s<=S_IDLE; tx_start<=0; busy<=0; i<=0; raddr<=0; end
    else begin
      tx_start<=0;
      case(s)
        S_IDLE: if (start_dump) begin busy<=1; raddr<=start_addr; s<=S_H0; end
        S_H0:   if (!tx_busy) begin tx_data=`HDR0; tx_start<=1; s<=S_H1; end
        S_H1:   if (!tx_busy) begin tx_data=`HDR1; tx_start<=1; s<=S_HV; end
        S_HV:   if (!tx_busy) begin tx_data=`VERSION; tx_start<=1; s<=S_HM; end
        S_HM:   if (!tx_busy) begin tx_data=8'hFF; tx_start<=1; s<=S_HP; end // chan mask
        S_HP:   if (!tx_busy) begin tx_data=`PRE_SAMP[7:0]; tx_start<=1; s<=S_HQ; end
        S_HQ:   if (!tx_busy) begin tx_data=`POST_SAMP[7:0]; tx_start<=1; s<=S_HC; end
        S_HC:   if (!tx_busy) begin tx_data=count[7:0]; tx_start<=1; i<=0; s<=S_PAY; end
        S_PAY:  if (!tx_busy) begin tx_data=rdata; tx_start<=1; raddr<=raddr+1; i<=i+1;
                          if (i==count-1) s<=S_DONE; end
        S_DONE: begin busy<=0; s<=S_IDLE; end
      endcase
    end
  end
endmodule
