
#include "params.h"
#include "../build/floppy_description.h"
#include "game_enums.h"

    .text

_StartGameTextData

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i ô:^
#endif


/* MARK: Generic Messages

      ::::::::  :::::::::: ::::    ::: :::::::::: :::::::::  ::::::::::: ::::::::              
    :+:    :+: :+:        :+:+:   :+: :+:        :+:    :+:     :+:    :+:    :+:              
   +:+        +:+        :+:+:+  +:+ +:+        +:+    +:+     +:+    +:+                      
  :#:        +#++:++#   +#+ +:+ +#+ +#++:++#   +#++:++#:      +#+    +#+                       
 +#+   +#+# +#+        +#+  +#+#+# +#+        +#+    +#+     +#+    +#+                        
#+#    #+# #+#        #+#   #+#+# #+#        #+#    #+#     #+#    #+#    #+#                  
########  ########## ###    #### ########## ###    ### ########### ########                    
        :::   :::   :::::::::: ::::::::   ::::::::      :::      ::::::::  :::::::::: :::::::: 
      :+:+: :+:+:  :+:       :+:    :+: :+:    :+:   :+: :+:   :+:    :+: :+:       :+:    :+: 
    +:+ +:+:+ +:+ +:+       +:+        +:+         +:+   +:+  +:+        +:+       +:+         
   +#+  +:+  +#+ +#++:++#  +#++:++#++ +#++:++#++ +#++:++#++: :#:        +#++:++#  +#++:++#++   
  +#+       +#+ +#+              +#+        +#+ +#+     +#+ +#+   +#+# +#+              +#+    
 #+#       #+# #+#       #+#    #+# #+#    #+# #+#     #+# #+#    #+# #+#       #+#    #+#     
###       ### ########## ########   ########  ###     ###  ########  ########## ########   */


// Small feedback messages and prompts
_StartMessagesAndPrompts
#ifdef LANGUAGE_FR
_gTextAskInput              .byt "Quels sont vos instructions ?",0
_gTextNothingHere           .byt "Il n'y a rien d'important ici",0
_gTextCanSee                .byt "Je vois ",0
_gTextScore                 .byt "Score:",0
_gTextCarryInWhat           .byt "Transporte dans quoi ?",0
_gTextSetKeyboardAzerty     .byt "Clavier en mode AZERTY",0
_gTextSetKeyboardQwerty     .byt "Clavier en mode QWERTY",0
_gTextSetKeyboardQwertz     .byt "Clavier en mode QWERTZ",0
_gTextUsableActionVerbs     .byt "Verbes utilisables",0
_gTextUseShiftToHighligth   .byt TEXT_CRLF,"Note: Utilisize SHIFT pour voir les objects",0
#else
_gTextAskInput              .byt "What are you going to do now?",0
_gTextNothingHere           .byt "There is nothing of interest here",0
_gTextCanSee                .byt "I can see ",0
_gTextScore                 .byt "Score:",0
_gTextCarryInWhat           .byt "Carry it in what?",0
_gTextSetKeyboardAzerty     .byt "Keyboard set to AZERTY layout",0
_gTextSetKeyboardQwerty     .byt "Keyboard set to QWERTY layout",0
_gTextSetKeyboardQwertz     .byt "Keyboard set to QWERTZ layout",0
_gTextUsableActionVerbs     .byt "Usable action verbs",0
_gTextUseShiftToHighligth   .byt TEXT_CRLF,TEXT_CRLF,"Note: Use SHIFT to highlight items",0
#endif
_EndMessagesAndPrompts

// Error messages 
_StartErrorMessages
#ifdef LANGUAGE_FR
_gTextErrorInvalidDirection .byt "Impossible d'aller par la",0
_gTextErrorCantTakeNoSee    .byt "Je ne vois pas ca ici",0
_gTextErrorAlreadyHaveItem  .byt "Vous avez déjà cet objet",0
_gTextErrorRidiculous       .byt "Ne soyez pas ridicule",0
_gTextErrorAlreadyFull      .byt "Désolé, c'est déja plein",0
_gTextErrorMissingContainer .byt "Vous n'avez pas ce contenant",0
_gTextErrorDropNotHave      .byt "Impossible, vous ne l'avez pas",0
_gTextErrorUnknownItem      .byt "Je ne connais pas cet objet",0
_gTextErrorNeedMoreDetails  .byt "Pourriez vous être plus précis ?",0
_gTextErrorItemNotPresent   .byt "Cet objet n'est pas présent",0
_gTextErrorIventoryFull     .byt "Je doit d'abord déposer quelque chose",0
#else
_gTextErrorInvalidDirection .byt "Impossible to move in that direction",0
_gTextErrorCantTakeNoSee    .byt "You can only take something you see",0
_gTextErrorAlreadyHaveItem  .byt "You already have this item",0
_gTextErrorRidiculous       .byt "Don't be ridiculous",0
_gTextErrorAlreadyFull      .byt "Sorry, that's full already",0
_gTextErrorMissingContainer .byt "You don't have this container",0
_gTextErrorDropNotHave      .byt "You can only drop something you have",0
_gTextErrorUnknownItem      .byt "I do not know what this item is",0
_gTextErrorNeedMoreDetails  .byt "Could you be more precise please?",0
_gTextErrorItemNotPresent   .byt "Can't see it here",0
_gTextErrorIventoryFull     .byt "I need to drop something first",0
#endif
_EndErrorMessages


/* MARK: Items

██╗████████╗███████╗███╗   ███╗███████╗
██║╚══██╔══╝██╔════╝████╗ ████║██╔════╝
██║   ██║   █████╗  ██╔████╔██║███████╗
██║   ██║   ██╔══╝  ██║╚██╔╝██║╚════██║
██║   ██║   ███████╗██║ ╚═╝ ██║███████║
╚═╝   ╚═╝   ╚══════╝╚═╝     ╚═╝╚══════╝ */

_StartItemNames
#ifdef LANGUAGE_FR
// Containers
_gTextItemTobaccoTin              .byt "une tabatière",0
_gTextItemBucket                  .byt "un seau en bois",0
_gTextItemCardboardBox            .byt "une boite en carton",0
_gTextItemFishingNet              .byt "un filet de pêche",0
_gTextItemPlasticBag              .byt "un sac en plastique",0
_gTextItemSmallBottle             .byt "une petite bouteille",0
// Items requiring containers
_gTextItemBlackDust               .byt "du salpêtre",0
_gTextItemYellowPowder            .byt "du soufre",0
_gTextItemPetrol                  .byt "du pétrole",0
_gTextItemWater                   .byt "de l'eau",0
// Normal items
_gTextItemOpenPanel               .byt "un _paneau mural ouvert",0
_gTextItemSmallHoleInDoor         .byt "un petit _trou dans la porte",0
_gTextItemString                  .byt "une _ficelle",0
_gTextItemSilverKnife             .byt "un _couteau en argent",0
_gTextItemMixTape                 .byt "une _compil sur K7",0
_gTextItemAlsatianDog             .byt "un _chien qui grogne",0
_gTextItemMeat                    .byt "un morceau de _viande",0
_gTextItemBread                   .byt "du _pain complet",0
_gTextItemRollOfTape              .byt "un rouleau de _bande adhésive",0
_gTextItemChemistryBook           .byt "un _livre de chimie",0
_gTextItemBoxOfMatches            .byt "une boite d'_allumettes",0
_gTextItemSnookerCue              .byt "une _queue de billard",0
_gTextItemThug                    .byt "un _voyou endormi sur le lit",0
_gTextItemHeavySafe               .byt "un gros _coffre fort",0
_gTextItemHandWrittenNote         .byt "une _note manuscripte",0
_gTextItemRollOfToiletPaper       .byt "un _rouleau de PQ",0
_gTextItemOpenSafe                .byt "un _coffre fort ouvert",0
_gTextItemBrokenGlass             .byt "des morceaux de _glace",0
_gTextItemYoungGirl               .byt "une jeune _fille",0
_gTextItemFuse                    .byt "une _mêche",0
_gTextItemPowderMix               .byt "un _mix grumeleux",0
_gTextItemGunPowder               .byt "de la _poudre à cannon",0
_gTextItemKeys                    .byt "un jeu de _clefs",0
_gTextItemNewspaper               .byt "un _journal",0
_gTextItemBomb                    .byt "une _bombe",0
_gTextItemPistol                  .byt "un _pistolet",0
_gTextItemBullets                 .byt "trois _balles de calibre .38",0
_gTextItemChemistryRecipes        .byt "_formules de chimie",0
_gTextItemUnitedKingdomMap        .byt "une _carte du royaume uni",0
_gTextItemHandheldGame            .byt "un _jeu portable",0
_gTextItemSedativePills           .byt "des _somnifères",0
_gTextItemDartGun                 .byt "un _lance fléchettes",0
_gTextItemBlackTape               .byt "du _ruban adhésif noir",0
_gTextItemMortarAndPestle         .byt "un mortier et pilon",0
_gTextItemAdhesive                .byt "de l'_adhésif",0
_gTextItemAcid                    .byt "un _acide puissant",0
_gTextItemSecurityDoor            .byt "une _porte blindée",0
_gTextItemDriedOutClay            .byt "de l'_argile désséchée",0
_gTextItemProtectionSuit          .byt "une tenue EPI",0
_gTextItemHoleInDoor              .byt "un _trou dans la porte",0
_gTextItemFrontDoor               .byt "la _porte principale",0
_gTextItemRoughMap                .byt "une _carte sommaire",0
_gTextItemLargeDoveOutOfReach     .byt "une _colombe haute perchée",0
#else
// Containers
_gTextItemTobaccoTin              .byt "a tobacco _tin",0               
_gTextItemBucket                  .byt "a wooden _bucket",0                    
_gTextItemCardboardBox            .byt "a cardboard _box",0                    
_gTextItemFishingNet              .byt "a fishing _net",0                      
_gTextItemPlasticBag              .byt "a plastic _bag",0                      
_gTextItemSmallBottle             .byt "a small _bottle",0                     
// Items requiring containers
_gTextItemBlackDust               .byt "some _saltpetre",0
_gTextItemYellowPowder            .byt "some _sulphur",0
_gTextItemPetrol                  .byt "some _petrol",0                        
_gTextItemWater                   .byt "some _water",0                         
// Normal items
_gTextItemOpenPanel               .byt "an open _panel on wall",0              
_gTextItemSmallHoleInDoor         .byt "a small _hole in the door",0           
_gTextItemString                  .byt "a _string",0                         
_gTextItemSilverKnife             .byt "a silver _knife",0                     
_gTextItemMixTape                 .byt "a _mixtape",0
_gTextItemAlsatianDog             .byt "a _dog growling at you",0        
_gTextItemMeat                    .byt "a joint of _meat",0                    
_gTextItemBread                   .byt "some brown _bread",0                   
_gTextItemRollOfTape              .byt "a roll of sticky _tape",0              
_gTextItemChemistryBook           .byt "a chemistry _book",0                   
_gTextItemBoxOfMatches            .byt "a box of _matches",0                   
_gTextItemSnookerCue              .byt "a snooker _cue",0                      
_gTextItemThug                    .byt "a _thug asleep on the bed",0           
_gTextItemHeavySafe               .byt "a heavy _safe",0                       
_gTextItemHandWrittenNote         .byt "a hand written _note",0                     
_gTextItemRollOfToiletPaper       .byt "a toilet _roll",0            
_gTextItemOpenSafe                .byt "an open _safe",0                       
_gTextItemBrokenGlass             .byt "broken glass",0                       
_gTextItemYoungGirl               .byt "a young _girl",0                        
_gTextItemFuse                    .byt "a _fuse",0                             
_gTextItemPowderMix               .byt "a rough powder _mix",0
_gTextItemGunPowder               .byt "some _gunpowder",0
_gTextItemKeys                    .byt "a set of _keys",0                      
_gTextItemNewspaper               .byt "a _newspaper",0                        
_gTextItemBomb                    .byt "a _bomb",0                             
_gTextItemPistol                  .byt "a _pistol",0                           
_gTextItemBullets                 .byt "three .38 _bullets",0                  
_gTextItemChemistryRecipes        .byt "chemistry _recipes",0         
_gTextItemUnitedKingdomMap        .byt "a _map of the United Kingdom",0        
_gTextItemHandheldGame            .byt "a handheld _game",0
_gTextItemSedativePills           .byt "some sedative _pills",0
_gTextItemDartGun                 .byt "a _dart gun",0
_gTextItemBlackTape               .byt "some black adhesive _tape",0
_gTextItemMortarAndPestle         .byt "a _mortar and pestle",0
_gTextItemAdhesive                .byt "some _adhesive",0
_gTextItemAcid                    .byt "some strong _acid",0
_gTextItemSecurityDoor            .byt "a security _door",0
_gTextItemDriedOutClay            .byt "some dried out _clay",0
_gTextItemProtectionSuit          .byt "a protection _suit",0
_gTextItemHoleInDoor              .byt "a _hole in the door",0
_gTextItemFrontDoor               .byt "the entrance _door",0
_gTextItemRoughMap                .byt "a rough _map",0
_gTextItemLargeDoveOutOfReach     .byt "a _dove on a tall tree",0
#endif
_EndItemNames


/* MARK: Scene descriptions

███████╗ ██████╗███████╗███╗   ██╗███████╗    ██████╗ ███████╗███████╗ ██████╗██████╗ ██╗██████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝██╔════╝██╔════╝████╗  ██║██╔════╝    ██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
███████╗██║     █████╗  ██╔██╗ ██║█████╗      ██║  ██║█████╗  ███████╗██║     ██████╔╝██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║███████╗
╚════██║██║     ██╔══╝  ██║╚██╗██║██╔══╝      ██║  ██║██╔══╝  ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║╚════██║
███████║╚██████╗███████╗██║ ╚████║███████╗    ██████╔╝███████╗███████║╚██████╗██║  ██║██║██║        ██║   ██║╚██████╔╝██║ ╚████║███████║
╚══════╝ ╚═════╝╚══════╝╚═╝  ╚═══╝╚══════╝    ╚═════╝ ╚══════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ */

_StartSceneScripts
_gDescriptionTeenagerRoom         .byt "Teenager room?",0

_gDescriptionNone
    END

// MARK: Dark Tunel
_gDescriptionDarkTunel
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans un tunnel humide")
#else
    SET_DESCRIPTION("You are in a dark, damp tunnel")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(4,4,0,"Un tunnel ordinaire: sombre,")
    _BUBBLE_LINE(4,13,1,"humide et inquiétant.")
#else    
    _BUBBLE_LINE(4,4,0,"Like most tunnels: dark, damp,")
    _BUBBLE_LINE(4,13,1,"and somewhat scary.")
#endif    
    ; Could probably have an animation of a droplet falling down (like the animated FISH shop)
    ; and have the plic a single sound that plays at the same time
    ;PLAY_SOUND(_WaterDrip)                                   ; Play the plic, ploc background sound

falling_water_drop
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,88)                     ; Draw the droplet at the top
               _IMAGE(18,0)
               _SCREEN(24,24)
    WAIT(1)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,88)                     ; Draw the droplet falling
               _IMAGE(19,0)
               _SCREEN(24,24)
    WAIT(1)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,88)                     ; Draw the droplet falling
               _IMAGE(20,0)
               _SCREEN(24,24)
    WAIT(1)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,88)                     ; Draw the droplet falling
               _IMAGE(21,0)
               _SCREEN(24,24)
    WAIT(1)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,88)                     ; Draw the droplet falling
               _IMAGE(22,0)
               _SCREEN(24,24)
    WAIT(1)
    PLAY_SOUND(_WaterDrip)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,88)                     ; Draw the droplet splashing
               _IMAGE(23,0)
               _SCREEN(24,24)
    WAIT_RANDOM(50,127)
    WAIT_RANDOM(0,255)

    JUMP(falling_water_drop)

    END


// MARK: Market Place
_gDescriptionMarketPlace
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur la place du marché")
#else
    SET_DESCRIPTION("You are in a deserted market square")
#endif    
    SET_ITEM_LOCATION(e_ITEM_Car,e_LOC_MARKETPLACE)
+_gTextItemMyCar = *+2   
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"ma _voiture")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"my _car")
#endif    

hack_show_plastic_bag_again
    ; Is the plastic bag on the market place?
    JUMP_IF_FALSE(no_plastic_bag,CHECK_ITEM_LOCATION(e_ITEM_PlasticBag,e_LOC_MARKETPLACE))    
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,4)                     ; Draw the plastic bag
                _IMAGE(24,0)
                _BUFFER(2,79)
no_plastic_bag    

    ; Is the girl here?
    JUMP_IF_FALSE(girl_not_here,CHECK_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_MARKETPLACE))
        ; She's here, we won!
        ; Victory!
        SET_CUT_SCENE(1)
        STOP_CLOCK
        
        LOAD_MUSIC(LOADER_MUSIC_VICTORY)
        INCREASE_SCORE(POINTS_WON_THE_GAME)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_SOLVED_THE_CASE)
        FADE_BUFFER                            ; Show the market place
        WAIT(DELAY_FIRST_BUBBLE)
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
        _BUBBLE_LINE(4,100,0,"Nous l'avons fait !")
        _BUBBLE_LINE(4,106,4,"Plus qu'a rentrer à la maison")
#else
        _BUBBLE_LINE(90,70,0,"We did it!")
        _BUBBLE_LINE(70,80,0,"Time to go home!")
#endif    
        WAIT(50*4)                                ; Wait a couple seconds
        STOP_MUSIC()
        
        DISPLAY_IMAGE(LOADER_PICTURE_AUSTIN_MINI,"Time to go home")         ; Car without passengers
        WAIT(50*2)                                ; Wait a couple seconds
        
        BLIT_BLOCK(LOADER_SPRITE_AUSTIN_PARTS,8,80)                            ; Open the left door
            _IMAGE(0,0)
            _BUFFER(4,15)
        PLAY_SOUND(_DoorOpening)
        FADE_BUFFER
        WAIT(50)                                ; Wait a second

        BLIT_BLOCK(LOADER_SPRITE_AUSTIN_PARTS,3,13)                            ; Add the passenger head
            _IMAGE(0,80)
            _BUFFER(15,31)
        FADE_BUFFER
        WAIT(50)                                ; Wait a second

        BLIT_BLOCK(LOADER_SPRITE_AUSTIN_PARTS,8,80)                            ; Close the left door
            _IMAGE(32,0)
            _BUFFER(4,15)
        PLAY_SOUND(_DoorClosing)
        FADE_BUFFER
        WAIT(50)                                ; Wait a second

        BLIT_BLOCK(LOADER_SPRITE_AUSTIN_PARTS,7,80)                            ; Open the right door
            _IMAGE(8,0)
            _BUFFER(29,15)
        PLAY_SOUND(_DoorOpening)
        FADE_BUFFER
        WAIT(50)                                ; Wait a second

        BLIT_BLOCK(LOADER_SPRITE_AUSTIN_PARTS,4,14)                            ; Add the driver head
            _IMAGE(3,80)
            _BUFFER(22,29)
        FADE_BUFFER
        WAIT(50)                                ; Wait a second
        
        BLIT_BLOCK(LOADER_SPRITE_AUSTIN_PARTS,7,80)                            ; Close the right door
            _IMAGE(25,0)
            _BUFFER(29,15)
        PLAY_SOUND(_DoorClosing)
        FADE_BUFFER
        WAIT(50)                                ; Wait a second
        
        BLIT_BLOCK(LOADER_SPRITE_AUSTIN_PARTS,6,30)                            ; Draw the small puff of smoke
            _IMAGE(0,94)
            _BUFFER(12,94)
        PLAY_SOUND(_VroomVroom)
        FADE_BUFFER
        WAIT(50)                                ; Wait a second

        BLIT_BLOCK(LOADER_SPRITE_AUSTIN_PARTS,11,48)                            ; Draw the bigger puff of smoke
            _IMAGE(7,80)
            _BUFFER(10,80)
        PLAY_SOUND(_VroomVroom)
        FADE_BUFFER
        WAIT(50)                                ; Wait a second
        PLAY_SOUND(_EngineRunning)
        WAIT(50)                                ; Wait a second

        DISPLAY_IMAGE(LOADER_PICTURE_NEWS_SAVED,"The Daily Telegraph, September 30th")
        LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
        WAIT(50*4)                                ; Wait a couple seconds
        STOP_MUSIC()

        GAME_OVER(e_SCORE_SOLVED_THE_CASE)        ; The game is now over
        JUMP(_gDescriptionGameOverWon)            ; Draw the 'The End' logo
girl_not_here

    .(
    DO_ONCE(intro_sequence)
        SET_CUT_SCENE(1)
        FADE_BUFFER
    ENDDO(intro_sequence)
    .)
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(4,100,0,"La place du marché")
    _BUBBLE_LINE(4,106,4,"est désertée")
#else
    _BUBBLE_LINE(4,100,0,"The market place")
    _BUBBLE_LINE(4,106,4,"is deserted")
#endif    

    ; This should be shown only once at the start.
    ; Should probably disable the keyboard inputs
    .(
    DO_ONCE(intro_sequence)
        ; First we show the map of where the player needs to go
        SET_SKIP_POINT(end_intro_sequence)
        WAIT(50*2)
        GOSUB(_ShowRoughMap)        
        ; Then we show an animated sequence where the digital watch is set to have an alarm in two hours
        GOSUB(_WatchSetup)

end_intro_sequence        
        STOP_MUSIC()                   ; To ensure sounds are back if we cut before the music ended... (Need to fix that more cleanly, so many hacks now!)
        ; Back to the market place
        DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_LOCATIONS_START,"Time passes")
        FADE_BUFFER
        START_CLOCK
        SET_CUT_SCENE(0)
        JUMP(hack_show_plastic_bag_again)   ; Ugly, quick hack
    ENDDO(intro_sequence)
    .)

blinky_shop
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,8,11)                     ; Draw the Fish Shop "grayed out"
               _IMAGE(32,116)
               _SCREEN(11,14)
    WAIT(50) 
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,8,11)                     ; Draw the Fish Shop "fully drawn"
               _IMAGE(32,104)
               _SCREEN(11,14)
    
    WAIT(50)
    JUMP(blinky_shop)
    ;END
.)

// MARK: Dark Alley
_gDescriptionDarkAlley
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans une allée sombre")
#else
    SET_DESCRIPTION("You are in a dark, seedy alley")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(145,90,0,"Rats, graffitis,")
    _BUBBLE_LINE(160,103,0,"et seringues.")
#else
    _BUBBLE_LINE(153,85,0,"Rats, graffiti,")
    _BUBBLE_LINE(136,98,0,"and used syringes.")
#endif    

blinky_light_bulb
    PLAY_SOUND(_FlickeringLight)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,4,11)                     ; Draw the bright light
               _IMAGE(28,117)
               _SCREEN(4,37)
    WAIT_RANDOM(5,15)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,4,11)                     ; Draw the non working (dark) light
               _IMAGE(28,106)
               _SCREEN(4,37)  
    WAIT_RANDOM(10,255)
    JUMP(blinky_light_bulb)

    END


// MARK: Road
_gDescriptionRoad
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une longue route s'étend devant vous")
#else
    SET_DESCRIPTION("A long road stretches ahead of you")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(4,95,0,"Tous les chemins mènent...")
    _BUBBLE_LINE(4,106,0,"...quelque part?")
#else    
    _BUBBLE_LINE(4,100,0,"All roads lead...")
    _BUBBLE_LINE(4,106,4,"...somewhere?")
#endif    
    END


// MARK: Main Street
_gDescriptionMainStreet
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans la rue principale")
#else
    SET_DESCRIPTION("You are on the main street")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(4,4,0,"Une bonne vieille")
    _BUBBLE_LINE(4,16,0,"église médiévale")
#else    
    _BUBBLE_LINE(4,4,0,"A good old")
    _BUBBLE_LINE(4,16,0,"medieval church")
#endif    
    END


// MARK: Eastern Road
_gDescriptionEasternRoad
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur la route de l'est")
#else
    SET_DESCRIPTION("You are along the eastern road")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(130,5,0,"Serait-ce les")
    _BUBBLE_LINE(129,17,0,"portes du Paradis?")
#else    
    _BUBBLE_LINE(130,5,0,"Are these the open")
    _BUBBLE_LINE(109,17,0,"flood gates of heaven?")
#endif    
    END


// MARK: In the Pit
_gDescriptionInThePit
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes au fond d'un trou")
#else
    SET_DESCRIPTION("You are inside a deep pit")
#endif    

    ; If the rope is outside the pit and is attached to the tree, we move it inside  the pit
    JUMP_IF_FALSE(end_rope_check,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_OUTSIDE_PIT))
    JUMP_IF_FALSE(end_rope_check,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Rope,e_LOC_INSIDE_PIT)
end_rope_check

    ; If the ladder is outside the pit and is in place, we move it inside the pit
    JUMP_IF_FALSE(end_ladder_check,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_OUTSIDE_PIT))
    JUMP_IF_FALSE(end_ladder_check,CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_INSIDE_PIT)
end_ladder_check

    ; Check items
    SET_LOCATION_DIRECTION(e_LOC_INSIDE_PIT,e_DIRECTION_UP,e_LOC_NONE)      ; Disable the UP direction

    JUMP_IF_FALSE(no_rope,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_INSIDE_PIT))
    JUMP_IF_TRUE(rope_attached_to_tree,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
no_rope    

    JUMP_IF_TRUE(has_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_INVENTORY))    
    JUMP_IF_TRUE(draw_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_INSIDE_PIT))  

cannot_escape_pit    ; The player has no way to escape the pit
    SET_CUT_SCENE(1)
    FADE_BUFFER
    WAIT(50*2)
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(6,8,0,"Ca ne semblait")
#else    
    _BUBBLE_LINE(6,8,0,"It did not look")
#endif    
    WAIT(50)
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(156,42,0,"pas si profond")
#else    
    _BUBBLE_LINE(176,42,0,"that deep")
#endif    
    WAIT(50)
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(82,94,0,"vu de là haut")
#else    
    _BUBBLE_LINE(82,94,0,"from outside")
#endif    
    LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
    WAIT(50*2)                                      ; Wait a couple seconds for dramatic effect
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_FELL_INTO_PIT)   ; Achievement!
    GAME_OVER(e_SCORE_FELL_INTO_PIT)                ; The game is now over
    JUMP(_gDescriptionGameOverLost)                 ; Draw the 'The End' logo

draw_ladder
    SET_LOCATION_DIRECTION(e_LOC_INSIDE_PIT,e_DIRECTION_UP,e_LOC_OUTSIDE_PIT)                   ; Enable the UP direction
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,4,50)                     ; Draw the ladder 
               _IMAGE(36,0)
               _BUFFER(19,40)

has_ladder
    END

rope_attached_to_tree
    SET_LOCATION_DIRECTION(e_LOC_INSIDE_PIT,e_DIRECTION_UP,e_LOC_OUTSIDE_PIT)                           ; Enable the UP direction
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(3,52),40,_SecondImageBuffer+(40*51)+37,_ImageBuffer+(40*39)+19)    ; Draw the rope 
    END
.)


// MARK: Outside pit
_gDescriptionOutsidePit
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("En dehors d'un trou profond")
#else
    SET_DESCRIPTION("Outside a deep pit")
#endif    
    ; If the rope is inside the pit and is attached to the tree, we move it outside the pit
    JUMP_IF_FALSE(end_rope_check,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_INSIDE_PIT))
    JUMP_IF_FALSE(end_rope_check,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Rope,e_LOC_OUTSIDE_PIT)
end_rope_check

    ; If the ladder is inside the pit and is in place, we move it outside the pit
    JUMP_IF_FALSE(end_ladder_check,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_INSIDE_PIT))
    JUMP_IF_FALSE(end_ladder_check,CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_OUTSIDE_PIT)
end_ladder_check

    ; Check items
    JUMP_IF_FALSE(no_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_OUTSIDE_PIT))
    JUMP_IF_TRUE(ladder_in_hole,CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED))
no_ladder

    JUMP_IF_FALSE(no_rope,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_OUTSIDE_PIT))
    JUMP_IF_TRUE(rope_attached_to_tree,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
no_rope    
    JUMP(digging_for_gold)            ; Generic message if the ladder or rope are not present

ladder_in_hole
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(4,34),40,_SecondImageBuffer+25,_ImageBuffer+(40*53)+20)    ; Draw the ladder 
    END

rope_attached_to_tree
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(5,49),40,_SecondImageBuffer+30,_ImageBuffer+(40*38)+21)    ; Draw the rope 
    END

digging_for_gold
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(5,93,0,"Cherchent ils")
    _BUBBLE_LINE(5,101,4,"de l'or ?")
#else
    _BUBBLE_LINE(5,90,0,"Are they digging")
    _BUBBLE_LINE(8,103,0,"for gold?")
#endif    
    END
.)


// MARK: Parking Place
_gDescriptionParkingPlace
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur une zone asphaltée")
#else
    SET_DESCRIPTION("You are in an open area of tarmac")
#endif    

    SET_ITEM_LOCATION(e_ITEM_Car,e_LOC_PARKING_PLACE)
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"une _voiture abandonnée")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"an abandoned _car")
#endif    

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(119,5,0,"De cendres à cendres")
    _BUBBLE_LINE(124,13,3,"De rouille à rouille")
#else
    _BUBBLE_LINE(149,5,0,"Ashes to Ashes")
    _BUBBLE_LINE(152,15,0,"Rust to Rust...")
#endif    
    END


// MARK: Abandoned Car
_gDescriptionAbandonedCar
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une voiture abandonnée")
#else
    SET_DESCRIPTION("An abandoned car")
#endif    
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_CarBoot,ITEM_FLAG_CLOSED),boot)     ; Is the boot closed?
        BLIT_BLOCK(LOADER_SPRITE_CAR_PARTS,21,94)                       ; Draw the open boot
                _IMAGE(0,0)
                _BUFFER(2,0)
    ENDIF(boot)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_CarDoor,ITEM_FLAG_CLOSED),door)     ; Is the door open?
        BLIT_BLOCK(LOADER_SPRITE_CAR_PARTS,9,71)                        ; Draw the open door
                _IMAGE(31,0)
                _BUFFER(31,9)
    ENDIF(door)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_CarTank,ITEM_FLAG_CLOSED),tank)     ; Is the tank open?
        BLIT_BLOCK(LOADER_SPRITE_CAR_PARTS,2,24)                        ; Draw the open tank
                _IMAGE(0,95)
                _BUFFER(21,73)
    ENDIF(tank)

    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Hose,ITEM_FLAG_ATTACHED),hose)       ; Is the hose in the tank?
        BLIT_BLOCK(LOADER_SPRITE_CAR_PARTS,3,53)                        ; Draw the hose pipe
                _IMAGE(37,72)
                _BUFFER(21,75)
    ENDIF(hose)
    END
.)


// MARK: Old Well
_gDescriptionOldWell
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes prês d'un vieux puit")
#else
    SET_DESCRIPTION("You are near to an old-fashioned well")
#endif    
    ; Is the Bucket near the Well?    
    JUMP_IF_FALSE(no_bucket,CHECK_ITEM_LOCATION(e_ITEM_Bucket,e_LOC_WELL))    
      DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(6,35),40,_SecondImageBuffer,_ImageBuffer+(40*86)+24)    ; Draw the Bucket 
no_bucket    
    
    ; Is the Rope near the Well?      
    JUMP_IF_FALSE(no_rope,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_WELL))    
      DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(7,44),40,_SecondImageBuffer+7,_ImageBuffer+(40*35)+26)  ; Draw the Rope
no_rope    

    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    ; Then show the messages
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(121,5,0,"Ce puit semble aussi")
    _BUBBLE_LINE(138,16,0,"vieux que l'église")
#else
    _BUBBLE_LINE(111,5,0,"This well looks as old")
    _BUBBLE_LINE(158,16,0,"as the church")
#endif    
    JUMP(_ChirpingBirds)
.)


// MARK: Wooded Avenue
_gDescriptionWoodedAvenue
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans une allée arbroisée")
#else
    SET_DESCRIPTION("You are in a wooded avenue")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(4,4,0,"Ces arbres ont probablement")
    _BUBBLE_LINE(4,15,0,"été témoin de beaucoup de choses")
#else
    _BUBBLE_LINE(4,4,0,"These trees have probably")
    _BUBBLE_LINE(4,14,1,"witnessed many things")
#endif    
    JUMP(_ChirpingBirds)
.)


_ChirpingBirds
.(
loop
    GOSUB(_Chirp1Sequence3)
    WAIT_RANDOM(5,63)
    GOSUB(_Chirp2Sequence1)
    WAIT_RANDOM(5,63)
    GOSUB(_Chirp1Sequence2)
    WAIT_RANDOM(5,63)
    GOSUB(_Chirp2Sequence1)
    WAIT_RANDOM(5,63)
    GOSUB(_Chirp1Sequence1)
    WAIT_RANDOM(5,63)
    GOSUB(_Chirp2Sequence3)
    WAIT_RANDOM(5,63)
    JUMP(loop)
.)

_Chirp1Sequence3
    PLAY_SOUND(_BirdChirp1)
    WAIT_RANDOM(10,15)
_Chirp1Sequence2
    PLAY_SOUND(_BirdChirp1)
    WAIT_RANDOM(10,15)
_Chirp1Sequence1
    PLAY_SOUND(_BirdChirp1)
    WAIT_RANDOM(10,15)
    RETURN

_Chirp2Sequence3
    PLAY_SOUND(_BirdChirp2)
    WAIT_RANDOM(10,15)
_Chirp2Sequence2
    PLAY_SOUND(_BirdChirp2)
    WAIT_RANDOM(10,15)
_Chirp2Sequence1
    PLAY_SOUND(_BirdChirp2)
    WAIT_RANDOM(10,15)
    RETURN


// MARK: Gravel Drive
_gDescriptionGravelDrive
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur un passage gravilloné")
#else
    SET_DESCRIPTION("You are on a wide gravel drive")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(3)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(180,86,0,"Plutôt")
    _BUBBLE_LINE(150,97,0,"impressionnant")
    _BUBBLE_LINE(176,107,2,"vu de loin")
#else
    _BUBBLE_LINE(127,86,0,"Kind of impressive")
    _BUBBLE_LINE(143,97,0,"when seen from")
    _BUBBLE_LINE(182,107,0,"far away")
#endif    
    END


// MARK: Zen Garden
_gDescriptionZenGarden
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans un jardin zen relaxant")
#else
    SET_DESCRIPTION("You are in a relaxing zen garden")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(9,5,0,"Un jardin zen japonais ?")
    _BUBBLE_LINE(5,17,0,"En Angleterre ?")
#else    
    _BUBBLE_LINE(4,4,0,"A Japanese zen garden?")
    _BUBBLE_LINE(4,15,1,"In England?")
#endif    
    END


// MARK: Front Lawn
_gDescriptionFrontLawn
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur une large pelouse")
#else
    SET_DESCRIPTION("You are on a huge area of lawn")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(5,5,0,"La maison parfaite")
    _BUBBLE_LINE(5,15,0,"pour les égocentriques")
#else    
    _BUBBLE_LINE(5,5,0,"The perfect home")
    _BUBBLE_LINE(5,15,1,"for egomaniacs")
#endif    
    END


// MARK: Green House
_gDescriptionGreenHouse
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans une petite serre")
#else
    SET_DESCRIPTION("You are in a small greenhouse")
#endif    

    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(4,5,0,"Evidemment pour")
    .byt 4,17,0,34,"Usage thérapeutique",34,0
#else
    _BUBBLE_LINE(4,96,0,"Obviously for")
    .byt 4,107,1,34,"therapeutic use",34,0
#endif
    END
.)


// MARK: Tennis Court
_gDescriptionTennisCourt
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur un cours de tennis")
#else
    SET_DESCRIPTION("You are on a lawn tennis court")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(5,5,0,"Bein voila: Un vrai court")
    _BUBBLE_LINE(5,16,0,"de tennis sur gazon")
#else
    _BUBBLE_LINE(4,4,0,"That's more like it:")
    _BUBBLE_LINE(4,15,0,"a proper lawn tennis court")
#endif    
    END


// MARK: Vegetable Garden
_gDescriptionVegetableGarden
    SET_ITEM_LOCATION(e_ITEM_BasementWindow,e_LOC_VEGSGARDEN)     ; The window is in the garden
#ifdef LANGUAGE_FR       
_gTextItemBasementWindow = *+1
    SET_ITEM_DESCRIPTION(e_ITEM_BasementWindow,"une _fenêtre basse")
    SET_DESCRIPTION("Vous êtes dans un jardin potagé")
#else
_gTextItemBasementWindow = *+1
    SET_ITEM_DESCRIPTION(e_ITEM_BasementWindow,"a basement _window")
    SET_DESCRIPTION("You are in a vegetable plot")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(102,5,0,"Pas le meilleur endroit")
    _BUBBLE_LINE(97,15,0,"faire pousser des tomates")
#else    
    _BUBBLE_LINE(134,5,0,"Not the best spot")
    _BUBBLE_LINE(136,15,1,"to grow tomatoes")
#endif
    END


// MARK: Fish Pond
_gDescriptionFishPond
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes près d'un bac a poisson")
#else
    SET_DESCRIPTION("You are standing by a fish pond")
#endif    

    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(5,5,0,"Certains de ces poissons")
    _BUBBLE_LINE(5,17,0,"sont étonnamment gros")
#else    
    _BUBBLE_LINE(5,5,0,"Some of these fishes")
    _BUBBLE_LINE(5,17,0,"are surprisingly big")
#endif    
    END
.)


// MARK: Tiled Patio
_gDescriptionTiledPatio
.(
    ; Move the panic room window here if the girl is freed
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_YoungGirl,ITEM_FLAG_DISABLED),girl_unrestrained)
        SET_ITEM_LOCATION(e_ITEM_PanicRoomWindow,e_LOC_TILEDPATIO)
+_gTextItemHighUpWindow = *+2        
#ifdef LANGUAGE_FR                                                                                   ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"une _fenêtre inaccessible")
#else        
        SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"an inaccessible _window")
#endif        
    ENDIF(girl_unrestrained)

#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur un patio carellé")
#else
    SET_DESCRIPTION("You are on a tiled patio")
#endif    

    ; Draw the girl if she's here
    JUMP_IF_FALSE(girl_is_outside,CHECK_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_TILEDPATIO))
        INCREASE_SCORE(POINTS_MET_THE_GIRL)
        SET_ITEM_FLAGS(e_ITEM_YoungGirl,ITEM_FLAG_ATTACHED)                   ; From now on she will follow us
        BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,16,78)                     ; Draw the girl on the small wall outside on the view
                _IMAGE(23,0)
                _BUFFER(0,17)
        WAIT(50)

        ; Print the "Thank you" message (only once)
        .(
        DO_ONCE(thank_you)
            WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR   
            _BUBBLE_LINE(12,50,0,"Merci !")
#else
            _BUBBLE_LINE(12,50,0,"Thank you!")
#endif   
            
            BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,2,10)                     ; Draw the speech bubble triangle
                    _IMAGE(6,31)
                    _SCREEN(3,40)
            WAIT(50*2)
        ENDDO(thank_you)
        .)

        ; Print the "I'll follow you" message
        WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR   
        _BUBBLE_LINE(12,50,0,"Je vais vous suivre !")
#else
        _BUBBLE_LINE(12,50,0,"I'll follow you!")
#endif           
        BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,2,10)                     ; Draw the speech bubble triangle
                _IMAGE(6,31)
                _SCREEN(3,40)
girl_is_outside        

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(107,5,0,"Ici on accède à l'entrée")
    _BUBBLE_LINE(125,13,3,"arrière de la maison")
#else
    _BUBBLE_LINE(93,5,0,"The house's back entrance")
    _BUBBLE_LINE(110,15,0,"is accessible from here")
#endif    
    END
.)

// MARK: Apple Orchard
_gDescriptionAppleOrchard
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans une pommeraie")
#else
    SET_DESCRIPTION("You are in an apple orchard")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(5,5,0,"La meilleure sorte de pommes:")
    _BUBBLE_LINE(5,17,0,"sucrées, croquantes et juteuses")
#else 
    _BUBBLE_LINE(5,5,0,"The best kind of apples:")
    _BUBBLE_LINE(5,17,0,"sweet, crunchy and juicy")
#endif
    JUMP(_ChirpingBirds)


// MARK: Entrance Hall
_gDescriptionEntranceHall
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans un hall imposant")
#else
    SET_DESCRIPTION("You are in an imposing entrance hall")
#endif    
    ; If the dog is in the staircase, we move it to the entrance hall to simplify the rest of the code
    JUMP_IF_FALSE(end_dog_check,CHECK_ITEM_LOCATION(e_ITEM_Dog,e_LOC_LARGE_STAIRCASE))
    SET_ITEM_LOCATION(e_ITEM_Dog,e_LOC_ENTRANCEHALL)
end_dog_check

    ; Is there a dog in the entrance
    JUMP_IF_FALSE(end_dog,CHECK_ITEM_LOCATION(e_ITEM_Dog,e_LOC_ENTRANCEHALL))

    ; Is the dog dead?
    JUMP_IF_FALSE(dog_alive,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
      ; Draw the dead dog
      DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(6,12),40,_SecondImageBuffer+40*24+7,_ImageBuffer+(40*44)+18)    
      ; Text describing the dead dog
      WAIT(DELAY_FIRST_BUBBLE)
      WHITE_BUBBLE(2)
      _BUBBLE_LINE(5,5,0,"Let's call that")
      .byt 5,17,0,"collateral damage",34,0
      END
      
dog_alive
    ; Draw the Growling dog
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(7,30),40,_SecondImageBuffer+(40*31)+0,_ImageBuffer+(40*25)+18)    

    ; Text describing the growling dog
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,105,0,"Serait-ce Cerbère ?")
#else
    _BUBBLE_LINE(5,105,0,"Is that Cerberus?")
#endif    
dog_growls
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(10,15),40,_SecondImageBuffer+(40*62)+0,$a000+(40*10)+16)        // Erase the area under the grwwww
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(7,7),40,_SecondImageBuffer+(40*24)+0,$a000+(40*20)+18)    
    WAIT(15)
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(10,15),40,_SecondImageBuffer+(40*62)+0,$a000+(40*10)+16)        // Erase the area under the grwwww
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(7,7),40,_SecondImageBuffer+(40*24)+0,$a000+(40*19)+19)    
    WAIT(10)
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(10,15),40,_SecondImageBuffer+(40*62)+0,$a000+(40*10)+16)        // Erase the area under the grwwww
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(7,7),40,_SecondImageBuffer+(40*24)+0,$a000+(40*18)+18)    
    WAIT(12)
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(10,15),40,_SecondImageBuffer+(40*62)+0,$a000+(40*10)+16)        // Erase the area under the grwwww
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(7,7),40,_SecondImageBuffer+(40*24)+0,$a000+(40*17)+17)    
    WAIT(8)
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(10,15),40,_SecondImageBuffer+(40*62)+0,$a000+(40*10)+16)        // Erase the area under the grwwww
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(7,7),40,_SecondImageBuffer+(40*24)+0,$a000+(40*16)+18)    
    WAIT(10)
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(10,15),40,_SecondImageBuffer+(40*62)+0,$a000+(40*10)+16)        // Erase the area under the grwwww
    WAIT(50)
    JUMP(dog_growls)
    END

end_dog
    ; Some generic message in case the dog is not there (probably not displayed right now)
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(124,5,0,"Quite an impressive")
    _BUBBLE_LINE(187,17,0,"staircase")
    END
.)


// MARK: Front Entrance
_gDescriptionFrontDoor
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une entrée impressionante")
#else
    SET_DESCRIPTION("An impressive entrance")
#endif    
    END


// MARK: Staircase
_gDescriptionStaircase
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans un large escalier")
#else
    SET_DESCRIPTION("You are on a sweeping staircase")
#endif    
    ; If the dog is in the entrance hall, we move it to the staircase to simplify the rest of the code
    JUMP_IF_FALSE(end_dog_check,CHECK_ITEM_LOCATION(e_ITEM_Dog,e_LOC_ENTRANCEHALL))
    SET_ITEM_LOCATION(e_ITEM_Dog,e_LOC_LARGE_STAIRCASE)
end_dog_check

    ; Is there a dog in the entrance
    JUMP_IF_FALSE(end_dog,CHECK_ITEM_LOCATION(e_ITEM_Dog,e_LOC_LARGE_STAIRCASE))

    ; Is the dog dead?
    JUMP_IF_FALSE(dog_alive,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
      ; Draw the dead dog
      DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(17,34),40,_SecondImageBuffer+40*95,_ImageBuffer+(40*93)+12)    
      ; Text describing the dead dog
      WAIT(DELAY_FIRST_BUBBLE)
      WHITE_BUBBLE(2)
      _BUBBLE_LINE(5,5,0,"Let's call that")
      .byt 5,17,0,"collateral damage",34,0
      END
      
dog_alive
    ; If the dog is alive, it will jump on our face now
    SET_CUT_SCENE(1)
    FADE_BUFFER
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_MAIMED_BY_DOG)
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(21,128),40,_SecondImageBuffer+19,_ImageBuffer+(40*0)+10)    ; Draw the attacking dog     
    FADE_BUFFER
    LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
    _BUBBLE_LINE(5,108,0,"Oops...")
    WAIT(50*2)                              ; Wait a couple seconds
    GAME_OVER(e_SCORE_MAIMED_BY_DOG)        ; The game is now over
    JUMP(_gDescriptionGameOverLost)         ; Game Over

end_dog
    ; Some generic message in case the dog is not there (probably not displayed right now)
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(124,5,0,"Quite an impressive")
    _BUBBLE_LINE(187,17,0,"staircase")
    END
.)    



// MARK: Library
_gDescriptionLibrary
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Probablement une bibliothèque")
#else
    SET_DESCRIPTION("This looks like a library")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(5,99,0,"Livres, cheminée et")
    _BUBBLE_LINE(5,105,4,"un bon fauteuil")
#else
    _BUBBLE_LINE(5,86,0,"Books, fireplace, and")
    _BUBBLE_LINE(5,97,0,"a comfortable chair")
#endif    
    END


// MARK: Study Room
_gDescriptionStudyRoom
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Le centre des affaires")
#else
    SET_DESCRIPTION("Where serious Business happens")
#endif    
    ; Is the gun cabinet open?
    JUMP_IF_TRUE(cabinet_closed,CHECK_ITEM_FLAG(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED))
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(6,50),40,_SecondImageBuffer+40*0+8,_ImageBuffer+40*13+24)       ; Cabinet open
cabinet_closed

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(150,5,0,"Tradition et")
    _BUBBLE_LINE(177,17,0,"technologie")
#else
    _BUBBLE_LINE(150,5,0,"Tradition meets")
    _BUBBLE_LINE(177,17,0,"technology")
#endif    
    END
.)


// MARK: Narrow Passage
_gDescriptionNarrowPassage
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans un passage étroit")
#else
    SET_DESCRIPTION("You are in a narrow passage")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(3)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,48,0,"Soit ils aiment le noir")
    _BUBBLE_LINE(12,68,0,"soit ils ont oublié")
    _BUBBLE_LINE(27,88,0,"de payer leurs")
#else
    _BUBBLE_LINE(5,48,0,"Either they love the dark")
    _BUBBLE_LINE(12,68,0,"or they forgot to")
    _BUBBLE_LINE(37,88,0,"pay their")
#endif
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(55,108,0,"factures")
#else
    _BUBBLE_LINE(75,108,0,"bills")
#endif    
    END


// MARK: Entrance Lounge
_gDescriptionEntranceLounge
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans un salon")
#else
    SET_DESCRIPTION("You are in the lounge")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR       
    _BUBBLE_LINE(5,5,0,"On dirait que quelqu'un")
    _BUBBLE_LINE(12,13,4,"s'est bien amusé")
#else    
    _BUBBLE_LINE(5,5,0,"Looks like someone")
    _BUBBLE_LINE(5,15,0,"had fun")
#endif    
    END


// MARK: Dining Room
_gDescriptionDiningRoom
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Apparement une salle a manger")
#else
    SET_DESCRIPTION("A dining room, or so it appears")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,100,0,"Deux assiettes...")
    _BUBBLE_LINE(5,107,4,"...bon à savoir")
#else
    _BUBBLE_LINE(5,95,0,"Two plates...")
    _BUBBLE_LINE(5,107,0,"...good to know")
#endif    
    END


// MARK: Game Room
_gDescriptionGamesRoom
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("La salle de jeux")
#else
    SET_DESCRIPTION("This looks like a games room")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(155,5,0,"Système vidéo")
    _BUBBLE_LINE(151,16,0,"haut de gamme")
#else
    _BUBBLE_LINE(142,5,0,"Top of the range")
    _BUBBLE_LINE(164,16,0,"video system")
#endif
    WAIT(50)

    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(151,40,0,"Impressionnant")
#else
    _BUBBLE_LINE(175,40,0,"Impressive")
#endif    
    END


// MARK: Sun Lounge
_gDescriptionSunLounge
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Le solarium")
#else
    SET_DESCRIPTION("You find yourself in a sun-lounge")
#endif    

    ; Draw the girl if she's on the tiled patio (because we can see it from the sun lounge)
    JUMP_IF_FALSE(girl_is_outside,CHECK_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_TILEDPATIO))
        BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,8,40)                     ; Draw the girl on the small wall outside on the view
                _IMAGE(31,78)
                _BUFFER(8,8)
girl_is_outside        

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(80,5,0,"Pas de répit pour les braves")
#else
    _BUBBLE_LINE(112,5,0,"No rest for the weary")
#endif    
    END


// MARK: Kitchen
_gDescriptionKitchen
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Visiblement la cuisine")
#else
    SET_DESCRIPTION("This is obviously the kitchen")
#endif    
    ; Is the fridge open?
    JUMP_IF_TRUE(fridge_closed,CHECK_ITEM_FLAG(e_ITEM_Fridge,ITEM_FLAG_CLOSED))
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(4,52),40,_SecondImageBuffer+40*64+0,_ImageBuffer+40*22+26)       ; Fridge open
fridge_closed

    ; Is the medicine cabinet open?
    JUMP_IF_TRUE(medicine_cabinet_closed,CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED))
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(4,23),40,_SecondImageBuffer+40*64+4,_ImageBuffer+40*30+33)       ; Medicine cabinet open
medicine_cabinet_closed

    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(5,5,0,"Une cuisine")
    _BUBBLE_LINE(5,16,0,"bien équipée")
#else
    _BUBBLE_LINE(5,5,0,"A well equipped")
    _BUBBLE_LINE(5,14,4,"kitchen")
#endif    
    END
.)


// MARK: Basement Stairs
_gDescriptionBasementStairs
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans un escalier étroit")
#else
    SET_DESCRIPTION("You are on some gloomy, narrow steps")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR       
    _BUBBLE_LINE(5,5,0,"Attention à la marche")
#else
    _BUBBLE_LINE(5,5,0,"Watch your step")
#endif    

    .(
    ; Then we check if the player stroke the matches
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BoxOfMatches,e_LOC_NONE),matches)    ; Are the matches on fire?
        GOSUB(_gMiniKaboom)
        FADE_BUFFER
    ENDIF(matches)
    .)

    END


// MARK: Cellar Safe
_gDescriptionCellar
.(  
    ; First, initialize the scene to look proper  
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED),else)   ; Is the safe door open?
        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,6,99)                        ; Draw the open damaged door
                _IMAGE(34,0)
                _BUFFER(30,16)
    ELSE(else,safe_open)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_ATTACHED),bomb)    ; Is the bomb installed?
            BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the bomb attached to the closed door
                    _IMAGE(8,67)
                    _BUFFER(30,43)
        ENDIF(bomb)
    ENDIF(safe_open)

#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une cave frigide et humide")
#else
    SET_DESCRIPTION("This is a cold, damp cellar")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR       
    _BUBBLE_LINE(45,15,0,"Est-ce un coffre-fort")
    _BUBBLE_LINE(70,25,0,"Franz Jager ?")
#else
    _BUBBLE_LINE(75,15,0,"Is that a Franz")
    _BUBBLE_LINE(80,25,0,"Jager safe?")
#endif    

    ; Then we check if the player stroke the matches
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_BoxOfMatches,ITEM_FLAG_TRANSFORMED),matches)    ; Are the matches on fire?
        ; We set a few values right now, because the player can leave the script before it is finished.
        ; If these values are not set before the first WAIT instruction, the game will be broken.
        SET_ITEM_LOCATION(e_ITEM_Bomb,e_LOC_NONE)                    ; The bomb is gone
        SET_ITEM_LOCATION(e_ITEM_BoxOfMatches,e_LOC_NONE)            ; Don't need the matches anymore
        UNSET_ITEM_FLAGS(e_ITEM_BoxOfMatches,ITEM_FLAG_TRANSFORMED)  ; Un-strike the matches (just so the test above does not trigger a second time)

#ifdef LANGUAGE_FR                                                   ; Rename the safe to "an open safe"
        SET_ITEM_DESCRIPTION(e_ITEM_HeavySafe,"un _coffre ouvert")
#else    
        SET_ITEM_DESCRIPTION(e_ITEM_HeavySafe,"a open _safe")
#endif    

        //DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_WITH_BOMB,"Ready to blow!")
        CLEAR_TEXT_AREA(1)
        QUICK_MESSAGE("I should go somewhere safe")
        PLAY_SOUND(_FuseBurningStart)
        WAIT(50*2)

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the fuse animation sequence frame
                _IMAGE(8+3*1,67)
                _SCREEN(30,43)

        WAIT(50)

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the fuse animation sequence frame
                _IMAGE(8+3*2,67)
                _SCREEN(30,43)

        PLAY_SOUND(_FuseBurning)
        WAIT(50)

        CLEAR_TEXT_AREA(5)
        QUICK_MESSAGE("Hello?")

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the fuse animation sequence frame
                _IMAGE(8+3*3,67)
                _SCREEN(30,43)

        PLAY_SOUND(_FuseBurning)
        WAIT(50)

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the fuse animation sequence frame
                _IMAGE(8+3*4,67)
                _SCREEN(30,43)

        PLAY_SOUND(_FuseBurning)
        WAIT(50)

        CLEAR_TEXT_AREA(4)
        QUICK_MESSAGE("Still there?")

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the fuse animation sequence frame
                _IMAGE(8+3*5,67)
                _SCREEN(30,43)

        PLAY_SOUND(_FuseBurning)
        WAIT(50)

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the fuse animation sequence frame
                _IMAGE(8+3*6,67)
                _SCREEN(30,43)

        WAIT(50)
        SET_CUT_SCENE(1)
        PLAY_SOUND(_ExplodeData)
        DISPLAY_IMAGE(LOADER_PICTURE_EXPLOSION,"KA BOOM!")
        CLEAR_TEXT_AREA(1)
        INFO_MESSAGE("Well... I warned you, didn't I?")

        LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_BLOWN_INTO_BITS)             ; Achievement!
        GAME_OVER(e_SCORE_BLOWN_INTO_BITS)                          ; The game is now over

        WAIT(50*2)

        JUMP(_gDescriptionGameOverLost)                             ; Draw the 'The End' logo    
    ENDIF(matches)

    END
.)


// MARK: Darker Cellar
// TODO: Hide the locked panel
// TODO: Activate the window "it's too high"
_gDescriptionDarkerCellar
.(
    SET_ITEM_LOCATION(e_ITEM_BasementWindow, e_LOC_DARKCELLARROOM)         ; The window is visible
    .(
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER),else)
        SET_SCENE_IMAGE(LOADER_PICTURE_CELLAR_BRIGHT)
#ifdef LANGUAGE_FR       
        SET_DESCRIPTION("La fenêtre éclaire la pièce")
#else
        SET_DESCRIPTION("The room gets light from the window")
#endif    
        SET_ITEM_LOCATION(e_ITEM_AlarmPanel,e_LOC_DARKCELLARROOM)    ; Make the alarm panel now visible

        ; Is the alarm panel open?
        JUMP_IF_TRUE(alarm_panel_closed,CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED))
            BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,5,16)                     ; Draw the open panel
                    _IMAGE(8,51)
                    _BUFFER(25,24)
        //DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(4,23),40,_SecondImageBuffer+40*64+4,_ImageBuffer+40*30+33)       ; Medicine cabinet open
alarm_panel_closed

        // TODO: SET_LOCATION_DIRECTION(e_LOC_DARKCELLARROOM,e_DIRECTION_WEST,e_LOC_STORAGE_ROOM)      ; Enable the west direction
    ELSE(else,open)
#ifdef LANGUAGE_FR       
        SET_DESCRIPTION("Cette pièce est encore plus sombre")
        SET_ITEM_DESCRIPTION(e_ITEM_BasementWindow,"une _fenêtre noircie")
#else
        SET_DESCRIPTION("This room is even darker than the last")
        SET_ITEM_DESCRIPTION(e_ITEM_BasementWindow,"a darkened _window")
#endif    
    ENDIF(open)
    .)

    .(
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_DARKCELLARROOM),ladder)  
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,7,87)                     ; Draw the ladder
                _IMAGE(0,40)
                _BUFFER(29,7)
        SET_LOCATION_DIRECTION(e_LOC_DARKCELLARROOM,e_DIRECTION_UP,e_LOC_CELLAR_WINDOW)     ; Enable the UP direction
    ELSE(ladder,no_ladder)
        SET_LOCATION_DIRECTION(e_LOC_DARKCELLARROOM,e_DIRECTION_UP,e_LOC_NONE)              ; Disable the UP direction
    ENDIF(no_ladder)
    .)

    ; Make sure the safe looks correct before the explosion
    GOSUB(_gDrawSafeInDarkRom)

    .(
    WAIT(DELAY_FIRST_BUBBLE)
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER),tape_off)
        BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR   
        _BUBBLE_LINE(5,99,0,"On y voit bien")
        _BUBBLE_LINE(5,106,4,"mieux maintenant !")
#else
        _BUBBLE_LINE(5,99,0,"Can definitely see")
        _BUBBLE_LINE(5,108,3,"better now!")
#endif
    ELSE(tape_off,tape_on)
        BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR   
        _BUBBLE_LINE(5,99,0,"La fenêtre semble")
        _BUBBLE_LINE(5,106,4,"occultée")
#else
        _BUBBLE_LINE(5,99,0,"The window seems")
        _BUBBLE_LINE(5,107,3,"to be covered")
#endif
    ENDIF(tape_on)
    .)    


    .(
    ; Then we check if the player stroke the matches
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BoxOfMatches,e_LOC_NONE),matches)    ; Are the matches on fire?
        GOSUB(_gMiniKaboom)        
        GOSUB(_gDrawSafeInDarkRom)            ; Make sure the safe looks correct after the explosion
        FADE_BUFFER
    ENDIF(matches)
    .)

    END
.)

_gMiniKaboom
.(
    SET_CUT_SCENE(1)
    WAIT(50)
    PLAY_SOUND(_ExplodeData)
    SET_ITEM_LOCATION(e_ITEM_BoxOfMatches,e_LOC_GONE_FOREVER)           ; Don't need the matches anymore
    UNSET_ITEM_FLAGS(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED)                 ; The safe is now open
    BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,7,31)                            ; Draw the Boom!
            _IMAGE(20,0)
            _SCREEN(17,24)
    CLEAR_TEXT_AREA(1)
    INFO_MESSAGE("Good thing I was not in there!")
    WAIT(50*2)
    CLEAR_TEXT_AREA(4)
    SET_CUT_SCENE(0)
    RETURN
.)

; Make sure the safe looks correct
_gDrawSafeInDarkRom
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED),else)   ; Is the safe door open?
        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,49)                        ; Draw the open damaged door
                _IMAGE(14,0)
                _BUFFER(20,17)
    ELSE(else,safe_open)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_ATTACHED),bomb)    ; Is the bomb installed?
            BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,49)                     ; Draw the bomb attached to the closed door
                    _IMAGE(17,0)
                    _BUFFER(20,17)
        ENDIF(bomb)
    ENDIF(safe_open)
    RETURN
.)



// MARK: Cellar Window
_gDescriptionCellarWindow
.(
    SET_ITEM_LOCATION(e_ITEM_BasementWindow, e_LOC_CELLAR_WINDOW)         ; The window is visible

    ; Inspecting the window in the cellar
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER),bright)
        //DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_CELLAR_WINDOW_CLEARED,"A basement window")
        SET_SCENE_IMAGE(LOADER_PICTURE_CELLAR_WINDOW_CLEARED)
#ifdef LANGUAGE_FR       
        SET_DESCRIPTION("Il n'y a plus d'adhésif sur la fenêtre")
#else
        SET_DESCRIPTION("The window is now free of tape")
#endif
    ELSE(bright,dark)
        DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_CELLAR_WINDOW_DARK,"A dark basement window")
#ifdef LANGUAGE_FR       
        SET_DESCRIPTION("La fenêtre est occultée")
#else
        SET_DESCRIPTION("The window is covered in black tape")
#endif    
    ENDIF(dark)

    ; Is the ladder in place?
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_DARKCELLARROOM),ladder)
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,12,28)                     ; Draw the ladder
                _IMAGE(7,100)
                _BUFFER(14,101)
    ENDIF(ladder)
    FADE_BUFFER      ; Make sure everything appears on the screen
    END
.)


// MARK: Main Landing
_gDescriptionMainLanding
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur le palier principal")
#else
    SET_DESCRIPTION("You are on the main landing")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(53,70,0,"Belle vue de là-haut")
#else
    _BUBBLE_LINE(47,70,0,"Nice view from up there")
#endif    
    END


// MARK: East Gallery
_gDescriptionEastGallery
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("La gallerie est")
#else
    SET_DESCRIPTION("You have found the east gallery")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(5,5,0,"Couloir ennuyeux:")
    _BUBBLE_LINE(20,13,4,"Vérifié")
#else
    _BUBBLE_LINE(5,5,0,"Boring corridor:")
    _BUBBLE_LINE(20,17,0,"Check")
#endif    
    END


// MARK: Child Bedroom
_gDescriptionChildBedroom
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("La chambre d'un enfant")
#else
    SET_DESCRIPTION("This is a child's bedroom")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,86,0,"Laisse-moi deviner:")
    _BUBBLE_LINE(5,94,4,"Chambre d'adolescent ?")
#else
    _BUBBLE_LINE(5,96,0,"Let me guess:")
    _BUBBLE_LINE(5,107,0,"Teenager room?")
#endif    
    END


// MARK: Guest Bedroom
_gDescriptionGuestBedroom
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une chambre d'amis")
#else
    SET_DESCRIPTION("This seems to be a guest bedroom")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,6,0,"Simple et rafraichissant")
    _BUBBLE_LINE(5,17,0,"pour changer")
#else
    _BUBBLE_LINE(5,6,0,"Simple and fresh")
    _BUBBLE_LINE(5,17,0,"for a change")
#endif    
    END


// MARK: Shower Room
_gDescriptionShowerRoom
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une salle de bain carellée")
#else
    SET_DESCRIPTION("You are in a tiled shower-room")
#endif    

    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(145,5,0,"J'en aurai besoin")
    _BUBBLE_LINE(136,16,0,"quand j'aurai fini")
#else
    _BUBBLE_LINE(149,5,0,"I will need one")
    _BUBBLE_LINE(152,16,0,"when I'm done")
#endif    
    END
.)


// MARK: West Gallery
_gDescriptionWestGallery
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("La gallerie ouest")
#else
    SET_DESCRIPTION("This is the west gallery")
#endif    
    ; If the suit is equiped, we remove it
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED),suit)    ; Is the protection suit equiped?
        SET_CUT_SCENE(1)
        UNSET_ITEM_FLAGS(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED)
        PLAY_SOUND(_Zipper)
#ifdef LANGUAGE_FR    
        INFO_MESSAGE("Il faut que j'enlève cette combinaison")
#else
        INFO_MESSAGE("I need to remove that suit")
#endif        
        WAIT(50*2)
        CLEAR_TEXT_AREA(4)
        SET_CUT_SCENE(0)
    ENDIF(suit)

    ; Is the curtain closed?
    JUMP_IF_FALSE(curtain_open,CHECK_ITEM_FLAG(e_ITEM_Curtain,ITEM_FLAG_CLOSED))
curtain_closed
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(8,62),40,_SecondImageBuffer+0,_ImageBuffer+40*5+20)       ; Closed curtain
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(70,81,0,"Au théatre ce soir...")
#else
    _BUBBLE_LINE(55,81,0,"At the theater tonight...")
#endif    
    END

curtain_open    
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(85,81,0,"Est-ce de l'acier")
    _BUBBLE_LINE(60,92,0,"derrière le rideau ?")
#else
    _BUBBLE_LINE(85,81,0,"Is that steel")
    _BUBBLE_LINE(60,92,0,"behind the curtain?")
#endif    
    END
.)


// MARK: Box Room
_gDescriptionBoxRoom
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une petite loge")
#else
    SET_DESCRIPTION("This is a small box-room")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(5,5,0,"Une petite pièce")
    _BUBBLE_LINE(5,12,4,"utilitaire")
#else
    _BUBBLE_LINE(5,5,0,"A practical")
    _BUBBLE_LINE(5,16,0,"little room")
#endif    
    END


// MARK: Classy Bathroom
_gDescriptionClassyBathRoom
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une salle de bain luxieuse")
#else
    SET_DESCRIPTION("You are in an ornate bathroom")
#endif    

    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(132,5,0,"Semble comfortable")
#else
    _BUBBLE_LINE(132,5,0,"Looks comfortable")
#endif    
    END
.)


// MARK: Tiny Toilet
_gDescriptionTinyToilet
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Des petites toilette")
#else
    SET_DESCRIPTION("This is a tiny toilet")
#endif    

    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    WAIT(DELAY_FIRST_BUBBLE)
#ifdef LANGUAGE_FR    
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(160,5,0,"Une propreté")
    _BUBBLE_LINE(173,13,4,"étincelante")
#else
    WHITE_BUBBLE(1)
    _BUBBLE_LINE(137,5,0,"Sparklingly clean")
#endif    
    END
.)

// MARK: Master Bedroom
_gDescriptionMasterBedRoom
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("La chambre principale")
#else
    SET_DESCRIPTION("This must be the master bedroom")
#endif    
    ; Is there a thug in the master bedroom
    JUMP_IF_FALSE(end_thug,CHECK_ITEM_LOCATION(e_ITEM_Thug,e_LOC_MASTERBEDROOM))

    ; Draw the shoes at the bottom of the bed
    DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(7,15),40,_SecondImageBuffer+40*73+14,_ImageBuffer+40*112+3)       ; Shoes

    ; Is the thug alive?
    JUMP_IF_FALSE(thug_alive,CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED))
      ; Draw the dead thug 
      DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(23,24),40,_SecondImageBuffer+0,_ImageBuffer+40*66+12)          ; Dead thug
      DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(2,27),40,_SecondImageBuffer+40*24+17,_ImageBuffer+40*90+29)    ; Arm
      DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(6,17),40,_SecondImageBuffer+40*0+24,_ImageBuffer+40*109+33)    ; Pillow on the floor
      ; Text describing the dead thug
      WAIT(DELAY_FIRST_BUBBLE)
      WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
      _BUBBLE_LINE(10,5,0,"Appelons cela un")
      .byt 5,18,0,34,"dommage collatéral",34,0
#else
      _BUBBLE_LINE(5,5,0,"Let's call that")
      .byt 5,17,0,34,"collateral damage",34,0
#endif      
      END

thug_alive
    ; Draw the thug Sleeping
    DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(18,37),40,_SecondImageBuffer+40*91,_ImageBuffer+40*52+17)   ; Thug sleeping
    DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(8,23),40,_SecondImageBuffer+32,_ImageBuffer+40*33+30)       ; Zzzz over the head
    ; Draw the message
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"Cela rendra les choses")
    _BUBBLE_LINE(5,16,0,"nettement plus faciles...")
#else
    _BUBBLE_LINE(5,5,0,"This will make things")
    _BUBBLE_LINE(5,16,0,"notably easier...")
#endif    
    ; Should probably have a "game over" command
    END
    
end_thug    
    ; Draw the message
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(5,5,0,"This was make things")
    _BUBBLE_LINE(5,16,0,"notably easier...")
    ; Should probably have a "game over" command
    FADE_BUFFER
    END




// MARK: Panic Room Door
_gDescriptionPanicRoomDoor
.(
    ; Move the panic room window here if the girl is freed
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_YoungGirl,ITEM_FLAG_DISABLED),girl_unrestrained)
        SET_ITEM_LOCATION(e_ITEM_PanicRoomWindow,e_LOC_PANIC_ROOM_DOOR)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED),closed)
#ifdef LANGUAGE_FR       
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"la _fenêtre de la chambre forte")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"the panic room _window")
#endif        
        ELSE(closed,openened)
#ifdef LANGUAGE_FR       
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"la _fenêtre ouverte de la chambre forte")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"the open panic room _window")
#endif        
        ENDIF(openened)
    ENDIF(girl_unrestrained)

#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("L'entrée d'une chambre forte")
#else
    SET_DESCRIPTION("A panic room entrance")
#endif    

    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_HoleInDoor,e_LOC_CURRENT),acid)  ; Is there a hole in the door?
        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,5,14)                        ; Draw the acid hole
                _IMAGE(18,50)
                _BUFFER(15,72)
        WAIT(DELAY_FIRST_BUBBLE)
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
        _BUBBLE_LINE(135,16,0,"Elle est moins")
        _BUBBLE_LINE(131,53,0,"sécurisée maintenant")
#else
        _BUBBLE_LINE(153,70,0,"Definitely less")
        _BUBBLE_LINE(148,85,0,"secure now")
#endif    
        END
    ENDIF(acid)

    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED),suit)    ; Is the protection suit equiped?
        SET_SCENE_IMAGE(LOADER_PICTURE_STEEL_DOOR_WITH_GOOGLES)                ; Then we show the view with the googles on
        WAIT(DELAY_FIRST_BUBBLE)
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
        _BUBBLE_LINE(135,16,0,"C'est un peu")
        _BUBBLE_LINE(131,53,0,"oppressant")
#else
        _BUBBLE_LINE(153,70,0,"It's kind of")
        _BUBBLE_LINE(148,85,0,"claustrophobic")
#endif    
        END
    ENDIF(suit)


    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_ATTACHED),attached)       ; Is the clay attached?
        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,5,13)                            ; Draw the clay attached to the door
                _IMAGE(13,51)
                _BUFFER(15,73)
        WAIT(DELAY_FIRST_BUBBLE)
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
        _BUBBLE_LINE(135,16,0,"On dirait")
        _BUBBLE_LINE(131,53,0,"un sourire :)")
#else
        _BUBBLE_LINE(153,70,0,"Almost looks")
        _BUBBLE_LINE(148,85,0,"like a smile :)")
#endif    
        END
    ENDIF(attached)

    ; Default message if nothing has been changed (no clay, no hole, no protection suit...)
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(3)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(5,5,0,"Damn...")
    _BUBBLE_LINE(135,16,0,"Ils ont mis")
    _BUBBLE_LINE(131,53,0,"les gros moyen!")
#else
    _BUBBLE_LINE(5,5,0,"Damn...")
    _BUBBLE_LINE(168,70,0,"That's some")
    _BUBBLE_LINE(138,85,0,"serious hardware!")
#endif    
    END
.)

; This function assumes the GAME_OVER(xxx) has been called already
_gDescriptionGameOverLost
    DECREASE_SCORE(MALUS_POINTS_GAME_OVER)    
_gDescriptionGameOverWon
    DRAW_BITMAP(LOADER_SPRITE_THE_END,BLOCK_SIZE(20,95),20,_SecondImageBuffer,_ImageBuffer+(40*16)+10)     ; Draw the 'The End' logo
    WAIT(50*2)                                                                                             ; Wait a couple seconds
    FADE_BUFFER
    STOP_MUSIC()
    END
_EndSceneScripts


// Scene actions
_StartSceneActions


/* MARK: Main Action Mapping

.88b  d88.  .d8b.  d888888b d8b   db       .d8b.   .o88b. d888888b d888888b  .d88b.  d8b   db      .88b  d88.  .d8b.  d8888b. d8888b. d888888b d8b   db  d888b  
88'YbdP`88 d8' `8b   `88'   888o  88      d8' `8b d8P  Y8 `~~88~~'   `88'   .8P  Y8. 888o  88      88'YbdP`88 d8' `8b 88  `8D 88  `8D   `88'   888o  88 88' Y8b 
88  88  88 88ooo88    88    88V8o 88      88ooo88 8P         88       88    88    88 88V8o 88      88  88  88 88ooo88 88oodD' 88oodD'    88    88V8o 88 88      
88  88  88 88~~~88    88    88 V8o88      88~~~88 8b         88       88    88    88 88 V8o88      88  88  88 88~~~88 88~~~   88~~~      88    88 V8o88 88  ooo 
88  88  88 88   88   .88.   88  V888      88   88 Y8b  d8    88      .88.   `8b  d8' 88  V888      88  88  88 88   88 88      88        .88.   88  V888 88. ~8~ 
YP  YP  YP YP   YP Y888888P VP   V8P      YP   YP  `Y88P'    YP    Y888888P  `Y88P'  VP   V8P      YP  YP  YP YP   YP 88      88      Y888888P VP   V8P  Y888P   */

;                  Word opcode       Function or Stream          Flags
_gActionMappingsArray
    ; Implemented as actual C/Assembler functions
    WORD_MAPPING(e_WORD_NORTH     ,_PlayerMove                ,FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_SOUTH     ,_PlayerMove                ,FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_EAST      ,_PlayerMove                ,FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_WEST      ,_PlayerMove                ,FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_UP        ,_PlayerMove                ,FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_DOWN      ,_PlayerMove                ,FLAG_MAPPING_DEFAULT)

    WORD_MAPPING(e_WORD_TAKE      ,_TakeItem                  ,FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_DROP      ,_DropItem                  ,FLAG_MAPPING_DEFAULT)

    WORD_MAPPING(e_WORD_PAUSE     ,_PauseGameScript           ,FLAG_MAPPING_STREAM|FLAG_MAPPING_STREAM_CALLBACK)

#ifdef ENABLE_CHEATS       
    WORD_MAPPING(e_WORD_INVOKE    ,_Invoke                    ,FLAG_MAPPING_DEFAULT)
#endif
    ; Implemented as script streams
    WORD_MAPPING(e_WORD_COMBINE   ,_gCombineItemMappingsArray ,FLAG_MAPPING_STREAM|FLAG_MAPPING_TWO_ITEMS)
    WORD_MAPPING(e_WORD_READ      ,_gReadItemMappingsArray    ,FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_USE       ,_gUseItemMappingsArray     ,FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_OPEN      ,_gOpenItemMappingsArray    ,FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_CLOSE     ,_gCloseItemMappingsArray   ,FLAG_MAPPING_STREAM)

    WORD_MAPPING(e_WORD_LOOK      ,_gInspectItemMappingsArray ,FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_FRISK     ,_gSearchtemMappingsArray   ,FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_SEARCH    ,_gSearchtemMappingsArray   ,FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_THROW     ,_gThrowItemMappingsArray   ,FLAG_MAPPING_STREAM)

#ifdef ENABLE_PRINTER
    WORD_MAPPING(e_WORD_PRINT     ,_PrinterEnableDisable      ,FLAG_MAPPING_DEFAULT)
#endif    

    WORD_MAPPING(e_WORD_KEYBFR    ,_SetKeyboardAzerty         ,FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_KEYBUK    ,_SetKeyboardQwerty         ,FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_KEYBDE    ,_SetKeyboardQwertz         ,FLAG_MAPPING_DEFAULT)

    WORD_MAPPING(e_WORD_HELP      ,_ShowHelp                  ,FLAG_MAPPING_DEFAULT)

    WORD_MAPPING(e_WORD_COUNT_    ,0, 0)
    // End Marker


/* MARK: Combine 👨‍🏭

 .o88b.  .d88b.  .88b  d88. d8888b. d888888b d8b   db d88888b 
d8P  Y8 .8P  Y8. 88'YbdP`88 88  `8D   `88'   888o  88 88'     
8P      88    88 88  88  88 88oooY'    88    88V8o 88 88ooooo 
8b      88    88 88  88  88 88~~~b.    88    88 V8o88 88~~~~~ 
Y8b  d8 `8b  d8' 88  88  88 88   8D   .88.   88  V888 88.     
 `Y88P'  `Y88P'  YP  YP  YP Y8888P' Y888888P VP   V8P Y88888P  */

_gCombineItemMappingsArray
    COMBINE_MAPPING(e_ITEM_SedativePills,e_ITEM_Meat        ,_CombineMeatWithPills)
    COMBINE_MAPPING(e_ITEM_Petrol,e_ITEM_ToiletRoll         ,_CombinePetrolWithTP)
    COMBINE_MAPPING(e_ITEM_Saltpetre,e_ITEM_Sulphur         ,_CombineSulfurWithSalpetre)
    COMBINE_MAPPING(e_ITEM_GunPowder,e_ITEM_Fuse            ,_CombineGunPowderWithFuse)
    COMBINE_MAPPING(e_ITEM_Bomb,e_ITEM_Adhesive             ,_CombineBombWithAdhesive)
    COMBINE_MAPPING(e_ITEM_Bomb,e_ITEM_HeavySafe            ,_CombineStickyBombWithSafe)
    COMBINE_MAPPING(e_ITEM_Bomb,e_ITEM_BoxOfMatches         ,_CombineBombWithMatches)
    COMBINE_MAPPING(e_ITEM_Clay,e_ITEM_Water                ,_CombineClayWithWater)
    COMBINE_MAPPING(e_ITEM_SilverKnife,e_ITEM_HoleInDoor    ,_CommonGaveTheKnifeToTheGirl)
    COMBINE_MAPPING(e_ITEM_SnookerCue,e_ITEM_Rope           ,_CombineCueWithRope)
    COMBINE_MAPPING(e_ITEM_PanicRoomWindow,e_ITEM_Rope      ,_CombineWindowWithRope)

    VALUE_MAPPING2(255,255    ,_ErrorCannotDo)


_CombineMeatWithPills
.(
    SET_ITEM_LOCATION(e_ITEM_SedativePills,e_LOC_GONE_FOREVER)      ; The sedative are gone from the game
    SET_ITEM_FLAGS(e_ITEM_Meat,ITEM_FLAG_TRANSFORMED)                    ; We now have some drugged meat in our inventory
#ifdef LANGUAGE_FR                                                       ; Rename the meat to "drugged meat"
    SET_ITEM_DESCRIPTION(e_ITEM_Meat,"_viande droggée")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Meat,"drugged _meat")
#endif    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_MEAT)   ; Achievement!
    INCREASE_SCORE(POINTS_DRUGGED_MEAT)
    END_AND_REFRESH
.)


_CombinePetrolWithTP
.(
    SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_NONE)                          ; The Petrol is back into the car (but useless)
    SET_ITEM_LOCATION(e_ITEM_ToiletRoll,e_LOC_TINY_WC)                   ; The TP is back into the toilets (but useless)
    SET_ITEM_LOCATION(e_ITEM_Fuse,e_LOC_CURRENT)                         ; We now have a fuse for our bomb
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_BUILT_A_FUSE)                         ; Achievement!    
    INCREASE_SCORE(POINTS_BUILT_FUSE)
    END_AND_REFRESH
.)


_CombineSulfurWithSalpetre
.(
    SET_ITEM_LOCATION(e_ITEM_Saltpetre,e_LOC_NONE)                       ; The saltpetre is gone
    SET_ITEM_LOCATION(e_ITEM_Sulphur,e_LOC_NONE)                         ; The sulphur is gone
    SET_ITEM_LOCATION(e_ITEM_PowderMix,e_LOC_CURRENT)                    ; We now have a rough powder mix for our bomb
    INCREASE_SCORE(POINTS_COMBINED_SULPHUR_SALTPETRE)

    DISPLAY_IMAGE(LOADER_PICTURE_ROUGH_POWDER_MIX,"Sulphur & Saltpetre")
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    INFO_MESSAGE("It's mixed...")
    WAIT(50*2)
    INFO_MESSAGE("...but there are some large clumps")
    WAIT(50*2)
    STOP_MUSIC()
    END_AND_REFRESH
.)


_CombineGunPowderWithFuse
.(
    SET_ITEM_LOCATION(e_ITEM_GunPowder,e_LOC_NONE)                       ; The gunpowder is gone
    SET_ITEM_LOCATION(e_ITEM_Fuse,e_LOC_NONE)                            ; The fuse is gone as well
    SET_ITEM_LOCATION(e_ITEM_TobaccoTin,e_LOC_NONE)                      ; And so is the tobacco tin
    SET_ITEM_LOCATION(e_ITEM_Bomb,e_LOC_CURRENT)                         ; We now have a bomb
    INCREASE_SCORE(POINTS_COMBINED_GUNPOWDER_FUSE)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_BUILT_A_BOMB)                         ; Achievement!    

    DISPLAY_IMAGE(LOADER_PICTURE_READY_TO_BLOW,"Ready to blow!")
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    INFO_MESSAGE("The explosive is ready...")
    WAIT(50*2)
    INFO_MESSAGE("...but it needs to be attached")
    WAIT(50*2)
    STOP_MUSIC()
    END_AND_REFRESH
.)


_CombineBombWithAdhesive
.(
    SET_ITEM_LOCATION(e_ITEM_Adhesive,e_LOC_NONE)                        ; The adhesive is gone
    SET_ITEM_FLAGS(e_ITEM_Bomb,ITEM_FLAG_TRANSFORMED)                    ; We now have a sticky bomb
    INCREASE_SCORE(POINTS_COMBINED_BOMB_ADHESIVE)
#ifdef LANGUAGE_FR                                                       ; Rename the bomb to "sticky bomb"
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"_bombe collante")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"a sticky _bomb")
#endif    
    DISPLAY_IMAGE(LOADER_PICTURE_STICKY_BOMB,"Ready to install!")
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    INFO_MESSAGE("Should be ready to use now...")
    WAIT(50*2)
    INFO_MESSAGE("...need to install it!")
    WAIT(50*2)
    STOP_MUSIC()
    END_AND_REFRESH
.)


_CombineStickyBombWithSafe
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_TRANSFORMED),sticky)      ; Is the bomb sticky?
        ERROR_MESSAGE("It needs to stick to the door")
        END_AND_REFRESH
    ENDIF(sticky)

#ifdef LANGUAGE_FR                                                           ; Rename the sticky bomb to "bomb on the doort"
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"_bombe sur la porte")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"a _bomb on the door")
#endif    
    SET_ITEM_LOCATION(e_ITEM_Bomb,e_LOC_CURRENT)                             ; The bomb is now in the room
    SET_ITEM_FLAGS(e_ITEM_Bomb,ITEM_FLAG_ATTACHED)                           ; The bomb is now attached to the safe
    INCREASE_SCORE(POINTS_ATTACHED_BOMB_TO_SAFE)
    DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_WITH_BOMB,"Ready to blow!")
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    INFO_MESSAGE("Everything is in place...")
    WAIT(50*2)
    INFO_MESSAGE("...need to ignite it safely though!")
    WAIT(50*2)
    STOP_MUSIC()
    END_AND_REFRESH
.)


_CombineBombWithMatches
.(
    SET_ITEM_FLAGS(e_ITEM_BoxOfMatches,ITEM_FLAG_TRANSFORMED)         ; Strike the matches!
    INCREASE_SCORE(POINTS_IGNITED_BOMB)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_SAFE)                   ; The player may not survive the operation, but the safe is definitely open at that point!
    END_AND_REFRESH
.)


_CombineClayWithWater
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_TRANSFORMED),wet)    ; Is the clay wet?
        ERROR_MESSAGE("It's already wet!")
        END_AND_REFRESH
    ENDIF(wet)

#ifdef LANGUAGE_FR                                                     ; Rename the dry clay to wet clay
    SET_ITEM_DESCRIPTION(e_ITEM_Clay,"de l'argile humide")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Clay,"some wet _clay")
#endif    
    SET_ITEM_FLAGS(e_ITEM_Clay,ITEM_FLAG_TRANSFORMED)                  ; Clay is now wet
    INCREASE_SCORE(POINTS_MADE_CLAY_WET)
    END_AND_REFRESH
.)



_CombineCueWithRope
.(
    DISPLAY_IMAGE(LOADER_PICTURE_CUE_WITH_ROPE,"A flimsy contraption")
    INCREASE_SCORE(POINTS_COMBINED_CUE_ROPE)
#ifdef LANGUAGE_FR    
    INFO_MESSAGE("La queue ne va pas résister...")
#else
    INFO_MESSAGE("The cue is not strong enough...")
#endif    
    WAIT(50*2)
    END_AND_REFRESH
.)


; This operation is only doable if both the window and rope are available
_CombineWindowWithRope
.( 
    ; In order to combine the window and the rope, first she needs to have been given the rope
    JUMP_IF_TRUE(rope_in_the_room,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_IMMOVABLE))
#ifdef LANGUAGE_FR       
        ERROR_MESSAGE("Peut-être lui passer la corde?")
#else
        ERROR_MESSAGE("Maybe give her the rope first?")
#endif       
        JUMP(end)
rope_in_the_room

    ; Is the window open?
    JUMP_IF_FALSE(window_open,CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED))
#ifdef LANGUAGE_FR       
        ERROR_MESSAGE("La fenêtre est toujours fermée!")
#else
        ERROR_MESSAGE("Should probably open the window first!")
#endif       
        JUMP(end)
window_open

    ; Is the window broken?
    JUMP_IF_TRUE(window_broken,CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_DISABLED))
#ifdef LANGUAGE_FR       
        ERROR_MESSAGE("Peut-être casser la vitre?")
#else
        ERROR_MESSAGE("Maybe break the window first?")
#endif       
        JUMP(end)
window_broken

    ; Is the rope attached?
    JUMP_IF_FALSE(rope_not_attached,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
#ifdef LANGUAGE_FR       
        ERROR_MESSAGE("Elle est déjà attachée!")
#else
        ERROR_MESSAGE("It's already attached!")
#endif       
        JUMP(end)
rope_not_attached

    ; Everything is good!
    ; We can attach the rope!
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Attachons la corde")
#else
    INFO_MESSAGE("Let's attach the rope")
#endif    
    SET_ITEM_FLAGS(e_ITEM_Rope,ITEM_FLAG_ATTACHED)     ; The rope is now attached to the window
    INCREASE_SCORE(POINTS_WINDOW_ROPE)
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"une _corde qui pend de la fenêtre")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"a _rope hangs from the window")
#endif    

    ; Now we can show that to the player
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_TOP_WINDOW_CLOSED,"")
    ; Then add the sprites showing the window being opened
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,31,84)                    ; Draw the top part of the open window
            _IMAGE(0,0)
            _BUFFER(0,0)
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,9,28)                     ; Draw the bottom part of the open window
            _IMAGE(0,84)
            _BUFFER(0,84)
    ; Then add the sprite showing the broken window
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,5,25)                     ; Draw the bottom part of the open window
            _IMAGE(9,84)
            _BUFFER(21,49)
    FADE_BUFFER 
    WAIT(50*2)

    ; Then add the sprite showing the attached rope
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,4,33)                     ; Draw the rope attached to the window frame
            _IMAGE(14,84)
            _BUFFER(19,59)
    FADE_BUFFER 
    WAIT(50*2)

    ; Now we show the outside view with the girl at the window
    GOSUB(_ShowGirlAtTheWindow)

end    
    WAIT(50*2)
    END_AND_REFRESH
.)



/* MARK: Read Action 📖

 ██▀███  ▓█████ ▄▄▄      ▓█████▄     ▄▄▄       ▄████▄  ▄▄▄█████▓ ██▓ ▒█████   ███▄    █ 
▓██ ▒ ██▒▓█   ▀▒████▄    ▒██▀ ██▌   ▒████▄    ▒██▀ ▀█  ▓  ██▒ ▓▒▓██▒▒██▒  ██▒ ██ ▀█   █ 
▓██ ░▄█ ▒▒███  ▒██  ▀█▄  ░██   █▌   ▒██  ▀█▄  ▒▓█    ▄ ▒ ▓██░ ▒░▒██▒▒██░  ██▒▓██  ▀█ ██▒
▒██▀▀█▄  ▒▓█  ▄░██▄▄▄▄██ ░▓█▄   ▌   ░██▄▄▄▄██ ▒▓▓▄ ▄██▒░ ▓██▓ ░ ░██░▒██   ██░▓██▒  ▐▌██▒
░██▓ ▒██▒░▒████▒▓█   ▓██▒░▒████▓     ▓█   ▓██▒▒ ▓███▀ ░  ▒██▒ ░ ░██░░ ████▓▒░▒██░   ▓██░
░ ▒▓ ░▒▓░░░ ▒░ ░▒▒   ▓▒█░ ▒▒▓  ▒     ▒▒   ▓▒█░░ ░▒ ▒  ░  ▒ ░░   ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒ 
  ░▒ ░ ▒░ ░ ░  ░ ▒   ▒▒ ░ ░ ▒  ▒      ▒   ▒▒ ░  ░  ▒       ░     ▒ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░
  ░░   ░    ░    ░   ▒    ░ ░  ░      ░   ▒   ░          ░       ▒ ░░ ░ ░ ▒     ░   ░ ░ 
   ░        ░  ░     ░  ░   ░             ░  ░░ ░                ░      ░ ░           ░ 
                          ░                   ░                                           */

_gReadItemMappingsArray
    VALUE_MAPPING(e_ITEM_Newspaper          , _ReadNewsPaper)
    VALUE_MAPPING(e_ITEM_HandWrittenNote    , _ReadHandWrittenNote)
    VALUE_MAPPING(e_ITEM_ChemistryRecipes   , _ReadChemistryRecipes)
    VALUE_MAPPING(e_ITEM_ChemistryBook      , _ReadChemistryBook)
    VALUE_MAPPING(e_ITEM_RoughMap           , _ReadRoughMap)
    VALUE_MAPPING(255                       , _ErrorCannotRead)             ; Default option


_ReadNewsPaper
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_NEWSPAPER)   ; Achievement!
    INCREASE_SCORE(POINTS_READ_NEWSPAPER)    
    DISPLAY_IMAGE(LOADER_PICTURE_NEWSPAPER,"The Daily Telegraph, September 29th")
    INFO_MESSAGE("I have to find her fast...")
    WAIT(50*2)
    INFO_MESSAGE("...I hope she is fine!")
    WAIT(50*2)
    END_AND_REFRESH


_ReadHandWrittenNote
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_NOTE)   ; Achievement!    
    INCREASE_SCORE(POINTS_READ_NOTE)    
    DISPLAY_IMAGE(LOADER_PICTURE_HANDWRITTEN_NOTE,"A hand written note")
    WAIT(50*2)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ca pourrait être utile...")
    WAIT(50*2)
    INFO_MESSAGE("...si je peux y accéder !")
#else
    INFO_MESSAGE("That could be useful...")
    WAIT(50*2)
    INFO_MESSAGE("...if I can access it!")
#endif    
    WAIT(50*2)
    END_AND_REFRESH


_ReadChemistryRecipes
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_RECIPES)   ; Achievement!    
    INCREASE_SCORE(POINTS_READ_RECIPES)    
    DISPLAY_IMAGE(LOADER_PICTURE_CHEMISTRY_RECIPES,"A few useful recipes")
    WAIT(50*2)
    INFO_MESSAGE("I can definitely use these...")
    WAIT(50*2)
    INFO_MESSAGE("...just need to find the materials.")
    WAIT(50*2)
    END_AND_REFRESH


_ReadChemistryBook
.(
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_BOOK)   ; Achievement!
    INCREASE_SCORE(POINTS_READ_BOOK)    
    DISPLAY_IMAGE(LOADER_PICTURE_SCIENCE_BOOK,"A science book")
    WAIT(50*2)
    INFO_MESSAGE("I don't understand much...")
    WAIT(50*2)
    INFO_MESSAGE("...oh, I found something!")
    WAIT(50*2)
    // If the recipes were not yet found, they now appear at the current location
    JUMP_IF_FALSE(recipe_already_found,CHECK_ITEM_LOCATION(e_ITEM_ChemistryRecipes,e_LOC_NONE))
    SET_ITEM_LOCATION(e_ITEM_ChemistryRecipes,e_LOC_INVENTORY)
recipe_already_found
    END_AND_REFRESH
.)





/* MARK: Inspect Action 🔍

.___                                     __   
|   | ____   ____________   ____   _____/  |_ 
|   |/    \ /  ___/\____ \_/ __ \_/ ___\   __\
|   |   |  \\___ \ |  |_> >  ___/\  \___|  |  
|___|___|  /____  >|   __/ \___  >\___  >__|  
         \/     \/ |__|        \/     \/      */

_gInspectItemMappingsArray
    VALUE_MAPPING(e_ITEM_UnitedKingdomMap   , _InspectMap)
    VALUE_MAPPING(e_ITEM_ChemistryBook      , _InspectChemistryBook)
    VALUE_MAPPING(e_ITEM_HandheldGame       , _InspectGame)
    VALUE_MAPPING(e_ITEM_Fridge             , _InspectFridgeDoor)
    VALUE_MAPPING(e_ITEM_Medicinecabinet    , _InspectMedicineCabinet)
    VALUE_MAPPING(e_ITEM_PlasticBag         , _InspectPlasticBag)
    VALUE_MAPPING(e_ITEM_BasementWindow     , _InspectBasementWindow)
    VALUE_MAPPING(e_ITEM_PanicRoomWindow    , _InspectPanicRoomWindow)
    VALUE_MAPPING(e_ITEM_AlarmPanel         , _InspectPanel)
    VALUE_MAPPING(e_ITEM_MixTape            , _InspectMixTape)
    VALUE_MAPPING(e_ITEM_HeavySafe          , _InspectSafe)
    VALUE_MAPPING(e_ITEM_Thug               , _InspectThug)
    VALUE_MAPPING(e_ITEM_Newspaper          , _ReadNewsPaper)
    VALUE_MAPPING(e_ITEM_SecurityDoor       , _InspectPanicRoomDoor)
    VALUE_MAPPING(e_ITEM_ProtectionSuit     , _InspectProtectionSuit)
    VALUE_MAPPING(e_ITEM_HoleInDoor         , _InspectHoleInDoor)
    VALUE_MAPPING(e_ITEM_RoughMap           , _InspectRoughMap)
    VALUE_MAPPING(e_ITEM_Car                , _InspectCar)
    VALUE_MAPPING(e_ITEM_Dog                , _InspectDog)
    VALUE_MAPPING(255                       , _MessageNothingSpecial)  ; Default option


_UseRoughMap
_ReadRoughMap
_InspectRoughMap
    GOSUB(_ShowRoughMap)
    END_AND_REFRESH
_ShowRoughMap
.(
    BLIT_BLOCK(LOADER_SPRITE_ROUGH_MAP,40,128)                     ; Draw the map of the location
            _IMAGE(0,0)
            _BUFFER(0,0)      
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    FADE_BUFFER
    INFO_MESSAGE("I'll have to go back to the market...")
    WAIT(50*2)
    INFO_MESSAGE("...when I'm done")
    WAIT(50*2)
    STOP_MUSIC()
    RETURN
.)


_InspectMap
    INCREASE_SCORE(POINTS_INSPECT_MAP)    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_EXAMINED_THE_MAP)
    DISPLAY_IMAGE(LOADER_PICTURE_UK_MAP,"A map of the United Kingdom")
    INFO_MESSAGE("It shows Ireland, Wales and England")
    WAIT(50*2)
    END_AND_REFRESH


_InspectGame
    INCREASE_SCORE(POINTS_INSPECT_GAME)    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_EXAMINED_THE_GAME)
    DISPLAY_IMAGE(LOADER_PICTURE_DONKEY_KONG_TOP,"A handheld game")
    INFO_MESSAGE("State of the art hardware!")
    WAIT(50*2)
    END_AND_REFRESH


_InspectChemistryBook
    INCREASE_SCORE(POINTS_INSPECT_BOOK)    
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un livre épais avec des marques")
#else    
    INFO_MESSAGE("A thick book with some bookmarks")
#endif    
    WAIT(50*2)
    END_AND_REFRESH


_InspectFridgeDoor
    INCREASE_SCORE(POINTS_INSPECT_FRIDGE)    
    DISPLAY_IMAGE(LOADER_PICTURE_FRIDGE_DOOR,"Let's look at that fridge")
    INFO_MESSAGE("Looks like a happy familly...")
    WAIT(50*2)
    INFO_MESSAGE("...I wonder where they are?")
    WAIT(50*2)
    END_AND_REFRESH



_InspectMedicineCabinet
.(
    INCREASE_SCORE(POINTS_INSPECT_CABINET)    
    ; Is the medicine cabinet open?
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED),else)
        DISPLAY_IMAGE(LOADER_PICTURE_MEDICINE_CABINET_OPEN,"Inside the medicine cabinet")
        INFO_MESSAGE("I can use some of that.")
    ELSE(else,open)
        DISPLAY_IMAGE(LOADER_PICTURE_MEDICINE_CABINET,"A closed medicine cabinet")
        INFO_MESSAGE("Not much to see when closed.")
    ENDIF(open)
    WAIT(50*2)
    END_AND_REFRESH
.)


_InspectPanel
.(
    INCREASE_SCORE(POINTS_INSPECT_PANEL)
    ; Is the alarm panel open?
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED),else)
        DISPLAY_IMAGE(LOADER_PICTURE_ALARM_PANEL_OPEN,"An open alarm panel")
        INFO_MESSAGE("Can be used to disable the alarm.")
    ELSE(else,open)
        DISPLAY_IMAGE(LOADER_PICTURE_ALARM_PANEL,"A closed alarm panel")
        INFO_MESSAGE("Not much to see when closed.")
    ENDIF(open)
    WAIT(50*2)
    END_AND_REFRESH
.)


_InspectBasementWindow
.(
    INCREASE_SCORE(POINTS_INSPECT_BASEMENT_WINDOW)
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM),elsecellar)
    .(
        ; Inspecting the window in the cellar
        IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_BasementWindow,ITEM_FLAG_CLOSED),else)
            DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_CELLAR_WINDOW_CLEARED,"A basement window")
            INFO_MESSAGE("C'est plutôt haut")
        ELSE(else,open)
            DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_CELLAR_WINDOW_DARK,"A dark basement window")
            INFO_MESSAGE("It's quite high")
        ENDIF(open)
        ; Is the ladder in place?
        JUMP_IF_FALSE(no_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_DARKCELLARROOM))  
            BLIT_BLOCK(LOADER_SPRITE_ITEMS,12,28)                     ; Draw the ladder
                    _IMAGE(7,100)
                    _BUFFER(14,101)
no_ladder
        FADE_BUFFER      ; Make sure everything appears on the screen
    .)
    ELSE(elsecellar,cellar)
    .(
        ; Inspecting the window in the garden (or other places)
        IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_BasementWindow,ITEM_FLAG_CLOSED),else)
            DISPLAY_IMAGE(LOADER_PICTURE_BASEMENT_WINDOW,"A basement window")
            INFO_MESSAGE("I can see the basement room")
        ELSE(else,open)
            DISPLAY_IMAGE(LOADER_PICTURE_BASEMENT_WINDOW_DARK,"A dark basement window")
            INFO_MESSAGE("Was it painted black?")
        ENDIF(open)
    .)
    ENDIF(cellar)
    WAIT(50*2)
    END_AND_REFRESH
.)



_InspectPanicRoomWindow
.(  
    INCREASE_SCORE(POINTS_INSPECT_PANIC_ROOM_WINDOW)
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room_door)      ; Are we trying to look at the window from the hole in the door?
        DISPLAY_IMAGE(LOADER_PICTURE_TOP_WINDOW_CLOSED,"The window and shutters are closed")
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Hmmm, intéressant...")
#else
        INFO_MESSAGE("Hmmm, interesting...")
#endif    
        WAIT(50*2)        
    ELSE(panic_room_door,else)                                                 ; Or are we on the tiled patio looking at the window from below?
        GOSUB(_ShowGirlAtTheWindow)
    ENDIF(else)
    END_AND_REFRESH
.)

_InspectPlasticBag
.(
    INCREASE_SCORE(POINTS_INSPECT_PLASTIC_BAG)
    //CLEAR_TEXT_AREA(4)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Juste un sac blanc normal")
#else
    INFO_MESSAGE("It's just a white generic bag")
#endif    
    END_AND_REFRESH
.)


_InspectDog
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il ne vas pas vous laisser passer !")
#else
    INFO_MESSAGE("It will not let you pass!")
#endif    
    END_AND_REFRESH
.)


_InspectMixTape
.(
    INCREASE_SCORE(POINTS_INSPECT_MIX_TAPE)
    DISPLAY_IMAGE(LOADER_PICTURE_MIXTAPE,"Best Of 1981-1982")
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Une compilation faite maison !")
#else
    INFO_MESSAGE("Home made mixtape!")
#endif    
    WAIT(50*2)
    END_AND_REFRESH
.)


_InspectSafe
.(
    INCREASE_SCORE(POINTS_INSPECT_SAFE)
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED),elseclose)       ; Is the safe closed?
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_ATTACHED),else)           ; Is the bomb installed?
            DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_WITH_BOMB,"Ready to blow!")
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Espérons qu'il va survivre")
#else
            INFO_MESSAGE("Hopefully it will survive the blow")
#endif    
        ELSE(else,nobomb)
            DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR,"A big old safe")
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Il est gros, mais semble fragile")
#else
            INFO_MESSAGE("It's big, but not that sturdy")
#endif    
        ENDIF(nobomb)
    ELSE(elseclose,safeopen)
        DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_OPEN,"Some stuff broke")
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Acid,e_LOC_NONE),acid)                ; If the acid still hidden (in the safe)? 
            SET_ITEM_LOCATION(e_ITEM_Acid,e_LOC_CELLAR)                          ; It's now visible inside the cellar
        ENDIF(acid)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Quasiment rien de brisé!")
#else
        INFO_MESSAGE("Most of the stuff is intact!")
#endif    
    ENDIF(safeopen)

    WAIT(50*2)
    END_AND_REFRESH
.)


_InspectThug
.(
    INCREASE_SCORE(POINTS_INSPECT_THUG)
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED),alive)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il dort")
#else
        INFO_MESSAGE("He is sleeping")
#endif    
    ELSE(alive,dead)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il ne bouge plus")
#else
        INFO_MESSAGE("He is not moving")
#endif    
        WAIT(50*2)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Peut-être à t'il des trucs utiles?")
#else
        INFO_MESSAGE("Maybe he has useful items?")
#endif    
    ENDIF(dead)

    END_AND_REFRESH    
.)


_InspectPanicRoomDoor
.(
    INCREASE_SCORE(POINTS_INSPECT_PANIC_ROOM_DOOR)
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_HoleInDoor,e_LOC_CURRENT),acid)  ; Is there a hole in the door?
        DISPLAY_IMAGE(LOADER_PICTURE_DOOR_WITH_HOLE,"Home-made peep-hole")
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Ils ne plaisantaient pas...")
#else
        INFO_MESSAGE("They were not lying...")
#endif    
        WAIT(50*2)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("...c'était un acide puissant !")
#else
        INFO_MESSAGE("...that was a strong acid!")
#endif    
        WAIT(50*2)
    ELSE(acid,clay)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_ATTACHED),attached)       ; Is the clay attached?
            DISPLAY_IMAGE(LOADER_PICTURE_DOOR_WITH_CLAY,"First prize at school?")
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Un joli petit barrage...")
#else
            INFO_MESSAGE("A nice little damn...")
#endif    
            WAIT(50*2)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("...plus qu'à le remplir !")
#else
            INFO_MESSAGE("...just need to fill it!")
#endif    
            WAIT(50*2)
        ELSE(attached,nothing)
            DISPLAY_IMAGE(LOADER_PICTURE_DOOR_DIGICODE,"1982 'State of the Art' security")
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Impossible de deviner le code...")
#else
            INFO_MESSAGE("Impossible to guess that code...")
#endif    
            WAIT(50*2)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("La porte est elle vulnérable?")
#else
            INFO_MESSAGE("Maybe the door itself is vulnerable?")
#endif    
            WAIT(50*2)
        ENDIF(nothing)
    ENDIF(clay)

    END_AND_REFRESH    
.)


_InspectProtectionSuit
.(
    INCREASE_SCORE(POINTS_INSPECT_PROTECTION_SUIT)
    GOSUB(_ShowProtectionSuit)
    END_AND_REFRESH    
.)


; From the hole in the door we can see three situations:
; - The girl is on the floor with bindings
; - The girl is sitting on the floor after being freed
; - The room is empty
_InspectHoleInDoor
.(
    INCREASE_SCORE(POINTS_INSPECT_HOLE)
    ; We only draw the girl if she's actually in the room
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_HOSTAGE_ROOM),girl_in_room)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_YoungGirl,ITEM_FLAG_DISABLED),girl_restrained)
            GOSUB(_ShowGirlInRoomWithBindings)
        ELSE(girl_restrained,girl_freed)
            GOSUB(_ShowGirlInRoomWithoutBindings)
        ENDIF(girl_freed)
    ELSE(girl_in_room,room_empty)
        GOSUB(_ShowEmptyHostageRoom)
    ENDIF(room_empty)
    END_AND_REFRESH    
.)


_ShowGirlInRoomWithBindings
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_HOLE,"A damsel in distress")     ; Draw the base image with the hole over an empty room
    BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_ATTACHED,17,76,17)    ; Draw the patch with the girl restrained on the floor 
            _IMAGE_STRIDE(0,0,17)
            _BUFFER(10,26)
    FADE_BUFFER

    WAIT(50)

    BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_ATTACHED,11,33,17)    ; Draw the patch with the MMPH speech bubble
            _IMAGE_STRIDE(0,75,17)
            _BUFFER(11,26)
    FADE_BUFFER

    WAIT(50)

#ifdef LANGUAGE_FR
    INFO_MESSAGE("La victime est attachée...")
#else
    INFO_MESSAGE("The victim is restrained...")
#endif    
    WAIT(50)
    IF_FALSE(CHECK_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOC_HOSTAGE_ROOM),giving_knife)
        ; We don't show the MMHFF if we are passing the knife because that causes some redraw issues
        BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_ATTACHED,15,44,17)    ; Draw the patch with the MMMHF!! speech bubble
                _IMAGE_STRIDE(0,108,17)
                _BUFFER(22,67)
        FADE_BUFFER
        WAIT(50)
    ENDIF(giving_knife)

#ifdef LANGUAGE_FR
    INFO_MESSAGE("...elle a besoin de notre aide !")
#else
    INFO_MESSAGE("...she needs our help!")
#endif    
    WAIT(50*2)
    RETURN
.)


_ShowGirlInRoomWithoutBindings
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_HOLE,"No more bindings")     ; Draw the base image with the hole over an empty room
    BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_FREE,14,92,17)    ; Draw the patch with the girl sitting on the floor 
            _IMAGE_STRIDE(0,0,17)
            _BUFFER(12,16)
    FADE_BUFFER

    ; We show the message and the "thank you" only once.
    DO_ONCE(thank_you)
        LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Elle a coupé ses restraintes...")
#else
        INFO_MESSAGE("She cut her bindings...")
#endif    
        WAIT(50)
        BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_FREE,15,59,17)    ; Draw the patch with the Thank You! spech bubble
                _IMAGE_STRIDE(0,92,17)
                _SCREEN(18,2)
        WAIT(50)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("...mais comment s'échapper?")
#else
        INFO_MESSAGE("...now for the escape?")
#endif    
        STOP_MUSIC()
    ENDDO(thank_you)

    WAIT(50*2)
    FADE_BUFFER

    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED),closed)
        ; The window is still closed
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
        _BUBBLE_LINE(135,16,0,"Dites mois quoi faire !")
        _BUBBLE_LINE(131,53,0,"Je peux aider !")
#else
        _BUBBLE_LINE(10,50,0,"Tell me what to do!")
        _BUBBLE_LINE(15,65,0,"I can help!")
#endif    
    ELSE(closed,open)
        ; The window is now opened
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
        _BUBBLE_LINE(135,16,0,"La fenêtre est ouverte maintenant.")
        _BUBBLE_LINE(131,53,0,"Mais je ne peux pas descendre...")
#else
        _BUBBLE_LINE(10,50,0,"The window is open now.")
        _BUBBLE_LINE(15,65,0,"But I can't climb down...")
#endif    
    ENDIF(open)

    BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_FREE,2,14,17)    ; Draw the small speech bubble triangle to connec to the Thank You! spech bubble
            _IMAGE_STRIDE(15,0,17)
            _SCREEN(17,36)

    WAIT(50*3)

    RETURN
.)


_ShowEmptyHostageRoom
.(
    DISPLAY_IMAGE(LOADER_PICTURE_HOLE,"Empty panic room")
#ifdef LANGUAGE_FR
    INFO_MESSAGE("La pièce est vide...")
#else
    INFO_MESSAGE("The room is empty...")
#endif    
    WAIT(50*2)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("...elle doit être dehors maintenant")
#else
    INFO_MESSAGE("...she must be outside by now")
#endif    
    WAIT(50*2)
    RETURN
.)



_ShowOpenWindow
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_TOP_WINDOW_CLOSED,"")
    ; Then add the sprites showing the window being opened
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,31,84)                    ; Draw the top part of the open window
            _IMAGE(0,0)
            _BUFFER(0,0)
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,9,28)                     ; Draw the bottom part of the open window
            _IMAGE(0,84)
            _BUFFER(0,84)
    FADE_BUFFER 
    WAIT(50*2)
    RETURN
.)

_ShowCueBreakingTheWindow
.(
    ; Then add the sprite showing the cue
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,4,60)                     ; Draw the cue going to smash the window
            _IMAGE(31,0)
            _BUFFER(22,68)
    FADE_BUFFER 
    WAIT(50*2)
    RETURN
.)

_ShowBrokenWindow
.(
    ; Erase any eventual remnant of the cue smashing the window
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,4,60)                     ; Delete the cue going to smash the window
            _IMAGE(35,0)
            _BUFFER(22,68)
    ; Then add the sprite showing the broken window
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,5,25)                     ; Draw the broken window pane
            _IMAGE(9,84)
            _BUFFER(21,49)
    FADE_BUFFER 
    WAIT(50*2)
    RETURN
.)

_ShowOpeningWindow
.(
    ; Show the view from the outside with the closed shutters
    DISPLAY_IMAGE(LOADER_PICTURE_PANIC_ROOM_WINDOW,"A high-up window")
    WAIT(50*2)

    ; Load the base image with the wall and the closed window and shutters
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_TOP_WINDOW_CLOSED,"")
    FADE_BUFFER 
    WAIT(50*2)

    ; Then add the sprites showing the window being opened
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,31,84)                     ; Draw the top part of the open window
            _IMAGE(0,0)
            _BUFFER(0,0)
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,9,28)                     ; Draw the bottom part of the open window
            _IMAGE(0,84)
            _BUFFER(0,84)
    FADE_BUFFER 
    WAIT(50*2)
    RETURN
.)

_ShowGirlAtTheWindow
.(
    ; Base image with the wall and the closed window
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_PANIC_ROOM_WINDOW,"A high-up window")
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED),window_open)
        ; Show the shutters open
        BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,18,26)                     ; Draw the open shutters
                _IMAGE(0,0)
                _BUFFER(11,0)

        ; Show the rope going down the window if it's attached
        JUMP_IF_FALSE(rope_going_down,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))            
            BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,9,5)                      ; Draw the snooker cue with the top of the rope
                    _IMAGE(4,26)
                    _BUFFER(15,18)                    
            BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,1,105)                     ; Draw the rope going down
                    _IMAGE(39,0)
                    _BUFFER(19,23)
rope_going_down
                
        FADE_BUFFER 
        WAIT(50)

        ; Show the girl at the window if she's still in the room of course
        JUMP_IF_FALSE(girl_at_the_window,CHECK_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_HOSTAGE_ROOM))
            BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,4,18)                     ; Draw the girl in the window
                    _IMAGE(0,26)
                    _BUFFER(20,4)
            FADE_BUFFER 
            WAIT(50)

        ; Is the rope attached?
        IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED),rope_not_attached)
            ; The rope is not attached
            ; Show the girl's message to the player        
            WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR   
            _BUBBLE_LINE(107,15,0,"C'est trop haut pour sauter!")
#else
            _BUBBLE_LINE(93,25,0,"It's too high to jump!")
#endif    
            BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,2,10)                     ; Draw the speech bubble triangle
                    _IMAGE(4,31)
                    _SCREEN(21,15)
        ELSE(rope_not_attached,rope_attached)
            ; The rope is attached
            WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR   
            _BUBBLE_LINE(107,15,0,"Je peux le faire !")
#else
            _BUBBLE_LINE(93,25,0,"I can do that!")
#endif    
            BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,2,10)                     ; Draw the speech bubble triangle
                    _IMAGE(4,31)
                    _SCREEN(21,15)
        ENDIF(rope_attached)

        WAIT(50*2)
girl_at_the_window        

    ELSE(window_open,window_closed)
        FADE_BUFFER 
        INFO_MESSAGE("Impossible to access from here")
        WAIT(50*2)        
    ENDIF(window_closed)

    RETURN
.)


/* MARK: Open Action 📦➡

 ██████╗ ██████╗ ███████╗███╗   ██╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
██╔═══██╗██╔══██╗██╔════╝████╗  ██║    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
██║   ██║██████╔╝█████╗  ██╔██╗ ██║    ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║    ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
╚██████╔╝██║     ███████╗██║ ╚████║    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
 ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝*/

_gOpenItemMappingsArray
    VALUE_MAPPING(e_ITEM_Curtain            , _OpenCurtain)
    VALUE_MAPPING(e_ITEM_Fridge             , _OpenFridge)
    VALUE_MAPPING(e_ITEM_Medicinecabinet    , _OpenMedicineCabinet)
    VALUE_MAPPING(e_ITEM_GunCabinet         , _OpenGunCabinet)
    VALUE_MAPPING(e_ITEM_BasementWindow     , _OpenBasementWindow)
    VALUE_MAPPING(e_ITEM_AlarmPanel         , _OpenAlarmPanel)
    VALUE_MAPPING(e_ITEM_CarBoot            , _OpenCarBoot)
    VALUE_MAPPING(e_ITEM_CarDoor            , _OpenCarDoor)
    VALUE_MAPPING(e_ITEM_CarTank            , _OpenCarPetrolTank)
    VALUE_MAPPING(e_ITEM_PanicRoomWindow    , _OpenPanicRoomWindow)
    VALUE_MAPPING(e_ITEM_FrontDoor          , _OpenFrontDoor)
    VALUE_MAPPING(e_ITEM_SecurityDoor       , _OpenSecurityDoor)
    VALUE_MAPPING(255                       , _ErrorCannotDo)        ; Default option


_OpenCurtain
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Curtain,ITEM_FLAG_CLOSED),open)                                  ; Is the curtain closed?
        UNSET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)                                           ; Open it!
        SET_LOCATION_DIRECTION(e_LOC_WESTGALLERY,e_DIRECTION_NORTH,e_LOC_PANIC_ROOM_DOOR)           ; We can now access the panic room
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CURTAIN)                                          ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                                  ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"un _rideau ouvert")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"an opened _curtain")
#endif        
    ENDIF(open)
    END_AND_REFRESH
.)


_OpenPanicRoomWindow
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_TILEDPATIO),tiledpatio)
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Elle est trop haute")
#else
        ERROR_MESSAGE("It's too high")
#endif        
    ELSE(tiledpatio,panicroom)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED),open)                          ; Is the window closed?
            UNSET_ITEM_FLAGS(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED)                                   ; Open it! 
            INCREASE_SCORE(POINTS_OPENED_PANIC_ROOM_WINDOW)
            ; The description will get updated automatically by _gDescriptionPanicRoomDoor
            GOSUB(_ShowOpeningWindow)

            ; Check the status of the alarm... and if it's active, trigger it!
            JUMP_IF_FALSE(_AlarmTriggered,CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED))      ; Is the alarm active...

            GOSUB(_ShowGirlAtTheWindow)
        ELSE(open,else)
#ifdef LANGUAGE_FR
            ERROR_MESSAGE("Elle est déjà ouverte")
#else
            ERROR_MESSAGE("It's already open")
#endif        
        ENDIF(else)
    ENDIF(panicroom)
    END_AND_REFRESH
.)


; TODO: Messages to indicate that the fridge it already open or that we have already found something
; Probably need a string table/id system to easily reuse messages.
_SearchFridge
_OpenFridge
.(    
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Fridge,ITEM_FLAG_CLOSED),open)                               ; Is the fridge closed?
        PLAY_SOUND(_DoorOpening)
        UNSET_ITEM_FLAGS(e_ITEM_Fridge,ITEM_FLAG_CLOSED)                                        ; Open it!
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_FRIDGE)                                       ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                              ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"un _réfrigérateur ouvert")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"an open _fridge")
#endif        
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Meat,e_LOC_NONE),meat)                          ; If the meat still hidden (in the fridge)? 
            SET_ITEM_LOCATION(e_ITEM_Meat,e_LOC_KITCHEN)                                   ; It's now visible inside the kitchen
        ENDIF(meat)
    ENDIF(open)
    END_AND_REFRESH
.)


_SearchMedicineCabinet
_OpenMedicineCabinet
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED),open)                      ; Is the medicine cabinet closed?
        PLAY_SOUND(_DoorOpening)
        UNSET_ITEM_FLAGS(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED)                               ; Open it!
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                      ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                              ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"une _armoire à pharmacie ouverte")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"an open medicine _cabinet")
#endif        
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_SedativePills,e_LOC_NONE),pills)                ; Are the pills still hidden (in the cabinet)? 
            SET_ITEM_LOCATION(e_ITEM_SedativePills,e_LOC_KITCHEN)                          ; It's now visible inside the kitchen
        ENDIF(pills)
    ENDIF(open)
    END_AND_REFRESH
.)


_SearchGunCabinet
_OpenGunCabinet
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED),open)                           ; Is the gun cabinet closed?
        PLAY_SOUND(_DoorOpening)
        UNSET_ITEM_FLAGS(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED)                                    ; Open it!
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                      ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                              ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"une _armoire à armes ouverte")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"an open gun _cabinet")
#endif        
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_DartGun,e_LOC_NONE),dartgun)                    ; Is the dart gun still hidden (in the gun cabinet)? 
            DISPLAY_IMAGE(LOADER_PICTURE_DRAWER_GUN_CABINET,"Gun cabinet upper drawer")         ; Show what we found!
            SET_ITEM_LOCATION(e_ITEM_DartGun,e_LOC_STUDY_ROOM)                             ; It's now visible inside the study room
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Une seule fléchette, mieux que rien!")
#else
            INFO_MESSAGE("Only one dart, better than nothing!")
#endif    
            WAIT(50*2)
        ENDIF(dartgun)
    ENDIF(open)
    END_AND_REFRESH
.)


_OpenAlarmPanel
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_LOCKED),locked)                    ; Is the alarm panel locked?
        ERROR_MESSAGE("The door is locked")
        WAIT(50*2)
    ELSE(locked,unlocked)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED),open)                      ; Is the alarm panel closed?
            PLAY_SOUND(_DoorOpening)
            UNSET_ITEM_FLAGS(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED)                               ; Open it!
            UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_PANEL)                                   ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                             ; Update the description 
            SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"une _centrale d'alarme ouverte")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"an open alarm _panel")
#endif        
            SET_ITEM_LOCATION(e_ITEM_AlarmSwitch,e_LOC_DARKCELLARROOM)                         ; The alarm button is now visible 
        ENDIF(open)
        JUMP(_InspectPanel)
    ENDIF(unlocked)
    END_AND_REFRESH
.)


_OpenBasementWindow
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM),basement)                              ; Are we on the basement side in the room itself...
        INFO_MESSAGE("I can't reach it...")
        WAIT(50*2)
        END_AND_REFRESH
    ENDIF(basement)

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_CELLAR_WINDOW),basement_on_ladder)                     ; Are we on the basement side on the ladder...
        INFO_MESSAGE("The frame is stuck...")                                                   
    ELSE(basement_on_ladder,garden)                                                            ; ...or on the vegetable garden side of the window?
        DISPLAY_IMAGE(LOADER_PICTURE_BASEMENT_WINDOW_DARK,"")
        INFO_MESSAGE("It is locked from the inside...")
    ENDIF(garden)
    WAIT(50*2)
    INFO_MESSAGE("...maybe shake it a bit?")
    WAIT(50*2)
    ; Check the status of the alarm... and if it's active, trigger it!
    JUMP_IF_FALSE(_AlarmTriggered,CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED))      ; Is the alarm active...
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Rien ne se passe...")
#else
    INFO_MESSAGE("Nothing happens...")
#endif    
    END_AND_REFRESH
.)


_AlarmTriggered
.(
    SET_CUT_SCENE(1)
    DISPLAY_IMAGE(LOADER_PICTURE_ALARM_TRIGGERED,"")
    LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
    ERROR_MESSAGE("You triggered the alarm!")
    WAIT(50*2)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_TRIPPED_ALARM)   ; Achievement!
    GAME_OVER(e_SCORE_TRIPPED_ALARM)
    JUMP(_gDescriptionGameOverLost)                 ; Draw the 'The End' logo
.)


_OpenCarBoot
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_CarBoot,ITEM_FLAG_CLOSED),open)                             ; Is the boot closed?
        PLAY_SOUND(_DoorOpening)
        UNSET_ITEM_FLAGS(e_ITEM_CarBoot,ITEM_FLAG_CLOSED)                                      ; Open it!
#ifdef LANGUAGE_FR                                                                              ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"un _coffre ouvert")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"an open car _boot")
#endif        
    ENDIF(open)
    END_AND_REFRESH
.)


_OpenCarDoor
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_CarDoor,ITEM_FLAG_CLOSED),open)                              ; Is the door closed?
        PLAY_SOUND(_DoorOpening)
        UNSET_ITEM_FLAGS(e_ITEM_CarDoor,ITEM_FLAG_CLOSED)                                       ; Open it!
#ifdef LANGUAGE_FR                                                                              ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"une _portière ouverte")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"an open _car door")
#endif        
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_MixTape,e_LOC_NONE),mixtape)                         ; Is the mixtape still not found?
            SET_ITEM_LOCATION(e_ITEM_MixTape,e_LOC_ABANDONED_CAR)                               ; It's now visible inside the car
        ENDIF(mixtape)
    ENDIF(open)
    END_AND_REFRESH
.)


_OpenCarPetrolTank
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_CarTank,ITEM_FLAG_CLOSED),open)                              ; Is the petrol tank closed?
        PLAY_SOUND(_DoorOpening)
        UNSET_ITEM_FLAGS(e_ITEM_CarTank,ITEM_FLAG_CLOSED)                                       ; Open it!
#ifdef LANGUAGE_FR                                                                              ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"un _réservoir d'essence ouvert")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"an open petrol _tank")
#endif        
    ENDIF(open)
    END_AND_REFRESH
.)


_OpenSecurityDoor
_OpenFrontDoor
.(
    ERROR_MESSAGE("The door is locked")
    END_AND_REFRESH
.)



/* MARK: Close Action ➡📦

 ██████╗██╗      ██████╗ ███████╗███████╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
██╔════╝██║     ██╔═══██╗██╔════╝██╔════╝    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
██║     ██║     ██║   ██║███████╗█████╗      ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
██║     ██║     ██║   ██║╚════██║██╔══╝      ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
╚██████╗███████╗╚██████╔╝███████║███████╗    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
 ╚═════╝╚══════╝ ╚═════╝ ╚══════╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ */              

_gCloseItemMappingsArray
    VALUE_MAPPING(e_ITEM_Curtain            , _CloseCurtain)
    VALUE_MAPPING(e_ITEM_Fridge             , _CloseFridge)
    VALUE_MAPPING(e_ITEM_Medicinecabinet    , _CloseMedicineCabinet)
    VALUE_MAPPING(e_ITEM_GunCabinet         , _CloseGunCabinet)
    VALUE_MAPPING(e_ITEM_AlarmPanel         , _CloseAlarmPanel)
    VALUE_MAPPING(e_ITEM_CarBoot            , _CloseCarBoot)
    VALUE_MAPPING(e_ITEM_CarDoor            , _CloseCarDoor)
    VALUE_MAPPING(e_ITEM_CarTank            , _CloseCarPetrolTank)
    VALUE_MAPPING(255                       , _ErrorCannotDo)            ; Default option


_CloseCurtain
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Curtain,ITEM_FLAG_CLOSED),curtain)                               ; Is the curtain open?
        SET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)                                              ; Close it!
        SET_LOCATION_DIRECTION(e_LOC_WESTGALLERY,e_DIRECTION_NORTH,e_LOC_NONE)             ; The room behind is not accessible anymore
+_gTextItemClosedCurtain = *+2                                                                       ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                   ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"un _rideau fermé")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"a closed _curtain")
#endif    
    ENDIF(curtain)
    END_AND_REFRESH
.)


_CloseFridge
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Fridge,ITEM_FLAG_CLOSED),fridge)                                ; Is the fridge open?
        PLAY_SOUND(_DoorClosing)
        SET_ITEM_FLAGS(e_ITEM_Fridge,ITEM_FLAG_CLOSED)                                              ; Close it!
+_gTextItemFridge = *+2                                                                             ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                  ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"un _réfrigérateur")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"a _fridge")
#endif    
    ENDIF(fridge)
    END_AND_REFRESH
.)


_CloseMedicineCabinet
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED),cabinet)                      ; Is the cabinet open?
        PLAY_SOUND(_DoorClosing)
        SET_ITEM_FLAGS(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED)                                     ; Close it!
+_gTextItemMedicineCabinet = *+2                                                                    ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                  ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"une _armoire à pharmacie")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"a medicine _cabinet")
#endif    
    ENDIF(cabinet)
    END_AND_REFRESH
.)


_CloseGunCabinet
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED),cabinet)                           ; Is the cabinet open?
        PLAY_SOUND(_DoorClosing)
        SET_ITEM_FLAGS(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED)                                          ; Close it!
+_gTextItemClosedGunCabinet = *+2                                                                   ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                  ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"une _armoire à armes")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"a closed gun _cabinet")
#endif    
    ENDIF(cabinet)
    END_AND_REFRESH
.)


_CloseAlarmPanel
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED),open)                      ; Is the alarm panel closed?
        PLAY_SOUND(_DoorClosing)
        SET_ITEM_FLAGS(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED)                                  ; Close it!
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                  ; And get an achievement for that action
+_gTextItemLockedPanel = *+2       
#ifdef LANGUAGE_FR                                                                          ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"une _centrale d'alarme fermée")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"a closed alarm _panel")
#endif        
        SET_ITEM_LOCATION(e_ITEM_AlarmSwitch,e_LOC_NONE)                                    ; The alarm button is now invisible 
    ENDIF(open)
    JUMP(_InspectPanel)
.)


_CloseCarBoot
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_CarBoot,ITEM_FLAG_CLOSED),open)                            ; Is the boot open?
        PLAY_SOUND(_DoorClosing)
        SET_ITEM_FLAGS(e_ITEM_CarBoot,ITEM_FLAG_CLOSED)                                        ; Close it!
+_gTextItemCarBoot = *+2        
#ifdef LANGUAGE_FR                                                                              ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"un _coffre de voiture")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"a car _boot")
#endif        
    ENDIF(open)
    END_AND_REFRESH
.)


_CloseCarDoor
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_CarDoor,ITEM_FLAG_CLOSED),open)                             ; Is the door open?
        PLAY_SOUND(_DoorClosing)
        SET_ITEM_FLAGS(e_ITEM_CarDoor,ITEM_FLAG_CLOSED)                                         ; Close it!
+_gTextItemCarDoor = *+2        
#ifdef LANGUAGE_FR                                                                              ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"une _portière")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"a car _door")
#endif        
    ENDIF(open)
    END_AND_REFRESH
.)


_CloseCarPetrolTank
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_CarTank,ITEM_FLAG_CLOSED),open)                            ; Is the petrol tank open?
        SET_ITEM_FLAGS(e_ITEM_CarTank,ITEM_FLAG_CLOSED)                                        ; Close it!
+_gTextItemCarPetrolTank = *+2        
#ifdef LANGUAGE_FR                                                                             ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"un _réservoir d'essence")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"a closed petrol _tank")
#endif        
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_ABANDONED_CAR),petrol)                 ; If the petrol was not collected
            SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_NONE)                                        ; Then we hide it again
        ENDIF(petrol)

        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Hose,e_LOC_ABANDONED_CAR),hose)                 ; If the hose is installed
            IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Hose,ITEM_FLAG_ATTACHED),hose2)                 ; If the hose is installed
                SET_ITEM_LOCATION(e_ITEM_Hose,e_LOC_INVENTORY)                             ; Then we need to remove it again
            ENDIF(hose2)
        ENDIF(hose)
    ENDIF(open)
    END_AND_REFRESH
.)


/* MARK: Use Action ✋

:::    :::  ::::::::  ::::::::::          :::      :::::::: ::::::::::: ::::::::::: ::::::::  ::::    ::: 
:+:    :+: :+:    :+: :+:               :+: :+:   :+:    :+:    :+:         :+:    :+:    :+: :+:+:   :+: 
+:+    +:+ +:+        +:+              +:+   +:+  +:+           +:+         +:+    +:+    +:+ :+:+:+  +:+ 
+#+    +:+ +#++:++#++ +#++:++#        +#++:++#++: +#+           +#+         +#+    +#+    +:+ +#+ +:+ +#+ 
+#+    +#+        +#+ +#+             +#+     +#+ +#+           +#+         +#+    +#+    +#+ +#+  +#+#+# 
#+#    #+# #+#    #+# #+#             #+#     #+# #+#    #+#    #+#         #+#    #+#    #+# #+#   #+#+# 
 ########   ########  ##########      ###     ###  ########     ###     ########### ########  ###    #### */

_gUseItemMappingsArray
    VALUE_MAPPING(e_ITEM_Ladder             , _UseLadder)
    VALUE_MAPPING(e_ITEM_Rope               , _UseRope)
    VALUE_MAPPING(e_ITEM_HandheldGame       , _UseGame)
    VALUE_MAPPING(e_ITEM_Bread              , _UseBread)
    VALUE_MAPPING(e_ITEM_Meat               , _UseMeat)
    VALUE_MAPPING(e_ITEM_SilverKnife        , _UseKnife)
    VALUE_MAPPING(e_ITEM_SnookerCue         , _UseSnookerCue)
    VALUE_MAPPING(e_ITEM_DartGun            , _UseDartGun)
    VALUE_MAPPING(e_ITEM_Keys               , _UseKeys)
    VALUE_MAPPING(e_ITEM_AlarmSwitch        , _UseAlarmSwitch)
    VALUE_MAPPING(e_ITEM_Hose               , _UseHosePipe)
    VALUE_MAPPING(e_ITEM_MortarAndPestle    , _UseMortar)
    VALUE_MAPPING(e_ITEM_Bomb               , _UseBomb)
    VALUE_MAPPING(e_ITEM_BoxOfMatches       , _UseMatches)
    VALUE_MAPPING(e_ITEM_ProtectionSuit     , _UseProtectionSuit)
    VALUE_MAPPING(e_ITEM_Clay               , _UseClay)
    VALUE_MAPPING(e_ITEM_Acid               , _UseAcid)
    VALUE_MAPPING(e_ITEM_FishingNet         , _UseNet)
    VALUE_MAPPING(e_ITEM_RoughMap           , _UseRoughMap)
    VALUE_MAPPING(e_ITEM_Car                , _UseCar)
    VALUE_MAPPING(255                       , _ErrorCannotDo)   ; Default option


_InspectCar
_UseCar
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_MARKETPLACE),marketplace)
        INFO_MESSAGE("This is my car.")
        WAIT(50)
        INFO_MESSAGE("I need to finish the mission first!")
        END_AND_REFRESH
    ELSE(marketplace,abandonned_car)
        INFO_MESSAGE("Let's get closer")
        WAIT(50)
        SET_PLAYER_LOCATION(e_LOC_ABANDONED_CAR)
        END_AND_REFRESH
    ENDIF(abandonned_car)
.)


_UseLadder
.(
    JUMP_IF_TRUE(install_the_ladder,CHECK_PLAYER_LOCATION(e_LOC_INSIDE_PIT))
    JUMP_IF_TRUE(install_the_ladder,CHECK_PLAYER_LOCATION(e_LOC_OUTSIDE_PIT))
    JUMP_IF_TRUE(install_the_ladder,CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM))
    JUMP_IF_TRUE(ladder_too_short,CHECK_PLAYER_LOCATION(e_LOC_TILEDPATIO))
cannot_use_ladder_here
    ERROR_MESSAGE("Can't use it there")
    END_AND_REFRESH

ladder_too_short
    ERROR_MESSAGE("It's way too short!")
    END_AND_REFRESH

install_the_ladder
    INFO_MESSAGE("You position the ladder properly")
    SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_CURRENT)
    SET_ITEM_FLAGS(e_ITEM_Ladder,ITEM_FLAG_ATTACHED)
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"une _échelle prête à grimper")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"a _ladder ready to climb")
#endif    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_THE_LADDER)
    END_AND_REFRESH
.)


_ThrowRope
_UseRope
.(
    // - We are in front of the panic room and the hole was made
    JUMP_IF_FALSE(acid_hole_rope,CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR))
    JUMP_IF_FALSE(acid_hole_rope,CHECK_ITEM_LOCATION(e_ITEM_HoleInDoor,e_LOC_PANIC_ROOM_DOOR))
        ; Check if the rope is already in the panic room
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_IMMOVABLE),rope_in_the_room)
            ; If the rope is attached to the window, then the girl escapes and appears on the tiled patio outside
            ; If the rope is in the room, the only option is to attach it to the window if it's open and broken
            IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED),rope_attached)
                SET_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_TILEDPATIO) ; The girl is now outside on the patio
                SET_ITEM_LOCATION(e_ITEM_Rope,e_LOC_TILEDPATIO)      ; And we move the rope outside
                INCREASE_SCORE(POINTS_GIRL_USES_ROPE)
                GOSUB(_ShowGirlAtTheWindow)                          ; We show the girl...
#ifdef LANGUAGE_FR
                INFO_MESSAGE("On y va !!!")
#else
                INFO_MESSAGE("Let's go!!!")
#endif    
                ; Erase the girl at the window
                BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,4,22)                     ; Draw the girl in the window
                        _IMAGE(9,0)
                        _BUFFER(20,0)

                ; Draw the girl going down the rope
                BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,13,79)    ; Draw the girl with the slide message
                        _IMAGE(0,49)
                        _BUFFER(13,49)
                PLAY_SOUND(_ZipDownTheRope)
                FADE_BUFFER 
                WAIT(50*2)

            ELSE(rope_attached,rope_not_attached)
#ifdef LANGUAGE_FR       
                ERROR_MESSAGE("La corde n'est pas attachée")
#else
                ERROR_MESSAGE("The rope is not attached")
#endif       
            ENDIF(rope_not_attached)
            WAIT(50*2)
            END_AND_REFRESH
        ELSE(rope_in_the_room,rope_not_in_the_room)
            ; If the rope is not in the room, we pass it to the girl through the hole
            SET_ITEM_LOCATION(e_ITEM_Rope,e_LOC_CURRENT)    
            SET_ITEM_FLAGS(e_ITEM_Rope,ITEM_FLAG_IMMOVABLE)
            UNLOCK_ACHIEVEMENT(ACHIEVEMENT_GAVE_THE_ROPE)
#ifdef LANGUAGE_FR   
            SET_ITEM_DESCRIPTION(e_ITEM_Rope,"une _corde dans la chambre forte")
#else    
            SET_ITEM_DESCRIPTION(e_ITEM_Rope,"a _rope in the panic room")
#endif    
            DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_HOLE,"")     ; Draw the base image with the hole over an empty room
            BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_FREE,14,92,17)    ; Draw the patch with the girl sitting on the floor 
                    _IMAGE_STRIDE(0,0,17)
                    _BUFFER(12,16)
            FADE_BUFFER

            BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_ROPE,11,94,11)    ; Draw the patch with the rope through the hole
                    _IMAGE_STRIDE(0,0,11)
                    _BUFFER(16,34)
            FADE_BUFFER      ; Make sure everything appears on the screen
            WAIT(50*2)
            ENDIF(rope_not_in_the_room)
        END_AND_REFRESH    
acid_hole_rope

    ; Else check the pit
    JUMP_IF_TRUE(around_the_pit,CHECK_PLAYER_LOCATION(e_LOC_INSIDE_PIT))
    JUMP_IF_TRUE(around_the_pit,CHECK_PLAYER_LOCATION(e_LOC_OUTSIDE_PIT))
cannot_use_rope_here
    ERROR_MESSAGE("Can't use it there")
    END_AND_REFRESH

around_the_pit
    INFO_MESSAGE("You attach the rope to the tree")
    SET_ITEM_LOCATION(e_ITEM_Rope,e_LOC_OUTSIDE_PIT)
    SET_ITEM_FLAGS(e_ITEM_Rope,ITEM_FLAG_ATTACHED)
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"une _corde attachée à un arbre")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"a _rope attached to a tree")
#endif    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_THE_ROPE)
    END_AND_REFRESH    
.)


_UseGame
    DISPLAY_IMAGE(LOADER_PICTURE_DONKEY_KONG_PLAYING,"A handheld game")
    INFO_MESSAGE("Hum... looks like it crashed?")
    WAIT(50*2)
    END_AND_REFRESH


_UseDartGun
    DISPLAY_IMAGE(LOADER_PICTURE_SHOOTING_DART,"You shoot your only dart")
    SET_ITEM_LOCATION(e_ITEM_DartGun,e_LOC_GONE_FOREVER)                      ; The player can only use the dart gun once
    PLAY_SOUND(_Swoosh)

    // - We are in the entrance hall and the dog is still alive
    JUMP_IF_FALSE(snoozed_dog,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_TRUE(snoozed_dog,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_DOG)
        INCREASE_SCORE(POINTS_DART_GUNNED_DOG)
#ifdef LANGUAGE_FR   
        INFO_MESSAGE("Fait de beau rêves")
#else    
        INFO_MESSAGE("Sweet dreams doggy")
#endif    
        JUMP(_CommonDogDisabled)
snoozed_dog

    // - We are in the sleeping room and the thug is still alive
    JUMP_IF_FALSE(snoozed_thug,CHECK_PLAYER_LOCATION(e_LOC_MASTERBEDROOM))
    JUMP_IF_TRUE(snoozed_thug,CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED))
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_THUG)
        INCREASE_SCORE(POINTS_DART_GUNNED_THUG)
#ifdef LANGUAGE_FR   
        INFO_MESSAGE("Fait de beau rêves")
#else    
        INFO_MESSAGE("Sweet dreams scumbag")
#endif    
        JUMP(_CommonThugDisabled)
snoozed_thug    

    ;INFO_MESSAGE("Hum... looks like it crashed?")
    WAIT(50*2)
    END_AND_REFRESH


_UseKeys
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM),cellar)                    ; Are we in the cellar?
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_LOCKED),locked)        ; Is the alarm panel locked?
            UNSET_ITEM_FLAGS(e_ITEM_AlarmPanel,ITEM_FLAG_LOCKED)                   ; Unlock it!
            SET_ITEM_LOCATION(e_ITEM_Keys,e_LOC_GONE_FOREVER)                      ; We don't need the keys anymore
            INCREASE_SCORE(POINTS_USED_KEYS)
            INFO_MESSAGE("The panel is now unlocked")
#ifdef LANGUAGE_FR                                                                             ; Update the description 
            SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"une _centrale d'alarme déverouillée")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"an unlocked alarm _panel")
#endif        
            WAIT(50*1)
            END_AND_REFRESH
        ENDIF(locked)
    ENDIF(cellar)

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room)               ; Are we in front of the panic room?
        DISPLAY_IMAGE(LOADER_PICTURE_DOOR_DIGICODE,"1982 'State of the Art' security")
#ifdef LANGUAGE_FR
        INFO_MESSAGE("C'est une serrure numérique !")
#else
        INFO_MESSAGE("It uses a digital lock!")
#endif    
        WAIT(50*2)
        END_AND_REFRESH
    ENDIF(panic_room)

    JUMP(_ErrorCannotDo)
.)


_UseAlarmSwitch
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED),on)                 ; Is the alarm active?
        SET_ITEM_FLAGS(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED)                           ; Disable the alarm 
        INCREASE_SCORE(POINTS_USED_SWITCH)
        INFO_MESSAGE("The alarm is now disabled")
#ifdef LANGUAGE_FR                                                                      ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"un _bouton en position arrêt")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"a _switch in OFF position")
#endif        
    ELSE(on,off)
        UNSET_ITEM_FLAGS(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED)                         ; Enable the alarm 
        INFO_MESSAGE("The alarm is now disabled")
+_gTextItemAlarmSwitch = *+2
#ifdef LANGUAGE_FR                                                                      ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"un _bouton en position marche")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"a _switch in ON position")
#endif        
    ENDIF(off)
    WAIT(50*2)
    END_AND_REFRESH
.)


_UseHosePipe
.(
    JUMP_IF_TRUE(abandonned_car,CHECK_PLAYER_LOCATION(e_LOC_ABANDONED_CAR))
cannot_use_rope_here
    ERROR_MESSAGE("Can't use it there")
    END_AND_REFRESH

abandonned_car
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_CarTank,ITEM_FLAG_CLOSED),closed)                     ; Is the petrol tank open?
        ERROR_MESSAGE("The tank is closed")
        END_AND_REFRESH
    ENDIF(closed)

    INFO_MESSAGE("You put the hose in the tank")
    SET_ITEM_LOCATION(e_ITEM_Hose,e_LOC_ABANDONED_CAR)
    SET_ITEM_FLAGS(e_ITEM_Hose,ITEM_FLAG_ATTACHED)
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_NONE),petrol)                           ; Is the petrol still not found?
        SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_ABANDONED_CAR)                                ; It's now visible inside the car
    ENDIF(petrol)

#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"un _tuyeau dans le réservoir")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"a _hose in the petrol tank")
#endif    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_HOSE)
    INCREASE_SCORE(POINTS_USED_HOSE)
    END_AND_REFRESH
.)



_UseMortar
.(
    JUMP_IF_TRUE(made_gun_powder,CHECK_ITEM_LOCATION(e_ITEM_PowderMix,e_LOC_CURRENT))
    JUMP_IF_TRUE(made_gun_powder,CHECK_ITEM_LOCATION(e_ITEM_PowderMix,e_LOC_INVENTORY))
cannot_use_mortar
    ERROR_MESSAGE("Nothing to use it with")
    END_AND_REFRESH

made_gun_powder
    SET_ITEM_LOCATION(e_ITEM_PowderMix,e_LOC_NONE)                       ; The rough powder mix is gone
    SET_ITEM_LOCATION(e_ITEM_GunPowder,e_LOC_CURRENT)                    ; We now have proper gun powder

    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_MADE_BLACK_POWDER)                    ; Achievement!    

    DISPLAY_IMAGE(LOADER_PICTURE_MORTAR_AND_PESTLE,"There you go!")
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    INFO_MESSAGE("Homemade Gun powder...")
    WAIT(50*2)
    INFO_MESSAGE("...need a proper canister to store it")
    WAIT(50*2)
    STOP_MUSIC()
    END_AND_REFRESH
.)



_UseBomb
.(
    IF_FALSE(CHECK_PLAYER_LOCATION(e_LOC_CELLAR),cellar)
        ERROR_MESSAGE("I can't use it here")
        END_AND_REFRESH
    ENDIF(cellar)
    JUMP(_CombineStickyBombWithSafe)

.)

_UseMatches
.(
    IF_FALSE(CHECK_PLAYER_LOCATION(e_LOC_CELLAR),cellar)
        ERROR_MESSAGE("I can't use it here")
        END_AND_REFRESH
    ENDIF(cellar)
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED),safe)
        ERROR_MESSAGE("The safe is already open")
        END_AND_REFRESH
    ENDIF(safe)
    JUMP(_CombineBombWithMatches)
.)


_UseProtectionSuit
.(
    DISPLAY_IMAGE(LOADER_PICTURE_SHOWING_GLOVES,"PRO-TEC Personal Protection Equipment")
    PLAY_SOUND(_Zipper)
    INFO_MESSAGE("It seems to fit well...")
    WAIT(50*2)
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room)
        ; The player is in front of the Panic Room, we can now equip the protection suit
        INFO_MESSAGE("...let's experiment!")
        SET_ITEM_FLAGS(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED)
        WAIT(50*2)
    ELSE(panic_room,not_panic_room)
        ; The player is anywhere else
        PLAY_SOUND(_Zipper)
        INFO_MESSAGE("...but it's of no use here")
        WAIT(50*2)
    ENDIF(not_panic_room)
    END_AND_REFRESH
.)


_UseClay
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_ATTACHED),attached)    ; Is the clay attached?
        ERROR_MESSAGE("It's already in place!")
        END_AND_REFRESH
    ENDIF(attached)

    IF_FALSE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room)
        ERROR_MESSAGE("I can't use it here")
        END_AND_REFRESH
    ENDIF(panic_room)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_TRANSFORMED),wet)    ; Is the clay wet?
        ERROR_MESSAGE("It's too dry!")
        END_AND_REFRESH
    ENDIF(wet)

    SET_ITEM_LOCATION(e_ITEM_Clay,e_LOC_PANIC_ROOM_DOOR)                ; The clay is now in the room
    SET_ITEM_FLAGS(e_ITEM_Clay,ITEM_FLAG_ATTACHED)                      ; The clay is now attached to the door
    INCREASE_SCORE(POINTS_USED_CLAY)

    DISPLAY_IMAGE(LOADER_PICTURE_DOOR_WITH_CLAY,"A real piece of art!")
    INFO_MESSAGE("Ok, that should be good enough...")
    WAIT(50*2)
    INFO_MESSAGE("...now just need to fill it!")
    WAIT(50*2)

    END_AND_REFRESH
.)


_UseAcid
.(
    IF_FALSE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room)    ; Are we in the proper location to use the acid?
        ERROR_MESSAGE("I can't use it here")
        END_AND_REFRESH
    ENDIF(panic_room)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_ATTACHED),attached)    ; Is the clay attached?
        ERROR_MESSAGE("Needs something to contain the acid")
        END_AND_REFRESH
    ENDIF(attached)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED),suit)    ; Is the protection suit equiped?
        ERROR_MESSAGE("Needs some protection equipment first")
        END_AND_REFRESH
    ENDIF(suit)

    ; Cut scene, Action!
    DISPLAY_IMAGE(LOADER_PICTURE_DOOR_POURING_ACID,"Step 1: Pour the acid")
    WAIT(50)
    PLAY_SOUND(_Acid)
    WAIT(50)
    DISPLAY_IMAGE(LOADER_PICTURE_DOOR_ACID_BURNING,"Step 2: Let it burn")
    WAIT(50*2)
    DISPLAY_IMAGE(LOADER_PICTURE_DOOR_WITH_HOLE,"Result: A large hole!")
    INFO_MESSAGE("Large enough to peek through...")
    WAIT(50*2)
    INFO_MESSAGE("...or even pass objects?")
    WAIT(50*2)

    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_THE_ACID)

    SET_ITEM_LOCATION(e_ITEM_HoleInDoor,e_LOC_PANIC_ROOM_DOOR)            ; There is now a hole in the door
    SET_ITEM_LOCATION(e_ITEM_Clay,e_LOC_NONE)                             ; The clay has vanished
    SET_ITEM_LOCATION(e_ITEM_Acid,e_LOC_NONE)                             ; The acid is gone as well
    SET_ITEM_LOCATION(e_ITEM_ProtectionSuit,e_LOC_NONE)                   ; We don't need the protection suit
    UNSET_ITEM_FLAGS(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED)            ; 

    END_AND_REFRESH
.)

/* MARK: Search Action 🕵️‍♀️

            ███████╗███████╗ █████╗ ██████╗  ██████╗██╗  ██╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
            ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝██║  ██║    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
            ███████╗█████╗  ███████║██████╔╝██║     ███████║    ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
            ╚════██║██╔══╝  ██╔══██║██╔══██╗██║     ██╔══██║    ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
            ███████║███████╗██║  ██║██║  ██║╚██████╗██║  ██║    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
            ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                                                                   
*/

_gSearchtemMappingsArray
    VALUE_MAPPING(e_ITEM_Thug               , _SearchThug)
    VALUE_MAPPING(e_ITEM_Fridge             , _SearchFridge)
    VALUE_MAPPING(e_ITEM_Medicinecabinet    , _SearchMedicineCabinet)
    VALUE_MAPPING(e_ITEM_GunCabinet         , _SearchGunCabinet)
    VALUE_MAPPING(255             , _MessageNothingSpecial)   ; Default option


_SearchThug
.(
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_FRISKED_THE_THUG)
    JUMP_IF_TRUE(thug_disabled,CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED))
        ; If the thug was not disabled, attempting to search him will lead to the player immediate death
        SET_CUT_SCENE(1)
        DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(3,28),40,_SecondImageBuffer+40*100+19,_ImageBuffer+40*37+30)   ; Thug opening his eye
        DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(5,13),40,_SecondImageBuffer+40*59+14,_ImageBuffer+40*33+33)   ; Erase the Zzzz
        FADE_BUFFER
        CLEAR_TEXT_AREA(1)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il fallait d'abord le maitriser")
#else
        INFO_MESSAGE("You should have subdued him first")
#endif    
        WAIT(50*2)
        DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(4,33),40,_SecondImageBuffer+40*24+13,_ImageBuffer+(40*52)+31)      ; Erase the head of the sleeping thug
        DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(18,105),40,_SecondImageBuffer+40*23+22,_ImageBuffer+(40*21)+13)    ; Draw the attacking thug
        DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(13,56),40,_SecondImageBuffer+40*34+0,_ImageBuffer+(40*1)+23)       ; Now You Die!
        FADE_BUFFER
        PLAY_SOUND(_ShootData)
        ; Draw the message
        WAIT(50*2)                              ; Wait a couple seconds
        PLAY_SOUND(_ShootData)
        WHITE_BUBBLE(2)
        _BUBBLE_LINE(5,5,0,"This was a mistake:")
        _BUBBLE_LINE(60,16,0,"My last one")
        WAIT(50)                                        ; Wait a seconds
        LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
        WAIT(50*2)                                      ; Wait a couple seconds
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_SHOT_BY_THUG)    ; Achievement!
        GAME_OVER(e_SCORE_SHOT_BY_THUG)                 ; The game is now over
        JUMP(_gDescriptionGameOverLost)                 ; Game Over
        END

thug_disabled
    JUMP_IF_TRUE(found_items,CHECK_ITEM_LOCATION(e_ITEM_Pistol,e_LOC_NONE))
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Vous l'avez déjà fouillé")
#else    
    ERROR_MESSAGE("You've already frisked him")
#endif    
    END

found_items
    SET_ITEM_LOCATION(e_ITEM_Pistol,e_LOC_MASTERBEDROOM)
    SET_ITEM_LOCATION(e_ITEM_Keys,e_LOC_MASTERBEDROOM)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Vous avez trouvé quelque chose")
#else    
    INFO_MESSAGE("You found something interesting")
#endif    
    INCREASE_SCORE(POINTS_SEARCHED_THUG)
    END_AND_REFRESH
.)




/* MARK: Throw action ⚾

                ████████╗██╗  ██╗██████╗  ██████╗ ██╗    ██╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
                ╚══██╔══╝██║  ██║██╔══██╗██╔═══██╗██║    ██║    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
                   ██║   ███████║██████╔╝██║   ██║██║ █╗ ██║    ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
                   ██║   ██╔══██║██╔══██╗██║   ██║██║███╗██║    ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
                   ██║   ██║  ██║██║  ██║╚██████╔╝╚███╔███╔╝    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
                   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝     ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                                                                            
*/

_gThrowItemMappingsArray
    VALUE_MAPPING(e_ITEM_Bread              , _ThrowBread)
    VALUE_MAPPING(e_ITEM_Meat               , _ThrowMeat)
    VALUE_MAPPING(e_ITEM_SilverKnife        , _ThrowKnife)
    VALUE_MAPPING(e_ITEM_SnookerCue         , _ThrowSnookerCue)
    VALUE_MAPPING(e_ITEM_Rope               , _ThrowRope)
    VALUE_MAPPING(e_ITEM_LargeDove          , _FreeDove)
    VALUE_MAPPING(e_ITEM_FishingNet         , _ThrowNet)
    VALUE_MAPPING(255                       , _DropCurrentItem)  ; Default option

_ThrowBread
    // By default we just drop the bread where we are
    SET_ITEM_LOCATION(e_ITEM_Bread,e_LOC_CURRENT)
    GOSUB(BreadCommon)
    END_AND_REFRESH

_UseBread
    GOSUB(BreadCommon)
    JUMP(_ErrorCannotDo)

BreadCommon
.(
    JUMP_IF_FALSE(not_in_wooded_avenue,CHECK_PLAYER_LOCATION(e_LOC_WOODEDAVENUE))
give_bread_to_dove
    // The bird is now possible to catch
    SET_ITEM_LOCATION(e_ITEM_Bread,e_LOC_CURRENT)
    INCREASE_SCORE(POINTS_GAVE_BREAD_TO_DOVE)
    PLAY_SOUND(_Swoosh)
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"une _colombe qui picore")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"a _dove eating bread crumbs")
#endif    
//+_gSceneActionDoveEatingBread
    DISPLAY_IMAGE(LOADER_PICTURE_DOVE_EATING_BREADCRUMBS,"Birdy nam nam...")
#ifdef LANGUAGE_FR   
    INFO_MESSAGE("Elle est attrapable maintenant")
#else
    INFO_MESSAGE("Maybe I can catch it now?")
#endif    
    WAIT(50*2)
    END_AND_REFRESH

not_in_wooded_avenue
    RETURN
.)


_ThrowMeat
    // By default we just drop the meat where we are
    SET_ITEM_LOCATION(e_ITEM_Meat,e_LOC_CURRENT)
    GOSUB(MeatCommon)
    END_AND_REFRESH

_UseMeat
    GOSUB(MeatCommon)
    JUMP(_ErrorCannotDo)

MeatCommon
.(
    // The meat can only be eaten if we are in the Entrance Hall and the dog is still alive and kicking
    JUMP_IF_FALSE(nothing_to_eat_the_meat,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_TRUE(nothing_to_eat_the_meat,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
dog_eating_the_meat
    PLAY_SOUND(_Swoosh)
    DISPLAY_IMAGE(LOADER_PICTURE_DOG_EATING_MEAT,"Quite a hungry dog!")
    INFO_MESSAGE("Glad it's not me there!")
    SET_ITEM_LOCATION(e_ITEM_Meat,e_LOC_GONE_FOREVER)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DOG_ATE_THE_MEAT)
    WAIT(50*2)    
    JUMP_IF_FALSE(done,CHECK_ITEM_FLAG(e_ITEM_Meat,ITEM_FLAG_TRANSFORMED))  // Is the meat drugged?
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_DOG)
    INCREASE_SCORE(POINTS_DRUGGED_DOG)
    JUMP(_CommonDogDisabled)
done
    END_AND_REFRESH

nothing_to_eat_the_meat
    RETURN
 .)


_FreeDove
.(    
    CLEAR_TEXT_AREA(4)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("La comlombe s'échappe")                                         ; When left anywhere, the dove will manage to fly away
#else
    INFO_MESSAGE("The dove flies away")                                         ; When left anywhere, the dove will manage to fly away
#endif    
    SET_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_GONE_FOREVER)                 ; No mater where we use the DOVE, it will be out of the game definitely.
    // The dog will only chase the dove if the dog is where we are and is still alive and kicking
    JUMP_IF_FALSE(nothing_to_chase_the_dove,CHECK_ITEM_LOCATION(e_ITEM_Dog,e_LOC_CURRENT))
    JUMP_IF_TRUE(nothing_to_chase_the_dove,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
        DISPLAY_IMAGE(LOADER_PICTURE_DOG_CHASING_DOVE,"Run Forrest, Run!")      ; Show the picture with the dog running after the dove
        INFO_MESSAGE("Hopefully he will not catch the dove")
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_CHASED_THE_DOG)
        INCREASE_SCORE(POINTS_DOG_CHASED_DOVE)
        SET_ITEM_LOCATION(e_ITEM_Dog,e_LOC_GONE_FOREVER)           ; And the dog is now gone forever
        WAIT(50*2)    
nothing_to_chase_the_dove
    END_AND_REFRESH
 .)


_ThrowKnife
    // By default we just drop the knife where we are
    SET_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOC_CURRENT)
    GOSUB(KnifeCommon)
    END_AND_REFRESH

_UseKnife
    GOSUB(KnifeCommon)
    JUMP(_ErrorCannotDo)

KnifeCommon
.(
    // We only throw the knife if:
    // - We are in the entrance hall and the dog is still alive
    JUMP_IF_FALSE(dog_knife,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_TRUE(dog_knife,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
        SET_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOC_LARGE_STAIRCASE)
        PLAY_SOUND(_Swoosh)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_KILLED_THE_DOG)
        JUMP(_CommonDogDisabled)
dog_knife    

    // - We are in the sleeping room and the thug is still alive
    JUMP_IF_FALSE(thug_knife,CHECK_PLAYER_LOCATION(e_LOC_MASTERBEDROOM))
    JUMP_IF_TRUE(thug_knife,CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED))
        SET_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOC_MASTERBEDROOM)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_KILLED_THE_THUG)
        JUMP(_CommonThugDisabled)
thug_knife    

    // - We are in front of the panic room and the hole was made
    JUMP_IF_FALSE(acid_hole_knife,CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR))
    JUMP_IF_FALSE(acid_hole_knife,CHECK_ITEM_LOCATION(e_ITEM_HoleInDoor,e_LOC_PANIC_ROOM_DOOR))
        INCREASE_SCORE(POINTS_GAVE_KNIFE_TO_GIRL)
        JUMP(_CommonGaveTheKnifeToTheGirl)
acid_hole_knife    

    // - We are in the forest and assume the player want to scare the dove
    JUMP_IF_FALSE(dove_knife,CHECK_PLAYER_LOCATION(e_LOC_WOODEDAVENUE))
    JUMP_IF_FALSE(dove_knife,CHECK_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_WOODEDAVENUE))
        JUMP(_ScareDoveAway)

dove_knife    
    RETURN
.)


_ScareDoveAway
.(
    CLEAR_TEXT_AREA(5)
#ifdef LANGUAGE_FR   
    INFO_MESSAGE("La colombe s'envole effrayée")
#else    
    INFO_MESSAGE("You scared the dove away")
#endif    
    SET_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_GONE_FOREVER)
    END_AND_REFRESH
.)        




_ThrowNet
    // By default we just drop the knife where we are
    SET_ITEM_LOCATION(e_ITEM_FishingNet,e_LOC_CURRENT)
    GOSUB(NetCommon)
    END_AND_REFRESH

_UseNet
    GOSUB(NetCommon)
    JUMP(_ErrorCannotDo)

NetCommon
.(
    // We can use the net to trap the dove in the wooded avenue if she is on the ground eating the bred
    JUMP_IF_FALSE(dove_net,CHECK_PLAYER_LOCATION(e_LOC_WOODEDAVENUE))
    JUMP_IF_FALSE(dove_net,CHECK_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_WOODEDAVENUE))
    JUMP_IF_FALSE(dove_net,CHECK_ITEM_LOCATION(e_ITEM_Bread,e_LOC_WOODEDAVENUE))
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_CAPTURED_THE_DOVE)
        UNSET_ITEM_FLAGS(e_ITEM_LargeDove,ITEM_FLAG_IMMOVABLE)
        PLAY_SOUND(_Swoosh)
#ifdef LANGUAGE_FR   
        INFO_MESSAGE("La colombe est prise dans le filet")
        SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"une _colombe empêtrée")
#else    
        INFO_MESSAGE("The dove is caught in the net")
        SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"a stuck _dove")
#endif    
        END_AND_REFRESH
        
dove_net    
    RETURN
.)


_ThrowSnookerCue
    // By default we just drop the cue where we are
    SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOC_CURRENT)
    GOSUB(SnookerCueCommon)
    END_AND_REFRESH

_UseSnookerCue
    GOSUB(SnookerCueCommon)
    JUMP(_ErrorCannotDo)

SnookerCueCommon
.(
    // We only throw the snooker cue if:
    // - We are in the entrance hall and the dog is still alive
    JUMP_IF_FALSE(dog_snooker_cue,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_TRUE(dog_snooker_cue,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
        SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOC_LARGE_STAIRCASE)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_KILLED_THE_DOG)
        JUMP(_CommonDogDisabled)
dog_snooker_cue    

    // - We are in the sleeping room and the thug is still alive
    JUMP_IF_FALSE(thug_snooker_cue,CHECK_PLAYER_LOCATION(e_LOC_MASTERBEDROOM))
    JUMP_IF_TRUE(thug_snooker_cue,CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED))
        SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOC_MASTERBEDROOM)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_KILLED_THE_THUG)
        JUMP(_CommonThugDisabled)
thug_snooker_cue    

    // - We are in front of the panic room and the hole was made
    JUMP_IF_FALSE(acid_hole_cue,CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR))
    JUMP_IF_FALSE(acid_hole_cue,CHECK_ITEM_LOCATION(e_ITEM_HoleInDoor,e_LOC_PANIC_ROOM_DOOR))
        ; Check if the cue is already in the panic room
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_SnookerCue,ITEM_FLAG_IMMOVABLE),cue_in_the_room)
            ; If the cue is in the room, the only option is to break the window if it's open
            IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED),window_open)
                ; The window is open: Let's smash it with the cue
                GOSUB(_ShowOpenWindow)
                GOSUB(_ShowCueBreakingTheWindow)
                PLAY_SOUND(_Pling)
#ifdef LANGUAGE_FR
                INFO_MESSAGE("La queue brise la vitre")
#else
                INFO_MESSAGE("The cue smashes the window")
#endif    
                GOSUB(_ShowBrokenWindow)
                SET_ITEM_FLAGS(e_ITEM_PanicRoomWindow,ITEM_FLAG_DISABLED)   ; The window is now broken
                SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOC_GONE_FOREVER)     ; We don't need the cue anymore
                INCREASE_SCORE(POINTS_SMASHED_WINDOW_WITH_CUE)
            ELSE(window_open,window_closed)
                ; The window is closed
#ifdef LANGUAGE_FR       
                ERROR_MESSAGE("La fenêtre est toujours fermée!")
#else
                ERROR_MESSAGE("Should probably open the window first!")
#endif       
            ENDIF(window_closed)
        ELSE(cue_in_the_room,cue_not_in_the_room)
            ; If the cue is not in the room, we pass it to the girl through the hole
            SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOC_CURRENT)    
            SET_ITEM_FLAGS(e_ITEM_SnookerCue,ITEM_FLAG_IMMOVABLE)
#ifdef LANGUAGE_FR       
            SET_ITEM_DESCRIPTION(e_ITEM_SnookerCue,"une _queue de billard dans la chambre forte")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_SnookerCue,"a snooker _cue in the panic room")
#endif       
            DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_HOLE,"")     ; Draw the base image with the hole over an empty room
            IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_YoungGirl,ITEM_FLAG_DISABLED),girl_restrained)
                BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_ATTACHED,17,76,17)    ; Draw the patch with the girl restrained on the floor 
                        _IMAGE_STRIDE(0,0,17)
                        _BUFFER(10,26)
            ELSE(girl_restrained,girl_freed)
                BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_FREE,14,92,17)    ; Draw the patch with the girl sitting on the floor 
                        _IMAGE_STRIDE(0,0,17)
                        _BUFFER(12,16)
            ENDIF(girl_freed)
            FADE_BUFFER

            BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_CUE,14,111,14)    ; Draw the patch with the cue through the hole
                    _IMAGE_STRIDE(0,0,14)
                    _BUFFER(12,17)
            FADE_BUFFER      ; Make sure everything appears on the screen
            WAIT(50*2)
        ENDIF(cue_not_in_the_room)
        END_AND_REFRESH

acid_hole_cue
    RETURN
.)


_CommonDogDisabled
.(
    INCREASE_SCORE(POINTS_DISABLED_DOG)
    SET_ITEM_FLAGS(e_ITEM_Dog,ITEM_FLAG_DISABLED)
+_gTextDogLying = *+2
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Dog,"un _chien immobile")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Dog,"a _dog lying")
#endif
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    WAIT(50*2)
    STOP_MUSIC()
    END_AND_REFRESH
.)


_CommonThugDisabled
.(
    INCREASE_SCORE(POINTS_DISABLED_THUG)
    SET_ITEM_FLAGS(e_ITEM_Thug,ITEM_FLAG_DISABLED)
+_gTextDeadThug = *+2
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Thug,"un _voyou hors d'état de nuire")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Thug,"an unresponsive _thug")
#endif    
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    WAIT(50*2)
    STOP_MUSIC()
    END_AND_REFRESH
.)


_CommonGaveTheKnifeToTheGirl
.(
    SET_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOC_HOSTAGE_ROOM)

    ; Draw the picture with the attached girl
    GOSUB(_ShowGirlInRoomWithBindings)

    BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_KNIFE,20,111,20)    ; Draw the patch with the knife through the hole
            _IMAGE(0,0)
            _BUFFER(10,17)
    FADE_BUFFER      ; Make sure everything appears on the screen
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Le couteau passe par le trou...")
#else
    INFO_MESSAGE("The knife fits the hole...")
#endif    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_GAVE_THE_KNIFE)
    UNSET_ITEM_FLAGS(e_ITEM_YoungGirl,ITEM_FLAG_DISABLED)
    WAIT(50*2)

    ; Draw the picture with the girl without her bindings
    GOSUB(_ShowGirlInRoomWithoutBindings)

    END_AND_REFRESH
.)



/* MARK: Take Item 🛄

████████╗ █████╗ ██╗  ██╗███████╗    ██╗████████╗███████╗███╗   ███╗
╚══██╔══╝██╔══██╗██║ ██╔╝██╔════╝    ██║╚══██╔══╝██╔════╝████╗ ████║
   ██║   ███████║█████╔╝ █████╗      ██║   ██║   █████╗  ██╔████╔██║
   ██║   ██╔══██║██╔═██╗ ██╔══╝      ██║   ██║   ██╔══╝  ██║╚██╔╝██║
   ██║   ██║  ██║██║  ██╗███████╗    ██║   ██║   ███████╗██║ ╚═╝ ██║
   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝   ╚═╝   ╚══════╝╚═╝     ╚═╝ */

_gTakeItemMappingsArray
    VALUE_MAPPING(e_ITEM_Rope              , _TakeRope)
    VALUE_MAPPING(e_ITEM_Ladder            , _TakeLadder)
    VALUE_MAPPING(e_ITEM_LargeDove         , _TakeDove)
    VALUE_MAPPING(e_ITEM_Bread             , _TakeBread)
    VALUE_MAPPING(e_ITEM_BlackTape         , _TakeBlackTape)
    VALUE_MAPPING(e_ITEM_Acid              , _TakeAcid)
    VALUE_MAPPING(e_ITEM_ProtectionSuit    , _TakeProtectionSuit)
    VALUE_MAPPING(e_ITEM_Hose              , _TakeHose)
    VALUE_MAPPING(255                      , _TakeCommon)     ; Default option


_TakeRope
.(
+_gTextItemRope = *+2
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"une longueur de _corde")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"a length of _rope")
#endif    
    JUMP(_TakeCommon)
.)


_TakeLadder
.(
+_gTextItemLadder = *+2
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"une _échelle courte")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"a short _ladder")
#endif    
    JUMP(_TakeCommon)
.)


_TakeDove
.(
+_gTextItemLargeDove = *+2
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"une _colombe")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"a _dove")
#endif    
    JUMP(_TakeCommon)
.)


_TakeBread
.(
    JUMP_IF_FALSE(take_bread,CHECK_PLAYER_LOCATION(e_LOC_WOODEDAVENUE))
    JUMP_IF_FALSE(take_bread,CHECK_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_WOODEDAVENUE))
        JUMP(_ScareDoveAway)
take_bread    
    JUMP(_TakeCommon)
.)


_TakeBlackTape
.(
    CLEAR_TEXT_AREA(4)
    SET_ITEM_LOCATION(e_ITEM_BlackTape, e_LOC_GONE_FOREVER)  ; The black tape cannot be reused
#ifdef LANGUAGE_FR   
    INFO_MESSAGE("Le ruban n'est pas réutilisable")
    SET_ITEM_DESCRIPTION(e_ITEM_BasementWindow,"une _fenêtre")
#else    
    INFO_MESSAGE("The tape cannot be reused")
    SET_ITEM_DESCRIPTION(e_ITEM_BasementWindow,"a _window")
#endif    
    WAIT(50)
    END_AND_REFRESH
.)

_TakeAcid
.(
    DISPLAY_IMAGE(LOADER_PICTURE_CORROSIVE_LIQUID,"ACME XX121 Acid")
    INFO_MESSAGE("This stuff is highly dangerous!")
    WAIT(50*2)
    INFO_MESSAGE("...could go through a ship's hull!")
    WAIT(50*2)

    JUMP(_TakeCommon)
.)


_TakeProtectionSuit
.(
    GOSUB(_ShowProtectionSuit)
    JUMP(_TakeCommon)
.)


_TakeHose
.(
+_gTextItemHose = *+2
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"un _tuyau d'arrosage")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"a garden _hose")
#endif    
    JUMP(_TakeCommon)
.)



_TakeCommon
.(
    SET_ITEM_LOCATION(e_ITEM_CURRENT, e_LOC_INVENTORY)  ; The item is now in our inventory
    UNSET_ITEM_FLAGS(e_ITEM_CURRENT, ITEM_FLAG_ATTACHED)     ; If the item was attached, we detach it
    END_AND_REFRESH
.)




_ShowProtectionSuit
.(
    DISPLAY_IMAGE(LOADER_PICTURE_PROTECTION_SUIT,"PRO-TEC Personal Protection Equipment")
    INFO_MESSAGE("Protection against pesticides...")
    WAIT(50*2)
    INFO_MESSAGE("...and other types of noxious fumes")
    WAIT(50*2)
    RETURN
.)




/* MARK: Drop Action 💧

 .S_sSSs     .S_sSSs      sSSs_sSSs     .S_sSSs           .S_SSSs      sSSs  sdSS_SSSSSSbs   .S    sSSs_sSSs     .S_sSSs    
.SS~YS%%b   .SS~YS%%b    d%%SP~YS%%b   .SS~YS%%b         .SS~SSSSS    d%%SP  YSSS~S%SSSSSP  .SS   d%%SP~YS%%b   .SS~YS%%b   
S%S   `S%b  S%S   `S%b  d%S'     `S%b  S%S   `S%b        S%S   SSSS  d%S'         S%S       S%S  d%S'     `S%b  S%S   `S%b  
S%S    S%S  S%S    S%S  S%S       S%S  S%S    S%S        S%S    S%S  S%S          S%S       S%S  S%S       S%S  S%S    S%S  
S%S    S&S  S%S    d*S  S&S       S&S  S%S    d*S        S%S SSSS%S  S&S          S&S       S&S  S&S       S&S  S%S    S&S  
S&S    S&S  S&S   .S*S  S&S       S&S  S&S   .S*S        S&S  SSS%S  S&S          S&S       S&S  S&S       S&S  S&S    S&S  
S&S    S&S  S&S_sdSSS   S&S       S&S  S&S_sdSSS         S&S    S&S  S&S          S&S       S&S  S&S       S&S  S&S    S&S  
S&S    S&S  S&S~YSY%b   S&S       S&S  S&S~YSSY          S&S    S&S  S&S          S&S       S&S  S&S       S&S  S&S    S&S  
S*S    d*S  S*S   `S%b  S*b       d*S  S*S               S*S    S&S  S*b          S*S       S*S  S*b       d*S  S*S    S*S  
S*S   .S*S  S*S    S%S  S*S.     .S*S  S*S               S*S    S*S  S*S.         S*S       S*S  S*S.     .S*S  S*S    S*S  
S*S_sdSSS   S*S    S&S   SSSbs_sdSSS   S*S               S*S    S*S   SSSbs       S*S       S*S   SSSbs_sdSSS   S*S    S*S  
SSS~YSSY    S*S    SSS    YSSP~YSSY    S*S               SSS    S*S    YSSP       S*S       S*S    YSSP~YSSY    S*S    SSS  
            SP                         SP                       SP                SP        SP                  SP          
            Y                          Y                        Y                 Y         Y                   Y           */

_gDropItemMappingsArray
    VALUE_MAPPING(e_ITEM_Water          , _DropWater)
    VALUE_MAPPING(e_ITEM_Petrol         , _DropPetrol)
    VALUE_MAPPING(e_ITEM_LargeDove      , _FreeDove)
    VALUE_MAPPING(255                   , _DropCurrentItem)  ; Default option


_DropWater
.(
    SET_ITEM_LOCATION(e_ITEM_Water,e_LOC_WELL)             ; Put back the water into the well
#ifdef LANGUAGE_FR   
    INFO_MESSAGE("L'eau s'écoule")
#else
    INFO_MESSAGE("The water drains away")
#endif    
    END_AND_REFRESH
.)


_DropPetrol
.(
    SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_NONE)             ; The petrol goes back to the car, or maybe vanishes, need to see what's best
#ifdef LANGUAGE_FR   
    INFO_MESSAGE("Le pétrole s'évapore")
#else
    INFO_MESSAGE("The petrol evaporates")
#endif    
    END_AND_REFRESH
.)


_DropCurrentItem
.(
    SET_ITEM_LOCATION(e_ITEM_CURRENT,e_LOC_CURRENT)
    END_AND_REFRESH
.)


_gDoNothingScript
.(
    END
.)


/* MARK: Misc Stuff
*/
_SpawnWaterIfNotEquipped
.(
    IF_FALSE(CHECK_ITEM_LOCATION(e_ITEM_Water,e_LOC_INVENTORY),water)
        SET_ITEM_LOCATION(e_ITEM_Water,e_LOC_CURRENT)                    ; It's now visible at the curent location
    ENDIF(water)
    RETURN
.)


/* MARK: Generic Answers ⚠

      ::::::::  :::::::::: ::::    ::: :::::::::: :::::::::  ::::::::::: ::::::::              :::     ::::    :::  ::::::::  :::       ::: :::::::::: :::::::::   :::::::: 
    :+:    :+: :+:        :+:+:   :+: :+:        :+:    :+:     :+:    :+:    :+:           :+: :+:   :+:+:   :+: :+:    :+: :+:       :+: :+:        :+:    :+: :+:    :+: 
   +:+        +:+        :+:+:+  +:+ +:+        +:+    +:+     +:+    +:+                 +:+   +:+  :+:+:+  +:+ +:+        +:+       +:+ +:+        +:+    +:+ +:+         
  :#:        +#++:++#   +#+ +:+ +#+ +#++:++#   +#++:++#:      +#+    +#+                +#++:++#++: +#+ +:+ +#+ +#++:++#++ +#+  +:+  +#+ +#++:++#   +#++:++#:  +#++:++#++   
 +#+   +#+# +#+        +#+  +#+#+# +#+        +#+    +#+     +#+    +#+                +#+     +#+ +#+  +#+#+#        +#+ +#+ +#+#+ +#+ +#+        +#+    +#+        +#+    
#+#    #+# #+#        #+#   #+#+# #+#        #+#    #+#     #+#    #+#    #+#         #+#     #+# #+#   #+#+# #+#    #+#  #+#+# #+#+#  #+#        #+#    #+# #+#    #+#     
########  ########## ###    #### ########## ###    ### ########### ########          ###     ### ###    ####  ########    ###   ###   ########## ###    ###  ########   */              

_ErrorCannotDo
.(
+_gTextErrorCannotDo = *+1    
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Je ne peux pas le faire")
#else
    ERROR_MESSAGE("I can't do that")
#endif    
    END_AND_REFRESH
.)


_ErrorCannotRead
.(
//+_gTextErrorCannotRead = *+1    
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Je ne peux pas lire ca")
#else
    ERROR_MESSAGE("I can't read that")
#endif    
    END_AND_REFRESH
.)

_MessageNothingSpecial
.(
//+gTextErrorNothingSpecial = *+1    
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Rien de spécial")
#else
    ERROR_MESSAGE("Nothing special")
#endif    
    END_AND_REFRESH
.)


; This is a script that is run before the setup of a scene is done.
; In the current status it is used to get the girl to follow us
_LoadSceneScript
.(
    ; If the girl is "attached" we move her to the playe current location
    JUMP_IF_FALSE(end_girl_following,CHECK_ITEM_FLAG(e_ITEM_YoungGirl,ITEM_FLAG_ATTACHED))
        SET_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_CURRENT)
end_girl_following
    END
.)


; Animated sequence where the digital watch is set to have an alarm in two hours
_WatchSetup
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_WATCH_ALARM,"Let see...")       ; The watch is shown with 0:00:00 as a base image
    FADE_BUFFER
    WAIT(50)

    PLAY_SOUND(_WatchButtonPress)                                       ; Play the "button pressed" sound
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,9)                                 ; Overlay the 1 hours patch
            _IMAGE(24,43)
            _SCREEN(17,63)
    INFO_MESSAGE("I only have two hours...")

    PLAY_SOUND(_WatchButtonPress)                                       ; Play the "button pressed" sound
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,9)                                 ; Overlay the 2 hours patch
            _IMAGE(24,34)
            _SCREEN(17,63)
    INFO_MESSAGE("...make them count!")

    WAIT(50*2)

    PLAY_SOUND(_WatchButtonPress)                                       ; Play the "button pressed" sound
    WAIT(50)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,6,9)                                 ; Overlay the 1:59:59 patch
            _IMAGE(24,43)
            _SCREEN(17,63)
    WAIT(50)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,2,9)                                 ; Overlay the :58 patch
            _IMAGE(28,34)
            _SCREEN(21,63)
    WAIT(50)
    RETURN
.)


; Half-way display, when one hour has elapsed, to remind the player they need to speed up
_OneHourAlarmWarning
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_WATCH_ALARM,"Let see...")       ; The watch is shown with 0:00:00 as a base image
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,9)                                 ; Overlay the 1 hours patch
            _IMAGE(24,43)
            _BUFFER(17,63)
    FADE_BUFFER
    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    DRAW_BITMAP(LOADER_SPRITE_BEEP,BLOCK_SIZE(12,38),12,_SecondImageBuffer,$a000+(40*10)+27)        // Beep!

    CLEAR_TEXT_AREA(5)                                                  ; MAGENTA background
    INFO_MESSAGE("Already one hour has passed!")
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,9)                                 ; Overlay the 0 patch on the hour
            _IMAGE(24,52)
            _SCREEN(17,63)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,5,9)                                 ; Overlay the 59:59 patch
            _IMAGE(25,43)
            _SCREEN(18,63)
    CLEAR_TEXT_AREA(5)                                                  ; MAGENTA background
    INFO_MESSAGE("I need to hurry up!")

    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    DRAW_BITMAP(LOADER_SPRITE_BEEP,BLOCK_SIZE(12,38),12,_SecondImageBuffer,$a000+(40*81)+3)        // Beep!
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,2,9)                                 ; Overlay the :58 patch
            _IMAGE(28,34)
            _SCREEN(21,63)

    WAIT(50)
    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound

    END_AND_REFRESH
.)


; Time out, you lost!
_TimeOutGameOver
.(
    SET_CUT_SCENE(1)
    DISPLAY_IMAGE(LOADER_PICTURE_WATCH_ALARM,"Beep! Beep! Beep!")

    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    DRAW_BITMAP(LOADER_SPRITE_BEEP,BLOCK_SIZE(12,38),12,_SecondImageBuffer,$a000+(40*10)+27)        // Beep!
    CLEAR_TEXT_AREA(1)                                                  ; RED background
    INFO_MESSAGE("I was too slow...")

    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    DRAW_BITMAP(LOADER_SPRITE_BEEP,BLOCK_SIZE(12,38),12,_SecondImageBuffer,$a000+(40*81)+3)        // Beep!
    CLEAR_TEXT_AREA(1)                                                  ; RED background
    INFO_MESSAGE("...I have to abort the mission")
    WAIT(50)
    LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
    WAIT(50*2)

    GAME_OVER(e_SCORE_RAN_OUT_OF_TIME)      ; The game is now over
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_RAN_OUT_OF_TIME)
    JUMP(_gDescriptionGameOverLost)         ; Game Over
.)

_EndSceneActions


; The player can pause the game, the first time they get a 10 point penalty, then 50, 100, 500, 1000
; After that pauses are free!
_PauseGameScript
.(
    SET_CUT_SCENE(1)
    STOP_CLOCK
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_PAUSED_THE_GAME)
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_WATCH_ALARM,"GAME PAUSED - PRESS A KEY TO CONTINUE")
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,6,9)                                 ; Overlay the PAUSE patch
            _IMAGE(24,61)
            _BUFFER(17,63)
    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    FADE_BUFFER
    DO_ONCE(free_pause_message)
        CLEAR_TEXT_AREA(5)                                                  ; Magenta background
#ifdef LANGUAGE_FR
        INFO_MESSAGE("La première pause est gratuite !")
#else
        INFO_MESSAGE("The first pause is free!")
#endif    
        JUMP(_Unpause)
    ENDDO(free_pause_message)
    DO_ONCE(first_pause)
        JUMP(_UnpauseMinus10)
    ENDDO(first_pause)
    DO_ONCE(second_pause)
        JUMP(_UnpauseMinus50)
    ENDDO(second_pause)
    DO_ONCE(third_pause)
        JUMP(_UnpauseMinus100)
    ENDDO(third_pause)
    DO_ONCE(fourth_pause)
        JUMP(_UnpauseMinus500)
    ENDDO(fourth_pause)
    DO_ONCE(fifth_pause)
        JUMP(_UnpauseMinus1000)
    ENDDO(fifth_pause)
    DO_ONCE(unlimited_pauses)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_PAUSES_UNLIMITED)
        CLEAR_TEXT_AREA(2)                                               ; GREEN background
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Ok, ok, j'ai compris...")
#else
        INFO_MESSAGE("Ok, I give up, have it your way!")
#endif    
    ENDDO(unlimited_pauses)
    JUMP(_Unpause)

_UnpauseMinus1000
    DECREASE_SCORE(1000)
_UnpauseMinus500
    DECREASE_SCORE(500)
_UnpauseMinus100
    DECREASE_SCORE(100)
_UnpauseMinus50
    DECREASE_SCORE(50)
_UnpauseMinus10
    DECREASE_SCORE(10)
    CLEAR_TEXT_AREA(1)                                                  ; RED background
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Les pauses suivantes coutent !")
#else
    INFO_MESSAGE("Now pausing costs you points!")
#endif    
_Unpause
    WAIT_KEYPRESS
    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    START_CLOCK
    SET_CUT_SCENE(0)
    END_AND_REFRESH
.)    

_EndGameTextData

;
; Print statistics about the size of things
;
#if DISPLAYINFO=1
#print Total size of game text content = (_EndGameTextData - _StartGameTextData)
#print - Messages and prompts = (_EndMessagesAndPrompts - _StartMessagesAndPrompts)
#print - Error messages = (_EndErrorMessages - _StartErrorMessages)
#print - Item names = (_EndItemNames - _StartItemNames)
#print - Scene scripts = (_EndSceneScripts - _StartSceneScripts)
#print - Scene actions = (_EndSceneActions - _StartSceneActions)
#endif

