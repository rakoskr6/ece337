// $Id: $
// File name:   adder_1bit.sv
// Created:     9/1/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: 1 bit adder

module adder_1bit
  (
input wire a,
   input wire b,
   input wire carry_in,
   output reg sum,
   output reg carry_out
   );

   always @(a,b,carry_in) begin: COM
      sum = carry_in ^ (a ^ b);
      carry_out = ((!carry_in) && b && a) || (carry_in && (b || a));
	end
   endmodule
