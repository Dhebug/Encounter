//
// EncounterHD
// (c) 2020-2024 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"

#include "game_defines.h"
#include "input_system.h"

char gAskQuestion;
char gInputBuffer[40];
char gInputBufferPos;

char gWordCount;          	// How many tokens/word did we find in the input buffer
char gWordBuffer[10];     	// One byte identifier of each of the identified words
char gWordPosBuffer[10];   	// Actual offset in the original input buffer, can be used to print the unrecognized words

char gTextBuffer[80];    // Temp

//typedef WORDS (*AnswerProcessingFun)();

extern WORDS AskInput(const char* inputMessage,AnswerProcessingFun callback, char checkTockens);

void ResetInput()
{
	gAskQuestion = 1;	
	gInputBufferPos=0;
	gInputBuffer[gInputBufferPos]=0;
}



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
	memset(gWordPosBuffer,0,sizeof(gWordPosBuffer));

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
			gWordPosBuffer[gWordCount] = inputPtr-gInputBuffer;

			// Search the end
			separatorPtr=inputPtr;
			while (*separatorPtr && (*separatorPtr!=' '))
			{
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
			while (keepSearching && keywordPtr->word)   // The list is terminated by a null pointer entry
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



WORDS AskInput(const char* inputMessage,AnswerProcessingFun callback, char checkTockens)
{
    WORDS callbackOutput;
	int k;
	int shift=0;

	ResetInput();	
	while (1)
	{
		if (gAskQuestion)
		{
			PrintStatusMessage(2,inputMessage);
			memset((char*)0xbb80+40*23+1,' ',39);
			gAskQuestion=0;
		}

		do
		{
			WaitIRQ();
            callbackOutput=AskInputCallback();
            if (callbackOutput!=e_WORD_CONTINUE)
            {
                return callbackOutput;
            }
			k=ReadKeyNoBounce();
			sprintf((char*)0xbb80+40*23+1,"%c>%s%c           ",2,gInputBuffer, ((VblCounter&32)||(k==KEY_RETURN))?32:32|128);
		}
		while (k==0);

		if ((KeyBank[4] & 16))	// SHIFT code
		{
			shift=1;
		}

		switch (k)
		{
#ifdef MODULE_GAME            
#ifdef ENABLE_CHEATS
        case KEY_ESC:
            GameDebugger();
            break;
#endif            
#endif
		case KEY_DEL:  // We use DEL as Backspace
			if (gInputBufferPos)
			{
				gInputBufferPos--;
				gInputBuffer[gInputBufferPos]=0;
				PlaySound(KeyClickHData);
			}
			break;

		case KEY_RETURN:
			if (!checkTockens || ParseInputBuffer())
			{
				WORDS answer = callback();
				if (answer !=e_WORD_CONTINUE)
				{
					// Quit
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
				PlaySound(PingData);
			}
			break;

		default:
			if (k>=32)
			{
				if ( (k>='A') && (k<='Z') && shift)
				{
					k |= 32;
				}

				if (gInputBufferPos<35)
				{
					gInputBuffer[gInputBufferPos++]=k;
					gInputBuffer[gInputBufferPos]=0;
					PlaySound(KeyClickLData);
				}
			}
			break;
		}
	}
}

