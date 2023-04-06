
#include "params.h"

    .text

_gTextLowerCaseAlphabet    .byt "abcde",255-2,"f",255-2,"ghi",255-2,"jklmnopqrstuvwxyz",0

_gDescriptionTeenagerRoom         .byt "T",255-2,"eenager r",255-1,"oom?",0

_gDescriptionNone
    .byt COMMAND_END

_gDescriptionDarkTunel
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,172,15)
    .byt RECTANGLE(4,13,114,16)
    .byt OFFSET(1,0),"Like most tunnels: dark, damp,",0
    .byt OFFSET(1,1),"and somewhat scary.",0
    .byt COMMAND_END


_gDescriptionMarketPlace
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,100,95,15)
    .byt RECTANGLE(4,106,59,15)
    .byt OFFSET(1,0),"The market place",0
    .byt OFFSET(1,4),"is deserted",0
    .byt COMMAND_END


_gDescriptionDarkAlley
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(153,85,83,14)
    .byt RECTANGLE(136,98,100,15)
    .byt OFFSET(1,0),"Rats, gra",255-2,"f",255-3,"f",255-1,"itti,",0
    .byt OFFSET(1,0),"and used syringes.",0

    .byt COMMAND_END

#if 0
    // Performance testing
    .byt COMMAND_BUBBLE,2,127
    .byt RECTANGLE(53,45,83,14)
    .byt RECTANGLE(36,58,100,15)
    .byt OFFSET(1,0),"Rats, gra",255-2,"f",255-3,"f",255-1,"itti,",0
    .byt OFFSET(1,0),"and used syringes.",0

    ; Funny way to make an outlined text
    .byt COMMAND_TEXT
    .byt 8,8
    .byt 64
    .byt "This is a multine line message",13,10,"Second line!",0

    .byt COMMAND_TEXT
    .byt 10,8
    .byt 64
    .byt "This is a multine line message",13,10,"Second line!",0

    .byt COMMAND_TEXT
    .byt 8,9
    .byt 64
    .byt "This is a multine line message",13,10,"Second line!",0

    .byt COMMAND_TEXT
    .byt 10,9
    .byt 64
    .byt "This is a multine line message",13,10,"Second line!",0

    .byt COMMAND_TEXT
    .byt 8,10
    .byt 64
    .byt "This is a multine line message",13,10,"Second line!",0

    .byt COMMAND_TEXT
    .byt 10,10
    .byt 64
    .byt "This is a multine line message",13,10,"Second line!",0

    .byt COMMAND_TEXT
    .byt 9,9
    .byt 127
    .byt "This is a multine line message",13,10,"Second line!",0

    .byt COMMAND_END
#endif