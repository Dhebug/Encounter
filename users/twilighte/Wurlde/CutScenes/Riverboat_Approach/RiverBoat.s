; Riverboat CutScene
; All Cut-scene reside from $C000 and up to $FDFF giving 16K.
; All Cut Scenes may call upon main code routines in same way as SSC's.
; On termination all Cut Scenes must return the next file number to load in X
; All Cut Scenes may raise game_CutSceneFlag to resume game again after file load
; All Cut scenes may also modify the playerfile Map and Screen ID's

;16K Composed of..
; Parralax Scrolling River scene including developing scenery and Castle approach
; Text to describe passage and approach to witches castle
; 2 channel Musical overlay to set scene
; 1 channel watery sfx
;Screen area is 40x112
;
;(WM)Waning Moon is static with only bottom moon row masked by Top background
;
;(TB) Top Background back river bank is monochrome 40x40 bitmap
;based in mixed pattern of column sets to repeat and extend map
;Scroll right smooth(2 Pixel to remove flicker) 40x20 and 50% game cycle
;
;(BB) Bottom Background is front river bank monochrome 40x12 Mask
;based on undulating height taken from table but delayed randomly
;Scroll right smooth(2 pixel) 40x20 Full speed
;
;(MB) Middle Background is river monochrome 40x26 Bitmap masked against bottom background
;based on..
; static ripple effect (Row independant sine scroll l/r write)
; crude mirror of Top background (every 4th row)
; Scrolling 3-4 row at top to give back river bank an edge. Same 2 pixel 50% scroll
;
;(RB) Boat is monochrome 8x12 bitmap with 48x12 mask against Middle background
;rise and fall to keep boat active.

;WM           <Plotted direct to screen
;WM TB        <Plotted direct to screen
;   TB        <Plotted direct to screen
;   TB        <Plotted direct to screen
;   TB        <Plotted direct to screen
;
;MB           <Plotted to Buffer (((MB AND RBm) OR RBb) AND BB)
;MB BB RB     <Plotted to Buffer (((MB AND RBm) OR RBb) AND BB)
;MB BB        <Plotted to Buffer (((MB AND RBm) OR RBb) AND BB)
;MB BB        <Plotted to Buffer (((MB AND RBm) OR RBb) AND BB)
;   BB        <Plotted to Buffer (((MB AND RBm) OR RBb) AND BB)
 .zero
*=$00
#include "C:\OSDK\Projects\Wurlde\gamecode\zeropage.s"
 .bss
#include "C:\OSDK\Projects\Wurlde\PlayerFile\PlayerFile.s"

 .text

*=$C000
#include "C:\OSDK\Projects\Wurlde\gamecode\wurldedefines.s"

#define	TopBGScreen	$A821+40*6
#define	WaningMoonScreen	$A730+40*6
#define	ScreenBufferScreen	$a001+40*122
	
Driver	jsr InitText
	jsr InitRiver
	jsr DisplayWaningMoonRows
	lda #03
	sta NewBitPair
	lda #<TopBG_GFX_Bank2
	sta evnscn
	lda #>TopBG_GFX_Bank2
	sta evnscn+1
	lda #2
	sta ColumnCount
;	jsr RandomlyDraw20rows
	jsr DisplayColourColumn
.(
loop1	jsr AnimateSkipCharacter
	jsr ControlBoatsPosition
	jsr ManageFrontBankScroll
	jsr Perform2BitFrontBankScroll	;over 4 rows
	;Delay scrolling of TopBG(BackBank) by 50%
	lda BackBankFrac
	clc
	adc #128
	sta BackBankFrac
	bcc skip1
	;Operate at 50% normal speed here
	jsr Scroll2BitRight		;SmoothScroll_TopBG_Right
	jsr Manage_TopBG_Column
	
	;Branch on detecting cut-scene end
	lda game_CutSceneFlag
	bpl skip2
	
	jsr ScrollMaskedBackRiverShore
	lda FadeRowFlag
	beq skip1
	jsr FadeRows
skip1	
	jsr UndulateRiver		;To RiverBuffer
	jsr Mirror_TopBG_asWater	;To RiverMaskBuffer
	jsr PlotRandomRightColumn	;Refresh right river column with random bytes
	jsr River2ScreenBuffer	;(RiverBuffer AND RiverMaskBuffer) >> ScreenBuffer
	jsr Boat2ScreenBuffer	;((BoatMask AND ScreenBuffer) OR BoatBitmap) >> ScreenBuffer
	;jsr FrontBank		;(FrontBank AND ScreenBuffer) >> ScreenBuffer
	jsr MaskScreenBufferWithRiverShore
	jsr MaskFrontBankWithScreenBuffer
	jsr ScreenBuffer2Screen	;ScreenBuffer >> Screen
	jsr MaskMoonByte

	;Detect Action Key(Quick Exit clause)
	jsr game_ReadKeyboard
	lda KeyRegister
	cmp #16	;Action Key
	bne loop1
	jsr ExitGameCode
skip2	rts
.)


ExitGameCode
	jsr RestoreGravestoneGraphic
	;At End - For now load direct to Map1,screen0
	lda #1
	sta MapID
	lda #0
	sta ScreenID
	lda #10	;File number for map1,scn0
	sta game_CutSceneFlag
	lda #0
	sta SideApproachFlag
	rts

NewBitPair	.byt 0

;The bottom text border gravestone(Inversed ASCII 38) is replaced with an animated Down Arrow symbol here
AnimateSkipCharacter
	lda DownArrowFrac
	clc
	adc #64
	sta DownArrowFrac
.(
	bcc skip1
	lda DownArrowFrame
	eor #8
	sta DownArrowFrame
	tax
	ldy #7
loop1	lda DownArrowTextGraphic,x
	sta $9930,y
	inx
	dey
	bpl loop1
skip1	rts
.)

DownArrowTextGraphic
 .byt %00111111
 .byt %00111111
 .byt %00110011
 .byt %00100001
 .byt %00111111
 .byt %00110011
 .byt %00100001
 .byt %00111111

 .byt %00111111
 .byt %00110011
 .byt %00100001
 .byt %00111111
 .byt %00110011
 .byt %00100001
 .byt %00111111
 .byt %00111111

RestoreGravestoneGraphic
	ldx #7
.(
loop1	lda GraveStoneCharacter,x
	sta $9930,x
	dex
	bpl loop1
.)
	rts


GraveStoneCharacter
 .byt $21,$00,$0C,$1E,$1E,$0C,$0C,$00

DownArrowFrame	.byt 0
DownArrowFrac	.byt 0

;Whilst technically the moon never gets masked, visually the highest points of the background
;scroller look like they should mask it, so this modifies the bottom moon row.
;Note that the complete moon cannot be masked since it uses inverse on blue rows to achieve yellow.
MaskMoonByte
	lda WaningMoonScreen+37+40*6
	and #%01011110
	ora #%01010100
	sta WaningMoonScreen+37+40*5
	rts

DisplayWaningMoonRows
	lda #<WaningMoonScreen
	sta screen
	lda #>WaningMoonScreen
	sta screen+1
	lda #<WaningMoonGraphic
	sta source
	lda #>WaningMoonGraphic
	sta source+1
	
	ldx #7
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

WaningMoonGraphic
 .byt 4,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01111010,%01111011,%01111111,%01111111,%01110110

 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,7,%01011110,%01000000,%01000000
 
 .byt 4,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101011,%01101110,%01111110,%11101010,%01011111,%01011010

 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,7,%01111111,%01000000,%01000000

 .byt 4,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101011,%01111110,%11101010,%01011111,%01101110

 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 .byt %01000000,%01000000,%01000000,%01000000,7,%01011110,%01000000,%01000000

 .byt 4,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010,%01101010
 .byt %01101010,%01101010,%01101011,%01101101,%01111111,%01111111,%01111110,%01111010

; .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
; .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
; .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
; .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
; .byt %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01000000
 
Manage_TopBG_Column
	;Move bit through column
	asl NewBitPair
	asl NewBitPair
	lda NewBitPair
	cmp #64
.(
	bcc skip1
	;Update bit
	lda #3
	sta NewBitPair
	;Update Column
	ldy #19
loop1	lda (evnscn),y
	sta NewByteColumn,y
	dey
	bpl loop1
	;inc column
	lda evnscn
	clc
	adc #22
	sta evnscn
	lda evnscn+1
	adc #00
	sta evnscn+1
	;
	dec ColumnCount
	bne skip1

	;New map scenery
	inc MapIndex
	ldx MapIndex
	ldy TopBG_Map,x
	; Is this the Castle?
	cpy #19
	bne skip4
	; On reaching the castle, gradually fade the screen
	lda #1
	sta FadeRowFlag
skip4	lda TopBG_GFX_SceneryColumns,y
	sta ColumnCount
	lda TopBG_GFX_SceneryVectorLo,y
	sta evnscn
	lda TopBG_GFX_SceneryVectorHi,y
	sta evnscn+1
skip1	rts
.)

ColumnCount	.byt 0
MapIndex		.byt 0




;Can be held as 8 bit!
NewByteColumn
 .dsb 20,0





DisplayColourColumn
	;Display Blue down column 0
	lda #<TopBGScreen-1-11*40
	sta screen
	lda #>TopBGScreen-1-11*40
	sta screen+1
	ldy #00
	ldx #112
.(
loop1	lda #4
	sta (screen),y
	lda #40
	jsr AddScreen
skip1	dex
	bne loop1
.)
	rts

;Top BG Graphics
;These are held as SETS of graphics, each one with its own width but always 22 rows
;And held in memory as sequences of 22 bytes with separate table to indicate number of columns

;Individual graphics are held as columns.
;There are many ways to reduce bytes here but nothing has yet been done.
;For example, we currently use 6 bits, the graphic could be full 8 bit.
;Also we could use some compression for repeated bytes

TopBG_GFX_SceneryVectorLo
 .byt <TopBG_GFX_Tree1
 .byt <TopBG_GFX_Barn
 .byt <TopBG_GFX_Silverbirch
 .byt <TopBG_GFX_Milestone
 .byt <TopBG_GFX_FenceCont1
 .byt <TopBG_GFX_FenceEnd
 .byt <TopBG_GFX_Bank1
 .byt <TopBG_GFX_Bank2
 .byt <TopBG_GFX_FenceStart
 .byt <TopBG_GFX_FenceCont
 .byt <TopBG_GFX_Forest
 .byt <TopBG_GFX_Crag
 .byt <TopBG_GFX_Crag2
 .byt <TopBG_GFX_Hill1
 .byt <TopBG_GFX_Hill2
 .byt <TopBG_GFX_Hill3
 .byt <TopBG_GFX_Hill4
 .byt <TopBG_GFX_Rivine
 .byt <TopBG_GFX_Escarpment
 .byt <TopBG_GFX_Castle
TopBG_GFX_SceneryVectorHi
 .byt >TopBG_GFX_Tree1
 .byt >TopBG_GFX_Barn
 .byt >TopBG_GFX_Silverbirch
 .byt >TopBG_GFX_Milestone
 .byt >TopBG_GFX_FenceCont1
 .byt >TopBG_GFX_FenceEnd
 .byt >TopBG_GFX_Bank1
 .byt >TopBG_GFX_Bank2
 .byt >TopBG_GFX_FenceStart
 .byt >TopBG_GFX_FenceCont
 .byt >TopBG_GFX_Forest
 .byt >TopBG_GFX_Crag      
 .byt >TopBG_GFX_Crag2     
 .byt >TopBG_GFX_Hill1     
 .byt >TopBG_GFX_Hill2     
 .byt >TopBG_GFX_Hill3     
 .byt >TopBG_GFX_Hill4     
 .byt >TopBG_GFX_Rivine    
 .byt >TopBG_GFX_Escarpment
 .byt >TopBG_GFX_Castle
 
TopBG_GFX_SceneryColumns
 .byt 8	;TopBG_GFX_Tree1
 .byt 6	;TopBG_GFX_Barn
 .byt 4	;TopBG_GFX_Silverbirch
 .byt 2	;TopBG_GFX_Milestone
 .byt 7	;TopBG_GFX_FenceCont1
 .byt 8	;TopBG_GFX_FenceEnd
 .byt 3	;TopBG_GFX_Bank1
 .byt 2	;TopBG_GFX_Bank2
 .byt 4	;TopBG_GFX_FenceStart
 .byt 5	;TopBG_GFX_FenceCont
 .byt 5	;TopBG_GFX_Forest
 .byt 6   ;TopBG_GFX_Crag
 .byt 4   ;TopBG_GFX_Crag2
 .byt 3   ;TopBG_GFX_Hill1
 .byt 3   ;TopBG_GFX_Hill2
 .byt 3   ;TopBG_GFX_Hill3
 .byt 3   ;TopBG_GFX_Hill4
 .byt 4   ;TopBG_GFX_Rivine
 .byt 3   ;TopBG_GFX_Escarpment
 .byt 7	;TopBG_GFX_Castle

 
 
 
 
 
 
 
 
 
 
 
;+128 to repeat 101010 B0-5 times (0-19)
TopBG_GFX_Tree1	;8x22
 .byt $6A	;column 7
 .byt $6A
 .byt $4A
 .byt $6A
 .byt $4A
 .byt $42
 .byt $48
 .byt $62
 .byt $6A
 .byt $62
 .byt $62
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6B
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $4A
 .byt $4A
 .byt $64
 .byt $6A
 .byt $60
 .byt $60
 .byt $68
 .byt $40
 .byt $40
 .byt $4A
 .byt $62
 .byt $42
 .byt $68
 .byt $48
 .byt $4A
 .byt $6A
 .byt $6A
 .byt $48
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $68
 .byt $4A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $60
 .byt $62
 .byt $40
 .byt $48
 .byt $42
 .byt $40
 .byt $60
 .byt $4A
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $6A
 .byt $62
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $42
 .byt $62
 .byt $6A
 .byt $60
 .byt $62
 .byt $40
 .byt $40
 .byt $40
 .byt $42
 .byt $40
 .byt $40
 .byt $40
 .byt $4A
 .byt $40
 .byt $4A
 .byt $4A
 .byt $6A
 .byt $62
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $4A
 .byt $6A
 .byt $50
 .byt $48
 .byt $62
 .byt $60
 .byt $68
 .byt $42
 .byt $40
 .byt $60
 .byt $40
 .byt $68
 .byt $68
 .byt $68
 .byt $48
 .byt $40
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $68
 .byt $6A
 .byt $48
 .byt $4A
 .byt $62
 .byt $40
 .byt $40
 .byt $6A
 .byt $61
 .byt $40
 .byt $4A
 .byt $68
 .byt $60
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $68
 .byt $42
 .byt $60
 .byt $62
 .byt $4A
 .byt $62
 .byt $60
 .byt $42
 .byt $42
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $62
 .byt $48
 .byt $48
 .byt $68
 .byt $62
 .byt $6A
 .byt $62
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

TopBG_GFX_Barn	;6x22
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $42
 .byt $42
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $42
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $50
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $68
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $68
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $68
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $68
 .byt $68
 .byt $62
 .byt $6A
 .byt $6C
 .byt $4C
 .byt $6C
 .byt $6C
 .byt $6C
 .byt $40
 .byt $40
 .byt $40


TopBG_GFX_Silverbirch	;4x22
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $6A
 .byt $68
 .byt $4A
 .byt $6A
 .byt $68
 .byt $72
 .byt $6B
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $62
 .byt $6A
 .byt $68
 .byt $6A
 .byt $5A
 .byt $68
 .byt $62
 .byt $70
 .byt $62
 .byt $72
 .byt $72
 .byt $62
 .byt $62
 .byt $42
 .byt $42
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $69
 .byt $6A
 .byt $62
 .byt $6C
 .byt $5A
 .byt $68
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6B
 .byt $6B
 .byt $40
 .byt $40
 .byt $40
 .byt $40

TopBG_GFX_Milestone	;2x22
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $62
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40


TopBG_GFX_FenceCont1	;7x22
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6B
 .byt $6B
 .byt $6D
 .byt $48
 .byt $6A
 .byt $7A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7F
 .byt $62
 .byt $6A
 .byt $7E
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7E
 .byt $48
 .byt $6A
 .byt $7E
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $72
 .byt $72
 .byt $53
 .byt $72
 .byt $72
 .byt $76
 .byt $72
 .byt $6A
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7F
 .byt $62
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $48
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7F
 .byt $48
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $60
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7F
 .byt $62
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $62
 .byt $62
 .byt $40
 .byt $40


TopBG_GFX_FenceEnd	;8x22
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $5A
 .byt $66
 .byt $48
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6C
 .byt $4C
 .byt $6C
 .byt $6C
 .byt $6C
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $4E
 .byt $68
 .byt $42
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7A
 .byt $60
 .byt $4A
 .byt $68
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7A
 .byt $60
 .byt $6A
 .byt $60
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6C
 .byt $7C
 .byt $6C
 .byt $6C
 .byt $6C
 .byt $68
 .byt $6C
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6B
 .byt $7A
 .byt $6A
 .byt $6B
 .byt $7A
 .byt $6A
 .byt $48
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $43
 .byt $72
 .byt $72
 .byt $7A
 .byt $6C
 .byt $4C
 .byt $40
 .byt $40
 .byt $40


TopBG_GFX_Bank1	;3x22
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40


TopBG_GFX_Bank2	;2x22
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $48
 .byt $40
 .byt $40
 .byt $40
 .byt $40


TopBG_GFX_FenceStart	;4x22
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6C
 .byt $68
 .byt $6F
 .byt $6C
 .byt $68
 .byt $4C
 .byt $68
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6C
 .byt $42
 .byt $6A
 .byt $6A
 .byt $62
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6B
 .byt $70
 .byt $62
 .byt $72
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6C
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40


TopBG_GFX_FenceCont	;5x22
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $72
 .byt $72
 .byt $53
 .byt $70
 .byt $72
 .byt $7A
 .byt $60
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7F
 .byt $40
 .byt $6A
 .byt $7B
 .byt $62
 .byt $6A
 .byt $42
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7F
 .byt $40
 .byt $6A
 .byt $7E
 .byt $4A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $7F
 .byt $62
 .byt $6A
 .byt $7E
 .byt $62
 .byt $6A
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6C
 .byt $68
 .byt $6F
 .byt $6C
 .byt $68
 .byt $4C
 .byt $68
 .byt $40
 .byt $40
 .byt $40
 .byt $40


TopBG_GFX_
; 00 TopBG_GFX_Tree1
; 01 TopBG_GFX_Barn
; 02 TopBG_GFX_Silverbirch
; 03 TopBG_GFX_Milestone
; 04 TopBG_GFX_FenceCont1
; 05 TopBG_GFX_FenceEnd
; 06 TopBG_GFX_Bank1
; 07 TopBG_GFX_Bank2
; 08 TopBG_GFX_FenceStart
; 09 TopBG_GFX_FenceCont
; 10 TopBG_GFX_Forest
; 11 TopBG_GFX_Crag
; 12 TopBG_GFX_Crag2
; 13 TopBG_GFX_Hill1
; 14 TopBG_GFX_Hill2
; 15 TopBG_GFX_Hill3
; 16 TopBG_GFX_Hill4
; 17 TopBG_GFX_Rivine
; 18 TopBG_GFX_Escarpment
; 19 TopBG_GFX_Castle
TopBG_Map	;64
 .byt 5,4,4,9,4,9,4,8	;Fence
 .byt 6,7,6,7,3,6		;Bank
 .byt 1			;Barn
 .byt 7,7,2,6,6,7,5,4,8
 .byt 6,7,7,6,7,0
 .byt 7,7
 .byt 10,5,4,8,5,4,8,10,3,2,7,6,7,0
 .byt 18,13,15,14,12,17,13,15,14,16,11,12,17,13,14,15,16,17,12,11
 .byt 13,14,15,16,17,19
 .byt 13,15,14,12,17,13,15,14,16,128	;11,12,17,13,14,15,16,17,12,11

Mirror_TopBG_asWater
	;Interpolate every 4 rows with TopBG
	ldy #38
.(
loop1	lda TopBGScreen,y
;	ora #%01000100
	sta RiverMaskBuffer+80*12,y
	lda TopBGScreen+160*1,y
;	ora #%01010001
	sta RiverMaskBuffer+80*10,y
	lda TopBGScreen+160*2,y
;	ora #%01000100
	sta RiverMaskBuffer+80*8,y
	lda TopBGScreen+160*3,y
;	ora #%01010001
	sta RiverMaskBuffer+80*6,y
	lda TopBGScreen+160*4,y
;	ora #%01000100
	sta RiverMaskBuffer+80*4,y
	lda TopBGScreen+160*5,y
;	ora #%01010001
	sta RiverMaskBuffer+80*2,y
	lda TopBGScreen+160*6,y
;	ora #%01000100
	sta RiverMaskBuffer+80,y
	dey
	bpl loop1
.)
	rts

BackBankFrac	.byt 0
;two bit right scroll to reduce flicker
Scroll2BitRight
	lda NewByteColumn
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn
	lsr NewByteColumn
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64


	ldx #127-38
.(
loop1	ldy TopBGScreen-89,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+1
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+1
	lsr NewByteColumn+1
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*1,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*1,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+2
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+2
	lsr NewByteColumn+2
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*2,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*2,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+3
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+3
	lsr NewByteColumn+3
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*3,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*3,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+4
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+4
	lsr NewByteColumn+4
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*4,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*4,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+5
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+5
	lsr NewByteColumn+5
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*5,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*5,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+6
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+6
	lsr NewByteColumn+6
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*6,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*6,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+7
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+7
	lsr NewByteColumn+7
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*7,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*7,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+8
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+8
	lsr NewByteColumn+8
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*8,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*8,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+9
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+9
	lsr NewByteColumn+9
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*9,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*9,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+10
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+10
	lsr NewByteColumn+10
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*10,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*10,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+11
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+11
	lsr NewByteColumn+11
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*11,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*11,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+12
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+12
	lsr NewByteColumn+12
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*12,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*12,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+13
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+13
	lsr NewByteColumn+13
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*13,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*13,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+14
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+14
	lsr NewByteColumn+14
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*14,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*14,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+15
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+15
	lsr NewByteColumn+15
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*15,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*15,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+16
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+16
	lsr NewByteColumn+16
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*16,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*16,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+17
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+17
	lsr NewByteColumn+17
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*17,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*17,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+18
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+18
	lsr NewByteColumn+18
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*18,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*18,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	lda NewByteColumn+19
	and #3
	;Once we've captured B01, shift newbytecolumn right twice
	lsr NewByteColumn+19
	lsr NewByteColumn+19
	;Then shift B01 to B45
	asl
	asl
	asl
	asl
	;And add Bitmap flag	
	ora #64

	ldx #127-38
.(
loop1	ldy TopBGScreen-89+80*19,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta TopBGScreen-89+80*19,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	rts

TwoBitShift	;Based on screen codes 64-127
;      0000XXXX  0000XXXX  0000XXXX  0000XXXX
 .dsb 4,%00000000
 .dsb 4,%00000001
 .dsb 4,%00000010
 .dsb 4,%00000011
 .dsb 4,%00000100
 .dsb 4,%00000101
 .dsb 4,%00000110
 .dsb 4,%00000111
 .dsb 4,%00001000
 .dsb 4,%00001001 
 .dsb 4,%00001010 
 .dsb 4,%00001011 
 .dsb 4,%00001100
 .dsb 4,%00001101 
 .dsb 4,%00001110 
 .dsb 4,%00001111 
TwoBitremainder
;      01XX0000  01XX0000  01XX0000  01XX0000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000
 .byt %01000000,%01010000,%01100000,%01110000

;(MB) Middle Background is river monochrome 40x26 Bitmap masked against bottom background
;based on..
; static ripple effect (Row independant pattern write)
; crude mirror of Top background (alternate alternate line!)
; boat wake (animation ripple)
; possible moonlight reflection using even line but still masked against Bottom Background

;Possibly generate random rows, then shift l/r using sine to decide, but add random byte to
;random position every cycle.
SineWaveIndex	.byt 17

SineWave	;18
 .byt 0,0,1,0,1,1,1,0,1,0,0,255,0,255,255,255,0,255

 
RiverBuffer
 .dsb 40*26,64
RiverMaskBuffer
 .dsb 40*26,127
PlotRandomRightColumn
	lda #<RiverBuffer
	sta screen
	lda #>RiverBuffer
	sta screen+1
	ldx #14
.(
loop1	ldy #38
	
	lda #63
	jsr game_GetRNDRange
	ora #64
	sta (screen),y
	
	lda #80
	jsr AddScreen
	
	dex
	bne loop1
.)
	rts
	


River2ScreenBuffer
	lda #<RiverBuffer
	sta source
	lda #>RiverBuffer
	sta source+1
	
	lda #<RiverMaskBuffer
	sta bgmask
	lda #>RiverMaskBuffer
	sta bgmask+1
	
	lda #<ScreenBuffer	;$a001+40*122
	sta screen
	lda #>ScreenBuffer	;$a001+40*122
	sta screen+1
	
	ldx #14
.(	
loop2	ldy #38
loop1	lda (source),y
	and (bgmask),y
	ora #64
	sta (screen),y
	dey
	bpl loop1
	
	lda #80
	jsr AddSource
	lda #80
	jsr AddMask
	lda #80
	jsr AddScreen
	dex
	bne loop2
.)
	rts
	

UndulateRiver
	lda #<RiverBuffer	
	sta screen
	lda #>RiverBuffer	;$a001+40*122
	sta screen+1
	ldx #14
.(
loop1	ldy SineWaveIndex
	lda SineWave,y
	beq next
	bmi skip1
	jsr ShiftRiverRight
	jmp next
skip1	jsr ShiftRiverLeft
next	dec SineWaveIndex
	bpl skip2
	lda #17
	sta SineWaveIndex
skip2	lda #80
	jsr AddScreen
	dex
	bne loop1
.)
	rts
 
ShiftRiverLeft
.(
	ldy #38
loop1	;
	lda (screen),y
	rol
	and #127
	cmp #64
	ora #64
	;store it
	sta (screen),y
	;proceed for remainder of row
	dey
	bpl loop1
.)
	rts
	
ShiftRiverRight
.(
loop2	ldy #38
loop1	;
	lda (screen),y
	and #63
	bcc skip1
	ora #64
skip1	lsr
	ora #64
	;store it
	sta (screen),y
	;proceed for remainder of row
	dey
	bpl loop1
.)
	rts	
	

InitRiver
	lda #<RiverBuffer
	sta screen
	lda #>RiverBuffer
	sta screen+1
	ldx #14
.(
loop2	ldy #38
loop1	;Fetch 8 bit random number
	lda #63
	jsr game_GetRNDRange
	;filter for screen
	and #63
	ora #64
	;store it
	sta (screen),y
	;proceed for remainder of row
	dey
	bpl loop1
	
	; Now proceed to next row
	lda #80
	jsr AddScreen
	
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
AddMask
	clc
	adc bgmask
	sta bgmask
	lda bgmask+1
	adc #00
	sta bgmask+1
	rts

;(River OR TopBGMask) to ScreenBuffer
;((RiverboatMask AND ScreenBuffer) OR RiverboatBits) to ScreenBuffer
;(FrontBank AND ScreenBuffer) to Screen
ScreenBuffer
 .dsb 40*26,64




;Riverboat_BitsGraphic	;12x11 
; .byt $40,$40,$40,$4B,$55,$55,$55,$56,$61,$54,$40,$40
; .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
; .byt $40,$55,$40,$40,$40,$40,$40,$40,$40,$42,$40,$40
; .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
; .byt $40,$47,$77,$54,$64,$50,$64,$64,$44,$60,$40,$40
; .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
; .byt $40,$43,$7D,$55,$42,$40,$40,$40,$40,$40,$40,$40
; .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
; .byt $40,$40,$75,$52,$40,$40,$40,$40,$40,$41,$40,$40
; .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
; .byt $40,$40,$40,$40,$40,$40,$44,$52,$55,$56,$40,$40
RiverBoat_MaskGraphic
 .byt $7C,$4F,$7F,$7F,$70,$40,$40,$40,$40,$5C,$40,$7F
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $7E,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$7F
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $7F,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$7F
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $7F,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$7F
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $7F,$70,$40,$40,$40,$40,$40,$40,$40,$40,$40,$4F
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $7F,$7C,$40,$40,$40,$40,$40,$40,$40,$40,$40,$4F

BoatsScreenLocationLo
 .byt <ScreenBuffer+25+40*10
 .byt <ScreenBuffer+25+40*12
 .byt <ScreenBuffer+25+40*10
 .byt <ScreenBuffer+25+40*12
 .byt <ScreenBuffer+25+40*10
 .byt <ScreenBuffer+25+40*10
BoatsScreenLocationHi
 .byt >ScreenBuffer+25+40*10
 .byt >ScreenBuffer+25+40*12
 .byt >ScreenBuffer+25+40*10
 .byt >ScreenBuffer+25+40*12
 .byt >ScreenBuffer+25+40*10
 .byt >ScreenBuffer+25+40*10
 
BoatMovementFrac	.byt 0

ControlBoatsPosition
	lda BoatMovementFrac
	adc #60
	sta BoatMovementFrac
.(
	bcc skip1
	dec BoatHeight
	bpl skip1
	lda #05
	sta BoatHeight
skip1	rts
.)

BoatHeight	.byt 5

Boat2ScreenBuffer	;((BoatMask AND ScreenBuffer) OR BoatBitmap) >> ScreenBuffer
;	lda #<Riverboat_BitsGraphic
;	sta source
;	lda #>Riverboat_BitsGraphic
;	sta source+1
	
	lda #<RiverBoat_MaskGraphic
	sta bgmask
	lda #>RiverBoat_MaskGraphic
	sta bgmask+1
	
	ldx BoatHeight
	lda BoatsScreenLocationLo,x	;#<ScreenBuffer+25+40*12
	sta screen
	lda BoatsScreenLocationHi,x
	sta screen+1
	
	ldx #6
.(	
loop2	ldy #11
loop1	lda (screen),y
	and (bgmask),y
;	ora (source),y
	sta (screen),y
	dey
	bpl loop1
	
	lda #80
	jsr AddScreen
	
	lda #24
	jsr AddMask
	
;	lda #24
;	jsr AddSource
	
	dex
	bne loop2
.)
	rts
	
	
ScreenBuffer2Screen	;ScreenBuffer >> Screen
	lda #<ScreenBuffer
	sta source
	lda #>ScreenBuffer
	sta source+1
	
	lda #<ScreenBufferScreen
	sta screen
	lda #>ScreenBufferScreen
	sta screen+1
	
	ldx #14
.(	
loop2	ldy #38
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	
	lda #80
	jsr AddSource
	lda #80
	jsr AddScreen
	dex
	bne loop2
.)
	rts


MaskScreenBufferWithRiverShore
	ldx #39
.(
loop1	lda ScreenBuffer,x
	and RiverShoreBuffer,x
	sta ScreenBuffer,x
	lda ScreenBuffer+80,x
	and RiverShoreBuffer+40,x
	sta ScreenBuffer+80,x
	lda ScreenBuffer+160,x
	and RiverShoreBuffer+80,x
	sta ScreenBuffer+160,x
	dex
	bpl loop1
.)
	rts
	
	
RiverShoreBuffer
 .dsb 40*3,127
ThisShoreHeightReference	.byt 0
	
ScrollMaskedBackRiverShore	;2Bit scroll right of 3 rows
	;Scroll On Code
	lda #3
	jsr game_GetRNDRange
	sta ThisShoreHeightReference
.(
	beq skip2
	lda #%01000000
	jmp skip1
skip2	lda #%01110000
skip1	;Scroll row
.)
	
	

	ldx #127-38
.(
loop1	ldy RiverShoreBuffer-89,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta RiverShoreBuffer-89,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)

	;Scroll On Code
	lda ThisShoreHeightReference
	cmp #1
.(
	beq skip2
	lda #%01000000
	jmp skip1
skip2	lda #%01110000
skip1	;Scroll Row
.)
	ldx #127-38
.(
loop1	ldy RiverShoreBuffer-89+40,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta RiverShoreBuffer-89+40,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	;Scroll On Code
	lda ThisShoreHeightReference
	cmp #2
.(
	bcs skip2
	lda #%01000000
	jmp skip1
skip2	lda #%01110000
skip1	;Scroll Row
.)
	ldx #127-38
.(
loop1	ldy RiverShoreBuffer-89+80,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta RiverShoreBuffer-89+80,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	rts	
	

TopBG_GFX_Crag
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $40
 .byt $42
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $62
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $62
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $4A
 .byt $42
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $48
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $68
 .byt $6A
 .byt $6A 
 .byt $68
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

TopBG_GFX_Crag2
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $6A
 .byt $4A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $6A
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $62
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $68
 .byt $68
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 
 
TopBG_GFX_Hill1
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $68
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
  
TopBG_GFX_Hill2
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40
 .byt $40
 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $4A 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40
 .byt $40
 .byt $40
 .byt $40

TopBG_GFX_Hill3
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $62
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $48
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
  
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
  
TopBG_GFX_Rivine
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $68
 .byt $68
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $68 
 .byt $48 
 .byt $48 
 .byt $48 
 .byt $48 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40
 .byt $40
 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40 
 .byt $40
 .byt $40

 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $6A 
 .byt $40 
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
TopBG_GFX_Hill4
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $4A
 .byt $4A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $60
 .byt $40
 .byt $60
 .byt $68
 .byt $68
 .byt $68
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
TopBG_GFX_Escarpment
 .byt $6B
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $62
 .byt $4A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $44
 .byt $48
 .byt $42
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $42
 .byt $4A
 .byt $4A
 .byt $4A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
TopBG_GFX_Forest 	;5x20 (Right row to first)
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $42
 .byt $42
 .byt $42
 .byt $42
 .byt $42
 .byt $42
 .byt $42
 .byt $4A
 .byt $4A
 .byt $4A
 .byt $45
 .byt $4A
 .byt $4A
 .byt $4A
 .byt $4C
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $48
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $50
 .byt $52
 .byt $52
 .byt $52
 .byt $52
 .byt $52
 .byt $52
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $4A
 .byt $42
 .byt $42
 .byt $42
 .byt $40
 .byt $40
 .byt $40
 .byt $48
 .byt $48
 .byt $48
 .byt $48
 .byt $48
 .byt $54
 .byt $54
 .byt $54
 .byt $54
 .byt $54
 .byt $44
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $68
 .byt $68
 .byt $68
 .byt $68
 .byt $68
 .byt $48
 .byt $42
 .byt $42
 .byt $42
 .byt $42
 .byt $4A
 .byt $4A
 .byt $4A
 .byt $4A
 .byt $4A
 .byt $4A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $68
 .byt $68
 .byt $68
 .byt $68
 .byt $6A
 .byt $62
 .byt $62
 .byt $62
 .byt $62
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

ManageFrontBankScroll
	;Delay by random fraction
	lda #255
	jsr game_GetRNDRange
	lsr
	adc FrontBankDelayFrac
	sta FrontBankDelayFrac
.(
	bcs skip1
	rts
skip1	dec FrontBankSlopeIndex

	bpl skip2
	lda #19
	sta FrontBankSlopeIndex
skip2
.)
	ldx FrontBankSlopeIndex
	lda Height4Slope,x
	sta CurrentFrontBankHeight

	ldx #05
.(
loop1	lda #%01000000
	cpx CurrentFrontBankHeight
	bcs skip1
	lda #%01110000
skip1	sta FrontBankColumnList,x
	dex
	bpl loop1
.)
	rts

FrontBankDelayFrac	.byt 0
FrontBankSlopeIndex	.byt 7
Height4Slope
 .byt 0,1,0,1,2,3,2,3,4,4,3,4,3,2,1,2,1,0,0,0


MaskFrontBankWithScreenBuffer
	lda #<FrontBankMaskBuffer+40
	sta bgmask
	lda #>FrontBankMaskBuffer+40
	sta bgmask+1
	
	lda #<ScreenBuffer+80*9
	sta screen
	lda #>ScreenBuffer+80*9
	sta screen+1
	
	ldx #6
.(
loop2	ldy #38
loop1	lda (screen),y
	and (bgmask),y
	sta (screen),y
	dey
	bpl loop1
	lda #40
	jsr AddMask
	lda #80
	jsr AddScreen
	dex
	bne loop2
.)
	rts

CurrentFrontBankHeight	.byt 0
FrontBankColumnList
 .byt %01110000,%01110000,%01110000,%01000000,%01000000
FrontBankMaskBuffer
 .dsb 5*40,127
 .dsb 40,64

Perform2BitFrontBankScroll	;over 4 rows
	;Scroll On Code
	lda FrontBankColumnList
	;Scroll Code
	ldx #127-38
.(
loop1	ldy FrontBankMaskBuffer-89,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta FrontBankMaskBuffer-89,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1

.)
	;Scroll On Code
	lda FrontBankColumnList+1
	;Scroll Code
	ldx #127-38
.(
loop1	ldy FrontBankMaskBuffer-89+40,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta FrontBankMaskBuffer-89+40,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1

.)
	;Scroll On Code
	lda FrontBankColumnList+2
	;Scroll Code
	ldx #127-38
.(
loop1	ldy FrontBankMaskBuffer-89+80,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta FrontBankMaskBuffer-89+80,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	;Scroll On Code
	lda FrontBankColumnList+3
	;Scroll Code
	ldx #127-38
.(
loop1	ldy FrontBankMaskBuffer-89+120,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta FrontBankMaskBuffer-89+120,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
.)
	;Scroll On Code
	lda FrontBankColumnList+4
	;Scroll Code
	ldx #127-38
.(
loop1	ldy FrontBankMaskBuffer-89+160,x
	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
	sta FrontBankMaskBuffer-89+160,x
	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
	inx
	bpl loop1
	rts
.)


TopBG_GFX_Castle	;7x38
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $68
 .byt $60
 .byt $60
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40

 .byt $52
 .byt $42
 .byt $42
 .byt $62
 .byt $42
 .byt $42
 .byt $42
 .byt $42
 .byt $42
 .byt $42
 .byt $42
 .byt $6A
 .byt $40
 .byt $40
 .byt $54
 .byt $40
 .byt $60
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 .byt $69
 .byt $68
 .byt $68
 .byt $48
 .byt $40
 .byt $46
 .byt $46
 .byt $40
 .byt $46
 .byt $46
 .byt $40
 .byt $4A
 .byt $40
 .byt $40
 .byt $65
 .byt $55
 .byt $42
 .byt $40
 .byt $50
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $62
 .byt $40
 .byt $4E
 .byt $4E
 .byt $40
 .byt $4C
 .byt $5E
 .byt $5E
 .byt $4C
 .byt $5E
 .byt $7F
 .byt $7F
 .byt $55
 .byt $55
 .byt $68
 .byt $55
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $7A
 .byt $6A
 .byt $48
 .byt $40
 .byt $58
 .byt $58
 .byt $40
 .byt $58
 .byt $58
 .byt $40
 .byt $54
 .byt $40
 .byt $40
 .byt $69
 .byt $55
 .byt $61
 .byt $4A
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $62
 .byt $60
 .byt $60
 .byt $60
 .byt $60
 .byt $60
 .byt $60
 .byt $60
 .byt $45
 .byt $40
 .byt $40
 .byt $4A
 .byt $41
 .byt $4A
 .byt $54
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $6A
 .byt $4A
 .byt $42
 .byt $42
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 .byt $40
 
FadeRowFlag	.byt 0
FadeRowFrac	.byt 0
BottomFadeRowLo	.byt <$a000+40*150
BottomFadeRowHi	.byt >$a000+40*150
FadeRowCount	.byt 53

 
FadeRows	lda FadeRowFrac
	clc	
	adc #136
	sta FadeRowFrac
.(
	bcc skip1
	
	;Delete Row
	ldx BottomFadeRowLo
	stx screen
	ldx BottomFadeRowHi
	stx screen+1
	ldy #00
	tya
	sta (screen),y

	;And also wipe moon
	ldy #37
	sta (screen),y
	ldy #37+40
	sta (screen),y
	
	
	;Progress fade rows
	lda BottomFadeRowLo
	sec
	sbc #80
	sta BottomFadeRowLo
	bcs skip2
	dec BottomFadeRowHi

skip2	;Check End
	dec FadeRowCount
	bne skip1

	;At End - For now load direct to Map1,screen0
	jsr ExitGameCode

skip1	rts
.)

InitText
	; Display Bottom Text
	lda #<RiverboatText
	sta text
	lda #>RiverboatText
	sta text+1

	;X WindowID (+128 to clear to end of window)
	;Y Row in window (+128 for non embedded single word like Grotes or Form Group)
	;text Source location of text
	ldx #8+128
	ldy #0
	jsr game_DisplayText
	
	; Display Location Text
	lda #<RiverboatLocationText
	sta text
	lda #>RiverboatLocationText
	sta text+1
	ldx #1+128
	ldy #0
	jmp game_DisplayText
	
RiverboatLocationText
;      *************
 .byt "RIVER BANIT]"
RiverboatText
;      ***********************************
 .byt "As the high cliffs draw away Lucien%"
 .byt "rises from his drowsyness and spies%"
 .byt "glistening colours in the boat wake%"
 .byt "as if some strange magic holds his%"
 .byt "course. He sinks back into slumber.%"
 .byt "The scenery ever changing as hills%"
 .byt "loom in the distance..]"
 