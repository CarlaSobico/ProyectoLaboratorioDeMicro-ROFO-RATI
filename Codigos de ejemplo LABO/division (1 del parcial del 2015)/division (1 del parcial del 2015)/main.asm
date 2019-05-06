;
; division (1 del parcial del 2015).asm
;
; Created: 4/5/2019 22:04:23
; Author : Ivan Lisman 100001
;


; Replace with your application code



.DEF DIVIDENDO = R16
.DEF DIVISOR = R17
.DEF COCIENTE = R22
.DEF RESTO = R23
.DEF AUX_DIVIDENDO = R18
.DEF AUX_DIVISOR = R19
.DEF SIGNO_DIVIDENDO = R20
.DEF SIGNO_DIVISOR = R21

.SET a = 0;
.SET b = 10;

.EQU MASCARA_SIGNO_8BITS = 0x80

LDI DIVIDENDO, a ; cargo el numero a (si es negativo, está en complemento A2)
LDI DIVISOR, b ; cargo el numero b (si es negativo, está en complemento A2)
LDI SIGNO_DIVIDENDO, 0x00 ; inicializo el signo del dividendo
LDI SIGNO_DIVISOR, 0x00; inicializo el signo del divisor

; ¿CUÁL EL NEGATIVO?

; ¿ES EL DIVIDENDO?
MOV AUX_DIVIDENDO, DIVIDENDO ; copio el registro dividendo para operar sin perder info
ANDI AUX_DIVIDENDO, MASCARA_SIGNO_8BITS ; consigo el bit de signo
BRNE DIVIDENDO_NEGATIVO ; si Z=0 (flag de la ANDI anterior) es porque el signo del dividendo es 1 (entonces es negativo)

; ¿ES EL DIVISOR?

CHEQUEAR_DIVISOR: MOV AUX_DIVISOR, DIVISOR ; copio el registro divisor para operar sin perder info
ANDI AUX_DIVISOR, MASCARA_SIGNO_8BITS ; consigo el bit de signo
BRNE DIVISOR_NEGATIVO ; si Z=0 (flag de la ANDI anterior) es porque el signo del divisor es 1 (entonces es negativo)
JMP DIVISION

DIVIDENDO_NEGATIVO: NEG DIVIDENDO ; complemento A2 del dividendo (ahora me quedo "positivo")
LDI SIGNO_DIVIDENDO, 0x01 ; como el dividendo es negativo, su signo es 1 (negativo)
JMP CHEQUEAR_DIVISOR ; primero chequeé el dividendo, ahora el divisor

DIVISOR_NEGATIVO: NEG DIVISOR ; complemento A2 del divisor (ahora me quedo "positivo")
LDI SIGNO_DIVISOR, 0x01 ; como el divisor es negativo, su signo es 1 (negativo)
JMP DIVISION


DIVISION: INC COCIENTE
SUB DIVIDENDO, DIVISOR
MOV RESTO, DIVIDENDO
SUB RESTO, DIVISOR
BRMI RESULTADOS
JMP DIVISION

RESULTADOS: EOR SIGNO_DIVIDENDO, SIGNO_DIVISOR ; chequeo el signo con una xor (1 x 1 = 0 x 0 -> z=0)
BREQ COCIENTE_POSITIVO 
NEG COCIENTE
COCIENTE_POSITIVO:
ADD RESTO, DIVISOR
FIN: JMP FIN