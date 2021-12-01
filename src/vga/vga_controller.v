`timescale 1ns / 1ps

// Logic for VGA controller
module vga_controller(
    input clk,
	input clk_blink,
	input rst,
	input arst, // Reset button (async reset)

    // Game inputs
	input [9:0] player_x,
	input [9:0] player_y,
	input laser_active,
	input [9:0] laser_x,
	input [9:0] laser_y,
	input [54:0] invaders,
    input [9:0] invaders_x,
	input [9:0] invaders_y,
	input [9:0] m1_x,
	input [9:0] m1_y,
    input [9:0] m2_x,
	input [9:0] m2_y,
    input [9:0] m3_x,
	input [9:0] m3_y,
	
    output hsync, // Horizontal sync
	output vsync, // Vertical sync
	output frame, // Signals start of blanking interval
	output reg [7:0] vga_out, // 8-bit color pixel
	output reg [1:0] player_collision, // Non-zero if player and missile collided
	output reg [5:0] invader_collision // Non-zero if invader and laser collided
	);
	
   `include "../util/constants.v"
	
	wire data_enable;
	
	// Current x and y positions of pixel being drawn
	wire integer x, y;
	
	// Sprite start signals
	reg start_player;
    reg [INVADERS_V-1:0] start_invaders;
    reg [INVADERS_V-1:0] current_invader;
	reg [1:0] cnt_blink;
	reg player_blink;
	
	// Sprite draw signals
	wire player_draw;
	wire [$clog2(INVADERS_H):0] invader_draw;
	reg laser_draw;
    reg m1_draw, m2_draw, m3_draw;
    reg invader_x, invader_y;
    reg [INVADERS_H-1:0] invader_row;
	
	vga_timings _vga_timings (
		.clk,
		.rst,
		.hsync,
		.vsync,
		.data_enable,
		.frame,
		.ux(x),
		.uy(y)
	);
	
	draw_sprite draw_player (
		.clk,
		.rst,
		.start(start_player),
		.sprite(PLAYER),
		.spr_x(player_x),
		.pixel_x(x),
		.spr_draw(player_draw)
	);
    
   draw_sprite_row draw_invaders (
		.clk,
		.rst,
		.start(start_invaders != 0),
		.sprite(INVADER1),
		.spr_x(invaders_x),
		.pixel_x(x),
		.sprites(invader_row),
		.spr_draw(invader_draw)
   ); 
    
	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			vga_out <= 0;
			player_collision <= 0;
			invader_collision <= 0;
			start_player <= 0;
			start_invaders <= 0;
			laser_draw <= 0;
			current_invader <= 0;
			player_blink <= 0;
			cnt_blink <= 3;
		end
		else if (data_enable) begin		
			// Projectile drawing signals
			laser_draw <= (laser_active && x >= laser_x && x <= laser_x + PROJ_WIDTH_SCALED 
								&& y >= laser_y && y <= laser_y + PROJ_HEIGHT_SCALED);
            
			m1_draw <= (x >= m1_x && x <= m1_x + PROJ_WIDTH_SCALED
							&& y >= m1_y && y <= m1_y + PROJ_HEIGHT_SCALED);
			m2_draw <= (x >= m2_x && x <= m2_x + PROJ_WIDTH_SCALED
						  && y >= m2_y && y <= m2_y + PROJ_HEIGHT_SCALED);
			m3_draw <= (x >= m3_x && x <= m3_x + PROJ_WIDTH_SCALED
							&& y >= m3_y && y <= m3_y + PROJ_HEIGHT_SCALED);
			
			// Player drawing signal
			// Blinks 3 times when hit by missile
			if (player_blink)
				start_player <= 0;
			else
				start_player <= (x == player_x && y == player_y - 1);
				
			if (player_collision != 0) begin
				player_blink <= 1;
				cnt_blink <= 0;
			end
			else begin
				if (clk_blink && cnt_blink < 3) begin
					player_blink <= ~player_blink;
					
					if (player_blink)
						cnt_blink <= cnt_blink + 1;
				end
				else if (cnt_blink == 3)
					player_blink <= 0;
			end
         
			// Invaders drawing signal
			if (x == invaders_x) begin
				 if (y == invaders_y) begin
					  start_invaders <= 1;
					  current_invader <= 1;
					  invader_row <= invaders[INVADERS_H-1:0];
				 end
				 else if (y == invaders_y + (INVADERS_OFFSET_V * 1)) begin
					  start_invaders <= 2;
					  current_invader <= 2;
					  invader_row <= invaders[(INVADERS_H * 2)-1:INVADERS_H];
				 end
				 else if (y == invaders_y + (INVADERS_OFFSET_V * 2)) begin
					  start_invaders <= 3;
					  current_invader <= 3;
					  invader_row <= invaders[(INVADERS_H * 3)-1:(INVADERS_H * 2)];
				 end
				 else if (y == invaders_y + (INVADERS_OFFSET_V * 3)) begin
					  start_invaders <= 4;
					  current_invader <= 4;
					  invader_row <= invaders[(INVADERS_H * 4)-1:(INVADERS_H * 3)];
				 end
				 else if (y == invaders_y + (INVADERS_OFFSET_V * 4)) begin
					  start_invaders <= 5;
					  current_invader <= 5;
					  invader_row <= invaders[(INVADERS_H * 5)-1:(INVADERS_H * 4)];
				 end
				 else
					  start_invaders <= 0;
			end
			else
				 start_invaders <= 0;
				
			// Draw sprites
			if (player_draw) begin
				vga_out <= GREEN;
			end
			else if (laser_draw || m1_draw || m2_draw || m3_draw) begin
				vga_out <= WHITE;
			end
			else if (invader_draw != 0) begin
				 vga_out <= WHITE;
			end
			else begin
				vga_out <= 0;
			end
            
			// Detect collisions
			if (laser_draw && invader_draw != 0)
				invader_collision <= invader_draw + (INVADERS_H * (current_invader - 1));
			
			if (m1_draw && player_draw)
				player_collision <= 1;
			else if (m2_draw && player_draw)
				player_collision <= 2;
			else if (m3_draw && player_draw)
				player_collision <= 3;
		end
		else if (frame) begin
			// Set collision signals back to 0 for the next frame
			if (player_collision != 0)
				player_collision <= 0;
				
			if (invader_collision != 0)
				invader_collision <= 0;
		end
		else begin
			vga_out <= 0;
		end
	end
	
endmodule
