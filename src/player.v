`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:14 11/18/2021 
// Design Name: 
// Module Name:    player 
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
module player(
	// Inputs
	clk,
	rst,
	arst,
	frame,
	left,
	right,
	
	// Outputs
	player_x,
	player_y
	);
	
	`include "constants.v"

	input clk, rst, arst, frame, left, right;
	output reg [9:0] player_x, player_y;
	
	reg x_temp;
	
	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			x_temp <= PLAYER_START_X;
			player_y <= PLAYER_START_Y;
		end
		else if (frame)
			player_x <= x_temp;
		else begin
			if (left && ~right)
				x_temp <= x_temp - PLAYER_STEP;
			
			if (right && ~left)
				x_temp <= x_temp + PLAYER_STEP;
		end
	end

endmodule
