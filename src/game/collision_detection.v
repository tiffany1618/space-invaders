`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:27:49 11/15/2021 
// Design Name: 
// Module Name:    collision_detection 
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
module collision_detection(
	// Inputs
	clk,
	clk_collision,
	rst,
	obj_x, // Upper left x coord
	obj_y, // Upper left y coord
	obj_width,
	obj_height,
	proj_x,
	proj_y,
	
	// Outputs
	collision
	);
	
	input clk, clk_collision, rst;
	input obj_x, obj_y, obj_width, obj_height, proj_x, proj_y;
	
	output reg collision;

	always @(posedge clk) begin
		if (rst) begin
			
		end
		else if (clk_collision) begin
		
		end
	end

endmodule