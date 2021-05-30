###########################################################################################################
#Created:     Gu, James
#             jjgu 
#             29 May 2021
#
#Assignment:  Lab 4: Functions and Graphics
#             CSE 12/12L, Computer Systems and Assembly Language
#             UC Santa Cruz, Spring 2021
#
#Description: This program prints a graphic consisting of two pixels, two lines (one horizontal 
#             and one vertical), and a crosshair. Go to tools and then Bitmap Display to view.
#
#Notes:       This program is intended to be run from the MARS IDE
###########################################################################################################
#REGISTER USAGE:
#$t0: used for 0x000000XX
#$t1: used for 0x000000YY
#$t2: stores memory address based on 0x000000XX and 0x000000YY
#$t3: stores memory address
#$t4: loop ender variable
#$t5: loop counter
#$t6: used for 0x000000XX for crosshair
#$t7: used for 0x000000YY for crosshair

# Spring 2021 CSE12 Lab 4
######################################################
# Macros made for you (you will need to use these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	# YOUR CODE HERE
	sra %x %input 16                             #set %x to shifted right arithmetic %input 16 times 
	                                             #(0x00XX00YY->0x000000XX)
	sll %y %input 16                             #set %y to shifted left logical %input 16 times (0x00XX00YY->0x00YY0000)
	sra %y %y 16                                 #set %y to shifted right arithmetic %y 16 times (0x00YY0000->0x000000YY)
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args:
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)                          
	# YOUR CODE HERE                                 
	sll %output %x 16                            #set %output to shifted left logical %x 16 times(0x000000XX->0x00XX0000)
	add %output %output %y                       #set %output to the sum of %output and %y (0x00XX0000->0x00XX00YY)
.end_macro 

# Macro that converts pixel coordinate to address
# 	  output = origin + 4 * (x + 128 * y)
# 	where origin = 0xFFFF0000 is the memory address
# 	corresponding to the point (0, 0), i.e. the memory
# 	address storing the color of the the top left pixel.
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y)
	# YOUR CODE HERE
	sll %output %y 7                             #set %output to shifted left logical %y 7 times (multiply y by 128)     
	add %output %output %x                       #set %output to the sum of %output and %x
	sll %output %output 2                        #set %output to shifted left logical %output 2 times (multiply 
	                                             #current output by 4)
	addi %output %output 4294901760              #add the origin to the current output (0xFFFF0000+current output)
.end_macro


.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t3 4294901760                            #set the $t3 register to 0xFFFF0000 (memory vlaue starts at origin)
	li $t4 16384                                 #set the $t4 register to 16384. if $t5 becomes equal to $t4 
	                                             #the loop ends
	li $t5 0                                     #set the $t5 register to 0. $t5 will be the counter
	colorBackgroundLoop:
		beq $t5 $t4 exit               #exit for loop if $t5 and $t4 are equal
		sw $a0 ($t3)                   #store the $a0 into the corresponding value in memory (color the pixel)
		addi $t3 $t3 4                 #add 4 to memory value in $t3
		addi $t5 $t5 1                 #add 1 to the counter $t5
		j colorBackgroundLoop          #jump back to the top of the loop
	exit:
		jr $ra                         #return to where the function was called
	
#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	getCoordinates($a0 $t0 $t1)                  #set $t0 and $t1 to 0x000000XX and 0x000000YY based on $a0
	getPixelAddress($t2 $t0 $t1)                 #set $t2 to the memory address based on $t0 and $t1
	sw $a1 ($t2)                                 #store the $a1 into the corresponding value in memory (color the pixel)
	jr $ra                                       #return to where the function was called
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	getCoordinates($a0 $t0 $t1)                  #set $t0 and $t1 to 0x000000XX and 0x000000YY based on $a0
	getPixelAddress($t2 $t0 $t1)                 #set $t2 to the memory address based on $t0 and $t1
	lw $v0 ($t2)                                 #load the contents of the corresponding value in memory into $v0
	jr $ra                                       #return to where the function was called

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t4 128                                   #set $t4 to 128. when $t4 and $t5 are equal end the loop
	li $t5 0                                     #set $t5 to 0. $t5 will be the counter for the loop
	getPixelAddress($t3 $t5 $a0)                 #set $t3 to the memory address based on 0x00000000 and 0x000000YY
	drawHorizontalLineLoop:
		beq $t5 $t4 exit1              #exit loop if $t4 and $t5 are equal
		sw $a1 ($t3)                   #store the $a1 into the corresponding value in memory (color the pixel)
		addi $t3 $t3 4                 #add 4 to memory value in $t3
		addi $t5 $t5 1                 #add 1 to the counter $t5
		j drawHorizontalLineLoop       #jump back to the top of the loop
	exit1:
 		jr $ra                         #return to where the function was called


#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t4 128                                   #set $t4 to 128. when $t4 and $t5 are equal end the loop
	li $t5 0                                     #set $t5 to 0. $t5 will be the counter for the loop
	getPixelAddress($t3 $a0 $t5)                 #set $t3 to the memory address based on 0x000000XX and 0x00000000
	drawVerticleLineLoop:
		beq $t5 $t4 exit2              #exit loop if $t4 and $t5 are equal
		sw $a1 ($t3)                   #store the $a1 into the corresponding value in memory (color the pixel)
		addi $t3 $t3 512               #add 512 to memory value in $t3 (go to next row same x)
		addi $t5 $t5 1                 #add 1 to the counter $t5
		j drawVerticleLineLoop         #jump back to the top of the loop
	exit2:
 		jr $ra                         #return to where the function was called


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)
	
	# HINT: Store the pixel color at $a0 before drawing the horizontal and 
	# vertical lines, then afterwards, restore the color of the pixel at $a0 to 
	# give the appearance of the center being transparent.
	
	# Note: Remember to use push and pop in this function to save your t-registers
	# before calling any of the above subroutines.  Otherwise your t-registers 
	# may be overwritten.  
	
	# YOUR CODE HERE, only use t0-t7 registers (and a, v where appropriate)
	push($a0)                                    #push $a0 to the top of the stack
	getCoordinates($a0 $t6 $t7)                  #set $t6 and $t7 to 0x000000XX and 0x000000YY based on $a0
	jal get_pixel                                #jump to the function get_pixel to store the color of the pixel into $v0
	move $a0 $t7                                 #set $a0 to the value of $t7
	jal draw_horizontal_line                     #jump to the function draw_horizontal_line (draw horizontal line)
	move $a0 $t6                                 #set $a0 to the value of $t6
	jal draw_vertical_line                       #jump to the function draw_vertical_line (draw vertical line)
	pop($a0)                                     #pop $a0 out of the top of the stack
	move $a1 $v0                                 #set $a0 to the value of $v0
	jal draw_pixel                               #jump to the function draw_pixel (draw original color pixel)
	pop($ra)                                     #pop $ra out of the top of the stack
	# HINT: at this point, $ra has changed (and you're likely stuck in an infinite loop). 
	# Add a pop before the below jump return (and push somewhere above) to fix this.
	jr $ra                                       #return to where the function was called
