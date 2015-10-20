/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Tue Oct 20 02:13:42 2015
/////////////////////////////////////////////////////////////


module decode ( clk, n_rst, d_plus, shift_enable, eop, d_orig );
  input clk, n_rst, d_plus, shift_enable, eop;
  output d_orig;
  wire   current, N6, prev, n5, n8, n9, n10;

  DFFSR current_reg ( .D(N6), .CLK(clk), .R(1'b1), .S(n_rst), .Q(current) );
  DFFSR prev_reg ( .D(n5), .CLK(clk), .R(1'b1), .S(n_rst), .Q(prev) );
  MUX2X1 U11 ( .B(n8), .A(n9), .S(shift_enable), .Y(n5) );
  NOR2X1 U12 ( .A(d_plus), .B(eop), .Y(n9) );
  XOR2X1 U13 ( .A(n8), .B(current), .Y(d_orig) );
  INVX1 U14 ( .A(prev), .Y(n8) );
  INVX1 U15 ( .A(n10), .Y(N6) );
  AOI21X1 U16 ( .A(shift_enable), .B(eop), .C(d_plus), .Y(n10) );
endmodule

