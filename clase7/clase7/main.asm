;
; clase7.asm
;
; Created: 24/4/2019 7:35:39 p. m.
; Author : carli
;


; Replace with your application code
.dseg

VEC: .byte 25

.cseg
ldi ZL, low(VEC) 
ldi ZH, high(VEC)

;;;;;;;;
IN R16, EICRA
ORI R16, (1<<isc00)|(1<<isc01)
ANDI R16, ~(1<<4) ; siempre se pone en rojo
OUT EICRA, R16

;RUTINA DE INICIALIZACION DE TIMER, SPI, PWM....

 .cseg
 
 .org INT0addr
	rjmp ISR ;a donde este la isr

	ISR:
	in r16, pinb
	reti

	;;;;;;;para hacer una interrumpicioin
