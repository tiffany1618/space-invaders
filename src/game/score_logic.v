`timescale 1ns / 1ps

// Keeps track of the current score and player lives
module score_logic(
	input clk,
	input rst,
	input arst,
	input frame,
	input [5:0] invader_collision,
	input [1:0] player_collision,
	
	output reg [1:0] lives, // Current player lives
	output reg [6:0] score, // Current player score
	output reg done // Signals end of game
	);
	
	`include "../util/constants.v"

	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst || done) begin
			lives <= PLAYER_LIVES;
			score <= 7'b0;
			done <= 0;
		end
		else if (frame) begin
			if (invader_collision != 0 && score < 99)
				score <= score + 1;
			
			if (player_collision != 0 && lives > 0)
				lives <= lives - 1;
				
			if (score == 55 || lives == 0)
				done <= 1;
		end
	end

endmodule
