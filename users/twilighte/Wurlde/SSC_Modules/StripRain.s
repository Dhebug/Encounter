;Strip Rain - Rain that falls diagonally with trail of up to 8 pixels.
;Rain drops that are deleted from 0 to 7 steps behind when they are plotted.
;The only limit is that all strips travel as same velocity


;0123456789
;    h..t
;h==head
;t==tail
;.==body

MemoryTableX	;12-239
 .dsb 256,128
MemoryTableY	;0-58
 .dsb 256,128
 
StripHeadIndexes
 .dsb 32,0	;32 separate strips, each up to 8 pixels long, cycling 0-255
StripTailIndexes
 .dsb 32,0
StripParticleStatuses
 .dsb 32,128	;sets state of strip. 128==Inactive   0==Active
StripCurrentCount
 .byt 0		;The current number of active Strips
;Changing these values will change the behaviour over a period of time.
StripRainLimit
 .byt 31	;Sets limit of number of strips(Zero based)
NewStripLength
 .byt 7	;Sets length of any new strips generated
 
ProcStrips
	ldx #31
.(
loop1	lda StripParticleStatuses,x
	bmi skip1
	
	; Delete tail pixel
	jsr DeleteTail

	; Progress to next tail index
	dec StripTailIndexes,x
	
	; Check collision with Floor Table
	ldy StripHeadIndexes,x
	lda MemoryTableX,y
	tay
	lda xloc,y
	tay
	lda FloorTable,y
	ldy StripHeadIndexes,x
	cmp MemoryTableY,y
	bcc skip8	;Collision
	
	;Check collision with Left screen border
	lda MemoryTableX,y
	cmp #6
	bcc skip8	;Collision

	; Calculate new coords of head
	lda MemoryTableX,y
	sbc #2
	sta MemoryTableX,y
	lda MemoryTableY,y
	clc
	adc #2
	sta MemoryTableY,y
	
skip8	; End strip when Head Y == Tail Y
	ldy StripHeadIndexes,x
	lda MemoryTableY,y
	ldy StripTailIndexes,x
	cmp MemoryTableY,y
	bne skip9
TerminateStrip
	dec StripCurrentCount
	lda #128
	sta StripParticleStatuses,x
	jmp skip2
	
skip9	; Plot head pixel
	jsr PlotHead
	
	; Store new coords to memory tables
	ldy StripHeadIndexes,x
	lda NewX
	sta MemoryTableX,y
	lda NewY
	sta MemoryTableY,y
	
	dec StripHeadIndexes,x
	
	; Place 255 in memory index so that we can locate a free range easily later.
	ldy StripTailIndexes,x
	lda #255
	sta MemoryTableX,y
	sta MemoryTableY,y
	
skip2	; Progress to next strip
	dex
	bpl loop1
	rts

;Attempt to set up new strip
skip1	; Check strip limit
	lda StripCurrentCount
	cmp StripRainLimit
	bcs skip2

	; Can create new strip - Increment strip count
	inc StripCurrentCount
	
	; Locate free range in memory table
	ldy #00

loop2	lda MemoryTableX,y
	cmp #255
	bne skip4
	;Need to remember range Head and Tail?
	inc RangeCount
	lda RangeCount
	cmp NewStripLength
	bcs skip5	;Found Range
	jmp skip3
skip4	lda #00
	sta RangeCount
skip3	iny
	bne loop2
	;No Range Found - This should never happen!
	jmp skip2

skip5	; Store strip tail indexes
	tya
	sta StripTailIndexes,x
	; Strip Head is tail-NewStripLength
	sec
	sbc NewStripLength
	sta StripHeadIndexes,x
	
	; randomise Head coord
	; A Strip may either begin its journey from a random x position from the top of the screen
	; or a random Y position from the right of the screen but a height limit of floortable+39
	; is always observed.
	;  (12-239(Step2),0 or 239,0-58(Step1)) 114+59 == 173
	lda #172
	jsr getrand
	cmp #114
	bcs RightStrip
	;Top Strip - Adjust to 12-239(Step2)
	asl
	adc #12
	tay	;y==xpos
	lda #00	;a==ypos
	jmp skip6
RightStrip
	; Reduce to 0-58
	sbc #114	;a==ypos
	;Then compare against floortable height
	cmp FloorTable+39
	bcc skip7
	;And if exceeding set to -5 of floor
	lda FloorTable+39
	sbc #5
skip7	ldy #239	;y==xpos

skip6	; fill range with coords
	sta newYpos
	sty newXpos
	ldy StripHeadIndexes,x
loop3	lda newXpos
	sta MemoryTableX,y
	lda newYpos
	sta MemoryTableY,y
	iny
	tya
	cmp StripTailIndexes,x
	beq loop3
	bcc loop3

	; Activate strip
	lda #00
	sta StripParticleStatuses,x
	
	;Proceed to next strip
	jmp skip2
.)

DeleteTail
	; Fetch Tail coords
	ldy StripTailIndexes,x
	lda MemoryTableY,y
	tay
	lda game_sylocl,y
	sta screen
	lda game_syloch,y
	sta screen+1
	ldy StripTailIndexes,x
	lda MemoryTableX,y
	tay
	lda MaskBitpos,y
.(
	sta vector1+1
	lda xloc,y
	tay
	
	;Delete Tail at screen location
	lda (screen),y
vector1	and #00
.)
	sta (screen),y
	rts
	
PlotHead
	; Fetch Head Coords
	ldy StripHeadIndexes,x
	lda MemoryTableY,y
	tay
	lda game_sylocl,y
	sta screen
	lda game_syloch,y
	sta screen+1
	ldy StripHeadIndexes,x
	lda MemoryTableX,y
	tay
	lda Bitpos,y
.(
	sta vector1+1
	lda xloc,y
	tay
	
	;Plot Tail at screen location
	lda (screen),y
vector1	ora #00
.)
	sta (screen),y
	rts
