

// The various locations: These have to be in the same order as the e_WORD_xxx directions
#define e_DIRECTION_NORTH  0
#define e_DIRECTION_SOUTH  1
#define e_DIRECTION_EAST   2
#define e_DIRECTION_WEST   3
#define e_DIRECTION_UP     4   // Seldomly used (to go to the house upper floor and basement)
#define e_DIRECTION_DOWN   5   // Seldomly used (to go to the house upper floor and basement)
#define e_DIRECTION_COUNT_ 6 


// Define the various locations
#define	e_LOC_MARKETPLACE       0
#define	e_LOC_DARKALLEY         1
#define	e_LOC_ROAD              2
#define	e_LOC_DARKTUNNEL        3
#define	e_LOC_MAINSTREET        4
#define	e_LOC_EASTERN_ROAD      5
#define	e_LOC_INSIDE_PIT        6
#define	e_LOC_WELL              7
#define	e_LOC_WOODEDAVENUE      8
#define	e_LOC_GRAVELDRIVE       9 
#define	e_LOC_PARKING_PLACE    10
#define	e_LOC_ZENGARDEN        11
#define	e_LOC_LAWN             12
#define	e_LOC_GREENHOUSE       13
#define	e_LOC_TENNISCOURT      14
#define	e_LOC_VEGSGARDEN       15
#define	e_LOC_FISHPND          16
#define	e_LOC_TILEDPATIO       17
#define	e_LOC_ORCHARD          18
#define e_LOC_DARKCELLARROOM   19
#define	e_LOC_CELLAR           20
#define	e_LOC_BASEMENT_STAIRS  21
#define	e_LOC_LOUNGE           22
#define	e_LOC_ENTRANCEHALL     23
#define	e_LOC_LIBRARY          24
#define	e_LOC_DININGROOM       25
#define	e_LOC_LARGE_STAIRCASE  26
#define	e_LOC_GAMESROOM        27
#define	e_LOC_SUNLOUNGE        28
#define	e_LOC_KITCHEN          29
#define	e_LOC_NARROWPASSAGE    30 
#define	e_LOC_GUESTBEDROOM     31
#define	e_LOC_CHILDBEDROOM     32
#define	e_LOC_MASTERBEDROOM    33
#define	e_LOC_SHOWERROOM       34
#define	e_LOC_TINY_WC          35
#define	e_LOC_EASTGALLERY      36
#define	e_LOC_BOXROOM          37
#define	e_LOC_PADLOCKED_ROOM   38
#define	e_LOC_CLASSY_BATHROOM  39
#define	e_LOC_WESTGALLERY      40
#define	e_LOC_UP_STAIRS        41
#define	e_LOC_OUTSIDE_PIT      42
#define e_LOC_STUDY_ROOM       43
#define	e_LOC_CELLAR_WINDOW    44
#define e_LOC_FRONT_ENTRANCE   45
#define e_LOC_ABANDONED_CAR    46
#define e_LOC_COUNT_           47
#define e_LOC_INVENTORY        e_LOC_COUNT_         // Special location for the player's inventory
#define e_LOC_CURRENT          253                  // For the scripting, so objects can be dumped to where the player is
#define e_LOC_GONE_FOREVER     254                  // To indicate this item is not available anymore
#define e_LOC_NONE             255                  // To indicate we can't go in this particular location


// Define the various items, followed by instructions to simplify the parser
// Containers first
#define	e_ITEM_TobaccoTin    		 0          // an empty tobacco tin
#define	e_ITEM_Bucket        		 1          // a wooden bucket
#define	e_ITEM_CardboardBox  		 2          // a cardboard box
#define	e_ITEM_FishingNet    		 3          // a fishing net
#define	e_ITEM_PlasticBag    		 4          // a plastic bag
#define	e_ITEM_SmallBottle  		 5          // a small bottle
#define	e_ITEM__Last_Container       5          // ----- END CONTAINERS MARKER

// Items requiring containers
#define	e_ITEM_Saltpetre  			 6          // some saltpetre
#define	e_ITEM_Sulphur               7          // some sulphur
#define	e_ITEM_Petrol  				 8          // some petrol
#define	e_ITEM_Water  				 9          // some water
#define	e_ITEM_LargeDove  			 10         // a large dove
#define	e_ITEM_GunPowder  			 11         // some gunpowder
#define	e_ITEM__Last_Transportable   11         // ----- END TRANSPORTABLE MARKER

// Then normal items
#define	e_ITEM_AlarmPanel  		     12         // a locked panel on the wall / an open panel on wall
#define	e_ITEM_Fridge  			     13         // a fridge
#define	e_ITEM_SedativePills 		 14         // some sedative pills
#define e_ITEM_BasementWindow        15         // a basement window
#define	e_ITEM_Twine  				 16         // some twine
#define	e_ITEM_SilverKnife  		 17         // a silver knife
#define	e_ITEM_Ladder  				 18         // a ladder
#define	e_ITEM_MixTape      		 19         // a mix tape
#define	e_ITEM_AlsatianDog  		 20         // Alsatian dog
#define	e_ITEM_Meat  				 21         // a joint of meat
#define	e_ITEM_Bread  				 22         // some brown bread
#define	e_ITEM_BlackTape  			 23         // black tape
#define	e_ITEM_ChemistryBook  		 24         // a chemistry book
#define	e_ITEM_BoxOfMatches  		 25         // a box of matches
#define	e_ITEM_SnookerCue  			 26         // a snooker cue
#define	e_ITEM_Thug  				 27         // a Thug
#define	e_ITEM_HeavySafe  			 28         // a heavy safe
#define	e_ITEM_HandWrittenNote  	 29         // a hand written note
#define	e_ITEM_Rope  				 30         // a length of rope
#define e_ITEM_HandheldGame          31         // a handheld game
#define	e_ITEM_ToiletRoll            32         // a roll of toilet tissue~
#define	e_ITEM_HosePipe  			 33         // a hose-pipe
#define	e_ITEM_BrokenGlass  		 34         // broken glass
#define e_ITEM_Medicinecabinet       35         // a thick curtain
#define	e_ITEM_YoungGirl  			 36         // a young girl
#define	e_ITEM_Fuse  				 37         // a fuse
#define	e_ITEM_Keys  				 38         // a set of keys
#define	e_ITEM_Newspaper     		 39         // A newspaper
#define	e_ITEM_Bomb  				 40         // a bomb
#define	e_ITEM_Pistol 				 41         // a pistol
#define	e_ITEM_Bullets  			 42         // three .38 bullets
#define	e_ITEM_ChemistryRecipes   	 43         // a sheet of paper with a few recipes on things to build
#define	e_ITEM_UnitedKingdomMap   	 44         // the map of the UK in the library
#define e_ITEM_Curtain               45         // a thick curtain
#define e_ITEM_GunCabinet            46         // a gun cabinet
#define e_ITEM_DartGun               47         // a dart gun
#define e_ITEM_AlarmSwitch           48         // a alarm switch
#define e_ITEM_CarBoot               49         // the car boot
#define e_ITEM_CarDoor               50         // the car door
#define e_ITEM_CarTank               51         // the car petrol tank
#define	e_ITEM_COUNT_ 				 52         //  ----- END MARKER - Free until 127, after are action words
#define e_ITEM_CURRENT               52         // For the scripting, so the current objects can be accessed from various scripts
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
#ifdef ENABLE_CHEATS
#define	e_WORD_INVOKE                145
#endif    
// Meta instructions
#define	e_WORD_QUIT                  146
#define	e_WORD_COUNT_                147
// Additional values for the parser
#define	e_WORD_CONTINUE              148


// Flags for the items
#define ITEM_FLAG_DEFAULT 			0    // Nothing special
#define ITEM_FLAG_IS_CONTAINER 		1    // This item is a container
#define ITEM_FLAG_NEEDS_CONTAINER 	2    // This item needs to be transported in a container
#define ITEM_FLAG_IMMOVABLE			4    // Impossible to move for various reasons
#define ITEM_FLAG_LOCKED            8    // For item which are locked
#define ITEM_FLAG_DISABLED         16    // Used to indicate that something is not active anymore (ex: Dog, Thug )
#define ITEM_FLAG_ATTACHED         32    // Used to indicate that this item is attached to something (ex: Rope with the tree or window)
#define ITEM_FLAG_CLOSED           64    // For items that can be opened and closed
#define ITEM_FLAG_TRANSFORMED     128    // For items that get transformed (drugged meat)

// Achievements
#define ACHIEVEMENT_SOLVED_THE_CASE     0
#define ACHIEVEMENT_MAIMED_BY_DOG       1
#define ACHIEVEMENT_SHOT_BY_THUG        2
#define ACHIEVEMENT_FELL_INTO_PIT       3
#define ACHIEVEMENT_TRIPPED_ALARM       4
#define ACHIEVEMENT_RAN_OUT_OF_TIME     5
#define ACHIEVEMENT_BLOWN_INTO_BITS     6
#define ACHIEVEMENT_SIMPLY_VANISHED     7

#define ACHIEVEMENT_GAVE_UP             8
#define ACHIEVEMENT_LAUNCHED_THE_GAME   9   // It's kind of a basic one...
#define ACHIEVEMENT_WATCHED_THE_INTRO   10
#define ACHIEVEMENT_READ_THE_NEWSPAPER  11
#define ACHIEVEMENT_READ_THE_BOOK       12
#define ACHIEVEMENT_READ_THE_NOTE       13
#define ACHIEVEMENT_READ_THE_RECIPES    14
#define ACHIEVEMENT_OPENED_THE_FRIDGE   15

#define ACHIEVEMENT_OPENED_THE_CABINET  16
#define ACHIEVEMENT_DRUGGED_THE_MEAT    17
#define ACHIEVEMENT_KILLED_THE_DOG      18
#define ACHIEVEMENT_DRUGGED_THE_DOG     19
#define ACHIEVEMENT_CHASED_THE_DOG      20
#define ACHIEVEMENT_KILLED_THE_THUG     21
#define ACHIEVEMENT_DRUGGED_THE_THUG    22
#define ACHIEVEMENT_CAPTURED_THE_DOVE   23

#define ACHIEVEMENT_USED_THE_ROPE       24
#define ACHIEVEMENT_USED_THE_LADDER     25
#define ACHIEVEMENT_EXAMINED_THE_MAP    26
#define ACHIEVEMENT_EXAMINED_THE_GAME   27
#define ACHIEVEMENT_OPENED_THE_SAFE     28
#define ACHIEVEMENT_OPENED_THE_PANEL    29
#define ACHIEVEMENT_BUILT_A_FUSE        30
#define ACHIEVEMENT_BUILT_A_BOMB        31

#define ACHIEVEMENT_MADE_BLACK_POWDER   32
#define ACHIEVEMENT_FRISKED_THE_THUG    33
#define ACHIEVEMENT_USED_THE_ACID       34
#define ACHIEVEMENT_MADE_THERMITE       35
#define ACHIEVEMENT_PIERCED_THE_DOOR    36
#define ACHIEVEMENT_OPENED_THE_CURTAIN  37
#define ACHIEVEMENT_GAVE_THE_KNIFE      38
#define ACHIEVEMENT_GAVE_THE_ROPE       39

#define ACHIEVEMENT_WATCHED_THE_OUTRO   40
#define ACHIEVEMENT_GOT_A_HIGHSCORE     41
#define ACHIEVEMENT_GOT_THE_BEST_SCORE  42
#define ACHIEVEMENT_DOG_ATE_THE_MEAT    43
#define ACHIEVEMENT_USED_HOSE_PIPE      44
#define ACHIEVEMENT_FREE_3              45
#define ACHIEVEMENT_FREE_4              46
#define ACHIEVEMENT_FREE_5              47

#define	ACHIEVEMENT_COUNT_ 				48      //  Can't have more than 48 achievements
#define ACHIEVEMENT_BYTE_COUNT           6


// Game end conditions
#define e_SCORE_UNNITIALIZED     0
#define e_SCORE_SOLVED_THE_CASE  1
#define e_SCORE_MAIMED_BY_DOG    2
#define e_SCORE_SHOT_BY_THUG     3
#define e_SCORE_FELL_INTO_PIT    4
#define e_SCORE_TRIPPED_ALARM    5
#define e_SCORE_RAN_OUT_OF_TIME  6
#define e_SCORE_BLOWN_INTO_BITS  7
#define e_SCORE_SIMPLY_VANISHED  8
#define e_SCORE_GAVE_UP          9
