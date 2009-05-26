/*	This is WHITE (World Handling & Interaction with The Environment)
 	Version 0.1
	José María Enguita
	2005
*/

#ifndef _WHITE_H_
#define _WHITE_H_


#include "white_defs.h"
#include "noise.h"

// Callbacks for collisions
#ifdef COLLISION_CALLBACKS
char white_collided_with_bkg(char who, char against, char i, char j, char k); 	// Collided with a given background object
char white_collided_with_char(char who, char against); // Collided with a given character
#endif

void white_init();  // Inits the WHITE layer
void white_clear_room_map(); // Clears the room data (sets all tiles to 0)
void white_clear_screen(); // Clears the current screen (only the room) and sets paper and ink to 0
void white_show_screen(char attrmap1, char attrmap2); // Restore attribs so screen is visible. Sets the attribute value to attrmap1 and 2 alternatively
void white_load_room(char roomID); // Loads the room number roomID
void white_change_block(char i, char j, char k, char newID); // Changes a background block for the newID and repaints it.
void white_add_new_char(char ID); // Adds a character to the room... moving_chars[ID] should have been filled first.
void white_remove_char(char ID); // Removes a character from the room.
char white_step(char ID); // Makes a given char to move 1 step. Returns 0 if not able, 1 if able.
char white_movev(char ID, char dir); // Moves a character vertically. Returns 0 if not able, 1 if able.
char white_checkfloor(char ID);		// Checks the floor a character is standing at.  Returns 0 if nothing below, 1 else.
void white_standstill(char ID); // Makes the character to stand still (first frame)
void white_turn(char ID, char dir); // Turns character: CLOCKWISE (0) turns clockwise, ANTICLOCKWISE (1) turns anti-clockwise
void white_loop();	// main loop of white, for automatic actions.
void white_setPC(char ID); // sets the current player-controlled character and loads the room it is in.
char white_interact(char ID); // Makes the character ID (normally the player) explore what's nearby to interact with. Returns 0 if nothing found, 1 else.

#ifdef WAREHOUSE_MANAGE
char white_to_warehouse(char i, char j, char k); // Moves the object at position (i,j,k) to the warehouse. 
												 //Returns ID if success, 0 if nothing there.
char white_from_warehouse(char i, char j, char k, char ID); // Moves object ID from the warehouse to current room at position (i,j,k). 
															//Returns 0 if success and an ID if there was an object already at that position.
#endif
char white_add_hook(void(*f)(void),char hook_point);      // Adds a hook at a given hook_point
char white_remove_hook(char hook_point);                  // Removes a given hook_point

// Objects that move in the game
typedef struct t_moving_char{
	unsigned char room;
	unsigned char frame;
	unsigned char direction;
	unsigned char automov;
} moving_char_t;

// frame and direction fields have the 7th bit with a special meaning. If set, animation while stepping or changing direction
// respectively, is disabled.
// BEWARE: If animation in direction changes is disabled and later on enabled again, the actual direction should be consistent
// with the pointers to the graphics, or they will get corrupt. Basically it should be the same that when it was disabled. Just assign
// the old value when setting the 7th bit to 0 again and it should work well!


/* Structure of the automov field, controls how the char is auto-moved:
	  7 6 5 4 3 2 1 0
	 +---------------+
	 |a|t t t|f f|g|s|
	 +---------------+

	 a = automatic movement yes/no
	 s = speed
	 t = type of movement
     g = char is affected by gravity
	 f = free */

// Macros to set flags
#define SET_AUTOMOV(x) x=(x | 0x80)	// Sets the auto-movement flag (bit 7)
#define UNSET_AUTOMOV(x) x=(x & ~0x80) // Clears the auto-movement flag (bit 7)
#define SET_GRAV(x) x=(x | 0x2)	// Sets the gravity flag (bit 1)
#define UNSET_GRAV(x) x=(x & ~0x2) // Clears the gravity flag (bit 1)
#define AM_TYPE0	0	// On collision turn CLOCKWISE
#define AM_TYPE1	1	// On collision turn ANTICLOCKWISE
#define AM_TYPE2	2	// On collision turn twice
#define AM_TYPE3	3	// On collision randomly act as any of the above
#define AM_TYPE4	4   // Do 0-4 randomly when stepping
#define SET_AMTYPE(x,y) x=(x | (y << 4)) // Sets auto-movement type
#define SET_SPEEDNORMAL(x) x=(x | 1)	// Sets one step per loop (normal speed)
#define SET_SPEEDHALF(x) 	x=(x & 0xfe) // Sets one step every two loops (half speed)

// A more general macro, for direction and frame
#define SET_BIT7(x) x=(x | 0x80)	// Sets bit 7
#define UNSET_BIT7(x) x=(x & ~0x80) // Clears bit 7

// Array of moving chars then...
extern moving_char_t moving_chars[MAX_CHARS];
extern char num_characters; // Number of entries in the above array



// Objects in the world
typedef struct t_object{
	unsigned char room;
	unsigned char id;
	unsigned char i;
	unsigned char j;
	unsigned char k;
} object_t;

extern object_t objects[MAX_OBJS];
extern char num_objects; // Total of objects

extern char current_room;	// Current room we are at
extern char player_char;	// ID of the character we are controlling
extern char ink_colour; 	// Room ink
extern char ink_colour2;    // Room ink 2 (for alternating scans)
extern char room_size; 		// Room size
extern char camera_angle; 	// Camera angle
extern char counter1;		// Internal WHITE counter
extern char room_loaded;	// Has any room been loaded?
extern char ignore_collisions; 	// Sets or clears ignoring collisions with background objects
extern char phantom_mode;		// Sets or clears not stopping when colliding with background objects
extern char ignore_collision_test   // Tells WHITE to ignore collision check when stepping


#endif //_WHITE_H_

