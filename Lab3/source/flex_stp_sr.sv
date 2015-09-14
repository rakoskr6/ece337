// $Id: $
// File name:   flex_stp_sr.sv
// Created:     9/13/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Flexible serial-to-parallel shift register
module flex_stp_sr
  #(
    parameter NUM_BITS = 4,
    parameter SHIFT_MSB = 1
    )
   (
    input clk,
    input n_rst,
    input shift_enable,
    input serial_in,
    output reg [NUM_BITS-1:0] parallel_out
    );

   genvar 		i;
   
   generate
      for (i=0; i<NUM_BITS; i=i+1)
	begin
	   always_ff @ (posedge clk, negedge n_rst)
	     begin
		if(1'b0 == n_rst)
		  begin
		     parallel_out[i]<=1;
		  end
		else if (shift_enable == 1'b1)
		  begin
		     if (SHIFT_MSB == 1'b1)
		       begin
			  if (i == 0)
			    begin
			       parallel_out[i] <= serial_in;
			    end
			  else
			    begin
			       parallel_out[i] <= parallel_out[i-1];
			    end
		       end // if (SHIFT_MSB == 1'b1
		     else
		       begin
			  if (i == NUM_BITS-1)
			    begin
			       parallel_out[i] <= serial_in;
			    end
			  else
			    begin
			       parallel_out[i] <= parallel_out[i+1];
			    end
		       end // else: !if(SHIFT_MSB == 1'b1)
		  end
		else
		  begin
		     parallel_out[i] <= parallel_out[i];
		     
		  end  
		  
	     end
	end
   endgenerate
endmodule