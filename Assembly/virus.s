# A simple virus starter 
	.data
play_nice:	.asciiz		"I am a nice white sheep\n"
eat_grass:	.asciiz		"Just eating some nice grass.\n"
virus_text:	.asciiz		"And I am a black sheep - baahhh!\n"
virus_damage:	.asciiz		"Your partition table is gone!\n"
nl:		.asciiz		"\n"

	.text
# You can add more virus code here. You should not need a lot, but
# perhaps a few instructions are needed? surely? (hint!)
# Whatever you do: *DO NOT* modify virus_payload or white_sheep

virus_payload:		# This is the part of the virus that does damage!
	la $a0, virus_text
	li $v0, 4
	syscall
	la $a0, virus_damage
	li $v0, 4
	syscall
	jr $ra

white_sheep:		# This is our poor, innocent target program
	la $a0, play_nice
	li $v0, 4
	syscall
	la $a0, eat_grass
	li $v0, 4
	syscall
	li $v0, 10
ending:	syscall

run_virus:
	jal virus_payload	# call virus_payload
	sw $t7, ($t2)		# change the first instruction of white_sheep back to the original first instruction
	j white_sheep		# jump to white_sheep

run_run_virus:
	j run_virus		# jump to run_virus

main:				# Here you must add your virus installer
				# Do what you must to cause your virus to be
				# executed when we call white_sheep. Note that
				# white sheep's code must run!
				# * YOU CAN NOT CALL the virus code from here *
				# * And you can not call white_sheep as a subroutine *
				# from here either.

	la $t0, run_run_virus	# get the address of run_run_virus
	lw $t1, ($t0)		# $t1 has the first instruction of run_run_virus
	la $t2, white_sheep	# get the address of white_sheep
	lw $t7, ($t2)		# $t7 has the original first instruction of white_sheep
	sw $t1, ($t2)		# change the first instruction of white_sheep to first instruction of run_run_virus

	b white_sheep		# This line MUST BE EXECUTED. Your virus has
				# to run when we branch to white_sheep
# End
