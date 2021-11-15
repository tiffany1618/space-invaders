`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:27 11/15/2021 
// Design Name: 
// Module Name:    clk_divider 
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
module clk_divider(
	// Inputs
	clk, // 100 MHz
	rst,
	freq, // Hz
	
	// Outputs
	clk_out
	);
	
	input clk, rst;
	input [25:0] freq;
	output reg clk_out;
	
   reg [25:0] counter;
   reg [25:0] max;
    
	always @(posedge clk) begin
		if (rst) begin
			clk_out <= 0;
			counter <= 26'b0;
			max <= 100_000_000 / freq;
		end
		else begin
			if (clk_out)
				clk_out <= ~clk_out;
			
			if (counter == max) begin
				counter <= 0;
				clk_out <= 1;
			end
			else
				counter <= counter + 1;
		end
	end
	 
endmodule
