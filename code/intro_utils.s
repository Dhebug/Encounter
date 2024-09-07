
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

; No-op to avoid a linker bug
_PrinterSendStringAsm
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
  .word _Text_SCORE_SIMPLY_VANISHED
  .word _Text_SCORE_GAVE_UP        

// Temporary table with the dithering pattern for the paper out of the machine to appear darker
_TableDitherPatternOffset
#include "..\build\files\pattern_typewriter_dithering.s"

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
_TypeWriterData .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$05,%11110111,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$04,SOUND_COMMAND_SET_VALUE,$08,$05,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$03,SOUND_COMMAND_SET_VALUE,$08,$0f,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$02,SOUND_COMMAND_SET_VALUE,$08,$0D,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$01,SOUND_COMMAND_SET_VALUE,$08,$0a,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$01,SOUND_COMMAND_SET_VALUE,$08,$07,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END                    ; Finally set the volume to 0
                .byt SOUND_COMMAND_END

_SpaceBarData   .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$08,%11110111,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$0a,SOUND_COMMAND_SET_VALUE,$08,$05,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$07,SOUND_COMMAND_SET_VALUE,$08,$0f,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$05,SOUND_COMMAND_SET_VALUE,$08,$0D,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$04,SOUND_COMMAND_SET_VALUE,$08,$0a,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$03,SOUND_COMMAND_SET_VALUE,$08,$07,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END                    ; Finally set the volume to 0
                .byt SOUND_COMMAND_END

_ScrollPageData .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$08,%11110110,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$19,SOUND_COMMAND_SET_VALUE,$01,$08,SOUND_COMMAND_SET_VALUE,$06,$1f,SOUND_COMMAND_SET_VALUE,$08,$07,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$c2,SOUND_COMMAND_SET_VALUE,$01,$06,SOUND_COMMAND_SET_VALUE,$06,$17,SOUND_COMMAND_SET_VALUE,$08,$0c,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$95,SOUND_COMMAND_SET_VALUE,$01,$05,SOUND_COMMAND_SET_VALUE,$06,$1f,SOUND_COMMAND_SET_VALUE,$08,$0c,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$86,SOUND_COMMAND_SET_VALUE,$01,$04,SOUND_COMMAND_SET_VALUE,$06,$18,SOUND_COMMAND_SET_VALUE,$08,$09,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$08,SOUND_COMMAND_SET_VALUE,$01,$08,SOUND_COMMAND_SET_VALUE,$06,$1f,SOUND_COMMAND_SET_VALUE,$08,$06,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$5f,SOUND_COMMAND_SET_VALUE,$01,$05,SOUND_COMMAND_SET_VALUE,$06,$18,SOUND_COMMAND_SET_VALUE,$08,$0a,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$ca,SOUND_COMMAND_SET_VALUE,$01,$04,SOUND_COMMAND_SET_VALUE,$06,$1f,SOUND_COMMAND_SET_VALUE,$08,$0c,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$08,SOUND_COMMAND_SET_VALUE,$01,$04,SOUND_COMMAND_SET_VALUE,$06,$18,SOUND_COMMAND_SET_VALUE,$08,$0d,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$65,SOUND_COMMAND_SET_VALUE,$01,$03,SOUND_COMMAND_SET_VALUE,$06,$1f,SOUND_COMMAND_SET_VALUE,$08,$0b,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$bb,SOUND_COMMAND_SET_VALUE,$01,$07,SOUND_COMMAND_SET_VALUE,$06,$17,SOUND_COMMAND_SET_VALUE,$08,$09,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$b1,SOUND_COMMAND_SET_VALUE,$01,$05,SOUND_COMMAND_SET_VALUE,$06,$1f,SOUND_COMMAND_SET_VALUE,$08,$06,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$13,SOUND_COMMAND_SET_VALUE,$01,$05,SOUND_COMMAND_SET_VALUE,$06,$18,SOUND_COMMAND_SET_VALUE,$08,$0a,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$5a,SOUND_COMMAND_SET_VALUE,$01,$04,SOUND_COMMAND_SET_VALUE,$06,$1e,SOUND_COMMAND_SET_VALUE,$08,$0b,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$f4,SOUND_COMMAND_SET_VALUE,$01,$03,SOUND_COMMAND_SET_VALUE,$06,$18,SOUND_COMMAND_SET_VALUE,$08,$0a,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$98,SOUND_COMMAND_SET_VALUE,$01,$03,SOUND_COMMAND_SET_VALUE,$06,$1e,SOUND_COMMAND_SET_VALUE,$08,$06,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$75,SOUND_COMMAND_SET_VALUE,$01,$03,SOUND_COMMAND_SET_VALUE,$06,$18,SOUND_COMMAND_SET_VALUE,$08,$03,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,$00,$44,SOUND_COMMAND_SET_VALUE,$01,$03,SOUND_COMMAND_SET_VALUE,$06,$18,SOUND_COMMAND_SET_VALUE,$08,$03,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_END_FRAME
				.byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END                    ; Finally set the volume to 0
                .byt SOUND_COMMAND_END

_IntroMusic
.(
    .dw events
    .byt 1+2+4+8+16+32        ; All the three channels are used
#include "intro_music.s"
events
#include "intro_music_events.s"
.)

_TypewriterMusic
.(
    .dw events
    .byt 0+2+4+0+16+32        ; Only channels two and three are used, channel one is available for sound effects
#include "intro_music_typewriter.s"
events
#include "intro_music_typewriter_events.s"
.)

