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

extern location gLocations[e_LOCATION_COUNT_];

extern const char* gDirectionsArray[];

