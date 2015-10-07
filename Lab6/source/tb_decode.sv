// $Id: $
// File name:   tb_decode.sv
// Created:     10/6/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: decode test bench



`timescale 1ns / 100ps

module tb_decode
  ();
   // Define local parameters used by the test bench
   localparam NUM_TEST_CASES 		= 20;
   localparam TEST_DELAY					= 2;
   localparam CLK_PERIOD		= 4.16ns;
      
   
   // Declare Design Under Test (DUT) portmap signals
   reg tb_clk;
   reg tb_n_rst;
   reg tb_d_plus;
   reg	tb_d_orig;

   reg 	tb_shift_enable;
   reg 	tb_eop;
 	
   
   // Declare test bench signals
   integer tb_test_case;
   integer tb_total_fail;


   
   // Clock gen block
   always
     begin : CLK_GEN
	tb_clk = 1'b0;
	#(CLK_PERIOD / 2.0);
	tb_clk = 1'b1;
	#(CLK_PERIOD / 2.0);
     end
   
   // DUT port map
   decode DUT(.clk(tb_clk), .n_rst(tb_n_rst), .d_plus(tb_d_plus), .shift_enable(tb_shift_enable), .eop(tb_eop), .d_orig(tb_d_orig));
        
 
   
   // Test bench process
   initial
     begin
	tb_total_fail = 0;
	
	//case number 1
	tb_test_case = 1;
	
	// Send test input to the design

	tb_d_plus = 1'b1;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;
	

	// Check the DUT's output value
	@(posedge tb_clk);
	@(posedge tb_clk);
	#(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	     
	  end


	//case number 2
	tb_test_case++;
      
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b1)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end



	//case number 3
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	      tb_total_fail++;
	  end

	//case number 4
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b1;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b1)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end


	//case number 5
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b1;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	      tb_total_fail++;
	  end


	//case number 6
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b1;
	tb_n_rst = 0;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end


	//case number 7
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b1;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end

	
	//case number 8
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 0;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end


	//case number 9
       
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;
	
	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b1)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	      tb_total_fail++;
	  end


	//case number 10
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;
	
	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end




















	
	//case number 11
	tb_test_case++;
	
	// Send test input to the design

	tb_d_plus = 1'b1;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b1;
	

	// Check the DUT's output value
	@(posedge tb_clk);
	@(posedge tb_clk);
	#(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	     
	  end


	//case number 12
	tb_test_case++;
      
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b1;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end



	//case number 13
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 1;
	tb_shift_enable = 1'b0;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	      tb_total_fail++;
	  end

	//case number 14
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b1;
	tb_n_rst = 1;
	tb_shift_enable = 1'b0;
  	tb_eop = 1'b1;

	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end


	//case number 15
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b1;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b1;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	      tb_total_fail++;
	  end


	//case number 16
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b1;
	tb_n_rst = 0;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end


	//case number 17
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b1;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end

	
	//case number 18
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 0;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;

	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
	  end


	//case number 19
       
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;
	
	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b1)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	      tb_total_fail++;
	  end


	//case number 20
        tb_test_case++;
	
	// Send test input to the design
	@(negedge tb_clk); 
	tb_d_plus = 1'b0;
	tb_n_rst = 1;
	tb_shift_enable = 1'b1;
  	tb_eop = 1'b0;
	
	
	// Check the DUT's output value
	@(posedge tb_clk);
        #(TEST_DELAY - 1);
	if(tb_d_orig == 1'b0)
	  begin
	     $info("Correct output for test case %d!", tb_test_case);
	  end
	else
	  begin
	     $error("INCORRECT output for test case %d!", tb_test_case);
	     tb_total_fail++;
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
	     $display("Passed %d/%d testcases",tb_test_case-tb_total_fail,tb_test_case);
	     
	  end

     end // initial begin
endmodule // tb_eop_detect
