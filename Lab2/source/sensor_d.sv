// $Id: $
// File name:   sensor_d.sv
// Created:     9/1/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Dataflow sensor

module sensor_d
  (
   input wire [3:0] sensors,
   output wire error
   );
   wire [1:0]  o;
   
assign o1 = sensors[2] & sensors[1];
assign o0 = sensors[1] & sensors[3];
assign error = sensors[0] | o0 | o1;

endmodule

