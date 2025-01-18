#include "params.h"

    .text   // could be .data if we setup the base address properly

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i ô:^ ç:c â:[ ù:u
#endif


;
; Title screen
;
_Text_TitlePicture               
#ifdef LANGUAGE_FR
    .byt 16+3,5,12,"      <- Sélection de page ->",TEXT_CRLF
#else
    .byt 16+3,5,12,"       <- Page Navigation ->",TEXT_CRLF
#endif    
    .byt 16+3,4,"  Encounter ",96," 1983 Severn Software",TEXT_CRLF
#ifdef LANGUAGE_FR
    .byt 16+3,4," Améliorations ",96," 2024 Defence-Force "
#else
    .byt 16+3,4,"Redux Additions ",96," 2024 Defence-Force "
#endif    
    .byt TEXT_END



;
; Demo text
;
#ifdef PRODUCT_TYPE_GAME_DEMO
#ifdef LANGUAGE_FR
_Text_DemoFeatures
    .byt 1,"          Encounter Démo",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Si vous n'avez jamais joué à ce type",TEXT_CRLF
    .byt "de jeu, veuillez consulter le manuel",TEXT_CRLF
    .byt "sur",4,"encounter.defence-force.org",0,"ou",TEXT_CRLF
    .byt "lisez simplement les pages suivantes.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Les touches flèchées",5,"gauche",0,"et",5,"droite",TEXT_CRLF
    .byt "servent à naviguer entre les pages.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "La seule limite dans cette démo est",TEXT_CRLF
    .byt "que vous ne pouvez pas entrer dans le",TEXT_CRLF
    .byt "manoir, donc vous ne pourrez pas",TEXT_CRLF
    .byt "terminer la mission !",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Le reste est comme le jeu complet:",TEXT_CRLF
    .byt "Si vous l'achetez, les",2,"scores",0,"ainsi",TEXT_CRLF
    .byt "que les",2,"succès",0,"seront conservés.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Dernier mot:",4,"Merci beaucoup",0,"d'avoir",TEXT_CRLF
    .byt "essayé notre jeu parmi les 19000",TEXT_CRLF
    .byt "autres jeux sortis rien qu'en 2024 !",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Ce jeu n'est pas une oeuvre d'art",TEXT_CRLF
    .byt "photo-réaliste avec raytracing",TEXT_CRLF
    .byt "mais nous avons",1,"fait de notre mieux!",TEXT_CRLF
    .byt TEXT_END
#else// LANGUAGE_EN
_Text_DemoFeatures
    .byt 1,"          Encounter Demo",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "If you have never played this type of",TEXT_CRLF
	.byt "game before, please check the manual",TEXT_CRLF
	.byt "at",4,"encounter.defence-force.org",0,"or",TEXT_CRLF
	.byt "just read the next two pages!",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "You can use the",5,"left",0,"and",5,"right",0,"arrow",TEXT_CRLF
	.byt "keys to navigate between the pages.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "The only limit present in this demo",TEXT_CRLF
	.byt "is that you can't enter the mansion,",TEXT_CRLF
	.byt "so you will not be able to finish the",TEXT_CRLF
	.byt "mission!",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "The rest is identical to the complete",TEXT_CRLF
	.byt "game: if you decide to buy it, your",TEXT_CRLF
	.byt "scores and",2,"achievements",0,"will follow.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "One last word:",4,"Thank you",0,"very much",TEXT_CRLF
	.byt "for trying our game among the 19000",TEXT_CRLF
	.byt "other games released in 2024 alone!",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "It's definitely not a GPU accelerated",TEXT_CRLF
	.byt "photo-realistic raytraced masterpiece",TEXT_CRLF
	.byt "but",1,"we tried our best!",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_END
#endif
#endif

;
; Manual
;
#ifdef LANGUAGE_FR
_Text_GameInstructions
    .byt 1,"        Comment jouer (1/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Votre tâche est de trouver et sauver",TEXT_CRLF
    .byt "une fille kidnappée par des voyous.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "La mission échoue si vous êtes",TEXT_CRLF
    .byt "détecté ou si vous manquez de temps.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Utilisez des VERBES et des NOMS comme",TEXT_CRLF
    .byt "ex: PRENDS CLE ou COMBINE PAIN BEURRE",TEXT_CRLF
    .byt TEXT_CRLF

    .byt 1,"  MOUVEMENT              VERBES",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "N:NORD S:SUD     OUVRE PRENDS/RAMASSE",TEXT_CRLF
    .byt "O:OUEST E:EST        FERME POSE/LACHE",TEXT_CRLF
    .byt "D:DESCENDRE           CHERCHE/FOUILLE",TEXT_CRLF
    .byt "M:MONTER     EXAMINE/INSPECTE/REGARDE",TEXT_CRLF
    .byt "PAUSE AIDE            COMBINE UTILISE",TEXT_CRLF
    .byt "QUITTE                      LIS LANCE",TEXT_CRLF
    .byt 1,"              NOTES",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Tout ce dont vous avez besoin est là",TEXT_CRLF
    .byt "mais être bricoleur peut aider.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Tracez une carte et annotez-la.",TEXT_CRLF
    .byt "Bonne chance, vous en aurez besoin!"
    .byt TEXT_END
#else// LANGUAGE_EN
_Text_GameInstructions
    .byt 1,"         How to play (1/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "You have two hours to find and rescue",TEXT_CRLF
	.byt "a young girl kidnapped by thugs.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "The mission fails if you get detected",TEXT_CRLF
	.byt "or if you run out of time.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Give orders using VERBS and NOUNS",TEXT_CRLF
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


#ifdef LANGUAGE_FR
_Text_GameInstructionsPage2
    .byt 1,"        Comment jouer (2/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Presser ESC ou taper AIDE imprime",TEXT_CRLF
    .byt "la liste des instructions.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "SHIFT et flèches HAUT ou BAS font",TEXT_CRLF
    .byt "défiler les objets si débordement.",TEXT_CRLF
    .byt TEXT_CRLF                       
    .byt "SHIFT met aussi en surbrillance les",TEXT_CRLF
    .byt "noms des objets interactifs.",TEXT_CRLF
    .byt TEXT_CRLF     
    .byt "Parfois le nom d'un conteneur vous",TEXT_CRLF
    .byt "sera demandé lors de l'obtention de",TEXT_CRLF
    .byt "certains objets ou substances.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "COMBINE nécessite deux objets :",TEXT_CRLF
    .byt "leur ordre n'a pas d'importance.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Lire des documents peut révéler des",TEXT_CRLF
    .byt "informations utiles.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Assurez-vous de vérifier toutes les",TEXT_CRLF
    .byt "directions indiquées sur le compas.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Les touches fléchées peuvent être",TEXT_CRLF
    .byt "utilisées pour naviguer.",TEXT_CRLF
    .byt TEXT_END
#else// LANGUAGE_EN
_Text_GameInstructionsPage2
    .byt 1,"         How to play (2/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Pressing ESC or typing HELP will",TEXT_CRLF
	.byt "print the list of instructions.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "If the items list overflows use SHIFT",TEXT_CRLF
	.byt "with UP or DOWN arrows to scroll it.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "SHIFT also highlights the names of",TEXT_CRLF
    .byt "the items you can interact with.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Some items require a valid container",TEXT_CRLF
	.byt "to be transported: The game will then",TEXT_CRLF
	.byt "ask you the name of the container.",TEXT_CRLF
	.byt TEXT_CRLF
	.byt "The COMBINE command does requires two",TEXT_CRLF
    .byt "items: their order does not matter.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Reading documents can reveal useful",TEXT_CRLF
    .byt "tidbits of information.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Make sure to check all the directions",TEXT_CRLF
    .byt "indicated on the directional cross.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Arrow keys can be used to navigate.",TEXT_CRLF
    .byt TEXT_END
#endif



;
; Typeweriter intro.
; (use 13 to do carriage returns)
;
_Text_TypeWriterMessage 
#ifdef LANGUAGE_FR
    .byt "29 septembre 1982",13,13
    .byt "Ma mission : Secourir une fille de",13
    .byt "ses ravisseurs dans une résidence",13
    .byt "bourgeoise isolée.",13,13
    .byt "Ayant le droit d'opérer sans entrave,",13         
    .byt "potentiellement avec force, je garai",13
    .byt "ma voiture au marché local et",13
    .byt "avancai discrètement à pied."
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
    .byt "UTILISE, LACHE, LANCE, COMBINE objets.",TEXT_CRLF
    .byt "LIS, REGARDE ou CHERCHE quelques-uns.",TEXT_CRLF
    .byt 0
_Text_Loading_SecondTime    
    .byt "Tuer est toujours une option, mais être",TEXT_CRLF
    .byt "pacifiste rapporte plus de points.",TEXT_CRLF
    .byt 0
_Text_Loading_ThirdTime    
    .byt "Certains objets ont plusieurs usages...",TEXT_CRLF
    .byt "mais certains autres sont inutiles !",TEXT_CRLF
    .byt 0
_Text_Loading_FourthTime
    .byt "Vous devrez construire quelques objets",TEXT_CRLF
    .byt "en combinant ensemble d'autres objets.",TEXT_CRLF
    .byt 0
#else
_Text_Loading_FirstTimeEver    
    .byt "You can USE, DROP, THROW, COMBINE items.",TEXT_CRLF
    .byt "Some you can READ, INSPECT or SEARCH.",TEXT_CRLF
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
