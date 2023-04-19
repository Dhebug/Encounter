
#include "params.h"
#include "floppy_description.h"
#include "game_enums.h"

    .text

_gTextLowerCaseAlphabet    .byt "abcde",255-2,"f",255-2,"ghi",255-2,"jklmnopqrstuvwxyz",0

_gDescriptionTeenagerRoom         .byt "T",255-2,"eenager r",255-1,"oom?",0

_gDescriptionNone
    END

_gDescriptionDarkTunel
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,172,15)
    .byt RECTANGLE(4,13,114,16)
    .byt OFFSET(1,0),"Like most tunnels: dark, damp,",0
    .byt OFFSET(1,1),"and somewhat scary.",0
    END

_gDescriptionMarketPlace
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,100,95,15)
    .byt RECTANGLE(4,106,59,15)
    .byt OFFSET(1,0),"The market place",0
    .byt OFFSET(1,4),"is deserted",0
    END

_gDescriptionDarkAlley
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(153,85,83,14)
    .byt RECTANGLE(136,98,100,15)
    .byt OFFSET(1,0),"Rats, gra",255-2,"f",255-3,"f",255-1,"itti,",0
    .byt OFFSET(1,0),"and used syringes.",0
    END

_gDescriptionRoad
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,100,87,11)
    .byt RECTANGLE(4,106,69,15)
    .byt OFFSET(1,0),"All roads lead...",0
    .byt OFFSET(1,4),"...somewhere?",0
    END

_gDescriptionMainStreet
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,64,12)
    .byt RECTANGLE(4,16,93,11)
    .byt OFFSET(1,0),"A good old",0
    .byt OFFSET(4,0),"medieval church",0
    END

_gDescriptionNarrowPath
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(124,5,105,12)
    .byt RECTANGLE(104,17,130,15)
    .byt OFFSET(1,0),"Are these the open",0
    .byt OFFSET(1,0),"f",255-1,"lood gates o",255-2,"f heaven?",0
    END

_gDescriptionInThePit   
    WAIT(50*2)
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(6,8,86,11)
    .byt OFFSET(1,0),"It did not look",0
    WAIT(50)
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(176,42,54,15)
    .byt OFFSET(1,0),"that deep",0
    WAIT(50)
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(82,94,74,15)
    .byt OFFSET(1,0),"from outside",0
    
    WAIT(50*2)                      ; Wait a couple seconds for dramatic effect
    
    JUMP(_gDescriptionGameOverLost);            ; Draw the 'The End' logo

_gDescriptionOutsidePit
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,94,98,15)
    .byt RECTANGLE(5,103,55,19)
    .byt OFFSET(1,0),"Are they digging",0
    .byt OFFSET(1,4),"for gold?",0
    END


_gDescriptionTarmacArea
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(149,5,86,11)
    .byt RECTANGLE(152,15,82,11)
    .byt OFFSET(1,0),"Ashes to Ashes",0
    .byt OFFSET(1,0),"Rust to Rust...",0
    END

_gDescriptionOldWell
    ; Is the Bucket near the Well?    
    JUMP_IF_FALSE(no_bucket,CHECK_ITEM_LOCATION(e_ITEM_Bucket,e_LOCATION_WELL))    
      DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(6,35),40,_SecondImageBuffer,_ImageBuffer+(40*86)+24)    ; Draw the Bucket 
no_bucket    
    
    ; Is the Rope near the Well?      
    JUMP_IF_FALSE(no_rope,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_WELL))    
      DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(7,44),40,_SecondImageBuffer+7,_ImageBuffer+(40*35)+26)  ; Draw the Rope
no_rope    

    ; Then show the messages
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(111,5,124,12)
    .byt RECTANGLE(158,16,75,11)
    .byt OFFSET(1,0),"This well looks as old",0
    .byt OFFSET(1,0),"as the church",0
    END

_gDescriptionWoodedAvenue
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,144,16)
    .byt RECTANGLE(4,14,129,16)
    .byt OFFSET(1,0),"These trees have probably",0
    .byt OFFSET(1,1),"witnessed many things",0
    END

_gDescriptionGravelDrive
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,3,64
    .byt RECTANGLE(127,86,108,11)
    .byt RECTANGLE(143,97,92,11)
    .byt RECTANGLE(182,107,53,15)
    .byt OFFSET(1,0),"Kind o",255-2,"f impressive",0
    .byt OFFSET(1,0),"when seen from",0
    .byt OFFSET(1,0),"f",255-2,"ar away",0
    END

_gDescriptionZenGarden
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,139,11)
    .byt RECTANGLE(4,15,72,16)
    .byt OFFSET(1,0),"A Japanese Zen Garden?",0
    .byt OFFSET(1,1),"In England?",0
    END

_gDescriptionFrontLawn
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,93,11)
    .byt RECTANGLE(5,15,84,16)
    .byt OFFSET(1,0),"The per",255-2,"f",255-2,"ect home",0
    .byt OFFSET(1,1),"f",255-2,"or egomaniacs",0
    END

_gDescriptionGreenHouse
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,96,80,15)
    .byt RECTANGLE(4,107,98,16)
    .byt OFFSET(1,0),"Obviously f",255-2,"or",0
    .byt OFFSET(1,1),34,"Therapeutic use",34,0
    END

_gDescriptionTennisCourt
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(4,4,107,12)
    .byt RECTANGLE(4,15,150,15)
    .byt OFFSET(1,0),"That's more like it:",0
    .byt OFFSET(1,0),"a proper lawn tennis court",0
    END

_gDescriptionVegetableGarden
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(134,5,100,12)
    .byt RECTANGLE(136,15,98,16)
    .byt OFFSET(1,0),"Not the best spot",0
    .byt OFFSET(1,1),"to grow tomatoes",0
    END

_gDescriptionFishPond
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,116,12)
    .byt RECTANGLE(5,17,116,15)
    .byt OFFSET(1,0),"Some o",255-2,"f these f",255-1,"ishes",0
    .byt OFFSET(1,0),"are sur",255-1,"prinsingly big",0
    END

_gDescriptionTiledPatio
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(93,5,143,11)
    .byt RECTANGLE(110,15,126,15)
    .byt OFFSET(1,0),"The house's back entrance",0
    .byt OFFSET(1,0),"is accessible from here",0
    END

_gDescriptionAppleOrchard
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,136,15)
    .byt RECTANGLE(5,17,139,15)
    .byt OFFSET(1,0),"The best kind o",255-2,"f apples:",0
    .byt OFFSET(1,0),"sweet",255-1,", crunchy and juicy",0
    END

_gDescriptionEntranceHall
    ; Is there a dog in the entrance
    JUMP_IF_FALSE(end_dog,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOCATION_ENTRANCEHALL))

    ; Is the dog dead?
    JUMP_IF_FALSE(dog_alive,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DEAD))
      ; Draw the dead dog
      DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(12,27),40,_SecondImageBuffer,_ImageBuffer+(40*90)+27)    
      ; Text describing the dead dog
      WAIT(DELAY_FIRST_BUBBLE)
      .byt COMMAND_BUBBLE,2,64
      .byt RECTANGLE(5,5,89,14)
      .byt RECTANGLE(5,17,115,15)
      .byt OFFSET(1,0),"Let's call that a ",0
      .byt OFFSET(1,0),34,"Collateral Damage",34,0
      END
      
dog_alive
    ; Draw the Growling dog
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(13,66),40,_SecondImageBuffer+(40*61)+0,_ImageBuffer+(40*56)+26)    
    ; Text describing the growling dog
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,139,15)
    .byt RECTANGLE(5,19,120,15)
    .byt OFFSET(1,0),"O",255-2,"f course there is a dog.",0
    .byt OFFSET(1,0),"There's always a dog.",0
    END

end_dog
    ; Some generic message in case the dog is not there (probably not displayed right now)
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(124,5,111,14)
    .byt RECTANGLE(187,17,48,11)
    .byt OFFSET(1,0),"Quite an impressive",0
    .byt OFFSET(1,0),"staircase",0
    END

_gDescriptionDogAttacking
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(21,128),40,_SecondImageBuffer+14,_ImageBuffer+(40*0)+10)    ; Draw the attacking dog
     ;
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(5,108,35,15)
    .byt OFFSET(1,0),"Oops...",0
    WAIT(50*2)                              ; Wait a couple seconds
    JUMP(_gDescriptionGameOverLost)         ; Game Over

_gDescriptionThugAttacking
    END


_gDescriptionLibrary
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,86,119,11)
    .byt RECTANGLE(5,97,110,15)
    .byt OFFSET(1,0),"Books, fireplace, and",0
    .byt OFFSET(1,0),"a com",255-2,"f",255-2,"ortable chair",0
    END

_gDescriptionNarrowPassage
    WAIT(DELAY_FIRST_BUBBLE)
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

    END

_gDescriptionEntranceLounge
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,105,11)
    .byt RECTANGLE(5,15,49,15)
    .byt OFFSET(1,0),"Looks like someone",0
    .byt OFFSET(1,0),"had fun",0
    END

_gDescriptionDiningRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,95,69,13)
    .byt RECTANGLE(5,107,84,15)
    .byt OFFSET(1,0),"Two plates...",0
    .byt OFFSET(1,0),"...good to know",0
    END

_gDescriptionGamesRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(142,5,93,13)
    .byt RECTANGLE(164,16,71,15)
    .byt OFFSET(1,0),"T",255-2,"op o",255-2,"f the range",0
    .byt OFFSET(1,0),"video system",0

    WAIT(50)

    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(175,40,60,15)
    .byt OFFSET(1,0),"Impressive",0
    END

_gDescriptionSunLounge
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(112,5,123,15)
    .byt OFFSET(1,0),"No rest ",255-2,"f",255-2,"or the weary",0
    END

_gDescriptionKitchen
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,71,11)
    .byt RECTANGLE(5,16,41,12)
    .byt OFFSET(1,0),"A very basic",0
    .byt OFFSET(1,0),"kitchen",0
    END

_gDescriptionNarrowStaircase
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,1,127
    .byt RECTANGLE(5,5,95,15)
    .byt OFFSET(1,0),"Watch your step",0
    END

_gDescriptionCellar
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,127
    .byt RECTANGLE(75,15,90,12)
    .byt RECTANGLE(80,25,67,15)
    .byt OFFSET(1,0),"Is that a Franz",0
    .byt OFFSET(1,0),"Jager safe?",0
    END

_gDescriptionDarkerCellar
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,127
    .byt RECTANGLE(5,99,104,12)
    .byt RECTANGLE(5,109,77,13)
    .byt OFFSET(1,0),"The window seems",0
    .byt OFFSET(1,0),"to be occulted",0
    END

_gDescriptionStaircase
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,3,64
    .byt RECTANGLE(16,8,32,15)
    .byt RECTANGLE(179,8,39,12)
    .byt RECTANGLE(60,72,119,15)
    .byt OFFSET(1,0),"Left?",0
    .byt OFFSET(1,0),"Right?",0
    .byt OFFSET(1,0),"does it really matter?",0
    END

_gDescriptionMainLanding
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(47,70,143,15)
    .byt OFFSET(1,0),"Nice view from up there",0
    END

_gDescriptionEastGallery
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,90,12)
    .byt RECTANGLE(20,17,34,12)
    .byt OFFSET(1,0),"Boring corridor:",0
    .byt OFFSET(1,0),"Check",0
    END

_gDescriptionChildBedroom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,96,74,12)
    .byt RECTANGLE(5,107,85,15)
    .byt OFFSET(1,0),"Let me guess:",0
    .byt OFFSET(1,0),"Teenager room?",0
    END

_gDescriptionGuestBedroom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,6,92,12)
    .byt RECTANGLE(5,17,71,15)
    .byt OFFSET(1,0),"Simple and ",255-2,"f",255-2,"resh",0
    .byt OFFSET(1,0),"f",255-2,"or a change",0
    END

_gDescriptionShowerRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(149,5,86,12)
    .byt RECTANGLE(152,16,83,13)
    .byt OFFSET(1,0),"I will need one",0
    .byt OFFSET(1,0),"when I'm done",0
    END

_gDescriptionWestGallery
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,127
    .byt RECTANGLE(85,81,72,13)
    .byt RECTANGLE(60,92,112,13)
    .byt OFFSET(1,0),"Is that Steel",0
    .byt OFFSET(1,0),"behind the Curtain?",0
    END

_gDescriptionBoxRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,63,11)
    .byt RECTANGLE(5,16,59,11)
    .byt OFFSET(1,0),"A practical",0
    .byt OFFSET(1,0),"little room",0
    END

_gDescriptionClassyBathRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(132,5,103,15)
    .byt OFFSET(1,0),"Looks comfortable",0
    END

_gDescriptionTinyToilet
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,1,64
    .byt RECTANGLE(137,5,98,15)
    .byt OFFSET(1,0),"Sparklingly clean",0
    END

_gDescriptionMasterBedRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt RECTANGLE(5,5,124,15)
    .byt RECTANGLE(5,16,84,15)
    .byt OFFSET(1,0),"This will make things",0
    .byt OFFSET(1,0),"notably easier...",0
    END



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
    END


_gDescriptionGameOverLost
    ; Draw the 'The End' logo
    DRAW_BITMAP(LOADER_SPRITE_THE_END,BLOCK_SIZE(20,95),20,_SecondImageBuffer,_ImageBuffer+(40*16)+10)
    ; Should probably have a "game over" command
    .byt COMMAND_FADE_BUFFER
    END

