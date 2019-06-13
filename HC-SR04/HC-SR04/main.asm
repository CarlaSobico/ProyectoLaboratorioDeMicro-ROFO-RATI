;
; HC-SR04.asm
;
; Created: 1/6/2019 19:20:57
; Author : ivanlisman
;
;avrdude -c arduino -p m328p -P COM7 -b 115200 -U flash:w:HC-SR04.hex:


.INCLUDE "m328pdef.inc"

;*********************************************************************************************************************************************************************************************************


;===================================================================================================================DEFINES
.def AUX            =   R16
.def TIMEL		    =	R17     
.def TIMEH		    =	R18
.def OBSTACLE_FLAG	=	R19
;==========================================================================================================================


;================================================================================================================CONSTANTES
;PORTB
.equ ECHO_PIN		= 0                 ;chequear
.equ TRIG_PIN		= 2
.equ LED_OBSTACLE	= 5

;OTROS
.equ TRIGGER_UPTIME = 3
.equ TRIGGER_PERIOD = 1600
;==========================================================================================================================


;====================================================================================================================MACROS

.macro STACK_INIT	; setup stack
	ldi AUX, HIGH(RAMEND)
	out SPH, AUX
	ldi AUX, LOW(RAMEND)
	out SPL, AUX
.endmacro

.macro stsi						;CARGA UN NUMERO EN UN REGISTRO
	ldi AUX, @1
	sts	@0, AUX
.endmacro

.macro stsi16					;CARGA UN NUMERO DE 16 BIT EN 2 REGISTROS 
	ldi AUX, HIGH(@1)
	sts	@0H, AUX
	ldi AUX, LOW(@1)
	sts @0L, AUX
.endmacro


.macro PORTB_AS_OUTPUT ; @0 es la/s patita/s que quiero configurar (mandame 0bxxxxxxxx y x=1 es patita para salida)
	ldi AUX, @0
	out DDRB, AUX ; seteo la/s patita/s que me pidieron
	clr AUX
	out PORTB, AUX ; inicializo en 0 el puerto B	
.endmacro

.macro PORTC_AS_OUTPUT ; @0 es la/s patita/s que quiero configurar (mandame 0bxxxxxxxx y x=1 es patita para salida)
	ldi AUX, @0
	out DDRC, AUX ; seteo la/s patita/s que me pidieron
	clr AUX
	out PORTC, AUX ; inicializo en 0 el puerto C	
.endmacro

.macro PORTD_AS_OUTPUT ; @0 es la/s patita/s que quiero configurar (mandame 0bxxxxxxxx y x=1 es patita para salida)
	ldi AUX, @0
	out DDRD, AUX ; seteo la/s patita/s que me pidieron
	clr AUX
	out PORTD, AUX ; inicializo en 0 el puerto D	
.endmacro

;==========================================================================================================================


;*********************************************************************************************************************************************************************************************************


.CSEG

.ORG 0x00
	RJMP RESET

.ORG ICP1addr
	JMP ISR_ICP1

.ORG OVF1addr
	JMP RESTART_TIMER

.ORG INT_VECTORS_SIZE

RESET:
	STACK_INIT ; hay que adaptar esto más tarde a lo que me venga
	RCALL HC_SR04_INIT ; configuro el trigger y configuro el timer/wave generator
	; no hace falta que configure el puerto D para que me entre la interrup por captura
	; porque por default está en input.

	SEI

MAIN: RJMP MAIN


;***********************************************************************************************************************************************************************************************************
;INICIALIZA EL MODULO: EN OC1B PONE UN PWM CON DUTY CYCLE = 12uS, y PERIODO DE 64ms.
;TAMBIEN ACTIVA LA INTERRUPCION POR ICP1. EN DICHA INTERRUPCION SE COMPARA EL TIEMPO DEL TIMER CON EL TIEMPO DE ECHO
;				EL TIMER SE VA A CONFIGURAR POR OVERFLOW
;***********************************************************************************************************************************************************************************************************

HC_SR04_INIT:

	PORTB_AS_OUTPUT (1<<2)|(1<<3)|(1<<4)
	stsi16 TCNT1, 0xFFFF-TRIGGER_PERIOD ; OVERFLOW - K=Periodo del trigger (prescalado)
	stsi16	OCR1A, 0xFFFF ; fin del periodo de trigger (¿ TOP = MAX ?)
	stsi16	OCR1B, (0xFFFF-TRIGGER_PERIOD)+TRIGGER_UPTIME ; primer cambio de estado en inicio+endTrigger

	
	; 1
	;----- x 64(prescaler) x K (numero que cargo) = Segundos "que pasan en c/clock" 		
	; 16Mhz							;* EL PRESCALER ESTÁ PUESTO PARA PODER HACER ALGO DE APROX 64ms y 10uS
	

	stsi	TCCR1A, (1<<COM1B1)|(1<<WGM11)|(1<<WGM10)						
	;Clear OC1B on compare match, FAST-PWM, OCR1A = TOP
	stsi	TCCR1B, (0<<ICES1)|(1<<WGM13)|(1<<WGM12)|(1<<CS11)|(1<<CS10)	
	;Cuando llegue a TOP arranca a contar de nuevo
	stsi	TIMSK1, (1<<ICIE1)|(1<<TOIE1)

	ret


;***********************************************************************************************************************************************************************************************************
;INTERRUPCION POR OF PARA RESTARTEAR EL TIMER
;***********************************************************************************************************************************************************************************************************
RESTART_TIMER:
	stsi16 TCNT1, 0xFFFF-TRIGGER_PERIOD
	RETI


;***********************************************************************************************************************************************************************************************************
;INTERRUPCION POR CAPTURA: EN UN FLANCO DESCENDENTE DE PB0 (ICP1), COPIA EL TCNT1 EN ICR1 Y 
;LUEGO SE COMPARA ESTE VALOR CON EL CORRESPONDIENTE DE TIEMPO SEGUN LA DISTANCIA UMBRAL SETEADA. 
;***********************************************************************************************************************************************************************************************************
ISR_ICP1:
	CLI

	lds		TIMEL, ICR1L			;LEO EL TIEMPO QUE PASO DESDE QUE EMPEZO EL CICLO HASTA 
									;QUE HUBO FLANCO DESCENDENTE DE ECHO
	lds		TIMEH, ICR1H
	
	subi TIMEL, LOW(0xFFFF-TRIGGER_PERIOD-TRIGGER_UPTIME+0x0001)	;LE RESTO LOS 12uS correspondientes al trigger y el inicio de TNCT1 para que funcione
	sbci TIMEH, HIGH(0xFFFF-TRIGGER_PERIOD-TRIGGER_UPTIME+0x0001)	;COMO SI ARRANCARA EN 0x0000


	;PARA SETEAR UN UMBRAL DE 10cm, HAY QUE USAR LA FORMULA:
		
		;				 TIEMPO [s] * 344 m/s
		;DISTANCIA [m] = --------------------
		;						2

	;ENTONCES: TIEMPO_THRESHOLD = 581.4 us. 
	;
	;			581.4us --cargo---> 145.35 REDONDEO 145 


	; Apago los leds para probar
	cbi		PORTB, 4
	cbi		PORTB, 3

	CPI TIMEH, 0b11000010
	brne OBSTACLE_FALSE;ISR_ICP1_END

OBSTACLE_NEAR:
	CPI TIMEL, 146 ; .equ aca
	brsh OBSTACLE_FALSE;ISR_ICP1_END
	
OBSTACLE_TRUE:
	LDI OBSTACLE_FLAG, 1
	SBI PORTB, 4 ; Si hay un obstaculo, prender PB4
	;call obstacle_motor ;mejor que llamar a una funcion es mas rapido ponerlo directamente aca
	RJMP ISR_ICP1_END

OBSTACLE_FALSE:
	CLR OBSTACLE_FLAG
	SBI PORTB, 3 ; Si no hay un obstaculo, prender PB3

ISR_ICP1_END:	
	SEI	; Activo nuevamente las interrupciones
	reti
