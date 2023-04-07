
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

_gDescriptionRoad
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,100,87,11)
    .byt RECTANGLE(4,106,69,15)
    .byt OFFSET(1,0),"All roads lead...",0
    .byt OFFSET(1,4),"...somewhere?",0
    .byt COMMAND_END

_gDescriptionMainStreet
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,64,12)
    .byt RECTANGLE(4,16,93,11)
    .byt OFFSET(1,0),"A good old",0
    .byt OFFSET(4,0),"medieval church",0
    .byt COMMAND_END

_gDescriptionNarrowPath
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(124,5,105,12)
    .byt RECTANGLE(104,17,130,15)
    .byt OFFSET(1,0),"Are these the open",0
    .byt OFFSET(1,0),"f",255-1,"lood gates o",255-2,"f heaven?",0
    .byt COMMAND_END

_gDescriptionInThePit
    ;.byt COMMAND_WAIT,50*2
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(6,8,86,11)
    .byt OFFSET(1,0),"It did not look",0
    ;.byt COMMAND_WAIT,50
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(176,42,54,15)
    .byt OFFSET(1,0),"that deep",0
    ;.byt COMMAND_WAIT,50
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(82,94,74,15)
    .byt OFFSET(1,0),"from outside",0
    .byt COMMAND_END

_gDescriptionTarmacArea
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(149,5,86,11)
    .byt RECTANGLE(152,15,82,11)
    .byt OFFSET(1,0),"Ashes to Ashes",0
    .byt OFFSET(1,0),"Rust to Rust...",0
    .byt COMMAND_END

_gDescriptionOldWell
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(111,5,124,12)
    .byt RECTANGLE(158,16,75,11)
    .byt OFFSET(1,0),"This well looks as old",0
    .byt OFFSET(1,0),"as the church",0
    .byt COMMAND_END

_gDescriptionWoodedAvenue
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,144,16)
    .byt RECTANGLE(4,14,129,16)
    .byt OFFSET(1,0),"These trees have probably",0
    .byt OFFSET(1,1),"witnessed many things",0
    .byt COMMAND_END

_gDescriptionGravelDrive
    .byt COMMAND_BUBBLE,3,64
    .byt RECTANGLE(127,86,108,11)
    .byt RECTANGLE(143,97,92,11)
    .byt RECTANGLE(182,107,53,15)
    .byt OFFSET(1,0),"Kind o",255-2,"f impressive",0
    .byt OFFSET(1,0),"when seen from",0
    .byt OFFSET(1,0),"f",255-2,"ar away",0
    .byt COMMAND_END

_gDescriptionZenGarden
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,139,11)
    .byt RECTANGLE(4,15,72,16)
    .byt OFFSET(1,0),"A Japanese Zen Garden?",0
    .byt OFFSET(1,1),"In England?",0
    .byt COMMAND_END

_gDescriptionFrontLawn
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,93,11)
    .byt RECTANGLE(5,15,84,16)
    .byt OFFSET(1,0),"The per",255-2,"f",255-2,"ect home",0
    .byt OFFSET(1,1),"f",255-2,"or egomaniacs",0
    .byt COMMAND_END

_gDescriptionGreenHouse
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,96,80,15)
    .byt RECTANGLE(4,107,98,16)
    .byt OFFSET(1,0),"Obviously f",255-2,"or",0
    .byt OFFSET(1,1),34,"Therapeutic use",34,0
    .byt COMMAND_END

_gDescriptionTennisCourt
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,107,12)
    .byt RECTANGLE(4,15,150,15)
    .byt OFFSET(1,0),"That's more like it:",0
    .byt OFFSET(1,0),"a proper lawn tennis court",0
    .byt COMMAND_END

_gDescriptionVegetableGarden
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(134,5,100,12)
    .byt RECTANGLE(136,15,98,16)
    .byt OFFSET(1,0),"Not the best spot",0
    .byt OFFSET(1,1),"to grow tomatoes",0
    .byt COMMAND_END

_gDescriptionFishPond
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,116,12)
    .byt RECTANGLE(5,17,116,15)
    .byt OFFSET(1,0),"Some o",255-2,"f these f",255-1,"ishes",0
    .byt OFFSET(1,0),"are sur",255-1,"prinsingly big",0
    .byt COMMAND_END

_gDescriptionTiledPatio
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(93,5,143,11)
    .byt RECTANGLE(110,15,126,15)
    .byt OFFSET(1,0),"The house's back entrance",0
    .byt OFFSET(1,0),"is accessible from here",0
    .byt COMMAND_END


_gDescriptionAppleOrchard
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,136,15)
    .byt RECTANGLE(5,17,139,15)
    .byt OFFSET(1,0),"The best kind o",255-2,"f apples:",0
    .byt OFFSET(1,0),"sweet",255-1,", crunchy and juicy",0
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
#endif
    .byt COMMAND_END
