`timescale 1ns / 1ps

// Debounces button signals
module debouncer(
	input clk,
	input clk_debouncer, // Sampling frequency
	input rst,

    // Button signals
	input btn_shoot,
	input btn_left,
	input btn_right,
	input btn_rst,
	
    // Debounced signals
	output reg shoot,
	output reg left,
	output reg right,
	output reg arst
    );

    // Store three samples for each button
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

            // Event occurs when each button is high and stops when each
            // button is low
			if (step_right == 3'b110)
				right <= 1;
			else if (step_right == 3'b001)
				right <= 0;
				 
			if (step_left == 3'b110)
				left <= 1;
			else if (step_left == 3'b001)
				left <= 0;
			 
            // Single event occurs for each button press
			shoot <= (step_shoot == 3'b110);
			arst <= (step_arst == 3'b110);
		end
	end		

endmodule
