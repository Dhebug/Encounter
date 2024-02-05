
#include "params.h"

_gHighScores          .dsb 512   ; 456 bytes of actual score data, padded to 512 bytes for the saving system

// Redux is an adjective that means brought back, often used in the titles of films and video games. 
// It comes from the Latin word redux, meaning "back again". 

#ifdef LANGUAGE_FR
_gTextHighScoreAskForName   .byt "Nouveau top score ! Votre name SVP ?",0
#else
_gTextHighScoreAskForName   .byt "New highscore! Your name please?",0

_gTextThanks   
    .byt TEXT_CRLF,TEXT_CRLF
    .byt 3,10,"Thanks for playing Encounter Redux",TEXT_CRLF
    .byt 3,10,"Thanks for playing Encounter Redux",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3,10,"We hope you enjoyed the experience.",TEXT_CRLF
    .byt 3,10,"We hope you enjoyed the experience.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_END

_gTextCredits
    .byt TEXT_CRLF,TEXT_CRLF
    .byt 3,"Original game ",96, " 1983 Severn Software",TEXT_CRLF
    .byt 6,"        Game code and story:",TEXT_CRLF
    .byt 7,"          Adrian Sheppard",4,"(*)",7,TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3," Redux version ",96," 2024 Defence Force",TEXT_CRLF
    .byt 6,"         Code, and Graphics:",TEXT_CRLF
    .byt 7,"          Mickael Pointier",TEXT_CRLF
    .byt TEXT_CRLF
    .byt TEXT_CRLF
    .byt 4,"(*) we assume",TEXT_CRLF
    .byt TEXT_END

_gTextGameDescription
    .byt TEXT_CRLF
    .byt 3,"The original game, releaded on tape",TEXT_CRLF
    .byt 3,"was written 100% in BASIC and had no",TEXT_CRLF
    .byt 3," graphics or audio (except EXPLODE).",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 6,"This new version showcases what can",TEXT_CRLF
    .byt 6," be done using a floppy disk drive",TEXT_CRLF
    .byt 6,"  with a C and assembler program.",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 2,"The Oric is a quirky machine, but it",TEXT_CRLF
    .byt 2," is rewarding if you can master it",TEXT_CRLF
    .byt TEXT_END

_gTextExternalInformation
    .byt TEXT_CRLF
    .byt 6," If you want to know more about the",TEXT_CRLF
    .byt 6,"game, signal bugs, check for updates",TEXT_CRLF
    .byt 6,"  or simply explore the source code...",TEXT_CRLF
    .byt 6," just open you favorite browser to:",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 3," http://encounter.defence-force.org",TEXT_CRLF
    .byt TEXT_CRLF
    .byt 5,"On this site you will also find our",TEXT_CRLF
    .byt 5,"  many other Oric games and demos.",TEXT_CRLF
    .byt TEXT_END

#endif


//     .byt 1,"           Comment jouer",TEXT_CRLF
