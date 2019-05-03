/*
 * ej3.asm
 *
 *  Created: 13/09/2017 07:25:17 p.m.
 *   Author: Martin
 */ 

.include "M2560def.inc" 

.cseg

	ldi R20, 25 // dato
	ldi R21, 0x80 // mascara
	ldi R22, 0x80 // registro auxiliar
	clr R23 // contador
	ldi R24, 1 // para la and con el contador

obtener_paridad:	and R21, R20 // En R21 se guarda el resultado
					cpi R21, 0
					breq zero
					inc R23
					lsr R22 // Logical shift right
					mov R21, R22
					cpi R22, 0
					breq calcular_paridad
					rjmp obtener_paridad

zero:	lsr R22
		mov R21, R22
		rjmp obtener_paridad
					
calcular_paridad:	and R24, R23
					cpi R24, 1
					breq paridad_si
					rjmp paridad_no
					
paridad_si:	ldi R24, 1 // Bit de paridad es 1 si la cantidad de 1´s es impar
			rjmp fin

paridad_no: ldi R24, 0 // // Bit de paridad es 0 si la cantidad de 1´s es par
			rjmp fin

fin: rjmp fin