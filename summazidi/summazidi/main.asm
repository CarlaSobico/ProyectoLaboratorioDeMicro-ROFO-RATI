;
; summazidi.asm
;
; Created: 24/4/2019 10:59:14 a. m.
; Author : carli
;
;.include "m328pdef.inc" 

; Replace with your application code

.EQU SUM = 0x300
.set fran = 0x1
;.org 00
.dseg 
 mem :.byte 1


	;rjmp inicio;
.CSEG
.org 00
inicio: 
	ldi XL, fran
	LDI R16, 0x25
	STS SUM, R16
	LDI R17, 0x34
	LDI R18, 0b00110001
moco :
	ADD R16, R17
	ADD R17, R18
	LDI R17, 11
	ADD R16, R17
	STS SUM, R16
	STS XL, R16
	XL+
	jmp moco
HERE : JMP HERE

