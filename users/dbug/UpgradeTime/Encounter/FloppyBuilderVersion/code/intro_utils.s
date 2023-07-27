
    .text

IrqTasksHighSpeed
.(
    jmp SoundUpdateHighSpeed
.)

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr SoundUpdate50hz
    rts    
.)


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

_Text_FirstLine                  .byt 16+3,4,"                                        ",0
_Text_CopyrightSevernSoftware    .byt 16+3,4,"  Encounter ",96," 1983 Severn Software    ",0
_Text_CopyrightDefenceForce      .byt 16+3,4,"Redux Additions ",96," 2023 Defence-Force ",31,0

_Text_HowToPlay                  .byt 1,"           How to play",0
_Text_MovementVerbs              .byt 1,"   MOVEMENT            VERBS",0
_Text_Notes                      .byt 1,"              NOTES",4,"    SHOOT SIPHON",0    ; That's a bug there that needs fixing, using zero as a terminator means we can't use black ink because of strcpy

_Text_Leaderboard                .byt 16+1,3,"            Leaderboard",0

_Test_Empty                      .byt 0

_Text_SCORE_SOLVED_THE_CASE      .byt 2,"Solved the case",0
_Text_SCORE_MAIMED_BY_DOG        .byt 5,"Maimed by a dog",0
_Text_SCORE_SHOT_BY_THUG         .byt 1,"Shot by a thug",0
_Text_SCORE_FELL_INTO_PIT        .byt 3,"Fell into a pit",0
_Text_SCORE_TRIPPED_ALARM        .byt 3,"Tripped the alarm",0
_Text_SCORE_RAN_OUT_OF_TIME      .byt 6,"Ran out of time",0
_Text_SCORE_BLOWN_INTO_BITS      .byt 1,"Blown into bits",0
_Text_SCORE_SIMPLY_VANISHED      .byt 7,"Simply Vanished!",0
_Text_SCORE_GAVE_UP              .byt 5,"Gave up...",0

_gScoreConditionsArray
  .word _Test_Empty
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
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7d,$7f,$5f,$7f,$7b,$7e,$6f,$7d,$77,$7e,$5f,$7b,$6e,$7b,$5d
	.byt $77,$7a,$6f,$75,$6f,$75,$5a,$6d,$76,$5d,$76,$55,$6a,$6d,$55,$7a
	.byt $57,$6a,$75,$6a,$57,$59,$6a,$55,$62,$55,$4a,$64,$52,$69,$52,$49
	.byt $64,$50,$41,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40

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
