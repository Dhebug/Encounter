 ;
 ; Data generator for the high scores
 ;
 ; Each entry occupies 19 bytes:
 ;  2 bytes for the score (+32768)
 ;  1 byte for the game ending condition
 ; 15 bytes for the name (padded with spaces)
 ;-------------------------------------------
 ; 18 bytes per entry * 24 entries = 432 bytes total - But we save 512 because of the save system
 ;
#define ENTRY(type,score,name) .word (score+32768) : .byt type : .asc name

.text

StartScores
 ENTRY(1, 900,"    Lt. Columbo")
 ENTRY(1, 850,"    Miss Marple")
 ENTRY(1, 800,"Sherlock Holmes")
 ENTRY(6, 750,"   Mma Ramotswe")
 ENTRY(2, 700,"       Wishbone")
 ENTRY(6, 650," Hercule Poirot")
 ENTRY(3, 600," Harry Callahan")
 ENTRY(4, 550,"  Veronica Mars")
 ENTRY(6, 500,"Sergeant Zailer")
 ENTRY(6, 450,"    Ben Matlock")
 ENTRY(6, 400,"      Sam Spade")
 ENTRY(7, 350,"   Robert Goren")
 ENTRY(4, 300,"     Nancy Drew")
 ENTRY(6, 250,"  Alex Delaware")
 ENTRY(3, 200,"  Myron Bolitar")
 ENTRY(2, 150,"     Nero Wolfe")
 ENTRY(5, 100," Philip Marlowe")
 ENTRY(7,  50,"      Joe Hardy")
 ENTRY(7,   0,"    Frank Hardy")
 ENTRY(6, -50,"V.I. Warshawski")
 ENTRY(2,-100,"  Thomas Magnum")
 ENTRY(6,-150,"    Adrian Monk")
 ENTRY(3,-200,"C.Auguste Dupin")
 ENTRY(5,-250,"  Insp Clouseau")
 .dsb 56+24         ; Padding
EndScores


; Basic sanity checking, in case I break the macros, or forget some bytes...
#if ((EndScores-StartScores)<>512)
#echo Scores table should be 512 bytes long, but it is:
#print (EndScores-StartScores) 
#else
#echo Scores table successfully exported
#endif
