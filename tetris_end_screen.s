.section .data
game_over_str:
.ascii "game over\0"
.section .bss
#.lcomm record_buffer, BUFFER_SIZE
.section .text

###################################
# function game_over
# parameter is the current score
# return nothing
###################################
.globl game_over 
.type game_over, @function
game_over:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

.equ SCORE, 8 

#for getch turns on blocking mode
#nodelay(stdscr, FALSE);
pushl $0
push stdscr
call nodelay
addl $8, %esp

call clear_screen

pushl TEXT_COLOR_PAIR
call attron
addl $4, %esp

pushl $game_over_str
pushl $3 
pushl $3 
call mvprintw
addl $12, %esp

call getch

pushl TEXT_COLOR_PAIR
call attroff
addl $4, %esp


movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret
