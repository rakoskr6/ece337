// 337 student modified  Lab 2 Testbet
// This code serves as a test bench for the 16 bit adder design 

`timescale 1ns / 100ps

module tb_adder_16bit
();
	// Define local parameters used by the test bench
	localparam NUM_INPUT_BITS			= 16;
	localparam NUM_OUTPUT_BITS		= NUM_INPUT_BITS + 1;
	localparam MAX_OUTPUT_BIT			= NUM_OUTPUT_BITS - 1;
	localparam NUM_TEST_BITS 			= (NUM_INPUT_BITS * 2) + 1;
	localparam MAX_TEST_BIT				= NUM_TEST_BITS - 1;
	localparam NUM_TEST_CASES 		= 2 ** NUM_TEST_BITS;
	localparam MAX_TEST_VALUE 		= NUM_TEST_CASES - 1;
	localparam TEST_A_BIT					= NUM_INPUT_BITS - 1;
	localparam TEST_B_BIT					= NUM_INPUT_BITS;
	localparam TEST_CARRY_IN_BIT	= MAX_TEST_BIT;
	localparam TEST_SUM_BIT				= NUM_INPUT_BITS - 1;
	localparam TEST_CARRY_OUT_BIT	= MAX_OUTPUT_BIT;
	localparam TEST_DELAY					= 10;
	
	// Declare Design Under Test (DUT) portmap signals
	wire	[15:0]tb_a;
	wire	[15:0]tb_b;
	wire	tb_carry_in;
	wire	[15:0]tb_sum;
	wire	tb_carry_out;
	
	// Declare test bench signals
	integer tb_test_case;
	reg [MAX_TEST_BIT:0] tb_test_inputs;
	reg [MAX_OUTPUT_BIT:0] tb_expected_outputs;
   reg 			       no_match;
   
	
	// DUT port map
	adder_16bit DUT(.a(tb_a), .b(tb_b), .carry_in(tb_carry_in), .sum(tb_sum), .overflow(tb_carry_out));
	
	// Connect individual test input bits to a vector for easier testing
	assign tb_a					= tb_test_inputs[TEST_A_BIT:0];
	assign tb_b					= tb_test_inputs[MAX_TEST_BIT:TEST_B_BIT]; 
	assign tb_carry_in	= tb_test_inputs[TEST_CARRY_IN_BIT];
	
	// Test bench process
	initial
	begin
		// Initialize test inputs for DUT
		tb_test_inputs = 33'h000000000;

	       //modified test bench
	   for (tb_test_case=0; tb_test_case<=4; tb_test_case++)
	     begin
		if (tb_test_case==0)
		tb_test_inputs = 33'h000000000;
		else if (tb_test_case==1)
		  tb_test_inputs = 33'h00FFF000F;
		else if (tb_test_case==2)
		  tb_test_inputs = 33'h0000F0FFF;
		else if (tb_test_case==3)
		  tb_test_inputs = 33'hFFFFFFFFF;
		else if (tb_test_case==4)
		  tb_test_inputs = 33'h0000A000A;
		else
		  tb_test_inputs = 33'h000000000;
		
		
		#1;
		tb_expected_outputs = tb_a + tb_b +tb_carry_in;
		#(TEST_DELAY - 1);
		
		// Check the DUT's Sum output value
		assert(tb_expected_outputs[TEST_SUM_BIT:0] == tb_sum)
		  $info("Correct value for test case %d",tb_test_case);
		else
		     $error("Incorrect Sum value for test case %d!", tb_test_case);

		// Check the DUT's Sum output value
		assert(tb_expected_outputs[TEST_SUM_BIT:0] == tb_sum)
		  no_match = 1'b0;
		else
		  no_match = 1'b1;
		
		// Check the DUT's Carry Out output value
		assert(tb_expected_outputs[TEST_CARRY_OUT_BIT] == tb_carry_out)
		  $info("Correct value for carry out %d",tb_test_case);
		else
		     $error("Incorrect Carry Out value for test case %d!", tb_test_case);
	     end // for (tb_test_case=0; tb_test_case<4; tb_test_case++)
	   
	   
        
	end
	
	// Wrap-up process
	final
	begin
		if(NUM_TEST_CASES != tb_test_case)
		begin
			// Didn't run the test bench through all test cases
			$display("This test bench was not run long enough to execute all test cases. Please run this test bench for at least a total of %d ns", (NUM_TEST_CASES * TEST_DELAY));
		end
		else
		begin
			// Test bench was run to completion
			$display("This test bench has run to completion");
		end
	end
endmodule
