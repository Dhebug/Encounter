
/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/


/* Definitions for objects .... */

/* Active objects in the game are stored in an array up to MAX_OBJECTS with the following fields (each field is 1 byte): 
- Fields that need saving:

obj_id 			; ID of the object in this position of the array:
costume_id, costume_no	; Identification of costume used by this object
anim_state 		; Animatory state for this object
color_speech 		; Color of the text speech for this character
room 			; Room the character is in
pos_row, pos_col 	; Position of character in the room
walk_row, walk_col	; Position a character has to move to interact with this character.
			; if the entry is $ff it means it has to be calculated from
			; the position of the character
face_dir		; direction the actor should face to interact
			; with object. $ff means use default	
size_rows, size_cols	; Size of character in tiles	
z_plane			; z-Plane the character is currently in	
direction		; Direction the character is facing	
flags			; Object flags: OBJ_FLAG_ACTOR, OBJ_FLAG_PROP, OBJ_FLAG_USEDWITHOTHER
anim_speed 		;  This is an AND mask for the frame counter 
			; (tests if frame&&anim_speed == 0) 00: every frame, 01: every other frame, 11, every 4 frames, ...	
obj_names		; Object name (zero-ended string)

- Fields that doesn't need saving:

tab_tiles_hi, tab_tiles_lo			; Pointer to tile set used in to represent the object
tab_masks_hi, tab_masks_lo			; Pointer to the masks set
base_as_pointer_high, base_as_pointer_low 	; Pointer to base of animatory states 	
as_pointer_high, as_pointer_low  		; Pointer to current animatory state 	
command_high, command_low	; Pointer to current command being executed for an object		
subcom_high, subcom_low		; Idem for the subcommand
var1, var2, var3, var4		; Internal variables used by commands	
stride_step			; State for the stride frame. For animation of left/right walk	

*/


// Definitions for direction the character is facing
#define FACING_RIGHT		0
#define FACING_LEFT		1
#define FACING_UP		2
#define FACING_DOWN		3

// Definitions for animatory states
#define LOOK_RIGHT		0
#define WALK_RIGHT_1		1
#define WALK_RIGHT_2		2
#define WALK_RIGHT_3		3
#define LOOK_FRONT		4
#define WALK_DOWN_1		5	
#define WALK_DOWN_2		6
#define LOOK_BACK		7
#define WALK_UP_1		8
#define WALK_UP_2		9
#define TALK_FRONT		10
#define TALK_RIGHT		11

// Z-plane constant definitions
// Z-plane 0 is for background only
// sprites start in Z-plane 1
#define ZPLANE_0		0
#define ZPLANE_1		1<<5
#define ZPLANE_2		2<<5
#define ZPLANE_3		3<<5

// Flag field of object data (object is an actor, a prop -no graphic-, 
// needs to be used with other object, can be interacted from the distance).
#define OBJ_FLAG_ACTOR		1<<7	
#define OBJ_FLAG_PROP		1<<6
#define OBJ_FLAG_USEDWITHOTHER  1<<5
#define OBJ_FLAG_FROMDISTANCE 	1<<4

// Special ids for the object data array
#define OBJ_EMPTY_ENTRY 	$ff

