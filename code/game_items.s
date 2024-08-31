
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
    ITEM_CONTAINER( _gTextItemFishingNet  ,e_LOC_FISHPND         )  // e_ITEM_FishingNet           
    ITEM_CONTAINER( _gTextItemPlasticBag  ,e_LOC_MARKETPLACE     )  // e_ITEM_PlasticBag           
    ITEM_CONTAINER( _gTextItemSmallBottle ,e_LOC_NONE            )  // e_ITEM_SmallBottle          

    // Items requiring containers
    ITEM( _gTextItemBlackDust             ,e_LOC_DARKTUNNEL      ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_Saltpetre            
    ITEM( _gTextItemYellowPowder          ,e_LOC_INSIDE_PIT      ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_Sulphur         
    ITEM( _gTextItemPetrol                ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin))                       // e_ITEM_Petrol               
    ITEM( _gTextItemWater                 ,e_LOC_WELL            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin))                       // e_ITEM_Water                
    ITEM( _gTextItemLargeDove             ,e_LOC_WOODEDAVENUE    ,ITEM_FLAG_IMMOVABLE       ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_CardboardBox,e_ITEM_FishingNet))                     // e_ITEM_LargeDove            
    ITEM( _gTextItemPowderMix             ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_PowderMix            
    ITEM( _gTextItemGunPowder             ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK1(e_ITEM_TobaccoTin))                                                       // e_ITEM_GunPowder            

    // Normal items|
    ITEM_NORMAL( _gTextItemFridge                ,e_LOC_KITCHEN         ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_Fridge
    ITEM_NORMAL( _gTextItemSedativePills         ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_SedativePills     
    ITEM_NORMAL( _gTextItemBasementWindow        ,e_LOC_VEGSGARDEN      ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_BasementWindow
    ITEM_NORMAL( _gTextItemTwine                 ,e_LOC_GREENHOUSE      ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Twine                
    ITEM_NORMAL( _gTextItemSilverKnife           ,e_LOC_VEGSGARDEN      ,ITEM_FLAG_DEFAULT)                         // e_ITEM_SilverKnife          
    ITEM_NORMAL( _gTextItemLadder                ,e_LOC_ORCHARD         ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Ladder               
    ITEM_NORMAL( _gTextItemMixTape               ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_MixTape         
    ITEM_NORMAL( _gTextItemAlsatianDog           ,e_LOC_LARGE_STAIRCASE ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_AlsatianDog          
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
    ITEM_NORMAL( _gTextItemHose                  ,e_LOC_ZENGARDEN       ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Hose             
    ITEM_NORMAL( _gTextItemBrokenGlass           ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_BrokenGlass          
    ITEM_NORMAL( _gTextItemMedicineCabinet       ,e_LOC_KITCHEN         ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)      // e_ITEM_Medicinecabinet
    ITEM_NORMAL( _gTextItemYoungGirl             ,e_LOC_HOSTAGE_ROOM    ,ITEM_FLAG_DEFAULT)                         // e_ITEM_YoungGirl        
    ITEM_NORMAL( _gTextItemFuse                  ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Fuse                 
    ITEM_NORMAL( _gTextItemKeys                  ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Keys                 
    ITEM_NORMAL( _gTextItemNewspaper             ,e_LOC_INVENTORY       ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Newspaper            
    ITEM_NORMAL( _gTextItemBomb                  ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Bomb                 
    ITEM_NORMAL( _gTextItemPistol                ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Pistol               
    ITEM_NORMAL( _gTextItemBullets               ,e_LOC_NONE            ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Bullets              
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
    ITEM_NORMAL( _gTextItemLockedPanel           ,e_LOC_NONE            ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED|ITEM_FLAG_LOCKED)      // e_ITEM_AlarmPanel
    ITEM_NORMAL( _gTextItemSecurityDoor          ,e_LOC_PANIC_ROOM_DOOR ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_SecurityDoor
    ITEM_NORMAL( _gTextItemDriedOutClay          ,e_LOC_CHILDBEDROOM    ,ITEM_FLAG_DEFAULT)                         // e_ITEM_Clay
    ITEM_NORMAL( _gTextItemProtectionSuit        ,e_LOC_GREENHOUSE      ,ITEM_FLAG_DEFAULT)                         // e_ITEM_ProtectionSuit
    ITEM_NORMAL( _gTextItemHoleInDoor            ,e_LOC_NONE            ,ITEM_FLAG_IMMOVABLE)                       // e_ITEM_HoleInDoor
