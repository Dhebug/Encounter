
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
    e_WORD_USE   ,
    e_WORD_READ  ,
    e_WORD_CLIMB ,
    e_WORD_LOOK  ,
    e_WORD_KILL  ,
    e_WORD_FRISK ,
    e_WORD_SEARCH,
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

// Small feedback messages and prompts
extern const char gTextAskInput[];              // "What are you going to do now?"
extern const char gTextNothingHere[];           // "There is nothing of interest here"
extern const char gTextCanSee[];                // "I can see"
extern const char gTextScore[];                 // "Score:"
extern const char gTextHighScoreAskForName[];   // "New highscore! Your name please?"
extern const char gTextCarryInWhat[];           // "Carry it in what?"
extern const char gTextPetrolEvaporates[];      // "The petrol evaporates"
extern const char gTextWaterDrainsAways[];      // "The water drains away"
extern const char gTextClimbUpLadder[];         // "You climb up the ladder"
extern const char gTextClimbDownLadder[];       // "You climb down the ladder"
extern const char gTextPositionLadder[];        // "You position the ladder properly"
extern const char gTextClimbUpRope[];           // "You climb up the rope"
extern const char gTextClimbDownRope[];         // "You climb down the rope"
extern const char gTextAttachRopeToTree[];      // "You attach the rope to the tree"
extern const char gTextDeadDog[];               // "a dead dog"
extern const char gTextDeadThug[];              // "a dead thug"
extern const char gTextFoundSomething[];        // "You found something interesting"
extern const char gTextDogGrowlingAtYou[];      // "an alsatian growling at you"
extern const char gTextThugAsleepOnBed[];       // "a thug asleep on the bed",0
extern const char gTextNotDead[];               // "Not dead" - Debugging text
extern const char gTextDogJumpingAtMe[];        // "a dog jumping at me"
extern const char gTextThugShootingAtMe[];      // "a thug shooting at me"

// Error messages 
extern const char gTextErrorInvalidDirection[]; // "Impossible to move in that direction"
extern const char gTextErrorCantTakeNoSee[];    // "You can only take something you see"
extern const char gTextErrorAlreadyHaveItem[];  // "You already have this item"
extern const char gTextErrorTooHeavy[];         // "This is too heavy"
extern const char gTextErrorRidiculous[];       // "Don't be ridiculous"
extern const char gTextErrorAlreadyFull[];      // "Sorry, that's full already"
extern const char gTextErrorMissingContainer[]; // "You don't have this container"
extern const char gTextErrorDropNotHave[];      // "You can only drop something you have"
extern const char gTextErrorUnknownItem[];      // "I do not know what this item is"
extern const char gTextErrorItemNotPresent[];   // "This item does not seem to be present"
extern const char gTextErrorCannotRead[];       // "I can't read that"
extern const char gTextErrorCannotUseHere[];    // "I can't use it here"
extern const char gTextErrorDontKnowUsage[];    // "I don't know how to use that"
extern const char gTextErrorCannotAttachRope[]; // "You can't attach the rope"
extern const char gTextErrorLadderInHole[];     // "The ladder is already in the hole"
extern const char gTextErrorCantClimbThat[];    // "I don't know how to climb that"
extern const char gTextErrorNeedPositionned[];  // "It needs to be positionned first"
extern const char gTextErrorItsNotHere[];       // "It's not here"
extern const char gTextErrorAlreadyDead[];      // "Already dead"
extern const char gTextErrorShouldSaveGirl[];   // "You are supposed to save her"
extern const char gTextErrorShouldSubdue[];     // "I should subdue him first"
extern const char gTextErrorAlreadySearched[];  // "You've already frisked him"
extern const char gTextErrorInappropriate[];    // "Probably inappropriate"
extern const char gTextErrorDeadDontMove[];     // "Dead don't move"

