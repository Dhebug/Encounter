;PocketComputer.s
;q M      f m r
;o M W    c c c
;t M      s j p

;q Quit		Quit From Pocket Computer
;M Memory		Puzzle piece Memory
;W Work Area	Puzzle Piece work area(1)
;f Flip		Flip Puzzle piece
;m Mirror		Mirror  Puzzle piece
;r Delete		Remove selected Puzzle Piece from memory (splitting back into parts if merged)
;o Merge		Overlay the two puzzle pieces in the work area
;c Colour		Change the selected work area puzzle piece colour
;t Modem Menu	Go to the modem menu
;s Speaker	Sound On/Off
;j Joystick	Controller selection
;p Pause		Pause the game

;The cursor for the work area and memory is separate to the buttons
;For buttons
;LEFT	Navigate
;RIGHT	Navigate
;UP	Navigate
;DOWN	Navigate
;FIRE1	Select
;For Puzzle Memory(Push scroll)
;UP	Move up list or push scroll
;DOWN	Move Down list or push scroll
;LEFT	Navigate away
;RIGHT	Navigate away
;FIRE1	Move piece into work area or swap with currently selected work area piece
;For Puzzle Work area
;UP	Select Top Piece
;DOWN	Select Bottom Piece
;LEFT	Navigate away
;RIGHT	Navigate away
;For Telephone Menu
;UP	Move up
;DOWN	Move Down
;FIRE1	Select option
;PUZZLEMEMORY
; .byt 27,28,29,30,31,32,33,34,35
; .dsb 19,0

PocketControl
	jsr CapturePocketButtons
	jsr CLS
	jsr DisplayPuzzleScreen
	jsr PlotPocketCursor
	lda #SFX_MIDBEEP
	jsr KickSFX
.(
loop1	jsr WaitOnKey_NoRepeat
	
	and #CONTROLLER_LEFT
	beq skip1
	
	ldx CursorX
	lda PocketComputerLeftVectorLo,x
	sta vector1+1
	lda PocketComputerLeftVectorHi,x
	beq loop1
	sta vector1+2
	jsr DeletePocketCursor
vector1	jsr $dead
	jmp loop1
	
skip1	lda InputRegister
	and #CONTROLLER_RIGHT
	beq skip2
	
	ldx CursorX
	lda PocketComputerRightVectorLo,x
	sta vector2+1
	lda PocketComputerRightVectorHi,x
	beq loop1
	sta vector2+2
	jsr DeletePocketCursor
vector2	jsr $dead
	jmp loop1

skip2	lda InputRegister
	and #CONTROLLER_UP
	beq skip3
	
	ldx CursorX
	lda PocketComputerUpVectorLo,x
	sta vector3+1
	lda PocketComputerUpVectorHi,x
	beq loop1
	sta vector3+2
	jsr DeletePocketCursor
vector3	jsr $dead
	jmp loop1

skip3	lda InputRegister
	and #CONTROLLER_DOWN
	beq skip4
	
	ldx CursorX
	lda PocketComputerDownVectorLo,x
	sta vector4+1
	lda PocketComputerDownVectorHi,x
	beq loop1
	sta vector4+2
	jsr DeletePocketCursor
vector4	jsr $dead
	jmp loop1

skip4	lda InputRegister
	and #CONTROLLER_FIRE1
	beq skip5
	
	ldx CursorX
	lda PocketComputerSelectVectorLo,x
	sta vector5+1
	lda PocketComputerSelectVectorHi,x
	beq skip5
	sta vector5+2
	jsr DeletePocketCursor
vector5	jsr $dead

skip5	jmp loop1
.)

;All indexed by CursorX(0-4)
PocketComputerLeftVectorLo
 .byt 0
 .byt <PuzzleMemoryLeft
 .byt <ButtonLeft
 .byt <ButtonLeft
 .byt <ButtonLeft
PocketComputerLeftVectorHi
 .byt 0
 .byt >PuzzleMemoryLeft
 .byt >ButtonLeft
 .byt >ButtonLeft
 .byt >ButtonLeft
PocketComputerRightVectorLo
 .byt <ButtonRight
 .byt <PuzzleMemoryRight
 .byt <ButtonRight
 .byt <ButtonRight
 .byt 0
PocketComputerRightVectorHi
 .byt >ButtonRight
 .byt >PuzzleMemoryRight
 .byt >ButtonRight
 .byt >ButtonRight
 .byt 0
PocketComputerUpVectorLo
 .byt <ButtonUp
 .byt <PuzzleMemoryUp
 .byt <ButtonUp
 .byt <ButtonUp
 .byt <ButtonUp
PocketComputerUpVectorHi
 .byt >ButtonUp
 .byt >PuzzleMemoryUp
 .byt >ButtonUp
 .byt >ButtonUp
 .byt >ButtonUp
PocketComputerDownVectorLo
 .byt <ButtonDown
 .byt <PuzzleMemoryDown
 .byt <ButtonDown
 .byt <ButtonDown
 .byt <ButtonDown
PocketComputerDownVectorHi
 .byt >ButtonDown
 .byt >PuzzleMemoryDown
 .byt >ButtonDown
 .byt >ButtonDown
 .byt >ButtonDown
PocketComputerSelectVectorLo
 .byt <ButtonSelect
 .byt <PuzzleMemorySelect
 .byt <ButtonSelect
 .byt <ButtonSelect
 .byt <ButtonSelect
PocketComputerSelectVectorHi
 .byt >ButtonSelect
 .byt >PuzzleMemorySelect
 .byt >ButtonSelect
 .byt >ButtonSelect
 .byt >ButtonSelect

PlotPocketCursor
	ldx CursorX
	lda #<PlotPuzzleCursor
	ldy #>PlotPuzzleCursor
	cpx #1
.(
	beq skip1
	lda #<PlotButtonDown
	ldy #>PlotButtonDown
skip1	sta vector0+1
	sty vector0+2
vector0	jmp $dead
.)

DeletePocketCursor
	ldx CursorX
	lda #<DeletePuzzleCursor
	ldy #>DeletePuzzleCursor
	cpx #1
.(
	beq skip1
	lda #<RestorePocketButtons
	ldy #>RestorePocketButtons
skip1	sta vector0+1
	sty vector0+2
vector0	jmp $dead
.)


ShareButtonsCursorX
	lda CursorY,x
	sta CursorY
	sta CursorY+2
	sta CursorY+3
	sta CursorY+4
	rts

PuzzleMemoryLeft
;	jsr PlotPocketCursor
	dec CursorX
	jmp PlotPocketCursor
ButtonLeft
	ldx CursorX
	dec CursorX
	jsr ShareButtonsCursorX
	jmp PlotPocketCursor
ButtonRight
	;Ensure all CursorY's for buttons remain the same
	ldx CursorX
	inc CursorX
	jsr ShareButtonsCursorX
	jmp PlotPocketCursor
PuzzleMemoryRight
;	jsr PlotPocketCursor
	inc CursorX
	jmp PlotPocketCursor
ButtonUp
	ldx CursorX
	lda CursorY,x
.(
	beq skip1
	dec CursorY,x
skip1	jmp PlotPocketCursor
.)

ButtonDown
	ldx CursorX
	lda CursorY,x
.(
	cmp #2
	bcs skip1
	inc CursorY,x
skip1	jmp PlotPocketCursor
.)

PuzzleMemoryDown
	;potentially push scroll memory
	lda CursorY+1
	cmp #2
.(
	bcs skip1
	inc CursorY+1
	jmp PlotPocketCursor
skip1	clc
	adc PuzzleMemoryBase
	cmp UltimateMemoryListIndex
	bcs skip2
	lda UltimateMemoryListIndex
	bmi skip2
	inc PuzzleMemoryBase
	jsr PlotPuzzleMemoryPieces
	jmp CheckMemoryArrows
skip2	lda #SFX_LOWBEEP
	jsr KickSFX
	jmp PlotPocketCursor
.)
PuzzleMemoryUp
	;potentially push scroll memory
	lda CursorY+1
.(
	beq skip1
	dec CursorY+1
	jsr PlotPocketCursor
	jmp skip3
skip2	lda #SFX_LOWBEEP
	jsr KickSFX
	jmp skip3
skip1	lda PuzzleMemoryBase
	beq skip2
	dec PuzzleMemoryBase
	jsr PlotPuzzleMemoryPieces
skip3	;Now check memory arrows
.)
CheckMemoryArrows
	lda PuzzleMemoryBase
.(
	beq RemoveTopArrow
	jsr PlotPuzzleMemoryArrowUp
skip1	lda UltimateMemoryListIndex
	bmi RemoveBottomArrow
	lda PuzzleMemoryBase
	clc
	adc #2
	cmp UltimateMemoryListIndex
	bcc PlotBottomArrow
RemoveBottomArrow
	jsr DeletePuzzleMemoryArrowDown
	jmp PlotPocketCursor
RemoveTopArrow
	jsr DeletePuzzleMemoryArrowUp
	jmp skip1
PlotBottomArrow
	jsr PlotPuzzleMemoryArrowDown
	jmp PlotPocketCursor
.)

ButtonSelect
	;jump to operation
	
	;Calculate index
	lda CursorX
	tax
.(
	beq skip1
	sec
	sbc #1
skip1	;X becomes 0-3
	sta Temp01
	lda CursorY,x
	asl
	asl
	ora Temp01
	tay
	
	lda ButtonOperationVectorLo,y
	sta vector1+1
	lda ButtonOperationVectorHi,y
	sta vector1+2
vector1	jmp $dead
.)	

ButtonOperationVectorLo
 .byt <bo_Power	;0
 .byt <bo_Flip      ;1
 .byt <bo_Mirror    ;2
 .byt <bo_Undo      ;3
 .byt <bo_Disk      ;4
 .byt <bo_Orange    ;5  <
 .byt <bo_Green     ;6
 .byt <bo_White     ;7
 .byt <bo_Modem     ;8
 .byt <bo_Sound     ;9
 .byt <bo_Stats     ;10
 .byt <bo_Pause     ;11
ButtonOperationVectorHi
 .byt >bo_Power
 .byt >bo_Flip
 .byt >bo_Mirror
 .byt >bo_Undo
 .byt >bo_Disk
 .byt >bo_Orange
 .byt >bo_Green
 .byt >bo_White
 .byt >bo_Modem
 .byt >bo_Sound
 .byt >bo_Stats
 .byt >bo_Pause
	
bo_Power
	;SFX Power Off
	lda #SFX_LOWBEEP
	jsr KickSFX
	;Return to Corridor
	pla
	pla
	jsr lsm_RenderFullScreenBG
	jsr EyeOpenRoom
	;Wait until no keys
.(
loop1	lda InputRegister
	bne loop1
.)
	;Redisplay map of rooms and Re-enable glow
	jsr lsm_DisplayScoresComplexMap
	;Temporarily disable glowing(IRQ driven)
	jsr TurnOffGlow
	jmp DisplayRoomCursor2

;Attempt to Merge the selected memory list piece with the work area piece
bo_Merge
	;Check we have at least one puzzle piece already in work area
	lda UltimateWorkListIndex
.(
	bmi skip1
	
	;Check we have no more than 3
	cmp #3
	bcs skip1
	
	;Check we have selected a valid piece from the memory list
	lda PuzzleMemoryBase
	clc
	adc CursorY+1
	cmp UltimateMemoryListIndex
	beq skip3
	bcs skip1

skip3	pha
	
	;Redo existing merged work area
	jsr ReMergeWorkPuzzle

	;Now attempt to merge select puzzle piece (in Stack) with work area (merged) piece
	pla
	tay
	ldx PuzzleMemory,y
	jsr FetchPuzzleGraphicAddressIntoSource
	
	;Remember Y
	tya
	tax
	
	;Check for overlap between the memory piece and the work list pieces
	ldy #31
loop1	lda Object_WorkPuzzlePieceGraphic,y
	and #63
	and (source),y
	bne skip1		;Overlap Found
	dey
	bpl loop1
	
	;Remove piece from puzzle memory list
	ldy UltimateMemoryListIndex
	lda PuzzleMemory,x
	pha
	lda PuzzleMemory,y
	sta PuzzleMemory,x
	dec UltimateMemoryListIndex

	;Put puzzle piece into Work list
	pla
	inc UltimateWorkListIndex
	ldy UltimateWorkListIndex
	sta WorkMemory,y	;WORKMEMORY
	
	;Remerge work puzzle pieces
	jsr ReMergeWorkPuzzle

	;Display work area
	jsr DisplayWorkAreaPiece
	
	;If merge was for 4th piece then reset current orientation and colour
	lda UltimateWorkListIndex
	cmp #3
	bcc skip4
	lda #00
	sta CurrentPunchcardColour
	sta CurrentPunchcardOrientation
	
	lda UltimateWorkListIndex
	cmp #3
	bcc skip4
	jsr RestorePunchcardColour

skip4	;Refresh Memory list
 	jsr PlotPuzzleMemoryPieces
	jsr CheckMemoryArrows

	;SFX Mid Beep to confirm
	lda #SFX_HIGHBEEP
	jmp KickSFX
skip1	lda #SFX_LOWBEEP
skip2	jsr KickSFX
.)	
	;And plot Pocket Cursor
	jmp PlotPocketCursor
	

bo_Modem
	jsr PlotPocketCursor
	lda #SFX_DIALTONE
	jsr KickSFX
	
	jsr CLS
	jsr DisplayBlueBackdrop
	lda #1
	sta MenuType
	ora #128
	jsr DisplayMenuScreen
	lda #2
	sta ModemMenuOption
	jsr ControlMenu
	jmp ActOnModemOption
	
ControlMenu
.(	
loop3	;Plot Modem menu cursor
	lda ModemMenuOption
	asl
	asl
	asl
	bit MenuType
	bmi skip3
	asl
skip3	adc #156
	pha
	tay
	lda #<ModemMenuCursorText
	sta line
	lda #>ModemMenuCursorText
	sta line+1
	ldx #5
	lda #1
	jsr DisplayTextLine
	
	;Wait on key
loop1	lda InputRegister
	bne loop1
loop2	lda InputRegister
	beq loop2
	
	;Delete cursor
	pla
	tay
	lda #<ModemMenuCursorDelText
	sta line
	lda #>ModemMenuCursorDelText
	sta line+1
	ldx #5
	lda #1
	jsr DisplayTextLine
	
	;Branch on up
	LDA InputRegister
	cmp #CONTROLLER_UP
	bne skip1
	lda ModemMenuOption
	beq loop3
	dec ModemMenuOption
	jmp loop3
	
skip1	;Branch on down
	cmp #CONTROLLER_DOWN
	bne skip2
	lda MenuType
	asl
	tax
	lda ModemMenuOption
	cmp NumberOfMenuRows,x
	bcs loop3
	inc ModemMenuOption
	jmp loop3
	
skip2	;Branch back if not fire
	cmp #CONTROLLER_FIRE1
	bne loop3
.)
	rts

NumberOfMenuRows
 .byt 4,0,2	;The centre one is dummy
ActOnModemOption
	lda ModemMenuOption
	cmp #1
	beq mm_LocateRooms
	bcc mm_EnoughPiecesForAPuzzle
mm_Rent1	jsr PlotPocketCursor
	jsr CLS
	jsr SilenceSFX
	jmp DisplayPuzzleScreen

mm_LocateRooms
	jsr DialModem	;Jsr'd to wait until end
	;Scan mapofrooms for Room number 29 and 8 and set plundered flag
	ldx #7
.(
loop2	ldy #12
loop1	tya
	lsr
	bcs Ignore
	tya
	clc
	adc MultiplyBy13,x
	sty lsmTempX1
	tay
	lda MapOfRooms,y
	bmi skip1
	and #63
	cmp #29
	beq Found
	cmp #8
	bne skip1
Found	ora #64
	sta MapOfRooms,y
skip1	ldy lsmTempX1
Ignore	dey
	bpl loop1
	dex
	bpl loop2
.)
	;Set message to LOCATED
	ldx #28

ModemHighBeep
	lda #SFX_HIGHBEEP
	jmp ReportModemResult

mm_EnoughPiecesForAPuzzle
	jsr DialModem
	;Scan all pieces in memory and count up each puzzle piece group
	ldx #6
	lda #00
.(
loop1	sta GroupCount,x
	dex
	bpl loop1
.)
	ldy UltimateMemoryListIndex
.(
	bmi skip1
loop1	ldx PuzzleMemory,y
	lda PuzzlePieceProperties-27,x
	and #7
	tax
	inc GroupCount,x
	lda GroupCount,x
	cmp #4
	;Set message to A CARD EXISTS
	ldx #26
	bcs ModemHighBeep
	dey
	bpl loop1
	;Set message to NEED MORE
skip1	ldx #27
.)
	lda #SFX_LOWBEEP
ReportModemResult
	stx ModemsEventualMessage
	pha
	
	jsr PlotPocketCursor
	jsr CLS
	
	pla
	jsr KickSFX
	
	jsr EraseRoomText
	ldx ModemsEventualMessage
	jsr DisplayRoomText
	
	;Wait a big while
	lda #60
	jsr SlowDown
	jsr CLS
	jmp DisplayPuzzleScreen

DialModem	lda #SFX_DIALTONE
	jsr WaitOnSFX
	ldx #9
.(
loop1	lda DialPitchA,x
	sta ay_PitchLo
	lda DialPitchB,x
	sta ay_PitchLo+1
	lda #SFX_DIALDIGIT
	jsr WaitOnSFX
	dex
	bpl loop1
.)
	lda #SFX_MODEMTALK
	jsr WaitOnSFX
	
	;Subtract 2 minutes
	jsr DecrementMinutes
	jmp DecrementMinutes

;Dial pitches now in bottom of hires


WaitOnSFX
	jsr KickSFX
	;Wait for it to finish sfx
.(
loop2	lda sfx_Status
	bne loop2
.)
	rts

bo_Flip
	;Does the work list contain at least one puzzle piece?
	ldx UltimateWorkListIndex
.(
	bmi Error
	;If we have 4 pieces then flag change in current
	cpx #3
	bne skip2
	lda CurrentPunchcardOrientation
	eor #%00001000
	sta CurrentPunchcardOrientation
skip2	;Flip all puzzle pieces in work list

loop1	lda WorkMemory,x	;WORKMEMORY
	stx boTemp01
	
	tax
	sta Temp01
	jsr FetchPuzzleGraphicAddressIntoSource
	jsr FlipGraphic
	
	ldx boTemp01
	dex
	bpl loop1
	
	;Redo work pieces
	jsr ReMergeWorkPuzzle

	lda UltimateWorkListIndex
	bmi skip3
	cmp #3
	bcc skip3
	jsr RestorePunchcardColour

skip3	;Refresh work result
	jsr DisplayWorkAreaPiece
	
	lda #SFX_HIGHBEEP
	jmp skip1

Error	lda #SFX_LOWBEEP
skip1	jsr KickSFX
.)
	jsr PlotButtonDown
	
	jmp CheckFinalPunchcard
	
DisplayWorkAreaPiece
	lda #OBJ_WORKPUZZLEAREA
	sta Object_V
	lda #14
	sta Object_X
	lda #172
	sta Object_Y
	jmp DisplayGraphicObject
	


ReMergeWorkPuzzle
	;Wipe $BFE0-BFFF
	jsr ErasePuzzleBuffer
	ldx UltimateWorkListIndex
.(
	bmi skip1
loop2	lda WorkMemory,x	;WORKMEMORY
	stx boTemp01
	tax
	jsr FetchPuzzleGraphicAddressIntoSource
	ldy #31
loop1	lda Object_WorkPuzzlePieceGraphic,y
	ora (source),y
	sta Object_WorkPuzzlePieceGraphic,y
	dey
	bpl loop1
	ldx boTemp01
	dex
	bpl loop2
skip1	rts
.)

ErasePuzzleBuffer
	ldx #31
	lda #64
.(
loop1	sta Object_WorkPuzzlePieceGraphic,x
	dex
	bpl loop1
.)
	rts

bo_Mirror

	;Does the work list contain at least one puzzle piece?
	ldx UltimateWorkListIndex
.(
	bmi Error
	;If we have 4 pieces then flag change in current
	cpx #3
	bne skip2
	lda CurrentPunchcardOrientation
	eor #%00000100
	sta CurrentPunchcardOrientation
skip2	;Flip all puzzle pieces in work list

loop1	lda WorkMemory,x	;WORKMEMORY
	stx boTemp01
	
	tax
	sta Temp01
	jsr FetchPuzzleGraphicAddressIntoSource
	jsr MirrorGraphic
	
	ldx boTemp01
	dex
	bpl loop1

	;Redo work pieces
	jsr ReMergeWorkPuzzle
	
	lda UltimateWorkListIndex
	bmi skip3
	cmp #3
	bcc skip3
	jsr RestorePunchcardColour

skip3	;Refresh work result
	jsr DisplayWorkAreaPiece
	
	lda #SFX_HIGHBEEP
	jmp skip1

Error	lda #SFX_LOWBEEP
skip1	jsr KickSFX
.)
	jsr PlotButtonDown
	
CheckFinalPunchcard
	ldx UltimateWorkListIndex
	cpx #3
.(
	bne skip1
	
	;Ensure all pieces of punchcard share same group ID
	ldy WorkMemory,x	;WORKMEMORY,x
	lda PuzzlePieceProperties-27,y
	and #7
	sta TempGroupID
	dex
loop1	ldy WorkMemory,x	;WORKMEMORY,x
	lda PuzzlePieceProperties-27,y
	and #7
	cmp TempGroupID
	bne skip2
	dex
	bpl loop1
	
	;Check if correct Colour of punchcard
	ldx TempGroupID
	lda PunchCardProperty,x
	and #3
	cmp CurrentPunchcardColour
	bne skip1
	
	;Check if correct orientation of punchcard
	lda PunchCardProperty,x
	and #%00001100
	cmp CurrentPunchcardOrientation
	bne skip1
	
	;Award letter of password
	lda PasswordLetter,x
	sta PasswordText,x
	
	;Display new Letter
	jsr DisplayPassword
	
	;Update stats
	inc Stats_PunchcardCount
	
	;Award 500 to score
	lda #5
	jsr AddHundredsScore

	;Remove puzzle pieces from work area (and from game)
	lda #255
	sta UltimateWorkListIndex
	
	;Clear out work piece buffer
	jsr ErasePuzzleBuffer
	
	;And display it
	jsr DisplayWorkAreaPiece
	
	;Award with sfx too
	lda #SFX_FOUNDLETTER
	jmp KickSFX
skip2	lda #SFX_LOWBEEP
	jsr KickSFX
skip1	rts
.)
	
DisplayPassword
	lda #<PasswordText
	sta line
	lda #>PasswordText
	sta line+1
	ldx #23
	ldy #181
	lda #1
	jmp DisplayTextLine
	

bo_Undo
	;Transfer all work pieces list back into memory list and erase work display
	ldx UltimateWorkListIndex
.(
	bmi Error
loop1	inc UltimateMemoryListIndex
	ldy UltimateMemoryListIndex
	lda WorkMemory,x	;WORKMEMORY,x
	sta PuzzleMemory,y
	dec UltimateWorkListIndex
	dex
	bpl loop1
	
	;Clear out work piece buffer
	jsr ErasePuzzleBuffer
	
	;And display it
	jsr DisplayWorkAreaPiece
	
	;Refresh Puzzle memory list and arrows
 	jsr PlotPuzzleMemoryPieces
	jsr CheckMemoryArrows
	
	lda #SFX_HIGHBEEP
	jmp skip1
Error	lda #SFX_LOWBEEP
skip1	jsr KickSFX
.)
	jmp PlotButtonDown

	
	
	
	
	
RestorePunchcardColour
	ldx CurrentPunchcardColour
	lda PunchcardColourTemplateLo,x
	sta colour
	lda PunchcardColourTemplateHi,x
	sta colour+1
	jsr ReMergeWorkPuzzle
	ldy #31
.(
loop1	lda Object_WorkPuzzlePieceGraphic,y
	and #63
	eor (colour),y
	sta Object_WorkPuzzlePieceGraphic,y
	dey
	bpl loop1
.)
	rts

PunchcardColourTemplateLo
 .byt <PunchcardColourAmber
 .byt <PunchcardColourGreen
 .byt <PunchcardColourWhite
PunchcardColourTemplateHi
 .byt >PunchcardColourAmber
 .byt >PunchcardColourGreen
 .byt >PunchcardColourWhite

PunchcardColourAmber
 .byt 255,255,255,255,64,64,64,64,255,255,255,255,64,64,64,64
 .byt 255,255,255,255,64,64,64,64,255,255,255,255,64,64,64,64
PunchcardColourGreen
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
PunchcardColourWhite
 .byt 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
 .byt 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255

bo_Orange
bo_Green
bo_White
	jsr bo_CommonColourCheck
.(
	bcc skip1
	;Set colour in current
	tya
	sec
	sbc #5
	sta CurrentPunchcardColour
	;Colour the work area piece Green
	jsr RestorePunchcardColour
	jsr DisplayWorkAreaPiece
skip1	jsr PlotButtonDown
.)
	jmp CheckFinalPunchcard


 
;bo_Green
;	jsr bo_CommonColourCheck
;.(
;	bcc skip1
;	;Set colour in current
;	lda #01
;	sta CurrentPunchcardColour
;	;Colour the work area piece Green
;	jsr RestorePunchcardColour
;	jsr DisplayWorkAreaPiece
;skip1	jsr PlotButtonDown
;.)
;	jmp CheckFinalPunchcard
;
;bo_White
;	jsr bo_CommonColourCheck
;.(
;	bcc skip1
;	;Set colour in current
;	lda #02
;	sta CurrentPunchcardColour
;	;Colour the work area piece White
;	jsr RestorePunchcardColour
;	jsr DisplayWorkAreaPiece
;skip1	jsr PlotButtonDown
;.)
;	jmp CheckFinalPunchcard
;
;bo_Orange
;	;Check that the work list contains four pieces
;	jsr bo_CommonColourCheck
;.(
;	bcc skip1
;	;Set colour in current
;	lda #00
;	sta CurrentPunchcardColour
;	;Colour the work area piece Orange
;	jsr RestorePunchcardColour
;	jsr DisplayWorkAreaPiece
;skip1	jsr PlotButtonDown
;.)
;	jmp CheckFinalPunchcard

bo_CommonColourCheck
	lda UltimateWorkListIndex
.(
	bmi skip2
	cmp #3
	bcs skip1
skip2	lda #SFX_LOWBEEP
	jsr KickSFX
	clc
skip1	rts
.)	
	

bo_Sound
	;Toggle sound flag
	lda AudioFlag
	eor #128
	sta AudioFlag
.(
	bmi skip1
	
	;Turn off sound
	jsr SilenceSFX
	
skip1	;Display state in scorepanel
.)
	jsr DisplayAudioState
	
	;Redisplay Button highlight
	jmp PlotPocketCursor

bo_Pause
	;Enter Paused mode - Clear screen
	jsr CLS
	
	jsr ClearOutInputBuffer
	
	;Display Paused Message
	lda #<PausedMessage
	sta line
	lda #>PausedMessage
	sta line+1
	lda #1
	ldx #7
	ldy #186
	jsr DisplayTextLine
	
	;Flag Clock to stop counting
	lda #1
	sta GamePaused
	
	;Flash Pause button until Fire pressed
.(
loop1	jsr PlotPocketCursor
	jsr DelayPause
	bcs skip1
	jsr RestorePocketButtons
	jsr DelayPause
	bcs skip1
	jmp loop1

skip1	;Switch clock back on again
.)
	lda #00
	sta GamePaused
	
	;Clear screen again
	jsr CLS
	
	;Restore screen
	jsr DisplayPuzzleScreen
	
	;Redisplay cursor
	jsr PlotPocketCursor
	
	;Clear out input buffer
ClearOutInputBuffer
	lda InputRegister
	bne ClearOutInputBuffer
	rts
	

DelayPause
.(	
loop1	lda InputRegister
	sec
	and #CONTROLLER_FIRE1
	bne skip1
	lda EthanDelay
	bne loop1	
	lda #20
	sta EthanDelay
	clc
skip1	rts
.)
	
PuzzleMemorySelect	;
;	nop
;	jmp PuzzleMemorySelect
	;Is work list void?
	lda UltimateWorkListIndex
.(
	bmi MovePuzzlePiece2WorkList
	;Jump to Merge
	jmp bo_Merge
rent1	;Cannot move memory piece
	lda #SFX_LOWBEEP
	jsr KickSFX
	jmp PlotPocketCursor
MovePuzzlePiece2WorkList
	;Are we selecting a valid memory puzzle piece? (like empty list)
	lda UltimateMemoryListIndex
	bmi rent1
	lda PuzzleMemoryBase
	clc
	ldx CursorX
	adc CursorY,x
	cmp UltimateMemoryListIndex
	beq skip1
	bcs rent1

skip1	;Remove puzzle piece from Memory list
.)
	tax
	ldy UltimateMemoryListIndex
	lda PuzzleMemory,x
	pha
	lda PuzzleMemory,y
	sta PuzzleMemory,x
	dec UltimateMemoryListIndex

	;Put puzzle piece into Work list
	pla
	inc UltimateWorkListIndex
	ldy UltimateWorkListIndex
	sta WorkMemory,y	;WORKMEMORY,y
	
	;Display work area puzzle piece
	sta Object_V
	lda #14
	sta Object_X
	lda #172
	sta Object_Y
	jsr DisplayGraphicObject

	;Refresh Memory list
 	jsr PlotPuzzleMemoryPieces
	jsr CheckMemoryArrows

	lda #SFX_HIGHBEEP
	jmp KickSFX

PuzzleMemoryCursorYpos
 .byt 158,170,182
CursorY
 .byt 0,0,0,0,0,0
;PlotWorkCursor
;	lda #13
;	sta Object_X
;	lda #170
;	sta Object_Y
;	jmp PlotPuzzleCursorRent

PlotPuzzleCursor
	;Construct puzzle cursor out of the two objects
	lda #5	;or 13 for work
	sta Object_X
	
	;
	ldy CursorY+1
	lda PuzzleMemoryCursorYpos,y
	sta Object_Y

PlotPuzzleCursorRent
	;Plot Horizontal bar(top)
	lda #PUZZLECURSORHORIZONTAL
	sta Object_V
	jsr DisplayGraphicObject
	
	;Plot vertical bar(Left)
	inc Object_Y
	lda #PUZZLECURSORVERTICAL
	sta Object_V
	jsr DisplayGraphicObject
	
	;Plot vertical bar(right)
	lda Object_X
	adc #5
	sta Object_X
	jsr DisplayGraphicObject
	
	;Plot Horizontal bar(bottom)
	lda Object_X
	sbc #4
	sta Object_X
	lda Object_Y
	adc #9
	sta Object_Y
	lda #PUZZLECURSORHORIZONTAL
	sta Object_V
	jmp DisplayGraphicObject
	
DeletePuzzleCursor
	;Construct puzzle cursor out of the two objects
	lda #5	;or 13 for work
	sta Object_X
	
	;
	ldy CursorY,x
	lda PuzzleMemoryCursorYpos,y
	sta Object_Y

	;Plot Horizontal bar(top)
	lda #PUZZLECURSORDELETEDHORIZTOP
	sta Object_V
	jsr DisplayGraphicObject
	
	;Plot vertical bar(Left)
	inc Object_Y
	lda #PUZZLECURSORDELETEDVERTICAL
	sta Object_V
	jsr DisplayGraphicObject
	
	;Plot vertical bar(right)
	lda Object_X
	adc #5
	sta Object_X
	jsr DisplayGraphicObject
	
	;Plot Horizontal bar(bottom)
	lda Object_X
	sbc #4
	sta Object_X
	lda Object_Y
	adc #9
	sta Object_Y
	lda #PUZZLECURSORDELETEDHORIZBOT
	sta Object_V
	jmp DisplayGraphicObject


PlotPuzzleMemoryArrowUp
	lda #PUZZLEMEMORYARROWUP
PlotPuzzleMemoryArrowRent1
	ldy #154
PlotPuzzleMemoryArrowRent2
	sty Object_Y
	sta Object_V
	lda #7
	sta Object_X
	jmp DisplayGraphicObject
DeletePuzzleMemoryArrowUp
	lda #PUZZLEMEMORYDELETEDARROWUP
	jmp PlotPuzzleMemoryArrowRent1
PlotPuzzleMemoryArrowDown
	lda #PUZZLEMEMORYARROWDOWN
PlotPuzzleMemoryArrowRent3
	ldy #195
	jmp PlotPuzzleMemoryArrowRent2
DeletePuzzleMemoryArrowDown
	lda #PUZZLEMEMORYDELETEDARROWDOWN
	jmp PlotPuzzleMemoryArrowRent3


;B0-2 Group(0-6)
;B3-5 -
;B6   Current Flip state (0 is correct)
;B7   Current Mirror State (0 is correct)
PuzzlePieceProperties
 .byt 0,0,0,0
 .byt 1,1,1,1
 .byt 2,2,2,2
 .byt 3,3,3,3
 .byt 4,4,4,4
 .byt 5,5,5,5
 .byt 6,6,6,6
;PunchCardProperty
;B0-1 Colour 0-2
;B2   Mirror position
;B3   Flip position
PunchCardProperty
 .dsb 7,0
PuzzleMemoryBase		.byt 0
PuzzleMemoryPieceIndex	.byt 0
TempPuzzleMemoryBase	.byt 0
PuzzleMemoryYpos
 .byt 160,172,184


DisplayPuzzleScreen
	;Display blue backdrop
	jsr DisplayBlueBackdrop

	;Display puzzle memory and arrows
	jsr PlotPuzzleMemoryPieces
	jsr CheckMemoryArrows

	;Remerge all pieces currently working on
	jsr ReMergeWorkPuzzle

	;Display work area piece
	jmp DisplayWorkAreaPiece


DisplayBlueBackdrop
	lda #<$B83D
	sta screen
	lda #>$B83D
	sta screen+1
	ldx #21
.(
loop2	ldy #14
	lda #%11111111
loop1	sta (screen),y
	dey
	bpl loop1
	
	lda #80
	jsr AddScreen
	
	dex
	bne loop2
.)	
	rts

;PuzzleMemoryBase
PlotPuzzleMemoryPieces
	lda #00
	sta PuzzleMemoryPieceIndex
	lda PuzzleMemoryBase
	sta TempPuzzleMemoryBase
	lda #6
	sta Object_X
	
	lda UltimateMemoryListIndex
.(
	bmi RemainderEmpty
	
loop1	ldx TempPuzzleMemoryBase
	cpx UltimateMemoryListIndex
	bcc skip1
	bne RemainderEmpty
skip1	lda PuzzleMemory,x
	sta Object_V
	ldx PuzzleMemoryPieceIndex
	lda PuzzleMemoryYpos,x
	sta Object_Y
	jsr DisplayGraphicObject
	inc TempPuzzleMemoryBase
	inc PuzzleMemoryPieceIndex
	lda PuzzleMemoryPieceIndex
	cmp #3
	bcc loop1
	rts
RemainderEmpty
	lda #VOIDPUZZLEPIECE
	sta Object_V
loop2	ldx PuzzleMemoryPieceIndex
	lda PuzzleMemoryYpos,x
	sta Object_Y
	jsr DisplayGraphicObject
	inc PuzzleMemoryPieceIndex
	lda PuzzleMemoryPieceIndex
	cmp #3
	bcc loop2
.)
	rts
	
bo_Disk
	jsr PlotPocketCursor
;	jsr CLS
;	jsr DisplayBlueBackdrop
	ldx #128
	stx MenuType
	lda #2+128
	jsr DisplayMenuScreen
	lda #4
	sta ModemMenuOption
boDisk2	jsr ControlMenu
	lda ModemMenuOption
.(
	beq skip1	;Branch if SAVE GAME
	cmp #2
	bcc skip2	;Branch for LOAD GAME
	bne skip4
	;Quit to title
	jsr DeletePocketCursor
	jsr FadeDitherGameScreen
	ldx GameStartsStackPointer
	txs
	jmp TitleReEntry
skip4	cmp #3
	bne skip3
	;Change screen mode
	jsr AdjustColourVariables
	adc #2
	ldx #130
	jsr PlotTitleOptions10Text
	jmp boDisk2
skip1	;Save game
	jsr DeletePocketCursor
	jsr SaveGame
	jmp skip3
skip2	;Load Game
	
	;Flag Clock to stop counting
	jsr DeletePocketCursor
	jsr EyeCloseRoom
	jmp LoadGame
skip3	jsr CLS
.)
	jsr DisplayPuzzleScreen
	jsr PlotPocketCursor
	jmp ClearOutInputBuffer


bo_Stats
	jsr PlotPocketCursor
	jsr CLS
	jsr DisplayBlueBackdrop
	lda #00
	sta $0203
	;Set up Stats Values in Text form
	ldx #4
.(
loop3	lda Stats_Vars,x
	ldy StatsFormatDigits,x	;0(1)/1(2)/128(3)
	bpl skip1
	ldy #47
	sec
loop1	iny
	sbc #100
	bcs loop1
	adc #100
	pha
	tya
	ldy OffsetInStatsText4Hundreds,x
	sta StatsText,y
	pla
	ldy StatsFormatDigits,x	;0(1)/1(2)/128(3)
skip1	beq skip2
	ldy #47
	sec
loop2	iny
	sbc #10
	bcs loop2
	adc #10
	pha
	tya
	ldy OffsetInStatsText4Tens,x
	sta StatsText,y
	pla
skip2	;Always plot units
	ldy OffsetInStatsText4Units,x
	clc
	adc #48
	sta StatsText,y
	dex
	bpl loop3
.)
	lda #3
	jsr DisplayMenuScreen
	
	ldx #CONTROLLER_FIRE1
	jsr GetSpecificKey
	jsr CLS
	jsr DisplayPuzzleScreen
	jsr PlotPocketCursor
	jmp ClearOutInputBuffer


CapturePocketButtons
	;Capture the buttons to the left and right of the pocket computer in the background buffer
	;so we can use them to restore the display instead of button up graphics
	
	;Capture Left Button column
	lda #<BGBuffer+512
	sta bgbuff
	lda #>BGBuffer+512
	sta bgbuff+1
	
	lda #<$A000+1+40*151
	sta screen
	lda #>$A000+1+40*151
	sta screen+1
	
	ldx #49
.(
loop2	ldy #3
loop1	lda (screen),y
	sta (bgbuff),y
	dey
	bpl loop1
	
	jsr nl_screen
	lda bgbuff
	adc #4
	sta bgbuff
	bcc skip1
	inc bgbuff+1
	
skip1	dex
	bne loop2
.)
	;Capture Buttons to right
	lda #<BGBuffer+512+4*49
	sta bgbuff
	lda #>BGBuffer+512+4*49
	sta bgbuff+1
	
	lda #<$A000+30+40*151
	sta screen
	lda #>$A000+30+40*151
	sta screen+1
	
	ldx #49
.(
loop2	ldy #9
loop1	lda (screen),y
	sta (bgbuff),y
	dey
	bpl loop1
	
	jsr nl_screen
	lda bgbuff
	adc #10
	sta bgbuff
	bcc skip1
	inc bgbuff+1
	
skip1	dex
	bne loop2
.)
	rts

RestorePocketButtons
	;Restore Left Button column
	lda #<BGBuffer+512
	sta bgbuff
	lda #>BGBuffer+512
	sta bgbuff+1
	
	lda #<$A000+1+40*151
	sta screen
	lda #>$A000+1+40*151
	sta screen+1
	
	ldx #49
.(
loop2	ldy #3
loop1	lda (bgbuff),y
	sta (screen),y
	dey
	bpl loop1
	
	jsr nl_screen
	lda bgbuff
	adc #4
	sta bgbuff
	bcc skip1
	inc bgbuff+1
	
skip1	dex
	bne loop2
.)
	;Restore Buttons to right
	lda #<BGBuffer+512+4*49
	sta bgbuff
	lda #>BGBuffer+512+4*49
	sta bgbuff+1
	
	lda #<$A000+30+40*151
	sta screen
	lda #>$A000+30+40*151
	sta screen+1
	
	ldx #49
.(
loop2	ldy #9
loop1	lda (bgbuff),y
	sta (screen),y
	dey
	bpl loop1
	
	jsr nl_screen
	lda bgbuff
	adc #10
	sta bgbuff
	bcc skip1
	inc bgbuff+1
	
skip1	dex
	bne loop2
.)
	rts
