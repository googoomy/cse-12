.data

enterHeightPrompt: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
invalidInput: .asciiz "Invalid Entry!\n"


.text
userInput:
li $v0 4		#Prompt the user to enter the height
la $a0 enterHeightPrompt
syscall

li $v0 5		#get user's height
syscall

move $t0 $v0		#store result in $t0
blez $t0 branchInvalid
j triangle

branchInvalid:
li $v0 4
la $a0 invalidInput
syscall
j userInput

triangle:
















li $v0 10		#prep to exit
syscall		#exit