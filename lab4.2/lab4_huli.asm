; Henry Pan - hepan@ucsc.edu
; Hui Shi Li - huli@ucsc.edu
; CMPE12 - Section 6
; TA: Daphne Gorman
; Lab 4
; February 10, 2015
; 
; This program takes three user inputs and performs subtraction, multiplication
; and division of the two inputs, storing them in memory.



; The code will begin in memory at the address
; specified by .orig <number>.

	.ORIG   x3000

;strings
PROMPT1:	.STRINGZ	"This program accepts a SIGN and two-digit base-10 integers."
PROMPTS:	.STRINGZ	"\nSign: "
PROMPT2:	.STRINGZ	"\nFirst digit: "
PROMPT3:	.STRINGZ	"\nSecond digit: "
PROMPT4:	.STRINGZ	"\nInput is: "
; clear all registers that we may use
	AND	R0, R0, 0	;clear R0
	AND	R1, R0, 0	;clear R1
	AND	R2, R0, 0	;clear R2
	AND	R3, R0, 0	;clear R3
	AND	R4, R0, 0	;clear R4

; print out the intro
	LEA	R0, PROMPT1
	PUTS

; print out the sign prompt
	LEA	R0, PROMPTS
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; store entered string (otherwise it may be overwritten)
	ST	R0, SIGNINPUT

;;;;;;;;;;;;;;;;;;;;;FIRST INPUT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print out the first digit prompt
	LEA	R0, PROMPT2
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; subtract the ascii value
	ADD R0, R0, -12
	ADD R0, R0, -12
	ADD R0, R0, -12
	ADD R0, R0, -12

; store entered string (otherwise it may be overwritten)
	ST	R0, USERINPUT1

; print out the first input second digit prompt
	LEA	R0, PROMPT3
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; subtract the ascii value
	ADD R0, R0, -12
	ADD R0, R0, -12
	ADD R0, R0, -12
	ADD R0, R0, -12

; store entered string (otherwise it may be overwritten)
	ST	R0, USERINPUT2	

;check if the first input is 0
	LD	R1, USERINPUT1
	LD	R2, USERINPUT2
	ADD	R1, R1, R2
	STI	R1, FIRSTZERO
	BRz	SKIPFIRST	;if it is skip conversion
	AND	R1, R1, 0	;otherwise clear r1 and r2 and continue
	AND	R2, R2, 0

	JSR	TOINT		;convert input 1 to integer
	STI 	R4, INT1	;store integer result
	STI	R6, SIGN1	;store sign
	AND	R1, R1, 0	;clear r1
	LDI 	R1, INT1	;store integer in r1
	JSR	TOFLOAT		;convert input 1 to floating point
	STI	R5, MANTISSA1	;store mantissa
	STI	R2, EXPCOMP1	;store exponent
	STI	R1, FP1		;store floating point

;;;;;;;;;;;;;;;;;;;;;SECOND INPUT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SKIPFIRST:	;if the first input was 0, continue starting here

; print out the sign prompt for input 2
	LEA	R0, PROMPTS
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; store entered string (otherwise it may be overwritten)
	ST	R0, SIGNINPUT

; print out the second input first digit prompt
	LEA	R0, PROMPT2
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; subtract the ascii value
	ADD R0, R0, -12
	ADD R0, R0, -12
	ADD R0, R0, -12
	ADD R0, R0, -12

; store entered string (otherwise it may be overwritten)
	ST	R0, USERINPUT1

; print out the second input second digit prompt
	LEA	R0, PROMPT3
	PUTS

; get a user-entered character (result in R0)
; echo it back right away (otherwise it isn't visible)
	GETC
	PUTC

; subtract the ascii value
	ADD R0, R0, -12
	ADD R0, R0, -12
	ADD R0, R0, -12
	ADD R0, R0, -12

; store entered string (otherwise it may be overwritten)
	ST	R0, USERINPUT2

;check if the second input is 0
	LD	R1, USERINPUT1	
	LD	R2, USERINPUT2
	ADD	R1, R1, R2
	BRz	SKIPSECOND	;if so, skip to halt
	AND	R1, R1, 0	;otherwise clear r1, r2
	AND	R2, R2, 0

	JSR	TOINT		;convert to integer
	STI 	R4, INT2	;store result
	STI	R6, SIGN2	;store sign
	AND	R1, R1, 0	;clear r1
	LDI 	R1, INT2	;load int to r1
	JSR	TOFLOAT		;convert to floating point
	STI	R5, MANTISSA2	;store mantissa
	STI	R2, EXPCOMP2	;store exponent
	STI	R1, FP2		;store floating point

;check again if input 1 was 0
	AND	R1, R1, 0
	AND	R2, R2, 0
	LDI	R2, FIRSTZERO
	ADD	R1, R1, R2
	BRz	SKIPSECOND	;if so, skip to halt
	AND	R1, R1, 0	;otherwise clear r1, r2
	AND	R2, R2, 0

	JSR ADDEXPONENTS	;add exponents

	LDI	R1, MANTISSA1	;load first mantissa to r1
	AND	R5, R5,0	;clear r5
	ADD	R5, R5, 4	;set counter to 4
	JSR	RIGHTSHIFT	;right shift the mantissa 4 times
	STI	R4, MANTISSA1	;store mantissa of the first int

	LDI	R1, MANTISSA2	;load second mantissa to r1
	AND	R5, R5,0	;clear r5
	ADD	R5, R5, 4	;set counter to 4
	JSR	RIGHTSHIFT	;right shift the mantissa 4 times
	STI	R4, MANTISSA2	;store the second mantissa

	LDI	R1, MANTISSA1	;load first mantissa to r1
	LDI	R2, MANTISSA2	;load second mantissa to r2
	JSR	MMLOOP		;multiply mantissa
	

	JSR	CHECKPRODUCT	;check how many times to shift the product
	JSR	SHIFTEXPONENT	;shift the exponent
	JSR	REMOVE		;remove the leading 1
	JSR	PRODSIGN	;add sign to the product

SKIPSECOND:	; stop the processor
	HALT
USERINPUT1:	.FILL		0
USERINPUT2:	.FILL		0
;sign input
SIGNINPUT:	.FILL		0
FIRSTZERO:	.FILL		x320F	
;;;;;;;;;;;;;SUBROUTINES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRODSIGN:
	AND	R1, R1, 0	;clear r1, r2, r3
	AND	R2, R2, 0
	AND	R3, R3,	0
	LDI	R1, SIGN1	;load r1 with first input's sign
	LDI	R2, SIGN2	;load r2 with second input's sign
	ADD	R3, R1, R2	;add the signs together
	ADD	R3, R3, -1	;add -1 to that
	BRz	PRODUCTSN	;if the sign of the product is negative
	BRnp	PRODUCTSP	;if the sign of the product is positive
	
PRODUCTSN:
	AND	R1, R1, 0	;clear r1, r2, r3
	AND	R2, R2, 0
	AND 	R3, R3, 0
	LD	R1, SIGNBIT	;load signbit into r1
	LDI	R2, MANTISSASHIFT;load shifted mantissa to r2
	LDI	R3, EXPCOMPP	;load exponent to r3
	ADD	R1, R1, R2	;add the shifted mantissa to r1
	ADD	R1, R1, R3	;add the exponent to r1
	STI	R1, PRODUCT	;final product is in r1, store to product
	RET

PRODUCTSP:		
	AND	R1, R1, 0	;clear r1, r2, r3
	AND	R2, R2, 0
	AND 	R3, R3, 0
	LDI	R2, MANTISSASHIFT;load shifted mantissa to r2
	LDI	R3, EXPCOMPP	;load exponent to r3
	ADD	R1, R1, R2	;add the shifted mantissa to r1
	ADD	R1, R1, R3	;add exponent to r1
	STI	R1, PRODUCT	;final product is in r1, store to product	
	RET


REMOVE: ;removes leading 1 of mantissa
	AND	R1, R1, 0	;clear r1
	LD	R1, MMASK	;load mantissa mask to r1
	AND	R4, R4, 0	;clear r4
	LDI	R4, MANTISSASHIFT;load shifted mantissa to r4
	AND	R4, R4, R1	;and mask and shifted mantissa
	STI	R4, MANTISSASHIFT;store new mantissa w/o leading 1
	RET

SHIFTEXPONENT:
	AND	R4, R4, 0	;clear r4
	LDI	R4, EXPCOMPP	;load exponent to r4
	ADD 	R4, R4, R4	;left shift exponent component 10 times
	ADD 	R4, R4, R4	
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	STI	R4, EXPCOMPP	;store left shifted exponent for product
	RET

CHECKPRODUCT: 
;r6- result of ANDing
	AND	R4, R4, 0	;clear r4
	LD	R4, MASK2	;load mask2 to r4
	AND	R6, R6, 0	;clear r6
	AND	R6, R3, R4	;and mantissa and x2000
	BRz	SHIFT2		;if the result was 0, shift twice
	BRnp	SHIFT3		;if the result was not 0, shift 3 times
	RET

SHIFT2: 
	AND	R1, R1, 0	;clear r1
	ADD	R1, R3, 0	;add mantissa to r1
	AND	R5, R5, 0	;clear r5	
	ADD	R5, R5, 2	;set counter to 2
	AND	R0, R0, 0	;store trap to get back after jsr
	ADD	R0, R7, 0
	JSR	RIGHTSHIFT	;shift right 2 times
	AND	R7, R7, 0	;reload back the trap
	ADD	R7, R0, 0	
	STI	R4, MANTISSASHIFT;store shifted mantissa
	RET	

SHIFT3:
	AND	R1, R1, 0	;clear r1
	ADD	R1, R3, 0	;add mantissa to r1
	AND	R5, R5, 0	;clear r5
	ADD	R5, R5, 3	;set counter to 3
	AND	R0, R0, 0	;store trap to get back after jsr
	ADD	R0, R7, 0
	JSR	RIGHTSHIFT	;shift right 3 times
	AND	R7, R7, 0	;reload back the trap
	ADD	R7, R0, 0	
	STI	R4, MANTISSASHIFT;store shifted mantissa

	AND	R5, R5, 0	;clear r5
	LDI	R5, EXPCOMPP	;load exponent to r5
	ADD	R5, R5, 1	;add one to the exponent
	STI	R5, EXPCOMPP	;store exponent again
	RET	

ADDEXPONENTS: 
	AND	R1, R1, 0	;clear r1, r2, r3
	AND	R2, R2, 0
	AND	R3, R3, 0
	LDI	R1, EXPCOMP1	;load the first exponent to r1
	LDI	R2, EXPCOMP2	;load the second exponenet to r2
	ADD	R3, R1, R2	;add exponents
	ADD	R3, R3, -15	;subtract 15 from the sum
	STI	R3, EXPCOMPP	;store the exponent of the product
	RET	

MMLOOP:
	ADD	R3, R3, R1	;add mantissa1 to the product
	ADD	R2, R2, -1	;decrement mantissa2
	BRp	MMLOOP		;continue until mantissa2 is 0
	STI	R3, MANTISSAP	;store the product of the mantissas
	RET
;;;;;;;;;;;;;;;;;INTEGER CONVERSION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TOINT:
	LD	R1, SIGNINPUT	;load r1 with the sign
	LD	R2, USERINPUT1	;load r2 with the first input
	LD	R3, USERINPUT2	;load r3 with the second input
	AND	R4, R4, 0	;clear R4 (product)
	AND	R5, R5, 0	;clear R5 (factor)
	AND	R6, R6, 0	;clear R6 (sign)
	ADD	R5, R5, 10	;set R5 to 10

MLOOP:	
	ADD	R4, R4, R2	;add input 1 to R4
	ADD	R5, R5, -1	;decrement R5
	BRp	MLOOP		;if R5 is positive loop back
	ADD	R4, R4, R3
SIGNCHECK: 
;add -45 to that input   
   	ADD	R1, R1, #-12   
	ADD	R1, R1, #-12
	ADD	R1, R1, #-12
	ADD	R1, R1, #-9
	BRz	NEGSIGN		;if its zero, sign = -
	BRn	POSSIGN		;if its negative, sign = +

NEGSIGN:
	ADD	R6, R6, #1	;sign is 1 if integer is negative

POSSIGN:
	ADD	R6, R6, #0	;sign is 0 if integer is positive
	
	RET
;;;;;;;;;;;;;;;;;;;FLOATING POINT CONVERSION;;;;;;;;;;;;;;;;;;;;;;;;;;;
TOFLOAT:
	LD 	R2, MASK	;load r2 with mask
	AND 	R3, R3, 0	;clear R3, R4, R5
	AND 	R4, R4, 0	
	AND 	R5, R5, 0	
INCREMENT:
	ADD 	R3, R3, #1	;increment exponent counter
	ADD 	R1, R1, R1	;left shift integer

	AND 	R5, R1, R2	;check for match with mask
	BRz 	INCREMENT	;keep left shifting while still 0
	BRp 	EXPONENT	
EXPONENT:
	AND	R5, R5, 0	;clear r5
	ADD	R5, R5, R1	;store mantissa in R5
	ADD 	R4, R4, #12	;r4 will be 24
	ADD 	R4, R4, #12	

	NOT 	R3, R3		;invert
	ADD 	R3, R3, #1	;add one
	ADD 	R4, R4, R3	;subtracts exponent counter from 24
	AND	R2, R2, 0	;clear r2
	ADD	R2, R2, R4	;store the exponent component to R2
	ADD	R2, R2, 1	;correct the exponent component in R2	

	ADD 	R4, R4, R4	;left shift exponent component 10 times
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4
	ADD 	R4, R4, R4

	ADD 	R1, R1, R4	;add exponent component to mantissa

	AND	R6, R6, R6
	BRp	SNEG
	RET
SNEG:
	LD	R0, SIGNBIT	;if sign is negative
	ADD	R1, R1, R0	
	RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;RIGHT SHIFT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;r2- 2
;r3- quotient
;r1- mantissa loaded
;r4- mantissa
RIGHTSHIFT:
	AND	R2, R2, 0
	ADD	R2, R2, 2	;divisor
	AND	R3, R3, 0	;clear R3 (quotient)
	ADD	R4, R1, 0	

	NOT	R2, R2
	ADD	R2, R2, 1

DLOOP:	
	ADD	R5, R5, -1	;decrement counter	
	BRzp	DIVIDE2		;divide as long as counter is not negative
	RET
DIVIDE2:
	ADD	R3, R3, 1	;R3 = R3 + 1
	ADD	R4, R2, R4	;add R2 to R4
	BRp	DIVIDE2
	ADD	R4, R3, 0	;have the quotient be the new divdend
	AND	R3, R3, 0	;clear the quotient
	BRnzp	DLOOP

;vars
PRODUCT:	.FILL	x3200
INT1:		.FILL	x3201
INT2:		.FILL	x3202
FP1:		.FILL	x3203
FP2:		.FILL	x3204
SIGN1:		.FILL	x3205
SIGN2:		.FILL	x3206
EXPCOMP1:	.FILL	x3207
EXPCOMP2:	.FILL	x3208
MANTISSA1:	.FILL	x3209 ;w
MANTISSA2:	.FILL	x320A ;w
SIGNP:		.FILL	x320B ;w
EXPCOMPP:	.FILL	x320C ;w
MANTISSAP:	.FILL	x320D ;w
MANTISSASHIFT:	.FILL	x320E

MASK:		.FILL	1024
MASK2:		.FILL	8192
SIGNBIT:	.FILL	32768
MMASK:		.FILL	1023

; end of code
	.END
