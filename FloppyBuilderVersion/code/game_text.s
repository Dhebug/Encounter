
#include "params.h"
#include "../build/floppy_description.h"
#include "game_enums.h"

    .text

_StartGameTextData

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i ô:^
#endif

// Small feedback messages and prompts
_StartMessagesAndPrompts
#ifdef LANGUAGE_FR
_gTextAskInput              .byt "Quels sont vos instructions ?",0
_gTextNothingHere           .byt "Il n'y a rien d'important ici",0
_gTextCanSee                .byt "Je vois ",0
_gTextScore                 .byt "Score:",0
_gTextCarryInWhat           .byt "Transporte dans quoi ?",0
_gTextPetrolEvaporates      .byt "Le pétrole s'évapore",0
_gTextWaterDrainsAways      .byt "L'eau s'écoule",0
_gTextClimbUpLadder         .byt "Vous grimpez l'échelle",0
_gTextClimbDownLadder       .byt "Vous descendez l'échelle",0
_gTextPositionLadder        .byt "Vous mettez l'échelle en place",0
_gTextClimbUpRope           .byt "Vous grimpez la corde",0
_gTextClimbDownRope         .byt "Vous descendez la corde",0
_gTextAttachRopeToTree      .byt "Vous attachez la corde à l'arbre",0
_gTextDogLying              .byt "un chien immobile",0
_gTextDeadThug              .byt "un malfaiteur mort",0
_gTextFoundSomething        .byt "Vous avez trouvé quelque chose",0
_gTextDogGrowlingAtYou      .byt "un alsacien menacant",0
_gTextThugAsleepOnBed       .byt "un malfaiteur assoupi sur le lit",0
_gTextNotDead               .byt "Pas mort",0                                // Debugging text
_gTextDogJumpingAtMe        .byt "un chien qui me saute dessus",0
_gTextThugShootingAtMe      .byt "un malfaiteur qui me tire dessus",0
_gTextThickBookBookmarks    .byt "Un livre épais avec des marques",0
#else
_gTextAskInput              .byt "What are you going to do now?",0
_gTextNothingHere           .byt "There is nothing of interest here",0
_gTextCanSee                .byt "I can see ",0
_gTextScore                 .byt "Score:",0
_gTextCarryInWhat           .byt "Carry it in what?",0
_gTextPetrolEvaporates      .byt "The petrol evaporates",0
_gTextWaterDrainsAways      .byt "The water drains away",0
_gTextClimbUpLadder         .byt "You climb up the ladder",0
_gTextClimbDownLadder       .byt "You climb down the ladder",0
_gTextPositionLadder        .byt "You position the ladder properly",0
_gTextClimbUpRope           .byt "You climb up the rope",0
_gTextClimbDownRope         .byt "You climb down the rope",0
_gTextAttachRopeToTree      .byt "You attach the rope to the tree",0
_gTextDogLying              .byt "a dog lying",0
_gTextDeadThug              .byt "a dead thug",0
_gTextFoundSomething        .byt "You found something interesting",0
_gTextDogGrowlingAtYou      .byt "an alsatian growling at you",0
_gTextThugAsleepOnBed       .byt "a thug asleep on the bed",0
_gTextNotDead               .byt "Not dead",0                                // Debugging text
_gTextDogJumpingAtMe        .byt "a dog jumping at me",0
_gTextThugShootingAtMe      .byt "a thug shooting at me",0
_gTextThickBookBookmarks    .byt "A thick book with some boomarks",0
#endif
_EndMessagesAndPrompts

// Error messages 
_StartErrorMessages
#ifdef LANGUAGE_FR
_gTextErrorInvalidDirection .byt "Impossible d'aller par la",0
_gTextErrorCantTakeNoSee    .byt "Je ne vois pas ca ici",0
_gTextErrorAlreadyHaveItem  .byt "Vous avez déjà cet objet",0
_gTextErrorCannotDo         .byt "Je ne peux pas le faire",0
_gTextErrorRidiculous       .byt "Ne soyez pas ridicule",0
_gTextErrorAlreadyFull      .byt "Désolé, c'est déja plein",0
_gTextErrorMissingContainer .byt "Vous n'avez pas ce contenant",0
_gTextErrorDropNotHave      .byt "Impossible, vous ne l'avez pas",0
_gTextErrorUnknownItem      .byt "Je ne connais pas cet objet",0
_gTextErrorItemNotPresent   .byt "Cet objet n'est pas présent",0
_gTextErrorCannotRead       .byt "Je ne peux pas lire ca",0
_gTextErrorCannotUseHere    .byt "Pas utilisable ici",0
_gTextErrorDontKnowUsage    .byt "Je ne sais pas l'utiliser",0
_gTextErrorCannotAttachRope .byt "Impossible de l'attacher",0
_gTextErrorLadderInHole     .byt "L'échelle est déja dans le trou",0
_gTextErrorCantClimbThat    .byt "Je ne sais pas grimper ca",0
_gTextErrorNeedPositionned  .byt "Ca doit d'abort être en place",0
_gTextErrorItsNotHere       .byt "Ca n'est pas là",0
_gTextErrorAlreadyDealtWith .byt "Plus un problème",0
_gTextErrorShouldSaveGirl   .byt "Vous êtes censé la sauver",0
_gTextErrorShouldSubdue     .byt "Il faut d'abord le maitriser",0
_gTextErrorAlreadySearched  .byt "Vous l'avez déjà fouillé",0
_gTextErrorInappropriate    .byt "Probablement inapproprié",0
_gTextErrorDeadDontMove     .byt "Les morts ne bougent pas",0
_gTextErrorNothingSpecial   .byt "Rien de spécial",0
#else
_gTextErrorInvalidDirection .byt "Impossible to move in that direction",0
_gTextErrorCantTakeNoSee    .byt "You can only take something you see",0
_gTextErrorAlreadyHaveItem  .byt "You already have this item",0
_gTextErrorCannotDo         .byt "I can't do that",0
_gTextErrorRidiculous       .byt "Don't be ridiculous",0
_gTextErrorAlreadyFull      .byt "Sorry, that's full already",0
_gTextErrorMissingContainer .byt "You don't have this container",0
_gTextErrorDropNotHave      .byt "You can only drop something you have",0
_gTextErrorUnknownItem      .byt "I do not know what this item is",0
_gTextErrorItemNotPresent   .byt "This item does not seem to be present",0
_gTextErrorCannotRead       .byt "I can't read that",0
_gTextErrorCannotUseHere    .byt "I can't use it here",0
_gTextErrorDontKnowUsage    .byt "I don't know how to use that",0
_gTextErrorCannotAttachRope .byt "You can't attach the rope",0
_gTextErrorLadderInHole     .byt "The ladder is already in the hole",0
_gTextErrorCantClimbThat    .byt "I don't know how to climb that",0
_gTextErrorNeedPositionned  .byt "It needs to be positionned first",0
_gTextErrorItsNotHere       .byt "It's not here",0
_gTextErrorAlreadyDealtWith .byt "Not a problem anymore",0
_gTextErrorShouldSaveGirl   .byt "You are supposed to save her",0
_gTextErrorShouldSubdue     .byt "I should subdue him first",0
_gTextErrorAlreadySearched  .byt "You've already frisked him",0
_gTextErrorInappropriate    .byt "Probably inappropriate",0
_gTextErrorDeadDontMove     .byt "Dead don't move",0
_gTextErrorNothingSpecial   .byt "Nothing special",0
#endif
_EndErrorMessages


// Places
_StartLocationNames
#ifdef LANGUAGE_FR
//                                      0         1         2         3
//                                      0123456789012345678901234567890123456789
_gTextLocationMarketPlace         .byt "Vous êtes sur la place du marché",0
_gTextLocationDarkAlley           .byt "Vous êtes dans une allée sombre",0
_gTextLocationRoad                .byt "Une longue route s'étend devant vous",0

_gTextLocationDarkTunel           .byt "Vous êtes dans un tunnel humide",0
_gTextLocationMainStreet          .byt "Vous êtes dans la rue principale",0
_gTextLocationNarrowPath          .byt "Vous êtes sur un chemin étroit",0

_gTextLocationInThePit            .byt "Vous êtes au fond d'un trou",0
_gTextLocationOldWell             .byt "Vous êtes prês d'un vieux puit",0
_gTextLocationWoodedAvenue        .byt "Vous êtes dans une allée arbroisée",0

_gTextLocationGravelDrive         .byt "Vous êtes sur un passage gravilloné",0
_gTextLocationTarmacArea          .byt "Vous êtes sur une zone asphaltée",0
_gTextLocationZenGarden           .byt "Vous êtes dans un jarding zen relaxant",0

_gTextLocationFrontLawn           .byt "Vous êtes sur une large pelouse",0
_gTextLocationGreenHouse          .byt "Vous êtes dans une petite serre",0
_gTextLocationTennisCourt         .byt "Vous êtes sur un cours de tennis",0

_gTextLocationVegetableGarden     .byt "Vous êtes dans un jardin potagé",0
_gTextLocationFishPond            .byt "Vous êtes près d'un bac a poisson",0
_gTextLocationTiledPatio          .byt "Vous êtes sur un patio carellé",0

_gTextLocationAppleOrchard        .byt "Vous êtes dans une pommeraie",0
_gTextLocationDarkerCellar        .byt "Cette pièce est encore plus sombre",0
_gTextLocationCellar              .byt "Une cave frigide et humide",0

_gTextLocationNarrowStaircase     .byt "Vous êtes dans un escalier étroit",0
_gTextLocationEntranceLounge      .byt "Vous êtes dans un salon",0
_gTextLocationEntranceHall        .byt "Vous êtes dans un hall imposant",0

_gTextLocationLibrary             .byt "Probablement une bibliothèque",0
_gTextLocationDiningRoom          .byt "Apparement une salle a manger",0
_gTextLocationStaircase           .byt "Vous êtes dans un large escalier",0

_gTextLocationGamesRoom           .byt "La salle de jeux",0
_gTextLocationSunLounge           .byt "Le solarium",0
_gTextLocationKitchen             .byt "Visiblement la cuisine",0

_gTextLocationNarrowPassage       .byt "Vous êtes dans un passage étroit",0
_gTextLocationGuestBedroom        .byt "Une chambre d'amis",0
_gTextLocationChildBedroom        .byt "La chambre d'un enfant",0

_gTextLocationMasterBedRoom       .byt "La chambre principale",0
_gTextLocationShowerRoom          .byt "Une salle de bain carellée",0
_gTextLocationTinyToilet          .byt "Des petites toilettes",0

_gTextLocationEastGallery         .byt "La gallerie est",0
_gTextLocationBoxRoom             .byt "Une petite loge",0
_gTextLocationPadlockedRoom       .byt "Une porte blindée cadenassée",0

_gTextLocationClassyBathRoom      .byt "Une salle de bain luxieuse",0
_gTextLocationWestGallery         .byt "La gallerie ouest",0
_gTextLocationMainLanding         .byt "Vous êtes sur le palier principal",0

_gTextLocationOutsidePit          .byt "En dehors d'un trou profond",0

_gTextLocationGirlRoomOpenned     .byt "La pièce avec la fille (ouverte)",0
#else
_gTextLocationMarketPlace         .byt "You are in a deserted market square",0
_gTextLocationDarkAlley           .byt "You are in a dark, seedy alley",0
_gTextLocationRoad                .byt "A long road stretches ahead of you",0

_gTextLocationDarkTunel           .byt "You are in a dark, damp tunnel",0
_gTextLocationMainStreet          .byt "You are on the main street",0
_gTextLocationNarrowPath          .byt "You are on a narrow path",0

_gTextLocationInThePit            .byt "You are inside a deep pit",0
_gTextLocationOldWell             .byt "You are near to an old-fashioned well",0
_gTextLocationWoodedAvenue        .byt "You are in a wooded avenue",0

_gTextLocationGravelDrive         .byt "You are on a wide gravel drive",0
_gTextLocationTarmacArea          .byt "You are in an open area of tarmac",0
_gTextLocationZenGarden           .byt "You are in a relaxing zen garden",0

_gTextLocationFrontLawn           .byt "You are on a huge area of lawn",0
_gTextLocationGreenHouse          .byt "You are in a small greenhouse",0
_gTextLocationTennisCourt         .byt "You are on a lawn tennis court",0

_gTextLocationVegetableGarden     .byt "You are in a vegetable plot",0
_gTextLocationFishPond            .byt "You are standing by a fish pond",0
_gTextLocationTiledPatio          .byt "You are on a tiled patio",0

_gTextLocationAppleOrchard        .byt "You are in an apple orchard",0
_gTextLocationDarkerCellar        .byt "This room is even darker than the last",0
_gTextLocationCellar              .byt "This is a cold, damp cellar",0

_gTextLocationNarrowStaircase     .byt "You are on some gloomy, narrow steps",0
_gTextLocationEntranceLounge      .byt "You are in the lounge",0
_gTextLocationEntranceHall        .byt "You are in an imposing entrance hall",0

_gTextLocationLibrary             .byt "This looks like a library",0
_gTextLocationDiningRoom          .byt "A dining room, or so it appears",0
_gTextLocationStaircase           .byt "You are on a sweeping staircase",0

_gTextLocationGamesRoom           .byt "This looks like a games room",0
_gTextLocationSunLounge           .byt "You find yourself in a sun-lounge",0
_gTextLocationKitchen             .byt "This is obviously the kitchen",0

_gTextLocationNarrowPassage       .byt "You are in a narrow passage",0
_gTextLocationGuestBedroom        .byt "This seems to be a guest bedroom",0
_gTextLocationChildBedroom        .byt "This is a child's bedroom",0

_gTextLocationMasterBedRoom       .byt "This must be the master bedroom",0
_gTextLocationShowerRoom          .byt "You are in a tiled shower-room",0
_gTextLocationTinyToilet          .byt "This is a tiny toilet",0

_gTextLocationEastGallery         .byt "You have found the east gallery",0
_gTextLocationBoxRoom             .byt "This is a small box-room",0
_gTextLocationPadlockedRoom       .byt "You see a padlocked steel-plated door",0

_gTextLocationClassyBathRoom      .byt "You are in an ornate bathroom",0
_gTextLocationWestGallery         .byt "This is the west gallery",0
_gTextLocationMainLanding         .byt "You are on the main landing",0

_gTextLocationOutsidePit          .byt "Outside a deep pit",0

_gTextLocationGirlRoomOpenned     .byt "The girl room (openned lock)",0
#endif
_EndLocationNames

// Items
_StartItemNames
#ifdef LANGUAGE_FR
// Containers
_gTextItemTobaccoTin              .byt "une tabatière vide",0
_gTextItemBucket                  .byt "un seau en bois",0
_gTextItemCardboardBox            .byt "une boite en carton",0
_gTextItemFishingNet              .byt "un filet de pêche",0
_gTextItemPlasticBag              .byt "un sac en plastique",0
_gTextItemSmallBottle             .byt "une petite bouteille",0
// Items requiring containers
_gTextItemBlackDust               .byt "de la poudre noire",0
_gTextItemYellowPowder            .byt "poudre jaune granuleuse",0
_gTextItemPetrol                  .byt "du pétrole",0
_gTextItemWater                   .byt "de l'eau",0
// Normal items
_gTextItemLockedPanel             .byt "un paneau mural verouillé",0
_gTextItemOpenPanel               .byt "un paneau mural ouvert",0
_gTextItemFridge                  .byt "un réfrigérateur",0
_gTextItemOpenFridge              .byt "un réfrigérateur ouvert",0
_gTextItemSmallHoleInDoor         .byt "un petit trou dans la porte",0
_gTextItemBrokenWindow            .byt "une vitre brisée",0
_gTextItemLargeDove               .byt "une grosse colombe",0
_gTextItemTwine                   .byt "un peu de ficelle",0
_gTextItemSilverKnife             .byt "un coueau en argent",0
_gTextItemLadder                  .byt "une échelle",0
_gTextItemAbandonedCar            .byt "une voiture abandonnée",0
_gTextItemAlsatianDog             .byt "un alsacien qui grogne",0
_gTextItemMeat                    .byt "un morceau de viande",0
_gTextItemBread                   .byt "du pain complet",0
_gTextItemRollOfTape              .byt "un rouleau de bande adhésive",0
_gTextItemChemistryBook           .byt "un livre de chimie",0
_gTextItemBoxOfMatches            .byt "une boite d'allumettes",0
_gTextItemSnookerCue              .byt "une queue de billard",0
_gTextItemThug                    .byt "un voyou endormi sur le lit",0
_gTextItemHeavySafe               .byt "un gros coffre fort",0
_gTextItemHandWrittenNote         .byt "une note manuscripte",0
_gTextItemRope                    .byt "une longueur de corde",0
_gTextItemRopeHangingFromWindow   .byt "une core qui pend de la fenêtre",0
_gTextItemRollOfToiletPaper       .byt "un rouleau de papier toilette",0
_gTextItemHosePipe                .byt "un tuyau d'arrosage",0
_gTextItemOpenSafe                .byt "un coffre fort ouvert",0
_gTextItemBrokenGlass             .byt "des morceaux de glace",0
_gTextItemAcidBurn                .byt "une brulure d'acide",0
_gTextItemYoungGirl               .byt "une jeune fille",0
_gTextItemFuse                    .byt "un fusible",0
_gTextItemGunPowder               .byt "de la poudre à cannon",0
_gTextItemKeys                    .byt "un jeu de clefs",0
_gTextItemNewspaper               .byt "un journal",0
_gTextItemBomb                    .byt "une bombe",0
_gTextItemPistol                  .byt "un pistolet",0
_gTextItemBullets                 .byt "trois balles de calibre .38",0
_gTextItemYoungGirlOnFloor        .byt "une jeunne fille attachée au sol",0
_gTextItemChemistryRecipes        .byt "des formules de chimie",0
_gTextItemUnitedKingdomMap        .byt "une carte du royaume uni",0
_gTextItemLadderInTheHole         .byt "une échelle dans un trou",0
_gTextItemRopeAttachedToATree     .byt "une corde attachée à un arbre",0
_gTextItemClosedCurtain           .byt "un rideau fermé",0
_gTextItemOpenedCurtain           .byt "un rideau ouvert",0
_gTextItemHandheldGame            .byt "un jeu portable",0
_gTextItemMedicineCabinet         .byt "une armoire à pharmacie",0
_gTextItemOpenMedicineCabinet     .byt "une armoire à pharmacie ouverte",0
_gTextItemSedativePills           .byt "des somnifères",0
_gTextItemSedativeLacedMeat       .byt "viande droggée",0
#else
// Containers
_gTextItemTobaccoTin              .byt "an empty tobacco tin",0               
_gTextItemBucket                  .byt "a wooden bucket",0                    
_gTextItemCardboardBox            .byt "a cardboard box",0                    
_gTextItemFishingNet              .byt "a fishing net",0                      
_gTextItemPlasticBag              .byt "a plastic bag",0                      
_gTextItemSmallBottle             .byt "a small bottle",0                     
// Items requiring containers
_gTextItemBlackDust               .byt "black dust",0                         
_gTextItemYellowPowder            .byt "gritty yellow powder",0               
_gTextItemPetrol                  .byt "some petrol",0                        
_gTextItemWater                   .byt "some water",0                         
// Normal items
_gTextItemLockedPanel             .byt "a locked panel on the wall",0         
_gTextItemOpenPanel               .byt "an open panel on wall",0              
_gTextItemFridge                  .byt "a fridge",0
_gTextItemOpenFridge              .byt "an open fridge",0
_gTextItemSmallHoleInDoor         .byt "a small hole in the door",0           
_gTextItemBrokenWindow            .byt "the window is broken",0               
_gTextItemLargeDove               .byt "a large dove",0                       
_gTextItemTwine                   .byt "some twine",0                         
_gTextItemSilverKnife             .byt "a silver knife",0                     
_gTextItemLadder                  .byt "a ladder",0                           
_gTextItemAbandonedCar            .byt "an abandoned car",0                   
_gTextItemAlsatianDog             .byt "an alsatian growling at you",0        
_gTextItemMeat                    .byt "a joint of meat",0                    
_gTextItemBread                   .byt "some brown bread",0                   
_gTextItemRollOfTape              .byt "a roll of sticky tape",0              
_gTextItemChemistryBook           .byt "a chemistry book",0                   
_gTextItemBoxOfMatches            .byt "a box of matches",0                   
_gTextItemSnookerCue              .byt "a snooker cue",0                      
_gTextItemThug                    .byt "a thug asleep on the bed",0           
_gTextItemHeavySafe               .byt "a heavy safe",0                       
_gTextItemHandWrittenNote         .byt "a hand written note",0                     
_gTextItemRope                    .byt "a length of rope",0                   
_gTextItemRopeHangingFromWindow   .byt "a rope hangs from the window",0       
_gTextItemRollOfToiletPaper       .byt "a roll of toilet tissue",0            
_gTextItemHosePipe                .byt "a hose-pipe",0                        
_gTextItemOpenSafe                .byt "an open safe",0                       
_gTextItemBrokenGlass             .byt "broken glass",0                       
_gTextItemAcidBurn                .byt "an acid burn",0                       
_gTextItemYoungGirl               .byt "a young girl",0                        
_gTextItemFuse                    .byt "a fuse",0                             
_gTextItemGunPowder               .byt "some gunpowder",0                     
_gTextItemKeys                    .byt "a set of keys",0                      
_gTextItemNewspaper               .byt "a newspaper",0                        
_gTextItemBomb                    .byt "a bomb",0                             
_gTextItemPistol                  .byt "a pistol",0                           
_gTextItemBullets                 .byt "three .38 bullets",0                  
_gTextItemYoungGirlOnFloor        .byt "a young girl tied up on the floor",0  
_gTextItemChemistryRecipes        .byt "a couple chemistry recipes",0         
_gTextItemUnitedKingdomMap        .byt "a map of the United Kingdom",0        
_gTextItemLadderInTheHole         .byt "a ladder in a hole",0      
_gTextItemRopeAttachedToATree     .byt "a rope attached to a tree",0
_gTextItemClosedCurtain           .byt "a closed curtain",0
_gTextItemOpenedCurtain           .byt "an opened curtain",0
_gTextItemHandheldGame            .byt "a handheld game",0
_gTextItemMedicineCabinet         .byt "a medicine cabinet",0
_gTextItemOpenMedicineCabinet     .byt "an open medicine cabinet",0
_gTextItemSedativePills           .byt "some sedative pills",0
_gTextItemSedativeLacedMeat       .byt "drugged meat",0
#endif
_EndItemNames



// Scene descriptions
_StartSceneScripts
_gDescriptionTeenagerRoom         .byt "Teenager room?",0

_gDescriptionNone
    END

_gDescriptionDarkTunel
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 4,4,0,"Un tunnel ordinaire: sombre,",0
    .byt 4,13,1,"humide et inquiétant.",0
#else    
    .byt 4,4,0,"Like most tunnels: dark, damp,",0
    .byt 4,13,1,"and somewhat scary.",0
#endif    
    END

_gDescriptionMarketPlace
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 4,100,0,"La place du marché",0
    .byt 4,106,4,"est désertée",0
#else
    .byt 4,100,0,"The market place",0
    .byt 4,106,4,"is deserted",0
#endif    

blinky_shop
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(8,11),40,_SecondImageBuffer+(40*116)+32,$a000+(14*40)+11)    ; Draw the Fish Shop "grayed out"
    WAIT(50) 
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(8,11),40,_SecondImageBuffer+(40*104)+32,$a000+(14*40)+11)    ; Draw the Fish Shop "fully drawn"
    WAIT(50)
    JUMP(blinky_shop)

    END


_gDescriptionDarkAlley
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 145,90,0,"Rats, graffittis,",0
    .byt 160,103,0,"et seringues.",0
#else
    .byt 153,85,0,"Rats, graffitti,",0
    .byt 136,98,0,"and used syringes.",0
#endif    
    END

_gDescriptionRoad
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 4,95,0,"Tous les chemins mènent...",0
    .byt 4,106,0,"...quelque part?",0
#else    
    .byt 4,100,0,"All roads lead...",0
    .byt 4,106,4,"...somewhere?",0
#endif    
    END

_gDescriptionMainStreet
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 4,4,0,"Une bonne vieille",0
    .byt 4,16,0,"église médiévale",0
#else    
    .byt 4,4,0,"A good old",0
    .byt 4,16,0,"medieval church",0
#endif    
    END

_gDescriptionNarrowPath
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 130,5,0,"Serait-ce les",0
    .byt 129,17,0,"portes du Paradis?",0
#else    
    .byt 130,5,0,"Are these the open",0
    .byt 109,17,0,"flood gates of heaven?",0
#endif    
    END

_gDescriptionInThePit
.(
    JUMP_IF_FALSE(no_rope,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_INSIDEHOLE))
    JUMP_IF_TRUE(rope_attached_to_tree,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
no_rope    

    JUMP_IF_TRUE(has_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_INVENTORY))    
    JUMP_IF_TRUE(draw_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_INSIDEHOLE))  

cannot_escape_pit    ; The player has no way to escape the pit
    WAIT(50*2)
    .byt COMMAND_BLACK_BUBBLE,1
#ifdef LANGUAGE_FR    
    .byt 6,8,0,"Ca ne semblait",0
#else    
    .byt 6,8,0,"It did not look",0
#endif    
    WAIT(50)
    .byt COMMAND_BLACK_BUBBLE,1
#ifdef LANGUAGE_FR    
    .byt 156,42,0,"pas si profond",0
#else    
    .byt 176,42,0,"that deep",0
#endif    
    WAIT(50)
    .byt COMMAND_BLACK_BUBBLE,1
#ifdef LANGUAGE_FR    
    .byt 82,94,0,"vu de là haut",0
#else    
    .byt 82,94,0,"from outside",0
#endif    
    WAIT(50*2)                      ; Wait a couple seconds for dramatic effect
    
    JUMP(_gDescriptionGameOverLost);            ; Draw the 'The End' logo

draw_ladder
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(4,50),40,_SecondImageBuffer+36,_ImageBuffer+(40*40)+19)    ; Draw the ladder 
has_ladder
    END

rope_attached_to_tree
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(3,52),40,_SecondImageBuffer+(40*51)+37,_ImageBuffer+(40*39)+19)    ; Draw the rope 
    END
.)


_gDescriptionOutsidePit
.(
    JUMP_IF_FALSE(no_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_OUTSIDE_PIT))
    JUMP_IF_TRUE(ladder_in_hole,CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED))
no_ladder

    JUMP_IF_FALSE(no_rope,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_OUTSIDE_PIT))
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
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 5,93,0,"Cherchent ils",0
    .byt 5,101,4,"de l'or ?",0
#else
    .byt 5,90,0,"Are they digging",0
    .byt 8,103,0,"for gold?",0
#endif    
    END
.)

_gDescriptionTarmacArea
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 119,5,0,"De cendres à cendres",0
    .byt 124,13,3,"De rouille à rouille",0
#else
    .byt 149,5,0,"Ashes to Ashes",0
    .byt 152,15,0,"Rust to Rust...",0
#endif    
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
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 121,5,0,"Ce puit semble aussi",0
    .byt 138,16,0,"vieux que l'église",0
#else
    .byt 111,5,0,"This well looks as old",0
    .byt 158,16,0,"as the church",0
#endif    
    END

_gDescriptionWoodedAvenue
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 4,4,0,"Ces arbres ont probablement",0
    .byt 4,15,0,"été témoin de beaucoup de choses",0
#else
    .byt 4,4,0,"These trees have probably",0
    .byt 4,14,1,"witnessed many things",0
#endif    
    END

_gDescriptionGravelDrive
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,3
#ifdef LANGUAGE_FR   
    .byt 180,86,0,"Plutôt",0
    .byt 150,97,0,"impressionnant",0
    .byt 176,107,2,"vu de loin",0
#else
    .byt 127,86,0,"Kind of impressive",0
    .byt 143,97,0,"when seen from",0
    .byt 182,107,0,"far away",0
#endif    
    END

_gDescriptionZenGarden
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 9,5,0,"Un jardin zen japonais ?",0
    .byt 5,17,0,"En Angleterre ?",0
#else    
    .byt 4,4,0,"A Japanese Zen Garden?",0
    .byt 4,15,1,"In England?",0
#endif    
    END

_gDescriptionFrontLawn
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 5,5,0,"La maison parfaite",0
    .byt 5,15,0,"pour les égocentriques",0
#else    
    .byt 5,5,0,"The perfect home",0
    .byt 5,15,1,"for egomaniacs",0
#endif    
    END

_gDescriptionGreenHouse
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 4,5,0,"Evidemment pour",0
    .byt 4,17,0,34,"Usage thérapeutique",34,0
#else
    .byt 4,96,0,"Obviously for",0
    .byt 4,107,1,34,"Therapeutic use",34,0
#endif
    END

_gDescriptionTennisCourt
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 5,5,0,"Bein voila: Un vrai court",0
    .byt 5,16,0,"de tennis sur gazon",0
#else
    .byt 4,4,0,"That's more like it:",0
    .byt 4,15,0,"a proper lawn tennis court",0
#endif    
    END

_gDescriptionVegetableGarden
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 102,5,0,"Pas le meilleur endroit",0
    .byt 97,15,0,"faire pousser des tomates",0
#else    
    .byt 134,5,0,"Not the best spot",0
    .byt 136,15,1,"to grow tomatoes",0
#endif
    END

_gDescriptionFishPond
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 5,5,0,"Certains de ces poissons",0
    .byt 5,17,0,"sont étonnamment gros",0
#else    
    .byt 5,5,0,"Some of these fishes",0
    .byt 5,17,0,"are surprinsingly big",0
#endif    
    END

_gDescriptionTiledPatio
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 107,5,0,"Ici on accède à l'entrée",0
    .byt 125,13,3,"arrière de la maison",0
#else
    .byt 93,5,0,"The house's back entrance",0
    .byt 110,15,0,"is accessible from here",0
#endif    
    END

_gDescriptionAppleOrchard
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 5,5,0,"La meilleure sorte de pommes:",0
    .byt 5,17,0,"sucrées, croquantes et juteuses",0
#else 
    .byt 5,5,0,"The best kind of apples:",0
    .byt 5,17,0,"sweet, crunchy and juicy",0
#endif
    END

_gDescriptionEntranceHall
.(
    ; Is there a dog in the entrance
    JUMP_IF_FALSE(end_dog,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOCATION_ENTRANCEHALL))

    ; Is the dog dead?
    JUMP_IF_FALSE(dog_alive,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
      ; Draw the dead dog
      DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(6,12),40,_SecondImageBuffer+40*24+7,_ImageBuffer+(40*44)+18)    
      ; Text describing the dead dog
      WAIT(DELAY_FIRST_BUBBLE)
      .byt COMMAND_WHITE_BUBBLE,2
      .byt 5,5,0,"Let's call that a ",0
      .byt 5,17,0,"Collateral Damage",34,0
      END
      
dog_alive
    ; Draw the Growling dog
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(7,30),40,_SecondImageBuffer+(40*31)+0,_ImageBuffer+(40*25)+18)    

    ; Text describing the growling dog
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,1
#ifdef LANGUAGE_FR
    .byt 5,105,0,"Serait-ce Cerbère ?",0
#else
    .byt 5,105,0,"Is that Cerberus?",0
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
    .byt COMMAND_WHITE_BUBBLE,2
    .byt 124,5,0,"Quite an impressive",0
    .byt 187,17,0,"staircase",0
    END
.)


_gDescriptionStaircase
.(
    ; Is there a dog in the entrance
    JUMP_IF_FALSE(end_dog,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOCATION_LARGE_STAIRCASE))

    ; Is the dog dead?
    JUMP_IF_FALSE(dog_alive,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
      ; Draw the dead dog
      DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(17,34),40,_SecondImageBuffer+40*95,_ImageBuffer+(40*93)+12)    
      ; Text describing the dead dog
      WAIT(DELAY_FIRST_BUBBLE)
      .byt COMMAND_WHITE_BUBBLE,2
      .byt 5,5,0,"Let's call that a ",0
      .byt 5,17,0,"Collateral Damage",34,0
      END
      
dog_alive
    ; If the dog is alive, it will jump on our face now
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(21,128),40,_SecondImageBuffer+19,_ImageBuffer+(40*0)+10)    ; Draw the attacking dog
     ;
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,1
    .byt 5,108,0,"Oops...",0
    WAIT(50*2)                              ; Wait a couple seconds
    JUMP(_gDescriptionGameOverLost)         ; Game Over

end_dog
    ; Some generic message in case the dog is not there (probably not displayed right now)
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
    .byt 124,5,0,"Quite an impressive",0
    .byt 187,17,0,"staircase",0
    END
.)    

_gDescriptionDogAttacking
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(21,128),40,_SecondImageBuffer+14,_ImageBuffer+(40*0)+10)    ; Draw the attacking dog
     ;
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,1
    .byt 5,108,0,"Oops...",0
    WAIT(50*2)                              ; Wait a couple seconds
    JUMP(_gDescriptionGameOverLost)         ; Game Over
    /*
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,3
#ifdef LANGUAGE_FR    
    .byt 16,8,0,"Gauche ?",0
    .byt 179,8,0,"Droite ?",0
    .byt 45,72,0,"est-ce vraiment important ?",0
#else
    .byt 16,8,0,"Left?",0
    .byt 179,8,0,"Right?",0
    .byt 60,72,0,"does it really matter?",0
#endif    
    END
    */


_gDescriptionLibrary
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 5,99,0,"Livres, cheminée et",0
    .byt 5,105,4,"un bon fauteuil",0
#else
    .byt 5,86,0,"Books, fireplace, and",0
    .byt 5,97,0,"a comfortable chair",0
#endif    
    END

_gDescriptionNarrowPassage
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BLACK_BUBBLE,3
#ifdef LANGUAGE_FR
    .byt 5,48,0,"Soit ils aiment le noir",0
    .byt 12,68,0,"soit ils ont oublié",0
    .byt 27,88,0,"de payer leurs",0
#else
    .byt 5,48,0,"Either they love dark",0
    .byt 12,68,0,"or they forgot to",0
    .byt 37,88,0,"pay their",0
#endif
    .byt COMMAND_WHITE_BUBBLE,1
#ifdef LANGUAGE_FR    
    .byt 55,108,0,"factures",0
#else
    .byt 75,108,0,"bills",0
#endif    
    END

_gDescriptionEntranceLounge
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR       
    .byt 5,5,0,"On dirait que quelqu'un",0
    .byt 12,13,4,"s'est bien amusé",0
#else    
    .byt 5,5,0,"Looks like someone",0
    .byt 5,15,0,"had fun",0
#endif    
    END

_gDescriptionDiningRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR
    .byt 5,100,0,"Deux assiettes...",0
    .byt 5,107,4,"...bon à savoir",0
#else
    .byt 5,95,0,"Two plates...",0
    .byt 5,107,0,"...good to know",0
#endif    
    END

_gDescriptionGamesRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR
    .byt 155,5,0,"Système vidéo",0
    .byt 151,16,0,"haut de gamme",0
#else
    .byt 142,5,0,"Top of the range",0
    .byt 164,16,0,"video system",0
#endif
    WAIT(50)

    .byt COMMAND_WHITE_BUBBLE,1
#ifdef LANGUAGE_FR    
    .byt 151,40,0,"Impressionnant",0
#else
    .byt 175,40,0,"Impressive",0
#endif    
    END

_gDescriptionSunLounge
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,1
#ifdef LANGUAGE_FR    
    .byt 80,5,0,"Pas de répit pour les braves",0
#else
    .byt 112,5,0,"No rest for the weary",0
#endif    
    END

_gDescriptionKitchen
.(
    ; Is the fridge open?
    JUMP_IF_TRUE(fridge_closed,CHECK_ITEM_FLAG(e_ITEM_Fridge,ITEM_FLAG_CLOSED))
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(4,52),40,_SecondImageBuffer+40*64+0,_ImageBuffer+40*22+26)       ; Fridge open
:fridge_closed

    ; Is the medicine cabinet open?
    JUMP_IF_TRUE(medicine_cabinet_closed,CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED))
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(4,23),40,_SecondImageBuffer+40*64+4,_ImageBuffer+40*30+33)       ; Medicine cabinet open
:medicine_cabinet_closed

    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 5,5,0,"Une cuisine",0
    .byt 5,16,0,"bien équipée",0
#else
    .byt 5,5,0,"A well equipped",0
    .byt 5,14,4,"kitchen",0
#endif    
    END
.)


_gDescriptionNarrowStaircase
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BLACK_BUBBLE,1
#ifdef LANGUAGE_FR       
    .byt 5,5,0,"Attention à la marche",0
#else
    .byt 5,5,0,"Watch your step",0
#endif    
    END

_gDescriptionCellar
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BLACK_BUBBLE,2
#ifdef LANGUAGE_FR       
    .byt 45,15,0,"Est-ce un coffre-fort",0
    .byt 70,25,0,"Franz Jager ?",0
#else
    .byt 75,15,0,"Is that a Franz",0
    .byt 80,25,0,"Jager safe?",0
#endif    
    END

_gDescriptionDarkerCellar
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BLACK_BUBBLE,2
#ifdef LANGUAGE_FR   
    .byt 5,99,0,"La fenêtre semble",0
    .byt 5,106,4,"occultée",0
#else
    .byt 5,99,0,"The window seems",0
    .byt 5,109,0,"to be occulted",0
#endif    
    END



_gDescriptionMainLanding
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,1
#ifdef LANGUAGE_FR    
    .byt 53,70,0,"Belle vue de là-haut",0
#else
    .byt 47,70,0,"Nice view from up there",0
#endif    
    END

_gDescriptionEastGallery
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 5,5,0,"Couloir ennuyeux:",0
    .byt 20,13,4,"Vérifié",0
#else
    .byt 5,5,0,"Boring corridor:",0
    .byt 20,17,0,"Check",0
#endif    
    END

_gDescriptionChildBedroom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR
    .byt 5,86,0,"Laisse-moi deviner:",0
    .byt 5,94,4,"Chambre d'adolescent ?",0
#else
    .byt 5,96,0,"Let me guess:",0
    .byt 5,107,0,"Teenager room?",0
#endif    
    END

_gDescriptionGuestBedroom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR
    .byt 5,6,0,"Simple et rafraichissant",0
    .byt 5,17,0,"pour changer",0
#else
    .byt 5,6,0,"Simple and fresh",0
    .byt 5,17,0,"for a change",0
#endif    
    END

_gDescriptionShowerRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 145,5,0,"J'en aurai besoin",0
    .byt 136,16,0,"quand j'aurai fini",0
#else
    .byt 149,5,0,"I will need one",0
    .byt 152,16,0,"when I'm done",0
#endif    
    END

_gDescriptionWestGallery
    ; Is the curtain closed?
    JUMP_IF_FALSE(curtain_open,CHECK_ITEM_FLAG(e_ITEM_Curtain,ITEM_FLAG_CLOSED))
:curtain_closed
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(8,62),40,_SecondImageBuffer+0,_ImageBuffer+40*5+20)       ; Closed curtain
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BLACK_BUBBLE,1
#ifdef LANGUAGE_FR    
    .byt 70,81,0,"Au théatre ce soir...",0
#else
    .byt 55,81,0,"At the theater tonight...",0
#endif    
    END

:curtain_open    
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BLACK_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 85,81,0,"Est-ce de l'acier",0
    .byt 60,92,0,"derrière le rideau ?",0
#else
    .byt 85,81,0,"Is that Steel",0
    .byt 60,92,0,"behind the Curtain?",0
#endif    
    END

_gDescriptionBoxRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR    
    .byt 5,5,0,"Une petite pièce",0
    .byt 5,12,4,"utilitaire",0
#else
    .byt 5,5,0,"A practical",0
    .byt 5,16,0,"little room",0
#endif    
    END

_gDescriptionClassyBathRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,1
#ifdef LANGUAGE_FR    
    .byt 132,5,0,"Semble comfortable",0
#else
    .byt 132,5,0,"Looks comfortable",0
#endif    
    END

_gDescriptionTinyToilet
    WAIT(DELAY_FIRST_BUBBLE)
#ifdef LANGUAGE_FR    
    .byt COMMAND_WHITE_BUBBLE,2
    .byt 160,5,0,"Une propreté",0
    .byt 173,13,4,"étincelante",0
#else
    .byt COMMAND_WHITE_BUBBLE,1
    .byt 137,5,0,"Sparklingly clean",0
#endif    
    END

_gDescriptionMasterBedRoom
    ; Is there a thug in the master bedroom
    JUMP_IF_FALSE(end_thug,CHECK_ITEM_LOCATION(e_ITEM_Thug,e_LOCATION_MASTERBEDROOM))

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
      .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR
      .byt 10,5,0,"Appelons cela un",0
      .byt 5,18,0,34,"dommage collatéral",34,0
#else
      .byt 5,5,0,"Let's call that a ",0
      .byt 5,17,0,34,"Collateral Damage",34,0
#endif      
      END

thug_alive
    ; Draw the thug Sleeping
    DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(18,37),40,_SecondImageBuffer+40*91,_ImageBuffer+40*52+17)   ; Thug sleeping
    DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(8,23),40,_SecondImageBuffer+32,_ImageBuffer+40*33+30)       ; Zzzz over the head
    ; Draw the message
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
#ifdef LANGUAGE_FR
    .byt 5,5,0,"Cela rendra les choses",0
    .byt 5,16,0,"nettement plus faciles...",0
#else
    .byt 5,5,0,"This will make things",0
    .byt 5,16,0,"notably easier...",0
#endif    
    ; Should probably have a "game over" command
    END
    
end_thug    
    ; Draw the message
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
    .byt 5,5,0,"This was make things",0
    .byt 5,16,0,"notably easier...",0
    ; Should probably have a "game over" command
    .byt COMMAND_FADE_BUFFER
    END

_gDescriptionThugAttacking
    DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(18,105),40,_SecondImageBuffer+40*23+22,_ImageBuffer+(40*21)+13)    ; Draw the attacking thug
    DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(14,56),40,_SecondImageBuffer+40*34+0,_ImageBuffer+(40*1)+23)       ; Now You Die!
    ; Draw the message
    WAIT(50*2)                              ; Wait a couple seconds
    .byt COMMAND_WHITE_BUBBLE,2
    .byt 5,5,0,"This was a mistake:",0
    .byt 60,16,0,"My last one",0
    WAIT(50*2)                              ; Wait a couple seconds
    JUMP(_gDescriptionGameOverLost)         ; Game Over


_gDescriptionPadlockedRoom
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,4
#ifdef LANGUAGE_FR    
    .byt 5,5,0,"Damn...",0
    .byt 135,16,0,"Je ne pourrai pas",0
    .byt 131,53,0,"ouvrir ces serrures",0
    .byt 140,90,0,"assez vite !",0
#else
    .byt 5,5,0,"Damn...",0
    .byt 125,16,0,"I will never be able",0
    .byt 131,53,0,"to pick these locks",0
    .byt 140,90,0,"fast enough!",0
#endif    
    END


_gDescriptionGameOverLost
    ; Draw the 'The End' logo
    DRAW_BITMAP(LOADER_SPRITE_THE_END,BLOCK_SIZE(20,95),20,_SecondImageBuffer,_ImageBuffer+(40*16)+10)
    ; Should probably have a "game over" command
    .byt COMMAND_FADE_BUFFER
    END
_EndSceneScripts


// Scene actions
_StartSceneActions

_gSceneActionReadNewsPaper
    DISPLAY_IMAGE(LOADER_PICTURE_NEWSPAPER,"The Daily Telegraph, September 29th")
    INFO_MESSAGE("I have to find her fast...")
    WAIT(50*2)
    INFO_MESSAGE("...I hope she is fine!")
    WAIT(50*2)
    END_AND_REFRESH

_gSceneActionReadHandWrittenNote
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

_gSceneActionReadChemistryRecipes
    DISPLAY_IMAGE(LOADER_PICTURE_CHEMISTRY_RECIPES,"A few useful recipes")
    WAIT(50*2)
    INFO_MESSAGE("I can definitely use these...")
    WAIT(50*2)
    INFO_MESSAGE("...just need to find the materials.")
    WAIT(50*2)
    END_AND_REFRESH


_gSceneActionReadChemistryBook
.(
    DISPLAY_IMAGE(LOADER_PICTURE_SCIENCE_BOOK,"A science book")
    WAIT(50*2)
    INFO_MESSAGE("I don't understand much...")
    WAIT(50*2)
    INFO_MESSAGE("...oh, I found something!")
    WAIT(50*2)
    // If the recipes were not yet found, they now appear at the current location
    JUMP_IF_FALSE(recipe_already_found,CHECK_ITEM_LOCATION(e_ITEM_ChemistryRecipes,e_LOCATION_NONE))
    SET_ITEM_LOCATION(e_ITEM_ChemistryRecipes,e_LOCATION_LIBRARY)
recipe_already_found
    END_AND_REFRESH
.)


_gSceneActionInspectMap
    DISPLAY_IMAGE(LOADER_PICTURE_UK_MAP,"A map of the United Kingdom")
    INFO_MESSAGE("It shows Ireland, Wales and England")
    WAIT(50*2)
    END

_gSceneActionInspectGame
    DISPLAY_IMAGE(OADER_PICTURE_DONKEY_KONG_TOP,"A handheld game")
    INFO_MESSAGE("State of the art hardware!")
    WAIT(50*2)
    END

_gSceneActionPlayGame
    DISPLAY_IMAGE(LOADER_PICTURE_DONKEY_KONG_PLAYING,"A handheld game")
    INFO_MESSAGE("Hum... looks like it crashed?")
    WAIT(50*2)
    END

_gSceneActionFridgeDoor
    DISPLAY_IMAGE(LOADER_PICTURE_FRIDGE_DOOR,"Let's look at that fridge")
    INFO_MESSAGE("Looks like a happy familly...")
    WAIT(50*2)
    INFO_MESSAGE("...I wonder where they are?")
    WAIT(50*2)
    END

_gSceneActionDogEatingMeat
    DISPLAY_IMAGE(LOADER_PICTURE_DOG_EATING_MEAT,"Quite a hungry dog!")
    INFO_MESSAGE("Glad it's not me there!")
    WAIT(50*2)
    END

_gSceneActionExaminePlasticBag
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Juste un sac blanc normal")
#else
    ERROR_MESSAGE("It's just a white generic bag")
#endif    
    END

_EndSceneActions


_EndGameTextData

;
; Print statistics about the size of things
;
#print Total size of game text content = (_EndGameTextData - _StartGameTextData)
#print - Messages and prompts = (_EndMessagesAndPrompts - _StartMessagesAndPrompts)
#print - Error messages = (_EndErrorMessages - _StartErrorMessages)
#print - Location names = (_EndLocationNames - _StartLocationNames)
#print - Item names = (_EndItemNames - _StartItemNames)
#print - Scene scripts = (_EndSceneScripts - _StartSceneScripts)
#print - Scene actions = (_EndSceneActions - _StartSceneActions)


