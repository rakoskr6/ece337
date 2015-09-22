// $Id: $
// File name:   rcv_block.sv
// Created:     9/20/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: receiver block

module rcv_block
  (
   input clk,
   input n_rst,
   input serial_in,
   input data_read,
   output reg [7:0] rx_data,
   output data_ready,
   output overrun_error,
   output framing_error
   );

   wire   load_buffer;
   wire [7:0] packet_data;
   wire       packet_done;
   wire       enable_timer;
   wire       shift_strobe;
   wire       start_bit_detected;
   wire       sbc_enable;
   wire       sbc_clear;
   wire       stop_bit;
   
      

   rx_data_buff DUT1 (.clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), .packet_data(packet_data), .data_read(data_read), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error));

   stop_bit_chk DUT2 (.clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(framing_error));

   rcu DUT3 (.clk(clk), .n_rst(n_rst), .start_bit_detected(start_bit_detected), .packet_done(packet_done), .framing_error(framing_error), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), .enable_timer(enable_timer));

   sr_9bit DUT4 (.clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), .serial_in(serial_in), .packet_data(packet_data), .stop_bit(stop_bit));

   timer DUT5 (.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), .shift_strobe(shift_strobe), .packet_done(packet_done));

   start_bit_det DUT6 (.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .start_bit_detected(start_bit_detected));
   

   

endmodule