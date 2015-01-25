

_BufferZ		.dsb 200
_BufferPaper	.dsb 200
_BufferInk		.dsb 200


; Clear the raster color buffer
_RastersClearBuffer
;BreakPoint jmp BreakPoint
	ldx #200	; 200 entries in the buffer
RastersClearBufferLoop
	lda #16					; PAPER BLACK
	sta _BufferPaper-1,x
	lda #7					; White INK
	sta _BufferInk-1,x
	lda #0					; NULL Z
	sta _BufferZ-1,x
	;
	lda #16+4				; PAPER BLUE
	sta _BufferPaper-2,x
	lda #7					; White INK
	sta _BufferInk-2,x
	lda #0					; NULL Z
	sta _BufferZ-2,x

	dex
	dex
	bne RastersClearBufferLoop
	rts


_RastersXOffset		.byt 0

; Display the content of the buffer 
; onto the screen
_RastersDisplayBuffer
	clc
	lda #<$a000+40*55
	adc _RastersXOffset
	sta tmp0
	lda #>$a000+40*55
	adc #0
	sta tmp0+1

	ldx #0	
RastersDisplayBufferLoop
	lda _BufferPaper,x
	ldy #0
	sta (tmp0),y
	lda _BufferInk,x
	ldy #1
	sta (tmp0),y
	inx

	lda _BufferPaper,x
	ldy #40
	sta (tmp0),y
	lda _BufferInk,x
	ldy #41
	sta (tmp0),y
	inx

	clc
	lda tmp0
	adc #80
	sta tmp0
	lda tmp0+1
	adc #0
	sta tmp0+1

	cpx #142
	bne RastersDisplayBufferLoop
	rts





;typedef struct
;{
;	unsigned char *ptr_table;	+0
;	unsigned char prof;			+2
;	unsigned char angle;		+3
;	unsigned char speed;		+4
;}BIGRASTER;


_RasterZ			.byt 0
_RasterPointerBig	.word 0


_RastersDrawBig
;BreakPoint jmp BreakPoint

	lda _RasterPointerBig
	sta tmp0
	lda _RasterPointerBig+1
	sta tmp0+1

	; Get color table pointer
	ldy #0
	lda (tmp0),y
	sta tmp1
	iny
	lda (tmp0),y
	sta tmp1+1

	; Read Z value
	ldy #2
	lda (tmp0),y
	sta _RasterZ

	; Get the angle, and increment it
	iny
	lda (tmp0),y	; read angle
	tax
	clc
	iny 
	adc (tmp0),y	; add speed
	dey
	sta (tmp0),y	; store angle
	lda _CosTable,x
	lsr
	clc
	;adc #20
	tax

	ldy #0
RastersDrawBigLoop
	; Get color
	lda (tmp1),y
	beq RastersDrawBigEnd

;BreakPoint jmp BreakPoint

	lda _RasterZ
	cmp	_BufferZ,x
	bmi RastersDrawBigLoopSkipZ

	sta _BufferZ,x

	lda (tmp1),y
	sta _BufferPaper,x

RastersDrawBigLoopSkipZ
	inx
	iny 
	jmp RastersDrawBigLoop

RastersDrawBigEnd
	rts




;typedef struct
;{
;	unsigned char *ptr_table;	+0
;	unsigned char prof;			+2
;	unsigned char y;			+3
;	unsigned char direction;	+4
;	unsigned char speed;		+5
;	unsigned char size_table;	+6
;}SMALLRASTER;


_RasterPointerSmall	.word 0


_RastersDrawSmall
	;BreakPoint jmp BreakPoint

	lda _RasterPointerSmall
	sta tmp0
	lda _RasterPointerSmall+1
	sta tmp0+1

	; Get color table pointer
	ldy #0
	lda (tmp0),y
	sta tmp1
	iny
	lda (tmp0),y
	sta tmp1+1

	; Read Z value
	ldy #2
	lda (tmp0),y
	sta _RasterZ

	; Get the position, and move it
	ldy #4
	lda (tmp0),y	; read direction
	bne RastersDrawSmallMoveUp

RastersDrawSmallMoveDown
	; direction=0
	clc
	ldy #3
	lda (tmp0),y	; read y
	ldy #5
	adc (tmp0),y	; speed
	ldy #3
	sta (tmp0),y	; write new y
	tax
	cmp #200-15
	bcc RastersDrawSmallMoveEnd

;BreakPoint jmp BreakPoint

	ldy #4
	lda #1
	sta (tmp0),y	; write direction
	
	jmp RastersDrawSmallMoveEnd

RastersDrawSmallMoveUp
	; direction=1
	sec
	ldy #3
	lda (tmp0),y	; read y
	ldy #5
	sbc (tmp0),y	; speed
	ldy #3
	sta (tmp0),y	; write new y
	tax
	cmp #5
	bcs RastersDrawSmallMoveEnd

	ldy #4
	lda #0
	sta (tmp0),y	; write direction

	jmp RastersDrawSmallMoveEnd


RastersDrawSmallMoveEnd

	
	lda (tmp0),y	; read y pos

	ldy #0
RastersDrawSmallLoop
	; Get color
	lda (tmp1),y
	beq RastersDrawSmallEnd

	lda _RasterZ
	cmp	_BufferZ,x
	bmi RastersDrawSmallLoopSkipZ

	sta _BufferZ,x

	lda (tmp1),y
	sta _BufferPaper,x
	and #7
	sta _BufferInk,x

RastersDrawSmallLoopSkipZ
	inx
	iny 
	jmp RastersDrawSmallLoop

RastersDrawSmallEnd
	rts




; LAST LINE (to avoid missing instruction bug)