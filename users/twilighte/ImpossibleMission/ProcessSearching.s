;ProcessSearching

ProcessSearching
	;Check on Robot or Spark collision
	;Update Search progress
	ldx CollisionFurnitureSequenceID
	lda RoomFurniturePiece_SearchProgress-8,x
	clc
	adc SearchStep
	cmp #36
	bcs ProgressFinish
	sta RoomFurniturePiece_SearchProgress-8,x
	
	;Display Bar within progressbar gfx
	tax
	lda SearchProgressBar_Byte0,x
	sta SearchWindowBarLocationStart
	lda SearchProgressBar_Byte1,x
	sta SearchWindowBarLocationStart+1
	lda SearchProgressBar_Byte2,x
	sta SearchWindowBarLocationStart+2
	lda SearchProgressBar_Byte3,x
	sta SearchWindowBarLocationStart+3
	lda SearchProgressBar_Byte4,x
	sta SearchWindowBarLocationStart+4
	lda SearchProgressBar_Byte5,x
	sta SearchWindowBarLocationStart+5
	lda SearchProgressBar_Byte6,x
	sta SearchWindowBarLocationStart+6
	
	;Display progress bar
	jsr CalculateSearchWindowPosition
	lda #SEARCHWINDOWGFX
	sta Object_V
	jmp DisplayGraphicObject


CalculateSearchWindowPosition
	lda EthanX
	sec
	sbc #2
	;Ensure it is within screen bounds
.(
	cmp #2
	bcs skip2
	lda #02
	jmp skip1
skip2	cmp #33
	bcc skip1
	lda #32
skip1	sta Object_X
.)
	lda EthanY
	sec
	sbc #10
	sta Object_Y
	rts

ProgressFinish
	;Remove Search window
	jsr CalculateSearchWindowPosition
	lda #SEARCHWINDOWGFX
	sta Object_V
	jsr RestoreObjectsBackground
	jsr RedisplayLifts
	
	;Remove furniture from screen, bgbuffer and collision map
	jsr RemoveFurniture
	
	;Update stats
	lda FoundOnceFlag
.(
	bne skip1
	inc Stats_FurnitureCount
	;Award 5 points
	lda #5
	jsr AddUnitsScore
skip1
.)

	;Reset Ethan frame to standing
	jsr DeleteEthan
	lda #ETHAN_STANDING
	sta EthanFrame
	
	;Tie ethan to the current level
	jsr TieEthan2Platform
;	ldx EthanFrame
;	ldy EthansCurrentLevel
;	lda PlatformYPOS,y
;	sec
;	sbc EthanFrameYOffset,x
;	sta EthanY

	;Redisplay Ethan
	jsr PlotEthan
	
	;Fetch puzzle piece flag for this piece of furniture (Held in B6 of Rooms Furniture ID)
	ldy CurrentFurnitureRoomIndex
	lda (room),y
	asl
.(
	bpl skip1
FoundPuzzlePiece
	;Display 
	ldx #ROOMTEXT_FOUNDPUZZLEPIECE
	jsr DisplayRoomText

	;Update stats
	inc Stats_PuzzleCount
	
	;Add score
	lda #1
	jsr AddHundredsScore

	;Fetch the puzzle piece from the 4th byte in (room)
	ldy #3
	lda (room),y
	
	clc
	adc #PUZZLEPIECE00
	;store puzzle piece in PuzzleMemory
	inc UltimateMemoryListIndex
	ldx UltimateMemoryListIndex
	sta PuzzleMemory,x	;holds up to 28 puzzle pieces

	;Display Puzzle piece
	jmp DisplaySearchResult
	
skip1	;Does this FurnitureID hold a bonus flag?
.)
	asl
	bpl AwardNothing
	
	;Decide which bonus to award
	jsr GetRandomNumber
	and #1
	
	;0   Lift Reset
	;1   Robot Snooze
	beq AwardReset
	jmp AwardSnooze
	
AwardNothing
	;Display this message once
	lda FoundOnceFlag
.(
	bne skip1
	inc FoundOnceFlag
	ldx #ROOMTEXT_FOUNDNOTHING
	jsr DisplayRoomText
skip1	rts
.)	
	
AwardReset
	;Found Lift-reset
	ldx #ROOMTEXT_FOUNDLIFTRESET
	jsr DisplayRoomText
	
	;Trigger "Found Lift-Reset" SFX Here
	inc LiftResets
	jsr Display_LiftResets
	
	;Award 50 to score
	lda #$50
	jsr AddUnitsScore
	
	lda #SEARCHFOUNDRESETLIFTGFX
	jmp DisplaySearchResult
	
AwardSnooze
	;Found Snooze
	ldx #ROOMTEXT_FOUNDSNOOZE
	jsr DisplayRoomText

	;Trigger "Found Robot Snooze" SFX Here
	inc RobotSnoozes
	jsr Display_RobotSnoozes
	
	;Award 50 to score
	lda #$50
	jsr AddUnitsScore

	lda #SEARCHFOUNDSNOOZEDROIDGFX

DisplaySearchResult
;	nop
;	jmp DisplaySearchResult
	;We display the search result for a period of 4 game cycles
	ldx #SEARCH_OFF
	stx SearchingStatus
	ldx #1
	stx DisplayingSearchResult
	sta Object_V
	jsr CalculateSearchWindowPosition
	lda Object_X
	sta DisplayingSearchResultX
	lda Object_Y
	sta DisplayingSearchResultY
	jmp DisplayGraphicObject

DisplayingSearchResultEnd
	lda DisplayingSearchResultX
	sta Object_X
	lda DisplayingSearchResultY
	sta Object_Y
	lda #SEARCHWINDOWGFX
	sta Object_V
	jmp RestoreObjectsBackground
	
RemoveFurniture
;	nop
;	jmp RemoveFurniture
	;Remove furniture from BGBuffer
	ldy CurrentFurnitureRoomIndex
;	ldy RoomFurniturePiece_RoomIndex,x
	lda (room),y
	;Also set furniture as Plundered
	ora #128
	sta (room),y
	and #31
	clc
	adc #BASEOFFURNITURE
	sta Object_V
	dey
	;Fetch Y from (room) which is 1,3,5 or 7
	lda (room),y
	tax
	;Convert to platform(pixel)y
	lda PlatformYPOS,x
	;subtract height of furniture
	ldx Object_V
	sec
	sbc Object_Height,x
	sta Object_Y
	;Fetch X
	dey
	lda (room),y
	sta Object_X
	jsr EraseObjectsBackground
	
	;Remove Furniture from screen
	jsr RestoreObjectsBackground
	
	;Remove furniture from Collision map
	ldx Object_V
	lda Object_Width,x
	sta Object_W
	lda FurnitureCollisionHeight-122,x
	sta Object_H
	lda #00
	sta Object_V
	jmp PlotCollisionObject

Switch2SearchFurniture	;Called from Ethan.s to begin searching a piece of furniture
	;A holds Furniture ID
	;X Collision value (Furniture sequence ID)
	;Y holds index within (room) to furnitureID (X,Y,>FurnitureID<)
	sty CurrentFurnitureRoomIndex
	;The search progress will already have been set up in PlotRoom.s(when the furniture was plotted)
	tay
	;Use it to determine the search delay
	lda FurnitureSearchStep,y
	sta SearchStep
	stx CollisionFurnitureSequenceID
	lda #SEARCH_ON
	sta SearchingStatus
	lda #ETHAN_STANDING
	sta EthanFrame

	jsr DeleteEthan
	lda #ETHAN_SEARCHING
	sta EthanFrame
	
	;Tie ethan to the current level
	jsr TieEthan2Platform
	
	lda #00
	sta FoundOnceFlag

	jmp PlotEthan


SearchProgressBar_Byte0
 .byt $EB,$E9,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
 .byt $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
SearchProgressBar_Byte5
 .byt $FF,$FF,$FF,$FF,$FF,$FF
SearchProgressBar_Byte4 
 .byt $FF,$FF,$FF,$FF,$FF,$FF
SearchProgressBar_Byte3 
 .byt $FF,$FF,$FF,$FF,$FF,$FF
SearchProgressBar_Byte2 
 .byt $FF,$FF,$FF,$FF,$FF,$FF
SearchProgressBar_Byte1 
 .byt $FF,$FF,$FF,$DF,$CF,$C7,$C3,$C1,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
 .byt $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
SearchProgressBar_Byte6
 .byt $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
 .byt $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$DD,$CD,$C5

	
	
	
	