;GameTitle.s(Also incorperates Game Intro)

;This program does the following
;1) Play Intro (Not yet)
;2) Present Title
;3) Performs HIRES and displays game screen
;4) Calls to load Game


#define via_portb       $0300
#define via_t1cl        $0304
#define via_pcr         $030C
#define via_porta       $030F

#define ayr_KeyCol	$0E

#define ayc_Register	$FF
#define	ayc_Inactive	$DD
#define	ayc_Data	$FD

#define chr_Hires	28

#define	dsk_LoadFile	$FE00

 .zero
*=$00
source		.dsb 2
screen		.dsb 2
text		.dsb 2
;
MessSeq		.dsb 2
CurrentMessageIndex		.dsb 1
CurrentMessageEffectIndex       .dsb 1
CurrentMessageColour		.dsb 1
CurrentMessageGraphicLength	.dsb 1
CurrentDitherBitmap		.dsb 1
MessageTextIndex		.dsb 1
;
temp01		.dsb 1
temp02		.dsb 1
;
rndRandom	.dsb 1
rndTemp		.dsb 1
;
NewStarX	.dsb 1
NewStarY	.dsb 1

 .text
*=$400

;Assume no ROM
Driver
	;Disable irq's for duration of title
	sei

	;Clear key buffer
.(
loop1	jsr SenseKey	;Just senses any key
	bcs loop1
.)
	jsr DrawHIRES
	jsr InitCredits
	jsr InitStarfield
	;
.(
loop1
;	jsr AnimateHero
	jsr ProcStarfield
;	jsr ProcessCredits
	jsr SenseKey
	bcc loop1
.)
	jsr DrawGameScreen
	;Relocate game boot call to Page 2 so we can load $400-$9FFF
	ldx #EndOfPage2Code-Page2Code
.(
loop1	lda Page2Code,x
	sta $200,x
	dex
	bpl loop1
.)
	;And jump to it
	jmp $200

Page2Code
	;Load Game memory 400-9FFF
	lda #$04
	ldx #1
	jsr dsk_LoadFile
	;Load Player File
	lda #$9C
	ldx #2
	jsr dsk_LoadFile
;jonny	sec
;	bcs jonny
	;Load First SSC module
	lda #$C0
	ldx #3
	jsr dsk_LoadFile
	;Jump to Game Init at 400
	jmp $400
EndOfPage2Code

AnimateHero
	lda HeroRotationDelay
	clc
	adc #16
	sta HeroRotationDelay
.(
	bcc skip2
	lda HeroRotationFrame
	clc
	adc #01
	cmp #16
	bcc skip1
	lda #00
skip1	sta HeroRotationFrame
	jsr PlotRotatingHero
skip2	rts
.)

HeroRotationFrame	.byt 0
HeroRotationDelay	.byt 0

nl_screen
	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts
add_screen
	clc
	adc screen
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts
nl_source
	lda source
	clc
	adc #40
	sta source
	lda source+1
	adc #00
	sta source+1
	rts
add_source
	clc
	adc source
	sta source
	lda source+1
	adc #00
	sta source+1
	rts


SenseKey
	;Set Column to 0(All keys on row)
	lda #ayr_KeyCol
	sta via_porta
	lda #ayc_Register
	sta via_pcr
	ldx #ayc_Inactive
	stx via_pcr
	lda #00
	sta via_porta
	lda #ayc_Data
	sta via_pcr
	stx via_pcr
	;Scan all 8 rows for key
	ldx #07
.(
loop1	stx via_portb
	nop
	nop
	nop
	nop
	nop
	nop
	lda via_portb
	and #8
	bne skip1
	dex
	bpl loop1
skip1	cmp #01
.)
	rts

DrawHIRES
	;Set HIRES
	lda #chr_Hires
	sta $BFDF
	;Clear HIRES Part
	lda #<$a000
	sta screen
	lda #>$a000
	sta screen+1
	ldx #200
.(
loop2	ldy #39
	lda #64
loop1	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
.)
	;Clear last 3 text lines
	ldx #119
	lda #8
.(
loop1	sta $BF68,x
	dex
	bpl loop1
.)
	rts

DrawGameScreen
	;Draw HIRES part
	lda #<$a000
	sta screen
	lda #>$a000
	sta screen+1
	lda #<HIRESScreen
	sta source
	lda #>HIRESScreen
	sta source+1

	ldx #200
.(
loop2	ldy #39
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	jsr nl_source
	dex
	bne loop2
.)
	;Setup HIRES Hardware Border Charset
	ldx #$C0
.(
loop1	lda TextBorderCharset-1,x
	sta $9900-1,x
	dex
	bne loop1
.)
	;Clear HIRES Hardware Virtual HIRES Charset
	ldx #00
	txa
.(
loop1	sta $99D0,x
	sta $9A00,x
	sta $9B00,x
	dex
	bne loop1
.)
	;Draw Bottom 3 text lines as virtual HIRES
	ldx #119
.(
loop1	lda TextRows,x
	sta $bf68,x
	dex
	bpl loop1
.)
	rts

HIRESScreen
#include "InfoPan.s"
 .dsb 4800,64
#include "BotDevil.s"
TextRows
#include "TextLines.s"
TextBorderCharset
#include "TextBorderCharacterSet.s"

#include "HeroRotationFrames.s"
;#include "Starfield3D.s"
;#include "HIRESCharset.s"
;#include "Music.s"
;#include "IRQ.s"

PlotRotatingHero
	ldx HeroRotationFrame
	lda HeroRotationFrameAddressLo,x
	sta source
	lda HeroRotationFrameAddressHi,x
	sta source+1
	lda #<$A000+18+40*86
	sta screen
	lda #>$A000+18+40*86
	sta screen+1
	ldx #27
.(
loop2	ldy #05
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	lda #6
	jsr add_source
	dex
	bne loop2
.)
	rts

HeroRotationFrameAddressLo
 .byt <HeroRotationFrame00
 .byt <HeroRotationFrame01
 .byt <HeroRotationFrame02
 .byt <HeroRotationFrame03
 .byt <HeroRotationFrame04
 .byt <HeroRotationFrame05
 .byt <HeroRotationFrame06
 .byt <HeroRotationFrame07
 .byt <HeroRotationFrame08
 .byt <HeroRotationFrame09
 .byt <HeroRotationFrame10
 .byt <HeroRotationFrame11
 .byt <HeroRotationFrame12
 .byt <HeroRotationFrame13
 .byt <HeroRotationFrame14
 .byt <HeroRotationFrame15
HeroRotationFrameAddressHi
 .byt >HeroRotationFrame00
 .byt >HeroRotationFrame01
 .byt >HeroRotationFrame02
 .byt >HeroRotationFrame03
 .byt >HeroRotationFrame04
 .byt >HeroRotationFrame05
 .byt >HeroRotationFrame06
 .byt >HeroRotationFrame07
 .byt >HeroRotationFrame08
 .byt >HeroRotationFrame09
 .byt >HeroRotationFrame10
 .byt >HeroRotationFrame11
 .byt >HeroRotationFrame12
 .byt >HeroRotationFrame13
 .byt >HeroRotationFrame14
 .byt >HeroRotationFrame15

getrand
         lda rndRandom+1
         sta rndTemp
         lda rndRandom
         asl
         rol rndTemp
         asl
         rol rndTemp

         clc
         adc rndRandom
         pha
         lda rndTemp
         adc rndRandom+1
         sta rndRandom+1
         pla
         adc #$11
         sta rndRandom
         lda rndRandom+1
         adc #$36
         sta rndRandom+1
         rts

;A == Maximum (eg. 0-39)
GetRNDRange
        sta rndTemp+1
        jsr getrand
        cmp rndTemp+1
.(
        bcc skip1
        and rndTemp+1
skip1   rts
.)

;3DStarfield.s
;Resolution 0-233
;Alt res 0-116
;Offset res 0-58

XFracCount
 .dsb 64,0
XFracValue
 .dsb 64,255
StarXOffset
 .dsb 64,58	;Make all stars initially off screen
YFracCount
 .dsb 64,0
YFracValue
 .dsb 64,255
StarYOffset
 .dsb 64,0
StarXPolar
 .dsb 64,$7D
StarYPolar
 .dsb 64,$FD
OldStarX
 .dsb 64,0
OldStarY
 .dsb 64,0
RandomPolarX
 .byt $7D,$FD,$FD,$7D
RandomPolarY
 .byt $7D,$7D,$FD,$FD
SFXCyclicValue1	.byt 0
SFYCyclicValue1	.byt 127
VelocityFrac	.byt 0

InitStarfield
	ldx #63
	;Randomise StarX/Y
.(
loop1	jsr getrand
	and #31
	sta StarXOffset,x
	jsr getrand
	and #31
	sta StarYOffset,x
	jsr GenerateNewStar2
	dex
	bpl loop1
.)
	rts

GenerateNewStar
	lda #00
	sta XFracCount,x
	sta YFracCount,x
	sta StarXOffset,x
	sta StarYOffset,x
GenerateNewStar2
	;Counters used in generating new star
	dec SFXCyclicValue1
	inc SFYCyclicValue1

	lda SFXCyclicValue1
	lsr
	lsr
	sta XFracValue,x

	lda SFYCyclicValue1
	lsr
	lsr
	sta YFracValue,x

	lda SFXCyclicValue1
	and #3
	tay
	lda RandomPolarX,y
	sta StarXPolar,x

	lda SFYCyclicValue1
	and #3
	tay
	lda RandomPolarY,y
	sta StarYPolar,x
	rts


ProcStarfield
	ldx #63

SFLoop	;Adjust X Offset
	lda XFracCount,x
	sec
	adc XFracValue,x
	sta XFracCount,x
	lda StarXOffset,x
	adc #00
	sta StarXOffset,x	;0-58
	cmp #57
	bcs sskip1

	;Adjust Y offset
	lda YFracCount,x
	sec
	adc YFracValue,x
	sta YFracCount,x
	lda StarYOffset,x
	adc #00
	sta StarYOffset,x	;0-49
	cmp #49
	bcs SFRent
sskip1	jsr GenerateNewStar

	;Set X Trajectory by self modifying SBC/ADC mnemonic
SFRent	lda #61
	ldy StarXPolar,x	;Contains mnemonic for "ADC abs,x"(7D) or "SBC abs,x"(FD)
	sty SFVect1
	sec
SFVect1	sbc StarXOffset,x
	sta NewStarX

	;Set Y Trajectory by self modifying SBC/ADC mnemonic
	lda #50
	ldy StarYPolar,x
	sty SFVect2
	sec
SFVect2	sbc StarYOffset,x
	sta NewStarY

	;Slow Down Fractional Increase
	lda VelocityFrac
	adc SFXCyclicValue1
	sta VelocityFrac
	bcc sskip4
	;Increase velocity
	inc XFracValue,x
	inc YFracValue,x
sskip4
	stx temp01

	;Delete Star
	ldy OldStarY,x
	lda OldStarX,x
	tax
	lda EvenYLOCL,y
	sta screen
	lda EvenYLOCH,y
	sta screen+1
	ldy XLOC,x
	lda (screen),y
	and MASK,x
	sta (screen),y

	;Plot Star
	ldy NewStarY
	ldx NewStarX
	lda EvenYLOCL,y
	sta screen
	lda EvenYLOCH,y
	sta screen+1
	ldy XLOC,x
	lda (screen),y
	ora BITPOS,x
	sta (screen),y

	ldx temp01

	;Transfer New to Old
	lda NewStarX
	sta OldStarX,x
	lda NewStarY
	sta OldStarY,x

	;Update index
	dex
.(
	bmi skip1
	jmp SFLoop
skip1	rts
.)

;As Y is limited to even rows only, we are also gonna limit X to the same restriction
;This also means X now ranges 0-119 which is then easier to detect bounds.
;Generate3DStarfield
;	ldy #63
;.(
;loop1	jsr DeleteStar
;	jsr MoveStar
;	jsr PlotStar
;	dey
;	bpl loop1
;.)
;	rts
;
;MoveStar
;	;Control X Velocity
;	lda StarFracXReference,y
;	adc StarFracX,y
;	sta StarFracXReference,y
;.(
;	bcc skip1
;
;	;Increase X Velocity
;	lda StarFracX,y
;	cmp #255
;	bcs skip2
;	adc #01
;	sta StarFracX,y
;
;skip2	;Progress X trajectory
;	lda StarX,y
;	clc
;	adc XStep,y
;	sta StarX,y
;	cmp #120
;	bcs GenerateNewStar
;skip1
;.)
;
;	;Control Y Velocity
;	lda StarFracYReference,y
;	adc StarFracY,y
;	sta StarFracYReference,y
;.(
;	bcc skip1
;
;	;Increase Y Velocity
;	lda StarFracY,y
;	cmp #255
;	bcs skip2
;	adc #01
;	sta StarFracY,y
;
;skip2	;Progress Y trajectory
;	lda StarY,y
;	clc
;	adc YStep,y
;	sta StarY,y
;	cmp #120
;	bcs GenerateNewStar
;skip1
;.)
;	rts
;
;GenerateNewStar
;	;Reset star position to centre screen
;	lda #60
;	sta StarX,y
;	lda #50
;	sta StarY,y
;	;Set X and Y Step to random
;	jsr getrand
;	pha
;	and #7
;	clc
;	adc #252	;252-255 0-3
;.(
;	bne skip1
;	adc #01
;skip1	sta XStep,y
;.)
;	pla
;	lsr
;	lsr
;	lsr
;	and #7
;	adc #252	;252-255 0-3
;.(
;	bne skip1
;	adc #01
;skip1	sta YStep,y
;.)
;
;	lda #00
;	sta StarFracXReference,y
;	sta StarFracYReference,y
;	jsr getrand
;	sta StarFracX,y
;	jsr getrand
;	sta StarFracY,y
;	rts
;
;
;
;
;DeleteStar
;	ldx StarY,y
;	lda EvenYLOCL,x
;	sta screen
;	lda EvenYLOCH,x
;	sta screen+1
;
;	ldx StarX,y
;	sty temp01
;	ldy XLOC,x
;	lda (screen),y
;	and Mask,x
;	sta (screen),y
;	ldy temp01
;	rts
;
;
;PlotStar
;	ldx StarY,y
;	cpx #100
;.(
;	bcc skip1
;	jsr GenerateNewStar
;skip1	lda EvenYLOCL,x
;.)
;	sta screen
;	lda EvenYLOCH,x
;	sta screen+1
;	ldx StarX,y
;	sty temp01
;	ldy XLOC,x
;	lda (screen),y
;	ora BITPOS,x
;	sta (screen),y
;	ldy temp01
;	rts
;
;
;
;
;StarX	;0-119
; .dsb 64,128
;StarY	;0-99(Odd rows)
; .dsb 64,128
;XStep
; .dsb 64,1
;YStep
; .dsb 64,1
;StarFracXReference
; .dsb 64,0
;StarFracX
; .dsb 64,0
;StarFracYReference
; .dsb 64,0
;StarFracY
; .dsb 64,0

EvenYLOCL
 .byt <$A000
 .byt <$A000+80*1
 .byt <$A000+80*2
 .byt <$A000+80*3
 .byt <$A000+80*4
 .byt <$A000+80*5
 .byt <$A000+80*6
 .byt <$A000+80*7
 .byt <$A000+80*8
 .byt <$A000+80*9
 .byt <$A000+80*10
 .byt <$A000+80*11
 .byt <$A000+80*12
 .byt <$A000+80*13
 .byt <$A000+80*14
 .byt <$A000+80*15
 .byt <$A000+80*16
 .byt <$A000+80*17
 .byt <$A000+80*18
 .byt <$A000+80*19
 .byt <$A000+80*20
 .byt <$A000+80*21
 .byt <$A000+80*22
 .byt <$A000+80*23
 .byt <$A000+80*24
 .byt <$A000+80*25
 .byt <$A000+80*26
 .byt <$A000+80*27
 .byt <$A000+80*28
 .byt <$A000+80*29
 .byt <$A000+80*30
 .byt <$A000+80*31
 .byt <$A000+80*32
 .byt <$A000+80*33
 .byt <$A000+80*34
 .byt <$A000+80*35
 .byt <$A000+80*36
 .byt <$A000+80*37
 .byt <$A000+80*38
 .byt <$A000+80*39
 .byt <$A000+80*40
 .byt <$A000+80*41
 .byt <$A000+80*42
 .byt <$A000+80*43
 .byt <$A000+80*44
 .byt <$A000+80*45
 .byt <$A000+80*46
 .byt <$A000+80*47
 .byt <$A000+80*48
 .byt <$A000+80*49
 .byt <$A000+80*50
 .byt <$A000+80*51
 .byt <$A000+80*52
 .byt <$A000+80*53
 .byt <$A000+80*54
 .byt <$A000+80*55
 .byt <$A000+80*56
 .byt <$A000+80*57
 .byt <$A000+80*58
 .byt <$A000+80*59
 .byt <$A000+80*60
 .byt <$A000+80*61
 .byt <$A000+80*62
 .byt <$A000+80*63
 .byt <$A000+80*64
 .byt <$A000+80*65
 .byt <$A000+80*66
 .byt <$A000+80*67
 .byt <$A000+80*68
 .byt <$A000+80*69
 .byt <$A000+80*70
 .byt <$A000+80*71
 .byt <$A000+80*72
 .byt <$A000+80*73
 .byt <$A000+80*74
 .byt <$A000+80*75
 .byt <$A000+80*76
 .byt <$A000+80*77
 .byt <$A000+80*78
 .byt <$A000+80*79
 .byt <$A000+80*80
 .byt <$A000+80*81
 .byt <$A000+80*82
 .byt <$A000+80*83
 .byt <$A000+80*84
 .byt <$A000+80*85
 .byt <$A000+80*86
 .byt <$A000+80*87
 .byt <$A000+80*88
 .byt <$A000+80*89
 .byt <$A000+80*90
 .byt <$A000+80*91
 .byt <$A000+80*92
 .byt <$A000+80*93
 .byt <$A000+80*94
 .byt <$A000+80*95
 .byt <$A000+80*96
 .byt <$A000+80*97
 .byt <$A000+80*98
 .byt <$A000+80*99
EvenYLOCH
 .byt >$A000
 .byt >$A000+80*1
 .byt >$A000+80*2
 .byt >$A000+80*3
 .byt >$A000+80*4
 .byt >$A000+80*5
 .byt >$A000+80*6
 .byt >$A000+80*7
 .byt >$A000+80*8
 .byt >$A000+80*9
 .byt >$A000+80*10
 .byt >$A000+80*11
 .byt >$A000+80*12
 .byt >$A000+80*13
 .byt >$A000+80*14
 .byt >$A000+80*15
 .byt >$A000+80*16
 .byt >$A000+80*17
 .byt >$A000+80*18
 .byt >$A000+80*19
 .byt >$A000+80*20
 .byt >$A000+80*21
 .byt >$A000+80*22
 .byt >$A000+80*23
 .byt >$A000+80*24
 .byt >$A000+80*25
 .byt >$A000+80*26
 .byt >$A000+80*27
 .byt >$A000+80*28
 .byt >$A000+80*29
 .byt >$A000+80*30
 .byt >$A000+80*31
 .byt >$A000+80*32
 .byt >$A000+80*33
 .byt >$A000+80*34
 .byt >$A000+80*35
 .byt >$A000+80*36
 .byt >$A000+80*37
 .byt >$A000+80*38
 .byt >$A000+80*39
 .byt >$A000+80*40
 .byt >$A000+80*41
 .byt >$A000+80*42
 .byt >$A000+80*43
 .byt >$A000+80*44
 .byt >$A000+80*45
 .byt >$A000+80*46
 .byt >$A000+80*47
 .byt >$A000+80*48
 .byt >$A000+80*49
 .byt >$A000+80*50
 .byt >$A000+80*51
 .byt >$A000+80*52
 .byt >$A000+80*53
 .byt >$A000+80*54
 .byt >$A000+80*55
 .byt >$A000+80*56
 .byt >$A000+80*57
 .byt >$A000+80*58
 .byt >$A000+80*59
 .byt >$A000+80*60
 .byt >$A000+80*61
 .byt >$A000+80*62
 .byt >$A000+80*63
 .byt >$A000+80*64
 .byt >$A000+80*65
 .byt >$A000+80*66
 .byt >$A000+80*67
 .byt >$A000+80*68
 .byt >$A000+80*69
 .byt >$A000+80*70
 .byt >$A000+80*71
 .byt >$A000+80*72
 .byt >$A000+80*73
 .byt >$A000+80*74
 .byt >$A000+80*75
 .byt >$A000+80*76
 .byt >$A000+80*77
 .byt >$A000+80*78
 .byt >$A000+80*79
 .byt >$A000+80*80
 .byt >$A000+80*81
 .byt >$A000+80*82
 .byt >$A000+80*83
 .byt >$A000+80*84
 .byt >$A000+80*85
 .byt >$A000+80*86
 .byt >$A000+80*87
 .byt >$A000+80*88
 .byt >$A000+80*89
 .byt >$A000+80*90
 .byt >$A000+80*91
 .byt >$A000+80*92
 .byt >$A000+80*93
 .byt >$A000+80*94
 .byt >$A000+80*95
 .byt >$A000+80*96
 .byt >$A000+80*97
 .byt >$A000+80*98
 .byt >$A000+80*99
XLOC	;
 .dsb 3,0
 .dsb 3,1
 .dsb 3,2
 .dsb 3,3
 .dsb 3,4
 .dsb 3,5
 .dsb 3,6
 .dsb 3,7
 .dsb 3,8
 .dsb 3,9
 .dsb 3,10
 .dsb 3,11
 .dsb 3,12
 .dsb 3,13
 .dsb 3,14
 .dsb 3,15
 .dsb 3,16
 .dsb 3,17
 .dsb 3,18
 .dsb 3,19

 .dsb 3,20
 .dsb 3,21
 .dsb 3,22
 .dsb 3,23
 .dsb 3,24
 .dsb 3,25
 .dsb 3,26
 .dsb 3,27
 .dsb 3,28
 .dsb 3,29

 .dsb 3,30
 .dsb 3,31
 .dsb 3,32
 .dsb 3,33
 .dsb 3,34
 .dsb 3,35
 .dsb 3,36
 .dsb 3,37
 .dsb 3,38
 .dsb 3,39
BITPOS
 .byt 32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2
 .byt 32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2
 .byt 32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2
 .byt 32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2,32,8,2
MASK
 .byt 127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2
 .byt 127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2
 .byt 127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2
 .byt 127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2
 .byt 127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2
 .byt 127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2
 .byt 127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2
 .byt 127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2,127-32,127-8,127-2

#Define	meBlk	0
#Define	meRed	1
#Define	meGrn	2
#Define	meYel	3
#Define	meBlu	4
#Define	meMag	5
#Define	meCyn	6
#Define	meWht	7
#Define	meDt0	8
#Define	meDt1	16
#Define	meDt2	24
#Define	meScr	32
#Define	mePlt	64
#Define	meEnd	128


InitCredits
	lda #<MessageSequence
	sta MessSeq
	lda #>MessageSequence
	sta MessSeq+1
	rts

ProcessCredits
	jsr ControlMessages
	jsr ManageMessageFlow
	rts

MessageDelay	.byt 128
MessageEffectIndex
 .dsb 8,128
MessageX
 .dsb 8,0
MessageY
 .dsb 8,0
MessageScreenLo
 .dsb 8,0
MessageScreenHi
 .dsb 8,0
MessageTextLo
 .dsb 8,0
MessageTextHi
 .dsb 8,0
MessageScrollDirection
 .dsb 8,0
MessageTextLength
 .dsb 8,0
MessageGraphicLength
 .dsb 8,0
MessageTextAddressLo
 .dsb 8,0
MessageTextAddressHi
 .dsb 8,0

ControlMessages
	;Manage appearance of each new message
	;Display message(credit,author) specifying x,y,message number
	;Manage end of messages
	lda MessageDelay
.(
	bmi skip1
	dec MessageDelay
	rts
skip1	ldy #00
.)
	lda (MessSeq),y
.(
	beq EndOfMessages
	bmi DelayMessage
	;Locate Message
	ldx #7
loop1	lda MessageEffectIndex,x
	bmi skip1
	dex
	bpl loop1
	rts
skip1	;Populate Message tables
	iny
	lda (MessSeq),y
	sta MessageX,x
	iny
	lda (MessSeq),y
	sta MessageY,x
	iny
	lda (MessSeq),y
	and #127
	sta MessageEffectIndex,x
	iny
	lda (MessSeq),y
	sta MessageScrollDirection,x
	iny
	lda (MessSeq),y
	sta MessageTextLength,x
	iny
	tya
	clc
	adc MessSeq
	sta MessageTextAddressLo,x
	lda MessSeq+1
	adc #00
	sta MessageTextAddressHi,x
	;Step over text
	tya
	adc MessageTextLength,x
	adc MessSeq
	sta MessSeq
	lda MessSeq+1
	adc #00
	sta MessSeq+1
	;Now calculate messagescreenlo/hi,x
	ldy MessageY,x
	lda MessageX,x
	adc #40
	adc EvenYLOCL,y
	sta MessageScreenLo,x
	lda EvenYLOCH,y
	adc #00
	sta MessageScreenHi,x
EndOfMessages
	rts
DelayMessage
.)
	iny
	lda (MessSeq),y
	sta MessageDelay
	rts


;0  End
;1  Message	x,y,EffectIndex,ScrollDirection,TextLength,Text(Terminated with last char+128)
;128  Delay	Delay
MessageSequence
 .byt 1,2,20,0,0,9,"CONCIEVED"
 .byt 128,10
 .byt 1,3,24,8,0,9,"TWILIGHTE"
 .byt 128,20
 .byt 0

;Preferred_Colour permits Credit to appear in one colour cycle and Author in another.
;This should give a much better contrast. For example Cyan Credit and Magenta Author
;0 Red Combination 1537351
;1 Blu Combination 4267624
;2 Grn Combination 4237324
;3 Wht Combination 412373214



;B0-2 Colour
;     0 Black		meBlk
;     1 Red             meRed
;     2 Green           meGrn
;     3 Yellow          meYel
;     4 Blue            meBlu
;     5 Magenta         meMag
;     6 Cyan            meCyn
;     7 White           meWht
;B3-4 Dither
;     0 No Dither
;     1 Dither Level #1 meDt0
;     2 Dither Level #2 meDt1
;     3 Dither Level #3 meDt2
;B5   Scroll
;     0 No Scroll
;     1 Scroll     	meScr
;B6   Plot Message
;     0 Do nothing
;     1 Plot message    mePlt
;B7   End of Effect(Delete Message)
;     0 Continue Effect
;     1 Delete and End	meEnd
MessageEffect
 .byt meRed+mePlt	;Effect 0 - Index 0 (Number that goes in Messages)
 .byt meMag
 .byt meYel
 .byt meWht
 .byt meYel
 .byt meMag
 .byt meRed
 .byt meEnd

 .byt meBlu+mePlt	;Effect 1 - Index 8
 .byt meRed
 .byt meGrn
 .byt meYel
 .byt meWht
 .byt meYel
 .byt meGrn+meScr
 .byt meRed
 .byt meBlu+meScr+meDt0
 .byt meBlu+meScr+meDt0
 .byt meBlu+meScr+meDt0+meEnd

;Colour 41237321444
;Dither         DDD
;Scroll       S SSS
;0 Red Combination 1537351
;1 Blu Combination 4267624
;2 Grn Combination 4237324
;3 Wht Combination 412373214

ManageMessageFlow
	;Control flow(colour,dither,scroll) of all concurrent message
	ldx #7	;Maximum concurrent messages
	;0-number of steps
	;128 for inactive
.(
loop1	stx CurrentMessageIndex
	ldy MessageEffectIndex,x
	sty CurrentMessageEffectIndex
	bmi skip1
	jsr ProcActiveMessage
	ldx CurrentMessageIndex
skip1	dex
	bpl loop1
.)
	rts

ProcActiveMessage
	jsr CheckColour
	jsr CheckPlot
	jsr CheckDither
	jsr CheckScroll
	jsr CheckEnd
	;
	ldx CurrentMessageIndex
	inc MessageEffectIndex,x
	rts

CheckColour
	;Get Colour
	ldy CurrentMessageEffectIndex
	lda MessageEffect,y
	and #%00000111
	sta CurrentMessageColour
	;Get Screen Address
	ldx CurrentMessageIndex
	ldy MessageScreenLo,x
	sty screen
	ldy MessageScreenHi,x
	sty screen+1
	;Plot Colour
	ldx #04
	ldy #00
.(
loop1	lda CurrentMessageColour
	sta (screen),y
	lda #80
	jsr add_screen
	dex
	bne loop1
.)
	rts

;Delete Message and Terminate
CheckEnd
	;Get End Condition
	ldy CurrentMessageEffectIndex
	lda MessageEffect,y
	and #%10000000
.(
	beq skip1
	;Get Screen Address
	ldx CurrentMessageIndex
	lda MessageScreenLo,x
	sta screen
	lda MessageScreenHi,x
	sta screen+1
	;Fetch and adjust Message length to include scroll-in and Colour bytes
	ldy MessageGraphicLength,x
	iny
	iny
	sty CurrentMessageGraphicLength
	;Process Dither Mask
	ldx #04
loop2	lda #64
loop1	sta (screen),y
	dey
	bpl loop1
	;
	ldy CurrentMessageGraphicLength
	;
	lda #80
	jsr add_screen
	;
	dex
	bne loop2
	;Now Terminate Message
	ldx CurrentMessageIndex
	lda #128
	sta MessageEffectIndex,x
skip1	rts
.)

CheckScroll
	ldy CurrentMessageEffectIndex
	lda MessageEffect,y
	and #%00100000
.(
	beq skip1
	;Get Screen Address (+1)
	ldx CurrentMessageIndex
	lda MessageScreenLo,x
	clc
	adc #01
	sta screen
	lda MessageScreenHi,x
	adc #00
	sta screen+1
	;Fetch and adjust Message length to include scroll-in byte
	ldy MessageGraphicLength,x
	iny
	sty CurrentMessageGraphicLength
	;Branch on Scroll Direction
	lda MessageScrollDirection,x
	bmi ScrollRight
ScrollLeft
	ldx #4

loop2	clc	;to scroll out
loop1	lda (screen),y
	;Always assume never attribs
	rol	;Shift with adjacent bit
	and #63	;Chop off top two bits
	ora #64	;add back bitmap flag
	sta (screen),y
	dey
	bpl loop1
	;restore row index(Y)
	ldy temp01
	;Progress next row
	lda #80
	jsr add_screen
	;Reduce row counter
	dex
	bne loop2
skip1	rts
ScrollRight
.)
	ldx #4
	;work from right to left to scroll right
.(
loop2	ldy #00
	clc	;To scroll out
loop1	lda (screen),y
	and #63
	bcc skip1
	ora #64
skip1	lsr
	ora #64
	sta (screen),y
	iny
	cpy temp01
	bcc loop1
	;progress next row
	lda #80
	jsr add_screen
	;Reduce row counter
	dex
	bne loop2
.)
	rts


DitherBitmap
 .byt %01111011
 .byt %01101010
 .byt %01100010


CheckDither
	;Get Dither
	ldy CurrentMessageEffectIndex
	lda MessageEffect,y
	and #%00011000
	lsr
	lsr
	lsr
	;Branch if none
.(
	beq skip1
	;Use to index and fetch Dither Bitmap
	tax
	lda DitherBitmap-1,x
	sta CurrentDitherBitmap
	;Get Screen Address (+1)
	ldx CurrentMessageIndex
	lda MessageScreenLo,x
	clc
	adc #01
	sta screen
	lda MessageScreenHi,x
	adc #00
	sta screen+1
	;Fetch and adjust Message length to include scroll-in byte
	ldy MessageGraphicLength,x
	iny
	sty CurrentMessageGraphicLength
	;Process Dither Mask
	ldx #04
loop2	ldy CurrentMessageGraphicLength
loop1	lda (screen),y
	and CurrentDitherBitmap
	sta (screen),y
	dey
	bpl loop1
	;Update screen
	lda #80
	jsr add_screen
	;update row
	dex
	bne loop2
skip1	rts
.)




CheckPlot
	ldy CurrentMessageEffectIndex
	lda MessageEffect,y
	and #%01000000
.(
	beq skip1
	;Get Message Address
	ldx CurrentMessageIndex
	lda MessageTextLo,x
	sta text
	lda MessageTextHi,x
	sta text+1
	;Get Screen Address
	lda MessageScreenLo,x
	clc
	adc #02
	sta screen
	lda MessageScreenHi,x
	adc #00
	sta screen+1
	;Plot Message
	ldy #00
	sty MessageTextIndex
	sty CurrentMessageGraphicLength
loop1	;Fetch next Text character
	ldy MessageTextIndex
	lda (text),y
	;Preserve B7 (End of Text flag)
	php
	;Calculate Text Character address
	jsr CalculateDWCAddress	;Stores address in CharacterSource+1/+2
	sty CharacterSource+1
	sta CharacterSource+2
	;Plot Character
	ldx #07
CharacterSource
	lda $dead,x
	ldy ScreenOffset2xH,x
	sta (screen),y
	dex
	bpl CharacterSource
	;Update screen
	lda #02
	jsr add_screen
	;Update text index
	inc MessageTextIndex
	;Update actual Graphic row length
	inc CurrentMessageGraphicLength
	inc CurrentMessageGraphicLength
	;Recall EOL flag
	plp
	;Loop
	bpl loop1
	;Oppertunity also used to establish MessageLength
	ldx CurrentMessageIndex
	dec CurrentMessageGraphicLength
	dec CurrentMessageGraphicLength
	lda CurrentMessageGraphicLength
	sta MessageGraphicLength,x
skip1	rts
.)


ScreenOffset2xH
 .byt 0,1
 .byt 80,81
 .byt 160,161
 .byt 240,241

;A == Character ASCII (32 or 65-91)
;XY Not corrupted
CalculateDWCAddress
	;Branch if space
	cmp #32
.(
	beq skip1
	;Reduce code to 0-25
	sbc #65
	;Multiply by 8(8Bit)
	asl
	asl
	asl
	;Add to Base Address
	adc #<DoubleWidthText_A
	tay
	lda #>DoubleWidthText_A
	adc #00
	rts
skip1	;For space assign DoubleWidthText_
.)
	ldy #<DoubleWidthText_
	lda #>DoubleWidthText_
	rts


DoubleWidthText_
 .dsb 8,$40
DoubleWidthText_A
 .byt $47,$70
 .byt $58,$4C
 .byt $7F,$7E
 .byt $70,$46
DoubleWidthText_B
 .byt $7E,$40
 .byt $7F,$70
 .byt $70,$58
 .byt $7F,$78
DoubleWidthText_C
 .byt $47,$7E
 .byt $58,$40
 .byt $58,$40
 .byt $47,$7E
DoubleWidthText_D
 .byt $7F,$70
 .byt $70,$4C
 .byt $70,$46
 .byt $7F,$7C
DoubleWidthText_E
 .byt $7F,$7E
 .byt $7E,$40
 .byt $70,$40
 .byt $7F,$7E
DoubleWidthText_F
 .byt $7F,$7E
 .byt $70,$40
 .byt $7E,$40
 .byt $70,$40
DoubleWidthText_G
 .byt $4F,$7E
 .byt $70,$40
 .byt $70,$4E
 .byt $4F,$7E
DoubleWidthText_H
 .byt $70,$46
 .byt $7F,$7E
 .byt $70,$46
 .byt $70,$46
DoubleWidthText_I
 .byt $7F,$7E
 .byt $43,$40
 .byt $43,$40
 .byt $7F,$7E
DoubleWidthText_J
 .byt $7F,$7E
 .byt $40,$46
 .byt $70,$46
 .byt $5F,$7C
DoubleWidthText_K
 .byt $70,$46
 .byt $7F,$78
 .byt $70,$4C
 .byt $70,$46
DoubleWidthText_L
 .byt $70,$40
 .byt $70,$40
 .byt $70,$40
 .byt $7F,$7E
DoubleWidthText_M
 .byt $78,$4E
 .byt $76,$76
 .byt $73,$66
 .byt $71,$46
DoubleWidthText_N
 .byt $78,$46
 .byt $76,$46
 .byt $70,$76
 .byt $70,$4E
DoubleWidthText_O
 .byt $4F,$78
 .byt $70,$46
 .byt $70,$46
 .byt $4F,$78
DoubleWidthText_P
 .byt $7F,$7C
 .byt $70,$46
 .byt $7F,$7C
 .byt $70,$40
DoubleWidthText_Q
 .byt $4F,$78
 .byt $70,$76
 .byt $70,$4E
 .byt $4F,$7B
DoubleWidthText_R
 .byt $7F,$7C
 .byt $70,$46
 .byt $7F,$7C
 .byt $70,$46
DoubleWidthText_S
 .byt $41,$7E
 .byt $46,$40
 .byt $41,$60
 .byt $7E,$40
DoubleWidthText_T
 .byt $7F,$7E
 .byt $43,$40
 .byt $43,$40
 .byt $43,$40
DoubleWidthText_U
 .byt $70,$46
 .byt $70,$46
 .byt $58,$4C
 .byt $47,$70
DoubleWidthText_V
 .byt $58,$58
 .byt $4C,$70
 .byt $47,$60
 .byt $43,$40
DoubleWidthText_W
 .byt $70,$46
 .byt $71,$46
 .byt $76,$76
 .byt $78,$4E
DoubleWidthText_X
 .byt $70,$70
 .byt $4D,$40
 .byt $4B,$40
 .byt $70,$70
DoubleWidthText_Y
 .byt $70,$4C
 .byt $4C,$70
 .byt $43,$40
 .byt $43,$40
DoubleWidthText_Z
 .byt $7F,$7C
 .byt $41,$60
 .byt $46,$40
 .byt $7F,$7C

