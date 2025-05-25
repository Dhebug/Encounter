
#include "game_enums.h"

//
// These macros can be used to generate the list of containers that can be 
// used with a specific item: You can't get powder in a net, neither can you
// store water in a cardboard box (or at least not for very long)
//
#define CONTAINER_MASK1(a)          (1<<(a))
#define CONTAINER_MASK2(a,b)        (CONTAINER_MASK1(a)+(1<<(b)))
#define CONTAINER_MASK3(a,b,c)      (CONTAINER_MASK2(a,b)+(1<<(c)))
#define CONTAINER_MASK4(a,b,c,d)    (CONTAINER_MASK3(a,b,c)+(1<<(d)))

#define ITEM_CONTAINER(description,location)             .byt <description,>description,location,255,ITEM_FLAG_IS_CONTAINER,0
#define ITEM(description,location,flags,containers)      .byt <description,>description,location,255,flags,containers
#define ITEM_NORMAL(description,location,flags)          .byt <description,>description,location,255,flags,0

; The content must match the "item" structure layout in game_defines.h
_gItems
    //   Item                             World                       Generic                    Containers usable
    //   description                      location                    flags                      with this specific item
    // Containers
    ITEM_CONTAINER( _gTextItemTobaccoTin  ,e_LOC_LOUNGE          )  // e_ITEM_TobaccoTin           
    ITEM_CONTAINER( _gTextItemBucket      ,e_LOC_WELL            )  // e_ITEM_Bucket               
    ITEM_CONTAINER( _gTextItemCardboardBox,e_LOC_GREENHOUSE      )  // e_ITEM_CardboardBox         
    ITEM_CONTAINER( _gTextItemNet         ,e_LOC_TENNISCOURT     )  // e_ITEM_Net           
    ITEM_CONTAINER( _gTextItemPlasticBag  ,e_LOC_MARKETPLACE     )  // e_ITEM_PlasticBag           

    // Items requiring containers
    ITEM( _gTextItemGunPowder             ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_GunPowder            
    ITEM( _gTextItemBlackDust             ,e_LOC_DARKTUNNEL      ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_Saltpetre            
    ITEM( _gTextItemYellowPowder          ,e_LOC_INSIDE_PIT      ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_Sulphur         
    ITEM( _gTextItemPetrol                ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin))                       // e_ITEM_Petrol               
    ITEM( _gTextItemWater                 ,e_LOC_WELL            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin))                       // e_ITEM_Water                
    ITEM( _gTextItemLargeDoveOutOfReach   ,e_LOC_WOODEDAVENUE    ,ITEM_FLAG_IMMOVABLE       ,CONTAINER_MASK2(e_ITEM_CardboardBox,e_ITEM_Net))                                          // e_ITEM_LargeDove            
    ITEM( _gTextItemPowderMix             ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_PowderMix            

    // Normal items|
    ITEM_NORMAL( _gTextItemTelevision            ,e_LOC_GAMESROOM       ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Television
    ITEM_NORMAL( _gTextItemFridge                ,e_LOC_KITCHEN         ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_Fridge
    ITEM_NORMAL( _gTextItemSedativePills         ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_SedativePills     
    ITEM_NORMAL( _gTextItemBasementWindow        ,e_LOC_VEGSGARDEN      ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_BasementWindow
    ITEM_NORMAL( _gTextItemFancyStones           ,e_LOC_ZENGARDEN       ,ITEM_FLAG_DEFAULT)                         // e_ITEM_FancyStones                
    ITEM_NORMAL( _gTextItemSilverKnife           ,e_LOC_VEGSGARDEN      ,ITEM_FLAG_DEFAULT)                         // e_ITEM_SilverKnife          
    ITEM_NORMAL( _gTextItemLadder                ,e_LOC_ORCHARD         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Ladder               
    ITEM_NORMAL( _gTextItemMixTape               ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_MixTape         
    ITEM_NORMAL( _gTextItemAlsatianDog           ,e_LOC_LARGE_STAIRCASE ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Dog          
    ITEM_NORMAL( _gTextItemMeat                  ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Meat                 
    ITEM_NORMAL( _gTextItemBread                 ,e_LOC_DININGROOM      ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Bread                
    ITEM_NORMAL( _gTextItemBlackTape             ,e_LOC_CELLAR_WINDOW   ,ITEM_FLAG_DEFAULT)                         // e_ITEM_BlackTape
    ITEM_NORMAL( _gTextItemChemistryBook         ,e_LOC_LIBRARY         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_ChemistryBook        
    ITEM_NORMAL( _gTextItemBoxOfMatches          ,e_LOC_LOUNGE          ,ITEM_FLAG_DEFAULT)                         // e_ITEM_BoxOfMatches         
    ITEM_NORMAL( _gTextItemSnookerCue            ,e_LOC_GAMESROOM       ,ITEM_FLAG_DEFAULT)                         // e_ITEM_SnookerCue           
    ITEM_NORMAL( _gTextItemThug                  ,e_LOC_MASTERBEDROOM   ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Thug                 
    ITEM_NORMAL( _gTextItemHeavySafe             ,e_LOC_CELLAR          ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_HeavySafe            
    ITEM_NORMAL( _gTextItemHandWrittenNote       ,e_LOC_BOXROOM         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_HandWrittenNote          
    ITEM_NORMAL( _gTextItemRope                  ,e_LOC_WELL            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Rope                 
    ITEM_NORMAL( _gTextItemHandheldGame          ,e_LOC_CHILDBEDROOM    ,ITEM_FLAG_DEFAULT)                         // e_ITEM_HandheldGame
    ITEM_NORMAL( _gTextItemRollOfToiletPaper     ,e_LOC_TINY_WC         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_ToiletRoll    
    ITEM_NORMAL( _gTextItemHose                  ,e_LOC_FISHPND         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Hose             
    ITEM_NORMAL( _gTextItemGameConsole           ,e_LOC_GAMESROOM       ,ITEM_FLAG_DEFAULT)                         // e_ITEM_GameConsole
    ITEM_NORMAL( _gTextItemMedicineCabinet       ,e_LOC_KITCHEN         ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_Medicinecabinet
    ITEM_NORMAL( _gTextItemYoungGirl             ,e_LOC_HOSTAGE_ROOM    ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_DISABLED)    // e_ITEM_YoungGirl        
    ITEM_NORMAL( _gTextItemFuse                  ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Fuse                 
    ITEM_NORMAL( _gTextItemSmallKey              ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_SmallKey                 
    ITEM_NORMAL( _gTextItemNewspaper             ,e_LOC_INVENTORY       ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Newspaper            
    ITEM_NORMAL( _gTextItemBomb                  ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Bomb                 
    ITEM_NORMAL( _gTextItemPistol                ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Pistol               
    ITEM_NORMAL( _gTextItemInvoice               ,e_LOC_STUDY_ROOM      ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Invoice
    ITEM_NORMAL( _gTextItemChemistryRecipes      ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_ChemistryRecipes     
    ITEM_NORMAL( _gTextItemUnitedKingdomMap      ,e_LOC_LIBRARY         ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_UnitedKingdomMap   
    ITEM_NORMAL( _gTextItemClosedCurtain         ,e_LOC_WESTGALLERY     ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_Curtain
    ITEM_NORMAL( _gTextItemClosedGunCabinet      ,e_LOC_STUDY_ROOM      ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_GunCabinet
    ITEM_NORMAL( _gTextItemDartGun               ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_DartGun
    ITEM_NORMAL( _gTextItemAlarmSwitch           ,e_LOC_NONE            ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_DEFAULT)     // e_ITEM_AlarmSwitch    
    ITEM_NORMAL( _gTextItemCarBoot               ,e_LOC_ABANDONED_CAR   ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_CarBoot
    ITEM_NORMAL( _gTextItemCarDoor               ,e_LOC_ABANDONED_CAR   ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_CarDoor
    ITEM_NORMAL( _gTextItemCarPetrolTank         ,e_LOC_ABANDONED_CAR   ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_CarTank
    ITEM_NORMAL( _gTextItemMortarAndPestle       ,e_LOC_KITCHEN         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_MortarAndPestle
    ITEM_NORMAL( _gTextItemAdhesive              ,e_LOC_BOXROOM         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Adhesive
    ITEM_NORMAL( _gTextItemAcid                  ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Acid
    ITEM_NORMAL( _gTextItemLockedPanel           ,e_LOC_DARKCELLARROOM  ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED|ITEM_FLAG_LOCKED)      // e_ITEM_AlarmPanel
    ITEM_NORMAL( _gTextItemSecurityDoor          ,e_LOC_PANIC_ROOM_DOOR ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_SecurityDoor
    ITEM_NORMAL( _gTextItemDriedOutClay          ,e_LOC_CHILDBEDROOM    ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Clay
    ITEM_NORMAL( _gTextItemProtectionSuit        ,e_LOC_GREENHOUSE      ,ITEM_FLAG_DEFAULT)                         // e_ITEM_ProtectionSuit
    ITEM_NORMAL( _gTextItemHoleInDoor            ,e_LOC_NONE            ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_HoleInDoor
    ITEM_NORMAL( _gTextItemHighUpWindow          ,e_LOC_TILEDPATIO      ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_PanicRoomWindow
    ITEM_NORMAL( _gTextItemFrontDoor             ,e_LOC_FRONT_ENTRANCE  ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_FrontDoor
    ITEM_NORMAL( _gTextItemRoughPlan             ,e_LOC_INVENTORY       ,ITEM_FLAG_DEFAULT)                         // e_ITEM_RoughPlan
    ITEM_NORMAL( _gTextItemMyCar                 ,e_LOC_MARKETPLACE     ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Car
    ITEM_NORMAL( _gTextItemGraffiti              ,e_LOC_DARKTUNNEL      ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Graffiti
    ITEM_NORMAL( _gTextItemChurch                ,e_LOC_MAINSTREET      ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Church
    ITEM_NORMAL( _gTextItemWell                  ,e_LOC_WELL            ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Well
    ITEM_NORMAL( _gTextItemRoadSign              ,e_LOC_EASTERN_ROAD    ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_RoadSign
    ITEM_NORMAL( _gTextItemTrashCan              ,e_LOC_DARKALLEY       ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Trashcan
    ITEM_NORMAL( _gTextItemTombstone             ,e_LOC_PARKING_PLACE   ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Tombstone
    ITEM_NORMAL( _gTextItemFishpond              ,e_LOC_FISHPND         ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_FishPond
    ITEM_NORMAL( _gTextItemFish                  ,e_LOC_FISHPND         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Fish
    ITEM_NORMAL( _gTextItemApple                 ,e_LOC_ORCHARD         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Apple
    ITEM_NORMAL( _gTextItemTree                  ,e_LOC_OUTSIDE_PIT     ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Tree
    ITEM_NORMAL( _gTextItemPit                   ,e_LOC_OUTSIDE_PIT     ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Pit
    ITEM_NORMAL( _gTextItemHeap                  ,e_LOC_OUTSIDE_PIT     ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Heap
    ITEM_NORMAL( _gTextItemNormalWindow          ,e_LOC_NONE            ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_NormalWindow
    ITEM_NORMAL( _gTextItemAlarmIndicator        ,e_LOC_SUNLOUNGE       ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_AlarmIndicator
    ITEM_NORMAL( _gTextItemComputer              ,e_LOC_STUDY_ROOM      ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_Computer
    ITEM_NORMAL( _gTextItemOricComputer          ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Oric
    ITEM_NORMAL( _gTextItemClosedTVCabinet       ,e_LOC_GAMESROOM       ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_TVCabinet
    ITEM_NORMAL( _gTextItemBatteries             ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Batteries
    ITEM_NORMAL( _gTextItemClosedDrawer          ,e_LOC_GUESTBEDROOM    ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_Drawer
#ifdef PRODUCT_TYPE_GAME_DEMO
    ITEM_NORMAL( _gTextItemDemoReadMe            ,e_LOC_SUNLOUNGE       ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_DemoReadMe
#endif
