#ifndef _NOISE_DEFS_H_
#define _NOISE_DEFS_H_


// Max simultaneous free objects (characters) in the same room
#define MAX_CHARS 20 

// Number of layers to use. BEWARE it reduces performance!
#define NUM_LAYERS 4

/****************************************************************************************
  BEWARE: Don't change anything beyond this point unless you know what you are doing!!!!
 **************************************************************************************/

#define VERSION 0.2

// Size of room grid
#define SIZE_GRID 10

// Heigth of each layer
#define LAYER_HEIGHT 8


// Default index for hero (player-controlled character -PC- in characters array
#define HERO_INDEX 0


// Movement Directions
#define NORTH	0
#define WEST	2
#define SOUTH	1
#define EAST	3
#define UP	    4
#define DOWN	5


#define INVERT 64
#define SPECIAL 128

#define SET_INVERT(x) x=(x|INVERT)
#define SET_SPECIAL(x) x=(x|SPECIAL)
#define UNSET_INVERT(x) x=(x & ~INVERT)
#define UNSET_SPECIAL(x) x=(x & ~SPECIAL)


// Size codes (Up to 2^6=64)

#define SIZE_BLOCK      0
#define SIZE_CUBE       1
#define SIZE_FURNIT1    2
#define SIZE_FURNIT2    3
#define SIZE_SMALLCUBE  4
#define SIZE_SMALLCHAR  5
#define SIZE_CHAR       6
#define SIZE_AREA       7



#endif // _NOISE_DEFS_H_

