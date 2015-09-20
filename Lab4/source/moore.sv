// $Id: $
// File name:   moore.sv
// Created:     9/20/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Moore Machine 1101 detector

module moore
  (
   input wire clk,
   input wire n_rst,
   input wire i,
   output reg o
   );
   
   typdef enum logic [2:0] {init, rcv1, rcv11, rcv110, rcv1101}
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

   always @ (state, i)
     begin
	case (state)
	  init:
	    begin
	       if (i == 1)
		    nextstate = rcv1;
	       else
		 nextstate = init;
	    end

	       
   // output logic
   assign o = (state == rcv1101);
   
   