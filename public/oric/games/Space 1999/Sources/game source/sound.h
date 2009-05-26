/*

Some definitions for playing sound effects.

Music tracks (and channels used)

   0)Title Tune (Start Event 0) (ABC) (game start) 
   1)Reggae Track               (AB)  (infoposts)
   2)Repeating Drum Pattern     (A)   (speeches)
   3)Pool Music                 (AB)  (dark, dying)
   4)Hifi Music                 (AB)  (success)


Sound effects

   00 Switch 
   01 Door Opening/Closing 
   02 Pick up 
   03 Drop 
   04 Step #1 (Hard Floor) 
   05 Step #2 (Soft Floor) 
   06 Lift Start 
   07 Lift End 
   08 Alarm #1 (Power Down) 
   09 Effect #1 (InfoPost) 
   10 New Msg through Commlink 
   11 Effect #2 (InfoPost) 
   12 Computer Room #1 
   13 Computer Room #2 
   14 Beep for Info Messages in Text Area 
   15 Robot Shuffle 
   16 Alarm #2 
   17 Dying 
   18 Not Sure 
   19 Contact with Enemy 
   20 Alarm #3 (Life Support Circuit Open) 
   21 Alarm #3 End


To work load data on register A and call PlayAudio

Data is as follows:
Bit 0-1 Forms value 0-3 
        0 Assign Music to Track specified in Data 
    1 Assign Effect specified in Data to Channel A 
        2 Assign Effect specified in Data to Channel B 
        3 Assign Effect specified in Data to Channel C 
Bit 2-6 Forms value 0-31 
        0-31 Data 
Bit 7-7 Forms value 0-1 
    0 Stop Effect on specified Channel or Track 
    1 Start Effect on specified Channel or Track

*/


// Music tracks

#define STOP_ALL 0
#define STOP_TRACK 0

#define TRACK_0_ON %10000000
#define TRACK_1_ON %10000100
#define TRACK_2_ON %10001000
#define TRACK_3_ON %10001100
#define TRACK_4_ON %10010000


// Sfx
;#define TOGGLE          %10000011
#define MENUCHG          %10000011
#define DOOR            %10000111
#define PICKUP          %10001011  
#define DROP            %10001111
#define STEPK           %10010011
#define STEPH           %10010111
#define LIFT_START      %10011011
#define LIFT_STOP       %10011111
#define ALARMPWR        %10100001 
;#define MENUCHG         %10100111
#define TOGGLE          %10100111
#define NEWMSG          %10101011
#define MENUSEL         %10101111
#define BEEPS1          %10110010
#define BEEPS2          %10110110
#define BEEPGRL         %10111011
#define SHUFFLE         %10111111
#define ALARM           %11000001
#define DYING           %11000111
#define BUMP2           %11001011
#define BUMP            %11001111
#define ALARMLSA        %11010001
#define ALARMLSB        %11010101

#define ALARMPWR_OFF    %00100001
#define BEEPS1_OFF      %00110010
#define BEEPS2_OFF      %00110110
#define ALARM_OFF       %01000001


/* Used in game
    DYING NEWMSG TOGGLE MENUCHG DROP STEPH STEPK DOOR LIFT_STOP BUMP PICKUP LIFT_START MENUSEL BEEPGRL
*/