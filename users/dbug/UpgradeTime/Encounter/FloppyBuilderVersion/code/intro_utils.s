
    .text

IrqTasks
.(
	; Process keyboard
	jsr ReadKeyboard

    rts    
.)


_Text_FirstLine                  .byt 16+3,4,"                                        ",0
_Text_CopyrightSevernSoftware    .byt 16+3,4,"  Encounter ",96," 1983 Severn Software    ",0
_Text_CopyrightDefenceForce      .byt 16+3,4,"Redux Additions ",96," 2023 Defence-Force ",31,0

_Text_HowToPlay                  .byt 1,"           How to play",0
_Text_MovementVerbs              .byt 1,"   MOVEMENT            VERBS",0
_Text_Notes                      .byt 1,"              NOTES",4,"    SHOOT SIPHON",0    ; That's a bug there that needs fixing, using zero as a terminator means we can't use black ink because of strcpy

