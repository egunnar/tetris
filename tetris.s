.section .data
.equ SYS_EXIT, 1
.equ LINUX_SYSCALL, 0x80
welcome_string:
.ascii "Welcome to tetris\nThese are the top scores.\n\0"
welcome_string2:
.ascii "press any key to continue.\0"

.section .bss

.section .text
.globl _start
###################################
_start:
### exit ###
call splash_screen
call close_ncurses

movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL


###################################
# function to print splash screen
###################################
# no input and return value ignored
.type splash_screen, @function
splash_screen:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer
call init_ncurses
# 1) print welcome
pushl $welcome_string
call printw
addl $4, %esp
call refresh

# 2) print top scores file

# 3) wait for key input to continue
call getch

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret


###################################
# function to get user name
###################################

###################################
# functinon to init ncurses 
###################################
.type init_ncurses, @function
init_ncurses:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer
# Start curses mode
call initscr  

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# functinon to close/clean up ncurses 
###################################
.type close_ncurses, @function
close_ncurses:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

call endwin			 # End curses mode		  */

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret
