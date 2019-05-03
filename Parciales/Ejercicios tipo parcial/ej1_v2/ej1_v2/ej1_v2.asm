/*
 * ej1_v2.asm
 *
 *  Created: 21/09/2017 07:11:42 p.m.
 *   Author: Martin
 */ 
 //#########################################################################################################################################
 //	ATENCIÓN: LA TABLA A CARGAR ACEPTA NÚMEROS MENORES A 80. DE LO CONTRARIO LA TABLA NO SE ORDENARÁ CORRECTAMENTE.
 //			  CUANDO TERMINA EL PROGRAMA QUEDAN ORDENADOS PRIMERO LOS NÚMEROS MAYORES A 80 Y LUEGO ESTAN ORDENADOS LOS NÚMEROS MENORES A 80
 //#########################################################################################################################################

 .include "M2560def.inc"

 .dseg 
	.org 0x200

	Vec1: .Byte 25 // # de datos
	Vec2: .Byte 25 // # de datos

.cseg

	Main:	ldi zh, HIGH(Vec1)
			ldi zl, LOW(Vec1)
			ldi xh, HIGH(Vec2)
			ldi xl, LOW(Vec2)
			ldi R21, 25 //............... # de datos. para copiar tabla y ordenar tabla
			ldi R22, 1 // contador para copiar tabla y ordenar tabla
			ldi R23, 1 // contador para caso_no
			ldi R24, 1 // contador para caso_si
			ldi R25, 1 // contador. Sirve para terminar el programa
			ldi R20, 24 // ............# de datos. Comparador para caso_si

			call generar_tabla
			call inicializar_z
			rjmp copiar_tabla

	generar_tabla:	st Z+, R21 // Voy aumentando el puntero de posición y guardando en esa posición el valor de R21
					dec R21
					brne generar_tabla // Compara contra 0. Cuando R21 es distinto de 0 vuelve a generar_tabla y cuando es 0 sigue leyendo
					ret
			
	inicializar_z:	ldi zh, HIGH(Vec1)
					ldi zl, LOW(Vec1)
					ret

	copiar_tabla:	ld R21, z+ // Cargo en R21 lo que está apuntando z. Luego incremento z
					st x+, R21 // Guardo donde apunta x, el dato guardado en R21, luego incremento 21
					cpi R22, 25 //........... # de datos de la tabla
					breq inicializar_x // Si entra ya termine de copiar los datos
					inc R22
					rjmp copiar_tabla

	inicializar_x:	ldi xh, HIGH(Vec2)
					ldi xl, LOW(Vec2)
					rjmp direccionar_registros

	direccionar_registros:	ld R21, x+
							ld R22, x
							rjmp comparacion
									
	comparacion:	//cp R21, R22
					//brlt caso_si // Branch if les than (R21<R22)
					cp R22, R21
					brge caso_si // Branch if greater or equal (R22>=R21)
					rjmp caso_no
									
	caso_si:	cp R24, R20
				breq es_fin
				inc R24
				ld R21, x+
				ld R22, x
				rjmp comparacion
				
	caso_no:	cpi R23, 25 //..............
				breq es_fin // ¿Es fin? Es una pregunta
				inc R23
				st x, R21
				st -x, R22
				rjmp direccionar_registros

	inicializar_contador:	ldi R23, 1
							ldi R24, 1
							rjmp inicializar_x

	es_fin:	cpi R25, 24 //.................
			breq fin
			inc R25
			dec R20
			rjmp inicializar_contador

	fin: rjmp fin