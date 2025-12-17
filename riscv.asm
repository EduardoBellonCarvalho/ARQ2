.text	
.globl _start
_start:
  addi t0,x0,1
  addi t1,x0,0
  addi t2,x0,15

loop:
  add t1,t0,t1
  addi t0,t0,1
  beq t0,t2,fim
  j loop

fim:
  ebreak
