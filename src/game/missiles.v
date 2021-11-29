`timescale 1ns / 1ps

// Logic for invaders' missiles
// Only 3 missiles allowed on screen at a time
module missiles(
	input clk,
	input rst,
	input arst,
	input frame,
	input [9:0] invaders_x,
   input [9:0] invaders_y,
	input [1:0] player_collision,
	
	// Missile positions
	output reg [9:0] m1_x,
	output reg [9:0] m1_y,
   output reg [9:0] m2_x,
	output reg [9:0] m2_y,
   output reg [9:0] m3_x,
	output reg [9:0] m3_y
	);
	
	`include "../util/constants.v"

	reg [9:0] t1_x, t1_y, t2_x, t2_y, t3_x, t3_y;
	reg [3:0] count_1, count_2, count_3;
	
	always @(posedge clk or posedge rst or posedge arst) begin
        if (rst || arst) begin
				count_1 <= 0;
				count_2 <= 6;
				count_3 <= 10;
			
				t1_x <= INVADERS_START_X + (SPRITE_WIDTH_SCALED / 2) + (INVADERS_OFFSET_H * (count_1 % INVADERS_H));
				t1_y <= INVADERS_START_Y + SPRITE_HEIGHT_SCALED;
				t2_x <= INVADERS_START_X + (SPRITE_WIDTH_SCALED / 2) + (INVADERS_OFFSET_H * (count_2 % INVADERS_H));
				t2_y <= INVADERS_START_Y + SPRITE_HEIGHT_SCALED * 2;
				t3_x <= INVADERS_START_X + (SPRITE_WIDTH_SCALED / 2) + (INVADERS_OFFSET_H * (count_3 % INVADERS_H));
				t3_y <= INVADERS_START_Y + SPRITE_HEIGHT_SCALED * 3;
        end
        else if (frame) begin
            t1_y <= t1_y + MISSILE_STEP;
            t2_y <= t2_y + MISSILE_STEP;
            t3_y <= t3_y + MISSILE_STEP;

            m1_x <= t1_x;
            m1_y <= t1_y;
            m2_x <= t2_x;
            m2_y <= t2_y;
            m3_x <= t3_x;
            m3_y <= t3_y;
        end
        else begin
            // Generate new missiles if they have reached the end of the 
            // screen or hit the player
            if (t1_y == RES_V - PROJ_HEIGHT_SCALED || player_collision == 1) begin
					if (count_1 == 11)
						count_1 <= 0;
					else
						count_1 <= count_1 + 1;
						
					t1_x <= invaders_x + (SPRITE_WIDTH_SCALED / 2) + (INVADERS_OFFSET_H * (count_1 % INVADERS_H));
					t1_y <= invaders_y + SPRITE_HEIGHT_SCALED;
				end
            if (t2_y == RES_V - PROJ_HEIGHT_SCALED || player_collision == 2) begin
					if (count_2 == 11)
						count_2 <= 0;
					else
						count_2 <= count_2 + 1;
						
					t2_x <= invaders_x + (SPRITE_WIDTH_SCALED / 2) + (INVADERS_OFFSET_H * (count_2 % INVADERS_H));
					t2_y <= invaders_y + SPRITE_HEIGHT_SCALED * 2;
				end
            if (t3_y == RES_V - PROJ_HEIGHT_SCALED || player_collision == 3) begin
					if (count_3 == 11)
						count_3 <= 0;
					else
						count_3 <= count_1 + 3;
						
					t3_x <= invaders_x + (SPRITE_WIDTH_SCALED / 2) + (INVADERS_OFFSET_H * (count_3 % INVADERS_H));
					t3_y <= invaders_y + SPRITE_HEIGHT_SCALED * 3;
				end
        end
	end
     
endmodule
