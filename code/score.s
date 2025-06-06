
#include "params.h"

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i ô:^ ç:c â:[ ù:u û:]
#endif

_gSaveGameFile            .dsb 8       ; SAVESTRT
_gSaveGameFileVersion     .dsb 5       ; 1.2.3
_gHighScores              .dsb 512-8-5 ; 456 bytes of actual score data, padded to 512 bytes for the saving system



;
; Leaderboard
;
#ifdef LANGUAGE_FR
_Text_Leaderboard                .byt 16+1,3,"            Classement",TEXT_CRLF,TEXT_END
_Text_SCORE_SOLVED_THE_CASE      .byt 2,"A résolu l'affaire",0
_Text_SCORE_MAIMED_BY_DOG        .byt 5,"Mutilé par un chien",0
_Text_SCORE_SHOT_BY_THUG         .byt 1,"Abattu par un voyou",0
_Text_SCORE_FELL_INTO_PIT        .byt 3,"Tombé dans un trou",0
_Text_SCORE_TRIPPED_ALARM        .byt 3,"Déclenché l'alarme",0
_Text_SCORE_RAN_OUT_OF_TIME      .byt 6,"A manqué de temps",0
_Text_SCORE_BLOWN_INTO_BITS      .byt 1,"Soufflé en morceaux",0
_Text_SCORE_GAVE_UP              .byt 5,"A abandonné...",0
_Test_SCORE_FINISHED_DEMO        .byt 3,"Demo terminée",0
#else // LANGUAGE_EN
_Text_Leaderboard                .byt 16+1,3,"            Leaderboard",TEXT_CRLF,TEXT_END
_Text_SCORE_SOLVED_THE_CASE      .byt 2,"Solved the case",0
_Text_SCORE_MAIMED_BY_DOG        .byt 5,"Maimed by a dog",0
_Text_SCORE_SHOT_BY_THUG         .byt 1,"Shot by a thug",0
_Text_SCORE_FELL_INTO_PIT        .byt 3,"Fell into a pit",0
_Text_SCORE_TRIPPED_ALARM        .byt 3,"Tripped the alarm",0
_Text_SCORE_RAN_OUT_OF_TIME      .byt 6,"Ran out of time",0
_Text_SCORE_BLOWN_INTO_BITS      .byt 1,"Blown into bits",0
_Text_SCORE_GAVE_UP              .byt 5,"Gave up...",0
_Test_SCORE_FINISHED_DEMO        .byt 3,"Finished demo",0
#endif



;
; Achievements
;
#ifdef LANGUAGE_FR
_Text_AchievementStillLocked      .byt 6,"     <?>",7,0
_Text_AchievementNone             .byt 16+3,1,"     Aucun badges déverrouillé",0
_Text_AchievementCount            .byt 16+3,1,"     Badges déverrouillés: %d%%",0
_Text_AchievementWrongDirection   .byt "Sens interdit",0
_Text_AchievementLaunchedTheGame  .byt "Lancé le jeu",0
_Text_AchievementWatchedTheIntro  .byt "Regardé l'intro",0
_Text_AchievementReadTheNewspaper .byt "Lu le journal",0
_Text_AchievementReadTheBook      .byt "Lu le livre",0
_Text_AchievementReadTheNote      .byt "Lu la note",0
_Text_AchievementReadTheRecipes   .byt "Lu les formules",0
_Text_AchievementOpenedTheFridge  .byt "Ouvert le frigo",0
_Text_AchievementClosedTheFridge  .byt "Fermé le frigo",0
_Text_AchievementOpenedTheCabinet .byt "Ouvert le placard",0
_Text_AchievementDruggedTheMeat   .byt "Trafiqué la viande",0
_Text_AchievementKilledTheDog     .byt "Tué le chien",0
_Text_AchievementDruggedTheDog    .byt "Drogué le chien",0
_Text_AchievementChasedTheDog     .byt "Chassé le chien",0
_Text_AchievementKilledTheThug    .byt "Tué le voyou",0
_Text_AchievementDruggedTheThug   .byt "Drogué le voyou",0
_Text_AchievementCapturedTheDove  .byt "Capturé la colombe",0
_Text_AchievementUsedTheRope      .byt "Utilisé la corde",0
_Text_AchievementUsedTheLadder    .byt "Utilisé l'échelle",0
_Text_AchievementExaminedTheMap   .byt "Regardé la carte",0
_Text_AchievementExaminedTheGame  .byt "Regardé le jeu",0
_Text_AchievementOpenedTheSafe    .byt "Ouvert le coffre",0
_Text_AchievementOpenedThePanel   .byt "Ouvert le panneau",0
_Text_AchievementBuiltAFuse       .byt "Fait une mèche",0
_Text_AchievementBuiltABomb       .byt "Fabriqué une bombe",0
_Text_AchievementMadeBlackPowder  .byt "Fait de la poudre",0
_Text_AchievementFrikedTheThug    .byt "Fouillé le voyou",0
_Text_AchievementUsedTheAcid      .byt "Utilisé l'acide",0
_Text_AchievementOpenedTheCurtain .byt "Ouvert le rideau",0
_Text_AchievementGaveTheKnife     .byt "Donné le couteau",0
_Text_AchievementGaveTheRope      .byt "Donné la corde",0
_Text_AchievementWatchedTheOutro  .byt "Regardé la fin",0
_Text_AchievementGotAHighscore    .byt "Eu un gros score",0
_Text_AchievementGotTheBestScore  .byt "Meilleur score",0
_Text_AchievementDogAteTheMeat    .byt "Nourri le chien",0
_Text_AchievementUsedHosePipe     .byt "Utilisé le tuyau",0
_Text_AchievementPausedTheGame    .byt "Jeu mis en pause",0
_Text_AchievementCanYouRepeat     .byt "N'a rien compris",0
_Text_AchievementReadTheInvoice   .byt "Lu la facture",0
_Text_AchievementReadTheTombstone .byt "Repose en paix",0
_Text_AchievementOver9999         .byt "Ca dépasse 9999 !",0
_Text_AchievementMonkeyFall       .byt "Chute de gorille",0
#else // LANGUAGE_EN
_Text_AchievementStillLocked      .byt 6,"     <?>",7,0
_Text_AchievementNone             .byt 16+3,1,"      No achievement unlocked",0
_Text_AchievementCount            .byt 16+3,1,"     Achievements unlocked: %d%%",0
_Text_AchievementWrongDirection   .byt "Wrong direction",0
_Text_AchievementLaunchedTheGame  .byt "Launched the game",0
_Text_AchievementWatchedTheIntro  .byt "Watched the intro",0
_Text_AchievementReadTheNewspaper .byt "Read the newspaper",0
_Text_AchievementReadTheBook      .byt "Read the book",0
_Text_AchievementReadTheNote      .byt "Read the note",0
_Text_AchievementReadTheRecipes   .byt "Read the recipes",0
_Text_AchievementOpenedTheFridge  .byt "Opened the fridge",0
_Text_AchievementClosedTheFridge  .byt "Closed the fridge",0
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
_Text_AchievementOpenedTheCurtain .byt "Opened the curtain",0
_Text_AchievementGaveTheKnife     .byt "Gave the knife",0
_Text_AchievementGaveTheRope      .byt "Gave the rope",0
_Text_AchievementWatchedTheOutro  .byt "Watched the outro",0
_Text_AchievementGotAHighscore    .byt "Got a highscore",0
_Text_AchievementGotTheBestScore  .byt "Got the best score",0
_Text_AchievementDogAteTheMeat    .byt "Fed the dog",0
_Text_AchievementUsedHosePipe     .byt "Used the hose pipe",0
_Text_AchievementPausedTheGame    .byt "Paused the game",0
_Text_AchievementCanYouRepeat     .byt "Can you repeat?",0
_Text_AchievementReadTheInvoice   .byt "Read the invoice",0
_Text_AchievementReadTheTombstone .byt "Rest in peace",0
_Text_AchievementOver9999         .byt "It's over 9999!",0
_Text_AchievementMonkeyFall       .byt "Monkey Fall",0
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
    .word _Text_SCORE_GAVE_UP+1             ; "Gave up..."
    ; 8-15
    .word _Text_AchievementWrongDirection   ; "Wrong direction"
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
    .word _Text_AchievementCanYouRepeat     ; "Can you rpeat"
    .word _Text_AchievementPausedTheGame    ; "Paused the game"
    .word _Text_AchievementOpenedTheCurtain ; "Opened the curtain"
    .word _Text_AchievementGaveTheKnife     ; "Gave the knife"
    .word _Text_AchievementGaveTheRope      ; "Gave the rope"
    ; 40-47
    .word _Text_AchievementWatchedTheOutro  ; "Watched the outro"
    .word _Text_AchievementGotAHighscore    ; "Got a highscore"
    .word _Text_AchievementGotTheBestScore  ; "Got the best score"
    .word _Text_AchievementDogAteTheMeat    ; "Dog ate the meat"
    .word _Text_AchievementUsedHosePipe     ; "Used the hose pipe"
    .word _Text_AchievementClosedTheFridge  ; "Closed the fridge"
    .word _Text_AchievementReadTheInvoice   ; "Read the invoice"
    .word _Text_AchievementReadTheTombstone ; "Read the tombstone"
    ; 48-49
    .word _Text_AchievementOver9999         ; "It's over 9999!"
    .word _Text_AchievementMonkeyFall       ; "Falling hazard"

