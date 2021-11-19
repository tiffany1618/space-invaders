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
	vsync,
	frame
	);
	
	`include "../util/constants.v"
	
	input clk, rst, arst;
	input [9:0] player_x, player_y;
	output wire hsync, vsync, frame;
	output reg [7:0] vga_out;
	
	wire clk_pixel;
	wire data_enable;
	
	// Current x and y positions of pixel being drawn
	reg [$clog2(RES_H)-1:0] pixel_x;
	reg [$clog2(RES_V)-1:0] pixel_y;
	
	// Sprite start signals
	wire start_player;
	
	// Sprite draw signals
	wire player_draw;

	// Sprite output pixels
	reg [7:0] player_out;
		
	clk_divider _clk_pixel (
		.clk,
		.rst,
		.freq(PIXEL_FREQ),
		.clk_out(clk_pixel)
	);
	
	vga_timings _vga_timings (
		.clk(clk_pixel),
		.rst,
		.hsync,
		.vsync,
		.data_enable,
		.frame
	);
	
	draw_sprite draw_player (
		.clk(clk_pixel),
		.rst(arst),
		.start(start_player),
		.sprite(PLAYER),
		.spr_x(player_x),
		.pixel_x,
		.spr_draw(player_draw)
	);
	
	// Sprite drawing signals
	assign start_player = (pixel_x == player_x && pixel_y == player_y);
	
	always @(posedge clk_pixel) begin
		if (arst) begin
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
				
			// Draw sprites
			if (player_draw)
				vga_out <= PLAYER_PIXEL;
			else
				vga_out <= 0;
		end
		else
			vga_out <= 0;
	end
	
endmodule
