// $Id: $
// File name:   eop_detect.sv
// Created:     10/6/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: eop block

module eop_detect
  (
   input  d_plus,
   input  d_minus,
   output eop
);

   assign eop = ~d_plus & ~d_minus;
   
endmodule