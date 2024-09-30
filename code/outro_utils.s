
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
_PrinterSendStringAsm
_DrawArrows
    rts
    

/*
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
  .word _Text_SCORE_SIMPLY_VANISHED
  .word _Text_SCORE_GAVE_UP        
*/



_TypewriterMusic
.(
    .dw events
    .byt 0+2+4+0+16+32        ; Only channels two and three are used, channel one is available for sound effects
#include "intro_music_typewriter.s"
events
#include "intro_music_typewriter_events.s"
.)


_ThirdImageBuffer    .dsb 6000   ; A third buffer that can store a full image

