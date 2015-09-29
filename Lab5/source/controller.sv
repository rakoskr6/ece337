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
   output reg modwait,
   output reg [2:0] op,
   output reg [3:0] src1,
   output reg [3:0] src2,
   output reg [3:0] dest,
   output reg err
   );

   typedef enum logic [4:0] {idle, store, zero, sort1, sort2, sort3, sort4,
			     mul1, add1, mul2, sub1, mul3, add2, mul4, sub2, nop,
			     eidle,lc1,wait1,lc2,wait2,lc3,wait3,lc4} state_type;
   state_type state, nextstate;

   reg 	next_modwait;
   reg 	next_err;
   
      
always_ff @(posedge clk, negedge n_reset)
  begin
     if (n_reset == 0)
       begin
	  state <= idle;
	  modwait <= 0;
	  err <= 0;
	  
	  
       end
     else
       begin
	  state <= nextstate;
	  modwait <= next_modwait;
	  err <= next_err;
	  
       end
  end // always_ff @ (posedge clk, negedge n_rst)

   always_comb
     begin
	nextstate = state;

	case(state)
	  idle:
	    begin
	       if (lc == 1'b1)
		 begin
		    nextstate = lc1;
		 end
	       else if (dr == 1'b1)
		 begin
		    nextstate = store;
		 end
	       else
		 begin
		    nextstate = idle;
		 end	    
	       
	    end

	  store:
	    begin
	       if (dr == 1'b0)
		 begin
		    nextstate = eidle;
		 end
	       else
		 begin
		    //reg[3] = data
		    nextstate = zero;
		 end
	    end

	  zero:
	    begin
	       //reg[0] = 0
	       nextstate = sort1;
	    end

	  sort1:
	    begin
	       //reg[1] = reg[2]
	       nextstate = sort2;
	    end

	  sort2:
	    begin
	       //reg[2] = reg[3]
	       nextstate = sort3;
	    end

	  sort3:
	    begin
	       //reg[3] = reg[4]
	       nextstate = sort4;
	    end

	  sort4:
	    begin
	       //reg[4] = reg[5]
	       nextstate = mul1;
	    end

	  mul1:
	    begin
	       //reg[6] = reg[1]*reg[10]
	       nextstate = add1;
	    end

	  add1:
	    begin
	       if (overflow == 1'b1)
		 begin
		    nextstate = eidle;
		 end
	       else
		 begin
		    nextstate = mul2;
		 end
	    end

	  mul2:
	    begin
	       nextstate = sub1;
	    end

	  sub1:
	    begin
	       if (overflow == 1'b1)
		 begin
		    nextstate = eidle;
		 end
	       else
		 begin
		    nextstate = mul3;
		 end
	    end

	  mul3:
	    begin
	       nextstate = add2;
	    end

	  add2:
	    begin
	       if (overflow == 1'b1)
		 begin
		    nextstate = eidle;
		 end
	       else
		 begin
		    nextstate = mul4;
		 end
	    end

	  mul4:
	    begin
	       nextstate = sub2;
	       
	    end

	  sub2:
	    begin
	       if (overflow == 1'b1)
		 begin
		    nextstate = eidle;
		 end
	       else
		 begin
		    nextstate = nop;
		 end
	    end // case: sub2

	  nop:
	    begin
	       nextstate = idle;
	    end
	  

	  eidle:
	    begin
	       if (dr == 1'b1)
		 begin
		    nextstate = store;
		 end
	       else
		 begin
		    nextstate = eidle;
		 end	    
	    end

	  lc1:
	    begin
	       nextstate = wait1;
	    end

	  wait1:
	    begin
	       if (lc == 1'b1)
		 begin
		    nextstate = lc2;
		 end
	       else
		 begin
		    nextstate = wait1;
		 end
	    end

	  lc2:
	    begin
	       nextstate = wait2;
	    end

	  wait2:
	    begin
	       if (lc == 1'b1)
		 begin
		    nextstate = lc3;
		 end
	       else
		 begin
		    nextstate = wait2;
		 end
	    end

	  lc3:
	    begin
	       nextstate = wait3;
	    end

	  wait3:
	    begin
	       if (lc == 1'b1)
		 begin
		    nextstate = lc4;
		 end
	       else
		 begin
		    nextstate = wait3;
		 end
	    end

	  lc4:
	    begin
	       nextstate = idle;
	    end
	endcase // case (state)
     end // always_comb begin
   

   
   always_comb
     begin
	cnt_up = 1'b0;
	clear = 1'b0;
	next_modwait = 1'b1; //default 1
	op = 3'b000;
	src1 = 4'b0000;
	src2 = 4'b0000;
	dest = 4'b0000;
	next_err = 1'b0;

	//cnt_up
	if (state == zero) 
	  begin
	     cnt_up = 1;
	  end
	//clear
	if (state == lc1 || state == lc2 || state == lc3 || state == lc4)
	  begin
	     clear = 1;
	  end

	//modwait
	if (nextstate == idle || nextstate == eidle || nextstate == wait1 || nextstate == wait2 || nextstate == wait3)
	  begin
	     next_modwait = 1'b0;
	  end

	//op codes
	if (state == store) op = 3'b010;
	else if (state == zero) op = 3'b101;
	else if (state == sort1 || state == sort2 || state == sort3 || state == sort4) op = 3'b001;
	else if (state == mul1 || state == mul2 || state == mul3 || state == mul4) op = 3'b110;
	else if (state == add1 || state == add2) op = 3'b100;
	else if (state == sub1 || state == sub2) op = 3'b101;
	else if (state == lc1 || state == lc2 || state == lc3 || state == lc4) op = 3'b011;
	
	//src1
	if (state == sort1) src1 = 2;
	else if (state == sort2) src1 = 3;
	else if (state == sort3) src1 = 4;
	else if (state == sort4) src1 = 5;
	else if (state == zero) src1 = 0;
	else if (state == mul1) src1 = 1;
	else if (state == add1) src1 = 0;
	else if (state == mul2) src1 = 2;
	else if (state == sub1) src1 = 0;
	else if (state == mul3) src1 = 3;
	else if (state == add2) src1 = 0;
	else if (state == mul4) src1 = 4;
	else if (state == sub2) src1 = 0;

	//src2
	if (state == sort1) src2 = 0;
	else if (state == sort2) src2 = 0;
	else if (state == sort3) src2 = 0;
	else if (state == sort4) src2 = 0;
	else if (state == zero) src2 = 0;
	else if (state == mul1) src2 = 10;
	else if (state == add1) src2 = 6;
	else if (state == mul2) src2 = 9;
	else if (state == sub1) src2 = 6;
	else if (state == mul3) src2 = 8;
	else if (state == add2) src2 = 6;
	else if (state == mul4) src2 = 7;
	else if (state == sub2) src2 = 6;

	
	//dest
	if (state == store) dest = 5;
	else if (state == zero) dest = 0;
	else if (state == sort1)  dest = 1;
	else if (state == sort2) dest = 2;
	else if (state == sort3) dest = 3;
	else if (state == sort4) dest = 4;
	else if (state == mul1) dest = 6;
	else if (state == add1) dest = 0;
	else if (state == mul2) dest = 6;
	else if (state == sub1) dest = 0;
	else if (state == mul3) dest = 6;
	else if (state == add2) dest = 0;
	else if (state == mul4) dest = 6;
	else if (state == sub2) dest = 0;
	else if (state == lc1) dest = 7;
	else if (state == lc2) dest = 8;
	else if (state == lc3) dest = 9;
	else if (state == lc4) dest = 10;

	//err
	if (nextstate == eidle) next_err = 1'b1;
	
	
     end // always_comb end
   
   
   
   
   
endmodule
