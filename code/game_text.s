
#include "params.h"
#include "../build/floppy_description.h"
#include "game_enums.h"

    .text

_StartGameTextData

#pragma osdk replace_characters_if LANGUAGE_FR : é:{ è:} ê:| à:@ î:i ô:^ ç:c Ç:C â:[ ù:u û:] Ê:E
#pragma osdk replace_characters_if LANGUAGE_NO : æ:{ ø:} å:| Æ:A Ø:O Å:A


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
_gTextAskInput              .byt "Bon, par ou commencer...",0
_gTextNothingHere           .byt 3,"Il n'y a rien d'important ici",0
_gTextCanSee                .byt "Je vois ",0
_gTextAnd                   .byt " et",0
_gTextScore                 .byt 5,"Score: %d",7,0
_gTextCarryInWhat           .byt "Transporter dans quoi ?",0
_gTextUseShiftToHighlight   .byt TEXT_CRLF,TEXT_CRLF
                            .byt "Naviguez avec",3,"les flèches, CTRL",7,"plus",TEXT_CRLF
                            .byt "touches",3,"HAUT",7,"ou",3,"BAS",7,"pour grimper,",TEXT_CRLF
                            .byt "et",3,"MAJ",7,"pour identifier les objets.",0
                            //.byt "Note: Utilisez SHIFT pour voir les objects",0
#elif defined(LANGUAGE_NO)
_gTextAskInput              .byt "Greit, hvor begynner jeg...",0
_gTextNothingHere           .byt 3,"Det er ingenting interessant her",0
_gTextCanSee                .byt "Jeg ser ",0
_gTextAnd                   .byt " og",0
_gTextScore                 .byt 5,"Poeng: %d",7,0
_gTextCarryInWhat           .byt "Bær det i hva?",0
_gTextUseShiftToHighlight   .byt TEXT_CRLF,TEXT_CRLF
                            .byt "Bruk",3,"piltaster",7,"for å bevege deg,",3,"CTRL",TEXT_CRLF
                            .byt "pluss",3,"OPP",7,"eller",3,"NED",7,"for å klatre,",TEXT_CRLF
                            .byt "og",3,"SHIFT",7,"for å markere gjenstander.",0
#else
_gTextAskInput              .byt "Right, where do I start...",0
_gTextNothingHere           .byt 3,"There is nothing of interest here",0
_gTextCanSee                .byt "I can see ",0
_gTextAnd                   .byt " and",0
_gTextScore                 .byt 5,"Score: %d",7,0
_gTextCarryInWhat           .byt "Carry it in what?",0
_gTextUseShiftToHighlight   .byt TEXT_CRLF,TEXT_CRLF,
                            .byt "Use",3,"arrow keys",7,"to move around,",3,"CTRL",TEXT_CRLF
                            .byt "plus",3,"UP",7,"or",3,"DOWN",7,"to climb up or down,",TEXT_CRLF
                            .byt "and press",3,"SHIFT",7,"to highlight items.",0
#endif
_EndMessagesAndPrompts

// Error messages 
_StartErrorMessages
#ifdef LANGUAGE_FR
_gTextErrorInvalidDirection .byt "Je ne peux pas aller par là",0
_gTextErrorAlreadyHaveItem  .byt "Je l'ai déjà",0
_gTextErrorNotAContainer    .byt "Ca ne marchera pas comme contenant",0
_gTextErrorAlreadyFull      .byt "Hmm, c'est déjà plein",0
_gTextErrorMissingContainer .byt "Je n'ai pas ce contenant",0
_gTextErrorDropNotHave      .byt "Je ne peux lâcher que ce que j'ai",0
_gTextErrorUnknownItem      .byt "Je ne sais pas ce que c'est",0
_gTextErrorItemNotPresent   .byt "Cet objet n'est pas présent",0
_gTextErrorInventoryFull    .byt "Faut d'abord poser quelque chose",0
#elif defined(LANGUAGE_NO)
_gTextErrorInvalidDirection .byt "Jeg kan ikke gå den veien",0
_gTextErrorAlreadyHaveItem  .byt "Jeg har allerede det",0
_gTextErrorNotAContainer    .byt "Det fungerer ikke som beholder",0
_gTextErrorAlreadyFull      .byt "Hmm, det er allerede fullt",0
_gTextErrorMissingContainer .byt "Jeg har ikke den beholderen",0
_gTextErrorDropNotHave      .byt "Jeg kan bare slippe det jeg bærer",0
_gTextErrorUnknownItem      .byt "Jeg vet ikke hva det er",0
_gTextErrorItemNotPresent   .byt "Ser det ikke her",0
_gTextErrorInventoryFull    .byt "Jeg må legge fra meg noe først",0
#else
_gTextErrorInvalidDirection .byt "I can't go that way",0
_gTextErrorAlreadyHaveItem  .byt "I already have that",0
_gTextErrorNotAContainer    .byt "That won't work as a container",0
_gTextErrorAlreadyFull      .byt "Hmm, it's already full",0
_gTextErrorMissingContainer .byt "I don't have that container",0
_gTextErrorDropNotHave      .byt "I can only drop what I'm carrying",0
_gTextErrorUnknownItem      .byt "I don't know what that is",0
_gTextErrorItemNotPresent   .byt "Can't see it here",0
_gTextErrorInventoryFull    .byt "I need to drop something first",0
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
_gTextItemTobaccoTin              .byt "une$_tabatière",0
_gTextItemBucket                  .byt "un$_seau en bois",0
_gTextItemCardboardBox            .byt "une$_boite en carton",0
_gTextItemNet                     .byt "un$_filet",0
_gTextItemPlasticBag              .byt "un$_sac en plastique",0
// Items requiring containers
_gTextItemSaltpetre               .byt "un _dépôt blanc",0
_gTextItemSulphur                 .byt "des _cristaux jaunes",0
_gTextItemPetrol                  .byt "de l'$_essence",0
_gTextItemWater                   .byt "de l'$_eau",0
// Normal items
_gTextItemOpenPanel               .byt "un _panneau mural ouvert",0
_gTextItemSmallHoleInDoor         .byt "un petit _trou dans la porte",0
_gTextItemFancyStones             .byt "des$_pierres décoratives",0
_gTextItemSilverKnife             .byt "un$_couteau en argent",0
_gTextItemMixTape                 .byt "une$_compil sur K7",0
_gTextItemAlsatianDog             .byt "un _chien qui grogne",0
_gTextItemMeat                    .byt "un$morceau de _viande",0
_gTextItemBread                   .byt "du$_pain complet",0
_gTextItemRollOfTape              .byt "un rouleau de$_bande adhésive",0
_gTextItemChemistryBook           .byt "un$_livre de chimie",0
_gTextItemBoxOfMatches            .byt "une boite d'$_allumettes",0
_gTextItemSnookerCue              .byt "une$_queue de billard",0
_gTextItemThug                    .byt "un _voyou endormi sur le lit",0
_gTextItemHeavySafe               .byt "un gros _coffre",0
_gTextItemHandWrittenNote         .byt "une$_note manuscrite",0
_gTextItemRollOfToiletPaper       .byt "du$_papier toilette",0
_gTextItemOpenSafe                .byt "un _coffre ouvert",0
_gTextItemYoungGirl               .byt "une jeune _fille",0
_gTextItemFuse                    .byt "une$_mèche",0
_gTextItemPowderMix               .byt "un$_mix grumeleux",0
_gTextItemGunPowder               .byt "de la$_poudre à canon",0
_gTextItemSmallKey                .byt "une$petite _clef",0
_gTextItemNewspaper               .byt "un$_journal",0
_gTextItemBomb                    .byt "une$_bombe",0
_gTextItemPistol                  .byt "un$_pistolet",0
_gTextItemChemistryRecipes        .byt "_formules de chimie",0
_gTextItemUnitedKingdomMap        .byt "une _carte du Royaume-Uni",0
_gTextItemHandheldGame            .byt "un$_jeu portable",0
_gTextItemSedativePills           .byt "des$_somnifères",0
_gTextItemDartGun                 .byt "un$_lance fléchettes",0
_gTextItemBlackTape               .byt "du$_ruban adhésif noir",0
_gTextItemMortarAndPestle         .byt "un$_mortier et pilon",0
_gTextItemAdhesive                .byt "de l'$_adhésif",0
_gTextItemAcid                    .byt "un$_acide puissant",0
_gTextItemSecurityDoor            .byt "une _porte blindée",0
_gTextItemDriedOutClay            .byt "de l'$_argile desséchée",0
_gTextItemProtectionSuit          .byt "une$_combinaison",0
_gTextItemHoleInDoor              .byt "un _trou dans la porte",0
_gTextItemFrontDoor               .byt "la _porte principale",0
_gTextItemRoughPlan               .byt "un$_plan sommaire",0
_gTextItemLargeDoveOutOfReach     .byt "une _colombe haut perchée",0
_gTextItemGraffiti                .byt "des _graffitis",0
_gTextItemChurch                  .byt "une _église",0
_gTextItemWell                    .byt "un _puits",0
_gTextItemRoadSign                .byt "un _panneau",0
_gTextItemTrashCan                .byt "une _poubelle",0
_gTextItemTombstone               .byt "une _tombe",0
_gTextItemFishpond                .byt "un _bac à poissons",0
_gTextItemFish                    .byt "un _poisson",0
_gTextItemTree                    .byt "un$_arbre robuste",0
_gTextItemPit                     .byt "un$_trou instable",0
_gTextItemHeap                    .byt "quelques$_tas",0
_gTextItemNormalWindow            .byt "une _fenêtre",0
_gTextItemAlarmIndicator          .byt "un _indicateur d'alarme",0
_gTextItemComputer                .byt "un _ordinateur de bureau",0
_gTextItemOricComputer            .byt "un micro-ordinateur$_Oric 1",0
_gTextItemInvoice                 .byt "une$_facture",0
_gTextItemTelevision              .byt "une _télé",0
_gTextItemGameConsole             .byt "une _console de jeu",0
_gTextItemLockedPanel             .byt "un _voyant lumineux",0
_gTextItemBatteries               .byt "un paquet de$_piles SR44",0
_gTextItemDuneBook                .byt "un$_roman",0
#ifdef PRODUCT_TYPE_GAME_DEMO
_gTextItemDemoReadMe              .byt "un _message sur le mur",0
#endif // PRODUCT_TYPE_GAME_DEMO
#elif defined(LANGUAGE_NO)
// Beholdere
_gTextItemTobaccoTin              .byt "en$tobakks _boks",0
_gTextItemBucket                  .byt "en$tre _bøtte",0
_gTextItemCardboardBox            .byt "en$papp _eske",0
_gTextItemNet                     .byt "et$_nett",0
_gTextItemPlasticBag              .byt "en$_plastpose",0
// Gjenstander som krever beholder
_gTextItemSaltpetre               .byt "et hvitt _belegg",0
_gTextItemSulphur                 .byt "noen gule _krystaller",0
_gTextItemPetrol                  .byt "noe$_bensin",0
_gTextItemWater                   .byt "noe$_vann",0
// Vanlige gjenstander
_gTextItemOpenPanel               .byt "et$åpent _panel på veggen",0
_gTextItemSmallHoleInDoor         .byt "et$lite _hull i døren",0
_gTextItemFancyStones             .byt "noen$dekorative _steiner",0
_gTextItemSilverKnife             .byt "en$sølv _kniv",0
_gTextItemMixTape                 .byt "en$_kassett",0
_gTextItemAlsatianDog             .byt "en$_hund som knurrer",0
_gTextItemMeat                    .byt "et$stykke _kjøtt",0
_gTextItemBread                   .byt "noe$grovt _brød",0
_gTextItemRollOfTape              .byt "en$rull med _teip",0
_gTextItemChemistryBook           .byt "en$kjemi _bok",0
_gTextItemBoxOfMatches            .byt "en$eske med _fyrstikker",0
_gTextItemSnookerCue              .byt "en$snooker _kølle",0
_gTextItemThug                    .byt "en$_skurk som sover på senga",0
_gTextItemHeavySafe               .byt "en$tung _safe",0
_gTextItemHandWrittenNote         .byt "et$håndskrevet _notat",0
_gTextItemRollOfToiletPaper       .byt "en$_toalettrull",0
_gTextItemOpenSafe                .byt "en$åpen _safe",0
_gTextItemYoungGirl               .byt "en$ung _jente",0
_gTextItemFuse                    .byt "en$_lunte",0
_gTextItemPowderMix               .byt "en$grov pulver _miks",0
_gTextItemGunPowder               .byt "noe$_krutt",0
_gTextItemSmallKey                .byt "en$liten _nøkkel",0
_gTextItemNewspaper               .byt "en$_avis",0
_gTextItemBomb                    .byt "en$_bombe",0
_gTextItemPistol                  .byt "en$_pistol",0
_gTextItemChemistryRecipes        .byt "kjemi _oppskrifter",0
_gTextItemUnitedKingdomMap        .byt "et$_kart over Storbritannia",0
_gTextItemHandheldGame            .byt "et$håndholdt _spill",0
_gTextItemSedativePills           .byt "noen$sovemiddel _piller",0
_gTextItemDartGun                 .byt "en$_dartpistol",0
_gTextItemBlackTape               .byt "noe$svart _teip",0
_gTextItemMortarAndPestle         .byt "en$_morter og støter",0
_gTextItemAdhesive                .byt "en$_rull med teip",0
_gTextItemAcid                    .byt "noe$sterk _syre",0
_gTextItemSecurityDoor            .byt "en$sikkerhets _dør",0
_gTextItemDriedOutClay            .byt "noe$tørr _leire",0
_gTextItemProtectionSuit          .byt "en$verne _drakt",0
_gTextItemHoleInDoor              .byt "et$_hull i døren",0
_gTextItemFrontDoor               .byt "hoved _inngang",0
_gTextItemRoughPlan               .byt "et$_serviett med kart",0
_gTextItemLargeDoveOutOfReach     .byt "en$_due på et høyt tre",0
_gTextItemGraffiti                .byt "noe$_graffiti",0
_gTextItemChurch                  .byt "en$_kirke",0
_gTextItemWell                    .byt "en$_brønn",0
_gTextItemRoadSign                .byt "et$_skilt",0
_gTextItemTrashCan                .byt "en$søppel _kasse",0
_gTextItemTombstone               .byt "en$_gravstein",0
_gTextItemFishpond                .byt "en$fiske _dam",0
_gTextItemFish                    .byt "en$_fisk",0
_gTextItemTree                    .byt "et$solid _tre",0
_gTextItemPit                     .byt "en$ustabil _grop",0
_gTextItemHeap                    .byt "noen$_jordhauger",0
_gTextItemNormalWindow            .byt "et _vindu",0
_gTextItemAlarmIndicator          .byt "en alarm _indikator",0
_gTextItemComputer                .byt "en stasjonær _PC",0
_gTextItemOricComputer            .byt "en$_Oric 1 datamaskin",0
_gTextItemInvoice                 .byt "en$_faktura",0
_gTextItemTelevision              .byt "en _TV",0
_gTextItemGameConsole             .byt "en spill _konsoll",0
_gTextItemLockedPanel             .byt "et alarm _lys",0
_gTextItemBatteries               .byt "en pakke$SR44 _batterier",0
_gTextItemDuneBook                .byt "en$_roman",0
#ifdef PRODUCT_TYPE_GAME_DEMO
_gTextItemDemoReadMe              .byt "en _melding på veggen",0
#endif // PRODUCT_TYPE_GAME_DEMO
#else
// Containers
_gTextItemTobaccoTin              .byt "a$tobacco _tin",0               
_gTextItemBucket                  .byt "a$wooden _bucket",0                    
_gTextItemCardboardBox            .byt "a$cardboard _box",0                    
_gTextItemNet                     .byt "a$_net",0                      
_gTextItemPlasticBag              .byt "a$plastic _bag",0                      
// Items requiring containers
_gTextItemSaltpetre               .byt "a white _deposit",0
_gTextItemSulphur                 .byt "some yellow _crystals",0
_gTextItemPetrol                  .byt "some$_petrol",0                        
_gTextItemWater                   .byt "some$_water",0                         
// Normal items
_gTextItemOpenPanel               .byt "an$open _panel on the wall",0              
_gTextItemSmallHoleInDoor         .byt "a$small _hole in the door",0           
_gTextItemFancyStones             .byt "some$fancy _stones",0                         
_gTextItemSilverKnife             .byt "a$silver _knife",0                     
_gTextItemMixTape                 .byt "a$_mixtape",0
_gTextItemAlsatianDog             .byt "a$_dog growling at you",0        
_gTextItemMeat                    .byt "a$joint of _meat",0                    
_gTextItemBread                   .byt "some$brown _bread",0                   
_gTextItemRollOfTape              .byt "a$roll of sticky _tape",0              
_gTextItemChemistryBook           .byt "a$chemistry _book",0                   
_gTextItemBoxOfMatches            .byt "a$box of _matches",0                   
_gTextItemSnookerCue              .byt "a$snooker _cue",0                      
_gTextItemThug                    .byt "a$_thug asleep on the bed",0           
_gTextItemHeavySafe               .byt "a$heavy _safe",0                       
_gTextItemHandWrittenNote         .byt "a$handwritten _note",0
_gTextItemRollOfToiletPaper       .byt "a$toilet _roll",0            
_gTextItemOpenSafe                .byt "an$open _safe",0                       
_gTextItemYoungGirl               .byt "a$young _girl",0                        
_gTextItemFuse                    .byt "a$_fuse",0                             
_gTextItemPowderMix               .byt "a$rough powder _mix",0
_gTextItemGunPowder               .byt "some$_gunpowder",0
_gTextItemSmallKey                .byt "a$small _key",0                      
_gTextItemNewspaper               .byt "a$_newspaper",0                        
_gTextItemBomb                    .byt "a$_bomb",0                             
_gTextItemPistol                  .byt "a$_pistol",0                           
_gTextItemChemistryRecipes        .byt "chemistry _recipes",0         
_gTextItemUnitedKingdomMap        .byt "a$_map of the United Kingdom",0        
_gTextItemHandheldGame            .byt "a$handheld _game",0
_gTextItemSedativePills           .byt "some$sedative _pills",0
_gTextItemDartGun                 .byt "a$_dart gun",0
_gTextItemBlackTape               .byt "some$black adhesive _tape",0
_gTextItemMortarAndPestle         .byt "a$pestle and _mortar",0
_gTextItemAdhesive                .byt "some$_adhesive",0
_gTextItemAcid                    .byt "some$strong _acid",0
_gTextItemSecurityDoor            .byt "a$security _door",0
_gTextItemDriedOutClay            .byt "some$dried out _clay",0
_gTextItemProtectionSuit          .byt "a$protection _suit",0
_gTextItemHoleInDoor              .byt "a$_hole in the door",0
_gTextItemFrontDoor               .byt "the$entrance _door",0
_gTextItemRoughPlan               .byt "a$rough _plan",0
_gTextItemLargeDoveOutOfReach     .byt "a$_dove on a tall tree",0
_gTextItemGraffiti                .byt "some$_graffiti",0
_gTextItemChurch                  .byt "a$_church",0
_gTextItemWell                    .byt "a$_well",0
_gTextItemRoadSign                .byt "a$_sign",0
_gTextItemTrashCan                .byt "a$rubbish _bin",0
_gTextItemTombstone               .byt "a$_tombstone",0
_gTextItemFishpond                .byt "a$fish _pond",0
_gTextItemFish                    .byt "a$_fish",0
_gTextItemTree                    .byt "a$sturdy _tree",0
_gTextItemPit                     .byt "an$unstable _pit",0
_gTextItemHeap                    .byt "a few$spoil _heaps",0
_gTextItemNormalWindow            .byt "a _window",0
_gTextItemAlarmIndicator          .byt "an alarm _indicator",0
_gTextItemComputer                .byt "a desktop _computer",0
_gTextItemOricComputer            .byt "a$_Oric 1 computer",0
_gTextItemInvoice                 .byt "an$_invoice letter",0
_gTextItemTelevision              .byt "a _telly",0
_gTextItemGameConsole             .byt "a game _console",0
_gTextItemLockedPanel             .byt "a flashing _light",0
_gTextItemBatteries               .byt "a pack of$SR44 _batteries",0
_gTextItemDuneBook                .byt "a$_novel",0
#ifdef PRODUCT_TYPE_GAME_DEMO
_gTextItemDemoReadMe              .byt "a _message on the wall",0
#endif // PRODUCT_TYPE_GAME_DEMO
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

// MARK: Dark Tunel
_gDescriptionDarkTunel
    SET_ITEM_LOCATION(e_ITEM_Graffiti,e_LOC_DARKTUNNEL);

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(4,4,0,"Un tunnel ordinaire: sombre,")
    _BUBBLE_LINE(4,13,1,"humide et inquiétant.")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(4,4,0,"Som de fleste tunneler: mørk,")
    _BUBBLE_LINE(4,14,0,"fuktig og litt skummel.")
#else
    _BUBBLE_LINE(4,4,0,"Like most tunnels: dark, damp,")
    _BUBBLE_LINE(4,13,1,"and somewhat scary.")
#endif    

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
    SET_ITEM_LOCATION(e_ITEM_Car,e_LOC_MARKETPLACE)
+_gTextItemMyCar = *+2   
#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"ma _voiture")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"_bilen min")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"my _car")
#endif

hack_show_plastic_bag_again
    ; Is the plastic bag on the market place?
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_PlasticBag,e_LOC_MARKETPLACE),show_bag)
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,4)                     ; Draw the plastic bag
                _IMAGE(24,0)
                _BUFFER(2,79)
    ENDIF(show_bag)    

    ; Is the girl here?
    JUMP_IF_FALSE(girl_not_here,CHECK_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_MARKETPLACE))
        ; She's here, we won!
        ; Victory!
        SET_CUT_SCENE(1)
        CLEAR_TEXT_AREA(0)
        CLEAR_FULL_TEXT_AREA(0)
        STOP_CLOCK
        
        LOAD_MUSIC(LOADER_MUSIC_VICTORY)
        INCREASE_SCORE(POINTS_WON_THE_GAME)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_SOLVED_THE_CASE)
        FADE_BUFFER                            ; Show the market place
        WAIT(DELAY_FIRST_BUBBLE)
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
        _BUBBLE_LINE(60,70,0,"Nous avons réussi !")
        _BUBBLE_LINE(30,81,0,"Allez, on rentre !")
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(90,70,0,"Vi klarte det!")
        _BUBBLE_LINE(70,80,0,"Tid for å dra hjem!")
#else
        _BUBBLE_LINE(90,70,0,"We did it!")
        _BUBBLE_LINE(70,80,0,"Time to go home!")
#endif    
        WAIT(50*4)                                ; Wait a couple seconds
        STOP_MUSIC()
        
        DISPLAY_IMAGE(LOADER_PICTURE_AUSTIN_MINI) ; Car without passengers
        WAIT(50*2)                                ; Wait a couple seconds
#ifdef LANGUAGE_FR
        QUICK_MESSAGE("Tout le monde à bord !")
#elif defined(LANGUAGE_NO)
        QUICK_MESSAGE("Alle om bord!")
#else
        QUICK_MESSAGE("Everybody on board now!")
#endif    
        
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

        DISPLAY_IMAGE(LOADER_PICTURE_NEWS_SAVED)
        LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Tout est bien qui finit bien")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Alt er vel som ender vel")
#else
        INFO_MESSAGE("All is well that ends well")
#endif

        WAIT(50*2)                                ; Wait a couple seconds
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
#ifdef LANGUAGE_FR
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(4,100,0,"La place du marché")
    _BUBBLE_LINE(4,106,4,"est déserte")
#elif defined(LANGUAGE_NO)
    WHITE_BUBBLE(1)
    _BUBBLE_LINE(4,106,0,"Torget er øde")
#else
    WHITE_BUBBLE(2)
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
        GOSUB(_ShowRoughPlan)        
        ; Then we show an animated sequence where the digital watch is set to have an alarm in two hours
        GOSUB(_WatchSetup)

end_intro_sequence        
        STOP_MUSIC()                   ; To ensure sounds are back if we cut before the music ended... (Need to fix that more cleanly, so many hacks now!)
        ; Back to the market place
        DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_LOCATIONS_START)
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
    SET_ITEM_LOCATION(e_ITEM_Graffiti,e_LOC_DARKALLEY);

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(145,90,0,"Rats, graffitis,")
    _BUBBLE_LINE(160,103,0,"et seringues.")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(150,85,0,"Rotter, graffiti,")
    _BUBBLE_LINE(133,98,0,"og brukte sprøyter.")
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
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(4,95,0,"Tous les chemins mènent...")
    _BUBBLE_LINE(4,106,0,"...quelque part?")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(4,100,0,"Alle veier fører...")
    _BUBBLE_LINE(4,106,4,"...et sted?")
#else
    _BUBBLE_LINE(4,100,0,"All roads lead...")
    _BUBBLE_LINE(4,106,4,"...somewhere?")
#endif    
    END


// MARK: Main Street
_gDescriptionMainStreet
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(4,4,0,"Une bonne vieille")
    _BUBBLE_LINE(4,16,0,"église médiévale")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(4,4,0,"En gammel")
    _BUBBLE_LINE(4,15,3,"middelalderkirke")
#else
    _BUBBLE_LINE(4,4,0,"A good old")
    _BUBBLE_LINE(4,16,0,"medieval church")
#endif    

    END


// MARK: Eastern Road
_gDescriptionEasternRoad
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(130,5,0,"Serait-ce les")
    _BUBBLE_LINE(129,17,0,"portes du Paradis?")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(130,5,0,"Er dette himlens")
    _BUBBLE_LINE(139,17,0,"åpne porter?")
#else
    _BUBBLE_LINE(130,5,0,"Are these the open")
    _BUBBLE_LINE(109,17,0,"flood gates of heaven?")
#endif    
    END


// MARK: In the Pit
_gDescriptionInThePit
.(
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
    CLEAR_TEXT_AREA(1)
    QUICK_MESSAGE("Oops...")
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(6,8,0,"Ca ne semblait")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(6,8,0,"Det virket ikke")
#else
    _BUBBLE_LINE(6,8,0,"It did not look")
#endif    
    WAIT(50)
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(156,42,0,"pas si profond")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(176,42,0,"så dypt")
#else
    _BUBBLE_LINE(176,42,0,"that deep")
#endif    
    WAIT(50)
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(82,94,0,"vu de là-haut")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(82,94,0,"sett ovenfra")
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
#ifdef LANGUAGE_FR
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(5,93,0,"Cherchent-ils")
    _BUBBLE_LINE(5,101,4,"de l'or ?")
#elif defined(LANGUAGE_NO)
    WHITE_BUBBLE(1)
    _BUBBLE_LINE(5,90,0,"Graver de etter gull?")
#else
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(5,90,0,"Are they digging")
    _BUBBLE_LINE(8,103,0,"for gold?")
#endif    
    END
.)


// MARK: Parking Place
_gDescriptionParkingPlace
.(
    SET_ITEM_LOCATION(e_ITEM_Car,e_LOC_PARKING_PLACE)
#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"une _voiture abandonnée")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"en forlatt _bil")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Car,"an abandoned _car")
#endif

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_CarBoot,ITEM_FLAG_CLOSED),boot)     ; Is the boot closed?
        BLIT_BLOCK(LOADER_SPRITE_CAR_PARTS,5,19)                        ; Draw the open boot
                _IMAGE(3,96)
                _BUFFER(26,51)
    ENDIF(boot)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_CarDoor,ITEM_FLAG_CLOSED),door)     ; Is the door open?
        BLIT_BLOCK(LOADER_SPRITE_CAR_PARTS,3,16)                        ; Draw the open door
                _IMAGE(9,96)
                _BUFFER(32,54)
    ENDIF(door)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(119,5,0,"De cendres à cendres")
    _BUBBLE_LINE(124,13,3,"De rouille à rouille")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(149,5,0,"Aske til aske")
    _BUBBLE_LINE(152,13,2,"Rust til rust...")
#else
    _BUBBLE_LINE(149,5,0,"Ashes to Ashes")
    _BUBBLE_LINE(152,15,0,"Rust to Rust...")
#endif

#if 1  // TARDIS Easter Egg - near the tombstone with the anachronistic date
    .(
    ; Wait 20 seconds
    WAIT(50*5)
    WAIT(50*5)
    WAIT(50*5)
    WAIT(50*5)
    DO_ONCE(tardis)
        CALL_NATIVE(_PrintSceneDirections)                       ; HACK: Force draw the direction arrows
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,5,56)                     ; Draw the TARDIS
            _IMAGE(30,49)
            _BUFFER(7,40)
        PLAY_SOUND(_Zipper)
        FADE_BUFFER
        WAIT(50*5)
        WAIT(50*5)
        CALL_NATIVE(_PrintSceneDirections)                       ; HACK: Force draw the direction arrows
        DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_LOCATIONS_PARKINGPLACE)
        PLAY_SOUND(_Zipper)
        FADE_BUFFER
    ENDDO(tardis)
    .)
#endif
    END
.)


// MARK: Abandoned Car
_gDescriptionAbandonedCar
.(
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
    ; Is the Bucket near the Well?
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Bucket,e_LOC_WELL),show_bucket)
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,6,35)                     ; Draw the Bucket
                _IMAGE(0,0)
                _BUFFER(24,86)
    ENDIF(show_bucket)

    ; Is the Rope near the Well?
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_WELL),show_rope)
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,7,44)                     ; Draw the Rope
                _IMAGE(7,0)
                _BUFFER(26,35)
    ENDIF(show_rope)    

    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    ; Then show the messages
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(121,5,0,"Ce puits semble aussi")
    _BUBBLE_LINE(138,16,0,"vieux que l'église")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(107,5,0,"Denne brønnen ser like")
    _BUBBLE_LINE(111,16,0,"gammel ut som kirken")
#else
    _BUBBLE_LINE(111,5,0,"This well looks as old")
    _BUBBLE_LINE(158,16,0,"as the church")
#endif    
    JUMP(_ChirpingBirds)
.)


// MARK: Wooded Avenue
_gDescriptionWoodedAvenue
.(
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(4,4,0,"Ces arbres ont probablement")
    _BUBBLE_LINE(4,15,0,"été témoins de beaucoup de choses")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(4,4,0,"Disse trærne har sikkert")
    _BUBBLE_LINE(4,15,0,"sett mye")
#else
    _BUBBLE_LINE(4,4,0,"These trees have probably")
    _BUBBLE_LINE(4,14,1,"witnessed many things")
#endif    
    // If the dove is still there, but not eating, then play the  chirping
    JUMP_IF_TRUE(no_chirping,CHECK_ITEM_LOCATION(e_ITEM_Bread,e_LOC_WOODEDAVENUE))
    JUMP_IF_TRUE(_ChirpingBirds,CHECK_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_WOODEDAVENUE))
no_chirping    
    END
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
    WAIT(DELAY_FIRST_BUBBLE)
#ifdef LANGUAGE_FR
    WHITE_BUBBLE(3)
    _BUBBLE_LINE(180,86,0,"Plutôt")
    _BUBBLE_LINE(150,97,0,"impressionnant")
    _BUBBLE_LINE(176,107,2,"vu de loin")
#elif defined(LANGUAGE_NO)
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(126,96,0,"Ganske imponerende")
    _BUBBLE_LINE(152,107,0,"sett på avstand")
#else
    WHITE_BUBBLE(3)
    _BUBBLE_LINE(127,86,0,"Kind of impressive")
    _BUBBLE_LINE(143,97,0,"when seen from")
    _BUBBLE_LINE(182,107,0,"far away")
#endif    
    END


// MARK: Zen Garden
_gDescriptionZenGarden
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(9,5,0,"Un jardin zen japonais ?")
    _BUBBLE_LINE(5,17,0,"En Angleterre ?")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(4,4,0,"En japansk zen-hage?")
    _BUBBLE_LINE(4,16,0,"I England?")
#else
    _BUBBLE_LINE(4,4,0,"A Japanese zen garden?")
    _BUBBLE_LINE(4,15,1,"In England?")
#endif    
    END


// MARK: Front Lawn
_gDescriptionFrontLawn
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"La maison parfaite")
    _BUBBLE_LINE(5,15,0,"pour les égocentriques")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Det perfekte huset")
    _BUBBLE_LINE(5,16,0,"for egoister")
#else
    _BUBBLE_LINE(5,5,0,"The perfect home")
    _BUBBLE_LINE(5,15,1,"for egomaniacs")
#endif    
    END


// MARK: Green House
_gDescriptionGreenHouse
.(
    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_ProtectionSuit,e_LOC_GREENHOUSE),show_suit)
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,4,13)                     ; Draw the protection suit
                _IMAGE(14,0)
                _BUFFER(33,104)
    ENDIF(show_suit)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(4,5,0,"Evidemment pour")
    .byt 4,17,0,34,"Usage thérapeutique",34,0
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(4,95,0,"Tydeligvis for")
    .byt 4,108,0,34,"terapeutisk bruk",34,0
#else
    _BUBBLE_LINE(4,96,0,"Obviously for")
    .byt 4,107,1,34,"therapeutic use",34,0
#endif
    END
.)


// MARK: Tennis Court
_gDescriptionTennisCourt
    SET_ITEM_LOCATION(e_ITEM_NormalWindow,e_LOC_CURRENT)
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"Ah, voilà: Un vrai court")
    _BUBBLE_LINE(5,16,0,"de tennis sur gazon")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(4,4,0,"Det er mer som det:")
    _BUBBLE_LINE(4,15,0,"en skikkelig gressbane")
#else
    _BUBBLE_LINE(4,4,0,"That's more like it:")
    _BUBBLE_LINE(4,15,0,"a proper lawn tennis court")
#endif    
    END


// MARK: Vegetable Garden
_gDescriptionVegetableGarden
    SET_ITEM_LOCATION(e_ITEM_CellarWindow,e_LOC_VEGSGARDEN)       ; The window is in the garden
#ifdef LANGUAGE_FR
_gTextItemCellarWindow = *+1
    SET_ITEM_DESCRIPTION(e_ITEM_CellarWindow,"une _fenêtre basse")
#elif defined(LANGUAGE_NO)
_gTextItemCellarWindow = *+1
    SET_ITEM_DESCRIPTION(e_ITEM_CellarWindow,"et kjeller _vindu")
#else
_gTextItemCellarWindow = *+1
    SET_ITEM_DESCRIPTION(e_ITEM_CellarWindow,"a cellar _window")
#endif
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(102,5,0,"Pas le meilleur endroit")
    _BUBBLE_LINE(70,15,0,"pour faire pousser des tomates")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(124,5,0,"Ikke det beste stedet")
    _BUBBLE_LINE(136,16,0,"å dyrke tomater")
#else
    _BUBBLE_LINE(134,5,0,"Not the best spot")
    _BUBBLE_LINE(136,15,1,"to grow tomatoes")
#endif
    END


// MARK: Fish Pond
_gDescriptionFishPond
.(
    SET_ITEM_LOCATION(e_ITEM_NormalWindow,e_LOC_CURRENT)

    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"Certains de ces poissons")
    _BUBBLE_LINE(5,17,0,"sont étonnamment gros")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Noen av disse fiskene")
    _BUBBLE_LINE(5,15,2,"er overraskende store")
#else
    _BUBBLE_LINE(5,5,0,"Some of these fish")
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
#elif defined(LANGUAGE_NO)
        SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"et utilgjengelig _vindu")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"an inaccessible _window")
#endif
    ENDIF(girl_unrestrained)

    ; Draw the girl if she's here
    JUMP_IF_FALSE(girl_is_outside,CHECK_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_TILEDPATIO))
        SET_ITEM_LOCATION(e_ITEM_PanicRoomWindow,e_LOC_NONE)                  ; After all, we don't want the "innacessible window message" anymore
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
#elif defined(LANGUAGE_NO)
            _BUBBLE_LINE(12,50,0,"Takk!")
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
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(12,50,0,"Jeg følger etter deg!")
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
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(120,5,0,"Husets bakinngang")
    _BUBBLE_LINE(120,18,0,"er tilgjengelig herfra")
#else
    _BUBBLE_LINE(93,5,0,"The house's back entrance")
    _BUBBLE_LINE(110,15,0,"is accessible from here")
#endif    
    END
.)

// MARK: Apple Orchard
_gDescriptionAppleOrchard
.(
    ; Is the ladder in the scene?
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_CURRENT),show_ladder)
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,10,16)                        ; Draw the ladder
                _IMAGE(7,45)
                _BUFFER(22,87)
    ENDIF(show_ladder)    

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"La meilleure variété  de pommes:")
    _BUBBLE_LINE(5,17,0,"sucrées, croquantes et juteuses")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Den beste sorten epler:")
    _BUBBLE_LINE(5,17,0,"søte, sprø og saftige")
#else
    _BUBBLE_LINE(5,5,0,"The best kind of apples:")
    _BUBBLE_LINE(5,17,0,"sweet, crunchy and juicy")
#endif
    JUMP(_ChirpingBirds)
.)

// MARK: Entrance Hall
_gDescriptionEntranceHall
.(
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
      GOSUB(_SubCollateralDamage)
      END
      
dog_alive
    ; Draw the Growling dog
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(7,30),40,_SecondImageBuffer+(40*31)+0,_ImageBuffer+(40*25)+18)    

    ; Text describing the growling dog
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,105,0,"Serait-ce Cerbère ?")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,105,0,"Er det Kerberos?")
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
    GOSUB(_SubImpressiveStaircase)
    END
.)

_SubImpressiveStaircase
.(
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(120,5,0,"Un escalier vraiment")
    _BUBBLE_LINE(150,17,0,"impressionnant")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(107,5,0,"En ganske imponerende")
    _BUBBLE_LINE(187,17,0,"trapp")
#else
    _BUBBLE_LINE(124,5,0,"Quite an impressive")
    _BUBBLE_LINE(187,17,0,"staircase")
#endif    
    RETURN
.)


// MARK: Front Entrance
_gDescriptionFrontDoor
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"Quelle entrée !")
    _BUBBLE_LINE(5,17,0,"On dirait un temple")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"For en inngang!")
    _BUBBLE_LINE(5,17,0,"Nesten som et tempel")
#else
    _BUBBLE_LINE(5,5,0,"What an entrance!")
    _BUBBLE_LINE(5,17,0,"Almost like a temple")
#endif
    END


// MARK: Staircase
_gDescriptionStaircase
.(
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
      GOSUB(_SubCollateralDamage)
      END
      
dog_alive
    ; If the dog is alive, it will jump on our face now
    SET_CUT_SCENE(1)
    CLEAR_TEXT_AREA(1)                      ; Just to get a red text area
    QUICK_MESSAGE("Oops...")
    FADE_BUFFER
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_MAIMED_BY_DOG)
    DRAW_BITMAP(LOADER_SPRITE_DOG,BLOCK_SIZE(21,128),40,_SecondImageBuffer+19,_ImageBuffer+(40*0)+10)    ; Draw the attacking dog     
    FADE_BUFFER
    LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
    WAIT(DELAY_FIRST_BUBBLE)
    WAIT(50*2)                              ; Wait a couple seconds
    GAME_OVER(e_SCORE_MAIMED_BY_DOG)        ; The game is now over
    JUMP(_gDescriptionGameOverLost)         ; Game Over

end_dog
    ; Some generic message in case the dog is not there (probably not displayed right now)
    GOSUB(_SubImpressiveStaircase)
    END
.)    



// MARK: Library
_gDescriptionLibrary
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,99,0,"Livres, cheminée et")
    _BUBBLE_LINE(5,105,4,"un bon fauteuil")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,86,0,"Bøker, peis og")
    _BUBBLE_LINE(5,97,0,"en behagelig stol")
#else
    _BUBBLE_LINE(5,86,0,"Books, fireplace, and")
    _BUBBLE_LINE(5,97,0,"a comfortable chair")
#endif    
    END


// MARK: Study Room
_gDescriptionStudyRoom
.(
    SET_ITEM_LOCATION(e_ITEM_NormalWindow,e_LOC_CURRENT)

    ; Is the gun cabinet open?
    JUMP_IF_TRUE(cabinet_closed,CHECK_ITEM_FLAG(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED))
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(6,50),40,_SecondImageBuffer+40*0+8,_ImageBuffer+40*13+24)       ; Cabinet open
cabinet_closed

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(150,5,0,"Tradition et")
    _BUBBLE_LINE(177,17,0,"technologie")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(147,5,0,"Tradisjon møter")
    _BUBBLE_LINE(177,17,0,"teknologi")
#else
    _BUBBLE_LINE(150,5,0,"Tradition meets")
    _BUBBLE_LINE(177,17,0,"technology")
#endif    
    END
.)


// MARK: Narrow Passage
_gDescriptionNarrowPassage
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(4)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,48,0,"Soit ils aiment le noir")
    _BUBBLE_LINE(12,68,0,"soit ils ont oublié")
    _BUBBLE_LINE(27,88,0,"de payer leurs")
    _BUBBLE_LINE(55,108,0,"factures")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,48,0,"Enten elsker de mørket")
    _BUBBLE_LINE(12,68,0,"eller glemte de")
    _BUBBLE_LINE(37,88,0,"å betale")
    _BUBBLE_LINE(75,108,0,"regningene")
#else
    _BUBBLE_LINE(5,48,0,"Either they love the dark")
    _BUBBLE_LINE(12,68,0,"or they forgot to")
    _BUBBLE_LINE(37,88,0,"pay their")
    _BUBBLE_LINE(75,108,0,"bills")
#endif    
    END


// MARK: Entrance Lounge
_gDescriptionEntranceLounge
    SET_ITEM_LOCATION(e_ITEM_NormalWindow,e_LOC_CURRENT)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"On dirait que quelqu'un")
    _BUBBLE_LINE(12,13,4,"s'est bien amusé")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Det ser ut som noen")
    _BUBBLE_LINE(5,15,0,"hadde det gøy")
#else
    _BUBBLE_LINE(5,5,0,"Looks like someone")
    _BUBBLE_LINE(5,15,0,"had fun")
#endif    
    END


// MARK: Dining Room
_gDescriptionDiningRoom
    SET_ITEM_LOCATION(e_ITEM_NormalWindow,e_LOC_CURRENT)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,100,0,"Deux assiettes...")
    _BUBBLE_LINE(5,107,4,"...bon à savoir")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,95,0,"To tallerkener...")
    _BUBBLE_LINE(5,107,0,"...godt å vite")
#else
    _BUBBLE_LINE(5,95,0,"Two plates...")
    _BUBBLE_LINE(5,107,0,"...good to know")
#endif    
    END


// MARK: Game Room
_gDescriptionGamesRoom
    SET_ITEM_LOCATION(e_ITEM_NormalWindow,e_LOC_CURRENT)

    ; Is the tv cabinet open?
    JUMP_IF_TRUE(cabinet_closed,CHECK_ITEM_FLAG(e_ITEM_TVCabinet,ITEM_FLAG_CLOSED))
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(6,12),40,_SecondImageBuffer+40*100+34,_ImageBuffer+40*58+24)       ; Cabinet open
cabinet_closed

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(155,5,0,"Système vidéo")
    _BUBBLE_LINE(151,16,0,"haut de gamme")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(152,5,0,"Topp i klassen")
    _BUBBLE_LINE(164,16,0,"videosystem")
#else
    _BUBBLE_LINE(142,5,0,"Top of the range")
    _BUBBLE_LINE(164,16,0,"video system")
#endif
    WAIT(50)

    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(151,40,0,"Impressionnant")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(165,40,0,"Imponerende")
#else
    _BUBBLE_LINE(175,40,0,"Impressive")
#endif    
    END


// MARK: Sun Lounge
_gDescriptionSunLounge
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
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(112,5,0,"Ingen ro for de slitne")
#else
    _BUBBLE_LINE(112,5,0,"No rest for the weary")
#endif    
    END


// MARK: Kitchen
_gDescriptionKitchen
.(
    SET_ITEM_LOCATION(e_ITEM_NormalWindow,e_LOC_CURRENT)

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
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Et godt utstyrt")
    _BUBBLE_LINE(5,18,0,"kjøkken")
#else
    _BUBBLE_LINE(5,5,0,"A well-equipped")
    _BUBBLE_LINE(5,14,4,"kitchen")
#endif    
    END
.)


// MARK: Cellar Stairs
_gDescriptionCellarStairs
    .(
    ; First we check if the player stroke the matches
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BoxOfMatches,e_LOC_NONE),matches)    ; Are the matches on fire?    
        GOSUB(_gMiniKaboom)
        FADE_BUFFER
    ENDIF(matches)
    .)
    WAIT(DELAY_FIRST_BUBBLE)
    BLACK_BUBBLE(1)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"Attention à la marche")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Se opp for trinnet")
#else
    _BUBBLE_LINE(5,5,0,"Watch your step")
#endif    
    END


// MARK: Cellar Safe
_gDescriptionCellar
.(  
    ; We check if the player stroke the matches.
    ; Typically we would be back there in the case the player inspects the safe after starting the fuse
    ; If they do that, well, sucks to be them.
    JUMP_IF_TRUE(kaboom,CHECK_ITEM_LOCATION(e_ITEM_BoxOfMatches,e_LOC_NONE))   ; Are the matches on fire?

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

    ; Then we check if the player stroke the matches
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_BoxOfMatches,ITEM_FLAG_TRANSFORMED),matches)    ; Are the matches on fire?
        ; We set a few values right now, because the player can leave the script before it is finished.
        ; If these values are not set before the first WAIT instruction, the game will be broken.
        SET_ITEM_LOCATION(e_ITEM_Bomb,e_LOC_NONE)                    ; The bomb is gone
        SET_ITEM_LOCATION(e_ITEM_BoxOfMatches,e_LOC_NONE)            ; Don't need the matches anymore
        UNSET_ITEM_FLAGS(e_ITEM_BoxOfMatches,ITEM_FLAG_TRANSFORMED)  ; Un-strike the matches (just so the test above does not trigger a second time)
        WAIT(1)

#ifdef LANGUAGE_FR                                                   ; Rename the safe to "an open safe"
        SET_ITEM_DESCRIPTION(e_ITEM_HeavySafe,"un _coffre ouvert")
#elif defined(LANGUAGE_NO)
        SET_ITEM_DESCRIPTION(e_ITEM_HeavySafe,"en åpen _safe")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_HeavySafe,"a open _safe")
#endif

        CLEAR_TEXT_AREA(1)
#ifdef LANGUAGE_FR
        QUICK_MESSAGE("Bon, il faut se mettre à l'abri.")
#elif defined(LANGUAGE_NO)
        QUICK_MESSAGE("Greit, på tide å komme seg unna.")
#else
        QUICK_MESSAGE("Right, time to move to safety.")
#endif        
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
#ifdef LANGUAGE_FR
        QUICK_MESSAGE("Pourquoi je suis encore là ?!")
#elif defined(LANGUAGE_NO)
        QUICK_MESSAGE("Hvorfor står jeg fortsatt her?!")
#else
        QUICK_MESSAGE("Why am I still here?!")
#endif        

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
#ifdef LANGUAGE_FR
        QUICK_MESSAGE("BOUGE ! MAINTENANT !")
#elif defined(LANGUAGE_NO)
        QUICK_MESSAGE("FLYTT DEG! NÅ! NÅ! NÅ!")
#else
        QUICK_MESSAGE("MOVE! NOW! NOW! NOW!")
#endif        

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the fuse animation sequence frame
                _IMAGE(8+3*5,67)
                _SCREEN(30,43)

        PLAY_SOUND(_FuseBurning)
        WAIT(50)

        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,61)                     ; Draw the fuse animation sequence frame
                _IMAGE(8+3*6,67)
                _SCREEN(30,43)

        WAIT(50)
kaboom        
        SET_CUT_SCENE(1)
        CLEAR_TEXT_AREA(1)
#ifdef LANGUAGE_FR
        QUICK_MESSAGE("On m'avait prévenu...")
#elif defined(LANGUAGE_NO)
        QUICK_MESSAGE("Jeg ble advart om dette...")
#else
        QUICK_MESSAGE("I was told this would happen...")
#endif        
        JUMP(_KaboomSafe)

    ELSE(matches,no_matches)
        ; We only show the Franz Jager message if we are not actively trying to blow up the safe
        WAIT(DELAY_FIRST_BUBBLE)
        BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR
        _BUBBLE_LINE(45,15,0,"Est-ce un coffre-fort")
        _BUBBLE_LINE(70,25,0,"Franz Jager ?")
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(75,15,0,"Er det en Franz")
        _BUBBLE_LINE(80,25,0,"Jager safe?")
#else
        _BUBBLE_LINE(75,15,0,"Is that a Franz")
        _BUBBLE_LINE(80,25,0,"Jager safe?")
#endif    
    ENDIF(no_matches)
    END
.)


_CombinePetrolWithMatches
_CombineGunPowderWithMatches
_Kaboom
    CLEAR_TEXT_AREA(1)
#ifdef LANGUAGE_FR
    QUICK_MESSAGE("Allumettes et articles inflammables")
#elif defined(LANGUAGE_NO)
    QUICK_MESSAGE("Fyrstikker og brannfarlige ting...")
#else
    QUICK_MESSAGE("Matches and flammable items...")
#endif        
_KaboomSafe
.(
    SET_CUT_SCENE(1)
    PLAY_SOUND(_ExplodeData)
    DISPLAY_IMAGE_ONLY(LOADER_PICTURE_EXPLOSION)
    LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_BLOWN_INTO_BITS)             ; Achievement!
    GAME_OVER(e_SCORE_BLOWN_INTO_BITS)                          ; The game is now over

    WAIT(50*2)

    JUMP(_gDescriptionGameOverLost)                             ; Draw the 'The End' logo    
.)


// MARK: Darker Cellar
// TODO: Hide the locked panel
// TODO: Activate the window "it's too high"
_gDescriptionDarkerCellar
.(
    SET_ITEM_LOCATION(e_ITEM_CellarWindow, e_LOC_DARKCELLARROOM)           ; The window is visible
    .(
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER),else)
        SET_SCENE_IMAGE(LOADER_PICTURE_LOCATIONS_CELLAR_BRIGHT)
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
        SET_ITEM_DESCRIPTION(e_ITEM_CellarWindow,"une _fenêtre occultée")
#elif defined(LANGUAGE_NO)
        SET_ITEM_DESCRIPTION(e_ITEM_CellarWindow,"et mørklagt _vindu")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_CellarWindow,"a darkened _window")
#endif
    ENDIF(open)
    .)

    ; If the ladder is at the cellar window and is in place, we move it back here (same pattern as pit sync)
    .(
    JUMP_IF_FALSE(end_ladder_sync,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_CELLAR_WINDOW))
    JUMP_IF_FALSE(end_ladder_sync,CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_DARKCELLARROOM)
    UNSET_ITEM_FLAGS(e_ITEM_Ladder,ITEM_FLAG_IMMOVABLE)     ; Can grab it again from the bottom
end_ladder_sync
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
    ; Then we check if the player stroke the matches
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BoxOfMatches,e_LOC_NONE),matches)    ; Are the matches on fire?
        GOSUB(_gMiniKaboom)        
        GOSUB(_gDrawSafeInDarkRom)            ; Make sure the safe looks correct after the explosion
        FADE_BUFFER
    ENDIF(matches)
    .)

    .(
    WAIT(DELAY_FIRST_BUBBLE)
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER),tape_off)
        BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR
        _BUBBLE_LINE(5,99,0,"On y voit bien")
        _BUBBLE_LINE(5,106,4,"mieux maintenant !")
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(5,99,0,"Man ser definitivt")
        _BUBBLE_LINE(5,108,3,"mye bedre nå!")
#else
        _BUBBLE_LINE(5,99,0,"Can definitely see")
        _BUBBLE_LINE(5,108,3,"better now!")
#endif
    ELSE(tape_off,tape_on)
        BLACK_BUBBLE(2)
#ifdef LANGUAGE_FR
        _BUBBLE_LINE(5,99,0,"La fenêtre semble")
        _BUBBLE_LINE(5,106,4,"occultée")
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(5,99,0,"Vinduet virker")
        _BUBBLE_LINE(5,107,3,"tildekket")
#else
        _BUBBLE_LINE(5,99,0,"The window seems")
        _BUBBLE_LINE(5,107,3,"to be covered")
#endif
    ENDIF(tape_on)
    .)    

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED),alarm_active)      ; Is the alarm active...
blinking_led_animation
        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,1,3)                     ; Draw the led ON
                _IMAGE(5,88)
                _SCREEN(25,28)
        PLAY_SOUND(_AlarmLedBeeping)
        WAIT(50)
        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,1,3)                     ; Draw the led OFF
                _IMAGE(6,88)
                _SCREEN(25,28)
        WAIT(50*2)

        JUMP(blinking_led_animation)
    ENDIF(alarm_active)

    END
.)

_gMiniKaboom
.(
    SET_CUT_SCENE(1)
    FADE_BUFFER
    WAIT(50)
    PLAY_SOUND(_ExplodeData)
    SET_ITEM_LOCATION(e_ITEM_BoxOfMatches,e_LOC_GONE_FOREVER)           ; Don't need the matches anymore
    UNSET_ITEM_FLAGS(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED)                 ; The safe is now open
    BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,7,31)                            ; Draw the Boom!
            _IMAGE(20,0)
            _SCREEN(17,24)
    CLEAR_TEXT_AREA(1)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Heureusement que j'étais pas là !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Godt at jeg ikke var der inne!")
#else
    INFO_MESSAGE("Glad I wasn't standing in there.")
#endif
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
    SET_ITEM_LOCATION(e_ITEM_CellarWindow, e_LOC_CELLAR_WINDOW)           ; The window is visible

    ; If the ladder is in the dark cellar and is in place, we move it here (same pattern as pit sync)
    JUMP_IF_FALSE(end_ladder_sync,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_DARKCELLARROOM))
    JUMP_IF_FALSE(end_ladder_sync,CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED))
    SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_CELLAR_WINDOW)
    SET_ITEM_FLAGS(e_ITEM_Ladder,ITEM_FLAG_IMMOVABLE)       ; Can't grab it from the top
end_ladder_sync

    ; Inspecting the window in the cellar
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER),bright)
        SET_SCENE_IMAGE(LOADER_PICTURE_LOCATIONS_CELLAR_WINDOW_INSIDE_CLEARED)
    ELSE(bright,dark)
        DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_LOCATIONS_CELLAR_WINDOW_INSIDE_DARKENED)
    ENDIF(dark)

    ; Is the ladder in place?
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_CELLAR_WINDOW),ladder)
        BLIT_BLOCK(LOADER_SPRITE_ITEMS,12,28)                     ; Draw the ladder
                _IMAGE(7,100)
                _BUFFER(14,101)
    ENDIF(ladder)
    FADE_BUFFER      ; Make sure everything appears on the screen

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED),alarm_active)      ; Is the alarm active...
beeping_alarm_panel_loop
        PLAY_SOUND(_AlarmLedBeeping)                                ; Play the beep sound of the alarm
        WAIT(50*3)
        JUMP(beeping_alarm_panel_loop)
    ENDIF(alarm_active)
    
    END
.)


// MARK: Main Landing
_gDescriptionMainLanding
    SET_ITEM_LOCATION(e_ITEM_NormalWindow,e_LOC_CURRENT)
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(53,70,0,"Belle vue de là-haut")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(47,70,0,"Fin utsikt herfra oppe")
#else
    _BUBBLE_LINE(47,70,0,"Nice view from up here")
#endif    
    END


// MARK: East Gallery
_gDescriptionEastGallery
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"Couloir sans intérêt:")
    _BUBBLE_LINE(20,13,4,"C'est fait")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Kjedelig korridor:")
    _BUBBLE_LINE(20,14,3,"Hak av")
#else
    _BUBBLE_LINE(5,5,0,"Boring corridor:")
    _BUBBLE_LINE(20,17,0,"Check")
#endif    
    END

#ifdef PRODUCT_TYPE_GAME_DEMO
_gDescriptionChildBedroom
_gDescriptionGuestBedroom
_gDescriptionShowerRoom
_gDescriptionWestGallery
_gDescriptionBoxRoom
_gDescriptionClassyBathRoom
_gDescriptionTinyToilet
_gDescriptionMasterBedRoom
#else
// MARK: Child Bedroom
_gDescriptionChildBedroom
#ifdef TESTING_MONKEY_KING
    CALL_NATIVE(_PlayMonkeyKing)
#endif    
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,86,0,"Laissez-moi deviner:")
    _BUBBLE_LINE(5,94,4,"Chambre d'adolescent ?")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(7,95,0,"La meg gjette:")
    _BUBBLE_LINE(5,107,0,"Tenåringrom?")
#else
    _BUBBLE_LINE(5,96,0,"Let me guess:")
    _BUBBLE_LINE(5,107,0,"Teenager room?")
#endif    
    END


// MARK: Guest Bedroom
_gDescriptionGuestBedroom

    ; Is the drawer cabinet open?
    JUMP_IF_TRUE(drawer_closed,CHECK_ITEM_FLAG(e_ITEM_Drawer,ITEM_FLAG_CLOSED))
    DRAW_BITMAP(LOADER_SPRITE_SAFE_ROOM,BLOCK_SIZE(4,9),40,_SecondImageBuffer+40*117+0,_ImageBuffer+40*69+7)       ; Drawer open
drawer_closed

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,6,0,"Simple et rafraichissant")
    _BUBBLE_LINE(5,17,0,"pour changer")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,6,0,"Enkelt og friskt")
    _BUBBLE_LINE(5,17,0,"for en gangs skyld")
#else
    _BUBBLE_LINE(5,6,0,"Simple and fresh")
    _BUBBLE_LINE(5,17,0,"for a change")
#endif    
    END


// MARK: Shower Room
_gDescriptionShowerRoom
.(
    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(145,5,0,"J'en aurai besoin")
    _BUBBLE_LINE(136,16,0,"quand j'aurai fini")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(149,5,0,"Jeg trenger en")
    _BUBBLE_LINE(142,16,0,"når jeg er ferdig")
#else
    _BUBBLE_LINE(149,5,0,"I will need one")
    _BUBBLE_LINE(152,16,0,"when I'm done")
#endif    
    END
.)


// MARK: West Gallery
_gDescriptionWestGallery
.(
    ; If the suit is equiped, we remove it
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED),suit)    ; Is the protection suit equiped?
        SET_CUT_SCENE(1)
        UNSET_ITEM_FLAGS(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED)
        PLAY_SOUND(_Zipper)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il faut que j'enlève la combinaison")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Jeg må ta av meg den dressen")
#else
        INFO_MESSAGE("I need to remove that suit")
#endif
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
    _BUBBLE_LINE(70,81,0,"Au théâtre ce soir...")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(55,81,0,"Som på teateret i kveld...")
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
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(85,81,0,"Er det stål")
    _BUBBLE_LINE(60,92,0,"bak forhenget?")
#else
    _BUBBLE_LINE(85,81,0,"Is that steel")
    _BUBBLE_LINE(60,92,0,"behind the curtain?")
#endif    
    END
.)


// MARK: Box Room
_gDescriptionBoxRoom
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(5,5,0,"Une petite pièce")
    _BUBBLE_LINE(5,12,4,"utilitaire")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Et praktisk")
    _BUBBLE_LINE(5,13,3,"lite rom")
#else
    _BUBBLE_LINE(5,5,0,"A practical")
    _BUBBLE_LINE(5,16,0,"little room")
#endif    
    END


// MARK: Classy Bathroom
_gDescriptionClassyBathRoom
.(
    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(132,5,0,"Semble confortable")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(128,5,1,"Ser komfortabelt ut")
#else
    _BUBBLE_LINE(132,5,0,"Looks comfortable")
#endif    
    END
.)


// MARK: Tiny Toilet
_gDescriptionTinyToilet
.(
    ; Spawn water if required
    GOSUB(_SpawnWaterIfNotEquipped)

    ; Draw the roll of toilet paper if present
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_ToiletRoll,e_LOC_TINY_WC),toilet_paper)
        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,16)
                _IMAGE(20,32)
                _BUFFER(19,13)
    ENDIF(toilet_paper)

    WAIT(DELAY_FIRST_BUBBLE)
#ifdef LANGUAGE_FR
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(160,5,0,"Une propreté")
    _BUBBLE_LINE(173,13,4,"étincelante")
#elif defined(LANGUAGE_NO)
    WHITE_BUBBLE(1)
    _BUBBLE_LINE(147,5,0,"Skinnende rent")
#else
    WHITE_BUBBLE(1)
    _BUBBLE_LINE(137,5,0,"Sparklingly clean")
#endif    
    END
.)

// MARK: Master Bedroom
_gDescriptionMasterBedRoom
.(
    ; Is there a thug in the master bedroom
    //JUMP_IF_FALSE(end_thug,CHECK_ITEM_LOCATION(e_ITEM_Thug,e_LOC_MASTERBEDROOM))

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
      GOSUB(_SubCollateralDamage)
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
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Dette vil gjøre ting")
    _BUBBLE_LINE(5,16,0,"mye enklere...")
#else
    _BUBBLE_LINE(5,5,0,"This will make things")
    _BUBBLE_LINE(5,16,0,"notably easier...")
#endif    
    ; Should probably have a "game over" command

.(
loop_snore
    PLAY_SOUND(_Snore)
    WAIT_RANDOM(200,25)
    WAIT_RANDOM(200,25)
    JUMP(loop_snore)
.)

    END
.)
#endif // PRODUCT_TYPE_GAME_DEMO


    /*
end_thug    
    ; Draw the message
    WAIT(DELAY_FIRST_BUBBLE)
    WHITE_BUBBLE(2)
    _BUBBLE_LINE(5,5,0,"This was make things")
    _BUBBLE_LINE(5,16,0,"notably easier...")
    ; Should probably have a "game over" command
    FADE_BUFFER
    END
    */


_SubCollateralDamage
.(
    WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
    _BUBBLE_LINE(10,5,0,"Appelons cela un")
    .byt 5,18,0,34,"dommage collatéral",34,0
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"La oss kalle det")
    .byt 5,15,2,34,"kollateral skade",34,0
#else
    _BUBBLE_LINE(5,5,0,"Let's call that")
    .byt 5,17,0,34,"collateral damage",34,0
#endif      
    RETURN
.)


// MARK: Panic Room Door
_gDescriptionPanicRoomDoor
.(
    ; Move the panic room window here if the girl is freed
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_YoungGirl,ITEM_FLAG_DISABLED),girl_unrestrained)
        SET_ITEM_LOCATION(e_ITEM_PanicRoomWindow,e_LOC_PANIC_ROOM_DOOR)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED),closed)
#ifdef LANGUAGE_FR
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"la _fenêtre de la chambre forte")
#elif defined(LANGUAGE_NO)
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"et _vindu til panikk rommet")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"the panic room _window")
#endif
        ELSE(closed,openened)
#ifdef LANGUAGE_FR
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"la _fenêtre ouverte de la chambre forte")
#elif defined(LANGUAGE_NO)
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"et åpent _vindu til panikk rommet")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_PanicRoomWindow,"the open panic room _window")
#endif
        ENDIF(openened)
    ENDIF(girl_unrestrained)

    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_HoleInDoor,e_LOC_CURRENT),acid)  ; Is there a hole in the door?
        BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,5,14)                        ; Draw the acid hole
                _IMAGE(18,50)
                _BUFFER(15,72)
        WAIT(DELAY_FIRST_BUBBLE)
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
        _BUBBLE_LINE(150,10,1,"Elle est moins")
        _BUBBLE_LINE(120,57,1,"sécurisée maintenant")
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(138,70,0,"Definitivt mindre")
        _BUBBLE_LINE(148,82,3,"sikker nå")
#else
        _BUBBLE_LINE(153,70,0,"Definitely less")
        _BUBBLE_LINE(148,85,0,"secure now")
#endif    
        END
    ENDIF(acid)

    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED),suit)    ; Is the protection suit equiped?
        SET_SCENE_IMAGE(LOADER_PICTURE_LOCATIONS_STEEL_DOOR_WITH_GOGGLES)                ; Then we show the view with the goggles on
        WAIT(DELAY_FIRST_BUBBLE)
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
        _BUBBLE_LINE(135,16,0,"C'est un peu")
        _BUBBLE_LINE(131,53,0,"oppressant")
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(153,70,0,"Det er litt")
        _BUBBLE_LINE(148,85,0,"klaustrofobisk")
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
        _BUBBLE_LINE(153,70,1,"On dirait")
        _BUBBLE_LINE(148,80,2,"un sourire :)")
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(138,70,0,"Det ligner nesten")
        _BUBBLE_LINE(148,85,0,"på et smil :)")
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
    _BUBBLE_LINE(5,5,0,"Zut!")
    _BUBBLE_LINE(148,74,0,"Ils ont employé")
    _BUBBLE_LINE(130,85,0,"les grands moyens!")
#elif defined(LANGUAGE_NO)
    _BUBBLE_LINE(5,5,0,"Jøss...")
    _BUBBLE_LINE(168,70,0,"Det er noe")
    _BUBBLE_LINE(148,81,0,"seriøst utstyr!")
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
    STOP_CLOCK
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
    WORD_MAPPING(e_WORD_NORTH     ,_PlayerMove                ,0+FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_SOUTH     ,_PlayerMove                ,0+FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_EAST      ,_PlayerMove                ,0+FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_WEST      ,_PlayerMove                ,0+FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_UP        ,_PlayerMove                ,0+FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_DOWN      ,_PlayerMove                ,0+FLAG_MAPPING_DEFAULT)

    WORD_MAPPING(e_WORD_TAKE      ,_TakeItem                  ,1+FLAG_MAPPING_DEFAULT)
    WORD_MAPPING(e_WORD_DROP      ,_DropItem                  ,1+FLAG_MAPPING_DEFAULT)

    WORD_MAPPING(e_WORD_HELP      ,_PauseGameScript           ,0+FLAG_MAPPING_STREAM|FLAG_MAPPING_STREAM_CALLBACK)
    WORD_MAPPING(e_WORD_QUIT      ,_QuitGameScript            ,0+FLAG_MAPPING_STREAM|FLAG_MAPPING_STREAM_CALLBACK)

    ; Implemented as script streams
    WORD_MAPPING(e_WORD_COMBINE   ,_gCombineItemMappingsArray ,2+FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_READ      ,_gReadItemMappingsArray    ,1+FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_USE       ,_gUseItemMappingsArray     ,1+FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_OPEN      ,_gOpenItemMappingsArray    ,1+FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_CLOSE     ,_gCloseItemMappingsArray   ,1+FLAG_MAPPING_STREAM)

    WORD_MAPPING(e_WORD_LOOK      ,_gInspectItemMappingsArray ,1+FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_FRISK     ,_gSearchtemMappingsArray   ,1+FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_SEARCH    ,_gSearchtemMappingsArray   ,1+FLAG_MAPPING_STREAM)
    WORD_MAPPING(e_WORD_THROW     ,_gThrowItemMappingsArray   ,1+FLAG_MAPPING_STREAM)

    WORD_MAPPING(e_WORD_SKIP      ,_DoNothing                 ,0+FLAG_MAPPING_DEFAULT)   // To avoid the double execution of code when using ENTER instead of SPACE

    WORD_MAPPING(e_WORD_COUNT_    ,0, 0)
    // End Marker


_gActionMappingMenu
    .byt e_WORD_LOOK,e_WORD_READ,e_WORD_SEARCH,e_WORD_HELP,
    .byt e_WORD_TAKE,e_WORD_DROP,e_WORD_OPEN,e_WORD_CLOSE,
    .byt e_WORD_USE,e_WORD_THROW,e_WORD_COMBINE,e_WORD_QUIT,e_WORD_COUNT_


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
    COMBINE_MAPPING(e_ITEM_Petrol,e_ITEM_BoxOfMatches       ,_CombinePetrolWithMatches)
    COMBINE_MAPPING(e_ITEM_Saltpetre,e_ITEM_Sulphur         ,_CombineSulfurWithSalpetre)
    COMBINE_MAPPING(e_ITEM_PowderMix,e_ITEM_MortarAndPestle ,_CombinePowderMixWithMortar)
    COMBINE_MAPPING(e_ITEM_GunPowder,e_ITEM_Fuse            ,_CombineGunPowderWithFuse)
    COMBINE_MAPPING(e_ITEM_GunPowder,e_ITEM_BoxOfMatches    ,_CombineGunPowderWithMatches)
    COMBINE_MAPPING(e_ITEM_TobaccoTin,e_ITEM_Fuse           ,_CombineTinWithFuse)
    COMBINE_MAPPING(e_ITEM_Bomb,e_ITEM_Adhesive             ,_CombineBombWithAdhesive)
    COMBINE_MAPPING(e_ITEM_Bomb,e_ITEM_HeavySafe            ,_CombineStickyBombWithSafe)
    COMBINE_MAPPING(e_ITEM_Bomb,e_ITEM_BoxOfMatches         ,_CombineBombWithMatches)
    COMBINE_MAPPING(e_ITEM_SedativePills,e_ITEM_MortarAndPestle ,_CombinePillsWithMortar)
    COMBINE_MAPPING(e_ITEM_Clay,e_ITEM_Water                ,_CombineClayWithWater)
    COMBINE_MAPPING(e_ITEM_Clay,e_ITEM_SecurityDoor         ,_CombineClayDoor)    
    COMBINE_MAPPING(e_ITEM_SilverKnife,e_ITEM_HoleInDoor    ,_CombineKnifeHole)
    COMBINE_MAPPING(e_ITEM_SilverKnife,e_ITEM_Apple         ,_CombineKnifeApple)
    COMBINE_MAPPING(e_ITEM_Rope,e_ITEM_HoleInDoor           ,_CombineRopeHole)
    COMBINE_MAPPING(e_ITEM_SnookerCue,e_ITEM_HoleInDoor     ,_CombineQueueHole)
    COMBINE_MAPPING(e_ITEM_SnookerCue,e_ITEM_Rope           ,_CombineCueWithRope)
    COMBINE_MAPPING(e_ITEM_SnookerCue,e_ITEM_PanicRoomWindow,_CombineQueueHole)
    COMBINE_MAPPING(e_ITEM_PanicRoomWindow,e_ITEM_Rope      ,_CombineWindowWithRope)
    COMBINE_MAPPING(e_ITEM_Hose,e_ITEM_CarTank              ,_CombineHoseTank)
    COMBINE_MAPPING(e_ITEM_Rope,e_ITEM_Tree                 ,_CombineRopeTree)
    COMBINE_MAPPING(e_ITEM_HandheldGame,e_ITEM_Batteries    ,_CombineGameWithBatteries)
    VALUE_MAPPING2(255,255    ,_ErrorCannotDo)


_CombinePillsWithMortar
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_SedativePills,ITEM_FLAG_TRANSFORMED),already_crushed)
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Déjà fait.")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Allerede gjort.")
#else
        ERROR_MESSAGE("Already done that.")
#endif    
    ELSE(already_crushed,not_crushed_yet)
        DISPLAY_IMAGE(LOADER_PICTURE_MORTAR_AND_PESTLE)
        LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Broyés. Devrait bien se dissoudre.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Knust. Bør løse seg opp fint.")
#else
        INFO_MESSAGE("Crushed. Should dissolve nicely.")
#endif
        SET_ITEM_FLAGS(e_ITEM_SedativePills,ITEM_FLAG_TRANSFORMED)       ; We now have some crushed pills
#ifdef LANGUAGE_FR                                                       ; Rename the pills to "crushed pills"
        SET_ITEM_DESCRIPTION(e_ITEM_SedativePills,"des$_pilules écrasées")
#elif defined(LANGUAGE_NO)
        SET_ITEM_DESCRIPTION(e_ITEM_SedativePills,"noen$knuste _piller")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_SedativePills,"some$crushed _pills")
#endif
        STOP_MUSIC()
    ENDIF(not_crushed_yet)
    END_AND_REFRESH
.)

_CombineMeatWithPills
.(
    SET_ITEM_LOCATION(e_ITEM_SedativePills,e_LOC_GONE_FOREVER)      ; The sedative are gone from the game
    SET_ITEM_FLAGS(e_ITEM_Meat,ITEM_FLAG_TRANSFORMED)                    ; We now have some drugged meat in our inventory
#ifdef LANGUAGE_FR                                                       ; Rename the meat to "drugged meat"
    SET_ITEM_DESCRIPTION(e_ITEM_Meat,"_viande sédative")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Meat,"_kjøtt med sovemiddel")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Meat,"drugged _meat")
#endif
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_MEAT)   ; Achievement!
    INCREASE_SCORE(POINTS_DRUGGED_MEAT)
    END_AND_REFRESH
.)


_CombinePetrolWithTP
.(
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Et voilà une mèche.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det ble en fin lunte.")
#else
    INFO_MESSAGE("That makes a decent fuse.")
#endif
    COMBINE_ITEMS_2(e_ITEM_Fuse,e_ITEM_Petrol,e_ITEM_ToiletRoll)         ; We now have a fuse for our bomb, the Petrol and TP are gone
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_BUILT_A_FUSE)                         ; Achievement!    
    INCREASE_SCORE(POINTS_BUILT_FUSE)
    STOP_MUSIC()
    END_AND_REFRESH
.)


_CombineSulfurWithSalpetre
.(
    COMBINE_ITEMS_2(e_ITEM_PowderMix,e_ITEM_Saltpetre,e_ITEM_Sulphur)    ; We now have a rough powder mix for our bomb, the saltpetre and sulphur are gone
    INCREASE_SCORE(POINTS_COMBINED_SULPHUR_SALTPETRE)
    JUMP(_InspectPowderMix)
.)


_CombineGameWithBatteries
.(
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Le jeu devrait marcher maintenant")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Spillet bør nå fungere")
#else
    INFO_MESSAGE("The game should be working now")
#endif
    SET_ITEM_FLAGS(e_ITEM_HandheldGame,ITEM_FLAG_TRANSFORMED)                            ; The game should now be working
    SET_ITEM_LOCATION(e_ITEM_Batteries,e_LOC_NONE)                                       ; The batteries are now gone
    INCREASE_SCORE(POINTS_COMBINED_BATTERIES_GAME)
    STOP_MUSIC()
    END_AND_REFRESH
.)



_CombineTinWithFuse
.(
    IF_FALSE(CHECK_ITEM_CONTAINER(e_ITEM_GunPowder,e_ITEM_TobaccoTin),missing_powder)    ; Is the gunpowder in the tobacco tin?
       // We reach this code path if the gun power is not in the tin
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Inutile sans poudre.")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Ubrukelig uten krutt.")
#else
        ERROR_MESSAGE("No good without gunpowder.")
#endif    
        END_AND_PARTIAL_REFRESH
    ENDIF(missing_powder)
.)
_CombineGunPowderWithFuse
.(
    IF_TRUE(CHECK_ITEM_CONTAINER(e_ITEM_GunPowder,e_ITEM_TobaccoTin),in_tin)    ; Is the gunpowder in the tobacco tin?
        COMBINE_ITEMS_3(e_ITEM_Bomb,e_ITEM_GunPowder,e_ITEM_Fuse,e_ITEM_TobaccoTin) ; We now have a bomb, the Gunpowder, Fuse and Tin are now gone
        INCREASE_SCORE(POINTS_COMBINED_GUNPOWDER_FUSE)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_BUILT_A_BOMB)                         ; Achievement!    

        DISPLAY_IMAGE(LOADER_PICTURE_READY_TO_BLOW)
        LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("L'explosif est prêt...")
        INFO_MESSAGE("...mais il faut l'attacher")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Sprengstoffet er klart...")
        INFO_MESSAGE("...men det må festes")
#else
        INFO_MESSAGE("The explosive is ready...")
        INFO_MESSAGE("...but it needs to be attached")
#endif
        STOP_MUSIC()
        WAIT_KEYPRESS
    ELSE(in_tin,not_tin)
       // We reach this code path if the gun power is in the bucket, plastic bag, etc...
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Il faut un contenant pour la poudre")
        ERROR_MESSAGE("Il doit être solide et refermable")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Kruttet trenger en god beholder")
        ERROR_MESSAGE("Den bør være solid og lukkbar")
#else
        ERROR_MESSAGE("The powder needs a proper container")
        ERROR_MESSAGE("It should be sturdy and closable")
#endif    
    ENDIF(not_tin)
    END_AND_REFRESH
.)


_CombineBombWithAdhesive
.(
    SET_ITEM_LOCATION(e_ITEM_Adhesive,e_LOC_NONE)                        ; The adhesive is gone
    SET_ITEM_FLAGS(e_ITEM_Bomb,ITEM_FLAG_TRANSFORMED)                    ; We now have a sticky bomb
    INCREASE_SCORE(POINTS_COMBINED_BOMB_ADHESIVE)
#ifdef LANGUAGE_FR                                                       ; Rename the bomb to "sticky bomb"
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"_bombe collante")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"en$klissete _bombe")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"a$sticky _bomb")
#endif
    DISPLAY_IMAGE(LOADER_PICTURE_STICKY_BOMB)
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR                                                       ; Rename the bomb to "sticky bomb"
    INFO_MESSAGE("Ca devrait être tout bon...")
    INFO_MESSAGE("...plus qu'à l'installer !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Bør være klar til bruk nå...")
    INFO_MESSAGE("...bare å installere den!")
#else
    INFO_MESSAGE("Should be ready to use now...")
    INFO_MESSAGE("...need to install it!")
#endif
    STOP_MUSIC()
    END_AND_REFRESH
.)


_CombineStickyBombWithSafe
.(
    ; If the bomb is already attached, we don't redo the whole sequence
    JUMP_IF_TRUE(_ErrorAlreadyPositioned_Elle,CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_ATTACHED))

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_TRANSFORMED),sticky)      ; Is the bomb sticky?
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Faut que ça colle à la porte.")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Må feste seg til døren på noe vis.")
#else
        ERROR_MESSAGE("Needs to stick to the door somehow.")
#endif        
        END_AND_REFRESH
    ENDIF(sticky)

#ifdef LANGUAGE_FR                                                           ; Rename the sticky bomb to "bomb on the doort"
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"_bombe sur la porte")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"en _bombe på døren")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Bomb,"a _bomb on the door")
#endif
    SET_ITEM_LOCATION(e_ITEM_Bomb,e_LOC_CURRENT)                             ; The bomb is now in the room
    SET_ITEM_FLAGS(e_ITEM_Bomb,ITEM_FLAG_ATTACHED|ITEM_FLAG_IMMOVABLE)       ; The bomb is now attached to the safe and cannot be removed
    INCREASE_SCORE(POINTS_ATTACHED_BOMB_TO_SAFE)
    DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_WITH_BOMB)
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Tout est en place...")
    INFO_MESSAGE("...attention à l'allumage !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Alt er på plass...")
    INFO_MESSAGE("...bare å antenne det forsiktig!")
#else
    INFO_MESSAGE("Everything is in place...")
    INFO_MESSAGE("...need to ignite it safely though!")
#endif
    STOP_MUSIC()
    END_AND_REFRESH
.)



_CombineClayWithWater
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_TRANSFORMED),wet)    ; Is the clay wet?
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Encore humide. Pas la peine.")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Fortsatt vått. Ikke nødvendig.")
#else
        ERROR_MESSAGE("Still wet. No need.")
#endif        
        END_AND_REFRESH
    ENDIF(wet)

#ifdef LANGUAGE_FR                                                     ; Rename the dry clay to wet clay
    SET_ITEM_DESCRIPTION(e_ITEM_Clay,"de l'$_argile humide")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Clay,"noe$fuktig _leire")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Clay,"some$wet _clay")
#endif
    SET_ITEM_FLAGS(e_ITEM_Clay,ITEM_FLAG_TRANSFORMED)                  ; Clay is now wet
    INCREASE_SCORE(POINTS_MADE_CLAY_WET)
    END_AND_REFRESH
.)



_CombineCueWithRope
.(
    DISPLAY_IMAGE(LOADER_PICTURE_CUE_WITH_ROPE)
    INCREASE_SCORE(POINTS_COMBINED_CUE_ROPE)
    UNSET_ITEM_FLAGS(e_ITEM_Rope,ITEM_FLAG_ATTACHED)                   ; If it was attached to anything, it's not anymore
#ifdef LANGUAGE_FR
    INFO_MESSAGE("La queue ne va pas résister...")
    INFO_MESSAGE("Mais elle peut casser des trucs !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kølla er ikke sterk nok...")
    INFO_MESSAGE("...men den kan knuse ting!")
#else
    INFO_MESSAGE("The cue is not strong enough...")
    INFO_MESSAGE("But it could break things!")
#endif
    WAIT_KEYPRESS
    END_AND_REFRESH
.)


; This operation is only doable if both the window and rope are available
_CombineWindowWithRope
.( 
    ; Is the window open?
    JUMP_IF_FALSE(window_open,CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED))
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("La fenêtre est toujours fermée!")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Bør nok åpne vinduet først!")
#else
        ERROR_MESSAGE("Should open the window first!")
#endif
        JUMP(end)
window_open

    ; In order to combine the window and the rope, first she needs to have been given the rope
    JUMP_IF_TRUE(rope_in_the_room,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_IMMOVABLE))
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Peut-être lui passer la corde?")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Kanskje gi henne tauet først?")
#else
        ERROR_MESSAGE("Maybe give her the rope first?")
#endif       
        JUMP(end)
rope_in_the_room

    ; Is the window broken?
    JUMP_IF_TRUE(window_broken,CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_DISABLED))
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Peut-être casser un carreau ?")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Kanskje knuse vinduet først?")
#else
        ERROR_MESSAGE("Maybe break the window first?")
#endif       
        JUMP(end)
window_broken

    ; Is the rope attached?
    JUMP_IF_FALSE(rope_not_attached,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Elle est déjà attachée!")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Det er allerede festet!")
#else
        ERROR_MESSAGE("It's already attached!")
#endif       
        JUMP(end)
rope_not_attached

    ; Everything is good!
    ; We can attach the rope!
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Attachons la corde")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("La oss feste tauet")
#else
    INFO_MESSAGE("Let's attach the rope")
#endif
    SET_ITEM_FLAGS(e_ITEM_Rope,ITEM_FLAG_ATTACHED)     ; The rope is now attached to the window
    INCREASE_SCORE(POINTS_WINDOW_ROPE)
#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"une _corde qui pend de la fenêtre")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"et _tau hengende fra vinduet")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"a _rope hanging from the window")
#endif

    ; Now we can show that to the player
    GOSUB(_ShowTopWindowOpen)

    FADE_BUFFER 
    WAIT(50*2)

    ; Now we show the outside view with the girl at the window
    GOSUB(_ShowGirlAtTheWindow)

end    
    WAIT(50*2)
    END_AND_REFRESH
.)


_ShowTopWindowOpen
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_TOP_WINDOW_CLOSED)
    ; Then add the sprites showing the window being opened
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,31,84)                    ; Draw the top part of the open window
            _IMAGE(0,0)
            _BUFFER(0,0)
    BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,9,28)                     ; Draw the bottom part of the open window
            _IMAGE(0,84)
            _BUFFER(0,84)

    ; Then add the patch showing the broken window
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_DISABLED),window_broken)
        BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,5,25)                 ; Draw the broken tile on the right window pane
            _IMAGE(9,84)
            _BUFFER(21,49)
    ENDIF(window_broken)

    ; Then add the sprite showing the attached rope if it's both attached and at the proper location (either the tiledpatio outside or the panic room)
    JUMP_IF_FALSE(rope_not_attached,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
    JUMP_IF_TRUE(rope_on_window,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_TILEDPATIO))
    JUMP_IF_FALSE(rope_not_attached,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_PANIC_ROOM_DOOR))
rope_on_window    
        BLIT_BLOCK(LOADER_SPRITE_TOP_WINDOW,4,33)                     ; Draw the rope attached to the window frame
            _IMAGE(14,84)
            _BUFFER(19,59)
rope_not_attached            

    FADE_BUFFER

    WAIT(50*2)
    RETURN
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
    VALUE_MAPPING(e_ITEM_RoughPlan          , _ReadRoughPlan)
    VALUE_MAPPING(e_ITEM_RoadSign           , _ReadRoadSign)
    VALUE_MAPPING(e_ITEM_Tombstone          , _ReadTombstone)
    VALUE_MAPPING(e_ITEM_Graffiti           , _ReadGraffiti)
    VALUE_MAPPING(e_ITEM_Invoice            , _ReadInvoice)
    VALUE_MAPPING(e_ITEM_DuneBook           , _ReadDuneBook)
#ifdef PRODUCT_TYPE_GAME_DEMO
    VALUE_MAPPING(e_ITEM_DemoMessage        , _ReadDemoMessage)
#endif // PRODUCT_TYPE_GAME_DEMO
    VALUE_MAPPING(255                       , _ErrorCannotRead)             ; Default option


#ifdef PRODUCT_TYPE_GAME_DEMO
_InspectDemoMessage
_UseDemoMessage
_ReadDemoMessage
.(
    SET_CUT_SCENE(1)
    STOP_CLOCK
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Vous avez atteint la fin de la démo !")
    INFO_MESSAGE("L'étage est évidement visitable...")
    INFO_MESSAGE("...dans la version complete du jeu.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Du har nådd slutten av demoen!")
    INFO_MESSAGE("Øverste etasje er selvfølgelig...")
    INFO_MESSAGE("...tilgjengelig i fullversjonen.")
#else
    INFO_MESSAGE("You've reached the end of this demo!")
    INFO_MESSAGE("The top floor is obviously...")
    INFO_MESSAGE("...accessible in the full game.")
#endif

    DISPLAY_IMAGE(LOADER_PICTURE_LOCATIONS_START+e_LOC_UP_STAIRS)
    CLEAR_TEXT_AREA(5)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Si vous voulez découvrir le reste...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Hvis du vil oppdage resten...")
#else
    INFO_MESSAGE("If you want to discover the rest...")
#endif

    DISPLAY_IMAGE(LOADER_PICTURE_LOCATIONS_START+e_LOC_TINY_WC)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("si vous avez un besoin pressant...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("hvis du har presserende behov...")
#else
    INFO_MESSAGE("if you have some urgent needs...")
#endif

    DISPLAY_IMAGE(LOADER_PICTURE_LOCATIONS_START+e_LOC_GUESTBEDROOM)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("voulez faire une sieste relaxante...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("ønsker å ta en avslappende lur...")
#else
    INFO_MESSAGE("want to have a relaxing nap...")
#endif

    DISPLAY_IMAGE(LOADER_PICTURE_LOCATIONS_START+e_LOC_SHOWERROOM)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("ou prendre une douche...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("eller ta en dusj...")
#else
    INFO_MESSAGE("or take a shower...")
#endif

    DISPLAY_IMAGE(LOADER_PICTURE_LOCATIONS_START+e_LOC_BOXROOM)
    CLEAR_TEXT_AREA(2)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("alors tentez le jeu complet !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("så prøv fullversjonen av spillet!")
#else
    INFO_MESSAGE("then consider getting the full game!")
#endif

    DISPLAY_IMAGE(LOADER_PICTURE_DOOR_DIGICODE)
    CLEAR_TEXT_AREA(1)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Réussirez vous à entrer ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Klarer du å komme deg inn?")
#else
    INFO_MESSAGE("Will you find a way in?")
#endif

    DISPLAY_IMAGE(LOADER_PICTURE_ALARM_TRIGGERED)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Pourrez-vous désactiver l'alarme ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Klarer du å deaktivere alarmen?")
#else
    INFO_MESSAGE("Will you silence the alarm?")
#endif

    DISPLAY_IMAGE(LOADER_PICTURE_EXPLOSION)
    CLEAR_TEXT_AREA(1)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Souhaitez-vous tout faire sauter ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kommer du til å sprenge ting?")
#else
    INFO_MESSAGE("Will you blow things up?")
#endif

    DISPLAY_IMAGE(LOADER_PICTURE_SHOOTING_DART)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Allez-vous utiliser des armes ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kommer du til å bruke våpen?")
#else
    INFO_MESSAGE("Will you use weapons?")
#endif

    CLEAR_TEXT_AREA(2)
    DISPLAY_IMAGE(LOADER_PICTURE_TO_BE_CONTINUED)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Voulez-vous élucider l'affaire ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ønsker du å løse saken?")
#else
    INFO_MESSAGE("Do you want to solve the case?")
#endif
    STOP_MUSIC()
    GAME_OVER(e_SCORE_FINISHED_DEMO)        ; The game is now over
    END
.)
#endif // PRODUCT_TYPE_GAME_DEMO


_InspectNewspaper
_ReadNewsPaper
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_NEWSPAPER)   ; Achievement!
    INCREASE_SCORE(POINTS_READ_NEWSPAPER)    
    DISPLAY_IMAGE(LOADER_PICTURE_NEWSPAPER)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il faut que je la trouve vite...")
    INFO_MESSAGE("...j'espère qu'elle va bien !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Jeg må finne henne fort...")
    INFO_MESSAGE("...håper hun har det bra!")
#else
    INFO_MESSAGE("I need to find her. Quickly.")
    INFO_MESSAGE("...I hope she's alright.")
#endif
    WAIT_KEYPRESS    
    END_AND_REFRESH


_InspectHandWrittenNote
_ReadHandWrittenNote
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_NOTE)   ; Achievement!    
    INCREASE_SCORE(POINTS_READ_NOTE)    
    DISPLAY_IMAGE(LOADER_PICTURE_HANDWRITTEN_NOTE)
    GOSUB(_SubCouldComeInHandy)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("...si je peux y accéder !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("...hvis jeg kommer til den!")
#else
    INFO_MESSAGE("...if I can get to it.")
#endif    
    WAIT_KEYPRESS    
    END_AND_REFRESH

_InspectChemistryRecipes
_ReadChemistryRecipes
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_RECIPES)   ; Achievement!    
    INCREASE_SCORE(POINTS_READ_RECIPES)    
    DISPLAY_IMAGE(LOADER_PICTURE_CHEMISTRY_RECIPES)
    GOSUB(_SubCouldComeInHandy)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("...il faut trouver les composants.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("...bare finne materialene.")
#else
    INFO_MESSAGE("...just need the ingredients.")
#endif    
    WAIT_KEYPRESS    
    END_AND_REFRESH


_OpenChemistryBook
_UseChemistryBook
_ReadChemistryBook
.(
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_THE_BOOK)   ; Achievement!
    INCREASE_SCORE(POINTS_READ_BOOK)    
    DISPLAY_IMAGE(LOADER_PICTURE_SCIENCE_BOOK)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("J'y comprends rien du tout.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Skjønner ikke et kvekk...")
#else
    INFO_MESSAGE("Can't make head nor tail of this.")
#endif

    // If the recipes were not yet found, they now appear at the current location
    JUMP_IF_FALSE(recipe_already_found,CHECK_ITEM_LOCATION(e_ITEM_ChemistryRecipes,e_LOC_NONE))
        SET_ITEM_LOCATION(e_ITEM_ChemistryRecipes,e_LOC_CURRENT)
        GOSUB(_SubFoundSomething)
recipe_already_found
    END_AND_REFRESH
.)


; Called from reading the handwritten note and the chemistry recipes
_SubCouldComeInHandy
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ca pourrait servir...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det kan være nyttig...")
#else
    INFO_MESSAGE("That could come in handy...")
#endif
    RETURN
.)

; Called from reading the chemistry book, searching the thug and searching the safe
_SubFoundSomething
.(
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Tiens, qu'est-ce qu'on a là ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Hva har vi her da?")
#else
    INFO_MESSAGE("Hello, what have we here?")
#endif
    STOP_MUSIC()
    RETURN
.)

_InspectInvoice
_ReadInvoice
.(
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_INVOICE)                                       ; And get an achievement for that action    
    INCREASE_SCORE(POINTS_READ_INVOICE)    
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Deux mois à travers l'Europe...")
    INFO_MESSAGE("...ça doit être sympa.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("To måneder i Europa...")
    INFO_MESSAGE("...ikke dårlig.")
#else
    INFO_MESSAGE("Two months touring Europe...")
    INFO_MESSAGE("...must be nice.")
#endif
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
    VALUE_MAPPING(e_ITEM_LargeDove          , _InspectDove)
    VALUE_MAPPING(e_ITEM_ChemistryBook      , _InspectChemistryBook)
    VALUE_MAPPING(e_ITEM_ChemistryRecipes   , _InspectChemistryRecipes)
    VALUE_MAPPING(e_ITEM_HandheldGame       , _InspectGame)
    VALUE_MAPPING(e_ITEM_Fridge             , _InspectFridgeDoor)
    VALUE_MAPPING(e_ITEM_Medicinecabinet    , _InspectMedicineCabinet)
    VALUE_MAPPING(e_ITEM_PlasticBag         , _InspectPlasticBag)
    VALUE_MAPPING(e_ITEM_CellarWindow       , _InspectCellarWindow)
    VALUE_MAPPING(e_ITEM_PanicRoomWindow    , _InspectPanicRoomWindow)
    VALUE_MAPPING(e_ITEM_AlarmPanel         , _InspectPanel)
    VALUE_MAPPING(e_ITEM_MixTape            , _InspectMixTape)
    VALUE_MAPPING(e_ITEM_HeavySafe          , _InspectSafe)
    VALUE_MAPPING(e_ITEM_Thug               , _InspectThug)
    VALUE_MAPPING(e_ITEM_Newspaper          , _InspectNewspaper)
    VALUE_MAPPING(e_ITEM_SecurityDoor       , _InspectPanicRoomDoor)
    VALUE_MAPPING(e_ITEM_ProtectionSuit     , _InspectProtectionSuit)
    VALUE_MAPPING(e_ITEM_HoleInDoor         , _InspectHoleInDoor)
    VALUE_MAPPING(e_ITEM_RoughPlan          , _InspectRoughPlan)
    VALUE_MAPPING(e_ITEM_Car                , _InspectCar)
    VALUE_MAPPING(e_ITEM_CarBoot            , _InspectCarBoot)
    VALUE_MAPPING(e_ITEM_CarDoor            , _InspectCarDoor)
    VALUE_MAPPING(e_ITEM_CarTank            , _InspectCarTank)
    VALUE_MAPPING(e_ITEM_Petrol             , _InspectPetrol)
    VALUE_MAPPING(e_ITEM_Dog                , _InspectDog)
    VALUE_MAPPING(e_ITEM_Graffiti           , _InspectGraffiti)
    VALUE_MAPPING(e_ITEM_Church             , _InspectChurch)
    VALUE_MAPPING(e_ITEM_Well               , _InspectWell)
    VALUE_MAPPING(e_ITEM_RoadSign           , _InspectRoadSign)
    VALUE_MAPPING(e_ITEM_Trashcan           , _InspectTrashCan)
    VALUE_MAPPING(e_ITEM_Tombstone          , _InspectTombstone)
    VALUE_MAPPING(e_ITEM_FishPond           , _InspectFishPond)
    VALUE_MAPPING(e_ITEM_Apple              , _InspectApples)
    VALUE_MAPPING(e_ITEM_SilverKnife        , _InspectKnife)
    VALUE_MAPPING(e_ITEM_FancyStones        , _InspectFancyStones)
    VALUE_MAPPING(e_ITEM_SnookerCue         , _InspectCue)
    VALUE_MAPPING(e_ITEM_PowderMix          , _InspectPowderMix)
    VALUE_MAPPING(e_ITEM_GunPowder          , _InspectGunPowder)
    VALUE_MAPPING(e_ITEM_SedativePills      , _InspectPills)
    VALUE_MAPPING(e_ITEM_Meat               , _InspectMeat)
    VALUE_MAPPING(e_ITEM_Tree               , _InspectTree)
    VALUE_MAPPING(e_ITEM_Pit                , _InspectPit)
    VALUE_MAPPING(e_ITEM_Heap               , _InspectHeap)
    VALUE_MAPPING(e_ITEM_NormalWindow       , _InspectNormalWindow)
    VALUE_MAPPING(e_ITEM_AlarmIndicator     , _InspectAlarmIndicator)
    VALUE_MAPPING(e_ITEM_Invoice            , _InspectInvoice)
    VALUE_MAPPING(e_ITEM_Computer           , _InspectComputer)
    VALUE_MAPPING(e_ITEM_Television         , _InspectTelevision)
    VALUE_MAPPING(e_ITEM_GameConsole        , _InspectGameConsole)
    VALUE_MAPPING(e_ITEM_Oric               , _InspectOricOmputer)
    VALUE_MAPPING(e_ITEM_SmallKey           , _InspectKey)
    VALUE_MAPPING(e_ITEM_TobaccoTin         , _InspectTin)
    VALUE_MAPPING(e_ITEM_HandWrittenNote    , _InspectHandWrittenNote)
    VALUE_MAPPING(e_ITEM_FrontDoor          , _InspectFrontDoor)
    VALUE_MAPPING(e_ITEM_Fuse               , _InspectFuse)
    VALUE_MAPPING(e_ITEM_ToiletRoll         , _InspectToiletRoll)
    VALUE_MAPPING(e_ITEM_Bucket             , _InspectBucket)
    VALUE_MAPPING(e_ITEM_Rope               , _InspectRope)
    VALUE_MAPPING(e_ITEM_Ladder             , _InspectLadder)
    VALUE_MAPPING(e_ITEM_BoxOfMatches       , _InspectMatches)
    VALUE_MAPPING(e_ITEM_CardboardBox       , _InspectCardboardBox)
    VALUE_MAPPING(e_ITEM_Fish               , _InspectFish)
    VALUE_MAPPING(e_ITEM_Water              , _InspectWater)
    VALUE_MAPPING(e_ITEM_Hose               , _InspectHose)
    VALUE_MAPPING(e_ITEM_Bread              , _InspectBread)
    VALUE_MAPPING(e_ITEM_Adhesive           , _InspectAdhesive)
    VALUE_MAPPING(e_ITEM_Curtain            , _InspectCurtain)
    VALUE_MAPPING(e_ITEM_Saltpetre          , _InspectSaltpetre)
    VALUE_MAPPING(e_ITEM_Sulphur            , _InspectSulphur)
    VALUE_MAPPING(e_ITEM_Net                , _InspectNet)
    VALUE_MAPPING(e_ITEM_GunCabinet         , _InspectGunCabinet)
    VALUE_MAPPING(e_ITEM_Pistol             , _InspectPistol)
    VALUE_MAPPING(e_ITEM_DartGun            , _InspectDartGun)
    VALUE_MAPPING(e_ITEM_Clay               , _InspectClay)
    VALUE_MAPPING(e_ITEM_AlarmSwitch        , _InspectSwitch)
    VALUE_MAPPING(e_ITEM_YoungGirl          , _InspectGirl)
    VALUE_MAPPING(e_ITEM_BlackTape          , _InspectBlackTape)
    VALUE_MAPPING(e_ITEM_Acid               , _InspectAcid)
    VALUE_MAPPING(e_ITEM_Bomb               , _InspectBomb)
    VALUE_MAPPING(e_ITEM_TVCabinet          , _InspectTVCabinet)
    VALUE_MAPPING(e_ITEM_Batteries          , _InspectBatteries)
    VALUE_MAPPING(e_ITEM_Drawer             , _InspectDrawer)
    VALUE_MAPPING(e_ITEM_DuneBook           , _InspectDuneBook)
    VALUE_MAPPING(e_ITEM_MortarAndPestle    , _InspectMortar)
#ifdef PRODUCT_TYPE_GAME_DEMO
    VALUE_MAPPING(e_ITEM_DemoMessage        , _InspectDemoMessage)
#endif // PRODUCT_TYPE_GAME_DEMO
    VALUE_MAPPING(255                       , _MessageNothingSpecial)  ; Default option


_UseRoughPlan
_ReadRoughPlan
_InspectRoughPlan
    GOSUB(_ShowRoughPlan)
    WAIT_KEYPRESS    
    END_AND_REFRESH
_ShowRoughPlan
.(
    BLIT_BLOCK(LOADER_SPRITE_ROUGH_PLAN,40,128)                     ; Draw the map of the location with the instructions
            _IMAGE(0,0)
            _BUFFER(0,0)      
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    FADE_BUFFER
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Je devrai revenir au marché...")
    INFO_MESSAGE("...quand j'en aurai terminé")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Jeg må tilbake til markedet...")
    INFO_MESSAGE("...når jeg er ferdig")
#else
    INFO_MESSAGE("I need to get back to the market...")
    INFO_MESSAGE("...once this is over.")
#endif
    STOP_MUSIC()
    RETURN
.)


_InspectMap
    INCREASE_SCORE(POINTS_INSPECT_MAP)    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_EXAMINED_THE_MAP)
    DISPLAY_IMAGE(LOADER_PICTURE_UK_MAP)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Bon à savoir où je suis.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Greit å vite hvor jeg er.")
#else
    INFO_MESSAGE("Good to know where I am.")
#endif
    WAIT_KEYPRESS
    END_AND_REFRESH


_InspectGame
.(
    INCREASE_SCORE(POINTS_INSPECT_GAME)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_EXAMINED_THE_GAME)
    GOSUB(_ShowHandheldGame)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_HandheldGame,ITEM_FLAG_TRANSFORMED),no_batteries)    ; Have the batteries been installed?
        // Non functional game
#ifdef LANGUAGE_FR
        INFO_MESSAGE("On dirait qu'il n'y a pas de piles.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Ser ut som det mangler batterier.")
#else
        INFO_MESSAGE("Looks like it's out of batteries.")
#endif
    ENDIF(no_batteries)

    WAIT_KEYPRESS
    END_AND_REFRESH
.)


_TakeHandheldGame
.(
    DO_ONCE(take_game)
        GOSUB(_ShowHandheldGame)
    ENDDO(take_game)
    JUMP(_TakeCommon)
.)


_ShowHandheldGame
.(
    DISPLAY_IMAGE(LOADER_PICTURE_DONKEY_KONG_TOP)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Les gamins en sont tous fous.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ungene er helt ville etter disse.")
#else
    INFO_MESSAGE("Kids are going crazy for these.")
#endif
    WAIT_KEYPRESS
    RETURN
.)

 _InspectFuse
#ifdef LANGUAGE_FR
    INFO_MESSAGE("A combiner avec un explosif...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kombinere med noe eksplosivt...")
#else
    INFO_MESSAGE("Pair with something explosive...")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectBomb
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Pas mal pour une bombe maison.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ikke verst for en hjemmelaget bombe.")
#else
    INFO_MESSAGE("Not bad for a homemade bomb.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


 _InspectToiletRoll
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Long, résistant, et super absorbant")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Lang, solid og ekstra absorberende")
#else
    INFO_MESSAGE("Long, sturdy, and extra absorbent")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectMatches
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Utile pour allumer un feu")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kan starte en brann med det.")
#else
    INFO_MESSAGE("Could start a fire with that.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectLadder
_InspectRope
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Pratique pour grimper ou descendre")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kan klatre opp eller ned med den.")
#else
    INFO_MESSAGE("Could climb up or down with it.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectDove
.(
    ; If the dove is in the inventory or in the net, then inspect it shows some other message.
    JUMP_IF_FALSE(dove_not_happy,CHECK_ITEM_FLAG(e_ITEM_LargeDove,ITEM_FLAG_IMMOVABLE))
    JUMP_IF_TRUE(dove_eating,CHECK_ITEM_LOCATION(e_ITEM_Bread,e_LOC_WOODEDAVENUE))
    JUMP_IF_TRUE(dove_eating,CHECK_ITEM_LOCATION(e_ITEM_Apple,e_LOC_WOODEDAVENUE))

    ; Else it is happy chirping around
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Elle roucoule sur une branche haute")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Den kvitrer høyt oppe på en gren")
#else
    INFO_MESSAGE("It's chirping high up on a branch")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH

dove_eating
    GOSUB(_SubDoveEating)
    END_AND_REFRESH

dove_not_happy
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Elle bouge et essaye de s'échapper")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Den er misfornøyd og prøver å rømme")
#else
    INFO_MESSAGE("It's not happy and tries to escape")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)



_InspectFish
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il semble aimer son bassin")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Den ser glad ut mens den svømmer")
#else
    INFO_MESSAGE("It seems happy swimming around")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_UseWater
_InspectWater
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Elle est propre, fraiche et liquide")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det er rent, friskt og flytende")
#else
    INFO_MESSAGE("It's clean, fresh, and liquid")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectHose
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Sert à transférer les liquides")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Beregnet på å flytte væsker")
#else
    INFO_MESSAGE("Designed to move liquids efficiently")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectAdhesive
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ca maintient les choses en place")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Beregnet på å holde ting på plass")
#else
    INFO_MESSAGE("Designed to keep things in place")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectBlackTape
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Probablement possible de l'enlever")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det bør være mulig å fjerne den")
#else
    INFO_MESSAGE("It should be possible to remove it")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectSaltpetre
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Frais, amer au goût. Du salpêtre.")
    SET_ITEM_DESCRIPTION(e_ITEM_Saltpetre,"du$_salpêtre")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kjølig, bitter smak. Salpeter.")
    SET_ITEM_DESCRIPTION(e_ITEM_Saltpetre,"noe$_salpeter")
#else
    INFO_MESSAGE("Feels cool, bitter taste. Saltpetre.")
    SET_ITEM_DESCRIPTION(e_ITEM_Saltpetre,"some$_saltpetre")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectSulphur
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Du soufre. Ce jaune est typique.")
    SET_ITEM_DESCRIPTION(e_ITEM_Sulphur,"du$_soufre")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Svovel. Umulig å ta feil av gult.")
    SET_ITEM_DESCRIPTION(e_ITEM_Sulphur,"noe$_svovel")
#else
    INFO_MESSAGE("Sulphur. Can't mistake that yellow.")
    SET_ITEM_DESCRIPTION(e_ITEM_Sulphur,"some$_sulphur")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectBread
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Rassis. Devrait bien s'émietter.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Tørt. Bør smuldre fint.")
#else
    INFO_MESSAGE("Stale. Should crumble nicely.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectCurtain
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un rideau ici ? C'est étrange.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Et gardin her? Det er rart.")
#else
    INFO_MESSAGE("A curtain here? That's odd.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectNet
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Peut attraper des balles, etc.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kan fange baller, blant annet")
#else
    INFO_MESSAGE("Can catch balls, among other things")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_InspectKey
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Une étiquette indique 'Alarme'")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Den har en etikett: 'Alarm'")
#else
    INFO_MESSAGE("It has a label that says 'Alarm'")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH



_InspectComputer
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un IBM PC. On ne rigole pas ici.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("En IBM PC. Her er det alvor.")
#else
    INFO_MESSAGE("An IBM PC. Business means business.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH    
.)


_InspectTelevision
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Énorme. A dû coûter une fortune.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Enorm. Må ha kostet en formue.")
#else
    INFO_MESSAGE("Massive. Must've cost a fortune.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectGameConsole
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("ColecoVision. Pas facile à trouver.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("ColecoVision. Ikke lett å få tak i.")
#else
    INFO_MESSAGE("ColecoVision. Not easy to get here.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectTVCabinet
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il y a peut-être quelque chose.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kanskje noe der inne.")
#else
    INFO_MESSAGE("Might be something in there.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectBatteries
.(
    DISPLAY_IMAGE(LOADER_PICTURE_BATTERIES)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Idéal pour montres ou petit jeux.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Bør passe de fleste småting.")
#else
    INFO_MESSAGE("Should fit most small gadgets.")
#endif
    WAIT_KEYPRESS
    END_AND_REFRESH
.)


_InspectDrawer
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Table de chevet. Quoi dedans ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Et nattbord. Noe inni?")
#else
    INFO_MESSAGE("A plain nightstand. Anything inside?")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectKnife
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Plus tranchant qu'il n'y parait.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Skarpere enn den ser ut.")
#else
    INFO_MESSAGE("Sharper than it looks.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectOricOmputer
.(
    DISPLAY_IMAGE(LOADER_PICTURE_ORIC_COMPUTER)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un Oric 1. Tout neuf on dirait.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("En Oric 1. Splitter ny ser det ut.")
#else
    INFO_MESSAGE("An Oric 1. Brand new by the looks.")
#endif
    WAIT_KEYPRESS
    END_AND_REFRESH
.)


_InspectChemistryBook
    INCREASE_SCORE(POINTS_INSPECT_BOOK)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un livre épais avec des signets")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("En tykk bok med noen bokmerker")
#else
    INFO_MESSAGE("A thick book with some bookmarks")
#endif
    WAIT_KEYPRESS
    JUMP(_ReadChemistryBook)


_InspectApples
.(
    // Are the apples cut?
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Apple,ITEM_FLAG_TRANSFORMED),apple_cut)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Elles sont en morceaux")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("De er hakket i biter")
#else
        INFO_MESSAGE("They're chopped to bits")
#endif
    ELSE(apple_cut,apple_not_cut)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Elles semblent délicieuses !")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("De ser faktisk appetittlige ut!")
#else
        INFO_MESSAGE("They do look tasty!")
#endif
    ENDIF(apple_not_cut)
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_SubResetApplesLocation
.(
    SET_ITEM_LOCATION(e_ITEM_Apple,e_LOC_ORCHARD)     ; If we eat the apples, they are back to the orchard
    UNSET_ITEM_FLAGS(e_ITEM_Apple,ITEM_FLAG_TRANSFORMED)
+_gTextItemApple = *+2
#ifdef LANGUAGE_FR                                    ; Rename the apple back to itself
    SET_ITEM_DESCRIPTION(e_ITEM_Apple,"quelques$_pommes")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Apple,"noen$_epler")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Apple,"a few$_apples")
#endif
    RETURN
.)


_InspectFancyStones
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Feng shui de poche")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Lommeformat feng shui")
#else
    INFO_MESSAGE("Pocket sized feng shui")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectCue
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Bien équilibrée.")
    INFO_MESSAGE("Pourrait casser plus que des billes.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("God balanse.")
    INFO_MESSAGE("Kan knuse mer enn bare baller.")
#else
    INFO_MESSAGE("Nicely weighted.")
    INFO_MESSAGE("Could break more than just balls.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectPowderMix
.(
    DISPLAY_IMAGE(LOADER_PICTURE_ROUGH_POWDER_MIX)
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Hmm, bien trop grumeleux...")
    INFO_MESSAGE("Il faut que je broie ça plus fin.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Hmm, altfor klumpete...")
    INFO_MESSAGE("Jeg må male dette finere.")
#else
    INFO_MESSAGE("Hmm, way too lumpy...")
    INFO_MESSAGE("I need to grind this finer.")
#endif
    STOP_MUSIC()
    WAIT_KEYPRESS
    END_AND_REFRESH
.)


_InspectGunPowder
.(
    DISPLAY_IMAGE(LOADER_PICTURE_MORTAR_AND_PESTLE)
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("De la poudre à canon.")
    INFO_MESSAGE("Il me faut un récipient solide.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Krutt, intet mindre.")
    INFO_MESSAGE("Trenger noe solid å ha det i.")
#else
    INFO_MESSAGE("That's gunpowder alright.")
    INFO_MESSAGE("Need something sturdy to hold it.")
#endif
    STOP_MUSIC()
    WAIT_KEYPRESS
    END_AND_REFRESH
.)


_InspectPills
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("De quoi assommer quelqu'un.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kan slå ut noen med disse.")
#else
    INFO_MESSAGE("Could knock someone out with these.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectMeat
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un chien adorerait ce morceau !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("En hund ville elsket dette!")
#else
    INFO_MESSAGE("A dog would love this juicy morcel!")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)



_InspectTree
.(
    GOSUB(_SubInspectAttachment)
    END_AND_PARTIAL_REFRESH
.)


_InspectPit
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Pas sûr que je puisse remonter...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ikke sikkert jeg kommer opp igjen...")
#else
    INFO_MESSAGE("No getting back up without help.")
#endif
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Corde ou échelle nécessaire !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Tau eller stige er nødvendig!")
#else
    INFO_MESSAGE("Rope or ladder necessary!")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectHeap
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ca vient du trou !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Dette var inne i gropen!")
#else
    INFO_MESSAGE("This used to be inside the pit!")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)



_InspectFridgeDoor
.(
    INCREASE_SCORE(POINTS_INSPECT_FRIDGE)    
    DISPLAY_IMAGE(LOADER_PICTURE_FRIDGE_DOOR)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Une famille heureuse, on dirait...")
    INFO_MESSAGE("...où sont-ils passés ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ser ut som en lykkelig familie...")
    INFO_MESSAGE("...hvor er de nå mon tro?")
#else
    INFO_MESSAGE("Happy family, by the looks of it.")
    INFO_MESSAGE("...wonder where they've gone.")
#endif
    WAIT_KEYPRESS    
    END_AND_REFRESH
.)


_InspectMedicineCabinet
.(
    INCREASE_SCORE(POINTS_INSPECT_CABINET)    
    ; Is the medicine cabinet open?
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED),else)
        DISPLAY_IMAGE(LOADER_PICTURE_MEDICINE_CABINET_OPEN)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Des calmants. Ca peut servir.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Beroligende. Kan bli nyttig.")
#else
        INFO_MESSAGE("Sedatives. Could come in handy.")
#endif
    ELSE(else,open)
        DISPLAY_IMAGE(LOADER_PICTURE_MEDICINE_CABINET)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il y a peut-être quelque chose.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Kanskje noe nyttig der inne.")
#else
        INFO_MESSAGE("Might be something useful in there.")
#endif
    ENDIF(open)
    WAIT_KEYPRESS    
    END_AND_REFRESH
.)


_InspectGunCabinet
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Je vois du matériel de chasse")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Jeg ser jakteutstyr")
#else
    INFO_MESSAGE("I can see hunting equipment")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectGirl
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Elle semble indemne et soulagée")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Hun ser uskadd og lettet ut")
#else
    INFO_MESSAGE("She seems unharmed and relieved")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectPistol
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("C'est un gros calibre")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ganske stort kaliber")
#else
    INFO_MESSAGE("Quite a large caliber")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectDartGun
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ça pourrait endormir un éléphant !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kan bedøve en elefant!")
#else
    INFO_MESSAGE("Could knock out an elephant!")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectClay
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_TRANSFORMED),wet)    ; Is the clay wet?
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Elle est malléable maintenant")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Den er formbar nå")
#else
        INFO_MESSAGE("It's malleable now")
#endif
    ELSE(wet,dry)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il faudrait la réhydrater")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Den bør rehydreres")
#else
        INFO_MESSAGE("It should be rehydrated")
#endif
    ENDIF(dry)
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectSwitch
_InspectPanel
.(    
    ; Was the tape removed from the window?
    IF_FALSE(CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER),tape_removed)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Ca clignote et ca bipe")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Det blinker og piper")
#else
        INFO_MESSAGE("It blinks and beeps")
#endif
        END_AND_REFRESH
    ENDIF(tape_removed)

    INCREASE_SCORE(POINTS_INSPECT_PANEL)
    ; Is the alarm panel open?
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED),else)
        DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_ALARM_PANEL)                ; Load the image with the panel closed
        BLIT_BLOCK(LOADER_SPRITE_ALARM_PANEL,22,69)                     ; Draw the open panel overlayed on top
                _IMAGE(0,0)
                _BUFFER(14,47)
        FADE_BUFFER
#ifdef LANGUAGE_FR
        INFO_MESSAGE("De quoi neutraliser l'alarme.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Burde fikse den alarmen.")
#else
        INFO_MESSAGE("Should sort out that alarm.")
#endif
    ELSE(else,open)
        DISPLAY_IMAGE(LOADER_PICTURE_ALARM_PANEL)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_LOCKED),locked)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Il y a un trou pour une petite clef")
#elif defined(LANGUAGE_NO)
            INFO_MESSAGE("Det er et hull for en liten nøkkel")
#else
            INFO_MESSAGE("There's a hole for a small key")
#endif
        ELSE(locked,unlocked)
            GOSUB(_SubClosedButNotLocked_Elle)
        ENDIF(unlocked)
    ENDIF(open)
    WAIT_KEYPRESS    
    END_AND_REFRESH
.)


_InspectCellarWindow
.(
    INCREASE_SCORE(POINTS_INSPECT_CELLAR_WINDOW)
    .(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_CELLAR_WINDOW),cellar_on_lader)
        ; Inspecting the window in the cellar from on top the ladder
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER),see_garden)
            GOSUB(_SubCanSeeGardenOutside)
        ELSE(see_garden,see_black_tape)
            GOSUB(_SubBlackTapeOnWindow)
        ENDIF(see_black_tape)
        WAIT_KEYPRESS
        END_AND_PARTIAL_REFRESH
    ENDIF(cellar_on_lader)
    .)

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM),elsecellar)
    .(
        ; Inspecting the window in the cellar
        IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_CellarWindow,ITEM_FLAG_CLOSED),else)
            DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_LOCATIONS_CELLAR_WINDOW_INSIDE_CLEARED)
        ELSE(else,open)
            DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_LOCATIONS_CELLAR_WINDOW_INSIDE_DARKENED)
        ENDIF(open)
        ; Is the ladder in place?
        JUMP_IF_FALSE(no_ladder,CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_DARKCELLARROOM))  
            BLIT_BLOCK(LOADER_SPRITE_ITEMS,12,28)                     ; Draw the ladder
                    _IMAGE(7,100)
                    _BUFFER(14,101)
no_ladder
        FADE_BUFFER      ; Make sure everything appears on the screen
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Trop haut pour moi...")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Får ikke tak i det...")
#else
        INFO_MESSAGE("Can't reach that...")
#endif
    .)
    ELSE(elsecellar,cellar)
    .(
        ; Inspecting the window in the garden (or other places)
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER),else)
            DISPLAY_IMAGE(LOADER_PICTURE_CELLAR_WINDOW_OUTSIDE_CLEARED)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Je peux voir la cave")
#elif defined(LANGUAGE_NO)
            INFO_MESSAGE("Jeg kan se kjelleren")
#else
            INFO_MESSAGE("I can see the cellar")
#endif
        ELSE(else,open)
            DISPLAY_IMAGE(LOADER_PICTURE_CELLAR_WINDOW_OUTSIDE_DARKENED)
            GOSUB(_SubBlackTapeOnWindow)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Impossible à décoller d'ici.")
#elif defined(LANGUAGE_NO)
            INFO_MESSAGE("Får ikke løsnet det herfra.")
#else
            INFO_MESSAGE("Can't peel it off from here.")
#endif
        ENDIF(open)
    .)
    ENDIF(cellar)
    WAIT_KEYPRESS
    END_AND_REFRESH
.)


_SubBlackTapeOnWindow
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Scotché de l'intérieur.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Teipt fra innsiden.")
#else
    INFO_MESSAGE("Taped from the inside.")
#endif
    RETURN
.)


_InspectPanicRoomWindow
.(  
    INCREASE_SCORE(POINTS_INSPECT_PANIC_ROOM_WINDOW)
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room_door)      ; Are we trying to look at the window from the hole in the door?
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED),window_closed)
            DISPLAY_IMAGE(LOADER_PICTURE_TOP_WINDOW_CLOSED)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Contacts d'alarme. Noté.")
#elif defined(LANGUAGE_NO)
            INFO_MESSAGE("Alarmkontakter. Notert.")
#else
            INFO_MESSAGE("Alarm contacts. Noted.")
#endif
        ELSE(window_closed,window_open)
            GOSUB(_ShowTopWindowOpen)
            IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_HOSTAGE_ROOM),girl_in_room)
#ifdef LANGUAGE_FR
                INFO_MESSAGE("Le cadre de la fenêtre est solide...")
#elif defined(LANGUAGE_NO)
                INFO_MESSAGE("Vindusrammen er solid...")
#else
                INFO_MESSAGE("The window frame is strong...")
#endif
                IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_DISABLED),window_broken)
                    GOSUB(_SubInspectAttachment)
                ELSE(window_broken,window_not_broken)
#ifdef LANGUAGE_FR
                    INFO_MESSAGE("Mais les carreaux posent problème !")
#elif defined(LANGUAGE_NO)
                    INFO_MESSAGE("Men glassrutene er i veien!")
#else
                    INFO_MESSAGE("But the glass panes are in the way!")
#endif
                ENDIF(window_not_broken)
            ENDIF(window_open)
            WAIT_KEYPRESS    
        ELSE(girl_in_room,room_empty)
            GOSUB(_SubPrintEmptyRoomMessage)
        ENDIF(room_empty)
    ELSE(panic_room_door,else)                                                 ; Or are we on the tiled patio looking at the window from below?
        GOSUB(_ShowGirlAtTheWindow)
    ENDIF(else)
    END_AND_REFRESH
.)


; This is called both when inspecting the tree or the window with a rope attached to it
_SubInspectAttachment
.(
    ; We only show the rope if it's attached and in the hostage room so we don't allow going down if the rope is attached somewhere else
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_CURRENT),rope_attached)
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED),rope_attached)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il n'y a plus qu'à descendre !")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Trygt å klatre ned nå!")
#else
        INFO_MESSAGE("Should be safe to climb down now!")
#endif
    ELSE(rope_attached,rope_not_attached)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Y attacher une corde serait facile.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Enkelt å feste et tau her.")
#else
        INFO_MESSAGE("Could easily attach a rope to it.")
#endif
    ENDIF(rope_not_attached)
    WAIT_KEYPRESS
    RETURN
.)


_InspectNormalWindow
.(
    // Generic alarm sticker message
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il y a un signe d'avertissement")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det er et advarselsklistremerke")
#else
    INFO_MESSAGE("There is a warning sticker")
#endif

    // Then what we see through the window
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_TENNISCOURT),tennis_court)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Je peux voir un salon confortable")
        INFO_MESSAGE("Il y a aussi une salle à manger")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Jeg kan se en koselig stue")
        INFO_MESSAGE("Det er også en spisestue")
#else
        INFO_MESSAGE("I can see a comfortable lounge")
        INFO_MESSAGE("There's also a dining room")
#endif
tennis_court

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_FISHPND),fish_pond)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Je peux voir une salle de jeux")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Jeg kan se et spillerom")
#else
        INFO_MESSAGE("I can see a game room")
#endif
fish_pond

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_STUDY_ROOM),study_room)
        GOSUB(_SubCanSeeGardenOutside)
study_room

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_GAMESROOM),games_room)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Je vois le bac à poissons dehors")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Jeg kan se fiskedammen utenfor")
#else
        INFO_MESSAGE("I can see the fish pond outside")
#endif
games_room

    JUMP_IF_TRUE(lounge,CHECK_PLAYER_LOCATION(e_LOC_LOUNGE))
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_DININGROOM),dining_room)
lounge    
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Je vois le court de tennis dehors")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Jeg kan se tennisbanen utenfor")
#else
        INFO_MESSAGE("I can see the tennis court outside")
#endif
dining_room

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_KITCHEN),kitchen)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Je vois le passage arrière dehors")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Jeg kan se bakgangen utenfor")
#else
        INFO_MESSAGE("I can see the back wall outside")
#endif
kitchen

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_UP_STAIRS),up_stairs)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Je peux voir le patio dehors")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Jeg kan se terrassen utenfor")
#else
        INFO_MESSAGE("I can see the patio outside")
#endif
up_stairs
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_SubCanSeeGardenOutside
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Je peux voir le potager dehors")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Jeg kan se hagen utenfor")
#else
    INFO_MESSAGE("I can see the garden outside")
#endif
    RETURN
.)


_InspectAlarmIndicator
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED),alarm_disabled)      ; Is the alarm active...
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Le système d'alarme est désactivé")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Alarmsystemet er deaktivert")
#else
        INFO_MESSAGE("The alarm system has been disabled")
#endif
    ELSE(alarm_disabled,alarm_enabled)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Système actif, mais...")
        INFO_MESSAGE("les capteurs arrière sont shuntés.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Systemet er aktivt, men...")
        INFO_MESSAGE("noen har omgått baksensorene.")
#else
        INFO_MESSAGE("System's active, but...")
        INFO_MESSAGE("someone's bypassed the rear sensors.")
#endif
    ENDIF(alarm_enabled)
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_SearchCardboardBox
_InspectCardboardBox
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un colis postal standard.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Helt vanlig postpakke.")
#else
    INFO_MESSAGE("Royal Mail's finest.")
#endif
    JUMP(_InspectContainerGeneric)


_SearchTin
_InspectTin
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Une solide boite en métal")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det er en solid metallboks")
#else
    INFO_MESSAGE("It's a sturdy metal box")
#endif
    JUMP(_InspectContainerGeneric)


_SearchPlasticBag
_InspectPlasticBag
.(
    INCREASE_SCORE(POINTS_INSPECT_PLASTIC_BAG)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Juste un sac blanc normal")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Bare en hvit generisk pose")
#else
    INFO_MESSAGE("It's just a white generic bag")
#endif
    ;JUMP(_InspectContainerGeneric)
+_InspectBucket
+_InspectContainerGeneric
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Pratique pour transporter des trucs.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Greit å ha for å bære ting.")
#else
    INFO_MESSAGE("Handy for carrying things.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectDog
.(
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED),alive)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il ne va pas me laisser passer...")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Den slipper meg ikke forbi...")
#else
        INFO_MESSAGE("It won't let me past...")
#endif
    ELSE(alive,disabled)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il ne bouge plus")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Den rører seg ikke")
#else
        INFO_MESSAGE("It is not moving")
#endif
    ENDIF(disabled)
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_ReadGraffiti
_InspectGraffiti
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_DARKTUNNEL),tunnel)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Problèmes de père, on dirait ?")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Pappa-problemer, kanskje?")
#else
        INFO_MESSAGE("Someone's got daddy issues?")
#endif
    ELSE(tunnel,street)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Aussi moche qu'inintéressant.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Like dårlig kunst som innhold.")
#else
        INFO_MESSAGE("The art is as bad as the content.")
#endif
    ENDIF(street)
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectChurch
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Petite église tranquille.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Stille liten kirke.")
#else
    INFO_MESSAGE("Quiet little church.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectWell
.(
    DISPLAY_IMAGE(LOADER_PICTURE_INSIDE_WELL)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Juste un vieux puits")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Bare en gammel mosegrodd brønn")
#else
    INFO_MESSAGE("Just an old mossy well")
#endif
    WAIT_KEYPRESS    
    END_AND_REFRESH
.)



_InspectDuneBook
_ReadDuneBook
.(
    GOSUB(_ShowDuneBook)
    END_AND_REFRESH
.)

_TakeDuneBook
.(
    DO_ONCE(take_dune)
        GOSUB(_ShowDuneBook)
    ENDDO(take_dune)
    JUMP(_TakeCommon)
.)

_ShowDuneBook
.(
    DISPLAY_IMAGE(LOADER_PICTURE_BOOK_DUNE)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Un Dune de 1965, rongé par les vers")
    INFO_MESSAGE("Il paraît qu'un film est en cours!")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("En orm-spist Dune-roman fra 1965")
    INFO_MESSAGE("Hørte at de lager film av den?")
#else
    INFO_MESSAGE("A wormed-out 1965 Dune novel")
    INFO_MESSAGE("I heard a movie was in the works?")
#endif
    WAIT_KEYPRESS
    RETURN
.)


_InspectMortar
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Pour les épices, normalement...")
    INFO_MESSAGE("...pourrait servir à autre chose.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("For krydder, vanligvis...")
    INFO_MESSAGE("...kan brukes til annet også.")
#else
    INFO_MESSAGE("For grinding spices, usually...")
    INFO_MESSAGE("...could work on other things.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_ReadRoadSign
_InspectRoadSign
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il dit 'Creuseurs & Fils SARL'.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det heter 'Graverne & Sønner AS'.")
#else
    INFO_MESSAGE("It says 'Diggers & Sons Ltd.'")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_OpenTrashcan
_CloseTrashcan
_SearchTrashCan
_InspectTrashCan
.(
    DISPLAY_IMAGE(LOADER_PICTURE_TRASH_CAN)    
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ça sent pire que ça en a l'air.")
    INFO_MESSAGE("Rien qui vaille la peine.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Lukter verre enn det ser ut.")
    INFO_MESSAGE("Ingenting verdt bryet.")
#else
    INFO_MESSAGE("Smells worse than it looks.")
    INFO_MESSAGE("Nothing worth the trouble.")
#endif
    WAIT_KEYPRESS
    END_AND_REFRESH
.)


_ReadTombstone
_InspectTombstone
.(
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_READ_TOMBSTONE)   ; Achievement!    
    INCREASE_SCORE(POINTS_READ_TOMBSTONE)    

    DISPLAY_IMAGE(LOADER_PICTURE_TOMBSTONE)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Seulement 45 ans. Quel gâchis.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Bare 45. For en sløsing.")
#else
    INFO_MESSAGE("Only 45. What a waste.")
#endif
    WAIT_KEYPRESS    
    END_AND_REFRESH
.)


_InspectFishPond
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Pas mal de poissons là-dedans.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ganske mange fisk der inne!")
#else
    INFO_MESSAGE("Plenty of fish in there.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_InspectMixTape
.(
    INCREASE_SCORE(POINTS_INSPECT_MIX_TAPE)
    GOSUB(_ShowMixTape)
    END_AND_REFRESH
.)

_TakeMixTape
.(
    DO_ONCE(take_mixtape)
        GOSUB(_ShowMixTape)
    ENDDO(take_mixtape)
    JUMP(_TakeCommon)
.)

_ShowMixTape
.(
    DISPLAY_IMAGE(LOADER_PICTURE_MIXTAPE)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Les morceaux préférés de quelqu'un.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Noens favoritlåter.")
#else
    INFO_MESSAGE("Someone's favourite tunes.")
#endif
    WAIT_KEYPRESS
    RETURN
.)


_SearchSafe
_InspectSafe
.(
    INCREASE_SCORE(POINTS_INSPECT_SAFE)
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED),elseclose)       ; Is the safe closed?
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_ATTACHED),else)           ; Is the bomb installed?
            DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_WITH_BOMB)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Espérons qu'il va survivre")
#elif defined(LANGUAGE_NO)
            INFO_MESSAGE("Håper det overlever smellet")
#else
            INFO_MESSAGE("Hopefully it will survive the blow")
#endif
        ELSE(else,nobomb)
            DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Rien qu'un bon boom ne règlerait.")
#elif defined(LANGUAGE_NO)
            INFO_MESSAGE("Ikke noe et smell ikke fikser.")
#else
            INFO_MESSAGE("Nothing a good blast couldn't open.")
#endif
        ENDIF(nobomb)
        WAIT_KEYPRESS
    ELSE(elseclose,safeopen)
        DISPLAY_IMAGE(LOADER_PICTURE_SAFE_DOOR_OPEN)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Quasiment rien de brisé!")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Det meste er intakt!")
#else
        INFO_MESSAGE("Most of the stuff is intact!")
#endif
        WAIT_KEYPRESS    
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Acid,e_LOC_NONE),acid)                ; If the acid still hidden (in the safe)? 
            SET_ITEM_LOCATION(e_ITEM_Acid,e_LOC_CELLAR)                          ; It's now visible inside the cellar
            GOSUB(_SubFoundSomething)
        ENDIF(acid)
    ENDIF(safeopen)
    END_AND_REFRESH
.)


_InspectThug
.(
    INCREASE_SCORE(POINTS_INSPECT_THUG)
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED),alive)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il dort")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Han sover")
#else
        INFO_MESSAGE("He is sleeping")
#endif    
    ELSE(alive,disabled)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il ne bouge plus")
        INFO_MESSAGE("Peut-être a-t-il des trucs utiles?")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Han beveger seg ikke")
        INFO_MESSAGE("Kanskje har han nyttige ting?")
#else
        INFO_MESSAGE("He is not moving")
        INFO_MESSAGE("Maybe he has useful items?")
#endif    
    ENDIF(disabled)
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH    
.)


_InspectPanicRoomDoor
.(
    INCREASE_SCORE(POINTS_INSPECT_PANIC_ROOM_DOOR)
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_HoleInDoor,e_LOC_CURRENT),acid)  ; Is there a hole in the door?
        GOSUB(_DrawDoorWithHole)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Ils ne plaisantaient pas...")
        INFO_MESSAGE("...c'était un acide puissant !")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("De løy ikke...")
        INFO_MESSAGE("...det var en kraftig syre!")
#else
        INFO_MESSAGE("They were not lying...")
        INFO_MESSAGE("...that was a strong acid!")
#endif    
    ELSE(acid,clay)
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_ATTACHED),attached)       ; Is the clay attached?
            DISPLAY_IMAGE(LOADER_PICTURE_DOOR_WITH_CLAY)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Un joli petit barrage...")
            INFO_MESSAGE("...plus qu'à le remplir !")
#elif defined(LANGUAGE_NO)
            INFO_MESSAGE("Et fint lite demningsverk...")
            INFO_MESSAGE("...bare å fylle det opp!")
#else
            INFO_MESSAGE("A nice little damn...")
            INFO_MESSAGE("...just need to fill it!")
#endif    
        ELSE(attached,nothing)
            DISPLAY_IMAGE(LOADER_PICTURE_DOOR_DIGICODE)
#ifdef LANGUAGE_FR
            INFO_MESSAGE("Impossible de deviner le code...")
            INFO_MESSAGE("La porte est-elle vulnérable?")
#elif defined(LANGUAGE_NO)
            INFO_MESSAGE("Umulig å gjette koden...")
            INFO_MESSAGE("Er kanskje selve døren sårbar?")
#else
            INFO_MESSAGE("Impossible to guess that code...")
            INFO_MESSAGE("Maybe the door itself is vulnerable?")
#endif    
        WAIT_KEYPRESS    
        ENDIF(nothing)
    ENDIF(clay)
    END_AND_REFRESH    
.)


_DrawDoorWithHole
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_DOOR_WITH_CLAY)            ; Load the image with the clay dam
    BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,6,64)                       ; Apply the hole overlay
            _IMAGE(28,0)
            _BUFFER(17,64)
    FADE_BUFFER
    RETURN
.)


_InspectProtectionSuit
.(
    INCREASE_SCORE(POINTS_INSPECT_PROTECTION_SUIT)

    ; Check if we already have the suit equipped
    JUMP_IF_TRUE(_ErrorAlreadyEquipped_Elle,CHECK_ITEM_FLAG(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED))

    GOSUB(_ShowProtectionSuit)
    END_AND_REFRESH    
.)


_TakeProtectionSuit
.(
    DO_ONCE(take_suit)
        GOSUB(_ShowProtectionSuit)
    ENDDO(take_suit)
    JUMP(_TakeCommon)
.)


_ShowProtectionSuit
.(
    DISPLAY_IMAGE(LOADER_PICTURE_PROTECTION_SUIT)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Protection intégrale.")
    INFO_MESSAGE("Pesticides, chimie... pratique.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Full kroppsbeskyttelse.")
    INFO_MESSAGE("Plantevernmidler, kjemikalier...")
#else
    INFO_MESSAGE("Full body protection.")
    INFO_MESSAGE("Pesticides, chemicals... handy.")
#endif    
    WAIT_KEYPRESS
    RETURN
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
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_HOLE)                            ; Draw the base image with the hole over an empty room
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

    DO_ONCE(victim_speech)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("La victime est attachée...")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Offeret er bundet...")
#else
        INFO_MESSAGE("The victim is restrained...")
#endif
    ENDDO(victim_speech)
    
    IF_FALSE(CHECK_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOC_HOSTAGE_ROOM),giving_knife)
        ; We don't show the MMHFF if we are passing the knife because that causes some redraw issues
        BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_ATTACHED,15,44,17)    ; Draw the patch with the MMMHF!! speech bubble
                _IMAGE_STRIDE(0,108,17)
                _BUFFER(22,67)
        FADE_BUFFER
        WAIT(50)
    ENDIF(giving_knife)

    DO_ONCE(victim_reassure)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Tenez bon, je vais vous sortir de là")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Hold ut, jeg skal få deg ut herfra!")
#else
        INFO_MESSAGE("Hang on, I'll get you out of here!")
#endif
    ENDDO(victim_reassure)    
    RETURN
.)


_ShowGirlInRoomWithoutBindings
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_HOLE)                        ; Draw the base image with the hole over an empty room
    BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_FREE,14,92,17)    ; Draw the patch with the girl sitting on the floor 
            _IMAGE_STRIDE(0,0,17)
            _BUFFER(12,16)
    FADE_BUFFER

    ; We show the message and the "thank you" only once.
    DO_ONCE(thank_you)
        LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Elle a coupé ses entraves...")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Hun kuttet sine bånd...")
#else
        INFO_MESSAGE("She cut her bindings...")
#endif    
        BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_FREE,15,59,17)    ; Draw the patch with the Thank You! spech bubble
                _IMAGE_STRIDE(0,92,17)
                _SCREEN(18,2)
        WAIT(50)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("...mais comment s'échapper?")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("...nå for flukten?")
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
        _BUBBLE_LINE(10,50,0,"Dites-moi quoi faire !")
        _BUBBLE_LINE(15,65,0,"Je peux aider !")
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(10,50,0,"Si meg hva jeg skal gjøre!")
        _BUBBLE_LINE(15,65,0,"Jeg kan hjelpe!")
#else
        _BUBBLE_LINE(10,50,0,"Tell me what to do!")
        _BUBBLE_LINE(15,65,0,"I can help!")
#endif    
    ELSE(closed,open)
        ; The window is now opened
        JUMP_IF_TRUE(rope_not_attached,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
            WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
            _BUBBLE_LINE(10,50,0,"La fenêtre est ouverte maintenant.")
            _BUBBLE_LINE(15,65,0,"Mais je ne peux pas descendre...")
#elif defined(LANGUAGE_NO)
            _BUBBLE_LINE(10,50,0,"Vinduet er åpent nå.")
            _BUBBLE_LINE(15,65,0,"Men jeg kan ikke klatre ned...")
#else
            _BUBBLE_LINE(10,50,0,"The window is open now.")
            _BUBBLE_LINE(15,65,0,"But I can't climb down...")
#endif    
rope_not_attached        
    ENDIF(open)

    BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_FREE,2,14,17)    ; Draw the small speech bubble triangle to connec to the Thank You! spech bubble
            _IMAGE_STRIDE(15,0,17)
            _SCREEN(17,36)

    WAIT(50*3)

    RETURN
.)


_ShowEmptyHostageRoom
.(
    DISPLAY_IMAGE(LOADER_PICTURE_HOLE)
+_SubPrintEmptyRoomMessage
#ifdef LANGUAGE_FR
    INFO_MESSAGE("La pièce est vide...")
    INFO_MESSAGE("...la fille doit déjà être en bas")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Rommet er tomt...")
    INFO_MESSAGE("...hun er nok utenfor nå")
#else
    INFO_MESSAGE("The room is empty...")
    INFO_MESSAGE("...she must be outside by now")
#endif    
    RETURN
.)



_ShowOpenWindow
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_TOP_WINDOW_CLOSED)
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
    DISPLAY_IMAGE(LOADER_PICTURE_PANIC_ROOM_WINDOW)
    WAIT(50*2)

    ; Load the base image with the wall and the closed window and shutters
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_TOP_WINDOW_CLOSED)
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
    PLAY_SOUND(_DoorOpening) 
    WAIT(50*2)
    RETURN
.)

_ShowGirlAtTheWindow
.(
    ; Base image with the wall and the closed window
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_PANIC_ROOM_WINDOW)
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_PanicRoomWindow,ITEM_FLAG_CLOSED),window_open)
        ; Show the shutters open
        BLIT_BLOCK(LOADER_SPRITE_PANIC_ROOM_WINDOW,18,26)                     ; Draw the open shutters
                _IMAGE(0,0)
                _BUFFER(11,0)

        ; Show the rope going down the window if it's attached
        JUMP_IF_FALSE(rope_going_down,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
        JUMP_IF_TRUE(rope_visible,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_TILEDPATIO))
        JUMP_IF_FALSE(rope_going_down,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_PANIC_ROOM_DOOR))
rope_visible            
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

        ; Is the rope attached to the window?
        JUMP_IF_TRUE(check_rope_flag,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_TILEDPATIO))
        JUMP_IF_FALSE(too_high_to_jump,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_PANIC_ROOM_DOOR))
check_rope_flag
        IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED),rope_not_attached)
too_high_to_jump        
            ; The rope is not attached
            ; Show the girl's message to the player        
            WHITE_BUBBLE(1)
#ifdef LANGUAGE_FR
            _BUBBLE_LINE(80,25,0,"C'est trop haut pour sauter!")
#elif defined(LANGUAGE_NO)
            _BUBBLE_LINE(80,25,0,"Det er for høyt til å hoppe!")
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
            _BUBBLE_LINE(107,25,0,"Je peux le faire !")
#elif defined(LANGUAGE_NO)
            _BUBBLE_LINE(93,25,0,"Det klarer jeg!")
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
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Pas moyen d'y accéder d'ici.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Ingen vei opp herfra.")
#else
        INFO_MESSAGE("No way up from this side.")
#endif        
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
    VALUE_MAPPING(e_ITEM_CellarWindow       , _OpenCellarWindow)
    VALUE_MAPPING(e_ITEM_AlarmPanel         , _OpenAlarmPanel)
    VALUE_MAPPING(e_ITEM_Car                , _OpenCar)
    VALUE_MAPPING(e_ITEM_CarBoot            , _OpenCarBoot)
    VALUE_MAPPING(e_ITEM_CarDoor            , _OpenCarDoor)
    VALUE_MAPPING(e_ITEM_CarTank            , _OpenCarPetrolTank)
    VALUE_MAPPING(e_ITEM_PanicRoomWindow    , _OpenPanicRoomWindow)
    VALUE_MAPPING(e_ITEM_FrontDoor          , _OpenFrontDoor)
    VALUE_MAPPING(e_ITEM_SecurityDoor       , _OpenSecurityDoor)
    VALUE_MAPPING(e_ITEM_HeavySafe          , _OpenSafe)
    VALUE_MAPPING(e_ITEM_Church             , _OpenChurch)
    VALUE_MAPPING(e_ITEM_NormalWindow       , _OpenNormalWindow)    
    VALUE_MAPPING(e_ITEM_ChemistryBook      , _OpenChemistryBook)    
    VALUE_MAPPING(e_ITEM_TVCabinet          , _OpenTVCabinet)        
    VALUE_MAPPING(e_ITEM_Drawer             , _OpenDrawer)
    VALUE_MAPPING(e_ITEM_Trashcan           , _OpenTrashcan)
    VALUE_MAPPING(255                       , _ErrorCannotDo)        ; Default option


_OpenSafe
.(
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Il,CHECK_ITEM_FLAG(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED))      ; Is the safe open?
    GOSUB(_SubMessageDoorIsLocked)
    END_AND_PARTIAL_REFRESH
.)

_OpenCurtain
.(
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Il,CHECK_ITEM_FLAG(e_ITEM_Curtain,ITEM_FLAG_CLOSED))            ; Is the curtain closed?
    UNSET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)                                           ; Open it!
    SET_LOCATION_DIRECTION(e_LOC_WESTGALLERY,e_DIRECTION_NORTH,e_LOC_PANIC_ROOM_DOOR)           ; We can now access the panic room
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CURTAIN)                                          ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"un _rideau ouvert")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"et åpent _gardin")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"an opened _curtain")
#endif
    END_AND_REFRESH
.)


_OpenPanicRoomWindow
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_TILEDPATIO),tiledpatio)
        GOSUB(_SubErrorTooHigh)
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
            JUMP(_ErrorAlreadyOpen_Elle)
        ENDIF(else)
    ENDIF(panicroom)
    END_AND_REFRESH
.)


_SubErrorTooHigh
.(
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Trop haut d'ici.")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Når ikke opp herfra.")
#else
    ERROR_MESSAGE("Can't reach that from here.")
#endif        
    RETURN
.)


; TODO: Messages to indicate that the fridge it already open or that we have already found something
; Probably need a string table/id system to easily reuse messages.
_OpenFridge
.(    
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Il,CHECK_ITEM_FLAG(e_ITEM_Fridge,ITEM_FLAG_CLOSED))             ; Is the fridge closed?
+_SearchFridge
    PLAY_SOUND(_DoorOpening)
    UNSET_ITEM_FLAGS(e_ITEM_Fridge,ITEM_FLAG_CLOSED)                                                ; Open it!
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_FRIDGE)                                               ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"un _réfrigérateur ouvert")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"et åpent _kjøleskap")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"an open _fridge")
#endif
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Meat,e_LOC_NONE),meat)                          ; If the meat still hidden (in the fridge)? 
        SET_ITEM_LOCATION(e_ITEM_Meat,e_LOC_KITCHEN)                                   ; It's now visible inside the kitchen
    ENDIF(meat)
    END_AND_REFRESH
.)


_OpenMedicineCabinet
.(
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Elle,CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED))    ; Is the medicine cabinet closed?
+_SearchMedicineCabinet
    PLAY_SOUND(_DoorOpening)
    UNSET_ITEM_FLAGS(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED)                                       ; Open it!
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                              ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"une _armoire à pharmacie ouverte")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"et åpent _medisinskap")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"an open medicine _cabinet")
#endif
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_SedativePills,e_LOC_NONE),pills)                ; Are the pills still hidden (in the cabinet)? 
        SET_ITEM_LOCATION(e_ITEM_SedativePills,e_LOC_KITCHEN)                          ; It's now visible inside the kitchen
    ENDIF(pills)
    END_AND_REFRESH
.)


_OpenGunCabinet
.(
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Elle,CHECK_ITEM_FLAG(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED))         ; Is the gun cabinet closed?
+_SearchGunCabinet    
    PLAY_SOUND(_DoorOpening)
    UNSET_ITEM_FLAGS(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED)                                            ; Open it!
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                              ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"une _armoire à armes ouverte")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"et åpent _våpenskap")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"an open gun _cabinet")
#endif
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_DartGun,e_LOC_NONE),dartgun)                    ; Is the dart gun still hidden (in the gun cabinet)? 
        GOSUB(_SubFoundSomething)
        DISPLAY_IMAGE(LOADER_PICTURE_DRAWER_GUN_CABINET)                               ; Show what we found!
        SET_ITEM_LOCATION(e_ITEM_DartGun,e_LOC_STUDY_ROOM)                             ; It's now visible inside the study room
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Une seule fléchette, mieux que rien!")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Bare en pil, bedre enn ingenting!")
#else
        INFO_MESSAGE("Only one dart, better than nothing!")
#endif    
        WAIT_KEYPRESS
    ENDIF(dartgun)
    END_AND_REFRESH
.)


_OpenTVCabinet
.(
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Il,CHECK_ITEM_FLAG(e_ITEM_TVCabinet,ITEM_FLAG_CLOSED))          ; Is the TV cabinet closed?
+_SearchTVCabinet    
    PLAY_SOUND(_DoorOpening)
    UNSET_ITEM_FLAGS(e_ITEM_TVCabinet,ITEM_FLAG_CLOSED)                                             ; Open it!
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                              ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_TVCabinet,"un _meuble TV ouvert")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_TVCabinet,"et åpent _TVskap")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_TVCabinet,"an open TV _cabinet")
#endif
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Oric,e_LOC_NONE),oric)                          ; Is the Oric still hidden (in the TV cabinet)? 
        GOSUB(_SubFoundSomething)
        SET_ITEM_LOCATION(e_ITEM_Oric,e_LOC_GAMESROOM)                                 ; It's now visible inside the game room
        JUMP(_InspectOricOmputer)                                                      ; Show what we found!
    ENDIF(oric)
    END_AND_REFRESH
.)


_OpenDrawer
.(
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Il,CHECK_ITEM_FLAG(e_ITEM_Drawer,ITEM_FLAG_CLOSED))             ; Is the drawer closed?
+_SearchDrawer
    PLAY_SOUND(_DoorOpening)
    UNSET_ITEM_FLAGS(e_ITEM_Drawer,ITEM_FLAG_CLOSED)                                                ; Open it!
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                              ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_Drawer,"un _tiroir ouvert")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Drawer,"en åpen _skuff")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Drawer,"an open _drawer")
#endif
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Batteries,e_LOC_NONE),batteries)                          ; Are the batteries still hidden (in the drawer)? 
        GOSUB(_SubFoundSomething)
        SET_ITEM_LOCATION(e_ITEM_Batteries,e_LOC_GUESTBEDROOM)                                   ; It's now visible inside the guest bedroom
        JUMP(_InspectBatteries)                                                                  ; Show what we found!
    ENDIF(batteries)
    END_AND_REFRESH
.)


_OpenAlarmPanel
.(
    GOSUB(_SubCheckToDark)     ; Was the tape removed from the window?

    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_LOCKED),locked)                        ; Is the alarm panel locked?
#ifdef LANGUAGE_FR                                                                             ; Show error to the player
        ERROR_MESSAGE("Fermé. Il me faut une clef.")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Låst. Trenger en nøkkel.")
#else
        ERROR_MESSAGE("Locked. Need to find a key.")
#endif        
        END_AND_PARTIAL_REFRESH
    ELSE(locked,unlocked)
        JUMP_IF_FALSE(_ErrorAlreadyOpen_Elle,CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED))  ; Is the alarm panel locked?
        PLAY_SOUND(_DoorOpening)
        UNSET_ITEM_FLAGS(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED)                               ; Open it!
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_PANEL)                                   ; And get an achievement for that action
#ifdef LANGUAGE_FR                                                                             ; Update the description
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"une _centrale d'alarme ouverte")
#elif defined(LANGUAGE_NO)
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"et åpent alarm _panel")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"an open alarm _panel")
#endif
        SET_ITEM_LOCATION(e_ITEM_AlarmSwitch,e_LOC_DARKCELLARROOM)                         ; The alarm button is now visible 
        JUMP(_InspectPanel)
    ENDIF(unlocked)
    END_AND_REFRESH
.)


_OpenCellarWindow
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM),cellar)                                ; Are we on the cellar side in the room itself...
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Inaccessible...")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Utilgjengelig...")
#else
        INFO_MESSAGE("I can't reach it...")
#endif
        END_AND_PARTIAL_REFRESH
    ENDIF(cellar)

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_CELLAR_WINDOW),cellar_on_ladder)                       ; Are we on the cellar side on the ladder...
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Le cadre est bloqué...")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Karmen sitter fast...")
#else
        INFO_MESSAGE("The frame is stuck...")                                                   
#endif        
    ELSE(cellar_on_ladder,garden)                                                              ; ...or on the vegetable garden side of the window?
        DISPLAY_IMAGE(LOADER_PICTURE_CELLAR_WINDOW_OUTSIDE_DARKENED)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Elle est fermée de l'intérieur...")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Den er låst innenfra...")
#else
        INFO_MESSAGE("It is locked from the inside...")
#endif        
    ENDIF(garden)
    JUMP(_OpenWindowCommon)
.)


_OpenNormalWindow
    // If we are inside the house, we can open the window
    JUMP_IF_TRUE(_OpenWindowFromInside,CHECK_PLAYER_LOCATION(e_LOC_GAMESROOM))
    JUMP_IF_TRUE(_OpenWindowFromInside,CHECK_PLAYER_LOCATION(e_LOC_DININGROOM))
    JUMP_IF_TRUE(_OpenWindowFromInside,CHECK_PLAYER_LOCATION(e_LOC_LOUNGE))
    JUMP_IF_TRUE(_OpenWindowFromInside,CHECK_PLAYER_LOCATION(e_LOC_STUDY_ROOM))
    JUMP_IF_TRUE(_OpenWindowFromInside,CHECK_PLAYER_LOCATION(e_LOC_KITCHEN))

#ifdef LANGUAGE_FR
    INFO_MESSAGE("Elle semble verrouillée...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Den ser ut til å være låst...")
#else
    INFO_MESSAGE("It seems to be locked...")
#endif    

_OpenWindowCommon
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("...peut-être en secouant ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("...kanskje riste litt på den?")
#else
    INFO_MESSAGE("...maybe shake it a bit?")
#endif    
    ; Check the status of the alarm... and if it's active, trigger it!
    JUMP_IF_FALSE(_AlarmTriggered,CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED))      ; Is the alarm active...
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Rien ne se passe...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ingenting skjer...")
#else
    INFO_MESSAGE("Nothing happens...")
#endif    
    END_AND_PARTIAL_REFRESH
.)

_OpenWindowFromInside
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Pas besoin d'ouvrir la fenêtre")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det er ikke nødvendig å åpne vinduet")
#else
    INFO_MESSAGE("There's no need to open the window")
#endif    
    END_AND_PARTIAL_REFRESH



_AlarmTriggered
.(
    SET_CUT_SCENE(1)
    GAME_OVER(e_SCORE_TRIPPED_ALARM)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_TRIPPED_ALARM)   ; Achievement!
    DISPLAY_IMAGE(LOADER_PICTURE_ALARM_TRIGGERED)
    LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
    CLEAR_TEXT_AREA(1)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("J'ai déclenché l'alarme !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Jeg utløste alarmen!")
#else
    INFO_MESSAGE("I've triggered the alarm!")
#endif    
    WAIT(50*2)
    JUMP(_gDescriptionGameOverLost)                 ; Draw the 'The End' logo
.)


_OpenCarBoot
.(
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Il,CHECK_ITEM_FLAG(e_ITEM_CarBoot,ITEM_FLAG_CLOSED))  ; Is the boot closed?
    PLAY_SOUND(_DoorOpening)
    UNSET_ITEM_FLAGS(e_ITEM_CarBoot,ITEM_FLAG_CLOSED)                                     ; Open it!
#ifdef LANGUAGE_FR                                                                        ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"un _coffre ouvert")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"et åpent _bagasjerom")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"an open car _boot")
#endif
    END_AND_REFRESH
.)


_OpenCarDoor
.(
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Elle,CHECK_ITEM_FLAG(e_ITEM_CarDoor,ITEM_FLAG_CLOSED))  ; Is the door closed?
    PLAY_SOUND(_DoorOpening)
    UNSET_ITEM_FLAGS(e_ITEM_CarDoor,ITEM_FLAG_CLOSED)                                       ; Open it!
#ifdef LANGUAGE_FR                                                                          ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"une _portière ouverte")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"en åpen bil _dør")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"an open car _door")
#endif
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_MixTape,e_LOC_NONE),mixtape)                         ; Is the mixtape still not found?
        SET_ITEM_LOCATION(e_ITEM_MixTape,e_LOC_ABANDONED_CAR)                               ; It's now visible inside the car
    ENDIF(mixtape)
    END_AND_REFRESH
.)


_OpenCarPetrolTank
.(
    JUMP_IF_FALSE(_ErrorAlreadyOpen_Il,CHECK_ITEM_FLAG(e_ITEM_CarTank,ITEM_FLAG_CLOSED))    ; Is the petrol tank closed?
    PLAY_SOUND(_DoorOpening)
    UNSET_ITEM_FLAGS(e_ITEM_CarTank,ITEM_FLAG_CLOSED)                                       ; Open it!
#ifdef LANGUAGE_FR                                                                          ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"un _réservoir d'essence ouvert")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"en åpen bensin _tank")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"an open petrol _tank")
#endif
    END_AND_REFRESH
.)

_InspectFrontDoor
_OpenSecurityDoor
_OpenFrontDoor
_OpenChurch
.(
    GOSUB(_SubMessageDoorIsLocked)
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_FRONT_ENTRANCE),frontdoor)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("...par derrière peut-être ?")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("...rundt baksiden kanskje?")
#else
        INFO_MESSAGE("...round the back maybe?")
#endif
    ENDIF(frontdoor)
    END_AND_PARTIAL_REFRESH
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
    VALUE_MAPPING(e_ITEM_TVCabinet          , _CloseTVCabinet)    
    VALUE_MAPPING(e_ITEM_Drawer             , _CloseDrawer)
    VALUE_MAPPING(e_ITEM_Trashcan           , _CloseTrashcan)
    VALUE_MAPPING(255                       , _ErrorCannotDo)            ; Default option


_CloseCurtain
.(
    JUMP_IF_TRUE(_ErrorAlreadyClosed_Il,CHECK_ITEM_FLAG(e_ITEM_Curtain,ITEM_FLAG_CLOSED))           ; Is the curtain open?
    SET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)                                                 ; Close it!
    SET_LOCATION_DIRECTION(e_LOC_WESTGALLERY,e_DIRECTION_NORTH,e_LOC_NONE)                          ; The room behind is not accessible anymore
+_gTextItemClosedCurtain = *+2                                                                      ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"un _rideau fermé")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"et lukket _gardin")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"a closed _curtain")
#endif
    END_AND_REFRESH
.)


_CloseFridge
.(
    JUMP_IF_TRUE(_ErrorAlreadyClosed_Il,CHECK_ITEM_FLAG(e_ITEM_Fridge,ITEM_FLAG_CLOSED))            ; Is the fridge open?
    PLAY_SOUND(_DoorClosing)
    SET_ITEM_FLAGS(e_ITEM_Fridge,ITEM_FLAG_CLOSED)                                                  ; Close it!
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_CLOSED_THE_FRIDGE)                                               ; And get an achievement for that action
+_gTextItemFridge = *+2                                                                             ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"un _réfrigérateur")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"et _kjøleskap")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Fridge,"a _fridge")
#endif
    END_AND_REFRESH
.)


_CloseMedicineCabinet
.(
    JUMP_IF_TRUE(_ErrorAlreadyClosed_Elle,CHECK_ITEM_FLAG(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED))   ; Is the cabinet open?
    PLAY_SOUND(_DoorClosing)
    SET_ITEM_FLAGS(e_ITEM_Medicinecabinet,ITEM_FLAG_CLOSED)                                         ; Close it!
+_gTextItemMedicineCabinet = *+2                                                                    ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"une _armoire à pharmacie")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"et _medisinskap")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Medicinecabinet,"a medicine _cabinet")
#endif
    END_AND_REFRESH
.)


_CloseGunCabinet
.(
    JUMP_IF_TRUE(_ErrorAlreadyClosed_Elle,CHECK_ITEM_FLAG(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED))      ; Is the cabinet open?
    PLAY_SOUND(_DoorClosing)
    SET_ITEM_FLAGS(e_ITEM_GunCabinet,ITEM_FLAG_CLOSED)                                              ; Close it!
+_gTextItemClosedGunCabinet = *+2                                                                   ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"une _armoire à armes")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"et _våpenskap")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_GunCabinet,"a closed gun _cabinet")
#endif
    END_AND_REFRESH
.)


_CloseTVCabinet
.(
    JUMP_IF_TRUE(_ErrorAlreadyClosed_Il,CHECK_ITEM_FLAG(e_ITEM_TVCabinet,ITEM_FLAG_CLOSED))         ; Is the cabinet open?
    PLAY_SOUND(_DoorClosing)
    SET_ITEM_FLAGS(e_ITEM_TVCabinet,ITEM_FLAG_CLOSED)                                               ; Close it!
+_gTextItemClosedTVCabinet = *+2                                                                    ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_TVCabinet,"un _meuble TV fermé")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_TVCabinet,"et _TVskap")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_TVCabinet,"a closed TV _cabinet")
#endif
    END_AND_REFRESH
.)


_CloseDrawer
.(
    JUMP_IF_TRUE(_ErrorAlreadyClosed_Il,CHECK_ITEM_FLAG(e_ITEM_Drawer,ITEM_FLAG_CLOSED))            ; Is the drawer open?
    PLAY_SOUND(_DoorClosing)
    SET_ITEM_FLAGS(e_ITEM_Drawer,ITEM_FLAG_CLOSED)                                                  ; Close it!
+_gTextItemClosedDrawer = *+2                                                                       ; Description used by default when the game starts
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_Drawer,"un _tiroir fermé")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Drawer,"en _skuff")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Drawer,"a closed _drawer")
#endif
    END_AND_REFRESH
.)


_CloseAlarmPanel
.(
    GOSUB(_SubCheckToDark)     ; Was the tape removed from the window?

    JUMP_IF_TRUE(_ErrorAlreadyClosed_Elle,CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED))        ; Is the alarm panel closed?
    PLAY_SOUND(_DoorClosing)
    SET_ITEM_FLAGS(e_ITEM_AlarmPanel,ITEM_FLAG_CLOSED)                                              ; Close it!
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_CABINET)                                              ; And get an achievement for that action
    GOSUB(_SubSetLockedPanelDescription)
    SET_ITEM_LOCATION(e_ITEM_AlarmSwitch,e_LOC_NONE)                                                ; The alarm button is now invisible 
    JUMP(_InspectPanel)
.)

_SubSetLockedPanelDescription
.(
#ifdef LANGUAGE_FR                                                                                  ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"une _centrale d'alarme fermée")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"et lukket alarm _panel")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"a closed alarm _panel")
#endif
    RETURN
.)


_CloseCarBoot
.(
    JUMP_IF_TRUE(_ErrorAlreadyClosed_Il,CHECK_ITEM_FLAG(e_ITEM_CarBoot,ITEM_FLAG_CLOSED))   ; Is the boot open?
    PLAY_SOUND(_DoorClosing)
    SET_ITEM_FLAGS(e_ITEM_CarBoot,ITEM_FLAG_CLOSED)                                         ; Close it!
+_gTextItemCarBoot = *+2        
#ifdef LANGUAGE_FR                                                                          ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"un _coffre de voiture")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"et _bagasjerom")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_CarBoot,"a car _boot")
#endif
    END_AND_REFRESH
.)


_CloseCarDoor
.(
    JUMP_IF_TRUE(_ErrorAlreadyClosed_Elle,CHECK_ITEM_FLAG(e_ITEM_CarDoor,ITEM_FLAG_CLOSED))  ; Is the door open?
    PLAY_SOUND(_DoorClosing)
    SET_ITEM_FLAGS(e_ITEM_CarDoor,ITEM_FLAG_CLOSED)                                          ; Close it!
+_gTextItemCarDoor = *+2        
#ifdef LANGUAGE_FR                                                                           ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"une _portière")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"en bil _dør")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_CarDoor,"a car _door")
#endif
    END_AND_REFRESH
.)


_CloseCarPetrolTank
.(
    JUMP_IF_TRUE(_ErrorAlreadyClosed_Il,CHECK_ITEM_FLAG(e_ITEM_CarTank,ITEM_FLAG_CLOSED))   ; Is the petrol tank open?
    SET_ITEM_FLAGS(e_ITEM_CarTank,ITEM_FLAG_CLOSED)                                         ; Close it!
+_gTextItemCarPetrolTank = *+2        
#ifdef LANGUAGE_FR                                                                          ; Update the description
    SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"un _réservoir d'essence")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"en bensin _tank")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_CarTank,"a closed petrol _tank")
#endif
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_ABANDONED_CAR),petrol)                 ; If the petrol was not collected
        SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_NONE)                                        ; Then we hide it again
    ENDIF(petrol)

    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Hose,e_LOC_ABANDONED_CAR),hose)                 ; If the hose is installed...
        SET_CURRENT_ITEM(e_ITEM_Hose)                                                  ; Else we will take the reservoir...
        JUMP_IF_TRUE(_TakeHose,CHECK_ITEM_FLAG(e_ITEM_Hose,ITEM_FLAG_ATTACHED))        ; ...then we need to remove it again
    ENDIF(hose)
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
    VALUE_MAPPING(e_ITEM_Bucket             , _UseBucket)
    VALUE_MAPPING(e_ITEM_Rope               , _UseRope)
    VALUE_MAPPING(e_ITEM_HandheldGame       , _UseGame)
    VALUE_MAPPING(e_ITEM_Bread              , _UseBread)
    VALUE_MAPPING(e_ITEM_Apple              , _UseApples)
    VALUE_MAPPING(e_ITEM_Meat               , _UseMeat)
    VALUE_MAPPING(e_ITEM_Water              , _UseWater)
    VALUE_MAPPING(e_ITEM_LargeDove          , _UseDove)
    VALUE_MAPPING(e_ITEM_SilverKnife        , _UseKnife)
    VALUE_MAPPING(e_ITEM_SnookerCue         , _UseSnookerCue)
    VALUE_MAPPING(e_ITEM_DartGun            , _UseDartGun)
    VALUE_MAPPING(e_ITEM_SmallKey           , _UseKey)
    VALUE_MAPPING(e_ITEM_AlarmSwitch        , _UseAlarmSwitch)
    VALUE_MAPPING(e_ITEM_Hose               , _UseHosePipe)
    VALUE_MAPPING(e_ITEM_MortarAndPestle    , _UseMortar)
    VALUE_MAPPING(e_ITEM_Bomb               , _UseBomb)
    VALUE_MAPPING(e_ITEM_Adhesive           , _UseAdhesive)
    VALUE_MAPPING(e_ITEM_BoxOfMatches       , _UseMatches)
    VALUE_MAPPING(e_ITEM_ProtectionSuit     , _UseProtectionSuit)
    VALUE_MAPPING(e_ITEM_Clay               , _UseClay)
    VALUE_MAPPING(e_ITEM_Acid               , _UseAcid)
    VALUE_MAPPING(e_ITEM_Net                , _UseNet)
    VALUE_MAPPING(e_ITEM_RoughPlan          , _UseRoughPlan)
    VALUE_MAPPING(e_ITEM_Car                , _UseCar)
    VALUE_MAPPING(e_ITEM_FancyStones        , _UseFancyStones)
    VALUE_MAPPING(e_ITEM_Computer           , _UseComputer)
    VALUE_MAPPING(e_ITEM_GameConsole        , _UseGameConsole)
    VALUE_MAPPING(e_ITEM_Television         , _UseTelevision)
    VALUE_MAPPING(e_ITEM_ChemistryBook      , _UseChemistryBook)
    VALUE_MAPPING(e_ITEM_Oric               , _UseOricComputer)
#ifdef PRODUCT_TYPE_GAME_DEMO
    VALUE_MAPPING(e_ITEM_DemoMessage        , _UseDemoMessage)
#endif // PRODUCT_TYPE_GAME_DEMO
    VALUE_MAPPING(255                       , _ErrorCannotDo)   ; Default option


; Shared confirmation: "End the game: Are you sure?"
; If player confirms (Y/O/J): RETURN to caller to proceed with quit/reset
; If player declines: END_AND_REFRESH (never returns, game continues)
_ConfirmEndGame
.(
    ; Print the message on a red background to make it obvious it's dangerous
    CLEAR_TEXT_AREA(1)
#ifdef LANGUAGE_FR
    QUICK_MESSAGE("Fin du jeu: Êtes-vous sûr ?")
#elif defined(LANGUAGE_NO)
    QUICK_MESSAGE("Avslutte spillet: Er du sikker?")
#else
    QUICK_MESSAGE("End the game: Are you sure?")
#endif
    WAIT_KEYPRESS
#ifdef LANGUAGE_FR
    JUMP_IF_FALSE(not_confirmed, CHECK_ADDRESS_VALUE(_gInputKey,"O"))
#elif defined(LANGUAGE_NO)
    JUMP_IF_FALSE(not_confirmed, CHECK_ADDRESS_VALUE(_gInputKey,"J"))
#else
    JUMP_IF_FALSE(not_confirmed, CHECK_ADDRESS_VALUE(_gInputKey,"Y"))
#endif
    RETURN
not_confirmed
    END_AND_REFRESH
.)

_UseOricComputer   ; view_oric_computer.png
.(
    DISPLAY_IMAGE(LOADER_PICTURE_ORIC_COMPUTER)
    GOSUB(_ConfirmEndGame)
    ; Only reached if player confirmed
    QUICK_MESSAGE("RESET...")
    CALL_NATIVE(_Reset)
.)


_OpenCar
_SearchCar
_InspectCar
_UseCar
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_MARKETPLACE),marketplace)
        DISPLAY_IMAGE(LOADER_PICTURE_AUSTIN_MINI)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Mon Austin 850. Passe inaperçue.")
        INFO_MESSAGE("La mission d'abord. Elle attendra.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Austin 850. Går i ett med resten.")
        INFO_MESSAGE("Oppdraget først. Hun kan vente.")
#else
        INFO_MESSAGE("My Austin 850. Blends right in.")
        INFO_MESSAGE("Mission first. She'll wait.")
#endif        
    ELSE(marketplace,abandonned_car)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Ça mérite un coup d'oeil.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Verdt en nærmere titt.")
#else
        INFO_MESSAGE("Worth a closer look.")
#endif        
        SET_PLAYER_LOCATION(e_LOC_ABANDONED_CAR)
    ENDIF(abandonned_car)
    END_AND_REFRESH
.)

_InspectCarBoot
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_CarBoot,ITEM_FLAG_CLOSED),boot_closed)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il est fermé mais pas à clef")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Den er lukket men ikke låst.")
#else
        INFO_MESSAGE("It's closed, but not locked.")
#endif
    ELSE(boot_closed,boot_open)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il n'y a que la roue de secours")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Det er bare reservehjulet der")
#else
        INFO_MESSAGE("Other than the spare wheel, empty")
#endif    
    ENDIF(boot_open)
    END_AND_PARTIAL_REFRESH
.)


_InspectCarDoor
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_CarDoor,ITEM_FLAG_CLOSED),door_closed)
        GOSUB(_SubClosedButNotLocked_Elle)
    ELSE(door_closed,door_open)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("A peine accrochée aux gonds.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Henger knapt på hengslene.")
#else
        INFO_MESSAGE("Barely hanging on its hinges.")
#endif    
    ENDIF(door_open)
    END_AND_PARTIAL_REFRESH
.)


_InspectCarTank
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_CarTank,ITEM_FLAG_CLOSED),tank_closed)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il est fermé mais pas à clef")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Den er lukket men ikke låst.")
#else
        INFO_MESSAGE("It's closed, but not locked.")
#endif
    ELSE(tank_closed,tank_open)
        GOSUB(_SubTankHasPetrol)
    ENDIF(tank_open)
    END_AND_PARTIAL_REFRESH
.)


_SubTankHasPetrol
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il reste de l'essence dedans")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det er fortsatt bensin i den")
#else
    INFO_MESSAGE("It still has petrol in it")
#endif
    RETURN
.)


_InspectPetrol
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ça sent fort. Encore utilisable.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Lukter sterkt. Fortsatt brukbar.")
#else
    INFO_MESSAGE("Smells potent. Still usable.")
#endif
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH


_UseBucket
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM),in_dark_room)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Bien essayé. Toujours trop court.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Godt forsøk. Når fortsatt ikke.")
#else
        INFO_MESSAGE("Nice try. Still can't reach.")
#endif    
    ENDIF(in_dark_room)
    END_AND_PARTIAL_REFRESH
.)

_UseLadder
.(
    ; If already positioned, "use ladder" means climb it
    JUMP_IF_FALSE(not_yet_attached,CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED))
    JUMP_IF_TRUE(climb_out_of_pit,CHECK_PLAYER_LOCATION(e_LOC_INSIDE_PIT))
    JUMP_IF_TRUE(climb_into_pit,CHECK_PLAYER_LOCATION(e_LOC_OUTSIDE_PIT))
    JUMP_IF_TRUE(climb_up_to_window,CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM))
    JUMP_IF_TRUE(climb_down_from_window,CHECK_PLAYER_LOCATION(e_LOC_CELLAR_WINDOW))
    JUMP(_ErrorAlreadyPositioned_Elle)

climb_out_of_pit
    SET_PLAYER_LOCATION(e_LOC_OUTSIDE_PIT)
    END_AND_REFRESH
climb_into_pit
    SET_PLAYER_LOCATION(e_LOC_INSIDE_PIT)
    END_AND_REFRESH
climb_up_to_window
    SET_PLAYER_LOCATION(e_LOC_CELLAR_WINDOW)
    END_AND_REFRESH
climb_down_from_window
    SET_PLAYER_LOCATION(e_LOC_DARKCELLARROOM)
    END_AND_REFRESH

not_yet_attached
    JUMP_IF_TRUE(install_the_ladder,CHECK_PLAYER_LOCATION(e_LOC_INSIDE_PIT))
    JUMP_IF_TRUE(install_the_ladder,CHECK_PLAYER_LOCATION(e_LOC_OUTSIDE_PIT))
    JUMP_IF_TRUE(install_the_ladder,CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM))
    JUMP_IF_TRUE(ladder_too_short,CHECK_PLAYER_LOCATION(e_LOC_TILEDPATIO))
cannot_use_ladder_here
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("C'est inutile ici")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Kan ikke bruke det her")
#else
    ERROR_MESSAGE("Can't use it there")
#endif
    END_AND_REFRESH

ladder_too_short
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Bien trop courte pour ça.")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Altfor kort til det.")
#else
    ERROR_MESSAGE("Way too short for that.")
#endif
    END_AND_REFRESH

install_the_ladder

#ifdef LANGUAGE_FR
    INFO_MESSAGE("Bien, l'échelle est en place.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Så, stigen er på plass.")
#else
    INFO_MESSAGE("Right, ladder's in place.")
#endif    
    SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_CURRENT)
    SET_ITEM_FLAGS(e_ITEM_Ladder,ITEM_FLAG_ATTACHED)
#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"une _échelle prête à l'emploi")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"en _stige klar til bruk")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"a _ladder ready to climb")
#endif
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_THE_LADDER)
    END_AND_REFRESH
.)


_CombineRopeHole
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
                UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_THE_ROPE)
                GOSUB(_ShowGirlAtTheWindow)                          ; We show the girl...
#ifdef LANGUAGE_FR
                INFO_MESSAGE("Allez, c'est parti !")
#elif defined(LANGUAGE_NO)
                INFO_MESSAGE("Da så. Av gårde!")
#else
                INFO_MESSAGE("Right then. Off we go!")
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
                ERROR_MESSAGE("Faudrait d'abord attacher la corde.")
#elif defined(LANGUAGE_NO)
                ERROR_MESSAGE("Bør nok feste tauet først.")
#else
                ERROR_MESSAGE("Should probably tie it off first.")
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
#elif defined(LANGUAGE_NO)
            SET_ITEM_DESCRIPTION(e_ITEM_Rope,"et _tau i panikk rommet")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_Rope,"a _rope in the panic room")
#endif
            DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_HOLE)                                ; Draw the base image with the hole over an empty room
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

            BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_ROPE,11,94,11)    ; Draw the patch with the rope through the hole
                    _IMAGE_STRIDE(0,0,11)
                    _BUFFER(16,34)
            FADE_BUFFER      ; Make sure everything appears on the screen
            WAIT(50*2)
            ENDIF(rope_not_in_the_room)
        END_AND_REFRESH    
acid_hole_rope

    ; Else check the pit
    JUMP_IF_TRUE(inside_the_pit,CHECK_PLAYER_LOCATION(e_LOC_INSIDE_PIT))
    JUMP_IF_TRUE(around_the_pit,CHECK_PLAYER_LOCATION(e_LOC_OUTSIDE_PIT))
cannot_use_rope_here
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Pas utilisable ici")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Kan ikke bruke det her")
#else
    ERROR_MESSAGE("Can't use it there")
#endif    
    END_AND_REFRESH

; The rope is not possible to attach from the bottom of the pit
; The only situation you would see this message is if you also have the ladder, else that would be an instant game over
inside_the_pit
    ; If already attached, "use rope" means climb up out of the pit
    JUMP_IF_FALSE(rope_not_attached_in_pit,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
    SET_PLAYER_LOCATION(e_LOC_OUTSIDE_PIT)
    END_AND_REFRESH
rope_not_attached_in_pit
    GOSUB(_SubErrorTooHigh)
    END_AND_PARTIAL_REFRESH

around_the_pit
    ; If already attached, "use rope" means climb down into the pit
    JUMP_IF_FALSE(install_rope_on_tree,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
    SET_PLAYER_LOCATION(e_LOC_INSIDE_PIT)
    END_AND_REFRESH

+_CombineRopeTree
install_rope_on_tree
    ; "combine rope tree" when already attached just shows an error
    JUMP_IF_TRUE(_ErrorAlreadyPositioned_Elle,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))

#ifdef LANGUAGE_FR
    INFO_MESSAGE("Attachons la corde à l'arbre.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Fester tauet til treet.")
#else
    INFO_MESSAGE("Let's tie this to the tree.")
#endif    
    SET_ITEM_LOCATION(e_ITEM_Rope,e_LOC_OUTSIDE_PIT)
    SET_ITEM_FLAGS(e_ITEM_Rope,ITEM_FLAG_ATTACHED)
#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"une _corde attachée à un arbre")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"et _tau festet i treet")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"a _rope attached to a tree")
#endif
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_THE_ROPE)
    END_AND_REFRESH
.)


_UseGame
.(
    DISPLAY_IMAGE(LOADER_PICTURE_DONKEY_KONG_PLAYING)

    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_HandheldGame,ITEM_FLAG_TRANSFORMED),batteries)    ; Have the batteries been installed?
        // Functional game
        CALL_NATIVE(_PlayMonkeyKing)
    ELSE(batteries,no_batteries)
    // Non functional game
#ifdef LANGUAGE_FR
        INFO_MESSAGE("En panne. Manque de piles ?")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Dødt. Trenger nok batterier.")
#else
        INFO_MESSAGE("Dead. Probably needs batteries.")
#endif    
    ENDIF(no_batteries)
    END_AND_REFRESH
.)

_UseDartGun
    DISPLAY_IMAGE(LOADER_PICTURE_SHOOTING_DART)
    SET_ITEM_LOCATION(e_ITEM_DartGun,e_LOC_GONE_FOREVER)                      ; The player can only use the dart gun once
    PLAY_SOUND(_Swoosh)

    // - We are in the entrance hall and the dog is still alive
    JUMP_IF_FALSE(snoozed_dog,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_TRUE(snoozed_dog,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_DOG)
        INCREASE_SCORE(POINTS_DART_GUNNED_DOG)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Bonne nuit, le cabot...")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Natta, bansen...")
#else
        INFO_MESSAGE("Night-night, mutt...")
#endif    
        JUMP(_CommonDogDisabled)
snoozed_dog

    // - We are in the sleeping room and the thug is still alive
    JUMP_IF_FALSE(snoozed_thug,CHECK_PLAYER_LOCATION(e_LOC_MASTERBEDROOM))
    JUMP_IF_TRUE(snoozed_thug,CHECK_ITEM_FLAG(e_ITEM_Thug,ITEM_FLAG_DISABLED))
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_THUG)
        INCREASE_SCORE(POINTS_DART_GUNNED_THUG)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Dors bien, dur à cuire")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Sov godt, tøffing")
#else
        INFO_MESSAGE("Sweet dreams, sunshine...")
#endif    
        JUMP(_CommonThugDisabled)
snoozed_thug    
    END_AND_REFRESH


_UseKey
.(
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_DARKCELLARROOM),cellar)                    ; Are we in the cellar?
        GOSUB(_SubCheckToDark)     ; Was the tape removed from the window?
        IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_AlarmPanel,ITEM_FLAG_LOCKED),locked)        ; Is the alarm panel locked?
            PLAY_SOUND(_UseKeyOnAlarmPanel)
            UNSET_ITEM_FLAGS(e_ITEM_AlarmPanel,ITEM_FLAG_LOCKED)                   ; Unlock it!
            SET_ITEM_LOCATION(e_ITEM_SmallKey,e_LOC_GONE_FOREVER)                  ; We don't need the key anymore
            INCREASE_SCORE(POINTS_USED_KEY)
#ifdef LANGUAGE_FR                                                                             ; Update the description
            SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"une _centrale d'alarme déverrouillée")
            INFO_MESSAGE("La centrale est déverrouillée")
#elif defined(LANGUAGE_NO)
            SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"et ulåst alarm _panel")
            INFO_MESSAGE("Panelet er nå ulåst")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_AlarmPanel,"an unlocked alarm _panel")
            INFO_MESSAGE("The panel is now unlocked")
#endif
            WAIT(50*1)
            END_AND_PARTIAL_REFRESH
        ENDIF(locked)
    ENDIF(cellar)

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room)               ; Are we in front of the panic room?
        DISPLAY_IMAGE(LOADER_PICTURE_DOOR_DIGICODE)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("C'est une serrure numérique !")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Den bruker en digital lås!")
#else
        INFO_MESSAGE("It uses a digital lock!")
#endif    
        WAIT_KEYPRESS
        END_AND_REFRESH
    ENDIF(panic_room)

    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_FRONT_ENTRANCE),front_entrance)            ; Are we in front of the main entrance door of the house?
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Elle ne rentre pas")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Den passer ikke")
#else
        INFO_MESSAGE("It does not fit")
#endif    
        END_AND_PARTIAL_REFRESH
    ENDIF(front_entrance)

    JUMP(_ErrorCannotDo)
.)


_UseAlarmSwitch
.(
    PLAY_SOUND(_AlarmSwitchPressed)
    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED),on)                 ; Is the alarm active?
        SET_ITEM_FLAGS(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED)                           ; Disabled the alarm
        INCREASE_SCORE(POINTS_USED_SWITCH)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DISABLED_THE_ALARM)
#ifdef LANGUAGE_FR                                                                      ; Update the description
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"un _bouton en position arrêt")
        INFO_MESSAGE("L'alarme est désactivée")
#elif defined(LANGUAGE_NO)
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"en _bryter i AV-posisjon")
        INFO_MESSAGE("Alarmen er nå deaktivert")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"a _switch in OFF position")
        INFO_MESSAGE("The alarm is now disabled")
#endif
    ELSE(on,off)
        UNSET_ITEM_FLAGS(e_ITEM_AlarmSwitch,ITEM_FLAG_DISABLED)                         ; Enable the alarm 
+_gTextItemAlarmSwitch = *+2
#ifdef LANGUAGE_FR                                                                      ; Update the description
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"un _bouton en position marche")
        INFO_MESSAGE("L'alarme est activée")
#elif defined(LANGUAGE_NO)
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"en _bryter i PÅ-posisjon")
        INFO_MESSAGE("Alarmen er nå aktivert")
#else
        SET_ITEM_DESCRIPTION(e_ITEM_AlarmSwitch,"a _switch in ON position")
        INFO_MESSAGE("The alarm is now enabled")
#endif
    ENDIF(off)
    END_AND_REFRESH
.)


_CombineHoseTank
_UseHosePipe
.(
    JUMP_IF_TRUE(abandonned_car,CHECK_PLAYER_LOCATION(e_LOC_ABANDONED_CAR))
cannot_use_hose_here
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Pas utilisable ici")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Kan ikke bruke det her")
#else
    ERROR_MESSAGE("Can't use it there")
#endif    
    END_AND_PARTIAL_REFRESH

abandonned_car
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_CarTank,ITEM_FLAG_CLOSED),closed)                     ; Is the petrol tank open?
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Faut d'abord ouvrir le réservoir.")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Må åpne tanken først.")
#else
        ERROR_MESSAGE("Need to open the tank first.")
#endif        
        END_AND_PARTIAL_REFRESH
    ENDIF(closed)

    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Hose,ITEM_FLAG_ATTACHED),already_inside)
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Il est déjà dedans")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Den er allerede inni")
#else
        ERROR_MESSAGE("It's already inside")
#endif    
        END_AND_PARTIAL_REFRESH
    ELSE(already_inside,not_inside_yet)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Le tuyau dans le réservoir...")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Slangen i tanken...")
#else
        INFO_MESSAGE("Hose goes in the tank...")
#endif    
        SET_ITEM_LOCATION(e_ITEM_Hose,e_LOC_ABANDONED_CAR)
        SET_ITEM_FLAGS(e_ITEM_Hose,ITEM_FLAG_ATTACHED)
        IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_NONE),petrol)                           ; Is the petrol still not found?
            SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_ABANDONED_CAR)                                ; It's now visible inside the car
            GOSUB(_SubFoundSomething)
            GOSUB(_SubTankHasPetrol)
            WAIT_KEYPRESS
        ENDIF(petrol)
    ENDIF(not_inside_yet)

#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"un _tuyau dans le réservoir")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"en _slange i bensintanken")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"a _hose in the petrol tank")
#endif
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_HOSE)
    INCREASE_SCORE(POINTS_USED_HOSE)
    END_AND_REFRESH
.)



_CombinePowderMixWithMortar
_UseMortar
.(
    ; Is the powerder mix available around? If yes crush it!
    JUMP_IF_TRUE(made_gun_powder,CHECK_ITEM_LOCATION(e_ITEM_PowderMix,e_LOC_CURRENT))
    JUMP_IF_TRUE(made_gun_powder,CHECK_ITEM_LOCATION(e_ITEM_PowderMix,e_LOC_INVENTORY))

    ; Next we check the sedative pills: If they are around, and not already crushed, let's crash them!
    JUMP_IF_TRUE(cannot_use_mortar,CHECK_ITEM_FLAG(e_ITEM_SedativePills,ITEM_FLAG_TRANSFORMED))
    JUMP_IF_TRUE(_CombinePillsWithMortar,CHECK_ITEM_LOCATION(e_ITEM_SedativePills,e_LOC_CURRENT))
    JUMP_IF_TRUE(_CombinePillsWithMortar,CHECK_ITEM_LOCATION(e_ITEM_SedativePills,e_LOC_INVENTORY))

cannot_use_mortar
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Rien à moudre pour l'instant.")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Ingenting å male akkurat nå.")
#else
    ERROR_MESSAGE("Nothing to grind.")
#endif    
    END_AND_REFRESH

made_gun_powder
    SET_ITEM_LOCATION(e_ITEM_PowderMix,e_LOC_NONE)                       ; The rough powder mix is gone
    SET_ITEM_LOCATION(e_ITEM_GunPowder,e_LOC_CURRENT)                    ; We now have proper gun powder

    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_MADE_BLACK_POWDER)                    ; Achievement!    
    JUMP(_InspectGunPowder)
.)



_UseBomb
.(
    IF_FALSE(CHECK_PLAYER_LOCATION(e_LOC_CELLAR),cellar)
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Pas utilisable ici")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Kan ikke bruke det her")
#else
        ERROR_MESSAGE("I can't use it here")
#endif
        END_AND_REFRESH
    ENDIF(cellar)
    JUMP(_CombineStickyBombWithSafe)

.)


_UseAdhesive
.(
    ; If the bomb is available, we combine it autoamtically with the adhesive
    JUMP_IF_TRUE(_CombineBombWithAdhesive,CHECK_ITEM_LOCATION(e_ITEM_Bomb,e_LOC_CURRENT))
    JUMP_IF_TRUE(_CombineBombWithAdhesive,CHECK_ITEM_LOCATION(e_ITEM_Bomb,e_LOC_INVENTORY))
    JUMP(_ErrorCannotDo)
.)

_CombineBombWithMatches
_UseMatches
.(
    // If the user has any flammable items, kaboom!
    JUMP_IF_TRUE(_Kaboom,CHECK_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_CURRENT))
    JUMP_IF_TRUE(_Kaboom,CHECK_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_INVENTORY))
    JUMP_IF_TRUE(_Kaboom,CHECK_ITEM_LOCATION(e_ITEM_GunPowder,e_LOC_CURRENT))
    JUMP_IF_TRUE(_Kaboom,CHECK_ITEM_LOCATION(e_ITEM_GunPowder,e_LOC_INVENTORY))

    IF_FALSE(CHECK_PLAYER_LOCATION(e_LOC_CELLAR),cellar)
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Pas utilisable ici")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Kan ikke bruke det her")
#else
        ERROR_MESSAGE("I can't use it here")
#endif
        END_AND_PARTIAL_REFRESH
    ENDIF(cellar)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_ATTACHED),safe)
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Je devrais d'abord placer la bombe.")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Bør plassere bomben først.")
#else
        ERROR_MESSAGE("I should place the bomb first.")
#endif        
        END_AND_PARTIAL_REFRESH
    ENDIF(safe)
    SET_ITEM_FLAGS(e_ITEM_BoxOfMatches,ITEM_FLAG_TRANSFORMED)         ; Strike the matches!
    INCREASE_SCORE(POINTS_IGNITED_BOMB)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_OPENED_THE_SAFE)                   ; The player may not survive the operation, but the safe is definitely open at that point!
    END_AND_REFRESH
.)


_UseProtectionSuit
.(
    ; Check if we already have the suit equipped
    JUMP_IF_TRUE(_ErrorAlreadyEquipped_Elle,CHECK_ITEM_FLAG(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED))

#ifdef LANGUAGE_FR
    INFO_MESSAGE("Essayons-la...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("La oss prøve den...")
#else
    INFO_MESSAGE("Let's try it...")
#endif    
    DISPLAY_IMAGE(LOADER_PICTURE_SHOWING_GLOVES)
    PLAY_SOUND(_Zipper)
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room)
        ; The player is in front of the Panic Room, we can now equip the protection suit
#ifdef LANGUAGE_FR
        INFO_MESSAGE("...c'est la bonne taille !")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("...den passer perfekt!")
#else
        INFO_MESSAGE("...it fits perfectly!")
#endif        
        SET_ITEM_FLAGS(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED)
    ELSE(panic_room,not_panic_room)
        ; The player is anywhere else
        PLAY_SOUND(_Zipper)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("...mais pas besoin ici")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("...men den er til ingen nytte her")
#else
        INFO_MESSAGE("...but it's of no use here")
#endif        
    ENDIF(not_panic_room)
    END_AND_REFRESH
.)


_CombineClayDoor
_UseClay
.(
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_ATTACHED),attached)    ; Is the clay attached?
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("C'est déjà en place !")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Den er allerede på plass!")
#else
        ERROR_MESSAGE("It's already in place!")
#endif        
        END_AND_REFRESH
    ENDIF(attached)

    IF_FALSE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room)
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Pas utilisable ici")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Kan ikke bruke det her")
#else
        ERROR_MESSAGE("I can't use it here")
#endif        
        END_AND_REFRESH
    ENDIF(panic_room)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_TRANSFORMED),wet)    ; Is the clay wet?
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Trop sec. Il faut de l'eau.")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("For tørt. Trenger vann.")
#else
        ERROR_MESSAGE("Too dry. Needs water.")
#endif        
        END_AND_REFRESH
    ENDIF(wet)

    SET_ITEM_LOCATION(e_ITEM_Clay,e_LOC_PANIC_ROOM_DOOR)                ; The clay is now in the room
    SET_ITEM_FLAGS(e_ITEM_Clay,ITEM_FLAG_ATTACHED)                      ; The clay is now attached to the door
    INCREASE_SCORE(POINTS_USED_CLAY)

    DISPLAY_IMAGE(LOADER_PICTURE_DOOR_WITH_CLAY)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ok, ca devrait suffire...")
    INFO_MESSAGE("...plus qu'à remplir !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ok, det burde holde...")
    INFO_MESSAGE("...nå bare å fylle det!")
#else
    INFO_MESSAGE("Ok, that should be good enough...")
    INFO_MESSAGE("...now just need to fill it!")
#endif        
    END_AND_REFRESH
.)


_UseAcid
.(
    IF_FALSE(CHECK_PLAYER_LOCATION(e_LOC_PANIC_ROOM_DOOR),panic_room)    ; Are we in the proper location to use the acid?
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Pas utilisable ici")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Kan ikke bruke det her")
#else
        ERROR_MESSAGE("I can't use it here")
#endif        
        END_AND_REFRESH
    ENDIF(panic_room)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_Clay,ITEM_FLAG_ATTACHED),attached)    ; Is the clay attached?
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Il faudrait un barrage sinon")
        INFO_MESSAGE("l'acide va juste couler au sol")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Jeg trenger en barriere ellers")
        INFO_MESSAGE("vil syren bare renne på gulvet")
#else
        INFO_MESSAGE("I need some kind of barrier else")
        INFO_MESSAGE("the acid would spill everywhere")
#endif    
        END_AND_REFRESH
    ENDIF(attached)

    IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED),suit)    ; Is the protection suit equiped?
#ifdef LANGUAGE_FR
        ERROR_MESSAGE("Pas sans protection.")
#elif defined(LANGUAGE_NO)
        ERROR_MESSAGE("Ikke uten beskyttelse.")
#else
        ERROR_MESSAGE("Not without protection.")
#endif        
        END_AND_REFRESH
    ENDIF(suit)

    ; Cut scene, Action!
    DISPLAY_IMAGE(LOADER_PICTURE_DOOR_POURING_ACID)
    WAIT(50)
    PLAY_SOUND(_Acid)
    WAIT(50)
    DISPLAY_IMAGE(LOADER_PICTURE_DOOR_ACID_BURNING)
    WAIT(50*2)
    GOSUB(_DrawDoorWithHole)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Suffisamment large pour voir...")
    INFO_MESSAGE("...ou passer des objets ?")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Stort nok til å kikke gjennom...")
    INFO_MESSAGE("...eller sende gjenstander?")
#else
    INFO_MESSAGE("Large enough to peek through...")
    INFO_MESSAGE("...or even pass objects?")
#endif    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_USED_THE_ACID)

    SET_ITEM_LOCATION(e_ITEM_HoleInDoor,e_LOC_PANIC_ROOM_DOOR)            ; There is now a hole in the door
    SET_ITEM_LOCATION(e_ITEM_Clay,e_LOC_GONE_FOREVER)                     ; The clay has vanished
    SET_ITEM_LOCATION(e_ITEM_Acid,e_LOC_GONE_FOREVER)                     ; The acid is gone as well
    SET_ITEM_LOCATION(e_ITEM_ProtectionSuit,e_LOC_GONE_FOREVER)           ; We don't need the protection suit
    UNSET_ITEM_FLAGS(e_ITEM_ProtectionSuit,ITEM_FLAG_ATTACHED)            ; 

    END_AND_REFRESH
.)


_UseFancyStones
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Elles sont seulement décoratives.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("De er bare dekorative.")
#else
    INFO_MESSAGE("They are just light porous fakes.")
#endif    
    END_AND_PARTIAL_REFRESH
.)


_UseComputer
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il semble être verrouillé.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Den ser ut til å være låst.")
#else
    INFO_MESSAGE("It appears to be boot locked.")
#endif    
    END_AND_PARTIAL_REFRESH
.)


_UseGameConsole
.(
    DISPLAY_IMAGE(LOADER_PICTURE_COLECOVISION)
+_UseTelevision
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Tentant, mais j'ai du boulot.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Fristende, men jeg har en jobb.")
#else
    INFO_MESSAGE("Tempting, but I'm working.")
#endif
    WAIT_KEYPRESS    
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
    VALUE_MAPPING(e_ITEM_HeavySafe          , _SearchSafe)
    VALUE_MAPPING(e_ITEM_Car                , _SearchCar)
    VALUE_MAPPING(e_ITEM_PlasticBag         , _SearchPlasticBag)
    VALUE_MAPPING(e_ITEM_Trashcan           , _SearchTrashCan)
    VALUE_MAPPING(e_ITEM_CardboardBox       , _SearchCardboardBox)
    VALUE_MAPPING(e_ITEM_TobaccoTin         , _SearchTin)
    VALUE_MAPPING(e_ITEM_TVCabinet          , _SearchTVCabinet)
    VALUE_MAPPING(e_ITEM_Drawer             , _SearchDrawer)
    VALUE_MAPPING(255                       , _SearchFallbackToInspect)  ; Default: try the inspect handler

; If there's no dedicated search handler for an item, try the inspect handler instead.
; This way SEARCH and LOOK/INSPECT behave the same for items that don't need special search logic.
_SearchFallbackToInspect
    CALL_NATIVE(_RedispatchToInspect)
    END_AND_PARTIAL_REFRESH

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
        INFO_MESSAGE("J'aurais dû le maitriser d'abord.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Burde overmannet ham først.")
#else
        INFO_MESSAGE("Should have dealt with him first.")
#endif    
        DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(4,33),40,_SecondImageBuffer+40*24+13,_ImageBuffer+(40*52)+31)      ; Erase the head of the sleeping thug
        DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(18,105),40,_SecondImageBuffer+40*23+22,_ImageBuffer+(40*21)+13)    ; Draw the attacking thug
        DRAW_BITMAP(LOADER_SPRITE_THUG,BLOCK_SIZE(13,56),40,_SecondImageBuffer+40*34+0,_ImageBuffer+(40*1)+23)       ; Now You Die!
        FADE_BUFFER
        PLAY_SOUND(_ShootData)
        ; Draw the message
        WAIT(50*2)                              ; Wait a couple seconds
        PLAY_SOUND(_ShootData)
        WHITE_BUBBLE(2)
#ifdef LANGUAGE_FR
        _BUBBLE_LINE(5,5,0,"C'était une erreur:")
        _BUBBLE_LINE(60,16,0,"Ma dernière")
#elif defined(LANGUAGE_NO)
        _BUBBLE_LINE(5,5,0,"Dette var en feil:")
        _BUBBLE_LINE(60,13,3,"Min siste")
#else
        _BUBBLE_LINE(5,5,0,"This was a mistake:")
        _BUBBLE_LINE(60,16,0,"My last one")
#endif        
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
    ERROR_MESSAGE("Déjà fouillé.")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Allerede ransaket ham.")
#else
    ERROR_MESSAGE("Already searched him.")
#endif    
    END_AND_PARTIAL_REFRESH

found_items
    SET_ITEM_LOCATION(e_ITEM_Pistol,e_LOC_MASTERBEDROOM)
    SET_ITEM_LOCATION(e_ITEM_SmallKey,e_LOC_MASTERBEDROOM)
    GOSUB(_SubFoundSomething)
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
    VALUE_MAPPING(e_ITEM_Apple              , _ThrowApples)
    VALUE_MAPPING(e_ITEM_Meat               , _ThrowMeat)
    VALUE_MAPPING(e_ITEM_SilverKnife        , _ThrowKnife)
    VALUE_MAPPING(e_ITEM_SnookerCue         , _ThrowSnookerCue)
    VALUE_MAPPING(e_ITEM_Rope               , _ThrowRope)
    VALUE_MAPPING(e_ITEM_LargeDove          , _ThrowDove)
    VALUE_MAPPING(e_ITEM_Net                , _ThrowNet)
    VALUE_MAPPING(e_ITEM_CardboardBox       , _ThrowCardboardBox)
    VALUE_MAPPING(255                       , _ThrowCurrentItem)  ; Default option

_DropBread
_ThrowBread
    // By default we just drop the bread where we are
    SET_ITEM_LOCATION(e_ITEM_Bread,e_LOC_CURRENT)
    GOSUB(_SubBreadCommon)
    END_AND_REFRESH


_UseBread
    GOSUB(_SubBreadCommon)
    JUMP(_ErrorCannotDo)


_SubBreadCommon
.(
    // Are we at the fish pond?
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_FISHPND),at_the_fish_pond)
        // The fish eat the crumbs
        SET_ITEM_LOCATION(e_ITEM_Bread,e_LOC_GONE_FOREVER)
        INCREASE_SCORE(POINTS_GAVE_BREAD_TO_FISH)
        PLAY_SOUND(_Swoosh)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Les poissons mangent les miettes")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Fiskene spiser smulene")
#else
        INFO_MESSAGE("The fish eat the crumbs")
#endif    
        END_AND_PARTIAL_REFRESH
    ENDIF(at_the_fish_pond)

    // Are we in the woods?
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_WOODEDAVENUE),in_the_woods)
        SET_ITEM_LOCATION(e_ITEM_Bread,e_LOC_CURRENT)
        // Is the dove still there?
        IF_FALSE(CHECK_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_GONE_FOREVER),dove_present)
            // The bird is now possible to catch
            INCREASE_SCORE(POINTS_GAVE_BREAD_TO_DOVE)
            PLAY_SOUND(_Swoosh)
#ifdef LANGUAGE_FR
            SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"une _colombe qui picore")
#elif defined(LANGUAGE_NO)
            SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"en _due som spiser brødsmuler")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"a _dove eating bread crumbs")
#endif
            GOSUB(_SubDoveEating)
            END_AND_REFRESH
        ENDIF(dove_present)
    ENDIF(in_the_woods)

    RETURN
.)



_ThrowApples
    // By default we just drop the apples where we are
    SET_ITEM_LOCATION(e_ITEM_Apple,e_LOC_CURRENT)
    GOSUB(_SubApplesCommon)
    END_AND_PARTIAL_REFRESH


_UseApples
.(
    GOSUB(_SubApplesCommon)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Pas mauvaises du tout.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ikke verst.")
#else
    INFO_MESSAGE("Not bad at all.")
#endif    
    GOSUB(_SubResetApplesLocation)
    END_AND_PARTIAL_REFRESH
.)


_SubApplesCommon
.(
    // Are we at the fish pond?
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_FISHPND),at_the_fish_pond)
        // The fish don't like the apples, whole or cut
        PLAY_SOUND(_Swoosh)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Difficiles, ces poissons.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Kresne, disse fiskene.")
#else
        INFO_MESSAGE("Fussy lot, these fish.")
#endif    
        END_AND_PARTIAL_REFRESH
    ENDIF(at_the_fish_pond)

    // Are we in the woods?
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_WOODEDAVENUE),in_the_woods)
        // Is the dove still there?
        IF_FALSE(CHECK_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_GONE_FOREVER),dove_present)
            SET_ITEM_LOCATION(e_ITEM_Apple,e_LOC_CURRENT)
            // Are the apples cut?
            IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Apple,ITEM_FLAG_TRANSFORMED),apple_cut)
                // The bird is now possible to catch
                INCREASE_SCORE(POINTS_GAVE_APPLES_TO_DOVE)
                PLAY_SOUND(_Swoosh)
#ifdef LANGUAGE_FR
                SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"une _colombe mange des morceaux")
#elif defined(LANGUAGE_NO)
                SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"en _due som spiser eplebiter")
#else
                SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"a _dove eating apple chunks")
#endif
                GOSUB(_SubDoveEating)
                END_AND_REFRESH
            ELSE(apple_cut,apple_not_cut)
                // The bird is not interested by an uncut apple
#ifdef LANGUAGE_FR
                INFO_MESSAGE("Pas intéressée. Oiseau difficile.")
#elif defined(LANGUAGE_NO)
                INFO_MESSAGE("Ikke interessert. Kresen fugl.")
#else
                INFO_MESSAGE("Not interested. Fussy bird.")
#endif    
                END_AND_PARTIAL_REFRESH
            ENDIF(apple_not_cut)
        ENDIF(dove_present)
    ENDIF(in_the_woods)
    RETURN
.)


_SubDoveEating
.(
    DISPLAY_IMAGE(LOADER_PICTURE_DOVE_EATING_BREADCRUMBS)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il me faut de quoi l'attraper...")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Jeg trenger noe å fange den med...")
#else
    INFO_MESSAGE("I need something to catch it...")
#endif    
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
    DISPLAY_IMAGE(LOADER_PICTURE_DOG_EATING_MEAT)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Mieux le rôti que ma jambe.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Bedre kjøttet enn beinet mitt.")
#else
    INFO_MESSAGE("Better the meat than my leg.")
#endif    
    SET_ITEM_LOCATION(e_ITEM_Meat,e_LOC_GONE_FOREVER)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DOG_ATE_THE_MEAT)
    JUMP_IF_FALSE(done,CHECK_ITEM_FLAG(e_ITEM_Meat,ITEM_FLAG_TRANSFORMED))  // Is the meat drugged?
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_DRUGGED_THE_DOG)
    INCREASE_SCORE(POINTS_DRUGGED_DOG)
    JUMP(_CommonDogDisabled)
done
    END_AND_REFRESH

nothing_to_eat_the_meat
    RETURN
 .)


_UseDove
_ThrowDove
_DropDove
_FreeDove
.(    
    CLEAR_TEXT_AREA(4)
    // When left anywhere, the dove will manage to fly away
#ifdef LANGUAGE_FR
    INFO_MESSAGE("La colombe s'échappe")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Duen flyr bort")
#else
    INFO_MESSAGE("The dove flies away")
#endif    
    SET_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_GONE_FOREVER)                 ; No mater where we use the DOVE, it will be out of the game definitely.
    // The dog will only chase the dove if the dog is where we are and is still alive and kicking
    JUMP_IF_FALSE(nothing_to_chase_the_dove,CHECK_ITEM_LOCATION(e_ITEM_Dog,e_LOC_CURRENT))
    JUMP_IF_TRUE(nothing_to_chase_the_dove,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
        DISPLAY_IMAGE(LOADER_PICTURE_DOG_CHASING_DOVE)            ; Show the picture with the dog running after the dove
        LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Pourvu qu'il attrape pas l'oiseau")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Bare han ikke tar fuglen...")
#else
        INFO_MESSAGE("Better not catch the bird...")
#endif        
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_CHASED_THE_DOG)
        INCREASE_SCORE(POINTS_DOG_CHASED_DOVE)
        SET_ITEM_LOCATION(e_ITEM_Dog,e_LOC_GONE_FOREVER)           ; And the dog is now gone forever
        SET_ITEM_FLAGS(e_ITEM_Dog,ITEM_FLAG_DISABLED)              ; And just to make scripting easier, mark it as out of commission
        STOP_MUSIC()
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

    // - We have some apples and we want to cut them down
    JUMP_IF_TRUE(apple_knife,CHECK_ITEM_FLAG(e_ITEM_Apple,ITEM_FLAG_TRANSFORMED))
    JUMP_IF_TRUE(_SliceApples,CHECK_ITEM_LOCATION(e_ITEM_Apple,e_LOC_INVENTORY))
    JUMP_IF_TRUE(_SliceApples,CHECK_ITEM_LOCATION(e_ITEM_Apple,e_LOC_CURRENT))
apple_knife

    RETURN
.)


_CombineKnifeApple
_SliceApples
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Découpons les pommes...")
    INFO_MESSAGE("...parfait pour un clafoutis.")
    SET_ITEM_DESCRIPTION(e_ITEM_Apple,"des$_pommes en morceaux")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("La meg skjære opp eplene...")
    INFO_MESSAGE("...perfekt til en eplekake.")
    SET_ITEM_DESCRIPTION(e_ITEM_Apple,"noen$_epler i biter")
#else
    INFO_MESSAGE("Let's chop these apples...")
    INFO_MESSAGE("...perfect for a clafoutis.")
    SET_ITEM_DESCRIPTION(e_ITEM_Apple,"chopped _apples")   // SET_ITEM_DESCRIPTION(e_ITEM_Apple,"$chopped _apples") ???? (space in the description)
#endif
    SET_ITEM_FLAGS(e_ITEM_Apple,ITEM_FLAG_TRANSFORMED)
    WAIT_KEYPRESS
    END_AND_PARTIAL_REFRESH
.)


_ScareDoveAway
.(
    CLEAR_TEXT_AREA(5)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Bravo. La colombe s'est envolée.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Flott. Skremte duen vekk.")
#else
    INFO_MESSAGE("Brilliant. Scared the dove off.")
#endif    
    SET_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_GONE_FOREVER)
    WAIT_KEYPRESS
    END_AND_REFRESH
.)        



_ThrowCardboardBox
.(
    // If the dove is in the box then we need to free it
    JUMP_IF_TRUE(_DropDove,CHECK_ITEM_CONTAINER(e_ITEM_LargeDove,e_ITEM_CardboardBox))

    // By default we just drop the net where we are even if just trying to use it
    SET_ITEM_LOCATION(e_ITEM_CardboardBox,e_LOC_CURRENT)

    END_AND_PARTIAL_REFRESH
.)


_TakeNet
.(
    // Take the net first
    SET_ITEM_LOCATION(e_ITEM_Net,e_LOC_INVENTORY)

    // If the dove is caught (at same location and not immovable), it flies away
    JUMP_IF_FALSE(no_dove,CHECK_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_CURRENT))
    JUMP_IF_FALSE(_DropDove,CHECK_ITEM_FLAG(e_ITEM_LargeDove,ITEM_FLAG_IMMOVABLE))
no_dove
    END_AND_PARTIAL_REFRESH
.)

_ThrowNet
_UseNet
.(
    // We can use the net to trap the dove in the wooded avenue if she is on the ground eating the bread or the apples
    JUMP_IF_FALSE(end_dove_net,CHECK_PLAYER_LOCATION(e_LOC_WOODEDAVENUE))
    JUMP_IF_FALSE(end_dove_net,CHECK_ITEM_LOCATION(e_ITEM_LargeDove,e_LOC_WOODEDAVENUE))
    JUMP_IF_TRUE(dove_net,CHECK_ITEM_LOCATION(e_ITEM_Bread,e_LOC_WOODEDAVENUE))
    JUMP_IF_FALSE(_ImmovableDove,CHECK_ITEM_LOCATION(e_ITEM_Apple,e_LOC_WOODEDAVENUE))  ; If the dove is still in the tree, indicate we can't do that
    JUMP_IF_FALSE(_ImmovableDove,CHECK_ITEM_FLAG(e_ITEM_Apple,ITEM_FLAG_TRANSFORMED))   ; If the dove is still in the tree, indicate we can't do that
dove_net
        SET_ITEM_LOCATION(e_ITEM_Net,e_LOC_CURRENT)                      ; Only useful for the Use Net, else it stays in the inventory
        INCREASE_SCORE(POINTS_CAPTURED_THE_DOVE)
        UNLOCK_ACHIEVEMENT(ACHIEVEMENT_CAPTURED_THE_DOVE)
        UNSET_ITEM_FLAGS(e_ITEM_LargeDove,ITEM_FLAG_IMMOVABLE)
        PLAY_SOUND(_Swoosh)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("La colombe est prise dans le filet")
        SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"une _colombe empêtrée")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Duen er fanget i nettet")
        SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"en _due som sitter fast")
#else
        INFO_MESSAGE("The dove is caught in the net")
        SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"a stuck _dove")
#endif
        END_AND_REFRESH
end_dove_net

    // If the player tries to trap the fish we just display some error message
    JUMP_IF_TRUE(_ImmovableNoFishing,CHECK_PLAYER_LOCATION(e_LOC_FISHPND))

    // If the player tries to trap the dog we just display some error message
    JUMP_IF_FALSE(end_dog_net,CHECK_PLAYER_LOCATION(e_LOC_ENTRANCEHALL))
    JUMP_IF_FALSE(_ErrorTooRisky,CHECK_ITEM_FLAG(e_ITEM_Dog,ITEM_FLAG_DISABLED))
end_dog_net

    // If the dove is in the net then we need to free it
    JUMP_IF_TRUE(_DropDove,CHECK_ITEM_CONTAINER(e_ITEM_LargeDove,e_ITEM_Net))

    // By default we just drop the net where we are even if just trying to use it
    JUMP(_ErrorNothingToCatch)
.)


_ErrorTooRisky
.(
    CLEAR_TEXT_AREA(5)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ça vaut pas le risque.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ikke verdt risikoen.")
#else
    INFO_MESSAGE("Not worth the risk.")
#endif    
    END_AND_REFRESH
.)


_ErrorNothingToCatch
.(
    CLEAR_TEXT_AREA(5)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Rien à attraper !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Ingenting å fange!")
#else
    INFO_MESSAGE("Nothing to catch!")
#endif    
    END_AND_REFRESH
.)




_ThrowSnookerCue
    // By default we just drop the cue where we are
    SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOC_CURRENT)
    GOSUB(SnookerCueCommon)
    END_AND_REFRESH

_UseSnookerCue
.(
    JUMP_IF_FALSE(game_room,CHECK_PLAYER_LOCATION(e_LOC_GAMESROOM))
#ifdef LANGUAGE_FR
        INFO_MESSAGE("Pas le temps. Au boulot.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Ikke tid. Fokus.")
#else
        INFO_MESSAGE("No time for that. Focus.")
#endif    
        END_AND_REFRESH
game_room
    GOSUB(SnookerCueCommon)
    JUMP(_ErrorCannotDo)
.)

_CombineQueueHole
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
                INFO_MESSAGE("La queue brise le carreau")
#elif defined(LANGUAGE_NO)
                INFO_MESSAGE("Kølla knuser vindusruten")
#else
                INFO_MESSAGE("The cue smashes a window pane")
#endif    
                GOSUB(_ShowBrokenWindow)
                SET_ITEM_FLAGS(e_ITEM_PanicRoomWindow,ITEM_FLAG_DISABLED)   ; The window is now broken
                SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOC_GONE_FOREVER)     ; We don't need the cue anymore
                INCREASE_SCORE(POINTS_SMASHED_WINDOW_WITH_CUE)
            ELSE(window_open,window_closed)
                ; The window is closed
#ifdef LANGUAGE_FR
                ERROR_MESSAGE("La fenêtre est toujours fermée!")
#elif defined(LANGUAGE_NO)
                ERROR_MESSAGE("Bør nok åpne vinduet først!")
#else
                ERROR_MESSAGE("Should open the window first!")
#endif
            ENDIF(window_closed)
        ELSE(cue_in_the_room,cue_not_in_the_room)
            ; If the cue is not in the room, we pass it to the girl through the hole
            SET_ITEM_LOCATION(e_ITEM_SnookerCue,e_LOC_CURRENT)    
            SET_ITEM_FLAGS(e_ITEM_SnookerCue,ITEM_FLAG_IMMOVABLE)
#ifdef LANGUAGE_FR
            SET_ITEM_DESCRIPTION(e_ITEM_SnookerCue,"une _queue de billard dans la chambre forte")
#elif defined(LANGUAGE_NO)
            SET_ITEM_DESCRIPTION(e_ITEM_SnookerCue,"en snooker _kølle i sikkerhetsrommet")
#else
            SET_ITEM_DESCRIPTION(e_ITEM_SnookerCue,"a snooker _cue in the panic room")
#endif
            DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_HOLE)     ; Draw the base image with the hole over an empty room
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
    SET_ITEM_DESCRIPTION(e_ITEM_Dog,"un _chien inanimé")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Dog,"en bevisstløs _hund")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Dog,"a lying _dog")
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
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Thug,"en bevisstløs _skurk")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Thug,"an unresponsive _thug")
#endif
    LOAD_MUSIC(LOADER_MUSIC_SUCCESS)
    WAIT(50*2)
    STOP_MUSIC()
    END_AND_REFRESH
.)


_CombineKnifeHole
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
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Kniven passer gjennom hullet...")
#else
    INFO_MESSAGE("The knife fits the hole...")
#endif    
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_GAVE_THE_KNIFE)
    UNSET_ITEM_FLAGS(e_ITEM_YoungGirl,ITEM_FLAG_DISABLED)

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
    VALUE_MAPPING(e_ITEM_Net               , _TakeNet)
    VALUE_MAPPING(e_ITEM_MixTape           , _TakeMixTape)
    VALUE_MAPPING(e_ITEM_DuneBook          , _TakeDuneBook)
    VALUE_MAPPING(e_ITEM_HandheldGame      , _TakeHandheldGame)
    VALUE_MAPPING(255                      , _TakeCommon)     ; Default option


_TakeRope
.(
+_gTextItemRope = *+2
#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"une$_corde")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"et$_tau")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Rope,"a$_rope")
#endif
    JUMP(_TakeCommon)
.)


_TakeLadder
.(
+_gTextItemLadder = *+2
#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"une$_échelle courte")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"en$kort _stige")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Ladder,"a short$_ladder")
#endif
    JUMP(_TakeCommon)
.)


_TakeDove
.(
+_gTextItemLargeDove = *+2
#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"une$_colombe")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"en$_due")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_LargeDove,"a$_dove")
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
    INFO_MESSAGE("En lambeaux. Inutilisable.")
    SET_ITEM_DESCRIPTION(e_ITEM_CellarWindow,"une _fenêtre")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Revet i filler. Ubrukelig nå.")
    SET_ITEM_DESCRIPTION(e_ITEM_CellarWindow,"et _vindu")
#else
    INFO_MESSAGE("Ripped to shreds. No use now.")
    SET_ITEM_DESCRIPTION(e_ITEM_CellarWindow,"a _window")
#endif
    GOSUB(_SubSetLockedPanelDescription)
    END_AND_REFRESH
.)


_InspectAcid
.(
    GOSUB(_SubInspectAcid)
    END_AND_REFRESH
.)

_TakeAcid
.(
    GOSUB(_SubInspectAcid)
    JUMP(_TakeCommon)
.)

_SubInspectAcid
.(
    DISPLAY_IMAGE(LOADER_PICTURE_CORROSIVE_LIQUID)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Ce truc est super dangereux !")
    INFO_MESSAGE("...ca pourrait couler un navire !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Dette er svært farlig stoff!")
    INFO_MESSAGE("...kan gå gjennom et skips skrog!")
#else
    INFO_MESSAGE("This stuff is highly dangerous!")
    INFO_MESSAGE("...could go through a ship's hull!")
#endif
    WAIT_KEYPRESS
    RETURN
.)




_TakeHose
.(
+_gTextItemHose = *+2
#ifdef LANGUAGE_FR
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"un$_tuyau")
#elif defined(LANGUAGE_NO)
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"en$_slange")
#else
    SET_ITEM_DESCRIPTION(e_ITEM_Hose,"a$_hose")
#endif
    ; If the petrol was in the scene, then we hide it until the player puts the hose again
    IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_ABANDONED_CAR),petrol)
        SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_NONE)
    ENDIF(petrol)
    JUMP(_TakeCommon)
.)




_TakeCommon
.(
    SET_ITEM_LOCATION(e_ITEM_CURRENT, e_LOC_INVENTORY)  ; The item is now in our inventory
    UNSET_ITEM_FLAGS(e_ITEM_CURRENT, ITEM_FLAG_ATTACHED)     ; If the item was attached, we detach it
    JUMP_IF_TRUE(visible_item, CHECK_ITEM_FLAG(e_ITEM_CURRENT, ITEM_FLAG_VISIBLE_IN_SCENE))
        END_AND_PARTIAL_REFRESH
visible_item
    END_AND_REFRESH
.)


/* MARK: Immovable 🛄

██╗███╗   ███╗███╗   ███╗ ██████╗ ██╗   ██╗ █████╗ ██████╗ ██╗     ███████╗  
██║████╗ ████║████╗ ████║██╔═══██╗██║   ██║██╔══██╗██╔══██╗██║     ██╔════╝  
██║██╔████╔██║██╔████╔██║██║   ██║██║   ██║███████║██████╔╝██║     █████╗    
██║██║╚██╔╝██║██║╚██╔╝██║██║   ██║╚██╗ ██╔╝██╔══██║██╔══██╗██║     ██╔══╝    
██║██║ ╚═╝ ██║██║ ╚═╝ ██║╚██████╔╝ ╚████╔╝ ██║  ██║██████╔╝███████╗███████╗  
╚═╝╚═╝     ╚═╝╚═╝     ╚═╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝  */

; Dispatched when trying to TAKE an immovable item.
; Allows custom messages explaining why items can't be taken.
_gImmovableItemMappingsArray
    VALUE_MAPPING(e_ITEM_LargeDove         , _ImmovableDove)
    VALUE_MAPPING(e_ITEM_Dog               , _ImmovableLiving)
    VALUE_MAPPING(e_ITEM_Thug              , _ImmovableLiving)
    VALUE_MAPPING(e_ITEM_YoungGirl         , _ImmovableLiving)
    VALUE_MAPPING(e_ITEM_HeavySafe         , _ImmovableTooHeavy)
    VALUE_MAPPING(e_ITEM_Fridge            , _ImmovableTooHeavy)
    VALUE_MAPPING(e_ITEM_Car               , _ImmovableTooHeavy)
    VALUE_MAPPING(e_ITEM_TVCabinet         , _ImmovableTooHeavy)
    VALUE_MAPPING(e_ITEM_CellarWindow      , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_NormalWindow      , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_Medicinecabinet   , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_Curtain           , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_GunCabinet        , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_AlarmSwitch       , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_AlarmPanel        , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_SecurityDoor      , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_UnitedKingdomMap  , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_AlarmIndicator    , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_Rope              , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_Drawer            , _ImmovableAttached)
    VALUE_MAPPING(e_ITEM_CarBoot           , _ImmovablePartOfCar)
    VALUE_MAPPING(e_ITEM_CarDoor           , _ImmovablePartOfCar)
    VALUE_MAPPING(e_ITEM_CarTank           , _ImmovablePartOfCar)
    VALUE_MAPPING(e_ITEM_Tombstone         , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_HoleInDoor        , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_Church            , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_Well              , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_Tree              , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_FishPond          , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_FrontDoor         , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_PanicRoomWindow   , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_Graffiti          , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_RoadSign          , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_Pit               , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_Heap              , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_Trashcan          , _ImmovableNotSerious)
    VALUE_MAPPING(e_ITEM_Fish              , _ImmovableNoFishing)
    VALUE_MAPPING(e_ITEM_Computer          , _ImmovableNoStealing)
    VALUE_MAPPING(e_ITEM_Television        , _ImmovableNoStealing)
    VALUE_MAPPING(e_ITEM_Oric              , _ImmovableNoStealing)
    VALUE_MAPPING(e_ITEM_GameConsole       , _ImmovableNoStealing)
    VALUE_MAPPING(255                      , _ImmovableDefault)   ; Default: generic message


_ImmovableDove
.(
    ; Is the dove on the ground eating? (bread or cut apples present)
    JUMP_IF_TRUE(_ScareDoveAway,CHECK_ITEM_LOCATION(e_ITEM_Bread,e_LOC_WOODEDAVENUE))
    JUMP_IF_TRUE(_ScareDoveAway,CHECK_ITEM_LOCATION(e_ITEM_Apple,e_LOC_WOODEDAVENUE))
    ; Dove is still up in the tree
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("La colombe est hors de portée")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Duen er utenfor rekkevidde")
#else
    ERROR_MESSAGE("The dove is out of reach")
#endif
    END_AND_PARTIAL_REFRESH
.)


_ImmovableLiving
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Il vaut mieux ne pas essayer...")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Bedre å ikke prøve...")
#else
    ERROR_MESSAGE("Better not try that...")
#endif
    END_AND_PARTIAL_REFRESH


_ImmovableTooHeavy
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("C'est bien trop lourd")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Det er altfor tungt")
#else
    ERROR_MESSAGE("That's way too heavy")
#endif
    END_AND_PARTIAL_REFRESH


_ImmovableAttached
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("C'est solidement fixé")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Det sitter godt fast")
#else
    ERROR_MESSAGE("It's firmly attached")
#endif
    END_AND_PARTIAL_REFRESH


_ImmovablePartOfCar
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Ça fait partie de la voiture")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Det er en del av bilen")
#else
    ERROR_MESSAGE("It's part of the car")
#endif
    END_AND_PARTIAL_REFRESH


_ImmovableNotSerious
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("C'est pas sérieux...")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Det er ikke seriøst...")
#else
    ERROR_MESSAGE("Seriously?")
#endif
    END_AND_PARTIAL_REFRESH


_ImmovableNoFishing
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Jamais aimé la pêche...")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Aldri likt å fiske...")
#else
    ERROR_MESSAGE("Never did like fishing...")
#endif
    END_AND_PARTIAL_REFRESH


_ImmovableNoStealing
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Doucement. Je suis pas un voleur.")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Rolig nå. Jeg er ingen tyv.")
#else
    ERROR_MESSAGE("Steady on. I'm no thief.")
#endif
    END_AND_PARTIAL_REFRESH


_ImmovableDefault
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Je ne peux pas faire ça")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Jeg kan ikke gjøre det")
#else
    ERROR_MESSAGE("I can't do that")
#endif
    END_AND_PARTIAL_REFRESH





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
    VALUE_MAPPING(e_ITEM_LargeDove      , _DropDove)
    VALUE_MAPPING(e_ITEM_Bread          , _DropBread)
    VALUE_MAPPING(255                   , _DropCurrentItem)  ; Default option


_DropWater
.(
    SET_ITEM_LOCATION(e_ITEM_Water,e_LOC_WELL)             ; Put back the water into the well
#ifdef LANGUAGE_FR
    INFO_MESSAGE("L'eau s'écoule")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Vannet renner bort")
#else
    INFO_MESSAGE("The water drains away")
#endif    
    END_AND_REFRESH
.)


_DropPetrol
.(
    ; Depending if the hose is still in the tank or not we show or not the petrol still in the tank
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Hose,ITEM_FLAG_ATTACHED),hose)       ; Is the hose in the tank?
        SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_ABANDONED_CAR)            ; It's now visible inside the car
    ELSE(hose,no_hose)
        SET_ITEM_LOCATION(e_ITEM_Petrol,e_LOC_NONE)                     ; The petrol goes back to the car, or maybe vanishes, need to see what's best
    ENDIF(no_hose)

    ; Are we at the car location?
    IF_TRUE(CHECK_PLAYER_LOCATION(e_LOC_ABANDONED_CAR),car)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("L'essence retourne au réservoir.")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Bensinen tilbake i tanken.")
#else
        INFO_MESSAGE("Petrol back in the tank.")
#endif
    ELSE(car,no_car)
#ifdef LANGUAGE_FR
        INFO_MESSAGE("L'essence s'évapore")
#elif defined(LANGUAGE_NO)
        INFO_MESSAGE("Bensinet fordamper")
#else
        INFO_MESSAGE("The petrol evaporates")
#endif    
    ENDIF(no_car)
    END_AND_PARTIAL_REFRESH
.)


_ThrowCurrentItem
.(
    ; Check to see if the item is already in the scene.
    ; If it is, we show a generic "can't do that" error message, this way we can't throw "windows" or "the girl"
    JUMP_IF_TRUE(_ErrorCannotDo,CHECK_ITEM_LOCATION(e_ITEM_CURRENT,e_LOC_CURRENT))
+_DropCurrentItem
    SET_ITEM_LOCATION(e_ITEM_CURRENT,e_LOC_CURRENT)
    UNSET_ITEM_FLAGS(e_ITEM_CURRENT, ITEM_FLAG_ATTACHED)     ; If the item was attached, we detach it
    JUMP_IF_TRUE(visible_item, CHECK_ITEM_FLAG(e_ITEM_CURRENT, ITEM_FLAG_VISIBLE_IN_SCENE))
        END_AND_PARTIAL_REFRESH
visible_item
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
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Jeg kan ikke gjøre det")
#else
    ERROR_MESSAGE("I can't do that")
#endif    
    END_AND_PARTIAL_REFRESH
.)


_ErrorCannotRead
.(
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Je ne peux pas lire ça")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Jeg kan ikke lese det")
#else
    ERROR_MESSAGE("I can't read that")
#endif    
    END_AND_PARTIAL_REFRESH
.)

_MessageNothingSpecial
.(
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Rien à signaler.")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Ingenting verdt å nevne.")
#else
    ERROR_MESSAGE("Nothing worth mentioning.")
#endif    
    END_AND_PARTIAL_REFRESH
.)


_SubMessageDoorIsLocked
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("La porte est verrouillée")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Døren er låst")
#else
    INFO_MESSAGE("Door's locked tight.")
#endif
    RETURN
.)


_ErrorAlreadyOpen_Il
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Il est déjà ouvert")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Den er allerede åpen")
#else
    ERROR_MESSAGE("It's already open")
#endif
    END_AND_PARTIAL_REFRESH


_ErrorAlreadyOpen_Elle
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Elle est déjà ouverte")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Den er allerede åpen")
#else
    ERROR_MESSAGE("It's already open")
#endif        
    END_AND_PARTIAL_REFRESH


_ErrorAlreadyClosed_Il
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Il est déjà fermé")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Den er allerede lukket")
#else
    ERROR_MESSAGE("It's already closed")
#endif
    END_AND_PARTIAL_REFRESH


_ErrorAlreadyClosed_Elle
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Elle est déjà fermée")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Den er allerede lukket")
#else
    ERROR_MESSAGE("It's already closed")
#endif        
    END_AND_PARTIAL_REFRESH


_ErrorAlreadyPositioned_Elle
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Elle est déjà en position")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Den er allerede på plass")
#else
    ERROR_MESSAGE("It's already positioned")
#endif        
    END_AND_PARTIAL_REFRESH


_ErrorAlreadyEquipped_Elle
#ifdef LANGUAGE_FR
    ERROR_MESSAGE("Elle est déjà sur moi")
#elif defined(LANGUAGE_NO)
    ERROR_MESSAGE("Den er allerede påsatt")
#else
    ERROR_MESSAGE("It's already equipped")
#endif        
    END_AND_PARTIAL_REFRESH


_SubClosedButNotLocked_Elle
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Elle est fermée mais pas à clef")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Den er lukket men ikke låst.")
#else
    INFO_MESSAGE("It's closed, but not locked.")
#endif
    RETURN


_SubCheckToDark
.(
    JUMP_IF_FALSE(_ErrorTooDark,CHECK_ITEM_LOCATION(e_ITEM_BlackTape,e_LOC_GONE_FOREVER))
    RETURN
.)


_ErrorTooDark
.(
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Il fait trop sombre !")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Det er for mørkt!")
#else
    INFO_MESSAGE("It's too dark!")
#endif    
    END_AND_REFRESH
.)



; This is a script that is run before the setup of a scene is done.
; In the current status it is used to get the girl to follow us
_ScenePreLoadScript
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
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_WATCH_ALARM)                    ; The watch is shown with 0:00:00 as a base image
    FADE_BUFFER
    WAIT(50)

    PLAY_SOUND(_WatchButtonPress)                                       ; Play the "button pressed" sound
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,9)                                 ; Overlay the 1 hours patch
            _IMAGE(24,43)
            _SCREEN(17,63)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Deux heures. C'est tout.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("To timer. Det er alt.")
#else
    INFO_MESSAGE("Two hours. That's all I've got.")
#endif    

    PLAY_SOUND(_WatchButtonPress)                                       ; Play the "button pressed" sound
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,9)                                 ; Overlay the 2 hours patch
            _IMAGE(24,34)
            _SCREEN(17,63)
#ifdef LANGUAGE_FR
    INFO_MESSAGE("...faut pas les gaspiller.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("...best å ikke kaste dem bort.")
#else
    INFO_MESSAGE("...better not waste them.")
#endif    

    WAIT(50)

    PLAY_SOUND(_WatchButtonPress)                                       ; Play the "button pressed" sound
    WAIT(30)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,6,9)                                 ; Overlay the 1:59:59 patch
            _IMAGE(24,43)
            _SCREEN(17,63)
    WAIT(30)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,2,9)                                 ; Overlay the :58 patch
            _IMAGE(28,34)
            _SCREEN(21,63)
    WAIT(25)
    RETURN
.)


; Half-way display, when one hour has elapsed, to remind the player they need to speed up
_OneHourAlarmWarning
.(
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_WATCH_ALARM)                    ; The watch is shown with 0:00:00 as a base image
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,9)                                 ; Overlay the 1 hours patch
            _IMAGE(24,43)
            _BUFFER(17,63)
    FADE_BUFFER
    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    DRAW_BITMAP(LOADER_SPRITE_BEEP,BLOCK_SIZE(12,38),12,_SecondImageBuffer,$a000+(40*10)+27)        // Beep!

    CLEAR_TEXT_AREA(5)                                                  ; MAGENTA background
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Déjà une heure de passée.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Allerede en time gått!")
#else
    INFO_MESSAGE("One hour gone already.")
#endif    
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,1,9)                                 ; Overlay the 0 patch on the hour
            _IMAGE(24,52)
            _SCREEN(17,63)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,5,9)                                 ; Overlay the 59:59 patch
            _IMAGE(25,43)
            _SCREEN(18,63)
    CLEAR_TEXT_AREA(5)                                                  ; MAGENTA background
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Faut que j'accélère.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("Jeg må skynde meg!")
#else
    INFO_MESSAGE("I need to get a move on.")
#endif

    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    DRAW_BITMAP(LOADER_SPRITE_BEEP,BLOCK_SIZE(12,38),12,_SecondImageBuffer,$a000+(40*81)+3)        // Beep!
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,2,9)                                 ; Overlay the :58 patch
            _IMAGE(28,34)
            _SCREEN(21,63)

    WAIT(25)
    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound

    END_AND_REFRESH
.)


; Time out, you lost!
_TimeOutGameOver
.(
    SET_CUT_SCENE(1)
    DISPLAY_IMAGE(LOADER_PICTURE_WATCH_ALARM)

    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    DRAW_BITMAP(LOADER_SPRITE_BEEP,BLOCK_SIZE(12,38),12,_SecondImageBuffer,$a000+(40*10)+27)        // Beep!
    CLEAR_TEXT_AREA(1)                                                  ; RED background
#ifdef LANGUAGE_FR
    INFO_MESSAGE("Trop lent. Mince.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("For sakte. Pokker.")
#else
    INFO_MESSAGE("Too slow. Blast.")
#endif    

    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    DRAW_BITMAP(LOADER_SPRITE_BEEP,BLOCK_SIZE(12,38),12,_SecondImageBuffer,$a000+(40*81)+3)        // Beep!
    CLEAR_TEXT_AREA(1)                                                  ; RED background
#ifdef LANGUAGE_FR
    INFO_MESSAGE("...plus de temps.")
#elif defined(LANGUAGE_NO)
    INFO_MESSAGE("...tiden er ute.")
#else
    INFO_MESSAGE("...I've run out of time.")
#endif
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
    DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_WATCH_ALARM)
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,6,9)                                 ; Overlay the PAUSE patch
            _IMAGE(24,61)
            _BUFFER(17,63)
    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    FADE_BUFFER
    CALL_NATIVE(_ShowHelp)                                   ; Show the list of all commands
    PLAY_SOUND(_WatchBeepData)                                          ; Play the beep beep beep sound
    START_CLOCK
    SET_CUT_SCENE(0)
    END_AND_REFRESH
.)    


; Called if the player types QUIT to leave the game
_QuitGameScript
.(
    GOSUB(_ConfirmEndGame)
    ; Only reached if player confirmed
    PLAY_SOUND(_KeyClickHData)
    UNLOCK_ACHIEVEMENT(ACHIEVEMENT_GAVE_UP)
    GAME_OVER(e_SCORE_GAVE_UP)
    DECREASE_SCORE(MALUS_POINTS_GIVE_UP)
    END
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

