`timescale 1ns / 1ps

module tb;

	// Inputs
	reg clk;
	reg rst;
	reg btn_right;
	reg btn_left;
	reg btn_shoot;
	reg btn_rst;

	// Outputs
	wire [3:0] an_lives;
	wire [6:0] seg_lives;
	wire an_score;
	wire [6:0] seg_score;
	wire [7:0] vga_color;
	wire hsync;
	wire vsync;

	// Instantiate the Unit Under Test (UUT)
	space_invaders uut (
		.clk(clk), 
		.rst(rst), 
		.btn_right(btn_right), 
		.btn_left(btn_left), 
		.btn_shoot(btn_shoot), 
		.btn_rst(btn_rst), 
		.an_lives(an_lives), 
		.seg_lives(seg_lives), 
		.an_score(an_score), 
		.seg_score(seg_score), 
		.vga_color(vga_color), 
		.hsync(hsync), 
		.vsync(vsync)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		btn_right = 0;
		btn_left = 0;
		btn_shoot = 0;
		btn_rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		#1000;
		rst = 0;
        
		// Add stimulus here
		
	end
	
	// 100 MHz clk
	always #5 clk = ~clk;
      
endmodule

