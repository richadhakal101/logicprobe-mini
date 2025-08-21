module sampler #(parameter AW=10)(
  input  wire         clk, input wire rst,
  input  wire         sample_en,
  input  wire [7:0]   din_sync,
  input  wire         trig,
  input  wire [AW-1:0]wptr_at_trig,
  output reg  [AW-1:0]wptr,
  output reg          capturing,
  output reg          done
);
  localparam DEPTH=(1<<AW);
  reg [15:0] post_cnt;
  wire [AW-1:0] next_wptr = wptr + 1'b1;

  always @(posedge clk) begin
    if (rst) begin wptr<=0; capturing<=1; done<=0; post_cnt<=0; end
    else begin
      done<=0;
      if (capturing && sample_en) wptr<=next_wptr;
      if (trig) begin post_cnt<=0; end
      if (!capturing) ; // idle
      else if (trig && sample_en) begin
        post_cnt<=post_cnt+1;
        if (post_cnt==(`POST_SAMP-1)) begin capturing<=0; done<=1; end
      end
    end
  end
endmodule
