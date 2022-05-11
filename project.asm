# CS 2640 Hangman Final Project
# Registers used:
# t0 - input
# s0 - used to hold game word
# s1 - used to hold array for printing
# s2 - used to check lose condition
# s3 - handler for hangman display
# s4 - used to determine if they lost
# s5 - holds constant 1 because we frequently compare using it
# s6 - holds the end of the incorrect array for dynamic appending
# s7 - holds starting address of word
# t4 - boolean used to determine if a guess was in the word.

# YOU MUST MANUALLY CHANGE THE FILE PATH IN ORDER FOR IT WORK FULLY
# ON MAC YOU MUST PASTE THE FULL PATH, AND IT CANNOT BE ON YOUR ACTUAL HARDDRIVE
# ON WINDOWS IT CAN BE ON YOUR HARDDRIVE, BUT MAKE SURE TO USE THE FULL PATH AND \\ FOR EACH \\



.data
	myFile: .asciiz "/Users/chirayur/OneDrive - Cal Poly Pomona/College/All semesters/Spring 2022/CS2640/CS2640_HANGMAN/WordBank.txt"
	buffer: .space 40607 # bytes in the wordbank file
	game_word: .space 15
	letterBank: .space 26
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
    	letterbank: .asciiz "Incorrect Guesses: "	
    	hang1: .asciiz "  +---+\n  |   |\n      |\n      |\n      |\n      |\n=========\n"
    	hang2: .asciiz "  +---+\n  |   |\n  O   |\n      |\n      |\n      |\n=========\n"
    	hang3: .asciiz "  +---+\n  |   |\n  O   |\n  |   |\n      |\n      |\n=========\n"
    	hang4: .asciiz "  +---+\n  |   |\n  O   |\n /|   |\n      |\n      |\n=========\n"
    	hang5: .asciiz "  +---+\n  |   |\n  O   |\n /|\\  |\n      |\n      |\n=========\n"
    	hang6: .asciiz "  +---+\n  |   |\n  O   |\n /|\\  |\n /    |\n      |\n=========\n"
    	hang7: .asciiz "  +---+\n  |   |\n  O   |\n /|\\  |\n / \\  |\n      |\n=========\n"
    	display_array: .word hang1, hang2, hang3, hang4, hang5, hang6, hang7
    	repeat_message: .asciiz "\nYou have already entered this character. Please try entering a new one instead!\n"

.text
main:
	#loads game word, loads the parallel boolean array, and loads life init
	jal findWord
	
	la $s1, check_arr
	
	la $s3, display_array
	
	#loads wrong boolean, lose condition, and loop break variable
	li $t4, 1
	
	lw $s2, 24($s3)
	
	li $s4, 2
	
	#1 is a constant we will check frequentl
	li $s5, 1
	
	la $s6, letterBank

	jal createBoolArray
	
	game_loop:

		jal print
	
		lw $t6, ($s3)
		jal check_WinCon
		beq $s4, $zero, exit_game_loop
		beq $s4, $s5, exit_game_loop
	
		jal prompt_Input
	
		jal check_Correct
	
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
exit_game_loop:
	bne $s4, $zero, didNotWin # Skip over the win output if they did not win
	#output the win condition
	la $a0, winOutput
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
	
	la $t0, letterBank
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
	la $a0, space
	li $v0, 4
	syscall
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
	
	# If their input is within the word bank, tell them to try again
	la $t6, letterBank
check_repeat:
	# Start iterating through the array
	lb $t7, ($t6)
		
	# If at end of letterBank, then continue game
	beqz $t7, continue
		
	# If current index of letterBank is equal to user input, then tell yell at them
	beq $t7, $t0, print_repeat_message
		
	# Iterate letterBank array, loop
	addi $t6, $t6, 1
	j check_repeat
	
	continue:
	#if they input correctly, return their input
	la $a0, newLine
	li $v0, 4
	syscall
	sb $t0, ($s6)
	addi $s6, $s6, 1
	jr $ra

incorrect_input:
	#display an error message, and tell them to input correctly.
	la $a0, enter_correct_char
	li $v0, 4
	syscall
	j prompt_Input
print_repeat_message:
	la $a0, repeat_message
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
findWord:
    #syscall for opening a file
    li $v0, 13 
    la $a0, myFile 
    li $a1, 0 
    li $a2, 0
    syscall 
    move $t1, $v0
    
    # reading from file just opened
    move $a0, $t1
    la   $a1, buffer
    li   $a2,  80
    li $v0, 14
    syscall

    # Printing File Content
    la $t2, buffer
    la $s0, game_word
    
findFile:
    lb $t0, ($t2)
    beq $t0, 49, getRandomNum
    sb $t0, ($s0)
    addi $s0, $s0, 1
    addi $t2, $t2, 1
    j findFile
getRandomNum:
    li $a1, 100
    li $v0, 42
    syscall
    li $t3, 0
    sb $t3, ($s0)
    blt $a0, 30, wordCorrect
    addi $t2, $t2, 1
    la $s0, game_word
    j findFile

wordCorrect:
    la $s0, game_word
    #close the file 
    li $v0, 16
    move $a0, $t1 
    syscall
    jr $ra
exit:
	li $v0, 10
	syscall
