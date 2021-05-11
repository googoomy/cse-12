####################################################################################################################
# Created by:	 Gu, James
#	 jjgu
#	 11 May, 2021
#
# Assignment:	 Lab 3: ASCII-risks (Asterisks)
#	 CSE 12/12L, Computer systems and Assembly Language
#	 UC Santa Cruz, Spring 2021
#
# Description: This program prints out a triangle made up of numbers, asterisks, and tabs with the height of
#	 whatever number the user inputs.
#
# Notes: 	 This program is intended to be ran from MARS IDE.
####################################################################################################################
# My Pseudocode:
# Step 1: Ask user for an integer greater than 0
# Step 2: If that integer is not greater than 0 go back to Step 1. If that integer is greater than 0 go to Step 3.
# Step 3: Set height to user's integer
# Step 4: Set counter to 1
# Step 5: Set randomVariable to height
# Step 6: Do Step 7 to Step 17 height times:
# Step 7: Print a tab randomVariable minus counter times
# Step 8: Print counter
# Step 9: if the counter is not 1 go to Step 13. If counter is 1 go to Step 9.
# Step 10: print a tab.
# Step 11: print an asterisk and a tab for counter minus 1 times
# Step 12: add 1 to the counter
# Step 13: print counter
# Step 14: Go to next line
# Step 15: add 1 to the counter
# Step 16: Print counter
# Step 17: subtract 1 from randomVariable


.data

enterHeightPrompt: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
invalidInput: .asciiz "Invalid Entry!\n"

.text
userInput:
li $v0 4			#Prep to prompt the user with the enterHeightPrompt
la $a0 enterHeightPrompt		#Put address of string into $a0
syscall			#print

li $v0 5			#prep to get user's height
syscall			#prompt

move $t0 $v0			#store result in $t0
blez $t0 branchInvalid		#check if user input is a valid value
j triangle			#jump to the actual code

branchInvalid:
li $v0 4			#Prep to print invalidInput message
la $a0 invalidInput		#Put address of string into $a0
syscall			#print
j userInput			#restart at beginning because of invalid input

triangle:
li $t1 1			#$t1 will be the counter but also the numbers along the triangle
la $t2 ($t0)			#$t2 is set to the user's inputted height of the triangle and will be the height loop counter
li $t3 1			#$t3 is my subtraction variable when I want to subtract 1
li $t6 0			#$t6 is my exit variable for loopHeightTimes


loopHeightTimes:
beq $t6 $t2 exitHeightLoop		#exit height loop if exit variable is equal to $t2

li $t7 1			#$t7 is the counter for beginning tabs loop
loopPrintBeginningTabs:
sub $t4 $t2 $t6		#Set $t4 equal to the value of $t2 minus $t6
beq $t7 $t4 exitBeginningTabLoop	#Exit Loop if $t7 is equal to $t4
li $v0 11			#prep to print tab
la $a0 9			#put the decimal value of tab in the ascii table into $a0
syscall			# print tab
addi $t7 $t7 1		#add one to the counter
j loopPrintBeginningTabs		#loop back

exitBeginningTabLoop:
li $v0 1			#prep to print
la $a0 ($t1)			#put the value of $t1 into $a0
syscall			# print the counter number

#in between:
bne $t1 $t3 printOneTab		#if the counter number is not equal to 1 then go to print one tab
j skipInBetween		#if the counter number is 1 jump to rest of code
printOneTab:
li $v0 11			#prep to print tab
la $a0 9			#put the decimal value of tab in the ascii table into $a0
syscall			# print tab

li $s0 0			#Set $s0 to 0. It is the counter for the printing asterisks loop
loopPrintAsterisks:
sub $t5 $t1 $t3		#Set the value of $t5 to the value of $t1 minus $t3
beq $s0 $t5 exitAsterisksLoop	#If the counter $s0 is equal to $t5
li $v0 11			#prep to print tab
la $a0 42			#put the decimal value of asterisk in the ascii table into $a0
syscall			# print asterick
li $v0 11			#prep to print tab
la $a0 9			#put the decimal value of tab in the ascii table into $a0
syscall			# print tab
addi $s0 $s0 1		#increment the counter by one
j loopPrintAsterisks		#jump back to continue the loop

exitAsterisksLoop:
addi $t1 $t1 1		#increment the counter number by one
li $v0 1			#prep to print the counter number
la $a0 ($t1)			#put the value of the counter number into $a0
syscall			# print counter number


skipInBetween:
addi $t1 $t1 1		#add one to the counter number

li $v0 11			#prep to print new line
la $a0 10			#put the decimal value of new line in the ascii table into $a0
syscall			#print new line

addi $t6 $t6 1		#increment the height times loop counter by one
	
j loopHeightTimes		#continue looping in the height times loop

exitHeightLoop:

li $v0 10			#prep to exit
syscall			#exit
