/*
 * ej1.asm
 *
 *  Created: 13/09/2017 04:38:26 p.m.
 *   Author: Martin
 */ 

.include "M2560def.inc" 

.cseg

main:	ldi R16, -10 // Dividendo
		ldi R17, 2 // Divisor
		clr R18 // Resultado.  Este registro lo inicializo siempre en 0
		clr R19 // Resto. 	
		
		cpi R17, 0
		breq fin_divisor_nulo

		cpi R16, 0 //Me fijo si el dividendo es 0. En caso afirmativo ya puedo dar el resultado
		breq fin_dividendo_nulo	
		
		rjmp division_ok

fin_dividendo_nulo: rjmp fin

fin_divisor_nulo:	set // Si el divisor es 0, dejo el flag T en 1 
					rjmp fin

division_ok:	sub R16, R17 //Resta R16 con R17 y guarda el resultado en R16
				breq fin_division_ok // Branch if equal
				brlt fin_division_ok // Branch if Less Than
				inc R18 // Actualizo el resultado
				rjmp division_ok

fin_division_ok:	inc R18
					mov R19, R16 // Actualizo el resto (R19)
					rjmp fin

fin: rjmp fin