
#include "common.h"
#include "params.h"
#include "game_defines.h"

typedef void (*ByteStreamCallback)();
extern ByteStreamCallback ByteStreamCallbacks[_COMMAND_COUNT];



unsigned int* jumpLocation;
char check = 0;


// The various commands:
// - COMMAND_END indicates the end of the stream
// - COMMAND_BUBBLE draws speech bubble and requires a number of parameters:
//   - Number of bubbles
//   - Main color
//   - For each bubble: X,Y,W,H,
// - COMMAND_TEXT
//   - x,y,color,message
void HandleByteStream()
{
	if (gDelayStream)
	{
		// _VblCounter
		gDelayStream--;
		return;
	}

	if (gCurrentStream)
	{
		gDrawAddress = (unsigned char*)0xa000;
        gCurrentStreamStop = 0;
		do
		{
			unsigned char command=*gCurrentStream++;
            if (command>=_COMMAND_COUNT)
            {
                Panic();
            }
            ByteStreamCallbacks[command]();

            if (gStreamCutScene)
            {
                while (gDelayStream)
                {
                    gDelayStream--;
                    WaitIRQ();
                    if (gStreamSkipPoint && ReadKeyNoBounce())
                    {
                        // If we have a skip point and the keyboard is pressed, jump there immediately
                        // This is used to skip the intro sequence when reaching the market place.
                        gCurrentStream=gStreamSkipPoint;
                        gStreamSkipPoint=0;
                        gDelayStream=0;
                    }
                }
            }
		}
        while (!gCurrentStreamStop);   // Can be triggered by END, WAIT, END_AND_REFRESH
	}
}

