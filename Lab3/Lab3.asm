.data

enterHeightPrompt: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
invalidInput: .asciiz "Invalid Entry!\n"
tab: .asciiz "\t"
newLine: .asciiz "\n"
asterisk: .asciiz "*\t"

.text
userInput:
li $v0 4		#Prep to prompt the user with the enterHeightPrompt
la $a0 enterHeightPrompt	#Put address of string into $a0
syscall		#print

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
la $t2 ($t0)			#$t2 is set to the user's inputted height of the triangle
li $t3 1			#$t3 is my subtraction variable when I want to subtract 1

loopHeightTimes:
beq $t2 $zero exitHeightLoop

loopPrintBeginningTabs:
sub $t4 $t2 $t3		#Set $t4 equal to the value of $t2 minus one
beq $t4 $zero exitBeginningTabLoop	#Exit Loop if $t4 is zero
li $v0 4			#prep to print tab
la $a0 tab			#put address of string into $a0
syscall			# print tab
sub $t4 $t4 $t3		#subtract 1 from $t4
j loopPrintBeginningTabs		#loop back

exitBeginningTabLoop:
li $v0 4			#prep to print
la $a0 ($t1)			#put address of string into $a0
syscall			# print the counter number

#in between:
bne $t1 $t3 printOneTab		#if the counter number is not equal to 1 then go to print one tab
j skipInBetween		#if the counter number is 1 jump to rest of code
printOneTab:
li $v0 4			#prep to print tab
la $a0 tab			#put address of string into $a0
syscall			# print tab

loopPrintAsterisks:
sub $t5 $t1 $t3
beq $t5 $zero exitAsterisksLoop
li $v0 4			#prep to print tab
la $a0 asterisk		#put address of string into $a0
syscall			# print asterick
sub $t5 $t5 $t3
j loopPrintAsterisks

exitAsterisksLoop:
addi $t1 $t1 1
li $v0 4			#prep to print tab
la $a0 ($t1)		#put address of string into $a0
syscall			# print counter number


skipInBetween:
addi $t1 $t1 1		#add one to the counter number

li $v0 4			#prep to print
la $a0 newLine		#put address of string into $a0
syscall			#print newLine

sub $t2 $t2 $t3
j loopHeightTimes

exitHeightLoop:

li $v0 10		#prep to exit
syscall		#exit