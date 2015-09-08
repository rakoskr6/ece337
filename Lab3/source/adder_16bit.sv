// $Id: $
// File name:   adder_16bit.sv
// Created:     9/7/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: 16 bit carry adder
`timescale 1ns / 100ps

module adder_16bit
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);

	// STUDENT: Fill in the correct port map with parameter override syntax for using your n-bit ripple carry adder design to be a 16-bit ripple carry adder design
   genvar 	    i;
   

   adder_nbit #(.NUM_BITS(16)) DUT(.a(a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(overflow));

   
   generate
     
      for (i=0; i<16;i=i+1)
	begin
	always @(a,b,carry_in) begin:COM
	      #(2) assert(a[i]==1'b1 || a[i]==1'b0)
		else
		  $error("A is not 1 or 0");
	      #(2) assert(b[i]==1'b1 || b[i]==1'b0)
		else
		  $error("b is not 1 or 0");
	      #(2) assert(carry_in==1'b1 || carry_in==1'b0)
		else
		  $error("Carry_in is not 1 or 0");
	   end // for (i=0; i<16;i=i+1)
	end
   endgenerate
   
   
endmodule
