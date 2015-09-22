// $Id: $
// File name:   tb_rcv_block-starter.sv
// Created:     2/5/2013
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: starter top level test bench provided for Lab 5

// THINGS I ADDED TO TEMPLATE TEST BENCH
		//
		// Changed the check_outputs task to properly report on failures and successes (the template incorrectly reports on anything in which we compare an expected value to its corresponding DUT value)
		// Also added a check for overrun error flag clearing after data_read assertion in the check_outputs task
		// GENERAL TEST PROCEDURE:
		//	Run through various permutations of period times for 3 data packets twice. 
		//	The first time, just test normal operation (stop bit = 1 and data always read). 
		//	The second time, vary stop bit to produce error conditions.

`timescale 1ns / 10ps

module tb_rcv_block();

	// Define parameters
	parameter CLK_PERIOD				= 2.5;
	parameter NORM_DATA_PERIOD	= (10 * CLK_PERIOD);
	
	localparam OUTPUT_CHECK_DELAY = (CLK_PERIOD - 0.2);
	localparam WORST_FAST_DATA_PERIOD = (NORM_DATA_PERIOD * 0.96);
	localparam WORST_SLOW_DATA_PERIOD = (NORM_DATA_PERIOD * 1.04);
	integer data_rates[0:2] = '{WORST_FAST_DATA_PERIOD, NORM_DATA_PERIOD, WORST_SLOW_DATA_PERIOD};
	
	//  DUT inputs
	reg tb_clk;
	reg tb_n_rst;
	reg tb_serial_in;
	reg tb_data_read;
	
	// DUT outputs
	wire [7:0] tb_rx_data;
	wire tb_data_ready;
	wire tb_overrun_error;
	wire tb_framing_error;
	
	// Test bench debug signals
	// Overall test case number for reference
	integer tb_test_case;
	// Test case 'inputs' used for test stimulus
	reg [7:0] tb_test_data;
	reg 			tb_test_stop_bit;
	time 			tb_test_bit_period;
	reg				tb_test_data_read;
	// Test case expected output values for the test case
	reg [7:0] tb_expected_rx_data;
	reg 			tb_expected_framing_error;
	reg 			tb_expected_data_ready;
	reg 			tb_expected_overrun;
	integer i;
	integer j;
	integer k;
	integer index;
	
	// DUT portmap
	rcv_block DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.serial_in(tb_serial_in),
		.data_read(tb_data_read),
		.rx_data(tb_rx_data),
		.data_ready(tb_data_ready),
		.overrun_error(tb_overrun_error),
		.framing_error(tb_framing_error)
	);
	
	// Tasks for regulating the timing of input stimulus to the design
	task send_packet;
		input  [7:0] data;
		input  stop_bit;
		input  time data_period;
		
		integer i;
	begin
		// First synchronize to away from clock's rising edge
		@(negedge tb_clk)
		
		// Send start bit
		tb_serial_in = 1'b0;
		#data_period;
		
		// Send data bits
		for(i = 0; i < 8; i = i + 1)
		begin
			tb_serial_in = data[i];
			#data_period;
		end
		
		// Send stop bit
		tb_serial_in = stop_bit;
		#data_period;
	end
	endtask
	
	task reset_dut;
	begin
		// Activate the design's reset (does not need to be synchronize with clock)
		tb_n_rst = 1'b0;
		
		// Wait for a couple clock cycles
		@(posedge tb_clk);
		@(posedge tb_clk);
		
		// Release the reset
		@(negedge tb_clk);
		tb_n_rst = 1;
		
		// Wait for a while before activating the design
		@(posedge tb_clk);
		@(posedge tb_clk);
	end
	endtask
	
	task check_outputs;
		input [7:0] expected_rx_data;
		input expected_data_ready;
		input expected_framing_error;
		input expected_overrun;
		input assert_data_read;
	begin
		// Don't need to syncrhonize relative to clock edge for this design's outputs since they should have been stable for quite a while given the 2 Data Period gap between the end of the packet and when this should be used to check the outputs
		
		// Data recieved should match the data sent
		assert(expected_rx_data == tb_rx_data)
			$info("Test case %0d: Test data correctly received", tb_test_case);
		else
			$error("Test case %0d: Test data was incorrectly received", tb_test_case);
			
		// If and only if a proper stop bit is sent ('1') there shouldn't be a framing error.
		assert(expected_framing_error == tb_framing_error)
			$info("Test case %0d: DUT correctly asserts/clears framing error", tb_test_case);
		else
			$error("Test case %0d: DUT incorrectly asserts/clears framing error", tb_test_case);
		
		// If and only if a proper stop bit is sent ('1') should there be 'data ready'
		assert(expected_data_ready == tb_data_ready)
			$info("Test case %0d: DUT correctly asserts/clears data ready flag", tb_test_case);
		else
			$error("Test case %0d: DUT incorrectly asserts/clears the data ready flag", tb_test_case);
			
		// Check for the proper overrun error state for this test case
		if(1'b0 == expected_overrun)
		begin
			assert(expected_overrun == tb_overrun_error)
				$info("Test case %0d: DUT correctly shows no overrun error", tb_test_case);
			else
				$error("Test case %0d: DUT incorrectly shows an overrun error", tb_test_case);
		end
		else
		begin
			assert(1'b1 == tb_overrun_error)
				$info("Test case %0d: DUT correctly shows an overrun error", tb_test_case);
			else
				$error("Test case %0d: DUT incorrectly shows no overrun error", tb_test_case);
		end
		
		// Handle the case of the test case asserting the data read signal
		if(1'b1 == assert_data_read)
		begin
			// Test case is supposed to have data read asserted -> check for proper handling
			// Should synchronize away from rising edge of clock for asserting this input.
			@(negedge tb_clk);
			
			// Activate the data read input 
			tb_data_read <= 1'b1;
			
			// Wait a clock cycle before checking for the flag to clear
			@(negedge tb_clk);
			tb_data_read <= 1'b0;
			
			// Check to see if the data ready flag cleared
			assert(1'b0 == tb_data_ready)
				$info("Test case %0d: DUT correctly cleared the data ready flag", tb_test_case);
			else
				$error("Test case %0d: DUT did not correctly clear the data ready flag", tb_test_case);
			// ADDED BY MYSELF
			// Check to see if the overrun error flag cleared
			assert(1'b0 == tb_overrun_error)
				$info("Test case %0d: DUT correctly cleared the overrun error flag", tb_test_case);
			else
				$error("Test case %0d: DUT did not correctly clear the overrun error flag", tb_test_case);
		end
	end
	endtask
	
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2);
	end

	// Actual test bench process
	initial
	begin : TEST_PROC
		// Initilize all inputs to inactive/idle values
		i = 0;
		j = 0;
		k = 0;
		tb_n_rst			= 1'b1; // Initially inactive
		tb_serial_in	= 1'b1; // Initially idle
		tb_data_read	= 1'b0; // Initially inactive
		
		// Get away from Time = 0
		#0.1; 
		
		// Test case 0: Basic Power on Reset
		tb_test_case = 0;
		
		// Power-on Reset Test case: Simply populate the expected outputs
		// These values don't matter since it's a reset test but really should be set to 'idle'/inactive values
		tb_test_data 				= '1;
		tb_test_stop_bit		= 1'b1;
		tb_test_bit_period	= NORM_DATA_PERIOD;
		tb_test_data_read		= 1'b0;
		
		// Define expected ouputs for this test case
		// Note: expected outputs should all be inactive/idle values
		// For a good packet RX Data value should match data sent
		tb_expected_rx_data 			= '1;
		// Valid stop bit ('1') -> Valid data -> Active data ready output
		tb_expected_data_ready		= 1'b0; 
		// Framing error if and only if bad stop_bit ('0') was sent
		tb_expected_framing_error = 1'b0;
		// Not intentionally creating an overrun condition -> overrun should be 0
		tb_expected_overrun				= 1'b0;
		
		// DUT Reset
		reset_dut;
		
		// Check outputs
		check_outputs(tb_expected_rx_data, tb_expected_data_ready, tb_expected_framing_error, tb_expected_overrun, tb_test_data_read);
		tb_test_data 				= 8'b00000001;

		for (i = 0; i < 2; i = i + 1) begin
			for (j = 0; j < 3; j = j + 1) begin
				// DUT Reset
				reset_dut;
				for (k = 0; k < 3; k = k + 1) begin
					@(negedge tb_clk);
					tb_test_case += 1;
					index = (j + k) % 3;
					if (tb_test_data == '0) begin // simple data and shift to verify data is actually shifted correctly
						tb_test_data = 8'b00000001;
					end
					else begin
						tb_test_data = tb_test_data << 1;
					end
					tb_test_bit_period	= data_rates[index];
					if (i == 0) begin //Normal operation (1st of 3 packets)
						tb_test_stop_bit		= 1'b1;
						tb_test_data_read	= 1'b1;
						// Setup packet info for debugging/verificaton signals
		
						// Define expected ouputs for this test case
						// For a good packet RX Data value should match data sent
						tb_expected_rx_data 			= tb_test_data;
						// Valid stop bit ('1') -> Valid data -> Active data ready output
						tb_expected_data_ready		= tb_test_stop_bit; 
						// Framing error if and only if bad stop_bit ('0') was sent
						tb_expected_framing_error = ~tb_test_stop_bit;
						// Not intentionally creating an overrun condition -> overrun should be 0
						tb_expected_overrun				= 1'b0;
					end
					else begin //Error condition tests (1 of 3 data packets - normal operation (stop bit and read)...produces overflow if not 1st in sequence of 9)
						tb_test_stop_bit		= 1'b1;
						tb_test_data_read	= 1'b1;
						// Setup packet info for debugging/verificaton signals
		
		
						// Define expected ouputs for this test case
						// For a good packet RX Data value should match data sent
						tb_expected_rx_data 			= tb_test_data;
						// Valid stop bit ('1') -> Valid data -> Active data ready output
						tb_expected_data_ready		= tb_test_stop_bit; 
						// Framing error if and only if bad stop_bit ('0') was sent
						tb_expected_framing_error = ~tb_test_stop_bit;
						// Not intentionally creating an overrun condition -> overrun should be 0
						if (k == 0) begin //1st test of 9 is after reset so no data comes before
							tb_expected_overrun				= 1'b0;
						end
						else begin
							tb_expected_overrun				= 1'b1;
						end
					end						
		
					// Send packet
					send_packet(tb_test_data, tb_test_stop_bit, tb_test_bit_period);
		
					// Wait for 2 data periods to allow DUT to finish processing the packet
					#(tb_test_bit_period * 2);
		
					// Check outputs
					check_outputs(tb_expected_rx_data, tb_expected_data_ready, tb_expected_framing_error, tb_expected_overrun, tb_test_data_read);
						
					tb_serial_in	= 1'b1;
					#(2*CLK_PERIOD);
					@(negedge tb_clk);
					tb_test_case += 1;
					index = (index + k) % 3;
					if (i == 0) begin
						if (tb_test_data == '0) begin
							tb_test_data = 8'b00000001;
						end
						else begin
							tb_test_data = tb_test_data << 1;
						end
					end
					tb_test_bit_period	= data_rates[(k+j) % 3];
					if (i == 0) begin //Normal operation (2nd of 3 packets)
						tb_test_stop_bit		= 1'b1;
						tb_test_data_read	= 1'b1;
						// Setup packet info for debugging/verificaton signals
		
		
						// Define expected ouputs for this test case
						// For a good packet RX Data value should match data sent
						tb_expected_rx_data 			= tb_test_data;
						// Valid stop bit ('1') -> Valid data -> Active data ready output
						tb_expected_data_ready		= tb_test_stop_bit; 
						// Framing error if and only if bad stop_bit ('0') was sent
						tb_expected_framing_error = ~tb_test_stop_bit;
						// Not intentionally creating an overrun condition -> overrun should be 0
						tb_expected_overrun				= 1'b0;
		
					end
					else begin //Error condition tests (2nd of 3 data packets - stop bit = 0, no read (tests packet throwaway))
						tb_test_stop_bit		= 1'b0;
						tb_test_data_read	= 1'b0;
						// Setup packet info for debugging/verificaton signals
		
		
						// Define expected ouputs for this test case
						// For a good packet RX Data value should match data sent
						tb_expected_rx_data 			= tb_test_data;
						// Valid stop bit ('1') -> Valid data -> Active data ready output
						tb_expected_data_ready		= tb_test_stop_bit; 
						// Framing error if and only if bad stop_bit ('0') was sent
						tb_expected_framing_error = ~tb_test_stop_bit;
						// Not intentionally creating an overrun condition -> overrun should be 0
						tb_expected_overrun				= 1'b0;

					end						
		
					// Send packet
					send_packet(tb_test_data, tb_test_stop_bit, tb_test_bit_period);
		
					// Wait for 2 data periods to allow DUT to finish processing the packet
					#(tb_test_bit_period * 2);
		
					// Check outputs
					check_outputs(tb_expected_rx_data, tb_expected_data_ready, tb_expected_framing_error, tb_expected_overrun, tb_test_data_read);
						
					tb_serial_in	= 1'b1;
					#(2*CLK_PERIOD);
					@(negedge tb_clk);
					tb_test_case += 1;
					index = (index + k) % 3;
					if (!(i == 1 && k == 2)) begin
						if (tb_test_data == '0) begin
							tb_test_data = 8'b00000001;
						end
						else begin
							tb_test_data = tb_test_data << 1;
						end
					end
					tb_test_bit_period	= data_rates[k];
					if (i == 0) begin //Normal operation (3rd of 3 packets)
						tb_test_stop_bit		= 1'b1;
						tb_test_data_read	= 1'b1;
						// Setup packet info for debugging/verificaton signals
		
		
						// Define expected ouputs for this test case
						// For a good packet RX Data value should match data sent
						tb_expected_rx_data 			= tb_test_data;
						// Valid stop bit ('1') -> Valid data -> Active data ready output
						tb_expected_data_ready		= tb_test_stop_bit; 
						// Framing error if and only if bad stop_bit ('0') was sent
						tb_expected_framing_error = ~tb_test_stop_bit;
						// Not intentionally creating an overrun condition -> overrun should be 0
						tb_expected_overrun				= 1'b0;
		
						
					end
					else begin //Error condition tests (3rd of 3 data packets - stop bit = 1, no read (tests overflow in next iteration of loop))
						if (k == 2) begin //if last iteration, keep stop bit = 0, to test multiple bad packets in a back-to-back
							tb_test_stop_bit		= 1'b0; 
						end
						else begin
							tb_test_stop_bit		= 1'b1;
						end
						tb_test_data_read	= 1'b0;
						// Setup packet info for debugging/verificaton signals
		
		
						// Define expected ouputs for this test case
						// For a good packet RX Data value should match data sent
						tb_expected_rx_data 			= tb_test_data;
						// Valid stop bit ('1') -> Valid data -> Active data ready output
						tb_expected_data_ready		= tb_test_stop_bit; 
						// Framing error if and only if bad stop_bit ('0') was sent
						tb_expected_framing_error = ~tb_test_stop_bit;
						// Not intentionally creating an overrun condition -> overrun should be 0
						tb_expected_overrun				= 1'b0;

					end						
		
					// Send packet
					send_packet(tb_test_data, tb_test_stop_bit, tb_test_bit_period);
		
					// Wait for 2 data periods to allow DUT to finish processing the packet
					#(tb_test_bit_period * 2);
		
					// Check outputs
					check_outputs(tb_expected_rx_data, tb_expected_data_ready, tb_expected_framing_error, tb_expected_overrun, tb_test_data_read);
						
					tb_serial_in	= 1'b1;
					#(2*CLK_PERIOD);
				end			
			end
		end
	end

endmodule

