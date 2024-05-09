`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
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
module NERP_demo_top(
	input wire clk,			//master clock = 50MHz
	input wire clr,			//right-most pushbutton for reset,
	input BTNU, 
	input BTNL, 
	input BTND, 
	input BTNR,
	output wire [6:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	output wire dp,			//7-segment display decimal point
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync			//vertical sync out
	);

// 7-segment clock interconnect
wire segclk;
wire [3:0] score;

wire [9:0] x, y, g_x, g_y;
// VGA display clock interconnect
wire dclk, clk_s, clk_10;
wire [7:0] dead;
wire p_dead;

// disable the 7-segment decimal points
assign dp = 1;

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(clr),
	.segclk(segclk),
	.dclk(dclk), 
	.clk_s(clk_s), 
	.clk_10(clk_10)
	);

// 7-segment display controller
segdisplay U2(
	.segclk(segclk),
	.clr(clr),
	.seg(seg),
	.an(an),
	.score(score),
	.p_dead(p_dead)
	);

	
sprite pac_man(
.clk(dclk), .rst(clr), .x_reg(x), .y_reg(y), .clk_s(clk_s), .clk_10(clk_10), .up(BTNU),
.down(BTND), .right(BTNR), .left(BTNL), .dead(dead), .score(score)
);

ghost ghost(.clk(clk), .rst(clr), .x_reg(x), .y_reg(y), .clk_s(clk_s), .clk_10(clk_10),
	 .p_dead(p_dead), .g_x(g_x), .g_y(g_y));

// VGA controller
vga640x480 U3(
	.dclk(dclk),
	.clr(clr),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue),
	.x(x),
	.y(y), 
	.dead(dead), 
	.g_x(g_x), 
	.g_y(g_y), 
	.p_dead(p_dead)
	);


endmodule
