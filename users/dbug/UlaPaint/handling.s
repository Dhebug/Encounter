

#define SPECIAL_KEY_NONE		0
#define SPECIAL_KEY_CONTROL		1
#define SPECIAL_KEY_SHIFT_LEFT	2
#define SPECIAL_KEY_SHIFT_RIGHT	4
#define SPECIAL_KEY_FUNCTION	8

_KeyCar			.byt 0
_KeyScan		.byt 0
_KeySpecial		.byt 0
_FlagExit		.byt 0


; =========================================
;  Increase the size of the zoomer window
; =========================================
_ZoomerExtend
.(
	lda _CurrentLineCount
	cmp #28
	bcs end_extend

	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_LEFT
	beq no_max_move

	lda #28
	sta _CurrentLineCount
	jmp apply_move 

no_max_move
	inc _CurrentLineCount

apply_move
	lda #1
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	sta _FlagRedrawInverse

	jsr _ValidateDisplayValues

end_extend
	rts
.)



; =========================================
;  Decrease the size of the zoomer window
; =========================================
_ZoomerShrink
.(
	lda _CurrentLineCount
	cmp #2
	bcc end_shrink

	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_LEFT
	beq no_max_move

	lda #1
	sta _CurrentLineCount
	jmp apply_move 

no_max_move
	dec _CurrentLineCount

apply_move

	lda #1
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	sta _FlagRedrawInverse

	jsr _ValidateDisplayValues

end_shrink
	rts
.)





; =========================================
;    Move the current pixel to the left
; =========================================
_MoveLeft
.(
	lda _CurrentPixelX
	bne continue_move_left
	rts

continue_move_left
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_RIGHT
	beq no_max_move

	; Force zoomer to the left of the screen
	lda #0
	jmp end_move_left

no_max_move
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_LEFT
	beq no_fast_move
	
	; Move left the zoomer fast
	lda #6
	ldx _FlagPixelMode
	bne apply_movement
	lda #36
	jmp apply_movement

no_fast_move
	; Just move at normal speed
	lda #1
	ldx _FlagPixelMode
	bne apply_movement
	lda #6

apply_movement
	sta tmp0			; Increment value
	cmp _CurrentPixelX
	bcs reached_border 
	sec
	lda _CurrentPixelX
	sbc tmp0
	jmp end_move_left

reached_border
	lda #0

end_move_left
	sta _CurrentPixelX

	lda #1
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	sta _FlagRedrawInverse
	rts
.)





; =========================================
;    Move the current pixel to the right
; =========================================
_MoveRight
.(
	lda _CurrentPixelX
	cmp #239
	bne continue_move_right
	rts

continue_move_right
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_RIGHT
	beq no_max_move

	; Force zoomer to the right of the screen
	lda #239
	jmp end_move_right

no_max_move
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_LEFT
	beq no_fast_move
	
	; Move right the zoomer fast
	lda #6
	ldx _FlagPixelMode
	bne apply_movement

	lda _CurrentPixelX
	cmp #219
	bcs reached_border
	lda #36
	jmp apply_movement

no_fast_move
	; Just move at normal speed
	lda #1
	ldx _FlagPixelMode
	bne apply_movement
	lda #6

apply_movement
	clc
	sta tmp0			; Increment value
	lda _CurrentPixelX
	adc tmp0
	cmp #240
	bcc end_move_right 

reached_border
	lda #239

end_move_right
	sta _CurrentPixelX

	lda #1
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	sta _FlagRedrawInverse
	rts
.)




; =========================================
;         Move the current pixel up
; =========================================
_MoveUp
.(
	lda _CurrentPixelY
	bne continue_move_up
	rts

continue_move_up
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_RIGHT
	beq no_max_move

	; Force zoomer to the top of the screen
	lda #0
	jmp end_move_up

no_max_move
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_LEFT
	beq no_fast_move
	
	; Move up the zoomer fast
	lda _CurrentLineCount
	jmp apply_movement

no_fast_move
	; Just move at normal speed
	lda #1

apply_movement
	sta tmp0			; Increment value
	cmp _CurrentPixelY
	bcs reached_border 
	sec
	lda _CurrentPixelY
	sbc tmp0
	jmp end_move_up

reached_border
	lda #0

end_move_up
	sta _CurrentPixelY

	lda #1
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	sta _FlagRedrawInverse
	rts
.)




; =========================================
;         Move the current pixel down
; =========================================
_MoveDown
.(
	lda _CurrentPixelY
	cmp #199
	bne continue_move_down
	rts

continue_move_down
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_RIGHT
	beq no_max_move

	; Force zoomer to the top of the screen
	lda #199
	jmp end_move_down

no_max_move
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_LEFT
	beq no_fast_move
	
	; Move down the zoomer fast
	lda _CurrentLineCount
	jmp apply_movement

no_fast_move
	; Just move at normal speed
	lda #1

apply_movement
	clc
	sta tmp0			; Increment value
	lda _CurrentPixelY
	adc tmp0
	cmp #200
	bcc end_move_down 

reached_border
	lda #199

end_move_down
	sta _CurrentPixelY

	lda #1
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	sta _FlagRedrawInverse
	rts
.)





// ========================================
// Compute the position of the zoomer based on the coordinate of the edited pixel
// ========================================
_ValidateDisplayValues_X
.(
	// Fake 12 add for unsigned char centering calculations
	clc
	lda _CurrentPixelX
	pha
	adc #2*6
	sta _CurrentPixelX

	// Position of the bit in the byte at this position
	ldx _CurrentPixelX
	lda _TableMod6,x
	sta _CurrentZoomPixelBit

	ldy _TableDiv6,x
	dey
	dey
	sty _CurrentZoomX

	lda #2
	sta _CurrentZoomPixelX

	lda _CurrentZoomX
	cmp #2
	bcs skip_left

left_side
	//
	// CurrentZoomPixelX=CurrentZoomPixelX-2+CurrentZoomX;
	// CurrentZoomX=2;
	//
	sec
	lda _CurrentZoomPixelX
	sbc #2
	clc
	adc _CurrentZoomX
	sta _CurrentZoomPixelX

	lda #2
	sta _CurrentZoomX
	jmp end

skip_left
	cmp #34+2
	bcc skip_right

right_side
	//
	// CurrentZoomPixelX=2+CurrentZoomX-(34+2);
	// CurrentZoomX=34+2;
	//
	sec
	lda _CurrentZoomX
	sbc #34
	sta _CurrentZoomPixelX

	lda #34+2
	sta _CurrentZoomX
	jmp end

skip_right

end
	dec _CurrentZoomX
	dec _CurrentZoomX


	// Remove fake 12 add for unsigned char centering calculations
	pla
	sta _CurrentPixelX


	//
	// Memorise pointer on current byte:
	// PtrCurrentByte=BufferMain1+CurrentPixelY*40+TableDiv6[CurrentPixelX];
	//
	clc
	ldx _CurrentPixelY
	lda #<_BufferMain1
	adc _HiresAddrLow,x
	sta tmp0+0
	lda #>_BufferMain1
	adc _HiresAddrHigh,x
	sta tmp0+1

	ldx _CurrentPixelX
	clc
	lda tmp0+0
	adc _TableDiv6,x
	sta _PtrCurrentByte+0
	lda tmp0+1
	adc #0
	sta _PtrCurrentByte+1

	rts
.)




_ValidateDisplayValues_Y
.(

.(
	//
	// HiresSizeView=198-(CurrentLineCount*6);
	//
	sec
	lda _CurrentLineCount
	asl			; x2
	sta tmp0
	asl			; x4
	clc
	adc tmp0	; x4+x2=x6
	sta tmp0
	lda #198
	sec 
	sbc tmp0
	sta _HiresSizeView


	//
	// Compute the half size
	// And temporarily fake the value of Y coordinate to ease computations
	//
	// half_size=CurrentLineCount/2;
	// CurrentPixelY+=half_size;
	//
	lda _CurrentLineCount
	lsr
	sta tmp0
	lda _CurrentPixelY
	pha
	clc
	adc tmp0
	sta _CurrentPixelY

	;
	; CurrentZoomY		=CurrentPixelY-half_size;
	; CurrentZoomPixelY	=half_size;
	;
	sec
	lda _CurrentPixelY
	sbc tmp0
	sta _CurrentZoomY
	lda tmp0
	sta _CurrentZoomPixelY


	lda _CurrentZoomY
	cmp tmp0
	bcs skip_top

top_side
	;
	; CurrentZoomPixelY=CurrentZoomPixelY-half_size+CurrentZoomY;
	; CurrentZoomY=half_size;
	;
	sec
	lda _CurrentZoomPixelY
	sbc tmp0
	clc
	adc _CurrentZoomY
	sta _CurrentZoomPixelY

	lda tmp0
	sta _CurrentZoomY
	jmp end

skip_top
	;
	; end_limit=200-CurrentLineCount+half_size;
	;
	sec
	lda #200
	sbc	_CurrentLineCount
	clc
	adc tmp0
	sta tmp1

	lda _CurrentZoomY
	cmp tmp1
	bcc skip_bottom

bottom_side
	;
	; CurrentZoomPixelY=half_size+CurrentZoomY-end_limit;
	; CurrentZoomY=end_limit;
	;
	clc
	lda _CurrentZoomY
	adc tmp0
	sec
	sbc tmp1
	sta _CurrentZoomPixelY

	lda tmp1
	sta _CurrentZoomY
	jmp end

skip_bottom

end
	; CurrentZoomY-=half_size;
	sec
	lda _CurrentZoomY
	sbc tmp0
	sta _CurrentZoomY

	;
	; Restore the faked Y value
	;
	pla
	sta _CurrentPixelY
.)

	


.(
	; if (CurrentZoomY>=(200-CurrentLineCount))
	; {
	;   CurrentZoomY=(200-CurrentLineCount);
	;   FlagRedrawZoomer=1;
	; }
	sec
	lda #200
	sbc _CurrentLineCount
	sta tmp0

	lda _CurrentZoomY
	cmp tmp0
	bcc skip

	lda tmp0
	sta _CurrentZoomY

	lda #1
	sta _FlagRedrawZoomer
skip
.)
	rts


	; ===========
	; Ca marche pas
	; Problemes de valeur négative sur 16 bits...
	; ===========

.(
	;
	; new_pos=CurrentZoomY+CurrentLineCount/2-HiresSizeView/2;
	;
	lda _HiresSizeView
	lsr
	sta tmp0

	lda _CurrentLineCount
	lsr
	sta tmp1

	clc	
	lda tmp1
	adc _CurrentZoomY
	sta tmp1
	lda #0
	sta tmp1+1

	sec
	lda tmp1
	sbc tmp0
	sta tmp0
	lda tmp1+1
	sbc tmp0+1
	sta tmp0+1

	lda tmp0+1
	beq skip

	; if (new_pos<0)
	; {
	; 	new_pos=0;
	; }
	lda #0
	sta tmp0
	jmp end

skip
	; else
	; if (new_pos>=(200-HiresSizeView))
	; {
	; 	new_pos=(200-HiresSizeView);
	; }
	sec
	lda #200	
	sbc _HiresSizeView
	sta tmp1

	lda tmp0
	cmp tmp1
	bcc end

	lda tmp1
	sta tmp0

end

	lda tmp0
	cmp _HiresSizePos
	beq no_movement

	sta _HiresSizePos
	lda #1
	sta _FlagRedrawPicture 
no_movement	
.)

	rts
.)




_HandleKeyboard
.(
	; Get the value of scan code
.(
	ldx $208
	lda _KeyCar
	bne no_key
	ldx #0
no_key
	stx _KeyScan
.)


.(
	; Read special keys
	ldx #SPECIAL_KEY_NONE
	lda $209
	cmp #162
	bne no_control
	ldx #SPECIAL_KEY_CONTROL
	jmp end_special
no_control
	cmp #164
	bne no_shift_left
	ldx #SPECIAL_KEY_SHIFT_LEFT
	jmp end_special
no_shift_left
	cmp #167
	bne no_shift_right
	ldx #SPECIAL_KEY_SHIFT_RIGHT
	jmp end_special
no_shift_right
	cmp #165
	bne no_function
	ldx #SPECIAL_KEY_FUNCTION
no_function
end_special
	stx _KeySpecial
.)
	
	ldx _KeyScan
	lda _KeyboardFunctionsLow,x
	sta _jump_patch+1
	lda _KeyboardFunctionsHigh,x
	sta _jump_patch+2
_jump_patch
	jmp $1234
	rts
.)


_KeyUndefined
.(
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_LEFT
	beq no_shift

	;
	; Higlight current area
	;
	lda #1
	sta _FlagRedrawPicture
	sta _FlagRedrawInverse

no_shift
	rts
.)



; ===================
; Back to menu mode
; ===================
_KeyQuitEditing
.(
	lda #1
	sta _FlagExit
	rts
.)



;
; Let's paint a pixel if CONTROL key is pressed
;
_CheckPaintPixel
	jsr _ValidateDisplayValues

	lda _KeySpecial
	and #SPECIAL_KEY_CONTROL
	bne	do_paint_pixel
	rts

do_paint_pixel
	ldx _CurrentZoomPixelBit 
	jsr _PaintPixel
	rts


; ===================
; Cursor movement pad
; ===================
_KeyMoveLeftUp
	jsr _MoveLeft
	jsr _MoveUp
	jsr _CheckPaintPixel
	rts

_KeyMoveUp
	jsr _MoveUp
	jsr _CheckPaintPixel
	rts

_KeyMoveRightUp
	jsr _MoveRight
	jsr _MoveUp
	jsr _CheckPaintPixel
	rts

_KeyMoveLeft
	jsr _MoveLeft
	jsr _CheckPaintPixel
	rts

_KeyMoveRight
	//jmp _KeyMoveRight
	jsr _MoveRight
	jsr _CheckPaintPixel
	rts

_KeyMoveLeftDown
	jsr _MoveLeft
	jsr _MoveDown
	jsr _CheckPaintPixel
	rts

_KeyMoveDown
	jsr _MoveDown
	jsr _CheckPaintPixel
	rts

_KeyMoveRightDown
	jsr _MoveRight
	jsr _MoveDown
	jsr _CheckPaintPixel
	rts


; ===================
; Zoomer size control
; ===================
_KeyZoomerExtend
	; Increase zoomer size
	jsr _ZoomerExtend
	rts

_KeyZoomerShrink
	; Decrease zoomer size
	jsr _ZoomerShrink
	rts


; =================
; Pixel/Byte switch
; =================
_KeySwitchByteMode
.(
	lda #1
	sta _FlagRedrawZoomer
	eor _FlagPixelMode
	sta _FlagPixelMode
	beq end

	; Enabling PIXEL mode disable CODE mode
	lda #0
	sta _CurrentDisplayCode
end
	lda #1
	sta _FlagRedrawInfos
	rts
.)


; =================
; FullScreen/Zoomer switch
; =================
_KeySwitchViewMode
	lda #1
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	eor _FlagDisplayZoomer
	sta _FlagDisplayZoomer
	rts

; =================
; Zoomer in Colored/Code mode switch
; =================
_KeySwitchZoomerDisplay
.(
	lda #1
	sta _FlagRedrawZoomer
	eor _CurrentDisplayCode
	sta _CurrentDisplayCode
	beq end

	; Enabling CODE mode disable PIXEL mode
	lda #0
	sta _FlagPixelMode
end
	rts
.)


; =========================
; Copy and Paste
; =========================

_KeyCopy
	lda _PtrCurrentByte+0
	sta tmp0+0
	lda _PtrCurrentByte+1
	sta tmp0+1
	ldy #0
	lda (tmp0),y
	sta _MemorizedByte 
	rts

_KeyPaste
	lda _PtrCurrentByte+0
	sta tmp0+0
	lda _PtrCurrentByte+1
	sta tmp0+1
	ldy #0
	lda _MemorizedByte 
	sta (tmp0),y

	lda #1
	sta _FlagRedrawZoomer
	sta _FlagRedrawPicture
	sta _FlagRedrawInverse
	rts



; =========================
; Set pixel drawing mode
; =========================

_KeySetWriteMode
	lda #0
	sta _PixelDrawMode
	lda #1
	sta _FlagRedrawInfos
	rts

_KeySetEraseMode
	lda #1
	sta _PixelDrawMode
	lda #1
	sta _FlagRedrawInfos
	rts

_KeySetReverseMode
	lda #2
	sta _PixelDrawMode
	lda #1
	sta _FlagRedrawInfos
	rts


; =========================
; Byte related commands
; =========================
_KeyInvertPixels
	lda _PtrCurrentByte+0
	sta tmp0+0
	lda _PtrCurrentByte+1
	sta tmp0+1
	ldy #0
	lda (tmp0),y
	eor #63
	sta (tmp0),y

	lda #1
	sta _FlagRedrawZoomer
	sta _FlagRedrawPicture
	rts

_KeyInvertVideo
	lda _PtrCurrentByte+0
	sta tmp0+0
	lda _PtrCurrentByte+1
	sta tmp0+1
	ldy #0
	lda (tmp0),y
	eor #128
	sta (tmp0),y

	lda #1
	sta _FlagRedrawZoomer
	sta _FlagRedrawPicture
	rts




_KeyInvertProtection
	lda _FlagProtectedAttribute
	eor #1
	sta _FlagProtectedAttribute
	lda #1
	sta _FlagRedrawInfos
	rts


;
; Since this command must work even in BYTE mode,
; we need to force pixel mode before
;
_SetPixel
.(
	lda _FlagPixelMode
	pha
	lda #1
	sta _FlagPixelMode

	jsr _PaintPixel

	pla
	sta _FlagPixelMode

	lda #1
	sta _FlagRedrawZoomer
	sta _FlagRedrawPicture
	rts
.)





; =========================
; Direct pixel draw 
; =========================
_KeySetPixel0
	ldx #5
	jsr _SetPixel
	rts

_KeySetPixel1
	ldx #4
	jsr _SetPixel
	rts

_KeySetPixel2
	ldx #3
	jsr _SetPixel
	rts

_KeySetPixel3
	ldx #2
	jsr _SetPixel
	rts

_KeySetPixel4
	ldx #1
	jsr _SetPixel
	rts

_KeySetPixel5
	ldx #0
	jsr _SetPixel
	rts


; =========================
; Validate the current tool
; =========================
_KeySetPixelCurrent
	jsr _DrawTool

	lda #1
	sta _FlagRedrawZoomer
	sta _FlagRedrawPicture

	rts

						   



; ===================
; Color change
; ===================

; Pressing 1 to 8 set the color of ink
; Additionnaly pressing SHIFT set the color of paper
_SetColorChange
.(
	; Start by forcing to BYTE mode
	lda #0
	sta _FlagPixelMode

	; Then test if we change INK or PAPER
	lda _KeySpecial
	and #SPECIAL_KEY_SHIFT_LEFT
	beq set_ink
	
set_paper
	txa
	ora #16
	sta _MemorizedByte
	rts

set_ink
	stx _MemorizedByte
	rts
.)

_KeyNumber1
	ldx #0
	jmp _SetColorChange

_KeyNumber2
	ldx #1
	jmp _SetColorChange

_KeyNumber3
	ldx #2
	jmp _SetColorChange

_KeyNumber4
	ldx #3
	jmp _SetColorChange

_KeyNumber5
	ldx #4
	jmp _SetColorChange

_KeyNumber6
	ldx #5
	jmp _SetColorChange

_KeyNumber7
	ldx #6
	jmp _SetColorChange

_KeyNumber8
	ldx #7
	jmp _SetColorChange



_KeyNumber9
	; do nothing
	rts


; =========================
; Swap the two sets of coordinates
; =========================
_KeyNumber0
	lda _CurrentPixelX
	ldx _OtherPixelX
	stx _CurrentPixelX
	sta _OtherPixelX

	lda _CurrentPixelY
	ldx _OtherPixelY
	stx _CurrentPixelY
	sta _OtherPixelY

	jsr _ValidateDisplayValues

	lda #1
	sta _FlagRedrawInfos
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	sta _FlagRedrawInverse
	rts





; =========================
; Undo related
; =========================
_KeyUndoMemorize
	jsr _UndoBufferMemorize
	rts

_KeyUndoSwitch
	jsr _UndoBufferSwap

	lda #1
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	rts




; =========================
; Tool menu
; =========================
_KeyMenuTool
	jsr _HandleMenuToolSelection
	jsr _ClearHiresTextScreenPart

	lda #1
	sta _FlagRedrawInfos
	sta _FlagRedrawPicture
	sta _FlagRedrawZoomer
	rts

_HandleMenuToolSelection
.(
	;
	; Display the tool selection menu
	;
	jsr _DisplayToolMenu


	;
	; Wait for one of the tool keys
	;
.(
wait_key
	ldy #0 
	jsr _key 
	stx tmp0 
	sta tmp0+1 
	cpx #0
	beq wait_key

	; We just want the scan code
	ldx $208

	cpx #168
	beq _SetToolHandDraw
	cpx #178
	beq _SetToolLines
	cpx #184
	beq _SetToolRectangles
	cpx #154
	beq _SetToolRectanglesFilled
	cpx #144
	beq _SetToolEllipses
	cpx #138
	beq _SetToolEllipsedFilled
	cpx #128
	beq _SetToolFloodFill
	.)


	rts
.)


	; 0=hand draw
	; 1=lines
	; 2=rectangles
	; 3=rectangles (filled)
	; 4=ellipses
	; 5=ellipses (filled)
	; 6=flood fill

_SetToolHandDraw
.(
	ldx #0
	stx _CurrentTool
	rts
.)


_SetToolLines
.(
	ldx #1
	stx _CurrentTool
	rts
.)


_SetToolRectangles
.(
	ldx #2
	stx _CurrentTool
	rts
.)


_SetToolRectanglesFilled
.(
	ldx #3
	stx _CurrentTool
	rts
.)


_SetToolEllipses
.(
	ldx #4
	stx _CurrentTool
	rts
.)


_SetToolEllipsedFilled
.(
	ldx #5
	stx _CurrentTool
	rts
.)


_SetToolFloodFill
.(
	ldx #6
	stx _CurrentTool
	rts
.)








