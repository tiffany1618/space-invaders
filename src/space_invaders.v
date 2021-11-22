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
	
	output wire an_score;
	output wire [3:0] an_lives;
	output wire [6:0] seg_lives, seg_score;
	output wire hsync, vsync;
	output wire [7:0] vga_color;
	
	// Clocks
	wire clk_100Hz, clk_10Hz;
	
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
	wire [54:0] invaders;
	
	// Projectiles
	wire laser_active;
	wire [9:0] laser_x, laser_y;
	
	clk_divider _clk_100Hz (
		// Inputs
		.clk,
		.rst,
		.freq(100),
		
		// Outputs
		.clk_out(clk_100Hz)
	);
			
	clk_divider _clk_pixel (
		.clk,
		.rst,
		.freq(PIXEL_FREQ),
		.clk_out(clk_pixel)
	);
    
    clk_divider _clk_10Hz (
		// Inputs
		.clk,
		.rst,
		.freq(10),
		
		// Outputs
		.clk_out(clk_10Hz)
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
		.rst,
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
		.invaders,
		.invaders_x,
		.invaders_y,
		.vga_out(vga_color),
		.vsync,
		.hsync,
		.frame
	);
	
	score_logic _score_logic (
		.clk(clk_pixel),
		.rst,
		.arst,
		.invader_collision,
		.player_collision,
		.lives,
		.score
	);
	
	player _player (
		.clk,
		.clk_move(clk_10Hz),
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
	
	invaders _invaders (
		.clk,
		.rst,
		.arst,
		.frame,
		.invader_collision,
		.invaders,
		.invaders_x,
		.invaders_y
	);

endmodule
