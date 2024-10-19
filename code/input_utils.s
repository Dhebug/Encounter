
#include "params.h"

    .zero

_gAskQuestion       .dsb 1      ; Should the prompt ("what do you want to do now?", "in what?") be shown
_gInputBufferPos    .dsb 1      ; Position in the edit buffer
_gInputMaxSize      .dsb 1      ; Maximum number of characters accepted 
_gWordCount         .dsb 1      ; How many tokens/word did we find in the input buffer
_gAnswerProcessingCallback .dsb 2
_gInputKey          .dsb 1
_gInputShift        .dsb 1

_gWordBuffer        .dsb MAX_WORDS 	; One byte identifier of each of the identified words

    .text 


_ResetInput
.(
    lda #1
    sta _gAskQuestion

    lda #0
    sta _gInputBufferPos
    sta _gInputBuffer+0
    rts
.)


_InputCheckKey
.(
    jsr _ReadKeyNoBounce    ; Result in X
    stx _gInputKey
    beq InputQuit

    ldx #0
    lda _KeyBank+4          ; Left shift
    ora _KeyBank+7          ; Right shift 
    and #16                 ; The two shift keys are on the same column
    beq save_shift
    inx                     ; Shifted!
save_shift    
    stx _gInputShift

+InputQuit                  ; WARNING: Used by multiple commands
    rts
.)


_InputDelete
.(
    ldx _gInputBufferPos
    beq InputQuit
    dex
    stx _gInputBufferPos
    lda #0
    sta _gInputBuffer,x

    ldx #<_KeyClickHData
    ldy #>_KeyClickHData
    jmp _PlaySoundAsmXY
.)


_InputDefaultKey
.(
    lda _gInputKey
    cmp #32                     ; Is it a displayable character?
    bcc InputQuit

    ldx _gInputShift
    bne not_shifted_letter      ; If shift is pressed, we skip the lowercase-ization
    cmp #"A"
    bcc not_shifted_letter
    cmp #"Z"+1
    bcs not_shifted_letter
letter_a_z
    ora #32
    sta _gInputKey   ; Make the character lower case
not_shifted_letter

    ldx _gInputBufferPos
    cpx _gInputMaxSize          ; Do we still have room in the buffer?
    bcs errorPlop
    
    ldx _gInputBufferPos
    sta _gInputBuffer,x         ; Insert the new character in the input buffer
    inx
    lda #0
    sta _gInputBuffer,x         ; And put the null terminator
    stx _gInputBufferPos

clickSound    
    ldx #<_KeyClickLData
    ldy #>_KeyClickLData
    jmp _PlaySoundAsmXY

errorPlop    
    ldx #<_ErrorPlop
    ldy #>_ErrorPlop
    jmp _PlaySoundAsmXY
.)