;SSCM-OM2S1.S Butterflies - MOAT2.MEM on WURLDE.DSK
;Synopsis
;1) Butterflies buzzing around
;2) Using the butterfly net whilst standing still hero can capture them.


#include "..\gamecode\WurldeDefines.s"

#include "..\gamecode\SSCModuleHeader.s"
 .zero
*=$00
#include "..\gamecode\ZeroPage.s"

 .text
*=$C000

;**************************
ScreenSpecificCodeBlock
        jmp ScreenInit		;C000	;Run immediately after SSC(This file) is loaded
        jmp ScreenRun		;C003	;Run during a game cycle
        jmp CollisionDetection	;C006	;Run during game cycle and parsed Collision Type in A
        jmp ProcAction		;C009	;Called when Recognised Key Pressed
        jmp Spare			;C00C
        jmp Spare			;C00F
        jmp Spare			;C012
        jmp Spare			;C015
ScreenProseVector
 .byt <ScreenProse,>ScreenProse	;C018
ScreenNameVector
 .byt <ScreenName,>ScreenName		;C01A
ScreenRules
 .byt %10001100			;C01C
LocationID
 .byt 7				;C01D
RecognisedAction
 .byt %00000000			;C01E
CollisionType
 .byt 0				;C01F
CollisionTablesVector
 .byt <ct_CeilingLevel,>ct_CeilingLevel	;C020
ScreenInlayVector
 .byt <ScreenInlay,>ScreenInlay	;C022
EnteringTextVector		;Nothing here
 .byt 0,0				;C024
InteractionHeaderVector	;This SSC has no meeting place so 0 must be written to high address
 .byt 0,0				;C026
CharacterList			;
 .byt 0,0				;C028
CharacterInfo
 .byt 0,0				;C02A
;**************************
;Collision tables(120) always exist in first page of C000
ct_CeilingLevel
 .dsb 40,128
ct_FloorLevel
 .dsb 40,128
ct_BGCollisions
 .dsb 40,0

ScreenInlay
#include "inlay-om2s1.s"	;Butterflies - moat2.mem in wurlde.dsk

#include "SSC_CommonCode.s"
ScreenProse	;Up to 37x7 characters
;      ***********************************
 .byt "Butterflies are quite rare here in%"
 .byt "Ritemoor. However when the season%"
 .byt "is just turning and the weather is%"
 .byt "to their favour, they will take the%"
 .byt "moment in full glory and feed from%"
 .byt "natures cup spawning their future%"
 .byt "offspring.]"
ScreenName	;Always 13 characters long
;      *************
 .byt "BUTTERFLIES]"


ScreenInit
	jsr InitialiseHero
Spare	rts

;Parsed
;SideApproachFlag	Hero Appears on Left(0) or Right(1)
InitialiseHero
	;For this screen there is no exit right but the game may have just started.
	lda SideApproachFlag
.(
	bne InitHero4Right
	;Set initial hero sprite frame
	lda #98
	sta HeroSprite
	;Set Hero X to left
	ldx #3
	stx HeroX
	;Set hero y to land contour
	lda ct_FloorLevel,x
	and #63
	sec
	sbc #9
	sta HeroY
	;Set other stuff
	lda #3
	sta SpriteWidth
	lda #9
	sta SpriteHeight
	;Set initial action to stand right
	lda #hcStandRight
	sta HeroAction
	rts

InitHero4Right
.)
	lda #105
	sta HeroSprite
	;Game start (For Map02) parameters
	ldx #34
	stx HeroX
	;Set hero y to land contour
	lda ct_FloorLevel,x
	and #63
	sec
	sbc #09
	sta HeroY
	;Set a few defaults
	lda #3
	sta SpriteWidth
	lda #9
	sta SpriteHeight
	;Set initial Action
	lda #hcStandLeft
	sta HeroAction
	rts

ScreenRun
        	;Twinkle stars
.(
        	ldx #05
loop1   	lda StarLocationsLo,x
        	sta screen
        	lda StarLocationsHi,x
        	sta screen+1
        	txa
        	tay
        	lda rndRandom
loop2   	lsr
        	dey
        	bpl loop2
        	and #3
        	tay
        	lda TwinkleColour,y
        	ldy #00
        	sta (screen),y
        	dex
        	bpl loop1

        	;flying insects(biting?)
.)
	jsr BeeDriver
	rts

;	lda ButterFlyNetUpFlag
;	beq skip1
;	;Might prefer to animate net swiping down!
;
;	;Sense butterfly in net here - if found then add to inventory and drop net
;
;	dec ButterflyNetUpPeriod
;.(
;	bpl skip1
;	jsr DeleteButterflyNet
;skip1    	rts
;.)

;Called from DetectFloorAndCollisions in hero.s when the floortable(A) contains
;0,64,128,192 depending on collision(9,10,11,12)
;For M2S5 it is unused
;
;Returned
;Carry Set when move prohibited
CollisionDetection
	sta CollisionFound
	rts

CollisionFound
 .byt 0


;When the hero performs a recognised action this routine is called
;ProcAction
;
; If the hero presses action key then plot butterfly net here and set flag
; to 1) delete after short time in screenrun and 2) sense caught butterfly
;
ProcAction
	clc
	rts

;	;If butterfly flag already set then delete previous net
;	lda ButterflyNetUpFlag
;.(
;	beq skip1
;	jsr DeleteButterflyNet
;skip1	jsr PlotButterflyNet
;.)
;	lda #1
;	sta ButterflyNetUpFlag
;	lda #20
;	sta ButterflyNetUpPeriod
;	rts
;
;
;DeleteButterflyNet
;PlotButterflyNet


#include "Bees.s"


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
StarLocationsLo
 .byt <$29+$a758
 .byt <$7E+$a758
 .byt <$38+$a758
 .byt <$3B+$a758
 .byt <$12A+$a758
 .byt <$47+$a758
StarLocationsHi
 .byt >$29+$a758
 .byt >$7E+$a758
 .byt >$38+$a758
 .byt >$3B+$a758
 .byt >$12A+$a758
 .byt >$47+$a758
TwinkleColour
 .byt 6,3,2,7
