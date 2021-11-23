`timescale 1ns / 1ps

module space_invaders(
	input clk,
	input rst,
	input btn_right,
	input btn_left,
	input btn_shoot,
	input btn_rst,
	
	output [3:0] an_lives,
	output [6:0] seg_lives,
	output an_score,
	output [6:0] seg_score,
	output [7:0] vga_color,
	output hsync,
	output vsync
	);
	
	`include "util/constants.v"

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
		.clk,
		.rst,
		.freq(100),
		.clk_out(clk_100Hz)
	);
			
	clk_divider _clk_pixel (
		.clk,
		.rst,
		.freq(PIXEL_FREQ),
		.clk_out(clk_pixel)
	);
    
    clk_divider _clk_10Hz (
		.clk,
		.rst,
		.freq(10),
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
