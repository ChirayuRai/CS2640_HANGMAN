# CS 2640 Hangman Final Project
# Registers used:
# t0 - input
# t1 - general purpose iterator 
# t2 - Size of word (globally 5 for now)
# t3 - lives left (6 - one for each appendage) 


.data
	game_word: .asciiz "rosey"
	incorrect: .byte 
	check_arr: .byte 0,0,0,0,0
	size: .word 5
	life: .word 6
	
.text
main:
	la $s0 game_word
	
	la $t2, size
	lw $t2, ($t2)
	
	la $s1, check_arr
	
	la $t3, life
	lw $t3, ($t3)

game_loop:
	jal print
	
	jal prompt_Input
	
	jal check_Correct
	
	j game_loop
	
	j exit
	
print:

	
prompt_Input:

check_Correct:

exit:
	li $v0, 10
	syscall
