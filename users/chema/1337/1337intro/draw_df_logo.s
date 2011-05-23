


#define ADDR_LOGO			$a000+40*60
#define ADDR_LOGO_LETTERS	$a000+40*71+5

#define _BufferUnpackTemp $c000

_LabelPicture1		= _BufferUnpackTemp+2010*1
_LabelPicture2		= _BufferUnpackTemp+2010*2
_LabelPicture3		= _BufferUnpackTemp+2010*3
_LabelPicture4		= _BufferUnpackTemp+2010*4
_LabelPicture5		= _BufferUnpackTemp+2010*5

						   
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

; Non signed values, from 0 to 255
_CosTable	; Used by the DF logo
	.byt	254
	.byt	253
	.byt	253
	.byt	253
	.byt	253
	.byt	253
	.byt	252
	.byt	252
	.byt	251
	.byt	250
	.byt	250
	.byt	249
	.byt	248
	.byt	247
	.byt	246
	.byt	245
	.byt	244
	.byt	243
	.byt	241
	.byt	240
	.byt	239
	.byt	237
	.byt	235
	.byt	234
	.byt	232
	.byt	230
	.byt	229
	.byt	227
	.byt	225
	.byt	223
	.byt	221
	.byt	218
	.byt	216
	.byt	214
	.byt	212
	.byt	209
	.byt	207
	.byt	205
	.byt	202
	.byt	200
	.byt	197
	.byt	194
	.byt	192
	.byt	189
	.byt	186
	.byt	184
	.byt	181
	.byt	178
	.byt	175
	.byt	172
	.byt	169
	.byt	166
	.byt	163
	.byt	160
	.byt	157
	.byt	154
	.byt	151
	.byt	148
	.byt	145
	.byt	142
	.byt	139
	.byt	136
	.byt	133
	.byt	130
	.byt	127
	.byt	124
	.byt	121
	.byt	118
	.byt	115
	.byt	112
	.byt	109
	.byt	106
	.byt	103
	.byt	100
	.byt	97
	.byt	94
	.byt	91
	.byt	88
	.byt	85
	.byt	82
	.byt	79
	.byt	76
	.byt	73
	.byt	70
	.byt	68
	.byt	65
	.byt	62
	.byt	60
	.byt	57
	.byt	54
	.byt	52
	.byt	49
	.byt	47
	.byt	45
	.byt	42
	.byt	40
	.byt	38
	.byt	36
	.byt	33
	.byt	31
	.byt	29
	.byt	27
	.byt	25
	.byt	24
	.byt	22
	.byt	20
	.byt	19
	.byt	17
	.byt	15
	.byt	14
	.byt	13
	.byt	11
	.byt	10
	.byt	9
	.byt	8
	.byt	7
	.byt	6
	.byt	5
	.byt	4
	.byt	4
	.byt	3
	.byt	2
	.byt	2
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	0
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	2
	.byt	2
	.byt	3
	.byt	4
	.byt	4
	.byt	5
	.byt	6
	.byt	7
	.byt	8
	.byt	9
	.byt	10
	.byt	11
	.byt	13
	.byt	14
	.byt	15
	.byt	17
	.byt	19
	.byt	20
	.byt	22
	.byt	24
	.byt	25
	.byt	27
	.byt	29
	.byt	31
	.byt	33
	.byt	36
	.byt	38
	.byt	40
	.byt	42
	.byt	45
	.byt	47
	.byt	49
	.byt	52
	.byt	54
	.byt	57
	.byt	60
	.byt	62
	.byt	65
	.byt	68
	.byt	70
	.byt	73
	.byt	76
	.byt	79
	.byt	82
	.byt	85
	.byt	88
	.byt	91
	.byt	94
	.byt	97
	.byt	100
	.byt	103
	.byt	106
	.byt	109
	.byt	112
	.byt	115
	.byt	118
	.byt	121
	.byt	124
	.byt	127
	.byt	130
	.byt	133
	.byt	136
	.byt	139
	.byt	142
	.byt	145
	.byt	148
	.byt	151
	.byt	154
	.byt	157
	.byt	160
	.byt	163
	.byt	166
	.byt	169
	.byt	172
	.byt	175
	.byt	178
	.byt	181
	.byt	184
	.byt	186
	.byt	189
	.byt	192
	.byt	194
	.byt	197
	.byt	200
	.byt	202
	.byt	205
	.byt	207
	.byt	209
	.byt	212
	.byt	214
	.byt	216
	.byt	218
	.byt	221
	.byt	223
	.byt	225
	.byt	227
	.byt	229
	.byt	230
	.byt	232
	.byt	234
	.byt	235
	.byt	237
	.byt	239
	.byt	240
	.byt	241
	.byt	243
	.byt	244
	.byt	245
	.byt	246
	.byt	247
	.byt	248
	.byt	249
	.byt	250
	.byt	250
	.byt	251
	.byt	252
	.byt	252
	.byt	253
	.byt	253
	.byt	253
	.byt	253
	.byt	253

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
	lda #<_BufferUnpackTemp
	sta tmp0
	lda #>_BufferUnpackTemp
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
	.byt <_BufferUnpackTemp 
	.byt <_LabelPicture1
	.byt <_LabelPicture2
	.byt <_LabelPicture3
	.byt <_LabelPicture4
	.byt <_LabelPicture5

DisplayTableLogoHigh
	.byt >_BufferUnpackTemp 
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
	lda _TableDiv6b,x
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


_GenerateExtraTables
.(

.(
	; Cosine table
	ldx #0
loop
	clc
	lda _CosTable,x	
	adc _CosTable,x	
	sta reg0+0			; x2
	lda #0
	adc #0				; Just to get the carry	
	sta reg0+1
	
	clc
	lda reg0+0
	adc reg0+0
	sta reg1+0			; x4
	lda reg0+1
	adc reg0+1
	sta reg1+1			; x4
	
	clc
	lda reg0+0
	adc reg1+0
	sta reg1+0			; x6
	lda reg0+1
	adc reg1+1
	sta reg1+1			; x6
		
	lda reg1+1
	sta _CosTable,x
	inx
	bne loop	

.)

   ; Generate multiple of 6 data table
.(
    lda #0      ; cur div
    tay         ; cur mod
    tax
loop
    sta _TableDiv6b,x
	pha
	tya
	sta _TableMod6,x
	pla
    iny
    cpy #6
    bne skip_mod
    ldy #0
    adc #0      ; carry = 1!
skip_mod

    inx
    bne loop
.)

	rts
.)








