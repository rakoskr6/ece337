// $Id: $
// File name:   rx_fifo.sv
// Created:     10/6/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: rcv fifo block

module rx_fifo
  (
   input wire clk,
   input wire n_rst,
   input wire r_enable,
   input wire w_enable,
   input wire [7:0] w_data,
   output wire [7:0] r_data,
   output wire empty,
   output wire full
   );

   fifo DUG(.r_clk(clk), .w_clk(clk), .n_rst(n_rst), .r_enable(r_enable), .w_enable(w_enable), .w_data(w_data), .r_data(r_data), .empty(empty), .full(full));
   
endmodule
