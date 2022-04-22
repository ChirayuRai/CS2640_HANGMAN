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
	lifecount: .asciiz "You have "
	lifecount2: .asciiz " lives left...\n"
	promptguess: .asciiz "Enter a character to guess in the string!\n"
	underscore: .byte 0x5F
    enter_correct_char: .asciiz "\nPlease only enter lower case letters a-z\n"
    newLine: "\n"
	
.text
main:
	la $s0 game_word
	
	la $s1, check_arr
	
	la $t3, life
	lw $t3, ($t3)

game_loop:
	jal print
	
	jal prompt_Input
	
	jal check_Correct
	
	j exit
	
print:
	la $a0, lifecount
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	la $a0, lifecount2
	li $v0, 4
	syscall
	
	li $t1, 0
printloop:
	lb $a0, ($s0)
	beqz $a0, extprint
	lb $t6, ($s1) #t6 has parallel boolean
	
	beq $t6, $zero, neq
	
	li $v0, 11
	syscall
	j post_print_else
neq:
	la $a0, underscore
	lb $a0, ($a0)
	li $v0, 11
	syscall
post_print_else:

	addi $s0, $s0, 1
	addi $s1, $s1, 1
	addi $t1, $t1, 1
	j printloop
	
extprint:
	la $s0, game_word
	la $s1, check_arr
	jr $ra
	
prompt_Input:
    li $v0, 12 # read in user input
    syscall
    move $t0, $v0
    blt $t0, 0x61, incorrect_input
    bgt $t0, 0x7a, incorrect_input
    jr $ra

incorrect_input:
    la $a0, enter_correct_char
    li $v0, 4
    syscall
    j prompt_Input
    

check_Correct:

exit:
	li $v0, 10
	syscall

