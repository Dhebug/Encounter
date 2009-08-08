;SeaToSamson


#define HIRES	$EC33
 .zero
source		.dsb 2 
screen		.dsb 2
temp01		.dsb 1
WaveFerocity	.dsb 1
RowerFrame	.dsb 1

 .text
*=$500


Driver	jmp TestDriver

#include "RowingBoat_AweFrames.s"
#include "Rower.s"

TestDriver
	jsr HIRES
	jsr SetupScreen
.(	
loop1	jsr GenerateWaves
	jsr Wipe_ScreenBufferOverHero
	jsr Copy_WaveBuffer2ScreenBuffer
;	jsr OverlayRowingBoat
;	jsr OverlayHeroAndOars
	jsr Copy_ScreenBuffer2RealScreen
	jmp loop1
.)
OBE_RowerFrameAddressLo
 .byt <OBE_Frame00
 .byt <OBE_Frame01
 .byt <OBE_Frame02
 .byt <OBE_Frame03
 .byt <OBE_Frame04
 .byt <OBE_Frame05
 .byt <OBE_Frame06
 .byt <OBE_Frame07
 .byt <OBE_Frame08
 .byt <OBE_Frame09
 .byt <OBE_Frame10
 .byt <OBE_Frame11
 .byt <OBE_Frame12
 .byt <OBE_Frame13
 .byt <OBE_Frame14
 .byt <OBE_Frame15
OBE_RowerFrameAddressHi
 .byt >OBE_Frame00
 .byt >OBE_Frame01
 .byt >OBE_Frame02
 .byt >OBE_Frame03
 .byt >OBE_Frame04
 .byt >OBE_Frame05
 .byt >OBE_Frame06
 .byt >OBE_Frame07
 .byt >OBE_Frame08
 .byt >OBE_Frame09
 .byt >OBE_Frame10
 .byt >OBE_Frame11
 .byt >OBE_Frame12
 .byt >OBE_Frame13
 .byt >OBE_Frame14
 .byt >OBE_Frame15
OverlayHeroAndOars
	lda RowerFrame
	clc
	adc #1
	and #15
	sta RowerFrame
	tax
	lda OBE_RowerFrameAddressLo,x
	sta source
	lda OBE_RowerFrameAddressHi,x
	sta source+1
	ldx #20
	lda WaveHeight+20
	asl
	clc
	adc #11
	tay
	jmp PlotOBE
	
OverlayRowingBoat
	;Calculate Awe
	lda WaveHeight+16	;Front of Boat wave height
	cmp WaveHeight+24	;Back of boat
.(
	beq BoatLevel
	bcc AweRight
	;But by how much?
;	sbc WaveHeight+24
	lda #<OBE_FrameAweLeft16
	sta source
	lda #>OBE_FrameAweLeft16
	jmp skip1
AweRight	lda #<OBE_FrameLevel
	sta source
	lda #>OBE_FrameLevel
	jmp skip1
BoatLevel	lda #<OBE_FrameAweRight16
	sta source
	lda #>OBE_FrameAweRight16
skip1	sta source+1
.)
	ldx #20
	lda WaveHeight+20
	asl
	clc
	adc #12
	tay
	jmp PlotOBE

	
CursorX		.byt 0
CursorY		.byt 0
InterlaceRow	.byt 0
RowType		.byt 0

	
End
	rts
PlotOBE
	;
	stx CursorX
	sty CursorY
	ldy #00
	lda #1
	sta InterlaceRow
	sta RowType
.(	
loop1	lda (source),y
;	sei
;	jmp loop1
	bmi Inversed
	cmp #8
	beq End
	bcc Plot
	cmp #24
	bcc Plot
	cmp #64
	bcs Plot
XStep	cmp #44
	bcc MoveLeft
MoveRight	sbc #44
	clc
	adc CursorX
	sta CursorX
	jmp CalcScreenAndNextByte
MoveLeft	sec
	sbc #24
	sta temp01
	lda CursorX
	sbc temp01
	sta CursorX
	jmp CalcScreenAndNextByte
Inversed	cmp #24+128
	bcc Plot
	cmp #64+128
	bcs Plot
YStep	cmp #44+128
	bcc MoveUp
MoveDown	sbc #44+128
	clc
	adc CursorY
	sta CursorY
	;Currently we can't deal with jumping more than 1 row
	jmp CalculateIfInterlaceRow
MoveUp	sec
	sbc #24+128
	sta temp01
	lda CursorY
	sbc temp01
	sta CursorY
CalculateIfInterlaceRow
	and #1
	ldx #00
	cmp RowType
	bne NotInterlaceRow
	ldx #1
NotInterlaceRow
	stx InterlaceRow
	jmp CalcScreenAndNextByte
Plot	;Interlace?
	ldx InterlaceRow
	bne NonInterlacedRow
InterlaceByte
	and (screen),y
	sta (screen),y
	inc CursorX
	jmp CalcScreenAndNextByte
NonInterlacedRow
	sta (screen),y
	inc CursorX
CalcScreenAndNextByte
	lda CursorX
	ldx CursorY
	clc
	adc ScreenBufferYLOCL,x
	sta screen
	lda ScreenBufferYLOCH,x
	adc #00
	sta screen+1
NextByte	inc source
	bne skip1
	inc source+1
skip1	jmp loop1
.)	

ScreenBufferYLOCL
 .byt <ScreenBuffer
 .byt <ScreenBuffer+40*1
 .byt <ScreenBuffer+40*2
 .byt <ScreenBuffer+40*3
 .byt <ScreenBuffer+40*4
 .byt <ScreenBuffer+40*5
 .byt <ScreenBuffer+40*6
 .byt <ScreenBuffer+40*7
 .byt <ScreenBuffer+40*8
 .byt <ScreenBuffer+40*9
 .byt <ScreenBuffer+40*10
 .byt <ScreenBuffer+40*11
 .byt <ScreenBuffer+40*12
 .byt <ScreenBuffer+40*13
 .byt <ScreenBuffer+40*14
 .byt <ScreenBuffer+40*15
 .byt <ScreenBuffer+40*16
 .byt <ScreenBuffer+40*17
 .byt <ScreenBuffer+40*18
 .byt <ScreenBuffer+40*19
 .byt <ScreenBuffer+40*20
 .byt <ScreenBuffer+40*21
 .byt <ScreenBuffer+40*22
 .byt <ScreenBuffer+40*23
 .byt <ScreenBuffer+40*24
 .byt <ScreenBuffer+40*25
 .byt <ScreenBuffer+40*26
 .byt <ScreenBuffer+40*27
 .byt <ScreenBuffer+40*28
 .byt <ScreenBuffer+40*29
 .byt <ScreenBuffer+40*30
 .byt <ScreenBuffer+40*31
 .byt <ScreenBuffer+40*32
 .byt <ScreenBuffer+40*33
 .byt <ScreenBuffer+40*34
 .byt <ScreenBuffer+40*35
 .byt <ScreenBuffer+40*36
 .byt <ScreenBuffer+40*37
 .byt <ScreenBuffer+40*38
 .byt <ScreenBuffer+40*39
 .byt <ScreenBuffer+40*40
 .byt <ScreenBuffer+40*41
 .byt <ScreenBuffer+40*42
 .byt <ScreenBuffer+40*43
 .byt <ScreenBuffer+40*44
 .byt <ScreenBuffer+40*45
 .byt <ScreenBuffer+40*46
 .byt <ScreenBuffer+40*47
 .byt <ScreenBuffer+40*48
 .byt <ScreenBuffer+40*49
 .byt <ScreenBuffer+40*50
 .byt <ScreenBuffer+40*51
 .byt <ScreenBuffer+40*52
 .byt <ScreenBuffer+40*53
 .byt <ScreenBuffer+40*54
 .byt <ScreenBuffer+40*55
 .byt <ScreenBuffer+40*56
 .byt <ScreenBuffer+40*57
 .byt <ScreenBuffer+40*58
 .byt <ScreenBuffer+40*59
 .byt <ScreenBuffer+40*60
 .byt <ScreenBuffer+40*61
 .byt <ScreenBuffer+40*62
 .byt <ScreenBuffer+40*63
ScreenBufferYLOCH
 .byt >ScreenBuffer
 .byt >ScreenBuffer+40*1
 .byt >ScreenBuffer+40*2
 .byt >ScreenBuffer+40*3
 .byt >ScreenBuffer+40*4
 .byt >ScreenBuffer+40*5
 .byt >ScreenBuffer+40*6
 .byt >ScreenBuffer+40*7
 .byt >ScreenBuffer+40*8
 .byt >ScreenBuffer+40*9
 .byt >ScreenBuffer+40*10
 .byt >ScreenBuffer+40*11
 .byt >ScreenBuffer+40*12
 .byt >ScreenBuffer+40*13
 .byt >ScreenBuffer+40*14
 .byt >ScreenBuffer+40*15
 .byt >ScreenBuffer+40*16
 .byt >ScreenBuffer+40*17
 .byt >ScreenBuffer+40*18
 .byt >ScreenBuffer+40*19
 .byt >ScreenBuffer+40*20
 .byt >ScreenBuffer+40*21
 .byt >ScreenBuffer+40*22
 .byt >ScreenBuffer+40*23
 .byt >ScreenBuffer+40*24
 .byt >ScreenBuffer+40*25
 .byt >ScreenBuffer+40*26
 .byt >ScreenBuffer+40*27
 .byt >ScreenBuffer+40*28
 .byt >ScreenBuffer+40*29
 .byt >ScreenBuffer+40*30
 .byt >ScreenBuffer+40*31
 .byt >ScreenBuffer+40*32
 .byt >ScreenBuffer+40*33
 .byt >ScreenBuffer+40*34
 .byt >ScreenBuffer+40*35
 .byt >ScreenBuffer+40*36
 .byt >ScreenBuffer+40*37
 .byt >ScreenBuffer+40*38
 .byt >ScreenBuffer+40*39
 .byt >ScreenBuffer+40*40
 .byt >ScreenBuffer+40*41
 .byt >ScreenBuffer+40*42
 .byt >ScreenBuffer+40*43
 .byt >ScreenBuffer+40*44
 .byt >ScreenBuffer+40*45
 .byt >ScreenBuffer+40*46
 .byt >ScreenBuffer+40*47
 .byt >ScreenBuffer+40*48
 .byt >ScreenBuffer+40*49
 .byt >ScreenBuffer+40*50
 .byt >ScreenBuffer+40*51
 .byt >ScreenBuffer+40*52
 .byt >ScreenBuffer+40*53
 .byt >ScreenBuffer+40*54
 .byt >ScreenBuffer+40*55
 .byt >ScreenBuffer+40*56
 .byt >ScreenBuffer+40*57
 .byt >ScreenBuffer+40*58
 .byt >ScreenBuffer+40*59
 .byt >ScreenBuffer+40*60
 .byt >ScreenBuffer+40*61
 .byt >ScreenBuffer+40*62
 .byt >ScreenBuffer+40*63
WaveHeight
 .dsb 40,0
SetupScreen
	ldx #59
.(
loop1	lda SYLocl,x
	sta screen
	lda SYLoch,x
	sta screen+1
	ldy #0
	lda #4
	sta (screen),y
	ldy #40
	sta (screen),y
	iny
	lda #$14
	sta (screen),y
	cpx #31
	bcc skip1
	ldy #39
	lda #127
loop2	sta (screen),y
	dey
	bne loop2
skip1	dex
	bpl loop1
.)	
	lda #0
	sta WaveFerocity
	sei
	rts
	
GenerateWaves
.(
loop2	ldx #39
loop1	lda WaveFracCount1	;,x
	adc #77
	sta WaveFracCount1	;,x
	lda WaveIntersectionIndex1,x
	adc #00
	sta WaveIntersectionIndex1,x

	lda WaveFracCount2	;,x
	sec
	sbc #111
	sta WaveFracCount2	;,x
	lda WaveIntersectionIndex2,x
	sbc #00
	sta WaveIntersectionIndex2,x
;	inc WaveFrac2
	ldy WaveIntersectionIndex1,x
	lda SineTable,y
	ldy WaveIntersectionIndex2,x
	lsr
	;A Max is 7
	clc
	adc SineTable,y
	;A Max is 21(+3 for Clearing below)==24 or Less(LSR)
	ldy WaveFerocity	;0(High)/1(Low)/128(Medium)
	beq skip1
	bmi skip2
	lsr
skip2	lsr
skip1	sta WaveHeight,x
;	clc
;	adc #20
	tay
	jsr PlotByte
	dex
	bne loop1
	;jmp loop2
	rts
.)

PlotByte
	txa
	clc
	adc WaveBufferYLOCL,y
	sta screen
	lda WaveBufferYLOCH,y
	adc #00
	sta screen+1
;	;If height step greater than one then plot inverse
;	lda #127
;	cpy temp01
;.(
;	beq skip1
;	lda #127+128
;skip1	pha
;.)
	sty temp01
	ldy #00
	lda #64
	sta (screen),y
	ldy #40
	sta (screen),y
	lda #127
	ldy #80
	sta (screen),y
	ldy #120
	sta (screen),y
	ldy temp01
	rts
	

;	sty temp01
;	ldy #00
;	lda #64
;	sta (screen),y
;	ldy #80
;	sta (screen),y
;	lda #127
;	ldy #160
;	sta (screen),y
;	;lda #127
;	ldy #240
;	sta (screen),y
;	ldy temp01
;	rts
Wipe_ScreenBufferOverHero
	lda #<ScreenBuffer+16+40
	sta screen
	lda #>ScreenBuffer+16+40
	sta screen+1
	ldx #31
.(
loop2	ldy #9
	lda #64
loop1	sta (screen),y
	dey
	bpl loop1
	ldy #24+41
	lda #$14
	sta (screen),y
	lda #80
	jsr AddScreen
	dex
	bne loop2
.)
	rts

Copy_WaveBuffer2ScreenBuffer	;And wipe odd rows
	lda #<WaveBuffer
	sta source
	lda #>WaveBuffer
	sta source+1
	lda #<ScreenBuffer+16*40
	sta screen
	lda #>ScreenBuffer+16*40
	sta screen+1
	ldx #25
.(
loop2	ldy #39
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #40
	jsr AddSource
	lda #80
	jsr AddScreen
	dex
	bne loop2
.)
	rts
	
Copy_ScreenBuffer2RealScreen
	lda #<ScreenBuffer
	sta source
	lda #>ScreenBuffer
	sta source+1
	lda #<$A758
	sta screen
	lda #>$A758
	sta screen+1
	ldx #64
.(
loop2	ldy #39
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #40
	jsr AddScreen
	lda #40
	jsr AddSource
	dex
	bne loop2
.)
	rts

AddScreen
	clc
	adc screen
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts
AddSource
	clc
	adc source
	sta source
	lda source+1
	adc #00
	sta source+1
	rts

ScreenBuffer
 .dsb 40*64,4
WaveBuffer
 .dsb 40*25,4
WaveBufferYLOCL
 .byt <WaveBuffer
 .byt <WaveBuffer+40*1
 .byt <WaveBuffer+40*2
 .byt <WaveBuffer+40*3
 .byt <WaveBuffer+40*4
 .byt <WaveBuffer+40*5
 .byt <WaveBuffer+40*6
 .byt <WaveBuffer+40*7
 .byt <WaveBuffer+40*8
 .byt <WaveBuffer+40*9
 .byt <WaveBuffer+40*10
 .byt <WaveBuffer+40*11
 .byt <WaveBuffer+40*12
 .byt <WaveBuffer+40*13
 .byt <WaveBuffer+40*14
 .byt <WaveBuffer+40*15
 .byt <WaveBuffer+40*16
 .byt <WaveBuffer+40*17
 .byt <WaveBuffer+40*18
 .byt <WaveBuffer+40*19
 .byt <WaveBuffer+40*20
 .byt <WaveBuffer+40*21
 .byt <WaveBuffer+40*22
 .byt <WaveBuffer+40*23
 .byt <WaveBuffer+40*24
WaveBufferYLOCH
 .byt >WaveBuffer
 .byt >WaveBuffer+40*1
 .byt >WaveBuffer+40*2
 .byt >WaveBuffer+40*3
 .byt >WaveBuffer+40*4
 .byt >WaveBuffer+40*5
 .byt >WaveBuffer+40*6
 .byt >WaveBuffer+40*7
 .byt >WaveBuffer+40*8
 .byt >WaveBuffer+40*9
 .byt >WaveBuffer+40*10
 .byt >WaveBuffer+40*11
 .byt >WaveBuffer+40*12
 .byt >WaveBuffer+40*13
 .byt >WaveBuffer+40*14
 .byt >WaveBuffer+40*15
 .byt >WaveBuffer+40*16
 .byt >WaveBuffer+40*17
 .byt >WaveBuffer+40*18
 .byt >WaveBuffer+40*19
 .byt >WaveBuffer+40*20
 .byt >WaveBuffer+40*21
 .byt >WaveBuffer+40*22
 .byt >WaveBuffer+40*23
 .byt >WaveBuffer+40*24

SineTable	;Expand to 256
 .byt 1,1,1,2,2,3,4,5,6,7,8,9,9,10,10,10,11,11,11,11
 .byt 10,10,10,9,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0

 .byt 1,1,1,1,2,2,2,3,3,4,4,5,6,7,8,9,9,9,9,8,8,7,7,6,6,5,5,4,3,3,2,2,1,1,1,0,0,0,0,0
 .byt 1,1,2,3,4,5,6,7,8,9,9,8,8,8,7,7,6,5,4,3,2,1,1,2,2,3,3,4,4,4,4
 .byt 3,3,3,2,2,2,1,1,1
 .byt 1,1,1,2,2,3,4,5,6,7,8,9,9,10,10,10,11,11,11,11
 .byt 10,10,10,9,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0

 
 .byt 1,2,3,4,5,6,7,8,9,10,10,11,11,11,12,12,12,12,12,13,13,13,13,14,14,14,14,14,14
 .byt 13,13,13,13,12,12,12,12,12,11,11,11,10,10,9,8,7,6,5,4,3,2
 
 .byt 1,2,3,4,4,5,5,5,6,6,6,6,5,5,5,4,4,3,2,1,1,1,1,0,0,0,0,0,0
; .byt 10,10,10,9,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0
; .byt 1,1,1,2,2,3,4,5,6,7,8,9,9,10,10,10,11,11,11,11
; .byt 10,10,10,9,9,8,7,6,5,4,3,2,2,1,1,1,0,0,0,0
 .byt 1,1,1,2,2,3,4,4,4,4,3,3,3,2,2,2
WaveIntersectionIndex1
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 .byt 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40
WaveIntersectionIndex2
 .byt 1+128,2+128,3+128,4+128,5+128,6+128,7+128,8+128,9+128,10+128,11+128,12+128,13+128,14+128,15+128
 .byt 16+128,17+128,18+128,19+128,20+128,21+128,22+128,23+128,24+128,25+128,26+128,27+128,28+128
 .byt 29+128,30+128,31+128,32+128,33+128,34+128,35+128,36+128,37+128,38+128,39+128,40+128
WaveFracCount1
 .byt 00,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
 .byt $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
 .byt $A6,$A6,$A6,$A6,$A6,$A6,$A6,$A6
WaveFracCount2
 .byt $A6,$D5,$13,$51,$8F,$CD,$0B,$49,$87,$C5,$03,$41,$7F,$BD,$FB,$39
 .byt $77,$B5,$F3,$31,$6F,$AD,$EB,$29,$67,$A5,$E3,$21,$5F,$9D,$DB,$19
 .byt $57,$95,$D3,$11,$4F,$8D,$CB,$61

SYLocl
 .byt <$a758
 .byt <$a758+80*1
 .byt <$a758+80*2
 .byt <$a758+80*3
 .byt <$a758+80*4
 .byt <$a758+80*5
 .byt <$a758+80*6
 .byt <$a758+80*7
 .byt <$a758+80*8
 .byt <$a758+80*9
 .byt <$a758+80*10
 .byt <$a758+80*11
 .byt <$a758+80*12
 .byt <$a758+80*13
 .byt <$a758+80*14
 .byt <$a758+80*15
 .byt <$a758+80*16
 .byt <$a758+80*17
 .byt <$a758+80*18
 .byt <$a758+80*19
 .byt <$a758+80*20
 .byt <$a758+80*21
 .byt <$a758+80*22
 .byt <$a758+80*23
 .byt <$a758+80*24
 .byt <$a758+80*25
 .byt <$a758+80*26
 .byt <$a758+80*27
 .byt <$a758+80*28
 .byt <$a758+80*29
 .byt <$a758+80*30
 .byt <$a758+80*31
 .byt <$a758+80*32
 .byt <$a758+80*33
 .byt <$a758+80*34
 .byt <$a758+80*35
 .byt <$a758+80*36
 .byt <$a758+80*37
 .byt <$a758+80*38
 .byt <$a758+80*39
 .byt <$a758+80*40
 .byt <$a758+80*41
 .byt <$a758+80*42
 .byt <$a758+80*43
 .byt <$a758+80*44
 .byt <$a758+80*45
 .byt <$a758+80*46
 .byt <$a758+80*47
 .byt <$a758+80*48
 .byt <$a758+80*49
 .byt <$a758+80*50
 .byt <$a758+80*51
 .byt <$a758+80*52
 .byt <$a758+80*53
 .byt <$a758+80*54
 .byt <$a758+80*55
 .byt <$a758+80*56
 .byt <$a758+80*57
 .byt <$a758+80*58
 .byt <$a758+80*59
SYLoch
 .byt >$a758
 .byt >$a758+80*1
 .byt >$a758+80*2
 .byt >$a758+80*3
 .byt >$a758+80*4
 .byt >$a758+80*5
 .byt >$a758+80*6
 .byt >$a758+80*7
 .byt >$a758+80*8
 .byt >$a758+80*9
 .byt >$a758+80*10
 .byt >$a758+80*11
 .byt >$a758+80*12
 .byt >$a758+80*13
 .byt >$a758+80*14
 .byt >$a758+80*15
 .byt >$a758+80*16
 .byt >$a758+80*17
 .byt >$a758+80*18
 .byt >$a758+80*19
 .byt >$a758+80*20
 .byt >$a758+80*21
 .byt >$a758+80*22
 .byt >$a758+80*23
 .byt >$a758+80*24
 .byt >$a758+80*25
 .byt >$a758+80*26
 .byt >$a758+80*27
 .byt >$a758+80*28
 .byt >$a758+80*29
 .byt >$a758+80*30
 .byt >$a758+80*31
 .byt >$a758+80*32
 .byt >$a758+80*33
 .byt >$a758+80*34
 .byt >$a758+80*35
 .byt >$a758+80*36
 .byt >$a758+80*37
 .byt >$a758+80*38
 .byt >$a758+80*39
 .byt >$a758+80*40
 .byt >$a758+80*41
 .byt >$a758+80*42
 .byt >$a758+80*43
 .byt >$a758+80*44
 .byt >$a758+80*45
 .byt >$a758+80*46
 .byt >$a758+80*47
 .byt >$a758+80*48
 .byt >$a758+80*49
 .byt >$a758+80*50
 .byt >$a758+80*51
 .byt >$a758+80*52
 .byt >$a758+80*53
 .byt >$a758+80*54
 .byt >$a758+80*55
 .byt >$a758+80*56
 .byt >$a758+80*57
 .byt >$a758+80*58
 .byt >$a758+80*59
