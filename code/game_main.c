//
// EncounterHD - Main Game
// (c) 2020-2024 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"

#include "game_defines.h"
#include "input_system.h"

extern int gScore;          // Moved to the last 32 bytes so it can be shared with the other modules
extern unsigned char gGameOverCondition;        // Moved to the last 32 bytes so it can be shared with the other modules




void PrintSceneDirections()
{
	unsigned char* directions = gCurrentLocationPtr->directions;
	int direction;

	gFlagDirections = 0;
	for (direction=0;direction<e_DIRECTION_COUNT_;direction++)
	{
		if (directions[direction]!=e_LOC_NONE)
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
		if (itemPtr->location == e_LOC_INVENTORY)
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
        const char* ptrMessage=gTextCanSee;
		char* ptrScreen=(char*)0xbb80+40*18;
		for (item=0;item<e_ITEM_COUNT_;item++)
		{
			if (gItems[item].location == gCurrentLocation)
			{
				sprintf(ptrScreen+1,"%c%s%s",3,ptrMessage,gItems[item].description); // "I can see"
                ptrMessage="";
				ptrScreen+=40;
			}
		}
	}
	else
	{
		sprintf((char*)0xbb80+40*18+1,"%c%s",3,gTextNothingHere);  // "There is nothing of interest here"
	}
}


void PrintSceneInformation()
{
	// Print the description of the place at the top (centered)
    PrintTopDescription(gDescription);  //gCurrentLocationPtr->description);

    // The redefined charcters to draw the bottom part of the directional arrows \v/
	poke(0xbb80+16*40+16,9);                      // ALT charset
	memcpy((char*)0xbb80+16*40+17,";<=>?@",6);

    // Display the score
	sprintf((char*)0xbb80+16*40+1,"%c%s%d%c",4,gTextScore,gScore,7);   // "Score:"

	PrintSceneDirections();

	PrintSceneObjects();

	PrintInventory();
}


void LoadScene()
{
	gCurrentLocationPtr = &gLocations[gCurrentLocation];
	// Set the byte stream pointer
	SetByteStream(gCurrentLocationPtr->script);
    gSceneImage = LOADER_PICTURE_LOCATIONS_START+gCurrentLocation;
    
	ClearMessageWindow(16+4);

#if 1
	LoadFileAt(gSceneImage,ImageBuffer);	
#else
	memset(ImageBuffer,64+1,40*128);
#endif	

	// And run the first set of commands for this scene
	HandleByteStream();

    // We need to print the scene information *after* the script has been launched, else the moved items will not appear until the next refresh
	PrintSceneInformation();

	BlitBufferToHiresWindow();

	//TrashFreeMemory();
}


void PlayerMove()
{
    unsigned char direction = gWordBuffer[0]-e_WORD_NORTH;
	unsigned char requestedScene = gCurrentLocationPtr->directions[direction];
	if (requestedScene==e_LOC_NONE)
	{
		PrintErrorMessage(gTextErrorInvalidDirection);   // "Impossible to move in that direction"
	}
	else
	{
		PlaySound(KeyClickHData);
		gCurrentLocation=requestedScene;
		LoadScene();
	}
}


WORDS AskInputCallback()
{
    HandleByteStream();
    if ( (gGameOverCondition!=0) && (gCurrentStream==0) )
    {
        // The player has reached a game over condition and the end of the current stream
        return e_WORD_QUIT;
    }
    return e_WORD_CONTINUE;
}

WORDS ProcessContainerAnswer()
{
    return gWordBuffer[0];
}

char ProcessFoundToken(WORDS wordId)
{
    if (wordId < e_ITEM_COUNT_)
    {
        // It's an item
        if (gItems[wordId].location == e_LOC_INVENTORY)
        {
            return 1;
        }
        if (gItems[wordId].location == gCurrentLocation)
        {
            return 1;
        }
    }
    else
    {
        return 1;
    }
    return 0;
}


char ItemCheck(unsigned char itemId)
{
	if (itemId<e_ITEM_COUNT_)
    {
        if ( (gItems[itemId].location==e_LOC_INVENTORY) || (gItems[itemId].location==gCurrentLocation) )
        {
            return 1;
        }
        else
        {
            PrintErrorMessage(gTextErrorItemNotPresent);   // "This item does not seem to be present"
        }
    }
    else
	{
		PrintErrorMessage(gTextErrorUnknownItem);   // "I do not know what this item is"
	}
    return 0; // Cannot use
}

void TakeItem()
{
    unsigned char itemId = gWordBuffer[1];
    item* itemPtr=&gItems[itemId];
	if (itemId>=e_ITEM_COUNT_)
	{
		PrintErrorMessage(gTextErrorCantTakeNoSee);   // "You can only take something you see"
        return;
	}

    // The item is in the scene
    if (itemPtr->location == e_LOC_INVENTORY)
    {
        PrintErrorMessage(gTextErrorAlreadyHaveItem);    // "You already have this item"
        return;
    }
    
    if (itemPtr->flags & ITEM_FLAG_IMMOVABLE)
    {
        PrintErrorMessage(gTextErrorCannotDo);   // "I can't do it");
        return;
    }

    if (itemPtr->usable_containers)
    {
        // Requires a container
        WORDS containerId = AskInput(gTextCarryInWhat,ProcessContainerAnswer,1 );    // "Carry it in what?"
        if ( (containerId >= e_ITEM__Last_Container) || (!(itemPtr->usable_containers & (1<<containerId))) )
        {
            PrintErrorMessage(gTextErrorRidiculous);    // "Don't be ridiculous"
            return;
        }
        else
        {
            item* containerPtr=&gItems[containerId];
            if (containerPtr->location != e_LOC_INVENTORY)
            {
                // We do not have this container...
                if (containerPtr->location!=gCurrentLocation)
                {
                    PrintErrorMessage(gTextErrorMissingContainer);  // "You don't have this container" 
                    return;
                }
                // But it's on the scene, so we pick-it up automatically
                containerPtr->location = e_LOC_INVENTORY;
            }

            if (containerPtr->associated_item != 255)
            {
                PrintErrorMessage(gTextErrorAlreadyFull);    // "Sorry, that's full already"
                return;
            }

            // Looks like we have both the item and an empty container!
            itemPtr->associated_item 	  = containerId;
            containerPtr->associated_item = itemId;
        }
    }

    // Common part for all items (in containers or not)
    DispatchStream(gTakeItemMappingsArray,itemId);
}


void DropItem()
{
    unsigned char itemId = gWordBuffer[1];
	if ( (itemId>e_ITEM_COUNT_) || (gItems[itemId].location!=e_LOC_INVENTORY) )
	{
		PrintErrorMessage(gTextErrorDropNotHave);  // "You can only drop something you have"
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

        // Execute the steam to perform any item specific operation
        if (ItemCheck(itemId))
        {
            DispatchStream(gDropItemMappingsArray,itemId);
        }
	}
}



#ifdef ENABLE_CHEATS
void Invoke()
{
    // Wherever they are, give a specific item to the user
    unsigned char itemId=gWordBuffer[1];
    item* itemPtr=&gItems[itemId];
    itemPtr->location = e_LOC_INVENTORY;
    LoadScene();            
}
#endif    


WORDS ProcessAnswer()
{
	// Check the first word
    action_mapping* actionMappingPtr = gActionMappingsArray;
    unsigned char actionId=gWordBuffer[0];
    if (actionId==e_WORD_QUIT)
    {
		// Quit the game
		PlaySound(KeyClickHData);
        UnlockAchievement(ACHIEVEMENT_GAVE_UP);
		return e_WORD_QUIT;
    }

    while (actionMappingPtr->id!=e_WORD_COUNT_)
    {
        if (actionMappingPtr->id==actionId)
        {            
            unsigned char flags = actionMappingPtr->flag;
            if (flags & FLAG_MAPPING_STREAM)
            {
                // Run the stream
                unsigned char itemId = gWordBuffer[1];
                if (ItemCheck(itemId))
                {
                    if (flags & FLAG_MAPPING_TWO_ITEMS)
                    {
                        unsigned char itemId2 = gWordBuffer[2];
                        if (ItemCheck(itemId2))
                        {
                            DispatchStream2(actionMappingPtr->u.stream,itemId,itemId2);
                        }
                    }
                    else
                    {
                        DispatchStream(actionMappingPtr->u.stream,itemId);
                    }
                }
            }
            else
            {
                // call the callback
                actionMappingPtr->u.function();
            }

            // Test for game over
            if (gGameOverCondition!=0)
            {
                // The player has reached a game over condition
                return e_WORD_QUIT;
            }

            // Continue
            return e_WORD_CONTINUE;
        }
        actionMappingPtr++;
    }

	// Not recognized: Warn the player and continue
	PlaySound(PingData);
 	return e_WORD_CONTINUE;
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
	//gCurrentLocation =e_LOC_INSIDE_PIT;
	//gCurrentLocation =e_LOC_OUTSIDE_PIT;
    //gItems[e_ITEM_Rope].location           = e_LOC_INVENTORY;
    //gItems[e_ITEM_Rope].flags |= ITEM_FLAG_ATTACHED;

    //gItems[e_ITEM_Ladder].location           = e_LOC_INVENTORY;

	//gCurrentLocation =e_LOC_WELL;
	//gCurrentLocation =e_LOC_ENTRANCEHALL;
	//gCurrentLocation =e_LOC_LAWN;
	//gCurrentLocation =e_LOC_MASTERBEDROOM;
	////gCurrentLocation =e_LOC_MARKETPLACE;
	//gCurrentLocation =e_LOC_EASTERN_ROAD;
    //gCurrentLocation = e_LOC_LIBRARY;
	//gItems[e_ITEM_PlasticBag].location = e_LOC_INVENTORY;

    //gItems[e_ITEM_ChemistryBook].location          = e_LOC_INVENTORY;
    //gItems[e_ITEM_AlsatianDog].location          = e_LOC_LARGE_STAIRCASE;
    /*
    gCurrentLocation = e_LOC_ENTRANCEHALL; // e_LOC_LARGE_STAIRCASE; // 40; //e_LOC_EASTERN_ROAD; //e_LOC_WELL; e_LOC_LIBRARY;
    gItems[e_ITEM_Meat].location = e_LOC_INVENTORY;  // Instead we now have some drugged meat in our inventory    
    gItems[e_ITEM_Meat].flags |= ITEM_FLAG_TRANSFORMED;   // The drug is 
    gItems[e_ITEM_Meat].description = gTextItemSedativeLacedMeat;

    gItems[e_ITEM_SilverKnife].location           = e_LOC_INVENTORY;
    gItems[e_ITEM_SnookerCue].location           = e_LOC_INVENTORY;
    */

   /*
   gCurrentLocation = e_LOC_WOODEDAVENUE;
   gItems[e_ITEM_CardboardBox].location = e_LOC_INVENTORY;
   gItems[e_ITEM_FishingNet].location   = e_LOC_INVENTORY;
   */
   //gCurrentLocation = e_LOC_ENTRANCEHALL;  //e_LOC_KITCHEN;
   gCurrentLocation = e_LOC_DARKCELLARROOM;  //e_LOC_DARKCELLARROOM;
#else
	// In normal gameplay, the player starts from the marketplace with an empty inventory
	gCurrentLocation = e_LOC_MARKETPLACE;
#endif	

	gScore = 0;
    gCurrentStream = 0;
    gDelayStream = 0;
    gGameOverCondition = 0;

	LoadScene();
	DisplayClock();

	ResetInput();
}


void main()
{
    UnlockAchievement(ACHIEVEMENT_LAUNCHED_THE_GAME);

	Initializations();	

#ifdef ENABLE_GAME
	AskInput(gTextAskInput,ProcessAnswer,1);
#endif

    // Clear the bottom of the screen
    memset(0xbb80+40*17,16+0,40*11);        // Bottom half
    poke(0xbb80+40*16+1,3);                 // Highlighte the score
    
	// Just to let the last click sound to keep playing
	WaitFrames(4);

	System_RestoreIRQ_SimpleVbl();

	// Quit and go to the high scores/credits
	InitializeFileAt(LOADER_OUTRO_PROGRAM,0x400);
}

