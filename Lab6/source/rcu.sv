// $Id: $
// File name:   rcu.sv
// Created:     10/19/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: The ultimate RCU
//wait for eop to deassert before going to states
module rcu
   (
    input clk,
    input n_rst,
    input d_edge,
    input eop,
    input shift_enable,
    input [7:0]rcv_data,
    input byte_received,
    output reg rcving,
    output reg w_enable,
    output reg r_error
    );

   typedef enum logic [4:0] {idleWait, idle, beforeIdle, rcvFirst, chkSync, Wait, rcvNext, wrtNext,syncErr, eidle, WaitSyncErr, WaitrcvNext} state_type;
   state_type state, nextstate;

always_ff @(posedge clk, negedge n_rst)
  begin
     if (n_rst == 0)
       begin
	  state <= idle;
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
	  beforeIdle:
	    begin
	       nextstate = idle;
	    end
	  
	  idle:
	    begin
	       if (d_edge == 1) nextstate = rcvFirst;
	       else nextstate = idle;
	    end

	  idleWait:
	    begin
	       if (eop == 0) nextstate = idle;
	       else nextstate = beforeIdle;
	    end

	  rcvFirst:
	    begin
	       if (byte_received == 1) nextstate = chkSync;
	       else nextstate = rcvFirst;
	    end

	  chkSync:
	    begin
	       if (rcv_data == 8'b10000000) nextstate = Wait;
	       else nextstate = syncErr;
	    end
	  
	  Wait:
	    begin
	       if (eop == 1 && shift_enable == 1) nextstate = idleWait;
	       else if (eop == 0 && shift_enable == 1) nextstate = rcvNext;
	       else nextstate = Wait;
	    end

	  rcvNext:
	    begin
	       if (byte_received == 1) nextstate = wrtNext;
	       else if (eop == 1 && shift_enable == 1) nextstate = WaitrcvNext;
	       else nextstate = rcvNext;
	    end

	  wrtNext:
	    begin
	       nextstate = Wait;
	    end

	  syncErr:
	    begin
	       if (eop == 1 && shift_enable == 1) nextstate = WaitSyncErr;
	       else nextstate = syncErr;
	    end

	  eidle:
	    begin
	       if (d_edge == 1) nextstate = rcvFirst;
	       else nextstate = eidle;
	    end

	  WaitSyncErr:
	    begin
	       if (eop == 0) nextstate = eidle;
	       else nextstate = WaitSyncErr;
	       
	    end

	  WaitrcvNext:
	    begin
	       if (eop == 0) nextstate = eidle;
	       else nextstate = WaitrcvNext;
	    end
	  
	endcase
     end // always_comb begin

   always_comb
     begin

	if (state == idle || state == idleWait)
	  begin
	     rcving = 0;
	     w_enable = 0;
	     r_error = 0;
	  end
	else if (state == rcvFirst || state == chkSync || state == Wait || state == rcvNext)
	  begin
	     rcving = 1;
	     w_enable = 0;
	     r_error = 0;
	  end
	else if (state == wrtNext)
	  begin
	     rcving = 1;
	     w_enable = 1;
	     r_error = 0;
	  end
	else if (state == syncErr)
	  begin
	     rcving = 1;
	     w_enable = 1;
	     r_error = 0;
	  end
	else if (state == eidle || state == WaitSyncErr || state == WaitrcvNext)
	  begin
	     rcving = 0;
	     w_enable = 0;
	     r_error = 1;
	  end
	else
	  begin
	     rcving = 0;
	     w_enable = 0;
	     r_error = 0;
	  end

     end
      
endmodule