#ifndef _WHITE_DEFS_H
#define _WHITE_DEFS_H

#ifndef _NOISE_DEFS_H_
#include "noise_defs.h"
#endif


// Maximum objects in the world that are movable
#define MAX_OBJS 0


// Should WHITE manage putting objects to and back from the warehouse?
//#define WAREHOUSE_MANAGE

// Room not used, just a way to set an object to non-existant
#define WAREHOUSE 255 

// We want to be informed of collisions
#define COLLISION_CALLBACKS 

// Make characters go up/down stairs
#define AUTOSTAIRS

// Do NPCs go automatically up/down stairs?
#define NPCUSESTAIRS


// Shall NPCs avoid reporting collisions with bkg objects?
#define NPC_DONTREPORTBKGCOL

// Perform simulation of gravity?
#define GRAVITY


// Want WHITE to automatically change rooms?
#define AUTO_ROOM_CHANGE

// Want WHITE to try to avoid corners when moving (by displacing character laterally on collision)?
#define AVOID_CORNERS

// Use own random routine
#define OWNRAND

// Defines for tiles that are to be treated as stairs
#define T_STAIRN		16 // Stair to the NORTH
#define T_STAIRW		80 //T_STAIRN | INVERT // Stair to the WEST
#define T_STAIRE		17 // Stair to the EAST
#define T_STAIRS		81 //T_STAIRE | INVERT // Stair to the SOUTH

#define A_FWBLACK        0		// Attribute for "black" ink (to make screen invisible while painting room)
#define A_FWNORMAL       7		// Attribute for "normal" ink (to make the picture appear after drawing room)


/*****************************************************************************/
/* DO NOT TOUCH ANYTHING BELOW THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING */
/*****************************************************************************/

#define WHITE_VERSION 0.2

/* Directions for turning */
#define CLOCKWISE 0
#define ANTICLOCKWISE 1

/* Attributes */
#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7

/* Hook points */
#define HOOK_ROOMLOADED 0
#define HOOK_PRELOAD    1
#define HOOK_ROOMSHOWN  2


/* Screen start address for drawing */
#define SCR_START (char*)(0xa000+152*40+18)



#endif //_WHITE_DEFS_H