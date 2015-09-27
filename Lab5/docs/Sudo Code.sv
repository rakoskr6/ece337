idle: if (data_ready=0) goto idle // wait until data_ready=1
store: if (data_ready=0) goto eidle
  reg[3] = data; // Store data in a register
	   err = 0;

; reset error
zero: reg[0] = 0
; zero out accumulator
sort1: reg[1] = reg[2]
; Reorder registers
sort2: reg[2] = reg[3]
; Reorder registers
mul1: reg[6] = reg[1] * reg[4]
; sample2 * F2
add:
reg[0] = reg[0] + reg[6]
; add Large pos. coefficient
if (V) goto eidle
; On overflow, err condition
mul2: reg[6] = reg[2] * reg[5]
; sample1 * F1
sub:
reg[0] = reg[0] - reg[6]
; sub Large neg. coefficient
if (V) goto eidle
; On overflow, err condition
else goto idle
eidle: err = 1
if (data_ready=1) goto store ; wait until data_ready=1
if (data_ready=0) goto eidle

