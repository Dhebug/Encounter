
#include "game_enums.h"
#include "params.h"

typedef unsigned char WORDS;

extern unsigned char gCurrentLocation;
extern unsigned char gCurrentItem;

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
	const char* word;				// How it's actually written (ex: "Take")
    unsigned char id;				// The matching id           (ex: e_WORD_TAKE)
} keyword;


typedef void (*callback)();

typedef struct
{
    unsigned char id;				// The id of the instruction (ex: e_WORD_TAKE)
    unsigned char flag;             // See: FLAG_MAPPING_DEFAULT, FLAG_MAPPING_STREAM, FLAG_MAPPING_TWO_ITEMS in scripting.h
    union 
    {
        callback function;          // Pointer to the routine to call (ex: TakeItem())
        void* stream;               // Pointer to a stream
    } u;
} action_mapping;


typedef struct
{
    unsigned char id;				// The id of the item (ex: e_ITEM_Newspaper)
    void* stream;                   // Pointer to a stream
} stream_mapping;


extern location gLocations[e_LOCATION_COUNT_];
extern location* gCurrentLocationPtr;
extern item gItems[e_ITEM_COUNT_];

extern const char* gDirectionsArray[];
extern keyword gWordsArray[];

extern action_mapping gActionMappingsArray[];

extern stream_mapping gTakeItemMappingsArray[];
extern stream_mapping gDropItemMappingsArray[];

// Small feedback messages and prompts
extern const char gTextAskInput[];              // "What are you going to do now?"
extern const char gTextNothingHere[];           // "There is nothing of interest here"
extern const char gTextCanSee[];                // "I can see"
extern const char gTextScore[];                 // "Score:"
extern const char gTextCarryInWhat[];           // "Carry it in what?"
extern const char gTextPetrolEvaporates[];      // "The petrol evaporates"
extern const char gTextWaterDrainsAways[];      // "The water drains away"
extern const char gTextDeadThug[];              // "a dead thug"
extern const char gTextDogGrowlingAtYou[];      // "an alsatian growling at you"
extern const char gTextThugAsleepOnBed[];       // "a thug asleep on the bed",0
extern const char gTextNotDead[];               // "Not dead" - Debugging text
extern const char gTextDogJumpingAtMe[];        // "a dog jumping at me"
extern const char gTextThugShootingAtMe[];      // "a thug shooting at me"

// Error messages 
extern const char gTextErrorInvalidDirection[]; // "Impossible to move in that direction"
extern const char gTextErrorCantTakeNoSee[];    // "You can only take something you see"
extern const char gTextErrorAlreadyHaveItem[];  // "You already have this item"
extern const char gTextErrorCannotDo[];         // "I can't do it"
extern const char gTextErrorRidiculous[];       // "Don't be ridiculous"
extern const char gTextErrorAlreadyFull[];      // "Sorry, that's full already"
extern const char gTextErrorMissingContainer[]; // "You don't have this container"
extern const char gTextErrorDropNotHave[];      // "You can only drop something you have"
extern const char gTextErrorUnknownItem[];      // "I do not know what this item is"
extern const char gTextErrorItemNotPresent[];   // "This item does not seem to be present"
