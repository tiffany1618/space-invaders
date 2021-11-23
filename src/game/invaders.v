`timescale 1ns / 1ps

// Logic for invaders
module invaders(
	input clk,
	input rst,
	input arst, // Reset button (async reset)
	input frame, // Signals start of blanking interval

    // The number of which invader has been hit (0 if there are currently no collisions)
	input [5:0] invader_collision, 	

    // Represents which invaders are currently alive
    // 1 for alive, 0 for killed
	output reg [54:0] invaders,	

    // Coordinates of top left corner of invaders grid
    output reg [9:0] invaders_x,
	output reg [9:0] invaders_y
	);
	
	`include "../util/constants.v"
	
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
