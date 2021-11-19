`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:21:54 11/15/2021 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer(
	// Inputs
	clk,
	clk_debouncer,
	rst,
	btn_shoot,
	btn_left,
	btn_right,
	btn_rst,
	
	// Outputs
	shoot,
	left,
	right,
	arst
   );

	input clk, clk_debouncer, rst, btn_shoot, btn_left, btn_right, btn_rst;
	output reg shoot, left, right, arst;

	reg [2:0] step_shoot, step_left, step_right, step_arst;

	always @ (posedge clk) begin
		if (rst) begin
			shoot <= 0;
			left <= 0;
			right <= 0;
			arst <= 0;
			step_shoot <= 3'b0;
			step_left <= 3'b0;
			step_right <= 3'b0;
			step_arst <= 3'b0;
		end

		else if (clk_debouncer) begin
			// Update our three samples for each button
			step_shoot <= {btn_shoot, step_shoot[2:1]}; 
			step_left <= {btn_left, step_left[2:1]};
			step_right <= {btn_right, step_right[2:1]};
			step_arst <= {btn_rst, step_arst[2:1]};

			if (step_right == 3'b110)
				right <= 1;
			else if (step_right == 3'b001)
				right <= 0;
				 
			if (step_left == 3'b110)
				left <= 1;
			else if (step_left == 3'b001)
				left <= 0;
			 
			shoot <= (step_shoot == 3'b110);
			arst <= (step_arst == 3'b110);
		end
	end		

endmodule
