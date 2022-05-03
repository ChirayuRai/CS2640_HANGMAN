# CS 2640 Hangman Final Project
# Registers used:
# t0 - input
# t1 - general purpose iterator 
# t2 - Size of word (globally 5 for now)
# t3 - lives left (6 - one for each appendage) 


.data
	game_word: .asciiz "rosey"
	incorrect: .byte 
	check_arr: .byte 1,1,0,0,1
	life: .word 6
	promptguess: .asciiz "Enter a character to guess in the string!\n"
	underscore: .byte 0x5F
    	enter_correct_char: .asciiz "\nPlease only enter lower case letters a-z\n"
    	newLine: "\n"
    	hang1: .asciiz "  +---+\n  |   |\n      |\n      |\n      |\n      |\n=========\n"
    	hang2: .asciiz "  +---+\n  |   |\n  O   |\n      |\n      |\n      |\n=========\n"
    	hang3: .asciiz "  +---+\n  |   |\n  O   |\n  |   |\n      |\n      |\n=========\n"
    	hang4: .asciiz "  +---+\n  |   |\n  O   |\n /|   |\n      |\n      |\n=========\n"
    	hang5: .asciiz "  +---+\n  |   |\n  O   |\n /|\\  |\n      |\n      |\n=========\n"
    	hang6: .asciiz "  +---+\n  |   |\n  O   |\n /|\\  |\n /    |\n      |\n=========\n"
    	hang7: .asciiz "  +---+\n  |   |\n  O   |\n /|\\  |\n / \\  |\n      |\n=========\n"
    	display_array: .word hang1, hang2, hang3, hang4, hang5, hang6, hang7

.text
main:
	#loads game word, loads the parallel boolean array, and loads the # of lives
	la $s0 game_word
	
	la $s1, check_arr
	
	la $t3, display_array

game_loop:
	jal print
	
	jal prompt_Input
	
	jal check_Correct
	
	j game_loop
	
#------------------------------------------------------------------------------------------------
print:
	#prints the status of the hangman
	lw $a0, ($t3)
	li $v0, 4
	syscall
	

	#starts the print loop to print based off of parallel array
	li $t1, 0
printloop:
	#loads the next letter of the word, and if its not the end of the string, continue
	lb $a0, ($s0)
	beqz $a0, extprint
	
	#loads the byte of the parallel array
	lb $t6, ($s1)
	
	#if the byte of the parallel array isn't 0, display the character, else jump to neq
	beq $t6, $zero, neq
	
	li $v0, 11
	syscall
	j post_print_else
	
neq:
	#if the byte was 0, display an underscore instead 
	la $a0, underscore
	lb $a0, ($a0)
	li $v0, 11
	syscall
post_print_else:
	#iterate both parallel arrays, and iterator and continue
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	addi $t1, $t1, 1
	j printloop
	
extprint:
	#reset our array back to the base address and return
	la $s0, game_word
	la $s1, check_arr
	la $a0, newLine
	li $v0, 4
	syscall
	jr $ra
#------------------------------------------------------------------------------------------------
	
prompt_Input:
	#read the user input
	li $v0, 12 
	syscall
	move $t0, $v0
	
	#if the user input is not within ascii bounds of a lower case alpha character, jump to incorrect input
	blt $t0, 0x61, incorrect_input
	bgt $t0, 0x7a, incorrect_input
	#if they input correctly, return their input
	jr $ra

incorrect_input:
	#display an error message, and tell them to input correctly.
	la $a0, enter_correct_char
	li $v0, 4
	syscall
	j prompt_Input
#------------------------------------------------------------------------------------------------

check_Correct:


#------------------------------------------------------------------------------------------------

exit:
	li $v0, 10
	syscall
