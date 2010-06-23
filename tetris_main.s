#define COLOR_BLACK	0
#define COLOR_RED	1
#define COLOR_GREEN	2
#define COLOR_YELLOW	3
#define COLOR_BLUE	4
#define COLOR_MAGENTA	5
#define COLOR_CYAN	6
#define COLOR_WHITE	7

# from ncurses.h
#define KEY_DOWN	0402		/* down-arrow key */
#define KEY_UP		0403		/* up-arrow key */
#define KEY_LEFT	0404		/* left-arrow key */
#define KEY_RIGHT	0405		/* right-arrow key */
#
# block 0 is: block 1 block 2 block 3
#   X          XX       X	    XX
#   X          XX       X        XX
#   X                   XX
#   X
# game play is 
# screen 16 wide 16 high
.section .data
block0_x:
.int 0, 0, 0, 0
block1_x:
.int 0, 1, 0, 1
block2_x:
.int 0, 0, 0, 1
block3_x:
.int 0, 1, 1, 2
block0_y:
.int 0, 1, 2, 3
block1_y:
.int 0, 0, 1, 1
block2_y:
.int 0, 1, 2, 2
block3_y:
.int 0, 0, 1, 1
temp_x:
.int 0
temp_y:
.int 0
# used for a timing loop. at level 1 it's 10, level 2 it's 9, level 3 it's 8, etc..
level_counter:
.int 10

# represents current rotation of the block going down
# can be 0 to 3
current_rotation:
.int 0
# the current x of the block
# i want to initailly set this in the function to start each 
# new blcok. point that the block rotates around
current_x:
.int 0
current_y:
.int 0

# other spaces filled by the block (note all blocks are size 4)
current_x1:
.int 0
current_x2:
.int 0
current_x3:
.int 0
current_y1:
.int 0
current_y2:
.int 0
current_y3:
.int 0

# represents type of block currently 
# can be 0 to 3
current_block_type:
.int 0
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

###################################
# function give_block_coord 
###################################
# this gives the location of 4 squares of the current
# block (only really has to calculate 3 off of 
# current_x and current_y). it puts the result in 
# current_x1, current_x2, current_x3, and
# current_y1, current_y2, current_y3. the function takes
# no arguments
###################################
.globl give_block_coord 
.type give_block_coord, @function
give_block_coord:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

# PART 1
# first calculate locations wo rotation

# block type 0
#  2nd square
movl $block0_x, temp_x
movl $block0_y, temp_y
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x1
movl %ebx, current_y1
#  3rd square
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x2
movl %ebx, current_y2
#  4rd square
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x3
movl %ebx, current_y3
cmpl $0, current_block_type
je end_compare_block_type

# block type 1
#  2nd square
movl $block1_x, temp_x
movl $block1_y, temp_y
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x1
movl %ebx, current_y1
#  3rd square
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x2
movl %ebx, current_y2
#  4rd square
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x3
movl %ebx, current_y3
cmpl $1, current_block_type
je end_compare_block_type

# block type 2
#  2nd square
movl $block2_x, temp_x
movl $block2_y, temp_y
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x1
movl %ebx, current_y1
#  3rd square
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x2
movl %ebx, current_y2
#  4rd square
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x3
movl %ebx, current_y3
cmpl $2, current_block_type
je end_compare_block_type

# block type 3
#  3nd square
movl $block3_x, temp_x
movl $block3_y, temp_y
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x1
movl %ebx, current_y1
#  3rd square
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x2
movl %ebx, current_y2
#  4rd square
addl $4, temp_x
addl $4, temp_y
movl temp_x, %eax
movl temp_y, %ebx
movl (%eax), %eax
movl (%ebx), %ebx
addl current_x, %eax
addl current_y, %ebx
movl %eax, current_x3
movl %ebx, current_y3

end_compare_block_type:

# PART 2
# do the rotation calculations

cmpl $1, current_rotation
je rotation_type_1
cmpl $2, current_rotation
je rotation_type_2
cmpl $3, current_rotation
je rotation_type_3
jmp end_loop_rotation


##########################################
# START HERE !!!!!!!!!!!!!!
# rotation calcuation completely 
# started to rework on square 2 below
rotation_type_1:
#rotation type 1 (-y, x)
#  square 2
#  get relative positive of 1 square to sqaure 0
movl current_x1, %eax
movl current_y1, %ebx
subl current_x, %eax
subl current_y, %ebx
# copy the current_x & current_y into current_x1 & current_y1
movl current_x, %ecx
movl %ecx, current_x1
movl current_y, %edx
movl %edx, current_y1
# add the relative rotation to values
addl %eax, current_y1
subl %ebx, current_x1
#  square 3
#  get relative positive of 1 square to sqaure 0
movl current_x2, %eax
movl current_y2, %ebx
subl current_x, %eax
subl current_y, %ebx
# copy the current_x & current_y into current_x2 & current_y2
movl current_x, %ecx
movl %ecx, current_x2
movl current_y, %edx
movl %edx, current_y2
# add the relative rotation to values
addl %eax, current_y2
subl %ebx, current_x2
#  square 4
#  get relative positive of 1 square to sqaure 0
movl current_x3, %eax
movl current_y3, %ebx
subl current_x, %eax
subl current_y, %ebx
# copy the current_x & current_y into current_x3 & current_y3
movl current_x, %ecx
movl %ecx, current_x3
movl current_y, %edx
movl %edx, current_y3
# add the relative rotation to values
addl %eax, current_y3
subl %ebx, current_x3
jmp end_loop_rotation

#rotation type 2 (-x, -y)
#  square 2
#  get relative positive of 1 square to sqaure 0
rotation_type_2:
movl current_x1, %eax
movl current_y1, %ebx
subl current_x, %eax
subl current_y, %ebx
# copy the current_x & current_y into current_x1 & current_y1
movl current_x, %ecx
movl %ecx, current_x1
movl current_y, %edx
movl %edx, current_y1
# add the relative rotation to values
subl %eax, current_x1
subl %ebx, current_y1
#  square 3
#  get relative positive of 1 square to sqaure 0
movl current_x2, %eax
movl current_y2, %ebx
subl current_x, %eax
subl current_y, %ebx
# copy the current_x & current_y into current_x2 & current_y2
movl current_x, %ecx
movl %ecx, current_x2
movl current_y, %edx
movl %edx, current_y2
# add the relative rotation to values
subl %eax, current_x2
subl %ebx, current_y2
#  square 4
#  get relative positive of 1 square to sqaure 0
movl current_x3, %eax
movl current_y3, %ebx
subl current_x, %eax
subl current_y, %ebx
# copy the current_x & current_y into current_x3 & current_y3
movl current_x, %ecx
movl %ecx, current_x3
movl current_y, %edx
movl %edx, current_y3
# add the relative rotation to values
subl %eax, current_x3
subl %ebx, current_y3
jmp end_loop_rotation

#rotation type 3 (y, x)
#  square 2
#  get relative positive of 1 square to sqaure 0
rotation_type_3:
movl current_x1, %eax
movl current_y1, %ebx
subl current_x, %eax
subl current_y, %ebx
# copy the current_x & current_y into current_x1 & current_y1
movl current_x, %ecx
movl %ecx, current_x1
movl current_y, %edx
movl %edx, current_y1
# add the relative rotation to values
addl %eax, current_y1
addl %ebx, current_x1
#  square 3
#  get relative positive of 1 square to sqaure 0
movl current_x2, %eax
movl current_y2, %ebx
subl current_x, %eax
subl current_y, %ebx
# copy the current_x & current_y into current_x2 & current_y2
movl current_x, %ecx
movl %ecx, current_x2
movl current_y, %edx
movl %edx, current_y2
# add the relative rotation to values
addl %eax, current_y2
addl %ebx, current_x2
#  square 4
#  get relative positive of 1 square to sqaure 0
movl current_x3, %eax
movl current_y3, %ebx
subl current_x, %eax
subl current_y, %ebx
# copy the current_x & current_y into current_x3 & current_y3
movl current_x, %ecx
movl %ecx, current_x3
movl current_y, %edx
movl %edx, current_y3
# add the relative rotation to values
addl %eax, current_y3
addl %ebx, current_x3

end_loop_rotation:

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# main_game
###################################
.globl main_game
.type main_game, @function
main_game:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

# set the seed for generating random numbers later
# c code
# srand(time(NULL));
pushl $0
call time
addl $4, %esp 
pushl %eax 
call srand
addl $4, %esp 

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

call main_game_loop

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function is_square_in_game_block # takes 2 parameters. the x and y cordinates
# to check. returns 0 if not in the game play area.
# otherwise 1
###################################
.type is_square_in_game_block, @function
is_square_in_game_block:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

.equ X_PARAM, 8 
.equ Y_PARAM, 12 

movl $0, %eax

# check left wall
cmpl $1, X_PARAM(%ebp) 
jl illegal_square

# check right wall
cmpl $17, X_PARAM(%ebp) 
jge illegal_square

# check top wall
cmpl $1, Y_PARAM(%ebp) 
jl illegal_square

# check bottom wall
cmpl $17, Y_PARAM(%ebp) 
jge illegal_square

movl $1, %eax
illegal_square:

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function draw_block
# takes 1 param which is the color pair 
###################################
.type draw_block, @function
draw_block:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

.equ DRAW_COLOR_PAIR_PARAM, 8 

pushl DRAW_COLOR_PAIR_PARAM(%ebp)
call attron
addl $4, %esp

call give_block_coord 

# check if current_x & current_y is in playable area
pushl current_y 
pushl current_x 
call is_square_in_game_block
addl $8, %esp
cmpl $0, %eax
je skip_print0

pushl $x
pushl current_x 
pushl current_y 
call mvprintw
addl $12, %esp
skip_print0:

# check if current_x1 & current_y1 is in playable area
pushl current_y1 
pushl current_x1
call is_square_in_game_block
addl $8, %esp
cmpl $0, %eax
je skip_print1

pushl $x
pushl current_x1 
pushl current_y1 
call mvprintw
addl $12, %esp
skip_print1:

# check if current_x2 & current_y2 is in playable area
pushl current_y2 
pushl current_x2
call is_square_in_game_block
addl $8, %esp
cmpl $0, %eax
je skip_print2

pushl $x
pushl current_x2
pushl current_y2 
call mvprintw
addl $12, %esp
skip_print2:

# check if current_x3 & current_y3 is in playable area
pushl current_y3 
pushl current_x3
call is_square_in_game_block
addl $8, %esp
cmpl $0, %eax
je skip_print3

pushl $x
pushl current_x3 
pushl current_y3 
call mvprintw
addl $12, %esp
skip_print3:

call refresh

# FIXME this is correct, right ?
# pushl BLOCK_COLOR_PAIR
pushl DRAW_COLOR_PAIR_PARAM(%ebp)
call attroff
addl $4, %esp

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function new_block
# whenever a new block is started at the top of the screen
###################################
.type new_block, @function
new_block:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

movl $8, current_x
movl $1, current_y
# generate a random number between 0 and 3 for the block type
# current_block_type
# c code
#int result = rand() % 4
call rand
movl $0, %edx
movl $4, %edi
divl %edi
# remainder in %edx
movl %edx, current_block_type
# FIXME FIXME erase
movl $0, current_block_type

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function left_move_ok
# takes no arguments
# returns 0 if can't go left 
###################################
.type left_move_ok, @function
left_move_ok:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

call give_block_coord 

movl $0, %eax

cmpl $1, current_x
jle left_move_not_ok
cmpl $1, current_x1
jle left_move_not_ok
cmpl $1, current_x2
jle left_move_not_ok
cmpl $1, current_x3
jle left_move_not_ok

movl $1, %eax
left_move_not_ok:

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function rotate_move_ok
# takes no arguments
# returns 0 if can't rotate
###################################
.type rotate_move_ok, @function
rotate_move_ok:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

addl $1, current_rotation 
cmpl $4, current_rotation
jne dont_reset_rotation
movl $0, current_rotation
dont_reset_rotation:

call give_block_coord 
movl $0, %eax

cmpl $17, current_x
jge move_not_ok
cmpl $17, current_x1
jge move_not_ok
cmpl $17, current_x2
jge move_not_ok
cmpl $17, current_x3
jge move_not_ok

cmpl $0, current_x
jle move_not_ok
cmpl $0, current_x1
jle move_not_ok
cmpl $0, current_x2
jle move_not_ok
cmpl $0, current_x3
jle move_not_ok

movl $1, %eax
move_not_ok:

subl $1, current_rotation 
cmpl $-1, current_rotation
jne dont_reset_rotation2
movl $3, current_rotation
dont_reset_rotation2:

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret
###################################
# function right_move_ok
# takes no arguments
# returns 0 if can't go right 
###################################
.type right_move_ok, @function
right_move_ok:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

call give_block_coord 
movl $0, %eax

cmpl $16, current_x
jge right_move_not_ok
cmpl $16, current_x1
jge right_move_not_ok
cmpl $16, current_x2
jge right_move_not_ok
cmpl $16, current_x3
jge right_move_not_ok

movl $1, %eax
right_move_not_ok:

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function time_for_new_block
# takes no arguments
# returns 0 if the current hit bottom of screen from
# 1) the very bottom of the playable area
# 2) other older blocks at rest
###################################
.type time_for_new_block, @function
time_for_new_block:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

call give_block_coord 
movl $0, %eax

# PART 1
# 1) the very bottom of the playable area
cmpl $17, current_y
jge hit_bottom_of_screen
cmpl $17, current_y1
jge hit_bottom_of_screen
cmpl $17, current_y2
jge hit_bottom_of_screen
cmpl $17, current_y3
jge hit_bottom_of_screen

movl $1, %eax
hit_bottom_of_screen:

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

###################################
# function main_game_loop
###################################
.type main_game_loop, @function
main_game_loop:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

# FIXME I is used elsewhere, this ok? 
.equ I, -4
.equ KEY_STROKE, -8

subl $8, %esp

call new_block
main_loop:

	# check if time to stop from (any of above)
	# 1) hitting bottom of screen
	# 2) hitting old blocks already set
	call time_for_new_block
	cmpl $0, %eax
	jne no_new_block_time
	call new_block
	no_new_block_time:


	movl $0, I(%ebp)
	time_loop:

		# draw block
		pushl BLOCK_COLOR_PAIR
		call draw_block
		addl $4, %esp

		# sleep
		# think -1 means no key stroke
		#pushl $100000 # .1 seconds
		pushl $100000 # .1 seconds
		call usleep 
		addl $4, %esp

		# erase old block on screen
		pushl ALL_BLACK_COLOR_PAIR
		call draw_block
		addl $4, %esp

		call getch
		#if  ((key_stroke = getch()) != -1){
		call getch
		movl %eax, KEY_STROKE(%ebp)
		cmpl $-1, %eax 
		je end_keystroke
		#if (key_stroke == 'j'|| key_stroke == KEY_LEFT ){
		cmpl $106, KEY_STROKE(%ebp)
		je go_left
		cmpl $260, KEY_STROKE(%ebp)
		je go_left
		cmpl $108, KEY_STROKE(%ebp)
		je go_right
		cmpl $261, KEY_STROKE(%ebp)
		je go_right
		# DOWN key
		cmpl $0402, KEY_STROKE(%ebp)
		je go_rotate
		cmpl $107, KEY_STROKE(%ebp)
		je go_rotate

		# FIXME shouldn't be needed
		jmp end_keystroke
		
		go_left:
		call left_move_ok
		cmpl $0, %eax
		je end_keystroke
		subl $1, current_x
		jmp end_keystroke 

		go_right:
		call right_move_ok
		cmpl $0, %eax
		je end_keystroke
		addl $1, current_x
		jmp end_keystroke 

		go_rotate:
		call rotate_move_ok
		cmpl $0, %eax
		je end_keystroke
		addl $1, current_rotation
		cmpl $4, current_rotation
		jne end_keystroke
		movl $0, current_rotation

		end_keystroke:

		addl $1, I(%ebp) 
		movl I(%ebp), %eax
		cmpl %eax, level_counter
		jge time_loop


	addl $1, current_y

jmp main_loop

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
# screen 16 wide 16 high
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
