//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:51:11 11/20/2021 
// Design Name: 
// Module Name:    laser 
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
module laser(
	// Inputs
	clk,
	rst,
	arst,
	frame,
	shoot,
	player_x,
	invader_collision,
	
	// Outputs
	laser_active,
	laser_x,
	laser_y
	);
	
	`include "../util/constants.v"

	input clk, rst, arst, frame, shoot;
	input [9:0] player_x;
	input [5:0] invader_collision;
	
	output reg laser_active;
	output reg [9:0] laser_x, laser_y;
	
	reg [9:0] x_temp, y_temp;
	
	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			laser_active <= 0;
		end
		else if (shoot && ~laser_active) begin
			laser_active <= 1;
			x_temp <= player_x + (SPRITE_WIDTH_SCALED / 2) - (PROJ_WIDTH_SCALED) / 2;
			y_temp <= PLAYER_START_Y - PROJ_HEIGHT_SCALED;
		end
		else if (frame && laser_active) begin
			if (y_temp == 0 || invader_collision != 0)
				laser_active <= 0;
			else begin
				y_temp <= y_temp - LASER_STEP;
				laser_x <= x_temp;
				laser_y <= y_temp;
			end
		end
	end

endmodule
