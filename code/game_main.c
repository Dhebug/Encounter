//
// EncounterHD - Main Game
// (c) 2020-2024 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"

#include "game_defines.h"
#include "input_system.h"

extern int gScore;          // Moved to the last 32 bytes so it can be shared with the other modules




void PrintSceneDirections()
{
	unsigned char* directions = gCurrentLocationPtr->directions;
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
    PrintTopDescription(gCurrentLocationPtr->description);

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

	ClearMessageWindow(16+4);

#if 1
	LoadFileAt(LOADER_PICTURE_LOCATIONS_START+gCurrentLocation+1,ImageBuffer);	
#else
	memset(ImageBuffer,64+1,40*128);
#endif	

	// Set the byte stream pointer
	SetByteStream(gCurrentLocationPtr->script);

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
	if (requestedScene==e_LOCATION_NONE)
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


WORDS ProcessContainerAnswer()
{
    return gWordBuffer[0];
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
    if (itemPtr->location == e_LOCATION_INVENTORY)
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
            if (containerPtr->location != e_LOCATION_INVENTORY)
            {
                // We do not have this container...
                if (containerPtr->location!=gCurrentLocation)
                {
                    PrintErrorMessage(gTextErrorMissingContainer);  // "You don't have this container" 
                    return;
                }
                // But it's on the scene, so we pick-it up automatically
                containerPtr->location = e_LOCATION_INVENTORY;
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
    itemPtr->location = e_LOCATION_INVENTORY;    // The item is now in our inventory
    itemPtr->flags   &= ~ITEM_FLAG_ATTACHED;     // If the item was attached, we detach it
    switch (itemId)
    {
    case e_ITEM_Rope:
        itemPtr->description = gTextItemRope;
        break;
    case e_ITEM_Ladder:
        itemPtr->description = gTextItemLadder;
        break;
    case e_ITEM_LargeDove:
        itemPtr->description = gTextItemLargeDove;
        break;
    }
    LoadScene();
}


void DropItem()
{
    unsigned char itemId = gWordBuffer[1];
	if ( (itemId>e_ITEM_COUNT_) || (gItems[itemId].location!=e_LOCATION_INVENTORY) )
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

		if (itemPtr->flags & ITEM_FLAG_EVAPORATES)
		{
			// Special items like water of petrol go back to where they were or disappear
			if (itemId == e_ITEM_Water)
			{
				itemPtr->location = e_LOCATION_WELL;
				PrintInformationMessage(gTextWaterDrainsAways);  // "The water drains away"
			}
			else
			{
				itemPtr->location = 99;
				PrintInformationMessage(gTextPetrolEvaporates);  // "The petrol evaporates"
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

char ItemCheck(unsigned char itemId)
{
	if (itemId<e_ITEM_COUNT_)
    {
        if ( (gItems[itemId].location==e_LOCATION_INVENTORY) || (gItems[itemId].location==gCurrentLocation) )
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





void Kill()
{
    unsigned char itemId=gWordBuffer[1];
    item* itemPtr=&gItems[itemId];
    if (itemPtr->location != gCurrentLocation)
    {
        PrintErrorMessage(gTextErrorItsNotHere);   // "It's not here"
    }
    else
    if (itemPtr->flags & ITEM_FLAG_DISABLED)
    {
        PrintErrorMessage(gTextErrorAlreadyDealtWith);  // "Not a problem anymore"
    }
    else
    {
        // Normally we should ask how, check the weapon, etc...
        // Right now it's just to check things
        switch (itemId)
        {
        case e_ITEM_Thug:
            gScore+=50;
            itemPtr->flags|=ITEM_FLAG_DISABLED;
            itemPtr->description=gTextDeadThug;   // "a dead thug";
            LoadScene();
            break;

        case e_ITEM_YoungGirl:
            PrintErrorMessage(gTextErrorShouldSaveGirl);  // "You are supposed to save her"
            break;
        }
    }
}



#ifdef ENABLE_CHEATS
void Revive()
{
    unsigned char itemId=gWordBuffer[1];
    item* itemPtr=&gItems[itemId];
    if (itemPtr->location != gCurrentLocation)
    {
        PrintErrorMessage(gTextErrorItsNotHere);   // "It's not here"
    }
    else
    if (!(itemPtr->flags & ITEM_FLAG_DISABLED))
    {
        PrintErrorMessage(gTextNotDead);    // "Not dead"
    }
    else
    {
        // We revive the characters to debug and test  more easily
        switch (itemId)
        {
        case e_ITEM_Thug:
            itemPtr->flags&=~ITEM_FLAG_DISABLED;
            itemPtr->description=gTextThugAsleepOnBed;     // "a thug asleep on the bed";
            LoadScene();
            break;

        case e_ITEM_AlsatianDog:
            itemPtr->flags&=~ITEM_FLAG_DISABLED;
            itemPtr->description=gTextDogGrowlingAtYou;     // "an alsatian growling at you"
            LoadScene();
            break;
        }
    }
}

void Tickle()
{
    unsigned char itemId=gWordBuffer[1];
    item* itemPtr=&gItems[itemId];
    if (itemPtr->location != gCurrentLocation)
    {
        PrintErrorMessage(gTextErrorItsNotHere);   // "It's not here"
    }
    else
    if (itemPtr->flags & ITEM_FLAG_DISABLED)
    {
        PrintErrorMessage(gTextErrorDeadDontMove);  // "Dead don't move"
    }
    else
    {
        // The tickling is just a way to trigger the attack sequence
        switch (itemId)
        {
        case e_ITEM_Thug:
            gCurrentLocationPtr->script = gDescriptionThugAttacking;
            itemPtr->description=gTextThugShootingAtMe;    // "a thug shooting at me"
            UnlockAchievement(ACHIEVEMENT_SHOT_BY_THUG);
            LoadScene();
            break;

        case e_ITEM_AlsatianDog:
            gCurrentLocationPtr->script = gDescriptionDogAttacking;
            itemPtr->description=gTextDogJumpingAtMe;     // "a dog jumping at me"
            UnlockAchievement(ACHIEVEMENT_MAIMED_BY_DOG);
            LoadScene();
            break;

        case e_ITEM_YoungGirl:
            PrintErrorMessage(gTextErrorInappropriate);   // "Probably impropriate"
            break;
        }
    }
}

void Invoke()
{
    // Wherever they are, give a specific item to the user
    unsigned char itemId=gWordBuffer[1];
    item* itemPtr=&gItems[itemId];
    itemPtr->location = e_LOCATION_INVENTORY;
    LoadScene();            
}
#endif    


#define COMBINATOR(firstItem,secondItem)    ((firstItem&255)|((secondItem&255)<<8))

void CombineItems()
{
    unsigned char firstItemId     = gWordBuffer[1];
    unsigned char secondaryItemId = gWordBuffer[2];
	if (ItemCheck(firstItemId) && ItemCheck(secondaryItemId))
    {
        switch (COMBINATOR(firstItemId,secondaryItemId))
        {
        case COMBINATOR(e_ITEM_Meat,e_ITEM_SedativePills):
        case COMBINATOR(e_ITEM_SedativePills,e_ITEM_Meat):
            {    
                gItems[e_ITEM_SedativePills].location = e_LOCATION_GONE_FOREVER;       // The sedative are gone from the game
                gItems[e_ITEM_Meat].flags |= ITEM_FLAG_TRANSFORMED;                    // We now have some drugged meat in our inventory
                gItems[e_ITEM_Meat].description = gTextItemSedativeLacedMeat;
                UnlockAchievement(ACHIEVEMENT_DRUGGED_THE_MEAT);
                LoadScene();
            }
            break;

        default:
            PrintErrorMessage(gTextErrorDontKnowUsage);   // "I don't know how to use that"
            break;
        }
    }
}


void OpenItem()
{
    unsigned char itemId = gWordBuffer[1];
	if (ItemCheck(itemId))
    {
        item* currentItem = &gItems[itemId];
        switch (itemId)
        {
        case e_ITEM_Curtain:
            {    
                if (currentItem->flags & ITEM_FLAG_CLOSED)
                {
                    currentItem->description = gTextItemOpenedCurtain;
                    currentItem->flags &= ~ITEM_FLAG_CLOSED;
                    gCurrentLocationPtr->directions[e_DIRECTION_NORTH]=e_LOCATION_PADLOCKED_ROOM;                   
                    UnlockAchievement(ACHIEVEMENT_OPENED_THE_CURTAIN);
                    LoadScene();
                    return;
                }
            }
            break;

        case e_ITEM_Fridge:
            {    
                if (currentItem->flags & ITEM_FLAG_CLOSED)
                {
                    currentItem->description = gTextItemOpenFridge;
                    currentItem->flags &= ~ITEM_FLAG_CLOSED;

                    currentItem = &gItems[e_ITEM_Meat];
                    if (currentItem->location==e_LOCATION_NONE)
                    {
                        // If the meat was in the fridge, we now have it inside the kitchen
                        currentItem->location=e_LOCATION_KITCHEN;
                    }
                    UnlockAchievement(ACHIEVEMENT_OPENED_THE_FRIDGE);
                    LoadScene();
                    return;
                }
            }
            break;

        case e_ITEM_Medicinecabinet:
            {    
                if (currentItem->flags & ITEM_FLAG_CLOSED)
                {
                    currentItem->description = gTextItemOpenMedicineCabinet;
                    currentItem->flags &= ~ITEM_FLAG_CLOSED;

                    currentItem = &gItems[e_ITEM_SedativePills];
                    if (currentItem->location==e_LOCATION_NONE)
                    {
                        // If the meat was in the fridge, we now have it inside the kitchen
                        currentItem->location=e_LOCATION_KITCHEN;
                    }
                    UnlockAchievement(ACHIEVEMENT_OPENED_THE_CABINET);
                    LoadScene();
                    return;
                }
            }
            break;
        }
        PrintErrorMessage(gTextErrorCannotDo);   // "I can't do that"
    }
}


void ReadItem()
{
    unsigned char itemId = gWordBuffer[1];
	if (ItemCheck(itemId))
    {
        DispatchStream(gReadItemMappingsArray,itemId);
	}
}


void CloseItem()
{
    unsigned char itemId = gWordBuffer[1];
	if (ItemCheck(itemId))
    {
        DispatchStream(gCloseItemMappingsArray,itemId);
    }
}


void InspectItem()
{
    unsigned char itemId = gWordBuffer[1];    
	if (ItemCheck(itemId))
    {
        DispatchStream(gInspectItemMappingsArray,itemId);
	}
}


void UseItem()
{
    unsigned char itemId = gWordBuffer[1];    
	if (ItemCheck(itemId))
    {
        DispatchStream(gUseItemMappingsArray,itemId);
	}
}


void Frisk()
{
    unsigned char itemId = gWordBuffer[1];    
	if (ItemCheck(itemId))
    {
        DispatchStream(gSearchtemMappingsArray,itemId);
	}
}


void ThrowItem()
{
    unsigned char itemId = gWordBuffer[1];
	if (ItemCheck(itemId))
    {
        DispatchStream(gThrowItemMappingsArray,itemId);
	}
}



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
            // call the callback
            actionMappingPtr->function();
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
	//gCurrentLocation =e_LOCATION_INSIDEHOLE;
	gCurrentLocation =e_LOCATION_OUTSIDE_PIT;
    gItems[e_ITEM_Rope].location = e_LOCATION_INVENTORY;
    gItems[e_ITEM_Ladder].location          = e_LOCATION_INVENTORY;
    //gItems[e_ITEM_LadderInTheHole].location = e_LOCATION_OUTSIDE_PIT;
	//gCurrentLocation =e_LOCATION_WELL;
	//gCurrentLocation =e_LOCATION_ENTRANCEHALL;
	//gCurrentLocation =e_LOCATION_LAWN;
	//gCurrentLocation =e_LOCATION_MASTERBEDROOM;
	////gCurrentLocation =e_LOCATION_MARKETPLACE;
	//gCurrentLocation =e_LOCATION_NARROWPATH;
    //gCurrentLocation = e_LOCATION_LIBRARY;
	//gItems[e_ITEM_PlasticBag].location = e_LOCATION_INVENTORY;

    gItems[e_ITEM_ChemistryBook].location          = e_LOCATION_INVENTORY;
    gCurrentLocation =e_LOCATION_LIBRARY;
    
#else
	// In normal gameplay, the player starts from the marketplace with an empty inventory
	gCurrentLocation = e_LOCATION_MARKETPLACE;
#endif	

	gScore = 0;
    gCurrentStream = 0;
    gDelayStream = 0;

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

