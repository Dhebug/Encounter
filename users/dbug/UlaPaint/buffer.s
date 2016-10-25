//
// List of labels:
//
/*

Data
	_BufferMain1
	_BufferUndo
	_DrawLineOpcodes
	_RestoreBuffer

Code
	_UndoBufferSwap
	_UndoBufferMemorize
	_DisplayPictureFullScreen
	_BufferErase
	_PictureInvertWindow
	_PaintPixel
	_ClearVideoMemory
	_ClearTextScreen
	_ClearHiresTextScreenPart
	_SwitchToHires
	_SwitchToText
	_PlotPixel
	_RestorePixelFromBuffer
	_RestorePixel
	_LineRoutine
	_DrawLine
	_RestoreLine
	_DrawTool
	_RestoreToolBackground

*/


	.dsb 256-(*&255)

_BufferMain1		.dsb 8000	; Buffer that contains the picture we are currently working on


	.dsb 256-(*&255)

_BufferUndo			.dsb 8000	; Second buffer that helps us avoid mistakes !!!
					

; =========================================
; Swap between Undo buffer and main buffer
; =========================================
_UndoBufferSwap
.(
	lda #<_BufferMain1-1
	sta tmp0+0
	lda #>_BufferMain1-1
	sta tmp0+1

	lda #<_BufferUndo-1
	sta tmp1+0
	lda #>_BufferUndo-1
	sta tmp1+1

	lda #200
	sta tmp2
loop_y
	ldy #40
loop_x
	lda (tmp0),y
	tax
	lda (tmp1),y
	sta (tmp0),y
	txa
	sta (tmp1),y

	dey
	bne loop_x

	clc
	lda tmp0+0
	adc #40
	sta tmp0+0

	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp0+1
	inc tmp1+1
skip

	dec	tmp2
	bne loop_y


	rts
.)



; =========================================
; Recopy main buffer into undo buffer
; =========================================
_UndoBufferMemorize
.(
	ldx #0
loop
	lda _BufferMain1+256*0,x
	sta _BufferUndo+256*0,x
	lda _BufferMain1+256*1,x
	sta _BufferUndo+256*1,x
	lda _BufferMain1+256*2,x
	sta _BufferUndo+256*2,x
	lda _BufferMain1+256*3,x
	sta _BufferUndo+256*3,x
	lda _BufferMain1+256*4,x
	sta _BufferUndo+256*4,x
	lda _BufferMain1+256*5,x
	sta _BufferUndo+256*5,x
	lda _BufferMain1+256*6,x
	sta _BufferUndo+256*6,x
	lda _BufferMain1+256*7,x
	sta _BufferUndo+256*7,x
	lda _BufferMain1+256*8,x
	sta _BufferUndo+256*8,x
	lda _BufferMain1+256*9,x
	sta _BufferUndo+256*9,x

	lda _BufferMain1+256*10,x
	sta _BufferUndo+256*10,x
	lda _BufferMain1+256*11,x
	sta _BufferUndo+256*11,x
	lda _BufferMain1+256*12,x
	sta _BufferUndo+256*12,x
	lda _BufferMain1+256*13,x
	sta _BufferUndo+256*13,x
	lda _BufferMain1+256*14,x
	sta _BufferUndo+256*14,x
	lda _BufferMain1+256*15,x
	sta _BufferUndo+256*15,x
	lda _BufferMain1+256*16,x
	sta _BufferUndo+256*16,x
	lda _BufferMain1+256*17,x
	sta _BufferUndo+256*17,x
	lda _BufferMain1+256*18,x
	sta _BufferUndo+256*18,x
	lda _BufferMain1+256*19,x
	sta _BufferUndo+256*19,x
						 
	lda _BufferMain1+256*20,x
	sta _BufferUndo+256*20,x
	lda _BufferMain1+256*21,x
	sta _BufferUndo+256*21,x
	lda _BufferMain1+256*22,x
	sta _BufferUndo+256*22,x
	lda _BufferMain1+256*23,x
	sta _BufferUndo+256*23,x
	lda _BufferMain1+256*24,x
	sta _BufferUndo+256*24,x
	lda _BufferMain1+256*25,x
	sta _BufferUndo+256*25,x
	lda _BufferMain1+256*26,x
	sta _BufferUndo+256*26,x
	lda _BufferMain1+256*27,x
	sta _BufferUndo+256*27,x
	lda _BufferMain1+256*28,x
	sta _BufferUndo+256*28,x
	lda _BufferMain1+256*29,x
	sta _BufferUndo+256*29,x

	lda _BufferMain1+256*30,x
	sta _BufferUndo+256*30,x
	lda _BufferMain1+8000-256,x
	sta _BufferUndo+8000-256,x

	dex
	beq end_loop
	jmp loop

end_loop
	rts
.)



; =========================================
; ultra fast buffer to screen copy routine
; =========================================
_DisplayPictureFullScreen
.(
	ldx #0
loop
	lda _BufferMain1+256*0,x
	sta $a000+256*0,x
	lda _BufferMain1+256*1,x
	sta $a000+256*1,x
	lda _BufferMain1+256*2,x
	sta $a000+256*2,x
	lda _BufferMain1+256*3,x
	sta $a000+256*3,x
	lda _BufferMain1+256*4,x
	sta $a000+256*4,x
	lda _BufferMain1+256*5,x
	sta $a000+256*5,x
	lda _BufferMain1+256*6,x
	sta $a000+256*6,x
	lda _BufferMain1+256*7,x
	sta $a000+256*7,x
	lda _BufferMain1+256*8,x
	sta $a000+256*8,x
	lda _BufferMain1+256*9,x
	sta $a000+256*9,x

	lda _BufferMain1+256*10,x
	sta $a000+256*10,x
	lda _BufferMain1+256*11,x
	sta $a000+256*11,x
	lda _BufferMain1+256*12,x
	sta $a000+256*12,x
	lda _BufferMain1+256*13,x
	sta $a000+256*13,x
	lda _BufferMain1+256*14,x
	sta $a000+256*14,x
	lda _BufferMain1+256*15,x
	sta $a000+256*15,x
	lda _BufferMain1+256*16,x
	sta $a000+256*16,x
	lda _BufferMain1+256*17,x
	sta $a000+256*17,x
	lda _BufferMain1+256*18,x
	sta $a000+256*18,x
	lda _BufferMain1+256*19,x
	sta $a000+256*19,x
						 
	lda _BufferMain1+256*20,x
	sta $a000+256*20,x
	lda _BufferMain1+256*21,x
	sta $a000+256*21,x
	lda _BufferMain1+256*22,x
	sta $a000+256*22,x
	lda _BufferMain1+256*23,x
	sta $a000+256*23,x
	lda _BufferMain1+256*24,x
	sta $a000+256*24,x
	lda _BufferMain1+256*25,x
	sta $a000+256*25,x
	lda _BufferMain1+256*26,x
	sta $a000+256*26,x
	lda _BufferMain1+256*27,x
	sta $a000+256*27,x
	lda _BufferMain1+256*28,x
	sta $a000+256*28,x
	lda _BufferMain1+256*29,x
	sta $a000+256*29,x

	lda _BufferMain1+256*30,x
	sta $a000+256*30,x
	lda _BufferMain1+8000-256,x
	sta $a000+8000-256,x

	dex
	beq end_loop
	jmp loop

end_loop
	rts
.)


; =========================================
;		Erase the main picture buffer
; =========================================
_BufferErase
.(
	lda #64
	ldx #0
loop
	sta _BufferMain1+256*0,x
	sta _BufferMain1+256*1,x
	sta _BufferMain1+256*2,x
	sta _BufferMain1+256*3,x
	sta _BufferMain1+256*4,x
	sta _BufferMain1+256*5,x
	sta _BufferMain1+256*6,x
	sta _BufferMain1+256*7,x
	sta _BufferMain1+256*8,x
	sta _BufferMain1+256*9,x

	sta _BufferMain1+256*10,x
	sta _BufferMain1+256*11,x
	sta _BufferMain1+256*12,x
	sta _BufferMain1+256*13,x
	sta _BufferMain1+256*14,x
	sta _BufferMain1+256*15,x
	sta _BufferMain1+256*16,x
	sta _BufferMain1+256*17,x
	sta _BufferMain1+256*18,x
	sta _BufferMain1+256*19,x
						 
	sta _BufferMain1+256*20,x
	sta _BufferMain1+256*21,x
	sta _BufferMain1+256*22,x
	sta _BufferMain1+256*23,x
	sta _BufferMain1+256*24,x
	sta _BufferMain1+256*25,x
	sta _BufferMain1+256*26,x
	sta _BufferMain1+256*27,x
	sta _BufferMain1+256*28,x
	sta _BufferMain1+256*29,x

	sta _BufferMain1+256*30,x
	sta _BufferMain1+8000-256,x

	dex
	bne loop
	rts
.)




_PictureInvertWindow
.(
	clc
	ldx _CurrentZoomY
	lda #<_BufferMain1
	adc _HiresAddrLow,x
	sta tmp0+0
	lda #>_BufferMain1
	adc _HiresAddrHigh,x
	sta tmp0+1

	ldx _CurrentLineCount
loop_y
	ldy _CurrentZoomX
	lda (tmp0),y
	eor #128		
	sta (tmp0),y

	iny 
	lda (tmp0),y
	eor #128		
	sta (tmp0),y

	iny 
	lda (tmp0),y
	eor #128		
	sta (tmp0),y

	iny 
	lda (tmp0),y
	eor #128		
	sta (tmp0),y

	iny 
	lda (tmp0),y
	eor #128		
	sta (tmp0),y

	iny 
	lda (tmp0),y
	eor #128		
	sta (tmp0),y

	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip_inc
	inc tmp0+1
skip_inc

	dex
	bne loop_y

	rts
.)



;
; X: Index of pixel to paint
;
_PaintPixel
	lda #0
	sta _FlagRedrawInverse

	lda _PtrCurrentByte+0
	sta tmp0+0
	lda _PtrCurrentByte+1
	sta tmp0+1

	lda _FlagPixelMode
	bne _PaintPixel_PixelMode

_PaintPixel_ByteMode
.(
	;
	; In byte mode, we paint with the memorised byte
	;
	ldy #0
	lda _MemorizedByte
	sta (tmp0),y
	rts
.)


_PaintPixel_PixelMode
.(
	;
	; In pixel mode, we paint with pixels
	;
	lda _TableBit6Reverse,x
	sta tmp1					; Binary mask

	;
	; Dispatch on the right code depending of if we
	; are working on a pixel bloc, or attribute bloc
	;
	ldy #0
	lda (tmp0),y			; Get the byte from picture
	bpl is_not_inverted
	and #127				; clear the video inverse flag
is_not_inverted
	cmp #32
	bcs operation_on_pixels

operation_on_attribute
.(
	lda  _FlagProtectedAttribute
	bne  keep_attributes

	; Ok, attributes are not protected, so we replace it by a
	; bloc of pixels
	lda #64
	sta (tmp0),y
	jmp operation_on_pixels

;
; Ok, well, we are on an attribute in protected mode, just leave !
;
keep_attributes
	rts
.)


;
; When we are here, we don't have to worry about attributes at all
;
operation_on_pixels
.(
	ldx _PixelDrawMode
	beq write_mode
	dex
	beq erase_mode

reverse_mode
	lda (tmp0),y
	eor tmp1
	sta (tmp0),y
	rts
	
write_mode
	lda (tmp0),y
	ora tmp1
	sta (tmp0),y
	rts

erase_mode
	lda tmp1		; Get the binary mask	 => [0-0-00010]
	eor #%11111111	; Inverse the pixel mask => [1-1-11101]
	and (tmp0),y	; Clear the right bit
	sta (tmp0),y	
	rts
.)

.)



; Erase, filling with BLACK ink, all the area going from 
; $9800 to $c000 = 10240 bytes = 256*40
_ClearVideoMemory
.(
	ldx #0
loop
	sta $9800+256*0,x
	sta $9800+256*1,x
	sta $9800+256*2,x
	sta $9800+256*3,x
	sta $9800+256*4,x
	sta $9800+256*5,x
	sta $9800+256*6,x
	sta $9800+256*7,x
	sta $9800+256*8,x
	sta $9800+256*9,x

	sta $9800+256*10,x
	sta $9800+256*11,x
	sta $9800+256*12,x
	sta $9800+256*13,x
	sta $9800+256*14,x
	sta $9800+256*15,x
	sta $9800+256*16,x
	sta $9800+256*17,x
	sta $9800+256*18,x
	sta $9800+256*19,x

	sta $9800+256*20,x
	sta $9800+256*21,x
	sta $9800+256*22,x
	sta $9800+256*23,x
	sta $9800+256*24,x
	sta $9800+256*25,x
	sta $9800+256*26,x
	sta $9800+256*27,x
	sta $9800+256*28,x
	sta $9800+256*29,x

	sta $9800+256*30,x
	sta $9800+256*31,x
	sta $9800+256*32,x
	sta $9800+256*33,x
	sta $9800+256*34,x
	sta $9800+256*35,x
	sta $9800+256*36,x
	sta $9800+256*37,x
	sta $9800+256*38,x
	sta $9800+256*39,x

	dex
	bne loop
	rts
.)


_ClearTextScreen
.(
	lda #32
	ldx #0
loop
	sta $bb80+256*0,x
	sta $bb80+256*1,x
	sta $bb80+256*2,x
	sta $bb80+256*3,x
	sta $bfe0-257,x

	dex
	bne loop
	rts
.)


_ClearHiresTextScreenPart
.(
	lda #32
	ldx #0
loop
	sta $bb80+40*25,x

	inx
	cpx #120-1	; Avoid erasing the "back to hires" attribute
	bne loop
	rts
.)



_SwitchToHires
.(
	lda #0
	jsr _ClearVideoMemory

	; Write HIRES attribute in the last byte of video memory
	lda #30
	sta $bb80+(40*28)-1

	; Copy charset to hires area $9800
.(
	ldx #0
loop
	lda _FuturisticFont+256*0,x
	sta $9800+256*0,x
	lda _FuturisticFont+256*1,x
	sta $9800+256*1,x
	lda _FuturisticFont+256*2,x
	sta $9800+256*2,x
	lda _FuturisticFont+256*3,x
	sta $9800+256*3,x

	dex
	bne loop
.)

	; Clear the 3 lines of text
	jsr _ClearHiresTextScreenPart
	rts
.)


_SwitchToText
.(
	lda #0
	jsr _ClearVideoMemory

	; Write TEXT attribute in the last byte of video memory
	lda #26
	sta $bb80+(40*28)-1

	; Copy charset to text area $B400
.(
	ldx #0
loop
	lda _FuturisticFont+256*0,x
	sta $B400+256*0,x
	lda _FuturisticFont+256*1,x
	sta $B400+256*1,x
	lda _FuturisticFont+256*2,x
	sta $B400+256*2,x
	lda _FuturisticFont+256*3,x
	sta $B400+256*3,x

	dex
	bne loop
.)

	rts
.)








x1	.byt 0
y1	.byt 0
x2	.byt 0
y2	.byt 0

x	.byt 0
y	.byt 0
dx	.byt 0,0	; 2 byte
dy	.byt 0,0	; 2 bytes
s1	.byt 0		; 0=dec 2=inc 4=nop
s2	.byt 0		; 0=dec 2=inc 4=nop

i	.byt 0

e	.byt 0,0	; 2 bytes



; 00 = Decrement = 0
; 01 = Increment = 2
; 10 = Rien		 = 4
; 11 = Rien      = 6

; 0  = X
; 1  = Y

_DrawLineOpcodes
				; 42 1
	.byt $CA	; 00 0	 DEC X
	.byt $88	; 00 1	 DEC Y
	.byt $E8	; 01 0	 INC X
	.byt $C8	; 01 1	 INC Y
	.byt $EA	; 10 0	 NOP
	.byt $EA	; 10 1	 NOP
	.byt $EA	; 11 0	 NOP
	.byt $EA	; 11 1	 NOP


	.dsb 256-(*&255)

_RestoreBufferX		.dsb 256
_RestoreBufferY		.dsb 256
_RestoreBufferIndex	.byt 0


_PlotPixel
	stx x
	sty y
	pha

	ldx _RestoreBufferIndex

	lda x
	sta _RestoreBufferX,x
	lda y
	sta _RestoreBufferY,x

	inc _RestoreBufferIndex

	clc
	lda _HiresAddrLow,y	   
	adc #<_BufferMain1	// $a000
	sta tmp0+0
	lda _HiresAddrHigh,y
	adc #>_BufferMain1	// $a000
	sta tmp0+1

	ldx x
	lda _TableMod6,x
	ldy _TableDiv6,x
	tax
	lda (tmp0),y
	ora _TableBit6Reverse,x
	sta (tmp0),y

	pla
	ldy y
	ldx x
	rts




	/*
_RestorePixelFromBuffer
	stx x
	sty y
	pha

	ldy y
	clc
	lda _HiresAddrLow,y
	adc #<_BufferMain1
	sta tmp0+0
	lda _HiresAddrHigh,y
	adc #>_BufferMain1
	sta tmp0+1

	dec _restore_pixel_patch+1

	ldx x
	ldy _TableDiv6,x
_restore_pixel_patch
	lda _RestoreBuffer
	sta (tmp0),y

	pla
	ldy y
	ldx x
	rts
	*/





_RestorePixel
.(
	stx x
	sty y
	pha

	ldy y
	clc
	lda _HiresAddrLow,y
	adc #<_BufferUndo
	sta tmp0+0
	lda _HiresAddrHigh,y
	adc #>_BufferUndo
	sta tmp0+1

	clc
	lda _HiresAddrLow,y
	adc #<_BufferMain1
	sta tmp1+0
	lda _HiresAddrHigh,y
	adc #>_BufferMain1
	sta tmp1+1


	ldx x
	ldy _TableDiv6,x
	lda (tmp0),y
	sta (tmp1),y

	pla
	ldy y
	ldx x
	rts
.)




_LineRoutine
	;
	; Compute deltas and signs
	;
  ; Test X value
.(
	lda x1
	cmp x2
	beq equal
	bcc cur_smaller

cur_bigger					; x1>x2
	sec
	sbc x2
	sta dx

	lda #0	; DEC
	sta s1
	jmp end

equal
	lda #4	; NOP
	sta s1

	lda #0
	sta dx
	jmp end

cur_smaller					; x1<x2
	sec
	lda x2
	sbc x1
	sta dx

	lda #2	; INC
	sta s1
end
.)


  ; Test Y value
.(
	lda y1
	cmp y2
	beq equal
	bcc cur_smaller

cur_bigger					; y1>y2
	sec
	sbc y2
	sta dy

	lda #0
	sta s2
	jmp end

equal
	lda #4	; NOP
	sta s2

	lda #0
	sta dy
	jmp end

cur_smaller					; y1<y2
	sec
	lda y2
	sbc y1
	sta dy

	lda #2
	sta s2
end
.)



	;
	; Compute slope
	;
.(
	lda dy
	cmp dx
	bcc dy_smaller

dy_bigger					; dy>dx
	ldx dx
	stx dy
	sta dx

	lda #0	; X
	ora s1
	tax

	lda #1	; Y
	ora s2
	tay

	jmp end


dy_smaller					; dx<dy
	lda #1	; Y
	ora s2
	tax

	lda #0	; X
	ora s1
	tay
end
.)

	;
	; Patch the code
	;
	lda _DrawLineOpcodes,x
	sta _inner_patch

	lda _DrawLineOpcodes,y
	sta _outer_patch


	;
	; Initialize counter
	;
	ldx dx
	inx
	stx i


	; Initialise e
	clc
	lda dy
	adc dy
	sta dy
	sta e
	lda #0
	adc #0
	sta dy+1
	sta e+1

	sec
	lda e
	sbc dx
	sta e
	lda e+1
	sbc #0
	sta e+1



	clc
	lda dx
	adc dx
	sta dx
	lda #0
	adc #0
	sta dx+1


	;
	; Initialise start coordinates
	;
	ldx x1
	ldy y1

	;
	; Draw loop
	;
outer_loop
	lda i
	beq end_line
	dec i

_ploter_routine_path
	jsr _PlotPixel

inner_loop
	lda e+1
	bmi end_inner_loop

_inner_patch
	iny

	; e=e-2*dx
	sec
	lda e
	sbc dx
	sta e
	lda e+1
	sbc dx+1
	sta e+1

	jmp inner_loop


end_inner_loop

_outer_patch
	inx

	; e=e+2*dy

	clc
	lda e
	adc dy
	sta e
	lda e+1
	adc dy+1
	sta e+1

	jmp outer_loop

end_line
	;jmp end_line


	rts





; =========================================
; Draw a line into the picture buffer
; =========================================
_DrawLine
	lda _CurrentPixelX
	sta x1
	lda _CurrentPixelY
	sta y1

	lda _OtherPixelX
	sta x2
	lda _OtherPixelY
	sta y2


	lda #<_PlotPixel
	sta _ploter_routine_path+1
	lda #>_PlotPixel
	sta _ploter_routine_path+2

	//lda #<_RestoreBuffer
	//sta _plot_pixel_patch+1

	jmp _LineRoutine


; =========================================
; Restore a line from the undo buffer
; =========================================
_RestoreLine
	//jmp _RestoreLine
	
loop
	dec _RestoreBufferIndex
	lda _RestoreBufferIndex

	tax
	lda _RestoreBufferX,x
	sta x
	lda _RestoreBufferY,x
	sta y

	ldy y
	clc
	lda _HiresAddrLow,y
	adc #<_BufferUndo
	sta tmp0+0
	lda _HiresAddrHigh,y
	adc #>_BufferUndo
	sta tmp0+1

	clc
	lda _HiresAddrLow,y
	adc #<_BufferMain1
	sta tmp1+0
	lda _HiresAddrHigh,y
	adc #>_BufferMain1
	sta tmp1+1

	ldx x
	ldy _TableDiv6,x
	lda (tmp0),y
	sta (tmp1),y

	lda _RestoreBufferIndex
	bne loop

	/*
	lda _CurrentPixelX
	sta x2
	lda _CurrentPixelY
	sta y2

	lda _OtherPixelX
	sta x1
	lda _OtherPixelY
	sta y1


	lda #<_RestorePixelFromBuffer
	sta _ploter_routine_path+1
	lda #>_RestorePixelFromBuffer
	sta _ploter_routine_path+2

	lda #<_RestoreBuffer
	sta _restore_pixel_patch+1
	
	jmp _LineRoutine
	*/




; =========================================
; Draw a tool into the picture buffer
; =========================================
_DrawTool
.(
	ldx _CurrentTool
	beq validate_hand_draw
	dex
	beq validate_line
	dex
	beq validate_rectangle
	rts

validate_line
	jsr _DrawLine
	rts

validate_rectangle
	rts

validate_hand_draw
	//rts
	ldx _CurrentZoomPixelBit 
	jsr _PaintPixel

	rts
.)



; =========================================
; Restore a tool from the undo buffer
; =========================================
_RestoreToolBackground
.(
	ldx _CurrentTool
	beq validate_hand_draw
	dex
	beq validate_line
	dex
	beq validate_rectangle
	rts

validate_line
	jsr _RestoreLine
	rts

validate_rectangle
	rts

validate_hand_draw
	//rts
	ldx _CurrentPixelX
	ldy _CurrentPixelY
	jsr _RestorePixel

	rts
.)











