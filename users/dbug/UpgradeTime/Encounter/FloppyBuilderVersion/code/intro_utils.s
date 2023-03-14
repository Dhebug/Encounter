
    .text

IrqTasks
.(
	; Process keyboard
	jsr ReadKeyboard

    rts    
.)


_Text_FirstLine                  .byt 16+3,4,"                                        ",0
_Text_CopyrightSevernSoftware    .byt 16+3,4,"  Encounter ",96," 1983 Severn Software    ",0
_Text_CopyrightDefenceForce      .byt 16+3,4,"Redux Additions ",96," 2023 Defence-Force  ",0
