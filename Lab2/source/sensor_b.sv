// $Id: $
// File name:   sensor_b.sv
// Created:     9/1/2015
// Author:      Kyle Rakos
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: behavioral error detector

module sensor_b
  (
   input wire [3:0] sensors,
   output reg error
   );

   always @sensors begin: COM
	if ((sensors[0] == 1'b1) || ((sensors[1] == 1'b1) && (sensors[3] == 1'b1)) || ((sensors[1] == 1'b1) && (sensors[2] == 1'b1)))
	  error = 1'b1;
	else
	  error = 1'b0;
	
     end

endmodule // sensor_b
