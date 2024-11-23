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
|**black dust**|Component for the black powder|e_ITEM_Saltpetre|
|**gritty yellow powder**|Component for the black powder|e_ITEM_Sulphur|
|**some petrol**|Component for the fuse|e_ITEM_Petrol|
|**some water**|Not actually used|e_ITEM_Water|

## Normal items
These are items you will find around in the various locations
|Item|Description|Define|
|-|-|-|
|**panel on the wall**|Located in the basement dark room and can be opened with the keys|e_ITEM_AlarmPanel|
|**a large dove**|The dove can be captured with the fishing net and used to distract the dog|e_ITEM_LargeDove|
|**a string**|The string can be used to control the thug|e_ITEM_String|
|**a silver knife**|The knife is there to help defend the player|e_ITEM_SilverKnife|
|**a ladder**|The ladder is too short to reach the window but can be used to climb out of the pit|e_ITEM_Ladder<br>e_ITEM_LadderInTheHole|
|**an abandoned car**|The car is a source of petrol - and possibly rust|e_ITEM_AbandonedCar|
|**an alsatian growling at you**|The dog is blocking the access to the second level of the house|e_ITEM_Dog|
|**a joint of meat**|The meat can be given to the dog|e_ITEM_Meat|
|**some brown bread**|The bread can be used to catch the dove|e_ITEM_Bread|
|**a roll of sticky tape**||e_ITEM_RollOfTape|
|**a chemistry book**|The book is only there to give hints to the player about what can be made|e_ITEM_ChemistryBook|
|**a box of matches**|Used to ignite the bomb|e_ITEM_BoxOfMatches|
|**a snooker cue**|Can be used as a weapon, but also to break the window|e_ITEM_SnookerCue|
|**a thug asleep on the bed**|There are a few items in his pockets, if you can take control of the situation|e_ITEM_Thug|
|**a heavy safe**|The safe is in the basement and contains chemicals|e_ITEM_HeavySafe<br>e_ITEM_HeavySafe|
|**a hand written note**|The note is a help for the player telling them to investigate the safe in the basement|e_ITEM_HandWrittenNote|
|**a length of rope**|The rope is necessary for the girl to escape, but can also be used around the tree to escape the pit|e_ITEM_Rope<br>e_ITEM_RopeAttachedToATree|
|**a roll of toilet tissue**|The toilet roll can be used to build some fuse for the bomb|e_ITEM_ToiletRoll|
|**a garden-hose**|This tube can be used to get the petrol out of the car tank|e_ITEM_Hose|
|**a small key**|Found ouside the house, they open the panel with the alarm (probably fell from the pockets of the owner)|e_ITEM_Keys|
|**a newspaper**|Present in the inventory of the player at the start to provide some information|e_ITEM_Newspaper|
|**a pistol**|Owned by the sleeping thug|e_ITEM_Pistol|
|**three .38 bullets**|Bullets for the pistol, found in another room|e_ITEM_Bullets|
|**a couple chemistry recipes**|Found in the chemistry book in the library|e_ITEM_ChemistryRecipes|
|**a map of the United Kingdom**|Some decorative element on the wall of the library, the idea is to provide some information about why there is a kidnapping|e_ITEM_UnitedKingdomMap|
|**a young girl**|The hostage we need to free|e_ITEM_YoungGirl|

## Constructed items
The following items have to be created by the player by performing some actions on the other items
|Item|Description|Define|
|-|-|-|
|**a fuse**|Made with the toilet paper roll and the petrol|e_ITEM_Fuse|
|**some gunpowder**|Made by mixing salpeter and sulfur|e_ITEM_GunPowder|
|**a bomb**|The combinaison of various items resulting in a quite powerful device|e_ITEM_Bomb|

