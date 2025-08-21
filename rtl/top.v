`include "pkg_defs.vh"
module top(
  input  wire clk,               // 12 MHz
  input  wire [7:0] ch,          // probe inputs (3.3V)
  output wire uart_tx
);
  // Params
  localparam integer DIV = 100; // 12MHz/100 = 120 kHz sample (example)

  // Sample enable
  wire sample_en;
  clock_div #(.DIV(DIV)) UDIV(.clk(clk), .rst(1'b0), .tick(sample_en));

  // Sync
  wire [7:0] ch_sync;
  sync8 USYNC(.clk(clk), .din(ch), .dout(ch_sync));

  // Circular writer
  wire trig, capturing, done;
  wire [`AW-1:0] wptr, wptr_at_trig;
  sampler #(.AW(`AW)) USAMP(
    .clk(clk), .rst(1'b0), .sample_en(sample_en),
    .din_sync(ch_sync), .trig(trig), .wptr_at_trig(wptr_at_trig),
    .wptr(wptr), .capturing(capturing), .done(done)
  );

  // Trigger
  trigger #(.AW(`AW)) UTRIG(
    .clk(clk), .rst(1'b0), .din_sync(ch_sync),
    .wptr(wptr), .armed(), .trig(trig), .wptr_at_trig(wptr_at_trig)
  );

  // BRAM
  wire [`AW-1:0] raddr; wire [7:0] rdata;
  bram_dp #(.AW(`AW)) URAM(
    .clk(clk),
    .waddr(wptr), .we(sample_en && capturing), .din(ch_sync),
    .raddr(raddr), .dout(rdata)
  );

  // Compute dump window
  wire [15:0] COUNT = `PRE_SAMP + `POST_SAMP;
  wire [`AW-1:0] start_addr = wptr_at_trig - `PRE_SAMP[`AW-1:0];

  // UART + dump
  wire tx_busy; reg start_dump=0;
  always @(posedge clk) if (done) start_dump <= 1'b1;
                        else if (!tx_busy) start_dump <= 1'b0;

  wire tx_start; wire [7:0] tx_data; wire dump_busy;
  dump_fsm #(.AW(`AW)) UDUMP(
    .clk(clk), .rst(1'b0), .start_dump(start_dump),
    .start_addr(start_addr), .count(COUNT),
    .raddr(raddr), .rdata(rdata),
    .tx_start(tx_start), .tx_data(tx_data), .tx_busy(tx_busy),
    .busy(dump_busy)
  );

  uart_tx #(.CLK_HZ(`CLK_HZ), .BAUD(`BAUD)) UTX(
    .clk(clk), .rst(1'b0), .tx_start(tx_start), .tx_data(tx_data),
    .tx(uart_tx), .busy(tx_busy)
  );
endmodule
