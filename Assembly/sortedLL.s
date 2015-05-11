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
		
		li	$a0, 2048		# create a new 60 bytes buffer
		li	$v0, 9			# for user input
		syscall
		
		move	$a0, $v0		# move memory address of buffer to $a0
		li	$a1, 2048		# load size of buffer in $a1
		li	$v0, 8			# read string from user
		syscall
		
		la	$t4, empty
		lb	$t4, ($t4)		# $t4 is \n
		lb	$t5, ($a0)		# $t5 is the first byte of user string
		beq	$t4, $t5, exit
		
		lw	$t0, head		# load head node's address in reg $t0
		sw	$a0, ($t0)		# store the address of buffer in head node
		
		li	$t7, 1			# swapping boolean in bubble_sort
		
		
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
		
		beq	$t4, $t5, bubble_sort	# if user input is \n then jump to print
		
		sw	$a0, ($t1)		# store the address of string buffer in node
		
		lw	$t3, 4($t0)		# load head node's next in $t3
		sw	$t3, 4($t1)		# make new node's next as head node's next
		sw	$t1, 4($t0)		# make head node's next as the new node
		
		j	get_string
		

bubble_sort:	lw	$t1, head		# $t1 is set to the address of head node
		li	$t6, 0
		beq	$t6, $t7, print		# if there was no swap at all then go to print ($t7 initialized to 1 on top ^)
		li	$t7, 0			# $t7 is the swap boolean set to 0 every time before starting the inner loop
		
inner_loop:	lw	$t2, 4($t1)		# $t2 has the address of the next node
		
		lw	$t3, ($t1)		# $t3 has the address of string at current node
		lb	$t4, ($t3)		# $t4 has the first letter of current node
		
		li	$t6, 0
		beq	$t6, $t2, bubble_sort	# if pointer of next node is nil, then go to bubble_sort
		
		lw	$t5, ($t2)		# $t5 has the address of the next node's string
		lb	$t6, ($t5)		# $t6 has the first letter of next node
		
		ble	$t4, $t6, after_swap	# if letter in $t2 < letter in $t3, then go to after_swap
		
		sw	$t5, ($t1)		# make current node's next as next node's next
		sw	$t3, ($t2)		# make next node's next as current node's next
		li	$t7, 1
		
after_swap:	lw	$t1, 4($t1)		# make $t1 the address of to the next node
		li	$t2, 0
		bne	$t1, $t2, inner_loop	# go to next iteration of inner loop if next node is not 0
		
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




