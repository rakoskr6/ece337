/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Tue Oct  6 22:46:53 2015
/////////////////////////////////////////////////////////////


module decode ( clk, n_rst, d_plus, shift_enable, eop, d_orig );
  input clk, n_rst, d_plus, shift_enable, eop;
  output d_orig;
  wire   current, prev, n6, n8, n9, n10, n11;

  DFFSR current_reg ( .D(n8), .CLK(clk), .R(1'b1), .S(n_rst), .Q(current) );
  DFFSR prev_reg ( .D(n6), .CLK(clk), .R(1'b1), .S(n_rst), .Q(prev) );
  MUX2X1 U12 ( .B(n9), .A(n10), .S(shift_enable), .Y(n8) );
  NOR2X1 U13 ( .A(d_plus), .B(eop), .Y(n10) );
  MUX2X1 U14 ( .B(n11), .A(n9), .S(shift_enable), .Y(n6) );
  XOR2X1 U15 ( .A(n11), .B(n9), .Y(d_orig) );
  INVX1 U16 ( .A(current), .Y(n9) );
  INVX1 U17 ( .A(prev), .Y(n11) );
endmodule

