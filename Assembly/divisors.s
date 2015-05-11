.data
message:	.asciiz		"Please enter a number between 1 and 289\n"
output:		.asciiz		" is exactly divisible by\n"
nl:		.asciiz		"\n"
input_error:	.asciiz		"The number entered is not between 1 and 289\n"

.text
_start:
main:		la	$a0, message			# print message for user
		li	$v0, 4
		syscall
		
		li	$v0, 5				# read user's input integer
		syscall
		
		li	$t0, 1
		blt	$v0, $t0, out_of_range
		li	$t0, 289
		bgt	$v0, $t0, out_of_range
		
		move	$t0, $v0			# from this point, $t0 will be the user's input integer
		move	$a0, $v0
		li	$v0, 1
		syscall
		
		la	$a0, output			# print the first line of output
		li	$v0, 4
		syscall
		
		li	$t1, 2				# divide user input by 2 and store the quotient
		div	$t0, $t1			# in $t6 (we will loop only till half)
		mflo	$t6
		
		li	$t1, 1				# $t1 is the current integer
		li	$t4, 0				# $t4 is 0 throughout the code
		
loop:		blt	$t6, $t1, exit			# loop till user's input is less than current integer
		sw	$t0, ($sp)			# push user's input in stack
		addi	$sp, $sp, 4			
		sw	$t1, ($sp)			# push current integer in stack
		addi	$sp, $sp, 4
		jal	divide				# call divide
		
		addi	$sp, $sp, -4			# pop return value
		lw	$t2, ($sp)
		bne	$t2, $t4, next			# print current integer if the return value is 0 (i.e. remainder is 0)
		move	$a0, $t1
		li	$v0, 1
		syscall
		la	$a0, nl				# print new line
		li	$v0, 4
		syscall
		
next:		addi	$t1,$t1, 1
		j	loop

divide:		addi	$sp, $sp, -4			# pop current integer from stack
		lw	$t2, ($sp)
		
		addi	$sp, $sp, -4			# pop user's input from stack
		lw	$t3, ($sp)
		
		sw	$ra, ($sp)			# push return address on stack
		addi	$sp, $sp, 4			
		
		div	$t3, $t2			# divide user's input by current integer
		
		addi	$sp, $sp, -4			# pop return address from stack
		lw	$t3, ($sp)
		
		mfhi	$t2				# the remainder is the return value
		sw	$t2, ($sp)			# push the return value on stack
		addi	$sp, $sp, 4
		
		jr	$t3				# jump to return address

		
exit:		move	$a0, $t0			# print the user input itself
		li	$v0, 1
		syscall
		
		la	$a0, nl				# print new line
		li	$v0, 4
		syscall
		
		li	$v0, 10				# exit
		syscall

out_of_range:	la	$a0, input_error		# if user input is out of range then
		li	$v0, 4				# tell inform the user
		syscall
		j	main				# prompt the user for input again
