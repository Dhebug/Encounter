
#include "params.h"
#include "floppy_description.h"
#include "game_enums.h"

    .text

_gTextLowerCaseAlphabet    .byt "abcde",255-2,"f",255-2,"ghi",255-2,"jklmnopqrstuvwxyz",0

_gDescriptionTeenagerRoom         .byt "T",255-2,"eenager r",255-1,"oom?",0

_gDescriptionNone
    .byt COMMAND_END

_gDescriptionDarkTunel
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,172,15)
    .byt RECTANGLE(4,13,114,16)
    .byt OFFSET(1,0),"Like most tunnels: dark, damp,",0
    .byt OFFSET(1,1),"and somewhat scary.",0
    .byt COMMAND_END

_gDescriptionMarketPlace
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,100,95,15)
    .byt RECTANGLE(4,106,59,15)
    .byt OFFSET(1,0),"The market place",0
    .byt OFFSET(1,4),"is deserted",0
    .byt COMMAND_END

_gDescriptionDarkAlley
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(153,85,83,14)
    .byt RECTANGLE(136,98,100,15)
    .byt OFFSET(1,0),"Rats, gra",255-2,"f",255-3,"f",255-1,"itti,",0
    .byt OFFSET(1,0),"and used syringes.",0
    .byt COMMAND_END

_gDescriptionRoad
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,100,87,11)
    .byt RECTANGLE(4,106,69,15)
    .byt OFFSET(1,0),"All roads lead...",0
    .byt OFFSET(1,4),"...somewhere?",0
    .byt COMMAND_END

_gDescriptionMainStreet
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,64,12)
    .byt RECTANGLE(4,16,93,11)
    .byt OFFSET(1,0),"A good old",0
    .byt OFFSET(4,0),"medieval church",0
    .byt COMMAND_END

_gDescriptionNarrowPath
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(124,5,105,12)
    .byt RECTANGLE(104,17,130,15)
    .byt OFFSET(1,0),"Are these the open",0
    .byt OFFSET(1,0),"f",255-1,"lood gates o",255-2,"f heaven?",0
    .byt COMMAND_END

_gDescriptionInThePit   
    .byt COMMAND_WAIT,50*2
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(6,8,86,11)
    .byt OFFSET(1,0),"It did not look",0
    .byt COMMAND_WAIT,50
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(176,42,54,15)
    .byt OFFSET(1,0),"that deep",0
    .byt COMMAND_WAIT,50
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(82,94,74,15)
    .byt OFFSET(1,0),"from outside",0
    
    .byt COMMAND_WAIT,50*2
    ; Draw the 'The End' logo
    .byt COMMAND_BITMAP,LOADER_SPRITE_THE_END
    .byt BLOCK_SIZE(20,95)
    .byt STRIDE(20)
    .word _SecondImageBuffer
    .word _ImageBuffer+(40*16)+10
    ; Should probably have a "game over" command
    .byt COMMAND_FADE_BUFFER
    .byt COMMAND_END

_gDescriptionOutsidePit
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,94,98,15)
    .byt RECTANGLE(5,103,55,19)
    .byt OFFSET(1,0),"Are they digging",0
    .byt OFFSET(1,4),"for gold?",0
    .byt COMMAND_END


_gDescriptionTarmacArea
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(149,5,86,11)
    .byt RECTANGLE(152,15,82,11)
    .byt OFFSET(1,0),"Ashes to Ashes",0
    .byt OFFSET(1,0),"Rust to Rust...",0
    .byt COMMAND_END

_gDescriptionOldWell
    ; e_LOCATION_WELL / e_ITEM_Bucket / e_ITEM_Rope
.(
    ; Is the Bucket near the Well?
    .byt COMMAND_JUMP_IF_FALSE
    .word no_bucket
    .byt OPERATOR_CHECK_ITEM_LOCATION
    .byt e_ITEM_Bucket
    .byt e_LOCATION_WELL
    ; Draw the Bucket 
    .byt COMMAND_BITMAP,LOADER_SPRITE_ITEMS
    .byt BLOCK_SIZE(6,35)
    .byt STRIDE(40)
    .word _SecondImageBuffer
    .word _ImageBuffer+(40*86)+24
no_bucket    
.)
    ;
.(    
    ; Is the Rope near the Well?
    .byt COMMAND_JUMP_IF_FALSE
    .word no_rope
    .byt OPERATOR_CHECK_ITEM_LOCATION
    .byt e_ITEM_Rope
    .byt e_LOCATION_WELL
    ; Draw the Rope
    .byt COMMAND_BITMAP,LOADER_SPRITE_ITEMS
    .byt BLOCK_SIZE(7,44)
    .byt STRIDE(40)
    .word _SecondImageBuffer+7
    .word _ImageBuffer+(40*35)+26
no_rope    
.)
    ;
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(111,5,124,12)
    .byt RECTANGLE(158,16,75,11)
    .byt OFFSET(1,0),"This well looks as old",0
    .byt OFFSET(1,0),"as the church",0
    .byt COMMAND_END

_gDescriptionWoodedAvenue
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,144,16)
    .byt RECTANGLE(4,14,129,16)
    .byt OFFSET(1,0),"These trees have probably",0
    .byt OFFSET(1,1),"witnessed many things",0
    .byt COMMAND_END

_gDescriptionGravelDrive
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,3,64
    .byt RECTANGLE(127,86,108,11)
    .byt RECTANGLE(143,97,92,11)
    .byt RECTANGLE(182,107,53,15)
    .byt OFFSET(1,0),"Kind o",255-2,"f impressive",0
    .byt OFFSET(1,0),"when seen from",0
    .byt OFFSET(1,0),"f",255-2,"ar away",0
    .byt COMMAND_END

_gDescriptionZenGarden
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,139,11)
    .byt RECTANGLE(4,15,72,16)
    .byt OFFSET(1,0),"A Japanese Zen Garden?",0
    .byt OFFSET(1,1),"In England?",0
    .byt COMMAND_END

_gDescriptionFrontLawn
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,93,11)
    .byt RECTANGLE(5,15,84,16)
    .byt OFFSET(1,0),"The per",255-2,"f",255-2,"ect home",0
    .byt OFFSET(1,1),"f",255-2,"or egomaniacs",0
    .byt COMMAND_END

_gDescriptionGreenHouse
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,96,80,15)
    .byt RECTANGLE(4,107,98,16)
    .byt OFFSET(1,0),"Obviously f",255-2,"or",0
    .byt OFFSET(1,1),34,"Therapeutic use",34,0
    .byt COMMAND_END

_gDescriptionTennisCourt
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,107,12)
    .byt RECTANGLE(4,15,150,15)
    .byt OFFSET(1,0),"That's more like it:",0
    .byt OFFSET(1,0),"a proper lawn tennis court",0
    .byt COMMAND_END

_gDescriptionVegetableGarden
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(134,5,100,12)
    .byt RECTANGLE(136,15,98,16)
    .byt OFFSET(1,0),"Not the best spot",0
    .byt OFFSET(1,1),"to grow tomatoes",0
    .byt COMMAND_END

_gDescriptionFishPond
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,116,12)
    .byt RECTANGLE(5,17,116,15)
    .byt OFFSET(1,0),"Some o",255-2,"f these f",255-1,"ishes",0
    .byt OFFSET(1,0),"are sur",255-1,"prinsingly big",0
    .byt COMMAND_END

_gDescriptionTiledPatio
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(93,5,143,11)
    .byt RECTANGLE(110,15,126,15)
    .byt OFFSET(1,0),"The house's back entrance",0
    .byt OFFSET(1,0),"is accessible from here",0
    .byt COMMAND_END

_gDescriptionAppleOrchard
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,136,15)
    .byt RECTANGLE(5,17,139,15)
    .byt OFFSET(1,0),"The best kind o",255-2,"f apples:",0
    .byt OFFSET(1,0),"sweet",255-1,", crunchy and juicy",0
    .byt COMMAND_END

_gDescriptionEntranceHall
    ; Draw the dog growling in the entrance
    .byt COMMAND_BITMAP,LOADER_SPRITE_DOG
    .byt BLOCK_SIZE(13,66)
    .byt STRIDE(40)
    .word _SecondImageBuffer+(40*61)+0
    .word _ImageBuffer+(40*56)+25
    ;
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(124,5,111,14)
    .byt RECTANGLE(187,17,48,11)
    .byt OFFSET(1,0),"Quite an impressive",0
    .byt OFFSET(1,0),"staircase",0
    ;
    .byt COMMAND_END

_gDescriptionLibrary
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,86,119,11)
    .byt RECTANGLE(5,97,110,15)
    .byt OFFSET(1,0),"Books, fireplace, and",0
    .byt OFFSET(1,0),"a com",255-2,"f",255-2,"ortable chair",0
    .byt COMMAND_END

_gDescriptionNarrowPassage
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,3,127
    .byt RECTANGLE(5,48,122,13)
    .byt RECTANGLE(12,68,98,15)
    .byt RECTANGLE(37,90,52,15)
    .byt OFFSET(1,0),"Either they love dark",0
    .byt OFFSET(1,0),"or they f",255-2,"orgot to",0
    .byt OFFSET(1,0),"pay their",0

    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(75,110,26,11)
    .byt OFFSET(1,0),"bills",0

    .byt COMMAND_END

_gDescriptionEntranceLounge
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,105,11)
    .byt RECTANGLE(5,15,49,15)
    .byt OFFSET(1,0),"Looks like someone",0
    .byt OFFSET(1,0),"had fun",0
    .byt COMMAND_END

_gDescriptionDiningRoom
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,95,69,13)
    .byt RECTANGLE(5,107,84,15)
    .byt OFFSET(1,0),"Two plates...",0
    .byt OFFSET(1,0),"...good to know",0
    .byt COMMAND_END

_gDescriptionGamesRoom
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(142,5,93,13)
    .byt RECTANGLE(164,16,71,15)
    .byt OFFSET(1,0),"T",255-2,"op o",255-2,"f the range",0
    .byt OFFSET(1,0),"video system",0

    .byt COMMAND_WAIT,50

    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(175,40,60,15)
    .byt OFFSET(1,0),"Impressive",0
    .byt COMMAND_END

_gDescriptionSunLounge
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(112,5,123,15)
    .byt OFFSET(1,0),"No rest ",255-2,"f",255-2,"or the weary",0
    .byt COMMAND_END

_gDescriptionKitchen
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,71,11)
    .byt RECTANGLE(5,16,41,12)
    .byt OFFSET(1,0),"A very basic",0
    .byt OFFSET(1,0),"kitchen",0
    .byt COMMAND_END

_gDescriptionNarrowStaircase
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(5,5,95,15)
    .byt OFFSET(1,0),"Watch your step",0
    .byt COMMAND_END

_gDescriptionCellar
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,127
    .byt RECTANGLE(75,15,90,12)
    .byt RECTANGLE(80,25,67,15)
    .byt OFFSET(1,0),"Is that a Franz",0
    .byt OFFSET(1,0),"Jager safe?",0
    .byt COMMAND_END

_gDescriptionDarkerCellar
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,127
    .byt RECTANGLE(5,99,104,12)
    .byt RECTANGLE(5,109,77,13)
    .byt OFFSET(1,0),"The window seems",0
    .byt OFFSET(1,0),"to be occulted",0
    .byt COMMAND_END

_gDescriptionStaircase
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,3,64
    .byt RECTANGLE(16,8,32,15)
    .byt RECTANGLE(179,8,39,12)
    .byt RECTANGLE(60,72,119,15)
    .byt OFFSET(1,0),"Left?",0
    .byt OFFSET(1,0),"Right?",0
    .byt OFFSET(1,0),"does it really matter?",0
    .byt COMMAND_END

_gDescriptionMainLanding
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(47,70,143,15)
    .byt OFFSET(1,0),"Nice view from up there",0
    .byt COMMAND_END

_gDescriptionEastGallery
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,90,12)
    .byt RECTANGLE(20,17,34,12)
    .byt OFFSET(1,0),"Boring corridor:",0
    .byt OFFSET(1,0),"Check",0
    .byt COMMAND_END

_gDescriptionChildBedroom
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,96,74,12)
    .byt RECTANGLE(5,107,85,15)
    .byt OFFSET(1,0),"Let me guess:",0
    .byt OFFSET(1,0),"Teenager room?",0
    .byt COMMAND_END

_gDescriptionGuestBedroom
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,6,92,12)
    .byt RECTANGLE(5,17,71,15)
    .byt OFFSET(1,0),"Simple and ",255-2,"f",255-2,"resh",0
    .byt OFFSET(1,0),"f",255-2,"or a change",0
    .byt COMMAND_END

_gDescriptionShowerRoom
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(149,5,86,12)
    .byt RECTANGLE(152,16,83,13)
    .byt OFFSET(1,0),"I will need one",0
    .byt OFFSET(1,0),"when I'm done",0
    .byt COMMAND_END

_gDescriptionWestGallery
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,127
    .byt RECTANGLE(85,81,72,13)
    .byt RECTANGLE(60,92,112,13)
    .byt OFFSET(1,0),"Is that Steel",0
    .byt OFFSET(1,0),"behind the Curtain?",0
    .byt COMMAND_END

_gDescriptionBoxRoom
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,63,11)
    .byt RECTANGLE(5,16,59,11)
    .byt OFFSET(1,0),"A practical",0
    .byt OFFSET(1,0),"little room",0
    .byt COMMAND_END

_gDescriptionClassyBathRoom
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(132,5,103,15)
    .byt OFFSET(1,0),"Looks comfortable",0
    .byt COMMAND_END

_gDescriptionTinyToilet
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(137,5,98,15)
    .byt OFFSET(1,0),"Sparklingly clean",0
    .byt COMMAND_END

_gDescriptionMasterBedRoom
    .byt COMMAND_WAIT,DELAY_FIRST_BUBBLE
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,124,15)
    .byt RECTANGLE(5,16,84,15)
    .byt OFFSET(1,0),"This will make things",0
    .byt OFFSET(1,0),"notably easier...",0
    .byt COMMAND_END



_gDescriptionPadlockedRoom
    .byt COMMAND_BUBBLE,4,64
    .byt RECTANGLE(5,5,41,11)
    .byt RECTANGLE(125,16,110,11)
    .byt RECTANGLE(131,53,104,15)
    .byt RECTANGLE(140,90,74,15)
    .byt OFFSET(1,0),"Damn...",0
    .byt OFFSET(1,0),"I will never be able",0
    .byt OFFSET(1,0),"to pick these locks",0
    .byt OFFSET(1,0),"fast enough!",0
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
