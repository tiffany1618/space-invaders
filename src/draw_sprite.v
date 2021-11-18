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
	spr_file,
	spr_width,
	spr_height,
	spr_scale,
	spr_color,
	
	// Outputs
	pixel
	);
	
	input clk, rst;
	input string spr_file;
	input [9:0] spr_width, spr_height;
	input [7:0] spr_scale, spr_color;
	output [7:0] pixel;
	
	// States
	localparam IDLE = 0; // Awaiting start signal
	localparam START = 1; // Prepare for new sprite drawing
	localparam AWAIT_POS = 2; // Await horizontal position
	localparam DRAW = 3; // Draw pixel
	localparam NEXT_LINE = 4; // Prepare for next sprie line
	
	reg [3:0] state, next_state;
	reg [(spr_width * spr_height)-1:0] memory;
	reg [$clog2(spr_width * spr_height)-1:0] spr_addr;  // Pixel position
	reg [$clog2(spr_width)-1:0] x;
	reg [$clog2(spr_height)-1:0] y;
	reg [$clog2(spr_scale)-1:0] counter_x, counter_y;
	
	initial begin
		$readmemb(spr_file, memory);
	end
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state <= IDLE;
			x <= 0;
			y <= 0;
			counter_y <= 0;
			counter_x <= 0;
			spr_addr <= 0;
		end
		else begin
			state <= next_state;
			
			case (state)
				START: begin
					y <= 0;
					counter_y <= 0;
					spr_addr <= 0;
				end
				AWAIT_POS: begin
					x <= 0;
					counter_x <= 0;
				end
				DRAW: begin
					if (spr_scale <= 1 || counter_x  == spr_scale - 1) begin
						x <= x + 1;
						counter_x <= 0;
						spr_addr <= spr_addr + 1;
					end
					else
						counter_x <= counter_x + 1;
				end
				NEXT_LINE: begin
					if (spr_scale <= 1 || counter_y == spr_scale - 1) begin
						y <= y + 1;
						counter_y <= 0;
					end
					else begin
						counter_y <= counter_y + 1;
						spr_addr <= spr_addr - spr_width; // Restart line
					end
				end
			endcase
		end
		
		if (state == DRAW && memory[spr_addr])
			pixel <= spr_color;
		else
			pixel <= 0;
	end
	
	always @* begin
		case (state)
			IDLE: state_next = start ? START : IDLE;
         START: state_next = AWAIT_POS;
         AWAIT_POS: state_next = (sx == sprx-1) ? DRAW : AWAIT_POS;
         DRAW: state_next = !(x == spr_width - 1 && counter_x == spr_scale - 1) 
				? DRAW :(!(y == spr_height - 1 && counter_y == spr_scale - 1) ? NEXT_LINE : IDLE);
         NEXT_LINE:  state_next = AWAIT_POS;
         default: state_next = IDLE;
		endcase
	end

endmodule
