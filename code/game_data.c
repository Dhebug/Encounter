
#include "params.h"
#include "game_defines.h"
#include "common.h"



keyword gWordsArray[] =
{
    // Containers
#ifdef LANGUAGE_FR    
    { "TABATIERE" ,e_ITEM_TobaccoTin           },  // e_ITEM_TobaccoTin            
    { "SEAU"    ,e_ITEM_Bucket               },  // e_ITEM_Bucket                
    { "BOITE"   ,e_ITEM_CardboardBox         },  // e_ITEM_CardboardBox          
    { "FILET"   ,e_ITEM_FishingNet           },  // e_ITEM_FishingNet            
    { "SAC"     ,e_ITEM_PlasticBag           },  // e_ITEM_PlasticBag            
#else
    { "TIN",    e_ITEM_TobaccoTin           },  // e_ITEM_TobaccoTin            
    { "BUCKET", e_ITEM_Bucket               },  // e_ITEM_Bucket                
    { "BOX",    e_ITEM_CardboardBox         },  // e_ITEM_CardboardBox          
    { "NET",    e_ITEM_FishingNet           },  // e_ITEM_FishingNet            
    { "BAG",    e_ITEM_PlasticBag           },  // e_ITEM_PlasticBag            
#endif    

    // Then normal items
    { "GIRL",   e_ITEM_YoungGirl            },  // e_ITEM_YoungGirl         
    { "WINDOW", e_ITEM_BrokenWindow         },  // e_ITEM_BrokenWindow          
    { "DUST",   e_ITEM_BlackDust            },  // e_ITEM_BlackDust             
    { "PANEL",  e_ITEM_LockedPanel          },  // e_ITEM_LockedPanel             
    { "FRIDGE",  e_ITEM_Fridge              },  // e_ITEM_Fridge
    { "POWDER", e_ITEM_YellowPowder         },  // e_ITEM_YellowPowder          
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
    { "NOTE",   e_ITEM_HandWrittenNote      },  // e_ITEM_HandWrittenNote       
    { "ROPE",   e_ITEM_Rope                 },  // e_ITEM_Rope                  
    { "TISSUE", e_ITEM_RollOfToiletPaper    },  // e_ITEM_RollOfToiletPaper     
    { "HOSE",   e_ITEM_HosePipe             },  // e_ITEM_HosePipe              
    { "PETROL", e_ITEM_Petrol               },  // e_ITEM_Petrol                
    { "GLASS",  e_ITEM_BrokenGlass          },  // e_ITEM_BrokenGlass       
    { "BOTTLE", e_ITEM_SmallBottle          },  // e_ITEM_SmallBottle       
    { "FUSE",   e_ITEM_Fuse                 },  // e_ITEM_Fuse                  
    { "GUN",    e_ITEM_GunPowder            },  // e_ITEM_GunPowder             
    { "GUN",    e_ITEM_DartGun              },  // e_ITEM_DartGun             
    { "KEYS",   e_ITEM_Keys                 },  // e_ITEM_Keys                  
    { "NEWSPAPER",e_ITEM_Newspaper          },  // e_ITEM_Newspaper             
    { "BOMB",   e_ITEM_Bomb                 },  // e_ITEM_Bomb                  
    { "PISTOL", e_ITEM_Pistol               },  // e_ITEM_Pistol                
    { "BULLETS",e_ITEM_Bullets              },  // e_ITEM_Bullets           
    { "RECIPES",e_ITEM_ChemistryRecipes     },
    { "MAP"    ,e_ITEM_UnitedKingdomMap     },
    { "CURTAIN",e_ITEM_Curtain              },  // e_ITEM_Curtain
    { "CABINET",e_ITEM_Medicinecabinet      },  // e_ITEM_Medicinecabinet
    { "CABINET",e_ITEM_GunCabinet           },  // e_ITEM_Medicinecabinet
    { "PILLS"  ,e_ITEM_SedativePills        },  // e_ITEM_SedativePills
    { "SEDATIVES",e_ITEM_SedativePills      },  // e_ITEM_SedativePills

    { "HANDHELD",e_ITEM_HandheldGame        },  // e_ITEM_HandheldGame
    { "GAME"    ,e_ITEM_HandheldGame        },  // e_ITEM_HandheldGame

    
    

    // Directions
#ifdef LANGUAGE_FR    
    { "N", e_WORD_NORTH },
    { "S", e_WORD_SOUTH },
    { "E", e_WORD_EAST  },
    { "O", e_WORD_WEST  },
    { "M", e_WORD_UP    },
    { "D", e_WORD_DOWN  },

    { "NORD", e_WORD_NORTH },
    { "SUD", e_WORD_SOUTH },
    { "EST", e_WORD_EAST  },
    { "OUEST", e_WORD_WEST  },
    { "MONTE", e_WORD_UP    },
    { "DESCEND", e_WORD_DOWN  },
#else
    { "N", e_WORD_NORTH },
    { "S", e_WORD_SOUTH },
    { "E", e_WORD_EAST  },
    { "W", e_WORD_WEST  },
    { "U", e_WORD_UP    },
    { "D", e_WORD_DOWN  },

    { "NORTH", e_WORD_NORTH },
    { "SOUTH", e_WORD_SOUTH },
    { "EAST", e_WORD_EAST  },
    { "WEST", e_WORD_WEST  },
    { "UP", e_WORD_UP    },
    { "DOWN", e_WORD_DOWN  },
#endif    

    // Misc instructions
#ifdef LANGUAGE_FR    
    { "PREND"   , e_WORD_TAKE },
    { "RAMASSE" , e_WORD_TAKE },
    { "FOUILLE" , e_WORD_FRISK },
    { "CHERCHE" , e_WORD_SEARCH },
    { "LANCE"   , e_WORD_THROW },

    { "LACHE"   , e_WORD_DROP },
    { "POSE"    , e_WORD_DROP },

    { "UTILISE" , e_WORD_USE },

    { "COMBINE" , e_WORD_COMBINE },

    { "LIT"     , e_WORD_READ },

    { "REGARDE" , e_WORD_LOOK },
    { "EXAMINE" , e_WORD_LOOK },
    { "INSPECTE", e_WORD_LOOK },
#else
    { "TAKE"    , e_WORD_TAKE },
    { "GET"     , e_WORD_TAKE },
    { "FRISK"   , e_WORD_FRISK },
    { "SEARCH"  , e_WORD_SEARCH },
    { "THROW"   , e_WORD_THROW },

    { "DROP", e_WORD_DROP },
    { "PUT" , e_WORD_DROP },

    { "USE" , e_WORD_USE },

    { "COMBINE" , e_WORD_COMBINE },

    { "OPEN" , e_WORD_OPEN },
    { "CLOSE" , e_WORD_CLOSE },

    { "READ" , e_WORD_READ },

    { "LOOK"    , e_WORD_LOOK },
    { "EXAMINE" , e_WORD_LOOK },
    { "INSPECT" , e_WORD_LOOK },
#endif

#ifdef ENABLE_CHEATS
    { "INVOKE", e_WORD_INVOKE },
#endif    

    // Last instruction
    { "QUIT", e_WORD_QUIT },

    // Sentinelle
    { 0,  e_WORD_COUNT_ }
};

