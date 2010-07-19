


#define ADDR_LOGO			$a000+40*60
#define ADDR_LOGO_LETTERS	$a000+40*71+5

						   
TempX		.byt 0
TempY		.byt 0
TempOffset	.byt 0
TempColor	.byt 0

DiplayAngle1		.byt 0
DiplayAngle2		.byt 0
DisplayPosX			.byt 0
DisplayMemoX		.byt 0

OldByte		.byt 0
blablabla 	.byt 0


DisplayParamBlackFrameTop
	.byt 10				; Count
	.byt 2   ,64+1+2	; Black pixels
	.byt 2+40,64+1+2	; Black pixels
	.byt 3   ,16+0		; Black paper
	.byt 3+40,16+0		; Black paper
	.byt 36    ,0		; Black ink
	.byt 36+40 ,0		; Black ink
	.byt 37   ,64+1+2	; Black pixels
	.byt 37+40,64+1+2	; Black pixels
	.byt 38   ,16+7		; White paper
	.byt 38+40,16+7		; White paper

DisplayParamBlueFrame
	.byt 12
	.byt 2    ,64+1+2	; Black pixels
	.byt 2+40 ,64+1+2	; Black pixels
	.byt 3    ,16+4		; Blue paper
	.byt 3+40 ,16+6		; Cyan paper
	.byt 4    ,3		; Yellow ink
	.byt 4+40 ,1		; Red ink
	.byt 36    ,0		; Black ink
	.byt 36+40 ,0		; Black ink
	.byt 37   ,64+1+2	; Black pixels
	.byt 37+40,64+1+2	; Black pixels
	.byt 38   ,16+7		; White paper
	.byt 38+40,16+7		; White paper

DisplayParamBlueFrameShadow
	.byt 14
	.byt 2    ,64+1+2	; Black pixels
	.byt 2+40 ,64+1+2	; Black pixels
	.byt 3    ,16+4		; Blue paper
	.byt 3+40 ,16+6		; Cyan paper
	.byt 4    ,3		; Yellow ink
	.byt 4+40 ,1		; Red ink
	.byt 36    ,0		; Black ink
	.byt 36+40 ,0		; Black ink
	.byt 37   ,64+1+2	; Black pixels
	.byt 37+40,64+1+2	; Black pixels
	.byt 38   ,16+0		; Black paper
	.byt 38+40,16+0		; Black paper
	.byt 39   ,16+7		; White paper
	.byt 39+40,16+7		; White paper

DisplayParamBlackFrameBottom
	.byt 12				; Count
	.byt 2   ,64+1+2	; Black pixels
	.byt 2+40,64+1+2	; Black pixels
	.byt 3   ,16+0		; Black paper
	.byt 3+40,16+0		; Black paper
	.byt 36    ,0		; Black ink
	.byt 36+40 ,0		; Black ink
	.byt 37   ,64+1+2	; Black pixels
	.byt 37+40,64+1+2	; Black pixels
	.byt 38   ,16+0		; Black paper
	.byt 38+40,16+0		; Black paper
	.byt 39   ,16+7		; White paper
	.byt 39+40,16+7		; White paper

DisplayParamBlackFrameBottomShadow
	.byt 6				; Count
	.byt 4   ,16+0		; Black paper
	.byt 4+40,16+0		; Black paper
	.byt 38   ,16+0		; Black paper
	.byt 38+40,16+0		; Black paper
	.byt 39   ,16+7		; White paper
	.byt 39+40,16+7		; White paper



DisplayNextLine
	clc
	lda tmp1
	adc #80
	sta tmp1
	bcc skip_display_rasters
	inc tmp1+1
skip_display_rasters
	rts



DisplayScanLine
	stx TempX

LoopDisplayScanLineOuter
	ldy #0
	lda (tmp0),y
	iny
	tax

LoopDisplayScanLine
	lda (tmp0),y	// Get offset
	sta TempOffset
	iny
	lda (tmp0),y	// Get color
	sta TempColor
	iny
	sty TempY

	ldy TempOffset
	lda TempColor
	sta (tmp1),y

	ldy TempY

	dex
	bne LoopDisplayScanLine

	jsr DisplayNextLine

	dec	TempX
	bne	LoopDisplayScanLineOuter

	rts



_DisplayDefenceForceFrame
	lda #<ADDR_LOGO
	sta tmp1+0
	lda #>ADDR_LOGO
	sta tmp1+1

	;
	lda #<DisplayParamBlackFrameTop
	sta tmp0+0
	lda #>DisplayParamBlackFrameTop
	sta tmp0+1

	ldx #1
	jsr DisplayScanLine

	;
	lda #<DisplayParamBlueFrame
	sta tmp0+0
	lda #>DisplayParamBlueFrame
	sta tmp0+1

	ldx #3
	jsr DisplayScanLine

	;
	lda #<DisplayParamBlueFrameShadow
	sta tmp0+0
	lda #>DisplayParamBlueFrameShadow
	sta tmp0+1

	ldx #40
	jsr DisplayScanLine

	;
	lda #<DisplayParamBlackFrameBottom
	sta tmp0+0
	lda #>DisplayParamBlackFrameBottom
	sta tmp0+1

	ldx #1
	jsr DisplayScanLine

	;
	lda #<DisplayParamBlackFrameBottomShadow
	sta tmp0+0
	lda #>DisplayParamBlackFrameBottomShadow
	sta tmp0+1

	ldx #3
	jsr DisplayScanLine

	rts






DisplayMakeShiftedLogo
	ldx #67
LoopDisplayMakeShiftedLogo_Y

	lda #0
	sta OldByte
	ldy #0
LoopDisplayMakeShiftedLogo_X
	lda (tmp0),y
	sta blablabla
	;pha
	and #63
	lsr 
	ora	OldByte
	ora #64
	sta (tmp1),y

	lda blablabla
	;pla
	and #1
	asl
	asl
	asl
	asl
	asl
	sta OldByte

	iny 
	cpy #30
	bne LoopDisplayMakeShiftedLogo_X

	clc
	lda tmp0
	adc #30
	sta tmp0
	bcc skip_src
	inc tmp0+1
	clc
skip_src

	lda tmp1
	adc #30
	sta tmp1
	bcc skip_dst
	inc tmp1+1
skip_dst

	dex
	bne LoopDisplayMakeShiftedLogo_Y
	rts


_DisplayMakeShiftedLogos
	; 0
	lda #<_BufferUnpack
	sta tmp0
	lda #>_BufferUnpack
	sta tmp0+1
	lda #<_LabelPicture1
	sta tmp1
	lda #>_LabelPicture1
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 1
	lda #<_LabelPicture1
	sta tmp0
	lda #>_LabelPicture1
	sta tmp0+1
	lda #<_LabelPicture2
	sta tmp1
	lda #>_LabelPicture2
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 2
	lda #<_LabelPicture2
	sta tmp0
	lda #>_LabelPicture2
	sta tmp0+1
	lda #<_LabelPicture3
	sta tmp1
	lda #>_LabelPicture3
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 3
	lda #<_LabelPicture3
	sta tmp0
	lda #>_LabelPicture3
	sta tmp0+1
	lda #<_LabelPicture4
	sta tmp1
	lda #>_LabelPicture4
	sta tmp1+1
	jsr DisplayMakeShiftedLogo

	; 4
	lda #<_LabelPicture4
	sta tmp0
	lda #>_LabelPicture4
	sta tmp0+1
	lda #<_LabelPicture5
	sta tmp1
	lda #>_LabelPicture5
	sta tmp1+1
	jsr DisplayMakeShiftedLogo
	rts


DisplayTableLogoLow
	.byt <_BufferUnpack 
	.byt <_LabelPicture1
	.byt <_LabelPicture2
	.byt <_LabelPicture3
	.byt <_LabelPicture4
	.byt <_LabelPicture5

DisplayTableLogoHigh
	.byt >_BufferUnpack 
	.byt >_LabelPicture1
	.byt >_LabelPicture2
	.byt >_LabelPicture3
	.byt >_LabelPicture4
	.byt >_LabelPicture5



_DisplayScrappIt
	clc
	lda DiplayAngle1
	sta tmp4
	adc #2
	sta DiplayAngle1

	clc
	lda DiplayAngle2
	sta reg1
	adc #5
	sta DiplayAngle2

	; Offset source
	lda #<0
	sta tmp0
	lda #>0
	sta tmp0+1

	; Screen address
	lda #<ADDR_LOGO_LETTERS
	sta tmp1
	lda #>ADDR_LOGO_LETTERS
	sta tmp1+1

	ldx #67
LoopDisplayScrappItY
	stx DisplayMemoX

	;	pos_x=(int)CosTable[angle_1];
	;	pos_x+=(int)CosTable[angle_2];
	;	pos_x=(pos_x*12)/(256*2);
	clc
	ldx tmp4
	lda _CosTable,x
	ldx reg1
	adc _CosTable,x
	tax

	; Increment angles
	inc tmp4

	clc
	lda reg1
	adc #5
	sta reg1

	; Compute src adress
	lda _TableMod6,x
	tay
	clc
	lda DisplayTableLogoLow,y
	adc tmp0
	sta tmp2
	lda DisplayTableLogoHigh,y
	adc tmp0+1
	sta tmp2+1


	; Compute dst adress
	clc
	lda _TableDiv6,x
	adc tmp1
	sta tmp3
	lda tmp1+1
	adc #0
	sta tmp3+1

	ldy #0
LoopDisplayScrappItX
	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	lda (tmp2),y
	sta (tmp3),y
	iny

	cpy #30
	bne LoopDisplayScrappItX

	clc
	lda tmp0
	adc #30
	sta tmp0
	bcc display_skip_src
	inc tmp0+1
	clc
display_skip_src

	lda tmp1
	adc #40
	sta tmp1
	bcc display_skip_dst
	inc tmp1+1
display_skip_dst

	ldx DisplayMemoX

	dex
	beq DisplayScrappItYEnd
	jmp LoopDisplayScrappItY

DisplayScrappItYEnd
	rts


_DisplayPaperSet
	lda #$00
	sta tmp0
	lda #$a0
	sta tmp0+1

	ldx #200
LoopDisplayPaperSet
	ldy #0
	lda #16+7
	sta (tmp0),y
	iny
	lda #0
	sta (tmp0),y

	lda tmp0
	clc
	adc #40
	sta tmp0
	bcc skipbla
	inc tmp0+1
skipbla

	dex
	bne LoopDisplayPaperSet
	rts









