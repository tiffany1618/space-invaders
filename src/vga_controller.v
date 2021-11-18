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
(* bram_map = "yes" *)
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
			
		end
		else if (data_enable) begin
			
		end
		else
			vga_out <= 8'b0;
		
		if (update) begin
	
		end
	end
	
endmodule
