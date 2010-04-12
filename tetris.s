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
.ascii "-%.*s-\n\0"
temp_str:
.ascii "1%d2\0"
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
.equ PRINTED_CHARACTERS, -12 

pushl %ebp           #save old base pointer
movl  %esp, %ebp     #make stack pointer the base pointer

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
pushl %eax # should be my file descriptor
# TODO	 if %eax if negative that means instead a error
# occurred and that is the error code


read_loop:
# actually read into buffer
movl FILE_DESCRIPTOR(%ebp), %ebx
movl  $record_buffer, %ecx
movl  $BUFFER_SIZE, %edx
movl  $SYS_READ, %eax
int   $LINUX_SYSCALL
pushl %eax
#TODO check for error

# if read nothing then end
# FIXME never is true
#cmpl $0, BYTES_READ_IN(%ebp) why don't this work ???
cmpl $0, %eax
je end_read_loop

# FIXME erase
# why the fuck can't i get this to not throw
# seg fault
pushl BYTES_READ_IN(%ebp)
pushl $52
pushl $temp_str
call printw
addl $12, %esp

pushl $record_buffer
pushl BYTES_READ_IN(%ebp)
pushl $print_f_code
call printw 
addl $12, %esp
call refresh

jmp read_loop
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
