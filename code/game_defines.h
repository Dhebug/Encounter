
#include "game_enums.h"
#include "params.h"

typedef unsigned char WORDS;

extern unsigned char gCurrentLocation;
extern unsigned char gCurrentItemCount;
extern unsigned char gCurrentItem;
extern unsigned char gCurrentAssociatedItem;
extern char gInventoryOffset;
extern char gInventoryMaxOffset;

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
	const char* script;                             // Additional list of commands to add elements to the graphical view (speech bubble, etc...)
} location;

typedef struct
{
	const char* description;        	// +0 Full description of the object in the world
	unsigned char location;         	// +2 Where the object is in the world
	unsigned char associated_item;      // +3 For the item<->container association
    unsigned char flags;            	// +4 Special flags on what can be done with the item
    unsigned char usable_containers;	// +5 Bit masks representing the possible containers to store the item
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
    unsigned char flag;             // See: FLAG_MAPPING_DEFAULT, FLAG_MAPPING_STREAM in scripting.h
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


extern location gLocations[e_LOC_COUNT_];
extern location* gCurrentLocationPtr;
extern unsigned char gSceneImage;
extern item gItems[e_ITEM_COUNT_];

extern keyword gWordsArray[];

extern action_mapping gActionMappingsArray[];

extern stream_mapping gTakeItemMappingsArray[];
extern stream_mapping gDropItemMappingsArray[];

// Small feedback messages and prompts
extern       char gTextAskInput[];              // "What are you going to do now?" (not const because we patch it)
extern const char gTextNothingHere[];           // "There is nothing of interest here"
extern const char gTextCanSee[];                // "I can see"
extern const char gTextScore[];                 // "Score:"
extern const char gTextCarryInWhat[];           // "Carry it in what?"

// Error messages 
extern const char gTextErrorInvalidDirection[]; // "Impossible to move in that direction"
extern const char gTextErrorCantTakeNoSee[];    // "You can only take something you see"
extern const char gTextErrorAlreadyHaveItem[];  // "You already have this item"
extern const char gTextErrorCannotDo[];         // "I can't do it"
extern const char gTextErrorThatWillNotWork[];  // "That will not work"
extern const char gTextErrorAlreadyFull[];      // "Sorry, that's full already"
extern const char gTextErrorMissingContainer[]; // "You don't have this container"
extern const char gTextErrorDropNotHave[];      // "You can only drop something you have"
extern const char gTextErrorUnknownItem[];      // "I do not know what this item is"
extern const char gTextErrorNeedMoreDetails[];  // "Could you be more precise please?"
extern const char gTextErrorItemNotPresent[];   // "This item does not seem to be present"
extern const char gTextErrorInventoryFull[];    // "I need to drop something first"
extern const char gTextErrorDidNotUnderstand[]; // "I don't understand"
extern const char gTextUseShiftToHighlight[];   // "Use SHIFT to highlight"
