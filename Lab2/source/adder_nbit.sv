// $Id: $
// File name:   adder_nbit.sv
// Created:     9/7/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: n bit carry adder

module adder_nbit
#(
  parameter NUM_BITS = 4
  )
(
   input wire [NUM_BITS - 1:0] a,
   input wire [NUM_BITS - 1:0] b,
   output wire overflow,
   input wire carry_in,
   output wire [NUM_BITS - 1:0]sum
   );

   genvar     i;
   wire [NUM_BITS:0] carrys;
   
assign carrys[0] = carry_in;
generate
for(i=0; i<=NUM_BITS-1; i=i+1)
begin
   adder_1bit IX (.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));
end
endgenerate
   assign overflow = carrys[NUM_BITS];
   

 endmodule