;
; ejercicio medio inventado de paridades.asm
;
; Created: 6/5/2019 00:05:27
; Author : Ivan Lisman 100001
;


;Recibe una tabla en la SRAM de largo TABLE_SIZE que arranca desde la posición de memoria TABLE_RAM
;calcular la paridad de cada número (bit de paridad) y guardar la paridad de c/u en una tabla.
;Si el numero tiene paridad impar P=1 y si tiene paridad impar P=0


.DEF BIT_GETTER = R21
.DEF OF_1_AMOUNT = R22
.DEF NUMBER = R23
.DEF TABLE_COUNTER=R24


.EQU TABLE_SIZE = 10
.EQU TABLE_RAM = SRAM_START 
.EQU MASK_BIT_GETTER = 0b10000000  ; mascara para obtener c/bit del n° binario 
.EQU MASK_PARITY_GET = 0b00000001 ; mascara para ver si la cantidad de unos es par o impar
.EQU INITIAL_VALUE = 0x05

.DSEG 

.ORG TABLE_RAM 
	var1:			.BYTE 1  
	TABLE:			.BYTE TABLE_SIZE
	TABLE_PARITIES:	.BYTE TABLE_SIZE

.CSEG   
 
.ORG 0x00                   
	
	LDI ZL, LOW(TABLE)
	LDI ZH, HIGH(TABLE)
	LDI R20, TABLE_SIZE-1 ; 1 menos porque el ultimo valor tiene que ser FF
	LDI R19, INITIAL_VALUE ; cargo el valor inicial de la tabla

CARGAR_TABLE:
	ST Z+, R19 
	INC R19 ; cargo 4 5 6 7 8 9 y asi.
	DEC R20
	BRNE CARGAR_TABLE
	LDI R19, 0xFF ; carga e ultimo valor FF
	ST Z, R19

; aca arranca el ejercicio. Lo anterior era solo para cargar valores en la tabla.

MAIN:
	LDI ZL, LOW(TABLE) ; apunto de nuevo porque en el cargar_tabla perdi la referencia
	LDI ZH, HIGH(TABLE) 
	LDI XL, LOW(TABLE_PARITIES) ; apunto en la nueva tabla
	LDI XH, HIGH(TABLE_PARITIES)
	LDI TABLE_COUNTER, TABLE_SIZE ; contador para iterar por las tablas
	
KEEP_GOING:		CLR OF_1_AMOUNT ; arranco en 0 la cantidad de unos
				LDI BIT_GETTER, MASK_BIT_GETTER ; cargo la mascara en un registro para usar LSR
				CALL GET_1_AMOUNT ; funcion para conseguir cantidad de unos
				ANDI OF_1_AMOUNT, MASK_PARITY_GET ; ahora me fijo si la cantidad de unos es par o no. En binario, los pares terminan en 0 y los impares en 1.
				ST X+, OF_1_AMOUNT ; X=1 es porque el numero Z tiene paridad impar y si X=0 es porque el numero de Z tiene paridad par. // lo cargo a la nueva tabla y apunto al siguiente
				DEC TABLE_COUNTER ; decrementar para loopear
				BRNE KEEP_GOING ; hasta que el counter no sea 0 segui recorriendo el vector
END:			JMP END ; termina programa


GET_1_AMOUNT:
			LD NUMBER, Z ; cargo de nuevo el numero
			AND NUMBER,BIT_GETTER ; getteo el si hay un 1 o un 0 en la posicion en la que estoy
			BREQ BIT_ZERO ; el current bit del numero es 0
			INC OF_1_AMOUNT ; si el current bit del numero es 1, voy contando los unos
BIT_ZERO:	LSR BIT_GETTER ; corro un bit a la derecha el uno
			BRCC GET_1_AMOUNT ; si el bit de carry de BIT_GETTER es 0, sigue
			LD NUMBER, Z+ ; cargo el proximo numero a comparar y apunto al prox
			RET ; si el carry es 1 es porque ya se corrio la mascara 
	