.section .data
game_over_str:
.ascii "Game over\nScore was %d.\n"
.ascii "Press \"q\" to quit or \"p\" to play another game.\0"
.section .bss
.section .text
		
##############################################################################
# function end_game
# takes no parameters and returns nothing. exits the program
##############################################################################
.globl end_game 
.type end_game, @function
end_game:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

call close_ncurses

movl $SYS_EXIT, %eax
movl $0, %ebx

int $LINUX_SYSCALL
movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function game_over
# parameter is the current score
# return nothing
##############################################################################
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

pushl SCORE(%ebp)
pushl $game_over_str
pushl $0 
pushl $0 
call mvprintw
addl $12, %esp

get_keystroke:
call getch
cmpl $113, %eax # 113 is ascii code for "q"
je end_game_label
cmpl $112, %eax # 113 is ascii code for "p"
je play_again
jmp get_keystroke

play_again:
call main_game

end_game_label:
call end_game

pushl TEXT_COLOR_PAIR
call attroff
addl $4, %esp

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret
