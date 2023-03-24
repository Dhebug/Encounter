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

// Define the various locations
enum LOCATIONS
{
	e_LOCATION_MARKETPLACE      = 0,
	e_LOCATION_DARKALLEY        = 1,
	e_LOCATION_ROAD             = 2,
	e_LOCATION_DARKTUNNEL       = 3,
	e_LOCATION_MAINSTREET       = 4,
	e_LOCATION_NARROWPATH       = 5,
	e_LOCATION_INSIDEHOLE       = 6,
	e_LOCATION_WELL             = 7,
	e_LOCATION_WOODEDAVENUE     = 8,
	e_LOCATION_GRAVELDRIVE      = 9, 
	e_LOCATION_TARMACAREA       =10,
	e_LOCATION_ZENGARDEN        =11,
	e_LOCATION_LAWN             =12,
	e_LOCATION_GREENHOUSE       =13,
	e_LOCATION_TENNISCOURT      =14,
	e_LOCATION_VEGSGARDEN       =15,
	e_LOCATION_FISHPND          =16,
	e_LOCATION_TILEDPATIO       =17,
	e_LOCATION_APPLE_TREES      =18,
    e_LOCATION_DARKCELLARROOM   =19,
	e_LOCATION_CELLAR           =20,
	e_LOCATION_NARROWSTAIRCASE  =21,
	e_LOCATION_LOUNGE           =22,
	e_LOCATION_ENTRANCEHALL     =23,
	e_LOCATION_LIBRARY          =24,
	e_LOCATION_DININGROOM       =25,
	e_LOCATION_LARGE_STAIRCASE  =26,
	e_LOCATION_GAMESROOM        =27,
	e_LOCATION_SUNLOUNGE        =28,
	e_LOCATION_KITCHEN          =29,
	e_LOCATION_NARROWPASSAGE    =30, 
	e_LOCATION_GUESTBEDROOM     =31,
	e_LOCATION_CHILDBEDROOM     =32,
	e_LOCATION_MASTERBEDROOM    =33,
	e_LOCATION_SHOWERROOM       =34,
	e_LOCATION_TINY_WC          =35,
	e_LOCATION_EASTGALLERY      =36,
	e_LOCATION_BOXROOM          =37,
	e_LOCATION_PADLOCKED_ROOM   =38,
	e_LOCATION_CLASSY_BATHROOM  =39,
	e_LOCATION_WESTGALLERY      =40,
	e_LOCATION_UP_STAIRS        =41,
	e_LOCATION_GIRLROOM         =42,
    e_LOCATION_COUNT_           =43,
    e_LOCATION_INVENTORY        =e_LOCATION_COUNT_,    // Special location for the player's inventory
    e_LOCATION_NONE             =255                   // To indicate we can't go in this particular location
};

// Define the various items
enum ITEMS
{
	// Define the various items
	// Containers first
	e_ITEM_TobaccoTin    		= 0,          // an empty tobacco tin
	e_ITEM_Bucket        		= 1,          // a wooden bucket
	e_ITEM_CardboardBox  		= 2,          // a cardboard box
	e_ITEM_FishingNet    		= 3,          // a fishing net
	e_ITEM_PlasticBag    		= 4,          // a plastic bag
	e_ITEM__Last_Container      = 4,          // ----- END CONTAINERS MARKER
	// Then normal items
	e_ITEM_YoungGirl  			= 5,         // a young girl
	e_ITEM_BrokenWindow  		= 6,          // the window is broken
	e_ITEM_OpenSafe  			= 7,          // an open safe
	e_ITEM_BlackDust  			= 8,          // black dust
	e_ITEM_OpenPanel  			= 9,          // an open panel on wall
	e_ITEM_LockedPanel  		= 10,         // a locked panel on the wall
	e_ITEM_YellowPowder  		= 11,         // gritty yellow powder
	e_ITEM_SmallHoleInDoor 		= 12,         // a small hole in the door
	e_ITEM_Water  				= 13,         // some water
	e_ITEM_LargeDove  			= 14,         // a large dove
	e_ITEM_Twine  				= 15,         // some twine
	e_ITEM_SilverKnife  		= 16,         // a silver knife
	e_ITEM_Ladder  				= 17,         // a ladder
	e_ITEM_AbandonedCar  		= 18,         // an abandoned car
	e_ITEM_AlsatianDog  		= 19,         // Alsatian dog
	e_ITEM_Meat  				= 20,         // a joint of meat
	e_ITEM_Bread  				= 21,         // some brown bread
	e_ITEM_RollOfTape  			= 22,         // a roll of sticky tape
	e_ITEM_ChemistryBook  		= 23,         // a chemistry book
	e_ITEM_BoxOfMatches  		= 24,         // a box of matches
	e_ITEM_SnookerCue  			= 25,         // a snooker cue
	e_ITEM_Thug  				= 26,         // a Thug
	e_ITEM_HeavySafe  			= 27,         // a heavy safe
	e_ITEM_PrintedNote  		= 28,         // a printed note
	e_ITEM_Rope  				= 29,         // a length of rope
	e_ITEM_RopeHangingFromWindow= 30,         // a rope hangs from the window
	e_ITEM_RollOfToiletPaper  	= 31,         // a roll of toilet tissue~
	e_ITEM_HosePipe  			= 32,         // a hose-pipe
	e_ITEM_Petrol  				= 33,         // some petrol
	e_ITEM_BrokenGlass  		= 34,         // broken glass
	e_ITEM_AcidBurn  			= 35,         // an acid burn
	e_ITEM_SmallBottle  		= 36,         // a small bottle
	e_ITEM_Fuse  				= 37,         // a fuse
	e_ITEM_GunPowder  			= 38,         // some gunpowder
	e_ITEM_Keys  				= 39,         // a set of keys
	e_ITEM_Newspaper     		= 40,         // A newspaper
	e_ITEM_Bomb  				= 41,         // a bomb
	e_ITEM_Pistol 				= 42,         // a pistol
	e_ITEM_Bullets  			= 43,         // three .38 bullets
	e_ITEM_YoungGirlOnFloor  	= 44,         // a young girl tied up on the floor
	e_ITEM_COUNT_ 				= 45,         //  ----- END MARKER

	e_ITEM__Reserved      		= 45,          // Reserved entry code (not sure it's needed)

	// End marker
};

// For practical reasons we reuse the item ids in the list of words
// followed by the actual instructions
enum WORDS
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

	// Meta instructions
	e_WORD_QUIT  ,
	e_WORD_COUNT_
};

#define ITEM_FLAG_DEFAULT 			0    // Nothing special
#define ITEM_FLAG_IS_CONTAINER 		1    // This item is a container
#define ITEM_FLAG_NEEDS_CONTAINER 	2    // This item needs to be transported in a container
#define ITEM_FLAG_HEAVY   			4    // Impossible to move: Too Heavy
#define ITEM_FLAG_EVAPORATES        8    // Used to the water and petrol when you try to drop them

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
    const char* description;
} location;

typedef struct
{
	const char* description;        // Full description of the object in the world
	unsigned char location;         // Where the object is in the world
    unsigned char flags;            // Special flags on what can be done with the item
    const char* containers;
} item;

typedef struct 
{
	const char* word;				// How it's actually written
    unsigned char id;				// The matching id
} keyword;


extern location gLocations[e_LOCATION_COUNT_];
extern item gItems[e_ITEM_COUNT_];

extern const char* gDirectionsArray[];

extern keyword gWordsArray[];

