;
; ejercicio1.asm
;
; Created: 4/5/2019 14:49:18
; Author : Ivan Lisman 100001
;


;Programar en Assembly un bucle infinito que lee los 8 bits de los terminales del puerto
;B y se lo pasa a un rutina FILTRO a través de una variable ENTRADA en RAM. Luego
;recibe en la variable SALIDA el resultado y lo saca por el puerto C. Definir las variables
;en memoria RAM, inicializar SALIDA en 0 y la pila antes de invocar a FILTRO por
;primera vez.

.DEF R_AUX = R16
.DEF R_BYTE_DE_PRUEBA = R17
.DEF R_ENTRADA = R18
.DEF R_SALIDA = R19
.DEF R_PILA = R20

.EQU DATO_PRUEBA = 0b10101101 ; 0xAD
.EQU ON_REGISTRO = 0xFF
.EQU OFF_REGISTRO = 0x00


.cseg

.ORG 0x00                   

LDI R_AUX, ON_REGISTRO ; cargo 0b11111111 / 0xFF que voy a usar para prender el DDRB
OUT DDRB, R_AUX ; configuro el puerto B como output
LDI R_BYTE_DE_PRUEBA, DATO_PRUEBA ; cargo en un registro el numero con el que voy a llenar el puerto
OUT PORTB, R_BYTE_DE_PRUEBA ; cargo en el PORTB (output del puerto B) el byte para leerlo despues
LDI R_AUX, OFF_REGISTRO ; cargo ob00000000 / 0x00 que voy a usar para apagar el DDRB
OUT DDRB, R_AUX ; vuelvo a dejar al puerto B como estaba por default

;arranca el ejercicio

MAIN:
		
		LDI R_AUX, ON_REGISTRO ; cargo 0b11111111 / 0xFF que voy a usar para prender el DDRC
		OUT DDRB, R_AUX ; configuro el puerto C como output

		CLR R_SALIDA ; inicializo salida en 0

		LDI	R_PILA,	HIGH(RAMEND) ; inicializo el stack pointer
		OUT	SPH,	R_PILA
		LDI	R_PILA,	LOW(RAMEND)
		OUT	SPL,	R_PILA

LOOP:	IN R_ENTRADA, PINB ; Guardo en R_ENTRADA la info de la "terminal input" del puerto B . Como el puerto B está como input por default (todo en 0), puedo hacer esto sin configurar nada
		RCALL FILTRO ; función cualquiera que invento
		OUT PORTC, R_SALIDA ; saco por la "terminarl output" del puerto C la información R_SALIDA
		RJMP LOOP ; dice que buclee infinitamente


FILTRO:
		COM R_ENTRADA ; hago cualquier cosa, es para probar el codigo (complemento A1)
		MOV R_SALIDA, R_ENTRADA ; pongo en la R_SALIDA los cambios hechos a la entrada
		RET