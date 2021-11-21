`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:26:39 11/20/2021 
// Design Name: 
// Module Name:    game 
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
module game(
	// Inputs
	clk,
	rst,
	arst,
	left,
	right,
	shoot,
	player_collision,
	invader_collision,
	frame,
	
	// Outputs
	lives,
	score,
	player_x,
	player_y,
	laser_x,
	laser_y,
	laser_active
	);

	input clk, rst, arst, left, right, shoot;
	input frame, player_collision;
	input [5:0] invader_collision;
	
	output wire [1:0] lives;
	output wire [6:0] score;
	output wire laser_active;
	output wire [9:0] player_x, player_y, laser_x, laser_y;
	
	score_logic _score_logic (
		.clk,
		.rst,
		.arst,
		.invader_collision,
		.player_collision,
		.lives,
		.score
	);
	
	player _player (
		.clk,
		.rst,
		.arst,
		.frame,
		.left,
		.right,
		.player_x,
		.player_y
	);
	
	laser _laser (
		.clk,
		.rst,
		.arst,
		.frame,
		.shoot,
		.player_x,
		.invader_collision,
		.laser_active,
		.laser_x,
		.laser_y
	);

endmodule
