
#include "game_defines.h"



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
    { e_LOCATION_DARKTUNNEL        , e_LOCATION_NONE              , e_LOCATION_DARKALLEY         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a deserted market square"},   // e_LOCATION_MARKETPLACE    
    { e_LOCATION_MAINSTREET        , e_LOCATION_NONE              , e_LOCATION_ROAD              , e_LOCATION_MARKETPLACE       , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a dark, seedy alley"},        // e_LOCATION_DARKALLEY      
    { e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_DARKALLEY         , e_LOCATION_NONE              , e_LOCATION_NONE              , "A long road stretches ahead of you"},    // e_LOCATION_ROAD      

    { e_LOCATION_WOODEDAVENUE      , e_LOCATION_MARKETPLACE       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a dark, damp tunnel"},        // e_LOCATION_DARKTUNNEL     
    { e_LOCATION_GRAVELDRIVE       , e_LOCATION_DARKALLEY         , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on the main street"},            // e_LOCATION_MAINSTREET     
    { e_LOCATION_TARMACAREA        , e_LOCATION_ROAD              , e_LOCATION_INSIDEHOLE        , e_LOCATION_MAINSTREET        , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a narrow path"},              // e_LOCATION_NARROWPATH     

    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You have fallen into a deep pit"},       // e_LOCATION_INSIDEHOLE
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are near to an old-fashioned well"}, // e_LOCATION_WELL           
    { e_LOCATION_ZENGARDEN         , e_LOCATION_DARKTUNNEL        , e_LOCATION_GRAVELDRIVE       , e_LOCATION_WELL              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a wooded avenue"},            // e_LOCATION_WOODEDAVENUE   

    { e_LOCATION_LAWN              , e_LOCATION_MAINSTREET        , e_LOCATION_TARMACAREA        , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a wide gravel drive"},        // e_LOCATION_GRAVELDRIVE   
    { e_LOCATION_GREENHOUSE        , e_LOCATION_NARROWPATH        , e_LOCATION_NONE              , e_LOCATION_GRAVELDRIVE       , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in an open area of tarmac"},     // e_LOCATION_TARMACAREA      
    { e_LOCATION_TENNISCOURT       , e_LOCATION_WOODEDAVENUE      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a relaxing zen garden"},      // e_LOCATION_ZENGARDEN       

    { e_LOCATION_ENTRANCEHALL      , e_LOCATION_GRAVELDRIVE       , e_LOCATION_GREENHOUSE        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a huge area of lawn"},        // e_LOCATION_LAWN  
    { e_LOCATION_VEGSGARDEN        , e_LOCATION_TARMACAREA        , e_LOCATION_NONE              , e_LOCATION_LAWN              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a small greenhouse"},         // e_LOCATION_GREENHOUSE      
    { e_LOCATION_FISHPND           , e_LOCATION_ZENGARDEN         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a lawn tennis court"},        // e_LOCATION_TENNISCOURT     

    { e_LOCATION_APPLE_TREES       , e_LOCATION_GREENHOUSE        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a vegetable plot"},           // e_LOCATION_VEGSGARDEN   
    { e_LOCATION_NONE              , e_LOCATION_TENNISCOURT       , e_LOCATION_TILEDPATIO        , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are standing by a fish pond"},       // e_LOCATION_FISHPND         
    { e_LOCATION_NONE              , e_LOCATION_SUNLOUNGE         , e_LOCATION_APPLE_TREES       , e_LOCATION_FISHPND           , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a tiled patio"},              // e_LOCATION_TILEDPATIO - and above it is a barred window 

    { e_LOCATION_NONE              , e_LOCATION_VEGSGARDEN        , e_LOCATION_NONE              , e_LOCATION_TILEDPATIO        , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in an apple orchard"},           // e_LOCATION_APPLE_TREES     
    { e_LOCATION_CELLAR            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This room is even darker than the last"},// e_LOCATION_DARKCELLARROOM   
    { e_LOCATION_NONE              , e_LOCATION_DARKCELLARROOM    , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_KITCHEN           , e_LOCATION_NONE              , "This is a cold, damp cellar"},           // e_LOCATION_CELLAR           

    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_KITCHEN           , e_LOCATION_CELLAR            , "You are on some gloomy, narrow steps"},  // e_LOCATION_NARROWSTAIRCASE  
    { e_LOCATION_DININGROOM        , e_LOCATION_NONE              , e_LOCATION_ENTRANCEHALL      , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in the lounge"},                 // e_LOCATION_LOUNGE     
    { e_LOCATION_NARROWPASSAGE     , e_LOCATION_LAWN              , e_LOCATION_NONE              , e_LOCATION_LOUNGE            , e_LOCATION_LARGE_STAIRCASE   , e_LOCATION_NONE              , "You are in an imposing entrance hall"},  // e_LOCATION_ENTRANCEHALL    

    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NARROWPASSAGE     , e_LOCATION_NONE              , e_LOCATION_NONE              , "This looks like a library"},             // e_LOCATION_LIBRARY         
    { e_LOCATION_GAMESROOM         , e_LOCATION_LOUNGE            , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "A dining room, or so it appears"},       // e_LOCATION_DININGROOM      
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_UP_STAIRS         , e_LOCATION_ENTRANCEHALL      , "You are on a sweeping staircase"},       // e_LOCATION_LARGE_STAIRCASE 

    { e_LOCATION_NONE              , e_LOCATION_DININGROOM        , e_LOCATION_SUNLOUNGE         , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This looks like a games room"},          // e_LOCATION_GAMESROOM        
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_KITCHEN           , e_LOCATION_GAMESROOM         , e_LOCATION_NONE              , e_LOCATION_NONE              , "You find yourself in a sun-lounge"},     // e_LOCATION_SUNLOUNGE        
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_SUNLOUNGE         , e_LOCATION_NONE              , e_LOCATION_NARROWSTAIRCASE   , "This is obviously the kitchen"},         // e_LOCATION_KITCHEN    

    { e_LOCATION_SUNLOUNGE         , e_LOCATION_ENTRANCEHALL      , e_LOCATION_LIBRARY           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a narrow passage"},           // e_LOCATION_NARROWPASSAGE   
    { e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This seems to be a guest bedroom"},      // e_LOCATION_GUESTBEDROOM     
    { e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This is a child's bedroom"},             // e_LOCATION_CHILDBEDROOM     

    { e_LOCATION_TINY_WC           , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , "This must be the master bedroom"},       // e_LOCATION_MASTERBEDROOM    
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in a tiled shower-room"},        // e_LOCATION_SHOWERROOM       
    { e_LOCATION_NONE              , e_LOCATION_MASTERBEDROOM     , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This is a tiny toilet"},                 // e_LOCATION_TINY_WC          

    { e_LOCATION_CLASSY_BATHROOM   , e_LOCATION_CHILDBEDROOM      , e_LOCATION_MASTERBEDROOM     , e_LOCATION_UP_STAIRS         , e_LOCATION_NONE              , e_LOCATION_NONE              , "You have found the east gallery"},       // e_LOCATION_EASTGALLERY      
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "This is a small box-room"},              // e_LOCATION_BOXROOM          
    { e_LOCATION_NONE              , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You see a padlocked steel-plated door"}, // e_LOCATION_PADLOCKED_ROOM   

    { e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are in an ornate bathroom"},         // e_LOCATION_CLASSY_BATHROOM  
    { e_LOCATION_PADLOCKED_ROOM    , e_LOCATION_GUESTBEDROOM      , e_LOCATION_UP_STAIRS         , e_LOCATION_BOXROOM           , e_LOCATION_NONE              , e_LOCATION_NONE              , "This is the west gallery"},              // e_LOCATION_WESTGALLERY      
    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_EASTGALLERY       , e_LOCATION_WESTGALLERY       , e_LOCATION_NONE              , e_LOCATION_LARGE_STAIRCASE   , "You are on the main landing"},           // e_LOCATION_UP_STAIRS        

    { e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , e_LOCATION_NONE              , "The girl room (openned lock)"},          // e_LOCATION_GIRLROOM         
};

