// $Id: $
// File name:   tb_mealy.sv
// Created:     9/2/2013
// Author:      Kyle Rakos
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Mealy Machine 1101 detector test bench

`timescale 1ns / 10ps

module tb_mealy();

   // Define parameters
   // basic test bench parameters
   localparam	CLK_PERIOD	= 2.5;
   localparam TEST_DELAY = 10;
   
   
   // Shared Test Variables
   reg tb_clk;
   reg 	   tb_n_rst;
   reg 	   tb_i;
   reg 	   tb_o;
   
   // Clock generation block
   always
     begin
	tb_clk = 1'b0;
	#(CLK_PERIOD/2.0);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2.0);
     end
   
   // Default Config Test Variables & constants


  mealy DUT
    (
     .clk(tb_clk),
     .n_rst(tb_n_rst),
     .i(tb_i),
     .o(tb_o)
     );
 
   
   integer tb_test_num;

   

   clocking cb @(posedge tb_clk);
      // 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
      default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
      output 	   #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
      output 	   i = tb_i;
      input        o = tb_o;
 	   
   endclocking // cb
   

   // Default Configuration Test bench main process
   initial
     begin
	// Initialize all of the test inputs
	tb_n_rst		= 1'b1;				// Initialize to be inactive
	// Initialize idle values
	tb_i = 0;
		
	tb_test_num 		= 0;
	
	// Power-on Reset of the DUT
	// Assume we start at positive edge. Immediately assert reset at first negative edge
	// without using clocking block in order to avoid metastable value warnings
	@(negedge tb_clk);
	tb_n_rst	<= 1'b0; 	// Need to actually toggle this in order for it to actually run dependent always blocks
	@cb;
	cb.n_rst	<= 1'b1; 	// Deactivate the chip reset
	
	// Wait for a while to see normal operation
	@cb;
	
	// Test 1: Check for Proper Reset 
	tb_test_num = tb_test_num + 1;
	
	cb.n_rst	<= 1'b0;
	cb.i <= 1'b0;
	
	// Wait two cycles, long enough for the reset to get to the DUT, and to receive
	// the response back
	@cb;
	@cb;
	// Check that the rollover_flag and count_out is 0
	if (cb.o == 1'b0)
	  $info("Test Case %0d:: PASSED", tb_test_num);
	else // Test case failed
	  $error("Test Case %0d:: FAILED", tb_test_num);

	// Test 2: Check pattern
	cb.n_rst <= 1'b1;
	@cb;
	@cb;
	
	
	cb.i <= 1'b1;
	@cb;
	
	cb.i <= 1'b1;
	@cb;
	
	cb.i <= 1'b0;
	@cb;
	
	cb.i <= 1'b1;
	@cb;
	
	tb_test_num = 2;
		
	if (cb.o == 1'b1)
	  $info("Test Case %0d:: PASSED", tb_test_num);
	else // Test case failed
	  $error("Test Case %0d:: FAILED", tb_test_num);
	
	// Test 3: Check pattern
	
	tb_test_num = 3;
	
	cb.i <= 1'b1;
	@cb;
	
	
	cb.i <= 1'b0;
	@cb;
	
	cb.i <= 1'b1;
	@cb;
		
	
	if (cb.o == 1'b1)
	  $info("Test Case %0d:: PASSED", tb_test_num);
	else // Test case failed
	  $error("Test Case %0d:: FAILED", tb_test_num);
	
	
	
	


     end // initial begin
   

endmodule // tb_mealy_DUT

