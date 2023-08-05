# Napisati asemblerski program za RISC-V koji vrši zamenu mesta najvećeg i najmanjeg elementa kvadratne matrice celih brojeva.
# Matricu je potrebno uneti direktno u asemblerski kod. Dozvoljeno je korišćenje pseudoinstrukcija. 
# Ako nešto nije definisano usvojiti razumnu pretpostavku.
# Preporučuje se korišćenje Venus RISC-V simulatora, ali je dozvoljeno koristiti bilo koji RISC-V simulator.

.data
matrix: .word 7, 5, 9, 2, 8, 3, 6, 1, 4
rows: .word 3 
cols: .word 3

.text
main: 

la x11, matrix # adress of first element (0x10000000)
add x13, x0, x11 # copy x11
add x30, x0, x11 # min address
add x31, x0, x11 # max address

lw x12, rows # load n
lw x15, cols # load m
mul x5, x12, x15 # x5 = n * m

addi x7, x0, 1 # i = 1
addi x8, x0, 1 # j = 1

loop_min:
  bge x9, x5, end_min # end of matrix
  lw x28, 0(x13) # load current element
  lw x29, 0(x30) # load min element
  bgt x29, x28, swap_min # if min > current then swap
  jal x1, increase_i # jumps to function for altering i/j values
  addi x13, x13, 4 # next element
  jal x0, loop_min # loop

swap_min:
  addi x30, x13, 0 # update min
  jal x0, loop_min # loop

end_min:
  addi x7, x0, 1 # i = 1
  addi x8, x0, 1 # j = 1
  addi x9, x0, 1 # x9 = 1
  addi x13, x11, 0 # copy x11

loop_max:
  bge x9, x5, swap_minmax # end of matrix
  lw x28, 0(x13) # load current element
  lw x29, 0(x31) # load max element
  blt x29, x28, swap_max # if max < current then swap
  jal x1, increase_i # jumps to function for altering i/j values
  addi x13, x13, 4 # next element
  jal x0, loop_max # loop

swap_max:
  addi x31, x13, 0 # update max
  jal x0, loop_max # loop

swap_minmax:
  lw x28, 0(x30) # load numbers
  lw x29, 0(x31)
  sw x28, 0(x31) # swap numbers
  sw x29, 0(x30)

increase_i:
  mul x9, x7, x8 # multiplies i and j in order to check in the main loop if the current element is the last one
  addi x7, x7, 1 # i++
  bgt x7, x12, increase_j # checks if i has exceeded row size increase j and return i to 1
  jalr x1, x1, 0 # return where you left off in the main loop
  
increase_j:
  addi x8, x8, 1 # increases j by 1, but there is no need to check if the new number has exceeded the column size because x9 has reached the value needed to stop the main loop
  addi x7, x0, 1 # returns value of i to 1
  jalr x1, x1, 0 # return where you left off in the main loop

nop