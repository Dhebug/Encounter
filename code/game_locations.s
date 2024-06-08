#include "game_enums.h"
 
 /*
    e_DIRECTION_NORTH = 0,
    e_DIRECTION_SOUTH = 1,
    e_DIRECTION_EAST  = 2,
    e_DIRECTION_WEST  = 3,
    e_DIRECTION_UP    = 4,   // Seldomly used (to go to the house upper floor and basement)
    e_DIRECTION_DOWN  = 5,   // Seldomly used (to go to the house upper floor and basement)
    e_DIRECTION_COUNT_
*/

#define LOCATION(n,s,e,w,u,d,description,script)      .byt n,s,e,w,u,d,<description,>description,<script,>script

; The content must match the "location" structure layout in game_defines.h
_gLocations
    //  North                          South                          East                           West                           Up                             Down                          Description
    LOCATION(e_LOCATION_DARKTUNNEL        , e_LOCATION_NONE              , e_LOCATION_DARKALLEY         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationMarketPlace              ,_gDescriptionMarketPlace)       // e_LOCATION_MARKETPLACE    
    LOCATION(e_LOCATION_MAINSTREET        , e_LOCATION_NONE              , e_LOCATION_ROAD              , e_LOCATION_MARKETPLACE       , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationDarkAlley                ,_gDescriptionDarkAlley)         // e_LOCATION_DARKALLEY      
    LOCATION(e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_DARKALLEY         , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationRoad                     ,_gDescriptionRoad)              // e_LOCATION_ROAD      

    LOCATION(e_LOCATION_WOODEDAVENUE      , e_LOCATION_MARKETPLACE       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationDarkTunel                ,_gDescriptionDarkTunel)         // e_LOCATION_DARKTUNNEL     
    LOCATION(e_LOCATION_GRAVELDRIVE       , e_LOCATION_DARKALLEY         , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationMainStreet               ,_gDescriptionMainStreet)        // e_LOCATION_MAINSTREET     
    LOCATION(e_LOCATION_TARMACAREA        , e_LOCATION_ROAD              , e_LOCATION_OUTSIDE_PIT       , e_LOCATION_MAINSTREET        , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationNarrowPath               ,_gDescriptionNarrowPath)        // e_LOCATION_NARROWPATH     

    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationInThePit                 ,_gDescriptionInThePit)          // e_LOCATION_INSIDE_PIT
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationOldWell                  ,_gDescriptionOldWell)           // e_LOCATION_WELL           
    LOCATION(e_LOCATION_ZENGARDEN         , e_LOCATION_DARKTUNNEL        , e_LOCATION_GRAVELDRIVE       , e_LOCATION_WELL              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationWoodedAvenue             ,_gDescriptionWoodedAvenue)      // e_LOCATION_WOODEDAVENUE   

    LOCATION(e_LOCATION_LAWN              , e_LOCATION_MAINSTREET        , e_LOCATION_TARMACAREA        , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationGravelDrive              ,_gDescriptionGravelDrive)       // e_LOCATION_GRAVELDRIVE   
    LOCATION(e_LOCATION_GREENHOUSE        , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_GRAVELDRIVE       , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationTarmacArea               ,_gDescriptionTarmacArea)        // e_LOCATION_TARMACAREA      
    LOCATION(e_LOCATION_TENNISCOURT       , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationZenGarden                ,_gDescriptionZenGarden)         // e_LOCATION_ZENGARDEN       

    LOCATION(e_LOCATION_ENTRANCEHALL      , e_LOCATION_GRAVELDRIVE       , e_LOCATION_GREENHOUSE        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationFrontLawn                ,_gDescriptionFrontLawn)         // e_LOCATION_LAWN  
    LOCATION(e_LOCATION_VEGSGARDEN        , e_LOCATION_TARMACAREA        , e_LOCATION_NONE              , e_LOCATION_LAWN              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationGreenHouse               ,_gDescriptionGreenHouse)        // e_LOCATION_GREENHOUSE      
    LOCATION(e_LOCATION_FISHPND           , e_LOCATION_ZENGARDEN         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationTennisCourt              ,_gDescriptionTennisCourt)       // e_LOCATION_TENNISCOURT     

    LOCATION(e_LOCATION_APPLE_TREES       , e_LOCATION_GREENHOUSE        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationVegetableGarden          ,_gDescriptionVegetableGarden)   // e_LOCATION_VEGSGARDEN   
    LOCATION(e_LOCATION_NONE              , e_LOCATION_TENNISCOURT       , e_LOCATION_TILEDPATIO        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationFishPond                 ,_gDescriptionFishPond)          // e_LOCATION_FISHPND         
    LOCATION(e_LOCATION_SUNLOUNGE         , e_LOCATION_SUNLOUNGE         , e_LOCATION_APPLE_TREES       , e_LOCATION_FISHPND           , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationTiledPatio               ,_gDescriptionTiledPatio)        // e_LOCATION_TILEDPATIO - and above it is a barred window 

    LOCATION(e_LOCATION_NONE              , e_LOCATION_VEGSGARDEN        , e_LOCATION_NONE              , e_LOCATION_TILEDPATIO        , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationAppleOrchard             ,_gDescriptionAppleOrchard)      // e_LOCATION_APPLE_TREES     
    LOCATION(e_LOCATION_CELLAR            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationDarkerCellar             ,_gDescriptionDarkerCellar)      // e_LOCATION_DARKCELLARROOM   
    LOCATION(e_LOCATION_NONE              , e_LOCATION_DARKCELLARROOM    , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NARROWSTAIRCASE   , e_LOCATION_NONE              , _gTextLocationCellar                   ,_gDescriptionCellar)            // e_LOCATION_CELLAR           

    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_KITCHEN           , e_LOCATION_CELLAR            , _gTextLocationNarrowStaircase          ,_gDescriptionNarrowStaircase)   // e_LOCATION_NARROWSTAIRCASE  
    LOCATION(e_LOCATION_DININGROOM        , e_LOCATION_NONE              , e_LOCATION_ENTRANCEHALL      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationEntranceLounge           ,_gDescriptionEntranceLounge)    // e_LOCATION_LOUNGE     
    LOCATION(e_LOCATION_NARROWPASSAGE     , e_LOCATION_LAWN              , e_LOCATION_NONE              , e_LOCATION_LOUNGE            , e_LOCATION_LARGE_STAIRCASE   , e_LOCATION_NONE              , _gTextLocationEntranceHall             ,_gDescriptionEntranceHall)      // e_LOCATION_ENTRANCEHALL    

    LOCATION(e_LOCATION_NONE              , e_LOCATION_STUDY_ROOM        , e_LOCATION_NONE              , e_LOCATION_NARROWPASSAGE     , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationLibrary                  ,_gDescriptionLibrary)           // e_LOCATION_LIBRARY         
    LOCATION(e_LOCATION_GAMESROOM         , e_LOCATION_LOUNGE            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationDiningRoom               ,_gDescriptionDiningRoom)        // e_LOCATION_DININGROOM      
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_UP_STAIRS         , e_LOCATION_ENTRANCEHALL      , _gTextLocationStaircase                ,_gDescriptionStaircase)         // e_LOCATION_LARGE_STAIRCASE 

    LOCATION(e_LOCATION_NONE              , e_LOCATION_DININGROOM        , e_LOCATION_SUNLOUNGE         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationGamesRoom                ,_gDescriptionGamesRoom)         // e_LOCATION_GAMESROOM        
    LOCATION(e_LOCATION_TILEDPATIO        , e_LOCATION_NARROWPASSAGE     , e_LOCATION_KITCHEN           , e_LOCATION_GAMESROOM         , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationSunLounge                ,_gDescriptionSunLounge)         // e_LOCATION_SUNLOUNGE        
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_SUNLOUNGE         , e_LOCATION_NONE              , e_LOCATION_NARROWSTAIRCASE   , _gTextLocationKitchen                  ,_gDescriptionKitchen)           // e_LOCATION_KITCHEN    

    LOCATION(e_LOCATION_SUNLOUNGE         , e_LOCATION_ENTRANCEHALL      , e_LOCATION_LIBRARY           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationNarrowPassage            ,_gDescriptionNarrowPassage)     // e_LOCATION_NARROWPASSAGE   
    LOCATION(e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_SHOWERROOM        , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationGuestBedroom             ,_gDescriptionGuestBedroom)      // e_LOCATION_GUESTBEDROOM     
    LOCATION(e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationChildBedroom             ,_gDescriptionChildBedroom)      // e_LOCATION_CHILDBEDROOM     

    LOCATION(e_LOCATION_TINY_WC           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationMasterBedRoom            ,_gDescriptionMasterBedRoom)     // e_LOCATION_MASTERBEDROOM    
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_GUESTBEDROOM      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationShowerRoom               ,_gDescriptionShowerRoom)        // e_LOCATION_SHOWERROOM       
    LOCATION(e_LOCATION_NONE              , e_LOCATION_MASTERBEDROOM     , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationTinyToilet               ,_gDescriptionTinyToilet)        // e_LOCATION_TINY_WC          

    LOCATION(e_LOCATION_CLASSY_BATHROOM   , e_LOCATION_CHILDBEDROOM      , e_LOCATION_MASTERBEDROOM     , e_LOCATION_UP_STAIRS         , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationEastGallery              ,_gDescriptionEastGallery)       // e_LOCATION_EASTGALLERY      
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationBoxRoom                  ,_gDescriptionBoxRoom)           // e_LOCATION_BOXROOM          
    LOCATION(e_LOCATION_NONE              , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationPadlockedRoom            ,_gDescriptionPadlockedRoom)     // e_LOCATION_PADLOCKED_ROOM   

    LOCATION(e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationClassyBathRoom           ,_gDescriptionClassyBathRoom)    // e_LOCATION_CLASSY_BATHROOM  
    LOCATION(e_LOCATION_NONE              , e_LOCATION_GUESTBEDROOM      , e_LOCATION_UP_STAIRS         , e_LOCATION_BOXROOM           , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationWestGallery              ,_gDescriptionWestGallery)       // e_LOCATION_WESTGALLERY      
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_LARGE_STAIRCASE   , _gTextLocationMainLanding              ,_gDescriptionMainLanding)       // e_LOCATION_UP_STAIRS        

    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_INSIDE_PIT        , _gTextLocationOutsidePit               ,_gDescriptionOutsidePit)        // e_LOCATION_OUTSIDE_PIT

    LOCATION(e_LOCATION_LIBRARY           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationStudyRoom                ,_gDescriptionStudyRoom)         // e_LOCATION_STUDY_ROOM

    LOCATION(e_LOCATION_CELLAR            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationDarkerCellar             ,_gDescriptionDarkerCellar)      // e_LOCATION_BRIGHTCELLARROOM   

    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gTextLocationGirlRoomOpenned          ,0)                              // e_LOCATION_GIRLROOM (technically this room cannot be accessed, so do not need description)        

