`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:58:37 06/05/2023
// Design Name:   sprite
// Module Name:   C:/Users/Student/Documents/Lab6/Lab4/NERP_demo/pac.v
// Project Name:  NERP_demo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sprite
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pac;

	// Inputs
	reg clk;
	reg rst;
	reg clk_s;
	reg clk_10;
	reg up;
	reg down;
	reg left;
	reg right;

	// Outputs
	wire [9:0] x_reg;
	wire [9:0] y_reg;

	// Instantiate the Unit Under Test (UUT)
	sprite uut (
		.clk(clk), 
		.rst(rst), 
		.x_reg(x_reg), 
		.y_reg(y_reg), 
		.clk_s(clk_s), 
		.clk_10(clk_10), 
		.up(up), 
		.down(down), 
		.left(left), 
		.right(right)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		clk_s = 0;
		clk_10 = 0;
		up = 0;
		down = 0;
		left = 0;
		right = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

			#10
			clk_s = ~clk_s;
			#90
			clk_10 = ~clk_10;
			#100
			clk = ~clk;
			up = 1;
			#30
			up  =0;
			down = 1;
			#30
			down = 0;
			#30
			right = 1;
			#30
			right = 0;
			#30
			left = 1;
			#30
			left = 0;
			
	end
      
endmodule

