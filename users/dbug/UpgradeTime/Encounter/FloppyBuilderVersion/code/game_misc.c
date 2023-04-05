
#include "common.h"
#include "params.h"

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

	gDrawWidth	= width;
	gDrawHeight	= height;
	gDrawPattern= fillValue;

	gDrawPosX	= xPos;
	gDrawPosY	= yPos;
	DrawVerticalLine();
	DrawHorizontalLine();

	gDrawPosX	= xPos+width-1;
	DrawVerticalLine();

	gDrawPosX	= xPos;
	gDrawPosY	= yPos+height-1;
	DrawHorizontalLine();
}


const char* PrintFancyFont()
{
	int xPos;
	int y;
	int car;
	char width;
	char* fontPtr;
	char* targetPtr;
	unsigned char* shiftTablePtr;
	char* targetScanlinePtr;
	unsigned char xPosStart = gDrawPosX;
	unsigned char yPos 		= gDrawPosY;
	const char* message 	= gDrawExtraData;
	unsigned char inverted 	= gDrawPattern;
	char* baseLinePtr = (char*)0xa000+(yPos*40);


	xPos = xPosStart;
	while (car=*message++)
	{
		if (car<0)
		{
			xPos += car;
		}
		else
		if (car==13)
		{
			// Carriage return followed by number of scanlines to jump
			xPos = xPosStart;
			baseLinePtr+=40*(*message++);
		}
		else
		{
			car -= 32;
			width=gFont12x14Width[car];
			targetPtr = baseLinePtr+gTableDivBy6[xPos];
			shiftTablePtr = gShiftBuffer+(gTableModulo6[xPos]*64*2);
			xPos += width+1;
			fontPtr = gFont12x14+car*2;
			while (width>0)
			{
				// Draw the 14 scanlines of each character vertically one by one.
				targetScanlinePtr=targetPtr;
				for (y=0;y<14;y++)
				{
					// Read one byte from the character
					char v = (fontPtr[y*95*2] & 63);

					// And use the shift table to get the left and right parts shifted by the right amount
					if (inverted)
					{
						targetScanlinePtr[0] &= (~shiftTablePtr[v*2+0])|64;
						targetScanlinePtr[1] &= (~shiftTablePtr[v*2+1])|64;
					}
					else
					{
						targetScanlinePtr[0] |= shiftTablePtr[v*2+0];
						targetScanlinePtr[1] |= shiftTablePtr[v*2+1];
					}

					targetScanlinePtr += 40;
				}
				++targetPtr;
				++fontPtr;
				width-=6;
			}
		}
	}
	return message;
}


// The various commands:
// - COMMAND_END indicates the end of the stream
// - COMMAND_BUBBLE draws speech bubble and requires a number of parameters:
//   - Number of bubbles
//   - Main color
//   - For each bubble: X,Y,W,H,
// - COMMAND_TEXT
//   - x,y,color,message
void HandleByteStream(const char* byteStream)
{
	gDrawAddress = (unsigned char*)0xa000;
	if (byteStream)
	{
		char code;
		while (code=*byteStream++)  // COMMAND_END is zero
		{
			switch (code)
			{
			case COMMAND_BUBBLE:
				{
					unsigned char index;
					unsigned char count = *byteStream++;
					unsigned char color = *byteStream++;
					const char* coordinates = byteStream;				
					for (index=0;index<count;index++)
					{
						unsigned char x = *coordinates++;
						unsigned char y = *coordinates++;
						unsigned char w = *coordinates++;
						unsigned char h = *coordinates++;
						DrawRectangleOutline(x-1,y-1,w+2,h+2,color);
					}

					color ^= 63;

					for (index=0;index<count;index++)
					{

						gDrawPattern = color;
						gDrawPosX    = *byteStream++;
						gDrawPosY    = *byteStream++;
						gDrawWidth   = *byteStream++;
						gDrawHeight  = *byteStream++;
						DrawFilledRectangle();
					}
				}
				break;

			case COMMAND_TEXT:
				{
					gDrawPosX 		= *byteStream++;
					gDrawPosY 		= *byteStream++;
					gDrawPattern 	= *byteStream++;
					gDrawExtraData  = byteStream;
					byteStream = PrintFancyFont();
				}
				break;	

			default:			// That's not supposed to happen
				Panic();
				break;
			}
		}
	}
}


