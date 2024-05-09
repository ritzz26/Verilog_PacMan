`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:35:39 05/25/2023 
// Design Name: 
// Module Name:    logicmodule 
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
module logicmodule(
clk, clr, up, down, left, right, 
    );
input clk, clr, up, down, left, right;
reg pac_h;
reg pac_v;

initial begin
	pac_h = 300;
	pac_v = 200;
end

//always@(*)


endmodule
