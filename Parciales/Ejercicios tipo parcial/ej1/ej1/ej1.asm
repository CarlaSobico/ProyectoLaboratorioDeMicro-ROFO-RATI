/*
 * ej1.asm
 *
 *  Created: 21/09/2017 12:37:11 p.m.
 *   Author: Martin
 */ 

 .include "M2560def.inc"

 .dseg 
	.org 0x200

	Vec1: .Byte 5 // 25...........
	Vec2: .Byte 5 // 25...........

.cseg

	Main:	ldi zh, HIGH(Vec1)
			ldi zl, LOW(Vec1)
			ldi xh, HIGH(Vec2)
			ldi xl, LOW(Vec2)
			ldi R21, 5 // 25...............Contador para generar la tabla y para ir recorriendo la tabla a ordenar
			clr R22 // registro auxiliar
			clr R19
			clr R23 // contador de z
			clr R24 // contador de x
			clr R25
			call generar_tabla
			call inicializar_z
			rjmp ordenar_tabla_de_menor_a_mayor


	generar_tabla:	st Z+, R21 // Voy aumentando el puntero de posición y guardando en esa posición el valor de R21
					dec R21
					brne generar_tabla // Compara contra 0. Cuando R21 es distinto de 0 vuelve a generar_tabla y cuando es 0 sigue leyendo
					ret

	ordenar_tabla_de_menor_a_mayor: ld R21, z+ // cargo en R21 lo qu está apuntado por z y post incremento z
									ld R19, z
									cp R25, R19
									breq ordenar_tabla_de_menor_a_mayor
									cp R21, R19
									brlt fin_leer_tabla_caso1 // branch if less than (R21<z)
									rjmp fin_leer_tabla_caso2

	inicializar_z:	ldi zh, HIGH(Vec1)
					ldi zl, LOW(Vec1)
					ret

	fin_leer_tabla_caso1:	mov R22, R21
							rjmp fin_leer_tabla 

	fin_leer_tabla_caso2:	mov R22, R19
							rjmp fin_leer_tabla

	fin_leer_tabla:	inc R23
					cpi R23, 5 // 25.................. Cantidad de datos en la tabla
					breq generar_tabla_ordenada
					rjmp ordenar_tabla_de_menor_a_mayor


	generar_tabla_ordenada:	st x+, R22
							inc R24
							cpi R24, 5 // 25................
							breq fin
							mov R25, R22
							rjmp inicializar_z_2

	inicializar_z_2:	ldi zh, HIGH(Vec1)
						ldi zl, LOW(Vec1)
						clr R23
						rjmp ordenar_tabla_de_menor_a_mayor

	fin: rjmp fin