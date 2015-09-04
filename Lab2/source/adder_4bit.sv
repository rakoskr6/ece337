// $Id: $
// File name:   adder_4bit
// Created:     9/3/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: 4 bit adder (structural style)

module adder_4bit
  (
   wire [3:0] carrys,
   input wire [2:0] a,
   input wire [2:0] b,
   output reg overflow,
   
   );

   genvar     i;
   
assign carrys[0] = carry_in;
generate
for(i=0; i<=2; i=i+1)
begin
   adder_1bit IX (.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i]));
end
endgenerate
assign overflow = carrys[3]

 endmodule