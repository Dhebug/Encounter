
#include "common.h"
#include "params.h"
#include "game_defines.h"

typedef void (*ByteStreamCallback)();
extern ByteStreamCallback ByteStreamCallbacks[_COMMAND_COUNT];



unsigned int* jumpLocation;
char check = 0;


unsigned char car;
unsigned char index;
unsigned char count;
unsigned char color;
const char* coordinates;				

void ByteStreamCommandBUBBLE()
{
	count = *gCurrentStream++;
	color = *gCurrentStream++;
	coordinates = gCurrentStream;				
	for (index=0;index<count;index++)
	{
		unsigned char x = *coordinates++;
		unsigned char y = *coordinates++;
        unsigned char w = 2;
		unsigned char h = 15;
        coordinates++;           // offset y
        while (car=*coordinates++)  // Skip string
        {
            if (car>127)    w+=(char)car;
            else            w+=gFont12x14Width[car-32]+1;

        }
        //sprintf((char*)0xbb80+40*(20+index),"%d %d %d %d ",x,y,w,h);
		DrawRectangleOutline(x-1,y-1,w+2,h+2,color);
	}

	color ^= 63;
	gDrawPattern = color;

	coordinates = gCurrentStream;
	for (index=0;index<count;index++)
	{
		gDrawPosX    = *coordinates++;
		gDrawPosY    = *coordinates++;
		gDrawHeight  = 15;
        coordinates++;           // offset y
        gDrawWidth=2;
        while (car=*coordinates++)  // Skip string
        {
            if (car>127)    gDrawWidth+=(char)car;
            else            gDrawWidth+=gFont12x14Width[car-32]+1;
        }

		DrawFilledRectangle();
	}

	color ^= 63;
	gDrawPattern 	= color;
	coordinates = gCurrentStream;
	for (index=0;index<count;index++)
	{
		gDrawPosX    	= *coordinates++;
		gDrawPosY    	= *coordinates++;
		gDrawHeight  	= 15;
		gDrawPosX      += 1;   // offset x
		gDrawPosY      += *coordinates++;  // offset y
		gDrawExtraData  = coordinates;
		PrintFancyFont();
		coordinates = gDrawExtraData;    // modified by the PrintFancyFont function
	}
    gCurrentStream = coordinates;
}



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


