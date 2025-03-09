
    .text

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr _PlayMusicFrame
    jmp SoundUpdate50hz
.)


_ValidateInputSpace
.(
    ldx _gInputBufferPos
    bne skip
    jsr _PrintKeyboardMenu
    ; Make sure that we don't add some "space" to the input buffer
    lda #0
    sta _gInputKey
skip
.)
+_ValidateInputReturn
    ldx #1
// Called from on the blitt functions
Count1SecondsDown
Count10SecondsDown
; No-op to avoid a linker bug
_InputArrows
_PrintInformationMessageAsm
_DrawArrows
_gFont12x14
    rts

