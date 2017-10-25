/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

/* Script commands and definitions */

/* Some default scripts */
/* This is the first script loaded by the engine */
#define SCRIPT_GAME_ENTRY_POINT		0
/* This is the script called when an action could not begin
   handled by the objec's code */
#define SCRIPT_UNHANDLED_ACTIONS	1

; Script commands 
#define SC_STOP_SCRIPT		0
#define SC_RESTART_SCRIPT	1
#define SC_WAIT_EVENT		2
#define SC_ACTOR_WALKTO 	3
#define SC_ACTOR_TALK		4
#define SC_WAIT_FOR_ACTOR	5
#define SC_DELAY		6
#define SC_FOLLOW_ACTOR		7
#define SC_SET_ANIMSTATE	8
#define SC_PAN_CAMERA		9
#define SC_WAIT_FOR_CAMERA	10
#define SC_LOAD_ROOM		11
#define SC_SET_EGO		12
#define SC_BREAK_HERE		13
#define SC_SET_OBJECT_POS	14
#define SC_CHANGE_ROOM_AND_STOP 15
#define SC_ASSIGN		16
#define SC_SETFLAG		17
#define SC_EXECUTE_ACTION	18
#define SC_JUMP_REL		19
#define SC_JUMP_REL_IF		20
#define SC_CHAIN_SCRIPT		21
#define SC_SPAWN_SCRIPT		22
#define SC_SET_EVENTS		23
#define SC_CLEAR_EVENTS		24
#define SC_RUN_OBJECT_CODE	25
#define SC_SET_CAMERA_AT	26
#define SC_SET_FADEEFFECT	27
#define SC_CURSOR_ON		28
#define SC_LOOK_DIRECTION 	29
#define SC_SET_STATE		30
#define SC_SET_COSTUME		31
#define SC_DISABLE_VERB		32
#define SC_SET_WBASWALKABLE	33
#define SC_SET_NEXTWB		34
#define SC_PLAY_TUNE		35
#define SC_WAIT_FOR_TUNE	36
#define SC_STOP_TUNE		37
#define SC_SHOW_VERBS		38
#define SC_PRINT		39
#define SC_PRINT_AT		40
#define SC_REDRAW_SCREEN	41
#define SC_PUT_IN_INVENTORY	42
#define SC_REMOVE_FROM_INVENTORY 43
#define SC_LOAD_RESOURCE	44
#define SC_NUKE_RESOURCE	45
#define SC_LOCK_RESOURCE	46
#define SC_UNLOCK_RESOURCE	47
#define SC_LOAD_OBJECT		48
#define SC_REMOVE_OBJECT	49
#define SC_SET_OVERRIDE		50
#define SC_CLEAR_ROOMAREA	51
#define SC_JUMP			52
#define SC_JUMP_IF		53
#define SC_START_DIALOG		54
#define SC_END_DIALOG		55
#define SC_LOAD_DIALOG		56
#define SC_ACTIVATE_DLGOPT	57
#define SC_FREEZE_SCRIPT	58
#define SC_FREEZE_ALL_SCRIPTS 	59
#define SC_TERMINATE_SCRIPT	60
#define SC_FADETOBLACK		61
#define SC_PLAYSFX		62
#define SC_STOPCHARACTION	63
#define SC_LOADGAME		64
#define SC_SAVEGAME		65
#define SC_MENU			66
#define SC_BWPALETTE		67
#define SC_ROOMPALETTE		68
#define SC_STOPSFX		69
#define SC_CLEAR_INVENTORY	70

/* Functions (bit 7 = 1, remove to get entry in table)*/

/* Set 1: Logic & Math */

#define FIRSTMATH		0+$80

#define SF_ADD			FIRSTMATH+0
#define SF_SUB			FIRSTMATH+1
#define SF_MUL			FIRSTMATH+2
#define SF_DIV			FIRSTMATH+3
#define SF_AND			FIRSTMATH+4
#define SF_OR			FIRSTMATH+5
#define SF_NOT			FIRSTMATH+6
#define SF_EQUAL		FIRSTMATH+7
#define SF_EQ			SF_EQUAL
#define SF_GE			FIRSTMATH+8
#define SF_GT			FIRSTMATH+9
#define SF_LE			FIRSTMATH+10
#define SF_LT			FIRSTMATH+11
#define SF_GETRAND		FIRSTMATH+12
#define SF_GETRANDINT		FIRSTMATH+13
#define SF_GETVAL		FIRSTMATH+14
#define SF_GETFLAG		FIRSTMATH+15

/* Set 2: Object Control */
#define FIRSTOBJCTRL		FIRSTMATH+16

#define SF_GET_EGO		FIRSTOBJCTRL+0
#define SF_GET_TALKING		FIRSTOBJCTRL+1
#define SF_GET_COL		FIRSTOBJCTRL+2
#define SF_GET_ROW		FIRSTOBJCTRL+3
#define SF_GET_FACING		FIRSTOBJCTRL+4
#define SF_GET_ROOM		FIRSTOBJCTRL+5
#define SF_GET_WALKBOX		FIRSTOBJCTRL+6
#define SF_GET_COSTID		FIRSTOBJCTRL+7
#define SF_GET_COSTNO		FIRSTOBJCTRL+8
#define SF_GET_STATE		FIRSTOBJCTRL+9
#define SF_IS_NOTMOVING		FIRSTOBJCTRL+10
#define SF_GET_ANIMSTATE	FIRSTOBJCTRL+11
#define SF_GET_WALKROW		FIRSTOBJCTRL+12
#define SF_GET_WALKCOL		FIRSTOBJCTRL+13
#define SF_GET_WALKFACEDIR	FIRSTOBJCTRL+14
#define SF_GET_COLORSPEECH	FIRSTOBJCTRL+15
#define SF_GET_SIZEX		FIRSTOBJCTRL+16
#define SF_GET_SIZEY		FIRSTOBJCTRL+17
#define SF_GET_ANIMSPEED	FIRSTOBJCTRL+18
#define SF_IS_ACTOR		FIRSTOBJCTRL+19
#define SF_IS_PROP		FIRSTOBJCTRL+20
#define SF_GET_CLOSESTACTOR	FIRSTOBJCTRL+21
#define SF_GET_DISTANCE		FIRSTOBJCTRL+22
#define SF_GET_OBJAT		FIRSTOBJCTRL+23
#define SF_IS_OBJINVENTORY	FIRSTOBJCTRL+24

/* Set 3: Room control */
#define FIRSTROOM		FIRSTOBJCTRL+25

#define SF_GET_CURROOM		FIRSTROOM+0
#define SF_GET_ROOMCOLS		FIRSTROOM+1
#define SF_IS_WALKBOXWALKABLE	FIRSTROOM+2
#define SF_GET_NEXTWALKBOX	FIRSTROOM+3

/* Set 4: Actions */
#define FIRSTACTION		FIRSTROOM+4


#define SF_GET_ACTIONACTOR	FIRSTACTION+0
#define SF_GET_ACTIONVERB	FIRSTACTION+1
#define SF_GET_ACTIONOBJ1	FIRSTACTION+2
#define SF_GET_ACTIONOBJ2	FIRSTACTION+3

/* Set 5: Camera control */
#define FIRSTCAMERA		FIRSTACTION+4

#define SF_GET_CAMERACOL	FIRSTCAMERA+0
#define SF_GET_CAMERAFOLLOWING	FIRSTCAMERA+1
#define SF_GET_FADEEFFECT	FIRSTCAMERA+2
#define SF_IS_CAMERAINACTION	FIRSTCAMERA+3

/* Set 4: Script engine & misc */
#define FIRSTENGINE		FIRSTCAMERA+4

#define SF_IS_SCRIPTRUNNING	FIRSTENGINE+0
#define SF_IS_MUSICPLAYING	FIRSTENGINE+1
	
	
