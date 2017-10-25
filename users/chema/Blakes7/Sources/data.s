
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;; Data file

#include "params.h"
#include "object.h"
#include "thread.h"
#include "core.h"
#include "verbs.h"
#include "inventory.h"

.bss
; This whole area will be initialized by game routines,
; thus is not included in the generated data (except tables)
; which are loaded from disk. Therefore the .bss section
*=OBJ_DATA_LOCATION

; Table data is loaded from disk at this location
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#include "tables.s"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; META: This was in zero page. Moved here when SRB went there.
; Now there is no free space in zero page anymore
; Frame counter, for character speed, for instance
nFrameCount	.byt 0

#ifndef SRB_IN_ZEROPAGE
; Screen refresh buffer
SRB .dsb ROOM_ROWS*5
#endif

; Index in array of actor running the action. Could be started by
; the user, and then be the ego, or from a script.
ActorExecutingAction	.byt 00	
CommandRunning		.byt 0

; Last frame time in IRQs
LastFrameTime	.byt 0

; Some temporal storage 
dlg_count .byt  0	
dlg_count2 .byt 0
dlg_row .byt  0	

; Some stuff for printing texts (text.s)
print2buffer	.byt 00	; Prints in str buffer, for formatting text
buffercounter	.byt 00
double_height	.byt 00
; Moved to _main
;str_buffer	.dsb 40	

#ifdef SPEECHSOUND
pointer2string  .word 0000 ; Pointer to last printed string, to make speech sounds
#else
last_nchars_printed	.byt 0	; Last number of characters printed by print
#endif

Cursor_origin_x .dsb 1 
Cursor_origin_y .dsb 1 


; For dealing with menu
MenuShown 		.byt 0

; Put this as a value different from 0
; and text will be printed on caps.
capson .byt 00

; Walkbox data (box.s) stuff
; Pointers to current walkbox data
nWalkBoxes 	.byt 0
pWalkBoxes 	.word 0
pWalkMatrix 	.word 0

; The virtual Key Matrix
_KeyBank .dsb 8



; This moved to tables.s to fit in holes in Hires Scan table
#if MAX_THREADS<>16
#error ***** Check this!!!!!!!
#endif
;thread_script_pt_lo		.dsb MAX_THREADS,0	; Low byte of script pointer
;thread_script_pt_hi		.dsb MAX_THREADS,0	; High byte of script pointer

; For walkboxes
owb .byt 0
;dwb .byt 0

; These are used in the getWalkCoordinates stuff
orig_col .byt 0
orig_row .byt 0
dest_col .byt 0
dest_row .byt 0


; Signaling if we are in pause mode
InPause	.byt 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Here starts the area that needs to be saved
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
__SaveGameData_start

; This is to detect the pressence of a valid savepoint
magic
.byt %00111100	

__inventory_data_start
; Number of objects currently in the inventory
nObjectsInventory	.byt 0
; Inventory object IDs
inventory_id 		.dsb MAX_ITEMS_INV,$ff
; Object flags (should be used over another item?)
inventory_flags		.dsb MAX_ITEMS_INV,0
; Object names
inventory_names	; As many as max inventory items??
	.dsb OBJ_NAME_LEN*(MAX_ITEMS_INV),0
__inventory_data_end
	
#echo Size of Object inventory array:
#print (__inventory_data_end - __inventory_data_start)
#echo	


__object_data_start
; Data for characters and objects in the game. Data that needs saving

; ID of the object in this position of the array:
obj_id
	.dsb MAX_OBJECTS, OBJ_EMPTY_ENTRY
; Identification of costume used by this object
costume_id
	.dsb MAX_OBJECTS, 0
costume_no	
	.dsb MAX_OBJECTS, 0
; Animatory state for this object
anim_state 
	.dsb MAX_OBJECTS,0
; Color of the text speech for this character
color_speech
	.dsb MAX_OBJECTS,0
; Room the character is in
room
	.dsb MAX_OBJECTS,0
; Position of character in the room
pos_row
	.dsb MAX_OBJECTS, 0
pos_col
	.dsb MAX_OBJECTS, 0
; Position a character has to move to interact with this character.
; if the entry is $ff it means it has to be calculated from
; the position of the character
walk_row
	.dsb MAX_OBJECTS, 0
walk_col
	.dsb MAX_OBJECTS, 0
	
; direction the actor should face to interact
; with object. $ff means use default	
face_dir
	.dsb MAX_OBJECTS, $ff
; Size of character in tiles	
size_rows
	.dsb MAX_OBJECTS, 0	
size_cols
	.dsb MAX_OBJECTS, 0
; z-Plane the character is currently in	
z_plane
	.dsb MAX_OBJECTS, ZPLANE_0
; Direction the character is facing	
direction
	.dsb MAX_OBJECTS,FACING_RIGHT
; Object flags: OBJ_FLAG_ACTOR, OBJ_FLAG_PROP, OBJ_FLAG_USEDWITHOTHER
flags	
	.dsb MAX_OBJECTS, 0	
;  This is an AND mask for the frame counter 
; (tests if frame&&anim_speed == 0) 00: every frame, 01: every other frame, 11, every 4 frames, ...	
anim_speed 
	.dsb MAX_OBJECTS,%01

; As many as MAX_OBJECTS	
obj_names
	.dsb OBJ_NAME_LEN*MAX_OBJECTS,0
__object_data_end

#echo Size of Object data array:
#print (__object_data_end - __object_data_start)
#echo


; Current fade effect to perform
CurrentFadeEffect .byt FADE_RIGHTLEFT

; Thread data
thread_script_type		.dsb MAX_THREADS,0 	; Type of script associated to this thread (RESOURCE_SCRIPT, RESOURCE_OBJECTCODE,...)
thread_script_id		.dsb MAX_THREADS,0 	; ID of script associated to this thread
thread_parent_thread		.dsb MAX_THREADS,$ff	; Parent thread ($ff if not spawned by another script)
thread_state			.dsb MAX_THREADS,0 	; State of thread: RUNNING, PENDED (a child was spawned), DELAYED, FROZEN, WAITING_EVENT
thread_timeout			.dsb MAX_THREADS,0	; Timeout for DELAYED status. When 0 thread is resumed
thread_event_mask		.dsb MAX_THREADS,0	; Mask of events to wait for in WAITING_EVENT state
thread_offset_lo		.dsb MAX_THREADS,0	; Low byte of script offset to current instruction
thread_offset_hi		.dsb MAX_THREADS,0	; High byte of script offset to current instruction

_CurrentEgo		.byt $ff	; ID Object currently set as ego (there is a current ego entry var out there...)
_CurrentRoom		.byt $ff	; Current Room ID
;_CameraCol		.byt 00		; META: This is unused now
_TalkingActor		.byt $ff	; Current actor talking, if any (entry, not ID)
_CurrentThread		.byt $ff	; Current running thread (thread number not script or code ID)
_EntryScript		.byt $ff	; Entry script for this room
_ExitScript		.byt $ff	; Exit script for this room
_EngineEvents		.byt 0		; Events to monitor for the threads
_PlayingTuneID		.byt $ff	; Current tune being played, if any

; Global vars
_VARS 
.dsb SIZE_GLOBAL_VARS, 0
_FLAGS
.dsb SIZE_GLOBAL_FLAGS/8,0

; Local thread space
_LSPACE
.dsb MAX_THREADS*LSPACE_S,0	

; Copy of first_col
first_col_copy 		.byt 00

; Mouse status
MouseOff		.byt 00

; Are verbs and inventory shown?
VerbsShown		.byt 00

; Current actor the camera is following
actor_following		.byt $ff

; Menu Selections
vol_sel   	.byt 0

; Vars needed for overriding when pressing ESC
override_thread .byt $00
override_offset .word $0000

; Talk selection speed or sound
ttalk_sel 	.byt 1

; List of Global Resources
_GlobalResourceList .dsb 256-((*-__SaveGameData_start)&255) 

__SaveGameData_end

	
#echo Size of Save Data Chunk:
#print (__SaveGameData_end - __SaveGameData_start)
#echo	

	
; For scrolling the item list
first_item_shown 	.byt 0

__object_dataB_start
; Data for characters and objects in the game. Data that need no saving

; Tables with addresses where the tiles for characters
; are stored. This allows different tile sets for
; groups of objects.
; Other pointers to animatory state data (current as and base)
; All this can be calculated from data (no need to save)
tab_tiles_hi
	.dsb MAX_OBJECTS, 0
tab_tiles_lo
	.dsb MAX_OBJECTS, 0	
tab_masks_hi
	.dsb MAX_OBJECTS, 0	
tab_masks_lo
	.dsb MAX_OBJECTS, 0	
base_as_pointer_high 
	.dsb MAX_OBJECTS, 0	
base_as_pointer_low  
	.dsb MAX_OBJECTS, 0	
as_pointer_high 
	.dsb MAX_OBJECTS, 0	
as_pointer_low  
	.dsb MAX_OBJECTS, 0	
		
; Pointers to current commands being executed for an object	
; If any command is active when a saving is performed, they
; should be saved, else we can avoid this data too
command_high
	.dsb MAX_OBJECTS,0
command_low
	.dsb MAX_OBJECTS,0
subcom_high
	.dsb MAX_OBJECTS,0
subcom_low
	.dsb MAX_OBJECTS,0
; Internal variables used by commands	
var1
	.dsb MAX_OBJECTS,0
var2
	.dsb MAX_OBJECTS,0
var3
	.dsb MAX_OBJECTS,0
var4
	.dsb MAX_OBJECTS,0
; State for the stride frame. For animation of left/right walk	
stride_step
	.dsb MAX_OBJECTS,0

__object_dataB_end

#echo Size of Object data array:
#print (__object_dataB_end - __object_dataB_start)
#echo


; Drawing queue ordered by row and taking z_plane into account	
tab_objects .dsb MAX_OBJECTS,0	


; Number of active objects
nActiveObjects		.byt 0


; For dialog management
InDialogMode .byt 00
; String resource with strings to print as options
DlgStringRes .byt 00
; Which sttings are active?. Entry is string ID. Ends with $ff
DlgActiveOptions .dsb 16,0
; Script ID with responses
DlgScript .byt 200
; Offsets
DlgOffsetsLo .dsb 16,0
DlgOffsetsHi .dsb 16,0


; Camera control stuff (core.s)
camera_command_hi 	.byt 0
camera_command_lo 	.byt 0
var_camera		.byt 0
var_camera2		.byt 0

; Other stuff used in core.s
CurrentEgoEntry		.byt 00 	; Current entry number for the ego character
RoomChanged 		.byt 0  	; Flag to indicate if room changed
pPalette 		.word 00 	; pointer to attrib data


; This is for executing actions (verbexec.s). Check, as some may have to be saved
SentenceChanged		.byt 01
LookingForObj2		.byt 00

; Action being performed: verb + two objects.
CurrentVerb		.byt VERB_WALKTO
CurrentObject1		.byt $ff
CurrentObject2		.byt $ff
Obj1FromInventory	.byt 0
Obj2FromInventory	.byt 0

; Action being constructed by user
SelCurrentVerb		.byt VERB_WALKTO
SelCurrentObject1	.byt $ff
SelCurrentObject2	.byt $ff
SelObj1FromInventory	.byt 0
SelObj2FromInventory	.byt 0

; Some temporary vars used in object routines
tmp_X .byt 00
tmp_X2 .byt 00
tmp_Y .byt 00
temp_code .byt 00

; Parameters for threads
param_blk .dsb 7

	
freespace
	
#if *>$1d30
#echo *******************************************************
#echo ******** Danger of not enough space for resources!! ***
#echo *******************************************************

/*#error ******** Danger of not enough space for resources!! */
#else
*=$1d30
#endif	


; Resource data goes here...
__resource_memory_start
; This is initialized byt the engine as a full empty area
.dsb (RESOURCE_TOP-__resource_memory_start) 
__resource_memory_end
#echo Resource data size:
#print __resource_memory_end-__resource_memory_start
#echo


