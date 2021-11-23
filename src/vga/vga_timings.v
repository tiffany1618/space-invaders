`timescale 1ns / 1ps

// Outputs timing signals for VGA controller
// Based on https://projectf.io/posts/fpga-graphics/
module vga_timings(
	input clk,
	input rst,
	
	output reg hsync, // Horizontal sync
	output reg vsync, // Vertical sync
	output reg data_enable, // High during active drawing period
	output reg frame, // Signals start of blanking interval
	output integer ux, // Current unsigned horizontal screen position
	output integer uy // Current unsigned vertical screen position
	);
	
	`include "../util/constants.v"
	
	integer x, y;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			x <= START_H;
			y <= START_V;
			ux <= 0;
			uy <= 0;
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
			data_enable <= (x >= ACTIVE_START_H - 1 && y >= ACTIVE_START_V - 1);
			frame <= (x == START_H && y == START_V);
			
			if (data_enable) begin
				ux <= $unsigned(x);
				uy <= $unsigned(y);
			end
		end
	end
endmodule
