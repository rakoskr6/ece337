// $Id: $
// File name:   controller.sv
// Created:     9/28/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: regulates the controls the operation sequence of the entire system

module controller
  (
   input wire clk,
   input wire n_reset,
   input wire dr,
   input wire lc,
   input wire overflow,
   output reg cnt_up,
   output reg clear,
   output wire modwait,
   output reg [2:0] op,
   output reg [3:0] src1,
   output reg [3:0] src2,
   output reg [3:0] dest,
   output reg err
   );

   typedef enum logic [3:0] {idle, store, zero, sort1, sort2, sort3, sort4,
			     mul1, add1, mul2, sub1, mul3, add2, mul4, sub2,
			     ,eidle} state_type;
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

	case(state)
	  init:
	    begin

	    end

	  store:
	    begin

	    end

	  zero:
	    begin

	    end

	  sort1:
	    begin

	    end

	  sort2:
	    begin

	    end

	  sort3:
	    begin

	    end

	  sort4:
	    begin

	    end

	  mul1:
	    begin

	    end

	  add1:
	    begin

	    end

	  mul2:
	    begin

	    end

	  sub1:
	    begin

	    end

	  mul3:
	    begin

	    end

	  add2:
	    begin

	    end

	  mul4:
	    begin

	    end

	  sub2:
	    begin

	    end

	  eidle:
	    begin

	    end
	  
	end // always_comb begin
   
   
   
   
endmodule