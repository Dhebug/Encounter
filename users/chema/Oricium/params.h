/*
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
*/

/* General definition file */

/* Attributes */
#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7
#define A_BGBLACK       16
#define A_BGRED         17
#define A_BGGREEN       18
#define A_BGYELLOW      19
#define A_BGBLUE        20
#define A_BGMAGENTA     21
#define A_BGCYAN        22
#define A_BGWHITE       23

#define A_STD            8
#define A_ALT            9
#define A_STD2H         10
#define A_ALT2H         11
#define A_STDFL         12
#define A_ALTFL         13
#define A_STD2HFL       14
#define A_ALT2HFL       15
#define A_TEXT60        24
#define A_TEXT50        26
#define A_HIRES60       28
#define A_HIRES50       30

#define NEWLINE			31

/* Character that represents an empty space */
/* (for user input in names or savecodes    */
#define DELETE_CHAR   "."

/* Row to start the play area */
#define START_ROW 5

/* Number of stars in the background */
#define NSTARS 30

/* Column and row where manta is located */
#define HERO_AT_SIDE
#ifdef HERO_AT_SIDE
#define MANTA_COL 19-8
#else
#define MANTA_COL 19
#endif
#define MANTA_ROW 10

/* Column where boss is placed */
#define BOSS_COL 100


/* Which is the last level? (zero based, so -1) */
#define LAST_LEVEL 41

//#define TRYAIC

/* Define if either lives or frame rate control is to be displayed */
//#define DISPLAY_FRC

/* Steps during which a shot is active */
#ifdef HERO_AT_SIDE
#define SHOT_LENGTH 20
#else
#define SHOT_LENGTH 20
#endif

/* Columns to be protected (not drawn) */
#define PCOLSL 2
#define PCOLSR 2

/* Constants for characters. These are zero based */
#define MAX_SPRITES 	15
#define NUM_SHOTS 		(4+4)
#define FIRST_SHOT  	(MAX_SPRITES-NUM_SHOTS+1)

/* Number of maximum simultaneous enemies */
#define MAX_ENEMIES 	(6-1+1)

/* Number of total enemies in onslaught mode */
#define NUM_ENEMIES_ONSLAUGHT 10

/* Number of lives initially for the player */
#define PLAYER_LIVES 3

/* Initial energy for the player */
#define INITAL_ENERGY 10

/* Tile that represents a star */
#define STAR_TILE 54


/* Tile that represents an energy ball */
#define ENERGYBALL_TILE 55

/* Tile where barriers start (must have the $20 added) */
#define BARRIER_START 50+$20

/* Tiles for the switches (must have the $20 added)*/
#define BASE_SWITCH 46+$20

/* Position of radar (column) */
#define RADAR_COL		12+1

/* Text tiles where the radar is going */
#define RADAR_BASE ($9900+26*8)

/* Flags */
#define IS_ACTIVE		1
#define IS_EXPLODING	2

/* Energy loss for every collision */
#define ENLOS_COLLISION	5

/* Levels */

#define LEV_TUTORIAL	 5
#define LEV_CAKE		10
#define LEV_AVERAGE		17
#define LEV_CHALLENGING	24
#define LEV_LETHAL		30
#define LEV_MAYHEM		37
#define LEV_ELITE		100