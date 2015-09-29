// $Id: $
// File name:   counter.sv
// Created:     9/28/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: keeps track of processed samples

module counter
  (
   input wire clk,
   input wire n_reset,
   input wire cnt_up,
   input wire clear,
   output wire one_k_samples
   );

   flex_counter #(.NUM_CNT_BITS(10)) Flxctr(.clk(clk),.n_rst(n_rst),.clear(clear),.count_enable(cnt_up),.rollover_val(10'b1111101000),.count_out(),.rollover_flag(one_k_samples));

endmodule
