;Map01Code.s

;Holds screen specific code
; S00 Castle Flags (2),S01,S04
; S00 Guards holding spears patrolling castle
; S00 Ripples in water (Same as S06)
; S00,01,02,03,04,05,06 Stars
; S02 Lighthouse Beam
; S02 Church light flicker
; S02 Chimney smoke
; S01 Flag
; S01 Cable and Platform/Barrel rising and falling from 1st floor door
; S01 Ripples in water
; S03 Hillside light flicker
; S04 Tower Flag
; S04 Splashing sluece
; S04,S05,S06 Seagulls
; S05 waves
; S05 Distant tower candlelight
; S06 Ship Flag
; S06 Rocking boat
ResetScreenEvents
	;Execute for new screen
	lda #00
	sta WaveCount
	rts

ProcessScreenEvents
	inc EventFrameIndex
	ldx ScreenID
	lda EventList_VectorLo,x
	sta header
	lda EventList_VectorHi,x
	sta header+1
.(
loop1	ldy #00
	lda (header),y
	bmi EndOfList
	pha
	tax
	lda EventTypeVectorLo,x
	sta vector1+1
	lda EventTypeVectorHi,x
	sta vector1+2
	iny
vector1	jsr $dead
	pla
	tax
	lda header
	clc
	adc EventType_Bytes,x
	sta header
	lda header+1
	adc #00
	sta header+1
	jmp loop1
EndOfList
	rts
.)


eveCode_Star
	;Fetch Screen loc of star
	jsr FetchScreen
	jsr getrand
	and #3
	tax
	lda TwinkleColour,x
	ldy #00
	sta (screen),y
	iny
	lda #%01001000
	sta (screen),y
	rts

FetchScreen
	lda (header),y
	sta screen
	iny
	lda (header),y
	sta screen+1
	iny
	rts

TwinkleColour
 .byt 6,3,2,7


eveCode_Flag
	;Fetch Screen loc for flag
	jsr FetchScreen
	;Fetch Frame
	lda EventFrameIndex
	and #03
	tax
	lda FlagWaveFrameAddressLo,x
.(
	sta vector1+1
	lda FlagWaveFrameAddressHi,x
	sta vector1+2
	;Display Flag
	ldx #20
vector1	lda $dead,x
	ldy ScreenOffset3xH,x
	sta (screen),y
	dex
	bpl vector1
.)
	rts
FlagWaveFrameAddressLo
 .byt <FlagWaveFrame0
 .byt <FlagWaveFrame1
 .byt <FlagWaveFrame2
 .byt <FlagWaveFrame3
FlagWaveFrameAddressHi
 .byt >FlagWaveFrame0
 .byt >FlagWaveFrame1
 .byt >FlagWaveFrame2
 .byt >FlagWaveFrame3
FlagWaveFrame0	;3x7
 .byt %01000000,%01000000,%01000000
 .byt %01110000,%01000011,%01000000
 .byt %01000011,%01001111,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01100000
 .byt %01110011,%01111100,%01100000
 .byt %01000000,%01110000,%01000000
FlagWaveFrame1
 .byt %01000000,%01000000,%01000000
 .byt %01110000,%01000011,%01000000
 .byt %01000011,%01000111,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01100000
 .byt %01110011,%01111100,%01100000
 .byt %01000000,%01111000,%01000000
FlagWaveFrame2
 .byt %01000000,%01000000,%01100000
 .byt %01110000,%01000011,%01100000
 .byt %01000011,%01001111,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01000000
 .byt %01110011,%01111100,%01000000
 .byt %01000000,%01110000,%01000000
FlagWaveFrame3
 .byt %01000000,%01000000,%01000000
 .byt %01110000,%01000011,%01100000
 .byt %01000010,%01011111,%01100000
 .byt %01110011,%01111111,%01100000
 .byt %01000011,%01111111,%01100000
 .byt %01110011,%01111100,%01000000
 .byt %01000001,%01100000,%01000000


eveCode_Flow
eveCode_Lift
eveCode_Flicker
eveCode_Sluece
	rts
eveCode_Wave
	ldx WaveCount
	cpx #31
.(
	bcc skip4
	jmp skip5
skip4	;Generate new wave
	lda (header),y	;LevelWaveHorizonWidth
	jsr GetRNDRange
	iny
	adc (header),y	;LevelWaveHorizonLeft
	sta wsX,x
	iny
	lda (header),y	;LevelWaveHorizonHeight
	jsr GetRNDRange
	iny
	adc (header),y	;LevelWaveHorizonDown
	sta wsY,x
	jsr getrand
	and #63
	ora #64
	sta wsBitmap,x
	;plot bitmap
	ldy wsY,x
	lda SYLocl,y
	sta screen
	lda SYLoch,y
	sta screen+1
	ldy wsX,x
	iny
	lda (screen),y
	cmp #127
	bne skip5
	lda wsX,x
	clc
	adc #40
	tay

	lda #7
	sta (screen),y
	iny
	lda wsBitmap,x
	sta (screen),y

	inc WaveCount

skip5	;Process existing waves
	ldx WaveCount
	beq skip3
	dex

loop1	;Calc screen loc
	ldy wsY,x
	lda SYLocl,y
	sta screen
	lda SYLoch,y
	sta screen+1
	lda wsX,x
	clc
	adc #40
	tay
	lda #7
	sta (screen),y
	iny
	sty temp01
	lda wsBitmap,x
	asl
	;gradually reduce granularity
;	and rndRandom
	and #63
	sta wsBitmap,x
	bne skip1
	;nothing left to shift - Whilst still displaying, remove wave index
	ora #64
	ldy temp01
	sta (screen),y
	ldy WaveCount	;always Marks last wave
	dey
	lda wsX,y
	sta wsX,x
	lda wsY,y
	sta wsY,x
	lda wsBitmap,y
	sta wsBitmap,x
	dec WaveCount
	jmp skip2

skip1	ora #64
	ldy temp01
	sta (screen),y

skip2	dex
	bpl loop1
skip3	rts
.)

WaveCount	.byt 0
wsX
 .dsb 32,0
wsY
 .dsb 32,0
wsBitmap
 .dsb 32,0

eveCode_Seagulls
eveCode_ShipFlag
	rts
eveCode_Moor
	;
	rts


EventTypeVectorLo
 .byt <eveCode_Star
 .byt <eveCode_Flag
 .byt <eveCode_Flow
 .byt <eveCode_Lift
 .byt <eveCode_Flicker
 .byt <eveCode_Sluece
 .byt <eveCode_Wave
 .byt <eveCode_Seagulls
 .byt <eveCode_Moor
 .byt <eveCode_ShipFlag
EventTypeVectorHi
 .byt >eveCode_Star
 .byt >eveCode_Flag
 .byt >eveCode_Flow
 .byt >eveCode_Lift
 .byt >eveCode_Flicker
 .byt >eveCode_Sluece
 .byt >eveCode_Wave
 .byt >eveCode_Seagulls
 .byt >eveCode_Moor
 .byt >eveCode_ShipFlag
EventType_Bytes
 .byt 3    ;eveCode_Star
 .byt 3    ;eveCode_Flag
 .byt 5    ;eveCode_Flow
 .byt 1    ;eveCode_Lift
 .byt 3    ;eveCode_Flicker
 .byt 3    ;eveCode_Sluece
 .byt 5    ;eveCode_Wave
 .byt 5    ;eveCode_Seagulls
 .byt 1    ;eveCode_Moor
 .byt 1    ;eveCode_ShipFlag
EventFrameIndex	.byt 0

EventList_VectorLo
 .byt <EventList_SCN01
 .byt <EventList_SCN02
 .byt <EventList_SCN03
 .byt <EventList_SCN04
 .byt <EventList_SCN05
 .byt <EventList_SCN06
 .byt <EventList_SCN07
EventList_VectorHi
 .byt >EventList_SCN01
 .byt >EventList_SCN02
 .byt >EventList_SCN03
 .byt >EventList_SCN04
 .byt >EventList_SCN05
 .byt >EventList_SCN06
 .byt >EventList_SCN07


EventList_SCN01
 .byt eve_Star,<$A000+16+40*50,>$A000+16+40*50
 .byt eve_Flag,<$A000+15+40*76,>$A000+15+40*76
 .byt eve_Flag,<$A000+23+40*76,>$A000+23+40*76
 .byt eve_Flow,<$A000+1+40*151,>$A000+1+40*151,13,5
 .byt eve_EOL
EventList_SCN02
; .byt eve_Star,ScreenLo,ScreenHi
; .byt eve_Star,ScreenLo,ScreenHi
; .byt eve_Star,ScreenLo,ScreenHi
 .byt eve_Flow,<$A000+21+40*160,>$A000+21+40*160,10,4
 .byt eve_Lift
 .byt eve_Flag,<$A000+35+40*82,>$A000+35+40*82
 .byt eve_Flicker,<$A000+24+40*103,>$A000+24+40*103
 .byt eve_EOL
EventList_SCN03
 .byt eve_EOL
EventList_SCN04
 .byt eve_EOL
EventList_SCN05
 .byt eve_Star,<$A000+4+40*48,>$A000+4+40*48
 .byt eve_Star,<$A000+38+40*48,>$A000+38+40*48
 .byt eve_Star,<$A000+35+40*50,>$A000+35+40*50
 .byt eve_Flag,<$A000+21+40*47,>$A000+21+40*47
 .byt eve_Sluece,<$A000+24+40*149,>$A000+24+40*149
 .byt eve_Wave,39,1,3,160	;mn,W,X,H,Y
 .byt eve_Seagulls,<$A000+24+40*52,>$A000+24+40*52,16,34
 .byt eve_EOL
EventList_SCN06
 .byt eve_Star,<$A000+4+40*48,>$A000+4+40*48
 .byt eve_Star,<$A000+38+40*48,>$A000+38+40*48
 .byt eve_Star,<$A000+35+40*50,>$A000+35+40*50
 .byt eve_Wave,13,27,10,112	;mn,W,X,H,Y
 .byt eve_EOL
EventList_SCN07
 .byt eve_Star,<$A000+4+40*48,>$A000+4+40*48
 .byt eve_Star,<$A000+38+40*48,>$A000+38+40*48
 .byt eve_Star,<$A000+35+40*50,>$A000+35+40*50
 .byt eve_Moor
 .byt eve_ShipFlag
 .byt eve_Wave,<$A000+1+40*102,>$A000+1+40*102,39,15
 .byt eve_EOL


