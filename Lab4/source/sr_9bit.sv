// $Id: $
// File name:   sr_9bit.sv
// Created:     9/20/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: 9 bit shift register

module sr_9bit
  (
   input clk,
   input n_rst,
   input shift_strobe,
   input serial_in,
   output [7:0] packet_data,
   output stop_bit
   );

   reg [8:0] all_data;

   assign packet_data = all_data[7:0];
   assign stop_bit = all_data[8];
   
   flex_stp_sr #(.NUM_BITS(9),.SHIFT_MSB(0)) DUT(.clk(clk), .n_rst(n_rst), .shift_enable(shift_strobe), .serial_in(serial_in), .parallel_out(all_data));

endmodule // sr_9bit
