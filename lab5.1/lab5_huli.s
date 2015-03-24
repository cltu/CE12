
#include <WProgram.h>

/* define all global symbols here */
.global MyFunc
.global Counter
.global milliseconds

.text
.set noreorder


/*********************************************************************
 * Setup MyFunc
 ********************************************************************/
.ent MyFunc
MyFunc:
/*push stack*/
ADD $sp, $sp, -4
SW $ra, 0($sp)

/*loading string and counter to be printed*/
LA $a0, myStr2
LA $t1, Counter
LW $a1, 0($t1)

/*prints the value of PortD temp */
LA $t3, Value

JAL printf
NOP


/*checks the value of the first bit of t1con*/
LI $t0, 0x8000
LA $t1, T1CON
LW $t2, 0($t1)
AND $t0, $t2, $t0

/* if the timer has been set, skip */
bgtz $t0, SKIP

/*part 1 - clear t1con*/
la $t1, T1CON
addi $t0, $zero, 0xFFFF
sw $t0, 4($t1)


/*part 2- set prescalar*/
la $t1, T1CON
addi $t0, $zero, 0x0030
sw $t0, 8($t1)


/*part 3 - clear count*/
la $t0, TMR1
addi $t1, $zero, 0xFFFF
sw $t1, 4($t0)


/*part 4 - set the value for PR1*/
/*set pr1 = 10mhz/256*/
la $t0, PR1
addi $t1, $zero, 0x4000
sw $t1, 8($t0)


/*part 5 - set interrupt priority */
la $t0, IPC1
addi $t1, $zero, 0x0004
sw $t1, 8($t0)


/*part 6 - clear prior interrupt*/
    la $t0, IFS0
addi $t1, $zero, 0x0010
sw $t1, 4($t0)


/*part 7 - enable the interrupt*/
la $t0, IEC0
addi $t1, $zero, 0x0010
sw $t1, 8($t0)


/*part 8 - turn on the timer*/
la $t0, T1CON
addi $t1, $zero, 0x8000
sw $t1, 8($t0)


SKIP:



/*incrementing counter*/
LA $t1, Counter
LW $t2, 0($t1)
ADD $t2, $t2, 1
SW $t2, 0($t1)

/* loading portd and getting the delay */
la $s1, PORTD
lw $s2, 0($s1)

/* calculating the delay by masking for 8-11, then dividing it by 256 and multiplying it by clock time*/
and $s2, $s2, 0xF00
div $s2, $s2, 256
la $s3, Clock
lw $s4, 0($s3)
mult $s2, $s4
mflo $s2

/*returning the delay*/
addu $v0, $zero, $s2


/*pop stack*/
LW $ra, 0($sp)
ADD $sp, $sp, 4

JR $ra

.end MyFunc


/*********************************************************************
 * This is your ISR implementation. It is called from the vector table jump.
 ********************************************************************/
Lab5_ISR:

li $t9, 0x0010
la $t8, IFS0
SW $t9, 4($t8)
    /*clear IFS0*/

li $t9, 0x00FF
la $t7, PORTE
SW $t9, 8($t7)
/* set the first 8 bits of PORTE*/


ERET
NOP
	
/*********************************************************************
 * This is the actual interrupt handler that gets installed
 * in the interrupt vector table. It jumps to the Lab5
 * interrupt handler function.
 ********************************************************************/
.section .vector_4, code
	j Lab5_ISR
	nop


.data
myStr: .asciiz "This is a test!\n"
myStr2: .asciiz "Hello, world! %d\n"
milliseconds: .word 0
Counter: .word 0
Value: .word 0
Clock: .word 0x80000
Timer: .word 0x40000
