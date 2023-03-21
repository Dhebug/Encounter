//
// EncounterHD - Main Game
// (c) 2020-2023 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"

#include "game_defines.h"

char gInputBuffer[40];
char gInputBufferPos;

char gWordCount;          	// How many tokens/word did we find in the input buffer
char gWordBuffer[10];     	// One byte identifier of each of the identified words
char gWordPosBuffer[10];   	// Actual offset in the original input buffer, can be used to print the unrecognized words

char gTextBuffer[80];    // Temp


// At the end of the parsing, each of the words is terminated by a zero so it can be printed individually
unsigned char ParseInputBuffer()
{
	unsigned char wordId;
	char car;
	char done;
	char* separatorPtr;
	char* inputPtr = gInputBuffer;

	memset(gWordBuffer,e_WORD_COUNT_,sizeof(gWordBuffer));
	memset(gWordPosBuffer,0,sizeof(gWordPosBuffer));

	gWordCount=0;
	done = 0;

	// While we have not reached the null terminator
	while ((!done) && (car=*inputPtr)
	)
	{
		if (car==' ')
		{
			// We automagically filter out the spaces
			inputPtr++;
		}
		else
		{
			// This is not a space, so we assume it is the start of a word
			gWordPosBuffer[gWordCount] = inputPtr-gInputBuffer;

			// Search the end
			separatorPtr=inputPtr;
			while (*separatorPtr && (*separatorPtr!=' '))
			{
				separatorPtr++;
			}
			if (*separatorPtr == 0)
			{
				done = 1;
			}
			else
			{
				*separatorPtr=0;
			}

			// Now that we have identified the begining and end of the word, check if it's in our vocabulary list
			gWordBuffer[gWordCount]=e_WORD_COUNT_;
			for (wordId=0;wordId<e_WORD_COUNT_;wordId++)
			{
				if (strcmp(inputPtr,gWordsArray[wordId])==0)
				{
					// Found the word in the list, we mark down the token id and continue searching
					gWordBuffer[gWordCount] = wordId;
					gWordCount++;
					break;
				}
			}
			inputPtr = separatorPtr+1;
		}
	}

	return gWordCount;
}


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


// Very basic version of the inventory, does not check anything, 
// displays a maximum of 7 items before it starts overwriting the clock
void PrintInventory()
{
	int item;
	int inventoryCell =0 ;
	memset((char*)0xbb80+40*24,32,40*4-8);  // 8 characters at the end of the inventory for the clock
	for (item=0;item<e_ITEM_COUNT_;item++)
	{
		if (gItems[item].location == e_LOCATION_INVENTORY)
		{
			memcpy((char*)0xbb80+40*(24+inventoryCell/2)+(inventoryCell&1)*20,gItems[item].description,strlen(gItems[item].description));
			inventoryCell++;
		}
	}
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

	PrintInventory();
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


void TakeItem(unsigned char itemId)
{
	if (itemId>e_ITEM_COUNT_)
	{
		PrintStatusMessage(1,"You can only take something you see");
		PlaySound(PingData);
		WaitFrames(75);
	}
	else
	{
		if (gItems[itemId].location!=gCurrentLocation)
		{
			PrintStatusMessage(1,"I don't see this item here");
			PlaySound(PingData);
			WaitFrames(75);
		}
		else
		{
			gItems[itemId].location = e_LOCATION_INVENTORY;
			LoadScene();
		}
	}
}


void DropItem(unsigned char itemId)
{
	if ( (itemId>e_ITEM_COUNT_) || (gItems[itemId].location!=e_LOCATION_INVENTORY) )
	{
		PrintStatusMessage(1,"You can only drop something you have");
		PlaySound(PingData);
		WaitFrames(75);
	}
	else
	{
		gItems[itemId].location = gCurrentLocation;
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
			memset((char*)0xbb80+40*23+1,' ',39);
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
			if (ParseInputBuffer())
			{
				// Check the first word
				switch (gWordBuffer[0])
				{
				//
				// Movement
				//
				case e_WORD_NORTH:
					PlayerMove(e_DIRECTION_NORTH);
					break;
				case e_WORD_SOUTH:
					PlayerMove(e_DIRECTION_SOUTH);
					break;
				case e_WORD_EAST:
					PlayerMove(e_DIRECTION_EAST);
					break;
				case e_WORD_WEST:
					PlayerMove(e_DIRECTION_WEST);
					break;
				case e_WORD_UP:
					PlayerMove(e_DIRECTION_UP);
					break;
				case e_WORD_DOWN:
					PlayerMove(e_DIRECTION_DOWN);
					break;

				//
				// Action
				//
				case e_WORD_TAKE:
					TakeItem(gWordBuffer[1]);
					break;
				case e_WORD_DROP:
					DropItem(gWordBuffer[1]);
					break;

				//
				// Meta
				//
				case e_WORD_QUIT:
					PlaySound(KeyClickHData);
					k=13;
					break;
				default:
					PlaySound(PingData);

				}

			}
			else
			{
				// No word recognized
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

