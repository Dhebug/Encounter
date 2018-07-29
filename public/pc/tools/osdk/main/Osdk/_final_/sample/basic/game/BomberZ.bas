 ' ##########################################################
 ' #Type in program adapted from the book                   #
 ' #"ORIC ATMOS, vos programmes BASIC et langage machine"   #
 ' #Authors : Michel Bussac and Gil Espèche                 #
 ' #Editor : CEDIC NATHAN (1984)                            #
 ' #Original Title : Mission Bonbardement                   #
 ' ##########################################################
 ' # Move with A,Z, < and >
 ' # Fire with space bar
 ' 'BomberZ
 ' 'machine code
 ' #the assembly routine can be used in any game
 ' #for this copy the series of DATA given here and 
 ' #the folowing code :
 ' #    FOR R=0 TO #8D
 ' #    READ A
 ' #    POKE #400+R,A
 ' #    NEXT 
 ' #It can be used in two different ways :
 ' # - With DOKE 0,#BBA9:DOKE 2,#BBA8:CALL#400, you should obtain 
 ' #   a scrolling from right to left
 ' # - With both the same DOKE, but calling the routine in #431, you should obtain 
 ' #   a scrolling from right to left plus the plotting of two characters that you must
 ' #   define at the beginning of the game in #4FD and #4FE. Moreover, used in this way, 
 ' #   this code takes care of keybord handlingand moves the characters according 
 ' #   to the keys pressed.

 #labels                 ' Indicates we want to be using the labels/self numbering system
 #optimize               ' We want to remove all comments, whitespace, etc...

 #define Radar 35
 #define Mine  40

Start:+1:0               ' Start from Line 0, with increments by one line 
 DATA #A2,#00,#A0,#00
 DATA #B1,#00,#91,#02
 DATA #C8,#C0,#26,#D0
 DATA #F7,#A9,#20,#91
 DATA #02,#18,#A5,#02
 DATA #69,#28,#85,#02
 DATA #48,#A5,#03,#69
 DATA #00,#85,#03,#68
 DATA #18,#69,#01,#85
 DATA #00,#A5,#03,#69
 DATA #00,#85,#01,#E8
 DATA #E0,#1C,#D0,#D2
 DATA #60,#A0,#01,#A9
 DATA #20,#91,#04,#88
 DATA #10,#FB,#20,#00
 DATA #04,#AD,#08,#02
 DATA #A2,#01,#C9,#94
 DATA #F0,#0E,#C9,#8C
 DATA #F0,#19,#A2,#28
 DATA #C9,#AE,#F0,#13
 DATA #C9,#AA,#D0,#1E
 DATA #8A,#18,#65,#04
 DATA #85,#04,#A5,#05
 DATA #69,#00,#85,#05
 DATA #4C,#72,#04,#86
 DATA #06,#A5,#04,#38
 DATA #E5,#06,#85,#04
 DATA #A5,#05,#E9,#00
 DATA #85,#05,#A0,#01
 DATA #B1,#04,#C9,#20
 DATA #D0,#0E,#88,#10
 DATA #F7,#A0,#01,#B9
 DATA #FD,#04,#91,#04
 DATA #88,#10,#F8,#60
 DATA #A9,#01,#8D,#FC
 DATA #04,#60
 
 ' Graphics for characters
 DATA 0,48,56,60,31,31,31,7
 DATA 0,0,0,0,48,60,63,32
 DATA 30,45,45,45,30,18,33,63
 DATA 1,1,2,4,8,16,32,32
 DATA 63,0,0,0,0,0,0,0
 DATA 32,32,16,8,4,2,1,1
 DATA 0,0,0,0,0,0,0,63
 DATA 0,30,33,63,18,12,0,0
 DATA 45,24,61,35,51,62,37,35
 DATA 0,0,16,56,24,4,2,1
 
 ' Clear Screen, disable keyboard sound
 CLS:POKE#26A,10
 PLAY 0,7,0,0
 
 ' Load Machine Code
 FOR R=0 TO #8D
   READ A
   POKE #400+R,A
 NEXT 
 
 ' Load Graphics
 FOR R=0 TO 79
   READ A
   POKE#B508+R,A
 NEXT
 
 ' Introduction
introduction
 CLS:PAPER 0:INK2
 PRINT 
 PRINT CHR$(138);CHR$(134);SPC(15)"Bomber Z"
 PRINT CHR$(138);CHR$(133);SPC(15)"Bomber Z"
 PRINT
 PRINT "Controls :"
 PRINT "Up    - A"
 PRINT "Down  - Z"
 PRINT "Left  - <"
 PRINT "Right - >"
 PRINT "Fire  - [Space]"
 PRINT
 PRINT CHR$(135);"   ";CHR$(Radar);" Radar       --> 5 Pts"
 PRINT
 PRINT CHR$(135);"   ";CHR$(Mine);" Flying mine --> 1 Pts"
 PRINT
 PRINT
 PRINT "Press any key to Start":GET A$:GET A$
 CLS
 ' Prepare the screen, load two caracters for the assembly routine in #4FD,and init score
 PAPER 0:INK7:DOKE #4FD,#2221:AC=#25:SC=0
 
 ' delete 'CAPS'
 FOR R=0 TO 3:POKE#BBA4+R,32:NEXT
 
 ' Show up the battle field, and start the engines sound effects
 FOR R=0TO38
   POKE#BBD0+R,39:POKE#BE28+R,37:SOUND4,R,5
 NEXT
 
 ' Prepare the tables for the machine code routine
 DOKE 4,#BD18:M=#BE4E:HM=15:POKE#4FC,0
 
 ' Start of the main loop:vectors initialization for horizontal scrolling
loop
 DOKE0,#BBA9:DOKE2,#BBA8:POKE#BBF6,39
 
 ' Shoot test
 IF T=1 THEN POKE MT,32:GOTO Do_Scrolling
 
 ' Test for fire key
 IF PEEK(#208)=#84 THEN Create_Fire_Shot
 
 ' scoll the screen and move the plane
Do_Scrolling
 CALL#431
 
 ' collision test
 IF PEEK(#4FC)=1 THEN game_lost
 
 ' Shoot second test
 IF T=1 THEN Move_Fire_Shot
 
 ' Random evolution of the game
update_field
 AZ=INT(RND(1)*5)
 ON AZ GOTO ascending_mountain,descending_mountain,radar,mine
 
flat_mountain
 IF AC=#26 OR AC=#23THEN M=M+40:HM=HM+1
 POKEM,37:AC=#25
 GOTO loop
 
ascending_mountain
 IF HM-1<4 THEN flat_mountain
 IF AC=#24 OR AC=#25 THEN M=M-40:HM=HM-1
 POKEM,36:AC=#24
 GOTO loop
 
descending_mountain
 IF HM+1>20 THEN flat_mountain
 IF AC=#26 OR AC=#23 THEN M=M+40:HM=HM+1
 POKEM,38:AC=#26
 GOTO loop
 
radar
 IF AC=#26 THEN new_radar
 GOTO flat_mountain
new_radar
 POKEM,Radar:AC=#23
 GOTO loop
 
mine
 IF INT(RND(1)*2)=0 THEN flat_mountain
 HB=INT(RND(1)*HM)
 POKE#BC1E+40*HB,40
 GOTO flat_mountain
 
 ' Shoot handlers
Create_Fire_Shot
 T=1:MT=DEEK(4):GOTO loop
Move_Fire_Shot
 MT=MT+40
 IFDEEK(MT-1)<>#2020THENBoom
 POKEMT,42:GOTO update_field
 
Boom
 IF PEEK(MT)=Radar THEN boom_radar
 IF PEEK(MT)=Mine  THEN boom_mine
 GOTO boom_common
boom_radar
 SC=SC+5:POKEMT,41:GOTOboom_common
boom_mine
 SC=SC+1:POKEMT,32:GOTOboom_common
boom_common
 T=0:SHOOT
 PAPER7:PAPER0
 PLAY0,7,0,0:SOUND4,6,5
 GOTO update_field
 
game_lost
 FOR R=0 TO 10
   PAPER7:PAPER0
   SOUND4,3*R,15
 NEXT
 EXPLODE
 WAIT50
 CLS:INK3:PRINT"Your Score:";SC;" Points."
 PRINT:PRINT:PRINT:PRINT
 PRINT:PRINTSPC(10)"You loose ..."
 PRINT:PRINT:PRINT
 PRINT"Play again ?":GET A$:GET A$
 IF A$="Y" THEN introduction
