// $Id: $
// File name:   fir_filter.sv
// Created:     9/28/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Creates top level module

module fir_filter
  (
   input wire 	      clk,
   input wire 	      n_reset,
   input wire [15:0]  sample_data,
   input wire [15:0]  fir_coefficient,
   input wire 	      data_ready,
   input wire 	      load_coeff,
   output wire 	      one_k_samples,
   output wire 	      modwait,
   output wire [15:0] fir_out,
   output wire 	      err
   );

   wire 	      dr;
   wire 	      lc;
   wire 	      cnt_up;
   wire 	      clear;
   wire [2:0] 	      op;
   wire [3:0] 	      src1;
   wire [3:0] 	      src2;
   wire [3:0] 	      dest;
   wire 	      overflow;
   wire 	      outreg_data;
   
   
   
   sync sync1(.clk(clk), .n_rst(n_reset), .async_in(data_ready), .sync_out(dr));
   sync sync2(.clk(clk), .n_rst(n_reset), .async_in(load_coeff), .sync_out(lc));
   
   controller contrl1(.clk(clk), .n_reset(n_reset), .dr(dr), .lc(lc), .overflow(overflow), .cnt_up(cnt_up), .clear(clear), .modwait(modwait), .op(op), .src1(src1), .src2(src2), .dest(dest), .err(err));

   counter cntr1(.clk(clk), .n_reset(n_reset), .cnt_up(cnt_up), .clear(clear), .one_k_samples(one_k_samples));

   magnitude mgntd1(.in(outreg_data), .out(fir_out));

   datapath dtapth1(.clk(clk), .n_reset(n_reset), .op(op), .src1(src1), .src2(src2), .dest(dest), .ext_data1(sample_data), .ext_data2(fir_coefficient), .outreg_data(outreg_data), .overflow(overflow));
   

      
endmodule

