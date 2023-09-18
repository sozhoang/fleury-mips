# Title: Fleury algorithm         Filename: main.asm
# Author: sozhoang                Date: 12/03/2023
# Description: Macro thuat toan Fleury va mot so macro lien quan
# Input:
# Output:

############################ Data segment ##################################
.data
visited: .space 80

########################## Algorithm segment ################################

# thuat toan Fleury voi dinh bat dau la %startVer
.macro fleury(%mat, %size, %startVer, %edge)
	addi $sp, $sp, -12
	sw $ra, ($sp)
	sw $t4, 4($sp)			# bien dem
	sw $t3, 8($sp)			# bien bool
	add $t4, %startVer, $0
	recursive:			# bat dau vong de quy
		add %startVer, $t4, $0	
		beqz %edge, end_loop
		for($t4, $0, %size, loop) #duyet cac dinh ke voi dinh %startVer
		j end_loop
		loop:
			get_val($t3, %mat, %size, %startVer, $t4) 
			beqz $t3, skip
			isBridge(%mat, %size, %startVer, $t4, $t3) # kiem tra xem co la canh cau khong 
			bgtz $t3, check_neigh
			j print_edge
			check_neigh:				# kiem tra xem co ton tai hang xom khac khong
				countDeg(%mat, %size, %startVer, $t3)
				addi $t3, $t3, -1
				beqz $t3, print_edge
				j skip
			print_edge:				# in canh ra
				print_int(%startVer)
				putc('-')
				print_int($t4)
				putc(' ')
				set_val($0, %mat, %size, %startVer, $t4) # xoa canh khoi do thi
				set_val($0, %mat, %size, $t4, %startVer)
				addi %edge, %edge, -1
				j recursive			# quay lai vong de quy va thay dinh %startVer
			skip:
			jr $ra
		end_loop:
	lw $ra, ($sp)
	lw $t4, 4($sp)
	lw $t3, 8($sp)
	addi $sp, $sp, 8
.end_macro

# Ham dem bac cua dinh %vertex va tra gia tri ve thanh ghi %num
.macro countDeg(%mat, %size, %vertex, %num)
	addi $sp, $sp, -12
	sw $t8, ($sp)
	sw $t9, 4($sp)
	sw $ra, 8($sp)
	add %num, $0, $0
	for($t9, $0, %size, count) # duyet tat ca cac dinh
	j end_count
	count:
		get_val($t8,%mat, %size, %vertex, $t9) # neu ton tai canh thi +1 vao bac
		bgtz $t8, yes
		j no
		yes:
		addi %num, %num, 1
		no:
		jr $ra
	end_count:
	lw $t8, ($sp)
	lw $t9, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
.end_macro

# Ham kiem tra canh cau 
.macro isBridge(%mat, %size, %start, %end, %bool)
	addi $sp, $sp, -20
	sw $ra, ($sp)	
	sw $t8, 4($sp)				# dinh ke voi dinh trong stack
	sw $t7, 8($sp) 				# bien dem
	sw $t6, 12($sp)				# bien luu dia chi stack ban dau 
	sw $t5, 16($sp)				# gia tri dinh stack
	li %bool, 1
	for($t7, $0, %size, initVisited)	# khoi tao ma tran visited 
	j inited
	initVisited:				
	sll $t7, $t7, 2
	sw $0, visited($t7)
	srl $t7, $t7, 2
	jr $ra
	inited:
	set_val($0, %mat, %size, %start, %end)	# gia su xoa canh khoi do thi
	set_val($0, %mat, %size, %end, %start)
	add $t6, $sp, $0
	addi $sp, $sp, -4
	sw %start, ($sp)
	dfs:					# kiem tra tinh lien thong cua do thi khi ta xoa canh bang dfs
		beq $t6, $sp, true
		lw $t5, ($sp)
		sw $0, ($sp)			# luu gia tri ban dau cua stack
		addi $sp, $sp, 4
		beq $t5, %end, false		# dung khi gia tri ve gia tri ban dau
		sll $t5, $t5, 2
		sw %bool, visited($t5)		# danh dau da tham trong manh visited
		srl $t5, $t5, 2
		for($t7, $0, %size, pushStack)
		j end_loop
		pushStack:			# day cac dinh hang xom vao stack neu no chua duoc tham
			get_val($t8, %mat, %size, $t5, $t7)
			beqz $t8, no_push
			sll $t7, $t7, 2
			lw $t8, visited($t7)
			srl $t7, $t7, 2
			beq $t8, %bool, no_push
			addi $sp, $sp, -4
			sw $t7, ($sp)
		no_push:
			jr $ra
		end_loop:
			j dfs
	true:					# True neu do la canh cau va khong ton tai duong di giua hai dinh khi ta xoa canh
		li %bool, 1
		j end_check
	false:
		li %bool, 0
	end_check:
	li $t7, 1
	set_val($t7, %mat, %size, %start, %end)
	set_val($t7, %mat, %size, %end, %start)	
	lw $ra, ($sp)	
	lw $t8, 4($sp)
	lw $t7, 8($sp) 			
	lw $t6, 12($sp)			
	lw $t5, 16($sp)
	addi $sp, $sp, 20
.end_macro

# Ham kiem tra xem do thi co ton tai duong di Euler khong va tra ve dinh bat dau %startVer
.macro isEulerianPath(%mat, %size, %bool, %startVer)
	addi $sp, $sp, -16
	sw $ra, ($sp)
	sw $t5, 4($sp)			# biem dem
	sw $t6, 8($sp)			# bac cua dinh dang xet
	sw $t7, 12($sp) 		# so dinh co bac le trong do thi
	li %bool, 2
	li %startVer, 0
	li $t7, 0	
	for($t5, $0, %size, loop)	# duyet tat ca cac dinh cua do thi
	j end_loop	
	loop:
		countDeg(%mat, %size, $t5, $t6) 
		div $t6, %bool
		mfhi $t6
		beq $t6, $0, even
		addi $t7, $t7, 1	# +1 neu dinh dang xet la dinh co bac le
		add %startVer, $t5, $0
	even:
		jr $ra	
	end_loop:
	beq $t7, %bool, true		
	beq $t7, $0, true
	li %bool, 0
	j exit
	true:				# tra ve True neu ton tai 2 dinh bac le hoac khong ton tai dinh bac le
		li %bool, 1
	exit:
	lw $ra, ($sp)
	lw $t5, 4($sp)
	lw $t6, 8($sp)
	lw $t7, 12($sp)
	addi $sp, $sp, 16
.end_macro
