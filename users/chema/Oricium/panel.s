;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Routines for panel controls

#define ENERGY_METER_BASE1 	$a24e
#define ENERGY_METER_BASE2 	$a276
#define RETRO_METER_BASE1 	$a3de
#define RETRO_METER_BASE2 	$a406
#define LEDS_BASE 			$a470
#define SCORE_BASE			$a294
#define LEVEL_BASE			$a154
#define LIVES_BASE			($a000+26*40+9)

#define LED_OFF				%01000000
#define LED_ON				%01011110


; Update meter graphics according to the
; value of the corresponding variables

; Tables used by the routines
tab_byte_meter
	.byt 0
	.byt 0,0,0,0,0
	.byt 1,1,1,1,1
	.byt 2,2,2,2,2
	.byt 3,3,3,3,3
	.byt 4,4,4,4,4
	.byt 5,5,5,5,5
	.byt 5

tab_mask_meter
	.byt %11111111
	.byt %11011111, %11001111, %11000111, %11000011, %11000001
	.byt %11011111, %11001111, %11000111, %11000011, %11000001
	.byt %11011111, %11001111, %11000111, %11000011, %11000001
	.byt %11011111, %11001111, %11000111, %11000011, %11000001
	.byt %11011111, %11001111, %11000111, %11000011, %11000001
	.byt %11011111, %11001111, %11000111, %11000011, %11000001
	.byt %11000000

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update retro item meter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
update_retro_meter
.(
	lda #<RETRO_METER_BASE1
	sta tmp0
	lda #>RETRO_METER_BASE1
	sta tmp0+1
	lda #<RETRO_METER_BASE2
	sta tmp1
	lda #>RETRO_METER_BASE2
	sta tmp1+1	
	ldx items
	jmp update_meter_common
.)	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update energy meter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
update_energy_meter
.(
	lda #<ENERGY_METER_BASE1
	sta tmp0
	lda #>ENERGY_METER_BASE1
	sta tmp0+1
	lda #<ENERGY_METER_BASE2
	sta tmp1
	lda #>ENERGY_METER_BASE2
	sta tmp1+1	
	ldx energy
.)
update_meter_common
.(	
	; Set the current mask in byte of the meter
	ldy tab_byte_meter,x
	sty smc_byte+1
	lda tab_mask_meter,x
	sta (tmp0),y
	sta (tmp1),y
	
	; Set as full the previous bytes
	cpy #0
	beq doloop2
	lda #%11000001
	ldy #0
loop1
	sta (tmp0),y
	sta (tmp1),y
	iny
smc_byte	
	cpy #0
	bne loop1

doloop2	
	; Set as empty the following bytes
	iny
	cpy #6
	beq skip
	lda #%11111111
loop2
	sta (tmp0),y
	sta (tmp1),y
	iny
	cpy #6
	bne loop2
skip	
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update leds in scorepanel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
update_leds
.(
	lda ledstatus
+update_leds_ex	
	sta tmp
	ldy #6
loop	
	lsr tmp
	bcs lit
	lda #LED_OFF
	bne plot
lit
	lda #LED_ON
plot
	sta LEDS_BASE,y
	dey
	dey
	bpl loop
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update level in scorepanel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
update_level
.(
	lda #<LEVEL_BASE
	sta screen
	lda #>LEVEL_BASE
	sta screen+1
   	lda level
	jsr bin2bcd
	jmp printnum
.)

bin2bcd
.(
	sta tmp+1

    lda #0
	sta tmp
	
	sty savy+1
	ldy #8
	sed
loop
	asl tmp+1
	lda tmp
	adc tmp
	sta tmp
	dey
	bne loop
savy
	ldy #0
	cld
   	lda tmp
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update score in scorepanel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
update_score
.(
	lda #<SCORE_BASE
	sta screen
	lda #>SCORE_BASE
	sta screen+1
   
   	lda score+1
	jsr printnum
	lda score
	jmp printnum
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update lives in scorepanel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
update_lives
.(
#ifndef DISPLAY_FRC
	lda #<LIVES_BASE
	sta screen
	lda #>LIVES_BASE
	sta screen+1
   
   	lda lives
	jmp printnum
#else
	rts
#endif
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize scorepanel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
init_panel
.(
	jsr update_level
	jsr update_lives
	jsr update_score
	jsr update_leds
	jsr update_retro_meter
	jmp update_energy_meter
.)

