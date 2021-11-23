`timescale 1ns / 1ps

// Divides clk signal into clk_out signal that is high for one clk cycle at the desired freq
module clk_divider(
	input clk, // 100 MHz
	input rst, // Reset
	input [26:0] freq, // Hz
	
	output reg clk_out
	);
	
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
