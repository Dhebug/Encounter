
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
extern const char gTextAGenericWhiteBag[];      // "It's just a white generic bag"
extern const char gTextThickBookBookmarks[];    // "A thick book with some boomarks"

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
extern const char gTextErrorNothingSpecial[];   // "Nothing special"

// Places
extern const char gTextLocationMarketPlace[];          // "You are in a deserted market square"     
extern const char gTextLocationDarkAlley[];            // "You are in a dark, seedy alley"          
extern const char gTextLocationRoad[];                 // "A long road stretches ahead of you"      

extern const char gTextLocationDarkTunel[];            // "You are in a dark, damp tunnel"          
extern const char gTextLocationMainStreet[];           // "You are on the main street"              
extern const char gTextLocationNarrowPath[];           // "You are on a narrow path"                

extern const char gTextLocationInThePit[];             // "You are insided a deep pit"              
extern const char gTextLocationOldWell[];              // "You are near to an old-fashioned well"   
extern const char gTextLocationWoodedAvenue[];         // "You are in a wooded avenue"              

extern const char gTextLocationGravelDrive[];          // "You are on a wide gravel drive"          
extern const char gTextLocationTarmacArea[];           // "You are in an open area of tarmac"       
extern const char gTextLocationZenGarden[];            // "You are in a relaxing zen garden"        

extern const char gTextLocationFrontLawn[];            // "You are on a huge area of lawn"          
extern const char gTextLocationGreenHouse[];           // "You are in a small greenhouse"           
extern const char gTextLocationTennisCourt[];          // "You are on a lawn tennis court"          

extern const char gTextLocationVegetableGarden[];      // "You are in a vegetable plot"             
extern const char gTextLocationFishPond[];             // "You are standing by a fish pond"         
extern const char gTextLocationTiledPatio[];           // "You are on a tiled patio"                

extern const char gTextLocationAppleOrchard[];         // "You are in an apple orchard"             
extern const char gTextLocationDarkerCellar[];         // "This room is even darker than the last"  
extern const char gTextLocationCellar[];               // "This is a cold, damp cellar"             

extern const char gTextLocationNarrowStaircase[];      // "You are on some gloomy, narrow steps"    
extern const char gTextLocationEntranceLounge[];       // "You are in the lounge"                   
extern const char gTextLocationEntranceHall[];         // "You are in an imposing entrance hall"    

extern const char gTextLocationLibrary[];              // "This looks like a library"               
extern const char gTextLocationDiningRoom[];           // "A dining room, or so it appears"         
extern const char gTextLocationStaircase[];            // "You are on a sweeping staircase"         

extern const char gTextLocationGamesRoom[];            // "This looks like a games room"            
extern const char gTextLocationSunLounge[];            // "You find yourself in a sun-lounge"       
extern const char gTextLocationKitchen[];              // "This is obviously the kitchen"           

extern const char gTextLocationNarrowPassage[];        // "You are in a narrow passage"             
extern const char gTextLocationGuestBedroom[];         // "This seems to be a guest bedroom"        
extern const char gTextLocationChildBedroom[];         // "This is a child's bedroom"               

extern const char gTextLocationMasterBedRoom[];        // "This must be the master bedroom"         
extern const char gTextLocationShowerRoom[];           // "You are in a tiled shower-room"          
extern const char gTextLocationTinyToilet[];           // "This is a tiny toilet"                   

extern const char gTextLocationEastGallery[];          // "You have found the east gallery"         
extern const char gTextLocationBoxRoom[];              // "This is a small box-room"                
extern const char gTextLocationPadlockedRoom[];        // "You see a padlocked steel-plated door"   

extern const char gTextLocationClassyBathRoom[];       // "You are in an ornate bathroom"           
extern const char gTextLocationWestGallery[];          // "This is the west gallery"                
extern const char gTextLocationMainLanding[];          // "You are on the main landing"             

extern const char gTextLocationOutsidePit[];           // "Outside a deep pit"          
extern const char gTextLocationGirlRoomOpenned[];      // "The girl room (openned lock)"

// Items
// Containers
extern const char gTextItemTobaccoTin[];              // "an empty tobacco tin"               
extern const char gTextItemBucket[];                  // "a wooden bucket"                    
extern const char gTextItemCardboardBox[];            // "a cardboard box"                    
extern const char gTextItemFishingNet[];              // "a fishing net"                      
extern const char gTextItemPlasticBag[];              // "a plastic bag"                      
extern const char gTextItemSmallBottle[];             // "a small bottle"                     
// Items requiring containers
extern const char gTextItemBlackDust[];               // "black dust"                         
extern const char gTextItemYellowPowder[];            // "gritty yellow powder"               
extern const char gTextItemPetrol[];                  // "some petrol"                        
extern const char gTextItemWater[];                   // "some water"                         
// Normal items
extern const char gTextItemLockedPanel[];             // "a locked panel on the wall"         
extern const char gTextItemOpenPanel[];               // "an open panel on wall"              
extern const char gTextItemSmallHoleInDoor[];         // "a small hole in the door"           
extern const char gTextItemBrokenWindow[];            // "the window is broken"               
extern const char gTextItemLargeDove[];               // "a large dove"                       
extern const char gTextItemTwine[];                   // "some twine"                         
extern const char gTextItemSilverKnife[];             // "a silver knife"                     
extern const char gTextItemLadder[];                  // "a ladder"                           
extern const char gTextItemAbandonedCar[];            // "an abandoned car"                   
extern const char gTextItemAlsatianDog[];             // "an alsatian growling at you"        
extern const char gTextItemMeat[];                    // "a joint of meat"                    
extern const char gTextItemBread[];                   // "some brown bread"                   
extern const char gTextItemRollOfTape[];              // "a roll of sticky tape"              
extern const char gTextItemChemistryBook[];           // "a chemistry book"                   
extern const char gTextItemBoxOfMatches[];            // "a box of matches"                   
extern const char gTextItemSnookerCue[];              // "a snooker cue"                      
extern const char gTextItemThug[];                    // "a thug asleep on the bed"           
extern const char gTextItemHeavySafe[];               // "a heavy safe"                       
extern const char gTextItemHandWrittenNote[];         // "a hand written note"                     
extern const char gTextItemRope[];                    // "a length of rope"                   
extern const char gTextItemRopeHangingFromWindow[];   // "a rope hangs from the window"       
extern const char gTextItemRollOfToiletPaper[];       // "a roll of toilet tissue"            
extern const char gTextItemHosePipe[];                // "a hose-pipe"                        
extern const char gTextItemOpenSafe[];                // "an open safe"                       
extern const char gTextItemBrokenGlass[];             // "broken glass"                       
extern const char gTextItemAcidBurn[];                // "an acid burn"                       
extern const char gTextItemYoungGirl[];               // "a young girl"                        
extern const char gTextItemFuse[];                    // "a fuse"                             
extern const char gTextItemGunPowder[];               // "some gunpowder"                     
extern const char gTextItemKeys[];                    // "a set of keys"                      
extern const char gTextItemNewspaper[];               // "a newspaper"                        
extern const char gTextItemBomb[];                    // "a bomb"                             
extern const char gTextItemPistol[];                  // "a pistol"                           
extern const char gTextItemBullets[];                 // "three .38 bullets"                  
extern const char gTextItemYoungGirlOnFloor[];        // "a young girl tied up on the floor"  
extern const char gTextItemChemistryRecipes[];        // "a couple chemistry recipes"         
extern const char gTextItemUnitedKingdomMap[];        // "a map of the United Kingdom"        
extern const char gTextItemLadderInTheHole[];         // "a ladder in a hole"                 
extern const char gTextItemeRopeAttachedToATree[];    // "a rope attached to a tree"

// Scene actions
extern const char gSceneActionReadNewsPaper[];
extern const char gSceneActionReadHandWrittenNote[];
extern const char gSceneActionReadChemistryRecipes[];
extern const char gSceneActionReadChemistryBook[];
extern const char gSceneActionInspectMap[];

