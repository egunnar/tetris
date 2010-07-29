# FIXME - think there is a bug can rotate below bottom of playable area
# TODO - finish implementing the score part (scoring top 10 scores in a file)
# a lot of stuff is commented out for this functionality. I'd like to finish 
# some day.

.include "tetris_main.s"
.include "tetris_end_screen.s"
.section .data

# System Call Numbers
.equ SYS_EXIT, 1
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_BRK, 45

.equ LINUX_SYSCALL, 0x80

# Standard File Descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# Common Status Codes
.equ END_OF_FILE, 0
.equ BUFFER_SIZE, 1000 

welcome_string:
.ascii "Welcome to tetris\n\0"
#score_file:
#.ascii "tetris.dat\0"
#print_f_code:
#.ascii "%c\0"
#.ascii "-%.*s-\n\0"
#print_f_code2:
#.ascii " %d\n\0"
print_f_code3:
.ascii "Directions\n\tTo move left use left arrow or \"j\" key\n"
.ascii "\tTo move right use right arrow or \"l\" key\n"
.ascii "\tTo move the block down faster use up arrow or \"i\" key\n"
.ascii "\tTo rotate use the down arrow or \"k\" key\n"
.ascii "\n\nPress any key to start game\0"
print_f_code4:
.ascii "\nYour terminal does not support colors. Sorry, I can not continue\0"

.section .bss
.lcomm record_buffer, BUFFER_SIZE

##############################################################################
# function _start
# entry point for game. takes no parameters and returns status code program
##############################################################################
.section .text
.globl _start
_start:

call splash_screen
call main_game
call close_ncurses

movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL

##############################################################################
# function to print splash screen
# takes no parameters and returns nothing
##############################################################################
# no input and return value ignored
.type splash_screen, @function
splash_screen:
.equ FILE_DESCRIPTOR, -4 
.equ BYTES_READ_IN, -8 
.equ ON_STRING_MODE, -12 
.equ DIGIT_NUMBER, -16
.equ SCORE, -20
.equ CURRENT_BYTE_INDEX, -24
.equ CURRENT_BYTE, -28

pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

subl $28, %esp

call init_ncurses

# 1) print welcome
pushl $welcome_string
call printw
addl $4, %esp
call refresh

## 2) print top scores file
#
## open the file for reading
#movl  $SYS_OPEN, %eax
#movl  $score_file, %ebx
#movl  $0, %ecx    #This says to open read-only
#movl  $0666, %edx
#int   $LINUX_SYSCALL
##check
##pushl %eax # should be my file descriptor
#movl %eax, FILE_DESCRIPTOR(%ebp)
## TODO	 if %eax if negative that means instead a error
## occurred and that is the error code
#
#read_loop:
#	# actually read into buffer
#	movl FILE_DESCRIPTOR(%ebp), %ebx
#	movl  $record_buffer, %ecx
#	movl  $BUFFER_SIZE, %edx
#	movl  $SYS_READ, %eax
#	int   $LINUX_SYSCALL
#	#check
#	#pushl %eax
#	movl %eax, BYTES_READ_IN(%ebp)
#	#TODO check for error
#
#	# if read nothing then end
#	cmpl $0, %eax
#	je end_read_loop
#	
#	movl $1, ON_STRING_MODE(%ebp)
#	movl $0, DIGIT_NUMBER(%ebp)
#	movl $0, CURRENT_BYTE_INDEX(%ebp)
#	# loop on each byte
#	each_byte_loop:
#	movl BYTES_READ_IN(%ebp), %eax
#	cmpl %eax, CURRENT_BYTE_INDEX(%ebp)
#	je each_byte_loop_end
#	movl CURRENT_BYTE_INDEX(%ebp), %ebx
#	movl $0, %eax
#	movb record_buffer(,%ebx, 1), %al
#	movl %eax, CURRENT_BYTE(%ebp)
#
#		# if on string mode == true
#		cmpl $0, ON_STRING_MODE(%ebp)
#		je not_on_string_mode
#			cmpl $0, CURRENT_BYTE(%ebp)
#			je skip_print
#			pushl CURRENT_BYTE(%ebp)
#			pushl $print_f_code
#			call printw
#			addl $8, %esp
#			call refresh
#			jmp pre_each_byte_loop_end
#			skip_print:
#			movl $0, ON_STRING_MODE(%ebp)	
#			movl $0, SCORE(%ebp)
#			jmp pre_each_byte_loop_end
#
#	    # if on string mode == false
#		not_on_string_mode:
#			# not right???
#			#addl $1, CURRENT_BYTE_INDEX(%ebp)
#			cmpl $3, DIGIT_NUMBER(%ebp)
#			jne not_third_digit
#
#			# on third digit
#			# %al least signigant byte of %eax
#			movl $0, %eax
#			movb CURRENT_BYTE(%ebp), %al
#			sall $24, %eax
#		    orl %eax, SCORE(%ebp)	
#			pushl SCORE(%ebp)
#			pushl $print_f_code2
#			call printw
#			addl $8, %esp
#			call refresh
#			movl $0, DIGIT_NUMBER(%ebp)
#			movl $1, ON_STRING_MODE(%ebp)
#			jmp pre_each_byte_loop_end
#
#			not_third_digit:
#			#movl DIGIT_NUMBER(%ebp), %eax
#			#cmpl 
#			# %al least signigant byte of %eax
#			movl $0, %eax
#			movb CURRENT_BYTE(%ebp), %al
#
#			cmpl $1, DIGIT_NUMBER(%ebp)
#			jne test_two
#			sall $8, %eax
#			jmp end_of_shift
#
#			test_two:
#			cmpl $2, DIGIT_NUMBER(%ebp)
#			jne end_of_shift
#			sall $16, %eax
#
#			end_of_shift:
#		    orl %eax, SCORE(%ebp)	
#
#			addl $1, DIGIT_NUMBER(%ebp)
#
#	pre_each_byte_loop_end:
#		addl $1, CURRENT_BYTE_INDEX(%ebp)
#		jmp each_byte_loop
#	each_byte_loop_end:
#end_read_loop:
#addl $4, %esp

pushl $print_f_code3
call printw
addl $4, %esp

# 3) wait for key input to continue
call getch

splash_screen_end:
movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function to init ncurses 
# takes no parameters and returns nothing. it can end the program if something
# goes wrong though.
##############################################################################
.type init_ncurses, @function
init_ncurses:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

# Start curses mode
call initscr  

#To disable the buffering of typed characters by the TTY
#driver and get a character-at-a-time input
call cbreak

#suppress automatic echoing of typed characters
call noecho

#in order to capture special keystorkes like arrow keys	
#keypad(stdscr, TRUE);	
pushl $1
push stdscr
call keypad
addl $8, %esp

#make cursor invisible
#curs_set(0);
pushl $0
call curs_set
addl $4, %esp

#	if(has_colors() == FALSE)
#	{	endwin();
#		printf("Your terminal does not support color\n");
#		exit(1);
#	}
call has_colors
cmpl $0, %eax
je no_colors_end_game
jmp has_colors_continue

no_colors_end_game: 
call endwin
pushl $print_f_code4
call printf
add $4, %esp
pushl $1
call exit

has_colors_continue:
call start_color

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

##############################################################################
# function to close/clean up ncurses 
# takes no parameters and returns nothing
##############################################################################
.type close_ncurses, @function
close_ncurses:
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

call endwin			 # End curses mode		  */

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret
