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
	
	// Outputs
	hsync,
	vsync,
	data_enable,
	frame // Beginning of new frame
	);
	
	`include "constants.v"
	
	input clk, rst;
	output reg hsync, vsync, data_enable, frame;
	
	reg signed [10:0] x, y;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			x <= START_H;
			y <= START_V;
		end
		else begin
			if (x == END_H) begin
				x <= START_H;
				
				if (y == END_V)
					y <= START_V;
				else
					y <= y + 1;
			end
			else
				x <= x + 1;	
			
			hsync <= ~(x > SYNC_START_H && x <= SYNC_END_H);
			vsync <= ~(y > SYNC_START_V && y <= SYNC_END_V);
			data_enable <= ((x >= ACTIVE_START_H && x <= END_H)
				|| (y >= ACTIVE_START_V && y <= END_V));
			frame <= (x == START_H && y == START_V);
		end
	end
endmodule
