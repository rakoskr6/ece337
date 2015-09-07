// $Id: $
// File name:   adder_4bit
// Created:     9/3/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: 4 bit adder (structural style)

module adder_4bit
  (
   wire [4:0] carrys,
   input wire [3:0] a,
   input wire [3:0] b,
   output reg overflow,
   input wire carry_in,
   output wire [3:0]sum
   );

   genvar     i;
   
assign carrys[0] = carry_in;
generate
for(i=0; i<=3; i=i+1)
begin
   adder_1bit IX (.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));
end
endgenerate
   assign overflow = carrys[4];
   

 endmodule