.data
message:	.asciiz		"Please enter an integer between 0 and 25:\n"
head:		.word		0
separator:	.asciiz		": "
nl:		.asciiz		"\n"

input_error:	.asciiz		"The integer entered is not between 0 and 25\n"

.text
_start:
main:		la	$a0, message		# prompt the user for input
		li 	$v0, 4
		syscall
		
		li	$t5, 0			# $t5 contains 0 throughout the code
		li	$a3, 25			# $a3 will have 25 to check if user inputs integer greater than 25
		
		li	$v0, 5			# get integer from user
		syscall
		
		blt	$v0, $t5, h_outofrange	# if user inputs an integer less than 0
		bgt	$v0, $a3, h_outofrange	# if user inputs an integer greater than 25
		
		move	$t1, $v0		# $t1 has the user unput		
		
		li	$a0, 8			# 1 byte interger, 1 byte counter of integer
		li	$v0, 9			# and 4 bytes for address of next node
		syscall
		
		sw	$v0, head		# store address of head node in head
		lw	$t0, head
				
		sb 	$t1, ($t0)		# store the user input in the head node
		
		li	$t3, 1			
		sb	$t3, 1($t0)		# set the counter of the integer as 1
		
		li	$t7, 0			# counter of number of user inputs
		
		
get_integer:	addi	$t7, $t7, 1
		li	$t1, 10
		beq	$t1, $t7, end_loop
		
		la	$a0, message		# prompt the user for input
		li	$v0, 4
		syscall
		
		li	$v0, 5			# get integer from user
		syscall
		
		bgt	$v0, $a3, out_of_range	# if the user inputs integer greater than 25
		blt	$v0, $t5, out_of_range	# if the user inputs integer less than 0
		
		move	$t0, $v0		# $t0 now has the user input
		lw	$t1, head		# $t1 has the address of head node
		li	$t6, 0			# $t6 is previous node's pointer

find_node:	lb	$t2, ($t1)		# $t2 has the integer at current node
		beq	$t0, $t2, add_counter	# if user input is same as integer at this node, then add 1 to it's counter
		bgt	$t2, $t0, add_node	# if current node's integer is greater than users integer then 
						# add a new node between the previous node and current node
		
		move	$t6, $t1		# make current node, previous node
		lw	$t1, 4($t6)		# make previous node's next node as current node
		
		beq	$t1, $t5, add_tail	# if we reach the end of linked list then add new node as a tail
		
		j	find_node
		

end_loop:	lw	$t0, head		# $t0 will be current node's address

print:		lb	$a0, ($t0)		# print the current node's integer
		li	$v0, 1
		syscall
		
		la	$a0, separator		# print ": "
		li	$v0, 4
		syscall
		
		lb	$a0, 1($t0)		# print the current node's counter
		li	$v0, 1
		syscall
		
		la	$a0, nl			# print new line
		li	$v0, 4
		syscall
		
		lw	$t0, 4($t0)		# make current node's next node as current node
		beq	$t0, $t5, exit
		j	print
		
		
exit:		li	$v0, 10
		syscall


add_counter:	lb	$t3, 1($t1)		# add 1 to the counter of this node since the
		addi	$t3, $t3, 1		# integer at this node appeared again
		sb	$t3, 1($t1)
		j	get_integer
		
add_node:	li	$a0, 8			# create a new node
		li	$v0, 9
		syscall
		
		sb	$t0, ($v0)		# store the user input in the new node's 1st byte
		li	$t3, 1			
		sb	$t3, 1($v0)		# set the counter of new node to 1
		beq	$t6, $t5, make_head	# if inserting at the start of linked list, then make it the head node
		
		lw	$t3, 4($t6)		# make previous node's next node as new node's next node
		sw	$t3, 4($v0)
		
		sw	$v0, 4($t6)		# make previous node's next node as new node
		j	get_integer

make_head:	sw	$t1, 4($v0)		# make new node's next as head node
		sw	$v0, head		# make new node as head node
		j	get_integer

add_tail:	li	$a0, 8			# create a new node
		li	$v0, 9
		syscall
		
		sb	$t0, ($v0)		# store user input in the node
		li	$t3, 1
		sb	$t3, 1($v0)		# make the counter as 1
		
		sw	$v0, 4($t6)		# make previous node's next node as the new node
		j	get_integer

out_of_range:	la	$a0, input_error	# tell the user that the number is out of range
		li	$v0, 4
		syscall
		addi	$t7, $t7, -1		# decrement $t7 which is counter for number of integers
		j	get_integer

h_outofrange:	la	$a0, input_error
		li	$v0, 4
		syscall
		j	main
