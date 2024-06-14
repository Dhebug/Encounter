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
    //       North                     South                     East                      West                      Up                        Down                     Script
    LOCATION(e_LOC_DARKTUNNEL        , e_LOC_NONE              , e_LOC_DARKALLEY         , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionMarketPlace)       // e_LOC_MARKETPLACE    
    LOCATION(e_LOC_MAINSTREET        , e_LOC_NONE              , e_LOC_ROAD              , e_LOC_MARKETPLACE       , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionDarkAlley)         // e_LOC_DARKALLEY      
    LOCATION(e_LOC_NARROWPATH        , e_LOC_NONE              , e_LOC_NONE              , e_LOC_DARKALLEY         , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionRoad)              // e_LOC_ROAD      

    LOCATION(e_LOC_WOODEDAVENUE      , e_LOC_MARKETPLACE       , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionDarkTunel)         // e_LOC_DARKTUNNEL     
    LOCATION(e_LOC_GRAVELDRIVE       , e_LOC_DARKALLEY         , e_LOC_NARROWPATH        , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionMainStreet)        // e_LOC_MAINSTREET     
    LOCATION(e_LOC_TARMACAREA        , e_LOC_ROAD              , e_LOC_OUTSIDE_PIT       , e_LOC_MAINSTREET        , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionNarrowPath)        // e_LOC_NARROWPATH     

    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionInThePit)          // e_LOC_INSIDE_PIT
    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_WOODEDAVENUE      , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionOldWell)           // e_LOC_WELL           
    LOCATION(e_LOC_ZENGARDEN         , e_LOC_DARKTUNNEL        , e_LOC_GRAVELDRIVE       , e_LOC_WELL              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionWoodedAvenue)      // e_LOC_WOODEDAVENUE   

    LOCATION(e_LOC_LAWN              , e_LOC_MAINSTREET        , e_LOC_TARMACAREA        , e_LOC_WOODEDAVENUE      , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionGravelDrive)       // e_LOC_GRAVELDRIVE   
    LOCATION(e_LOC_GREENHOUSE        , e_LOC_NARROWPATH        , e_LOC_NONE              , e_LOC_GRAVELDRIVE       , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionTarmacArea)        // e_LOC_TARMACAREA      
    LOCATION(e_LOC_TENNISCOURT       , e_LOC_WOODEDAVENUE      , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionZenGarden)         // e_LOC_ZENGARDEN       

    LOCATION(e_LOC_ENTRANCEHALL      , e_LOC_GRAVELDRIVE       , e_LOC_GREENHOUSE        , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionFrontLawn)         // e_LOC_LAWN  
    LOCATION(e_LOC_VEGSGARDEN        , e_LOC_TARMACAREA        , e_LOC_NONE              , e_LOC_LAWN              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionGreenHouse)        // e_LOC_GREENHOUSE      
    LOCATION(e_LOC_FISHPND           , e_LOC_ZENGARDEN         , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionTennisCourt)       // e_LOC_TENNISCOURT     

    LOCATION(e_LOC_APPLE_TREES       , e_LOC_GREENHOUSE        , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionVegetableGarden)   // e_LOC_VEGSGARDEN   
    LOCATION(e_LOC_NONE              , e_LOC_TENNISCOURT       , e_LOC_TILEDPATIO        , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionFishPond)          // e_LOC_FISHPND         
    LOCATION(e_LOC_NONE              , e_LOC_SUNLOUNGE         , e_LOC_APPLE_TREES       , e_LOC_FISHPND           , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionTiledPatio)        // e_LOC_TILEDPATIO - and above it is a barred window 

    LOCATION(e_LOC_NONE              , e_LOC_VEGSGARDEN        , e_LOC_NONE              , e_LOC_TILEDPATIO        , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionAppleOrchard)      // e_LOC_APPLE_TREES     
    LOCATION(e_LOC_CELLAR            , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              ,_gDescriptionDarkerCellar)       // e_LOC_DARKCELLARROOM   
    LOCATION(e_LOC_NONE              , e_LOC_DARKCELLARROOM    , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NARROWSTAIRCASE   , e_LOC_NONE              , _gDescriptionCellar)            // e_LOC_CELLAR           

    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_KITCHEN           , e_LOC_CELLAR            , _gDescriptionNarrowStaircase)   // e_LOC_NARROWSTAIRCASE  
    LOCATION(e_LOC_DININGROOM        , e_LOC_NONE              , e_LOC_ENTRANCEHALL      , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionEntranceLounge)    // e_LOC_LOUNGE     
    LOCATION(e_LOC_NARROWPASSAGE     , e_LOC_LAWN              , e_LOC_NONE              , e_LOC_LOUNGE            , e_LOC_LARGE_STAIRCASE   , e_LOC_NONE              , _gDescriptionEntranceHall)      // e_LOC_ENTRANCEHALL    

    LOCATION(e_LOC_NONE              , e_LOC_STUDY_ROOM        , e_LOC_NONE              , e_LOC_NARROWPASSAGE     , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionLibrary)           // e_LOC_LIBRARY         
    LOCATION(e_LOC_GAMESROOM         , e_LOC_LOUNGE            , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionDiningRoom)        // e_LOC_DININGROOM      
    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_UP_STAIRS         , e_LOC_ENTRANCEHALL      , _gDescriptionStaircase)         // e_LOC_LARGE_STAIRCASE 

    LOCATION(e_LOC_NONE              , e_LOC_DININGROOM        , e_LOC_SUNLOUNGE         , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionGamesRoom)         // e_LOC_GAMESROOM        
    LOCATION(e_LOC_TILEDPATIO        , e_LOC_NARROWPASSAGE     , e_LOC_KITCHEN           , e_LOC_GAMESROOM         , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionSunLounge)         // e_LOC_SUNLOUNGE        
    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_SUNLOUNGE         , e_LOC_NONE              , e_LOC_NARROWSTAIRCASE   , _gDescriptionKitchen)           // e_LOC_KITCHEN    

    LOCATION(e_LOC_SUNLOUNGE         , e_LOC_ENTRANCEHALL      , e_LOC_LIBRARY           , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionNarrowPassage)     // e_LOC_NARROWPASSAGE   
    LOCATION(e_LOC_WESTGALLERY       , e_LOC_NONE              , e_LOC_NONE              , e_LOC_SHOWERROOM        , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionGuestBedroom)      // e_LOC_GUESTBEDROOM     
    LOCATION(e_LOC_EASTGALLERY       , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionChildBedroom)      // e_LOC_CHILDBEDROOM     

    LOCATION(e_LOC_TINY_WC           , e_LOC_NONE              , e_LOC_NONE              , e_LOC_EASTGALLERY       , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionMasterBedRoom)     // e_LOC_MASTERBEDROOM    
    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_GUESTBEDROOM      , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionShowerRoom)        // e_LOC_SHOWERROOM       
    LOCATION(e_LOC_NONE              , e_LOC_MASTERBEDROOM     , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionTinyToilet)        // e_LOC_TINY_WC          

    LOCATION(e_LOC_CLASSY_BATHROOM   , e_LOC_CHILDBEDROOM      , e_LOC_MASTERBEDROOM     , e_LOC_UP_STAIRS         , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionEastGallery)       // e_LOC_EASTGALLERY      
    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_WESTGALLERY       , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionBoxRoom)           // e_LOC_BOXROOM          
    LOCATION(e_LOC_NONE              , e_LOC_WESTGALLERY       , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionPadlockedRoom)     // e_LOC_PADLOCKED_ROOM   

    LOCATION(e_LOC_NONE              , e_LOC_EASTGALLERY       , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionClassyBathRoom)    // e_LOC_CLASSY_BATHROOM  
    LOCATION(e_LOC_NONE              , e_LOC_GUESTBEDROOM      , e_LOC_UP_STAIRS         , e_LOC_BOXROOM           , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionWestGallery)       // e_LOC_WESTGALLERY      
    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_EASTGALLERY       , e_LOC_WESTGALLERY       , e_LOC_NONE              , e_LOC_LARGE_STAIRCASE   , _gDescriptionMainLanding)       // e_LOC_UP_STAIRS        

    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NARROWPATH        , e_LOC_NONE              , e_LOC_INSIDE_PIT        , _gDescriptionOutsidePit)        // e_LOC_OUTSIDE_PIT

    LOCATION(e_LOC_LIBRARY           , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , _gDescriptionStudyRoom)         // e_LOC_STUDY_ROOM

    LOCATION(e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_NONE              , e_LOC_DARKCELLARROOM    , _gDescriptionCellarWindow)      // e_LOC_CELLAR_WINDOW 

