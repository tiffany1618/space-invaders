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
	
	// Outputs
	vga_color,
	hsync,
	vsync
	);
	
	`include "constants.v"
	
	input clk, rst;
	output wire hsync, vsync;
	output wire [7:0] vga_color;
	
	wire clk_pixel;
	
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
		.vsync
	);
	
endmodule