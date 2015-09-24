// $Id: $
// File name:   flex_counter.sv
// Created:     9/13/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Flexible and Scalable counter with controlled rollover


module flex_counter
  #(
    parameter NUM_CNT_BITS = 4
    )
   (
    input clk,
    input n_rst,
    input clear,
    input count_enable,
    input [NUM_CNT_BITS-1:0]rollover_val,
    output reg [NUM_CNT_BITS-1:0]count_out,
    output reg rollover_flag
    );

   always_ff @ (posedge clk, negedge n_rst)
     begin
	if(1'b0 == n_rst)
	  begin
	     rollover_flag <= 1'b0;
	     count_out <= 0;
	  end
	else if (clear == 1'b1)
	  begin
	     count_out <= 0;
	     rollover_flag <= 1'b0;
	  end

	else if (count_enable == 1'b1)
	  begin
	     if (count_out >= rollover_val)
	       begin
		  rollover_flag <= 1'b0;
		  count_out <= 1;
	       end
	     else if (count_out == rollover_val - 1)
	       begin
		  count_out <= count_out + 1;
		  rollover_flag <= 1'b1;
	       end		       
	     else
	       begin
		  count_out <= count_out + 1;
		  rollover_flag <= 1'b0;
	       end
	  end // if (count_enable == 1'b1)
	
	else
	  begin
	     count_out <= count_out;
	     rollover_flag <= rollover_flag;
	  end // else: !if(count_enable == 1'b1)
     end // always_ff @ (posedge clk, negedge n_rst)

   //always comb output
endmodule
