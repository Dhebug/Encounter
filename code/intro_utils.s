
    .text


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


_IntroMusic
.(
#ifdef USE_MUSIC_EVENTS    
    .dw events
#endif    
    .byt 1+2+4+8+16+32        ; All the three channels are used
#include "intro_music.s"
#ifdef USE_MUSIC_EVENTS
events
#include "intro_music_events.s"
#endif
.)

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


