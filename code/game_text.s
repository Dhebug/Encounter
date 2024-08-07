
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
#else
_gTextAskInput              .byt "What are you going to do now?",0
_gTextNothingHere           .byt "There is nothing of interest here",0
_gTextCanSee                .byt "I can see ",0
_gTextScore                 .byt "Score:",0
_gTextCarryInWhat           .byt "Carry it in what?",0
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
_gTextErrorItemNotPresent   .byt "Cet objet n'est pas présent",0
#else
_gTextErrorInvalidDirection .byt "Impossible to move in that direction",0
_gTextErrorCantTakeNoSee    .byt "You can only take something you see",0
_gTextErrorAlreadyHaveItem  .byt "You already have this item",0
_gTextErrorRidiculous       .byt "Don't be ridiculous",0
_gTextErrorAlreadyFull      .byt "Sorry, that's full already",0
_gTextErrorMissingContainer .byt "You don't have this container",0
_gTextErrorDropNotHave      .byt "You can only drop something you have",0
_gTextErrorUnknownItem      .byt "I do not know what this item is",0
_gTextErrorItemNotPresent   .byt "Can't see it here",0
#endif
_EndErrorMessages


/* MARK: Location Descriptions

██╗      ██████╗  ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗    ██████╗ ███████╗███████╗ ██████╗██████╗ ██╗██████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
██║     ██╔═══██╗██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║    ██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
██║     ██║   ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║    ██║  ██║█████╗  ███████╗██║     ██████╔╝██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║███████╗
██║     ██║   ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║    ██║  ██║██╔══╝  ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║╚════██║
███████╗╚██████╔╝╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║    ██████╔╝███████╗███████║╚██████╗██║  ██║██║██║        ██║   ██║╚██████╔╝██║ ╚████║███████║
╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═════╝ ╚══════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
                                                                                                                                                              
*/
_StartLocationNames
#ifdef LANGUAGE_FR
//                                      0         1         2         3
//                                      0123456789012345678901234567890123456789

_gTextLocationGirlRoomOpenned     .byt "La pièce avec la fille (ouverte)",0
#else

_gTextLocationGirlRoomOpenned     .byt "The girl room (openned lock)",0
#endif
_EndLocationNames


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
//_gTextItemAlarmSwitch             .byt "un bouton en position marche",0
_gTextItemOpenPanel               .byt "un _paneau mural ouvert",0
_gTextItemSmallHoleInDoor         .byt "un petit _trou dans la porte",0
_gTextItemTwine                   .byt "un peu de _ficelle",0
_gTextItemSilverKnife             .byt "un _couteau en argent",0
_gTextItemMixTape                 .byt "une _compil sur K7",0
_gTextItemAlsatianDog             .byt "un alsacien qui grogne",0
_gTextItemMeat                    .byt "un morceau de _viande",0
_gTextItemBread                   .byt "du _pain complet",0
_gTextItemRollOfTape              .byt "un rouleau de _bande adhésive",0
_gTextItemChemistryBook           .byt "un _livre de chimie",0
_gTextItemBoxOfMatches            .byt "une boite d'_allumettes",0
_gTextItemSnookerCue              .byt "une _queue de billard",0
_gTextItemThug                    .byt "un _voyou endormi sur le lit",0
_gTextItemHeavySafe               .byt "un gros _coffre fort",0
_gTextItemHandWrittenNote         .byt "une _note manuscripte",0
_gTextItemRopeHangingFromWindow   .byt "une _corde qui pend de la fenêtre",0
_gTextItemRollOfToiletPaper       .byt "un _rouleau de PQ",0
_gTextItemHose                    .byt "un _tuyau d'arrosage",0
_gTextItemOpenSafe                .byt "un _coffre fort ouvert",0
_gTextItemBrokenGlass             .byt "des morceaux de _glace",0
_gTextItemAcidBurn                .byt "une brulure d'acide",0
_gTextItemYoungGirl               .byt "une jeune fille",0
_gTextItemFuse                    .byt "une _mêche",0
_gTextItemPowderMix               .byt "un _mix grumeleux",0
_gTextItemGunPowder               .byt "de la _poudre à cannon",0
_gTextItemKeys                    .byt "un jeu de _clefs",0
_gTextItemNewspaper               .byt "un _journal",0
_gTextItemBomb                    .byt "une _bombe",0
_gTextItemPistol                  .byt "un _pistolet",0
_gTextItemBullets                 .byt "trois _balles de calibre .38",0
_gTextItemYoungGirlOnFloor        .byt "une jeune _fille attachée au sol",0
_gTextItemChemistryRecipes        .byt "des _formules de chimie",0
_gTextItemUnitedKingdomMap        .byt "une _carte du royaume uni",0
_gTextItemHandheldGame            .byt "un _jeu portable",0
_gTextItemSedativePills           .byt "des _somnifères",0
_gTextItemDartGun                 .byt "un _lance fléchettes",0
_gTextItemBlackTape               .byt "du _ruban adhésif noir",0
_gTextItemMortarAndPestle         .byt "un mortier et pilon",0
_gTextItemAdhesive                .byt "de l'_adhésif",0
_gTextItemAcid                    .byt "un _acide puissant",0
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
//_gTextItemAlarmSwitch             .byt "a button in ON position",0
_gTextItemOpenPanel               .byt "an open _panel on wall",0              
_gTextItemSmallHoleInDoor         .byt "a small _hole in the door",0           
_gTextItemTwine                   .byt "some _twine",0                         
_gTextItemSilverKnife             .byt "a silver _knife",0                     
_gTextItemMixTape                 .byt "a _mixtape",0
_gTextItemAlsatianDog             .byt "an alsatian growling at you",0        
_gTextItemMeat                    .byt "a joint of _meat",0                    
_gTextItemBread                   .byt "some brown _bread",0                   
_gTextItemRollOfTape              .byt "a roll of sticky _tape",0              
_gTextItemChemistryBook           .byt "a chemistry _book",0                   
_gTextItemBoxOfMatches            .byt "a box of _matches",0                   
_gTextItemSnookerCue              .byt "a snooker _cue",0                      
_gTextItemThug                    .byt "a _thug asleep on the bed",0           
_gTextItemHeavySafe               .byt "a heavy _safe",0                       
_gTextItemHandWrittenNote         .byt "a hand written _note",0                     
_gTextItemRopeHangingFromWindow   .byt "a _rope hangs from the window",0       
_gTextItemRollOfToiletPaper       .byt "a toilet _roll",0            
_gTextItemHose                    .byt "a garden _hose",0                        
_gTextItemOpenSafe                .byt "an open _safe",0                       
_gTextItemBrokenGlass             .byt "broken glass",0                       
_gTextItemAcidBurn                .byt "an acid burn",0                       
_gTextItemYoungGirl               .byt "a young girl",0                        
_gTextItemFuse                    .byt "a _fuse",0                             
_gTextItemPowderMix               .byt "a rough powder _mix",0
_gTextItemGunPowder               .byt "some _gunpowder",0
_gTextItemKeys                    .byt "a set of _keys",0                      
_gTextItemNewspaper               .byt "a _newspaper",0                        
_gTextItemBomb                    .byt "a _bomb",0                             
_gTextItemPistol                  .byt "a _pistol",0                           
_gTextItemBullets                 .byt "three .38 _bullets",0                  
_gTextItemYoungGirlOnFloor        .byt "a young girl tied up on the floor",0  
_gTextItemChemistryRecipes        .byt "a couple chemistry _recipes",0         
_gTextItemUnitedKingdomMap        .byt "a _map of the United Kingdom",0        
_gTextItemHandheldGame            .byt "a handheld _game",0
_gTextItemSedativePills           .byt "some sedative _pills",0
_gTextItemDartGun                 .byt "a dart _gun",0
_gTextItemBlackTape               .byt "some black adhesive _tape",0
_gTextItemMortarAndPestle         .byt "a _mortar and pestle",0
_gTextItemAdhesive                .byt "some _adhesive",0
_gTextItemAcid                    .byt "some strong _acid",0
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
    END


// MARK: Market Place
_gDescriptionMarketPlace
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur la place du marché")
#else
    SET_DESCRIPTION("You are in a deserted market square")
#endif    

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(4,100,0,"La place du marché")
    _BUBBLE_LINE(4,106,4,"est désertée")
#else
    _BUBBLE_LINE(4,100,0,"The market place")
    _BUBBLE_LINE(4,106,4,"is deserted")
#endif    

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
    _BUBBLE_LINE(145,90,0,"Rats, graffittis,")
    _BUBBLE_LINE(160,103,0,"et seringues.")
#else
    _BUBBLE_LINE(153,85,0,"Rats, graffitti,")
    _BUBBLE_LINE(136,98,0,"and used syringes.")
#endif    
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
    JUMP(digging_for_gold);            ; Generic message if the ladder or rope are not present

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
    END


// MARK: Wooded Avenue
_gDescriptionWoodedAvenue
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
    END


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
    _BUBBLE_LINE(4,4,0,"A Japanese Zen Garden?")
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
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans une petite serre")
#else
    SET_DESCRIPTION("You are in a small greenhouse")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(4,5,0,"Evidemment pour")
    .byt 4,17,0,34,"Usage thérapeutique",34,0
#else
    _BUBBLE_LINE(4,96,0,"Obviously for")
    .byt 4,107,1,34,"Therapeutic use",34,0
#endif
    END


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
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes près d'un bac a poisson")
#else
    SET_DESCRIPTION("You are standing by a fish pond")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(5,5,0,"Certains de ces poissons")
    _BUBBLE_LINE(5,17,0,"sont étonnamment gros")
#else    
    _BUBBLE_LINE(5,5,0,"Some of these fishes")
    _BUBBLE_LINE(5,17,0,"are surprinsingly big")
#endif    
    END


// MARK: Tiled Patio
_gDescriptionTiledPatio
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes sur un patio carellé")
#else
    SET_DESCRIPTION("You are on a tiled patio")
#endif    
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
    END


// MARK: Entrance Hall
_gDescriptionEntranceHall
.(
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Vous êtes dans un hall imposant")
#else
    SET_DESCRIPTION("You are in an imposing entrance hall")
#endif    
    ; If the dog is in the staircase, we move it to the entrance hall to simplify the rest of the code
    JUMP_IF_FALSE(end_dog_check,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOC_LARGE_STAIRCASE))
    SET_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOC_ENTRANCEHALL)
end_dog_check

    ; Is there a dog in the entrance
    JUMP_IF_FALSE(end_dog,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOC_ENTRANCEHALL))

    ; Is the dog dead?
    JUMP_IF_FALSE(dog_alive,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
      ; Draw the dead dog
      DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(6,12),40,_SecondImageBuffer+40*24+7,_ImageBuffer+(40*44)+18)    
      ; Text describing the dead dog
      WAIT(DELAY_FIRST_BUBBLE)
      WHITE_BUBBLE(2)
      _BUBBLE_LINE(5,5,0,"Let's call that a ")
      .byt 5,17,0,"Collateral Damage",34,0
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
    SET_DESCRIPTION("An impressive entrance door")
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
    JUMP_IF_FALSE(end_dog_check,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOC_ENTRANCEHALL))
    SET_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOC_LARGE_STAIRCASE)
end_dog_check

    ; Is there a dog in the entrance
    JUMP_IF_FALSE(end_dog,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOC_LARGE_STAIRCASE))

    ; Is the dog dead?
    JUMP_IF_FALSE(dog_alive,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
      ; Draw the dead dog
      DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(17,34),40,_SecondImageBuffer+40*95,_ImageBuffer+(40*93)+12)    
      ; Text describing the dead dog
      WAIT(DELAY_FIRST_BUBBLE)
      WHITE_BUBBLE(2)
      _BUBBLE_LINE(5,5,0,"Let's call that a ")
      .byt 5,17,0,"Collateral Damage",34,0
      END
      
dog_alive
    ; If the dog is alive, it will jump on our face now
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(21,128),40,_SecondImageBuffer+19,_ImageBuffer+(40*0)+10)    ; Draw the attacking dog     
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
    _BUBBLE_LINE(5,48,0,"Either they love dark")
    _BUBBLE_LINE(12,68,0,"or they forgot to")
    _BUBBLE_LINE(37,88,0,"pay their")
#endif
    WHITE_BUBBLE(1)
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
        SET_ITEM_LOCATION(e_ITEM_Acid,e_LOC_CURRENT)                 ; The acid is now visible
        UNSET_ITEM_FLAGS(e_ITEM_BoxOfMatches,ITEM_FLAG_TRANSFORMED); ; Un-strike the matches (just so the test above does not trigger a second time)
        UNSET_ITEM_FLAGS(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED)          ; The safe is now open

#ifdef LANGUAGE_FR                                                   ; Rename the safe to "an open safe"
        SET_ITEM_DESCRIPTION(e_ITEM_HeavySafe,"un _coffre ouvert")
#else    
        SET_ITEM_DESCRIPTION(e_ITEM_HeavySafe,"a open _safe")
#endif    

        //DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_WITH_BOMB,"Ready to blow!")
        CLEAR_TEXT_AREA(1)
        INFO_MESSAGE("I should go somewhere safe")

        WAIT(50*2)

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the bomb attached to the closed door
                _IMAGE(8+3*1,67)
                _SCREEN(30,43)

        WAIT(50)

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the bomb attached to the closed door
                _IMAGE(8+3*2,67)
                _SCREEN(30,43)

        WAIT(50)

        CLEAR_TEXT_AREA(5)
        INFO_MESSAGE("Hello?")

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the bomb attached to the closed door
                _IMAGE(8+3*3,67)
                _SCREEN(30,43)

        WAIT(50)

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the bomb attached to the closed door
                _IMAGE(8+3*4,67)
                _SCREEN(30,43)

        WAIT(50)

        CLEAR_TEXT_AREA(4)
        INFO_MESSAGE("Still there?")

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the bomb attached to the closed door
                _IMAGE(8+3*5,67)
                _SCREEN(30,43)

        WAIT(50)

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the bomb attached to the closed door
                _IMAGE(8+3*6,67)
                _SCREEN(30,43)

        WAIT(50)

        DISPLAY_IMAGE(LOADER_PICTURE_EXPLOSION,"KA BOOM!")
        CLEAR_TEXT_AREA(1)
        INFO_MESSAGE("Well... I warned you, didn't I?")

        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_BLOWN_INTO_BITS)             ; Achievement!
        GAME_OVER(e_SCORE_FELL_INTO_PIT)                            ; The game is now over

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
        SET_ITEM_DESCRIPTION(e_ITEM_BasementWindow,"une _fenêtre")
#else
        SET_DESCRIPTION("The room gets light from the window")
#endif    
        SET_ITEM_LOCATION(e_ITEM_AlarmPanel,e_LOC_DARKCELLARROOM)    ; Make the alarm panel now visible
        SET_ITEM_DESCRIPTION(e_ITEM_BasementWindow,"a _window")

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

    JUMP_IF_FALSE(no_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_DARKCELLARROOM))  
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,7,87)                     ; Draw the ladder
                _IMAGE(0,40)
                _BUFFER(29,7)
        SET_LOCATION_DIRECTION(e_LOC_DARKCELLARROOM,e_DIRECTION_UP,e_LOC_CELLAR_WINDOW)      ; Enable the UP direction
no_ladder

    ; Make sure the safe looks correct
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
    .)

    ; Draw the explosion?
    .(

    .)


    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(5,99,0,"La fenêtre semble")
    _BUBBLE_LINE(5,106,4,"occultée")
#else
    _BUBBLE_LINE(5,99,0,"The window seems")
    _BUBBLE_LINE(5,109,0,"to be covered")
#endif    
    END
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
    FADE_BUFFER()      ; Make sure everything appears on the screen
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
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une salle de bain carellée")
#else
    SET_DESCRIPTION("You are in a tiled shower-room")
#endif    
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


// MARK: West Gallery
_gDescriptionWestGallery
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("La gallerie ouest")
#else
    SET_DESCRIPTION("This is the west gallery")
#endif    
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
    _BUBBLE_LINE(85,81,0,"Is that Steel")
    _BUBBLE_LINE(60,92,0,"behind the Curtain?")
#endif    
    END


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
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une salle de bain luxieuse")
#else
    SET_DESCRIPTION("You are in an ornate bathroom")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(132,5,0,"Semble comfortable")
#else
    _BUBBLE_LINE(132,5,0,"Looks comfortable")
#endif    
    END


// MARK: Tiny Toilet
_gDescriptionTinyToilet
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Des petites toilette")
#else
    SET_DESCRIPTION("This is a tiny toilet")
#endif    
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
      _BUBBLE_LINE(5,5,0,"Let's call that a ")
      .byt 5,17,0,34,"Collateral Damage",34,0
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
    FADE_BUFFER()
    END


_gDescriptionThugAttacking
    DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(18,105),40,_SecondImageBuffer+40*23+22,_ImageBuffer+(40*21)+13)    ; Draw the attacking thug
    DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(14,56),40,_SecondImageBuffer+40*34+0,_ImageBuffer+(40*1)+23)       ; Now You Die!
    ; Draw the message
    WAIT(50*2)                              ; Wait a couple seconds
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(5,5,0,"This was a mistake:")
    _BUBBLE_LINE(60,16,0,"My last one")
    WAIT(50*2)                                      ; Wait a couple seconds
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_SHOT_BY_THUG)    ; Achievement!
    GAME_OVER(e_SCORE_SHOT_BY_THUG)                 ; The game is now over
    JUMP(_gDescriptionGameOverLost)                 ; Game Over


// MARK: Padlocked Room
_gDescriptionPadlockedRoom
#ifdef LANGUAGE_FR       
    SET_DESCRIPTION("Une porte blindée cadenassée")
#else
    SET_DESCRIPTION("You see a padlocked steel-plated door")
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(4)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(5,5,0,"Damn...")
    _BUBBLE_LINE(135,16,0,"Je ne pourrai pas")
    _BUBBLE_LINE(131,53,0,"ouvrir ces serrures")
    _BUBBLE_LINE(140,90,0,"assez vite !")
#else
    _BUBBLE_LINE(5,5,0,"Damn...")
    _BUBBLE_LINE(125,16,0,"I will never be able")
    _BUBBLE_LINE(131,53,0,"to pick these locks")
    _BUBBLE_LINE(140,90,0,"fast enough!")
#endif    
    END


; This function assumes the GAME_OVER(xxx) has been called already
_gDescriptionGameOverLost    
    DRAW_BITMAP(LOADER_SPRITE_THE_END,BLOCK_SIZE(20,95),20,_SecondImageBuffer,_ImageBuffer+(40*16)+10)     ; Draw the 'The End' logo
    WAIT(50*2)                                                                                             ; Wait a couple seconds
    FADE_BUFFER()
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
    END_AND_REFRESH
.)


_CombinePetrolWithTP
.(
    SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_NONE)                          ; The Petrol is back into the car (but useless)
    SET_ITEM_LOCATION(e_ITEM_ToiletRoll,e_LOC_TINY_WC)                   ; The TP is back into the toilets (but useless)
    SET_ITEM_LOCATION(e_ITEM_Fuse,e_LOC_CURRENT)                         ; We now have a fuse for our bomb
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_BUILT_A_FUSE)                         ; Achievement!    
    END_AND_REFRESH
.)


_CombineSulfurWithSalpetre
.(
    SET_ITEM_LOCATION(e_ITEM_Saltpetre,e_LOC_NONE)                       ; The saltpetre is gone
    SET_ITEM_LOCATION(e_ITEM_Sulphur,e_LOC_NONE)                         ; The sulphur is gone
    SET_ITEM_LOCATION(e_ITEM_PowderMix,e_LOC_CURRENT)                    ; We now have a rough powder mix for our bomb

    DISPLAY_IMAGE(LOADER_PICTURE_ROUGH_POWDER_MIX,"Sulphur & Saltpeter")
    INFO_MESSAGE("It's mixed...")
    WAIT(50*2)
    INFO_MESSAGE("...but there are some large clumps")
    WAIT(50*2)
    END_AND_REFRESH
.)


_CombineGunPowderWithFuse
.(
    SET_ITEM_LOCATION(e_ITEM_GunPowder,e_LOC_NONE)                       ; The gunpowder is gone
    SET_ITEM_LOCATION(e_ITEM_Fuse,e_LOC_NONE)                            ; The fuse is gone as well
    SET_ITEM_LOCATION(e_ITEM_TobaccoTin,e_LOC_NONE)                      ; And so is the tobacco tin
    SET_ITEM_LOCATION(e_ITEM_Bomb,e_LOC_CURRENT)                         ; We now have a bomb

    DISPLAY_IMAGE(LOADER_PICTURE_READY_TO_BLOW,"Ready to blow!")
    INFO_MESSAGE("The explosive is ready...")
    WAIT(50*2)
    INFO_MESSAGE("...but it needs to be attached")
    WAIT(50*2)
    END_AND_REFRESH
.)


_CombineBombWithAdhesive
.(
    SET_ITEM_LOCATION(e_ITEM_Adhesive,e_LOC_NONE)                        ; The adhesive is gone
    SET_ITEM_FLAGS(e_ITEM_Bomb,ITEM_FLAG_TRANSFORMED)                    ; We now have a sticky bomb
#ifdef LANGUAGE_FR                                                       ; Rename the bomb to "sticky bomb"
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"_bombe collante")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"a sticky _bomb")
#endif    
    DISPLAY_IMAGE(LOADER_PICTURE_STICKY_BOMB,"Ready to install!")
    INFO_MESSAGE("Should be ready to use now...")
    WAIT(50*2)
    INFO_MESSAGE("...need to install it!")
    WAIT(50*2)
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
    DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_WITH_BOMB,"Ready to blow!")
    INFO_MESSAGE("Everything is in place...")
    WAIT(50*2)
    INFO_MESSAGE("...need to safely ignite it though!")
    WAIT(50*2)
    END_AND_REFRESH
.)


_CombineBombWithMatches
.(
    SET_ITEM_FLAGS(e_ITEM_BoxOfMatches,ITEM_FLAG_TRANSFORMED);    // Strike the matches!
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
    VALUE_MAPPING(255                       , _ErrorCannotRead)             ; Default option


_ReadNewsPaper
    DISPLAY_IMAGE(LOADER_PICTURE_NEWSPAPER,"The Daily Telegraph, September 29th")
    INFO_MESSAGE("I have to find her fast...")
    WAIT(50*2)
    INFO_MESSAGE("...I hope she is fine!")
    WAIT(50*2)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_NEWSPAPER)   ; Achievement!    
    END_AND_REFRESH


_ReadHandWrittenNote
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
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_NOTE)   ; Achievement!    
    END_AND_REFRESH


_ReadChemistryRecipes
    DISPLAY_IMAGE(LOADER_PICTURE_CHEMISTRY_RECIPES,"A few useful recipes")
    WAIT(50*2)
    INFO_MESSAGE("I can definitely use these...")
    WAIT(50*2)
    INFO_MESSAGE("...just need to find the materials.")
    WAIT(50*2)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_RECIPES)   ; Achievement!    
    END_AND_REFRESH


_ReadChemistryBook
.(
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
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_BOOK)   ; Achievement!
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
    VALUE_MAPPING(e_ITEM_AlarmPanel         , _InspectPanel)
    VALUE_MAPPING(e_ITEM_MixTape            , _InspectMixTape)
    VALUE_MAPPING(e_ITEM_HeavySafe          , _InspectSafe)
    VALUE_MAPPING(e_ITEM_Thug               , _InspectThug)
    VALUE_MAPPING(e_ITEM_Newspaper          , _ReadNewsPaper)
    VALUE_MAPPING(255                       , _MessageNothingSpecial)  ; Default option


_InspectMap
    DISPLAY_IMAGE(LOADER_PICTURE_UK_MAP,"A map of the United Kingdom")
    INFO_MESSAGE("It shows Ireland, Wales and England")
    WAIT(50*2)
    END_AND_REFRESH


_InspectGame
    DISPLAY_IMAGE(LOADER_PICTURE_DONKEY_KONG_TOP,"A handheld game")
    INFO_MESSAGE("State of the art hardware!")
    WAIT(50*2)
    END_AND_REFRESH


_InspectChemistryBook
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un livre épais avec des marques")
#else    
    INFO_MESSAGE("A thick book with some bookmarks")
#endif    
    WAIT(50*2)
    END_AND_REFRESH


_InspectFridgeDoor
    DISPLAY_IMAGE(LOADER_PICTURE_FRIDGE_DOOR,"Let's look at that fridge")
    INFO_MESSAGE("Looks like a happy familly...")
    WAIT(50*2)
    INFO_MESSAGE("...I wonder where they are?")
    WAIT(50*2)
    END_AND_REFRESH



_InspectMedicineCabinet
.(
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
        FADE_BUFFER()      ; Make sure everything appears on the screen
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


_InspectPlasticBag
.(
    //CLEAR_TEXT_AREA(4)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Juste un sac blanc normal")
#else
    INFO_MESSAGE("It's just a white generic bag")
#endif    
    END_AND_REFRESH
.)



_InspectMixTape
.(
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
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_ATTACHED),else)    ; Is the bomb installed?
        DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_WITH_BOMB,"Ready to blow!")
    ELSE(else,nobomb)
        DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR,"A big old safe")
    ENDIF(nobomb)

#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il est gros, mais semble fragile")
#else
    INFO_MESSAGE("It's big, but not that sturdy")
#endif    
    WAIT(50*2)
    END_AND_REFRESH
.)


_InspectThug
.(
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
    VALUE_MAPPING(255                       , _ErrorCannotDo)        ; Default option


_OpenCurtain
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Curtain,ITEM_FLAG_CLOSED),open)                                  ; Is the curtain closed?
        UNSET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)                                           ; Open it!
        SET_LOCATION_DIRECTION(e_LOC_WESTGALLERY,e_DIRECTION_NORTH,e_LOC_PADLOCKED_ROOM)  ; We can now access the padlocked room
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CURTAIN)                                          ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                                  ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"un _rideau ouvert")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"an opened _curtain")
#endif        
    ENDIF(open)
    END_AND_REFRESH
.)


; TODO: Messages to indicate that the fridge it already open or that we have already found something
; Probably need a string table/id system to easily reuse messages.
_OpenFridge
.(    
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Fridge,ITEM_FLAG_CLOSED),open)                               ; Is the fridge closed?
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


_OpenMedicineCabinet
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED),open)                      ; Is the medicine cabinet closed?
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


_OpenGunCabinet
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED),open)                           ; Is the gun cabinet closed?
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
            UNSET_ITEM_FLAGS(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED)                               ; Open it!
            UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                 ; And get an achievement for that action
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
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_CELLAR_WINDOW),basement)                               ; Are we on the basement side...
        INFO_MESSAGE("The frame is stuck...")                                                   
    ELSE(basement,garden)                                                                      ; ...or on the vegetable garden side of the window?
        DISPLAY_IMAGE(LOADER_PICTURE_BASEMENT_WINDOW_DARK,"")
        INFO_MESSAGE("It is locked from the inside...")
    ENDIF(garden)
    WAIT(50*2)
    INFO_MESSAGE("...maybe shake it a bit?")
    WAIT(50*2)
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED),on)                        ; Is the alarm active...
        DISPLAY_IMAGE(LOADER_PICTURE_ALARM_TRIGGERED,"")
        ERROR_MESSAGE("You triggered the alarm!")
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_TRIPPED_ALARM)   ; Achievement!
        GAME_OVER(e_SCORE_TRIPPED_ALARM)
        JUMP(_gDescriptionGameOverLost)                 ; Draw the 'The End' logo
    ELSE(on,off)                                                                               ; ...or was it disabled by the player?
        INFO_MESSAGE("Nothing happens...")
    ENDIF(off)
    END_AND_REFRESH
.)


_OpenCarBoot
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_CarBoot,ITEM_FLAG_CLOSED),open)                             ; Is the boot closed?
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
        UNSET_ITEM_FLAGS(e_ITEM_CarTank,ITEM_FLAG_CLOSED)                                       ; Open it!
#ifdef LANGUAGE_FR                                                                              ; Update the description 
        SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"un _réservoir d'essence ouvert")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"an open petrol _tank")
#endif        
    ENDIF(open)
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
    VALUE_MAPPING(e_ITEM_Bread              , _ThrowBread)
    VALUE_MAPPING(e_ITEM_Meat               , _ThrowMeat)
    VALUE_MAPPING(e_ITEM_SilverKnife        , _ThrowKnife)
    VALUE_MAPPING(e_ITEM_SnookerCue         , _ThrowSnookerCue)
    VALUE_MAPPING(e_ITEM_DartGun            , _UseDartGun)
    VALUE_MAPPING(e_ITEM_Keys               , _UseKeys)
    VALUE_MAPPING(e_ITEM_AlarmSwitch        , _UseAlarmSwitch)
    VALUE_MAPPING(e_ITEM_Hose           , _UseHosePipe)
    VALUE_MAPPING(e_ITEM_MortarAndPestle    , _UseMortar)
    VALUE_MAPPING(e_ITEM_Bomb               , _UseBomb)
    VALUE_MAPPING(e_ITEM_BoxOfMatches       , _UseMatches)
    VALUE_MAPPING(255                       , _ErrorCannotDo)   ; Default option


_UseLadder
.(
    JUMP_IF_TRUE(install_the_ladder,CHECK_PLAYER_LOCATION(e_LOC_INSIDE_PIT))
    JUMP_IF_TRUE(install_the_ladder,CHECK_PLAYER_LOCATION(e_LOC_OUTSIDE_PIT))
    JUMP_IF_TRUE(install_the_ladder,CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM))
cannot_use_ladder_here
    ERROR_MESSAGE("Can't use it there")
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


_UseRope
.(
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

    // - We are in the entrance hall and the dog is still alive
    JUMP_IF_FALSE(snoozed_dog,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_TRUE(snoozed_dog,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_DOG)
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
            INFO_MESSAGE("The door is now unlocked")
#ifdef LANGUAGE_FR                                                                             ; Update the description 
            SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"une _centrale d'alarme déverouillée")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"an unlocked alarm _panel")
#endif        
            WAIT(50*1)
        ENDIF(locked)
    ENDIF(cellar)

   END_AND_REFRESH
.)


_UseAlarmSwitch
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED),on)                 ; Is the alarm active?
        SET_ITEM_FLAGS(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED)                           ; Disable the alarm 
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
    INFO_MESSAGE("Homemade Gun powder...")
    WAIT(50*2)
    INFO_MESSAGE("...need a proper canister to store it")
    WAIT(50*2)

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


/* MARK: Search Action 🕵️‍♀️

            ███████╗███████╗ █████╗ ██████╗  ██████╗██╗  ██╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
            ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝██║  ██║    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
            ███████╗█████╗  ███████║██████╔╝██║     ███████║    ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
            ╚════██║██╔══╝  ██╔══██║██╔══██╗██║     ██╔══██║    ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
            ███████║███████╗██║  ██║██║  ██║╚██████╗██║  ██║    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
            ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                                                                   
*/

_gSearchtemMappingsArray
    VALUE_MAPPING(e_ITEM_Thug     , _SearchThug)
    VALUE_MAPPING(255             , _MessageNothingSpecial)   ; Default option


_SearchThug
.(
    JUMP_IF_TRUE(thug_disabled,CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED))
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Il faut d'abord le maitriser");
#else
    ERROR_MESSAGE("I should subdue him first");
#endif    
    END

thug_disabled
    JUMP_IF_TRUE(found_items,CHECK_ITEM_LOCATION(e_ITEM_Pistol,e_LOC_NONE))
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Vous l'avez déjà fouillé");
#else    
    ERROR_MESSAGE("You've already frisked him");
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
    INCREASE_SCORE(50)
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
    VALUE_MAPPING(e_ITEM_LargeDove          , _FreeDove)
    VALUE_MAPPING(255                       , _DropCurrentItem)  ; Default option


_ThrowBread
.(
    JUMP_IF_FALSE(not_in_wooded_avenue,CHECK_PLAYER_LOCATION(e_LOC_WOODEDAVENUE))
give_bread_to_dove
    // The bread is going away, but the bird is now possible to catch
    SET_ITEM_LOCATION(e_ITEM_Bread,e_LOC_GONE_FOREVER)
    UNSET_ITEM_FLAGS(e_ITEM_LargeDove,ITEM_FLAG_IMMOVABLE)
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"une _colombe qui picore")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"a _dove eating bread crumbs")
#endif    
//+_gSceneActionDoveEatingBread
    DISPLAY_IMAGE(LOADER_PICTURE_DOVE_EATING_BREADCRUMBS,"Birdy nam nam...")
    INFO_MESSAGE("Maybe I can catch it now?")
    WAIT(50*2)
    END_AND_REFRESH

not_in_wooded_avenue
    // In other locations we just drop the bread where we are
    SET_ITEM_LOCATION(e_ITEM_Bread,e_LOC_CURRENT)
    END_AND_REFRESH
.)


_ThrowMeat
.(
    // The meat can only be eaten if we are in the Entrance Hall and the dog is still alive and kicking
    JUMP_IF_FALSE(nothing_to_eat_the_meat,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_TRUE(nothing_to_eat_the_meat,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
dog_eating_the_meat
    DISPLAY_IMAGE(LOADER_PICTURE_DOG_EATING_MEAT,"Quite a hungry dog!")
    INFO_MESSAGE("Glad it's not me there!")
    SET_ITEM_LOCATION(e_ITEM_Meat,e_LOC_GONE_FOREVER)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DOG_ATE_THE_MEAT)
    WAIT(50*2)    
    JUMP_IF_FALSE(done,CHECK_ITEM_FLAG(e_ITEM_Meat,ITEM_FLAG_TRANSFORMED))  // Is the meat drugged?
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_DOG)
    INCREASE_SCORE(50)
    JUMP(_CommonDogDisabled)
done
    END_AND_REFRESH

nothing_to_eat_the_meat
    // In other locations we just drop the meat where we are
    SET_ITEM_LOCATION(e_ITEM_Meat,e_LOC_CURRENT)
    END_AND_REFRESH
 .)


_FreeDove
.(    
    INFO_MESSAGE("The dove flies away")                                         ; When left anywhere, the dove will manage to fly away
    SET_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_GONE_FOREVER)                 ; No mater where we use the DOVE, it will be out of the game definitely.
    // The dog will only chase the dove if the dog is where we are and is still alive and kicking
    JUMP_IF_FALSE(nothing_to_chase_the_dove,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOC_CURRENT))
    JUMP_IF_TRUE(nothing_to_chase_the_dove,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
        DISPLAY_IMAGE(LOADER_PICTURE_DOG_CHASING_DOVE,"Run Forrest, Run!")      ; Show the picture with the dog running after the dove
        INFO_MESSAGE("Hopefully he will not catch the dove")
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_CHASED_THE_DOG)
        SET_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOC_GONE_FOREVER)           ; And the dog is now gone forever
        WAIT(50*2)    
nothing_to_chase_the_dove
    END_AND_REFRESH
 .)


_ThrowKnife
.(
    // We only throw the knife if:
    // - We are in the entrance hall and the dog is still alive
    JUMP_IF_FALSE(dog_knife,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_TRUE(dog_knife,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
        SET_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOC_LARGE_STAIRCASE)
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

    // In other locations we just drop the item where we are
    SET_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOC_CURRENT)
    END_AND_REFRESH
.)


_ThrowSnookerCue
.(
    // We only throw the snooker cue if:
    // - We are in the entrance hall and the dog is still alive
    JUMP_IF_FALSE(dog_snooker_cue,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_TRUE(dog_snooker_cue,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
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

    // In other locations we just drop the item where we are
    SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOC_CURRENT)
    END_AND_REFRESH
.)


_CommonDogDisabled
.(
    INCREASE_SCORE(50)
    SET_ITEM_FLAGS(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED)
+_gTextDogLying = *+2
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_AlsatianDog,"un _chien immobile")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_AlsatianDog,"a _dog lying")
#endif    
    END_AND_REFRESH
.)


_CommonThugDisabled
.(
    INCREASE_SCORE(50)
    SET_ITEM_FLAGS(e_ITEM_Thug,ITEM_FLAG_DISABLED)
+_gTextDeadThug = *+2
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Thug,"un _voyou hors d'état de nuire")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Thug,"an unresponsive _thug")
#endif    
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
    VALUE_MAPPING(e_ITEM_BlackTape         , _TakeBlackTape)
    VALUE_MAPPING(e_ITEM_Acid              , _TakeAcid)
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
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"une _échelle")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"a _ladder")
#endif    
    JUMP(_TakeCommon)
.)


_TakeDove
.(
+_gTextItemLargeDove = *+2
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"une grosse _colombe")
#else    
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"a large _dove")
#endif    
    JUMP(_TakeCommon)
.)


_TakeBlackTape
.(
    SET_ITEM_LOCATION(e_ITEM_BlackTape, e_LOC_GONE_FOREVER)  ; The black tape cannot be reused
#ifdef LANGUAGE_FR   
    INFO_MESSAGE("Le ruban n'est pas réutilisable")
#else    
    INFO_MESSAGE("The tape cannot be reused")
#endif    
    WAIT(50)
    END_AND_REFRESH
.)

_TakeAcid
.(
    DISPLAY_IMAGE(LOADER_PICTURE_CORROSIVE_LIQUID,"ACME XX121 Acid")
    INFO_MESSAGE("This stuff is highly dangerous!")
    WAIT(50*2)
    INFO_MESSAGE("...could go through a ship hull!")
    WAIT(50*2)

    JUMP(_TakeCommon)
.)


_TakeCommon
.(
    SET_ITEM_LOCATION(e_ITEM_CURRENT, e_LOC_INVENTORY)  ; The item is now in our inventory
    UNSET_ITEM_FLAGS(e_ITEM_CURRENT, ITEM_FLAG_ATTACHED)     ; If the item was attached, we detach it
    END_AND_REFRESH
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


_EndSceneActions



_EndGameTextData

;
; Print statistics about the size of things
;
#if DISPLAYINFO=1
#print Total size of game text content = (_EndGameTextData - _StartGameTextData)
#print - Messages and prompts = (_EndMessagesAndPrompts - _StartMessagesAndPrompts)
#print - Error messages = (_EndErrorMessages - _StartErrorMessages)
#print - Location names = (_EndLocationNames - _StartLocationNames)
#print - Item names = (_EndItemNames - _StartItemNames)
#print - Scene scripts = (_EndSceneScripts - _StartSceneScripts)
#print - Scene actions = (_EndSceneActions - _StartSceneActions)
#endif

