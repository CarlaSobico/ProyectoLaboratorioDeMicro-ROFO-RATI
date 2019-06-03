;
; ParcialEj3.asm
;
; Created: 31/5/2019 7:17:38 p. m.
; Author : carlasobico
;

;Problema 3
;Supongamos que el espacio de memoria de datos empezando en la direccion $140 contiene el siguiente mensaje:
;"Si buscas resultados distintos, no hagas siempre lo mismo", /0
;Cuente las letra 'a' y saque el resultado por el puerto B


.def letra_a_ASCII=r16
.def letra = r17
.def cant_a = r18
.def aux = r19

.equ val_final = 0
.dseg
.org 0x140
	mensaje: .byte 60
.cseg



ldi xl, low(0x140)
	ldi xh, high(0x140)
	ldi zl, low(0x500<<1)
	ldi zh, high(0x500<<1)
back:
	lpm R19, Z+
	cpi r19, val_final
	breq contar_a
	st x+, r19
	jmp back



contar_a:
	ldi xl, low(0x140)
	ldi xh, high(0x140)
	ldi letra_a_ascii, 'a'
	clr cant_a
loop:
	ld letra, X+
	cpi letra, val_final
	breq fin_cadena
	cp letra, letra_a_ascii
	brne loop
	inc cant_a
	jmp loop

fin_cadena:
	ser aux
	out ddrb, aux
	out portb, cant_a
	;ret
fin: jmp fin ;agregado

.org 0x500
	mensajerom: .db "Si buscas resultados distintos, no hagas siempre lo mismo", 0

;funciona sin cambiar nada, le agregue el resto del codigo para poder hacerlo, la puse en rom para pasarla a la ram para probar