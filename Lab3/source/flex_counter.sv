// $Id: $
// File name:   flex_counter.sv
// Created:     9/13/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Flexible and Scalable counter with controlled rollover


module flex_counter.sv
  #(
    parameter NUM_CNT_BITS = 4
    )
   (
    input clk,
    input n_rst,
    input clear,
    input count_enable,
    input [NUM_CNT_BITS-1:0]rollover_val,
    output [NUM_CNT_BITS-1:0]count_out,
    output reg rollover_flag
    );

   genvar 		i;
   reg [NUM_BITS-1:0] 	parallel_in_reg;
   
   generate
      for (i=0; i<NUM_BITS; i=i+1)
	begin
	   always_ff @ (posedge clk, negedge n_rst)
	     begin
		if(1'b0 == n_rst)
		  begin
		     parallel_in_reg[i]<=1;
		  end
		else if (load_enable == 1'b1)
		  begin
		     //load registers with parallel_in
		     parallel_in_reg[i] <= parallel_in[i];
		     
		  end
		
		else if (shift_enable == 1'b1)
		  begin
		     if (SHIFT_MSB == 1'b1)
		       begin
			  if (i == 0)
			    begin
			       parallel_in_reg[i] <= 1;
			    end
			  else
			    begin
			       parallel_in_reg[i] <= parallel_in_reg[i-1];
			    end
		       end // if (SHIFT_MSB == 1'b1
		     else
		       begin
			  if (i == NUM_BITS-1)
			    begin
			       parallel_in_reg[i] <= 1;
			    end
			  else
			    begin
			       parallel_in_reg[i] <= parallel_in_reg[i+1];
			    end
		       end 
		  end
		else
		  begin
		     parallel_in_reg[i] <= parallel_in_reg[i];
		  end  
		
	     end // always_ff @ (posedge clk, negedge n_rst)
	   if (SHIFT_MSB == 1'b1)
	     begin
		assign serial_out = parallel_in_reg[NUM_BITS-1];
	     end
	   else
	     begin
		assign serial_out = parallel_in_reg[0];
	     end
	end // for (i=0; i<NUM_BITS; i=i+1)
      
   endgenerate
endmodule