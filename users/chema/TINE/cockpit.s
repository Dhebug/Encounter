
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


; Some helpers to reduce code size

fm_prepare
.(
	inc capson
	inc print2buffer
	lda #0
	sta buffercounter
	rts
.)

fm_printdestroyed
.(
    jsr search_string_and_print
	lda #<str_destroyed
	ldx #>str_destroyed
.)
fm_print
.(
	jsr print
	dec print2buffer
	dec capson
	jmp flight_message_end
.)

flight_message_itemlost
.(
	jsr fm_prepare
	lda #<Goodnames
	sta tmp0
    lda #>Goodnames
    sta tmp0+1
	jmp fm_printdestroyed
.)

flight_message_eqlost
.(
  	jsr fm_prepare
    lda #<str_equip2
	sta tmp0
    lda #>str_equip2
    sta tmp0+1
	jmp fm_printdestroyed
.)


flight_message_loot
.(

	jsr fm_prepare
    lda #<Goodnames
	sta tmp0
    lda #>Goodnames
    sta tmp0+1
    jsr search_string_and_print
	dec print2buffer
	dec capson
	jmp flight_message_end
.)

bounty_am .byt 0,0

flight_message_bounty
.(
	jsr fm_prepare
	lda bounty_am
	sta op2
	lda bounty_am+1
	sta op2+1
	jsr print_float
	jsr put_space
	lda #<str_credits
	ldx #>str_credits
	jmp fm_print
.)


; Pass X=message id

flight_message
.(
	lda #<flight_message_base
	sta tmp0
	lda #>flight_message_base
	sta tmp0+1

+fligth_message_b
	; Print message id to buffer
	jsr fm_prepare
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

	jmp SndMsg
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
	lda #0
	sta warnlight_colour
	lda _planet_dist
	jsr planet_light
	jsr update_energy_panel
    jsr update_temperature_panel
	jsr update_speed_panel
	jsr update_shields_panel
	jsr update_ecm_panel
	jsr update_redirection
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

	;jmp update_ship_id	; let the program flow
	;rts

.)

;****** 8 character Text row(System) *******
;$A060 - Top Left of first character of 8


update_ship_id
.(
	lda #$60
	sta screen
	lda #$a0
	sta screen+1
	
	lda compass_index ;_missile_armed
	beq clear
	bmi clear
setname
	tax
	cpx #2
	bne next_test
	jmp pname
next_test
	jsr GetShipType
	and #%01111111
	tax
+name_ship
	lda #<str_ship_names
	sta tmp0
	lda #>str_ship_names
	sta tmp0+1

	;dex

	; Print message id to buffer
	inc capson
	jsr search_string_and_print
	dec capson
	rts
clear
	lda #<str_blank
	ldx #>str_blank
	jmp print ;This is jsr/rts
.)


pname
.(
    ldx #0
	ldy #0
loop
    lda _cpl_system+NAME,x
    beq end
    cmp #"."
    beq noprint
	iny
noprint
    inx
    jmp loop
end
	sty tmp
	sec
	lda #8
	sbc tmp
	pha
	lsr
	sta tmp
	pla
	sec
	sbc tmp
	beq doprint
	tax
loop2
	jsr put_space
	dex
	bne loop2
doprint
	jsr print_planet_name
	ldx tmp
	beq end2
loop3
	jsr put_space
	dex
	bne loop3
end2
	rts
.)


;****** Warning Light ******

; Sets the planet distance light indicator.
; Needs A=planet_dist
planet_light
.(
	cmp #PDIST_DOCK
	bcs noneardock
	ldx #INV_MAGENTA
	bmi set
noneardock
	cmp #PDIST_MASSLOCK
	bcs nonearplanet
	ldx #INV_YELLOW
	bmi set
nonearplanet
	cmp #PDIST_TOOFAR
	bcc nofar

	; If not in front view, alert player
	ldy _current_screen
	cpy #SCR_FRONT
	beq noal
    ldx #1
	jsr alarm
noal
	ldx #INV_RED
	bmi set
nofar
	ldx #INV_GREEN
set	
	cpx warnlight_colour
	beq end
	stx warnlight_colour
	cpx #INV_GREEN
	beq noflash
	jmp flash_warning_on
noflash
	jmp flash_warning_off
end
	rts
.)




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
	cpx #29
	bcs end

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


 ;****** Power Redirection *******
;$B742 - Top left corner of plotted graphic
;This requires three 4x5 graphics (60 Bytes) to represent the three positions the switch may be in.

update_redirection
.(

	lda #<$b742+(40*4)	
	sta tmp
	lda #>$b742+(40*4)	
	sta tmp+1

	lda _ptsh
	beq nosh
	lda #<SelectorLeft
	ldx #>SelectorLeft
	jmp setit
nosh
	lda _ptla
	beq nola
	lda #<SelectorRight
	ldx #>SelectorRight
	jmp setit
nola
	lda #<SelectorMiddle
	ldx #>SelectorMiddle
setit
	sta loop1+1
	stx loop1+2

	ldx #19
	ldy #3
loop1
	lda SelectorLeft,x
dest_p
	sta (tmp),y
	dey
	bpl cont
	ldy #3
	sec
	lda tmp
	sbc #40
	sta tmp
	bcs cont
	dec tmp+1
cont
	dex
	bpl loop1
	rts
.)


SelectorLeft
 .byt $5F,$4F,$7F,$7E
 .byt $E1,$D8,$C0,$C1
 .byt $5D,$73,$7F,$7E
 .byt $E4,$78,$FF,$F1
 .byt $58,$41,$7F,$7E
SelectorMiddle
 .byt $5F,$7E,$5F,$7E
 .byt $E0,$C2,$F0,$C1
 .byt $5F,$7B,$67,$7E
 .byt $E3,$F8,$70,$F1
 .byt $5F,$70,$43,$7E
SelectorRight
 .byt $5F,$7F,$7C,$7E
 .byt $E0,$C0,$C5,$E1
 .byt $5F,$7F,$77,$4E
 .byt $E3,$FF,$4F,$D9
 .byt $5F,$7F,$40,$46

;******* Energy Banks *******
;Again i would use similar table to horizontal bar since there are only 5 positions(0-5)
;Didn't get time tonight to sort u out a routine, though i suspect you won't have a problem with that
;$BB4E $BB50 $BB52 $BB54
;$BB9E $BBA0 $BBA2 $BBA4
;$BBEE $BBF0 $BBF2 $BBF4
;$BC3E $BC40 $BC42 $BC44
;$BC8E $BC90 $BC92 $BC94

update_energy_panel
.(
	lda _current_screen
	cmp #SCR_FRONT
	beq correct
	rts
correct
	lda _energy+1
	bpl doit
	lda #0
doit
	lsr
	lsr
	sta tmp

	cmp #6
	bcc l6a
	ldx #6
	bne conta
l6a
	tax
conta
	lda table1,x
	sta $bb4e+80*0
	lda table2,x
	sta $bb4e+80*1
	lda table3,x
	sta $bb4e+80*2
	lda table4,x
	sta $bb4e+80*3
	lda table5,x
	sta $bb4e+80*4

	lda tmp
	sec
	sbc #6
	sta tmp
	bpl normalb
	lda #0
	beq l6b
normalb
	cmp #6
	bcc l6b
	ldx #6
	bne contb
l6b
	tax
contb		
		
	lda table1,x
	sta $BB50+80*0
	lda table2,x
	sta $BB50+80*1
	lda table3,x
	sta $BB50+80*2
	lda table4,x
	sta $BB50+80*3
	lda table5,x
	sta $BB50+80*4

	lda tmp
	sec
	sbc #6
	sta tmp
	bpl normalc
	lda #0
	beq l6c
normalc

	cmp #6
	bcc l6c
	ldx #6
	bne contc
l6c
	tax
contc		
		
	lda table1,x
	sta $BB52+80*0
	lda table2,x
	sta $BB52+80*1
	lda table3,x
	sta $BB52+80*2
	lda table4,x
	sta $BB52+80*3
	lda table5,x
	sta $BB52+80*4

	lda tmp
	sec
	sbc #6
	sta tmp
	bpl normald
	lda #0
	beq l6d
normald
	cmp #6
	bcc l6d
	ldx #6
	bne contd
l6d
	tax
contd		
		
	lda table1,x
	sta $BB54+80*0
	lda table2,x
	sta $BB54+80*1
	lda table3,x
	sta $BB54+80*2
	lda table4,x
	sta $BB54+80*3
	lda table5,x
	sta $BB54+80*4
	
	rts

.)

table1
	.byt $40
table2
	.byt $40
table3
	.byt $40
table4
	.byt $40
table5
	.byt $40,$f3,$f3,$f3,$f3,$f3,$f3


update_ecm_panel
.(
	lda _current_screen
	cmp #SCR_FRONT
	beq correct
	rts
correct
	lda #<$A095+40*5
	sta loop+3
	lda #>$A095+40*5
	sta loop+3+1

	lda _ecm_counter
	beq no_ecm_active
	lda #<panel_ecm_on
	ldx #>panel_ecm_on
	bne done	; Trick that assumes high byte cannot be zero!
no_ecm_active
	lda #<panel_ecm_off
	ldx #>panel_ecm_off
done
	sta tmp1
	stx tmp1+1

	ldy #23
loopo
	ldx #3
loop
	lda (tmp1),y
	sta $dead,x
	dey
	bmi end
	dex
	bpl loop

	lda loop+3
	sec
	sbc #40
	sta loop+3
	bcs nocarry
	dec loop+3+1
nocarry
	jmp loopo
end
	rts

.)

panel_ecm_on
 .byt $D7,$FC,$CF,$FA
 .byt $6A,$60,$41,$55
 .byt $D5,$D6,$DA,$EA
 .byt $6A,$69,$65,$55
 .byt $D5,$DF,$FE,$EA
 .byt $68,$43,$70,$45
panel_ecm_off
 .byt $FF,$FF,$FF,$FF
 .byt $40,$40,$40,$40
 .byt $FF,$FF,$FF,$FF
 .byt $40,$40,$40,$40
 .byt $FF,$FF,$FF,$FF
 .byt $40,$40,$40,$40




