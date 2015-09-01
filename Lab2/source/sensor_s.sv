// $Id: $
// File name:   sensor_s.sv
// Created:     9/1/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: sensor error detection circuit


module sensor_s
  (
   input wire [3:0] sensors,
   output wire error
   );

   wire [1:0]  OOR;

   
   and A1(OOR1,sensors[1],sensors[2]);

   and A2(OOR0,sensors[1],sensors[3]);

   or O1(error,OOR1,OOR0,sensors[0]);
   
endmodule
