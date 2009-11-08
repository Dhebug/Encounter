
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



flight_message_loot
.(

	inc capson
	inc print2buffer
	lda #0
	sta buffercounter
    lda #<Goodnames
	sta tmp0
    lda #>Goodnames
    sta tmp0+1
    jsr search_string_and_print
	
	dec print2buffer
	dec capson

	jmp flight_message_end
.)



flight_message_bounty
.(

	inc capson
	inc print2buffer
	lda #0
    sta buffercounter
	jsr print_float
	jsr put_space
	lda #<str_credits
	ldx #>str_credits
	jsr print
	dec print2buffer
	dec capson

	jmp flight_message_end
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
	
	lda #<flight_message_base
	sta tmp0
	lda #>flight_message_base
	sta tmp0+1

	; Print message id to buffer
	inc print2buffer
	inc capson
	lda #0
    sta buffercounter
	jsr search_string_and_print
	dec print2buffer
	dec capson

+flight_message_end
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
	dec print2dbuffer
	ldx message_X
	ldy #HUD_MSG_Y
	jsr gotoXY	
	lda #<message_buffer
	ldx #>message_buffer
	jsr print
	inc print2dbuffer
	rts
.)




;;;;;;;;;;;;;; Control for panels

update_all_controls
.(
    jsr update_temperature_panel
	jsr update_speed_panel
	jsr update_shields_panel
	jmp update_missile_panel
.)


;****** Missile boxes(Missiles) ******
;A07B - Slot 1 - Poke Inversed Colour (See below for codes)
;A07D - Slot 2 - Poke Inversed Colour (See below for codes)
;A07F - Slot 3 - Poke Inversed Colour (See below for codes)
;A081 - Slot 4 - Poke Inversed Colour (See below for codes)

;Inversed Colours
;$80 - Black(Empty/Off)
;$81 - Red
;$82 - Green
;$83 - Yellow
;$84 - Blue(low visibility)
;$85 - Magenta
;$86 - Cyan
;$87 - White

tab_miss_pos
	.byt $7b,$7d,$7f,$81

update_missile_panel
.(
	ldx _missiles_left
	beq noleft
	lda #$86
	ldy _missile_armed
	beq loop
	bpl locked
	lda #$83
	.byt $2c
locked
	lda #$85
loop
	ldy tab_miss_pos-1,x
	sta $a000,y
	dex
	bne loop

noleft
	ldx #4
	cpx _missiles_left
	beq end

	lda #$80
loop2
	ldy tab_miss_pos-1,x
	sta $a000,y
	dex
	cpx _missiles_left
	bne loop2
end
	rts

.)


;****** Warning Light ******
;Version sent has green flashing light
;To set colour poke $A073,$A09B,$A0C3 with Inversed colour (see above for values)
;To Set Flashing, poke $A074,$A09C,$A0C4 with $8C
;To Disable flashing, poke $A074,$A09C,$A0C4 with $88


warnlight_colour .byt INV_GREEN

flash_warning_off
.(
	lda #$88
	.byt $2c
+flash_warning_on
	lda #$8c

	ldx _current_screen
	cpx #SCR_FRONT
	bne end

	sta $a074
	sta $a09c
	sta $a0c4

+set_warning_light
	lda warnlight_colour
	sta $a073
	sta $a09b
	sta $a0c3
end
	rts
.)

;****** Shield bars ******
;The Cyan bar can be set at pixel(0-22) or byte resolution(0-3)
;The black hole to right is the warning light when the shield is empty
;See below for routine i'd use for pixel res

;****** Fore shield ******
;$B60C - Left byte of bar
;$B610 - Warning Light

;****** Aft shield ******
;$B6FC - Left byte of bar
;$B700 - Warning Light

update_shields_panel
.(
  	lda _current_screen
	cmp #SCR_FRONT
	bne end

	ldx _front_shield
	lda BarSegment0,x
	sta $B60C
	lda BarSegment1,x
	sta $B60D
	lda BarSegment2,x
	sta $B60E
	lda BarSegment3,x
	sta $B60F

	ldx _rear_shield
	lda BarSegment0,x
	sta $B6FC
	lda BarSegment1,x
	sta $B6FD
	lda BarSegment2,x
	sta $B6FE
	lda BarSegment3,x
	sta $B6FF
end
	rts
.)


;******** Speed *********
;$B954 - Top left
;Pretty much same as Fore and Aft shields except different pattern, twice written and half pixel res(0-14)
;Personally what i'd do is use the tables above for aft shields (avoids excessive tables) together with
;one more (BarSegment4) and mask(AND) the fetched bar byte with %01010101

update_speed_panel
.(
	lda _current_screen
	cmp #SCR_FRONT
	bne end


	ldx _speed+1
	lda BarSegment0,x
	and #%01010101
	sta $B954
	sta $B954+40
	lda BarSegment1,x
	and #%01010101
	sta $B955
	sta $B955+40
	lda BarSegment2,x
	and #%01010101
	sta $B956
	sta $B956+40
	lda BarSegment3,x
	and #%01010101
	sta $B957
	sta $B957+40
	lda BarSegment4,x
	and #%01010101
	sta $B958
	sta $B958+40
end
	rts
.)


BarSegment4
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000
BarSegment3
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000
BarSegment2
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000
BarSegment1
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000
BarSegment0
 .byt %01000000,%01100000,%01110000,%01111000,%01111100,%01111110,%01111111
 .byt %01111111,%01111111,%01111111,%01111111,%01111111,%01111111,%01111111
 .byt %01111111,%01111111,%01111111,%01111111,%01111111,%01111111,%01111111
 .byt %01111111,%01111111,%01111111
 .byt %01111111,%01111111,%01111111,%01111111,%01111111


;******** Laser Temperature ********
;This looks more complicated than it really is.
;For colour of pointer..
;$FF Red
;$C0 White
;$40 Black
;The range is 1-10 and i'd use this routine

OldLaserTemperature .byt 0
LaserTemperature .byt 0

update_temperature_panel
.(
	lda _current_screen
	cmp #SCR_FRONT
	bne skip1


	ldx OldLaserTemperature
	cpx LaserTemperature

	beq skip1
	
	;Delete Old pointer
	lda TemperatureIndicatorScreenLocLo,x
	sta vector1+1
	lda TemperatureIndicatorScreenLocHi,x
	sta vector1+2
	lda #$40
vector1	sta $dead
	
	;Plot new pointer
	ldx LaserTemperature
	stx OldLaserTemperature
	lda TemperatureIndicatorScreenLocLo,x
	sta vector2+1
	lda TemperatureIndicatorScreenLocHi,x
	sta vector2+2
	lda #$C0
vector2	sta $dead
skip1	rts
.)


TemperatureIndicatorScreenLocLo
 .byt $E0
 .byt $90
 .byt $40
 .byt $F0
 .byt $A0
 .byt $50
 .byt $00
 .byt $B0
 .byt $60
 .byt $10
TemperatureIndicatorScreenLocHi
 .byt $BD
 .byt $BD
 .byt $BD
 .byt $BC
 .byt $BC
 .byt $BC
 .byt $BC
 .byt $BB
 .byt $BB
 .byt $BB






