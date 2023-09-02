#include "params.h"

    .text   // could be .data if we setup the base address properly

;
; Title screen
;
_Text_FirstLine                  .byt 16+3,4,"                                        ",0
_Text_CopyrightSevernSoftware    .byt 16+3,4,"  Encounter ",96," 1983 Severn Software    ",0
_Text_CopyrightDefenceForce      .byt 16+3,4,"Redux Additions ",96," 2023 Defence-Force ",31,0

;
; Manual
;
#ifdef LANGUAGE_FR
_Text_GameInstructions
    .byt 1,"           Comment jouer",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Votre tache est de trouver et sauver",TEXT_CRLF
	.byt "une fille kidnapp{e par des voyous.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Give orders using VERBS and NOUNS",TEXT_CRLF
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
	.byt "Tout ce dont vous avez besoin est la",TEXT_CRLF
	.byt "mais etre bricoleur peut aider.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "La mission {choue si le temps restant",TEXT_CRLF
	.byt "ou l'alarme tombent a z{ro.",TEXT_CRLF
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
	.byt "eg:EMP(ty) BOT(tle) or GET KEY(s)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 1,"   MOVEMENT            VERBS",TEXT_CRLF,TEXT_CRLF
	.byt "N:NORTH S:SOUTH   GET DROP THROW KILL",TEXT_CRLF
	.byt "W:WEST E:EAST     HIT MAKE CLIMB QUIT",TEXT_CRLF
	.byt "U:UP D:DOWN       OPEN LOAD FRISK USE",TEXT_CRLF
	.byt "L:Look                READ PRESS BLOW",TEXT_CRLF
    .byt 1,"              NOTES",0,"    SHOOT SIPHON",TEXT_CRLF
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
_Text_Leaderboard                .byt 16+1,3,"            Classement",0
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
_Text_Leaderboard                .byt 16+1,3,"            Leaderboard",0
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
; Typeweriter intro.
; (use 13 to do carriage returns)
;
_Text_TypeWriterMessage 
#ifdef LANGUAGE_FR
	.byt "Mercredi 1er septembre 1982",13,13,13
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
	.byt "Wednesday, September 1st, 1982",13,13,13
	.byt "My client had asked me to save their",13
    .byt "daughter who had been kidnapped by",13
	.byt "some vilains who hide in a posh house",13
    .byt "in the middle of nowhere.",13,13
	.byt "I was given carte blanche on how to",13
    .byt "solve the issue...",13
	.byt "...using lethal force if necessary.",13,13,13
	.byt "I parked my car on the market place",13
    .byt "and approached discretely by foot to",13
	.byt "not alert them from my presence...",13,13
    .byt 0
#endif
