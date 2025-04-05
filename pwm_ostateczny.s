#include "msp430.h"			; dolaczenie biblioteki do MSP430
;------------------------------------------------------------------------------
; regulacja PWM
;------------------------------------------------------------------------------
	ORG	01100h			; poczatkowy adres pamieci programu
INIT:	mov.w	#0A00h,SP		; inicjalizacja wsk. stosu
	mov.w	#WDTPW+WDTHOLD,&WDTCTL	; wylaczenie watchdoga

	
        bis.w   #GIE, SR
        mov.w   #TBSSEL1, TBCTL
	mov.w  ID1, TBCTL
  	mov.w   MC0, TBCTL
    	mov.w   MC1, TBCTL
        mov.w   #OUTMOD1, TBCCTL4
        mov.w   #0032h, TBCCR0
        mov.w   #0005h, TBCCR4
        bis.b	#010h,&P4DIR
        bis.b	#010h,&P4SEL
        mov.b	#03h,P1IE
        mov.b	#03h,P1IES
//main:	push	SR			; SR -> stos
	//mov.b	#0FFh,P2OUT		; inicjalizacja P1OUT
loop:   jmp loop//git
PORT_P: 
        bic.b   #03h, P1IFG
        xor.b   #02h, P1IES
        bit.b   #01h, P1IN
        jz      resetdziewiec
        bit.b   #02h, P1IES
        jz      narastajace
        jnz     opadajace
        RETI
narastajace:
        bit.b   #04h, P1IN
        jz      zwiekszenie
        jnz     zmniejszenie
opadajace:
        bit.b   #04h, P1IN
        jnz     zwiekszenie
        jz      zmniejszenie
zwiekszenie:
        cmp.b   #0FFh, P2OUT
        jz      resetzero
        add.w   #0005h, TBCCR4
        setc
        rrc.b   P2OUT
        RETI
zmniejszenie:
        cmp.b   #00h, P2OUT
        jz      resetdziewiec
        sub.w   #0005h, TBCCR4
        clrc
        rlc.b   P2OUT
        RETI
resetzero:
       mov.b    #0FFh, P2OUT
       RETI
resetdziewiec:
       mov.b    #00h, P2OUT
       RETI
//delay: MOV #0FFFFh, R8
//OP: dec R8
//    jnz OP
//    RET
;------------------------------------------------------------------------------
;       Wektory przerwan
;------------------------------------------------------------------------------
	ORG	0FFFEh			; wektor resetu
	DW	INIT			; adres poczatkowy pamieci programu
        ORG     0FFE8h
        DW      PORT_P
	END
