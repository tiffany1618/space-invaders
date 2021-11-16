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
	vsync,
	update
	);
	
	`include "constants.v"
	
	input clk, rst, clk_pixel;
	output reg hsync, vsync, update;
	
	reg [9:0] counter_h, counter_v;
	
	
	always @(posedge clk) begin
		if (rst) begin
			counter_h <= 10'b0;
			counter_v <= 10'b0;
		end
		else if (clk_pixel) begin
			if (counter_h == END_H) begin
				counter_h <= 0;
				
				if (counter_v == END_V)
					counter_v <= 0;
				else
					counter_v <= counter_v + 1;
			end
			else
				counter_h <= counter_h + 1;
	
			hsync <= (counter_h >= SYNC_START_H && counter_h < SYNC_END_H);
			vsync <= (counter_v >= SYNC_START_V && counter_v < SYNC_END_V);
			update <= (counter_h == 0 && counter_v == DISPLAY_V);
		end
	end
endmodule
