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
	
	// Outputs
	vga_out, // RRRGGGBB
	hsync,
	vsync
	);
	
	`include "constants.v"
	
	input clk, rst, arst;
	input [9:0] player_x, player_y;
	output wire hsync, vsync;
	output reg [7:0] vga_out;
	
	wire clk_pixel;
	wire data_enable, update;
	wire [7:0] vga_in;
	
	reg [18:0] pixel_counter;
	reg [18:0] i, j; // Update counters
	reg [7:0] data [DISPLAY_V-1:0] [DISPLAY_H-1:0];
	
	clk_divider _clk_pixel (
		.clk,
		.rst,
		.freq(PIXEL_FREQ),
		.clk_out(clk_pixel)
	);
	
	vga_timings _vga_timings (
		.clk,
		.rst,
		.clk_pixel,
		.hsync,
		.vsync,
		.data_enable,
		.update
	);
	
	always @(posedge clk_pixel) begin
		if (arst) begin
			pixel_counter <= 19'b0;
		end
		else if (data_enable) begin
			if (pixel_counter == TOTAL_PIXELS)
				pixel_counter <= 1;
			else
				pixel_counter <= pixel_counter + 1;
				
			vga_out <= data[pixel_counter / DISPLAY_V][pixel_counter % DISPLAY_H];
		end
		else
			vga_out <= 8'b0;
		
		if (update) begin
			// Update player
			for (i = player_y; i < player_y + CHAR_HEIGHT; i = i + 1) begin
				for (j = player_x; j < player_x + PLAYER_WIDTH; j = j + 1) begin
					if (PLAYER_BITMAP[i - player_y][j - player_x]) begin
						data[i][j] = GREEN;
					end
				end
			end
			
			// Update invaders
			
			// Update player projectile
			
			// Update invader projectiles
		end
	end
	
endmodule
