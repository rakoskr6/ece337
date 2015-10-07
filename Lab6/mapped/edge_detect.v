/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Tue Oct  6 13:49:56 2015
/////////////////////////////////////////////////////////////


module edge_detect ( clk, n_rst, d_plus, d_edge );
  input clk, n_rst, d_plus;
  output d_edge;
  wire   current, prev;

  DFFSR current_reg ( .D(d_plus), .CLK(clk), .R(1'b1), .S(n_rst), .Q(current)
         );
  DFFSR prev_reg ( .D(current), .CLK(clk), .R(1'b1), .S(n_rst), .Q(prev) );
  XOR2X1 U6 ( .A(prev), .B(current), .Y(d_edge) );
endmodule

