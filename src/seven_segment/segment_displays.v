`timescale 1ns / 1ps

// Seven-segment display controllers
module segment_displays(
	input clk,
	input clk_display, // Frequency at which to cycle through the displays
	input rst,
	input arst, // Reset button (async reset)
	input [1:0] lives,
   input [6:0] score,
	
   output reg an_score, // Anode for score displays
	output reg [3:0] an_lives, // Anode for lives displays
   output reg [6:0] seg_score,  // Cathodes for score displays
	output reg [6:0] seg_lives // Cathodes for lives displays
   );
	 
	reg [3:0] digit;
    reg counter;
	
	always @(posedge clk or posedge rst or posedge arst) begin
		if (rst || arst) begin
			counter <= 0;
			an_lives <= 4'b1110; // Only using 1 of 4 displays
         an_score <= 0;
		end
		else if (clk_display) begin
			dig_to_seg(lives, seg_lives);
			
            // Cycle through the two displays for score
			counter <= counter + 1;
			case(counter)
				0: begin
					an_score <= 0;
					inverted_dig_to_seg(score / 10, seg_score);
				end
				1: begin
					an_score <= 1;
					inverted_dig_to_seg(score % 10, seg_score);
				end
			endcase
		end
	end
	
    // Segment output for active low display
	task dig_to_seg;
		input [3:0] dig;
		output reg [6:0] seg;
		
		begin
			case(dig)
				0: seg <= 7'b1000000;
				1: seg <= 7'b1111001;
				2: seg <= 7'b0100100;
				3: seg <= 7'b0110000;
				4: seg <= 7'b0011001;
				5: seg <= 7'b0010010;
				6: seg <= 7'b0000010;
				7: seg <= 7'b1111000;
				8: seg <= 7'b0000000;
				9: seg <= 7'b0010000;
				default: seg <= 7'b1111111;
			endcase
		end
    endtask
	
    // Segment output for active high display
    task inverted_dig_to_seg;
        input [3:0] dig;
		output reg [6:0] seg;
		
		begin
		    case(dig)
				0: seg <= 7'b0111111;
				1: seg <= 7'b0110000;
				2: seg <= 7'b1011011;
				3: seg <= 7'b1111001;
				4: seg <= 7'b1110100;
				5: seg <= 7'b1101101;
				6: seg <= 7'b1101111;
				7: seg <= 7'b0111000;
				8: seg <= 7'b1111111;
				9: seg <= 7'b1111101;
				default: seg <= 7'b0000000;
			endcase
		end
    endtask

endmodule
