#ifndef GAME_ENUMS_H
#define GAME_ENUMS_H


// The various locations: These have to be in the same order as the e_WORD_xxx directions
#define e_DIRECTION_NORTH  0
#define e_DIRECTION_SOUTH  1
#define e_DIRECTION_EAST   2
#define e_DIRECTION_WEST   3
#define e_DIRECTION_UP     4   // Seldomly used (to go to the house upper floor and cellar)
#define e_DIRECTION_DOWN   5   // Seldomly used (to go to the house upper floor and cellar)
#define e_DIRECTION_COUNT_ 6 


// Define the various locations
typedef enum
{
	e_LOC_MARKETPLACE       = 0,
	e_LOC_DARKALLEY         = 1,
	e_LOC_ROAD              = 2,
	e_LOC_DARKTUNNEL        = 3,
	e_LOC_MAINSTREET        = 4,
	e_LOC_EASTERN_ROAD      = 5,
	e_LOC_INSIDE_PIT        = 6,
	e_LOC_WELL              = 7,
	e_LOC_WOODEDAVENUE      = 8,
	e_LOC_GRAVELDRIVE       = 9, 
	e_LOC_PARKING_PLACE    = 10,
	e_LOC_ZENGARDEN        = 11,
	e_LOC_LAWN             = 12,
	e_LOC_GREENHOUSE       = 13,
	e_LOC_TENNISCOURT      = 14,
	e_LOC_VEGSGARDEN       = 15,
	e_LOC_FISHPND          = 16,
	e_LOC_TILEDPATIO       = 17,
	e_LOC_ORCHARD          = 18,
	e_LOC_DARKCELLARROOM   = 19,
	e_LOC_CELLAR           = 20,
	e_LOC_CELLAR_STAIRS    = 21,
	e_LOC_LOUNGE           = 22,
	e_LOC_ENTRANCEHALL     = 23,
	e_LOC_LIBRARY          = 24,
	e_LOC_DININGROOM       = 25,
	e_LOC_LARGE_STAIRCASE  = 26,
	e_LOC_GAMESROOM        = 27,
	e_LOC_SUNLOUNGE        = 28,
	e_LOC_KITCHEN          = 29,
	e_LOC_NARROWPASSAGE    = 30, 
	e_LOC_GUESTBEDROOM     = 31,
	e_LOC_CHILDBEDROOM     = 32,
	e_LOC_MASTERBEDROOM    = 33,
	e_LOC_SHOWERROOM       = 34,
	e_LOC_TINY_WC          = 35,
	e_LOC_EASTGALLERY      = 36,
	e_LOC_BOXROOM          = 37,
	e_LOC_PANIC_ROOM_DOOR  = 38,
	e_LOC_CLASSY_BATHROOM  = 39,
	e_LOC_WESTGALLERY      = 40,
	e_LOC_UP_STAIRS        = 41,
	e_LOC_OUTSIDE_PIT      = 42,
	e_LOC_STUDY_ROOM       = 43,
	e_LOC_CELLAR_WINDOW    = 44,
	e_LOC_FRONT_ENTRANCE   = 45,
	e_LOC_ABANDONED_CAR    = 46,
	e_LOC_HOSTAGE_ROOM     = 47,
	e_LOC_INVENTORY        = 48,                   // Special location for the player's inventory (sits right after the real locations)
	e_LOC_COUNT_           = e_LOC_INVENTORY,      // Number of real locations — declared AFTER inventory so the debugger shows 48 as e_LOC_INVENTORY (first name wins)
	e_LOC_CURRENT          = 253,                  // For the scripting, so objects can be dumped to where the player is
	e_LOC_GONE_FOREVER     = 254,                  // To indicate this item is not available anymore
	e_LOC_NONE             = 255                  // To indicate we can't go in this particular location
} location_id;


// Define the various items, followed by instructions to simplify the parser
// Containers first
typedef enum
{
	e_ITEM_TobaccoTin    		 = 0,          // an empty tobacco tin
	e_ITEM_Bucket        		 = 1,          // a wooden bucket
	e_ITEM_CardboardBox  		 = 2,          // a cardboard box
	e_ITEM_Net    		         = 3,          // a net
	e_ITEM_PlasticBag    		 = 4,          // a plastic bag
	e_ITEM__Last_Container       = 4,          // ----- END CONTAINERS MARKER

// Items requiring containers
	e_ITEM_GunPowder  			 = 5,         // some gunpowder
	e_ITEM_Saltpetre  			 = 6,          // some saltpetre
	e_ITEM_Sulphur               = 7,          // some sulphur
	e_ITEM_Petrol  				 = 8,          // some petrol
	e_ITEM_Water  				 = 9,          // some water
	e_ITEM_LargeDove  			 = 10,         // a large dove
	e_ITEM_PowderMix  			 = 11,         // some gunpowder
	e_ITEM__Last_Transportable   = 11,         // ----- END TRANSPORTABLE MARKER

// Then normal items
	e_ITEM_Television            = 12,         // a television
	e_ITEM_Fridge  			     = 13,         // a fridge
	e_ITEM_SedativePills 		 = 14,         // some sedative pills
	e_ITEM_CellarWindow          = 15,         // a cellar window
	e_ITEM_FancyStones			 = 16,         // some fancy stones
	e_ITEM_SilverKnife  		 = 17,         // a silver knife
	e_ITEM_Ladder  				 = 18,         // a ladder
	e_ITEM_MixTape      		 = 19,         // a mix tape
	e_ITEM_Dog  		         = 20,         // a dog
	e_ITEM_Meat  				 = 21,         // a joint of meat
	e_ITEM_Bread  				 = 22,         // some brown bread
	e_ITEM_BlackTape  			 = 23,         // black tape
	e_ITEM_ChemistryBook  		 = 24,         // a chemistry book
	e_ITEM_BoxOfMatches  		 = 25,         // a box of matches
	e_ITEM_SnookerCue  			 = 26,         // a snooker cue
	e_ITEM_Thug  				 = 27,         // a Thug
	e_ITEM_HeavySafe  			 = 28,         // a heavy safe
	e_ITEM_HandWrittenNote  	 = 29,         // a hand written note
	e_ITEM_Rope  				 = 30,         // a length of rope
	e_ITEM_HandheldGame          = 31,         // a handheld game
	e_ITEM_ToiletRoll            = 32,         // a roll of toilet tissue~
	e_ITEM_Hose  			     = 33,         // a garden hose
	e_ITEM_GameConsole           = 34,         // a game console
	e_ITEM_Medicinecabinet       = 35,         // a thick curtain
	e_ITEM_YoungGirl  			 = 36,         // a young girl
	e_ITEM_Fuse  				 = 37,         // a fuse
	e_ITEM_SmallKey				 = 38,         // a small key
	e_ITEM_Newspaper     		 = 39,         // A newspaper
	e_ITEM_Bomb  				 = 40,         // a bomb
	e_ITEM_Pistol 				 = 41,         // a pistol
	e_ITEM_Invoice               = 42,         // an invoice letter
	e_ITEM_ChemistryRecipes   	 = 43,         // a sheet of paper with a few recipes on things to build
	e_ITEM_UnitedKingdomMap   	 = 44,         // the map of the UK in the library
	e_ITEM_Curtain               = 45,         // a thick curtain
	e_ITEM_GunCabinet            = 46,         // a gun cabinet
	e_ITEM_DartGun               = 47,         // a dart gun
	e_ITEM_AlarmSwitch           = 48,         // a alarm switch
	e_ITEM_CarBoot               = 49,         // the car boot
	e_ITEM_CarDoor               = 50,         // the car door
	e_ITEM_CarTank               = 51,         // the car petrol tank
	e_ITEM_MortarAndPestle       = 52,         // a mortar and pestle
	e_ITEM_Adhesive              = 53,         // some adhesive
	e_ITEM_Acid                  = 54,         // some acid
	e_ITEM_AlarmPanel  		     = 55,         // a locked panel on the wall / an open panel on wall
	e_ITEM_SecurityDoor		     = 56,         // a security door
	e_ITEM_Clay    		         = 57,         // some dried out clay
	e_ITEM_ProtectionSuit	     = 58,         // a protection suit
	e_ITEM_HoleInDoor            = 59,         // a hole in the door
	e_ITEM_PanicRoomWindow       = 60,         // a high-up window
	e_ITEM_FrontDoor             = 61,         // an impressive entrance door
	e_ITEM_RoughPlan             = 62,         // a rough plan
	e_ITEM_Car                   = 63,         // either "my car" or "a car" depending of the location
	e_ITEM_Graffiti              = 64,         // either the graffiti in the tunnel or the dirty alley
	e_ITEM_Church                = 65,         // the old church in main street
	e_ITEM_Well                  = 66,         // the old well in the forest
	e_ITEM_RoadSign              = 67,         // the sign at the chantier entnrace
	e_ITEM_Trashcan              = 68,         // the bins in the dirty alley
	e_ITEM_Tombstone             = 69,         // the tombstone near the church
	e_ITEM_FishPond              = 70,         // the fishpond
	e_ITEM_Fish                  = 71,         // a fish
	e_ITEM_Apple                 = 72,         // an apple
	e_ITEM_Tree                  = 73,         // a tree
	e_ITEM_Pit                   = 74,         // a pit
	e_ITEM_Heap                  = 75,         // a heap
	e_ITEM_NormalWindow          = 76,         // a normal window
	e_ITEM_AlarmIndicator        = 77,         // an alarm indicator
	e_ITEM_Computer              = 78,         // a desktop computer
	e_ITEM_Oric                  = 79,         // a Oric computer
	e_ITEM_TVCabinet             = 80,         // a TV cabinet
	e_ITEM_Batteries             = 81,         // a couple SR44 batteries
	e_ITEM_Drawer                = 82,         // a drawer
	e_ITEM_DuneBook              = 83,         // a dune book
	e_ITEM_Towel                 = 84,         // a towel
	e_ITEM_FabricStrip           = 85,         // a long strip of fabric
#ifdef PRODUCT_TYPE_GAME_DEMO
	e_ITEM_DemoMessage           = 86,         // a demo readme message
	e_ITEM_COUNT_ 				 = 87,         //  ----- END MARKER - Free until 127, after are action words
#else
	e_ITEM_COUNT_ 				 = 86,         //  ----- END MARKER - Free until 127, after are action words
#endif // PRODUCT_TYPE_GAME_DEMO
	e_ITEM_CURRENT               = e_ITEM_COUNT_    // For the scripting, so the current objects can be accessed from various scripts
} item_id;
// For practical reasons we reuse the item ids in the list of words followed by the actual instructions
// Directions: These have to be in the same order as the DIRECTIONS enum
#define	e_WORD_NORTH                 128        // = e_ITEM_COUNT_
#define	e_WORD_SOUTH                 129
#define	e_WORD_EAST                  130
#define	e_WORD_WEST                  131
#define	e_WORD_UP                    132
#define	e_WORD_DOWN                  133
// In-game instructions
#define	e_WORD_TAKE                  134
#define	e_WORD_DROP                  135
#define	e_WORD_USE                   136
#define	e_WORD_COMBINE               137
#define	e_WORD_OPEN                  138
#define	e_WORD_CLOSE                 139
#define	e_WORD_READ                  140
#define	e_WORD_LOOK                  141
#define	e_WORD_FRISK                 142
#define	e_WORD_SEARCH                143
#define	e_WORD_THROW                 144
// Meta instructions
#define	e_WORD_QUIT                  145
#define e_WORD_HELP                  146
#define	e_WORD_COUNT_                147
// Additional values for the parser
#define	e_WORD_CONTINUE              148
#define e_WORD_SKIP                  149  // Special command to modify the behavior of the system

// Flags for the items
#define ITEM_FLAG_DEFAULT 			0    // Nothing special
#define ITEM_FLAG_IS_CONTAINER 		1    // This item is a container
#define ITEM_FLAG_VISIBLE_IN_SCENE	2    // Item has a visible sprite in its location scene, requires full refresh on take/drop
#define ITEM_FLAG_IMMOVABLE			4    // Impossible to move for various reasons
#define ITEM_FLAG_LOCKED            8    // For item which are locked
#define ITEM_FLAG_DISABLED         16    // Used to indicate that something is not active anymore (ex: Dog, Thug )
#define ITEM_FLAG_ATTACHED         32    // Used to indicate that this item is attached to something (ex: Rope with the tree or window)
#define ITEM_FLAG_CLOSED           64    // For items that can be opened and closed
#define ITEM_FLAG_TRANSFORMED     128    // For items that get transformed (drugged meat)

// Achievements
typedef enum
{
	ACHIEVEMENT_SOLVED_THE_CASE    = 0,
	ACHIEVEMENT_MAIMED_BY_DOG      = 1,
	ACHIEVEMENT_SHOT_BY_THUG       = 2,
	ACHIEVEMENT_FELL_INTO_PIT      = 3,
	ACHIEVEMENT_TRIPPED_ALARM      = 4,
	ACHIEVEMENT_RAN_OUT_OF_TIME    = 5,
	ACHIEVEMENT_BLOWN_INTO_BITS    = 6,
	ACHIEVEMENT_GAVE_UP            = 7,

	ACHIEVEMENT_WRONG_DIRECTION    = 8,
	ACHIEVEMENT_LAUNCHED_THE_GAME  = 9,   // It's kind of a basic one...
	ACHIEVEMENT_WATCHED_THE_INTRO  = 10,
	ACHIEVEMENT_READ_THE_NEWSPAPER = 11,
	ACHIEVEMENT_READ_THE_BOOK      = 12,
	ACHIEVEMENT_READ_THE_NOTE      = 13,
	ACHIEVEMENT_READ_THE_RECIPES   = 14,
	ACHIEVEMENT_OPENED_THE_FRIDGE  = 15,

	ACHIEVEMENT_OPENED_THE_CABINET = 16,
	ACHIEVEMENT_DRUGGED_THE_MEAT   = 17,
	ACHIEVEMENT_KILLED_THE_DOG     = 18,
	ACHIEVEMENT_DRUGGED_THE_DOG    = 19,
	ACHIEVEMENT_CHASED_THE_DOG     = 20,
	ACHIEVEMENT_KILLED_THE_THUG    = 21,
	ACHIEVEMENT_DRUGGED_THE_THUG   = 22,
	ACHIEVEMENT_CAPTURED_THE_DOVE  = 23,

	ACHIEVEMENT_USED_THE_ROPE      = 24,
	ACHIEVEMENT_USED_THE_LADDER    = 25,
	ACHIEVEMENT_EXAMINED_THE_MAP   = 26,
	ACHIEVEMENT_EXAMINED_THE_GAME  = 27,
	ACHIEVEMENT_OPENED_THE_SAFE    = 28,
	ACHIEVEMENT_OPENED_THE_PANEL   = 29,
	ACHIEVEMENT_BUILT_A_FUSE       = 30,
	ACHIEVEMENT_BUILT_A_BOMB       = 31,

	ACHIEVEMENT_MADE_BLACK_POWDER  = 32,
	ACHIEVEMENT_FRISKED_THE_THUG   = 33,
	ACHIEVEMENT_USED_THE_ACID      = 34,
	ACHIEVEMENT_DISABLED_THE_ALARM = 35,
	ACHIEVEMENT_PAUSED_THE_GAME    = 36,
	ACHIEVEMENT_OPENED_THE_CURTAIN = 37,
	ACHIEVEMENT_GAVE_THE_KNIFE     = 38,
	ACHIEVEMENT_GAVE_THE_ROPE      = 39,

	ACHIEVEMENT_WATCHED_THE_OUTRO  = 40,
	ACHIEVEMENT_GOT_A_HIGHSCORE    = 41,
	ACHIEVEMENT_GOT_THE_BEST_SCORE = 42,
	ACHIEVEMENT_DOG_ATE_THE_MEAT   = 43,
	ACHIEVEMENT_USED_HOSE          = 44,
	ACHIEVEMENT_CLOSED_THE_FRIDGE  = 45,
	ACHIEVEMENT_READ_INVOICE       = 46,
	ACHIEVEMENT_READ_TOMBSTONE     = 47,

	ACHIEVEMENT_OVER_9999          = 48,
	ACHIEVEMENT_MONKEY_FALL        = 49,

	ACHIEVEMENT_COUNT_             = 50
} achievement;

#define ACHIEVEMENT_BYTE_COUNT           7      // Can't have more than 56 achievements


// Game end conditions
#define e_SCORE_UNNITIALIZED     0
#define e_SCORE_SOLVED_THE_CASE  1
#define e_SCORE_MAIMED_BY_DOG    2
#define e_SCORE_SHOT_BY_THUG     3
#define e_SCORE_FELL_INTO_PIT    4
#define e_SCORE_TRIPPED_ALARM    5
#define e_SCORE_RAN_OUT_OF_TIME  6
#define e_SCORE_BLOWN_INTO_BITS  7
#define e_SCORE_GAVE_UP          8
#define e_SCORE_FINISHED_DEMO    9
#define e_SCORE_COUNT_           10

// Scoring and points
// Used INCREASE_SCORE(define)
#define POINTS_COMBINED_SULPHUR_SALTPETRE 100
#define POINTS_GRINDED_GUNPOWNDER         100
#define POINTS_BUILT_FUSE                 100
#define POINTS_COMBINED_GUNPOWDER_FUSE    100
#define POINTS_COMBINED_BOMB_ADHESIVE     100
#define POINTS_ATTACHED_BOMB_TO_SAFE      100
#define POINTS_IGNITED_BOMB               100

#define POINTS_COMBINED_BATTERIES_GAME    100

#define POINTS_WINDOW_ROPE                100
#define POINTS_COMBINED_CUE_ROPE          100
#define POINTS_MADE_CLAY_WET              100

#define POINTS_GAVE_BREAD_TO_FISH         100

#define POINTS_GAVE_BREAD_TO_DOVE         100
#define POINTS_GAVE_APPLES_TO_DOVE        100
#define POINTS_CAPTURED_THE_DOVE          200
#define POINTS_DOG_CHASED_DOVE            500

#define POINTS_DRUGGED_MEAT               100
#define POINTS_DRUGGED_DOG                200
#define POINTS_DISABLED_DOG               400

#define POINTS_DART_GUNNED_DOG            200
#define POINTS_DART_GUNNED_THUG           200

#define POINTS_SEARCHED_THUG              100

#define POINTS_DISABLED_THUG             500

#define POINTS_MET_THE_GIRL             1000
#define POINTS_WON_THE_GAME             1000

#define POINTS_READ_NEWSPAPER             50
#define POINTS_READ_NOTE                  50
#define POINTS_READ_BOOK                  50
#define POINTS_READ_RECIPES               50
#define POINTS_READ_INVOICE               50
#define POINTS_READ_TOMBSTONE             50

#define POINTS_INSPECT_MAP                50
#define POINTS_INSPECT_GAME               50
#define POINTS_INSPECT_BOOK               50
#define POINTS_INSPECT_FRIDGE             50
#define POINTS_INSPECT_CABINET            50
#define POINTS_INSPECT_PANEL              50
#define POINTS_INSPECT_CELLAR_WINDOW      50
#define POINTS_INSPECT_PANIC_ROOM_WINDOW  50
#define POINTS_INSPECT_PANIC_ROOM_DOOR    50
#define POINTS_INSPECT_PLASTIC_BAG        50
#define POINTS_INSPECT_MIX_TAPE           50
#define POINTS_INSPECT_SAFE               50
#define POINTS_INSPECT_THUG               50
#define POINTS_INSPECT_PROTECTION_SUIT    50
#define POINTS_INSPECT_HOLE               50

#define POINTS_USED_KEY                  100
#define POINTS_USED_SWITCH               100
#define POINTS_USED_HOSE                 100
#define POINTS_USED_CLAY                 100
#define POINTS_GAVE_KNIFE_TO_GIRL        500
#define POINTS_OPENED_PANIC_ROOM_WINDOW  500
#define POINTS_SMASHED_WINDOW_WITH_CUE   500
#define POINTS_GIRL_USES_ROPE            500

#define MALUS_POINTS_GAME_OVER           1800
#define MALUS_POINTS_GIVE_UP             3600

#endif // GAME_ENUMS_H
