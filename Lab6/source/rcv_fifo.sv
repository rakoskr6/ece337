// $Id: $
// File name:   rcv_fifo.sv
// Created:     10/6/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: rcv fifo block

module rcv_fifo
  (
   input clk,
   input n_rst,
   input r_enable,
   input w_enable,
   input [7:0] w_data,
   output [7:0] r_data,
   output empty,
   output full
   );

   fifo DUG(.r_clk(clk), .w_clk(clk), .n_rst(n_rst), .r_enable(r_enable), .w_enable(w_enable), .w_data(w_data), .r_data(r_data), .empty(empty), .full(full));
   
endmodule
