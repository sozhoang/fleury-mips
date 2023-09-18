# Title: Fleury algorithm         Filename: main.asm
# Author: songutboiz              Date: 12/03/2023
# Description: Macro get va set gia tri cho ma tran
# Input:
# Output: 


############################ Matrix segment ##################################

# Lay gia tri tu arr[row][column] va tra ve thanh ghi %val
.macro get_val(%val, %arr, %size, %row, %column)
.text
	addi $sp, $sp, -8
	sw %row, ($sp)
	sw %column, 4($sp)
	mul %row, %row, %size
	add %column, %column, %row
	sll %column, %column, 2
	add %column, %column, %arr
	lw %val,(%column)
	lw %row, ($sp)
	lw %column, 4($sp)
	addi $sp, $sp, 8	
.end_macro

# Dat gia tri trong %val cho arr[row][column]
.macro set_val(%val, %arr, %size, %row, %column)
.text
	addi $sp, $sp, -8
	sw %row, ($sp)
	sw %column, 4($sp)
	mul %row, %row, %size
	add %column, %column, %row
	sll %column, %column, 2
	add %column, %column, %arr
	sw %val,(%column)
	lw %row, ($sp)
	lw %column, 4($sp)
	addi $sp, $sp, 8	
.end_macro

.macro init_graph(%mat, %numsize)
	addi $sp, $sp, -8
	sw $t0, ($sp)
	sw $t9, 4($sp)
	mul $t0, %numsize, %numsize
	for($t0, $0, $t0, init_gra)
	j end_init_gra
	init_gra:
		sll $t0, $t0, 2
		add $t9, %mat, $t0
		sw $0, ($t9)
		srl $t0, $t0, 2
	end_init_gra:
	lw $t0, ($sp)
	lw $t9, 4($sp)
	addi $sp, $sp, 8
.end_macro
