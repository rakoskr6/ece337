// $Id: $
// File name:   timer.sv
// Created:     10/19/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: timer module

module timer
  (
   input clk,
   input n_rst,
   input d_edge,
   input rcving,
   output shift_enable,
   output byte_received
   );

   

   flex_counter #(.NUM_CNT_BITS(10)) FLX1(.clk(clk), .n_rst(n_rst), .clear(d_edge), .count_enable(), .rollover_val(), .count_out(), .rollover_flag());

endmodule