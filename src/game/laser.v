`timescale 1ns / 1ps

// Logic for player's laser
// Only one laser allowed on screen at a time
module laser(
	input clk,
	input rst,
	input arst, // Reset button (async reset)
	input frame, // Signals start of blanking interval
	input shoot, // Debounced shoot button signal
	input [9:0] player_x, // Current top left horizontal player position
	input [5:0] invader_collision,
	
    // 1 if laser should appear, 0 if not
	output reg laser_active,

    // Coordinates of top left corner of laser
	output reg [9:0] laser_x,
	output reg [9:0] laser_y
	);
	
	`include "../util/constants.v"

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
			y_temp <= y_temp - LASER_STEP;
			laser_x <= x_temp;
			laser_y <= y_temp;
		end
		else if (y_temp == 0 || invader_collision != 0) begin
			laser_active <= 0;
		end
	end

endmodule
