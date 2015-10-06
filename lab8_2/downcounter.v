`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:06:26 09/17/2015 
// Design Name: 
// Module Name:    downcounter 
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
`include "global.v"
module downcounter(
	in_value,
	value,
	borrow,
	clk,
	rst_n,
	decrease,
	limit,
	switch,
	not_borrow
    );

input clk,rst_n,decrease,switch,not_borrow;
output reg borrow;
output reg [3:0] value;
reg [3:0] value_tmp;
input [3:0]in_value,limit;

//always@(switch)
//value_tmp = in_value;


// Combinational logics
always@*
if(value==`BCD_ZERO&&decrease&&en)
	begin
	value_tmp=limit;
	borrow=`ENABLED;
	end
else if (value!=`BCD_ZERO && decrease&&en)
	begin
	value_tmp = value - `INCREMENT;
	borrow = `DISABLED;
	end
else if (en)
	begin
	value_tmp = value;
	borrow = `DISABLED;
	end
else 
	begin
	value_tmp = `BCD_ZERO;
	borrow = `DISABLED;
	end

// register part for BCD counter
always @(posedge clk or negedge rst_n)
if (~rst_n) value <= in_value;
else value <= value_tmp;

endmodule
