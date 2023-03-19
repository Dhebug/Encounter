//
// EncounterHD - Main Game
// (c) 2020-2023 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"

#include "game_defines.h"

char gInputBuffer[40];
char gInputBufferPos;

char gTextBuffer[80];    // Temp



void PrintSceneInformation()
{
	location* locationPtr = &gLocations[gCurrentLocation];
	unsigned char* directions = locationPtr->directions;
	int direction;
	int exitCount = 0;
	int messageLength = 0;

	for (direction=0;direction<e_DIRECTION_COUNT_;direction++)
	{
		if (directions[direction]!=e_LOCATION_NONE)
		{
			exitCount++;
		}
	}

	// Print the description of the place at the top (centered)
	memset((char*)0xbb80+16*40+1,' ',39);
	messageLength=strlen(locationPtr->description);
	strcpy((char*)0xbb80+16*40+20-messageLength/2,locationPtr->description);

	// Print the directions under (also centered)
	memset((char*)0xbb80+17*40+1,' ',39);
	if (exitCount)
	{
		SetLineAddress(gTextBuffer);
		
		if (exitCount==1)
		{
			PrintWord("The only exit is ");
		}
		else
		{
			PrintWord("Exits lead ");
		}

		for (direction=0;direction<e_DIRECTION_COUNT_;direction++)
		{
			if (directions[direction]!=e_LOCATION_NONE)
			{
				PrintWord(gDirectionsArray[direction]);
				exitCount--;
				if (exitCount==1)
				{
					PrintWord(" and ");
				}
				else
				if (exitCount)
				{
					PrintWord(", ");
				}
			}
		}
		*gPrintAddress=0;  // Make sure to null terminate the string
	}
	else
	{
		strcpy(gTextBuffer,"There seems to be no way out");
	}
	messageLength=strlen(gTextBuffer);
	strcpy((char*)0xbb80+17*40+20-messageLength/2,gTextBuffer);
}


void LoadScene()
{
	LoadFileAt(LOADER_PICTURE_LOCATIONS_START+gCurrentLocation+1,ImageBuffer);	
	BlitBufferToHiresWindow();

	PrintSceneInformation();
}


// Lines 18 to 23, with blue background
void ScrollMessage()
{
	memcpy((char*)0xbb80+40*18,(char*)0xbb80+40*19, 40*5);
	memset((char*)0xbb80+40*23+2,32,38);
}

void PrintMessage(const char* message,char color)
{
	ScrollMessage();
	sprintf((char*)0xbb80+40*23+1,"%c%s",color,message);
}


void PlayerMove(unsigned char direction)
{
	location* locationPtr = &gLocations[gCurrentLocation];

	unsigned char requestedScene = gLocations[gCurrentLocation].directions[direction];
	if (requestedScene==e_LOCATION_NONE)
	{
		PlaySound(PingData);
		PrintMessage("Impossible to move in that direction",1);		
	}
	else
	{
		PlaySound(KeyClickHData);
		gCurrentLocation=requestedScene;
		LoadScene();
	}
}



void main()
{
	int k;
	int askQuestion = 1;

	// erase the screen
	memset((char*)0xa000,0,8000);

	// 
	System_InstallIRQ_SimpleVbl();

 	// Setup the Hires/Text mixed graphic mode
	InitializeGraphicMode();      

	// Load the charset
	LoadFileAt(LOADER_FONT_6x8,0xb500);

	gCurrentLocation = e_LOCATION_MARKETPLACE;

	LoadScene();
	DisplayClock();

	gInputBufferPos=0;
	gInputBuffer[gInputBufferPos]=0;

	do
	{
		int shift=0;
		//sprintf((char*)0xbb80+40*22+1,"%cWhat are you going to do now?",6);
		if (askQuestion)
		{
			ScrollMessage();
			PrintMessage("What are you going to do now?",6);
			ScrollMessage();
			askQuestion=0;
		}
		do
		{
			WaitIRQ();
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
		case KEY_DEL:  // We use DEL as Backspace
			if (gInputBufferPos)
			{
				gInputBufferPos--;
				gInputBuffer[gInputBufferPos]=0;
				PlaySound(KeyClickHData);
			}
			break;

		case KEY_RETURN:
			if (strcmp(gInputBuffer,"N")==0)
			{
				PlayerMove(e_DIRECTION_NORTH);
			}
			else
			if (strcmp(gInputBuffer,"S")==0)
			{
				PlayerMove(e_DIRECTION_SOUTH);
			}
			else
			if (strcmp(gInputBuffer,"E")==0)
			{
				PlayerMove(e_DIRECTION_EAST);
			}
			else
			if (strcmp(gInputBuffer,"W")==0)
			{
				PlayerMove(e_DIRECTION_WEST);
			}
			else
			if (strcmp(gInputBuffer,"U")==0)
			{
				PlayerMove(e_DIRECTION_UP);
			}
			else
			if (strcmp(gInputBuffer,"D")==0)
			{
				PlayerMove(e_DIRECTION_DOWN);
			}
			else
			if (strcmp(gInputBuffer,"LOAD")==0)
			{
				PlaySound(KeyClickHData);
				LoadScene();
			}
			else
			if (strcmp(gInputBuffer,"QUIT")==0)
			{
				PlaySound(KeyClickHData);
				k=13;
			}
			else
			{
				PlaySound(PingData);
			}
			gInputBufferPos=0;
			gInputBuffer[gInputBufferPos]=0;
			askQuestion = 1;
			break;

		default:
			if (k>=32)
			{
				if ( (k>='A') && (k<='Z') && shift)
				{
					k |= 32;
				}

				if (gInputBufferPos<20)
				{
					gInputBuffer[gInputBufferPos++]=k;
					gInputBuffer[gInputBufferPos]=0;
					PlaySound(KeyClickLData);
				}
			}
			break;
		}
	}
	while (k!=13);

	// Just to let the last click sound to keep playing
	WaitFrames(4);

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the intro
	InitializeFileAt(LOADER_INTRO_PROGRAM,0x400);
}

