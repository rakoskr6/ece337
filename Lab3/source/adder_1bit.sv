// $Id: $
// File name:   adder_1bit.sv
// Created:     9/1/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: 1 bit adder
`timescale 1ns / 100ps

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
      
      assert(a==1 || a==0)
	else
	  $error("A is not 1 or 0");
      assert(b==1 || b==0)
	else
	  $error("b is not 1 or 0");
      assert(carry_in==1'b1 || carry_in==1'b0)
	else
	  $error("Carry_in is not 1 or 0");	    
	    	    
end
   
   endmodule
