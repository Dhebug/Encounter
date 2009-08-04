
; Routines to print HUD strings

#include "cockpit.h"
#include "main.h"


message_delay .byt 00
message_buffer .dsb 30
message_X .byt 00

; Needs to center strings

; Calculate the length of the string
strlen
.(
	ldx #$ff
loop
	inx
	lda str_buffer,x	
	bne loop
	
	rts
.)


; Pass X=message id

flight_message
.(
/*	; If not in front view, return
	lda _current_screen
	cmp #SCR_FRONT
	beq cont
	rts
cont*/
	; Print message id to buffer
	lda #<flight_message_base
	sta tmp0
	lda #>flight_message_base
	sta tmp0+1
	inc print2buffer
	lda #0
    sta buffercounter
	jsr search_string_and_print
	dec print2buffer

	; Calculate length of string
	jsr strlen
	txa
	tay
	lda #0
	sta message_buffer,y
	dey
loop
	lda str_buffer,y
	sta message_buffer,y
	dey
	bpl loop
	
	txa
	; This is in characters, translate to pixels
	; That is, multiply by 6, so we need to do
	; A/2*6=A*3=A*2+A	
	sta tmp
	asl
	clc
	adc tmp
	
	; That is it, now store calculated position
	sta tmp
	lda #120
	sec
	sbc tmp
	sta message_X

	; Now setup the counter to delete the string at the main loop
	lda #HUD_MESSAGE_DELAY
	sta message_delay
	rts
.)


print_inflight_message
.(
	ldx message_X
	ldy #HUD_MSG_Y
	jsr gotoXY	
	lda #<message_buffer
	ldx #>message_buffer
	jmp print
.)












