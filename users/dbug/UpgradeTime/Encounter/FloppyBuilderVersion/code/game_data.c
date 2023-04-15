
#include "game_defines.h"
#include "common.h"


unsigned char gCurrentLocation = e_LOCATION_MARKETPLACE;
 
 /*
    e_DIRECTION_NORTH = 0,
    e_DIRECTION_SOUTH = 1,
    e_DIRECTION_EAST  = 2,
    e_DIRECTION_WEST  = 3,
    e_DIRECTION_UP    = 4,   // Seldomly used (to go to the house upper floor and basement)
    e_DIRECTION_DOWN  = 5,   // Seldomly used (to go to the house upper floor and basement)
    e_DIRECTION_COUNT_
*/
location gLocations[e_LOCATION_COUNT_] =
{ //  North                          South                          East                           West                           Up                             Down                          Description
    { e_LOCATION_DARKTUNNEL        , e_LOCATION_NONE              , e_LOCATION_DARKALLEY         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a deserted market square"     ,gDescriptionMarketPlace},       // e_LOCATION_MARKETPLACE    
    { e_LOCATION_MAINSTREET        , e_LOCATION_NONE              , e_LOCATION_ROAD              , e_LOCATION_MARKETPLACE       , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a dark, seedy alley"          ,gDescriptionDarkAlley},         // e_LOCATION_DARKALLEY      
    { e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_DARKALLEY         , e_LOCATION_NONE              , e_LOCATION_NONE              , "A long road stretches ahead of you"      ,gDescriptionRoad},              // e_LOCATION_ROAD      

    { e_LOCATION_WOODEDAVENUE      , e_LOCATION_MARKETPLACE       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a dark, damp tunnel"          ,gDescriptionDarkTunel},         // e_LOCATION_DARKTUNNEL     
    { e_LOCATION_GRAVELDRIVE       , e_LOCATION_DARKALLEY         , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on the main street"              ,gDescriptionMainStreet},        // e_LOCATION_MAINSTREET     
    { e_LOCATION_TARMACAREA        , e_LOCATION_ROAD              , e_LOCATION_OUTSIDE_PIT       , e_LOCATION_MAINSTREET        , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a narrow path"                ,gDescriptionNarrowPath},        // e_LOCATION_NARROWPATH     

    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You have fallen into a deep pit"         ,gDescriptionInThePit},          // e_LOCATION_INSIDEHOLE
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are near to an old-fashioned well"   ,gDescriptionOldWell},           // e_LOCATION_WELL           
    { e_LOCATION_ZENGARDEN         , e_LOCATION_DARKTUNNEL        , e_LOCATION_GRAVELDRIVE       , e_LOCATION_WELL              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a wooded avenue"              ,gDescriptionWoodedAvenue},      // e_LOCATION_WOODEDAVENUE   

    { e_LOCATION_LAWN              , e_LOCATION_MAINSTREET        , e_LOCATION_TARMACAREA        , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a wide gravel drive"          ,gDescriptionGravelDrive},       // e_LOCATION_GRAVELDRIVE   
    { e_LOCATION_GREENHOUSE        , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_GRAVELDRIVE       , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in an open area of tarmac"       ,gDescriptionTarmacArea},        // e_LOCATION_TARMACAREA      
    { e_LOCATION_TENNISCOURT       , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a relaxing zen garden"        ,gDescriptionZenGarden},         // e_LOCATION_ZENGARDEN       

    { e_LOCATION_ENTRANCEHALL      , e_LOCATION_GRAVELDRIVE       , e_LOCATION_GREENHOUSE        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a huge area of lawn"          ,gDescriptionFrontLawn},         // e_LOCATION_LAWN  
    { e_LOCATION_VEGSGARDEN        , e_LOCATION_TARMACAREA        , e_LOCATION_NONE              , e_LOCATION_LAWN              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a small greenhouse"           ,gDescriptionGreenHouse},        // e_LOCATION_GREENHOUSE      
    { e_LOCATION_FISHPND           , e_LOCATION_ZENGARDEN         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a lawn tennis court"          ,gDescriptionTennisCourt},       // e_LOCATION_TENNISCOURT     

    { e_LOCATION_APPLE_TREES       , e_LOCATION_GREENHOUSE        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a vegetable plot"             ,gDescriptionVegetableGarden},   // e_LOCATION_VEGSGARDEN   
    { e_LOCATION_NONE              , e_LOCATION_TENNISCOURT       , e_LOCATION_TILEDPATIO        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are standing by a fish pond"         ,gDescriptionFishPond},          // e_LOCATION_FISHPND         
    { e_LOCATION_SUNLOUNGE         , e_LOCATION_SUNLOUNGE         , e_LOCATION_APPLE_TREES       , e_LOCATION_FISHPND           , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a tiled patio"                ,gDescriptionTiledPatio},        // e_LOCATION_TILEDPATIO - and above it is a barred window 

    { e_LOCATION_NONE              , e_LOCATION_VEGSGARDEN        , e_LOCATION_NONE              , e_LOCATION_TILEDPATIO        , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in an apple orchard"             ,gDescriptionAppleOrchard},      // e_LOCATION_APPLE_TREES     
    { e_LOCATION_CELLAR            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This room is even darker than the last"  ,gDescriptionDarkerCellar},      // e_LOCATION_DARKCELLARROOM   
    { e_LOCATION_NONE              , e_LOCATION_DARKCELLARROOM    , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NARROWSTAIRCASE   , e_LOCATION_NONE              , "This is a cold, damp cellar"             ,gDescriptionCellar},            // e_LOCATION_CELLAR           

    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_KITCHEN           , e_LOCATION_CELLAR            , "You are on some gloomy, narrow steps"    ,gDescriptionNarrowStaircase},   // e_LOCATION_NARROWSTAIRCASE  
    { e_LOCATION_DININGROOM        , e_LOCATION_NONE              , e_LOCATION_ENTRANCEHALL      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in the lounge"                   ,gDescriptionEntranceLounge},    // e_LOCATION_LOUNGE     
    { e_LOCATION_NARROWPASSAGE     , e_LOCATION_LAWN              , e_LOCATION_NONE              , e_LOCATION_LOUNGE            , e_LOCATION_LARGE_STAIRCASE   , e_LOCATION_NONE              , "You are in an imposing entrance hall"    ,gDescriptionEntranceHall},      // e_LOCATION_ENTRANCEHALL    

    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NARROWPASSAGE     , e_LOCATION_NONE              , e_LOCATION_NONE              , "This looks like a library"               ,gDescriptionLibrary},           // e_LOCATION_LIBRARY         
    { e_LOCATION_GAMESROOM         , e_LOCATION_LOUNGE            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "A dining room, or so it appears"         ,gDescriptionDiningRoom},        // e_LOCATION_DININGROOM      
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_UP_STAIRS         , e_LOCATION_ENTRANCEHALL      , "You are on a sweeping staircase"         ,gDescriptionStaircase},         // e_LOCATION_LARGE_STAIRCASE 

    { e_LOCATION_NONE              , e_LOCATION_DININGROOM        , e_LOCATION_SUNLOUNGE         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This looks like a games room"            ,gDescriptionGamesRoom},         // e_LOCATION_GAMESROOM        
    { e_LOCATION_TILEDPATIO        , e_LOCATION_NARROWPASSAGE     , e_LOCATION_KITCHEN           , e_LOCATION_GAMESROOM         , e_LOCATION_NONE              , e_LOCATION_NONE              , "You find yourself in a sun-lounge"       ,gDescriptionSunLounge},         // e_LOCATION_SUNLOUNGE        
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_SUNLOUNGE         , e_LOCATION_NONE              , e_LOCATION_NARROWSTAIRCASE   , "This is obviously the kitchen"           ,gDescriptionKitchen},           // e_LOCATION_KITCHEN    

    { e_LOCATION_SUNLOUNGE         , e_LOCATION_ENTRANCEHALL      , e_LOCATION_LIBRARY           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a narrow passage"             ,gDescriptionNarrowPassage},     // e_LOCATION_NARROWPASSAGE   
    { e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_SHOWERROOM        , e_LOCATION_NONE              , e_LOCATION_NONE              , "This seems to be a guest bedroom"        ,gDescriptionGuestBedroom},      // e_LOCATION_GUESTBEDROOM     
    { e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This is a child's bedroom"               ,gDescriptionChildBedroom},      // e_LOCATION_CHILDBEDROOM     

    { e_LOCATION_TINY_WC           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , "This must be the master bedroom"         ,gDescriptionMasterBedRoom},     // e_LOCATION_MASTERBEDROOM    
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_GUESTBEDROOM      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a tiled shower-room"          ,gDescriptionShowerRoom},        // e_LOCATION_SHOWERROOM       
    { e_LOCATION_NONE              , e_LOCATION_MASTERBEDROOM     , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This is a tiny toilet"                   ,gDescriptionTinyToilet},        // e_LOCATION_TINY_WC          

    { e_LOCATION_CLASSY_BATHROOM   , e_LOCATION_CHILDBEDROOM      , e_LOCATION_MASTERBEDROOM     , e_LOCATION_UP_STAIRS         , e_LOCATION_NONE              , e_LOCATION_NONE              , "You have found the east gallery"         ,gDescriptionEastGallery},       // e_LOCATION_EASTGALLERY      
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This is a small box-room"                ,gDescriptionBoxRoom},           // e_LOCATION_BOXROOM          
    { e_LOCATION_NONE              , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You see a padlocked steel-plated door"   ,gDescriptionPadlockedRoom},     // e_LOCATION_PADLOCKED_ROOM   

    { e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in an ornate bathroom"           ,gDescriptionClassyBathRoom},    // e_LOCATION_CLASSY_BATHROOM  
    { e_LOCATION_PADLOCKED_ROOM    , e_LOCATION_GUESTBEDROOM      , e_LOCATION_UP_STAIRS         , e_LOCATION_BOXROOM           , e_LOCATION_NONE              , e_LOCATION_NONE              , "This is the west gallery"                ,gDescriptionWestGallery},       // e_LOCATION_WESTGALLERY      
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_LARGE_STAIRCASE   , "You are on the main landing"             ,gDescriptionMainLanding},       // e_LOCATION_UP_STAIRS        

    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_INSIDEHOLE        , "Outside a deep pit"                      ,gDescriptionOutsidePit},        // e_LOCATION_OUTSIDE_PIT

    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "The girl room (openned lock)"            ,0},                             // e_LOCATION_GIRLROOM (technically this room cannot be accessed, so do not need description)        
};


//
// These macros can be used to generate the list of containers that can be 
// used with a specific item: You can't get powder in a net, neither can you
// store water in a cardboard box (or at least not for very long)
//
#define CONTAINER_MASK1(a)          (1<<(a))
#define CONTAINER_MASK2(a,b)        (CONTAINER_MASK1(a)+(1<<(b)))
#define CONTAINER_MASK3(a,b,c)      (CONTAINER_MASK2(a,b)+(1<<(c)))
#define CONTAINER_MASK4(a,b,c,d)    (CONTAINER_MASK3(a,b,c)+(1<<(d)))


// The flags and usable containers are copied from the BASIC version.
// The final version will contain actual bit-masks
item gItems[e_ITEM_COUNT_] =
{   //           Item                              World               Associated    Generic               Containers usable
    //           description                       location            item          flags                 with this specific item
    // Containers
    { "an empty tobacco tin"                 ,e_LOCATION_LOUNGE          ,255   ,ITEM_FLAG_IS_CONTAINER    ,0},                                            // e_ITEM_TobaccoTin           
    { "a wooden bucket"                      ,e_LOCATION_WELL            ,255   ,ITEM_FLAG_IS_CONTAINER    ,0},                                            // e_ITEM_Bucket               
    { "a cardboard box"                      ,e_LOCATION_GREENHOUSE      ,255   ,ITEM_FLAG_IS_CONTAINER    ,0},                                            // e_ITEM_CardboardBox         
    { "a fishing net"                        ,e_LOCATION_FISHPND         ,255   ,ITEM_FLAG_IS_CONTAINER    ,0},                                            // e_ITEM_FishingNet           
    { "a plastic bag"                        ,e_LOCATION_MARKETPLACE     ,255   ,ITEM_FLAG_IS_CONTAINER    ,0},                                            // e_ITEM_PlasticBag           
    { "a small bottle"                       ,99                         ,255   ,ITEM_FLAG_IS_CONTAINER    ,0},                                            // e_ITEM_SmallBottle          

    // Items requiring containers
    { "black dust"                           ,e_LOCATION_DARKTUNNEL      ,255   ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox)},                            // e_ITEM_BlackDust            
    { "gritty yellow powder"                 ,e_LOCATION_INSIDEHOLE      ,255   ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox)},                            // e_ITEM_YellowPowder         
    { "some petrol"                          ,99                         ,255   ,ITEM_FLAG_EVAPORATES      ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin)},                                // e_ITEM_Petrol               
    { "some water"                           ,e_LOCATION_WELL            ,255   ,ITEM_FLAG_EVAPORATES      ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin)},                                // e_ITEM_Water                

    // Normal items
    { "a locked panel on the wall"           ,e_LOCATION_DARKCELLARROOM  ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_LockedPanel          
    { "an open panel on wall"                ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_OpenPanel            
    { "a small hole in the door"             ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_SmallHoleInDoor      
    { "the window is broken"                 ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_BrokenWindow         
    { "a large dove"                         ,e_LOCATION_WOODEDAVENUE    ,255   ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK3(e_ITEM_Bucket,e_ITEM_CardboardBox,e_ITEM_FishingNet)},                                // e_ITEM_LargeDove            
    { "some twine"                           ,e_LOCATION_GREENHOUSE      ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Twine                
    { "a silver knife"                       ,e_LOCATION_VEGSGARDEN      ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_SilverKnife          
    { "a ladder"                             ,e_LOCATION_APPLE_TREES     ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Ladder               
    { "an abandoned car"                     ,e_LOCATION_TARMACAREA      ,255   ,ITEM_FLAG_HEAVY           ,0},                                            // e_ITEM_AbandonedCar         
    { "an alsatian growling at you"          ,e_LOCATION_ENTRANCEHALL    ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_AlsatianDog          
    { "a joint of meat"                      ,e_LOCATION_DININGROOM      ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Meat                 
    { "some brown bread"                     ,e_LOCATION_DININGROOM      ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Bread                
    { "a roll of sticky tape"                ,e_LOCATION_LIBRARY         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_RollOfTape           
    { "a chemistry book"                     ,e_LOCATION_LIBRARY         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_ChemistryBook        
    { "a box of matches"                     ,e_LOCATION_KITCHEN         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_BoxOfMatches         
    { "a snooker cue"                        ,e_LOCATION_GAMESROOM       ,255   ,ITEM_FLAG_DEFAULT         ,ITEM_FLAG_DEFAULT },                           // e_ITEM_SnookerCue           
    { "a thug asleep on the bed"             ,e_LOCATION_MASTERBEDROOM   ,255   ,ITEM_FLAG_HEAVY           ,0},                                            // e_ITEM_Thug                 
    { "a heavy safe"                         ,e_LOCATION_CELLAR          ,255   ,ITEM_FLAG_HEAVY           ,0},                                            // e_ITEM_HeavySafe            
    { "a printed note"                       ,e_LOCATION_BOXROOM         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_PrintedNote          
    { "a length of rope"                     ,e_LOCATION_WELL            ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Rope                 
    { "a rope hangs from the window"         ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_RopeHangingFromWindow
    { "a roll of toilet tissue"              ,e_LOCATION_TINY_WC         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_RollOfToiletPaper    
    { "a hose-pipe"                          ,e_LOCATION_ZENGARDEN       ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_HosePipe             
    { "an open safe"                         ,99                         ,255   ,ITEM_FLAG_HEAVY           ,0},                                            // e_ITEM_OpenSafe             
    { "broken glass"                         ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_BrokenGlass          
    { "an acid burn"                         ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_AcidBurn             
    { "a young girl"                         ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_YoungGirl        
    { "a fuse"                               ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Fuse                 
    { "some gunpowder"                       ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,CONTAINER_MASK4(e_ITEM_Bucket,e_ITEM_PlasticBag,e_ITEM_TobaccoTin,e_ITEM_CardboardBox)},                            // e_ITEM_GunPowder            
    { "a set of keys"                        ,e_LOCATION_MAINSTREET      ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Keys                 
    { "a newspaper"                          ,e_LOCATION_MARKETPLACE     ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Newspaper            
    { "a bomb"                               ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Bomb                 
    { "a pistol"                             ,99                         ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Pistol               
    { "three .38 bullets"                    ,e_LOCATION_DARKCELLARROOM  ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_Bullets              
    { "a young girl tied up on the floor"    ,e_LOCATION_GIRLROOM        ,255   ,ITEM_FLAG_DEFAULT         ,0},                                            // e_ITEM_YoungGirlOnFloor     
};


keyword gWordsArray[] =
{
    // Containers
    { "TIN",    e_ITEM_TobaccoTin           },  // e_ITEM_TobaccoTin            
    { "BUCKET", e_ITEM_Bucket               },  // e_ITEM_Bucket                
    { "BOX",    e_ITEM_CardboardBox         },  // e_ITEM_CardboardBox          
    { "NET",    e_ITEM_FishingNet           },  // e_ITEM_FishingNet            
    { "BAG",    e_ITEM_PlasticBag           },  // e_ITEM_PlasticBag            
    // Then normal items
    { "GIRL",   e_ITEM_YoungGirl            },  // e_ITEM_YoungGirl         
    //{ "GIRL",e_ITEM_YoungGirlOnFloor     },  // e_ITEM_YoungGirlOnFloor - Girl, girl on the floor, etc... should be the same item, but with flags
    { "WINDOW", e_ITEM_BrokenWindow         },  // e_ITEM_BrokenWindow          
    //{ "SAFE",   e_ITEM_OpenSafe             },  // e_ITEM_OpenSafe  - Open and locked safe should be the same item, but with flags            
    { "DUST",   e_ITEM_BlackDust            },  // e_ITEM_BlackDust             
    { "PANEL",  e_ITEM_OpenPanel            },  // e_ITEM_OpenPanel             
    //{ "PANEL",e_ITEM_LockedPanel          },  // e_ITEM_LockedPanel  - Open and Locked panels should be the same item, but with flags
    { "POWDER", e_ITEM_YellowPowder         },  // e_ITEM_YellowPowder          
    //{ "...",e_ITEM_SmallHoleInDoor      },  // e_ITEM_SmallHoleInDoor       
    { "WATER",  e_ITEM_Water                },  // e_ITEM_Water                 
    { "DOVE",   e_ITEM_LargeDove            },  // e_ITEM_LargeDove             
    { "TWINE",  e_ITEM_Twine                },  // e_ITEM_Twine                 
    { "KNIFE",  e_ITEM_SilverKnife          },  // e_ITEM_SilverKnife       
    { "LADDER", e_ITEM_Ladder               },  // e_ITEM_Ladder                
    { "CAR",    e_ITEM_AbandonedCar         },  // e_ITEM_AbandonedCar          
    { "DOG",    e_ITEM_AlsatianDog          },  // e_ITEM_AlsatianDog       
    { "MEAT",   e_ITEM_Meat                 },  // e_ITEM_Meat                  
    { "BREAD",  e_ITEM_Bread                },  // e_ITEM_Bread                 
    { "TAPE",   e_ITEM_RollOfTape           },  // e_ITEM_RollOfTape            
    { "BOOK",   e_ITEM_ChemistryBook        },  // e_ITEM_ChemistryBook         
    { "MATCHES",e_ITEM_BoxOfMatches         },  // e_ITEM_BoxOfMatches          
    { "CUE",    e_ITEM_SnookerCue           },  // e_ITEM_SnookerCue            
    { "THUG",   e_ITEM_Thug                 },  // e_ITEM_Thug                  
    { "SAFE",   e_ITEM_HeavySafe            },  // e_ITEM_HeavySafe             
    { "NOTE",   e_ITEM_PrintedNote          },  // e_ITEM_PrintedNote       
    { "ROPE",   e_ITEM_Rope                 },  // e_ITEM_Rope                  
    //{ "...",e_ITEM_RopeHangingFromWindow},  // e_ITEM_RopeHangingFromWindow
    { "TISSUE", e_ITEM_RollOfToiletPaper    },  // e_ITEM_RollOfToiletPaper     
    { "HOSE",   e_ITEM_HosePipe             },  // e_ITEM_HosePipe              
    { "PETROL", e_ITEM_Petrol               },  // e_ITEM_Petrol                
    { "GLASS",  e_ITEM_BrokenGlass          },  // e_ITEM_BrokenGlass       
    //{ "...",e_ITEM_AcidBurn             },  // e_ITEM_AcidBurn              
    { "BOTTLE", e_ITEM_SmallBottle          },  // e_ITEM_SmallBottle       
    { "FUSE",   e_ITEM_Fuse                 },  // e_ITEM_Fuse                  
    { "GUN",    e_ITEM_GunPowder            },  // e_ITEM_GunPowder             
    { "KEYS",   e_ITEM_Keys                 },  // e_ITEM_Keys                  
    { "NEWSPAPER",e_ITEM_Newspaper            },  // e_ITEM_Newspaper             
    { "BOMB",   e_ITEM_Bomb                 },  // e_ITEM_Bomb                  
    { "PISTOL", e_ITEM_Pistol               },  // e_ITEM_Pistol                
    { "BULLETS",e_ITEM_Bullets              },  // e_ITEM_Bullets           

    // Directions
    { "N", e_WORD_NORTH },
    { "S", e_WORD_SOUTH },
    { "E", e_WORD_EAST  },
    { "W", e_WORD_WEST  },
    { "U", e_WORD_UP    },
    { "D", e_WORD_DOWN  },

    { "NORTH", e_WORD_NORTH },
    { "SOUT", e_WORD_SOUTH },
    { "EAST", e_WORD_EAST  },
    { "WEST", e_WORD_WEST  },
    { "UP", e_WORD_UP    },
    { "DOWN", e_WORD_DOWN  },

    // Misc instructions
    { "TAKE", e_WORD_TAKE },
    { "GET" , e_WORD_TAKE },

    { "DROP", e_WORD_DROP },
    { "PUT" , e_WORD_DROP },

    // Last instruction
    { "QUIT", e_WORD_QUIT },

    // Sentinelle
    { 0,  e_WORD_COUNT_ }
};
