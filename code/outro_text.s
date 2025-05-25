
#include "params.h"

// Redux is an adjective that means brought back, often used in the titles of films and video games. 
// It comes from the Latin word redux, meaning "back again". 

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i ô:^ ç:c â:[ ù:u û:]

_gTextHighScoreAskForName   .byt "Nouveau top score ! Votre nom SVP ?",0
_gTextHighScoreInvalidName  .byt "Entre 1 et 15 caractères",0

_gTextThanks   
    .byt TEXT_CRLF,TEXT_CRLF
#ifdef PRODUCT_TYPE_GAME_DEMO
    .byt 3,10,"Merci d'avoir joué à Encounter Démo",TEXT_CRLF
    .byt 3,10,"Merci d'avoir joué à Encounter Démo",TEXT_CRLF
#else
    .byt 3,10,"Merci d'avoir joué à Encounter Redux",TEXT_CRLF
    .byt 3,10,"Merci d'avoir joué à Encounter Redux",TEXT_CRLF
#endif    
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,10," Nous espérons que vous l'avez aimé.",TEXT_CRLF
    .byt 3,10," Nous espérons que vous l'avez aimé.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
#ifdef PRODUCT_TYPE_GAME_DEMO
    .byt 2,10,"Si oui, achetez donc le jeu complet !",TEXT_CRLF
    .byt 2,10,"Si oui, achetez donc le jeu complet !",TEXT_CRLF
#endif    
    .byt TEXT_CRLF
    .byt TEXT_END

_gTextCredits
    .byt TEXT_CRLF
    .byt 3," Jeu Original ",96, " 1983 Severn Software",TEXT_CRLF
    .byt 6,"      Histoire et programmation:",TEXT_CRLF
    .byt 7,"          Adrian Sheppard",4,"(*)",7,TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,"  Redux version ",96," 2024 Defence Force",TEXT_CRLF
    .byt 6,"         Code, et graphismes:",TEXT_CRLF
    .byt 7,"       Mickael 'Dbug' Pointier",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 6,"               Musique:",TEXT_CRLF
    .byt 7,"  Per Almered (avec Arkos Tracker)",TEXT_CRLF
    .byt 4," (*) supposément"
    .byt TEXT_END

_gTextAdditionalCredits
    .byt TEXT_CRLF,TEXT_CRLF,TEXT_CRLF
    .byt 6,"    Test du jeu et retour d'expérience",TEXT_CRLF
    .byt 7,"   Dom, Lukas, Phreak, Retroric, Symoon",TEXT_CRLF
    .byt TEXT_CRLF,TEXT_CRLF
    .byt 5,"    Développeurs d'Oricutron, merci !",TEXT_CRLF
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
    .byt 6,"        suffit d'aller sur:",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,"      encounter.defence-force.org",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 5,"Vous y trouverez également nos autres",TEXT_CRLF
    .byt 5,"    jeux et démos pour vos Orics.",TEXT_CRLF
    .byt TEXT_END

_gTextGreetings
    .byt TEXT_CRLF
    .byt 6,"Salutations à tous ceux qui continuent",TEXT_CRLF
    .byt 6,"à produire des logiciels pour l'Oric:",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3," Rax - Iss - Andre - Fabrizio - Xeron",TEXT_CRLF
    .byt 1," Dom - Jibe - Chema - Xahmol - Assinie",TEXT_CRLF
    .byt 5,"  Fabrice - h0ffman - Inufuto - Kyex",TEXT_CRLF
    .byt 4,"   Dusan Strakl - Simon Luce - Dunric",TEXT_CRLF
    .byt 6,"   Minter - 6502Nerd - Bieno - BobMar",TEXT_CRLF
    .byt 7,"   Hugo Labrande - DJChloe - Romualdl",TEXT_CRLF
    .byt 2,"     DrPsy - Totoshampoin - 8bitguy",TEXT_CRLF
    .byt TEXT_END
#else
_gTextHighScoreAskForName   .byt "New highscore! Your name please?  ",0
_gTextHighScoreInvalidName  .byt "Choose between 1 and 15 characters",0

_gTextThanks   
    .byt TEXT_CRLF,TEXT_CRLF
#ifdef PRODUCT_TYPE_GAME_DEMO
    .byt 3,10," Thanks for playing Encounter Demo",TEXT_CRLF
    .byt 3,10," Thanks for playing Encounter Demo",TEXT_CRLF
#else
    .byt 3,10," Thanks for playing Encounter Redux",TEXT_CRLF
    .byt 3,10," Thanks for playing Encounter Redux",TEXT_CRLF
#endif    
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,10," We hope you enjoyed the experience.",TEXT_CRLF
    .byt 3,10," We hope you enjoyed the experience.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
#ifdef PRODUCT_TYPE_GAME_DEMO
    .byt 2,10,"If you did, maybe buy the full game?",TEXT_CRLF
    .byt 2,10,"If you did, maybe buy the full game?",TEXT_CRLF
#endif    
    .byt TEXT_END

_gTextCredits
    .byt TEXT_CRLF
    .byt 3," Original game ",96, " 1983 Severn Software",TEXT_CRLF
    .byt 6,"         Game code and story:",TEXT_CRLF
    .byt 7,"           Adrian Sheppard",4,"(*)",7,TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,"  Redux version ",96," 2024 Defence Force",TEXT_CRLF
    .byt 6,"  Code, design, graphics and sounds:",TEXT_CRLF
    .byt 7,"        Mickael 'Dbug' Pointier",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 6,"                Music:",TEXT_CRLF
    .byt 7,"  Per Almered (using Arkos Tracker)",TEXT_CRLF
    .byt 4," (*) we assume"
    .byt TEXT_END

_gTextAdditionalCredits
    .byt TEXT_CRLF,TEXT_CRLF,TEXT_CRLF
    .byt 6,"      Game testing and feedback",TEXT_CRLF
    .byt 7," Dom, Lukas, Phreak, Retroric, Symoon",TEXT_CRLF
    .byt TEXT_CRLF,TEXT_CRLF
    .byt 5,"Special thanks to Oricutron developers",TEXT_CRLF
    .byt TEXT_END

_gTextGameDescription
    .byt TEXT_CRLF
    .byt 3," The original game, released on tape",TEXT_CRLF
    .byt 3," was written 100% in BASIC and had no",TEXT_CRLF
    .byt 3,"  graphics or audio (except EXPLODE).",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 6," This new version showcases what can",TEXT_CRLF
    .byt 6,"  be done using a floppy disk drive",TEXT_CRLF
    .byt 6,"   with a C and assembler program.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 2," The Oric is a quirky machine, but it",TEXT_CRLF
    .byt 2,"  is rewarding if you can master it.",TEXT_CRLF
    .byt TEXT_END

_gTextExternalInformation
    .byt TEXT_CRLF
    .byt 6,"  If you want to know more about the",TEXT_CRLF
    .byt 6," game, report bugs, check for updates",TEXT_CRLF
    .byt 6,"   or simply explore the source code...",TEXT_CRLF
    .byt 6,"  just open your favorite browser to:",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,"      encounter.defence-force.org",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 5," On this site you will also find our",TEXT_CRLF
    .byt 5,"   many other Oric games and demos.",TEXT_CRLF
    .byt TEXT_END

_gTextGreetings
    .byt TEXT_CRLF
    .byt 6," Greetings to all the people who keep",TEXT_CRLF
    .byt 6,"releasing great software for the Oric:",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3," Rax - Iss - Andre - Fabrizio - Xeron",TEXT_CRLF
    .byt 1," Dom - Jibe - Chema - Xahmol - Assinie",TEXT_CRLF
    .byt 5,"  Fabrice - h0ffman - Inufuto - Kyex",TEXT_CRLF
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


;
; Results
;
#ifdef LANGUAGE_FR
_Test_DETAILS_SOLVED_THE_CASE
    .byt 2,"Bravo, vous avez résolu l'affaire !",TEXT_CRLF,TEXT_CRLF
    .byt 3,"L'otage a été libérée et est maintenant",TEXT_CRLF
    .byt 3,"de retour dans sa famille. Bien joué !",TEXT_CRLF
    .byt 0

_Test_DETAILS_MAIMED_BY_DOG
    .byt 5,"Votre mieux n'était pas suffisant. Vous",TEXT_CRLF
    .byt 5,"n'étiez pas de taille face au monstre",TEXT_CRLF
    .byt 5,"et",1,"vous en êtes à peine sorti vivant !",TEXT_CRLF
    .byt 0

_Test_DETAILS_SHOT_BY_THUG
    .byt 1,"Vous avez appris (tard) que réveiller",TEXT_CRLF
    .byt 1,"un voyou armé d'un pistolet n'était pas",TEXT_CRLF
    .byt 1,"une bonne idée.",3,"Vous avez êté plombé",TEXT_CRLF
    .byt 0

_Test_DETAILS_FELL_INTO_PIT
    .byt 6,"Sortir du trou a pris beaucoup de temps",TEXT_CRLF
    .byt 6,"Quand vous en êtes sorti l'otage avait",TEXT_CRLF
    .byt 6,"disparu:",1,"Il était trop tard",TEXT_CRLF
    .byt 0

_Test_DETAILS_TRIPPED_ALARM
    .byt 3,"Un détective aurait dû remarquer les",TEXT_CRLF
    .byt 3,"avertissements et les capteurs sur les",TEXT_CRLF
    .byt 3,"fenêtres:",5,"N'êtes vous pas d'accord ?",TEXT_CRLF
    .byt 0

_Test_DETAILS_RAN_OUT_OF_TIME
    .byt 5,"Vous aviez deux heures mais vous avez",TEXT_CRLF
    .byt 5,"tout de même manqué de temps ! Seriez",TEXT_CRLF
    .byt 5,"vous par hasard un",3,"programmeur ?",TEXT_CRLF
    .byt 0

_Test_DETAILS_BLOWN_INTO_BITS
    .byt 3,"Les explosifs sont",1,"dangereux !",3,"Et qui",TEXT_CRLF
    .byt 3,"va devoir nettoyer tout ce bazar ?",TEXT_CRLF
    .byt 3,"Pas vous en tout cas,",1,"agent éparpillé.",TEXT_CRLF
    .byt 0

_Test_DETAILS_GAVE_UP
    .byt 5,"J'espère que vous aviez une excuse pour",TEXT_CRLF
    .byt 5,"abandonner, car l'otage n'a jamais été",TEXT_CRLF
    .byt 5,"revue après...",1,"C'était votre boulot !",TEXT_CRLF
    .byt 0

_Test_DETAILS_FINISHED_DEMO
    .byt 5,"Vous avez trouvé l'entrée arrière de la",TEXT_CRLF
    .byt 5,"maison. Qui sait ce qui se cache",TEXT_CRLF
    .byt 5,"derrière ces portes !",1,"Curieux ?",TEXT_CRLF
    .byt 0
#else // LANGUAGE_EN
_Test_DETAILS_SOLVED_THE_CASE      
    .byt 2,"Congratulations, you solved the case!",TEXT_CRLF,TEXT_CRLF
    .byt 3,"The hostage has been freed and is now",TEXT_CRLF
    .byt 3,"back with her family. Well done you!",TEXT_CRLF
    .byt 0

_Test_DETAILS_MAIMED_BY_DOG        
    .byt 5,"You probably tried your best, but you",TEXT_CRLF
    .byt 5,"were no match for the four legged beast",TEXT_CRLF
    .byt 5,"and",1,"barely made it alive!",TEXT_CRLF
    .byt 0

_Test_DETAILS_SHOT_BY_THUG        
    .byt 1,"You've learnt (a bit late) that waking",TEXT_CRLF
    .byt 1,"up a thug armed with a big gun was not",TEXT_CRLF
    .byt 1,"a super smart idea.",3,"You bit the bullet",TEXT_CRLF
    .byt 0

_Test_DETAILS_FELL_INTO_PIT        
    .byt 6,"You fell into the pit and were not able",TEXT_CRLF
    .byt 6,"to climb up. By the time you got out",TEXT_CRLF
    .byt 6,"the hostage was gone:",1,"You were too late",TEXT_CRLF
    .byt 0

_Test_DETAILS_TRIPPED_ALARM        
    .byt 3,"You would expect an investigator to see",TEXT_CRLF
    .byt 3,"the warning stickers and the sensors on",TEXT_CRLF
    .byt 3,"the windows,",5,"don't you agree?",TEXT_CRLF
    .byt 0

_Test_DETAILS_RAN_OUT_OF_TIME      
    .byt 5,"You had two hours. And you were warned.",TEXT_CRLF
    .byt 5,"You still managed to run out of time!",TEXT_CRLF
    .byt 5,"Would you happen to be a",3,"programmer?",TEXT_CRLF
    .byt 0

_Test_DETAILS_BLOWN_INTO_BITS      
    .byt 3,"Explosives are",1,"dangerous!",3,"You were",TEXT_CRLF
    .byt 3,"warned multiple times, and now someone",TEXT_CRLF
    .byt 3,"has to clean the mess! ",1,"Rest In Pieces",TEXT_CRLF
    .byt 0

_Test_DETAILS_GAVE_UP              
    .byt 5,"I should hope you had a good excuse to",TEXT_CRLF
    .byt 5,"abandon, because the hostage never had",TEXT_CRLF
    .byt 5,"a chance and was",1,"never seen after...",TEXT_CRLF
    .byt 0

_Test_DETAILS_FINISHED_DEMO
    .byt 5,"You've found the rear entrance of the",TEXT_CRLF
    .byt 5,"mansion. Who knows what you would find",TEXT_CRLF
    .byt 5,"behind these closed doors!",1,"Curious?",TEXT_CRLF
    .byt 0
#endif

_Text_Empty .byt 0

_gScoreConditionsArray
  .word _Text_Empty
  .word _Test_DETAILS_SOLVED_THE_CASE
  .word _Test_DETAILS_MAIMED_BY_DOG  
  .word _Test_DETAILS_SHOT_BY_THUG   
  .word _Test_DETAILS_FELL_INTO_PIT  
  .word _Test_DETAILS_TRIPPED_ALARM  
  .word _Test_DETAILS_RAN_OUT_OF_TIME
  .word _Test_DETAILS_BLOWN_INTO_BITS
  .word _Test_DETAILS_GAVE_UP        
  .word _Test_DETAILS_FINISHED_DEMO


// Bonus texts
#ifdef LANGUAGE_FR
_gTextMonkeyBonus       .byt "%cMonkey King points:%d  ",0   ; The spaces is to clear the decrementing number
_gTextBaseScore         .byt "%cScore:%d  ",0                ; The space is required is the earlier score was negative
_gTextNewAchievement    .byt "%cNouveau succ}s:%c%s%c",0     ; The last %c is to clear the color
_gTextNoTimeBonus       .byt "%cPas de bonus de temps pour vous!%c",0  ; The last %c is to clear the color
#else
_gTextMonkeyBonus       .byt "%cMonkey King points:%d  ",0   ; The spaces is to clear the decrementing number
_gTextBaseScore         .byt "%cScore:%d  ",0                ; The space is required is the earlier score was negative
_gTextNewAchievement    .byt "%cNew achievement:%c%s%c",0    ; The last %c is to clear the color
_gTextNoTimeBonus       .byt "%cNo time bonus for you!%c",0  ; The last %c is to clear the color
#endif
