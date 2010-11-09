;PuzzleControl

;P  
;P  W
;P  

;In total there are 28 puzzle pieces hidden in furniture spread across the complex.
;When a piece is collected its Graphic ID is stored in a list at $2BC and displayed
;in the left list in the Puzzle control window.

;When an item is selected from the Puzzle List it is added to the WorkList and removed
;from the PuzzleList at $2C2.

;Each puzzle piece also has a separate table that holds its property called the 
;PuzzlePieceProperties
;Each piece is randomly mirrored and flipped on each new game.

;B0-2 Group(0-6)
;B3-5 -
;B6   Current Flip state (0 is correct)
;B7   Current Mirror State (0 is correct)


;Mirror, Flip and colour always act on the Work puzzle piece and in turn toggles the flags in
;PuzzleProperty.

;When an item is selected in the Puzzle list and a puzzle piece already exists in the Worklist then
;Merge is invoked and an attempt is made to merge the currently selected PuzzleMemory piece
;with the worklist piece. If the merge is successful the puzzlememory piece is moved to the
;WorkList and the display will show the merged product of the two pieces.
;Further merges will again be shown in the Work Piece.

;Once a punchcard has been found, flipped, mirrored and coloured correctly it will produce a
;Letter for the password and the Worklist pieces will be removed from the game.

;If Undo is pressed at any time the last Piece that was added to the Worklist will be moved back to
;the next entry after the Cursor in the Puzzle Memory.

DisplayPuzzleScreen
	;Display blue backdrop
	jsr DisplayBlueBackdrop

	;Display puzzle memory and arrows
	jsr PlotPuzzleMemoryPieces
	jsr CheckMemoryArrows

	;Remerge all pieces currently working on
	jsr ReMergeWorkPuzzle

	;Display work area piece
	jsr DisplayWorkAreaPiece

	;Display puzzle cursors
	jmp PlotPuzzleCursor


PlotPuzzleMemoryPieces
	;Use X as row index
	ldx #0

	;Fetch top of display Puzzle memory index
	ldy PuzzleMemoryBase
	
	;Display up to 3 puzzle pieces
.(	
loop1	;Fetch Puzzle Piece
	lda PuzzleMemory,y	;PUZZLEMEMORY,y
	bpl skip1
	;Set to blank if the end of puzzle memory is reached
	lda #
	jmp skip2
skip1	clc
	adc #PUZZLEPIECE00
skip2	sta Object_V
	
skip1	;Fetch its Position on screen
	lda PuzzleMemoryScreenPositionX,x
	sta Object_X
	lda PuzzleMemoryScreenPositionY,x
	sta Object_Y
	
	;Display the puzzle piece
	jsr 
	
	;Progress the display
	iny
	inx
	cpx #3
	bcc loop1
.)
	rts

;potentially push scroll memory
PuzzleMemoryDown
	;CursorY is a table 5 wide representing the y position for each
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

DisplayWorkAreaPiece
	lda #OBJ_WORKPUZZLEAREA
	sta Object_V
	lda #14
	sta Object_X
	lda #172
	sta Object_Y
	jmp DisplayGraphicObject
	
Undo_Work
	;Move last Piece in WorkList back to Puzzle Memory and redraw
	ldx UltimateWorkListIndex
.(
	bpl skip1
	jmp NegativeResponse
skip1	lda WORKLIST,x
.)
	dec UltimateWorkListIndex
	bmi DisplayVoidWorkPiece
	inc UltimateMemoryListIndex
	ldy UltimateMemoryListIndex
	sta PuzzleMemory,y	;PUZZLEMEMORY,y

	;Redraw
	jsr PlotPuzzleMemoryPieces
	jmp ReMergeWorkPuzzle
	
	

ReMergeWorkPuzzle
	;Wipe $BFE0-BFFF
	jsr ErasePuzzleBuffer
	ldx UltimateWorkListIndex
.(
	bmi skip1
loop2	lda WORKLIST,x
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

	

PuzzleUndo

;Called by
; RandomiseOrientationOfPuzzlePieces
; bo_Mirror
;Mirrors Puzzle piece specified in A(0-27)
PuzzleMirror
PuzzleFlip