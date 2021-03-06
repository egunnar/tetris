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
# there are 4 types of blocks
# block 0 is: block 1 block 2 block 3
#   X          XX       X	    XX
#   X          XX       X        XX
#   X                   XX
#   X
#
# note that i rely on the fact that each block type is made up of 4 squares
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
# used for a timing loop. at level 1 it's 100, level 2 it's 90, level 3 it's 
# 80, etc... it ends at level 10 which 10
level_counter:
.int 100
# counts of blocks complete for game
blocks_completed:
.int 0

# represents current rotation of the block going down
# can be 0 to 3
current_rotation:
.int 0
# the current x of the block
# i want to initailly set this in the function to start each 
# new blcok. this is point that the block rotates around
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
# filled_squares_counter is count of filled blocks on screen. used with
# filled_squares_y and filled_squares_y
filled_squares_counter:
.long 0

.section .bss
# game squares that have been filled by previous blocks. squares 256 = 16 * 16 
# which is the playable area. 256 * 4  = 1024 (each block is 4 bytes)
.lcomm filled_squares_x, 1024
.lcomm filled_squares_y, 1024

.section .text

##############################################################################
# function give_block_coord 
#
# this gives the location of 4 squares of the current block (only really has
# to calculate 3 off of current_x and current_y). it puts the result in 
# current_x1, current_x2, current_x3, and current_y1, current_y2, current_y3.
# the function takes no arguments
##############################################################################
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

# rotation type 2 (-x, -y)
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

##############################################################################
# main_game
# takes no parameters and returns nothing. this function does the loop for 
# the game play.
##############################################################################
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

#for getch turns off blocking mode
#nodelay(stdscr, TRUE);
pushl $1
push stdscr
call nodelay
addl $8, %esp
call draw_frame

call main_game_loop

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function is_square_in_game_block 
# takes 2 parameters. the x and y cordinates to check. returns 0 if not in 
# the game play area.  otherwise 1
##############################################################################
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

##############################################################################
# function draw_block
# draws the current block on the screen. called to overwrite the old shape 
# (passing ALL_BLACK_COLOR_PAIR) with nothing or actually draw it (pass 
# BLOCK_COLOR_PAIR)
# takes 1 param which is the color pair and returns nothing. 
##############################################################################
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

pushl DRAW_COLOR_PAIR_PARAM(%ebp)
call attroff
addl $4, %esp

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function leave_old_block
# draw the old block permemantly and save its squares in
# filled_squares_x and filled_squares_y 
##############################################################################
.type leave_old_block, @function
leave_old_block:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

pushl BLOCK_COLOR_PAIR
call draw_block
addl $4, %esp

call give_block_coord 

movl $filled_squares_x, %eax
movl $filled_squares_y, %ebx

movl $0, %edi
filled_square_loop:
	cmpl %edi, filled_squares_counter
	je end_filled_square_loop
	addl $4, %eax
	addl $4, %ebx

	addl $1, %edi
	jmp filled_square_loop
end_filled_square_loop:

movl current_x, %ecx
movl current_y, %edx
movl %ecx, (%eax)
movl %edx, (%ebx)
addl $4, %eax
addl $4, %ebx

movl current_x1, %ecx
movl current_y1, %edx
movl %ecx, (%eax)
movl %edx, (%ebx)
addl $4, %eax
addl $4, %ebx

movl current_x2, %ecx
movl current_y2, %edx
movl %ecx, (%eax)
movl %edx, (%ebx)
addl $4, %eax
addl $4, %ebx

movl current_x3, %ecx
movl current_y3, %edx
movl %ecx, (%eax)
movl %edx, (%ebx)
addl $4, %eax
addl $4, %ebx

addl $4, filled_squares_counter

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function disolved_blocks
# takes no parameters and returns nothign
# clears completed rows and has rows above it fall. 
##############################################################################
.type disolved_blocks, @function
disolved_blocks:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

# takes up 64 bytes ( 16 * 4)
.equ Y_COUNT, -4 
# takes up 1024 bytes
.equ TEMP_X_FILLED_SQUARES, -72
# takes up 1024 bytes
.equ TEMP_Y_FILLED_SQUARES, -1096
.equ NEW_BLOCK_COUNT, -2120
.equ DROP_COUNT, -2124
.equ I, -2128

subl $2128, %esp

call draw_frame

pushl $2120 # size
pushl $0
movl %ebp, %eax
subl $2120, %eax
pushl %eax
call memset
addl $12, %esp
# y locations 1 though 16
movl $0, NEW_BLOCK_COUNT(%ebp) 

# part 1 find the rows which need to be disolved
# Y_COUNT[0] is for y =0,  Y_COUNT[1] is for y =1, etc...
movl $0, %edi
movl %ebp, %edx
subl $4, %edx # %edx holds the address of Y_COUNT(%ebp)
begin_disolve_block_loop:
	cmpl %edi, filled_squares_counter
	je end_disolve_block_loop

	movl $filled_squares_y, %ebx
	movl %edi, %eax
	imull $4, %eax
	addl %eax, %ebx
	movl (%ebx), %ecx # %ecx now has the y of current square being checked
	imull $4, %ecx # %ecx is now the offset to use for Y_COUNT

	movl %edx, %eax
	subl %ecx, %eax
	addl $1, (%eax)
	
	addl $1, %edi

	jmp begin_disolve_block_loop
end_disolve_block_loop:

# part 2
# destory the blocks in completed rows. do this by copying into a temporary 
# array and then copy back
movl %ebp, %edx
subl $4, %edx # %edx holds the address of Y_COUNT(%ebp)
movl $0, %edi
begin_disolve_block_loop2:
	cmpl %edi, filled_squares_counter
	je end_disolve_block_loop2

	# grab the y at %edi index
	movl $filled_squares_y, %ebx
	movl %edi, %eax
	imull $4, %eax
	addl %eax, %ebx
	movl (%ebx), %ecx # %ecx now has the y of current square being checked

	# should the block be eliminated
	# get the count at Y_COUNT
	movl %edx, %esi
	movl %ecx, %eax
	imull $4, %eax
	#addl %eax, %esi
	subl %eax, %esi
	movl (%esi), %esi # %esi now holds the right value at Y_COUNT
	cmpl $16, %esi
	je	block_eliminated_end
	jmp block_will_not_be_eliminated

	block_will_not_be_eliminated:
		
		# copy y value into temp array
		movl %ebp, %eax 
		subl $1096, %eax  #1096 is TEMP_Y_FILLED_SQUARES
		movl NEW_BLOCK_COUNT(%ebp), %ebx
		imull $4, %ebx
		#addl %ebx, %eax # %eax now has the address of TEMP_Y_FILLED_SQUARES 
		subl %ebx, %eax # %eax now has the address of TEMP_Y_FILLED_SQUARES 
						# for current index
		movl %ecx, (%eax) 

		# grab the x at %edi index
		movl %edi, %eax
		imull $4, %eax
		movl $filled_squares_x, %ebx
		addl %eax, %ebx
		movl (%ebx), %ecx # %ecx now has the x of current square being checked
		# copy x value into temp array
		movl %ebp, %eax 
		subl $72, %eax  #72 is TEMP_X_FILLED_SQUARES
		movl NEW_BLOCK_COUNT(%ebp), %ebx
		imull $4, %ebx
		subl %ebx, %eax # %eax now has the address of TEMP_X_FILLED_SQUARES 
						# for current index
		movl %ecx, (%eax) 

		addl $1, NEW_BLOCK_COUNT(%ebp)
	block_eliminated_end:

	addl $1, %edi

	jmp begin_disolve_block_loop2
end_disolve_block_loop2:

# now copy the temp array back into the real array
movl $0, %edi
disolve_block_loop3:
	cmpl %edi, NEW_BLOCK_COUNT(%ebp)
	je end_disolve_block_loop3

	# %ebx is 4 * %edi	
	movl %edi, %ebx
	imull $4, %ebx

	# copy the y at %edi index
	movl %ebp, %eax 
	subl $1096, %eax  #1096 is TEMP_Y_FILLED_SQUARES
	subl %ebx, %eax # %eax now has the address of TEMP_Y_FILLED_SQUARES 
					# for current index
	movl $filled_squares_y, %ecx
	addl %ebx, %ecx
	movl (%eax), %esi
	movl %esi, (%ecx)

	# copy the x at %edi index
	movl %ebp, %eax 
	subl $72, %eax   # 72 is TEMP_X_FILLED_SQUARES
	subl %ebx, %eax # %eax now has the address of TEMP_X_FILLED_SQUARES 
					# for current index
	movl $filled_squares_x, %ecx
	addl %ebx, %ecx
	movl (%eax), %esi
	movl %esi, (%ecx)
	addl $1, %edi

	jmp disolve_block_loop3  
end_disolve_block_loop3:
movl NEW_BLOCK_COUNT(%ebp), %eax
movl %eax, filled_squares_counter

# part 3
# drop each block the correct account. i could have implemented without a 
# nested loop but i got lazy
movl $16, I(%ebp)
movl $0, DROP_COUNT(%ebp)

# loop every row
disolve_block_loop4:
	cmpl $0, I(%ebp)
	je end_disolve_block_loop4
	
	# Y_COUNT[0] is for y =0,  Y_COUNT[1] is for y =1, etc...
	movl %ebp, %eax
	subl $4, %eax # Y_COUNT is -4
	movl I(%ebp), %ebx
	imull $4, %ebx
	subl %ebx, %eax
	cmpl $16, (%eax)
	jne no_drop_count_increase
	addl $1, DROP_COUNT(%ebp)
	no_drop_count_increase:

	movl $0, %edi
	inner_block:
		cmpl %edi, filled_squares_counter
		je end_inner_block

		# grab the y at %edi index
		movl %edi, %eax
		imull $4, %eax
		movl $filled_squares_y, %ebx
		addl %eax, %ebx # %ebx has the address of the y being checked
		movl (%ebx), %ecx # %ecx now has the y of current square being checked
		
		cmpl %ecx, I(%ebp) 
		jne dont_change_value
		movl DROP_COUNT(%ebp), %esi
		addl %esi, (%ebx)
		dont_change_value:
		
		addl $1, %edi
		jmp inner_block
	end_inner_block:

	subl $1, I(%ebp)
	jmp disolve_block_loop4
end_disolve_block_loop4:

# part 5 print out the new square
movl $0, %edi
start_print_loop2:
	cmpl %edi, filled_squares_counter
	je end_start_print_loop2

	# grab the x at %edi index
	movl %edi, %eax
	imull $4, %eax
	movl $filled_squares_x, %ebx
	addl %eax, %ebx # %ebx has the address of the x being checked
	movl (%ebx), %esi # %ecx now has the x of current square being checked

	pushl $x
	pushl %esi

	# grab the y at %edi index
	movl %edi, %eax
	imull $4, %eax
	movl $filled_squares_y, %ebx
	addl %eax, %ebx # %ebx has the address of the y being checked
	movl (%ebx), %ecx # %ecx now has the y of current square being checked

	pushl %ecx
	
	pushl BLOCK_COLOR_PAIR
	call attron
	addl $4, %esp

	call mvprintw 
	addl $12, %esp

	pushl BLOCK_COLOR_PAIR
	call attroff
	addl $4, %esp

	addl $1, %edi
	jmp start_print_loop2
end_start_print_loop2:

call refresh

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function is_game_over
# determines if the game is over (player dies). no params passed in and 
# return 0 if the game is over
##############################################################################
.type is_game_over, @function
is_game_over:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

movl $0, %eax

cmpl $2, current_y
jle game_over_label
cmpl $2, current_y1
jle game_over_label
cmpl $2, current_y2
jle game_over_label
cmpl $2, current_y3
jle game_over_label
movl $1, %eax

game_over_label:

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function new_block
# takes no parameters and returns nothing
# whenever a new block is started at the top of the screen
##############################################################################
.type new_block, @function
new_block:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

# skip a bunch of stuff if at start of a game (current_y will be 0)
cmpl $0, current_y
je skip_for_start_of_game

addl $1, score
addl $1, blocks_completed
call leave_old_block

# check if the game ended (blocks hit top of screen)
call is_game_over
cmpl $0, %eax
jne game_not_over
pushl score
call game_over
game_not_over:

skip_for_start_of_game:

movl $0, current_rotation
movl $8, current_x
movl $1, current_y

# update the level stuff is it is time
cmpl $10, blocks_completed
je update_level
cmpl $20, blocks_completed
je update_level
cmpl $30, blocks_completed
je update_level
cmpl $40, blocks_completed
je update_level
cmpl $50, blocks_completed
je update_level
cmpl $60, blocks_completed
je update_level
cmpl $70, blocks_completed
je update_level
cmpl $80, blocks_completed
je update_level
cmpl $90, blocks_completed
je update_level
jmp skip_update_level

update_level:
subl $10, level_counter
addl $1, level

skip_update_level:

call disolved_blocks

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

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function left_move_ok
# takes no arguments
# returns 0 if can't go left 
##############################################################################
.type left_move_ok, @function
left_move_ok:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

call give_block_coord 

movl $0, %eax

# check against the left wall
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

##############################################################################
# function rotate_move_ok
# takes no arguments
# returns 0 if can't rotate
##############################################################################
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
##############################################################################
# function right_move_ok
# takes no arguments
# returns 0 if can't go right 
##############################################################################
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

##############################################################################
# function time_for_new_block
# takes no arguments
# returns 0 if the current hit bottom of screen from
# 1) the very bottom of the playable area
# 2) other older blocks at rest
##############################################################################
.type time_for_new_block, @function
time_for_new_block:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

.equ RETURN_VALUE, -4
subl $4, %esp

call give_block_coord 
movl $0, RETURN_VALUE(%ebp)

# PART 1
# 1) the very bottom of the playable area
cmpl $16, current_y
jge block_is_done
cmpl $16, current_y1
jge block_is_done
cmpl $16, current_y2
jge block_is_done
cmpl $16, current_y3
jge block_is_done

# PART 2
# 2) check if hit existing blocks
movl $0, %edi
movl $filled_squares_x, %eax
movl $filled_squares_y, %ebx

check_loop:
	cmpl %edi, filled_squares_counter 
	je end_check_loop

	movl (%eax), %ecx
	movl (%ebx), %edx

	subl $1, %edx

	# check square 1
	cmpl %ecx, current_x
	jne check_square_2
	cmpl %edx, current_y
	je block_is_done

	# check square 2
	check_square_2:
	cmpl %ecx, current_x1
	jne check_square_3
	cmpl %edx, current_y1
	je block_is_done

	# check square 3
	check_square_3:
	cmpl %ecx, current_x2
	jne check_square_4
	cmpl %edx, current_y2
	je block_is_done

	# check square 4
	check_square_4:
	cmpl %ecx, current_x3
	jne blocks_ok_for_this_iteration
	cmpl %edx, current_y3
	je block_is_done

	blocks_ok_for_this_iteration:

	addl $4, %eax
	addl $4, %ebx
	addl $1, %edi
	
	jmp check_loop
end_check_loop:


movl $1, RETURN_VALUE(%ebp)
block_is_done:

movl RETURN_VALUE(%ebp), %eax

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function does_movement_hit_existing_blocks
# takes 1 arg - the key stroke just hit (for left, right, 
# or rotate)
# returns 0 if the move is invalid
##############################################################################
.type does_movement_hit_existing_blocks, @function
does_movement_hit_existing_blocks:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

.equ KEY_HIT, 8 
.equ RETURN_VALUE, -4

subl $4, %esp

cmpl $0402, KEY_HIT(%ebp)
je prepare_rotate_logic
cmpl $107, KEY_HIT(%ebp)
je prepare_rotate_logic
jmp no_prepare_rotate_logic

prepare_rotate_logic:
	addl $1, current_rotation 
	cmpl $4, current_rotation
	jne dont_reset_rotation3
	movl $0, current_rotation
	dont_reset_rotation3:
no_prepare_rotate_logic:

call give_block_coord 

movl $0, RETURN_VALUE(%ebp)

movl $0, %edi
movl $filled_squares_x, %eax
movl $filled_squares_y, %ebx

check_loop_existing_block:
	cmpl %edi, filled_squares_counter 
	je end_check_loop_existing_block

	movl (%eax), %ecx
	movl (%ebx), %edx

	cmpl $106, KEY_HIT(%ebp)
	je go_left_check
	cmpl $260, KEY_HIT(%ebp)
	je go_left_check
	cmpl $108, KEY_HIT(%ebp)
	je go_right_check
	cmpl $261, KEY_HIT(%ebp)
	je go_right_check
	jmp end_key_check

	go_left_check:
	addl $1, %ecx
	jmp end_key_check
	go_right_check:
	subl $1, %ecx
	end_key_check:

	# check square 1
	cmpl %ecx, current_x
	jne do_check_square_2
	cmpl %edx, current_y
	je block_collision

	# check square 2
	do_check_square_2:
	cmpl %ecx, current_x1
	jne do_check_square_3
	cmpl %edx, current_y1
	je block_collision

	# check square 3
	do_check_square_3:
	cmpl %ecx, current_x2
	jne do_check_square_4
	cmpl %edx, current_y2
	je block_collision

	# check square 4
	do_check_square_4:
	cmpl %ecx, current_x3
	jne do_blocks_ok_for_this_iteration
	cmpl %edx, current_y3
	je block_collision

	do_blocks_ok_for_this_iteration:

	addl $4, %eax
	addl $4, %ebx
	addl $1, %edi
	
	jmp check_loop_existing_block
end_check_loop_existing_block:


movl $1, RETURN_VALUE(%ebp)
block_collision:

cmpl $0402, KEY_HIT(%ebp)
je prepare_rotate_logic2
cmpl $107, KEY_HIT(%ebp)
je prepare_rotate_logic2
jmp no_prepare_rotate_logic2

prepare_rotate_logic2:
	subl $1, current_rotation 
	cmpl $-1, current_rotation
	jne dont_reset_rotation4
	movl $3, current_rotation
	dont_reset_rotation4:
no_prepare_rotate_logic2:

movl RETURN_VALUE(%ebp), %eax

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function main_game_loop
# takes no parameter and returns nothings
##############################################################################
.type main_game_loop, @function
main_game_loop:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

.equ I, -4
.equ KEY_STROKE, -8
.equ TIME_VAL, -144
.equ SELECT_RESULT, -148
.equ TIMEVAL_tv_sec, -144
.equ TIMEVAL_tv_usec, -140
.equ FD_SET, -136

subl $144, %esp

# after a game ends i can come back into this function for 2nd and subsequent
# games. i need to initialize all the globals again.	
movl $0, temp_x
movl $0, temp_y
movl $100, level_counter
movl $0, blocks_completed
movl $0, current_rotation
movl $0, current_x
movl $0, current_y
movl $0, current_x1
movl $0, current_x2
movl $0, current_x3
movl $0, current_y1
movl $0, current_y2
movl $0, current_y3
movl $0, current_block_type
movl $0, score
movl $1, level
movl $0, filled_squares_counter

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

	movl $1, I(%ebp)
	time_loop:

		# draw block
		pushl BLOCK_COLOR_PAIR
		call draw_block
		addl $4, %esp

		#FD_ZERO(&rfds);
		pushl $128
		pushl $0
		movl %ebp, %eax
		subl $12, %eax
		# tricky memset counts forward, the stack goes backward, so start at end
		subl $127, %eax
		pushl %eax
		call memset
		addl $12, %esp 


		# FD_SET(0, &rfds);
		# i think this set the 0 bit to 1 
		movl %ebp, %eax
		subl $139, %eax 
		movb $1, (%eax)
		
		# tv.tv_sec = 5;
		# tv.tv_usec = 0;
		# struct timeval {
		#	time_t      tv_sec;     // seconds 
		#	suseconds_t tv_usec;    // microseconds 
		# };
		movl $0, TIMEVAL_tv_sec(%ebp)
		movl $10000, TIMEVAL_tv_usec(%ebp) # .01 seconds

		#retval = select(1, &rfds, NULL, NULL, &tv);
		movl %ebp, %eax
		subl $144, %eax
		pushl %eax
		pushl $0
		pushl $0
		movl %ebp, %eax
		subl $136, %eax
		pushl %eax
		pushl $1
		call select
		addl $20, %esp
		movl %eax, SELECT_RESULT(%ebp)
		
		# erase old block on screen
		pushl ALL_BLACK_COLOR_PAIR
		call draw_block
		addl $4, %esp
		
		# if it's > 0 then a keystroke is available
		call getch
		movl %eax, KEY_STROKE(%ebp)
		cmpl $-1, %eax 
		je end_keystroke
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
		cmpl $0403, KEY_STROKE(%ebp)
		je go_up
		cmpl $105, KEY_STROKE(%ebp)
		je go_up

		# this shouldn't be needed
		jmp end_keystroke
	
		# LEFT
		go_left:
		call left_move_ok
		cmpl $0, %eax
		je end_keystroke

		pushl KEY_STROKE(%ebp)
		call does_movement_hit_existing_blocks
		addl $4, %esp
		cmpl $0, %eax
		je end_keystroke

		subl $1, current_x
		jmp end_keystroke 

		# RIGHT
		go_right:
		call right_move_ok
		cmpl $0, %eax
		je end_keystroke

		pushl KEY_STROKE(%ebp)
		call does_movement_hit_existing_blocks
		addl $4, %esp
		cmpl $0, %eax
		je end_keystroke

		addl $1, current_x
		jmp end_keystroke 

		# ROTATE
		go_rotate:
		call rotate_move_ok
		cmpl $0, %eax
		je end_keystroke

		pushl KEY_STROKE(%ebp)
		call does_movement_hit_existing_blocks
		addl $4, %esp
		cmpl $0, %eax
		je end_keystroke

		addl $1, current_rotation
		cmpl $4, current_rotation
		jne end_keystroke
		movl $0, current_rotation
		jmp end_keystroke 

		go_up:
		movl level_counter, %eax
		movl %eax, I(%ebp)
		jmp end_keystroke 

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

##############################################################################
# function to draw basic frame around game play
# takes no parameters and returns nothing
##############################################################################
.type draw_frame, @function
draw_frame:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer
.equ I, -4  # loop counter variable
subl $4, %esp

call setup_color_pairs

call clear_screen

pushl FRAME_COLOR_PAIR
call attron
addl $4, %esp

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

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function to print_level_and_score
# takes no parameters and returns nothing
##############################################################################
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

##############################################################################
# function to clear_screen
# takes no parameters and returns nothing
##############################################################################
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
call attroff
addl $4, %esp

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function setup_color_pairs
# takes no parameters and returns nothing
# set up the global variables for the color pairs (makes things easier for
# later
##############################################################################
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

##############################################################################
# function to set the color
# takes 1 arg which is the color pair to set and returns nothing
##############################################################################
.type set_color, @function
set_color:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer
.equ COLOR_PAIR_PARAM, 8 

pushl COLOR_PAIR_PARAM(%ebp)
call COLOR_PAIR
addl $4, %esp

pushl %eax
call attron
addl $4, %esp

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret
