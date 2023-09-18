# Title: Fleury algorithm         Filename: main.asm
# Author: songutboiz              Date: 12/03/2023
# Description: Chương trinh thuc hien thuat toan Fleury tim duong di Euler
# Input: Danh sach cac canh
# Output: Duong di Euler

.include "matrix.asm"
.include "io.asm"
.include "fleury.asm"
############################ Data segment ##################################
.data
		.align 2
	mat: 	.space 1600
	size: 	.word 0
	edge: 	.word 0
############################ Main segment ##################################
.text
main:
	la $s0, mat
	la $s1, size
	la $s2, edge
	print_string("\n______________________________________________\n")
	print_string("1. Nhap cac canh\n")
	print_string("2. Thuat toan Fleury tim duong di Euler\n")
   	print_string("3. Thoat\n")
    	print_string("______________________________________________\n")
    	print_string("Lua chon: ")
    	addi $v0, $0, 5
    	syscall
    	# Switch case
    	beq $v0, 1, case1
    	beq $v0, 2, case2
    	beq $v0, 3, case3
    	print_string("Vui long nhap lai\n")
    	j main
case1:
	print_string("Nhap so luong dinh V (V < 20) = ")
        read_int($s4)
        print_string("Nhap so luong canh E = ")
        read_int($s5)
        init_graph($s0, $s4)
        for($t0, $0, $s5, read_edge)
        j end_read
    read_edge:
        print_string("Nhap canh thu #")
        print_int($t0)
        endl
        print_string("Dinh dau: ")
        read_int($t1)
        print_string("Dinh cuoi: ")
        read_int($t2)
	li $t4, 1
        set_val($t4, $s0, $s4, $t1, $t2)
        set_val($t4, $s0, $s4, $t2, $t1)
        jr $ra
    end_read:
    	j main
case2:
	beqz $s4, end_find
	beqz $s5, end_find
	isEulerianPath($s0, $s4, $t0, $s3)
	beqz $t0, end_find
	endl
	fleury($s0, $s4, $s3, $s5)
	j main
	end_find: 
		print_string("Khong ton tai duong di Euler\n")
		j main
case3:
    	addi $v0, $0, 10
    	syscall   


	
