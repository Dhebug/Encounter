#include "params.h"

    .text   // could be .data if we setup the base address properly

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@
#endif


;
; Title screen
;
_Text_TitlePicture               
    .byt 16+3,4,TEXT_CRLF
    .byt 16+3,4,"  Encounter ",96," 1983 Severn Software",TEXT_CRLF
    .byt 16+3,4,"Redux Additions ",96," 2024 Defence-Force ",31
    .byt TEXT_END

;
; Manual
;
#ifdef LANGUAGE_FR
_Text_GameInstructions
    .byt 1,"           Comment jouer",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Votre tache est de trouver et sauver",TEXT_CRLF
    .byt "une fille kidnappée par des voyous.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Donnez les ordres avec VERBES et NOMS",TEXT_CRLF
    .byt "ex:VID(e) SEA(u) ou DON(ne) CLE(fs)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 1,"  MOUVEMENT            VERBES",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "N:NORD S:SUD    PRENDS POSE LANCE TUE",TEXT_CRLF
    .byt "O:OUEST E:EST  FABRIQUE GRIMPE QUITTE",TEXT_CRLF
    .byt "H:HAUT B:BAS     OUVRE CHARGE FOUILLE",TEXT_CRLF
    .byt "R:REGARDE           LIT PRESSE FRAPPE",TEXT_CRLF
    .byt 1,"              NOTES",0,"    TIRE SIPHONE",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Tout ce dont vous avez besoin est là",TEXT_CRLF
    .byt "mais être bricoleur peut aider.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "La mission échoue si le temps restant",TEXT_CRLF
    .byt "ou l'alarme tombent a zéro.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Tracez une carte et annotez la.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Bonne chance, vous en aurez besoin!"
    .byt TEXT_END
#else// LANGUAGE_EN
_Text_GameInstructions
    .byt 1,"           How to play",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Your task is to find and rescue a",TEXT_CRLF
	.byt "young girl kidnapped by thugs.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Give orders using VERBS and NOUNS",TEXT_CRLF
	.byt "eg:DROP BOTTLE or GET KEYS",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 1,"   MOVEMENT            VERBS",TEXT_CRLF,TEXT_CRLF
	.byt "N:NORTH U:UP       TAKE/GET DROP/PUT",TEXT_CRLF
	.byt "S:SOUTH D:DOWN     THROW COMBINE USE",TEXT_CRLF
	.byt "E:EAST               EXAMINE/INSPECT",TEXT_CRLF
	.byt "W:WEST             READ SEARCH/FRISK",TEXT_CRLF
    .byt "                     OPEN CLOSE QUIT",TEXT_CRLF
    .byt 1,"              NOTES",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Everything you need is here but you",TEXT_CRLF
	.byt "may have to manufacture some items.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "The mission fails if the movement or",TEXT_CRLF
	.byt "alarm counters reaches zero.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Drawing and annotating a map helps.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Good luck, you will need it..."
    .byt TEXT_END
#endif

;
; Leaderboard
;
#ifdef LANGUAGE_FR
_Text_Leaderboard                .byt 16+1,3,"            Classement",TEXT_CRLF,TEXT_END
_Text_SCORE_SOLVED_THE_CASE      .byt 2,"R{solu le cas",0
_Text_SCORE_MAIMED_BY_DOG        .byt 5,"Mutil{ par un chien",0
_Text_SCORE_SHOT_BY_THUG         .byt 1,"Abattu par un voyou",0
_Text_SCORE_FELL_INTO_PIT        .byt 3,"Tomb{ dans un trou",0
_Text_SCORE_TRIPPED_ALARM        .byt 3,"D{clench{ l'alarme",0
_Text_SCORE_RAN_OUT_OF_TIME      .byt 6,"A manqu{ de temps",0
_Text_SCORE_BLOWN_INTO_BITS      .byt 1,"Souffl{ en morceaux",0
_Text_SCORE_SIMPLY_VANISHED      .byt 7,"A disparu !",0
_Text_SCORE_GAVE_UP              .byt 5,"A abandonn{...",0
#else // LANGUAGE_EN
_Text_Leaderboard                .byt 16+1,3,"            Leaderboard",TEXT_CRLF,TEXT_END
_Text_SCORE_SOLVED_THE_CASE      .byt 2,"Solved the case",0
_Text_SCORE_MAIMED_BY_DOG        .byt 5,"Maimed by a dog",0
_Text_SCORE_SHOT_BY_THUG         .byt 1,"Shot by a thug",0
_Text_SCORE_FELL_INTO_PIT        .byt 3,"Fell into a pit",0
_Text_SCORE_TRIPPED_ALARM        .byt 3,"Tripped the alarm",0
_Text_SCORE_RAN_OUT_OF_TIME      .byt 6,"Ran out of time",0
_Text_SCORE_BLOWN_INTO_BITS      .byt 1,"Blown into bits",0
_Text_SCORE_SIMPLY_VANISHED      .byt 7,"Simply Vanished!",0
_Text_SCORE_GAVE_UP              .byt 5,"Gave up...",0
#endif

;
; Achievements
;
#ifdef LANGUAGE_FR
_Text_Achievements                .byt 16+3,1,"          Badges collectés",TEXT_CRLF,TEXT_END
_Text_AchievementStillLocked      .byt 6,"     <?>",7,0
_Text_AchievementNone             .byt 16+3,1,"        Nothing unlocked!!!",0
_Text_AchievementCount            .byt 16+3,1,"  %d out of %d unlocked - %d percent",0
_Text_AchievementLaunchedTheGame  .byt "Launched the game",0
_Text_AchievementWatchedTheIntro  .byt "Watched the intro",0
_Text_AchievementReadTheNewspaper .byt "Read the newspaper",0
_Text_AchievementReadTheBook      .byt "Read the book",0
_Text_AchievementReadTheNote      .byt "Read the note",0
_Text_AchievementReadTheRecipes   .byt "Read the recipes",0
_Text_AchievementOpenedTheFridge  .byt "Opened the fridge",0
_Text_AchievementOpenedTheCabinet .byt "Opened the cabinet",0
_Text_AchievementDruggedTheMeat   .byt "Drugged the meat",0
_Text_AchievementKilledTheDog     .byt "Killed the dog",0
_Text_AchievementDruggedTheDog    .byt "Drugged the dog",0
_Text_AchievementChasedTheDog     .byt "Chased the dog",0
_Text_AchievementKilledTheThug    .byt "Killed the thug",0
_Text_AchievementDruggedTheThug   .byt "Drugged the thug",0
_Text_AchievementCapturedTheDove  .byt "Captured the dove",0
_Text_AchievementUsedTheRope      .byt "Used the rope",0
_Text_AchievementUsedTheLadder    .byt "Used the ladder",0
_Text_AchievementExaminedTheMap   .byt "Examined the map",0
_Text_AchievementExaminedTheGame  .byt "Examined the game",0
_Text_AchievementOpenedTheSafe    .byt "Opened the safe",0
_Text_AchievementOpenedThePanel   .byt "Opened the panel",0
_Text_AchievementBuiltAFuse       .byt "Built a fuse",0
_Text_AchievementBuiltABomb       .byt "Built a bomb",0
_Text_AchievementMadeBlackPowder  .byt "Made blackpowder",0
_Text_AchievementFrikedTheThug    .byt "Frisked the thug",0
_Text_AchievementUsedTheAcid      .byt "Used the acid",0
_Text_AchievementMadeThermite     .byt "Made thermite",0
_Text_AchievementPiercedTheDoor   .byt "Pierced the door",0
_Text_AchievementOpenedTheCurtain .byt "Opened the curtain",0
_Text_AchievementGaveTheKnife     .byt "Gave the knife",0
_Text_AchievementGaveTheRope      .byt "Gave the rope",0
_Text_AchievementWatchedTheOutro  .byt "Watched the outro",0
_Text_AchievementGotAHighscore    .byt "Got a highscore",0
_Text_AchievementGotTheBestScore  .byt "Got the best score",0
_Text_AchievementDogAteTheMeat    .byt "Dog ate the meat",0
_Text_AchievementFree2            .byt "Free 2",0
_Text_AchievementFree3            .byt "Free 3",0
_Text_AchievementFree4            .byt "Free 4",0
_Text_AchievementFree5            .byt "Free 5",0
#else // LANGUAGE_EN
_Text_Achievements                .byt 16+3,1,"        Achievements unlocked",TEXT_CRLF,TEXT_END
_Text_AchievementStillLocked      .byt 6,"     <?>",7,0
_Text_AchievementNone             .byt 16+3,1,"        Nothing unlocked!!!",0
_Text_AchievementCount            .byt 16+3,1,"  %d out of %d unlocked - %d percent",0
_Text_AchievementLaunchedTheGame  .byt "Launched the game",0
_Text_AchievementWatchedTheIntro  .byt "Watched the intro",0
_Text_AchievementReadTheNewspaper .byt "Read the newspaper",0
_Text_AchievementReadTheBook      .byt "Read the book",0
_Text_AchievementReadTheNote      .byt "Read the note",0
_Text_AchievementReadTheRecipes   .byt "Read the recipes",0
_Text_AchievementOpenedTheFridge  .byt "Opened the fridge",0
_Text_AchievementOpenedTheCabinet .byt "Opened the cabinet",0
_Text_AchievementDruggedTheMeat   .byt "Drugged the meat",0
_Text_AchievementKilledTheDog     .byt "Killed the dog",0
_Text_AchievementDruggedTheDog    .byt "Drugged the dog",0
_Text_AchievementChasedTheDog     .byt "Chased the dog",0
_Text_AchievementKilledTheThug    .byt "Killed the thug",0
_Text_AchievementDruggedTheThug   .byt "Drugged the thug",0
_Text_AchievementCapturedTheDove  .byt "Captured the dove",0
_Text_AchievementUsedTheRope      .byt "Used the rope",0
_Text_AchievementUsedTheLadder    .byt "Used the ladder",0
_Text_AchievementExaminedTheMap   .byt "Examined the map",0
_Text_AchievementExaminedTheGame  .byt "Examined the game",0
_Text_AchievementOpenedTheSafe    .byt "Opened the safe",0
_Text_AchievementOpenedThePanel   .byt "Opened the panel",0
_Text_AchievementBuiltAFuse       .byt "Built a fuse",0
_Text_AchievementBuiltABomb       .byt "Built a bomb",0
_Text_AchievementMadeBlackPowder  .byt "Made blackpowder",0
_Text_AchievementFrikedTheThug    .byt "Frisked the thug",0
_Text_AchievementUsedTheAcid      .byt "Used the acid",0
_Text_AchievementMadeThermite     .byt "Made thermite",0
_Text_AchievementPiercedTheDoor   .byt "Pierced the door",0
_Text_AchievementOpenedTheCurtain .byt "Opened the curtain",0
_Text_AchievementGaveTheKnife     .byt "Gave the knife",0
_Text_AchievementGaveTheRope      .byt "Gave the rope",0
_Text_AchievementWatchedTheOutro  .byt "Watched the outro",0
_Text_AchievementGotAHighscore    .byt "Got a highscore",0
_Text_AchievementGotTheBestScore  .byt "Got the best score",0
_Text_AchievementDogAteTheMeat    .byt "Dog ate the meat",0
_Text_AchievementFree2            .byt "Free 2",0
_Text_AchievementFree3            .byt "Free 3",0
_Text_AchievementFree4            .byt "Free 4",0
_Text_AchievementFree5            .byt "Free 5",0
#endif

_AchievementMessages
    ; 0-7
    .word _Text_SCORE_SOLVED_THE_CASE+1     ; "Solved the case"
    .word _Text_SCORE_MAIMED_BY_DOG+1       ; "Maimed by a dog"
    .word _Text_SCORE_SHOT_BY_THUG+1        ; "Shot by a thug"
    .word _Text_SCORE_FELL_INTO_PIT+1       ; "Fell into a pit"
    .word _Text_SCORE_TRIPPED_ALARM+1       ; "Tripped the alarm"
    .word _Text_SCORE_RAN_OUT_OF_TIME+1     ; "Ran out of time"
    .word _Text_SCORE_BLOWN_INTO_BITS+1     ; "Blown into bits"
    .word _Text_SCORE_SIMPLY_VANISHED+1     ; "Simply Vanished!"
    ; 8-15
    .word _Text_SCORE_GAVE_UP+1             ; "Gave up..."
    .word _Text_AchievementLaunchedTheGame  ; "Launched the game"
    .word _Text_AchievementWatchedTheIntro  ; "Watched the intro"
    .word _Text_AchievementReadTheNewspaper ; "Read the newspaper"
    .word _Text_AchievementReadTheBook      ; "Read the book"
    .word _Text_AchievementReadTheNote      ; "Read the note"
    .word _Text_AchievementReadTheRecipes   ; "Read the recipes"
    .word _Text_AchievementOpenedTheFridge  ; "Opened the fridge"
    ; 16-23
    .word _Text_AchievementOpenedTheCabinet ; "Opened the cabinet"
    .word _Text_AchievementDruggedTheMeat   ; "Drugged the meat"
    .word _Text_AchievementKilledTheDog     ; "Killed the dog"
    .word _Text_AchievementDruggedTheDog    ; "Drugged the dog"
    .word _Text_AchievementChasedTheDog     ; "Chased the dog"
    .word _Text_AchievementKilledTheThug    ; "Killed the thug"
    .word _Text_AchievementDruggedTheThug   ; "Drugged the thug"
    .word _Text_AchievementCapturedTheDove  ; "Captured the dove"
    ; 24-31
    .word _Text_AchievementUsedTheRope      ; "Used the rope"
    .word _Text_AchievementUsedTheLadder    ; "Used the ladder"
    .word _Text_AchievementExaminedTheMap   ; "Examined the map"
    .word _Text_AchievementExaminedTheGame  ; "Examined the game"
    .word _Text_AchievementOpenedTheSafe    ; "Opened the safe"
    .word _Text_AchievementOpenedThePanel   ; "Opened the panel"
    .word _Text_AchievementBuiltAFuse       ; "Built a fuse"
    .word _Text_AchievementBuiltABomb       ; "Built a bomb"
    ; 32-39
    .word _Text_AchievementMadeBlackPowder  ; "Made blackpowder"
    .word _Text_AchievementFrikedTheThug    ; "Frisked the thug"
    .word _Text_AchievementUsedTheAcid      ; "Used the acid"
    .word _Text_AchievementMadeThermite     ; "Made thermite"
    .word _Text_AchievementPiercedTheDoor   ; "Pierced the door"
    .word _Text_AchievementOpenedTheCurtain ; "Opened the curtain"
    .word _Text_AchievementGaveTheKnife     ; "Gave the knife"
    .word _Text_AchievementGaveTheRope      ; "Gave the rope"
    ; 40-47
    .word _Text_AchievementWatchedTheOutro  ; "Watched the outro"
    .word _Text_AchievementGotAHighscore    ; "Got a highscore"
    .word _Text_AchievementGotTheBestScore  ; "Got the best score"
    .word _Text_AchievementDogAteTheMeat    ; "Dog ate the meat"
    .word _Text_AchievementFree2            ; "Free 2"
    .word _Text_AchievementFree3            ; "Free 3"
    .word _Text_AchievementFree4            ; "Free 4"
    .word _Text_AchievementFree5            ; "Free 5"



;
; Typeweriter intro.
; (use 13 to do carriage returns)
;
_Text_TypeWriterMessage 
#ifdef LANGUAGE_FR
	.byt "Mercredi 29 septembre 1982",13,13,13
	.byt "Mon client m'a demand{ de sauver",13
    .byt "sa fille kidnapp{e par des brigants",13
	.byt "cach{s dans une maison bourgeoise",13
    .byt "au milieu de nul part.",13,13
	.byt "J'avais carte blanche pour",13
    .byt "regler le probl}me...",13
	.byt "...force lethale autoris{e.",13,13,13
	.byt "Gar{ sur la place du march{",13
    .byt "j'approchais a pied pour ne pas",13
	.byt "les alerter...",13,13
    .byt 0
#else // LANGUAGE_EN
	.byt "September 29, 1982",13,13
	.byt "My mission: Rescue a girl from her",13
    .byt "captors within a secluded, upscale",13
    .byt "residence.",13,13
    .byt "With a license to operate freely,",13
    .byt "potentially with force, I stationed",13
    .byt "my car at the local market and",13
    .byt "advanced covertly by foot.",13,13
    .byt 0
#endif
