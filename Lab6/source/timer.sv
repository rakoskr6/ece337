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

   reg 	  [3:0]firstout;
   reg 	  secondout;
   reg [3:0] roll = 8;
   
   

   flex_counter #(.NUM_CNT_BITS(4)) FLX1(.clk(clk), .n_rst(n_rst), .clear(d_edge|| !rcving), .count_enable(rcving), .rollover_val(roll), .count_out(firstout), .rollover_flag());

   flex_counter #(.NUM_CNT_BITS(4)) FLX2(.clk(clk), .n_rst(n_rst), .clear(byte_received || !rcving), .count_enable(firstout==2), .rollover_val(roll), .count_out(), .rollover_flag(byte_received));

   assign shift_enable = (firstout == 2);


endmodule