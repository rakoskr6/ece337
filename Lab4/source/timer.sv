// $Id: $
// File name:   time.sv
// Created:     9/20/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: timer control block

module timer
  (
   input clk,
   input n_rst,
   input enable_timer,
   output shift_strobe,
   output packet_done
   );

   flex_counter #(.NUM_CNT_BITS(4)) DUT1(.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(enable_timer), .rollover_val(10), .count_out(), .rollover_flag(shift_strobe));

   
    flex_counter #(.NUM_CNT_BITS(4)) DUT2(.clk(clk), .n_rst(n_rst), .clear(packet_done), .count_enable(shift_strobe), .rollover_val(9), .count_out(), .rollover_flag(packet_done));

			
endmodule		
					

				   