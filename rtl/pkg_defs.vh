`ifndef PKG_DEFS_VH
`define PKG_DEFS_VH

//apture depth = 2^AW samples
`define AW         10          // 1024 samples total
`define PRE_SAMP   256
`define POST_SAMP  768

//clocks and UART
`define CLK_HZ     12000000    // UPduino 12 MHz
`define BAUD       115200

//dump header bytes
`define HDR0       8'hA5
`define HDR1       8'h5A
`define VERSION    8'h01

`endif
