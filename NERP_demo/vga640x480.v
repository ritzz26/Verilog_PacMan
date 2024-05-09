`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
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
module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	input [7:0] dead, //cookie lives
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue,	//blue vga output
	input [9:0] x,
	input [9:0] y, 
	input [9:0] g_x, 
	input [9:0] g_y, 
	input wire p_dead
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;
reg lives = 2;


//pac_square
parameter pac_width = 20;
parameter pac_height = 20;
// parameter pac_x = x;
// parameter pac_y = y;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;


// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
	//PAC
	if (p_dead)	begin
		if(vc >= (vbp + 410) && vc <= (vbp + 430 ) && hc >= (hbp+50) && hc < (hbp+600)) begin
			red = 3'b111;
			green = 3'b000;
			blue = 3'b00;
		end
	end
	else begin
	if(vc >=(vbp+y) && vc < (vbp+y + pac_height) && hc >= (hbp+x) && hc<(hbp+x+pac_width)) begin
				red = 3'b111;
				green = 3'b111;
				blue = 2'b00;
	end
	else if(p_dead && vc >= (vbp + 410) && vc <= (vbp + 430 ) && hc >= (hbp+50) && hc < (hbp+600)) begin
			red = 3'b111;
			green = 3'b000;
			blue = 3'b00;
	end
	else if(vc >=(vbp+g_y) && vc < (vbp+g_y + 15) && hc >= (hbp+g_x) && hc<(hbp+g_x+15)) begin 
	//ghost
			red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
	end
	else if(vc >= (vbp+80) && vc<=(vbp+85) && hc>=(hbp+90) && hc<(hbp+95) && ~dead[0]) begin
	//cookie 0 TOP left
		red = 3'b111;
		green = 3'b100;
		blue = 2'b00;
	end
	else if(vc >= (vbp+80) && vc<=(vbp+85) && hc>=(hbp+480) && hc<(hbp+485) && ~dead[1]) begin
	//cookie 1 TOP right
		red = 3'b111;
		green = 3'b100;
		blue = 2'b00;
	end
	else if(vc >= (vbp+220) && vc<=(vbp+225) && hc>=(hbp+140) && hc<(hbp+145)&& ~dead[2]) begin
	//cookie 2 left of V1
		red = 3'b111;
		green = 3'b100;
		blue = 2'b00;
	end
	else if(vc >= (vbp+220) && vc<=(vbp+225) && hc>=(hbp+560) && hc<(hbp+565) && ~dead[3]) begin
	//cookie 3 right of V2
		red = 3'b111;
		green = 3'b100;
		blue = 2'b00;
	end
	else if(vc >= (vbp+120) && vc<=(vbp+125) && hc>=(hbp+320) && hc<(hbp+325) && ~dead[4]) begin
	//cookie 4 middle top
		red = 3'b111;
		green = 3'b100;
		blue = 2'b00;
	end
	else if(vc >= (vbp+320) && vc<=(vbp+325) && hc>=(hbp+320) && hc<(hbp+325) && ~dead[5]) begin
	//cookie 5 middle bottom
		red = 3'b111;
		green = 3'b100;
		blue = 2'b00;
	end
	else if(vc >= (vbp +385) && vc <= (vbp + 390) && hc >= (hbp+160) && hc < (hbp+165) && ~dead[6]) begin
	//cookie 6 bottom left
		red = 3'b111;
		green = 3'b100;
		blue = 2'b00;
	end
	else if(vc >= (vbp +385) && vc <= (vbp + 390) && hc>=(hbp+490) && hc<(hbp+495)&& ~dead[7]) begin
	//cookie 7 bottom right
		red = 3'b111;
		green = 3'b100;
		blue = 2'b00;
	end
	else if (vc >= (vbp +50) && vc <= (vbp + 70) && hc >= (hbp+50) && hc < (hbp+600)) begin
		//TOP BAR OF MAP
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
	end
	else if(vc >= (vbp +110) && vc <= (vbp + 130) && hc >= (hbp+110) && hc < (hbp+210)) begin
		//B1
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
		end
	else if(vc >= (vbp +110) && vc <= (vbp + 130) && hc >= (hbp+440) && hc < (hbp+540)) begin
		//B2
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
	end
	else if(vc >= (vbp +350) && vc <= (vbp + 370) && hc >= (hbp+110) && hc < (hbp+210)) begin
		//B3
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
		end
	else if(vc >= (vbp +350) && vc <= (vbp + 370) && hc >= (hbp+440) && hc < (hbp+540)) begin
		//B4
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
	end
	else if(vc >= (vbp +240) && vc <= (vbp + 260) && hc >= (hbp+260) && hc < (hbp+400)) begin
		//CENTER BAR
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
	end
	else if(vc >= (vbp +160) && vc <= (vbp + 280) && hc >= (hbp+180) && hc < (hbp+200)) begin
		//V1
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
	end
	else if(vc >= (vbp +160) && vc <= (vbp + 280) && hc >= (hbp+500) && hc < (hbp+520)) begin
		//V2
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
	end
	else if(vc >= (vbp +50) && vc <= (vbp + 430) && hc >= (hbp+50) && hc < (hbp+70)) begin
		//LEFT BAR
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
	end	
	else if(vc >= (vbp +50) && vc <= (vbp + 430) && hc >= (hbp+580) && hc < (hbp+600)) begin
		//RIGHT BAR
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
	end
	else if(vc >= (vbp + 410) && vc <= (vbp + 430 ) && hc >= (hbp+50) && hc < (hbp+600)) begin
			//BOTTOM BAR
				red = 3'b000;
				green = 3'b111;
				blue = 2'b11;
	end	
	else begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
	end
	end
	
//	if (p_dead)	begin
//		if(vc >= (vbp + 410) && vc <= (vbp + 430 ) && hc >= (hbp+50) && hc < (hbp+600)) begin
//			red = 3'b111;
//			green = 3'b000;
//			blue = 3'b00;
//		end
//	end
end

endmodule
