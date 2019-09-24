.section .rodata
too_many_arg_print: .asciz "too many argumentn"
not_enough_arg_print: .asciz "not enough arguments\n"
output_print: .asciz "Result: %d %c %d = %d\n"
wrong_operator: .asciz "Unknown operator %c\n"
int_scan: .asciz "%d"
char_scan: .asciz "%c"

.section .text
.global addition
addition:
	la		a0,	output_print
	ld		a1, 32(sp)
	ld		a2, 40(sp)
	ld		a3, 48(sp)
	add		a4, a1, a3		
	ret

.global subtraction
subtraction:
	la		a0, output_print
	ld		a1, 32(sp)
	ld		a2,	40(sp)
	ld		a3,	48(sp)
	sub		a4, a1, a3
	ret

.global multiplication
multiplication:
	la		a0, output_print
	ld		a1,	32(sp)
	ld		a2, 40(sp)
	ld		a3,	48(sp)
	mul		a4, a1, a3
	ret

.global division
division:
	la		a0, output_print
	ld		a1, 32(sp)
	ld		a2, 40(sp)
	ld		a3, 48(sp)
	div		a4, a1, a3
	ret

.global modulo
modulo:
	la		a0, output_print
	ld		a1, 32(sp)
	ld		a2, 40(sp)
	ld		a3, 48(sp)
	rem		a4, a1, a3


.global main
main:

	/*allocate stack space*/
	addi	sp, sp, -64
	sd		ra, 0(sp)

	/*check the command line arguments*/
	li		t0, 4
	bgt		a0, t0, too_many_arg
	blt		a0, t0, not_enough_arg



	/*use the saved register to save information*/
	sd		s0, 8(sp)
	sd		s1, 16(sp)
	sd		s2, 24(sp)

	ld		s0, 8(a1)	/*s0 = argv[1]*/
	ld		s1, 16(a1)  /*s1 = argv[2]*/
	ld		s2, 24(a1)  /*s2 = argv[3]*/

	/*use sscanf to read in the command line arguments*/
	/*sscanf(argv[1], "%d", &left)*/
	mv		a0, s0
	la		a1, int_scan
	addi	a2, sp, 32
	call	sscanf

	/*sscanf(argv[2], "%c", &op)*/
	mv		a0, s1
	la		a1, char_scan
	addi	a2, sp, 40
	call	sscanf

	/*sscanf(argv[3], "d", &right)*/
	mv		a0, s2
	la		a1, int_scan
	addi	a2, sp, 48
	call	sscanf

	lw		s0, 32(sp)
	lb		s1, 40(sp)
	lw		s2, 48(sp)



	/*use the temp register to store some values for the ascii values of the operators*/
	/* + */
	li		t0, 43
	/* - */
	li		t1, 45
	/* x */
	li		t2, 120
	/* / */
	li		t3, 47
	/* % */
	li		t4, 37

	/*save a temp register to 0 so we can make sure we don't divide or modulo by zero */

	li		t5, 0

	/*if statements*/
	/*addition*/
	beq		s1, t0, addLabel
	/*subraction*/
	beq		s1, t1, subLabel
	/*multiplication*/
	beq		s1, t2, multLabel
	/*division*/
	beq		s1, t3, divLabel
	/*modulo*/
	beq		s1, t4, modLabel

	/*if no operator could be read, print an error*/
	la		a0, wrong_operator
	call	printf
	j		exit

too_many_arg:
	la		a0, not_enough_arg_print
	call	printf
	j		exit

not_enough_arg:
	la		a0, too_many_arg_print
	call	printf
	j		exit

addLabel:
	call	addition
	j		outputLabel

subLabel:
	call	subtraction
	j		outputLabel

multLabel:
	call	multiplication
	j		outputLabel

divLabel:
	beq		s3, t5, divLabelZero
	call	division
	j		outputLabel

modLabel:
	beq		s3, t5, modLabelZero
	call	modulo
	j		outputLabel

divLabelZero:
	ld		a1, 32(sp)
	ld		a2, 40(sp)
	ld		a3, 48(sp)
	li		a4, -1
	j		outputLabel

modLabelZero:
	ld		a1, 32(sp)
	ld		a2, 40(sp)
	ld		a3, 48(sp)
	li		a4, 0
	j		outputLabel

outputLabel:
	la		a0, output_print
	call	printf
	
exit:
	ld		ra, 0(sp)
	addi	sp, sp, 64
	ret
