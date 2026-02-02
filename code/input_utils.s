
#include "params.h"

    .zero

_gInputMessage      .dsb 2      ; Contains the message prompt shown to the user
_gAskQuestion       .dsb 1      ; Should the prompt ("what do you want to do now?", "in what?") be shown
_gInputBufferPos    .dsb 1      ; Position in the edit buffer
_gInputMaxSize      .dsb 1      ; Maximum number of characters accepted 
_gWordCount         .dsb 1      ; How many tokens/word did we find in the input buffer
_gAnswerProcessingCallback .dsb 2
_gInputShift        .dsb 1
_gInputErrorCounter .dsb 1
_gInputDone         .dsb 1
_gWordBuffer        .dsb MAX_WORDS 	; One byte identifier of each of the identified words

    .text

_gInputAcceptsEmpty     .byt 0
_gContainerRequestMode  .byt 0   ; Set to 1 during "Carry in what?" prompts

// MARK:Reset Input
_ResetInput
.(
    lda #1
    sta _gAskQuestion

    lda #0
    sta _gInputBufferPos
    sta _gInputBuffer+0
    sta _gInputErrorCounter
    sta _gInputKey
    sta _gInputShift
    
    jmp _WaitReleasedKey            ; Remove any key in the buffer and wait for the keys to not be pressed anymoe
.)


// MARK:Input Check Key
_InputCheckKey
.(
    ldx _gInputErrorCounter
    beq skip_counter
    dec _gInputErrorCounter
skip_counter    

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


// MARK:Input Delete Character
_InputDeleteCharacter
.(
    ldx _gInputBufferPos
    beq empty
    dex
    stx _gInputBufferPos
    lda #0
    sta _gInputBuffer,x
empty
    rts
.)    


// MARK:Input Delete
_InputDelete
.(    
    ldx _gInputBufferPos
    beq InputQuit

    lda _KeyBank+2
    and #16
    bne delete_word

delete_character
    jsr _InputDeleteCharacter

    ldx #<_KeyClickHData
    ldy #>_KeyClickHData
    jmp _PlaySoundAsmXY

delete_word              ; If CTRL is pressed, we delete the entire word from the input buffer
    ;jmp delete_word
    lda _gInputBuffer-1,x
    cmp #32
    beq done_word
    jsr _InputDeleteCharacter
    cpx #0
    bne delete_word

done_word
    jsr _InputDeleteCharacter

    ldx #<_Swoosh
    ldy #>_Swoosh
    jsr _PlaySoundAsmXY

    lda #1
    sta _gAskQuestion
    rts
.)


// MARK:Input Default Key
_InputDefaultKey
.(
    jsr _ValidateInputSpace
    beq _InputError
    
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
    bcs _InputError
    
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

+_InputError
    lda #25
    sta _gInputErrorCounter
+_PlayErrorSound    
    ldx #<_ErrorPlop
    ldy #>_ErrorPlop
    jmp _PlaySoundAsmXY
.)
