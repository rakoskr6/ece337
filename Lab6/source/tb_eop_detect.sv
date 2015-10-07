// $Id: $
// File name:   tb_eop_detect
// Created:     10/6/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: eop detect test bench


`timescale 1ns / 100ps

module tb_eop_detect
  ();
   // Define local parameters used by the test bench
   localparam NUM_TEST_CASES 		= 4;
   localparam TEST_DELAY					= 10;
      
   
   // Declare Design Under Test (DUT) portmap signals
   reg	tb_d_plus;
   reg	tb_d_minus;
   reg	tb_eop;

   
   // Declare test bench signals
   integer tb_test_case;
   integer tb_total_fail;
   
   
   // DUT port map
  eop_detect DUT(.d_plus(tb_d_plus), .d_minus(tb_d_minus), .eop(tb_eop));
   

   // Test bench process
   initial
     begin
	tb_total_fail = 0;
	
	//case number 1
	tb_test_case = 1;
	
	// Send test input to the design
	tb_d_plus = 1'b1;
	tb_d_minus = 1'b0;
	
	// Wait for DUT to process the inputs
	#(TEST_DELAY - 1);
	
	// Check the DUT's output value
	if(tb_eop == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_test_case++;
	  end


	//case number 2
	tb_test_case++;
      
	
	// Send test input to the design
	tb_d_plus = 1'b0;
	tb_d_minus = 1'b1;
	
	// Wait for DUT to process the inputs
	#(TEST_DELAY - 1);
	
	// Check the DUT's output value
	if(tb_eop == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_test_case++;
	  end



	//case number 3
        tb_test_case++;
	
	// Send test input to the design
	tb_d_plus = 1'b0;
	tb_d_minus = 1'b0;
	
	
	// Wait for DUT to process the inputs
	#(TEST_DELAY - 1);
	
	// Check the DUT's output value
	if(tb_eop == 1'b1)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_test_case++;
	  end

	//case number 4
        tb_test_case++;
	
	// Send test input to the design
	tb_d_plus = 1'b1;
	tb_d_minus = 1'b1;
	
	// Wait for DUT to process the inputs
	#(TEST_DELAY - 1);
	
	// Check the DUT's output value
	if(tb_eop == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_test_case++;
	  end

	

	if(NUM_TEST_CASES != tb_test_case)
	  begin
	     // Didn't run the test bench through all test cases
	     $display("This test bench was not run long enough to execute all test cases. Please run this test bench for at least a total of %d ns", (NUM_TEST_CASES * TEST_DELAY));
	  end
	else
	  begin
	     // Test bench was run to completion
	     $display("This test bench has run to completion");
	     $display("Passed %d/%d testcases",tb_test_case,tb_test_case);
	     
	  end

     end // initial begin
endmodule // tb_eop_detect
