
_Y0		.byt	0
_DIV6	.byt	0
_MOD6	.byt	0

_LeftPattern
	.byt 1+2+4+8+16+32
	.byt 1+2+4+8+16
	.byt 1+2+4+8
	.byt 1+2+4
	.byt 1+2
	.byt 1


_RightPattern
	.byt 63-(1+2+4+8+16+32)
	.byt 63-(1+2+4+8+16)
	.byt 63-(1+2+4+8)
	.byt 63-(1+2+4)
	.byt 63-(1+2)
	.byt 63-(1)


_Tables_InitialiseScreenAddrTable
.(
	/*
	.( ; Clear the BSS section
	lda #0

	ldx #<_BssStart_
	stx tmp0
	ldx #>_BssStart_
	stx tmp0

	ldx #((_BssEnd_-_BssStart_)+1)/256
loop_outer
	tay
loop_inner
	sta (tmp0),y
	dey
	bne loop_inner
	inc tmp0
	dex
	bne loop_outer
	.)
	*/

	
	.( ; Generate multiple of 6 data table
	lda #0
	sta tmp0+0	// cur mul
	sta tmp0+1	// cur div
	sta tmp0+2	// cur mod

	ldx #0
loop
	lda tmp0+0
	clc
	sta _TableMul6,x
	adc #6
	sta tmp0+0

	lda tmp0+1
	sta _TableDiv6,x

	lda tmp0+2
	sta _TableMod6,x

	ldy tmp0+2
	iny
	cpy #6
	bne skip_mod
	ldy #0
	inc tmp0+1
skip_mod
	sty tmp0+2

	inx
	bne loop
	.)

	.( ; Generate the patterns
	lda	#0
	sta	_Y0

	ldx	#0
loop_div
	;
	; Store Div6
	;
	lda	_DIV6
	ldy	_Y0
	//sta	_Div6,y

	;
	; Store Mod6
	;
	ldy	_MOD6
	lda	_LeftPattern,y
	ldy	_Y0
	ora #64
	sta	_Mod6Left,y

	ldy	_MOD6
	lda	_RightPattern,y
	ldy	_Y0
	ora #64
	sta	_Mod6Right,y


	;
	; Update Div/Mod
	;
	inc	_MOD6
	lda	_MOD6
	cmp	#6
	bne	no_update
	lda	#0
	sta	_MOD6
	inc	_DIV6
no_update

	;
	; Inc Y
	;
	inc	_Y0
	ldy	_Y0
	bne	loop_div
	.)

	.( ; Generate the screen addresses
	lda #<$a000
	sta tmp0+0
	lda #>$a000
	sta tmp0+1

	ldx	#0
loop
	lda	tmp0+0
	sta	_HiresAddrLow,x
	lda	tmp0+1
	sta	_HiresAddrHigh,x

	clc
	lda	tmp0+0
	adc	#40
	sta	tmp0+0
	bcc skip
	inc	tmp0+1
skip

	inx
	cpx #200
	bne	loop
	.)

	rts
.)



_Rasters
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+6
	.byt 16+4
	.byt 16+4
	.byt 16+6
	.byt 16+4
	.byt 16+6
	.byt 16+6
	.byt 16+4
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+3
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+3
	.byt 16+6
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+1
	.byt 16+3
	.byt 16+3
	.byt 16+1
	.byt 16+3
	.byt 16+1
	.byt 16+1
	.byt 16+1
	.byt 16+1
	.byt 16+5
	.byt 16+1
	.byt 16+5
	.byt 16+5
	.byt 16+1
	.byt 16+1
	.byt 16+5
	.byt 16+5
	.byt 16+0	
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2
	.byt 16+0
	.byt 16+2



_LeftTable
	.byt 1
	.byt 10
	.byt 19
	.byt 29
	.byt 35
	.byt 38
	.byt 42
	.byt 45
	.byt 48
	.byt 52
	.byt 54
	.byt 57
	.byt 61
	.byt 65
	.byt 68
	.byt 72
	.byt 76
	.byt 80
	.byt 84
	.byt 87
	.byt 91
	.byt 94
	.byt 97
	.byt 99
	.byt 102
	.byt 104
	.byt 107
	.byt 109
	.byt 111
	.byt 112
	.byt 113
	.byt 114
	.byt 115
	.byt 116
	.byt 117
	.byt 118
	.byt 118
	.byt 119
	.byt 119
	.byt 120
	.byt 120
	.byt 120
	.byt 121
	.byt 121
	.byt 121
	.byt 122
	.byt 122
	.byt 122
	.byt 122
	.byt 122
	.byt 122
	.byt 122
	.byt 122
	.byt 122
	.byt 121
	.byt 121
	.byt 121
	.byt 120
	.byt 120
	.byt 120
	.byt 119
	.byt 119
	.byt 118
	.byt 118
	.byt 117
	.byt 116
	.byt 115
	.byt 113
	.byt 112
	.byt 111
	.byt 110
	.byt 109
	.byt 108
	.byt 107
	.byt 106
	.byt 105
	.byt 104
	.byt 103
	.byt 101
	.byt 100
	.byt 99
	.byt 98
	.byt 97
	.byt 96
	.byt 95
	.byt 94
	.byt 93
	.byt 92
	.byt 90
	.byt 88
	.byt 87
	.byt 85
	.byt 84
	.byt 82
	.byt 81
	.byt 79
	.byt 77
	.byt 76
	.byt 74
	.byt 73
	.byt 72
	.byt 71
	.byt 68
	.byt 67
	.byt 65
	.byt 63
	.byt 62
	.byt 60
	.byt 58
	.byt 56
	.byt 54
	.byt 53
	.byt 50
	.byt 49
	.byt 48
	.byt 46
	.byt 44
	.byt 42
	.byt 41
	.byt 38  ;39-----
	.byt 36  ;38
	.byt 34  ;35-----
	.byt 31  ;33
	.byt 28  ;28-----
	.byt 26  ;25
	.byt 24  ;20-----
	.byt 21  ;16
	.byt 18  ;10-----

_BackgroundStart
#include "scrolling_background.s"
_BackgroundEnd

_EnergySpeedStart
#include "energy_speed.s"
_EnergySpeedEnd

_GameLogoStart
#include "game_logo.s"
_GameLogoEnd

_PlayerPodStart
#include "player_pod.s"
_PlayerPodEnd

// 0123456789SCORE:
// 32x3 characters
_HighScoreCharacterStart
#include "highscores_characters.s"
_HighScoreCharacterEnd

; 30x29 pixels
; 5x29 bytes=
; 0-Forward
; 1-ZigZag
; 2-Scared
; 3-Left
; 4-Right
_RoadSignsStart
#include "road_signs.s"
_RoadSignsEnd

_PlayerPodOffsetTable	.byt 8*0,


_TrackDataPtr	.word _TrackData

; Commands:
; 0 -> END of TRACK
; 1 -> IMAGE to draw (followed by pointer)
; else -> ROAD segment

#define TRACK_END  .byt 0
#define TRACK_SIGNAL_OFF  	  .byt 1,0,0
#define TRACK_SIGNAL(signal)  .byt 1,<_RoadSignsStart+signal*5*29,>_RoadSignsStart+signal*5*29

#define TRACK_SECTION(duration,curve) .byt duration,curve

_TrackData
	TRACK_SIGNAL(0)
	.byt 128,0           ; Straight
	TRACK_SIGNAL_OFF
	.byt 128,0           ; Straight

		;TRACK_END  

	TRACK_SIGNAL(3)
	.byt 32,255
	TRACK_SIGNAL_OFF
	.byt 32,1

	.byt 128,0           ; Straight

	TRACK_SIGNAL(4)
	.byt 32,1
	TRACK_SIGNAL_OFF
	.byt 32,255

	.byt 128,0           ; Straight


	TRACK_SIGNAL(3)
	.byt 32,254
	TRACK_SIGNAL_OFF
	.byt 32,2

	.byt 128,0           ; Straight

	TRACK_SIGNAL(4)
	.byt 32,2
	TRACK_SIGNAL_OFF
	.byt 32,254

	.byt 128,0           ; Straight

	TRACK_SIGNAL(3)
	.byt 32,256-4
	TRACK_SIGNAL_OFF
	.byt 32,4

	.byt 128,0           ; Straight

	TRACK_SIGNAL(4)
	.byt 32,4
	TRACK_SIGNAL_OFF
	.byt 32,256-4

	.byt 128,0           ; Straight


	TRACK_SIGNAL(3)
	.byt 128,255         ; Left
	.byt 128,0
	TRACK_SIGNAL_OFF
	.byt 128,1

	.byt 128,0	
	
	TRACK_SIGNAL(4)
	.byt 128,1
	.byt 128,0	
	TRACK_SIGNAL_OFF

	.byt 128,255
	TRACK_END               ; End of track


/*
_Font6x6Start
#include "font_6x6.s"
_Font6x6End
*/

/*
_Font8x8Start
#include "font_6x6.s"
_Font6x6End
*/


;	.bss
;	*=$C000
	.dsb 256-(*&255)

_BssStart_

_BufferAddrLow
_HiresAddrLow			.dsb 176
_TextAddrLow			.dsb 80
_BufferAddrHigh
_HiresAddrHigh			.dsb 176
_TextAddrHigh			.dsb 80

_TableMul6				.dsb 256
_TableDiv6				.dsb 256
_TableMod6				.dsb 256

_Mod6Left				.dsb 256
_Mod6Right				.dsb 256

_DivTable				.dsb 256

_RoadMiddleTableLow		.dsb 128
_RoadMiddleTableHigh	.dsb 128

_RoadOffsetTableLow     .dsb 128
_RoadOffsetTableHigh    .dsb 128

_RoadWidthTable			.dsb 128


_BssEnd_

	.text


