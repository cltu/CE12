
; The code will begin in memory at the address
; specified by .orig <number>.

	.ORIG   x3000


START:
; clear all registers that we may use
	AND	R0, R0, 0
	AND	R1, R0, 0
	AND	R2, R0, 0
	AND	R3, R0, 0
	AND	R4, R0, 0
	AND	R5, R0, 0
	AND	R6, R0, 0
	AND	R7, R0, 0

;///////////////INPUT1/////////////////////
; print out a greeting
	LEA	R0, GREETING
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; store entered string (otherwise it may be overwritten)
; add -16 three times to subtract 48 from input's ascii value, since it starts 48 = 0
; since max negative value to be represented with 5 bits is -16
	ADD	R0, R0, #-16
	ADD	R0, R0, #-16
	ADD	R0, R0, #-16
; store content of r0 in userinput1 label
	ST	R0, USERINPUT1

; print out a newline
	LEA	R0, NEWLINE
	PUTS

; print out the user's input
	LD	R0, USERINPUT1
; add 12 four times back to output
; since max positive value to be represented w/ 5 bits is 15
	ADD	R0, R0, #12
	ADD	R0, R0, #12
	ADD	R0, R0, #12
	ADD	R0, R0, #12
	PUTC

;////////////////INPUT2/////////////////////

; print out the second greeting
	LEA	R0, GREETING2
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; store entered string (otherwise it may be overwritten)
; add -16 three times to subtract 48 from input's ascii value, since it starts 48 = 0
	ADD	R0, R0, #-16
	ADD	R0, R0, #-16
	ADD	R0, R0, #-16
	;ADD	R0, R0, #-12
	ST	R0, USERINPUT2

; print out a newline
	LEA	R0, NEWLINE
	PUTS

; print out the user's input
; add 12 four times back to output
	LD	R0, USERINPUT2
	ADD	R0, R0, #12
	ADD	R0, R0, #12
	ADD	R0, R0, #12
	ADD	R0, R0, #12
	PUTC

;/////////////OPERATIONS/////////////////
;subtract
	JSR	SUBTRACT

;multiply
	JSR	MULTIPLY

;divide
	JSR	DIVIDE

; stop the processor
	HALT


;/////////////STRINGS/////////////////
GREETING:	.STRINGZ	"WELCOME! \nPlease enter a number: "
GREETING2:	.STRINGZ	"\nENTER ANOTHER NUMBER:"
NEWLINE:	.STRINGZ 	"\n";

;//////////VARIABLES///////////////////
USERINPUT1:	.FILL	0
USERINPUT2:	.FILL	0
SUBOUTPUT:	.FILL	x3100
PRODUCT:	.FILL 	x3101
QUOTIENT:	.FILL	x3102
REMAINDER:	.FILL	x3103


;////////////SUBROUTINES//////////////////
SUBTRACT:
; load userinput2 to r5
	LD	R5, USERINPUT2
; invert userinput2 for 2's complement
	NOT 	R5, R5
; add 1 to that
	ADD 	R5, R5, #1
; load userinput1 to r6
	LD	R6, USERINPUT1
	ADD	R6, R5, R6
; store r6 in the memory address of suboutput 
	STI	R6, SUBOUTPUT
	RET


MULTIPLY:
; r5 will be the counter
	LD	R5, USERINPUT2 
; r6 will be input1
	LD	R6, USERINPUT1 

; add r6 to r2, r5 times as long as r5 is positive
	REPEAT:
		ADD	R2, R2, R6
		ADD	R5, R5, #-1	
		BRp	REPEAT
; store r2 in the memory address of product
	STI	R2, PRODUCT
	RET

	
DIVIDE:
; R3- quotient counter
; R5- userinput1 - dividend, remainder
; R6- userinput2- 2's complement of divisor
; R0- userinput2- divisor
	LD	R5, USERINPUT1
	LD	R6, USERINPUT2
	LD	R0, USERINPUT2
; invert userinput2 to get 2's complement and add 1
	NOT	R6, R6
	ADD	R6, R6, #1

	REPEATDIV:
		; add 1 to quotient counter
		ADD	R3, R3, #1
		; add r5 and r6 and store in r5
		ADD	R5, R6, R5
		BRn	NEGATIVE
		BRzp	REPEATDIV
	
	
	; if r5/dividend was negative
	NEGATIVE:
		; add -1 to subtract from the quotient counter
		ADD	R3, R3, #-1
		; add back divisor to remainder
		ADD	R5, R5, R0
		; store r3 and r5 in respective memory address
		STI	R3, QUOTIENT
		STI	R5, REMAINDER	
		RET

	STI	R3, QUOTIENT
	STI	R5, REMAINDER	
	RET

; end of code
	.END
