`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:56:56 03/19/2013 
// Design Name: 
// Module Name:    segdisplay 
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
module segdisplay(
	input wire segclk,		//7-segment clock
	input wire clr,			//asynchronous reset
	output reg [6:0] seg,	//7-segment display LEDs
	output reg [3:0] an,		//7-segment display anode enable
	input wire [3:0] score,
	input wire p_dead
	);

// constants for displaying letters on display
parameter N = 7'b1001000;
parameter E = 7'b0000110;
parameter R = 7'b1001100;
parameter P = 7'b0001100;

// Finite State Machine (FSM) states
parameter left = 2'b00;
parameter midleft = 2'b01;
parameter midright = 2'b10;
parameter right = 2'b11;

// state register
reg [1:0] state;
reg blink;

//initial begin
//	blink <= 0;
//end

// FSM which cycles though every digit of the display every 2.62ms.
// This should be fast enough to trick our eyes into seeing that
// all four digits are on display at the same time.
always @(posedge segclk or posedge clr)
begin
//blink<=~blink;
	// reset condition
	if (clr == 1)
	begin
		seg <= 7'b1111111;
		an <= 7'b1111;
		state <= left;
	end
	// display the character for the current position
	// and then move to the next state
	else 
	begin
    case(state)
			left:
      begin
				seg <= 8'b11111111;
				an <= 4'b0111;
				state <= midleft;
			end
			midleft:
			begin
				//seg <= E;
				seg <= 8'b11111111;
				an <= 4'b1011;
				state <= midright;
			end
			midright:
			begin
				//seg <= R;
				seg <= 8'b11111111;
				an <= 4'b1101;
				state <= right;
			end
			right:
			begin
//			if(p_dead && blink) begin
//				seg <= 8'b11111111;
//			end
			
          case(score)
            4'd0: 
            begin
               seg<=8'b11000000;
            end
            4'd1:
            begin
              seg<=8'b11111001;
            end
            4'd2:
            begin 
              seg<=8'b10100100;
            end
            4'd3:
            begin 
              seg<=8'b10110000;
            end
            4'd4: 
            begin 
              seg<=8'b10011001;
            end
            4'd5: 
            begin
              seg<=8'b100100101;
            end
            4'd6: 
            begin 
              seg<=8'b10000010;
            end
				4'd7:
				begin
					seg<=8'b11111000;
				end
				4'd8:
				begin
					seg<=8'b10000000;
				end
          endcase
			 
				an <= 4'b1110;
				state <= left;
			end
		endcase

    
		/*case(state)
			left:
			begin
				seg <= N;
				an <= 4'b0111;
				state <= midleft;
			end
			midleft:
			begin
				seg <= E;
				an <= 4'b1011;
				state <= midright;
			end
			midright:
			begin
				seg <= R;
				an <= 4'b1101;
				state <= right;
			end
			right:
			begin
				seg <= P;
				an <= 4'b1110;
				state <= left;
			end
		endcase*/
	end
end

endmodule
