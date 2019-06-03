;
; ParcialEj1.asm
;
; Created: 31/5/2019 6:41:51 p. m.
; Author : carlasobico
;

;Problema1
; Se lee un valor en el puerto B (Valores entre 0 y FF) de un microcontrolador atmega 328p se quiere saber:
;1) Si ese de dicho valor es mayor o menor que la cte. almaceada en la direccion 0x500 de la memoria flash,
;si es mayor sumarle el valor que se encuentra la variable "valor", y almacenarla en la variable resultado.

;2)Si es menor trasmitir el valor leido en el puertoB en forma serial por e pin PA.1


.def AUX = r16
.def val_entrada = r17
.def cte = r18
.def cant = r19

.dseg
.org 0x100;SRAM_START
	valor: .byte 1
	resultado: .byte 1

.cseg
.org 0x00
	jmp main
.org INT_VECTORS_SIZE


main:
ldi aux, 4
sts valor, aux


mainprin:
	ldi aux, 0x00
	out ddrb, aux
	in val_entrada, pinb
	ldi zl, low(0x500<<1)
	ldi zh, high(0x500<<1)
	LPM cte, Z
	cp val_entrada, cte
	BRLO trasmitir
	ldi xl, low(valor)
	ldi xh, high(valor)
	ld aux, x
	add val_entrada, aux
	sts resultado, val_entrada
fin:jmp fin

trasmitir:
	in aux, ddrc
	ori aux, (1<<pc1)
	out ddrc, aux
	ldi cant, 0x08
loop:
	lsr val_entrada
	brcs mandar1
	clr aux
	out portc, aux
	dec cant
	brne loop
	jmp fin

mandar1:
	ldi aux, 0x02
	out portc, aux
	dec cant
	brne loop
	jmp fin

.org 0x500
	constante: .DW 8