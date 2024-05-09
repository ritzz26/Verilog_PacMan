`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:18:00 05/30/2023 
// Design Name: 
// Module Name:    sprite 
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
module sprite(
	clk, rst, x_reg, y_reg, clk_s, clk_10,
	up, down, left, right, dead, score
    );
	 
input clk, rst, clk_s, clk_10, up, down, left, right;
reg [9:0] x, y;
//output reg [2:0] r, g;
//output reg [1:0] b;
output reg [9:0] x_reg, y_reg;
output reg [7:0] dead;
output reg [3:0] score;

wire [9:0] x_l, x_r;
wire [9:0] y_t, y_b;

// reg[9:0] x_reg, y_reg;
reg [9:0] x_next, y_next;

parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch

parameter pac_vel = 2;

wire [9:0] pac_l, pac_r, pac_t, pac_b;

//
//
assign pac_l = x_reg;
assign pac_r = x_reg + 20;
assign pac_t = y_reg;
assign pac_b = y_reg + 20;

reg wall_up, wall_down, wall_left, wall_right;

reg[3:0] dir;
initial begin
	x_reg <= 330;
	y_reg <= 180;
	x_next <= 330;
	y_next <= 180;
	dead <= 0;
	score = 4'd0;
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
//assign refresh = ((y == 522) && (x==0)) ? 1:0; 

//change clock to 10Hz
always @(posedge clk_10 or posedge rst) begin
	if(rst) begin
		x_reg <= 330;
		y_reg <= 180;
		//dead <=0;
//		xd_reg <= 10'h002;
//		yd_reg <= 10'h002;
	end
	else begin
		x_reg <= x_next;
		y_reg <= y_next;
//		xd_reg <= xd_next;
//		yd_reg <= yd_next;
	end
end


/*
reg [1:0] reg_r;
reg r;

always @(posedge clk_s) begin
	reg_r[1:0] <= {right, reg_r[1]};
	if(reg_r[0] && ~reg_r[1])
		r<=1;
end
//left button debounce
reg [1:0] reg_l;
reg l;

always @(posedge clk_s) begin
	reg_l[1:0] <= {left, reg_l[1]};
	if(reg_l[0] && ~reg_l[1])
		l<=1;
end
//down button debounce
reg [1:0] reg_d;
reg d;

always @(posedge clk_s) begin
	reg_d[1:0] <= {down, reg_d[1]};
	if(reg_d[0] && ~reg_d[1])
		d<=1;
end
//up button debounce
reg [1:0] reg_u;
reg u;

always @(posedge clk_s) begin
	reg_u[1:0] <= {up, reg_u[1]};
	if(reg_u[0] && ~reg_u[1])
		u<=1;
end

*/

// COLLISION DETECTION GRID
always@(*) begin
	if(rst) begin
		dead =0;
		score = 4'd0;
	end
	if(down) begin
		if(((y_next+20) >= 240) && ((y_next+20) <= 260) && ((pac_l) <= 400) && ((pac_r) >= 260))
		//CENTER BAR
		wall_down = 1;
    else if((y_next+20) >= 410) wall_down =1;
    else if(((y_next+20) >= 110) && ((y_next+20) <= 130) && ((pac_l) <= 210) && ((pac_r) >= 110))
		//B1
		wall_down = 1;
    else if(((y_next+20) >= 110) && ((y_next+20) <= 130) && ((pac_l) <= 540) && ((pac_r) >= 440))
		//B2
		wall_down = 1;
    else if(((y_next+20) >= 350) && ((y_next+20) <= 370) && ((pac_l) <= 210) && ((pac_r) >= 110))
		//B3
		wall_down = 1;
    else if(((y_next+20) >= 350) && ((y_next+20) <= 370) && ((pac_l) <= 540) && ((pac_r) >= 440))
		//B4
		wall_down = 1;
    else if(((y_next+20) >= 160) && ((y_next+20) <= 280) && ((pac_l) <= 200) && ((pac_r) >= 180))
		//V1
		wall_down = 1;
    else if(((y_next+20) >= 160) && ((y_next+20) <= 280) && ((pac_l) <= 520) && ((pac_r) >= 500))
		//V2
		wall_down = 1;
	else 		wall_down = 0;
	//C0
	if(((y_next+20) >= 80) && ((y_next+20) <= 85) && ((pac_l) <= 95) && ((pac_r) >= 90) && ~dead[0]) begin
		dead[0]=1;
		score = score+ 4'd1;
	end
	//C1
	else if(((y_next+20) >= 80) && ((y_next+20) <= 85) && ((pac_l) <= 485) && ((pac_r) >= 480) && ~dead[1]) begin
		dead[1]=1;
		score = score+ 4'd1;
	end
	//C2
	else if(((y_next+20) >= 220) && ((y_next+20) <= 225) && ((pac_l) <= 145) && ((pac_r) >= 140)  && ~dead[2]) begin
		dead[2]=1;
		score = score+ 4'd1;
	end
	//C3
	else if(((y_next+20) >= 220) && ((y_next+20) <= 225) && ((pac_l) <= 565) && ((pac_r) >= 560)  && ~dead[3]) begin
		dead[3]=1;
		score = score+ 4'd1;
	end
	//C4
	else if(((y_next+20) >= 120) && ((y_next+20) <= 125) && ((pac_l) <= 325) && ((pac_r) >= 320)  && ~dead[4]) begin
		dead[4]=1;
		score = score+1'b1;
	end
	//C5
	else if(((y_next+20) >= 320) && ((y_next+20) <= 325) && ((pac_l) <= 325) && ((pac_r) >= 320) && ~dead[5]) begin
		dead[5]=1;
		score = score+ 4'd1;
	end
	//C6
	else if(((y_next+20) >= 385) && ((y_next+20) <= 390) && ((pac_l) <= 165) && ((pac_r) >= 160) && ~dead[6]) begin
		dead[6]=1;
		score = score+ 4'd1;
	end
	//C7
	else if(((y_next+20) >= 385) && ((y_next+20) <= 390) && ((pac_l) <=495) && ((pac_r) >= 490) && ~dead[7]) begin
		dead[7]=1;
		score = score+ 4'd1;
	end

	end //end down 
	
	if (up) begin
		if(((y_next+1) <= 260) && (y_next >= 240) && ((pac_l) <= 400) && ((pac_r) >= 260))
      //CENTER BAR
      wall_up = 1;
    else if(((y_next+1) <= 130) && (y_next >= 110) && ((pac_l) <= 210) && ((pac_r) >= 110))
      //B1
      wall_up = 1;
    else if(((y_next+1) <= 130) && (y_next >= 110) && ((pac_l) <= 540) && ((pac_r) >= 440))
      //B2
      wall_up = 1;
    else if(((y_next+1) <= 370) && (y_next >= 350) && ((pac_l) <= 210) && ((pac_r) >= 110))
      //B3
      wall_up = 1;
    else if(((y_next+1) <= 370) && (y_next >= 350) && ((pac_l) <= 540) && ((pac_r) >= 440))
      //B4
      wall_up = 1;
    else if(((y_next+1) <= 280) && (y_next >= 160) && ((pac_l) <= 200) && ((pac_r) >= 180))
      //V1
      wall_up = 1;
    else if(((y_next+1) <= 280) && (y_next >= 160) && ((pac_l) <= 520) && ((pac_r) >= 500))
      //V2
      wall_up = 1;
    else if(y_next<=70) wall_up=1;
	else wall_up = 0;

	//COOKIES
	//C0
	if(((y_next+1) >= 85) && ((y_next) <= 80) && ((pac_l) <= 95) && ((pac_r) >= 90)  && ~dead[0]) begin
		dead[0]=1;
		score = score+ 4'd1;
	end
	//C1
	else if(((y_next+1) >= 85) && ((y_next) <= 80) && ((pac_l) <= 485) && ((pac_r) >= 480)  && ~dead[1] ) begin
		dead[1]=1;
		score = score+ 4'd1;
	end
	//C2
	else if(((y_next+1) >= 225) && ((y_next) <= 220) && ((pac_l) <= 145) && ((pac_r) >= 140) && ~dead[2]) begin
		dead[2]=1;
		score = score+ 4'd1;
	end
	//C3
	else if(((y_next+1) >= 225) && ((y_next) <= 220) && ((pac_l) <= 565) && ((pac_r) >= 560)  && ~dead[3]) begin
		dead[3]=1;
		score = score+ 4'd1;
	end
	//C4
	else if(((y_next+1) >= 125) && ((y_next) <= 120) && ((pac_l) <= 325) && ((pac_r) >= 320) && ~dead[4]) begin
		dead[4]=1;
		score = score+ 4'd1;
	end
	//C5
	else if(((y_next+1) >= 325) && ((y_next) <= 320) && ((pac_l) <= 325) && ((pac_r) >= 320) && ~dead[5]) begin
		dead[5]=1;
		score = score+ 4'd1;
	end
	//C6
	else if(((y_next+1) >= 390) && ((y_next) <= 385) && ((pac_l) <= 165) && ((pac_r) >= 160) && ~dead[6]) begin
		dead[6]=1;
	score = score+ 4'd1;
	end
	//C7
	else if(((y_next+1) >= 390) && ((y_next) <= 385) && ((pac_l) <= 495) && ((pac_r) >= 490) && ~dead[7]) begin
		dead[7]=1;
		score = score+ 4'd1;
	end

	end //end up
	
	if(left) begin
		if((pac_t <= 260) && (pac_b >= 240) && (x_next <= 400) && (x_next >= 260))
      //CENTER BAR 
			wall_left = 1;
    else if((pac_t <= 130) && (pac_b >= 110) && (x_next <= 210) && (x_next >= 110))
      //B1 
			wall_left = 1;
    else if((pac_t <= 130) && (pac_b >= 110) && (x_next <= 540) && (x_next >= 440))
      //B2 
			wall_left = 1;
    else if((pac_t <= 370) && (pac_b >= 350) && (x_next <= 210) && (x_next >= 110))
      //B3 
			wall_left = 1;
    else if((pac_t <= 370) && (pac_b >= 350) && (x_next <= 540) && (x_next >= 440))
      //B4 
			wall_left = 1;
    else if((pac_t <= 280) && (pac_b >= 160) && (x_next <= 200) && (x_next >= 180))
      //V1
			wall_left = 1;
    else if((pac_t <= 280) && (pac_b >= 160) && (x_next <= 520) && (x_next >= 500))
      //V2 
			wall_left = 1;
      
    else if(x_next <= 70) wall_left = 1;
	else wall_left = 0;

	//COOKIES
	//C0
	if((pac_t <= 85) && ((pac_b) >= 80) && ((x_next) <= 95) && ((x_next) >= 90) && ~dead[0]) begin
		dead[0]=1;
		score = score+ 4'd1;
	end
	//C1
	else if(((pac_t) <= 85) && ((pac_b) >= 80) && ((x_next) <= 485) && ((x_next) >= 480)  && ~dead[1]) begin
		dead[1]=1;
		score = score+ 4'd1;
	end
	//C2
	else if(((pac_t) <= 225) && ((pac_b) >= 220) && ((x_next) <= 145) && ((x_next) >= 140) && ~dead[2]) begin
		dead[2]=1;
		score = score+ 4'd1;
	end
	//C3
	else if(((pac_t) <= 225) && ((pac_b) >= 220) && ((x_next) <= 565) && ((x_next) >= 560) && ~dead[3]) begin
		dead[3]=1;
		score = score+ 4'd1;
	end
	//C4
	else if(((pac_t) <= 125) && ((pac_b) >= 120) && ((x_next) <= 325) && ((x_next) >= 320) && ~dead[4]) begin
		dead[4]=1;
		score = score+ 4'd1;
	end
	//C5
	else if(((pac_t) <= 325) && ((pac_b) >= 320) && ((x_next) <= 325) && ((x_next) >= 320)  && ~dead[5]) begin
		dead[5]=1;
		score = score+ 4'd1;
	end
	//C6
	else if(((pac_t) <= 390) && ((pac_b) >= 385) && ((x_next) <= 165) && ((x_next) >= 160)  && ~dead[6]) begin
		dead[6]=1;
		score = score+ 4'd1;
	end
	//C7
	else if(((pac_t) <= 390) && ((pac_b) >= 385) && ((x_next) <= 495) && ((x_next) >= 490) && ~dead[7]) begin
		dead[7]=1;
		score = score+ 4'd1;
	end
	
	end //end left
	
	
	if(right) begin
		if((pac_t <= 260) && (pac_b >= 240) && ((x_next+20) >= 260) && ((x_next+20) <= 400))
      //CENTER BAR
			wall_right = 1;
    else if((pac_t <= 130) && (pac_b >= 110) && ((x_next+20) >= 110) && ((x_next+20) <= 210))
      //B1
			wall_right = 1;
    else if((pac_t <= 130) && (pac_b >= 110) && ((x_next+20) >= 440) && ((x_next+20) <= 540))
      //B2
			wall_right = 1;
    else if((pac_t <= 370) && (pac_b >= 350) && ((x_next+20) >= 110) && ((x_next+20) <= 210))
      //B3
			wall_right = 1;
    else if((pac_t <= 370) && (pac_b >= 350) && ((x_next+20) >= 440) && ((x_next+20) <= 540))
      //B4
			wall_right = 1;
    else if((pac_t <= 280) && (pac_b >= 160) && ((x_next+20) >= 180) && ((x_next+20) <= 200))
      //V1
			wall_right = 1;
    else if((pac_t <= 280) && (pac_b >= 160) && (x_next+20 >= 500) && (x_next+20 <= 520))
      //V2
			wall_right = 1;
    
    else if((x_next+20)>= 580 && ((x_next)<=600) ) wall_right = 1;
	else	wall_right = 0;
    
	//COOKIES
	//C0
	if((pac_t <= 85) && ((pac_b) >= 80) && ((x_next+20) >= 90) && ((x_next+20) <= 95) && ~dead[0]) begin
		dead[0]=1;
score = score+ 4'd1;	end
	//C1
	else if(((pac_t) <= 85) && ((pac_b) >= 80) && ((x_next+20) <= 480) && ((x_next+20) >= 485) && ~dead[1]) begin
		dead[1]=1;
		score = score+ 4'd1;
	end
	//C2
	else if(((pac_t) <= 225) && ((pac_b) >= 220) && ((x_next+20) <= 140) && ((x_next+20) >= 145) && ~dead[2]) begin
		dead[2]=1;
		score = score+ 4'd1;
	end
	//C3
	else if(((pac_t) <= 225) && ((pac_b) >= 220) && ((x_next+20) <= 560) && ((x_next+20) >= 565) && ~dead[3]) begin
		dead[3]=1;
	score = score+ 4'd1;
	end
	//C4
	else if(((pac_t) <= 125) && ((pac_b) >= 120) && ((x_next+20) <= 320) && ((x_next+20) >= 325) && ~dead[4]) begin
		dead[4]=1;
		score = score+ 4'd1;
	end
	//C5
	else if(((pac_t) <= 325) && ((pac_b) >= 320) && ((x_next+20) <= 320) && ((x_next+20) >= 325) && ~dead[5]) begin
		dead[5]=1;
		score = score+ 4'd1;
	end
	//C6
	else if(((pac_t) <= 390) && ((pac_b) >= 385) && ((x_next+20) <= 160) && ((x_next+20) >= 165) && ~dead[6]) begin
		dead[6]=1;
		score = score+ 4'd1;
	end
	//C7
	else if(((pac_t) <= 390) && ((pac_b) >= 385) && ((x_next+20) <= 490) && ((x_next+20) >= 495) && ~dead[7]) begin
		dead[7]=1;
		score = score+ 4'd1;
	end

	end //end right
			
		if(up && ~wall_up) begin
			y_next = (clk_s) ? y_reg - 2 : y_reg;

	//		dir <= 4'b1000;
		end
		else if(right && ~wall_right) begin
			x_next = (clk_s) ? x_reg + 2 : x_reg;

	//		dir <= 4'b0100;
			//try blovking statements
		end
		else if(left && ~wall_left) begin
			x_next = (clk_s) ? x_reg - 2 : x_reg;

	//		dir <= 4'b0010;
		end
		else if(down && ~wall_down) begin
			y_next = (clk_s) ? y_reg + 2 : y_reg;

	//		dir <= 4'b0001;
		end
		else begin
			y_next = y_reg;
			x_next = x_reg;
		end
	
end


endmodule
