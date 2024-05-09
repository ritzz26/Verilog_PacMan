`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:33:18 06/06/2023 
// Design Name: 
// Module Name:    ghost 
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
module ghost(
clk, rst, x_reg, y_reg, clk_s, clk_10,
	 p_dead, g_x, g_y
    );
input clk, rst, clk_s, clk_10;
output reg [9:0] g_x, g_y;
reg [9:0] x, y;
input[9:0] x_reg, y_reg; //pac location
output reg p_dead; 

reg [9:0] x_next, y_next;

parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch


wire [9:0] pac_l, pac_r, pac_t, pac_b;
wire [9:0] g_l, g_r, g_t, g_b;
reg [9:0] diff_x, diff_y;

//
//
assign pac_l = x_reg;
assign pac_r = x_reg + 20;
assign pac_t = y_reg;
assign pac_b = y_reg + 20;

assign g_l = g_x;
assign g_r = g_x +20;
assign g_t = g_y;
assign g_b = g_y + 20;

reg wall_up, wall_down, wall_left, wall_right;

reg up, down, left, right;

initial begin
	g_x = 330;
	g_y = 300;
  x_next = 330;
  y_next = 300;
	p_dead = 0;
end

//wire refresh;

always @(posedge clk_10 or posedge rst)
begin
	// reset condition
	if (rst == 1)
	begin
		x <= 0;
		y <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (x < 800 - 1)
			x <= x + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			x <= 0;
			if (y < 521 - 1)
				y <= y + 1;
			else
				y <= 0;
		end
		
	end
end

//always @(posedge clk_10 or posedge rst) begin
//	if(rst) begin
//		g_x = 330;
//		g_y = 300;
//		p_dead =0;
//	end
//	else begin
//		g_x = x_next;
//		g_y = y_next;
//	end
//end


// COLLISION DETECTION GRID
always@(posedge clk_10 or posedge rst) begin 
	if(rst==1) begin
		g_x = 330;
		g_y = 300;
		y_next = 330;
		x_next = 300;
		p_dead =0;
		
	end
	else begin
	g_x = x_next;
	g_y = y_next;
	if(g_x < x_reg) begin
		diff_x <= x_reg - g_x;
		if(g_y < y_reg) begin
			diff_y = y_reg - g_y;
			if(diff_y >= diff_x) begin
				down = 1;
				up =0;
				right =0;
				left = 0;
			end else begin 
				right = 1;
				left = 0;
				up = 0;
				down = 0;
			end 
		end
		else begin
			diff_y = g_y - y_reg;
			if(diff_y >= diff_x) begin
				right = 0;
				left = 0;
				up = 1;
				down = 0;
			end
			else begin
				right = 1;
				left = 0;
				up = 0;
				down = 0;

			end
		end
	end
	else begin
		diff_x <= g_x - x_reg;
		if(g_y < y_reg) begin
			diff_y = y_reg - g_y;
			if(diff_y >= diff_x) begin
				right = 0;
				left = 0;
				up = 0;
				down = 1;
			end
			else begin
				right = 0;
				left = 1;
				up = 0;
				down = 0;
			end
		end
		else begin
			diff_y = g_y - y_reg;
			if(diff_y >= diff_x) begin
				right = 0;
				left = 0;
				up = 1;
				down = 0;
			end
			else begin
				right = 0;
				left = 1;
				up = 0;
				down = 0;

			end
		end
	end
	
	if(down) begin
		//PAC
		if(((y_next+20) >= pac_t) && ((y_next+20) <= pac_b) && ((g_l) <= pac_r) && ((g_r) >= pac_l)) begin
			p_dead = 1; end
		else if(((y_next+20) >= 240) && ((y_next+20) <= 260) && ((g_l) <= 400) && ((g_r) >= 260)) begin
		//CENTER BAR
		wall_down = 1; end
		else if((y_next+20) >= 410) wall_down =1;
		else if(((y_next+20) >= 110) && ((y_next+20) <= 130) && ((g_l) <= 210) && ((g_r) >= 110)) begin
			//B1
			wall_down = 1; end
		else if(((y_next+20) >= 110) && ((y_next+20) <= 130) && ((g_l) <= 540) && ((g_r) >= 440)) begin
			//B2
			wall_down = 1; end
		else if(((y_next+20) >= 350) && ((y_next+20) <= 370) && ((g_l) <= 210) && ((g_r) >= 110)) begin
			//B3
			wall_down = 1; end
		else if(((y_next+20) >= 350) && ((y_next+20) <= 370) && ((g_l) <= 540) && ((g_r) >= 440)) begin
			//B4
			wall_down = 1; end
		else if(((y_next+20) >= 160) && ((y_next+20) <= 280) && ((g_l) <= 180) && ((g_r) >= 200)) begin
			//V1
			wall_down = 1; end
		else if(((y_next+20) >= 160) && ((y_next+20) <= 280) && ((g_l) <= 500) && ((g_r) >= 520)) begin
			//V2
			wall_down = 1; end
			else
			wall_down = 0;
	end 
	else begin
		wall_down=0;
	end
	
	if(left) begin
		if((g_t <= pac_b) && ((g_b+20) >= pac_t) && (x_next <= pac_r) && (x_next >= pac_l))
			//PAC
			p_dead=1;
		else if((g_t <= 260) && (g_b >= 240) && (x_next <= 400) && (x_next >= 260))
		//CENTER BAR 
				wall_left = 1;
		else if((g_t <= 130) && (g_b >= 110) && (x_next <= 210) && (x_next >= 110))
		//B1 
				wall_left = 1;
		else if((g_t <= 130) && (g_b >= 110) && (x_next <= 540) && (x_next >= 440))
		//B2 
				wall_left = 1;
		else if((g_t <= 370) && (g_b >= 350) && (x_next <= 210) && (x_next >= 110))
		//B3 
				wall_left = 1;
		else if((g_t <= 370) && (g_b >= 350) && (x_next <= 540) && (x_next >= 440))
		//B4 
				wall_left = 1;
		else if((g_t <= 280) && (g_b >= 160) && (x_next <= 200) && (x_next >= 180))
		//V1
				wall_left = 1;
		else if((g_t <= 280) && (g_b >= 160) && (x_next <= 520) && (x_next >= 500))
		//V2 
				wall_left = 1;
		
		else if(x_next <= 70) wall_left = 1;
			else 
				wall_left = 0;
	end
	else begin
		wall_left =0;
	end

	if(right) begin
		if((g_t <= pac_b) && (g_b >= pac_t) && ((x_next+20) >= pac_l) && ((x_next+20) <= pac_r))
			//PAC
			p_dead=1;
		else if((g_t <= 260) && (g_b >= 240) && ((x_next+20) >= 260) && ((x_next+20) <= 400))
		//CENTER BAR
				wall_right = 1;
		else if((g_t <= 130) && (g_b >= 110) && ((x_next+20) >= 110) && ((x_next+20) <= 210))
		//B1
				wall_right = 1;
		else if((g_t <= 130) && (g_b >= 110) && ((x_next+20) >= 440) && ((x_next+20) <= 540))
		//B2
				wall_right = 1;
		else if((g_t <= 370) && (g_b >= 350) && ((x_next+20) >= 110) && ((x_next+20) <= 210))
		//B3
				wall_right = 1;
		else if((g_t <= 370) && (g_b >= 350) && ((x_next+20) >= 440) && ((x_next+20) <= 540))
		//B4
				wall_right = 1;
		else if((g_t <= 280) && (g_b >= 160) && ((x_next+20) >= 180) && ((x_next+20) <= 200))
		//V1
				wall_right = 1;
		else if((g_t <= 280) && (g_b >= 160) && (x_next+20 >= 500) && (x_next+20 <= 520))
		//V2
				wall_right = 1;
		
		else if((x_next+20)>= 580) wall_right = 1;
		
			else
				wall_right = 0;
	end
	else begin
		wall_right=0;
	end

	if(up) begin
		if(((y_next) <= pac_b) && (y_next >= pac_t) && ((g_l) <= pac_r) && ((g_r) >= pac_l))
			//PAC
			p_dead=1;
		else if(((y_next) <= 260) && (y_next >= 240) && ((g_l) <= 400) && ((g_r) >= 260))
		//CENTER BAR
		wall_up = 1;
		else if(((y_next) <= 130) && (y_next >= 110) && ((g_l) <= 210) && ((g_r) >= 110))
		//B1
		wall_up = 1;
		else if(((y_next) <= 130) && (y_next >= 110) && ((g_l) <= 540) && ((g_r) >= 440))
		//B2
		wall_up = 1;
		else if(((y_next) <= 370) && (y_next >= 350) && ((g_l) <= 210) && ((g_r) >= 110))
		//B3
		wall_up = 1;
		else if(((y_next) <= 370) && (y_next >= 350) && ((g_l) <= 540) && ((g_r) >= 440))
		//B4
		wall_up = 1;
		else if(((y_next) <= 280) && (y_next >= 160) && ((g_l) <= 200) && ((g_r) >= 180))
		//V1
		wall_up = 1;
		else if(((y_next) <= 280) && (y_next >= 160) && ((g_l) <= 520) && ((g_r) >= 500))
		//V2
		wall_up = 1;
		
		else if(y_next<=70) wall_up=1;
			else
				wall_up = 0;
	end
	else begin
		wall_up = 0;
	end

	
		if(up && ~wall_up) begin
			y_next = (clk_s) ? g_y - 2 : g_y;
		end
		else if(right && ~wall_right) begin
			x_next = (clk_s) ? g_x + 2 : g_x;
		end
		else if(left && ~wall_left) begin
			x_next = (clk_s) ? g_x - 2 : g_x;
		end
		else if(down && ~wall_down) begin
			y_next = (clk_s) ? g_y + 2 : g_y;

		end
		else begin
			if((right || left) && ~wall_up) begin
				y_next = (clk_s) ? g_y - 2 : g_y;
			end else if ((up || down ) && ~wall_right) begin
				x_next = (clk_s) ? g_x + 2 : g_x;
			end else if ((up || down ) && ~wall_left) begin
				x_next = (clk_s) ? g_x - 2 : g_x;
			end else if ((right || left) && ~wall_down) begin
				y_next = (clk_s) ? g_y + 2 : g_y;
			end 
		end
	end
end


endmodule