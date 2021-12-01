`timescale 1ns / 1ps

// Logic for player
module player(
	input clk,
   input clk_move, // Frequency at which to move player
	input rst,
	input arst, // Reset buton (async reset)
	input frame, // Signals start of blanking interval
	input left, // Debounced left button signal
	input right, // Debounced right button signal
	input done,
	
	output reg [9:0] player_x,
	output reg [9:0] player_y
	);
	
	`include "../util/constants.v"
	
	reg [9:0] x_temp, y_temp;
	
	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst || done) begin
			x_temp <= PLAYER_START_X;
			y_temp <= PLAYER_START_Y;
		end
		else if (frame) begin
			player_x <= x_temp;
			player_y <= y_temp;
		end
		else if (clk_move) begin
			if (left && ~right && x_temp > PLAYER_STEP)
				x_temp <= x_temp - PLAYER_STEP;
			
			if (right && ~left && x_temp < (RES_H - SPRITE_WIDTH_SCALED - PLAYER_STEP))
				x_temp <= x_temp + PLAYER_STEP;
		end
	end

endmodule
