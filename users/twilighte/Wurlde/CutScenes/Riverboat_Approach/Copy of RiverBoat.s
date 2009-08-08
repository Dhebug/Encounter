; Riverboat CutScene
;Screen area is 40x112
;
;(WM)Waning Moon is static masked by Top background
;
;(TB) Top Background back river bank is monochrome 40x40 bitmap
;based in mixed pattern of column sets to repeat and extend map
;Scroll right smooth(1 Pixel) 40x20
;
;(BB) Bottom Background is front river bank monochrome 40x40 Mask
;based on mixed pattern of column sets to repeat and extend map
;Scroll right smooth(2 pixel) 40x20
;
;(MB) Middle Background is river monochrome 40x26 Bitmap masked against bottom background
;based on..
; static ripple effect (Row independant pattern write)
; crude mirror of Top background (alternate alternate line!)
; boat wake (animation ripple)
; possible moonlight reflection using even line but still masked against Bottom Background
;
;(RB) Boat is monochrome 8x12 bitmap with 48x12 mask against Middle background
;Possible rise and fall and scroll to keep boat active.

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

NewBitPair	.dsb 1
screen	.dsb 2
column	.dsb 2
source	.dsb 2
mask	.dsb 2

 .text

*=$500

#define			$A821	;0x52
#define	TopBGScreen	$A821
#define	WaningMoonScreen	$A730
#define	romHIRES		$ec33

Driver	jsr romHIRES
	sei
	jsr InitRiver
	jsr DisplayWaningMoonRows
	lda #03
	sta NewBitPair
	lda #<TopBG_GFX_Bank2
	sta column
	lda #>TopBG_GFX_Bank2
	sta column+1
	lda #2
	sta ColumnCount
;	jsr RandomlyDraw20rows
	jsr DisplayColourColumn
.(
loop1	jsr ControlBoatsPosition

	;Delay scrolling of TopBG(BackBank) by 50%
	lda BackBankFrac
	clc
	adc #128
	sta BackBankFrac
	bcc skip1
	jsr Scroll2BitRight		;SmoothScroll_TopBG_Right
	jsr Manage_TopBG_Column
skip1	jsr Mirror_TopBG_asWater	;To RiverMaskBuffer
	jsr UndulateRiver		;To RiverBuffer
	jsr PlotRandomRightColumn	;Refresh right river column with random bytes
	jsr River2ScreenBuffer	;(RiverBuffer AND RiverMaskBuffer) >> ScreenBuffer
	jsr Boat2ScreenBuffer	;((BoatMask AND ScreenBuffer) OR BoatBitmap) >> ScreenBuffer
	;jsr FrontBank		;(FrontBank AND ScreenBuffer) >> ScreenBuffer
	jsr ScreenBuffer2Screen	;ScreenBuffer >> Screen
	
	
	jmp loop1
.)

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
loop1	lda (column),y
	sta NewByteColumn,y
	dey
	bpl loop1
	;inc column
	lda column
	clc
	adc #22
	sta column
	lda column+1
	adc #00
	sta column+1
	;
	dec ColumnCount
	bne skip1
	;New map scenery
	lda MapIndex
	clc
	adc #01
	and #31
	sta MapIndex
	tax
	ldy TopBG_Map,x
	lda TopBG_GFX_SceneryColumns,y
	sta ColumnCount
	lda TopBG_GFX_SceneryVectorLo,y
	sta column
	lda TopBG_GFX_SceneryVectorHi,y
	sta column+1
skip1	rts
.)


ColumnCount	.byt 0
MapIndex		.byt 0




;Can be held as 8 bit!
NewByteColumn
 .dsb 20,0


rndRandom
 .byt 0,0
rndTemp
 .byt 0


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

         and #63
         ora #64
         rts

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
;These are held as SETS of graphics, each one with its own width but always 20 rows
;And held in memory as sequences of 20 bytes with separate table to indicate number of columns

;Graphic columns are overlaid over sky bg and we specify height (from bottom) which saves many bytes

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
 .byt $4A
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
TopBG_Map	;32
 .byt 5,4,4,9,4,9,4,8	;Fence
 .byt 6,7,6,7,3,6		;Bank
 .byt 1			;Barn
 .byt 7,7,2,6,6,7,5,4,8
 .byt 6,7,7,6,7,0
 .byt 7,7
Mirror_TopBG_asWater
	;every 4 rows
	ldy #38
.(
loop1	lda TopBGScreen,y
	ora #%01000100
	sta RiverMaskBuffer+80*12,y
	lda TopBGScreen+160*1,y
	ora #%01010001
	sta RiverMaskBuffer+80*10,y
	lda TopBGScreen+160*2,y
	ora #%01000100
	sta RiverMaskBuffer+80*8,y
	lda TopBGScreen+160*3,y
	ora #%01010001
	sta RiverMaskBuffer+80*6,y
	lda TopBGScreen+160*4,y
	ora #%01000100
	sta RiverMaskBuffer+80*4,y
	lda TopBGScreen+160*5,y
	ora #%01010001
	sta RiverMaskBuffer+80*2,y
	lda TopBGScreen+160*6,y
	ora #%01000100
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
	
	jsr getrand
	and #63
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
	sta mask
	lda #>RiverMaskBuffer
	sta mask+1
	
	lda #<ScreenBuffer	;$a001+40*122
	sta screen
	lda #>ScreenBuffer	;$a001+40*122
	sta screen+1
	
	ldx #14
.(	
loop2	ldy #38
loop1	lda (source),y
	and (mask),y
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
	jsr getrand
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
	adc mask
	sta mask
	lda mask+1
	adc #00
	sta mask+1
	rts

;(River OR TopBGMask) to ScreenBuffer
;((RiverboatMask AND ScreenBuffer) OR RiverboatBits) to ScreenBuffer
;(FrontBank AND ScreenBuffer) to Screen
ScreenBuffer
 .dsb 40*26,64




Riverboat_BitsGraphic	;12x11 
 .byt $40,$40,$40,$4B,$55,$55,$55,$56,$61,$54,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$55,$40,$40,$40,$40,$40,$40,$40,$42,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$47,$77,$54,$64,$50,$64,$64,$44,$60,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$43,$7D,$55,$42,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$75,$52,$40,$40,$40,$40,$40,$41,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$40,$44,$52,$55,$56,$40,$40
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
 .byt <ScreenBuffer+25+40*12
 .byt <ScreenBuffer+25+40*12
 .byt <ScreenBuffer+25+40*10
 .byt <ScreenBuffer+25+40*12
 .byt <ScreenBuffer+25+40*10
 .byt <ScreenBuffer+25+40*10
BoatsScreenLocationHi
 .byt >ScreenBuffer+25+40*12
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
	lda #<Riverboat_BitsGraphic
	sta source
	lda #>Riverboat_BitsGraphic
	sta source+1
	
	lda #<RiverBoat_MaskGraphic
	sta mask
	lda #>RiverBoat_MaskGraphic
	sta mask+1
	
	ldx BoatHeight
	lda BoatsScreenLocationLo,x	;#<ScreenBuffer+25+40*12
	sta screen
	lda BoatsScreenLocationHi,x
	sta screen+1
	
	ldx #6
.(	
loop2	ldy #11
loop1	lda (screen),y
	and (mask),y
	ora (source),y
	sta (screen),y
	dey
	bpl loop1
	
	lda #80
	jsr AddScreen
	
	lda #24
	jsr AddMask
	
	lda #24
	jsr AddSource
	
	dex
	bne loop2
.)
	rts
	
	
ScreenBuffer2Screen	;ScreenBuffer >> Screen
	lda #<ScreenBuffer
	sta source
	lda #>ScreenBuffer
	sta source+1
	
	lda #<$a001+40*122
	sta screen
	lda #>$a001+40*122
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


;	;2bitscroll FrontBank right
;FrontScrollRight
;	lda NewByteColumn
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn
;	lsr NewByteColumn
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+1
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+1
;	lsr NewByteColumn+1
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*1,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*1,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+2
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+2
;	lsr NewByteColumn+2
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*2,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*2,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+3
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+3
;	lsr NewByteColumn+3
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*3,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*3,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+4
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+4
;	lsr NewByteColumn+4
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*4,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*4,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+5
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+5
;	lsr NewByteColumn+5
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*5,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*5,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+6
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+6
;	lsr NewByteColumn+6
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*6,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*6,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+7
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+7
;	lsr NewByteColumn+7
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*7,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*7,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+8
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+8
;	lsr NewByteColumn+8
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*8,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*8,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+9
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+9
;	lsr NewByteColumn+9
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*9,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*9,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+10
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+10
;	lsr NewByteColumn+10
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*10,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*10,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+11
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+11
;	lsr NewByteColumn+11
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*11,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*11,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+12
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+12
;	lsr NewByteColumn+12
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*12,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*12,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+13
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+13
;	lsr NewByteColumn+13
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*13,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*13,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+14
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+14
;	lsr NewByteColumn+14
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*14,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*14,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+15
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+15
;	lsr NewByteColumn+15
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*15,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*15,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+16
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+16
;	lsr NewByteColumn+16
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*16,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*16,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+17
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+17
;	lsr NewByteColumn+17
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*17,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*17,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+18
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+18
;	lsr NewByteColumn+18
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*18,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*18,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	lda NewByteColumn+19
;	and #3
;	;Once we've captured B01, shift newbytecolumn right twice
;	lsr NewByteColumn+19
;	lsr NewByteColumn+19
;	;Then shift B01 to B45
;	asl
;	asl
;	asl
;	asl
;	;And add Bitmap flag	
;	ora #64
;
;	ldx #127-38
;.(
;loop1	ldy TopBGScreen-89+80*19,x
;	ora TwoBitShift-64,y	;2 bit Shifts right of supplied data in y leaving b45 empty (64 bytes)
;	sta TopBGScreen-89+80*19,x
;	lda TwoBitremainder-64,y	;TwoBit remainder (in b45) of 2 bit shift right of data in y (64 bytes)
;	inx
;	bpl loop1
;.)
;	rts

	