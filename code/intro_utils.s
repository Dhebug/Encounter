
#include "intro.h"

    .text



; Assembly version of "int Wait2(unsigned int frameCount, unsigned char referenceFrame)"
; Input: param0.uint = frameCount, param1.uchar = referenceFrame
; Output: X=0/1 (timed out/key pressed), A=0 (high byte), Z flag matches X
;
; Waits until (VblCounter - referenceFrame) >= frameCount.
; Only checks RETURN, SPACE, ESC to exit early.
_Wait2Asm
.(
loop
    ; Check if (VblCounter - referenceFrame) >= frameCount
    lda _VblCounter
    sec
    sbc _param1              ; A = VblCounter - referenceFrame (8-bit wrapping subtraction)
    cmp _param0+0            ; Compare low byte (frameCount is small, high byte assumed 0)
    bcs wait_return_0        ; If elapsed >= frameCount, done

    jsr _WaitIRQ
    jsr _ReadKeyNoBounce     ; Result in X

    cpx #KEY_RETURN
    beq key_pressed
    cpx #" "
    beq key_pressed
    cpx #KEY_ESC
    beq key_pressed
    bne loop

key_pressed
    ; WaitFrames(4)
    lda #4
    sta _param0+0
    lda #0
    sta _param0+1
    jsr _WaitFramesAsm
    jmp wait_return_1
.)

; Assembly version of "int Wait(int frameCount)"
; Input: param0.uint = frameCount (16-bit)
; Output: X=0/1 (timed out/key pressed), A=0 (high byte), Z flag matches X
;
; Waits frameCount frames while checking for key presses:
; - ESC/UP/DOWN: set gShouldExit=1, return 1
; - LEFT: go back a page (quadruple reading delay), return 1
; - RIGHT: go forward a page (normal reading delay), return 1
; - Any other key: show key controls hint (if not on title and not starting game)
;
left_pressed
    lda #4
    sta _gWaitAndFadeMultiplicator
    lda #0
    sta _gWaitAndFadeMultiplicator+1
    ; gIntroPage = (gIntroPage + _INTRO_COUNT_ - 2)
    lda _gIntroPage
    clc
    adc #(_INTRO_COUNT_ - 2)
    ; if gIntroPage >= _INTRO_COUNT_, subtract _INTRO_COUNT_
    cmp #_INTRO_COUNT_
    bcc left_no_wrap
    sbc #_INTRO_COUNT_
left_no_wrap
    sta _gIntroPage
    beq wait_return_1

right_pressed
    lda #1
    sta _gWaitAndFadeMultiplicator
    lda #0
    sta _gWaitAndFadeMultiplicator+1
    beq wait_return_1

wait_return_0
    lda #0
    tax             ; X=0, Z=1 (set)
    rts

exit_pressed
    lda #1
    sta _gShouldExit
wait_return_1
    lda #0
    ldx #1          ; X=1, Z=0 (clear)
    rts

; Z flag is set correctly on exit: Z=1 when X=0, Z=0 when X=1.
_WaitAsm
.(
loop
    ; Decrement frameCount (16-bit), exit if underflow
    lda _param0+0
    bne no_high_dec
    lda _param0+1
    beq wait_return_0            ; Both bytes zero, we're done
    dec _param0+1
no_high_dec
    dec _param0+0

    jsr _WaitIRQ
    jsr _ReadKeyNoBounce        ; Result in X, Z=1 if no key
    beq loop                    ; No key pressed, continue waiting

    ; Check exit keys: ESC=10, UP=6, DOWN=8
    cpx #KEY_ESC
    beq exit_pressed
    cpx #KEY_UP
    beq exit_pressed
    cpx #KEY_DOWN
    beq exit_pressed

    cpx #KEY_LEFT
    beq left_pressed
    cpx #KEY_RIGHT
    beq right_pressed

    ; Any other key: show hint if conditions are met
    lda _gIntroPage
    cmp #INTRO_TITLE_PICTURE
    beq loop                    ; Don't show hint on title picture
    lda _gGameStarting
    bne loop                    ; Don't show hint when game is starting

    ; Save gPrintAddress, set up and print the hint
    lda _gPrintAddress+0
    pha
    lda _gPrintAddress+1
    pha
    lda #40
    sta _gPrintWidth
    lda #255                    ; TEXT_END
    sta _gPrintTerminator
    lda #<_Text_KeyControls
    sta _param0+0
    lda #>_Text_KeyControls
    sta _param0+1
    lda #<($bb80+40*27)
    sta _gPrintAddress+0
    lda #>($bb80+40*27)
    sta _gPrintAddress+1
    lda #0
    sta _gPrintPos
    jsr _PrintStringInternal
    ; Restore gPrintAddress
    pla
    sta _gPrintAddress+1
    pla
    sta _gPrintAddress+0
    jmp loop
.)




; Assembly version of "int WaitAndFade(int frameCount)"
; Input: param0.uint = frameCount
; Output: X=0/1 (timed out/key pressed), A=0 (high byte)
;
; Multiplies frameCount by gWaitAndFadeMultiplicator, calls WaitAsm,
; then calls FadeToBlack if Wait didn't exit early.
_WaitAndFadeAsm
.(
    ; Multiply param0 (frameCount) by gWaitAndFadeMultiplicator (int, but typically 1 or 4)
    ldx _gWaitAndFadeMultiplicator
    dex
    beq end_multiply          ; If multiplicator is 1, skip
    ; Store original value
    lda _param0+0
    sta tmp0
    lda _param0+1
    sta tmp0+1
multiply_loop
    clc
    lda _param0+0
    adc tmp0
    sta _param0+0
    lda _param0+1
    adc tmp0+1
    sta _param0+1
    dex
    bne multiply_loop

end_multiply
    jsr _WaitAsm   ; WaitAsm sets Z flag: Z=0 means key pressed (X=1), Z=1 means timed out (X=0) 
    bne done
    ; Otherwise call FadeToBlack — it's a C function, returns in X/A too
    jsr _FadeToBlack
done
    rts
.)


; No-op to avoid a linker bug
_PrintInformationMessageAsm
_DrawArrows
    rts

; Screen base + 144 scanlines (constant offset where the paper starts drawing from)
PAPER_DEST_BASE = $A000 + 144*40 - 1       ; Pre-subtracted by 1 ($B67F)
; Roller zone: the physical roller area on screen that must not be overwritten
ROLLER_ZONE_TOP = $A000 + 120*40 - 1       ; $B2BF (pre-subtracted)
ROLLER_ZONE_BOT = $A000 + 126*40 - 1       ; $B3AF (pre-subtracted)

; ============================================
; InitPaperSheet - call once before the typewriter sequence starts
; ============================================
; Computes the initial sourcePtr from gYPos and caches it.
_InitPaperSheet
.(
    ; sourcePtr = ImageBuffer - 1 + (gYPos+2)*320 (pre-subtracted by 1)
    lda #<(_ImageBuffer-1)
    sta _gSourcePtrBase
    lda #>(_ImageBuffer-1)
    sta _gSourcePtrBase+1

    lda _gYPos
    clc
    adc #2
    tax                             ; X = gYPos+2

    ; height = (gYPos+2)*8
    asl
    asl
    asl
    sta _gPaperSheetHeight

    ; Add X*320 ($0140)
    cpx #0
    beq done
add_320
    clc
    lda _gSourcePtrBase
    adc #$40
    sta _gSourcePtrBase
    lda _gSourcePtrBase+1
    adc #$01
    sta _gSourcePtrBase+1
    dex
    bne add_320
done
    rts
.)

_gSourcePtrBase .word 0

; ============================================
; DisplayPaperSheet (full assembly version)
; ============================================
; Draws the typewriter paper sheet with bending effect.
; Uses cached _gSourcePtrBase (updated by CarriageReturn).
_DisplayPaperSheet
.(
    ; --- sourcePtr from cache ---
    lda _gSourcePtrBase
    sta _param0
    lda _gSourcePtrBase+1
    sta _param0+1

    ; --- destPtr (constant, pre-subtracted) ---
    lda #<PAPER_DEST_BASE
    sta _param1
    lda #>PAPER_DEST_BASE
    sta _param1+1

    ; --- Compute border parameters based on gXPos ---
    lda _gXPos
    cmp #19
    bcs right_border

    ; Left border: borderOffset=0, borderWidth=19-gXPos, destOffset=borderWidth, sourceOffset=0
    lda #19
    sec
    sbc _gXPos
    sta _TypeWriterBorderWidth
    sta _param2+1                   ; destOffset = borderWidth
    lda #0
    sta _param2+0                   ; sourceOffset = 0

    ; TypeWriterBorderRead = ImageBuffer2 + 5759 (borderOffset=0, -1)
    lda #<(_ImageBuffer2+5759)
    sta _TypeWriterBorderRead
    lda #>(_ImageBuffer2+5759)
    sta _TypeWriterBorderRead+1

    ; TypeWriterBorderWrite = destPtr (pre-subtracted, no borderOffset for left border)
    lda #<PAPER_DEST_BASE
    sta _TypeWriterBorderWrite
    lda #>PAPER_DEST_BASE
    sta _TypeWriterBorderWrite+1

    jmp setup_paper_width

right_border
    ; Right border: borderWidth=gXPos-18, borderOffset=40-width, sourceOffset=width-1, destOffset=0
    lda _gXPos
    sec
    sbc #18
    sta _TypeWriterBorderWidth
    sec
    sbc #1
    sta _param2+0                   ; sourceOffset = width-1
    lda #0
    sta _param2+1                   ; destOffset = 0

    ; borderOffset = 40 - borderWidth
    lda #40
    sec
    sbc _TypeWriterBorderWidth      ; A = borderOffset

    ; TypeWriterBorderRead = ImageBuffer2 + 5759 + borderOffset
    clc
    adc #<(_ImageBuffer2+5759)
    sta _TypeWriterBorderRead
    lda #>(_ImageBuffer2+5759)
    adc #0
    sta _TypeWriterBorderRead+1

    ; TypeWriterBorderWrite = destPtr + borderOffset
    lda #40
    sec
    sbc _TypeWriterBorderWidth      ; recompute borderOffset
    clc
    adc #<PAPER_DEST_BASE
    sta _TypeWriterBorderWrite
    lda #>PAPER_DEST_BASE
    adc #0
    sta _TypeWriterBorderWrite+1

setup_paper_width
    ; TypeWriterPaperWidth = 40 - TypeWriterBorderWidth
    lda #40
    sec
    sbc _TypeWriterBorderWidth
    sta _TypeWriterPaperWidth

    ; Fall through to the inner loop
.)

; ============================================
; DisplayPaperSheetLoop - inner scanline loop
; ============================================
; Input: param0=sourcePtr, param1=destPtr, param2+0=sourceOffset, param2+1=destOffset
;        _gPaperSheetHeight=height
;   param1 = destPtr (16-bit)
;   param2+0 = sourceOffset, param2+1 = destOffset
;   _gPaperSheetHeight = height (8-bit, max ~216)
; Uses self-modifying TypeWriter* addresses from CopyTypeWriterLine
_DisplayPaperSheetLoop
.(
    ldy #0                          ; Y = loop counter

loop
    ; destPtr -= 40
    sec
    lda _param1
    sbc #40
    sta _param1
    bcs no_borrow_dest
    dec _param1+1
no_borrow_dest

    ; sourcePtr -= TableRotateOffset[y]
    sec
    lda _param0
    sbc _TableRotateOffset,y
    sta _param0
    bcs no_borrow_src
    dec _param0+1
no_borrow_src

    ; TypeWriterBorderRead -= 40
    sec
    lda _TypeWriterBorderRead
    sbc #40
    sta _TypeWriterBorderRead
    bcs no_borrow_br
    dec _TypeWriterBorderRead+1
no_borrow_br

    ; TypeWriterBorderWrite -= 40
    sec
    lda _TypeWriterBorderWrite
    sbc #40
    sta _TypeWriterBorderWrite
    bcs no_borrow_bw
    dec _TypeWriterBorderWrite+1
no_borrow_bw

    ; if (sourcePtr < ImageBuffer-1) break (sourcePtr is pre-subtracted by 1)
    lda _param0+1
    cmp #>(_ImageBuffer-1)
    bcc done
    bne no_break
    lda _param0
    cmp #<(_ImageBuffer-1)
    bcs no_break

done
    rts

no_break

    ; Skip the roller zone (the physical roller must not be overwritten)
    lda _param1+1
    cmp #>ROLLER_ZONE_TOP
    bcc do_draw                     ; Above roller zone → draw
    cmp #(ROLLER_ZONE_BOT >> 8) + 1  ; High byte past the roller zone
    bcs do_draw                     ; Below roller zone → draw
    ; High byte matches roller zone — check low byte more precisely
    cmp #>ROLLER_ZONE_TOP
    bne check_bot
    lda _param1
    cmp #<ROLLER_ZONE_TOP
    bcs skip_draw                   ; >= top → skip
    bcc do_draw                     ; < top → draw
check_bot
    ; High byte is >ROLLER_ZONE_BOT
    lda _param1
    cmp #(ROLLER_ZONE_BOT & $FF) + 1 ; Low byte past the roller zone
    bcc skip_draw                   ; <= bot → skip
    ; >= $B3B1 → draw (past roller zone)

do_draw
    ; Set up PaperRead = sourcePtr + sourceOffset (sourcePtr already has -1 baked in)
    clc
    lda _param0
    adc _param2+0
    sta _TypeWriterPaperRead
    lda _param0+1
    adc #0
    sta _TypeWriterPaperRead+1

    ; Set up PaperWrite = destPtr + destOffset (destPtr already has -1 baked in)
    clc
    lda _param1
    adc _param2+1
    sta _TypeWriterPaperWrite
    lda _param1+1
    adc #0
    sta _TypeWriterPaperWrite+1

    ; Check if dithering is needed
    lda _TableDitherPatternOffset,y
    cmp #$7F
    bne has_mask

    ; Fast path: patch AND→LDA and shorten branch to skip the mask load
    ldx #OPCODE_LDA_ABS_X
    lda #256-9                      ; Branch offset: skip lda #mask (-9 = $F7)
    bne draw_paper                    ; Always branches

has_mask
    ; Normal path: AND with dither pattern
    sta paper_mask+1                  ; Set the mask value
    ldx #OPCODE_AND_ABS_X
    lda #256-11                     ; Branch offset: include lda #mask (-11 = $F5)

draw_paper
    stx paper_and_opcode
    sta paper_bne_offset

+_TypeWriterPaperWidth =*+1
    ldx #0
loop_paper
paper_mask
    lda #$FF                        ; Dither mask value (skipped in fast mode)
paper_and_opcode = *
+_TypeWriterPaperRead =*+1
    and $1234,x                     ; Patched to LDA in fast mode
+_TypeWriterPaperWrite =*+1
    sta $1234,x
    dex
paper_bne_offset = *+1
    bne loop_paper

+_TypeWriterBorderWidth =*+1
    ldx #0
loop_border
+_TypeWriterBorderRead =*+1
    lda $1234,x
+_TypeWriterBorderWrite =*+1
    sta $1234,x
    dex
    bne loop_border

skip_draw
    iny
+_gPaperSheetHeight = *+1
    cpy #0
    beq done
    jmp loop
.)



; ============================================
; CarriageReturn (full assembly version)
; ============================================
_CarriageReturn
.(
    inc _gYPos

    ; Update cached sourcePtr += 320 ($0140)
    clc
    lda _gSourcePtrBase
    adc #$40
    sta _gSourcePtrBase
    lda _gSourcePtrBase+1
    adc #$01
    sta _gSourcePtrBase+1

    ; Update cached height += 8
    lda _gPaperSheetHeight
    clc
    adc #8
    sta _gPaperSheetHeight

    jsr _DisplayPaperSheet

    ldx #<_ScrollPageData
    ldy #>_ScrollPageData
    jsr _PlaySoundAsmXY

carriage_loop
    lda _gXPos
    cmp #3
    bcc carriage_done               ; gXPos <= 2, stop
    sec
    sbc #4
    bcc carriage_done               ; Underflow (went negative), stop
    sta _gXPos
    jsr _DisplayPaperSheet
    jmp carriage_loop

carriage_done
    lda #1
    sta _gXPos
    lda #0
    sta _gXPos+1                    ; Clear high byte (gXPos is int)
    jmp _DisplayPaperSheet          ; Tail call
.)


    .text   // could be .data if we setup the base address properly

_Text_Empty                      .byt 0

_gScoreConditionsArray
  .word _Text_Empty
  .word _Text_SCORE_SOLVED_THE_CASE
  .word _Text_SCORE_MAIMED_BY_DOG  
  .word _Text_SCORE_SHOT_BY_THUG   
  .word _Text_SCORE_FELL_INTO_PIT  
  .word _Text_SCORE_TRIPPED_ALARM  
  .word _Text_SCORE_RAN_OUT_OF_TIME
  .word _Text_SCORE_BLOWN_INTO_BITS
  .word _Text_SCORE_GAVE_UP      
  .word _Test_SCORE_FINISHED_DEMO  


// Temporary table with the dithering pattern for the paper out of the machine to appear darker
_TableDitherPatternOffset
#include "..\build\files\pattern_typewriter_dithering.s"


_GradientTable
    .byt 3,3,3,3,3,3,3,3,3,3
    .byt 3,3,3,3,3,3,3,3,3,3
    .byt 3,3,3,3,3,3,3,3,3,3
    .byt 3,3,3,3,3,3,3,3,3,3

    .byt 3,1,1,3,3,1,3,3,3,3
    .byt 2,3,3,2,2,3,2,2,2,2
    .byt 6,2,2,6,6,2,6,6,6,6
    .byt 4,6,6,4,4,6,4,4,4,4
    .byt 1,4,4,1,1,4,1,1,1,1
    .byt 5,1,1,5,5,1,5,5,5,5
    .byt 4,5,5,4,4,5,4,4,4,4
    .byt 6,4,4,6,6,4,6,6,6,6
    .byt 3,6,6,3,3,6,3,3,3,3

    .byt 3,3,3,3,3,3,3,3,3,3
    .byt 3,3,3,3,3,3,3,3,3,3
    .byt 3,3,3,3,3,3,3,3,3,3
    .byt 3,3,3,3,3,3,3,3,3,3

// Temporary table with the offset for the text "compression" to simulate the rotation of the paper out of the machine
_TableRotateOffset
	.byt 40,40,40,40,40,40,40,40,
	.byt 40,40,40,40,40,40,40,40,
	.byt 40,40,40,40,40,40,40,40,
	.byt 40,40,40,40,40,40,40,40,
	.byt 40,40,40,40,40,40,40,40,

	.byt 40*2,40,40,40,40,40,40,40,
	.byt 40*2,40,40,40,40*2,40,40,40,
	.byt 40*2,40,40*2,40,40,40*2,40,40,
	.byt 40*2,40,40*2,40,40*2,40,40*2,40,
	.byt 40*2,40*2,40*2,40,40*2,40*2,40*2,40,
	.byt 40*2,40*2,40*2,40*2,40*2,40*2,40*2,40*2,

	.byt 40*3,40*2,40*2,40*2,40*2,40*2,40*2,40*2,
	.byt 40*3,40*2,40*2,40*2,40*3,40*2,40*2,40*2,
	.byt 40*3,40*2,40*2,40*2,40*3,40*2,40*2,40*2,
	.byt 40*3,40*3,40*2,40*2,40*3,40*2,40*3,40*2,
	.byt 40*3,40*3,40*3,40*3,40*3,40*3,40*3,40*3,

	.byt 40*3,40*3,40*3,40*3,40*3,40*3,40*3,40*3,
	.byt 40*3,40*3,40*3,40*3,40*3,40*3,40*3,40*3,


// 200 hz version
_TypeWriterData 
    .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$05,%11110111,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
    SOUND_SET_VALUE(REG_NOISE_FREQ,4)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,5)
    SOUND_SET_VALUE(REG_NOISE_FREQ,3)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,15)
    SOUND_SET_VALUE(REG_NOISE_FREQ,2)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,13)
    SOUND_SET_VALUE(REG_NOISE_FREQ,1)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,10)
    SOUND_SET_VALUE(REG_NOISE_FREQ,1)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,7)
    SOUND_SET_VALUE_END(8,0)                   ; Finally set the volume to 0


_SpaceBarData   
    .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$08,%11110111,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
    SOUND_SET_VALUE(REG_NOISE_FREQ,10)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,5)
    SOUND_SET_VALUE(REG_NOISE_FREQ,7)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,15)
    SOUND_SET_VALUE(REG_NOISE_FREQ,5)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,13)
    SOUND_SET_VALUE(REG_NOISE_FREQ,4)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,10)
    SOUND_SET_VALUE(REG_NOISE_FREQ,3)
    SOUND_SET_VALUE_ENDFRAME(REG_A_VOLUME,7)
    SOUND_SET_VALUE_END(8,0)                   ; Finally set the volume to 0


_ScrollPageData 
    .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$08,%11110110,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
    SOUND_SET_VALUE2(REG_A_FREQ,$819)
    SOUND_SET_VALUE(REG_NOISE_FREQ,31)
    SOUND_SET_VALUE(REG_A_VOLUME,7)                
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$6c2)
    SOUND_SET_VALUE(REG_NOISE_FREQ,23)
    SOUND_SET_VALUE(REG_A_VOLUME,12)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$595)
    SOUND_SET_VALUE(REG_NOISE_FREQ,31)
    SOUND_SET_VALUE(REG_A_VOLUME,12)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$486)
    SOUND_SET_VALUE(REG_NOISE_FREQ,24)
    SOUND_SET_VALUE(REG_A_VOLUME,9)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$808)
    SOUND_SET_VALUE(REG_NOISE_FREQ,31)
    SOUND_SET_VALUE(REG_A_VOLUME,6)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$55f)
    SOUND_SET_VALUE(REG_NOISE_FREQ,24)
    SOUND_SET_VALUE(REG_A_VOLUME,10)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$4ca)
    SOUND_SET_VALUE(REG_NOISE_FREQ,31)
    SOUND_SET_VALUE(REG_A_VOLUME,12)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$408)
    SOUND_SET_VALUE(REG_NOISE_FREQ,24)
    SOUND_SET_VALUE(REG_A_VOLUME,13)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$365)
    SOUND_SET_VALUE(REG_NOISE_FREQ,31)
    SOUND_SET_VALUE(REG_A_VOLUME,11)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$7bb)
    SOUND_SET_VALUE(REG_NOISE_FREQ,23)
    SOUND_SET_VALUE(REG_A_VOLUME,9)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$5b1)
    SOUND_SET_VALUE(REG_NOISE_FREQ,31)
    SOUND_SET_VALUE(REG_A_VOLUME,6)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$513)
    SOUND_SET_VALUE(REG_NOISE_FREQ,24)
    SOUND_SET_VALUE(REG_A_VOLUME,10)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$45a)
    SOUND_SET_VALUE(REG_NOISE_FREQ,30)
    SOUND_SET_VALUE(REG_A_VOLUME,11)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE2(REG_A_FREQ,$3f4)
    SOUND_SET_VALUE(REG_NOISE_FREQ,24)
    SOUND_SET_VALUE(REG_A_VOLUME,10)
    SOUND_WAIT(4) 
    SOUND_SET_VALUE_END(8,0)                   ; Finally set the volume to 0


_IntroMusic       ; All the three channels are used
#include "intro_music.s"

