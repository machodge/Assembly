.data
	arrStr: .asciiz "Array:"
	spaceStr: .asciiz " "
	newLineStr: .asciiz "\n"
	maxStr: .asciiz "The max was: "
	#arrSize is equivalent to 6
	arrSize: .eqv 6

.text
	# Make stack space for arr
	addi	$sp, $sp, -32

	# Put values into arr
	li	$t0, 4
	sw	$t0, 0($sp)
	li	$t0, 32
	sw	$t0, 4($sp)
	li	$t0, -18
	sw  $t0, 8($sp)
	li	$t0, 73($sp)
	sw	$t0, 12($sp)
	li	$t0, 9
	sw	$t0, 16($sp)
	li  $t0, 51
	sw	$t0, 20($sp)

	#call printFunc
	move $a0, $sp
	jal	printFunc

	#call findMax, deal with return values
	move $a0, $sp
	jal findMax
	
	#store the result of findMax
	sw	$v0, 24($sp)
	li $v0, 4
	la $a0, maxStr
	syscall

	li $v0, 1
	lw $a0, 24(sp)
	syscall

	#reset stack
	#Return from main
	j done

printFunc:

	addi $sp, $sp, -8
	#s0 contains array pointer, s1 contains i
	sw	$s0, 0($sp)
	sw	$s1, 4,($sp)

	move $s0, $a0

	li $v0, 4
	la $a0,	arrStr
	syscall
	
	li	$s1, 0
for1_1:
	la $t0, arrSize
	lw $t0, 0($t0)
	li	$t0, arrSize
	bge	$s1, $t0, for1_2

	#print the space
	li  $v0, 4
	la	$a0, spaceStr
	syscall

    #get arr[i], then print it
	li	$v0, 1
	lw	$a0, 0($s0)
	syscall

	#modify s0 and s1
	addi	$s0, $s0, 4
	addi	$s1, $s1, 1
	b for1_1

for1_2:

	li $v0, 4
	la $a0, newLineStr
	syscall

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra


findMax:
	#t0 = arr
	#t1 = i
	#t2 = arrSize
	#t3 = max
	#t4 = ar[i]

	move $t0, $a0
	li $t1, 0
	la $t2, arrSize
	lw $t2, 0($t2)
	li $t3, 0


for2_1:
	bge $t1, $t2, for2_2
	lw	$t4, 0($t0)
	ble $t4, $t3, if_false
	move $t3, $t4


if_false:
	addi $t0, $t0, 4
	addi $t1, t1, 1
	b for2_1

for2_2:
	move $v0, $t3
	jr $ra


done:
