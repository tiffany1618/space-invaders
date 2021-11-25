`timescale 1ns / 1ps

// Logic for invaders
module invaders(
	input clk,
	input clk_move,
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
	
	reg [54:0] temp_invaders;
	reg [9:0] temp_x, temp_y;
	reg direction; // 1 for right, 0 for left

	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			temp_invaders <= 55'h7FFFFFFFFFFFFF; // All invaders alive
			temp_x <= INVADERS_START_X;
			temp_y <= INVADERS_START_Y;
         direction <= 0;
		end
		else if (frame) begin
         invaders <= temp_invaders;
			invaders_x <= temp_x;
			invaders_y <= temp_y;
		end
		else if (invader_collision != 0) begin
			temp_invaders[invader_collision - 1] <= 0;
		end
		else if (clk_move) begin
			// Change directions when the invaders hit the edge of the screen
			if (temp_x == RES_H - INVADERS_WIDTH_TOT) begin
				 direction <= 0;
				 
				 // Move invaders down the screen
				 // temp_y <= temp_y + SPRITE_HEIGHT_SCALED;
			end
			else if (temp_x == 0)
				 direction <= 1;

			if (direction)
				 temp_x <= temp_x + INVADERS_STEP;
			else
				 temp_x <= temp_x - INVADERS_STEP;
		end
	end

endmodule
