;RandomiseGame.s

;1)Randomise Map of rooms
;2)Randomise puzzle piece graphics mirror/flip and colours
;3)Randomise Robot behaviours
RandomiseGame
	jsr GenerateRandomRoomMap
	jsr RandomiseOrientationOfPuzzlePieces
	jsr RandomisePuzzleGroupColours
	jsr RandomiseDroidBehaviours
	jmp RandomisePuzzlePieces
	
;Their are 28 puzzle pieces to find and 31 rooms(32nd room is simon computer)
;The 4th byte of the room(in the entrance block) specifies the puzzle piece
;associated to a room.
;The 6th bit of the Furniture ID indicates this piece contains the puzzle piece.

;Method..
;Run through first 28 rooms assigning a puzzle piece to a random piece of furniture.
RandomisePuzzlePieces
	;
	
	;Process up to 32 rooms(Some rooms have no furniture in them)
	lda #00
	sta FurnitureID_Counter
	ldx #31
.(	
loop2	;Scan this room for furniture
	lda RoomAddressLo,x
	sta room
	lda RoomAddressHi,x
	sta room+1
	stx Temp01
	
	;Avoid Simon Computer room
	cpx #ROOM_SIMON
	beq skip3
	
	;Reset flag in byte 4 of room
;	ldy #3
;	lda #00
;	sta (room),y
	
	ldy #255
	sty TempFurnitureTableIndex
	
loop5	iny
loop1	lda (room),y
	cmp #END
	beq skip2
	cmp #FURNITURE_
	bne skip1
	;Avoid Terminal or FinalDoor
	iny
	iny
	iny
	lda (room),y
	;Also take this moment to filter plundered and puzzle piece flags
	and #%00011111
	sta (room),y
	cmp #TERMINAL_
	beq skip8
	cmp #DOORWAY
	beq skip8
	cmp #SIMONCONSOLE
	beq skip8
	;Store Furniture Index in temp table
	inc TempFurnitureTableIndex
	ldx TempFurnitureTableIndex
	sty TempRoomFurnitureList,x
skip8	;Proceed to next command
	jmp loop5
skip1	tax
	tya
	clc
	adc CommandBytes,x
	tay
	jmp loop1
skip2	;Did this room contain Furniture?
	ldx TempFurnitureTableIndex
	bmi skip3
	beq skip6
	;Select random index between zero and TempFurnitureTableIndex(x) which may be 11
loop3	jsr GetRandomNumber
	and #15	;Reduce odds of getting it wrong
	cmp TempFurnitureTableIndex
	beq skip5
	bcs loop3
skip5	tax
skip6	;Store Puzzle in furniture
	ldy TempRoomFurnitureList,x
	lda (room),y
	ora #%01000000
	sta (room),y
	;Store puzzle piece in room
	ldy #3
	lda FurnitureID_Counter
	sta (room),y
	;increment Puzzle Piece
	inc FurnitureID_Counter
	;Check furniture piece does not exceed 28
	lda FurnitureID_Counter
	cmp #28
	bcs skip4
	;Stick a bonus item in one other piece of furniture
	lda TempFurnitureTableIndex
	beq skip3	;Only one piece of furniture
	stx TempFurnitureWithPuzzle
loop4	jsr GetRandomNumber
	and #15	;Reduce odds of getting it wrong
	cmp TempFurnitureTableIndex
	beq skip7
	bcs loop4
	cmp TempFurnitureWithPuzzle
	beq loop4
skip7	tax
	ldy TempRoomFurnitureList,x
	lda (room),y
	ora #%00100000
	sta (room),y
skip3	;Proceed to next room
	ldx Temp01
	dex
	bmi rent1
	jmp loop2
	;done all rooms but puzzle pieces left!!
rent1	nop
	jmp rent1
skip4	;All puzzle pieces used
.)
	rts

RandomiseDroidBehaviours
	ldx #31
.(
loop2	lda RoomAddressLo,x
	sta room
	lda RoomAddressHi,x
	sta room+1
	
	;Now scan room to END
	ldy #00
loop1	lda (room),y
	beq skip1
	cmp #DROID
	bne skip2
	iny
	iny
	iny
	iny
	jsr GetRandomNumber
	and #3
	sta (room),y
	iny
	jmp loop1
skip2	sta Temp01
	tya
	ldy Temp01
	clc
	adc CommandBytes,y
	tay
	jmp loop1

skip1	;Proceed to next room
	dex
	bpl loop2
.)
	rts
	 
RandomisePuzzleGroupColours
	ldx #6
	;Randomise colour
.(
loop1	jsr GetRandomNumber
	and #3
	cmp #3
	bcs loop1
	sta Temp01
	;Randomise mirror and flip position
	jsr GetRandomNumber
	and #%00001100
	ora Temp01
	sta PunchCardProperty,x
	dex
	bpl loop1
.)
	rts

RandomiseOrientationOfPuzzlePieces
	ldx #54
.(	
loop1	stx Temp01
	
	;Fetch graphics address of puzzle piece
	jsr FetchPuzzleGraphicAddressIntoSource
	
	;Randomise Flip
	jsr GetRandomNumber
	and #1
	beq skip1
	
	jsr FlipGraphic
	
skip1	;Randomise Mirror
	jsr GetRandomNumber
	and #1
	beq skip2
	ldx Temp01
	
	;Fetch graphics address of puzzle piece
	jsr FetchPuzzleGraphicAddressIntoSource
	
	jsr MirrorGraphic
	
skip2	ldx Temp01
	
	dex
	cpx #27
	bcs loop1
.)
	rts	
FlipBuffer
 .dsb 32,0	
	
FlipGraphic
	;Toggle Flip Bit
	lda PuzzlePieceProperties-27,x
	eor #BIT6
	sta PuzzlePieceProperties-27,x
	
	;Flip 4x8 graphic in (source) using buffer
	lda #<FlipBuffer+28
	sta screen
	lda #>FlipBuffer+28
	sta screen+1
	ldx #8
.(
loop2	ldy #3
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #4
	jsr AddSource
	lda #4
	jsr SubScreen
	dex
	bne loop2
.)
	;Restore graphic address
	ldx Temp01
	jsr FetchPuzzleGraphicAddressIntoSource

	;Now copy buffer back to puzzle graphic
	ldy #31
.(
loop1	lda FlipBuffer,y
	sta (source),y
	dey
	bpl loop1
.)
	rts

FetchPuzzleGraphicAddressIntoSource
	lda Object_AddressLo,x
	sta source
	lda Object_AddressHi,x
	sta source+1
	rts


MirrorGraphic
	;Toggle Mirror Bit
	lda PuzzlePieceProperties-27,x
	eor #BIT7
	sta PuzzlePieceProperties-27,x

	;Mirror 4x8 graphic in (source)
	lda #8
	sta RowCount
.(	
loop1	ldy #3
	jsr FetchMirroredByte
	pha
	ldy #00
	jsr FetchMirroredByte
	ldy #3
	sta (source),y
	ldy #00
	pla
	sta (source),y
	
	ldy #2
	jsr FetchMirroredByte
	pha
	dey
	jsr FetchMirroredByte
	iny
	sta (source),y
	dey
	pla
	sta (source),y
	
	lda #4
	jsr AddSource
	dec RowCount
	bne loop1
.)
	rts	
	
FetchMirroredByte
	lda (source),y
	tax
	lda Mirror64-64,x
	ora #64
	rts
