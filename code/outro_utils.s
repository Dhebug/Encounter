
    .text

IrqTasksHighSpeed
.(
    jmp SoundUpdateHighSpeed
.)

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr _PlayMusicFrame
    jsr SoundUpdate50hz
    rts    
.)

// Called from on the blitt functions
Count1SecondsDown
Count10SecondsDown
    rts

; No-op to avoid a linker bug
_InputArrows
_PrintInformationMessageAsm
_DrawArrows
_gFont12x14
    rts

_ValidateInputReturn
_ValidateInputSpace
    ldx #1
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



