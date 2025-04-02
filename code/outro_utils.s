
    .text

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr _PlayMusicFrame
    jmp SoundUpdate50hz
.)


// Two no-op for input_utils.s
_ValidateInputSpace
_ValidateInputReturn
// Called from on the blitt functions
Count1SecondsDown
Count10SecondsDown
; No-op to avoid a linker bug
_InputArrows
_PrintInformationMessageAsm
_DrawArrows
_gFont12x14
    rts

