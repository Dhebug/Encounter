
#include "game_defines.h"


keyword gWordsArray[] =
{
    // Misc instructions
#ifdef LANGUAGE_FR
    { "PRENDS"  , e_WORD_TAKE },
    { "RAMASSE" , e_WORD_TAKE },
    { "FOUILLE" , e_WORD_FRISK },
    { "CHERCHE" , e_WORD_SEARCH },
    { "LANCE"   , e_WORD_THROW },

    { "POSE"    , e_WORD_DROP },
    { "LACHE"   , e_WORD_DROP },

    { "UTILISE" , e_WORD_USE },

    { "COMBINE" , e_WORD_COMBINE },

    { "OUVRE" , e_WORD_OPEN },
    { "FERME" , e_WORD_CLOSE },

    { "LIS"     , e_WORD_READ },

    { "INSPECTE", e_WORD_LOOK },
    { "REGARDE" , e_WORD_LOOK },
    { "EXAMINE" , e_WORD_LOOK },
#elif defined(LANGUAGE_NO)
    { "TA"      , e_WORD_TAKE },
    { "HENT"    , e_WORD_TAKE },
    { "RANSAK"  , e_WORD_FRISK },   // Ransak
    { "LET"     , e_WORD_SEARCH },  // Å lete
    { "KAST"    , e_WORD_THROW },

    { "SLIPP"   , e_WORD_DROP },    // Slipp
    { "LEGG"    , e_WORD_DROP },    // Legg fra deg

    { "BRUK"    , e_WORD_USE },

    { "KOMBINER", e_WORD_COMBINE },
    { "BLAND"   , e_WORD_COMBINE },

    { "APNE"    , e_WORD_OPEN },    // Åpne
    { "LUKK"    , e_WORD_CLOSE },

    { "LES"     , e_WORD_READ },

    { "SJEKK"   , e_WORD_LOOK },    // Examine
    { "SE"      , e_WORD_LOOK },
    { "GRANSK"  , e_WORD_LOOK },
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

#ifdef LANGUAGE_FR
    { "AIDE",  e_WORD_HELP },
    { "PAUSE", e_WORD_HELP },

    // Last instruction
    { "QUITTE", e_WORD_QUIT },
#elif defined(LANGUAGE_NO)
    { "HJELP",   e_WORD_HELP },
    { "PAUSE",   e_WORD_HELP },

    // Last instruction
    { "AVSLUTT", e_WORD_QUIT },
#else
    { "HELP",  e_WORD_HELP },
    { "PAUSE", e_WORD_HELP },

    // Last instruction
    { "QUIT", e_WORD_QUIT },
#endif

    // Single letter shortcuts (at the end so full words appear first in the menu)
#ifdef LANGUAGE_FR
    { "N", e_WORD_NORTH },
    { "S", e_WORD_SOUTH },
    { "E", e_WORD_EAST  },
    { "O", e_WORD_WEST  },  // Ouest
    { "M", e_WORD_UP    },  // Monter
    { "D", e_WORD_DOWN  },  // Descendre

    { "X", e_WORD_LOOK  },
#elif defined(LANGUAGE_NO)
    { "N", e_WORD_NORTH },  // We keep the English words in Norwegian
    { "S", e_WORD_SOUTH },  // The reason is taht the Oric keyboard does not have any Norwegian character
    { "E", e_WORD_EAST  },  // So typing "OST" (Cheese) instead of "ØST" (East) would be awkward
    { "W", e_WORD_WEST  },
    { "U", e_WORD_UP    },
    { "D", e_WORD_DOWN  },

    { "X", e_WORD_LOOK  },
#else
    { "N", e_WORD_NORTH },
    { "S", e_WORD_SOUTH },
    { "E", e_WORD_EAST  },
    { "W", e_WORD_WEST  },
    { "U", e_WORD_UP    },
    { "D", e_WORD_DOWN  },

    { "X", e_WORD_LOOK  },
#endif

    // Sentinelle
    { 0,  e_WORD_COUNT_ }
};

