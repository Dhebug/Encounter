

// Define the various locations
#define	e_LOCATION_MARKETPLACE       0
#define	e_LOCATION_DARKALLEY         1
#define	e_LOCATION_ROAD              2
#define	e_LOCATION_DARKTUNNEL        3
#define	e_LOCATION_MAINSTREET        4
#define	e_LOCATION_NARROWPATH        5
#define	e_LOCATION_INSIDEHOLE        6
#define	e_LOCATION_WELL              7
#define	e_LOCATION_WOODEDAVENUE      8
#define	e_LOCATION_GRAVELDRIVE       9 
#define	e_LOCATION_TARMACAREA       10
#define	e_LOCATION_ZENGARDEN        11
#define	e_LOCATION_LAWN             12
#define	e_LOCATION_GREENHOUSE       13
#define	e_LOCATION_TENNISCOURT      14
#define	e_LOCATION_VEGSGARDEN       15
#define	e_LOCATION_FISHPND          16
#define	e_LOCATION_TILEDPATIO       17
#define	e_LOCATION_APPLE_TREES      18
#define e_LOCATION_DARKCELLARROOM   19
#define	e_LOCATION_CELLAR           20
#define	e_LOCATION_NARROWSTAIRCASE  21
#define	e_LOCATION_LOUNGE           22
#define	e_LOCATION_ENTRANCEHALL     23
#define	e_LOCATION_LIBRARY          24
#define	e_LOCATION_DININGROOM       25
#define	e_LOCATION_LARGE_STAIRCASE  26
#define	e_LOCATION_GAMESROOM        27
#define	e_LOCATION_SUNLOUNGE        28
#define	e_LOCATION_KITCHEN          29
#define	e_LOCATION_NARROWPASSAGE    30 
#define	e_LOCATION_GUESTBEDROOM     31
#define	e_LOCATION_CHILDBEDROOM     32
#define	e_LOCATION_MASTERBEDROOM    33
#define	e_LOCATION_SHOWERROOM       34
#define	e_LOCATION_TINY_WC          35
#define	e_LOCATION_EASTGALLERY      36
#define	e_LOCATION_BOXROOM          37
#define	e_LOCATION_PADLOCKED_ROOM   38
#define	e_LOCATION_CLASSY_BATHROOM  39
#define	e_LOCATION_WESTGALLERY      40
#define	e_LOCATION_UP_STAIRS        41
#define	e_LOCATION_OUTSIDE_PIT      42
#define	e_LOCATION_GIRLROOM         43
#define e_LOCATION_COUNT_           44
#define e_LOCATION_INVENTORY        e_LOCATION_COUNT_    // Special location for the player's inventory
#define e_LOCATION_GONE_FOREVER     254                  // To indicate this item is not available anymore
#define e_LOCATION_NONE             255                  // To indicate we can't go in this particular location


// Define the various items
// Define the various items
// Containers first
#define	e_ITEM_TobaccoTin    		 0          // an empty tobacco tin
#define	e_ITEM_Bucket        		 1          // a wooden bucket
#define	e_ITEM_CardboardBox  		 2          // a cardboard box
#define	e_ITEM_FishingNet    		 3          // a fishing net
#define	e_ITEM_PlasticBag    		 4          // a plastic bag
#define	e_ITEM_SmallBottle  		 5          // a small bottle
#define	e_ITEM__Last_Container       5          // ----- END CONTAINERS MARKER

// Items requiring containers
#define	e_ITEM_BlackDust  			 6          // black dust
#define	e_ITEM_YellowPowder  		 7          // gritty yellow powder
#define	e_ITEM_Petrol  				 8          // some petrol
#define	e_ITEM_Water  				 9          // some water
#define	e_ITEM_LargeDove  			 10         // a large dove
#define	e_ITEM_GunPowder  			 11         // some gunpowder
#define	e_ITEM__Last_Transportable   11         // ----- END TRANSPORTABLE MARKER

// Then normal items
#define	e_ITEM_LockedPanel  		 12         // a locked panel on the wall / an open panel on wall
#define	e_ITEM_Fridge  			     13         // a fridge
#define	e_ITEM_SmallHoleInDoor 		 14         // a small hole in the door
#define	e_ITEM_BrokenWindow  		 15         // the window is broken
#define	e_ITEM_Twine  				 16         // some twine
#define	e_ITEM_SilverKnife  		 17         // a silver knife
#define	e_ITEM_Ladder  				 18         // a ladder
#define	e_ITEM_AbandonedCar  		 19         // an abandoned car
#define	e_ITEM_AlsatianDog  		 20         // Alsatian dog
#define	e_ITEM_Meat  				 21         // a joint of meat
#define	e_ITEM_Bread  				 22         // some brown bread
#define	e_ITEM_RollOfTape  			 23         // a roll of sticky tape
#define	e_ITEM_ChemistryBook  		 24         // a chemistry book
#define	e_ITEM_BoxOfMatches  		 25         // a box of matches
#define	e_ITEM_SnookerCue  			 26         // a snooker cue
#define	e_ITEM_Thug  				 27         // a Thug
#define	e_ITEM_HeavySafe  			 28         // a heavy safe
#define	e_ITEM_HandWrittenNote  	 29         // a hand written note
#define	e_ITEM_Rope  				 30         // a length of rope
#define e_ITEM_HandheldGame          31         // a handheld game
#define	e_ITEM_RollOfToiletPaper  	 32         // a roll of toilet tissue~
#define	e_ITEM_HosePipe  			 33         // a hose-pipe
#define	e_ITEM_BrokenGlass  		 34         // broken glass
#define	e_ITEM_AcidBurn  			 35         // an acid burn
#define	e_ITEM_YoungGirl  			 36         // a young girl
#define	e_ITEM_Fuse  				 37         // a fuse
#define	e_ITEM_Keys  				 38         // a set of keys
#define	e_ITEM_Newspaper     		 39         // A newspaper
#define	e_ITEM_Bomb  				 40         // a bomb
#define	e_ITEM_Pistol 				 41         // a pistol
#define	e_ITEM_Bullets  			 42         // three .38 bullets
#define	e_ITEM_YoungGirlOnFloor  	 43         // a young girl tied up on the floor
#define	e_ITEM_ChemistryRecipes   	 44         // a sheet of paper with a few recipes on things to build
#define	e_ITEM_UnitedKingdomMap   	 45         // the map of the UK in the library
#define e_ITEM_Curtain               46         // a thick curtain
#define e_ITEM_Medicinecabinet       47         // a thick curtain
#define e_ITEM_SedativePills         48         // some sedative pills
#define	e_ITEM_COUNT_ 				 49         //  ----- END MARKER
// End marker


#define ITEM_FLAG_DEFAULT 			0    // Nothing special
#define ITEM_FLAG_IS_CONTAINER 		1    // This item is a container
#define ITEM_FLAG_NEEDS_CONTAINER 	2    // This item needs to be transported in a container
#define ITEM_FLAG_IMMOVABLE			4    // Impossible to move for various reasons
#define ITEM_FLAG_EVAPORATES        8    // Used to the water and petrol when you try to drop them
#define ITEM_FLAG_DISABLED          16    // Used to indicate that something is not active anymore (ex: Dog, Thug )
#define ITEM_FLAG_ATTACHED         32    // Used to indicate that this item is attached to something (ex: Rope with the tree or window)
#define ITEM_FLAG_CLOSED           64    // For items that can be opened and closed
#define ITEM_FLAG_TRANSFORMED     128    // For items that get transformed (drugged meat)
