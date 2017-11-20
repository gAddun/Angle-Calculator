	.globl part_three
part_three:
	//Clear registers
	ADD X4, XZR, XZR //Index into the array
	ADD X5, XZR, XZR //Sum variable for dot product
	SUB X8, XZR, XZR //Counter for loop on accessing arrays
	ADD X11, XZR, XZR //X11 is control logic for branching int pre_norm
	//Registers for double values converted from int
	FSUB D9, D9, D9//Clear D registers
	FSUB D5, D5, D5// Clear D registers
a_dot_b:
	CMP X8, X2 //If counter equals array length
	B.EQ pre_norm //Branch to finding length of first vector
	LDR X6, [X0, X4] //Load element i from vector a
	LDR X7, [X1, X4] //Load element i from vector b
	MUL X9, X6, X7 //multiply element i from vectors a and b
	ADD X5, X5, X9 //add products for dot products
	ADD X4, X4, #8 //increment index into arrays a and b
	B incr
incr:
	ADD X8, X8, #1 //increase counter
	B a_dot_b //branch back to dot product loop
pre_norm:
	//clear reigster
	ADD X4, XZR, XZR
	ADD X8, XZR, XZR
	FSUB, D5, D5, D5
	CMP X11, XZR //If the norm_a procedure has finished executing
	B.NE pre_norm_b //Branch to pre_norm_b
//Find the length of a
norm_a:
	CMP X8, X2 //If counter equals array length
	B.EQ pre_norm //Branch to find length of second vector
	LDR X6, [X0, X4] //load value of element i from the array
	UCVTF D9, X6 //convert integer in X6 to double
	FMUL D9, D9, D9 //Square the element i in the array
	FADD D5, D9, D5 //Add sqaured elements together
	ADD X4, X4, #8 //increment index into array
	ADD X8, X8 #1 //incerment counter
	ADD X11, X11, #1 //control for branch in pre_norm to pre_norm_b
	B norm_a //loop back to this procedure
pre_norm_b:
	FSQRT D5, D5 // final step in computing norm of a
	FSUB D6, D6, D6 //clear double register that will store norm of b
norm_b:
	CMP X8, X2
	B.EQ cos_val //branch to obtain cosine value
	LDR X6, [X1, X4] //load element i from vector 2
	UCVTF D9, X6 //convert integer to double
	FMUL D9, D9, D9
	FADD D6, D6, D9
	ADD X4, X4, #8
	ADD X8, X8, #1
	B norm_b // loop back to this procedure
cos_val:
	
exit:
	MOV X0, X5
	UCVTF D0, X0
	br	X30


//X1 address of first vector
//X2 address of second vector
//X3 number of elements
