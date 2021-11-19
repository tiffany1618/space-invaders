`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:32:16 11/15/2021 
// Design Name: 
// Module Name:    segment_displays 
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
module segment_displays(
	// Inputs
	clk,
	clk_display,
	arst,
	lives,
   score,
	
	// Outputs
	an_lives,
	seg_lives,
   seg_score, 
   an_score
   );
	 
	input clk, clk_display, arst;
	input [1:0] lives;
	input [6:0] score;
	
	output reg an_lives, an_score;
	output reg [6:0] seg_lives, seg_score;
	
	reg [3:0] digit;
   reg counter;
	
	always @(posedge clk) begin
		if (arst) begin
			counter <= 0;
			an_lives <= 0;
         an_score <= 0;
		end
		else if (clk_display) begin
			dig_to_seg(lives, seg_lives);
			
			counter <= counter + 1;
			case(counter)
				0: begin
					an_score <= 0;
					dig_to_seg(score % 10, seg_score);
				end
				1: begin
					an_score <= 1;
					dig_to_seg(score / 10, seg_score);
				end
			endcase
		end
	end
	
	task dig_to_seg;
		input [3:0] dig;
		output reg [6:0] seg;
		
		begin
			case(dig)
				0: seg <= 7'b1000000;
				1: seg <= 7'b1111001;
				2: seg <= 7'b0100100;
				3: seg <= 7'b0110000;
				4: seg <= 7'b0011001;
				5: seg <= 7'b0010010;
				6: seg <= 7'b0000010;
				7: seg <= 7'b1111000;
				8: seg <= 7'b0000000;
				9: seg <= 7'b0010000;
				default: seg <= 7'b1111111;
			endcase
		end
	endtask
endmodule