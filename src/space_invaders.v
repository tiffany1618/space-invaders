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
	seg_score,
	vga_color,
	hsync,
	vsync
	);
	
	`include "util/constants.v"

	input clk, rst, btn_right, btn_left, btn_shoot, btn_rst;
	
	output wire an_lives, an_score;
	output wire [6:0] seg_lives, seg_score;
	output wire hsync, vsync;
	output wire [7:0] vga_color;
	
	// Clocks
	wire clk_200Hz;
	
	// Game
	wire shoot, left, right, arst;
	wire [5:0] invader_collision;
	wire player_collision;
	wire [1:0] lives;
	wire [6:0] score;
	
	// VGA
	wire clk_pixel, frame;
	
	// Sprites
	wire [9:0] player_x, player_y;
	wire [9:0] invaders_x, invaders_y;
	
	// Projectiles
	wire laser_active;
	wire [9:0] laser_x, laser_y;
	
	clk_divider _clk_200Hz (
		// Inputs
		.clk,
		.rst,
		.freq(200),
		
		// Outputs
		.clk_out(clk_200Hz)
	);
			
	clk_divider _clk_pixel (
		.clk,
		.rst,
		.freq(PIXEL_FREQ),
		.clk_out(clk_pixel)
	);
	
	debouncer _debouncer (
		.clk,
		.clk_debouncer(clk_200Hz),
		.rst,
		.btn_shoot,
		.btn_left,
		.btn_right,
		.btn_rst,
		.shoot,
		.left,
		.right,
		.arst
	);
	
	segment_displays _segment_displays (
		.clk,
		.clk_display(clk_200Hz),
		.arst,
		.lives,
		.score,
		.an_lives,
		.seg_lives,
		.an_score,
		.seg_score
	);
	
	vga_controller _vga_controller (
		.clk(clk_pixel),
		.rst,
		.arst,
		.player_x,
		.player_y,
		.laser_active,
		.laser_x,
		.laser_y,
		.vga_out(vga_color),
		.vsync,
		.hsync,
		.frame
	);
	
	game _game (
		.clk(clk_pixel),
		.rst,
		.arst,
		.left,
		.right,
		.shoot,
		.invader_collision,
		.player_collision,
		.frame,
		.lives,
		.score,
		.player_x,
		.player_y,
		.laser_x,
		.laser_y,
		.laser_active
	);

endmodule
