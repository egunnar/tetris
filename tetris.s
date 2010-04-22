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
.ascii "Welcome to tetris\nThese are the top scores.\n\0"
welcome_string2:
.ascii "press any key to continue.\0"
score_file:
.ascii "tetris.dat\0"
print_f_code:
.ascii "-%c-\n\0"
#.ascii "-%.*s-\n\0"
print_f_code2:
.ascii "-%d-\n\0"
score_line:
.ascii "%s - %d\n\0"
#      "\n%d\n*"
ftwo:
.byte 42
str_ftwo:
.ascii "42\0"

.section .bss
.lcomm record_buffer, BUFFER_SIZE

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
.equ FILE_DESCRIPTOR, -4 
.equ BYTES_READ_IN, -8 
.equ ON_STRING_MODE, -12 
.equ DIGIT_NUMBER, -16
.equ SCORE, -20
.equ CURRENT_BYTE_INDEX, -24
.equ CURRENT_BYTE, -28

pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

# make room for local variables
#addl $28, %esp
subl $28, %esp

call init_ncurses
# 1) print welcome
pushl $welcome_string
call printw
addl $4, %esp
call refresh

# 2) print top scores file

# open the file for reading
movl  $SYS_OPEN, %eax
movl  $score_file, %ebx
movl  $0, %ecx    #This says to open read-only
movl  $0666, %edx
int   $LINUX_SYSCALL
#check
#pushl %eax # should be my file descriptor
movl %eax, FILE_DESCRIPTOR(%ebp)
# TODO	 if %eax if negative that means instead a error
# occurred and that is the error code

read_loop:
	# actually read into buffer
	movl FILE_DESCRIPTOR(%ebp), %ebx
	movl  $record_buffer, %ecx
	movl  $BUFFER_SIZE, %edx
	movl  $SYS_READ, %eax
	int   $LINUX_SYSCALL
	#check
	#pushl %eax
	movl %eax, BYTES_READ_IN(%ebp)
	#TODO check for error

	# if read nothing then end
	cmpl $0, %eax
	je end_read_loop
	
	movl $1, ON_STRING_MODE(%ebp)
	movl $0, DIGIT_NUMBER(%ebp)
	movl $0, CURRENT_BYTE_INDEX(%ebp)
	# loop on each byte
	each_byte_loop:
	movl BYTES_READ_IN(%ebp), %eax
	cmpl %eax, CURRENT_BYTE_INDEX(%ebp)
	je each_byte_loop_end
	movl CURRENT_BYTE_INDEX(%ebp), %ebx
	movl $0, %eax
	movb record_buffer(,%ebx, 1), %al
	movl %eax, CURRENT_BYTE(%ebp)

# FIXME don't print a \0 alone
		# if on string mode == true
		cmpl $0, ON_STRING_MODE(%ebp)
		je not_on_string_mode
			cmpl $0, CURRENT_BYTE(%ebp)
			je skip_print
			pushl CURRENT_BYTE(%ebp)
			pushl $print_f_code
			call printw
			addl $8, %esp
			call refresh
			jmp pre_each_byte_loop_end
			skip_print:
			movl $0, ON_STRING_MODE(%ebp)	
			movl $0, SCORE(%ebp)
			jmp pre_each_byte_loop_end

	    # if on string mode == false
		not_on_string_mode:
			# not right???
			#addl $1, CURRENT_BYTE_INDEX(%ebp)
			cmpl $3, DIGIT_NUMBER(%ebp)
			jne not_third_digit

			# on third digit
			# %al least signigant byte of %eax
			movl $0, %eax
			movb CURRENT_BYTE(%ebp), %al
			sall $24, %eax
		    orl %eax, SCORE(%ebp)	

			pushl SCORE(%ebp)
			pushl $print_f_code2
			call printw
			# not on 3rd digit
			addl $8, %esp
			call refresh
			movl $0, DIGIT_NUMBER(%ebp)
			jmp pre_each_byte_loop_end

			not_third_digit:
			#movl DIGIT_NUMBER(%ebp), %eax
			#cmpl 
			# %al least signigant byte of %eax
			movl $0, %eax
			movb CURRENT_BYTE(%ebp), %al

			cmpl $1, DIGIT_NUMBER(%ebp)
			jne test_two
			sall $8, %eax
			jmp end_of_shift

			test_two:
			cmpl $2, DIGIT_NUMBER(%ebp)
			jne end_of_shift
			sall $16, %eax

			end_of_shift:
		    orl %eax, SCORE(%ebp)	

			addl $1, DIGIT_NUMBER(%ebp)

	pre_each_byte_loop_end:
		addl $1, CURRENT_BYTE_INDEX(%ebp)
		jmp each_byte_loop
	each_byte_loop_end:
end_read_loop:
addl $4, %esp
########################################
# FIXME START_HERE
########################################


# 3) wait for key input to continue
call getch

splash_screen_end:
movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret


###################################
# function to get user name
###################################

###################################
# function to string_len 
###################################
.type string_len, @function
string_len:
.equ START_OF_STRING, 8 
pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

movl $0, %edi # %edi is the current index 
movl START_OF_STRING(%ebp), %ebx
string_len_loop:
cmpb $0, (%ebx) 
je string_len_end_loop
#incb %ebx
addl $1, %ebx
incl %edi
jmp string_len_loop

string_len_end_loop:
movl %edi, %eax

movl %ebp, %esp      #restore the stack pointer
popl %ebp            #restore the base pointer
ret

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
