`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:59:33 11/17/2021 
// Design Name: 
// Module Name:    draw_sprite 
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
module draw_sprite(
	// Inputs
	clk,
	rst,
	start,
	sprite,
	spr_x,
	pixel_x,
	
	// Outputs
	spr_draw
	);
	
	`include "../util/constants.v"
	
	input clk, rst, start;
	input [2:0] sprite;
	input [9:0] spr_x;
	input [$clog2(RES_H)-1:0] pixel_x;
	
	output wire spr_draw;
	
	// States
	localparam IDLE = 0; // Awaiting start signal
	localparam START = 1; // Prepare for new sprite drawing
	localparam AWAIT_POS = 2; // Await horizontal position
	localparam DRAW = 3; // Draw pixel
	localparam NEXT_LINE = 4; // Prepare for next sprite line
	
	reg [3:0] state, next_state;
	reg [SPRITE_WIDTH-1:0] memory [SPRITE_HEIGHT-1:0]; // Sprite data
	reg [$clog2(SPRITE_WIDTH)-1:0] x; // Horizontal position within sprite
	reg [$clog2(SPRITE_HEIGHT)-1:0] y; // Vertical position within sprite
	reg [$clog2(SPRITE_SCALE):0] counter_x, counter_y; // Scaling counters
	
	initial begin
		case (sprite)
			PLAYER: $readmemb("../bitmaps/player.txt", memory);
			INVADER1: $readmemb("../bitmaps/invader1.txt", memory);
		endcase
	end
	
	assign spr_draw = (state == DRAW && memory[y][x]);
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state <= IDLE;
			x <= 0;
			y <= 0;
			counter_y <= 0;
			counter_x <= 0;
		end
		else begin
			state <= next_state;
			
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
				else if (!(y == 7 && counter_y == SPRITE_SCALE - 1))
					next_state = NEXT_LINE;
				else
					next_state = IDLE;
			end
         NEXT_LINE:  next_state = AWAIT_POS;
         default: next_state = IDLE;
		endcase
	end

endmodule
