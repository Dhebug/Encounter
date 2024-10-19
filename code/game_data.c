
#include "params.h"
#include "game_defines.h"
#include "common.h"



keyword gWordsArray[] =
{
    // Containers
#ifdef LANGUAGE_FR    
    { "TABATIERE" ,e_ITEM_TobaccoTin         },      
    { "SEAU"    ,e_ITEM_Bucket               },      
    { "BOITE"   ,e_ITEM_CardboardBox         },      
    { "FILET"   ,e_ITEM_FishingNet           },      
    { "SAC"     ,e_ITEM_PlasticBag           },      
#else
    { "TIN",    e_ITEM_TobaccoTin           },      
    { "BUCKET", e_ITEM_Bucket               },      
    { "BOX",    e_ITEM_CardboardBox         },      
    { "NET",    e_ITEM_FishingNet           },      
    { "BAG",    e_ITEM_PlasticBag           },      
#endif    

    // Then normal items
    { "GIRL",   e_ITEM_YoungGirl            },  
    { "SALTPETRE",   e_ITEM_Saltpetre       },  
    { "PANEL",  e_ITEM_AlarmPanel           },  
    { "SWITCH", e_ITEM_AlarmSwitch          },  
    { "FRIDGE",  e_ITEM_Fridge              },  
    { "SULPHUR", e_ITEM_Sulphur             },  
    { "WATER",  e_ITEM_Water                },  
    { "DOVE",   e_ITEM_LargeDove            },  
    { "STONES", e_ITEM_FancyStones          },  
    { "KNIFE",  e_ITEM_SilverKnife          },  
    { "LADDER", e_ITEM_Ladder               },  
    { "DOG",    e_ITEM_Dog                  },  
    { "MEAT",   e_ITEM_Meat                 },  
    { "BREAD",  e_ITEM_Bread                },  
    { "TAPE",   e_ITEM_BlackTape            },  
    { "TAPE",   e_ITEM_MixTape              },  
    { "MIXTAPE",e_ITEM_MixTape              },  // Synonym of Tape
    { "BOOK",   e_ITEM_ChemistryBook        },  
    { "MATCHES",e_ITEM_BoxOfMatches         },  
    { "CUE",    e_ITEM_SnookerCue           },  
    { "THUG",   e_ITEM_Thug                 },  
    { "SAFE",   e_ITEM_HeavySafe            },  
    { "NOTE",   e_ITEM_HandWrittenNote      },  
    { "ROPE",   e_ITEM_Rope                 },  
    { "ROLL",   e_ITEM_ToiletRoll           },  
    { "HOSE",   e_ITEM_Hose                 },  
    { "PETROL", e_ITEM_Petrol               },  
    { "GLASS",  e_ITEM_BrokenGlass          },  
    { "BOTTLE", e_ITEM_SmallBottle          },  
    { "FUSE",   e_ITEM_Fuse                 },  
    { "GUNPOWDER", e_ITEM_GunPowder         },  
    { "MIX",    e_ITEM_PowderMix            },  
    { "DART",   e_ITEM_DartGun              },  
    { "KEYS",   e_ITEM_Keys                 },  
    { "NEWSPAPER",e_ITEM_Newspaper          },  
    { "BOMB",   e_ITEM_Bomb                 },  
    { "PISTOL", e_ITEM_Pistol               },  
    { "BULLETS",e_ITEM_Bullets              },  
    { "RECIPES",e_ITEM_ChemistryRecipes     },
    { "MAP"    ,e_ITEM_UnitedKingdomMap     },
    { "MAP"    ,e_ITEM_RoughMap             },
    { "CURTAIN",e_ITEM_Curtain              },  
    { "CABINET",e_ITEM_Medicinecabinet      },  
    { "CABINET",e_ITEM_GunCabinet           },  
    { "PILLS"  ,e_ITEM_SedativePills        },  
    { "SEDATIVES",e_ITEM_SedativePills      },  
    { "ADHESIVE",e_ITEM_Adhesive            },  
    { "ACID"    ,e_ITEM_Acid                },  

    { "HANDHELD",e_ITEM_HandheldGame        },  
    { "GAME"    ,e_ITEM_HandheldGame        },  

    { "WINDOW"  ,e_ITEM_BasementWindow      },  
    { "WINDOW"  ,e_ITEM_PanicRoomWindow     },  
    
    { "BOOT"    ,e_ITEM_CarBoot      },  
    { "DOOR"    ,e_ITEM_CarDoor      },  
    { "TANK"    ,e_ITEM_CarTank      },  
    { "CAR"     ,e_ITEM_Car          }, 

    { "DOOR"    ,e_ITEM_SecurityDoor },  
    { "HOLE"    ,e_ITEM_HoleInDoor },  

    { "DOOR"    ,e_ITEM_FrontDoor },  

    { "MORTAR"  ,e_ITEM_MortarAndPestle  },  

    { "CLAY"    ,e_ITEM_Clay },  
    { "SUIT"    ,e_ITEM_ProtectionSuit },  

    { "GRAFFITI"    ,e_ITEM_Graffiti }, 
    { "CHURCH"      ,e_ITEM_Church }, 
    { "WELL"        ,e_ITEM_Well }, 
    { "SIGN"        ,e_ITEM_RoadSign }, 
    { "BIN"         ,e_ITEM_Trashcan }, 
    { "TOMBSTONE"   ,e_ITEM_Tombstone }, 
    { "POND"        ,e_ITEM_FishPond }, 
    { "FISH"        ,e_ITEM_Fish }, 
    { "APPLES"      ,e_ITEM_Apple }, 


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

#ifdef ENABLE_PRINTER
    { "IMPRIME"   , e_WORD_PRINT  },
#endif    
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
#ifdef ENABLE_PRINTER
    { "PRINT"   , e_WORD_PRINT  },
#endif    
#endif

#ifdef ENABLE_CHEATS
    { "INVOKE", e_WORD_INVOKE },
#endif    

    { "PAUSE", e_WORD_PAUSE },
    { "HELP", e_WORD_HELP },

    // Last instruction
    { "QUIT", e_WORD_QUIT },

    // Sentinelle
    { 0,  e_WORD_COUNT_ }
};

