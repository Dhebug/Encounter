
#include "params.h"
#include "../build/floppy_description.h"
#include "game_enums.h"

    .text

_StartGameTextData

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i ô:^
#endif


/*

 ██████╗ ███████╗███╗   ██╗███████╗██████╗ ██╗ ██████╗    ███╗   ███╗███████╗███████╗███████╗ █████╗  ██████╗ ███████╗███████╗
██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔══██╗██║██╔════╝    ████╗ ████║██╔════╝██╔════╝██╔════╝██╔══██╗██╔════╝ ██╔════╝██╔════╝
██║  ███╗█████╗  ██╔██╗ ██║█████╗  ██████╔╝██║██║         ██╔████╔██║█████╗  ███████╗███████╗███████║██║  ███╗█████╗  ███████╗
██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██╗██║██║         ██║╚██╔╝██║██╔══╝  ╚════██║╚════██║██╔══██║██║   ██║██╔══╝  ╚════██║
╚██████╔╝███████╗██║ ╚████║███████╗██║  ██║██║╚██████╗    ██║ ╚═╝ ██║███████╗███████║███████║██║  ██║╚██████╔╝███████╗███████║
 ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝    ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝
                                                                                                                              
*/
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
_gTextDeadThug              .byt "un malfaiteur mort",0
_gTextDogGrowlingAtYou      .byt "un alsacien menacant",0
_gTextThugAsleepOnBed       .byt "un malfaiteur assoupi sur le lit",0
_gTextNotDead               .byt "Pas mort",0                                // Debugging text
_gTextDogJumpingAtMe        .byt "un chien qui me saute dessus",0
_gTextThugShootingAtMe      .byt "un malfaiteur qui me tire dessus",0
#else
_gTextAskInput              .byt "What are you going to do now?",0
_gTextNothingHere           .byt "There is nothing of interest here",0
_gTextCanSee                .byt "I can see ",0
_gTextScore                 .byt "Score:",0
_gTextCarryInWhat           .byt "Carry it in what?",0
_gTextPetrolEvaporates      .byt "The petrol evaporates",0
_gTextWaterDrainsAways      .byt "The water drains away",0
_gTextDeadThug              .byt "a dead thug",0
_gTextDogGrowlingAtYou      .byt "an alsatian growling at you",0
_gTextThugAsleepOnBed       .byt "a thug asleep on the bed",0
_gTextNotDead               .byt "Not dead",0                                // Debugging text
_gTextDogJumpingAtMe        .byt "a dog jumping at me",0
_gTextThugShootingAtMe      .byt "a thug shooting at me",0
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
_gTextErrorCannotUseHere    .byt "Pas utilisable ici",0
_gTextErrorDontKnowUsage    .byt "Je ne sais pas l'utiliser",0
_gTextErrorCannotAttachRope .byt "Impossible de l'attacher",0
_gTextErrorLadderInHole     .byt "L'échelle est déja dans le trou",0
_gTextErrorCantClimbThat    .byt "Je ne sais pas grimper ca",0
_gTextErrorNeedPositionned  .byt "Ca doit d'abort être en place",0
_gTextErrorItsNotHere       .byt "Ca n'est pas là",0
_gTextErrorAlreadyDealtWith .byt "Plus un problème",0
_gTextErrorShouldSaveGirl   .byt "Vous êtes censé la sauver",0
_gTextErrorInappropriate    .byt "Probablement inapproprié",0
_gTextErrorDeadDontMove     .byt "Les morts ne bougent pas",0
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
_gTextErrorCannotUseHere    .byt "I can't use it here",0
_gTextErrorDontKnowUsage    .byt "I don't know how to use that",0
_gTextErrorCannotAttachRope .byt "You can't attach the rope",0
_gTextErrorLadderInHole     .byt "The ladder is already in the hole",0
_gTextErrorCantClimbThat    .byt "I don't know how to climb that",0
_gTextErrorNeedPositionned  .byt "It needs to be positionned first",0
_gTextErrorItsNotHere       .byt "It's not here",0
_gTextErrorAlreadyDealtWith .byt "Not a problem anymore",0
_gTextErrorShouldSaveGirl   .byt "You are supposed to save her",0
_gTextErrorInappropriate    .byt "Probably inappropriate",0
_gTextErrorDeadDontMove     .byt "Dead don't move",0
#endif
_EndErrorMessages


/*

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


/*

██╗████████╗███████╗███╗   ███╗███████╗
██║╚══██╔══╝██╔════╝████╗ ████║██╔════╝
██║   ██║   █████╗  ██╔████╔██║███████╗
██║   ██║   ██╔══╝  ██║╚██╔╝██║╚════██║
██║   ██║   ███████╗██║ ╚═╝ ██║███████║
╚═╝   ╚═╝   ╚══════╝╚═╝     ╚═╝╚══════╝
                                       
*/
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
_gTextItemHandheldGame            .byt "un jeu portable",0
_gTextItemMedicineCabinet         .byt "une armoire à pharmacie",0
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
_gTextItemFridge                  .byt "a fridge",0                        // TODO: Use _gSceneActionCloseFridge description
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
_gTextItemClosedCurtain           .byt "a closed curtain",0             // TODO: Use _gSceneActionCloseCurtain description
_gTextItemHandheldGame            .byt "a handheld game",0
_gTextItemMedicineCabinet         .byt "a medicine cabinet",0           // TODO: Use _gSceneActionCloseMedicineCabinet description
_gTextItemSedativePills           .byt "some sedative pills",0
_gTextItemSedativeLacedMeat       .byt "drugged meat",0
#endif
_EndItemNames


/*

███████╗ ██████╗███████╗███╗   ██╗███████╗    ██████╗ ███████╗███████╗ ██████╗██████╗ ██╗██████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
██╔════╝██╔════╝██╔════╝████╗  ██║██╔════╝    ██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
███████╗██║     █████╗  ██╔██╗ ██║█████╗      ██║  ██║█████╗  ███████╗██║     ██████╔╝██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║███████╗
╚════██║██║     ██╔══╝  ██║╚██╗██║██╔══╝      ██║  ██║██╔══╝  ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║╚════██║
███████║╚██████╗███████╗██║ ╚████║███████╗    ██████╔╝███████╗███████║╚██████╗██║  ██║██║██║        ██║   ██║╚██████╔╝██║ ╚████║███████║
╚══════╝ ╚═════╝╚══════╝╚═╝  ╚═══╝╚══════╝    ╚═════╝ ╚══════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
                                                                                                                                        
*/
_StartSceneScripts
_gDescriptionTeenagerRoom         .byt "Teenager room?",0

_gDescriptionNone
    END

_gDescriptionDarkTunel
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

_gDescriptionMarketPlace
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
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(8,11),40,_SecondImageBuffer+(40*116)+32,$a000+(14*40)+11)    ; Draw the Fish Shop "grayed out"
    WAIT(50) 
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(8,11),40,_SecondImageBuffer+(40*104)+32,$a000+(14*40)+11)    ; Draw the Fish Shop "fully drawn"
    WAIT(50)
    JUMP(blinky_shop)
    ;END


_gDescriptionDarkAlley
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

_gDescriptionRoad
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

_gDescriptionMainStreet
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

_gDescriptionNarrowPath
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

_gDescriptionInThePit
.(
    ; If the rope is outside the pit and is attached to the tree, we move it inside  the pit
    JUMP_IF_FALSE(end_rope_check,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_OUTSIDE_PIT))
    JUMP_IF_FALSE(end_rope_check,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_INSIDE_PIT)
end_rope_check

    ; If the ladder is outside the pit and is in place, we move it inside the pit
    JUMP_IF_FALSE(end_ladder_check,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_OUTSIDE_PIT))
    JUMP_IF_FALSE(end_ladder_check,CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_INSIDE_PIT)
end_ladder_check

    ; Check items
    SET_LOCATION_DIRECTION(e_LOCATION_INSIDE_PIT,e_DIRECTION_UP,e_LOCATION_NONE)      ; Disable the UP direction

    JUMP_IF_FALSE(no_rope,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_INSIDE_PIT))
    JUMP_IF_TRUE(rope_attached_to_tree,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
no_rope    

    JUMP_IF_TRUE(has_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_INVENTORY))    
    JUMP_IF_TRUE(draw_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_INSIDE_PIT))  

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
    JUMP(_gDescriptionGameOverLost);                ; Draw the 'The End' logo

draw_ladder
    SET_LOCATION_DIRECTION(e_LOCATION_INSIDE_PIT,e_DIRECTION_UP,e_LOCATION_OUTSIDE_PIT)                   ; Enable the UP direction
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(4,50),40,_SecondImageBuffer+36,_ImageBuffer+(40*40)+19)    ; Draw the ladder 
has_ladder
    END

rope_attached_to_tree
    SET_LOCATION_DIRECTION(e_LOCATION_INSIDE_PIT,e_DIRECTION_UP,e_LOCATION_OUTSIDE_PIT)                           ; Enable the UP direction
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(3,52),40,_SecondImageBuffer+(40*51)+37,_ImageBuffer+(40*39)+19)    ; Draw the rope 
    END
.)


_gDescriptionOutsidePit
.(
    ; If the rope is inside the pit and is attached to the tree, we move it outside the pit
    JUMP_IF_FALSE(end_rope_check,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_INSIDE_PIT))
    JUMP_IF_FALSE(end_rope_check,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_OUTSIDE_PIT)
end_rope_check

    ; If the ladder is inside the pit and is in place, we move it outside the pit
    JUMP_IF_FALSE(end_ladder_check,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_INSIDE_PIT))
    JUMP_IF_FALSE(end_ladder_check,CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_OUTSIDE_PIT)
end_ladder_check

    ; Check items
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

_gDescriptionTarmacArea
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
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(121,5,0,"Ce puit semble aussi")
    _BUBBLE_LINE(138,16,0,"vieux que l'église")
#else
    _BUBBLE_LINE(111,5,0,"This well looks as old")
    _BUBBLE_LINE(158,16,0,"as the church")
#endif    
    END

_gDescriptionWoodedAvenue
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

_gDescriptionGravelDrive
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

_gDescriptionZenGarden
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

_gDescriptionFrontLawn
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

_gDescriptionGreenHouse
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

_gDescriptionTennisCourt
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

_gDescriptionVegetableGarden
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

_gDescriptionFishPond
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

_gDescriptionTiledPatio
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

_gDescriptionAppleOrchard
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

_gDescriptionEntranceHall
.(
    ; If the dog is in the staircase, we move it to the entrance hall to simplify the rest of the code
    JUMP_IF_FALSE(end_dog_check,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOCATION_LARGE_STAIRCASE))
    SET_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOCATION_ENTRANCEHALL)
end_dog_check

    ; Is there a dog in the entrance
    JUMP_IF_FALSE(end_dog,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOCATION_ENTRANCEHALL))

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


_gDescriptionStaircase
.(
    ; If the dog is in the entrance hall, we move it to the staircase to simplify the rest of the code
    JUMP_IF_FALSE(end_dog_check,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOCATION_ENTRANCEHALL))
    SET_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOCATION_LARGE_STAIRCASE)
end_dog_check

    ; Is there a dog in the entrance
    JUMP_IF_FALSE(end_dog,CHECK_ITEM_LOCATION(e_ITEM_AlsatianDog,e_LOCATION_LARGE_STAIRCASE))

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
     ;
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
    _BUBBLE_LINE(5,108,0,"Oops...")
    WAIT(50*2)                              ; Wait a couple seconds
    JUMP(_gDescriptionGameOverLost)         ; Game Over

end_dog
    ; Some generic message in case the dog is not there (probably not displayed right now)
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(124,5,0,"Quite an impressive")
    _BUBBLE_LINE(187,17,0,"staircase")
    END
.)    

_gDescriptionDogAttacking
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(21,128),40,_SecondImageBuffer+14,_ImageBuffer+(40*0)+10)    ; Draw the attacking dog
     ;
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
    _BUBBLE_LINE(5,108,0,"Oops...")
    WAIT(50*2)                                      ; Wait a couple seconds
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_MAIMED_BY_DOG)   ; Achievement!
    JUMP(_gDescriptionGameOverLost)                 ; Game Over
    /*
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(3)
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
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(5,99,0,"Livres, cheminée et")
    _BUBBLE_LINE(5,105,4,"un bon fauteuil")
#else
    _BUBBLE_LINE(5,86,0,"Books, fireplace, and")
    _BUBBLE_LINE(5,97,0,"a comfortable chair")
#endif    
    END

_gDescriptionNarrowPassage
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

_gDescriptionEntranceLounge
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

_gDescriptionDiningRoom
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

_gDescriptionGamesRoom
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

_gDescriptionSunLounge
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(80,5,0,"Pas de répit pour les braves")
#else
    _BUBBLE_LINE(112,5,0,"No rest for the weary")
#endif    
    END

_gDescriptionKitchen
.(
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


_gDescriptionNarrowStaircase
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR       
    _BUBBLE_LINE(5,5,0,"Attention à la marche")
#else
    _BUBBLE_LINE(5,5,0,"Watch your step")
#endif    
    END

_gDescriptionCellar
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR       
    _BUBBLE_LINE(45,15,0,"Est-ce un coffre-fort")
    _BUBBLE_LINE(70,25,0,"Franz Jager ?")
#else
    _BUBBLE_LINE(75,15,0,"Is that a Franz")
    _BUBBLE_LINE(80,25,0,"Jager safe?")
#endif    
    END

_gDescriptionDarkerCellar
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR   
    _BUBBLE_LINE(5,99,0,"La fenêtre semble")
    _BUBBLE_LINE(5,106,4,"occultée")
#else
    _BUBBLE_LINE(5,99,0,"The window seems")
    _BUBBLE_LINE(5,109,0,"to be occulted")
#endif    
    END



_gDescriptionMainLanding
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(53,70,0,"Belle vue de là-haut")
#else
    _BUBBLE_LINE(47,70,0,"Nice view from up there")
#endif    
    END

_gDescriptionEastGallery
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

_gDescriptionChildBedroom
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

_gDescriptionGuestBedroom
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

_gDescriptionShowerRoom
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

_gDescriptionWestGallery
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

_gDescriptionBoxRoom
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

_gDescriptionClassyBathRoom
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR    
    _BUBBLE_LINE(132,5,0,"Semble comfortable")
#else
    _BUBBLE_LINE(132,5,0,"Looks comfortable")
#endif    
    END

_gDescriptionTinyToilet
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
    .byt COMMAND_FADE_BUFFER
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
    JUMP(_gDescriptionGameOverLost)                 ; Game Over


_gDescriptionPadlockedRoom
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
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_NEWSPAPER)   ; Achievement!    
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
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_NOTE)   ; Achievement!    
    END_AND_REFRESH

_gSceneActionReadChemistryRecipes
    DISPLAY_IMAGE(LOADER_PICTURE_CHEMISTRY_RECIPES,"A few useful recipes")
    WAIT(50*2)
    INFO_MESSAGE("I can definitely use these...")
    WAIT(50*2)
    INFO_MESSAGE("...just need to find the materials.")
    WAIT(50*2)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_RECIPES)   ; Achievement!    
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
    SET_ITEM_LOCATION(e_ITEM_ChemistryRecipes,e_LOCATION_INVENTORY)
recipe_already_found
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_BOOK)   ; Achievement!
    END_AND_REFRESH
.)


_gSceneActionInspectMap
    DISPLAY_IMAGE(LOADER_PICTURE_UK_MAP,"A map of the United Kingdom")
    INFO_MESSAGE("It shows Ireland, Wales and England")
    WAIT(50*2)
    END_AND_REFRESH

_gSceneActionInspectGame
    DISPLAY_IMAGE(LOADER_PICTURE_DONKEY_KONG_TOP,"A handheld game")
    INFO_MESSAGE("State of the art hardware!")
    WAIT(50*2)
    END_AND_REFRESH

_gSceneActionInspectChemistryBook
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un livre épais avec des marques")
#else    
    INFO_MESSAGE("A thick book with some bookmarks")
#endif    
    WAIT(50*2)
    END_AND_REFRESH

_gSceneActionInspectFridgeDoor
    DISPLAY_IMAGE(LOADER_PICTURE_FRIDGE_DOOR,"Let's look at that fridge")
    INFO_MESSAGE("Looks like a happy familly...")
    WAIT(50*2)
    INFO_MESSAGE("...I wonder where they are?")
    WAIT(50*2)
    END_AND_REFRESH

_gSceneActionInspectMedicineCabinet
.(
    ; Is the medicine cabinet open?
    JUMP_IF_TRUE(medicine_cabinet_closed,CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED))
medicine_cabinet_open
    DISPLAY_IMAGE(LOADER_PICTURE_MEDICINE_CABINET_OPEN,"Inside the medicine cabinet")
    INFO_MESSAGE("I can use some of that.")
    WAIT(50*2)
    END_AND_REFRESH

medicine_cabinet_closed
    DISPLAY_IMAGE(LOADER_PICTURE_MEDICINE_CABINET,"A closed medicine cabinet")
    INFO_MESSAGE("Not much to see when closed.")
    WAIT(50*2)
    END_AND_REFRESH
.)

_gSceneActionPlayGame
    DISPLAY_IMAGE(LOADER_PICTURE_DONKEY_KONG_PLAYING,"A handheld game")
    INFO_MESSAGE("Hum... looks like it crashed?")
    WAIT(50*2)
    END_AND_REFRESH

_gSceneActionExaminePlasticBag
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Juste un sac blanc normal")
#else
    ERROR_MESSAGE("It's just a white generic bag")
#endif    
    END




/*
                     ██████╗ ██████╗ ███████╗███╗   ██╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
                    ██╔═══██╗██╔══██╗██╔════╝████╗  ██║    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
                    ██║   ██║██████╔╝█████╗  ██╔██╗ ██║    ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
                    ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║    ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
                    ╚██████╔╝██║     ███████╗██║ ╚████║    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
                     ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝                                                                                    
*/
_gSceneActionOpenCurtain
.(
    JUMP_IF_FALSE(curtain_already_open,CHECK_ITEM_FLAG(e_ITEM_Curtain,ITEM_FLAG_CLOSED))        ; Is the curtain closed?
    UNSET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)                                           ; Open it!
    SET_LOCATION_DIRECTION(e_LOCATION_WESTGALLERY,e_DIRECTION_NORTH,e_LOCATION_PADLOCKED_ROOM)  ; We can now access the padlocked room
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CURTAIN)                                          ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                              ; Update the description 
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"un rideau ouvert")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"an opened curtain")
#endif        
curtain_already_open
    END_AND_REFRESH
.)

; TODO: Messages to indicate that the fridge it already open or that we have already found something
; Probably need a string table/id system to easily reuse messages.
_gSceneActionOpenFridge
.(    
    JUMP_IF_FALSE(fridge_already_open,CHECK_ITEM_FLAG(e_ITEM_Fridge,ITEM_FLAG_CLOSED))   ; Is the fridge closed?
    UNSET_ITEM_FLAGS(e_ITEM_Fridge,ITEM_FLAG_CLOSED)                                     ; Open it!
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_FRIDGE)                                    ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                       ; Update the description 
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"un réfrigérateur ouvert")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"an open fridge")
#endif        
    JUMP_IF_FALSE(meat_already_found,CHECK_ITEM_LOCATION(e_ITEM_Meat,e_LOCATION_NONE))   ; If the meat still hidden (in the fridge)? 
    SET_ITEM_LOCATION(e_ITEM_Meat,e_LOCATION_KITCHEN)                                    ; It's now visible inside the kitchen
meat_already_found
fridge_already_open    
    END_AND_REFRESH
.)


_gSceneActionOpenMedicineCabinet
.(
    JUMP_IF_FALSE(cabinet_already_open,CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED))    ; Is the medicine cabinet closed?
    UNSET_ITEM_FLAGS(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED)                                       ; Open it!
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                              ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                                  ; Update the description 
    SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"une armoire à pharmacie ouverte")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"an open medicine cabinet")
#endif        
    JUMP_IF_FALSE(pills_already_found,CHECK_ITEM_LOCATION(e_ITEM_SedativePills,e_LOCATION_NONE))    ; Are the pills still hidden (in the cabinet)? 
    SET_ITEM_LOCATION(e_ITEM_SedativePills,e_LOCATION_KITCHEN)                                      ; It's now visible inside the kitchen
pills_already_found
cabinet_already_open    
    END_AND_REFRESH
.)


/* 

                  ██████╗██╗      ██████╗ ███████╗███████╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
                 ██╔════╝██║     ██╔═══██╗██╔════╝██╔════╝    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
                 ██║     ██║     ██║   ██║███████╗█████╗      ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
                 ██║     ██║     ██║   ██║╚════██║██╔══╝      ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
                 ╚██████╗███████╗╚██████╔╝███████║███████╗    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
                  ╚═════╝╚══════╝ ╚═════╝ ╚══════╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

*/                                                                                             
_gSceneActionCloseCurtain
.(
    JUMP_IF_TRUE(curtain_already_closed,CHECK_ITEM_FLAG(e_ITEM_Curtain,ITEM_FLAG_CLOSED))
    SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"a closed curtain")
    UNSET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)
    SET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)
    SET_LOCATION_DIRECTION(e_LOCATION_WESTGALLERY,e_DIRECTION_NORTH,e_LOCATION_NONE)
curtain_already_closed
    END_AND_REFRESH
.)

_gSceneActionCloseFridge
.(
    JUMP_IF_TRUE(fridge_already_closed,CHECK_ITEM_FLAG(e_ITEM_Fridge,ITEM_FLAG_CLOSED))
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"a fridge")
    SET_ITEM_FLAGS(e_ITEM_Fridge,ITEM_FLAG_CLOSED)
fridge_already_closed
    END_AND_REFRESH
.)

_gSceneActionCloseMedicineCabinet
.(
    JUMP_IF_TRUE(medicine_cabinet_already_closed,CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED))
    SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"a medicine cabinet")
    SET_ITEM_FLAGS(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED)
medicine_cabinet_already_closed
    END_AND_REFRESH
.)


_gSceneActionCannotDo
.(
+_gTextErrorCannotDo = *+1    
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Je ne peux pas le faire")
#else
    ERROR_MESSAGE("I can't do that")
#endif    
    END_AND_REFRESH
.)


_gSceneActionCannotRead
.(
+_gTextErrorCannotRead = *+1    
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Je ne peux pas lire ca")
#else
    ERROR_MESSAGE("I can't read that")
#endif    
    END_AND_REFRESH
.)

_gSceneActionNothingSpecial
.(
+gTextErrorNothingSpecial = *+1    
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Rien de spécial")
#else
    ERROR_MESSAGE("Nothing special")
#endif    
    END_AND_REFRESH
.)


/*

                ██╗   ██╗███████╗███████╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
                ██║   ██║██╔════╝██╔════╝    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
                ██║   ██║███████╗█████╗      ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
                ██║   ██║╚════██║██╔══╝      ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
                ╚██████╔╝███████║███████╗    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
                 ╚═════╝ ╚══════╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                                            
*/

_gSceneActionUseLadder
.(
    JUMP_IF_TRUE(around_the_pit,CHECK_PLAYER_LOCATION(e_LOCATION_INSIDE_PIT))
    JUMP_IF_TRUE(around_the_pit,CHECK_PLAYER_LOCATION(e_LOCATION_OUTSIDE_PIT))
cannot_use_ladder_here
    ERROR_MESSAGE("Can't use it there")
    END_AND_REFRESH

around_the_pit
    INFO_MESSAGE("You position the ladder properly")
    SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_OUTSIDE_PIT)
    SET_ITEM_FLAGS(e_ITEM_Ladder,ITEM_FLAG_ATTACHED)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_THE_LADDER)
    END_AND_REFRESH
.)


_gSceneActionUseRope
.(
    JUMP_IF_TRUE(around_the_pit,CHECK_PLAYER_LOCATION(e_LOCATION_INSIDE_PIT))
    JUMP_IF_TRUE(around_the_pit,CHECK_PLAYER_LOCATION(e_LOCATION_OUTSIDE_PIT))
cannot_use_rope_here
    ERROR_MESSAGE("Can't use it there")
    END_AND_REFRESH

around_the_pit
    INFO_MESSAGE("You attach the rope to the tree")
    SET_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_OUTSIDE_PIT)
    SET_ITEM_FLAGS(e_ITEM_Rope,ITEM_FLAG_ATTACHED)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_THE_ROPE)
    END_AND_REFRESH
.)


/*

            ███████╗███████╗ █████╗ ██████╗  ██████╗██╗  ██╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
            ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝██║  ██║    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
            ███████╗█████╗  ███████║██████╔╝██║     ███████║    ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
            ╚════██║██╔══╝  ██╔══██║██╔══██╗██║     ██╔══██║    ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
            ███████║███████╗██║  ██║██║  ██║╚██████╗██║  ██║    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
            ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                                                                   
*/
_gSceneActionSearchThug
.(
    JUMP_IF_TRUE(thug_disabled,CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED))
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Il faut d'abord le maitriser");
#else
    ERROR_MESSAGE("I should subdue him first");
#endif    
    END

thug_disabled
    JUMP_IF_TRUE(found_items,CHECK_ITEM_LOCATION(e_ITEM_Pistol,e_LOCATION_NONE))
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Vous l'avez déjà fouillé");
#else    
    ERROR_MESSAGE("You've already frisked him");
#endif    
    END

found_items
    SET_ITEM_LOCATION(e_ITEM_Pistol,e_LOCATION_MASTERBEDROOM)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Vous avez trouvé quelque chose")
#else    
    INFO_MESSAGE("You found something interesting")
#endif    
    INCREASE_SCORE(50)
    END_AND_REFRESH
.)


/*

                ████████╗██╗  ██╗██████╗  ██████╗ ██╗    ██╗     █████╗  ██████╗████████╗██╗ ██████╗ ███╗   ██╗
                ╚══██╔══╝██║  ██║██╔══██╗██╔═══██╗██║    ██║    ██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
                   ██║   ███████║██████╔╝██║   ██║██║ █╗ ██║    ███████║██║        ██║   ██║██║   ██║██╔██╗ ██║
                   ██║   ██╔══██║██╔══██╗██║   ██║██║███╗██║    ██╔══██║██║        ██║   ██║██║   ██║██║╚██╗██║
                   ██║   ██║  ██║██║  ██║╚██████╔╝╚███╔███╔╝    ██║  ██║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
                   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝     ╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                                                                            
*/
_gSceneActionThrowBread
.(
    JUMP_IF_FALSE(not_in_wooded_avenue,CHECK_PLAYER_LOCATION(e_LOCATION_WOODEDAVENUE))
give_bread_to_dove
    // The bread is going away, but the bird is now possible to catch
    SET_ITEM_LOCATION(e_ITEM_Bread,e_LOCATION_GONE_FOREVER)
    UNSET_ITEM_FLAGS(e_ITEM_LargeDove,ITEM_FLAG_IMMOVABLE)
#ifdef LANGUAGE_FR   
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"une colombe qui picore")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"a dove eating bread crumbs")
#endif    
//+_gSceneActionDoveEatingBread
    DISPLAY_IMAGE(LOADER_PICTURE_DOVE_EATING_BREADCRUMBS,"Birdy nam nam...")
    INFO_MESSAGE("Maybe I can catch it now?")
    WAIT(50*2)
    END_AND_REFRESH

not_in_wooded_avenue
    // In other locations we just drop the bread where we are
    SET_ITEM_LOCATION(e_ITEM_Bread,e_LOCATION_CURRENT)
    END_AND_REFRESH
.)



_gScemeActionCommonDogDisabled
.(
    INCREASE_SCORE(50)
    SET_ITEM_FLAGS(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED)
#ifdef LANGUAGE_FR   
+_gTextDogLying = *+2
    SET_ITEM_DESCRIPTION(e_ITEM_AlsatianDog,"un chien immobile")
#else    
+_gTextDogLying = *+2
    SET_ITEM_DESCRIPTION(e_ITEM_AlsatianDog,"a dog lying")
#endif    
    END_AND_REFRESH
.)


_gSceneActionThrowMeat
.(
    // The meat can only be eaten if we are in the Entrance Hall and the dog is still alive and kicking
    JUMP_IF_FALSE(nothing_to_eat_the_meat,CHECK_PLAYER_LOCATION(e_LOCATION_ENTRANCEHALL))
    JUMP_IF_TRUE(nothing_to_eat_the_meat,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))
dog_eating_the_meat
    DISPLAY_IMAGE(LOADER_PICTURE_DOG_EATING_MEAT,"Quite a hungry dog!")
    INFO_MESSAGE("Glad it's not me there!")
    SET_ITEM_LOCATION(e_ITEM_Meat,e_LOCATION_GONE_FOREVER)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DOG_ATE_THE_MEAT)
    WAIT(50*2)    
    JUMP_IF_FALSE(done,CHECK_ITEM_FLAG(e_ITEM_Meat,ITEM_FLAG_TRANSFORMED))  // Is the meat drugged?
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_DOG)
    INCREASE_SCORE(50)
    JUMP(_gScemeActionCommonDogDisabled)
done
    END_AND_REFRESH

nothing_to_eat_the_meat
    // In other locations we just drop the meat where we are
    SET_ITEM_LOCATION(e_ITEM_Meat,e_LOCATION_CURRENT)
    END_AND_REFRESH
 .)



_gSceneActionThrowKnife
.(
    // We only throw the knife if:
    // - We are in the entrance hall and the dog is still alive
    // - We are in the sleeping room and the thug is still alive
    JUMP_IF_FALSE(drop_knife,CHECK_PLAYER_LOCATION(e_LOCATION_ENTRANCEHALL))
    JUMP_IF_TRUE(drop_knife,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))

    SET_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOCATION_LARGE_STAIRCASE)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_KILLED_THE_DOG)
    JUMP(_gScemeActionCommonDogDisabled)

drop_knife    
    // In other locations we just drop the item where we are
    SET_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOCATION_CURRENT)
    END_AND_REFRESH
.)


_gSceneActionThrowSnookerCue
.(
    // We only throw the snooker cue if:
    // - We are in the entrance hall and the dog is still alive
    // - We are in the sleeping room and the thug is still alive
    JUMP_IF_FALSE(drop_snooker_cue,CHECK_PLAYER_LOCATION(e_LOCATION_ENTRANCEHALL))
    JUMP_IF_TRUE(drop_snooker_cue,CHECK_ITEM_FLAG(e_ITEM_AlsatianDog,ITEM_FLAG_DISABLED))

    SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOCATION_LARGE_STAIRCASE)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_KILLED_THE_DOG)
    INCREASE_SCORE(50)
    JUMP(_gScemeActionCommonDogDisabled)

drop_snooker_cue    
    // In other locations we just drop the item where we are
    SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOCATION_CURRENT)
    END_AND_REFRESH
.)


_gDropCurrentItem
.(
    SET_ITEM_LOCATION(e_ITEM_CURRENT,e_LOCATION_CURRENT)
    END_AND_REFRESH
.)


_gDoNothingScript
.(
    END
.)


_EndSceneActions


_gReadItemMappingsArray
    VALUE_MAPPING(e_ITEM_Newspaper          , _gSceneActionReadNewsPaper)
    VALUE_MAPPING(e_ITEM_HandWrittenNote    , _gSceneActionReadHandWrittenNote)
    VALUE_MAPPING(e_ITEM_ChemistryRecipes   , _gSceneActionReadChemistryRecipes)
    VALUE_MAPPING(e_ITEM_ChemistryBook      , _gSceneActionReadChemistryBook)
    VALUE_MAPPING(255, _gSceneActionCannotRead)  // End Marker

_gOpenItemMappingsArray
    VALUE_MAPPING(e_ITEM_Curtain            , _gSceneActionOpenCurtain)
    VALUE_MAPPING(e_ITEM_Fridge             , _gSceneActionOpenFridge)
    VALUE_MAPPING(e_ITEM_Medicinecabinet    , _gSceneActionOpenMedicineCabinet )
    VALUE_MAPPING(255, _gSceneActionCannotDo)  // End Marker

_gCloseItemMappingsArray
    VALUE_MAPPING(e_ITEM_Curtain            , _gSceneActionCloseCurtain)
    VALUE_MAPPING(e_ITEM_Fridge             , _gSceneActionCloseFridge)
    VALUE_MAPPING(e_ITEM_Medicinecabinet    , _gSceneActionCloseMedicineCabinet )
    VALUE_MAPPING(255, _gSceneActionCannotDo)  // End Marker

_gInspectItemMappingsArray
    VALUE_MAPPING(e_ITEM_UnitedKingdomMap   , _gSceneActionInspectMap)
    VALUE_MAPPING(e_ITEM_ChemistryBook      , _gSceneActionInspectChemistryBook)
    VALUE_MAPPING(e_ITEM_HandheldGame       , _gSceneActionInspectGame)
    VALUE_MAPPING(e_ITEM_Fridge             , _gSceneActionInspectFridgeDoor)
    VALUE_MAPPING(e_ITEM_Medicinecabinet    , _gSceneActionInspectMedicineCabinet)
    VALUE_MAPPING(e_ITEM_PlasticBag         , _gSceneActionExaminePlasticBag)
    VALUE_MAPPING(255, _gSceneActionNothingSpecial)  // End Marker

_gUseItemMappingsArray
    VALUE_MAPPING(e_ITEM_Ladder             , _gSceneActionUseLadder)
    VALUE_MAPPING(e_ITEM_Rope               , _gSceneActionUseRope)
    VALUE_MAPPING(e_ITEM_HandheldGame       , _gSceneActionPlayGame)
    VALUE_MAPPING(255, _gSceneActionNothingSpecial)  // End Marker

_gSearchtemMappingsArray
    VALUE_MAPPING(e_ITEM_Thug               , _gSceneActionSearchThug)
    VALUE_MAPPING(255, _gSceneActionNothingSpecial)  // End Marker

_gThrowItemMappingsArray
    VALUE_MAPPING(e_ITEM_Bread              , _gSceneActionThrowBread)
    VALUE_MAPPING(e_ITEM_Meat               , _gSceneActionThrowMeat)
    VALUE_MAPPING(e_ITEM_SilverKnife        , _gSceneActionThrowKnife)
    VALUE_MAPPING(e_ITEM_SnookerCue         , _gSceneActionThrowSnookerCue)
    VALUE_MAPPING(255, _gDropCurrentItem)  // End Marker


_gActionMappingsArray   
    VALUE_MAPPING2(e_WORD_NORTH     ,0, _PlayerMove)
    VALUE_MAPPING2(e_WORD_SOUTH     ,0, _PlayerMove)
    VALUE_MAPPING2(e_WORD_EAST      ,0, _PlayerMove)
    VALUE_MAPPING2(e_WORD_WEST      ,0, _PlayerMove)
    VALUE_MAPPING2(e_WORD_UP        ,0, _PlayerMove)
    VALUE_MAPPING2(e_WORD_DOWN      ,0, _PlayerMove)

    VALUE_MAPPING2(e_WORD_TAKE      ,0, _TakeItem)

    VALUE_MAPPING2(e_WORD_DROP      ,0, _DropItem)
    VALUE_MAPPING2(e_WORD_COMBINE   ,0, _CombineItems)
    VALUE_MAPPING2(e_WORD_KILL      ,0, _Kill)
    VALUE_MAPPING2(e_WORD_READ      ,1, _gReadItemMappingsArray)
    VALUE_MAPPING2(e_WORD_USE       ,1, _gUseItemMappingsArray)
    VALUE_MAPPING2(e_WORD_OPEN      ,1, _gOpenItemMappingsArray)
    VALUE_MAPPING2(e_WORD_CLOSE     ,1, _gCloseItemMappingsArray)

    VALUE_MAPPING2(e_WORD_LOOK      ,1, _gInspectItemMappingsArray)
    VALUE_MAPPING2(e_WORD_FRISK     ,1, _gSearchtemMappingsArray)
    VALUE_MAPPING2(e_WORD_SEARCH    ,1, _gSearchtemMappingsArray)
    VALUE_MAPPING2(e_WORD_THROW     ,1, _gThrowItemMappingsArray)
#ifdef ENABLE_CHEATS       
    VALUE_MAPPING2(e_WORD_REVIVE      ,0, _Revive)
    VALUE_MAPPING2(e_WORD_TICKLE      ,0, _Tickle)
    VALUE_MAPPING2(e_WORD_INVOKE      ,0, _Invoke)
#endif
    VALUE_MAPPING2(e_WORD_COUNT_    ,0, 0)
    // End Marker


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

