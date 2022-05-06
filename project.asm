# CS 2640 Hangman Final Project
# Registers used:
# t0 - input
<<<<<<< HEAD
# t1 - general purpose iterator 
# s0 - used to hold game word
# s1 - used to hold array for printing
# s2 - used to check lose condition
# s3 - lives left (6 - one for each appendage) 
# t4 - boolean used to determine if lives are lost
# s2 - used to determine if they lost


.data
	game_word: .asciiz "beginner"
	incorrect: .byte 
	check_arr: .byte 0,0,0,0,0,0,0,0
	correct_byte: .byte 2
	life: .word 6
<<<<<<< HEAD
<<<<<<< HEAD
	lifecount: .asciiz "You have "
	lifecount2: .asciiz " lives left...\n"
	promptguess: .asciiz "\nEnter a character to guess in the string!\n"
=======
	promptguess: .asciiz "Enter a character to guess in the string!\n"
	winOutput: .asciiz "Congratulations! You guessed the word: "
	loseOutput: .asciiz "You failed to guess the word: "
>>>>>>> 91ff5282d533c354b80db3203f763554f6f45a39
	underscore: .byte 0x5F
    	enter_correct_char: .asciiz "\nPlease only enter lower case letters a-z\n"
    	newLine: "\n"
=======
# s0 - used to hold game word
# s1 - used to hold array for printing
# s2 - used to check lose condition
# s3 - handler for hangman display
# s4 - used to determine if they lost
# s5 - holds constant 1 because we frequently compare using it
# s6 - holds the end of the incorrect array for dynamic appending
# t4 - boolean used to determine if a guess was in the word.



.data
	game_word: .asciiz "gaming"
	incorrect: .space 26
	check_arr: .space 15
	correct_byte: .byte 2
	life: .word 6
	promptguess: .asciiz "Enter a character to guess in the string!\n"
	winOutput: .asciiz "Congratulations! You guessed the word: "
	loseOutput: .asciiz "You failed to guess the word: "
	underscore: .byte 0x5F
    	enter_correct_char: .asciiz "\nPlease only enter lower case letters a-z\n"
    	newLine: .asciiz "\n"
    	space: .asciiz " "
    	letterbank: .asciiz "Letters Guessed: "	
>>>>>>> 7b33bcca69dcfdf6624a7b462a279d44ca7c3adf
=======
	promptguess: .asciiz "Enter a character to guess in the string!\n"
	winOutput: .asciiz "Congratulations! You guessed the word: "
	loseOutput: .asciiz "You failed to guess the word: "
	underscore: .byte 0x5F
    	enter_correct_char: .asciiz "\nPlease only enter lower case letters a-z\n"
    	newLine: "\n"
>>>>>>> master
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
	#loads game word, loads the parallel boolean array, and loads life init
	la $s0 game_word
	
	la $s1, check_arr
	
	la $s3, display_array
	
	#loads wrong boolean, lose condition, and loop break variable
	li $t4, 1
	
	lw $s2, 24($s3)
	
	li $s4, 2
	
	#1 is a constant we will check frequentl
	li $s5, 1
<<<<<<< HEAD
<<<<<<< HEAD

=======
	
	la $s6, incorrect

	jal createBoolArray
	
>>>>>>> 7b33bcca69dcfdf6624a7b462a279d44ca7c3adf
	game_loop:

		jal print
	
=======

	game_loop:

		jal print
	
>>>>>>> master
		lw $t6, ($s3)
		jal check_WinCon
		beq $s4, $zero, exit_game_loop
		beq $s4, $s5, exit_game_loop
	
		jal prompt_Input
	
		jal check_Correct
<<<<<<< HEAD
<<<<<<< HEAD
	
		j game_loop
=======
	
		j game_loop
#------------------------------------------------------------------------------------------------
createBoolArray:
	#load byte, if its not null termianted, enter loop
	lb $t0, ($s0)
	beqz $t0, exitBoolArr
	#push a zero into check_arr for each character in the string
	sb $zero, ($s1)
	#increment both addresses
	addi $s1,$s1, 1
	addi $s0, $s0, 1
	j createBoolArray
	
	
exitBoolArr:
	la $s0, game_word
	la $s1, check_arr
	jr $ra
#------------------------------------------------------------------------------------------------
>>>>>>> 7b33bcca69dcfdf6624a7b462a279d44ca7c3adf
=======
	
		j game_loop
>>>>>>> master
exit_game_loop:
	bne $s4, $zero, didNotWin # Skip over the win output if they did not win
	#output the win condition
	la $a0, winOutput
<<<<<<< HEAD
<<<<<<< HEAD
	li $v0, 4
	syscall
	#output the word
	la $a0, game_word
	li $v0, 4
	syscall
	didNotWin: # Jumps over win condition
	bne $s4, $s5, didNotLose # Skip over the lose output if they did not lose
	#output the lose condition
	la $a0, loseOutput
	li $v0, 4
	syscall
	#output the word
	la $a0, game_word
	li $v0, 4
	syscall
	didNotLose: # Jumps over lose condition
	j exit  # This will end the code



check_WinCon:
	#if they are on the last hangman, lose
	beq $s2, $t6, lost
	#use the string to loop. Load each byte simultaneously
	lb $t6, ($s1)
	lb $t7, ($s0)
	#if they reach the end of the string and havent exited, they win
	beqz $t7, won
	#if any byte of the string is undiscovered (zero), then continue with the game
	beqz $t6, leave
	#iterate both arrays
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j check_WinCon
leave:
	#reset addresses, and continue
	la $s1, check_arr
	la $s0, game_word
	jr $ra
#0 means won and will exit in main
won:
	move $s4, $zero
	jr $ra
#1 means lost and will exit in main
lost:
	move $s4, $s5
	jr $ra
#------------------------------------------------------------------------------------------------
print:
	#prints the status of the hangman
	lw $a0, ($s3)
	li $v0, 4
	syscall
	
=======
	li $v0, 4
	syscall
	#output the word
	move $a0, $s0
	li $v0, 4
	syscall
didNotWin: 
	# Jumps over win condition
	bne $s4, $s5, didNotLose # Skip over the lose output if they did not lose
	#output the lose condition
	la $a0, loseOutput
	li $v0, 4
	syscall
	#output the word
	move $a0, $s0
	li $v0, 4
	syscall
didNotLose: 
	# Jumps over lose condition
	j exit  # This will end the code
#------------------------------------------------------------------------------------------------
check_WinCon:
	#if they are on the last hangman, lose
	beq $s2, $t6, lost
	#use the string to loop. Load each byte simultaneously
	lb $t6, ($s1)
	lb $t7, ($s0)
	#if they reach the end of the string and havent exited, they win
	beqz $t7, won
	#if any byte of the string is undiscovered (zero), then continue with the game
	beqz $t6, leave
	#iterate both arrays
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j check_WinCon
leave:
	#reset addresses, and continue
	la $s1, check_arr
	la $s0, game_word
	jr $ra
#0 means won and will exit in main
won:
	move $s4, $zero
	jr $ra
#1 means lost and will exit in main
lost:
	move $s4, $s5
	jr $ra
#------------------------------------------------------------------------------------------------
print:
	#prints the status of the hangman
	lw $a0, ($s3)
	li $v0, 4
	syscall

wordBankDisplay:
	#display word bank
	la $a0, letterbank
	li $v0, 4
	syscall
	
	la $t0, incorrect
wordBankLoop:
	# load the next byte, if its not null terminated, enter loop
	lb $t6, ($t0)
	beqz $t6, bankdone
	
	#print the character
	move $a0, $t6
	li $v0, 11
	syscall
	
	#space for easy reading
	la $a0, space
	li $v0, 4
	syscall
	
	#iterate through array, loop
	addi $t0, $t0, 1
	j wordBankLoop

bankdone:
	#newline for rest of text
	la $a0, newLine
	li $v0, 4
	syscall
>>>>>>> 7b33bcca69dcfdf6624a7b462a279d44ca7c3adf
=======
	li $v0, 4
	syscall
	#output the word
	la $a0, game_word
	li $v0, 4
	syscall
	didNotWin: # Jumps over win condition
	bne $s4, $s5, didNotLose # Skip over the lose output if they did not lose
	#output the lose condition
	la $a0, loseOutput
	li $v0, 4
	syscall
	#output the word
	la $a0, game_word
	li $v0, 4
	syscall
	didNotLose: # Jumps over lose condition
	j exit  # This will end the code



check_WinCon:
	#if they are on the last hangman, lose
	beq $s2, $t6, lost
	#use the string to loop. Load each byte simultaneously
	lb $t6, ($s1)
	lb $t7, ($s0)
	#if they reach the end of the string and havent exited, they win
	beqz $t7, won
	#if any byte of the string is undiscovered (zero), then continue with the game
	beqz $t6, leave
	#iterate both arrays
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j check_WinCon
leave:
	#reset addresses, and continue
	la $s1, check_arr
	la $s0, game_word
	jr $ra
#0 means won and will exit in main
won:
	move $s4, $zero
	jr $ra
#1 means lost and will exit in main
lost:
	move $s4, $s5
	jr $ra
#------------------------------------------------------------------------------------------------
print:
	#prints the status of the hangman
	lw $a0, ($s3)
	li $v0, 4
	syscall
	
>>>>>>> master
printloop:
	#loads the next letter of the word, and if its not the end of the string, continue
	lb $a0, ($s0)
	beqz $a0, extprint
	
	#loads the byte of the parallel array
	lb $t6, ($s1)
	
	#if the byte of the parallel array isn't 0, display the character, else jump to neq
	beqz $t6, neq
	
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
	#iterate both parallel arrays
	addi $s0, $s0, 1
	addi $s1, $s1, 1
<<<<<<< HEAD
<<<<<<< HEAD
=======
	la $a0, space
	li $v0, 4
	syscall
>>>>>>> 7b33bcca69dcfdf6624a7b462a279d44ca7c3adf
=======
>>>>>>> master
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    la $a0, promptguess
    li $v0, 4
    syscall
    li $v0, 12 # read in user input
    syscall
    move $t0, $v0
    blt $t0, 0x61, incorrect_input
    bgt $t0, 0x7a, incorrect_input
    jr $ra
=======
=======
>>>>>>> 7b33bcca69dcfdf6624a7b462a279d44ca7c3adf
=======
>>>>>>> master
	#prompt the user input
	la $a0, promptguess
	li $v0, 4
	syscall
	#read the user input
	li $v0, 12 
	syscall
	move $t0, $v0
	
	#if the user input is not within ascii bounds of a lower case alpha character, jump to incorrect input
	blt $t0, 0x61, incorrect_input
	bgt $t0, 0x7a, incorrect_input
	#if they input correctly, return their input\
	la $a0, newLine
	li $v0, 4
	syscall
<<<<<<< HEAD
<<<<<<< HEAD
	jr $ra
>>>>>>> 91ff5282d533c354b80db3203f763554f6f45a39
=======
	#add it to the letterbank
	sb $t0, ($s6)
	addi $s6, $s6, 1
	jr $ra
>>>>>>> 7b33bcca69dcfdf6624a7b462a279d44ca7c3adf
=======
	jr $ra
>>>>>>> master

incorrect_input:
	#display an error message, and tell them to input correctly.
	la $a0, enter_correct_char
	li $v0, 4
	syscall
	j prompt_Input
#------------------------------------------------------------------------------------------------

check_Correct:
	#load the byte of the word
	lb $t6, ($s0)
	#if its the end of the word, leave
	beqz $t6, exitCheckCorrect
	#if the current byte matches user input, update parallel array
	beq $t6, $t0, updateArr
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j check_Correct
updateArr:
	#load 0 to t4 so we know that they dont lose a life
	li $t4, 0
	#store 1 into the array to indicate they got that letter right for print function
	sb $s5, ($s1)
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	#continue traversing array because of potential duplicate characters
	j check_Correct
	
exitCheckCorrect:
	#if they didnt lose a life, then dont increment lives
	beqz $t4, returnTrue
	addi $s3, $s3, 4
	
returnTrue:
	#reset all variables before leaving
	la $s0, game_word
	la $s1, check_arr
	li $t4, 1
	jr $ra
	
#------------------------------------------------------------------------------------------------
exit:
	li $v0, 10
	syscall
