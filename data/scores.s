 ;
 ; Data generator for the high scores
 ;
 ; Each entry occupies 19 bytes:
 ;  2 bytes for the score (+32768)
 ;  1 byte for the game ending condition
 ;  1 byte to know if it's a premade score or one unlocked by the player
 ; 15 bytes for the name (padded with spaces)
 ;-------------------------------------------
 ; 19 bytes per entry * 24 entries = 456 bytes total - But we save 512 because of the save system
 ;
 ; In addition we have 8 bytes of start marker and 8 bytes of end marker, plus some settings and the achievements
 ;
#define ENTRY(condition,score,name) .word (score+32768) : .byt condition,0 : .asc name

.text

// Bonus points calculation:
// If the player quits immediately, they current time is 2:00:00 = 7200 seconds
// We take half of that as bonus points, so maximum time bonus is 3600 points
//
// If the player saved the girl, they had to:
// -  500 - Get rid of the dog
// -  500 - Get rid ot the thug
// - 1000 - Meet the girl on the patio
// - 1000 - Reach the end 
// ----------------------
// - 3000 - Total + bunch of things
//
// Not sure if we can reach 5000 by doing all the extra stuff, need to play test
//
StartScores
 .byt "SAVESTRT"                      ; Start marker
 .byt "VERSION"
 ENTRY(1,5000,"    Lt. Columbo")
 ENTRY(1,4500,"    Miss Marple")
 ENTRY(1,3000,"Sherlock Holmes")
 ENTRY(6,2500,"   Mma Ramotswe")
 ENTRY(2,2000,"       Wishbone")
 ENTRY(6,1900," Hercule Poirot")
 ENTRY(3,1800," Harry Callahan")
 ENTRY(4,1700,"  Veronica Mars")
 ENTRY(6,1600,"Sergeant Zailer")
 ENTRY(6,1500,"    Ben Matlock")
 ENTRY(6,1400,"      Sam Spade")
 ENTRY(7,1300,"   Robert Goren")
 ENTRY(4,1200,"     Nancy Drew")
 ENTRY(6,1100,"  Alex Delaware")
 ENTRY(3, 900,"  Myron Bolitar")
 ENTRY(2, 500,"     Nero Wolfe")
 ENTRY(5, 100," Philip Marlowe")
 ENTRY(7,  50,"      Joe Hardy")
 ENTRY(7,   0,"    Frank Hardy")
 ENTRY(6, -50,"V.I. Warshawski")
 ENTRY(2,-100,"  Thomas Magnum")
 ENTRY(6,-150,"    Adrian Monk")
 ENTRY(3,-200,"C.Auguste Dupin")
 ENTRY(5,-250,"  Insp Clouseau")
 .dsb 6                              ; 6*8=48 achievements
 .dsb 56-6-4-8-8-5-1                 ; Padding (forced to zero)
 .byt 0                              ; joystick_interface - NONE by default
 .byt 0                              ; keyboard_layout - QWERTY by default (should be language checked?)
 .byt 1                              ; music_enabled by default
 .byt 1                              ; sound_enabled by default
 .byt 0                              ; launchCount - Number of times the game has been launched
 .byt "SAVE-END"                     ; End marker
EndScores


; Basic sanity checking, in case I break the macros, or forget some bytes...
#if ((EndScores-StartScores)<>512)
#echo Scores table should be 512 bytes long, but it is:
#print (EndScores-StartScores) 
#else
#echo Scores table successfully exported
#endif
