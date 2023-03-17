
    .text

IrqTasks
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr SoundUpdate
    rts    
.)


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


