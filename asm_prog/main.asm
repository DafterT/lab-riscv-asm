    .data
matrix:     # 4х4
    .word 1, 2, 3, 4
    .word 5, 6, 7, 8
    .word 9, 10, 11, 12
    .word 13, 14, 15, 16

    .text
    .globl main

max_sum_col_index:
    addi sp, sp, -32    # Выделяем 32 байта на стек
    sw ra, 28(sp)       # сохраняем ra
    sw s0, 24(sp)       # сохраняем s0
    sw s1, 20(sp)       # сохраняем s1
    sw s2, 16(sp)       # сохраняем s2
    sw s3, 12(sp)       # сохраняем s3
    sw s4, 8(sp)        # сохраняем s4

    # s0: массив
    # s1: rows
    # s2: cols
    # s3: max_sum
    # s4: max_col

    mv s0, a0           # s0 = a (указатель)
    mv s1, a1           # s1 = rows
    mv s2, a2           # s2 = cols
    li s3, 0            # s3 = max_sum
    li s4, 0            # s4 = max_col

    li t0, 0            # j = 0

col_loop:
    bge t0, s2, col_end # if j >= cols, выходим

    li t1, 0            # sum = 0
    li t2, 0            # i = 0

row_loop:
    bge t2, s1, row_end # if i >= rows, конец по строкам

    # адрес a[i*cols + j]:
    mul t3, t2, s2      # t3 = i * cols
    add t3, t3, t0      # t3 = i * cols + j
    slli t3, t3, 2      # t3 = (i*cols + j)*4
    add t4, s0, t3      # t4 = &a[i*cols + j]
    lw t5, 0(t4)        # t5 = a[i*cols + j]

    add t1, t1, t5      # sum += a[i*cols + j]
    addi t2, t2, 1      # i++
    j row_loop
row_end:

    # if (j == 0 || sum > max_sum)
    bnez t0, check_sum  # если j != 0
    mv s3, t1           # max_sum = sum
    mv s4, t0           # max_col = j
    j next_col
check_sum:
    ble t1, s3, next_col
    mv s3, t1           # max_sum = sum
    mv s4, t0           # max_col = j

next_col:
    addi t0, t0, 1      # j++
    j col_loop

col_end:
    mv a0, s4           # результат (max_col) в a0

    lw ra, 28(sp)
    lw s0, 24(sp)
    lw s1, 20(sp)
    lw s2, 16(sp)
    lw s3, 12(sp)
    lw s4, 8(sp)
    addi sp, sp, 32
    jr ra

# int main(void)
main:
    addi sp, sp, -16
    sw ra, 12(sp)

    la a0, matrix   # a0 = &matrix[0][0]
    li a1, 4        # rows = 4
    li a2, 4        # cols = 4
    call max_sum_col_index

    lw ra, 12(sp)
    addi sp, sp, 16
    
    mv a1, a0       
    li a0, 1        # file descriptor = 1 (stdout)
    li a7, 10       # exit
    ecall
