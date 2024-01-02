
#include "common.h"
#include "params.h"
#include "game_defines.h"

typedef void (*ByteStreamCallback)();
extern ByteStreamCallback ByteStreamCallbacks[_COMMAND_COUNT];


void ClearMessageWindow(unsigned char paperColor)
{
	int i;
	char* ptrScreen=(char*)0xbb80+40*18;
	for (i=18;i<=23;i++)
	{
		*ptrScreen=paperColor;
		memset(ptrScreen+1,32,39);
		ptrScreen+=40;
	}
}


void InitializeGraphicMode()
{
	ClearTextWindow();
	poke(0xbb80+40*0,31|128);  	// Switch to HIRES, using video inverse to keep the 6 pixels white
	poke(0xa000+40*128,26);  	// Switch to TEXT

	// from the old BASIC code, will fix later
	// CYAN on BLACK for the scene description
	poke(0xBB80+40*16,7);   // Line with the arrow character and the clock
	poke(0xBB80+40*17,6);    

	// BLUE background for the log output
	ClearMessageWindow(16+4);

	// BLACK background for the inventory area
	poke(0xBB80+40*24,16);
	poke(0xBB80+40*25,16);
	poke(0xBB80+40*26,16);
	poke(0xBB80+40*27,16);

	// Initialize the ALT charset numbers
	memcpy((char*)0xb800+'0'*8,gSevenDigitDisplay,8*11);
}


void DrawRectangleOutline(unsigned char xPos, unsigned char yPos, unsigned char width, unsigned char height, unsigned char fillValue)
{
	gDrawAddress = (unsigned char*)0xa000;

	gDrawPattern= fillValue;

	gDrawPosX	= xPos;
	gDrawPosY	= yPos+1;
	gDrawWidth	= width;
	gDrawHeight	= height-2;
	DrawVerticalLine();

	gDrawPosX	= xPos+1;
	gDrawPosY	= yPos;
	gDrawWidth	= width-2;
	gDrawHeight	= height;
	DrawHorizontalLine();

	gDrawPosX	= xPos+width-1;
	gDrawPosY	= yPos+1;
	gDrawWidth	= width+1;
	gDrawHeight	= height-2;
	DrawVerticalLine();

	gDrawPosX	= xPos+1;
	gDrawPosY	= yPos+height-1;
	gDrawWidth	= width-2;
	gDrawHeight	= height;
	DrawHorizontalLine();
}


void SetByteStream(const char* byteStream)
{
	gCurrentStream = byteStream;
	gDelayStream   = 0;
}


void PlayStream(const char* byteStream)
{
    const char* originalByteStream = gCurrentStream;
	gCurrentStream = byteStream;
	gDelayStream   = 0;

    do
    {
        WaitIRQ();
        HandleByteStream();
    }
    while (gCurrentStream);
}


void ByteStreamCommandINFO_MESSAGE()
{
    PrintInformationMessage(gCurrentStream);    // Should probably return the length or pointer to the end of string
	gCurrentStream += strlen(gCurrentStream)+1;
}


void ByteStreamCommandBITMAP()
{
	unsigned char loaderId = *gCurrentStream++;
	if (gFlagCurrentSpriteSheet!=loaderId)
	{
		// We only load the image if it's not already the one in memory
		LoadFileAt(loaderId,SecondImageBuffer);
		gFlagCurrentSpriteSheet=loaderId;
	}
	gDrawWidth 		= *gCurrentStream++;
	gDrawHeight 	= *gCurrentStream++;
	gSourceStride 	= *gCurrentStream++;
	gDrawSourceAddress =  (unsigned char*) *gCurrentStreamInt++;
	gDrawAddress       =  (unsigned char*) *gCurrentStreamInt++;
	BlitSprite();
}


void ByteStreamCommandFULLSCREEN_ITEM()
{
	unsigned char loaderId = *gCurrentStream++;

    ClearMessageWindow(16+4);
    LoadFileAt(loaderId,ImageBuffer);
    PrintTopDescription(gCurrentStream);
    BlitBufferToHiresWindow();

	gCurrentStream += strlen(gCurrentStream)+1;
}


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


