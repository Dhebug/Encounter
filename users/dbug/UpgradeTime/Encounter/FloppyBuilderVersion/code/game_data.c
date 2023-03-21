
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
    { e_LOCATION_SUNLOUNGE         , e_LOCATION_SUNLOUNGE         , e_LOCATION_APPLE_TREES       , e_LOCATION_FISHPND           , e_LOCATION_NONE              , e_LOCATION_NONE              , "You are on a tiled patio"},              // e_LOCATION_TILEDPATIO - and above it is a barred window 

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


// The flags and usable containers are copied from the BASIC version.
// The final version will contain actual bit-masks
item gItems[e_ITEM_COUNT_] =
{ //  Abrev  Description                             Location                    Flags       Usable Containers
    { "TIN"	,"an empty tobacco tin"					,e_LOCATION_LOUNGE			,""			,""},                                            // e_ITEM_TobaccoTin    		
    { "BUC"	,"a wooden bucket"						,e_LOCATION_WELL			,""			,""},                                            // e_ITEM_Bucket        		
    { "BOX"	,"a cardboard box"						,e_LOCATION_GREENHOUSE		,""			,""},                                            // e_ITEM_CardboardBox  		
    { "NET"	,"a fishing net"						,e_LOCATION_FISHPND		    ,""			,""},                                            // e_ITEM_FishingNet    		
    { "BAG"	,"a plastic bag"						,e_LOCATION_MARKETPLACE	    ,""			,""},                                            // e_ITEM_PlasticBag    		
    { "..."	,"a young girl"							,99							,""			,""},                                            // e_ITEM_YoungGirl  		
    { "..."	,"the window is broken"					,99							,""			,""},                                            // e_ITEM_BrokenWindow  		
    { "..."	,"an open safe"							,99							,"H"		,""},                                            // e_ITEM_OpenSafe  			
    { "DUS"	,"black dust"							,e_LOCATION_DARKTUNNEL		,""			,"BUC,BOX,BAG,TIN"},                             // e_ITEM_BlackDust  			
    { "..."	,"an open panel on wall"				,99							,""			,""},                                            // e_ITEM_OpenPanel  			
    { "PAN"	,"a locked panel on the wall"			,e_LOCATION_DARKCELLARROOM	,""			,""},                                            // e_ITEM_LockedPanel  		
    { "POW"	,"gritty yellow powder"					,e_LOCATION_INSIDEHOLE		,""			,"BUC,BOX,BAG,TIN"},                             // e_ITEM_YellowPowder  		
    { "..."	,"a small hole in the door"				,99							,""			,""},                                            // e_ITEM_SmallHoleInDoor 		
    { "WAT"	,"some water"							,e_LOCATION_WELL			,"D"		,"BUC,BAG,TIN"},                                 // e_ITEM_Water  				
    { "DOV"	,"a large dove"							,e_LOCATION_WOODEDAVENUE	,""			,"BUC,BOX,NET"},                                 // e_ITEM_LargeDove  			
    { "TWI"	,"some twine"							,e_LOCATION_GREENHOUSE		,""			,""},                                            // e_ITEM_Twine  				
    { "KNI"	,"a silver knife"						,e_LOCATION_VEGSGARDEN		,""			,""},                                            // e_ITEM_SilverKnife  		
    { "LAD"	,"a ladder"								,e_LOCATION_APPLE_TREES	    ,""			,""},                                            // e_ITEM_Ladder  				
    { "CAR"	,"an abandoned car"						,e_LOCATION_TARMACAREA		,"H"		,""},                                            // e_ITEM_AbandonedCar  		
    { "DOG"	,"an alsatian growling at you"			,e_LOCATION_ENTRANCEHALL	,""			,""},                                            // e_ITEM_AlsatianDog  		
    { "MEA"	,"a joint of meat"						,e_LOCATION_DININGROOM		,""			,""},                                            // e_ITEM_Meat  				
    { "BRE"	,"some brown bread"						,e_LOCATION_DININGROOM		,""			,""},                                            // e_ITEM_Bread  				
    { "TAP"	,"a roll of sticky tape"				,e_LOCATION_LIBRARY		    ,""			,""},                                            // e_ITEM_RollOfTape  			
    { "BOO"	,"a chemistry book"						,e_LOCATION_LIBRARY		    ,""			,""},                                            // e_ITEM_ChemistryBook  		
    { "MAT"	,"a box of matches"						,e_LOCATION_KITCHEN		    ,""			,""},                                            // e_ITEM_BoxOfMatches  		
    { "CUE"	,"a snooker cue"						,e_LOCATION_GAMESROOM		,""			,"" },                                           // e_ITEM_SnookerCue  			
    { "THU"	,"a thug asleep on the bed"				,e_LOCATION_MASTERBEDROOM	,"H"		,""},                                            // e_ITEM_Thug  				
    { "SAF"	,"a heavy safe"							,e_LOCATION_CELLAR 		    ,"H"		,""},                                            // e_ITEM_HeavySafe  			
    { "NOT"	,"a printed note"						,e_LOCATION_BOXROOM		    ,""			,""},                                            // e_ITEM_PrintedNote  		
    { "ROP"	,"a length of rope"						,e_LOCATION_WELL			,""			,""},                                            // e_ITEM_Rope  				
    { "..."	,"a rope hangs from the window"			,99							,""			,""},                                            // e_ITEM_RopeHangingFromWindow
    { "TIS"	,"a roll of toilet tissue"				,e_LOCATION_TINY_WC		    ,""			,""},                                            // e_ITEM_RollOfToiletPaper  	
    { "HOS"	,"a hose-pipe"							,e_LOCATION_ZENGARDEN		,""			,""},                                            // e_ITEM_HosePipe  			
    { "PET"	,"some petrol"							,99 						,"D"		,"BUC,BAG,TIN"},                                 // e_ITEM_Petrol  				
    { "GLA"	,"broken glass"							,99							,""			,""},                                            // e_ITEM_BrokenGlass  		
    { "..."	,"an acid burn"							,99							,""			,""},                                            // e_ITEM_AcidBurn  			
    { "BOT"	,"a small bottle"						,99							,""			,""},                                            // e_ITEM_SmallBottle  		
    { "FUS"	,"a fuse"								,99							,""			,""},                                            // e_ITEM_Fuse  				
    { "GUN"	,"some gunpowder"						,99							,""			,"BUC,BOX,BAG,TIN"},                             // e_ITEM_GunPowder  			
    { "KEY"	,"a set of keys"						,e_LOCATION_MAINSTREET		,""			,""},                                            // e_ITEM_Keys  				
    { "NEW"	,"a newspaper"							,e_LOCATION_MARKETPLACE	    ,""			,""},                                            // e_ITEM_Newspaper     		
    { "BOM"	,"a bomb"								,99							,""			,""},                                            // e_ITEM_Bomb  				
    { "PIS"	,"a pistol"								,99							,""			,""},                                            // e_ITEM_Pistol 				
    { "BUL"	,"three .38 bullets"					,e_LOCATION_DARKCELLARROOM	,""			,""},                                            // e_ITEM_Bullets  			
    { "GIR"	,"a young girl tied up on the floor"	,e_LOCATION_GIRLROOM		,""			,""},                                            // e_ITEM_YoungGirlOnFloor  	
};

const char* gWordsArray[e_WORD_COUNT_] =
{
    // Items
    "TIN",  // e_ITEM_TobaccoTin    		
    "BUC",  // e_ITEM_Bucket        		
    "BOX",  // e_ITEM_CardboardBox  		
    "NET",  // e_ITEM_FishingNet    		
    "BAG",  // e_ITEM_PlasticBag    		
    "...",  // e_ITEM_YoungGirl  		
    "...",  // e_ITEM_BrokenWindow  		
    "...",  // e_ITEM_OpenSafe  			
    "DUS",  // e_ITEM_BlackDust  			
    "...",  // e_ITEM_OpenPanel  			
    "PAN",  // e_ITEM_LockedPanel  		
    "POW",  // e_ITEM_YellowPowder  		
    "...",  // e_ITEM_SmallHoleInDoor 		
    "WAT",  // e_ITEM_Water  				
    "DOV",  // e_ITEM_LargeDove  			
    "TWI",  // e_ITEM_Twine  				
    "KNI",  // e_ITEM_SilverKnife  		
    "LAD",  // e_ITEM_Ladder  				
    "CAR",  // e_ITEM_AbandonedCar  		
    "DOG",  // e_ITEM_AlsatianDog  		
    "MEA",  // e_ITEM_Meat  				
    "BRE",  // e_ITEM_Bread  				
    "TAP",  // e_ITEM_RollOfTape  			
    "BOO",  // e_ITEM_ChemistryBook  		
    "MAT",  // e_ITEM_BoxOfMatches  		
    "CUE",  // e_ITEM_SnookerCue  			
    "THU",  // e_ITEM_Thug  				
    "SAF",  // e_ITEM_HeavySafe  			
    "NOT",  // e_ITEM_PrintedNote  		
    "ROP",  // e_ITEM_Rope  				
    "...",  // e_ITEM_RopeHangingFromWindow
    "TIS",  // e_ITEM_RollOfToiletPaper  	
    "HOS",  // e_ITEM_HosePipe  			
    "PET",  // e_ITEM_Petrol  				
    "GLA",  // e_ITEM_BrokenGlass  		
    "...",  // e_ITEM_AcidBurn  			
    "BOT",  // e_ITEM_SmallBottle  		
    "FUS",  // e_ITEM_Fuse  				
    "GUN",  // e_ITEM_GunPowder  			
    "KEY",  // e_ITEM_Keys  				
    "NEW",  // e_ITEM_Newspaper     		
    "BOM",  // e_ITEM_Bomb  				
    "PIS",  // e_ITEM_Pistol 				
    "BUL",  // e_ITEM_Bullets  			
    "GIR",  // e_ITEM_YoungGirlOnFloor

    // Directions
    "N", 
    "S", 
    "E", 
    "W", 
    "U", 
    "D", 

    // Misc instructions
    "TAKE",
    "DROP",

    // Last instruction
    "QUIT"
};
