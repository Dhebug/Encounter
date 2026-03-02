#include "params.h"

    .text   // could be .data if we setup the base address properly

#pragma osdk replace_characters_if LANGUAGE_FR : é:{ è:} ê:| à:@ î:i ô:^ ç:c â:[ ù:u
#pragma osdk replace_characters_if LANGUAGE_NO : æ:{ ø:} å:| Æ:A Ø:O Å:A


;
; Title screen
;
_Text_KeyControls
#ifdef LANGUAGE_FR
    .byt 16+3,5,12,"ESC pour jouer   <-> pour naviguer  "
#elif defined(LANGUAGE_NO)
    .byt 16+3,5,12," ESC for å spille  <-> for å bla     "
#else
    .byt 16+3,5,12,"Press ESC to play or <-> to browse   "
#endif
    .byt TEXT_END
_Text_TitleCopyright
    .byt 16+3,4,"  Encounter ",96," 1983 Severn Software",TEXT_CRLF
#ifdef LANGUAGE_FR
    .byt 16+3,4,"Améliorations ",96," 2024-26 Defence-Force"
#elif defined(LANGUAGE_NO)
    .byt 16+3,4,"Forbedringer ",96," 2024-26 Defence-Force"
#else
    .byt 16+3,4,"Enhancements ",96," 2024-26 Defence-Force"
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
    .byt "que vous ne pouvez pas monter à",TEXT_CRLF
    .byt "l'étage, donc vous ne pourrez pas",TEXT_CRLF
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
#elif defined(LANGUAGE_NO)
_Text_DemoFeatures
    .byt 1,"          Encounter Demo",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "   Har du aldri spilt denne typen",TEXT_CRLF
    .byt "    spill før, sjekk manualen på",TEXT_CRLF
    .byt 4,"encounter.defence-force.org",0," eller",TEXT_CRLF
    .byt " les ganske enkelt neste to sider!",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "  Du kan bruke",5,"venstre",0,"og",5,"høyre",0,"pil",TEXT_CRLF
    .byt "       for å bla mellom sidene.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Den eneste begrensningen i demoen er",TEXT_CRLF
    .byt " at du ikke har tilgang til øverste",TEXT_CRLF
    .byt "  etasje, så du kan ikke fullføre",TEXT_CRLF
    .byt "            oppdraget!",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Resten er identisk med hele spillet:",TEXT_CRLF
    .byt " Kjøper du det, følger",2,"poengene",0,"og",TEXT_CRLF
    .byt "      ",2,"prestasjonene",0,"med over.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "  Siste ord:",4,"Tusen takk",0,"for at du",TEXT_CRLF
    .byt "   prøvde spillet blant de 19000",TEXT_CRLF
    .byt " andre spillene utgitt bare i 2024!",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "  Det er nok ikke et GPU-akselerert",TEXT_CRLF
    .byt "   foto-realistisk mesterverk, men",TEXT_CRLF
    .byt "      ",1,"vi prøvde vårt beste!",TEXT_CRLF
    .byt TEXT_CRLF
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
    .byt "The only limit in this demo is that",TEXT_CRLF
	.byt "you can't access the top floor,",TEXT_CRLF
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
#endif // PRODUCT_TYPE_GAME_DEMO

;
; Manual
;
#ifdef LANGUAGE_FR
_Text_GameInstructionsPage1
    .byt 1,"        Comment jouer (1/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Votre tâche est de trouver et",4,"sauver",TEXT_CRLF
    .byt "une fille kidnappée par des voyous.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "La mission",4,"échoue",0,"si vous êtes",TEXT_CRLF
    .byt "détecté ou si vous manquez de temps.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Utilisez des",4,"VERBES",0,"et des",4,"NOMS",0,"comme",TEXT_CRLF
    .byt "ex: PRENDS CLE ou COMBINE PAIN BEURRE",TEXT_CRLF
    .byt TEXT_CRLF

    .byt 1,"  MOUVEMENT              VERBES",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "N:NORD S:SUD     OUVRE PRENDS/RAMASSE",TEXT_CRLF
    .byt "O:OUEST E:EST        FERME POSE/LACHE",TEXT_CRLF
    .byt "D:DESCENDRE           CHERCHE/FOUILLE",TEXT_CRLF
    .byt "M:MONTER     EXAMINE/INSPECTE/REGARDE",TEXT_CRLF
    .byt "flèches/manette COMBINE UTILISE LANCE",TEXT_CRLF
    .byt "                LIS QUITTE AIDE PAUSE",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Utilisez",4,"CTRL+HAUT/BAS",0,"ou diagonales",TEXT_CRLF
    .byt "pour monter ou descendre.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Presser",4,"ESC",0,"ou taper",4,"AIDE",0,"imprime",TEXT_CRLF
    .byt "la liste des instructions."
    .byt TEXT_END
#elif defined(LANGUAGE_NO)
_Text_GameInstructionsPage1
    .byt 1,"       Slik spiller du (1/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Du har",4,"to timer",0,"til å finne og redde",TEXT_CRLF
    .byt "en ung jente kidnappet av gangstere.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Oppdraget mislykkes om du oppdages",TEXT_CRLF
    .byt "eller går tom for tid.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Gi ordre med",4,"VERB",0,"og",4,"SUBSTANTIV",TEXT_CRLF
    .byt "f.eks: TA NØKKEL eller BLAND BRØD OST",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 1,"   BEVEGELSE            VERB",TEXT_CRLF,TEXT_CRLF
    .byt "N:NORD U:OPP      TA/HENT LEGG/SLIPP",TEXT_CRLF
    .byt "S:SYD D:NED      BLAND/KOMBINER BRUK",TEXT_CRLF
    .byt "E:ØST           KAST SE/SJEKK/GRANSK",TEXT_CRLF
    .byt "W:VEST                LES LET/RANSAK",TEXT_CRLF
    .byt "piltaster/styrespak    PAUSE AVSLUTT",TEXT_CRLF
    .byt "                     HJELP ÅPNE LUKK",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Bruk",4,"CTRL+OPP/NED",0,"eller diagonaler",TEXT_CRLF
    .byt "for å gå opp eller ned.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Trykk",4,"ESC",0,"eller skriv",4,"HJELP",0,"for å se",TEXT_CRLF
    .byt "kommandolisten."
    .byt TEXT_END
#else// LANGUAGE_EN
_Text_GameInstructionsPage1
    .byt 1,"         How to play (1/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "You have",4,"two hours",0,"to find and rescue",TEXT_CRLF
	.byt "a young girl kidnapped by thugs.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "The mission fails if you get detected",TEXT_CRLF
	.byt "or if you run out of time.",TEXT_CRLF
    .byt TEXT_CRLF
	.byt "Give orders using",4,"VERBS",0,"and",4,"NOUNS",TEXT_CRLF
    .byt "eg: GET KEYS or COMBINE BREAD BUTTER",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 1,"   MOVEMENT            VERBS",TEXT_CRLF,TEXT_CRLF
	.byt "N:NORTH U:UP       TAKE/GET DROP/PUT",TEXT_CRLF
	.byt "S:SOUTH D:DOWN     THROW COMBINE USE",TEXT_CRLF
	.byt "E:EAST               EXAMINE/INSPECT",TEXT_CRLF
	.byt "W:WEST             READ SEARCH/FRISK",TEXT_CRLF
    .byt "arrows/joystick      OPEN CLOSE QUIT",TEXT_CRLF
    .byt "                          HELP PAUSE",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Use",4,"CTRL+UP/DOWN",0,"or diagonals to",TEXT_CRLF
    .byt "go up or down.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Pressing",4,"ESC",0,"or typing",4,"HELP",0,"will",TEXT_CRLF
    .byt "print the list of instructions."
    .byt TEXT_END
#endif


#ifdef LANGUAGE_FR
_Text_GameInstructionsPage2
    .byt 1,"        Comment jouer (2/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Appuyez sur",4,"ESPACE",0,"ou le",4,"bouton",0,"pour",TEXT_CRLF
    .byt "choisir les commandes dans un menu.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Parfois le nom d'un",4,"conteneur",0,"vous",TEXT_CRLF
    .byt "sera demandé lors de l'obtention de",TEXT_CRLF
    .byt "certains objets ou substances.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Utilisez",4,"COMBINE",0,"avec deux objets pour",TEXT_CRLF
    .byt "créer quelque chose de nouveau.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "La touche",4,"SHIFT",0,"met en surbrillance",TEXT_CRLF
    .byt "les noms des objets interactifs.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Utilisez",4,"SHIFT+HAUT/BAS",0,"pour faire",TEXT_CRLF
    .byt "défiler les objets si besoin.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Touche",4,"DEL",0,"pour effacer une lettre",TEXT_CRLF
    .byt "ou",4,"CTRL+DEL",0,"pour effacer un mot.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Seuls les mots",4,"valides",0,"sont acceptés:",TEXT_CRLF
    .byt "les erreurs clignotent en rouge.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Le",4,"temps",0,"s'écoule en temps réel mais",TEXT_CRLF
    .byt "vos actions l'accélèrent.",TEXT_CRLF
    .byt TEXT_END
#elif defined(LANGUAGE_NO)
_Text_GameInstructionsPage2
    .byt 1,"       Slik spiller du (2/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Trykk",4,"MELLOMROM",0,"eller",4,"knappen",0,"for å",TEXT_CRLF
    .byt "velge kommandoer fra en meny.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Noen gjenstander krever en",4,"beholder",TEXT_CRLF
    .byt "for transport: spillet spør da om",TEXT_CRLF
    .byt "beholdernavn.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Bruk",4,"KOMBINER",0,"med to gjenstander for",TEXT_CRLF
    .byt "å lage noe nytt.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Bruk",4,"SHIFT",0,"for å fremheve navnene på",TEXT_CRLF
    .byt "gjenstander du kan samhandle med.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Bruk",4,"SHIFT+OPP/NED",0,"for å rulle listen",TEXT_CRLF
    .byt "om gjenstandene ikke får plass.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Trykk",4,"DEL",0,"for å slette et tegn,",TEXT_CRLF
    .byt "eller",4,"CTRL+DEL",0,"for å slette et ord.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Bare",4,"gyldige ord",0,"godtas: feil input",TEXT_CRLF
    .byt "blinker kort i rødt.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Tiden går i",4,"sanntid",0,"; handlinger",TEXT_CRLF
    .byt "får den til å gå fortere.",TEXT_CRLF
    .byt TEXT_END
#else// LANGUAGE_EN
_Text_GameInstructionsPage2
    .byt 1,"         How to play (2/2)",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Press",4,"SPACE",0,"or",4,"fire",0,"to open a menu and",TEXT_CRLF
    .byt "select commands instead of typing.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Some items require a valid",4,"container",TEXT_CRLF
    .byt "to be transported: The game will then",TEXT_CRLF
    .byt "ask you the name of the container.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Use",4,"COMBINE",0,"with two items to create",TEXT_CRLF
    .byt "something new.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Press",4,"SHIFT",0,"to highlight the names of",TEXT_CRLF
    .byt "items you can interact with.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Use",4,"SHIFT+UP/DOWN",0,"to scroll the list",TEXT_CRLF
    .byt "of visible objects if it overflows.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Press",4,"DEL",0,"to delete a character or",TEXT_CRLF
    .byt "press",4,"CTRL+DEL",0,"to delete a whole word.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Only",4,"valid words",0,"are accepted: wrong",TEXT_CRLF
    .byt "input will briefly flash red.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "The",4,"clock",0,"ticks in real-time; actions",TEXT_CRLF
    .byt "make it go faster.",TEXT_CRLF
    .byt TEXT_END
#endif



#ifdef LANGUAGE_FR
_Text_GameInstructionsPage3
    .byt 1,"        Trucs et astuces",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Lire les",4,"documents",0,"peut révéler des",TEXT_CRLF
    .byt "informations utiles.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Vérifiez toutes les",4,"directions",TEXT_CRLF
    .byt "indiquées sur le compas.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Certaines",4,"sorties",0,"sont bien cachées.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "N'oubliez pas d'",4,"ouvrir",0,"et fouiller!",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Tracez une",4,"carte",0,"et annotez-la.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Tout n'est pas lié à votre mission.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Ne prenez pas tout: trouvez d'abord",TEXT_CRLF
    .byt "la",4,"victime",0,"et planifiez le sauvetage.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Le jeu récompense la",4,"curiosité",0,"et",TEXT_CRLF
    .byt "les solutions non violentes.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Tout ce dont vous avez besoin est là",TEXT_CRLF
    .byt "mais être",4,"bricoleur",0,"peut aider.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Bonne chance, vous en aurez besoin!"
    .byt TEXT_END
#elif defined(LANGUAGE_NO)
_Text_GameInstructionsPage3
    .byt 1,"          Tips og triks",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Å lese",4,"dokumenter",0,"kan avsløre",TEXT_CRLF
    .byt "nyttig informasjon.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Sjekk alle",4,"retningene",0,"på kompasset.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Noen",4,"utganger",0,"kan være godt skjult.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Husk å",4,"åpne",0,"ting og sjekke inni!",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Tegn og noter et",4,"kart",0,"- det hjelper.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Ikke alt du finner er relevant.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Ikke ta alt: finn",4,"offeret",0,"først og",TEXT_CRLF
    .byt "legg en plan for redningen.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Spillet belønner",4,"nysgjerrighet",0,"og",TEXT_CRLF
    .byt "ikke-voldelige løsninger.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Alt du trenger finnes her, men du",TEXT_CRLF
    .byt "må kanskje",4,"lage",0,"noen gjenstander.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Lykke til, du vil trenge det..."
    .byt TEXT_END
#else// LANGUAGE_EN
_Text_GameInstructionsPage3
    .byt 1,"         Hints and tips",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Reading",4,"documents",0,"can reveal useful",TEXT_CRLF
    .byt "tidbits of information.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Check all the",4,"directions",0,"indicated",TEXT_CRLF
    .byt "on the directional cross.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Some",4,"exits",0,"may be hidden from sight.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Remember to",4,"open",0,"things: check inside!",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Drawing and annotating a",4,"map",0,"helps.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Not everything you find is relevant.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Don't try to grab everything: find",TEXT_CRLF
    .byt "the",4,"victim",0,"first and plan the rescue.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "The game rewards",4,"curiosity",0,"and",TEXT_CRLF
    .byt "non-violent solutions.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt "Everything you need is here but you",TEXT_CRLF
    .byt "may have to",4,"manufacture",0,"some items.",TEXT_CRLF
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
    .byt "29 septembre 1982",13,13
    .byt "Ma mission : Secourir une fille de",13
    .byt "ses ravisseurs dans une résidence",13
    .byt "bourgeoise isolée.",13,13
    .byt "Ayant le droit d'opérer sans entrave,",13         
    .byt "potentiellement avec force, je garai",13
    .byt "ma voiture au marché local et",13
    .byt "avancai discrètement à pied."
    .byt 0
#elif defined(LANGUAGE_NO)
    .byt "29. september 1982",13,13
    .byt "Mitt oppdrag: Redde en jente fra",13
    .byt "bortførerne i et avsides og",13
    .byt "luksuriøst herskapshus.",13,13
    .byt "Med tillatelse til å operere fritt,",13
    .byt "om nødvendig med makt, parkerte jeg",13
    .byt "bilen ved det lokale markedet og",13
    .byt "avanserte skjult til fots."
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
#elif defined(LANGUAGE_NO)
_Text_Loading_FirstTimeEver
    .byt "Du kan BRUK, LEGG, KAST, KOMBINER.",TEXT_CRLF
    .byt "Noen kan du LES, UNDERSØK eller SØK.",TEXT_CRLF
    .byt 0
_Text_Loading_SecondTime
    .byt "Å drepe er alltid et alternativ, men",TEXT_CRLF
    .byt "pasifisme gir deg flere poeng.",TEXT_CRLF
    .byt 0
_Text_Loading_ThirdTime
    .byt "Noen gjenstander har flere bruksområder,",TEXT_CRLF
    .byt "andre er uten hensikt. Gjett riktig!",TEXT_CRLF
    .byt 0
_Text_Loading_FourthTime
    .byt "Noen gjenstander må lages ved å",TEXT_CRLF
    .byt "kombinere andre gjenstander.",TEXT_CRLF
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
