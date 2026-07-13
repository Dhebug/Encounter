#include "params.h"

    .zero

OldByte	.dsb 1

_angle          .dsb 1
_y              .dsb 1
_position       .dsb 1
_skipTop        .dsb 1      ; 1 = picture is stationary AND caller permits skipping the top redraw; 0 = redraw

_height         .dsb 1
_frameCount     .dsb 1

_ptrSrc          .dsb 2
_ptrDst          .dsb 2
_ptrDstBottom    .dsb 2

_setupSpacing   .dsb 1
_setupY         .dsb 1

_setupColorsPaper  .dsb 2   ; [0]=top half (lines 0..124), [1]=bottom half (lines 125..199)
_setupColorsInk    .dsb 2   ; [0]=top half (lines 0..124), [1]=bottom half (lines 125..199)

    .text


_GenerateTables
.(
    .(
    ; Patch CosTable: x*3/255 is piecewise constant — 0..84 -> 0, 85..169 -> 1, 170..254 -> 2, 255 -> 3.
    ; Also generate the vertical distortion offset table.
    ; Basically a simplified version of the Cos table but with precomputed multiples of 40 scanline offsets
    ldx #0
loop
    lda _CosTable,x       ; Input is a 8 bit value (0 to 254) range
    ldy #0
    cmp #85
    bcc store
    iny
    cmp #170
    bcc store
    iny
    cmp #255
    bcc store
    iny
store
    tya
    sta _CosTable,x         ; Rewrite value in the 0 to 3 range for horizontal distortion
    lda vsoffset_table,y
    sta _CosTableTimes40,x  ; And *40 variant table for vertical offset
    inx
    bne loop
    .)

    .(
    ; Generate the table of HIRES scanline start addresses
    lda #<$a000
    sta _HiresLineLow
    lda #>$a000
    sta _HiresLineHigh

    ldx #0
loop
    clc
    lda _HiresLineLow,x
    adc #40
    sta _HiresLineLow+1,x
    lda _HiresLineHigh,x
    adc #0
    sta _HiresLineHigh+1,x
    inx
    cpx #199
    bne loop
    .)
    rts

vsoffset_table
    .byt 0, 40, 80, 120
.)



;
; Chains DisplayMakeShiftedLogo five times to populate _LabelPicture1.._LabelPicture5 with each next sub-pixel shift of _LabelPicture0.
;
_GenerateLogoPreshiftsAsm
.(
    ldx #0
loop
    lda _DistorterTableLo,x
    sta _ptrSrc+0
    lda _DistorterTableHi,x
    sta _ptrSrc+1
    lda _DistorterTableLo+1,x
    sta _ptrDst+0
    lda _DistorterTableHi+1,x
    sta _ptrDst+1

    txa
    pha
    
    ldx #74
LoopDisplayMakeShiftedLogo_Y

	ldy #0
	sty OldByte
LoopDisplayMakeShiftedLogo_X
	lda (_ptrSrc),y
	pha
	and #63
	lsr 
	ora	OldByte
	ora #64
	sta (_ptrDst),y

	pla
	and #1
	asl
	asl
	asl
	asl
	asl
	sta OldByte

	iny 
	cpy #40
	bne LoopDisplayMakeShiftedLogo_X

	clc
	lda _ptrSrc
	adc #40
	sta _ptrSrc
	bcc skip_src
	inc _ptrSrc+1
	clc
skip_src

	lda _ptrDst
	adc #40
	sta _ptrDst
	bcc skip_dst
	inc _ptrDst+1
skip_dst

    txa
    pha
    ; Try to get the menu working during pre-calc
    jsr _CheckOptionMenuInput
    pla
    tax

	dex
	bne LoopDisplayMakeShiftedLogo_Y

    pla
    tax

    inx
    cpx #5
    bne loop
    rts
.)



.(

; Called by the two color update functions, basically writes a bunch of paper and ink attribute
; at the start of each scanlines, with an adjustable "jump over" spacing parameter to skip some lines
WriteColorAttributes
.(
    lda #0
    sta _setupY

loop
    ldx _setupY
    lda _HiresLineLow,x
    sta _ptrDst+0
    lda _HiresLineHigh,x
    sta _ptrDst+1

    cpx #125      ; Comparison result in the carry flag
    lda #0
    rol             ; A = carry from cpx: 0 if top half, 1 if bottom half
    tax

    ldy #0
    lda _setupColorsPaper,x
    sta (_ptrDst),y
    iny
    lda _setupColorsInk,x
    sta (_ptrDst),y

    clc
    lda _setupY
    adc _setupSpacing
    sta _setupY
    cmp #200
    bcc loop
    rts
.)


; Reads one key, stores it in _gMenuKeyOption, runs _HandleSettingsMenu when a non-quit key was pressed.
; Returns C=1 if the caller should bail out (RETURN, SPACE, or _ShouldQuit), C=0 otherwise.
CheckMenuOrQuit
.(
    jsr _ReadKeyNoBounce
    stx _gMenuKeyOption
    cpx #KEY_RETURN
    beq quit
    cpx #KEY_SPACE
    beq quit
    lda _ShouldQuit
    bne quit
    cpx #0
    beq no_menu
    jsr _HandleSettingsMenu
no_menu
    clc
    rts
quit
    sec
    rts
.)


; Progressive color transition using two sets of ink and paper colors
; Detects the user keyboard interactions and either call the menu system or returns 1 to indicate the user wants to quit.
wait_count      .byt 0

+_SetupColorsAsm
.(
    lda #16
    sta _setupSpacing
    .(
spacing_loop
    jsr WriteColorAttributes

    ; Idle for _setupSpacing/2 frames (8, 4, 2, 1, 0), polling the menu.
    ; spacing=1 yields zero frames so the final pass returns immediately.
    lda _setupSpacing
    lsr
    beq next_spacing
    sta wait_count

wait_loop
    jsr _WaitIRQ
    jsr CheckMenuOrQuit
    bcs return_one
    dec wait_count
    bne wait_loop

next_spacing
    lsr _setupSpacing
    bne spacing_loop
    .)
    beq return_zero

; Similar to _SetupColorsAsm, but calls the distorter animation as well
+_SetupColorsAnimatedAsm
    lda #16
    sta _setupSpacing
    .(
spacing_loop
    jsr WriteColorAttributes

    lda #0                  ; force redraw each pass — set_stopmoving keeps re-latching _skipTop to 1
    sta _skipTop
    lda #2
    sta _frameCount

    jsr _ContinueLogoAnimation
    cpx #0
    bne return_one

    lsr _setupSpacing
    bne spacing_loop
    .)

return_zero    
    lda #0
    tax
    rts

return_one
    lda #1
    tax
    rts

+_ShowLogoAnimation
    lda #0
    sta _skipTop            ; redraw top while scrolling; set_stopmoving latches to 1 once stationary
    ; fall through

; Alternate entry point: runs more frames using the existing _position state.
; Used to keep the river rippling during the inter-logo color fade.
+_ContinueLogoAnimation

; Frame-local register aliases for readability
angle2          = tmp4+0
angle3          = tmp4+1
angle4          = tmp5+0
offset          = tmp2+0
sumOffset       = tmp3
sourceOffset    = tmp6
&srcPtr         = tmp0   ; @ptr16
&dstPtr         = _ptrDstBottom   ; @ptr16

frame_loop
    dec _frameCount
    beq return_zero

    lda _DistorterTableLo
    sta _ptrSrc+0
    lda _DistorterTableHi
    sta _ptrSrc+1

    sec                      ; Compute top part draw address (with the scrolling logo)
    lda #125
    sbc _position
    tax
    lda _HiresLineLow,x
    sta _ptrDst+0
    lda _HiresLineHigh,x
    sta _ptrDst+1

    lda _position            ; Same thing for the bottom part (with the compressed reflection)
    lsr
    clc
    adc #125
    tax
    lda _HiresLineLow,x
    sta _ptrDstBottom+0
    lda _HiresLineHigh,x
    sta _ptrDstBottom+1

    lda _angle               ; Initialize the multiple angles to the same starting value
    sta angle2
    sta angle3
    sta angle4
    clc
    adc #5
    sta _angle

    lda #0
    sta sourceOffset+0
    sta sourceOffset+1
    sta _y

    jsr y_loop

    jsr CheckMenuOrQuit
    bcs return_one

    lda _skipTop
    bne frame_loop          ; already stopped — skip the position update entirely

    lda _height
    clc
    adc #5
    cmp _position
    bcc set_stopmoving
    beq set_stopmoving
    inc _position
    bne frame_loop

set_stopmoving
    inc _skipTop
    bne frame_loop


y_loop
    cmp _position           ; Check _y with current position (we draw the "n" first lines of the logo when it scrolls up)
    bcc draw_logo
    rts

draw_logo
    lda _skipTop
    bne do_bottom

do_top                ; Section of the screen at the top where the logo is shown normally
    .(
    jsr Copy38Top           ; Display a scanline at the top of the screen

    clc
    lda _ptrDst+0
    adc #40
    sta _ptrDst+0
    bcc skip1
    inc _ptrDst+1
skip1

    clc
    lda _ptrSrc+0
    adc #40
    sta _ptrSrc+0
    bcc skip2
    inc _ptrSrc+1
skip2
    .)

do_bottom           ; Section of the screen where we have the mirrored distorted logo reflection at the bottom
    lda _y
    lsr
    bcc skip_bottom_odd_lines

    ; Early out: if y >= height, the source picture has run out — skip the bottom-half copy
    ; (relies on the picture being padded with paper-color rows so the line stays paper).
    lda _y
    cmp _height
    bcs bottom_advance

    clc
    lda angle2
    adc #5
    sta angle2
    tax
    lda _CosTable,x
    ldx angle3
    clc
    adc _CosTable,x
    sta offset
    clc
    txa
    adc #7
    sta angle3

    clc
    lda angle4
    adc #11
    sta angle4
    tax

    ; dstPtr is aliased to _ptrDstBottom (the line base; Copy/Erase38 write at offsets 2..39)
    clc
    lda sourceOffset+0
    adc _CosTableTimes40,x
    sta sumOffset+0
    lda sourceOffset+1
    adc #0
    sta sumOffset+1

    ; srcPtr = DistorterTable[offset] + sumOffset
    ; (Copy38Bottom reads offsets 2..39 of srcPtr; sumOffset already holds sourceOffset+vertical distortion offset)
    ldx offset
    clc
    lda _DistorterTableLo,x
    adc sumOffset+0
    sta srcPtr+0
    lda _DistorterTableHi,x
    adc sumOffset+1
    sta srcPtr+1

    .(
    jsr Copy38Bottom
&bottom_advance
    clc
    lda sourceOffset+0
    adc #80
    sta sourceOffset+0
    bcc skip1
    inc sourceOffset+1
skip1

    sec
    lda _ptrDstBottom+0
    sbc #40
    sta _ptrDstBottom+0
    bcs skip2
    dec _ptrDstBottom+1
skip2
    .)

skip_bottom_odd_lines
    inc _y
    lda _y
    jmp y_loop
.)


; Copy 38 bytes from (_ptrSrc)+2 to (_ptrDst)+2, leaving the first two bytes containing the paper and ink attributes untouched
Copy38Top
    ldy #39
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    dey
    lda (_ptrSrc),y
    sta (_ptrDst),y
    rts


; Copy 38 bytes from (srcPtr)+2 to (dstPtr)+2, leaving the first two bytes containing the paper and ink attributes untouched
Copy38Bottom
    ldy #39
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    dey
    lda (srcPtr),y
    sta (dstPtr),y
    rts


+_Clear38Columns
.(
    lda #<$a000
    sta dstPtr+0
    lda #>$a000
    sta dstPtr+1

    ldx #200
loop_scanline
    ;jsr Erase38Bytes
    lda #64
    ldy #39
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y
    dey
    sta (dstPtr),y    

    clc
    lda dstPtr+0
    adc #40
    sta dstPtr+0
    bcc skip
    inc dstPtr+1
skip

    dex
    beq quit
    jmp loop_scanline
quit    
    rts
.)


.)   ; ---- end of logo animation subsystem ----


; Entry 0 is patched at runtime by SetLogoSource() before each animation.
_DistorterTableLo       .byt 0, <_LabelPicture1, <_LabelPicture2, <_LabelPicture3, <_LabelPicture4, <_LabelPicture5
_DistorterTableHi       .byt 0, >_LabelPicture1, >_LabelPicture2, >_LabelPicture3, >_LabelPicture4, >_LabelPicture5
