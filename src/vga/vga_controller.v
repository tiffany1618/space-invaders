`timescale 1ns / 1ps

// Logic for VGA controller
module vga_controller(
	input clk,
	input rst,
	input arst, // Reset button (async reset)

   // Game inputs
	input [9:0] player_x,
	input [9:0] player_y,
	input laser_active,
	input [9:0] laser_x,
	input [9:0] laser_y,
	input [54:0] invaders,
   input [9:0] invaders_x,
	input [9:0] invaders_y,
	
   output hsync, // Horizontal sync
	output vsync, // Vertical sync
	output frame, // Signals start of blanking interval
	output reg [7:0] vga_out, // 8-bit color pixel
	output reg player_collision, // 1 if player and missile collided
	output reg [5:0] invader_collision // Non-zero if invader and laser collided
	);
	
	`include "../util/constants.v"
	
	wire data_enable;
	
	// Current x and y positions of pixel being drawn
	wire integer x, y;
	
	// Sprite start signals
	reg start_player;
	reg [INVADERS_V:0] start_invaders;
	
	// Sprite draw signals
	wire player_draw; 
	wire [4:0] invader_draw;
	reg laser_draw;
	reg [$clog2(INVADERS_V):0] i; // Vertical invaders counter
	reg [INVADERS_H-1:0] invader_row; // Currently drawn row of invaders

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
	
	draw_sprite_row draw_invaders (
		.clk,
		.rst(arst),
		.start(start_invaders != 0),
		.sprite(INVADER1),
		.spr_x(invaders_x),
		.pixel_x(x),
		.sprites(invader_row),
		.spr_draw(invader_draw)
	);
	
	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			vga_out <= 0;
			player_collision <= 0;
			invader_collision <= 0;
			start_player <= 0;
			start_invaders <= 0;
			laser_draw <= 0;
		end
		else if (data_enable) begin		
			// Sprite drawing signals
			start_player <= (x == player_x && y == player_y);
			laser_draw <= (laser_active && x >= laser_x && x <= laser_x + PROJ_WIDTH_SCALED 
								&& y <= laser_y && y >= laser_y - PROJ_HEIGHT_SCALED);
         
			if (x == invaders_x) begin
				if (y == invaders_y) begin
					start_invaders <= 1;
					invader_row <= invaders[INVADERS_H-1:0];
				end
				else if (y == invaders_y + (INVADERS_OFFSET_V * 1)) begin
					start_invaders <= 2;
					invader_row <= invaders[(INVADERS_H * 2)-1:INVADERS_H];
				end
				else if (y == invaders_y + (INVADERS_OFFSET_V * 2)) begin
					start_invaders <= 3;
					invader_row <= invaders[(INVADERS_H * 3)-1:(INVADERS_H * 2)];
				end
				else if (y == invaders_y + (INVADERS_OFFSET_V * 3)) begin
					start_invaders <= 4;
					invader_row <= invaders[(INVADERS_H * 4)-1:(INVADERS_H * 3)];
				end
				else if (y == invaders_y + (INVADERS_OFFSET_V * 4)) begin
					start_invaders <= 5;
					invader_row <= invaders[(INVADERS_H * 5)-1:(INVADERS_H * 4)];
				end
				else
					start_invaders <= 0;
			end
			else
				start_invaders <= 0;
			
			/*
			for (i = 0; i < INVADERS_V - 1; i = i + 1) begin
				if (x == invaders_x && y == invaders_y + (INVADERS_OFFSET_V * i)) begin
					start_invaders <= i + 1;
					invader_row <= invaders[(INVADERS_H * (i + 1)):(INVADERS_H * i)];
				end
				else begin
					start_invaders <= 0;
				end
			end
			*/
				
			// Draw sprites
			if (player_draw) begin
				vga_out <= GREEN;
			end
			else if (laser_draw) begin
				vga_out <= WHITE;
			end
			else if (invader_draw != 0) begin
				 vga_out <= WHITE;
			end
			else begin
				vga_out <= 0;
			end
			
			// Detect collisions
			if (laser_draw && invader_draw != 0)
				invader_collision <= invader_draw * start_invaders;
			else
				invader_collision <= 0;
		end
		else begin
			vga_out <= 0;
		end
	end
	
endmodule
