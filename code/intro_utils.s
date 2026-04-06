
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


IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr _PlayMusicFrame
    jmp SoundUpdate50hz
.)

; No-op to avoid a linker bug
_PrintInformationMessageAsm
_DrawArrows
    rts

_CopyTypeWriterLine
.(
+_TypeWriterPaperWidth =*+1
    ldx #0
loop_paper
+_TypeWriterPaperRead =*+1
    lda $2211,x
+_TypeWriterPaperPattern = *+1
    and #$ff  
+_TypeWriterPaperWrite =*+1
    sta $5544,x
    dex
    bne loop_paper

+_TypeWriterBorderWidth =*+1
    ldx #0
loop_border
+_TypeWriterBorderRead =*+1
    lda $2211,x
+_TypeWriterBorderWrite =*+1
    sta $5544,x
    dex
    bne loop_border
    rts
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

