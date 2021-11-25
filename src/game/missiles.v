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
	
	always @(posedge clk or posedge rst or posedge arst) begin
        if (rst || arst) begin
            missileStart($urandom() % 55, t1_x, t1_y);
            missileStart($urandom() % 55, t2_x, t2_y);
            missileStart($urandom() % 55, t3_x, t3_y);
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
            if (t1_y == RES_V - PROJ_HEIGHT_SCALED || player_collision == 1)
                missileStart($urandom % 54, t1_x, t1_y);
            if (t2_y == RES_V - PROJ_HEIGHT_SCALED || player_collision == 2)
                missileStart($urandom % 54, t2_x, t2_y);
            if (t3_y == RES_V - PROJ_HEIGHT_SCALED || player_collision == 3)
                missileStart($urandom % 54, t3_x, t3_y);
        end
	end
    
    task missileStart;
        input [5:0] num;
        output reg [9:0] x;
        output reg [9:0] y;
        
        begin
            x <= invaders_x + (SPRITE_WIDTH_SCALED / 2) + (INVADERS_OFFSET_H * (num % INVADERS_H));
            y <= invaders_y + (SPRITE_HEIGHT_SCALED * ((num / INVADERS_H) + 1));
        end
    endtask

endmodule
