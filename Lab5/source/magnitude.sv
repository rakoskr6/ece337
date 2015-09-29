// $Id: $
// File name:   magnitude.sv
// Created:     9/28/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: handles magnitude logic

module magnitude
  (
   input wire [16:0] in,
   output wire [15:0] out
   );

   reg [16:0] 	      temp;
   

   always_comb
     begin
	if (in < 0)
	  begin
	     temp = -in;
	  end
	else
	  begin
	     temp = in;
	  end
	
	//out = temp[15:0];
	
     end

   assign out = temp[15:0];
   
   
endmodule