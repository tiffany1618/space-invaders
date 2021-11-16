`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:45:23 11/15/2021 
// Design Name: 
// Module Name:    vga_timings 
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
module vga_timings(
	// Inputs
	clk,
	rst,
	clk_pixel,
	
	// Outputs
	hsync,
	vsync
	);
	
	`include "constants.v"
	
	input clk, rst, clk_pixel;
	output reg hsync, vsync;
	
	reg [9:0] counter_h, counter_v;
	
	
	always @(posedge clk) begin
		if (rst) begin
			counter_h <= 10'b0;
			counter_v <= 10'b0;
		end
		else if (clk_pixel) begin
			if (counter_h > MAX_H)
				counter_h <= 10'b0;
			else
				counter_h <= counter_h + 1;
				
			if (counter_v > MAX_V)
				counter_v <= 10'b0;
			else
				counter_v <= counter_v + 1;
				
			hsync <= ~((counter_h >= SYNC_H && counter_h < BACK_PORCH_H) 
				|| (counter_h >= DISPLAY_H && counter_h < FRONT_PORCH_H));
			vsync <= ~((counter_v >= SYNC_V && counter_v < BACK_PORCH_V) 
				|| (counter_v >= DISPLAY_V && counter_v < FRONT_PORCH_V));
	
		end
	end
endmodule
