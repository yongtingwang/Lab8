`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:59:15 09/16/2015 
// Design Name: 
// Module Name:    lab8_1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module lab8_1(
	display,
	ftsd_ctl,
	clk,
	rst_n,
	sel0,   // ¶}©l/¼È°±
	sel1   //lap/reset
    );
output [14:0] display;
output [3:0] ftsd_ctl;
input clk,rst_n,sel0,sel1;

wire clk_out,clk_100;
wire [1:0] clk_ctl;
wire out0,out1,rst;
wire [1:0] alu;
wire [3:0] dig2,dig1,dig3,dig4,sec1,sec0,min1,min0,bcd;
wire carry_sec,carry_min;


freq_div f1(
  .clk_out(clk_out), // divided clock output
  .clk_ctl(clk_ctl), // divided clock for seven-segment display scan
  .clk(clk), // clock from the crystal
  .rst_n(rst_n), // low active reset
  .clk_100(clk_100) // generated 100 Hz clock
);

button0 b0(
	.clk_100(clk_100),
	.clk(clk),
	.rst_n(rst_n),
	.pb_in(sel0),
	.out_pulse(out0)
    );
	 
button0 b1(
	.clk_100(clk_100),
	.clk(clk),
	.rst_n(rst_n),
	.pb_in(sel1),
	.out_pulse(out1)
    );

fsm fsm1(
   .sel1(out1),
	.sel0(out0),
	.clk(clk),
	.alu(alu),
	.rst_n(rst_n),
	.rst(rst)
    );

fsm2 fsm2(
	.dig1(dig1),
	.dig2(dig2),
	.dig3(dig3),
	.dig4(dig4),
	.sec1(sec1),
	.sec0(sec0),
	.min1(min1),
	.min0(min0),
	.alu(alu),
	.clk(clk),
	.rst_n(rst_n)
    );
	 
second s1(
	.sec1(sec1), // digit 1 for second
	.sec0(sec0), // digit 0 for second
	.clk(clk_out), // global clock
	.carry_sec(carry_sec),
	.alu(alu),
	.rst_n(rst) // low active reset
);
	 
minute m1(
	.min1(min1),
	.min0(min0),
	.clk((clk_out)),
	.carry_min(carry_min),
	.carry_sec(carry_sec),
	.rst_n(rst)
    );
	 
scan_ctl(
	.ftsd_ctl(ftsd_ctl), // ftsd display control signal 
	.ftsd_in(bcd), // output to ftsd display
	.in0(dig1), // 1st input
	.in1(dig2), // 2nd input
	.in2(dig3), // 3rd input
	.in3(dig4), // 4th input
	.ftsd_ctl_en(clk_ctl) // divided clock for scan control
	);
	
bcd2ftsegdec dis(
	.display(display), // 14-segment display output
	.bcd(bcd) // BCD input
	);
	
endmodule
