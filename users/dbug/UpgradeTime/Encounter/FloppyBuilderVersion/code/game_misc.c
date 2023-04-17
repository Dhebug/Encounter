
#include "common.h"
#include "params.h"
#include "game_defines.h"

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


//const char* gCurrentStream = 0;
unsigned int gDelayStream = 0;

void SetByteStream(const char* byteStream)
{
	gCurrentStream = byteStream;
	gDelayStream   = 0;
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
		char code;
		gDrawAddress = (unsigned char*)0xa000;
		while (1)
		{
			code=*gCurrentStream++;
			switch (code)
			{
			case COMMAND_END:
				SetByteStream(0);
				return;

			case COMMAND_WAIT:
				gDelayStream = *gCurrentStream++;
				if (!gDelayStream)
				{
					gDelayStream <<= 8;
					gDelayStream |= *gCurrentStream++;
				}
				return;

			case COMMAND_RECTANGLE:
				{
					gDrawPosX    = *gCurrentStream++;
					gDrawPosY    = *gCurrentStream++;
					gDrawWidth   = *gCurrentStream++;
					gDrawHeight  = *gCurrentStream++;
					gDrawPattern = *gCurrentStream++;
					DrawFilledRectangle();
				}
				break;

			case COMMAND_FILL_RECTANGLE:
				{
					gDrawPosX    = *gCurrentStream++;
					gDrawPosY    = *gCurrentStream++;
					gDrawWidth   = *gCurrentStream++;
					gDrawHeight  = *gCurrentStream++;
					gDrawPattern = *gCurrentStream++;
					DrawFilledRectangle();
				}
				break;

			case COMMAND_TEXT:
				{
					gDrawPosX 		= *gCurrentStream++;
					gDrawPosY 		= *gCurrentStream++;
					gDrawPattern 	= *gCurrentStream++;
					gDrawExtraData  = gCurrentStream;
					PrintFancyFont();
					gCurrentStream = gDrawExtraData;    // modified by the PrintFancyFont function
				}
				break;	

			case COMMAND_BITMAP:
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
				break;	

			case COMMAND_FADE_BUFFER:
				BlitBufferToHiresWindow();
				break;

			case COMMAND_JUMP:
				gCurrentStreamInt =  (unsigned int*) *gCurrentStreamInt++;
				break;

			case COMMAND_JUMP_IF_TRUE:
			case COMMAND_JUMP_IF_FALSE:
				{
					unsigned int* jumpLocation = (unsigned int*) *gCurrentStreamInt++;
					char check = 0;
					switch (*gCurrentStream++)
					{
					case OPERATOR_CHECK_ITEM_LOCATION:
						{
							unsigned char itemId     = *gCurrentStream++;
							unsigned char locationId = *gCurrentStream++;
							check =  (gItems[itemId].location == locationId);
						}
						break;

					default:			// That's not supposed to happen
						Panic();
					}
					// code
					if ( (check && (code==COMMAND_JUMP_IF_TRUE)) || 
					    (!check && (code==COMMAND_JUMP_IF_FALSE)) )
					{
						gCurrentStreamInt = jumpLocation;
					}
				}
				break;

			case COMMAND_BUBBLE:
				{
					unsigned char index;
					unsigned char count = *gCurrentStream++;
					unsigned char color = *gCurrentStream++;
					const char* coordinates = gCurrentStream;				
					for (index=0;index<count;index++)
					{
						unsigned char x = *coordinates++;
						unsigned char y = *coordinates++;
						unsigned char w = *coordinates++;
						unsigned char h = *coordinates++;
						DrawRectangleOutline(x-1,y-1,w+2,h+2,color);
					}

					color ^= 63;
					gDrawPattern = color;

					coordinates = gCurrentStream;
					for (index=0;index<count;index++)
					{
						gDrawPosX    = *gCurrentStream++;
						gDrawPosY    = *gCurrentStream++;
						gDrawWidth   = *gCurrentStream++;
						gDrawHeight  = *gCurrentStream++;
						DrawFilledRectangle();
					}

					color ^= 63;
					gDrawPattern 	= color;
					for (index=0;index<count;index++)
					{
						gDrawPosX    	= *coordinates++ + *gCurrentStream++;
						gDrawPosY    	= *coordinates++ + *gCurrentStream++;
						gDrawWidth   	= *coordinates++; 		// Ignored
						gDrawHeight  	= *coordinates++;		// Ignored
						gDrawExtraData  = gCurrentStream;
						PrintFancyFont();
						gCurrentStream = gDrawExtraData;    // modified by the PrintFancyFont function
					}
				}
				break;

			default:			// That's not supposed to happen
				Panic();
				break;
			}
		}
	}
}


