idle: if (data_ready=0) goto idle // wait until data_ready=1
store: if (data_ready=0) goto eidle
	reg[3] = data // Store data in a register
	err = 0 //reset error
zero: reg[0] = 0 //zero out accumulator
sort1: reg[1] = reg[2] //Reorder registers
sort2: reg[2] = reg[3] //Reorder registers
sort3: reg[3] = reg[4]
sort4: reg[4] = reg[5]


mul1: reg[6] = reg[1] * reg[10] // sample4 * F4
add1:
reg[0] = reg[0] + reg[6] // add small pos. coefficient
	if (V) goto eidle // On overflow, err condition
mul2: reg[6] = reg[2] * reg[9] // sample3 * F3
sub1:
	reg[0] = reg[0] - reg[6] //sub Large neg. coefficient
	if (V) goto eidle // On overflow, err condition
	else goto idle
	
mul3: reg[6] = reg[3] * reg[8] // sample2 * F2
add2:
reg[0] = reg[0] + reg[6] // add Large pos. coefficient
	if (V) goto eidle // On overflow, err condition
mul4: reg[6] = reg[4] * reg[7] // sample1 * F1
sub2:
	reg[0] = reg[0] - reg[6] //sub small neg. coefficient
	if (V) goto eidle // On overflow, err condition
	else goto idle

eidle: err = 1
	if (data_ready=1) goto store // wait until data_ready=1
	if (data_ready=0) goto eidle

//reg[0] = answer
//reg[1:4] = samples
//reg[5] = newData
//reg[6] = multiplication
//reg[7-10] = coefficients
