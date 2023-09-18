# Title: Fleury algorithm         Filename: main.asm
# Author: songutboiz              Date: 12/03/2023
# Description: Mot so macro vao/ra co ban
# Input:
# Output: 


############################ In/Out segment ##################################

# In ki tu 'c'
.macro putc(%c)
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        sw $a0, 4($sp) 
        addi $v0, $0, 11
        addi $a0, $0, %c
        syscall
        lw $v0, ($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
.end_macro

# In khoang trang
.macro space
    putc(' ')
.end_macro

# In dau xuong dong
.macro endl
    putc('\n')
.end_macro

# Doc so nguyen vao thanh ghi %des
.macro read_int(%des)
    .text
        addi $sp, $sp, -4
        sw $v0, ($sp)
        addi $v0, $0, 5
        syscall
        add %des, $v0, $0
        lw $v0, ($sp)
        addi $sp, $sp, 4
.end_macro

# In so nguyen tu thanh ghi %src
.macro print_int(%src)
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        sw $a0, 4($sp)
        addi $v0, $0, 1
        add $a0, %src, $0
        syscall
        lw $v0, ($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
.end_macro

# In xau "string"
.macro print_string(%string)
    .data
        str: .asciiz %string
    .text
        addi $sp, $sp, -8
        sw $v0, ($sp)
        sw $a0, 4($sp)
        addi $v0, $0, 4
        la $a0, str
        syscall
        lw $v0, ($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
.end_macro

# Vong lap for tu %a den %b, nhay den nhan handle
.macro for(%index, %a, %b, %handle)
    .text
        add %index, $0, %a
    _loop:
        beq %index, %b, _end_loop
        jal %handle
        add %index, %index, 1
        j _loop
    _end_loop:
.end_macro


