;
; ejercicio 3.asm
;
; Created: 5/5/2019 14:47:19
; Author : ivanl
;


;Programar una rutina que levante una tabla ubicada en ROM (TABLA_ROM) y copie a
;una tabla ubicada en SRAM (TABLA_RAM) solamente los ASCII de números
;(ASCII(‘0’)=30h … ASCII(‘9’)=39h). La Tabla en ROM termina con 0xFF y no tiene
;más de 1000 posiciones.

.DEF NUMBER_ROM = R16

.EQU MASK_30 = 0xF0 ; esta máscara es 0b11110000 porque quiero recuperar los primeros 4 bits del número de la tabla en ROM
.EQU END_OF_TABLE = 0xFF ; el final de la tabla es 0xFF


.CSEG

	TABLE_ROM: .DB 0, 3, 100, "hola", 3, 24,100 ,0XFF

.DSEG
	TABLE_RAM: .BYTE 1000

.ORG 0x00

	
	LDI XL, LOW(TABLE_ROM)
	LDI XH, HIGH(TABLE_ROM)

	LDI ZL, LOW(TABLE_RAM)
	LDI ZH, HIGH(TABLE_RAM)  ; inicializo los punteros

COPY_VALUE:	LD NUMBER_ROM, X+ ; cargo el numero de la tabla ROM y apunto al prox
			CPI NUMBER_ROM , END_OF_TABLE ; sigo copiando o es EOT?
			BREQ FIN
			ANDI NUMBER_ROM, MASK_30 ; solo quiero chequear que onda con el primber nibble



			JMP COPY_VALUE ; veo el próximo


FIND		JMP FIN ; termina el programa