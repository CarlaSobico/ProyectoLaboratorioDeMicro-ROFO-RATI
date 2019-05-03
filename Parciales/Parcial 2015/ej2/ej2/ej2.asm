/*
 * ej2.asm
 *
 *  Created: 13/09/2017 11:46:50 a.m.
 *   Author: Martin
 */ 


 .include "M2560def.inc"
.dseg 

	TABLA_RAM: .Byte 256

.cseg /* cseg: code segment Sirve para decirle al micro que esto va en la ROM */

	
Inicio:	ldi ZL, LOW(TABLA_RAM)
		ldi ZH, HIGH(TABLA_RAM)
		ldi R21, 10
		ldi R22, 10
		call generar_tabla
		call inicializar_puntero
		call leer_tabla 
		rjmp end

generar_tabla:	st Z+, R21 // Voy aumentando el puntero de posición y guardando en esa posición el valor de R21
				dec R21
				brne generar_tabla // Compara contra 0. Cuando R21 es distinto de 0 vuelve a generar_tabla y cuando es 0 sigue leyendo
				ret


inicializar_puntero:	ldi ZL, LOW(TABLA_RAM)  // Vuelvo a apuntar al principio del puntero
						ldi ZH, HIGH(TABLA_RAM)
						ret

leer_tabla: ld R20, Z+ // Voy guardando en R20 lo que leo del puntero Z. 
			call CALCULAR_PARIDAD
			dec R22
			brne leer_tabla
			ret

CALCULAR_PARIDAD:	nop
					ret		 

end: rjmp end