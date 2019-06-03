;
; ParcialEj2.asm
;
; Created: 31/5/2019 7:06:28 p. m.
; Author : carlasobico
;


;Problema 2
; Asumiento que el registro20 esta configurado como BCD empaquetado, escriba un programa que convierta 
;los dos valores decimales en r20,  en ASCII y almacenarlos en los registros R22-R21
;0=0x30 ... 9=0x39

.def aux = r16
.def dif_a_ascii = r17

/*****parte agregada para que funcione****/

ldi r20, 0x92

BCD_ASCII:
	mov aux, r20
	andi aux, 0x0F
	ldi dif_a_ascii, 0x30
	add aux, dif_a_ascii
	mov r21, aux
	mov aux, r20
	swap aux
	andi aux, 0x0F
	add aux, dif_a_ascii
	mov r22, aux
	;ret
fin:jmp fin	;agregado

;funciona, hace lo que tiene que hacer, la unica confusion fue lo de ldi aux, r20 que lo cambie a mov aux, r20