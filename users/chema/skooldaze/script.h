;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;Scripting codes
;;----------------


;;;; For implementing Commands

#define SC_END				00	/* Terminate command (and keep halted)									*/
#define SC_GOTO				01	/* Make a character go to a given location (col,row)					*/	
#define SC_RESTIFNOLESSON	02	/* Restart command list until it is time to start a lesson (teachers)	*/
#define SC_FLAGEVENT		03	/* Flag a given event (eventID)											*/
#define SC_MSGSITDOWN		04	/* Tell the children to sit down (teachers)								*/
#define SC_DOCLASS			05	/* Make a teacher conduct a class (teachers)							*/
#define SC_MOVEUNTIL		06	/* Make a character move about until a certain event occurs (eventID)	*/
#define SC_FINDSEAT			07	/* Make a boy find a seat and sit down.									*/	
#define SC_SETCONTSUB		08  /* Places a continual subcommand in the character's buffer (cscommand)	*/
#define SC_CTRLEINSTEINCL1	09  /* Controls Einstein during class phase 1								*/
#define SC_CTRLEINSTEINCL2	10  /* Controls Einstein during class phase 2								*/
#define SC_WRITEBLCKBOARD	11  /* Make a character write on a blackboard if it is clean				*/
#define SC_WRITEBLCKBOARDC	12  /* Same but only if an event is not flagged (eventID)					*/
#define SC_WALKUPDOWN		13  /* Make a character walk up&down n times or until an event (n,eventID)	*/
#define SC_RESTARTLIST		14	/* Restart command list													*/
#define SC_RESTIFNODINNER	15	/* Restart command list until dinner has started (teachers)				*/
#define SC_DINNERDUTY		16  /* Perform dinner duty (teachers)										*/
#define SC_UNFLAGEVENT		17  /* Unflag a given event (eventID)										*/
#define SC_GOTORANDOM		18  /* Make a character go to a random place (in a table)					*/
#define SC_GOTORANDOMTRIP	19  /* Same but tripping people up (boy no 1 for stampede)					*/
#define SC_FOLLOWBOY1TRIP	20  /* Find and follow boy no 1 tripping people up (for stampede)			*/
#define SC_FINDERIC			21	/* Make a character find Eric											*/
#define SC_TELLEINSTEIN		22	/* Tell Eric about Einstein												*/
#define SC_TELLANGELFACE	23	/* Tell Eric about Angelface											*/
#define SC_TELLBOYWANDER	24	/* Tell Eric about BoyWander											*/
#define SC_2000LINESERIC	25	/* Give 2000 lines to Eric												*/
#define SC_ENDGAME			26	/* Tell Eric to go home and end game									*/



/* The spectrum version: 
The address of one of the following uninterruptible subcommand routines may be present 
in bytes 111 and 112 of a character's buffer:
27206 Deal with a character who has been knocked over 
27733 Deal with a character who's been dethroned (1) 
27748 Deal with a character who's been dethroned (2) 
27772 Deal with a character who is looking for a seat 
27932 Control the horizontal flight of a catapult pellet 
28102 Control the vertical flight of a catapult pellet 
28544 Make ANGELFACE throw a punch (1) 
28558 Make ANGELFACE throw a punch (2) 
28642 Make ANGELFACE throw a punch (3) 
28655 Make ANGELFACE throw a punch (4) 
28716 Make BOY WANDER fire his catapult (2) 
28733 Make BOY WANDER fire his catapult (3) 
28744 Make BOY WANDER fire his catapult (4) 
28775 Make BOY WANDER fire his catapult (5) 
28786 Make BOY WANDER fire his catapult (6) 
28799 Make BOY WANDER his fire catapult (7) 
63390 Make a character find ERIC 

The address of one of the following continual subcommand routines will be 
present in bytes 124 and 125 of a character's buffer:
25247 RET (do nothing) 
27126 Make a little boy trip people up 
28446 Make ANGELFACE hit now and then 
28672 Make BOY WANDER fire his catapult now and then 
32234 Make a character walk fast 
64042 Check whether ANGELFACE is touching ERIC 


The address of one of the following interruptible subcommand routines 
(or an entry point thereof) may be present in bytes 105 and 106 of a 
character's buffer:
25404 Guide a character to an intermediate destination 
25484 Guide a character up a staircase 
25488 Guide a character down a staircase 
29148 Make a teacher wipe a blackboard (1) 
29175 Make a teacher wipe a blackboard (2) 
29284 Make a character write on a blackboard 
31110 Make a character speak (1) 
31130 Make a character speak (2) 
31648 Make a teacher find the truant ERIC 
31739 Move a character looking for ERIC from the midstride position 
31944 Make a teacher wait for EINSTEIN to finish speaking 

*/



;;Timetables
;;-------------

;; Main timetable codes. Start with 224, end with 255 so they
;; use the last 32 bytes of a page, and we can get the personal
;; timetable by accessing directly for the character's code

#define DINNER_WITHIT			224
#define DINNER_WACKER			225
#define WACKER_EXAMROOM			226
#define ROCKITT_EXAMROOM		227
#define REV_LIBRARY1			228
#define REV_LIBRARY2			229
#define REV_LIBRARY3			230
#define WITHIT_MAPROOM			231
#define WACKER_READINGROOM		232
#define ROCKITT_READINGROOM		233
#define CREAK_READINGROOM		234
#define CREAK_WHITEROOM			235
#define WACKER_WHITEROOM		236
#define WITHIT_WHITEROOM		237
#define ROCKITT_WHITEROOM		238
#define WACKER_MAPROOM			239
#define WITHIT_MAPROOM			240
#define ROCKITT_WHITEROOM		241
#define CREAK_READINGROOM2		242
#define PLAYTIMEMUMPS			243	
#define PLAYTIMEEINSTEIN		244
#define PLAYTIMEPEASHOOTER		245
#define PLAYTIME1				246
#define PLAYTIME2				247
#define PLAYTIME3				248
#define PLAYTIME4				249
#define PLAYTIME5				250
#define PLAYTIME6				251

; (little boys stampede) 
#define PLAYTIME7S				252	
#define PLAYTIME8S				253	

#define PLAYTIME9				254
#define PLAYTIME10				255

				

/*
65064 DEFB 224 224: DINNER (MR WITHIT) 
65080 DEFB 225 225: DINNER (MR WACKER) 
65068 DEFB 226 226: MR WACKER - EXAM ROOM 
65051 DEFB 227 227: MR ROCKITT - EXAM ROOM 
65035 DEFB 228 228: REVISION LIBRARY 
65070 DEFB 229 229: REVISION LIBRARY 
65058 DEFB 230 230: REVISION LIBRARY 
65026 DEFB 231 231: MR WITHIT - MAP ROOM 
65074 DEFB 232 232: MR WACKER - READING ROOM 
65055 DEFB 233 233: MR ROCKITT - READING ROOM 
65061 DEFB 234 234: MR CREAK - READING ROOM 
65059 DEFB 235 235: MR CREAK - WHITE ROOM 
65039 DEFB 236 236: MR WACKER - WHITE ROOM 
65086 DEFB 237 237: MR WITHIT - WHITE ROOM 
65067 DEFB 238 238: MR ROCKITT - WHITE ROOM 
65046 DEFB 239 239: MR WACKER - MAP ROOM 
65057 DEFB 240 240: MR WITHIT - MAP ROOM 
65077 DEFB 241 241: MR ROCKITT - WHITE ROOM 
65078 DEFB 242 242: MR CREAK - READING ROOM 

243-245 ->Special playtimes (mumps, Einstein, pea-shooter)

65065 DEFB 246 246: PLAYTIME 
65027 DEFB 247 247: PLAYTIME 
65030 DEFB 248 248: PLAYTIME 
65036 DEFB 249 249: PLAYTIME 
65038 DEFB 250 250: PLAYTIME 
65040 DEFB 251 251: PLAYTIME 
65081 DEFB 252 252: PLAYTIME (little boys stampede) 
65049 DEFB 253 253: PLAYTIME (little boys stampede) 
65082 DEFB 254 254: PLAYTIME 
65066 DEFB 255 255: PLAYTIME 


 */


;;; Destinations for the different scripts
;;; --------------------------------------

#define D_FIRE_ESCAPE		3,124
#define D_HEAD_STUDY		3,7+3
#define D_HEAD_DOORWAY		3,10
#define D_LIBRARY_LEFT		3,21
#define D_READING_ENTRANCE	3,54		
#define D_STAFF_ROOM		10,12
#define D_GYM				17,124
#define	D_BIG_WINDOW		17,8+3
#define D_EXAM_BOARD		10,55
#define D_WHITE_BOARD		10,34
#define D_READING_BOARD		3,56
#define D_DINNER_TABLE		17,75
#define D_DINNER_BENCH		17,56
#define D_DINNER_HALL		17,70
#define D_LIBRARY			3,35
#define D_WHITE_ROOM		10,40
#define D_EXAM_ROOM			10,77
#define D_READING_ROOM		3,71
#define D_MAP_ROOM			3,90

#define D_WHITE_DOORWAY		10,30
#define D_ABOARD_WHITE		10,45
#define D_ABOARD1_WHITE		10,44

#define D_EXAM_DOORWAY		10,90-1
#define D_POS_EXAM			10,65

#define D_LIBRARY_INT		3,40
#define D_READING_DOORWAY	3,53
#define D_POS_READING1		3,69
#define D_POS_READING2		3,66

#define D_MAP_DOORWAY		3,98
#define D_MAP_MAP			3,79
#define D_POS_MAP			3,83

;;; Script event identifiers
;;; ------------------------

#define E_EMPTY				 0

#define E_TEACHER_MAP		8
#define E_TEACHER_READING	9
#define E_TEACHER_EXAM		10
#define E_TEACHER_WHITE		11

#define E_LITTLEBOY1_READY	16
#define E_LITTLEBOY1_READY2	17

#define E_EINSTEIN_READY	26
#define E_BOYW_READY		26
#define E_BOYW_GOTPEA		26
#define E_WACKER_READY		27
#define E_BEENTOLD_EINSTEIN 28
#define E_BEENTOLD_BOYW		28
#define E_BEENTOLD_ANGELF	28
#define E_EINSTEIN_GRASSED	29
#define E_ERIC_MUMPS		29


;; Continuous Subcommands
;; -----------------------

#define CS_WALKFAST		<csc_walk_fast,>csc_walk_fast
#define CS_FIRECATAPULT	<csc_bwander_fire,>csc_bwander_fire
#define CS_CHECKTOUCH	<csc_check_touch,>csc_check_touch
#define CS_HITNOWTHEN	<csc_angelhit,>csc_angelhit


