//
// EncounterHD - Main Game
// (c) 2020-2023 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"

#include "game_defines.h"

char gAskQuestion;
char gInputBuffer[40];
char gInputBufferPos;

char gWordCount;          	// How many tokens/word did we find in the input buffer
char gWordBuffer[10];     	// One byte identifier of each of the identified words
char gWordPosBuffer[10];   	// Actual offset in the original input buffer, can be used to print the unrecognized words

char gTextBuffer[80];    // Temp



typedef WORDS (*AnswerProcessingFun)();

extern WORDS AskInput(const char* inputMessage,AnswerProcessingFun callback);

void ResetInput()
{
	gAskQuestion = 1;	
	gInputBufferPos=0;
	gInputBuffer[gInputBufferPos]=0;
}


// At the end of the parsing, each of the words is terminated by a zero so it can be printed individually
unsigned char ParseInputBuffer()
{
	unsigned char wordId;
	char car;
	char done;
	keyword* keywordPtr;
	char* separatorPtr;
	char* inputPtr = gInputBuffer;

	memset(gWordBuffer,e_WORD_COUNT_,sizeof(gWordBuffer));
	memset(gWordPosBuffer,0,sizeof(gWordPosBuffer));

	gWordCount=0;
	done = 0;

	// While we have not reached the null terminator
	while ((!done) && (car=*inputPtr))
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
			keywordPtr = gWordsArray;
			while (keywordPtr->word)   // The list is terminated by a null pointer entry
			{
				// Right now we do a full comparison of the words, but technically we could restrict to only a few significant characters.
				if (strcmp(inputPtr,keywordPtr->word)==0)
				{
					// Found the word in the list, we mark down the token id and continue searching
					gWordBuffer[gWordCount] = keywordPtr->id;
					gWordCount++;
					break;
				}
				++keywordPtr;
			}
			inputPtr = separatorPtr+1;
		}
	}

	return gWordCount;
}



void PrintStatusMessage(char color,const char* message)
{
	char* ptrScreen=(char*)0xbb80+40*22;
	memset(ptrScreen+1,32,39);
	sprintf(ptrScreen+1,"%c%s",color,message);
}


void PrintErrorMessage(const char* message)
{
	PrintStatusMessage(1,message);
	PlaySound(PingData);
	WaitFrames(75);
}


void PrintInformationMessage(const char* message)
{
	PrintStatusMessage(3,message);
	//PlaySound(PingData);
	WaitFrames(75);
}


void PrintSceneDirections()
{
	location* locationPtr = &gLocations[gCurrentLocation];
	unsigned char* directions = locationPtr->directions;
	int direction;

	gFlagDirections = 0;
	for (direction=0;direction<e_DIRECTION_COUNT_;direction++)
	{
		if (directions[direction]!=e_LOCATION_NONE)
		{
			gFlagDirections|= (1<<direction);
		}
	}
}


// Very basic version of the inventory, does not check anything, 
// displays a maximum of 7 items before it starts overwriting the clock
void PrintInventory()
{	
	int itemId;
	int inventoryCell =0;
	item* itemPtr = gItems;
	memset((char*)0xbb80+40*24,32,40*4-8);  // 8 characters at the end of the inventory for the clock
	for (itemId=0;itemId<e_ITEM_COUNT_;itemId++)
	{
		if (itemPtr->location == e_LOCATION_INVENTORY)
		{
			int descriptionLength = strlen(itemPtr->description);
			char* screenPtr = (char*)0xbb80+40*(24+inventoryCell/2)+(inventoryCell&1)*20;
			memcpy(screenPtr,itemPtr->description , descriptionLength);
#if 0			
			// Ideally it would be nice to be able to display things like
			// - An empty plastic bag
			// - A tin box full of dust
			// - A bucket filled with petrol
			//
			// This is technically not very difficult to do, but we only have 3.5 lines of 40 characters
			// So probably should wait a bit until the whole UI layout is 100% fixed
			if (itemPtr->flags & ITEM_FLAG_IS_CONTAINER)
			{
				screenPtr += descriptionLength;
				if (itemPtr->associated_item == 255)
				{
					// Empty container
					memcpy(screenPtr," (empty)",7);
				}
				else
				{
					// Contains something
					memcpy(screenPtr," ->",2);
				}
			}
#endif			

			inventoryCell++;
		}
		++itemPtr;
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
	memset((char*)0xbb80+17*40+1,' ',39);
	messageLength=strlen(locationPtr->description);
	strcpy((char*)0xbb80+17*40+20-messageLength/2,locationPtr->description);

	poke(0xbb80+16*40+16,9);                      // ALT charset
	memcpy((char*)0xbb80+16*40+17,";<=>?@",6);

	PrintSceneDirections();

	PrintSceneObjects();

	PrintInventory();
}


void LoadScene()
{
	ClearMessageWindow(16+4);

#if 1
	LoadFileAt(LOADER_PICTURE_LOCATIONS_START+gCurrentLocation+1,ImageBuffer);	
#else
	memset(ImageBuffer,64+1,40*128);
#endif	



#if 0	  // Sprite test

#if 1
	LoadFileAt(LOADER_SPRITE_DOG,SecondImageBuffer);			// The dog is a 240x128 image with all the current dog graphics

	gDrawWidth	 	= 40;
	gDrawHeight	 	= 128;
	gSourceStride   = 40;
	gDrawSourceAddress 	= SecondImageBuffer;
	gDrawAddress 	= ImageBuffer;
	//gDrawAddress 		= (unsigned char*)0xa000;

	BlitSprite();
#else	
	LoadFileAt(LOADER_SPRITE_THE_END,SecondImageBuffer);		// The End is a 120x95 image -> 95 lines of 20 bytes

	gDrawWidth	 		= 20;
	gDrawHeight	 		= 95;
	gSourceStride   	= 20;
	gDrawSourceAddress 	= SecondImageBuffer;
	gDrawAddress 		= ImageBuffer+10+40*16;
	//gDrawAddress 		= (unsigned char*)0xa000+10+40*16;

	BlitSprite();
#endif
#endif

	PrintSceneInformation();

#if 1
	// Set the byte stream pointer
	SetByteStream(gLocations[gCurrentLocation].script);

	// And run the first set of commands for this scene
	HandleByteStream();
#endif

	BlitBufferToHiresWindow();

	//TrashFreeMemory();
}


void PlayerMove(unsigned char direction)
{
	location* locationPtr = &gLocations[gCurrentLocation];

	unsigned char requestedScene = gLocations[gCurrentLocation].directions[direction];
	if (requestedScene==e_LOCATION_NONE)
	{
		PrintErrorMessage("Impossible to move in that direction");
	}
	else
	{
		PlaySound(KeyClickHData);
		gCurrentLocation=requestedScene;
		LoadScene();
	}
}


WORDS ProcessContainerAnswer()
{
	// Check the first word: We expects a container id
	switch (gWordBuffer[0])
	{
	case e_ITEM_TobaccoTin:      // an empty tobacco tin
	case e_ITEM_Bucket:          // a wooden bucket
	case e_ITEM_CardboardBox:    // a cardboard box
	case e_ITEM_FishingNet:      // a fishing net
	case e_ITEM_PlasticBag:      // a plastic bag
	case e_ITEM_SmallBottle:   	 // a small bottle
		// We return the name of the object
		return gWordBuffer[0];

	default:
		// No idea what that is, but definitely not a container
		return e_WORD_QUIT;
	}
	// Continue
 	return e_WORD_CONTINUE;
}


void TakeItem(unsigned char itemId)
{
	if (itemId>e_ITEM_COUNT_)
	{
		PrintErrorMessage("You can only take something you see");
	}
	else
	{
		// The item is in the scene
		item* itemPtr=&gItems[itemId];
		if (itemPtr->location == e_LOCATION_INVENTORY)
		{
			PrintErrorMessage("You already have this item");
		}
		else
		if (itemPtr->location != gCurrentLocation)
		{
			PrintErrorMessage("I don't see this item here");
		}
		else
		if (itemPtr->flags & ITEM_FLAG_HEAVY)
		{
			PrintErrorMessage("This is too heavy");
		}
		else
		if (itemPtr->usable_containers)
		{
			// Requires a container
			WORDS containerId = AskInput("Carry it in what?",ProcessContainerAnswer);
			if (containerId == e_WORD_QUIT)
			{
				PrintErrorMessage("Don't be ridiculous");
			}
			else
			{
				item* containerPtr=&gItems[containerId];
				if (containerPtr->location != e_LOCATION_INVENTORY)
				{
					PrintErrorMessage("You don't have this container");  // Technically could be optimized at a later stage to automatically pick the item if it's in the scene
				}
				else
				if (containerPtr->associated_item != 255)
				{
					PrintErrorMessage("Sorry, that's full already");
				}
				else
				{
					// Looks like we have both the item and an empty container!
					itemPtr->location 			= e_LOCATION_INVENTORY;
					itemPtr->associated_item 	= containerId;

					containerPtr->associated_item = itemId;

					LoadScene();
				}
			}
		}
		else
		{
			// Can just be picked-up
			itemPtr->location = e_LOCATION_INVENTORY;
			LoadScene();
		}
	}
}


void DropItem(unsigned char itemId)
{
	if ( (itemId>e_ITEM_COUNT_) || (gItems[itemId].location!=e_LOCATION_INVENTORY) )
	{
		PrintErrorMessage("You can only drop something you have");
	}
	else
	{
		item* itemPtr=&gItems[itemId];
		if (itemPtr->flags & ITEM_FLAG_IS_CONTAINER)
		{
			// When the item is a container we need to drop both the container and the content
			item* containerPtr=itemPtr;
			itemId = containerPtr->associated_item;
			itemPtr = &gItems[itemId];

			// Put the container on the ground
			containerPtr->location        = gCurrentLocation;
		}

		if (itemPtr->associated_item != 255)
		{
			// Remove the item from the container
			item* containerPtr=&gItems[itemPtr->associated_item];
			containerPtr->associated_item = 255;
			itemPtr->associated_item      = 255;
		}

		if (itemPtr->flags & ITEM_FLAG_EVAPORATES)
		{
			// Special items like water of petrol go back to where they were or disappear
			if (itemId == e_ITEM_Water)
			{
				itemPtr->location = e_LOCATION_WELL;
				PrintInformationMessage("The water drains away");
			}
			else
			{
				itemPtr->location = 99;
				PrintInformationMessage("The petrol evaporates");
			}
		}
		else
		{
			// Normal items stay on the same location
			itemPtr->location        = gCurrentLocation;
		}		
		LoadScene();
	}
}


void Initializations()
{
	// erase the screen
	memset((char*)0xa000,0,8000);

	// Install the 50hz IRQ
	System_InstallIRQ_SimpleVbl();

 	// Setup the Hires/Text mixed graphic mode
	InitializeGraphicMode();      

	// Load the charset
	LoadFileAt(LOADER_FONT_6x8,0xb500);

	// Perform some initializations for the text display system
	ComputeFancyFontWidth();
	GenerateShiftBuffer();
	GenerateMul40Table();

#ifdef TESTING_MODE
	// Add here any change to the scenario to easily check things
	//gCurrentLocation =e_LOCATION_INSIDEHOLE;
	//gCurrentLocation =e_LOCATION_OUTSIDE_PIT;
	gCurrentLocation =e_LOCATION_WELL;
	gItems[e_ITEM_PlasticBag].location = e_LOCATION_INVENTORY;
#else
	// In normal gameplay, the player starts from the marketplace with an empty inventory
	gCurrentLocation = e_LOCATION_MARKETPLACE;
#endif	

	LoadScene();
	DisplayClock();

	ResetInput();
}


WORDS ProcessAnswer()
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
		// Quit
		return e_WORD_QUIT;
		break;

	default:
		PlaySound(PingData);
		break;
	}
	// Continue
 	return e_WORD_CONTINUE;
}


WORDS AskInput(const char* inputMessage,AnswerProcessingFun callback)
{
	int k;
	int shift=0;

	ResetInput();	
	while (1)
	{
		if (gAskQuestion)
		{
			PrintStatusMessage(2,inputMessage);
			memset((char*)0xbb80+40*23+1,' ',39);
			gAskQuestion=0;
		}

		do
		{
			WaitIRQ();
			HandleByteStream();
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
				WORDS answer = callback();
				if (answer !=e_WORD_CONTINUE)
				{
					// Quit
					return answer;
				}
				else
				{
					// Continue
					ResetInput();
					gAskQuestion = 1;
				}
			}
			else
			{
				// No word recognized
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
}


void main()
{
	Initializations();	

	AskInput("What are you going to do now?",ProcessAnswer);

	// Just to let the last click sound to keep playing
	WaitFrames(4);

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the intro
	InitializeFileAt(LOADER_INTRO_PROGRAM,0x400);
}

