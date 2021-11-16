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
	input [26:0] freq;
	output reg clk_out;
	
   reg [26:0] counter;
   reg [26:0] max;
    
	always @(posedge clk) begin
		if (rst) begin
			clk_out <= 0;
			counter <= 27'b0;
			max <= 100_000_000 / freq - 1;
		end
		else begin
			clk_out <= (counter == max);
			
			if (clk_out)
				counter <= 1;
			else
				counter <= counter + 1;			
		end
	end
	 
endmodule
