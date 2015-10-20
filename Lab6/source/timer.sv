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

   reg 	  firstout;
   reg 	  secondout;
   

   flex_counter #(.NUM_CNT_BITS(3)) FLX1(.clk(clk), .n_rst(n_rst), .clear(d_edge|| !rcving), .count_enable(rcving), .rollover_val(8), .count_out(firstout), .rollover_flag());

   flex_counter #(.NUM_CNT_BITS(3)) FLX2(.clk(clk), .n_rst(n_rst), .clear(byte_received || !rcving), .count_enable(firstout==2), .rollover_val(8), .count_out(), .rollover_flag(byte_received));

   assign shift_enable = (firstout == 2);


endmodule