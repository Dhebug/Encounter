
    .text

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr _PlayMusicFrame
    jmp SoundUpdate50hz
.)

_ValidateInputReturn
_ValidateInputSpace
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

_TypewriterMusic
.(
#ifdef USE_MUSIC_EVENTS    
    .dw events
#endif    
    .byt 0+2+4+0+16+32        ; Only channels two and three are used, channel one is available for sound effects
#include "intro_music_typewriter.s"
#ifdef USE_MUSIC_EVENTS
events
#include "intro_music_typewriter_events.s"
#endif
.)



