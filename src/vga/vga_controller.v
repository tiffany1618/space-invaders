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
	invaders,
   invaders_x,
	invaders_y,
	
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
	input [9:0] player_x, player_y, invaders_x, invaders_y;
	input [54:0] invaders;
	input laser_active;
	input [9:0] laser_x, laser_y;
	
	output wire hsync, vsync, frame;
	output reg [7:0] vga_out;
	output reg player_collision;
	output reg [5:0] invader_collision;
	
	wire data_enable;
	
	// Current x and y positions of pixel being drawn
	wire integer x, y;
	
	// Sprite start signals
	reg start_player;
	reg [5:0] start_invader;
	
	// Sprite draw signals
	wire player_draw, invader_draw;
	reg laser_draw;
	reg invader_x, invader_y;
	reg [2:0] i; // Vertical counter
	reg [3:0] j; // Horizontal counter

	// Sprite output pixels
	reg [7:0] player_out;
	
	vga_timings _vga_timings (
		.clk,
		.rst,
		.hsync,
		.vsync,
		.data_enable,
		.frame,
		.ux(x),
		.uy(y)
	);
	
	draw_sprite draw_player (
		.clk,
		.rst(arst),
		.start(start_player),
		.sprite(PLAYER),
		.spr_x(player_x),
		.pixel_x(x),
		.spr_draw(player_draw)
	);
	
    draw_sprite draw_invader1 (
		.clk,
		.rst(arst),
		.start(start_invader != 0),
		.sprite(INVADER1),
		.spr_x(invader_x),
		.pixel_x(x),
		.spr_draw(invader_draw)        
    );
    
	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			vga_out <= 0;
			player_collision <= 0;
			invader_collision <= 0;
			start_player <= 0;
			start_invader <= 0;
			laser_draw <= 0;
		end
		else if (data_enable) begin		
			// Sprite drawing signals
			start_player <= (x == player_x && y == player_y);
			laser_draw <= (laser_active && x >= laser_x && x <= laser_x + PROJ_WIDTH_SCALED 
								&& y <= laser_y && y >= laser_y - PROJ_HEIGHT_SCALED);
                                      
			for (i = 0; i < INVADERS_V - 1; i = i + 1) begin
				for (j = 0; j < INVADERS_H - 1; j = j + 1) begin
					if (invaders[i * j] && x >= invaders_x + (INVADERS_OFFSET_H * j) && x < invaders_x + (INVADERS_OFFSET_H * (j + 1))
							&& y < invaders_y + (INVADERS_OFFSET_V * i) && y >= invaders_y + (INVADERS_OFFSET_V * (i - 1))) begin
						start_invader <= i * j + 1;
					end
				end
			end
				
			// Draw sprites
			if (player_draw) begin
				vga_out <= GREEN;
			end
			else if (laser_draw) begin
				vga_out <= WHITE;
			end
			else if (invader_draw) begin
				 vga_out <= BLUE;
			end
			else begin
				vga_out <= 0;
			end
			
			// Detect collisions
			if (laser_draw && invader_draw) begin
				invader_collision[start_invader-1] <= 1;
			end
		end
		else begin
			vga_out <= 0;
		end
	end
	
endmodule
