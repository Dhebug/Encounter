;ScreenCopy
;Scans SSC screen extracting embedded heights and collisions and copying
;to screen and background buffer

;Vl Es Collision
;00 20 No Collision
;01 21 Left Exit
;02 22 Right Exit
;03 23 Wall
;04 24 Death
;05 25-3F Screen Specific

;Vl == Hex Value | Es Embedded Sentinel

ScreenCopy
	;Calculate Collision Table Locations
	lda ssc_CollisionTablesLo
	sta ContourCeiling
	clc
	adc #40
	sta ContourFloor
	adc #40
	sta ContourCollision
	lda ssc_CollisionTablesHi
	sta ContourCeiling+1
	sta ContourFloor+1
	sta ContourCollision+1

	;Setup Capture and Copy
	lda ssc_ScreenInlayLo
	sta source
	lda ssc_ScreenInlayHi
	sta source+1
	lda #<HIRESInlayLocation
	sta screen
	lda #>HIRESInlayLocation
	sta screen+1
	lda #<BackgroundBuffer
	sta bgbuff
	lda #>BackgroundBuffer
	sta bgbuff+1

	ldx #00	;-119
.(
loop2	ldy #39

loop1	; Fetch Inlay Byte
	lda (source),y

	; Embedded?
	and #127
	cmp #64
	bcs skip1
	cmp #32
	bcc skip1

	; Embedded Level?
	lda (source),y
	bpl skip2

	; Ceiling or Floor?
	lda (ContourCeiling),y
	bpl skip3
	txa
	lsr
	sta (ContourCeiling),y
	jmp skip2
skip3	txa
	lsr
	sta (ContourFloor),y

skip2	; Embedded Collision?
	lda (source),y
	and #127
	cmp #33
	bcc skip4

	; Reduce to 0 base
	sbc #32
	sta (ContourCollision),y

skip4	; Default to 64
	lda #64
	jmp rent1

skip1	; Capture Inlay to Store
	lda (source),y

rent1	; Store to screen
	sta (screen),y

	; Background Row?
	txa
	lsr
	bcc skip5

	; Store to BGB
	lda (screen),y
	dey
	bmi skip7
	sta (bgbuff),y
skip7	iny

skip5	; Progress Column
	dey
	bpl loop1

	; Progress bgbuff row by 40(if BGB row)
	bcc skip6
	jsr nl_bgbuff

skip6	; Progress screen row by 40
	jsr nl_screen

	; Progress source row by 40
	jsr nl_source

	; Progress Row Counter
	inx
	cpx #120
	bcc loop2
.)
	rts
