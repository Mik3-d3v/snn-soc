.section .text
.global _start
_start:
    li x1, 0x10000000       # print address
    li x2, 'H'
    sw x2, 0(x1)
    li x2, 'i'
    sw x2, 0(x1)
    li x2, '\n'
    sw x2, 0(x1)
    li x1, 0x20000000       # finish address
    li x2, 0
    sw x2, 0(x1)
loop:
    j loop