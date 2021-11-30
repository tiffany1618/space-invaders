`timescale 1ns / 1ps

// Draws a row of 11 scaled sprites from a single bitmap
// Invididual sprites in the row may be visible or hidden
// Implemented as FSM
module draw_sprite_row(
	input clk,
	input rst,
	input start, // Signals when to start drawing the row
	input [2:0] sprite, // Enum for sprite to draw
	input [9:0] spr_x, // Top left horizontal coord of sprite row
	input [$clog2(RES_H):0] pixel_x, // Current horizontal screen position
	input [INVADERS_H-1:0] sprites, // 1 if sprite should be drawn, 0 otherwise
	
	// Non-zero if the pixel currently drawn is a pixel within a sprite
	// Value denotes the position of the sprite currently being drawn
	output reg [$clog2(INVADERS_H):0] spr_draw
	);
	
	`include "../util/constants.v"

	// States
	localparam IDLE = 0; // Awaiting start signal
	localparam START = 1; // Prepare for new sprite row
	localparam AWAIT_POS = 2; // Await horizontal position
   localparam START_SPRITE = 3; // Prepare to draw next sprite
	localparam DRAW = 4; // Draw pixel
	localparam NEXT_LINE = 5; // Prepare for next sprite line
	
	reg [3:0] state, next_state;
	reg [SPRITE_WIDTH-1:0] memory [0:SPRITE_HEIGHT-1]; // Sprite data
	reg [$clog2(SPRITE_WIDTH):0] x; // Horizontal position within sprite
	reg [$clog2(SPRITE_HEIGHT):0] y; // Vertical position within sprite
	reg [$clog2(SPRITE_SCALE):0] counter_x, counter_y; // Scaling counters
	reg [$clog2(INVADERS_H):0] i; // Sprite counter
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state <= IDLE;
			x <= 0;
			y <= 0;
			counter_y <= 0;
			counter_x <= 0;
			spr_draw <= 0;
			i <= 0;
            
			case (sprite)
				 INVADER1: begin
					  memory[0] = 13'b0000011110000;
					  memory[1] = 13'b0011111111110;
					  memory[2] = 13'b0111111111111;
					  memory[3] = 13'b0111001100111;
					  memory[4] = 13'b0111111111111;
					  memory[5] = 13'b0000110011000;
					  memory[6] = 13'b0001101101100;
					  memory[7] = 13'b0110000000011;               
				 end
			endcase           
		end
		else begin
			state <= next_state;
			
			if (state == DRAW && memory[y][x])
				spr_draw <= i;
			else
				spr_draw <= 0;
			
			case (state)
				START: begin
					y <= 0;
					counter_y <= 0;
					i <= 0;
				end
				AWAIT_POS: begin
					x <= 0;
					counter_x <= 0;
				end
				START_SPRITE: begin
				  x <= 0;
				  counter_x <= 0;
				  i <= i + 1;
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
					i <= 0;
					
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
			AWAIT_POS: begin
				if (pixel_x == spr_x + (INVADERS_OFFSET_H * i))
					next_state = START_SPRITE;
				else
					next_state = AWAIT_POS;
			end
			START_SPRITE: begin
				if (sprites[i])
					next_state = DRAW;
				else if (i < INVADERS_H - 1)
					next_state = AWAIT_POS;
				else if (!(y == SPRITE_HEIGHT - 1 && counter_y == SPRITE_SCALE - 1))
					next_state = NEXT_LINE;
				else
					next_state = IDLE;
			end
			DRAW: begin
				if (!(x == SPRITE_WIDTH - 1 && counter_x == SPRITE_SCALE - 1))
					next_state = DRAW;
				else if (i < INVADERS_H)
					 next_state = AWAIT_POS;
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