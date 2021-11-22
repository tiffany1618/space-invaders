//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:23 11/15/2021 
// Design Name: 
// Module Name:    score_logic 
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
module score_logic(
	// Inputs
	clk,
	rst,
	arst,
	invader_collision,
	player_collision,
	
	// Outputs
	lives,
	score
	);
	
	`include "../util/constants.v"
		
	input clk, rst, arst;
    input [5:0] invader_collision;
    input player_collision;
	
	output reg [1:0] lives;
	output reg [6:0] score;

	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			lives <= PLAYER_LIVES;
			score <= 7'b0;
		end
		else begin
			if (invader_collision != 0 && score < 99)
				score <= score + 1;
			
			if (player_collision && lives > 0)
				lives <= lives - 1;
		end
	end

endmodule
