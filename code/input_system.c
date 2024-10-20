//
// EncounterHD
// (c) 2020-2024 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"

#include "game_defines.h"
#include "input_system.h"


extern void ResetInput();
extern void InputCheckKey();
extern void InputDelete();
extern void InputDefaultKey();
extern void InputArrows();


// At the end of the parsing, each of the words is terminated by a zero so it can be printed individually
unsigned char ParseInputBuffer()
{
	unsigned char wordId;
	char car;
	char done;
    char keepSearching;
	keyword* keywordPtr;
	char* separatorPtr;
	char* inputPtr = gInputBuffer;

	memset(gWordBuffer,e_WORD_COUNT_,sizeof(gWordBuffer));

	gWordCount=0;
	done = 0;

	// While we have not reached the null terminator
	while ((!done) && (car=*inputPtr))
	{
		if (car==' ')
		{
			// We automagically filter out the spaces
			inputPtr++;
		}
		else
		{
			// This is not a space, so we assume it is the start of a word

			// Search the end
			separatorPtr=inputPtr;
			while (*separatorPtr && (*separatorPtr!=' '))
			{
                // For the character to be upper case
                if ( (*separatorPtr>='a') && (*separatorPtr<='z') )
                {
                    *separatorPtr &= ~32;   // Force to upper case
                }
				separatorPtr++;
			}
			if (*separatorPtr == 0)
			{
				done = 1;
			}
			else
			{
				*separatorPtr=0;
			}

			// Now that we have identified the begining and end of the word, check if it's in our vocabulary list
			gWordBuffer[gWordCount]=e_WORD_COUNT_;
			keywordPtr = gWordsArray;
            keepSearching = 1;
			while (keepSearching && keywordPtr->word && (gWordCount<MAX_WORDS))   // The list is terminated by a null pointer entry
			{
				// Right now we do a full comparison of the words, but technically we could restrict to only a few significant characters.
				if (strcmp(inputPtr,keywordPtr->word)==0)
				{
					// Found the word in the list, we mark down the token id and continue searching
                    unsigned char itemId = keywordPtr->id;
					gWordBuffer[gWordCount] = itemId;
                    keepSearching = !ProcessFoundToken(itemId);
				}
				++keywordPtr;
			}
			gWordCount++;
			inputPtr = separatorPtr+1;
		}
	}

	return gWordCount;
}


char gPrintMessageBackground[40];

WORDS AskInput(const char* inputMessage,char checkTockens)
{
	ResetInput();	
	while (1)
	{        
		if (gAskQuestion)
		{
#ifdef ENABLE_PRINTER
            PrinterSendCrlf();
#endif    
            if (inputMessage[0])
            {
                memcpy(gPrintMessageBackground,gStatusMessageLocation+1,39);            
    			PrintStatusMessage(2,inputMessage);   // Implicitely sends to printer with a carriage return, no need to add one
            }
			memset(gStatusMessageLocation+40+1,' ',39);
			gAskQuestion=0;
		}

		do
		{
            WORDS callbackOutput=AskInputCallback();
            if (callbackOutput!=e_WORD_CONTINUE)
            {
                return callbackOutput;
            }
			InputCheckKey();
			sprintf(gStatusMessageLocation+40+1,"%c>%s%c ",2,gInputBuffer, ((VblCounter&32)||(gInputKey==KEY_RETURN))?32:32|128);
			WaitIRQ();
		}
		while (gInputKey==0);

		switch (gInputKey)
		{
#ifdef MODULE_GAME            
#ifdef ENABLE_CHEATS
        case KEY_ESC:
            GameDebugger();
            break;
#endif            
#endif
		case KEY_DEL:  // We use DEL as Backspace
            InputDelete();
			break;

        // Magic keyboard trickery to handle UP/DOWNN/LEFT/RIGHT... but should not apply to the credits, so need to be implemented per module
        case KEY_UP:
        case KEY_DOWN:
        case KEY_LEFT:
        case KEY_RIGHT:
            InputArrows();
            break;

		case KEY_RETURN:
#ifdef ENABLE_PRINTER
            PrinterSendMemory((char*)0xbb80+40*23+2,38);    // Player input
            PrinterSendString("\n\n");
#endif
			if (!checkTockens || ParseInputBuffer())
			{
				WORDS answer = gAnswerProcessingCallback();
				if (answer !=e_WORD_CONTINUE)
				{
					// Quit
                    if (inputMessage[0])
                    {
                        memcpy(gStatusMessageLocation+1,gPrintMessageBackground,39);            
                    }
					return answer;
				}
				else
				{
					// Continue
					ResetInput();
					gAskQuestion = 1;
				}
			}
			else
			{
				// No word recognized
				PlaySound(ErrorPlop);
			}
			break;

		default:
            InputDefaultKey();
			break;
		}
	}
}

