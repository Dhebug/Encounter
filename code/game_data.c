
#include "params.h"
#include "game_defines.h"
#include "common.h"
#include "input_system.h"


// At the end of the parsing, each of the words is terminated by a zero so it can be printed individually
void ParseInputBuffer()
{
	unsigned char car;
    unsigned char itemId;
    unsigned int foundKeywordId;
	char* endWordPtr;
    keyword* keywordPtr;
    item* itemPtr;
    const char* description;
	char* inputPtr = gInputBuffer;

	memset(gWordBuffer,e_WORD_COUNT_,sizeof(gWordBuffer));

	gWordCount=0;

	// While we have not reached the null terminator
	while (car=*inputPtr)
	{
		if (car==' ')
		{
			// We automagically filter out the spaces
			inputPtr++;
		}
		else
		{
			// This is not a space, so we assume it is the start of a word
			// Search the end of the word
			endWordPtr=inputPtr;
			while (*endWordPtr && (*endWordPtr!=' '))
			{
                // For the character to be upper case
				endWordPtr++;
			}

			// Now that we have identified the begining and end of the word, check if it's in our vocabulary list
            foundKeywordId = e_WORD_COUNT_;

            // First we search if it's one of the VERBS
            if (gWordCount == 0)
            {
                // A VERB can only be at the start, else we can't take the LANCE flechete (because LANCE is also a verb)
                keywordPtr = gWordsArray;
                while (keywordPtr->id!=e_WORD_COUNT_)
                {
                    // Right now we do a full comparison of the words, but technically we could restrict to only a few significant characters.
                    param0.ptr=inputPtr;param1.ptr=keywordPtr->word;
                    if (KeywordCompare())
                    {
                        // Found the word in the list, we mark down the token id and continue searching
                        unsigned char itemId = keywordPtr->id;
                        foundKeywordId = itemId;
                        break;
                    }
                    ++keywordPtr;
                }
            }

            // If not found in the VERBS, then we search in the ITEMS
            if (foundKeywordId == e_WORD_COUNT_)
            {
                itemPtr = gItems;
                itemId=0;
                while (itemId<e_ITEM_COUNT_)
                {
                    // Right now we do a full comparison of the words, but technically we could restrict to only a few significant characters.
                    description=itemPtr->description;     
                    while (car = *description)
                    {
                        description++;
                        if (car=='_')
                        {
                            break;
                        }
                    }

                    param0.ptr=inputPtr;param1.ptr=description;                   
                    if (KeywordCompare())
                    {
                        // Found the word in the list, we mark down the token id and continue searching
                        // The reason is that some items exist but they are not in the scene, so we can provide the "it's not here" error message
                        foundKeywordId = itemId;
                        if ((itemPtr->location == e_LOC_INVENTORY) || (itemPtr->location == gCurrentLocation))
                        {
                            break;
                        }
                    }
                    
                    ++itemId;
                    ++itemPtr;
                }
            }
			gWordBuffer[gWordCount]=foundKeywordId;
            gWordCount++;

			inputPtr = endWordPtr;
		}
	}
}




keyword gWordsArray[] =
{
    // Directions
#ifdef LANGUAGE_FR    
    { "N", e_WORD_NORTH },
    { "S", e_WORD_SOUTH },
    { "E", e_WORD_EAST  },
    { "O", e_WORD_WEST  },
    { "M", e_WORD_UP    },
    { "D", e_WORD_DOWN  },
#else
    { "N", e_WORD_NORTH },
    { "S", e_WORD_SOUTH },
    { "E", e_WORD_EAST  },
    { "W", e_WORD_WEST  },
    { "U", e_WORD_UP    },
    { "D", e_WORD_DOWN  },
#endif    

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
    { "AIDE", e_WORD_HELP },
    { "PAUSE", e_WORD_HELP },

    // Last instruction
    { "QUITTE", e_WORD_QUIT },
#else
    { "HELP", e_WORD_HELP },
    { "PAUSE", e_WORD_HELP },

    // Last instruction
    { "QUIT", e_WORD_QUIT },
#endif

    // Sentinelle
    { 0,  e_WORD_COUNT_ }
};

