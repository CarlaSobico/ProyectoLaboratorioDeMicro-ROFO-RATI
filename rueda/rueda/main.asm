;
; rueda.asm
;
; Created: 24/4/2019 7:48:00 p. m.
; Author : carli
;


; Replace with your application code
; .cseg
 
 ;.org INT0addr ;pd2 
	;rjmp ISR ;a donde este la isr

	;ISR:
	;in r16, pinb
	;SREGreti

SETEO:
	IN R17, EIMSK
	ORI R17, (1<<INT0)    
	OUT EIMSK, R17; Habilitamos el int0 para interrupciones

	LDS R17, EICRA ;El lds se usa para cuando esta por arriba de 0x63
	ORI R17, (1<<ISC00)|(1<<ISC01)
	STS EICRA, R17 ;Configuramos flanco ascendente

	IN R17, SREG
	ORI R17, (1<<SREG_I)
	OUT SREG, R17 ; Configuramos que haya interrupcuibes


ISR:
	IN R16, PINB
	LDI R17, 0
	CPSE R16, R17
	JMP VERDE
	JMP ROJO
	;RETI ;se puede no poner el reti aca y volver desde los jmp?

		 
VERDE:
	LDI R17, 1
	EOR R16 , R17
	OUT PC5 , R16
	RETI

ROJO:
	LDI R17, 1
	EOR R16 , R17
	OUT PC4 , R16
	RETI
