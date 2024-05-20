
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
    unsigned char flag;             // Used to determine what the other field means
    union 
    {
        callback function;              // Pointer to the routine to call (ex: TakeItem())
        void* stream;                   // Pointer to a stream
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
extern stream_mapping gReadItemMappingsArray[];
extern stream_mapping gCloseItemMappingsArray[];
extern stream_mapping gInspectItemMappingsArray[];
extern stream_mapping gUseItemMappingsArray[];
extern stream_mapping gSearchtemMappingsArray[];
extern stream_mapping gThrowItemMappingsArray[];
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
extern const char gTextErrorCannotRead[];       // "I can't read that"
extern const char gTextErrorCannotUseHere[];    // "I can't use it here"
extern const char gTextErrorDontKnowUsage[];    // "I don't know how to use that"
extern const char gTextErrorCannotAttachRope[]; // "You can't attach the rope"
extern const char gTextErrorLadderInHole[];     // "The ladder is already in the hole"
extern const char gTextErrorCantClimbThat[];    // "I don't know how to climb that"
extern const char gTextErrorNeedPositionned[];  // "It needs to be positionned first"
extern const char gTextErrorItsNotHere[];       // "It's not here"
extern const char gTextErrorAlreadyDealtWith[]; // "Not a problem anymore"
extern const char gTextErrorShouldSaveGirl[];   // "You are supposed to save her"
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
extern const char gTextItemFridge[];                  // "a fridge"
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
extern const char gTextItemRopeAttachedToATree[];     // "a rope attached to a tree"
extern const char gTextItemClosedCurtain[];           // "a closed curtain"
extern const char gTextItemHandheldGame[];            // "a handheld game"
extern const char gTextItemMedicineCabinet[];         // "a medicine cabinet"
extern const char gTextItemSedativePills[];           // "some sedative pills"
extern const char gTextItemSedativeLacedMeat[];       // "druggd meat"

