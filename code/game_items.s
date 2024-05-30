
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

; The content must match the "item" structure layou in game_defines.h
_gItems
    //   Item                             World                       Generic                    Containers usable
    //   description                      location                    flags                      with this specific item
    // Containers
    ITEM_CONTAINER( _gTextItemTobaccoTin  ,e_LOCATION_LOUNGE          )  // e_ITEM_TobaccoTin           
    ITEM_CONTAINER( _gTextItemBucket      ,e_LOCATION_WELL            )  // e_ITEM_Bucket               
    ITEM_CONTAINER( _gTextItemCardboardBox,e_LOCATION_GREENHOUSE      )  // e_ITEM_CardboardBox         
    ITEM_CONTAINER( _gTextItemFishingNet  ,e_LOCATION_FISHPND         )  // e_ITEM_FishingNet           
    ITEM_CONTAINER( _gTextItemPlasticBag  ,e_LOCATION_MARKETPLACE     )  // e_ITEM_PlasticBag           
    ITEM_CONTAINER( _gTextItemSmallBottle ,e_LOCATION_NONE            )  // e_ITEM_SmallBottle          

    // Items requiring containers
    ITEM( _gTextItemBlackDust             ,e_LOCATION_DARKTUNNEL      ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_BlackDust            
    ITEM( _gTextItemYellowPowder          ,e_LOCATION_INSIDE_PIT      ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_YellowPowder         
    ITEM( _gTextItemPetrol                ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin))                       // e_ITEM_Petrol               
    ITEM( _gTextItemWater                 ,e_LOCATION_WELL            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin))                       // e_ITEM_Water                
    ITEM( _gTextItemLargeDove             ,e_LOCATION_WOODEDAVENUE    ,ITEM_FLAG_IMMOVABLE       ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_CardboardBox,e_ITEM_FishingNet))                     // e_ITEM_LargeDove            
    ITEM( _gTextItemGunPowder             ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox))   // e_ITEM_GunPowder            

    // Normal items
    ITEM_NORMAL( _gTextItemLockedPanel           ,e_LOCATION_DARKCELLARROOM  ,ITEM_FLAG_DEFAULT|ITEM_FLAG_CLOSED)                           // e_ITEM_LockedPanel
    ITEM_NORMAL( _gTextItemFridge                ,e_LOCATION_KITCHEN         ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)                         // e_ITEM_Fridge
    ITEM_NORMAL( _gTextItemSmallHoleInDoor       ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_SmallHoleInDoor      
    ITEM_NORMAL( _gTextItemBrokenWindow          ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_BrokenWindow         
    ITEM_NORMAL( _gTextItemTwine                 ,e_LOCATION_GREENHOUSE      ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Twine                
    ITEM_NORMAL( _gTextItemSilverKnife           ,e_LOCATION_VEGSGARDEN      ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_SilverKnife          
    ITEM_NORMAL( _gTextItemLadder                ,e_LOCATION_APPLE_TREES     ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Ladder               
    ITEM_NORMAL( _gTextItemAbandonedCar          ,e_LOCATION_TARMACAREA      ,ITEM_FLAG_IMMOVABLE         )                                 // e_ITEM_AbandonedCar         
    ITEM_NORMAL( _gTextItemAlsatianDog           ,e_LOCATION_LARGE_STAIRCASE ,ITEM_FLAG_IMMOVABLE         )                                 // e_ITEM_AlsatianDog          
    ITEM_NORMAL( _gTextItemMeat                  ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Meat                 
    ITEM_NORMAL( _gTextItemBread                 ,e_LOCATION_DININGROOM      ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Bread                
    ITEM_NORMAL( _gTextItemRollOfTape            ,e_LOCATION_BOXROOM         ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_RollOfTape           
    ITEM_NORMAL( _gTextItemChemistryBook         ,e_LOCATION_LIBRARY         ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_ChemistryBook        
    ITEM_NORMAL( _gTextItemBoxOfMatches          ,e_LOCATION_LOUNGE          ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_BoxOfMatches         
    ITEM_NORMAL( _gTextItemSnookerCue            ,e_LOCATION_GAMESROOM       ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_SnookerCue           
    ITEM_NORMAL( _gTextItemThug                  ,e_LOCATION_MASTERBEDROOM   ,ITEM_FLAG_IMMOVABLE         )                                 // e_ITEM_Thug                 
    ITEM_NORMAL( _gTextItemHeavySafe             ,e_LOCATION_CELLAR          ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)                         // e_ITEM_HeavySafe            
    ITEM_NORMAL( _gTextItemHandWrittenNote       ,e_LOCATION_BOXROOM         ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_HandWrittenNote          
    ITEM_NORMAL( _gTextItemRope                  ,e_LOCATION_WELL            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Rope                 
    ITEM_NORMAL( _gTextItemHandheldGame          ,e_LOCATION_CHILDBEDROOM    ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_HandheldGame
    ITEM_NORMAL( _gTextItemRollOfToiletPaper     ,e_LOCATION_TINY_WC         ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_RollOfToiletPaper    
    ITEM_NORMAL( _gTextItemHosePipe              ,e_LOCATION_ZENGARDEN       ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_HosePipe             
    ITEM_NORMAL( _gTextItemBrokenGlass           ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_BrokenGlass          
    ITEM_NORMAL( _gTextItemAcidBurn              ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_AcidBurn             
    ITEM_NORMAL( _gTextItemYoungGirl             ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_YoungGirl        
    ITEM_NORMAL( _gTextItemFuse                  ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Fuse                 
    ITEM_NORMAL( _gTextItemKeys                  ,e_LOCATION_MAINSTREET      ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Keys                 
    ITEM_NORMAL( _gTextItemNewspaper             ,e_LOCATION_INVENTORY       ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Newspaper            
    ITEM_NORMAL( _gTextItemBomb                  ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Bomb                 
    ITEM_NORMAL( _gTextItemPistol                ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Pistol               
    ITEM_NORMAL( _gTextItemBullets               ,e_LOCATION_DARKCELLARROOM  ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_Bullets              
    ITEM_NORMAL( _gTextItemYoungGirlOnFloor      ,e_LOCATION_GIRLROOM        ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_YoungGirlOnFloor     
    ITEM_NORMAL( _gTextItemChemistryRecipes      ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_ChemistryRecipes     
    ITEM_NORMAL( _gTextItemUnitedKingdomMap      ,e_LOCATION_LIBRARY         ,ITEM_FLAG_IMMOVABLE         )                                 // e_ITEM_UnitedKingdomMap   
    ITEM_NORMAL( _gTextItemClosedCurtain         ,e_LOCATION_WESTGALLERY     ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)                         // e_ITEM_Curtain
    ITEM_NORMAL( _gTextItemMedicineCabinet       ,e_LOCATION_KITCHEN         ,ITEM_FLAG_IMMOVABLE|ITEM_FLAG_CLOSED)                         // e_ITEM_Medicinecabinet
    ITEM_NORMAL( _gTextItemSedativePills         ,e_LOCATION_NONE            ,ITEM_FLAG_DEFAULT           )                                 // e_ITEM_SedativePills     

