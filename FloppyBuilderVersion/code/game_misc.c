
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
		}
        while (!gCurrentStreamStop);
	}
}


