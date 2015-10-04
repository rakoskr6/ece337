// $Id: $
// File name:   sync.sv
// Created:     9/7/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Synchronizer Design spec

module sync
  (
   input clk,
   input n_rst,
   input async_in,
   output reg sync_out
   );

   always_ff @ (posedge clk, negedge n_rst) begin
	if(1'b0 == n_rst)
	  begin
	     sync_out = 0;

	  end
	else if (async_in==1 || async_in==0)
	  begin
	     sync_out = async_in;
	     if (sync_out != 0 && sync_out != 1)
	       begin
		  sync_out = 0;
	       end
	  end
	
	
     end // always_ff @ (posedge clk, negedge n_rst)

   endmodule