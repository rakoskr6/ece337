// $Id: $
// File name:   tb_flex_counter.sv.sv
// Created:     9/2/2013
// Author:      Kyle Rakos
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: Flexible Parallel to Serial shift register test bench

`timescale 1ns / 10ps

module tb_flex_counter ();

   // Define parameters
   // basic test bench parameters
   localparam	CLK_PERIOD	= 2.5;
   
   // Shared Test Variables
   reg tb_clk;
   
   // Clock generation block
   always
     begin
	tb_clk = 1'b0;
	#(CLK_PERIOD/2.0);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2.0);
     end
   
   // Default Config Test Variables & constants
   localparam DEFAULT_SIZE = 4;
   localparam DEFAULT_MSB = 1;

   tb_flex_counter_DUT #(.SIZE(DEFAULT_SIZE), .MSB(DEFAULT_MSB)) stp_default(.tb_clk);
   //tb_flex_counter_DUT #(.SIZE(8),            .MSB(1), .NAME("config1")) stp_config1(.tb_clk);
   //tb_flex_counter_DUT #(.SIZE(4),            .MSB(0), .NAME("config2")) stp_config2(.tb_clk);
   
endmodule // tb_flex_counter

module tb_flex_counter_DUT
  #(parameter SIZE = 4, MSB = 1, NAME = "default")
   (input wire tb_clk);
   
   localparam MAX_BIT = (SIZE - 1);
   localparam OUT_BIT = MAX_BIT*MSB; // The bit output by the shift register
   
   integer tb_test_num;
   integer tb_i;
   integer tb_fail_cnt;
   reg 	   tb_n_rst;
   reg 	   tb_clear;
   reg 	   tb_count_enable;
   reg [MAX_BIT:0] tb_rollover_val;
   reg [MAX_BIT:0] tb_count_out;
   reg 		   tb_rollover_flag;
   

   // DUT portmaps
   generate
      if(NAME == "default")
	flex_counter DUT
	  (
	   .clk(tb_clk),
	   .n_rst(tb_n_rst),
	   .clear(tb_clear),
	   .count_enable(tb_count_enable),
	   .rollover_val(tb_rollover_val),
	   .count_out(tb_count_out),
	   .rollover_flag(tb_rollover_flag)
	   );
      else if (NAME == "config1")
	flex_counter_8_msb DUT
	  (
	   .clk(tb_clk),
	   .n_rst(tb_n_rst),
	   .clear(tb_clear),
	   .count_enable(tb_count_enable),
	   .rollover_val(tb_rollover_val),
	   .count_out(tb_count_out),
	   .rollover_flag(tb_rollover_flag)
	   );
      else if (NAME == "config2")
	flex_counter_4_lsb DUT
	  (
	   .clk(tb_clk),
	   .n_rst(tb_n_rst),
	   .clear(tb_clear),
	   .count_enable(tb_count_enable),
	   .rollover_val(tb_rollover_val),
	   .count_out(tb_count_out),
	   .rollover_flag(tb_rollover_flag)
	   );
   endgenerate


   clocking cb @(posedge tb_clk);
      // 1step means 1 time precision unit, 10ps for this module. We assume the hold time is less than 200ps.
      default input #1step output #100ps; // Setup time (01CLK -> 10D) is 94 ps
      output 	   #800ps n_rst = tb_n_rst; // FIXME: Removal time (01CLK -> 01R) is 281.25ps, but this needs to be 800 to prevent metastable value warnings
      output 	   clear = tb_clear,
		   count_enable = tb_count_enable,
		   rollover_val = tb_rollover_val;
      input 	   count_out = tb_count_out,
		   rollover_flag = tb_rollover_flag;
   endclocking

   // Default Configuration Test bench main process
   initial
     begin
	// Initialize all of the test inputs
	tb_n_rst		= 1'b1;				// Initialize to be inactive
	// Initialize idle values
	tb_rollover_val		= '1;
	tb_count_enable		= 1'b0;				// Initialize to be inactive
	tb_clear		= 1'b0;				// Initialize to be inactive
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
	
	cb.count_enable <= 1'b0;
	cb.n_rst	<= 1'b0;
	cb.rollover_val	<= 'b1;
	// Wait two cycles, long enough for the reset to get to the DUT, and to receive
	// the response back
	@cb;
	@cb;
	// Check that the rollover_flag and count_out is 0
	if (1'b0 == cb.rollover_flag && 'b0 == cb.count_out)
	  $info("%s Test Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
	  $error("%s Test Case %0d:: FAILED", NAME, tb_test_num);


     end // initial begin
   

   task run_reset_DUT();
      @cb;

      cb.rollover_val		<= '1;
      cb.count_enable		<= 1'b0;		
      cb.clear		<= 1'b0;			

      cb.n_rst	<= 1'b0;

      @(cb);
      cb.n_rst	<= 1'b1;	// Deactivate the chip reset
      @(cb);
   endtask
endmodule // tb_flex_pts_sr_DUT

