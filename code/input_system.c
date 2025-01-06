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
extern char ValidateInputReturn();



char gPrintMessageBackground[40];   // moved to overlay

WORDS AskInput()
{
	ResetInput();	
	while (1)
	{        
		if (gAskQuestion)
		{
            if (gInputMessage[0])
            {
                memcpy(gPrintMessageBackground,gStatusMessageLocation+1,39);            
    			PrintStatusMessage(2,gInputMessage);   // Implicitely sends to printer with a carriage return, no need to add one
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
			sprintf(gStatusMessageLocation+40+1,"%c>%s%c ",gInputErrorCounter?1:2,gInputBuffer, ((VblCounter&32)||(gInputKey==KEY_RETURN))?32:32|128);
			WaitIRQ();
		}
		while (gInputKey==0);

		switch (gInputKey)
		{
		case KEY_DEL:  // We use DEL as Backspace
            InputDelete();
			break;

        // Magic keyboard trickery to handle UP/DOWNN/LEFT/RIGHT... but should not apply to the credits, so need to be implemented per module
        case KEY_UP:
        case KEY_DOWN:
        case KEY_LEFT:
        case KEY_RIGHT:
        case KEY_ESC:
            InputArrows();
            break;

		case KEY_RETURN:
            if (ValidateInputReturn() || ((gWordCount==0) && gInputAcceptsEmpty))
			{
				WORDS answer = gAnswerProcessingCallback();
				if (answer !=e_WORD_CONTINUE)
				{
					// Quit
                    if (gInputMessage[0])
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
                InputError();
			}
			break;

		default:
            InputDefaultKey();
			break;
		}
	}
}

