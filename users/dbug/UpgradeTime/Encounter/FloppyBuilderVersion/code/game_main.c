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


void PrintStatusMessage(char color,const char* message)
{
	char* ptrScreen=(char*)0xbb80+40*22;
	memset(ptrScreen+1,32,39);
	sprintf(ptrScreen+1,"%c%s",color,message);
}


void PrintSceneDirections()
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


void PrintSceneObjects()
{
	int i;
	int itemCount = 0;
	int item;

	for (item=0;item<e_ITEM_COUNT_;item++)
	{
		if (gItems[item].location == gCurrentLocation)
		{
			itemCount++;
		}
	}

	// Print any item in the location
	if (itemCount)
	{
		char first=1;
		char* ptrScreen=(char*)0xbb80+40*18;
		for (item=0;item<e_ITEM_COUNT_;item++)
		{
			if (gItems[item].location == gCurrentLocation)
			{
				if (first)
				{
					// The first item on the screen is shown a bit differently
					sprintf(ptrScreen+1,"%cI can see %s",3,gItems[item].description);					
					ptrScreen+=40;
					first=0;
				}
				else
				{
					sprintf(ptrScreen+1,"%c%s",3,gItems[item].description);					
					ptrScreen+=40;
				}
			}
		}
	}
	else
	{
		sprintf((char*)0xbb80+40*18+1,"%c%s",3,"There is nothing of interest here");
	}
}

void PrintSceneInformation()
{
	location* locationPtr = &gLocations[gCurrentLocation];
	int messageLength = 0;

	// Print the description of the place at the top (centered)
	memset((char*)0xbb80+16*40+1,' ',39);
	messageLength=strlen(locationPtr->description);
	strcpy((char*)0xbb80+16*40+20-messageLength/2,locationPtr->description);

	PrintSceneDirections();

	PrintSceneObjects();
}


void LoadScene()
{
	ClearMessageWindow(16+4);

	LoadFileAt(LOADER_PICTURE_LOCATIONS_START+gCurrentLocation+1,ImageBuffer);	
	BlitBufferToHiresWindow();

	PrintSceneInformation();
}


void PlayerMove(unsigned char direction)
{
	location* locationPtr = &gLocations[gCurrentLocation];

	unsigned char requestedScene = gLocations[gCurrentLocation].directions[direction];
	if (requestedScene==e_LOCATION_NONE)
	{
		PrintStatusMessage(1,"Impossible to move in that direction");
		PlaySound(PingData);
		WaitFrames(75);
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
		if (askQuestion)
		{
			PrintStatusMessage(2,"What are you going to do now?");
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

