> [!WARNING]  
> This page contains potential spoilers for the game.  
> If you plan to play the game, you should probably refrain to go farther!
>
> For more information, you can safely read [Encounter.md](../Encounter.md)

- [Items in the code](#items-in-the-code)
- [Items](#items)
	- [Containers](#containers)
	- [Items requiring containers to use](#items-requiring-containers-to-use)
	- [Normal items](#normal-items)
	- [Constructed items](#constructed-items)


# Items in the code 
Items are defined in a static array containing all the information about each item: 
```
typedef struct
{
	const char* description;        	// +0 Full description of the object in the world
	unsigned char location;         	// +2 Where the object is in the world
	unsigned char associated_item;      // +3 For the item<->container association
	unsigned char flags;            	// +4 Special flags on what can be done with the item
	unsigned char usable_containers;	// +5 Bit masks representing the possible containers to store the item
} item;  // sizeof = 6 bytes

extern item gItems[e_ITEM_COUNT_];
```

> [!NOTE]  
> If the size of the **item** structure changes, the code in **_ByteStreamComputeItemPtr** ([bytestream.s](../code/bytestream.h)) has to be adapted else the scripting code will not work properly (and probably crash) when accessing any item flag or location.

**See:**
- [game_enums.h](../code/game_enums.h) for the list of all items
- [game_defines.h](../code/game_defines.h) for the structures and declarations

----
# Items
There are quite a few items available in the game, some are directly usable, some are just container for other items, some need to be fabricated by combining other items.

## Containers
These have no purpose their own, they are just here to allow the player to transport or perform action on hard to transport items
|Item|Description|Define|
|-|-|-|
|**an empty tobacco tin**|Used to transport things or build a bomb|e_ITEM_TobaccoTin
|**a wooden bucket**|Use to transport liquids|e_ITEM_Bucket
|**a cardboard box**|Use to transport non liquids stuff|e_ITEM_CardboardBox
|**a net**|Can be used to catch the dove|e_ITEM_Net
|**a plastic bag**|Can be used to transport dust|e_ITEM_PlasticBag

## Items requiring containers to use
These items cannot just be collected, you need some adequate containers to transport them
|Item|Description|Define|
|-|-|-|
|**some saltpetre**|Component for the black powder|e_ITEM_Saltpetre|
|**some sulphur**|Component for the black powder|e_ITEM_Sulphur|
|**some petrol**|Component for the fuse|e_ITEM_Petrol|
|**some water**|Not actually used|e_ITEM_Water|

## Normal items
These are items you will find around in the various locations
|Item|Description|Define|
|-|-|-|
|**panel on the wall**|Located in the basement dark room and can be opened with the keys|e_ITEM_AlarmPanel|
|**a large dove**|The dove can be captured with the net and used to distract the dog|e_ITEM_LargeDove|
|**a silver knife**|Can be used to slice apples and defend the player|e_ITEM_SilverKnife|
|**a ladder**|Can be used to climb out of the pit or reach the basement window|e_ITEM_Ladder|
|**a car**|The car is a source of petrol|e_ITEM_Car|
|**an alsatian growling at you**|The dog is blocking the access to the second level of the house|e_ITEM_Dog|
|**a joint of meat**|The meat can be given to the dog|e_ITEM_Meat|
|**some brown bread**|The bread can be used to catch the dove|e_ITEM_Bread|
|**some adhesive**|Used to attach the bomb to the safe|e_ITEM_Adhesive|
|**some black adhesive tape**|Covers the basement window to prevent anyone from seeing inside|e_ITEM_BlackTape|
|**a chemistry book**|The book is only there to give hints to the player about what can be made|e_ITEM_ChemistryBook|
|**a box of matches**|Used to ignite the bomb|e_ITEM_BoxOfMatches|
|**a snooker cue**|Can be used as a weapon, but also to break the window|e_ITEM_SnookerCue|
|**a thug asleep on the bed**|There are a few items in his pockets, if you can take control of the situation|e_ITEM_Thug|
|**a heavy safe**|The safe is in the basement and contains chemicals|e_ITEM_HeavySafe|
|**a hand written note**|The note is a help for the player telling them to investigate the safe in the basement|e_ITEM_HandWrittenNote|
|**a length of rope**|The rope is necessary for the girl to escape, but can also be used around the tree to escape the pit|e_ITEM_Rope|
|**a roll of toilet tissue**|The toilet roll can be used to build some fuse for the bomb|e_ITEM_ToiletRoll|
|**a garden-hose**|This tube can be used to get the petrol out of the car tank|e_ITEM_Hose|
|**a small key**|Found in the thug's pockets, it opens the alarm panel in the basement|e_ITEM_SmallKey|
|**a newspaper**|Present in the inventory of the player at the start to provide some information|e_ITEM_Newspaper|
|**a pistol**|Owned by the sleeping thug|e_ITEM_Pistol|
|**a couple chemistry recipes**|Found in the chemistry book in the library|e_ITEM_ChemistryRecipes|
|**a young girl**|The hostage we need to free|e_ITEM_YoungGirl|
|**some sedative pills**|Found in the medicine cabinet, can be used to drug the meat|e_ITEM_SedativePills|
|**a dart gun**|Tranquilizer gun found in the gun cabinet|e_ITEM_DartGun|
|**a mortar and pestle**|Used to grind ingredients for gunpowder|e_ITEM_MortarAndPestle|
|**some acid**|Dangerous chemical found in the safe|e_ITEM_Acid|
|**a protection suit**|Protective gear required to safely handle acid|e_ITEM_ProtectionSuit|
|**an apple**|Fruit from the orchard that can be sliced|e_ITEM_Apple|
|**a rough plan**|Starting inventory item with information|e_ITEM_RoughPlan|
|**a fridge**|Contains meat for the dog when opened|e_ITEM_Fridge|
|**a medicine cabinet**|Contains sedative pills when opened|e_ITEM_Medicinecabinet|
|**a gun cabinet**|Contains the dart gun when opened|e_ITEM_GunCabinet|
|**the car petrol tank**|Fuel tank of the car, source of petrol|e_ITEM_CarTank|
|**a security door**|The reinforced steel-plated panic room door|e_ITEM_SecurityDoor|
|**a hole in the door**|Opening in the panic room door to look through|e_ITEM_HoleInDoor|
|**a high-up window**|Window of the panic room visible from outside|e_ITEM_PanicRoomWindow|
|**a basement window**|Small window to the basement dark room|e_ITEM_BasementWindow|
|**a tree**|Tree that can be used with rope to climb from pit|e_ITEM_Tree|
|**a pit**|Deep hole in the ground|e_ITEM_Pit|
|**a window**|Normal window (can be broken with snooker cue)|e_ITEM_NormalWindow|
|**an alarm indicator**|Display showing alarm status in sun lounge|e_ITEM_AlarmIndicator|
|**an alarm switch**|Switch related to the alarm system|e_ITEM_AlarmSwitch|
|**some dried out clay**|When combined with water, used to build a dam on the steel door to prevent acid spillage|e_ITEM_Clay|

## Constructed items
The following items have to be created by the player by performing some actions on the other items
|Item|Description|Define|
|-|-|-|
|**a fuse**|Made with the toilet paper roll and the petrol|e_ITEM_Fuse|
|**some gunpowder**|Made by mixing salpeter and sulfur|e_ITEM_GunPowder|
|**some gunpowder mix**|Intermediate step when mixing saltpetre and sulphur before grinding|e_ITEM_PowderMix|
|**a bomb**|The combinaison of various items resulting in a quite powerful device|e_ITEM_Bomb|

## Additional Items

These are decorative and environmental items that are not part of the main puzzle chain
|Item|Description|Define|
|-|-|-|
|**a television**|Found in the games room|e_ITEM_Television|
|**some fancy stones**|Decorative stones in the zen garden|e_ITEM_FancyStones|
|**a mix tape**|Music cassette tape|e_ITEM_MixTape|
|**a handheld game**|Portable gaming device that requires batteries to play Monkey King|e_ITEM_HandheldGame|
|**a game console**|Gaming console in the games room|e_ITEM_GameConsole|
|**an invoice**|Business document found in the study room|e_ITEM_Invoice|
|**a map of the United Kingdom**|Decorative element on the wall of the library|e_ITEM_UnitedKingdomMap|
|**SR44 batteries**|Button cell batteries for the handheld game|e_ITEM_Batteries|
|**the car boot**|Trunk of the car|e_ITEM_CarBoot|
|**the car door**|Door of the car|e_ITEM_CarDoor|
|**an impressive entrance door**|The massive front door of the manor|e_ITEM_FrontDoor|
|**a drawer**|Drawer in guest bedroom containing batteries|e_ITEM_Drawer|
|**a curtain**|Decorative curtain in the west gallery|e_ITEM_Curtain|
|**graffiti**|Writing on the wall in the dark tunnel|e_ITEM_Graffiti|
|**the old church**|Church building on main street|e_ITEM_Church|
|**the old well**|Well structure in the wooded area|e_ITEM_Well|
|**a road sign**|Sign at the construction entrance|e_ITEM_RoadSign|
|**a trashcan**|Garbage bin in the dark alley|e_ITEM_Trashcan|
|**a tombstone**|Grave marker near the parking area|e_ITEM_Tombstone|
|**a fish pond**|Ornamental pond with fish|e_ITEM_FishPond|
|**a fish**|Fish swimming in the pond|e_ITEM_Fish|
|**a heap**|Pile of dirt near the pit|e_ITEM_Heap|
|**a desktop computer**|Computer in the study room|e_ITEM_Computer|
|**an Oric computer**|Oric computer accessible via TV cabinet in games room|e_ITEM_Oric|
|**a TV cabinet**|Cabinet containing the Oric computer|e_ITEM_TVCabinet|
|**a Dune book**|Science fiction novel in the guest bedroom|e_ITEM_DuneBook|

