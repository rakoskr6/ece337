// $Id: $
// File name:   rcu.sv
// Created:     9/20/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: receiver control unit

module rcu
  (
   input clk,
   input n_rst,
   input start_bit_detected,
   input packet_done,
   input framing_error,
   output sbc_clear,
   output sbc_enable,
   output load_buffer,
   output enable_timer
   );

   typedef enum logic [2:0] {init, ReadData, Check, Receive, Load}
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
	case(state)
	  init:
	    begin
	       if (start_bit_detected == 1'b1)
		 nextstate = ReadData;
	       else
		 nextstate = init;

	    end

	  ReadData:
	    begin
	       if (packet_done == 1'b1)
		 nextstate = Check;
	       else
		 nextstate = ReadData;
	    end
	  Check:
	    begin
	       nextstate = Receive;
	    end
	  Receive:
	    begin
	       if (framing_error == 1'b1)
		 nextstate = init;
	       else
		 nextstate = Load;
	    end
	endcase // case (state)
     end // always_comb begin

   // output logic
   assign sbc_clear = (state == ReadData);
   assign sbc_enable = (state == Check);
   assign load_buffer = (state == Load);
   assign enable_timer = (state == ReadData);
     
   
endmodule // rcu

   