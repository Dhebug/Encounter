
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
