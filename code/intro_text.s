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
#ifdef LANGUAGE_FR
    .byt 16+3,4,"Amméliorations ",96," 2024 Defence-Force "
#else
    .byt 16+3,4,"Redux Additions ",96," 2024 Defence-Force "
#endif    
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
    .byt "You have two hours to find and rescue",TEXT_CRLF
	.byt "a young girl kidnapped by thugs.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "The mission fails if you get detected",TEXT_CRLF
	.byt "or if you run out of time.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Give orders using VERBS and NOUNS",TEXT_CRLF
	;.byt "eg:DROP BOTTLE or GET KEYS",TEXT_CRLF
    .byt "eg: GET KEYS or COMBINE BREAD BUTTER",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 1,"   MOVEMENT            VERBS",TEXT_CRLF,TEXT_CRLF
	.byt "N:NORTH U:UP       TAKE/GET DROP/PUT",TEXT_CRLF
	.byt "S:SOUTH D:DOWN     THROW COMBINE USE",TEXT_CRLF
	.byt "E:EAST               EXAMINE/INSPECT",TEXT_CRLF
	.byt "W:WEST             READ SEARCH/FRISK",TEXT_CRLF
    .byt "                     OPEN CLOSE QUIT",TEXT_CRLF
    .byt 1,"              NOTES",0,"     HELP PAUSE",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Everything you need is here but you",TEXT_CRLF
	.byt "may have to manufacture some items.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Drawing and annotating a map helps.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Good luck, you will need it..."
    .byt TEXT_END
#endif



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
	.byt "les alerter..."
    .byt 0
#else // LANGUAGE_EN
	.byt "September 29, 1982",13,13
	.byt "My mission: Rescue a girl from her",13
    .byt "captors within a secluded, upscale",13
    .byt "residence.",13,13
    .byt "With a license to operate freely,",13
    .byt "potentially with force, I stationed",13
    .byt "my car at the local market and",13
    .byt "advanced covertly by foot."
    .byt 0
#endif





// Bonus texts
#ifdef LANGUAGE_FR
_Text_Loading_FirstTimeEver    
    .byt "UTILISE, LACHE, LANCE, COMBINE items.",TEXT_CRLF
    .byt "Certain peuvent être LU ou INSPECTE.",TEXT_CRLF
    .byt 0
_Text_Loading_SecondTime    
    .byt "Lethality is always an option but being",TEXT_CRLF
    .byt "a pacifist will grant you more points.",TEXT_CRLF
    .byt 0
_Text_Loading_ThirdTime    
    .byt "Some items have multiple uses, some have",TEXT_CRLF
    .byt "no specific purpose. Try to guess right!",TEXT_CRLF
    .byt 0
_Text_Loading_FourthTime
    .byt "Some items will have to be built using",TEXT_CRLF
    .byt "combinations of other items together.",TEXT_CRLF
    .byt 0
#else
_Text_Loading_FirstTimeEver    
    .byt "You can USE, DROP, THROW, COMBINE items.",TEXT_CRLF
    .byt "Some you can READ or INSPECT.",TEXT_CRLF
    .byt 0
_Text_Loading_SecondTime    
    .byt "Lethality is always an option but being",TEXT_CRLF
    .byt "a pacifist will grant you more points.",TEXT_CRLF
    .byt 0
_Text_Loading_ThirdTime    
    .byt "Some items have multiple uses, some have",TEXT_CRLF
    .byt "no specific purpose. Try to guess right!",TEXT_CRLF
    .byt 0
_Text_Loading_FourthTime
    .byt "Some items will have to be built using",TEXT_CRLF
    .byt "combinations of other items together.",TEXT_CRLF
    .byt 0
#endif



_gLoadingMessagesArray
  .word _Text_Loading_FirstTimeEver
  .word _Text_Loading_SecondTime
  .word _Text_Loading_ThirdTime
  .word _Text_Loading_FourthTime
