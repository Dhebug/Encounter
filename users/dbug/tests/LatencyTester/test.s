
#define VIA_1				$30f
#define VIA_2				$30c


	.zero

_gKey			.dsb 1
_gRandomValue	.dsb 2
_gReaction		.dsb 2


	.text


_PsgVirtualRegisters
_PsgfreqA 		.byt 0,0    ;  0 1    Chanel A Frequency
_PsgfreqB		.byt 0,0    ;  2 3    Chanel B Frequency
_PsgfreqC		.byt 0,0    ;  4 5    Chanel C Frequency
_PsgfreqNoise	.byt 0      ;  6      Chanel sound generator
_Psgmixer		.byt 0      ;  7      Mixer/Selector
_PsgvolumeA		.byt 0      ;  8      Volume A
_PsgvolumeB		.byt 0      ;  9      Volume B
_PsgvolumeC		.byt 0      ; 10      Volume C
_PsgfreqShape	.byt 0,0    ; 11 12   Wave period
_PsgenvShape	.byt 0      ; 13      Wave form

_PsgNeedUpdate  .byt 1



_AudioTest
.(
	lda #2  ; Green
	sta $bb80+40*12+1
	sta $bb80+40*13+1
	rts
.)

_VisualTest
.(
	lda #6  ; Cyan
	sta $bb80+40*12+1
	sta $bb80+40*13+1
	rts
.)

_CommonTest
.(
	jsr _KeyboardFlush

	;jsr _Breakpoint
	;lda #16+3  ; Yellow
	;sta $bb80

	; Setup the actual test value
	ldx #<_VisualTest
	ldy #>_VisualTest

	lda _gRandomValue
	and #1
	beq setup_test
	ldx #<_AudioTest
	ldy #>_AudioTest
setup_test
	stx _auto_test+1
	sty _auto_test+2


	; Disable interrupts
	sei
	.(
	; Initial delay loop
countdown_loop
	; At the start of the test, we need to keyboard to be unpressed
	jsr _KeyboardRead
	lda _gKey
	beq keyboard_ok

	; Player pressed the keyboard to early
	;lda #16+1  ; Red
	;sta $bb80

	lda #255
	sta _gReaction+0
	sta _gReaction+1
	cli
	rts

keyboard_ok
	; Test our countdown
	lda _gRandomValue+0
	bne not_zero
	lda _gRandomValue+1
	beq countdown_finished ; branch when NUM = $0000 (NUM is not decremented in that case)
	dec _gRandomValue+1
not_zero 
	dec _gRandomValue+0
	jmp countdown_loop

countdown_finished
	.)

	; We show the signal
_auto_test
	jsr $1234

	; And now we wait for the reaction time of the player
	.(
	lda #0
	sta _gReaction+0
	sta _gReaction+1

reaction_time_loop
	; At the start of the test, we need to keyboard to be unpressed
	jsr _KeyboardRead
	lda _gKey
	bne key_pressed

	inc _gReaction+0
	bne skip
	inc _gReaction+1
skip
	jmp reaction_time_loop
key_pressed
	.)


	; Restore interrupts
	cli
	rts
.)


_Breakpoint
	jmp _Breakpoint
_DoNothing
	rts


_Sei
  sei
  rts
  
_Cli
  cli
  rts



_UpdatePSG
.(
	; Update the sound generator
	.(
	lda _PsgNeedUpdate
	beq skip_update

	and #1
	sta _PsgNeedUpdate

	lda _Psgmixer
	ora #%11000000
	sta _Psgmixer

	ldy #0
	sei
register_loop
	ldx	_PsgVirtualRegisters,y

	; y=register number
	; x=value to write
	jsr _PsgPlayRegister

	iny
	cpy #14
	bne register_loop
	cli
skip_update	
	.)
	rts
.)




; y=register number
; x=value to write
_PsgPlayRegister
.(
	sty	VIA_1
	txa

	pha
	lda	VIA_2
	ora	#$EE		; $EE	238	11101110
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	tax
	pla
	sta	VIA_1
	txa
	ora	#$EC		; $EC	236	11101100
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	rts
.)


_PsgStopSound
.(
	lda #0
	sta _PsgvolumeA
	sta _PsgvolumeB
	sta _PsgvolumeC
	lda #1
	sta _PsgNeedUpdate
	jmp _UpdatePSG
.)


ExplodeData
	.byt 0,0,0,0,0,0,15
	.byt 7,16,16,16,0,24

_PsgExplode
.(
	ldx #0
loop
	lda ExplodeData,x
	sta _PsgVirtualRegisters,x
	inx
	cpx #14
	bne loop

	lda #2
	sta _PsgNeedUpdate

	jmp _UpdatePSG
.)



	
_KeyboardFlush
.(
	sei
loop
	jsr _KeyboardRead
	lda _gKey
	bne loop
	cli
	rts
.)	

_KeyboardWait
.(
	jsr _KeyboardFlush
loop	
	jsr _KeyboardRead
	lda _gKey
	beq loop
	rts
.)
	
_KeyboardRead
	lda #00
	sta _gKey

read_left
	ldx #$df
	jsr KeyboardSetUp
	beq read_right
	lda _gKey	
	ora #1
	sta _gKey
	
read_right
	ldx #$7f
	jsr KeyboardSetUp
	beq read_up
	lda _gKey	
	ora #2
	sta _gKey
	
read_up
	ldx #$f7
	jsr KeyboardSetUp
	beq read_down
	lda _gKey	
	ora #4
	sta _gKey
	
read_down
	ldx #$bf
	jsr KeyboardSetUp
	beq read_fire
	lda _gKey	
	ora #8
	sta _gKey
	
read_fire
	ldx #$fe
	jsr KeyboardSetUp
	beq read_end
	lda _gKey	
	ora #16
	sta _gKey
	
read_end
	rts


KeyboardSetUp
	;x=column a=row
	lda #04
	sta $300
	lda #$0e
	sta $30f
	lda #$ff
	sta $30c
	ldy #$dd
	sty $30c
	stx $30f
	lda #$fd
	sta $30c
	sty $30c
	lda $300
	and #08
	rts






_ProfilerTest_20000_cycles  
Wait20000Cycles  
  jsr Wait5000Cycles	; 5000
  jsr Wait5000Cycles	; 5000
  jsr Wait5000Cycles	; 5000
  jsr Wait4000Cycles    ; 4000
  jsr Wait900Cycles  	; 900
  jsr Wait80Cycles  ; 80
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  					; 6
  ;                  	 +6 for jsr

Wait5000Cycles  
  jsr Wait1000Cycles	; 1000
Wait4000Cycles  
  jsr Wait1000Cycles	; 1000
  jsr Wait1000Cycles	; 1000
  jsr Wait1000Cycles	; 1000
  jsr Wait900Cycles  	; 900
  jsr Wait80Cycles  ; 80
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  					; 6
  ;                  	 +6 for jsr
  
    
Wait1000Cycles  
  jsr Wait100Cycles	; 100
Wait900Cycles  
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait80Cycles  ; 80
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  				; 6
  ;                  +6 for jsr
  
Wait100Cycles  
  jsr Wait20Cycles	; 20
Wait80Cycles  
  jsr Wait20Cycles	; 20
Wait60Cycles  
  jsr Wait20Cycles	; 20
Wait40Cycles  
  jsr Wait20Cycles	; 20
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  				; 6
  ;                  +6 for jsr

Wait20Cycles
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  				; 6
  ;                  +6 for jsr  

  
;
; List of 'neutral' instructions by number of cycles
; - 2 nop (0xEA) / and immediate   / clc,dex,dey
; - 3 jmp abs      / pha,php
; - 4 bit abs      / pla,plp
; - 5 asl zp
; - 6 asl abs
;
; Additional useful instructions
; - 2+1 bcc
; - 6 jsr
; - 6 rts
;  
;
;

_TemporizationIncrease
  ;jmp _TemporizationIncrease
 .(
  ; Make A goes from odd to even to odd to even
  ; This gives us the +1 cycles thanks to AND #1 / BNE
  lda _TemporizationPatchA+1
  eor #1
  sta _TemporizationPatchA+1
  bne end
 
  lda _TemporizationPatchAddress+1
  bne skip
  dec _TemporizationPatchAddress+2
skip
  dec _TemporizationPatchAddress+1
end  
  .)
  rts

_TemporizationRun
  ;jmp _TemporizationRun
_TemporizationPatchA
  lda #0						; 2
_TemporizationPatchAddress
  jmp _TemporizationTableEnd 	; 3+2+2+6
                            	; = 15 cycles
                                                         
                               

	.dsb 256-(*&255)
  
_TemporizationTableStart
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
  .byt $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
_TemporizationTableEnd
  and #1			; 2
  bne end_tempo		; 2/3 depending of A
end_tempo  
  rts				; 6


 