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
	invaders_x,
	invaders_y,
	);
	
	input clk, rst, arst, frame;
	
	output reg [9:0] invaders_x, invaders_y;
	
	reg [9:0] temp_x, temp_y;

	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			x_temp <= INVADERS_START_X;
			y_temp <= INVADERS_START_Y;
		end
		else if (frame) begin
			invaders_x <= temp_x;
			invaders_y <= temp_y;
		end
		else begin
			// TODO: movement?
		end
	end

endmodule
