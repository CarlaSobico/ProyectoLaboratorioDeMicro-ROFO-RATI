;
; 29-04-15dos.asm
;
; Created: 30/4/2019 10:37:55 a. m.
; Author : carlasobico
;


;Programar una rutina que lea una tabla alojada en SRAM 
;a partir de la direccion TABLA_RAM, y que finaliza con el valor 0xFF.
; El byte leido se pasa en R20 como parametro de entrada de la rutina 
;CALCULA_PARIDAD. Cuando no hay mas datos se regresa con RET.

.EQU TABLA_SIZE=10
.EQU TABLA_RAM=SRAM_START 
.EQU MASCARA=0x01
.EQU MASCARA_BIT= 0b10000000
.DEF cero=R23

.DSEG 

.ORG TABLA_RAM 
	var1:			.BYTE 1  
	Tabla:			.BYTE TABLA_SIZE 
	Paridad:		.BYTE TABLA_SIZE
	Paridad_bit:	.BYTE TABLA_SIZE
.CSEG   
 
.ORG 0x00                   
	
	LDI ZL, LOW(Tabla)
	LDI ZH, HIGH(Tabla)
	LDI R20, TABLA_SIZE-1
	LDI R19, 0x01
	LDI R21, 0xFF
	LDI cero, 0x00

CARGAR_TABLA: ;Carga la tabla con valores del 1 al 9 siendo el ultimo 0xFF
	ST Z+, R19
	INC R19
	DEC R20
	BRNE CARGAR_TABLA
	LDI R19, 0xFF
	ST Z, R19

MAIN:
	LDI ZL, LOW(Tabla)	;Seteo punteros
	LDI ZH, HIGH(Tabla)
	LDI YL, LOW(Paridad_bit)
	LDI YH, HIGH(Paridad_bit)
	LDI XL, LOW(Paridad)
	LDI XH, HIGH(Paridad)
	LD R20, Z+
	CALL CALCULA_PARIDAD ;Calcula la paridad decimal pone en 1 si es impar y 0 si es par
	LDI ZL, LOW(Tabla) ;Vuelvo a setear para poder hacer la otra funcion
	LDI ZH, HIGH(Tabla)
	CALL CALCULA_PARIDAD_BIT ;Calcula el bit de paridad impar  (Cuenta cantidad de 1, si son cantidad par el bit se pone en 0 y si es impar se pone en 1)
FIN:
	JMP FIN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CALCULA_PARIDAD:
	ANDI R20, MASCARA
	ST X+, R20 ;Cargo si es par o impar
	LD R20, Z+
	CP R21,R20 ;termina cuando lee el 0xFF 
	BRNE CALCULA_PARIDAD
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CALCULA_PARIDAD_BIT:
	LDI R18, MASCARA_BIT
	CLR R24
BIT:
	LD R20,Z	
	AND R20, R18
	CPSE R20, cero ;Compara si es 0, si no es 0 incrementa el valor de R24 que luego se verá si es par o no 
	INC R24 
	LSR R18 ;Muevo la máscara a la izquierda para comparar el próximo bit
	BRCC BIT ;Si el carry se prende quiere decir que la máscara ya terminó, entonces mientras que esto no pase sigo viendo si hay 1
	CALL CALCULA_PARIDAD_BIS	
	LD R20, Z+
	CP R21,R20 ;termina cuando lee el 0xFF 
	BRNE CALCULA_PARIDAD_BIT
	RET


CALCULA_PARIDAD_BIS:
	ANDI R24, MASCARA
	ST Y+, R24 ;Carga la paridad en la tabla
	RET
	

