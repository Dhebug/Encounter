
#include "game_enums.h"
#include "params.h"

// The various locations
enum DIRECTIONS
{
    e_DIRECTION_NORTH = 0,
    e_DIRECTION_SOUTH = 1,
    e_DIRECTION_EAST  = 2,
    e_DIRECTION_WEST  = 3,
    e_DIRECTION_UP    = 4,   // Seldomly used (to go to the house upper floor and basement)
    e_DIRECTION_DOWN  = 5,   // Seldomly used (to go to the house upper floor and basement)
    e_DIRECTION_COUNT_
};


// For practical reasons we reuse the item ids in the list of words
// followed by the actual instructions
typedef enum 
{
	// [0-44] Items 
	// see enum ITEMS

	// [45-51] Directions 
    e_WORD_NORTH = e_ITEM_COUNT_,
    e_WORD_SOUTH ,
    e_WORD_EAST  ,
    e_WORD_WEST  ,
    e_WORD_UP    ,
    e_WORD_DOWN  ,

	// In-game instructions
	e_WORD_TAKE  ,
	e_WORD_DROP  ,
    e_WORD_KILL  ,
#ifdef ENABLE_CHEATS
    e_WORD_REVIVE,
    e_WORD_TICKLE,
#endif    

	// Meta instructions
	e_WORD_QUIT  ,
	e_WORD_COUNT_,

	// Additional values for the parser
	e_WORD_CONTINUE

} WORDS;


extern unsigned char gCurrentLocation;

//unsigned char 
// We have 43 locations.
// For each location we need to store potential directions.
// - North
// - South
// - East
// - West
// - Up
// - Down
// 43*6=258 bytes if we store each of the directions

typedef struct 
{
    unsigned char directions[e_DIRECTION_COUNT_];   // The six possible directions (NSEWUP)
    const char* description;                        // The one line description of the place, displayed at the top of the TEXT area
	const char* script;                             // Additional list of commands to add elements to the graphical view (speech bubble, etc...)
} location;

typedef struct
{
	const char* description;        	// Full description of the object in the world
	unsigned char location;         	// Where the object is in the world
	unsigned char associated_item;      // For the item<->container association
    unsigned char flags;            	// Special flags on what can be done with the item
    unsigned char usable_containers;	// Bit masks representing the possible containers to store the item
} item;

typedef struct 
{
	const char* word;				// How it's actually written
    unsigned char id;				// The matching id
} keyword;


extern location gLocations[e_LOCATION_COUNT_];
extern location* gCurrentLocationPtr;
extern item gItems[e_ITEM_COUNT_];

extern const char* gDirectionsArray[];

extern keyword gWordsArray[];

