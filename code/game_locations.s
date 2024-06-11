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

#define LOCATION(n,s,e,w,u,d,script)      .byt n,s,e,w,u,d,<script,>script

; The content must match the "location" structure layout in game_defines.h
_gLocations
    //       North                          South                          East                           West                           Up                             Down                          Script
    LOCATION(e_LOCATION_DARKTUNNEL        , e_LOCATION_NONE              , e_LOCATION_DARKALLEY         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionMarketPlace)       // e_LOCATION_MARKETPLACE    
    LOCATION(e_LOCATION_MAINSTREET        , e_LOCATION_NONE              , e_LOCATION_ROAD              , e_LOCATION_MARKETPLACE       , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionDarkAlley)         // e_LOCATION_DARKALLEY      
    LOCATION(e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_DARKALLEY         , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionRoad)              // e_LOCATION_ROAD      

    LOCATION(e_LOCATION_WOODEDAVENUE      , e_LOCATION_MARKETPLACE       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionDarkTunel)         // e_LOCATION_DARKTUNNEL     
    LOCATION(e_LOCATION_GRAVELDRIVE       , e_LOCATION_DARKALLEY         , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionMainStreet)        // e_LOCATION_MAINSTREET     
    LOCATION(e_LOCATION_TARMACAREA        , e_LOCATION_ROAD              , e_LOCATION_OUTSIDE_PIT       , e_LOCATION_MAINSTREET        , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionNarrowPath)        // e_LOCATION_NARROWPATH     

    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionInThePit)          // e_LOCATION_INSIDE_PIT
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionOldWell)           // e_LOCATION_WELL           
    LOCATION(e_LOCATION_ZENGARDEN         , e_LOCATION_DARKTUNNEL        , e_LOCATION_GRAVELDRIVE       , e_LOCATION_WELL              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionWoodedAvenue)      // e_LOCATION_WOODEDAVENUE   

    LOCATION(e_LOCATION_LAWN              , e_LOCATION_MAINSTREET        , e_LOCATION_TARMACAREA        , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionGravelDrive)       // e_LOCATION_GRAVELDRIVE   
    LOCATION(e_LOCATION_GREENHOUSE        , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_GRAVELDRIVE       , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionTarmacArea)        // e_LOCATION_TARMACAREA      
    LOCATION(e_LOCATION_TENNISCOURT       , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionZenGarden)         // e_LOCATION_ZENGARDEN       

    LOCATION(e_LOCATION_ENTRANCEHALL      , e_LOCATION_GRAVELDRIVE       , e_LOCATION_GREENHOUSE        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionFrontLawn)         // e_LOCATION_LAWN  
    LOCATION(e_LOCATION_VEGSGARDEN        , e_LOCATION_TARMACAREA        , e_LOCATION_NONE              , e_LOCATION_LAWN              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionGreenHouse)        // e_LOCATION_GREENHOUSE      
    LOCATION(e_LOCATION_FISHPND           , e_LOCATION_ZENGARDEN         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionTennisCourt)       // e_LOCATION_TENNISCOURT     

    LOCATION(e_LOCATION_APPLE_TREES       , e_LOCATION_GREENHOUSE        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionVegetableGarden)   // e_LOCATION_VEGSGARDEN   
    LOCATION(e_LOCATION_NONE              , e_LOCATION_TENNISCOURT       , e_LOCATION_TILEDPATIO        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionFishPond)          // e_LOCATION_FISHPND         
    LOCATION(e_LOCATION_NONE              , e_LOCATION_SUNLOUNGE         , e_LOCATION_APPLE_TREES       , e_LOCATION_FISHPND           , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionTiledPatio)        // e_LOCATION_TILEDPATIO - and above it is a barred window 

    LOCATION(e_LOCATION_NONE              , e_LOCATION_VEGSGARDEN        , e_LOCATION_NONE              , e_LOCATION_TILEDPATIO        , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionAppleOrchard)      // e_LOCATION_APPLE_TREES     
    LOCATION(e_LOCATION_CELLAR            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              ,_gDescriptionDarkerCellar)       // e_LOCATION_DARKCELLARROOM   
    LOCATION(e_LOCATION_NONE              , e_LOCATION_DARKCELLARROOM    , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NARROWSTAIRCASE   , e_LOCATION_NONE              , _gDescriptionCellar)            // e_LOCATION_CELLAR           

    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_KITCHEN           , e_LOCATION_CELLAR            , _gDescriptionNarrowStaircase)   // e_LOCATION_NARROWSTAIRCASE  
    LOCATION(e_LOCATION_DININGROOM        , e_LOCATION_NONE              , e_LOCATION_ENTRANCEHALL      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionEntranceLounge)    // e_LOCATION_LOUNGE     
    LOCATION(e_LOCATION_NARROWPASSAGE     , e_LOCATION_LAWN              , e_LOCATION_NONE              , e_LOCATION_LOUNGE            , e_LOCATION_LARGE_STAIRCASE   , e_LOCATION_NONE              , _gDescriptionEntranceHall)      // e_LOCATION_ENTRANCEHALL    

    LOCATION(e_LOCATION_NONE              , e_LOCATION_STUDY_ROOM        , e_LOCATION_NONE              , e_LOCATION_NARROWPASSAGE     , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionLibrary)           // e_LOCATION_LIBRARY         
    LOCATION(e_LOCATION_GAMESROOM         , e_LOCATION_LOUNGE            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionDiningRoom)        // e_LOCATION_DININGROOM      
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_UP_STAIRS         , e_LOCATION_ENTRANCEHALL      , _gDescriptionStaircase)         // e_LOCATION_LARGE_STAIRCASE 

    LOCATION(e_LOCATION_NONE              , e_LOCATION_DININGROOM        , e_LOCATION_SUNLOUNGE         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionGamesRoom)         // e_LOCATION_GAMESROOM        
    LOCATION(e_LOCATION_TILEDPATIO        , e_LOCATION_NARROWPASSAGE     , e_LOCATION_KITCHEN           , e_LOCATION_GAMESROOM         , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionSunLounge)         // e_LOCATION_SUNLOUNGE        
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_SUNLOUNGE         , e_LOCATION_NONE              , e_LOCATION_NARROWSTAIRCASE   , _gDescriptionKitchen)           // e_LOCATION_KITCHEN    

    LOCATION(e_LOCATION_SUNLOUNGE         , e_LOCATION_ENTRANCEHALL      , e_LOCATION_LIBRARY           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionNarrowPassage)     // e_LOCATION_NARROWPASSAGE   
    LOCATION(e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_SHOWERROOM        , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionGuestBedroom)      // e_LOCATION_GUESTBEDROOM     
    LOCATION(e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionChildBedroom)      // e_LOCATION_CHILDBEDROOM     

    LOCATION(e_LOCATION_TINY_WC           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionMasterBedRoom)     // e_LOCATION_MASTERBEDROOM    
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_GUESTBEDROOM      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionShowerRoom)        // e_LOCATION_SHOWERROOM       
    LOCATION(e_LOCATION_NONE              , e_LOCATION_MASTERBEDROOM     , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionTinyToilet)        // e_LOCATION_TINY_WC          

    LOCATION(e_LOCATION_CLASSY_BATHROOM   , e_LOCATION_CHILDBEDROOM      , e_LOCATION_MASTERBEDROOM     , e_LOCATION_UP_STAIRS         , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionEastGallery)       // e_LOCATION_EASTGALLERY      
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionBoxRoom)           // e_LOCATION_BOXROOM          
    LOCATION(e_LOCATION_NONE              , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionPadlockedRoom)     // e_LOCATION_PADLOCKED_ROOM   

    LOCATION(e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionClassyBathRoom)    // e_LOCATION_CLASSY_BATHROOM  
    LOCATION(e_LOCATION_NONE              , e_LOCATION_GUESTBEDROOM      , e_LOCATION_UP_STAIRS         , e_LOCATION_BOXROOM           , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionWestGallery)       // e_LOCATION_WESTGALLERY      
    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_LARGE_STAIRCASE   , _gDescriptionMainLanding)       // e_LOCATION_UP_STAIRS        

    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_INSIDE_PIT        , _gDescriptionOutsidePit)        // e_LOCATION_OUTSIDE_PIT

    LOCATION(e_LOCATION_LIBRARY           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionStudyRoom)         // e_LOCATION_STUDY_ROOM

    LOCATION(e_LOCATION_CELLAR            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , _gDescriptionDarkerCellar)      // e_LOCATION_BRIGHTCELLARROOM   

    LOCATION(e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , 0)                              // e_LOCATION_GIRLROOM (technically this room cannot be accessed, so do not need description)        

