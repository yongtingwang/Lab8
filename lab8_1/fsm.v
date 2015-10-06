//************************************************************************
// Filename      : FSM.v
// Author        : hp
// Function      : FSM module for digital watch
// Last Modified : Date: 2009-03-10
// Revision      : Revision: 1
// Copyright (c), Laboratory for Reliable Computing (LaRC), EE, NTHU
// All rights reserved
//************************************************************************
`include "global.v"
module fsm(
   sel1,
	sel0,
	clk,
	alu,
	rst_n,
	rst
    );
	 
input sel1;
input sel0;	 
input clk;
input rst_n;
output alu;
output rst;

reg [1:0]state,next_state;
reg [1:0]alu;
reg rst;

always@*
begin
if(state==`stop)
alu=2'b00;
else if(state==`start)
alu=2'b01;
else if(state==`lap)
alu=2'b10;

end
always @*
begin
if(state==`stop && sel0==1'b1)
rst=1'b0;
else
rst=1'b1;
end


always@*
  case(state)
  
  `stop:
  if(sel1==1'b1)
  next_state= `start;
  else if(sel0==1'b1)
  next_state= `stop;
  else 
  next_state= `stop;
 
  `start:
  if(sel1==1'b1)
  next_state= `stop;
  else if(sel0==1'b1)
  next_state= `lap;
  else 
  next_state= `start;
  
  `lap:
  if(sel0==1'b1)
  next_state= `start;
  else
  next_state= `lap;
  
  default:
  next_state= `stop;
  
  endcase
  
  always @(posedge clk or negedge rst_n)
  if (~rst_n)
    state <= `stop;
	 
  else
    state <= next_state;
	 
endmodule
