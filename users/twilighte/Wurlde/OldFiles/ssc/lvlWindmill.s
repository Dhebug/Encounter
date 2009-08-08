;lvlWindmill.s
LevelSettings	.byt %00000000

LevelExit
LevelUnpack
	rts

;Monitor Y for clipping patch
;For Vane each minus represents an increment in YPOS
VaneAngle	;0-35
 .byt 0,9,18,27
VaneFrameLo
 .byt <vane00
 .byt <vane10
 .byt <vane20
 .byt <vane30
 .byt <vane40
 .byt <vane50
 .byt <vane60
 .byt <vane70
 .byt <vane80
 .byt <vane90

 .byt <vane100
 .byt <vane110
 .byt <vane120
 .byt <vane130
 .byt <vane140
 .byt <vane150
 .byt <vane160
 .byt <vane170

 .byt <vane00
 .byt <vane10
 .byt <vane20
 .byt <vane30
 .byt <vane40
 .byt <vane50
 .byt <vane60
 .byt <vane70
 .byt <vane80
 .byt <vane90

 .byt <vane100
 .byt <vane110
 .byt <vane120
 .byt <vane130
 .byt <vane140
 .byt <vane150
 .byt <vane160
 .byt <vane170
VaneFrameHi
 .byt >vane00
 .byt >vane10
 .byt >vane20
 .byt >vane30
 .byt >vane40
 .byt >vane50
 .byt >vane60
 .byt >vane70
 .byt >vane80
 .byt >vane90

 .byt >vane100
 .byt >vane110
 .byt >vane120
 .byt >vane130
 .byt >vane140
 .byt >vane150
 .byt >vane160
 .byt >vane170

 .byt >vane00
 .byt >vane10
 .byt >vane20
 .byt >vane30
 .byt >vane40
 .byt >vane50
 .byt >vane60
 .byt >vane70
 .byt >vane80
 .byt >vane90

 .byt >vane100
 .byt >vane110
 .byt >vane120
 .byt >vane130
 .byt >vane140
 .byt >vane150
 .byt >vane160
 .byt >vane170

VaneScreenLocationLo
 .byt <$A028+18+40*67	;00
 .byt <$A028+18+40*67	;10
 .byt <$A028+18+40*67	;20
 .byt <$A028+18+40*67	;30
 .byt <$A028+17+40*67	;40
 .byt <$A028+17+40*67	;50
 .byt <$A028+17+40*65	;60
 .byt <$A028+17+40*65	;70
 .byt <$A028+17+40*61	;80

 .byt <$A028+4+40*59	;90
 .byt <$A028+5+40*43	;100
 .byt <$A028+5+40*27	;110
 .byt <$A028+7+40*15	;120
 .byt <$A028+7+40*3	;130
 .byt <$9C40+9+40*20	;140
 .byt <$9C40+12+40*12	;150
 .byt <$9C40+14+40*4	;160
 .byt <$9C40+17+40*2	;170

 .byt <$9C40+18		;180(00)
 .byt <$9C40+21+40*2	;190(10)
 .byt <$9C40+24+40*4	;200(20)
 .byt <$9C40+26+40*12	;210(30)
 .byt <$9C40+27+40*20	;220(40)
 .byt <$A028+29+40*3	;230(50)
 .byt <$A028+31+40*15	;240(60)
 .byt <$A028+32+40*27	;250(70)
 .byt <$A028+33+40*43	;260(80)

 .byt <$A028+20+40*59	;270
 .byt <$A028+21+40*61	;280
 .byt <$A028+20+40*65	;290
 .byt <$A028+21+40*65   ;300
 .byt <$A028+19+40*67   ;310
 .byt <$A028+19+40*67   ;320
 .byt <$A028+19+40*67   ;330
 .byt <$A028+19+40*67   ;340
 .byt <$A028+19+40*65   ;350

VaneScreenLocationHi
 .byt >$A028+18+40*67	;00
 .byt >$A028+18+40*67	;10
 .byt >$A028+18+40*67	;20
 .byt >$A028+18+40*67	;30
 .byt >$A028+17+40*67	;40
 .byt >$A028+17+40*67	;50
 .byt >$A028+17+40*65	;60
 .byt >$A028+17+40*65	;70
 .byt >$A028+17+40*61	;80

 .byt >$A028+4+40*59	;90
 .byt >$A028+5+40*43	;100
 .byt >$A028+5+40*27	;110
 .byt >$A028+7+40*15	;120
 .byt >$A028+7+40*3	;130
 .byt >$9C40+9+40*20	;140
 .byt >$9C40+12+40*12	;150
 .byt >$9C40+14+40*4	;160
 .byt >$9C40+17+40*2	;170

 .byt >$9C40+18		;180(00)
 .byt >$9C40+21+40*2	;190(10)
 .byt >$9C40+24+40*4	;200(20)
 .byt >$9C40+26+40*12	;210(30)
 .byt >$9C40+27+40*20	;220(40)
 .byt >$A028+29+40*3	;230(50)
 .byt >$A028+31+40*15	;240(60)
 .byt >$A028+32+40*27	;250(70)
 .byt >$A028+33+40*43	;260(80)

 .byt >$A028+20+40*59	;270
 .byt >$A028+21+40*61	;280
 .byt >$A028+20+40*65	;290
 .byt >$A028+21+40*65   ;300
 .byt >$A028+19+40*67   ;310
 .byt >$A028+19+40*67   ;320
 .byt >$A028+19+40*67   ;330
 .byt >$A028+19+40*67   ;340
 .byt >$A028+19+40*65   ;350

VaneYPOSStart
 .byt 67-46	;00
 .byt 67-46	;10
 .byt 67-46	;20
 .byt 67-46	;30
 .byt 67-46	;40
 .byt 67-46	;50
 .byt 65-46	;60
 .byt 65-46	;70
 .byt 61-46	;80

 .byt 59-46	;90
 .byt 253	;100(43-46)
 .byt 237	;110(27-46)
 .byt 225	;120(15-46)
 .byt 213	;130(3-46)
 .byt 250-46	;140
 .byt 242-46	;150
 .byt 234-46	;160
 .byt 232-46	;170

 .byt 230-46	;180
 .byt 232-46	;190
 .byt 234-46	;200
 .byt 242-46	;210
 .byt 250-46	;220
 .byt 213	;230(3-46)
 .byt 225	;240(15-46)
 .byt 237	;250(27-46)
 .byt 253	;260(43-46)

 .byt 59-46	;270
 .byt 61-46	;280
 .byt 65-46	;290
 .byt 65-46	;300
 .byt 67-46	;310
 .byt 67-46	;320
 .byt 67-46	;330
 .byt 67-46	;340
 .byt 65-46	;350
VaneDelay	.byt 0
LevelRun
VaneManage
	lda VaneDelay
	clc
	adc #64
	sta VaneDelay
.(
	bcs skip1
	rts
skip1
	ldx #03
.)
.(
loop1	ldy VaneAngle,x
	;Delete old Vane
	dey
	bpl skip1
	ldy #35
skip1	lda VaneFrameLo,y
	sta source
	lda VaneFrameHi,y
	sta source+1
	lda VaneScreenLocationLo,y
	sta screen
	lda VaneScreenLocationHi,y
	sta screen+1
	lda VaneYPOSStart,y
	sta VaneScanLineYPOS
	jsr DeleteVane

	ldy VaneAngle,x
	;Plot Vane
	lda VaneFrameLo,y
	sta source
	lda VaneFrameHi,y
	sta source+1
	lda VaneScreenLocationLo,y
	sta screen
	lda VaneScreenLocationHi,y
	sta screen+1
	lda VaneYPOSStart,y
	sta VaneScanLineYPOS
	jsr PlotVane

	ldy VaneAngle,x
	iny
	cpy #36
	bcc skip2
	ldy #00
skip2	tya
	sta VaneAngle,x
	dex
	bpl loop1
.)
	rts

PlotVane
	stx VaneTempX
	ldy #00
.(
loop1   lda (source),y
        bmi skip1
	;Clip using YPOS
	ldx VaneScanLineYPOS	;0-118 is valid
	bmi skip3
	sta (screen),y
skip3   iny
        jmp loop1
skip1   and #127
        beq skip2

	clc
        adc screen
        sta screen
        lda screen+1
        adc #00
        sta screen+1

	iny
	tya
        adc source
        sta source
        lda #00
        tay
        adc source+1
        sta source+1

        inc VaneScanLineYPOS
        inc VaneScanLineYPOS
        jmp loop1
skip2   ldx VaneTempX
	rts
.)

DeleteVane
	ldy #00
.(
loop1   lda (source),y
        bmi skip1
	;Clip using YPOS
	lda VaneScanLineYPOS	;0-118 is valid
	bmi skip3
	lda #64
        sta (screen),y
skip3   iny
        jmp loop1
skip1   and #127
        beq skip2
        clc
        adc screen
        sta screen
        lda screen+1
        adc #00
        sta screen+1
	iny
	tya
        adc source
        sta source
        lda #00
        tay
        adc source+1
        sta source+1
        inc VaneScanLineYPOS
        inc VaneScanLineYPOS
        jmp loop1
skip2   rts
.)

DetermineContourMap
	ldx HeroY
DetermineContourMap2
	lda #<LevelFloorTable
	sta ContourFloor
	lda #>LevelFloorTable
	sta ContourFloor+1
	lda #<LevelCeilingTable
	sta ContourCeiling
	lda #>LevelCeilingTable
	sta ContourCeiling+1
	rts
LevelProse
 .byt "Up, up and away..                  "
 .byt "Swing, swing high                  "
 .byt "sweet chariot                      "
 .byt "If you catch this ryhme then       "
 .byt "catch that rythm.                  "
 .byt "                                   "
 .byt "                                   "

LevelCeilingTable
 .dsb 40,0
LevelFloorTable
 .dsb 40,57


VaneScanLineYPOS	.byt 0
VaneTempX		.byt 0
LevelScreen
#include "Windmill.s"
#include "VaneBitmaps.s"
