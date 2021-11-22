`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:28:52 11/22/2021 
// Design Name: 
// Module Name:    invaders 
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
module invaders(
	// Inputs
	clk,
	rst,
	arst,
	frame,
	invader_collision,
	
	// Outputs
	invaders,
	invaders_x,
	invaders_y,
	);
	
	`include "../util/constants.v"
	input clk, rst, arst, frame;
	input [5:0] invader_collision;
	
	output reg [54:0] invaders;
	output reg [9:0] invaders_x, invaders_y;
	
	reg [54:0] invaders_temp;
	reg [9:0] x_temp, y_temp;

	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			invaders_temp <= 55'h7FFFFFFFFFFFFF;
			x_temp <= INVADERS_START_X;
			y_temp <= INVADERS_START_Y;
		end
		else if (frame) begin
			invaders <= invaders_temp;
			invaders_x <= x_temp;
			invaders_y <= y_temp;
		end
		else if (invader_collision != 0) begin
			invaders_temp[invader_collision-1] <= 0;
		end
		else begin
			// TODO: movement?
		end
	end

endmodule
