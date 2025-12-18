.text	
.globl _start
_start:

  addi t0,x0,1
  addi t1,x0,0
  addi t2,x0,15
  li t3, 0x120 
  li t4, 0x200

check_pause:
  lw t5, 0(t3)
  and t5,t5,t4
  bnez t5, check_pause

loop:
  add t1,t0,t1
  addi t0,t0,1
  beq t0,t2,fim
  j check_pause

fim:
  ebreak
