
#include "profile.h"


#define ENABLE_ENERGY_FILL_UP



#define SCREN_ROAD_START		    $a000+72*40+1
#define ROADSIGN_SCREEN_POSITION    $a000+40*16+17
#define PLAYER_POD_SCREEN_POSITION  $a000+180*40
#define ROAD_SCREEN_POSITION       ($a000+72*40)



	.zero

save_x 		         .dsb 1
save_y 		         .dsb 1
_Position	         .dsb 2
_BackgroundPosition  .dsb 1
_GameLogoRaster1     .dsb 1
_RandomCounter       .dsb 1


;_VSyncCounter1			.dsb 2
;_VSyncCounter2			.dsb 2

_gKey					.dsb 1

;_System_IrqCounter		.dsb 1
;_SystemEffectTrigger	.dsb 1    //		$13       ;

;_System_VblCallBack		.dsb 2
_VblCounter				.dsb 1

_SystemFrameCounter
_SystemFrameCounter_low		.dsb 1
_SystemFrameCounter_high	.dsb 1

	.text

_RoadSignLow .byt 1
_RoadSignHigh .byt 1

_PlayerPodX 	.byt 100
_PlayerEnergy   .byt 0
_PlayerSpeed    .byt 0

_AttractModeSequence .byt 1    ; 0=in game  1=display welcome   2=display scores
_AttractModeCounter  .byt 0


_Score ;.byt 0,0,0,0,0,0,0,0,0   ; Up to 999.999.999
	.byt $21,$43,$65,$87,$09




_IncrementScore
	;jmp _IncrementScore
.(
 	php

	sei

	sed
	clc
	lda _Score+0
	adc #1
	sta _Score+0

	lda _Score+1
	adc #0
	sta _Score+1

	lda _Score+2
	adc #0
	sta _Score+2

	lda _Score+3
	adc #0
	sta _Score+3

	lda _Score+4
	adc #0
	sta _Score+4


	plp

	jsr _UpdateScreenScore

	rts
.)

; Each number is made of 6 characters (practical)
; 0 is at ID 32
_UpdateScreenScore
	;jmp _UpdateScreenScore
.(
	lda #<$bb80+25*40+34
	sta tmp1+0
	lda #>$bb80+25*40+34
	sta tmp1+1

    ; ------------------ First digit ------------------ 
	lda _Score+0
	and #$0F
	jsr _DisplaySingleDigit

	.(
	sec
	lda tmp1+0
	sbc #2
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1
	.)

	; ------------------ Second digit ------------------ 
	lda _Score+0
	lsr
	lsr
	lsr
	lsr
	jsr _DisplaySingleDigit

	.(
	sec
	lda tmp1+0
	sbc #2
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1
	.)

	; ------------------ Third digit ------------------ 
	lda _Score+1
	and #$0F
	jsr _DisplaySingleDigit

	.(
	sec
	lda tmp1+0
	sbc #3
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1
	.)

	; ------------------ Fourth digit ------------------ 
	lda _Score+1
	lsr
	lsr
	lsr
	lsr
	jsr _DisplaySingleDigit

	.(
	sec
	lda tmp1+0
	sbc #2
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1
	.)

	; ------------------ Fifth digit ------------------ 
	lda _Score+2
	and #$0F
	jsr _DisplaySingleDigit

	.(
	sec
	lda tmp1+0
	sbc #2
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1
	.)

	; ------------------ Sixth digit ------------------ 
	lda _Score+2
	lsr
	lsr
	lsr
	lsr
	jsr _DisplaySingleDigit

	.(
	sec
	lda tmp1+0
	sbc #3
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1
	.)

	; ------------------ Seventh digit ------------------ 
	lda _Score+3
	and #$0F
	jsr _DisplaySingleDigit

	.(
	sec
	lda tmp1+0
	sbc #2
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1
	.)

	; ------------------ Eight digit ------------------ 
	lda _Score+3
	lsr
	lsr
	lsr
	lsr
	jsr _DisplaySingleDigit

	.(
	sec
	lda tmp1+0
	sbc #2
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1
	.)

	; ------------------ Ninth digit ------------------ 
	lda _Score+4
	and #$0F
	jsr _DisplaySingleDigit
	/*
	.(
	sec
	lda tmp1+0
	sbc #2
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1
	.)
	*/

	rts
.)


_DisplaySingleDigit
.(
	tax
	clc
	lda _TableMul6,x

	adc #32
	ldy #0
	sta (tmp1),y           ; Top left

	ldy #40
	adc #1
	sta (tmp1),y           ; Center left

	ldy #80
	adc #1
	sta (tmp1),y           ; Bottom left

	ldy #1
	adc #1
	sta (tmp1),y           ; Top right

	ldy #41
	adc #1
	sta (tmp1),y           ; Center right

	ldy #81
	adc #1
	sta (tmp1),y           ; Bottom right

	rts
.)


_DisplayScore
.(
	lda #9                 ; ALT charset
	sta $bb80+25*40+2
	sta $bb80+26*40+2
	sta $bb80+27*40+2

	; Score colors
	lda #7
	sta $bb80+25*40+1
	lda #3
	sta $bb80+26*40+1
	lda #1
	sta $bb80+27*40+1

	; Numbers colors
	lda #7
	sta $bb80+25*40+15
	sta $bb80+25*40+22
	sta $bb80+25*40+29

	lda #6
	sta $bb80+26*40+15
	sta $bb80+26*40+22
	sta $bb80+26*40+29

	lda #2
	sta $bb80+27*40+15
	sta $bb80+27*40+22
	sta $bb80+27*40+29

	; Hide the crap on the right
	lda #0
	sta $bb80+25*40+36
	sta $bb80+26*40+36
	sta $bb80+27*40+36

	; Write text
	.(
	ldx #0
	clc
	lda #32+60
loop_x
	sta $bb80+25*40+3,x
	adc #1
	sta $bb80+26*40+3,x
	adc #1
	sta $bb80+27*40+3,x
	adc #1
	inx 
	cpx #12
	bne loop_x
	.)

	; Write zeroes
	.(
	ldx #0
	clc
	lda #32
loop_x
	sta $bb80+25*40+16,x
	sta $bb80+25*40+18,x
	sta $bb80+25*40+20,x
	;
	sta $bb80+25*40+23,x
	sta $bb80+25*40+25,x
	sta $bb80+25*40+27,x
	;
	sta $bb80+25*40+30,x
	sta $bb80+25*40+32,x
	sta $bb80+25*40+34,x

	adc #1

	sta $bb80+26*40+16,x
	sta $bb80+26*40+18,x
	sta $bb80+26*40+20,x
	;
	sta $bb80+26*40+23,x
	sta $bb80+26*40+25,x
	sta $bb80+26*40+27,x
	;
	sta $bb80+26*40+30,x
	sta $bb80+26*40+32,x
	sta $bb80+26*40+34,x

	adc #1

	sta $bb80+27*40+16,x
	sta $bb80+27*40+18,x
	sta $bb80+27*40+20,x
	;
	sta $bb80+27*40+23,x
	sta $bb80+27*40+25,x
	sta $bb80+27*40+27,x
	;
	sta $bb80+27*40+30,x
	sta $bb80+27*40+32,x
	sta $bb80+27*40+34,x

	adc #1
	inx 
	cpx #2
	bne loop_x
	.)

	lda #0
	sta _Score+0
	sta _Score+1
	sta _Score+2
	sta _Score+3
	sta _Score+4

	rts
.)

_InitializeAlternateCharset
.(
#if 0
	lda #9                 ; ALT charset
	sta $bb80+25*40+2
	sta $bb80+26*40+2
	sta $bb80+27*40+2

	; Write text
	.(
	ldx #0
	clc
	lda #32
loop_x
	sta $bb80+25*40+3,x
	adc #1
	sta $bb80+26*40+3,x
	adc #1
	sta $bb80+27*40+3,x
	adc #1
	inx 
	cpx #32
	bne loop_x
	.)
#endif
	;jsr _Breakpoint

	; Initialize charset
	.(
	lda #<_HighScoreCharacterStart
	sta tmp0+0
	lda #>_HighScoreCharacterStart
	sta tmp0+1

	lda #<$9C00+32*8  ; 9c00 for ALT / 9800 for STD
	sta tmp1+0
	lda #>$9C00+32*8
	sta tmp1+1

	lda #32
	sta tmp2
loop_x
	ldx #3*8
loop_y
	ldy #0
	lda (tmp0),y
	sta (tmp1),y

	clc
	lda tmp0+0
	adc #32
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1

	clc
	lda tmp1+0
	adc #1
	sta tmp1+0
	lda tmp1+1
	adc #0
	sta tmp1+1

	dex
	bne loop_y

	sec
	lda tmp0+0
	sbc #<32*24-1
	sta tmp0+0
	lda tmp0+1
	sbc #>32*24-1
	sta tmp0+1

	dec tmp2
	bne loop_x

	.)


	;jsr _Breakpoint
	rts
.)


_HandleGamePlay
	;jmp _HandleGamePlay
.(
	lda _AttractModeSequence
	beq play_mode
	rts  ; Attract mode

play_mode	
	lda _PlayerPodX

	; Are we out of the track
	cmp #175
	bcs out_of_tracks
	cmp #30
	bcc out_of_tracks

	; Are we in the wider area of the track
	cmp #115
	bcs on_the_track
	cmp #95
	bcc on_the_track
	bcs center_of_track

out_of_tracks	
	;jsr _Breakpoint

	; Make noise
	lda #128
	sta _PsgfreqNoise
	lda #10
	sta _PsgvolumeC

	;
	lda _Psgmixer
	and #%11011111
	sta _Psgmixer

	jsr _DecreaseEnergy
	jsr _DecreaseEnergy

	rts

center_of_track
	jsr _IncreaseEnergy
on_the_track
	; Stop noise
	lda _Psgmixer
	ora #%00100000
	sta _Psgmixer

	lda #0
	sta _PsgvolumeC

	rts
.)


_IncreaseEnergy
.(
	ldx _PlayerEnergy
	cpx #255
	beq maximum
	inx
	stx _PlayerEnergy
	jsr _UpdateEnergyBar
maximum	
	rts
.)

_DecreaseEnergy
.(
	ldx _PlayerEnergy
	beq zero
	dex
	stx _PlayerEnergy
	jsr _UpdateEnergyBar
zero	
	rts
.)


_UpdateEnergyBar
.(
	; _HiresAddrLow
	; _HiresAddrHigh

	lda _PlayerEnergy  // 0-255
	lsr                // 0-127
	lsr                // 0-63
	sta tmp0

	sec
	lda #63
	sbc tmp0
	tax

	lda _HiresAddrLow,x
	sta tmp1+0
	lda _HiresAddrHigh,x
	sta tmp1+1

	lda #0
	ldy #34
	sta (tmp1),y

	ldy #34+40
	lda #3
	sta (tmp1),y

	ldy #34+80
	lda #2
	sta (tmp1),y

	rts
.)



_PlayerPodMoveLeft
.(
	ldx _PlayerPodX
	cpx #12
	beq skip
	dex
	stx _PlayerPodX
skip	
	rts
.)


_PlayerPodMoveRight
.(
	ldx _PlayerPodX
	cpx #190
	beq skip
	inx
	stx _PlayerPodX
skip	
	rts
.)




_FillUpEnergy
.(

	clc
	lda #<$a000+40*64+1
	sta tmp1+0
	adc #33
	sta tmp2+0
	lda #>$a000+40*64+1
	sta tmp1+1
	adc #0
	sta tmp2+1

#ifdef ENABLE_ENERGY_FILL_UP
	lda #<400
	sta _PsgfreqA+0
	lda #>400
	sta _PsgfreqA+1

	lda #10
	sta _PsgvolumeA

	lda #8+16+32+64+128
	sta _Psgmixer
#endif

	ldx #64
loop
#ifdef ENABLE_ENERGY_FILL_UP
	jsr _VSync
	jsr _VSync
#endif

	sec
	lda _PsgfreqA+0
	sbc #2
	sta _PsgfreqA+0
	lda _PsgfreqA+1
	sbc #0
	sta _PsgfreqA+1

	ldy #0
	lda #1
	sta (tmp1),y
	lda #2
	sta (tmp2),y


	sec
	lda tmp1+0
	sbc #40
	sta tmp1+0
	lda tmp1+1
	sbc #0
	sta tmp1+1

	sec
	lda tmp2+0
	sbc #40
	sta tmp2+0
	lda tmp2+1
	sbc #0
	sta tmp2+1
	
	dex
	bne loop

	lda #0
	sta _PsgvolumeA

	lda #255
	sta _PlayerEnergy

	lda #0
	sta _PlayerSpeed

	rts
.)

; Each display is 18x64 (3x64 bytes=192)
_DisplayEnergySpeed
.(
	clc
	lda #<$a000+40*1+2
	sta tmp1+0
	adc #33
	sta tmp2+0
	lda #>$a000+40*1+2
	sta tmp1+1
	adc #0
	sta tmp2+1

	ldx #0
loop_y	
	ldy #0
loop_x
	lda _EnergySpeedStart,x
	sta (tmp1),y
	lda _EnergySpeedStart+3*64,x
	sta (tmp2),y
	inx
	iny
	cpy #3
	bne loop_x

	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	

	clc
	lda tmp2+0
	adc #40
	sta tmp2+0
	bcc skip2
	inc tmp2+1
skip2	

	cpx #3*64
	bne loop_y

	rts
.)



_ClearRoadArea
.(
	lda #<ROAD_SCREEN_POSITION+1
	sta tmp1+0
	lda #>ROAD_SCREEN_POSITION+1
	sta tmp1+1

	ldx #127
loop_y	

	lda #64
	ldy #38
loop_x
	sta (tmp1),y
	dey
	bne loop_x

	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	

	dex
	bne loop_y

	rts
.)


_DrawTriangularRoadArea
.(
	lda #<ROAD_SCREEN_POSITION+40+1
	sta tmp1+0
	lda #>ROAD_SCREEN_POSITION+40+1
	sta tmp1+1

	ldx #0
loop_y	
	lda _TableDiv6,x
	beq skip_line
	sta tmp0             ; counter

	lsr                  ; /2
	sta tmp0+1           ; counter

	sec
	lda #20
	sbc tmp0+1
	tay

	lda #64+1+2+4+8+16+32
loop_x
	sta (tmp1),y
	iny
	dec tmp0
	bne loop_x
skip_line

	clc
	lda tmp1+0
	adc #80
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	

	inx
	inx
	inx
	cpx #190
	bcc loop_y


loop
	;jmp loop
	rts
.)







_EraseDrawRoadSign
.(
	ldx #0
loop_y	
	ldy #0
	lda #64
	sta (tmp1),y
	iny
loop_x
	lda #64

	inx
	sta (tmp1),y
	iny
	cpy #6
	bne loop_x

	lda #64
	sta (tmp1),y
	iny

	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	

	cpx #5*29
	bne loop_y

	rts
.)


_DrawRoadSign
.(
	lda #<ROADSIGN_SCREEN_POSITION
	sta tmp1+0
	lda #>ROADSIGN_SCREEN_POSITION
	sta tmp1+1

	lda _RoadSignLow
	sta loop_x+1
	lda _RoadSignHigh
	sta loop_x+2
	beq _EraseDrawRoadSign

	ldx #0
loop_y	
	ldy #0
	lda #%000011+64
	sta (tmp1),y
	iny
loop_x
	lda $1234,x
	ora #64
	eor #128

	inx
	sta (tmp1),y
	iny
	cpy #6
	bne loop_x

	lda #%110000+64
	sta (tmp1),y
	iny


	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	

	cpx #5*29
	bne loop_y

	rts
.)






; Player pod is 48x18=8 bytes wide
; 8*18=144 bytes per sprite -> 864 bytes total
_DrawPlayerPod
.(
	ldx _PlayerPodX
	lda _TableDiv6,x
	tay
	lda _TableMod6,x
	asl                 ; x2
	asl                 ; x4
	asl                 ; x8
	tax

	;ldy _PlayerPodX

	;ldx #0
	;ldy #20

	lda #9
	sta tmp0
loop_x	
	lda _PlayerPodStart+49*0,x
	sta PLAYER_POD_SCREEN_POSITION+40*0,y
	lda _PlayerPodStart+49*1,x
	;sta PLAYER_POD_SCREEN_POSITION+40*1,y
	lda _PlayerPodStart+49*2,x
	sta PLAYER_POD_SCREEN_POSITION+40*2,y
	lda _PlayerPodStart+49*3,x
	;sta PLAYER_POD_SCREEN_POSITION+40*3,y
	lda _PlayerPodStart+49*4,x
	sta PLAYER_POD_SCREEN_POSITION+40*4,y
	lda _PlayerPodStart+49*5,x
	;sta PLAYER_POD_SCREEN_POSITION+40*5,y
	lda _PlayerPodStart+49*6,x
	sta PLAYER_POD_SCREEN_POSITION+40*6,y
	lda _PlayerPodStart+49*7,x
	;sta PLAYER_POD_SCREEN_POSITION+40*7,y
	lda _PlayerPodStart+49*8,x
	sta PLAYER_POD_SCREEN_POSITION+40*8,y
	lda _PlayerPodStart+49*9,x
	;sta PLAYER_POD_SCREEN_POSITION+40*9,y

	lda _PlayerPodStart+49*10,x
	sta PLAYER_POD_SCREEN_POSITION+40*10,y
	lda _PlayerPodStart+49*11,x
	;sta PLAYER_POD_SCREEN_POSITION+40*11,y
	lda _PlayerPodStart+49*12,x
	sta PLAYER_POD_SCREEN_POSITION+40*12,y
	lda _PlayerPodStart+49*13,x
	;sta PLAYER_POD_SCREEN_POSITION+40*13,y
	lda _PlayerPodStart+49*14,x
	sta PLAYER_POD_SCREEN_POSITION+40*14,y
	lda _PlayerPodStart+49*15,x
	;sta PLAYER_POD_SCREEN_POSITION+40*15,y
	lda _PlayerPodStart+49*16,x
	sta PLAYER_POD_SCREEN_POSITION+40*16,y
	lda _PlayerPodStart+49*17,x

	inx
	iny

	dec tmp0
	bne loop_x

	rts
.)




_AttractModeTextDisplay
.(
	lda _AttractModeSequence
	bne update
    rts

update
	dec _AttractModeCounter
	beq next
	rts

next	
	;jmp display_howtoplay  ; ---- test

	cmp #4
	beq display_howtoplay
	cmp #3
	beq display_story
	cmp #2
	beq display_scores
	bne display_welcome

display_welcome	
	jsr _EraseEvenLines
	jsr _DisplayWelcomeText
	lda #255
	sta _AttractModeCounter
	lda #2
	sta _AttractModeSequence
	rts

display_scores	
	jsr _EraseEvenLines
	jsr _DisplayScoresText
	lda #255
	sta _AttractModeCounter
	lda #3
	sta _AttractModeSequence
	rts

display_story
	jsr _EraseEvenLines
	jsr _DisplayStoryText
	lda #255
	sta _AttractModeCounter
	lda #4
	sta _AttractModeSequence
	rts

display_howtoplay
	jsr _EraseEvenLines
	jsr _DisplayHowToPlayText
	lda #255
	sta _AttractModeCounter
	lda #1
	sta _AttractModeSequence
	rts

.)


_EraseEvenLines
.(
	lda #<ROAD_SCREEN_POSITION
	sta tmp1+0
	lda #>ROAD_SCREEN_POSITION
	sta tmp1+1

	ldx #64
loop_y

	ldy #39
	lda #64  ; +1+4+16
loop_x
	sta (tmp1),y
	dey
	bpl loop_x

	clc
	lda tmp1+0
	adc #80
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	

	dex
	bne loop_y

	rts
.)




#define PRINT_TEXT(x,y,message) \
:.(                              \
	:lda #<$a000+x+40*y          \
	:sta tmp1+0                  \
	:lda #>$a000+x+40*y          \
	:sta tmp1+1                  \
	:lda #<message_data          \
	:sta __TextFetch+1           \
	:lda #>message_data          \
	:sta __TextFetch+2           \
	:jmp continue                \
:message_data                    \
	:.byt message                \
	:.byt 0                      \
:continue                        \
	:jsr _HiresDoublePrintOut    \
:.) 



; Going to use the font in $9800
_DisplayWelcomeText
	PRINT_TEXT(16,80,"WELCOME TO")
	PRINT_TEXT(11,100,"QUANTUM FX TURBO ULTRA")
	PRINT_TEXT(19,120,"V1.1")
	PRINT_TEXT(7,140,"THE ULTIMATE ORIC RACING GAME")
	PRINT_TEXT(2,160,"FOR THE CEO NEW YEAR 2019 COMPETITION")
	PRINT_TEXT(10,180,"(C) 2018 DEFENCE FORCE")
	rts	

_DisplayScoresText
	PRINT_TEXT(17,80,"HALL OF FAME")
	PRINT_TEXT(10,100,"#1 Woupite")
	PRINT_TEXT(10,120,"#2 Floushate")
	PRINT_TEXT(10,140,"#3 Rushronic")
	PRINT_TEXT(10,160,"#4 QubaiRace")
	PRINT_TEXT(10,180,"#5 Z-Fero")
	rts	

_DisplayStoryText
	PRINT_TEXT(13,80,"THE STORY SO FAR")
	PRINT_TEXT(3,100,"THE YEAR IS 3142 OR SOMETHING, AND")
	PRINT_TEXT(4,120,"HUMANS ARE NOW LIVING IN VIRTUAL")
	PRINT_TEXT(3,140,"WORLDS DESIGNED TO ENTERTAIN THEM.")
	PRINT_TEXT(4,160,"QUANTUM RACING HAS BECOME ONE OF")
	PRINT_TEXT(5,180,"THE FAVORITE SPORTS ALL AROUND.")
	rts	

_DisplayHowToPlayText
	PRINT_TEXT(14,80,"HOW TO PLAY")
	PRINT_TEXT(3,100,"USE YOUR VIRTUAL INTERFACE TO STEER")
	PRINT_TEXT(3,120,"LEFT AND RIGHT AS WELL AS ACCELERATE")
	PRINT_TEXT(3,140,"AND BREAK.")
	PRINT_TEXT(3,160,"FIGHT THE CENTRIFUGAL FORCE AND STAY")
	PRINT_TEXT(3,180,"IN THE CENTER TO COLLECT ENERGY.")
	rts	



_HiresDoublePrintOut	
	//jmp _HiresDoublePrintOut
.(
	/*
	lda #<$a000+20+40*100
	sta tmp1+0
	lda #>$a000+20+40*100
	sta tmp1+1
	*/

	ldx #0
loop
+__TextFetch
	lda $1234,x
	beq exit
	inx 
	stx save_x

	; a*1
	sta tmp0+0
	lda #0
	sta tmp0+1

	asl tmp0+0
	rol tmp0+1  ; x2

	asl tmp0+0
	rol tmp0+1  ; x4

	asl tmp0+0
	rol tmp0+1  ; x8

	clc
	lda tmp0+0
	adc #<$9800
	sta tmp0+0
	lda tmp0+1
	adc #>$9800
	sta tmp0+1

	ldy #7
loop_fetch	
	lda (tmp0),y
	pha
	dey
	bpl loop_fetch

	ldy #0
	ldx #0
loop_write
	pla
	ora #64
	sta (tmp1),y

	clc
	lda tmp1+0
	adc #80
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	

	inx
	cpx #8
	bne loop_write

	sec
	lda tmp1+0
	sbc #<640-1
	sta tmp1+0
	lda tmp1+1
	sbc #>640-1
	sta tmp1+1

	ldx save_x


	bne loop

exit
	rts
.)



_GameLogoRasterTable
	.byt 7
	.byt 7
	.byt 6
	.byt 7
	.byt 6
	.byt 6
	.byt 2
	.byt 6
	.byt 2
	.byt 2
	.byt 5
	.byt 2
	.byt 5
	.byt 5
	.byt 2
	.byt 5
	.byt 2
	.byt 2
	.byt 6
	.byt 2
	.byt 6
	.byt 6
	.byt 7
	.byt 6
	.byt 6
	.byt 7
	.byt 7
	.byt 6
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 3
	.byt 7
	.byt 7
	.byt 3
	.byt 7
	.byt 3
	.byt 3
	.byt 7
	.byt 7
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 7
	.byt 3
	.byt 3
	.byt 7
	.byt 3
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7

_GameLogoRasterTable2
	.byt 1
	.byt 1
	.byt 3
	.byt 1
	.byt 3
	.byt 3
	.byt 2
	.byt 3
	.byt 2
	.byt 2
	.byt 5
	.byt 2
	.byt 5
	.byt 5
	.byt 2
	.byt 5
	.byt 2
	.byt 2
	.byt 3
	.byt 2
	.byt 3
	.byt 3
	.byt 1
	.byt 3
	.byt 3
	.byt 1
	.byt 1
	.byt 3
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 3
	.byt 1
	.byt 1
	.byt 3
	.byt 1
	.byt 3
	.byt 3
	.byt 1
	.byt 1
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 1
	.byt 3
	.byt 3
	.byt 1
	.byt 3
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1

_AnimateGameLogoRasters
.(
	lda _GameLogoRaster1
	clc
	adc #1
	and #31
	sta _GameLogoRaster1
	tax 

	lda #<$a000+3+40*5
	sta tmp0+0
	lda #>$a000+3+40*5
	sta tmp0+1

	lda #<$a000+2+40*(19+5)
	sta tmp1+0
	lda #>$a000+2+40*(19+5)
	sta tmp1+1

	lda #19
	sta _RandomCounter
loop_y
	lda _GameLogoRasterTable,x
	ldy #0
	sta (tmp0),y
	lda _GameLogoRasterTable2,x
	ldy #25
	sta (tmp0),y

	lda _GameLogoRasterTable2,x
	ldy #0
	sta (tmp1),y
	lda _GameLogoRasterTable,x
	ldy #18
	sta (tmp1),y

	inx

	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1

	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	lda tmp1+1
	adc #0
	sta tmp1+1

	dec _RandomCounter
	bne loop_y	
	rts
.)


; 198x38 (33 bytes)
_DrawGameLogo
.(
	lda #<_GameLogoStart-1
	sta tmp0+0
	lda #>_GameLogoStart-1
	sta tmp0+1

	lda #<$a000+3+40*5
	sta tmp1+0
	lda #>$a000+3+40*5
	sta tmp1+1

	ldx #38
loop_y
	ldy #33
loop_x
	lda (tmp0),y
	sta (tmp1),y
	dey
	bne loop_x

	clc
	lda tmp0+0
	adc #33
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1

	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	lda tmp1+1
	adc #0
	sta tmp1+1

	dex
	bne loop_y	

	rts
.)

; _ScrollingBackground
; Picture is 512x30
;
; 2580 bytes / 6 = 430 bytes per shifted image
; Each image is 5 lines of 86 bytes


.(
go_4
	ldy #38
loop_4
	lda _ScrollingBackground+430*4+86*0,x
	sta $a000+1+40*67+40*0,y
	lda _ScrollingBackground+430*4+86*1,x
	sta $a000+1+40*67+40*1,y
	lda _ScrollingBackground+430*4+86*2,x
	sta $a000+1+40*67+40*2,y
	lda _ScrollingBackground+430*4+86*3,x
	sta $a000+1+40*67+40*3,y
	lda _ScrollingBackground+430*4+86*4,x
	sta $a000+1+40*67+40*4,y

	dex
	dey
	bne loop_4
	rts

go_5
	ldy #38
loop_5
	lda _ScrollingBackground+430*5+86*0,x
	sta $a000+1+40*67+40*0,y
	lda _ScrollingBackground+430*5+86*1,x
	sta $a000+1+40*67+40*1,y
	lda _ScrollingBackground+430*5+86*2,x
	sta $a000+1+40*67+40*2,y
	lda _ScrollingBackground+430*5+86*3,x
	sta $a000+1+40*67+40*3,y
	lda _ScrollingBackground+430*5+86*4,x
	sta $a000+1+40*67+40*4,y

	dex
	dey
	bne loop_5
	rts

+_DrawBackground
	ldy _BackgroundPosition
	lda _TableDiv6,y
	clc 
	adc #39
	tax

	lda _TableMod6,y
	tay
	beq go_5
	dey
	beq go_4
	dey
	beq go_3
	dey
	beq go_2
	dey
	beq go_1
	bne go_0


go_0
	ldy #38
loop_0
	lda _ScrollingBackground+430*0+86*0,x
	sta $a000+1+40*67+40*0,y
	lda _ScrollingBackground+430*0+86*1,x
	sta $a000+1+40*67+40*1,y
	lda _ScrollingBackground+430*0+86*2,x
	sta $a000+1+40*67+40*2,y
	lda _ScrollingBackground+430*0+86*3,x
	sta $a000+1+40*67+40*3,y
	lda _ScrollingBackground+430*0+86*4,x
	sta $a000+1+40*67+40*4,y

	dex
	dey
	bne loop_0
	rts

go_1
	ldy #38
loop_1
	lda _ScrollingBackground+430*1+86*0,x
	sta $a000+1+40*67+40*0,y
	lda _ScrollingBackground+430*1+86*1,x
	sta $a000+1+40*67+40*1,y
	lda _ScrollingBackground+430*1+86*2,x
	sta $a000+1+40*67+40*2,y
	lda _ScrollingBackground+430*1+86*3,x
	sta $a000+1+40*67+40*3,y
	lda _ScrollingBackground+430*1+86*4,x
	sta $a000+1+40*67+40*4,y

	dex
	dey
	bne loop_1
	rts

go_2
	ldy #38
loop_2
	lda _ScrollingBackground+430*2+86*0,x
	sta $a000+1+40*67+40*0,y
	lda _ScrollingBackground+430*2+86*1,x
	sta $a000+1+40*67+40*1,y
	lda _ScrollingBackground+430*2+86*2,x
	sta $a000+1+40*67+40*2,y
	lda _ScrollingBackground+430*2+86*3,x
	sta $a000+1+40*67+40*3,y
	lda _ScrollingBackground+430*2+86*4,x
	sta $a000+1+40*67+40*4,y

	dex
	dey
	bne loop_2
	rts

go_3
	ldy #38
loop_3
	lda _ScrollingBackground+430*3+86*0,x
	sta $a000+1+40*67+40*0,y
	lda _ScrollingBackground+430*3+86*1,x
	sta $a000+1+40*67+40*1,y
	lda _ScrollingBackground+430*3+86*2,x
	sta $a000+1+40*67+40*2,y
	lda _ScrollingBackground+430*3+86*3,x
	sta $a000+1+40*67+40*3,y
	lda _ScrollingBackground+430*3+86*4,x
	sta $a000+1+40*67+40*4,y

	dex
	dey
	bne loop_3
	rts
.)





;	for (y=0;y<128;y++)
;	{
;		if (y&1)
;		{
;			x=RoadMiddleTableHigh[y];
;			curset(120+x+RoadWidthTable[y]-10,72+y,0);
;			draw(10,0,0);
;			draw(-RoadWidthTable[y]*2,0,1);
;			draw(10,0,0);
;		}
;	}
;
; RoadWidthTable[y]	=-(100*y)/128;

#define ROAD(position)	:clc                                     \
						:lda _RoadMiddleTableHigh+position       \
						:adc #120-(100*position)/128             \
						:tay                                     \
						:lda _Mod6Left,y                         \
						:ldx _TableDiv6,y                        \
						:sta $a000+0+40*72+40*position+1,x       \
						:lda #64                                 \
						:sta $a000+0+40*72+40*position+0,x       \
						:lda #64+63                              \
						:sta $a000+0+40*72+40*position+2,x       \
						:clc                                     \
						:lda _RoadMiddleTableHigh+position       \
						:adc #120+(100*position)/128             \
						:tay                                     \
						:lda _Mod6Right,y                        \
						:ldx _TableDiv6,y                        \
						:sta $a000+0+40*72+40*position+1,x       \
						:lda #64+63                              \
						:sta $a000+0+40*72+40*position+0,x       \
						:lda #64                                 \
						:sta $a000+0+40*72+40*position+2,x                                      


_RoadDrawLoopASM
.(
	lda #<ROAD_SCREEN_POSITION
	sta tmp1+0
	lda #>ROAD_SCREEN_POSITION
	sta tmp1+1

	;ROAD(1)
	ROAD(3)
	ROAD(5)
	ROAD(7)
	ROAD(9)
	ROAD(11)
	ROAD(13)
	ROAD(15)
	ROAD(17)
	ROAD(19)
	ROAD(21)
	ROAD(23)
	ROAD(25)
	ROAD(27)
	ROAD(29)
	ROAD(31)
	ROAD(33)
	ROAD(35)
	ROAD(37)
	ROAD(39)
	ROAD(41)
	ROAD(43)
	ROAD(45)
	ROAD(47)
	ROAD(49)
	ROAD(51)
	ROAD(53)
	ROAD(55)
	ROAD(57)
	ROAD(59)
	ROAD(61)
	ROAD(63)
	ROAD(65)
	ROAD(67)
	ROAD(69)
	ROAD(71)
	ROAD(73)
	ROAD(75)
	ROAD(77)
	ROAD(79)
	ROAD(81)
	ROAD(83)
	ROAD(85)
	ROAD(87)
	ROAD(89)
	ROAD(91)
	ROAD(93)
	ROAD(95)
	ROAD(97)
	ROAD(99)
	ROAD(101)
	ROAD(103)
	ROAD(105)
	ROAD(107)
	ROAD(109)
	ROAD(111)
	ROAD(113)
	ROAD(115)
	ROAD(117)
	ROAD(119)
	ROAD(121)
	ROAD(123)
	ROAD(125)
	ROAD(127)

	rts
.)


/*
_Raster1 ; 256 bytes
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
*/

_Raster1 ; 256 bytes
	.byt 7,7,7,7,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 0,0,0,0,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 4,4,4,4,6,6,6,6,4,4,4,4,6,6,6,6,4,4,4,4,6,6,6,6,4,4,4,4,6,6,6,6  ; 32
	.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	;.byt 3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1,3,3,3,3,1,1,1,1  ; 32
	.byt 7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0  ; 32


_GroundRaster
	;.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+7,16+7,16+6,16+7,16+6,16+6,16+7,16+6,16+6,16+2,16+6,16+6,16+2,16+6,16+2,16+2	
	.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2

	.byt 16+3,16+2,16+2,16+2,16+3,16+3,16+2,16+2,16+3,16+3,16+3,16+2,16+3,16+3,16+3,16+3
	.byt 16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3
	.byt 16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3
	.byt 16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3,16+3

	.byt 16+1,16+3,16+3,16+3,16+1,16+1,16+3,16+3,16+1,16+1,16+3,16+1,16+1,16+1,16+3,16+1
	.byt 16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1
	.byt 16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1
	.byt 16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1,16+1

	.byt 16+0,16+1,16+1,16+1,16+0,16+0,16+1,16+1,16+0,16+1,16+1,16+1,16+0,16+1,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0

	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0

	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0

	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0

	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0
	.byt 16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0,16+0

	; ---------------
	.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+1,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+4,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2
	.byt 16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2,16+2



; DivTable[y]=(4096/(y+16))>>2;
;
;	if (y&1)
;	{
;		f=(DivTable[y]+position);
;		adr[1]=Raster1[f&31];
;	}
#define RASTER(position)    :clc                            \
							:lda #(4096/(position+16)>>2)   \
							:adc _Position                  \
							:tax                            \
							:lda _Raster1,x                 \
							:sta $a000+1+40*72+40*position  \
							:lda _GroundRaster+position/2,y \
							:sta $a000+0+40*72+40*position  \

_ScrollColors
.(
	PROFILE_ENTER(ROUTINE_SCROLL_COLORS);

	inc _Position

	sec
	lda #255
	sbc _PlayerEnergy
	tay

	; Colorize the 
	lda _GroundRaster,y 
	and #7                 ; Remove the paper flag
	sta $a000+1+40*67
	sta $a000+1+40*68
	sta $a000+1+40*69
	sta $a000+1+40*70
	sta $a000+1+40*71

	RASTER(1)
	RASTER(3)
	RASTER(5)
	RASTER(7)
	RASTER(9)
	RASTER(11)
	RASTER(13)
	RASTER(15)
	RASTER(17)
	RASTER(19)
	RASTER(21)
	RASTER(23)
	RASTER(25)
	RASTER(27)
	RASTER(29)
	RASTER(31)
	RASTER(33)
	RASTER(35)
	RASTER(37)
	RASTER(39)
	RASTER(41)
	RASTER(43)
	RASTER(45)
	RASTER(47)
	RASTER(49)
	RASTER(51)
	RASTER(53)
	RASTER(55)
	RASTER(57)
	RASTER(59)
	RASTER(61)
	RASTER(63)
	RASTER(65)
	RASTER(67)
	RASTER(69)
	RASTER(71)
	RASTER(73)
	RASTER(75)
	RASTER(77)
	RASTER(79)
	RASTER(81)
	RASTER(83)
	RASTER(85)
	RASTER(87)
	RASTER(89)
	RASTER(91)
	RASTER(93)
	RASTER(95)
	RASTER(97)
	RASTER(99)
	RASTER(101)
	RASTER(103)
	RASTER(105)
	RASTER(107)
	RASTER(109)
	RASTER(111)
	RASTER(113)
	RASTER(115)
	RASTER(117)
	RASTER(119)
	RASTER(121)
	RASTER(123)
	RASTER(125)
	RASTER(127)

	PROFILE_LEAVE(ROUTINE_SCROLL_COLORS);
	rts
.)


;       RoadWidthTable[y]	=-(100*y)/128;
;		offset=((int)LeftTable[y]-(120+(int)RoadWidthTable[y]))*2;	// *256/128
;		RoadOffsetTableLow[y]	=offset&255;
;		RoadOffsetTableHigh[y]	=(offset>>8)&255;


;       RoadWidthTable[y]	=-(100*position)/128;
;		offset=((int)LeftTable[y]-(120+-(100*position)/128))*2;	// *256/128
;		RoadOffsetTableLow[y]	=offset&255;
;		RoadOffsetTableHigh[y]	=(offset>>8)&255;


#define TURN_LEFT(position) :clc                               \
							:lda _RoadMiddleTableLow+position  \
							:adc _RoadOffsetTableLow+position  \
							:sta _RoadMiddleTableLow+position  \
							:lda _RoadMiddleTableHigh+position \
							:adc _RoadOffsetTableHigh+position \
							:sta _RoadMiddleTableHigh+position 

#define TURN_RIGHT(position) :sec                              \
						 	:lda _RoadMiddleTableLow+position  \
							:sbc _RoadOffsetTableLow+position  \
							:sta _RoadMiddleTableLow+position  \
							:lda _RoadMiddleTableHigh+position \
							:sbc _RoadOffsetTableHigh+position \
							:sta _RoadMiddleTableHigh+position 

_TurnLeftSimple
.(
	;dec _BackgroundPosition
	;jsr _PlayerPodMoveRight

	TURN_LEFT(1)
	TURN_LEFT(3)
	TURN_LEFT(5)
	TURN_LEFT(7)
	TURN_LEFT(9)
	TURN_LEFT(11)
	TURN_LEFT(13)
	TURN_LEFT(15)
	TURN_LEFT(17)
	TURN_LEFT(19)
	TURN_LEFT(21)
	TURN_LEFT(23)
	TURN_LEFT(25)
	TURN_LEFT(27)
	TURN_LEFT(29)
	TURN_LEFT(31)
	TURN_LEFT(33)
	TURN_LEFT(35)
	TURN_LEFT(37)
	TURN_LEFT(39)
	TURN_LEFT(41)
	TURN_LEFT(43)
	TURN_LEFT(45)
	TURN_LEFT(47)
	TURN_LEFT(49)
	TURN_LEFT(51)
	TURN_LEFT(53)
	TURN_LEFT(55)
	TURN_LEFT(57)
	TURN_LEFT(59)
	TURN_LEFT(61)
	TURN_LEFT(63)
	TURN_LEFT(65)
	TURN_LEFT(67)
	TURN_LEFT(69)
	TURN_LEFT(71)
	TURN_LEFT(73)
	TURN_LEFT(75)
	TURN_LEFT(77)
	TURN_LEFT(79)
	TURN_LEFT(81)
	TURN_LEFT(83)
	TURN_LEFT(85)
	TURN_LEFT(87)
	TURN_LEFT(89)
	TURN_LEFT(91)
	TURN_LEFT(93)
	TURN_LEFT(95)
	TURN_LEFT(97)
	TURN_LEFT(99)
	TURN_LEFT(101)
	TURN_LEFT(103)
	TURN_LEFT(105)
	TURN_LEFT(107)
	TURN_LEFT(109)
	TURN_LEFT(111)
	TURN_LEFT(113)
	TURN_LEFT(115)
	TURN_LEFT(117)
	TURN_LEFT(119)
	TURN_LEFT(121)
	TURN_LEFT(123)
	TURN_LEFT(125)
	TURN_LEFT(127)
	rts
.)


_TurnRightSimple
.(
	;inc _BackgroundPosition
	;jsr _PlayerPodMoveLeft

	TURN_RIGHT(1)
	TURN_RIGHT(3)
	TURN_RIGHT(5)
	TURN_RIGHT(7)
	TURN_RIGHT(9)
	TURN_RIGHT(11)
	TURN_RIGHT(13)
	TURN_RIGHT(15)
	TURN_RIGHT(17)
	TURN_RIGHT(19)
	TURN_RIGHT(21)
	TURN_RIGHT(23)
	TURN_RIGHT(25)
	TURN_RIGHT(27)
	TURN_RIGHT(29)
	TURN_RIGHT(31)
	TURN_RIGHT(33)
	TURN_RIGHT(35)
	TURN_RIGHT(37)
	TURN_RIGHT(39)
	TURN_RIGHT(41)
	TURN_RIGHT(43)
	TURN_RIGHT(45)
	TURN_RIGHT(47)
	TURN_RIGHT(49)
	TURN_RIGHT(51)
	TURN_RIGHT(53)
	TURN_RIGHT(55)
	TURN_RIGHT(57)
	TURN_RIGHT(59)
	TURN_RIGHT(61)
	TURN_RIGHT(63)
	TURN_RIGHT(65)
	TURN_RIGHT(67)
	TURN_RIGHT(69)
	TURN_RIGHT(71)
	TURN_RIGHT(73)
	TURN_RIGHT(75)
	TURN_RIGHT(77)
	TURN_RIGHT(79)
	TURN_RIGHT(81)
	TURN_RIGHT(83)
	TURN_RIGHT(85)
	TURN_RIGHT(87)
	TURN_RIGHT(89)
	TURN_RIGHT(91)
	TURN_RIGHT(93)
	TURN_RIGHT(95)
	TURN_RIGHT(97)
	TURN_RIGHT(99)
	TURN_RIGHT(101)
	TURN_RIGHT(103)
	TURN_RIGHT(105)
	TURN_RIGHT(107)
	TURN_RIGHT(109)
	TURN_RIGHT(111)
	TURN_RIGHT(113)
	TURN_RIGHT(115)
	TURN_RIGHT(117)
	TURN_RIGHT(119)
	TURN_RIGHT(121)
	TURN_RIGHT(123)
	TURN_RIGHT(125)
	TURN_RIGHT(127)
	rts
.)




; That code should erase the 128 bottom lines
;
;
_RoadErase
	lda #64
	ldx #38
RoadEraseLoop
	sta SCREN_ROAD_START+40*0,x
	sta SCREN_ROAD_START+40*1,x
	sta SCREN_ROAD_START+40*2,x
	sta SCREN_ROAD_START+40*3,x
	sta SCREN_ROAD_START+40*4,x
	sta SCREN_ROAD_START+40*5,x
	sta SCREN_ROAD_START+40*6,x
	sta SCREN_ROAD_START+40*7,x
	sta SCREN_ROAD_START+40*8,x
	sta SCREN_ROAD_START+40*9,x
	sta SCREN_ROAD_START+40*10,x
	sta SCREN_ROAD_START+40*11,x
	sta SCREN_ROAD_START+40*12,x
	sta SCREN_ROAD_START+40*13,x
	sta SCREN_ROAD_START+40*14,x
	sta SCREN_ROAD_START+40*15,x
	sta SCREN_ROAD_START+40*16,x
	sta SCREN_ROAD_START+40*17,x
	sta SCREN_ROAD_START+40*18,x
	sta SCREN_ROAD_START+40*19,x
	sta SCREN_ROAD_START+40*20,x
	sta SCREN_ROAD_START+40*21,x
	sta SCREN_ROAD_START+40*22,x
	sta SCREN_ROAD_START+40*23,x
	sta SCREN_ROAD_START+40*24,x
	sta SCREN_ROAD_START+40*25,x
	sta SCREN_ROAD_START+40*26,x
	sta SCREN_ROAD_START+40*27,x
	sta SCREN_ROAD_START+40*28,x
	sta SCREN_ROAD_START+40*29,x
	sta SCREN_ROAD_START+40*30,x
	sta SCREN_ROAD_START+40*31,x
	sta SCREN_ROAD_START+40*32,x
	sta SCREN_ROAD_START+40*33,x
	sta SCREN_ROAD_START+40*34,x
	sta SCREN_ROAD_START+40*35,x
	sta SCREN_ROAD_START+40*36,x
	sta SCREN_ROAD_START+40*37,x
	sta SCREN_ROAD_START+40*38,x
	sta SCREN_ROAD_START+40*39,x
	sta SCREN_ROAD_START+40*40,x
	sta SCREN_ROAD_START+40*41,x
	sta SCREN_ROAD_START+40*42,x
	sta SCREN_ROAD_START+40*43,x
	sta SCREN_ROAD_START+40*44,x
	sta SCREN_ROAD_START+40*45,x
	sta SCREN_ROAD_START+40*46,x
	sta SCREN_ROAD_START+40*47,x
	sta SCREN_ROAD_START+40*48,x
	sta SCREN_ROAD_START+40*49,x
	sta SCREN_ROAD_START+40*50,x
	sta SCREN_ROAD_START+40*51,x
	sta SCREN_ROAD_START+40*52,x
	sta SCREN_ROAD_START+40*53,x
	sta SCREN_ROAD_START+40*54,x
	sta SCREN_ROAD_START+40*55,x
	sta SCREN_ROAD_START+40*56,x
	sta SCREN_ROAD_START+40*57,x
	sta SCREN_ROAD_START+40*58,x
	sta SCREN_ROAD_START+40*59,x
	sta SCREN_ROAD_START+40*60,x
	sta SCREN_ROAD_START+40*61,x
	sta SCREN_ROAD_START+40*62,x
	sta SCREN_ROAD_START+40*63,x
	sta SCREN_ROAD_START+40*64,x
	sta SCREN_ROAD_START+40*65,x
	sta SCREN_ROAD_START+40*66,x
	sta SCREN_ROAD_START+40*67,x
	sta SCREN_ROAD_START+40*68,x
	sta SCREN_ROAD_START+40*69,x
	sta SCREN_ROAD_START+40*70,x
	sta SCREN_ROAD_START+40*71,x
	sta SCREN_ROAD_START+40*72,x
	sta SCREN_ROAD_START+40*73,x
	sta SCREN_ROAD_START+40*74,x
	sta SCREN_ROAD_START+40*75,x
	sta SCREN_ROAD_START+40*76,x
	sta SCREN_ROAD_START+40*77,x
	sta SCREN_ROAD_START+40*78,x
	sta SCREN_ROAD_START+40*79,x
	sta SCREN_ROAD_START+40*80,x
	sta SCREN_ROAD_START+40*81,x
	sta SCREN_ROAD_START+40*82,x
	sta SCREN_ROAD_START+40*83,x
	sta SCREN_ROAD_START+40*84,x
	sta SCREN_ROAD_START+40*85,x
	sta SCREN_ROAD_START+40*86,x
	sta SCREN_ROAD_START+40*87,x
	sta SCREN_ROAD_START+40*88,x
	sta SCREN_ROAD_START+40*89,x
	sta SCREN_ROAD_START+40*90,x
	sta SCREN_ROAD_START+40*91,x
	sta SCREN_ROAD_START+40*92,x
	sta SCREN_ROAD_START+40*93,x
	sta SCREN_ROAD_START+40*94,x
	sta SCREN_ROAD_START+40*95,x
	sta SCREN_ROAD_START+40*96,x
	sta SCREN_ROAD_START+40*97,x
	sta SCREN_ROAD_START+40*98,x
	sta SCREN_ROAD_START+40*99,x
	sta SCREN_ROAD_START+40*100,x
	sta SCREN_ROAD_START+40*101,x
	sta SCREN_ROAD_START+40*102,x
	sta SCREN_ROAD_START+40*103,x
	sta SCREN_ROAD_START+40*104,x
	sta SCREN_ROAD_START+40*105,x
	sta SCREN_ROAD_START+40*106,x
	sta SCREN_ROAD_START+40*107,x
	sta SCREN_ROAD_START+40*108,x
	sta SCREN_ROAD_START+40*109,x
	sta SCREN_ROAD_START+40*110,x
	sta SCREN_ROAD_START+40*111,x
	sta SCREN_ROAD_START+40*112,x
	sta SCREN_ROAD_START+40*113,x
	sta SCREN_ROAD_START+40*114,x
	sta SCREN_ROAD_START+40*115,x
	sta SCREN_ROAD_START+40*116,x
	sta SCREN_ROAD_START+40*117,x
	sta SCREN_ROAD_START+40*118,x
	sta SCREN_ROAD_START+40*119,x
	sta SCREN_ROAD_START+40*120,x
	sta SCREN_ROAD_START+40*121,x
	sta SCREN_ROAD_START+40*122,x
	sta SCREN_ROAD_START+40*123,x
	sta SCREN_ROAD_START+40*124,x
	sta SCREN_ROAD_START+40*125,x
	sta SCREN_ROAD_START+40*126,x
	sta SCREN_ROAD_START+40*127,x

	dex
	beq RoadEraseEnd
	jmp RoadEraseLoop


RoadEraseEnd
	rts
