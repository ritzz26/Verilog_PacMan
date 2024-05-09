`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:36 03/19/2013 
// Design Name: 
// Module Name:    clockdiv 
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
module clockdiv(
	input wire clk,		//master clock: 50MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output wire segclk,	//7-segment clock: 381.47Hz
	output reg clk_s, 
	output reg clk_10
	);

// 17-bit counter variable
reg [16:0] q;
reg [31:0] counter, counter_10;


// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
always @(posedge clk or posedge clr)
begin
	// reset condition
	if (clr == 1)
		q <= 0;
	// increment counter by one
	else begin
		q <= q + 1;
		if(counter == 100000000 / 10-1 ) begin
			counter <= 0;
			clk_s <= ~clk_s;
			end
		else begin
			counter <= counter + 1;
			end
		if(counter_10 == 100000000 / 100 -1 ) begin
			counter_10 <= 0;
			clk_10 <= ~clk_10;
			end 
		else begin
			counter_10 <= counter_10 +1;
		end
	end
end

// 50Mhz ÷ 2^17 = 381.47Hz
assign segclk = q[16];

// 50Mhz ÷ 2^1 = 25MHz
assign dclk = q[1];

endmodule
