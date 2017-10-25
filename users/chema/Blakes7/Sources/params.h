
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

/* Some main definitions.... */

#define MAX_OBJECTS			28
#define ROOM_ROWS			17
#define FIRST_VIS_COL			(2-1)
#define LAST_VIS_COL			(37+1)
#define VISIBLE_COLS			(LAST_VIS_COL-FIRST_VIS_COL+1)	
#define SRB_SIZE			(ROOM_ROWS*40/8)
#define DUMP_ADDRESS 			($a000+40*8)
#define OBJ_NAME_LEN			16

/* Locations for data */
#define OBJ_DATA_LOCATION 		$400
#define OASIS_LOCATION 			$c000
#define RESOURCE_TOP			$9fff-32-3	

/* Size of global engine memory space, vars in bytes and flags in bits */
#define SIZE_GLOBAL_VARS		32
#define SIZE_GLOBAL_FLAGS		128

/* Size of local space for threads */
#define LSPACE_S 			16

/* Address at which locals start */
#define LOCALS_START			200

/* Avoid jsrs as much as possible (not _that_ much) */
#define AVOID_JSRS
/* Complete table for x8, waste memory to improve speed (slightly) */
//#define FULLTABLEMUL8

/* Use enormous but faster scroll routines */
#define FASTSCROLLS
/* Set SRB in zero page: uses a lot of space, but good for performance */
#define SRB_IN_ZEROPAGE

/* Display a message when loading game data */
#define LOADING_MSG

/* Use sounds in speech */
//#define SPEECHSOUND
/* If sounds in speech are used, this is the value subtracted to 15 for the volume (15 - silence, 0 - highest) */
#define SPEECHVOL	2
/* If sounds in speech are used, this is the base note to which alterations are added. */
#define SPEECHBASE	20


// For some sanity checks that should be removed in the final game
// Level A (correct facing directions when moving, for instance)
//#define DOCHECKS_A	

// Catch engine exceptions (no memory...)
#define DOCHECKS_B

// Catch some basic scripting exceptions
#define DOCHECKS_C

// Show some debug codes in top row
//#define SHOWDBGINFO
// Show available memory after compaction
//#define DISPLAY_MEMORY

// IJK Joystick support
#define IJK_SUPPORT	


// Attributes
#define A_FWBLACK       00
#define A_FWRED         01
#define A_FWGREEN       02
#define A_FWYELLOW      03
#define A_FWBLUE        04
#define A_FWMAGENTA     05
#define A_FWCYAN        06
#define A_FWWHITE       07
#define A_BGBLACK       16
#define A_BGRED         17
#define A_BGGREEN       18
#define A_BGYELLOW      19
#define A_BGBLUE        20
#define A_BGMAGENTA     21
#define A_BGCYAN        22
#define A_BGWHITE       23

/*This keys don't have an ASCII code assigned, so we will
 use consecutive values outside the usual alphanumeric 
 space.
*/

#define KEY_UP			1
#define KEY_LEFT		2
#define KEY_DOWN		3
#define KEY_RIGHT		4
#define KEY_LCTRL		5
#define KET_RCTRL		6
#define KEY_LSHIFT		7
#define KEY_RSHIFT		8
#define KEY_FUNCT		9
#define KEY_ESC			10
#define KEY_DEL			11
#define KEY_RETURN		12





