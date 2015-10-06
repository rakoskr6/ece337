// $Id: $
// File name:   edge_detect.sv
// Created:     10/6/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: edge detect block

module edge_detect
  (
   input clk,
   input n_rst,
   input d_plus,
   output d_edge
   );

   reg 	  prev;
   reg 	  current;
   
   
   always_ff @ (posedge clk, negedge n_rst)
     begin
	if (n_rst == 1'b0)
	  begin
	     current <= 1;
	  end
	else
	  begin
	     current <= d_plus;
	  end	
     end // always_ff @
   

   always_ff @ (posedge clk, negedge n_rst)
     begin
	if (n_rst == 1'b0)
	  begin
	     prev <= 1;
	  end
	else
	  begin
	     prev <= current;
	  end
     end // always_ff @
   
   assign d_edge = current ^ prev;
   
endmodule
