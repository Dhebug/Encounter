;CeilingFloorCapture.s
;Capture height tables from embedded $1C bytes in hires image
	;Reset Tables
CaptureHeights
	ldx #39
.(
loop1	lda #00
	sta CeilingTable,x
	lda #59
	sta FloorTable,x
	dex
	bpl loop1
.)
	ldx #01
	lda #00
	sta OccurrenceFlag
.(
loop2	ldy #00
loop1
	lda SYLocl,y
	clc
	adc #40
	sta vector1+1
	sta vector2+1
	lda SYLoch,y
	adc #00
	sta vector1+2
	sta vector2+2
vector1	lda $dead,x
	cmp #$1C
	bne skip1
	lda #64
vector2	sta $dead,x
	lda OccurrenceFlag
	bne skip2
	tya
	sta CeilingTable,x
	lda #01
	sta OccurrenceFlag
	jmp skip1
skip2	tya
	sta FloorTable,x
	inc FloorTable,x
	lda #00
	sta OccurrenceFlag
	jmp skip3
skip1	iny
	cpy #59
	bcc loop1
skip3	lda #00
	sta OccurrenceFlag
	inx
	cpx #40
	bcc loop2
.)
	rts

DetermineContourMap
	ldx HeroY
DetermineContourMap2
	lda #<FloorTable
	sta ContourFloor
	lda #>FloorTable
	sta ContourFloor+1
	lda #<CeilingTable
	sta ContourCeiling
	lda #>CeilingTable
	sta ContourCeiling+1
	rts
