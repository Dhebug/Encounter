;IRQRoutine.s
; Read keyboard (Left,Right,Up,Down,Fire,Esc)
; Programmable Countdown
; Update Sunmoon
; Read Joystick

SetupIRQ	;Intercept Main IRQ jump at 246
	sei
	lda $FFFE
	sta source
	lda $FFFF
	sta source+1
	ldy #00
	lda #$4C
	sta (source),y
	iny
	lda #<IRQDriver
	sta (source),y
	iny
	lda #>IRQDriver
	sta (source),y
	
	;Slow IRQ Timer1 to 25Hz
	lda #<40000
	sta VIA_T1CL
	sta VIA_T1LL
	lda #>40000
	sta VIA_T1CH
	sta VIA_T1LH
	cli
	rts

IRQDriver	;Backup Registers
	sta IRQ_A+1
	stx IRQ_X+1
	sty IRQ_Y+1
	;Protect BCD mode
	php

	;Ensure BCD is disabled
	cld
	
	;Reset IRQ
	cmp VIA_T1CL
	
	;Read keyboard
	lda #00
	sta KeyRegister
	lda #$0E
	sta VIA_PORTA
	lda #$FF
	sta VIA_PCR
	ldy #$DD
	sty VIA_PCR
	ldx #6
.(
loop1 	lda KeyRow,x
  	sta VIA_PORTB
  	lda KeyColumn,x
	sta VIA_PORTA
	lda #$FD
	sta VIA_PCR
	sty VIA_PCR
 	nop
 	nop
 	nop
 	nop
 	nop
 	lda VIA_PORTB
 	and #8
 	beq skip1
 	lda KeyRegister
 	ora Bitpos,x
 	sta KeyRegister
skip1	dex
	bpl loop1
.)
	;Read Joysticks if configured and in game
	lda GameFlag
.(
	beq skip1
	ldx Option_Input
	beq skip1
	dex
	bne skip2
	jsr ReadIJK
	jmp skip1
skip2	jsr ReadPASE
skip1	;Update Sunmoon every 10 seconds (25 per second)
.)
	dec SecondCounter
.(
	bne skip1
	lda CounterReference
	sta SecondCounter
	;Alternate time so doubling res of Second Counter
	lda TimeAlt
	eor #128
	sta TimeAlt
	bpl skip1
	jsr UpdateSunMoon

skip1	;Are we in game or title?
.)
	lda GameFlag
.(
	bmi skip1
	beq PlayMusic
	
	lda Option_Ingame
	beq PlayMusic

          ;In game
	jsr sfx_ScriptEngine
	jmp skip1
PlayMusic	
;	nop
;	jmp PlayMusic
	jsr MusicIRQ

skip1	;Programmable Countdown
.)
	lda ProgrammableCountdown
.(
	beq skip1
	dec ProgrammableCountdown
skip1
.)
	;Restore Registers
	plp
IRQ_A	lda #00
IRQ_X	ldx #00
IRQ_Y	ldy #00
	rti
	