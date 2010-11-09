;Tape Routines
#define	CASS_SETUP6522	$E76A	;no 0 or 2
#define	CASS_OUTHEADER	$E607	;2F,024D(1==SLOW),02A7(HEADER),027F(FILENAME)
#define	CASS_OUTFILE	$E62E	;33-34
#define	CASS_RESET6522	$F9AA	;NO 0 OR 2
#define	CASS_RESETIRQ	$EDF9	;NO 0 OR 2

#define	CASS_INHEADER	$E4AC	;024D,2F,2B1,0293-(READ FN),21F,C-D,25F,25E
#define	CASS_INFILE	$E4E0	;25B,25C,25D

;Following locs used by rom tape routines
;page 0
;2F
;33
;34
;0C
;0D
;page 2
;021F
;024D
;025B-025F
;027F-028E
;0293-02A2
;02A7-02B1
GenerateChecksum	;255 not including checksum itself
	ldx #1
	txa
	clc
.(
loop1	adc GameDataStart-1,x
	inx
	bne loop1
.)
	rts
	
	
;The Room.s data hold all information about the content of every room in the game.
;This also includes flags to indicate whether a piece of furniture has already been
;searched(plundered) and the position of every platform lift in the rooms.
;We could just save the room data(which would be easy) but then at the cost of a 4K file.
;So instead we extract just the information we need into same game tables.
;Instead of 4K we can store everything in 113 bytes.
ExtractRoomLiftPositions
	;Flag we want to extract
	lda #1
	sta erl_ExtractFlag
LocateRoomLiftsAndAct
	lda #00
	sta GameLiftPositionsTableIndex
	sta PlunderedIndex
	lda #128
	sta PlunderedBitCount
	ldx #31	;Index by room
.(
loop2	cpx #ROOM_SIMON
	bne skip10
	jmp EndOfRoom
skip10	lda RoomAddressLo,x
	sta source
	lda RoomAddressHi,x
	sta source+1
	;We'll also use just y to index the bytes in the room since no room exceeds 256 bytes
	ldy #00
loop1	lda (source),y
	beq EndOfRoom
	cmp #LIFTPLATFORMS
	bne skip1
	;LIFTPLATFORMS	G(0-7),DL(Bitmap),CL(Bitmap)
	iny
	;Y indexes Group here
	iny
	;Y indexes DL(Default Lift position)
	iny
	;Y now indexes CL(Current Lift position)
	lda erl_ExtractFlag
	bne skip2
	;We're embedding (CLOAD) so pull and store
	sty Temp01
	ldy GameLiftPositionsTableIndex
	lda LiftPositionBuffer,y
	ldy Temp01
	sta (source),y
	jmp skip4
skip2	;We're extracting (CSAVE)
	lda (source),y
	sty Temp01
	ldy GameLiftPositionsTableIndex
	sta LiftPositionBuffer,y
	ldy Temp01
skip4	inc GameLiftPositionsTableIndex
	;next byte 
skip3	iny
	jmp loop1
skip1	cmp #FURNITURE_
	bne skip5
	;Ensure its not the simon console, Doorway or Terminal
	iny
	iny
	iny
	lda (source),y
	cmp #SIMONCONSOLE
	beq skip5
	cmp #TERMINAL_
	beq skip5
	cmp #DOORWAY
	beq skip5
	;Ok its a proper piece of furniture, so decide if we're extracting or embedding
	lda erl_ExtractFlag
	bne skip11
	;Embedding - Fetch plundered flag from block
	stx Temp01
	ldx PlunderedIndex
	lsr GamePlunderedBits,x
	
	;Transfer to room
	lda (source),y
	and #127
	bcc skip7
	ora #128
skip7	sta (source),y

	jmp skip8
skip11	;Extract - Fetch plundered flag from room into carry
	lda (source),y
	asl
	
	;transfer to block
	stx Temp01
	ldx PlunderedIndex
	ror GamePlunderedBits,x
skip8	lsr PlunderedBitCount
	bcc skip6
	ror PlunderedBitCount
	inc PlunderedIndex
skip6	ldx Temp01
	iny
	jmp loop1
	
skip5	sta Temp01
	tya
	ldy Temp01
	clc
	adc CommandBytes,y
	tay
	jmp loop1
EndOfRoom	dex
	bmi skip9
	jmp loop2
skip9	rts
.)

	
ShowSavingText
ShowLoadingText
	;Show text on 5th Line - plot 636363 to left
	ldx #5
.(
loop1	ldy ScreenOffset,x
	lda TextShowColour,x
	sta $A000+5+40*188,y
	dex
	bpl loop1
.)
	rts
TextShowColour
 .byt 6,3,6,3,6,3
	
Setup4Cass
	;All cassette operations do not use cpu activated interrupts. instead they rely on strobing
	;So we can disable cpu interrupts which also means we need not worry about other irq stuff
	sei
	
	;Set Screenmode flag to HIRES
	ldx #1
	stx $021F
	
	;Set Tape speed to Fast
	dex
	stx $024D
	
	;Transfer Header, filename and Zpage stuff and clear Join flags etc.
.(	
loop1	lda Tape_HeaderInfo,x
	sta $02A8,x
	lda EthanX,x
	sta Game_EthanX,x
	lda #00
	sta $025A,x
	lda Tape_Filename,x
	sta $027F,x
	beq skip1
	inx
	bne loop1
skip1	;
.)
	rts

SaveGame	;"PRESS RECORD ON"
	;"TAPE THEN PRESS"
	;"     SPACE     "
	;"               "
	;" SAVING GAME.. "
	;
	lda #6
	jsr DisplayMenuScreen
	jsr ClearOutInputBuffer
.(
loop1	lda InputRegister
	beq loop1
.)
	jsr ShowSavingText
CsaveGame	jsr Setup4Cass
	jsr ExtractRoomLiftPositions
	jsr GenerateChecksum
	sta Game_Checksum

	;Set 6522 for Cassette Operation
	jsr CASS_SETUP6522
	
	;Output Header to tape
	jsr CASS_OUTHEADER
	
	;out file
	jsr CASS_OUTFILE
	
	;reset status
	jsr CASS_RESET6522
	jsr ResetIRQ
	jsr SetupIRQ
	cli
	rts
	
ResetIRQ	pha
	jmp CASS_RESETIRQ
	
LoadGame
	;Loading a game means this is jumped to from wherever and we must both load the game
	;and set ethan back in the lift corridor where he was at game save
	;
	;" PRESS PLAY ON "
	;"     TAPE      "
	;"               "
	;"  SEARCHING..  "
	;" LOADING GAME.."
	;
	lda #1
	sta GamePaused

	lda #5
	jsr DisplayMenuScreen
CloadGame
	jsr Setup4Cass

	;Show Text on 4th line - plot 636363 to left
	ldx #5
.(
loop1	ldy ScreenOffset,x
	lda TextShowColour,x
	sta $A000+5+40*180,y
	dex
	bpl loop1
.)
	;
	jsr CASS_SETUP6522

	;
	jsr CASS_INHEADER

	;Report Loading
	;Hide text on 4th line - plot 000000 to left
	lda #0
	ldx #5
.(
loop1	ldy ScreenOffset,x
	sta $A000+5+40*180,y
	dex
	bpl loop1
.)
	
	jsr ShowLoadingText
	;We don't really have time to update a whole row of HIRES characters so 
	;
	jsr CASS_INFILE

	;reset status
	jsr CASS_RESET6522
	jsr ResetIRQ
	
	;Check checksum(very important we don't mess up game data)
	jsr GenerateChecksum
	cmp Game_Checksum
	bne LoadGame
	
	;Embed LiftPositionBuffer back into Rooms
	lda #00
	sta erl_ExtractFlag
	jsr LocateRoomLiftsAndAct
	
	;Transfer game Zpage vars back into zpage
	ldx #8
.(
loop1	lda Game_EthanX,x
	sta EthanX,x
	dex
	bpl loop1
.)
	;Restore original irq speed
	jsr SetupIRQ
	
	;display loaded game vars in score panel

	;Display Audio state
	jsr DisplayAudioState
	
	;Display Difficulty level
	jsr DisplayDifficulty
	
	;If the Colourscheme is different than before we'll need to update shaft colours
	jsr SetScreenColours
	
	;Display Score
	jsr Display_Score
	
	;Display Lift Resets
	jsr Display_LiftResets
	
	;Display Robot Snoozes
	jsr Display_RobotSnoozes
	
	;Display Password
	jsr DisplayPassword
	
	;Display Time remaining
	jsr DisplayHours
	jsr DisplayMinutes
	jsr DisplaySeconds
	ldx #0
	stx GamePaused
	stx InputRegister
	stx DisplayingSearchResult
	stx LiftStatus
	stx SearchingStatus
	inx	;IN_CORRIDOR
	stx EthansLocation
	

	;Now restore back to Ethan in lift at current location
	ldx GameStartsStackPointer
	txs
	
	jmp EntryAfterLoadOldGame


Tape_HeaderInfo
 .byt 0			;2a8 -
 .byt <GameDataStart 	;2a9 Start Address Lo
 .byt >GameDataStart 	;2aa Start Address Hi
 .byt <GameDataEnd   	;2ab End Address Lo
 .byt >GameDataEnd		;2ac End Address Hi
 .byt 0   		;2ad Program Type (0)
 .byt 0   		;2ae Auto Indicator (0 for off)
 .byt 0   		;2af Array Type
 .byt 0   		;2b0 -
Tape_Filename	;Filename is made same length as header only because optimisation in code
 .byt "IMGAMEFL",0
OpcodeData
 .byt >IM_IRQ
 .byt <IM_IRQ
 .byt $4C
