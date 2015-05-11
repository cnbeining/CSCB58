.data
head:			.word		0		# address of head node
message:		.asciiz		"Please Enter a String\n"
empty:			.asciiz		"\n"
arrow:			.asciiz		"|\n"

.text
_start:
main:		li	$a0, 8			# 2 word (8 bytes) for the head node
		li	$v0, 9			# allocate 8 bytes
		syscall
		
		sw	$v0, head		# store address of head node in head
		
		la	$a0, message		# display message for user to input
		li	$v0, 4			# a string
		syscall
		
		li	$a0, 2048			# create a new 60 bytes buffer
		li	$v0, 9			# for user input
		syscall
		
		move	$a0, $v0		# move memory address of buffer to $a0
		li	$a1, 2048			# load size of buffer in $a1
		li	$v0, 8			# read string from user
		syscall
		
		la	$t4, empty
		lb	$t4, ($t4)		# $t4 is \n
		lb	$t5, ($a0)		# $t5 is the first byte of the string

		beq	$t4, $t5, exit
		
		lw	$t0, head		# load head node's address in reg $t0
		sw	$a0, ($t0)		# store the address of buffer in head node
		
		
get_string:	la	$a0, message
		li	$v0, 4
		syscall
		li	$a0, 8			# 2 word (8 bytes) for the node	
		li	$v0, 9			# allocate 8 bytes
		syscall
		
		move	$t1, $v0		# store address of new node in $t1
		
		li	$a0, 2048		# create a new 60 bytes buffer
		li	$v0, 9			# for user input
		syscall
		
		move	$a0, $v0		# move memory address of buffer to $a0
		li	$a1, 2048		# load size of buffer in $a1
		li	$v0, 8			# read string from user
		syscall
		
		move	$t2, $a0		# $t2 has the address of the string buffer
		
		la	$t4, empty		# $t4 has address of empty

		lb	$t4, ($t4)		# $t4 will now have byte value of \n
		lb	$t5, ($a0)		# $t5 will now have byte value of first char in string
		
		beq	$t4, $t5, print		# if user input is \n then jump to print
		
		sw	$a0, ($t1)		# store the address of string buffer in node
		
		lw	$t3, 4($t0)		# load head node's next in $t3
		sw	$t3, 4($t1)		# make new node's next as head node's next
		sw	$t1, 4($t0)		# make head node's next as the new node
		
		j	get_string
		
print:		lw	$a0, ($t0)
		li	$v0, 4
		syscall
		la	$a0, arrow
		li	$v0, 4
		syscall
		
		lw	$t1, 4($t0)
		sw	$t1, head
		lw	$t0, head
		li	$t1, 0
		bne	$t0, $t1, print
		
exit:		li	$v0, 10
		syscall



















