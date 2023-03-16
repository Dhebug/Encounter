//
// EncounterHD - Main Game
// (c) 2020-2023 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"


int k;

char InputBuffer[40];
char InputBufferPos;

int CurrentImage=LOADER_PICTURE_LOCATIONS_START;


void LoadScene()
{
	//#define LOADER_PICTURE_LOCATIONS_START 4  -> NONE.HIR
	//#define LOADER_PICTURE_LOCATIONS_END 51
	CurrentImage++;
	if ( (CurrentImage<=LOADER_PICTURE_LOCATIONS_START) || (CurrentImage>LOADER_PICTURE_LOCATIONS_END) )
	{
		CurrentImage=LOADER_PICTURE_LOCATIONS_START+1;
	}
	//LoadFileAt(CurrentImage,0xa000);	
	LoadFileAt(CurrentImage,ImageBuffer);	
	//memcpy((char*)0xa000,ImageBuffer,5120);
	//ShowImage();
	BlitBufferToHiresWindow();
}

void main()
{
	// erase the screen
	memset((char*)0xa000,0,8000);

	// 
	System_InstallIRQ_SimpleVbl();

	ClearTextWindow();
	poke(0xbb80+40*0,31);  // Switch to HIRES
	poke(0xa000+40*128,26);  // Switch to TEXT

	// Load the charset
	LoadFileAt(LOADER_FONT_6x8,0xb500);

	LoadScene();
	DisplayClock();

	InputBufferPos=0;
	InputBuffer[InputBufferPos]=0;

	/*
// Modifier keys
#define KEY_LSHIFT		1
#define KEY_RSHIFT		2
#define KEY_LCTRL		3
#define KET_RCTRL		4
#define KEY_FUNCT		5
// Actual normal keys
#define KEY_UP			6
#define KEY_LEFT		7
#define KEY_DOWN		8
#define KEY_RIGHT		9
#define KEY_ESC			10
#define KEY_DEL			11
#define KEY_RETURN		12
	*/
	do
	{
		// RControl -> Bank0 & 16
		// LControl -> Bank2 & 16
		// LShift   -> Bank4 & 16 
		// RShift   -> Bank7 & 16 

		// Arrows:  -> All on Bank 4

		int shift=0;
		sprintf((char*)0xbb80+40*27,"> %s| ",InputBuffer);
		k=WaitKey();
		if ((KeyBank[4] & 16))	// SHIFT code
		{
			shift=1;
		}
		/*
		sprintf((char*)0xbb80+40*26,"Key: %d  %c shift: %d",k,k , shift );
		sprintf((char*)0xbb80+40*27,"%d %d %d %d %d %d %d %d  ",KeyBank[0],KeyBank[1],KeyBank[2],KeyBank[3],KeyBank[4],KeyBank[5],KeyBank[6],KeyBank[7]);
		*/
		// Control: 5
		// Shift: 7
		// Backspace: 11

		switch (k)
		{
		case KEY_DEL:  // We use DEL as Backspace
			if (InputBufferPos)
			{
				InputBufferPos--;
				InputBuffer[InputBufferPos]=0;
				PlaySound(KeyClickHData);
			}
			break;

		case KEY_RETURN:
			if (strcmp(InputBuffer,"LOAD")==0)
			{
				PlaySound(KeyClickHData);
				LoadScene();
			}
			else
			if (strcmp(InputBuffer,"QUIT")==0)
			{
				PlaySound(KeyClickHData);
				k=13;
			}
			else
			{
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

				if (InputBufferPos<20)
				{
					InputBuffer[InputBufferPos++]=k;
					InputBuffer[InputBufferPos]=0;
					PlaySound(KeyClickLData);
				}
			}
			break;
		}
	}
	while (k!=13);

	// Just to let the last click sound to keep playing
	WaitIRQ();
	WaitIRQ();
	WaitIRQ();
	WaitIRQ();

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the intro
	InitializeFileAt(LOADER_INTRO_PROGRAM,0x400);
}

