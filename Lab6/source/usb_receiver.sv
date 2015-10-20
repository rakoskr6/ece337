// $Id: $
// File name:   usb_receiver.sv
// Created:     10/20/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: the scary receiver!!!!!

module usb_receiver
  (
   input clk,
   input n_rst,
   input d_plus,
   input d_minus,
   input r_enable,
   output reg [7:0] r_data,
   output reg empty,
   output reg full,
   output reg rcving,
   output reg r_error
   );
   wire       d_plus_sync;
   wire       d_minus_sync;
   wire       eop;
   wire       d_orig;
   wire       d_edge;
   wire       shift_enable;
   wire       w_enable;
   wire [7:0] rcv_data;
   wire       byte_received;
   
   
   
   
   sync sync1(.clk(clk), .n_rst(n_rst), .async_in(d_plus), .sync_out(d_plus_sync));
   sync sync2(.clk(clk), .n_rst(n_rst), .async_in(d_minus), .sync_out(d_minus_sync));

   decode decode1(.clk(clk), .n_rst(n_rest), .d_plus(d_plus_sync), .shift_enable(shift_enable), .eop(eop), .d_orig(d_orig));

   edge_detect edge_detect1(.clk(clk), .n_rst(n_rst), .d_plus(d_plus_sync), .d_edge(d_edge));

   timer timer1(.clk(clk), .n_rst(n_rst), .d_edge(d_edge), .rcving(rcving), .shift_enable(shift_enable), .byte_received(byte_received));

   shift_register shift_register1(.clk(clk), .n_rst(n_rst), .shift_enable(shift_enable), .d_orig(d_orig), .rcv_data(rcv_data));

   rx_fifo rx_fifo1(.clk(clk), .n_rst(n_rst), .r_enable(r_enable), .w_enable(w_enable), .w_data(rcv_data), .r_data(r_data), .empty(empty), .full(full));

   eop_detect eop_detect1(.d_plus(d_plus_sync), .d_minus(d_minus_sync), .eop(eop));

   rcu rcu1(.clk(clk), .n_rst(n_rst), .d_edge(d_edge), .eop(eop), .shift_enable(shift_enable), .rcv_data(rcv_data), .byte_received(byte_received), .rcving(rcving), .w_enable(w_enable), .r_error(r_error));
   
   
   
endmodule