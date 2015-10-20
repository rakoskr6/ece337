// $Id: $
// File name:   shift_register.sv
// Created:     10/19/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: shift register block

module shift_register
  (
   input clk,
   input n_rst,
   input shift_enable,
   input d_orig,
   output [7:0]rcv_data
   );

   flex_stp_sr #(.NUM_BITS(8),.SHIFT_MSB(0)) FLXSTP(.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), .serial_in(d_orig), .parallel_out(rcv_data));

endmodule