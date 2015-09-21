// $Id: $
// File name:   mealy.sv
// Created:     9/20/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Moore Machine 1101 detector

module mealy
  (
   input wire clk,
   input wire n_rst,
   input wire i,
   output reg o
   );
   
   typedef enum logic [1:0] {init, rcv1, rcv11, rcv110}
   state_type;
   state_type state, nextstate;
   
   
always_ff @(posedge clk, negedge n_rst)
  begin
     if (n_rst == 0)
       begin
	  state <= init;

       end
     else
       begin
	  state <= nextstate;
       end
  end // always_ff @ (posedge clk, negedge n_rst)

   always_comb
     begin
	nextstate = state;
	case (state)
	  init:
	    begin
	       if (i == 1'b1)
		    nextstate = rcv1;
	       else
		 nextstate = init;
	    end
	  rcv1:
	    begin
	       if (i == 1'b1)
		 nextstate = rcv11;
	       else
		 nextstate = init;
	    end
	  rcv11:
	    begin
	       if (i == 1'b0)
		 nextstate = rcv110;
	       else
		 nextstate = init;
	    end
	  rcv110:
	    begin
	       if (i == 1'b1)
		 nextstate = rcv1;
	       else
		 nextstate = init;
	    end
	  
	endcase
     end // always @ (state, i)
   
  

	       
   // output logic
   assign o = ((state == rcv110) && (i == 1'b1));
   
endmodule