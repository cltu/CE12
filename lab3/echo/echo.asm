
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

; print out a greeting
	LEA	R0, GREETING
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; store entered string (otherwise it may be overwritten)
;48-15=33-15
	ADD	R0, R0, #-12
	ADD	R0, R0, #-12
	ADD	R0, R0, #-12
	ADD	R0, R0, #-12
	ST	R0, USERINPUT1
	ST	R1, USERINPUT1

; print out a newline and some other stuff
	LEA	R0, NEWLINE
	PUTS

; print out the user's input
	LD	R0, USERINPUT1
	PUTC

; print out a greeting
	LEA	R0, GREETING
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; store entered string (otherwise it may be overwritten)
	ADD	R0, R0, #-12
	ADD	R0, R0, #-12
	ADD	R0, R0, #-12
	ADD	R0, R0, #-12
	ST	R0, USERINPUT1

; print out a newline and some other stuff
	LEA	R0, NEWLINE
	PUTS

; print out the user's input
	LD	R0, USERINPUT1
	PUTC


; stop the processor
	HALT



; data declarations follow below



; strings
GREETING:	.STRINGZ	"WELCOME! \nPlease enter a number: "
GREETING2:	.STRINGZ	"ENTER ANOTHER NUMBER:"
NEWLINE:	.STRINGZ "\n--> ";

; variables
USERINPUT1:	.FILL	0
USERINPUT2:	.FILL	0

; end of code
	.END
