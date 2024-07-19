
#include "params.h"

// Redux is an adjective that means brought back, often used in the titles of films and video games. 
// It comes from the Latin word redux, meaning "back again". 

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i

_gTextHighScoreAskForName   .byt "Nouveau top score ! Votre name SVP ?",0
_gTextThanks   
    .byt TEXT_CRLF,TEXT_CRLF
    .byt 3,10,"Merci d'avoir joué à Encounter Redux",TEXT_CRLF
    .byt 3,10,"Merci d'avoir joué à Encounter Redux",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,10," Nous espérons que vous l'avez aimé.",TEXT_CRLF
    .byt 3,10," Nous espérons que vous l'avez aimé.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_END

_gTextCredits
    .byt TEXT_CRLF,TEXT_CRLF
    .byt 3," Jeu Original ",96, " 1983 Severn Software",TEXT_CRLF
    .byt 6,"      Histoire et programmation:",TEXT_CRLF
    .byt 7,"          Adrian Sheppard",4,"(*)",7,TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,"  Redux version ",96," 2024 Defence Force",TEXT_CRLF
    .byt 6,"         Code, et graphismes:",TEXT_CRLF
    .byt 7,"       Mickael 'Dbug' Pointier",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt 4,"(*) supposé",TEXT_CRLF
    .byt TEXT_END

_gTextGameDescription
    .byt TEXT_CRLF
    .byt 3,"Le jeu original, sorti sur cassette a",TEXT_CRLF
    .byt 3,"été écrit à 100% en BASIC et n'avait",TEXT_CRLF
    .byt 3,"ni graphismes ni audio (sauf EXPLODE).",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 6,"  Cette version démontre ce qui peut",TEXT_CRLF
    .byt 6,"être fait avec un lecteur de disquette", TEXT_CRLF
    .byt 6,"  avec un programme C et assembleur.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 2," L'Oric est une machine bizarre mais",TEXT_CRLF
    .byt 2,"  gratifiante quand on la maîtrise!", TEXT_CRLF    
    .byt TEXT_END

_gTextExternalInformation
    .byt TEXT_CRLF
    .byt 6,"    Pour en savoir plus sur le jeu", TEXT_CRLF
    .byt 6," signaler un bug, voir le code source",TEXT_CRLF
    .byt 6," ou chercher une mise à jour, il vous",TEXT_CRLF
    .byt 6,"        suffit d'allez sur:",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,"  http://encounter.defence-force.org",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 5,"Vous y trouverez également nos autres",TEXT_CRLF
    .byt 5,"    jeux et démos pour vos Orics.",TEXT_CRLF
    .byt TEXT_END

_gTextGreetings
    .byt TEXT_CRLF
    .byt 6,"Salutations à tous ceux qui continuent",TEXT_CRLF
    .byt 6,"à produire des logiciels pour l'Oric:",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3," Rax - Iss - Andre C - Fabrizio Caruzo",TEXT_CRLF
    .byt 1," Dom - Jibe - Chema - Xahmol - Assinie",TEXT_CRLF
    .byt 5,"    Xeron - h0ffman - Inufuto - Kyex",TEXT_CRLF
    .byt 4,"   Dusan Strakl - Simon Luce - Dunric",TEXT_CRLF
    .byt 6,"   Minter - 6502Nerd - Bieno - BobMar",TEXT_CRLF
    .byt 7,"   Hugo Labrande - DJChloe - Romualdl",TEXT_CRLF
    .byt 2,"     DrPsy - Totoshampoin - 8bitguy",TEXT_CRLF
    .byt TEXT_END
#else
_gTextHighScoreAskForName   .byt "New highscore! Your name please?",0

_gTextThanks   
    .byt TEXT_CRLF,TEXT_CRLF
    .byt 3,10," Thanks for playing Encounter Redux",TEXT_CRLF
    .byt 3,10," Thanks for playing Encounter Redux",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,10," We hope you enjoyed the experience.",TEXT_CRLF
    .byt 3,10," We hope you enjoyed the experience.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_END

_gTextCredits
    .byt TEXT_CRLF,TEXT_CRLF
    .byt 3," Original game ",96, " 1983 Severn Software",TEXT_CRLF
    .byt 6,"         Game code and story:",TEXT_CRLF
    .byt 7,"           Adrian Sheppard",4,"(*)",7,TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,"  Redux version ",96," 2024 Defence Force",TEXT_CRLF
    .byt 6,"          Code, and Graphics:",TEXT_CRLF
    .byt 7,"        Mickael 'Dbug' Pointier",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt 4," (*) we assume",TEXT_CRLF
    .byt TEXT_END

_gTextGameDescription
    .byt TEXT_CRLF
    .byt 3," The original game, releaded on tape",TEXT_CRLF
    .byt 3," was written 100% in BASIC and had no",TEXT_CRLF
    .byt 3,"  graphics or audio (except EXPLODE).",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 6," This new version showcases what can",TEXT_CRLF
    .byt 6,"  be done using a floppy disk drive",TEXT_CRLF
    .byt 6,"   with a C and assembler program.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 2," The Oric is a quirky machine, but it",TEXT_CRLF
    .byt 2,"  is rewarding if you can master it",TEXT_CRLF
    .byt TEXT_END

_gTextExternalInformation
    .byt TEXT_CRLF
    .byt 6,"  If you want to know more about the",TEXT_CRLF
    .byt 6," game, signal bugs, check for updates",TEXT_CRLF
    .byt 6,"   or simply explore the source code...",TEXT_CRLF
    .byt 6,"  just open you favorite browser to:",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,"   http://encounter.defence-force.org",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 5," On this site you will also find our",TEXT_CRLF
    .byt 5,"   many other Oric games and demos.",TEXT_CRLF
    .byt TEXT_END

_gTextGreetings
    .byt TEXT_CRLF
    .byt 6," Greetings to all the people who keep",TEXT_CRLF
    .byt 6,"releasing great software for the Oric:",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3," Rax - Iss - Andre C - Fabrizio Caruzo",TEXT_CRLF
    .byt 1," Dom - Jibe - Chema - Xahmol - Assinie",TEXT_CRLF
    .byt 5,"    Xeron - h0ffman - Inufuto - Kyex",TEXT_CRLF
    .byt 4,"   Dusan Strakl - Simon Luce - Dunric",TEXT_CRLF
    .byt 6,"   Minter - 6502Nerd - Bieno - BobMar",TEXT_CRLF
    .byt 7,"   Hugo Labrande - DJChloe - Romualdl",TEXT_CRLF
    .byt 2,"     DrPsy - Totoshampoin - 8bitguy",TEXT_CRLF
    .byt TEXT_END

; Rax & Iss - Wizard's Lair, Speed Ball, Memory, Mine Sweeper, Pong, cc65 chess, FIFTEEN PUZZLE, FLAPPY ORIC, TREASURE, LUNAR MISSION, BOCCO'S ADVENTURES , ORIC XMAS 2019 
; André C. - Rapidoric, RADAR ORIC, RADAR ORIC 2 , VISUCAR 
; Fabrizio Caruzo - Cross Horde, CROSS BOMBER, CROSS SNAKE, XSHOOT   
; Dom - D Pessan - Meutres a Venise, Athanor 2
; Xahmol - Xander Mol - ORIC SCREEN EDITOR, Ludo
; Jibe - Google Earth, CHEMINS DE GALDEON, LES, FLAPPY ORIC 3D
; Xeron & h0ffman - Iris - No Problem (demo)
; Inufuto - Ascend, Lift
; David Murray, Dusan Strakl, Simon Luce - Attack of the Petscii Robots
; Kyex - Awele-Kalaha
; Dunric, Minter, Chema - Castle Belmar
; 6502Nerd - Dflat
; Assinie - Comal, Focal, TEST JOYSTICKS
; Bieno, Chema & Dom - EL PRISIONERO 
; BOBMAR - Robert Martin - TETRISKOV
; Hugo Labrande - TRISTAM ISLAND
; DJChloe - Chlo� AVRILLON - ORIC KONG 2019 
; Romualdl - HITORIC,  LIGHTS OUT 
; DrPsy, Totoshampoin - ORIC JEWEL
#endif


//     .byt 1,"           Comment jouer",TEXT_CRLF
