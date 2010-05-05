#define COLOR_BLACK	0
#define COLOR_RED	1
#define COLOR_GREEN	2
#define COLOR_YELLOW	3
#define COLOR_BLUE	4
#define COLOR_MAGENTA	5
#define COLOR_CYAN	6
#define COLOR_WHITE	7

# game play is 
# screen 16 wide 28 high
.section .data
score:
.long 0
level:
.long 1
x:
.ascii "x\0"
level_str:
.ascii "level: %d\0"
score_str:
.ascii "score: %d\0"
eighteen_xes:
.ascii "xxxxxxxxxxxxxxxxxx\0"
screen_x_size:
.long 0
screen_y_size:
.long 0

ALL_BLACK_COLOR_PAIR:
.long 0
BLOCK_COLOR_PAIR:
.long 1
TEXT_COLOR_PAIR:
.long 2
FRAME_COLOR_PAIR:
.long 3

.section .bss

.section .text
.globl main_game
.type main_game, @function
main_game:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

# get the screen size
pushl stdscr
call getmaxy
movl %eax, screen_y_size
addl $4, %esp

pushl stdscr
call getmaxx
movl %eax, screen_x_size
addl $4, %esp

call draw_frame

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function to draw basic frame around game play
###################################
.type draw_frame, @function
draw_frame:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer
.equ I, -4  # loop counter variable
subl $4, %esp

call setup_color_pairs

# NEED a ncurse function to clear screen here
call clear_screen

pushl FRAME_COLOR_PAIR
call attron
addl $4, %esp

# FIXME ERASE
# game play is 
# screen 16 wide 28 high
pushl $eighteen_xes
pushl $0
pushl $0
call mvprintw
addl $12, %esp

	# loop to print the left and right wall 
	movl $0, I(%ebp)
	start_print_loop:
	cmpl $17, I(%ebp)
	je end_print_loop
	pushl $x
	pushl $0
	pushl I(%ebp)
	call mvprintw 
	addl $12, %esp
	pushl $x
	pushl $17
	pushl I(%ebp)
	call mvprintw 
	addl $12, %esp
	addl $1, I(%ebp)
	jmp start_print_loop
	end_print_loop:

pushl $eighteen_xes
pushl $0
pushl $17
call mvprintw
addl $12, %esp

pushl $x
pushl $0
pushl $18
call mvprintw
addl $12, %esp
pushl $x
pushl $17
pushl $18
call mvprintw
addl $12, %esp

pushl $x
pushl $0
pushl $19
call mvprintw
addl $12, %esp
pushl $x
pushl $17
pushl $19
call mvprintw
addl $12, %esp

pushl $eighteen_xes
pushl $0
pushl $20
call mvprintw
addl $12, %esp

pushl FRAME_COLOR_PAIR
call attroff
addl $4, %esp

call print_level_and_score

# FIXME erase when ready
call getch

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function to print_level_and_score
###################################
.type print_level_and_score, @function
print_level_and_score:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

pushl TEXT_COLOR_PAIR
call attron
addl $4, %esp

pushl level
pushl $level_str
pushl $2
pushl $18
call mvprintw
addl $12, %esp

pushl score
pushl $score_str
pushl $2
pushl $19
call mvprintw
addl $12, %esp

pushl TEXT_COLOR_PAIR
call attroff
addl $4, %esp

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function to clear_screen
###################################
.type clear_screen, @function
clear_screen:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer
.equ X, -4 
.equ Y, -8 
subl $8, %esp

#pushl ALL_BLACK_COLOR_PAIR 
#pushl TEXT_COLOR_PAIR
#call set_color
#addl $4, %esp
pushl ALL_BLACK_COLOR_PAIR
#call attron(COLOR_PAIR(1))
call attron
addl $4, %esp

# loop on y
movl $-1, Y(%ebp)
loop_on_y:
addl $1, Y(%ebp)
movl screen_y_size, %eax
cmpl %eax, Y(%ebp)
je end_clear_screen

	#loop on x
	movl $0, X(%ebp)
	loop_on_x:
	movl screen_x_size, %eax
	cmpl %eax, X(%ebp)
	je loop_on_y	
	# printw
	pushl $x
	pushl X(%ebp)
	pushl Y(%ebp)
	call mvprintw
	addl $12, %esp

	addl $1, X(%ebp)
	jmp loop_on_x
	
movl $0, X(%ebp)
jmp loop_on_y

end_clear_screen:

pushl ALL_BLACK_COLOR_PAIR
#call attroff(COLOR_PAIR(1))
call attroff
addl $4, %esp

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##################################
# function setup_color_pairs
##################################
.type setup_color_pairs, @function
setup_color_pairs:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

#ALL_BLACK_COLOR_PAIR: .long 0
pushl $0 
pushl $0 
pushl $1
#init_pair(ALL_BLACK_COLOR_PAIR, COLOR_RED, COLOR_RED)
call init_pair
addl $12, %esp
pushl $1 
call COLOR_PAIR
addl $4, %esp
movl %eax, ALL_BLACK_COLOR_PAIR

#BLOCK_COLOR_PAIR: .long 1
pushl $1 
pushl $1 
pushl $2
#init_pair(ALL_BLACK_COLOR_PAIR, COLOR_RED, COLOR_RED)
call init_pair
addl $12, %esp
pushl $2 
call COLOR_PAIR
addl $4, %esp
movl %eax, BLOCK_COLOR_PAIR

#TEXT_COLOR_PAIR: .long 2
pushl $0 
pushl $4 
pushl $3
#init_pair(ALL_BLACK_COLOR_PAIR, COLOR_RED, COLOR_RED)
call init_pair
addl $12, %esp
pushl $3 
call COLOR_PAIR
addl $4, %esp
movl %eax, TEXT_COLOR_PAIR

#FRAME_COLOR_PAIR: .long 3
pushl $6 
pushl $6 
pushl $4
#init_pair(ALL_BLACK_COLOR_PAIR, COLOR_RED, COLOR_RED)
call init_pair
addl $12, %esp
pushl $4 
call COLOR_PAIR
addl $4, %esp
movl %eax, FRAME_COLOR_PAIR

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function to set the color
# takes 1 arg which is the color pair to set 
###################################
.type set_color, @function
set_color:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer
.equ COLOR_PAIR_PARAM, 8 

pushl COLOR_PAIR_PARAM(%ebp)
call COLOR_PAIR
addl $4, %esp

pushl %eax
#call attron(COLOR_PAIR(1))
call attron
addl $4, %esp

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret
