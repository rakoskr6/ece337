// $Id: $
// File name:   decode.sv
// Created:     10/6/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: decode block

module decode
  (
   input clk,
   input n_rst,
   input d_plus,
   input shift_enable,
   input eop,
   output d_orig
   );
   reg 	  current;
   reg 	  prev;
      
      
   always_ff @ (posedge clk, negedge n_rst)
     begin
	if (n_rst == 1'b0)
	  begin
	     current <= 1;
	  end
	else
	  begin
	     if (shift_enable == 1'b1)
	       begin
		  current <= d_plus;
		  if (eop == 1'b1)
		    begin
		       current <= 1'b1;
		    end
		  current <= current;
	       end
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
	     if (shift_enable == 1'b1)
	       begin
		  prev <= current;
		  if (eop == 1'b1)
		    begin
		       current <= 1'b1;
		    end
		  prev <= prev;
	       end
	  end	
     end // always_ff @
   
   assign d_edge = current ^ prev;
   

endmodule
