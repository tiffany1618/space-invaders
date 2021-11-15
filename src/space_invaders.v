`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:54:40 11/15/2021 
// Design Name: 
// Module Name:    space_invaders 
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
module space_invaders(
	// Inputs
	clk,
	rst,
	btn_right,
	btn_left,
	btn_shoot,
	btn_rst,
	
	// Outputs
	an_lives,
	seg_lives,
	an_score,
	seg_score
	);
	
	`include "constants.v"

	input clk, rst, btn_right, btn_left, btn_shoot, btn_rst;
	output wire an_lives, an_score;
	output wire [6:0] seg_lives, seg_score;
	
	wire clk_200Hz;
	wire shoot, left, right, arst;
	wire [3:0] lives;
	wire [6:0] score;
	
	clk_divider _clk_200Hz (
		// Inputs
		.clk(clk),
		.rst(rst),
		.freq(200),
		
		// Outputs
		.clk_out(clk_200Hz)
	);
	
	debouncer _debouncer (
		// Inputs
		.clk(clk),
		.clk_debouncer(clk_200Hz),
		.rst(rst),
		.btn_shoot(btn_shoot),
		.btn_left(btn_left),
		.btn_right(btn_right),
		.btn_rst(btn_rst),
		
		// Outputs
		.shoot(shoot),
		.left(left),
		.right(right),
		.arst(arst)
	);
	
	segment_displays _segment_displays (
		// Inputs
		.clk(clk),
		.clk_display(clk_200Hz),
		.arst(arst),
		.lives(lives),
		.score(score),
		
		// Outputs
		.an_lives(an_lives),
		.seg_lives(seg_lives),
		.an_score(an_score),
		.seg_score(seg_score)
	);

endmodule
