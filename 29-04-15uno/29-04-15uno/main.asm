;
; 29-04-15uno.asm
;
; Created: 27/4/2019 4:36:16 p. m.
; Author : carlasobico
;


;Codificar a assembler para AVR una subrutina que, dados dos numeros de 8 bits
;con signo en convencion complemento a 2 en los registros R16(dividendo) y R17 (divisor),
;devuelva el resultado de su division en R18 el cociente y en R19 el resto y el bit T (SREG.6)
;en uno si el divisor es cero

.equ SHIFT_SIGNO_8BITS=0x07
.equ dividendo = 0b11001001
.equ divisor = 0b11110110
.equ on=1
.equ off=0
.def regdividendo=r16
.def regdivisor=r17
.def cociente=r18
.def resto=r19
.def aux=r20
.def dividendonegativo=r21
.def divisornegativo=r22
.def aux2=r23

.cseg
	ldi regdividendo, dividendo
	ldi regdivisor,divisor
	ldi aux2, off
	ldi dividendonegativo, off
	ldi divisornegativo, off
	;mov r18,r16
	;add r18,r17
	mov aux,regdividendo
	andi aux, (1<<SHIFT_SIGNO_8BITS)
	cpse aux, aux2
	rcall NEGATIVO1
	mov aux,regdivisor
	andi aux, (1<<SHIFT_SIGNO_8BITS)
	cpse aux, aux2
	rcall NEGATIVO2

DIVISION:
	inc cociente
	sub regdividendo, regdivisor
	mov resto, regdividendo
	sub resto, regdivisor
	BRMI RESULTADOS
	jmp DIVISION

RESULTADOS:
	ldi aux,off
	sub dividendonegativo, divisornegativo
	Cpse dividendonegativo,aux
	neg cociente
	cpse cociente, aux
	BSET 6
	add resto, regdivisor
	jmp FIN

	
NEGATIVO1:
	neg regdividendo
	ldi dividendonegativo, on
	ret

NEGATIVO2:
	neg regdivisor
	ldi divisornegativo, on
	ret

	
FIN:
	jmp FIN
	



