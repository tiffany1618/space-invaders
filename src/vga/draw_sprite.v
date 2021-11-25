`timescale 1ns / 1ps

// Draws a scaled sprite from a bitmap
// Implemented as FSM, based on https://projectf.io/posts/hardware-sprites/
module draw_sprite(
	input clk,
	input rst,
	input start, // Signals when to start drawing
	input [2:0] sprite, // Enum for sprite to draw
	input [9:0] spr_x, // Top left horizontal coord of sprite
	input [$clog2(RES_H)-1:0] pixel_x, // Current horizontal screen position
	
   // 1 if the pixel currently drawn is a pixel within the sprite
	output reg spr_draw
	);
	
	`include "../util/constants.v"

	// States
	localparam IDLE = 0; // Awaiting start signal
	localparam START = 1; // Prepare for new sprite drawing
	localparam AWAIT_POS = 2; // Await horizontal position
	localparam DRAW = 3; // Draw pixel
	localparam NEXT_LINE = 4; // Prepare for next sprite line
	
	reg [3:0] state, next_state;
	reg [SPRITE_WIDTH-1:0] memory [0:SPRITE_HEIGHT-1]; // Sprite data
	reg [$clog2(SPRITE_WIDTH)-1:0] x; // Horizontal position within sprite
	reg [$clog2(SPRITE_HEIGHT)-1:0] y; // Vertical position within sprite
	reg [$clog2(SPRITE_SCALE):0] counter_x, counter_y; // Scaling counters

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state <= IDLE;
			x <= 0;
			y <= 0;
			counter_y <= 0;
			counter_x <= 0;
			spr_draw <= 0;
			
			case (sprite)
				PLAYER: begin
					memory[0] = 13'b0000001000000;
					memory[1] = 13'b0000011100000;
					memory[2] = 13'b0000011100000;
					memory[3] = 13'b0111111111110;
					memory[4] = 13'b1111111111111;
					memory[5] = 13'b1111111111111;
					memory[6] = 13'b1111111111111;
					memory[7] = 13'b1111111111111;
				end
			endcase
		end
		else begin
			state <= next_state;
			spr_draw <= (state == DRAW && memory[y][x]);
			
			case (state)
				START: begin
					y <= 0;
					counter_y <= 0;
				end
				AWAIT_POS: begin
					x <= 0;
					counter_x <= 0;
				end
				DRAW: begin
					if (SPRITE_SCALE <= 1 || counter_x  == SPRITE_SCALE - 1) begin
						x <= x + 1;
						counter_x <= 0;
					end
					else
						counter_x <= counter_x + 1;
				end
				NEXT_LINE: begin
					if (SPRITE_SCALE <= 1 || counter_y == SPRITE_SCALE - 1) begin
						y <= y + 1;
						counter_y <= 0;
					end
					else begin
						counter_y <= counter_y + 1;
					end
				end
			endcase
		end
	end
	
	// State transitions
	always @* begin
		case (state)
			IDLE: next_state = start ? START : IDLE;
			START: next_state = AWAIT_POS;
			AWAIT_POS: next_state = (pixel_x == spr_x) ? DRAW : AWAIT_POS;
			DRAW: begin
				if (!(x == SPRITE_WIDTH - 1 && counter_x == SPRITE_SCALE - 1))
					next_state = DRAW;
				else if (!(y == SPRITE_HEIGHT - 1 && counter_y == SPRITE_SCALE - 1))
					next_state = NEXT_LINE;
				else
					next_state = IDLE;
			end
			NEXT_LINE:  next_state = AWAIT_POS;
			default: next_state = IDLE;
		endcase
	end

endmodule
