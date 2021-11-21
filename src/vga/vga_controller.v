`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:29:00 11/15/2021 
// Design Name: 
// Module Name:    vga_controller 
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
module vga_controller(
	// Inputs
	clk,
	rst,
	arst,
	
	player_x,
	player_y,
	laser_active,
	laser_x,
	laser_y,
	
	// Outputs
	vga_out, // RRRGGGBB
	hsync,
	vsync,
	frame,
	player_collision,
	invader_collision
	);
	
	`include "../util/constants.v"
	
	input clk, rst, arst;
	input [9:0] player_x, player_y;
	input laser_active;
	input [9:0] laser_x, laser_y;
	
	output wire hsync, vsync, frame;
	output reg [7:0] vga_out;
	output reg player_collision;
	output reg [5:0] invader_collision;
	
	wire data_enable;
	
	// Current x and y positions of pixel being drawn
	reg [$clog2(RES_H)-1:0] pixel_x;
	reg [$clog2(RES_V)-1:0] pixel_y;
	
	// Sprite start signals
	reg start_player;
	
	// Sprite draw signals
	wire player_draw;
	reg laser_draw;

	// Sprite output pixels
	reg [7:0] player_out;
	
	vga_timings _vga_timings (
		.clk,
		.rst,
		.hsync,
		.vsync,
		.data_enable,
		.frame
	);
	
	draw_sprite draw_player (
		.clk,
		.rst(arst),
		.start(start_player),
		.sprite(PLAYER),
		.spr_x(player_x),
		.pixel_x,
		.spr_draw(player_draw)
	);
	
	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			pixel_x <= 0;
			pixel_y <= 0;
			vga_out <= 0;
		end
		else if (data_enable) begin
			// Update pixel positions
			if (pixel_x == RES_H - 1) begin
				pixel_x <= 0;
				
				if (pixel_y == RES_V - 1)
					pixel_y <= 0;
				else
					pixel_y <= pixel_y + 1;
			end
			else
				pixel_x <= pixel_x + 1;
				
			// Sprite drawing signals
			start_player <= (pixel_x == player_x && pixel_y == player_y);
			laser_draw <= (laser_active && pixel_x >= laser_x && pixel_x <= laser_x + PROJ_WIDTH_SCALED 
								&& pixel_y >= laser_y && pixel_y <= laser_y + PROJ_HEIGHT_SCALED);
				
			// Draw sprites
			if (player_draw) begin
				vga_out <= PLAYER_PIXEL;
			end
			else if (laser_draw) begin
				vga_out <= WHITE;
			end
			else begin
				vga_out <= 0;
			end
		end
		else begin
			vga_out <= 0;
		end
	end
	
endmodule
