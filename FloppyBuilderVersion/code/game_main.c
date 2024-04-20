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


WORDS ProcessPlayerNameAnswer()
{
	// We accept anything, it's the player name so...
	return e_WORD_QUIT;
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

void MoveObjectsIfNecessary()
{
    switch (gCurrentLocation)
    {
    case e_LOCATION_ENTRANCEHALL:
        if (gItems[e_ITEM_AlsatianDog].location==e_LOCATION_LARGE_STAIRCASE)
        {
            gItems[e_ITEM_AlsatianDog].location=e_LOCATION_ENTRANCEHALL;
        }
        break;

    case e_LOCATION_LARGE_STAIRCASE:
        if (gItems[e_ITEM_AlsatianDog].location==e_LOCATION_ENTRANCEHALL)
        {
            gItems[e_ITEM_AlsatianDog].location=e_LOCATION_LARGE_STAIRCASE;
            if (! (gItems[e_ITEM_AlsatianDog].flags&ITEM_FLAG_DISABLED))
            {
                gItems[e_ITEM_AlsatianDog].description=gTextDogJumpingAtMe;
            }
        }
        break;

    case e_LOCATION_OUTSIDE_PIT:
        if ( (gItems[e_ITEM_Rope].location==e_LOCATION_INSIDEHOLE) && (gItems[e_ITEM_Rope].flags & ITEM_FLAG_ATTACHED))
        {
            gItems[e_ITEM_Rope].location=e_LOCATION_OUTSIDE_PIT;
        }
        if ( (gItems[e_ITEM_Ladder].location==e_LOCATION_INSIDEHOLE))
        {
            gItems[e_ITEM_Ladder].location=e_LOCATION_OUTSIDE_PIT;
        }
        break;

    case e_LOCATION_INSIDEHOLE:
        if ( (gItems[e_ITEM_Rope].location==e_LOCATION_OUTSIDE_PIT) && (gItems[e_ITEM_Rope].flags & ITEM_FLAG_ATTACHED))
        {
            gItems[e_ITEM_Rope].location=e_LOCATION_INSIDEHOLE;
        }
        if ( (gItems[e_ITEM_Ladder].location==e_LOCATION_OUTSIDE_PIT) && (gItems[e_ITEM_Ladder].flags & ITEM_FLAG_ATTACHED))
        {
            gItems[e_ITEM_Ladder].location=e_LOCATION_INSIDEHOLE;
        }
        break;
    
    default:
        break;
    }
}


void LoadScene()
{
	gCurrentLocationPtr = &gLocations[gCurrentLocation];
    MoveObjectsIfNecessary();

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
	SetByteStream(gCurrentLocationPtr->script);

	// And run the first set of commands for this scene
	HandleByteStream();
#endif

	BlitBufferToHiresWindow();

	//TrashFreeMemory();
}


void PlayerMove(unsigned char direction)
{
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
	if (itemId>=e_ITEM_COUNT_)
	{
		PrintErrorMessage(gTextErrorCantTakeNoSee);   // "You can only take something you see"
	}
	else
	{
		// The item is in the scene
		item* itemPtr=&gItems[itemId];
        item* itemAliasPtr=itemPtr;

		if (itemPtr->location == e_LOCATION_INVENTORY)
		{
			PrintErrorMessage(gTextErrorAlreadyHaveItem);    // "You already have this item"
            return;
		}
		
		if (itemPtr->location != gCurrentLocation)
		{
            int itemAlias;
            for (itemAlias=0;itemAlias<e_ITEM_COUNT_;itemAlias++)
            {
                itemAliasPtr=&gItems[itemAlias];
                if (itemAliasPtr->location==gCurrentLocation)
                {
                    break;
                }
            }
            if (itemAlias == e_ITEM_COUNT_)
            {
    			PrintErrorMessage(gTextErrorCantTakeNoSee);   // "I don't see this item here");
                return;
            }
		}
		

		if (itemPtr->flags & ITEM_FLAG_IMMOVABLE)
		{
			PrintErrorMessage(gTextErrorCannotDo);   // "I can't do it");
		}
		else
		if (itemPtr->usable_containers)
		{
			// Requires a container
			WORDS containerId = AskInput(gTextCarryInWhat,ProcessContainerAnswer,1 );    // "Carry it in what?"
			if (containerId == e_WORD_QUIT)
			{
				PrintErrorMessage(gTextErrorRidiculous);    // "Don't be ridiculous"
			}
			else
			{
				item* containerPtr=&gItems[containerId];
				if (containerPtr->location != e_LOCATION_INVENTORY)
				{
					PrintErrorMessage(gTextErrorMissingContainer);  // "You don't have this container" - Technically could be optimized at a later stage to automatically pick the item if it's in the scene
				}
				else
				if (containerPtr->associated_item != 255)
				{
					PrintErrorMessage(gTextErrorAlreadyFull);    // "Sorry, that's full already"
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
			itemAliasPtr->location = e_LOCATION_NONE;          // Can actually be the same pointer, literaly aliasing!
			itemPtr->location      = e_LOCATION_INVENTORY;     // Which means that one should be done after
            itemPtr->flags &= ~ITEM_FLAG_ATTACHED;             // If the item was attached, we detach it
            switch (itemId)
            {
            case e_ITEM_Rope:
                itemPtr->description = gTextItemRope;
                break;
            case e_ITEM_Ladder:
                itemPtr->description = gTextItemLadder;
                break;
            }
			LoadScene();
		}
	}
}


void DropItem(unsigned char itemId)
{
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

void ReadItem(unsigned char itemId)
{
	if (ItemCheck(itemId))
    {
        switch (itemId)
        {
        case e_ITEM_Newspaper:
            PlayStream(gSceneActionReadNewsPaper);
            LoadScene();
            break;

        case e_ITEM_HandWrittenNote:
            PlayStream(gSceneActionReadHandWrittenNote);
            LoadScene();
            break;

        case e_ITEM_ChemistryBook:
            PlayStream(gSceneActionReadChemistryBook);
            if (gItems[e_ITEM_ChemistryRecipes].location==e_LOCATION_NONE)
            {
                // If the recipes were not yet found, they now appear at the current location
                gItems[e_ITEM_ChemistryRecipes].location = gCurrentLocation;
            }
            LoadScene();
            break;

        case e_ITEM_ChemistryRecipes:
            PlayStream(gSceneActionReadChemistryRecipes);
            LoadScene();
            break;

        case e_ITEM_PlasticBag:
            PrintErrorMessage(gTextAGenericWhiteBag);    // "It's just a white generic bag"
            break;

        default:
            PrintErrorMessage(gTextErrorCannotRead);     // "I can't read that"
            break;
        }
	}
}


void ActionClimbLadder()
{    
    char ladderLocation = gItems[e_ITEM_Ladder].location;
    if (gCurrentLocation == e_LOCATION_INSIDEHOLE)
    {
        gItems[e_ITEM_Ladder].location           = e_LOCATION_INSIDEHOLE;       // The ladder stays inside the hole
        if (ladderLocation == e_LOCATION_INVENTORY)
        {
            PrintInformationMessage(gTextPositionLadder);  // "You position the ladder properly"
            LoadScene();
            WaitFrames(50*1);
        }
        PrintInformationMessage(gTextClimbUpLadder);   // "You climb up the ladder"
        WaitFrames(50*1);
        gCurrentLocation = e_LOCATION_OUTSIDE_PIT;
        LoadScene();
    }
    else
    if (gCurrentLocation == e_LOCATION_OUTSIDE_PIT)
    {
        gItems[e_ITEM_Ladder].location           = e_LOCATION_INSIDEHOLE;       // The ladder stays inside the hole
        if (ladderLocation == e_LOCATION_INVENTORY)
        {
            PrintInformationMessage(gTextPositionLadder);  // "You position the ladder properly"
            LoadScene();
            WaitFrames(50*1);
        }
        PrintInformationMessage(gTextClimbDownLadder);   // "You climb down the ladder"
        WaitFrames(50*1);
        gCurrentLocation = e_LOCATION_INSIDEHOLE;
        LoadScene();
    }
    else
    {
        PrintErrorMessage(gTextErrorCannotUseHere);    // "I can't use it here"
    }
}


void ActionClimbRope()
{    
    char ropeLocation = gItems[e_ITEM_Rope].location;
    if (gCurrentLocation == e_LOCATION_INSIDEHOLE)
    {
        if ( (gItems[e_ITEM_Rope].location == e_LOCATION_INSIDEHOLE) && (gItems[e_ITEM_Rope].flags & ITEM_FLAG_ATTACHED) )
        {
            gItems[e_ITEM_Rope].location           = e_LOCATION_OUTSIDE_PIT;
            PrintInformationMessage(gTextClimbUpRope);    // "You climb up the rope"
            WaitFrames(50*1);
            gCurrentLocation = e_LOCATION_OUTSIDE_PIT;
            LoadScene();
        }
        else
        {
            PrintErrorMessage(gTextErrorCannotAttachRope);   // "You can't attach the rope"
        }
    }
    else
    if (gCurrentLocation == e_LOCATION_OUTSIDE_PIT)
    {
        gItems[e_ITEM_Rope].location           = e_LOCATION_OUTSIDE_PIT;
        gItems[e_ITEM_Rope].flags |= ITEM_FLAG_ATTACHED;
        if (ropeLocation == e_LOCATION_INVENTORY)
        {
            PrintInformationMessage(gTextAttachRopeToTree);   // "You attach the rope to the tree"
            LoadScene();
            WaitFrames(50*1);
        }
        PrintInformationMessage(gTextClimbDownRope);   // "You climb down the rope"
        WaitFrames(50*1);
        gCurrentLocation = e_LOCATION_INSIDEHOLE;
        LoadScene();
    }
    else
    {
        PrintErrorMessage(gTextErrorCannotUseHere);   // "I can't use it here"
    }
}

void UseItem(unsigned char itemId)
{
	if (ItemCheck(itemId))
    {
        switch (itemId)
        {
        case e_ITEM_Ladder:
            {    
                if ( (gCurrentLocation == e_LOCATION_OUTSIDE_PIT) || (gCurrentLocation == e_LOCATION_INSIDEHOLE) )
                {
                    char ladderLocation = gItems[e_ITEM_Ladder].location;
                    if (ladderLocation == e_LOCATION_INVENTORY)
                    {
                        PrintInformationMessage(gTextPositionLadder);  // "You position the ladder properly"
                        gItems[e_ITEM_Ladder].location = e_LOCATION_OUTSIDE_PIT;        // The ladder stays inside the hole
                        gItems[e_ITEM_Ladder].flags |= ITEM_FLAG_ATTACHED;              // The ladder is ready to be used
                        gItems[e_ITEM_Ladder].description = gTextItemLadderInTheHole;
                        LoadScene();
                    }
                    else
                    if (ladderLocation == e_LOCATION_INSIDEHOLE)
                    {
                        PrintErrorMessage(gTextErrorLadderInHole);  // "The ladder is already in the hole"
                    }
                }
                else
                {
                    PrintErrorMessage(gTextErrorCannotUseHere);   // "I can't use it here"
                }
            }
            break;

        case e_ITEM_Rope:
            ActionClimbRope();
            break;

        case e_ITEM_HandheldGame:
            PlayStream(gSceneActionPlayGame);
			LoadScene();
            break;

        default:
            PrintErrorMessage(gTextErrorDontKnowUsage);   // "I don't know how to use that"
            break;
        }
    }
}


#define COMBINATOR(firstItem,secondItem)    ((firstItem&255)|((secondItem&255)<<8))

void CombineItems(unsigned char firstItemId,unsigned char secondaryItemId)
{
	if (ItemCheck(firstItemId) && ItemCheck(secondaryItemId))
    {
        switch (COMBINATOR(firstItemId,secondaryItemId))
        {
        case COMBINATOR(e_ITEM_Meat,e_ITEM_SedativePills):
        case COMBINATOR(e_ITEM_SedativePills,e_ITEM_Meat):
            {    
                gItems[e_ITEM_SedativePills].location = e_LOCATION_GONE_FOREVER;       // The sedative are gone from the game
                gItems[e_ITEM_Meat].flags |= ITEM_FLAG_TRANSFORMED;                    // We now have some drugged meat in our inventory
                LoadScene();
            }
            break;

        default:
            PrintErrorMessage(gTextErrorDontKnowUsage);   // "I don't know how to use that"
            break;
        }
    }
}


void OpenItem(unsigned char itemId)
{
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
                    LoadScene();
                    return;
                }
            }
            break;
        }
        PrintErrorMessage(gTextErrorCannotDo);   // "I can't do that"
    }
}


void CloseItem(unsigned char itemId)
{
	if (ItemCheck(itemId))
    {
        item* currentItem = &gItems[itemId];
        switch (itemId)
        {
        case e_ITEM_Curtain:
            {    
                if (!(currentItem->flags & ITEM_FLAG_CLOSED))
                {
                    currentItem->description = gTextItemOpenedCurtain;
                    currentItem->flags |= ITEM_FLAG_CLOSED;
                    gCurrentLocationPtr->directions[e_DIRECTION_NORTH]=e_LOCATION_NONE;
                    LoadScene();
                    return;
                }
            }
            break;

        case e_ITEM_Fridge:
            {    
                if (!(currentItem->flags & ITEM_FLAG_CLOSED))
                {
                    currentItem->description = gTextItemFridge;
                    currentItem->flags |= ITEM_FLAG_CLOSED;
                    LoadScene();
                    return;
                }
            }
            break;

        case e_ITEM_Medicinecabinet:
            {    
                if (!(currentItem->flags & ITEM_FLAG_CLOSED))
                {
                    currentItem->description = gTextItemMedicineCabinet;
                    currentItem->flags |= ITEM_FLAG_CLOSED;
                    LoadScene();
                    return;
                }
            }
            break;
        }
        PrintErrorMessage(gTextErrorCannotDo);   // "I can't do that"
    }
}



void ClimbItem(unsigned char itemId)
{
	if (ItemCheck(itemId))
    {
		switch (itemId)
		{
		case e_ITEM_Ladder:
            {    
                if ( (gCurrentLocation == e_LOCATION_OUTSIDE_PIT) || (gCurrentLocation == e_LOCATION_INSIDEHOLE) )
                {
                    char ladderLocation = gItems[e_ITEM_Ladder].location;
                    if (ladderLocation == e_LOCATION_INVENTORY)
                    {
                        PrintErrorMessage(gTextErrorNeedPositionned);   // "It needs to be positionned first"
                    }
                    else
                    if (ladderLocation == e_LOCATION_INSIDEHOLE)
                    {
                        gCurrentLocation = e_LOCATION_OUTSIDE_PIT;
                        LoadScene();
                    }
                }
                else
                {
                    PrintErrorMessage(gTextErrorCannotUseHere);   // "I can't use it here"
                }
            }
			//ActionClimbLadder();
			break;

        case e_ITEM_Rope:
            ActionClimbRope();
            break;

		default:
			PrintErrorMessage(gTextErrorCantClimbThat);     // "I don't know how to climb that"
			break;
		}
	}
}


void InspectItem(unsigned char itemId)
{
	if (ItemCheck(itemId))
    {
		switch (itemId)
		{
		case e_ITEM_UnitedKingdomMap:
            PlayStream(gSceneActionInspectMap);
			LoadScene();
			break;

		case e_ITEM_ChemistryBook:
			PrintInformationMessage(gTextThickBookBookmarks);   // "A thick book with some boomarks"
			break;

        case e_ITEM_HandheldGame:
            PlayStream(gSceneActionInspectGame);
			LoadScene();
			break;

        case e_ITEM_Fridge:
            PlayStream(gSceneActionFridgeDoor);
			LoadScene();
            break;

		default:
			PrintErrorMessage(gTextErrorNothingSpecial);    // "Nothing special"
			break;
		}
	}
}

void ThrowItem(unsigned char itemId)
{
	if (ItemCheck(itemId))
    {
        item* itemPtr=&gItems[itemId];
		switch (itemId)
		{
		case e_ITEM_Meat:
            if (gCurrentLocation==e_LOCATION_ENTRANCEHALL)
            {
                item* dogItemPtr=&gItems[e_ITEM_AlsatianDog];
                if (!(dogItemPtr->flags & ITEM_FLAG_DISABLED))            // The dog only eats if it's alive
                {
                    if (itemPtr->flags & ITEM_FLAG_TRANSFORMED)       // Modified meat -> The dog eats it and sleep after 30ish minutes
                    {
                        //PrintErrorMessage(gTextErrorShouldSubdue);    // "I should subdue him first"
                        itemPtr->location = e_LOCATION_GONE_FOREVER;
                        dogItemPtr->flags |= ITEM_FLAG_DISABLED;
                        dogItemPtr->description = gTextDogLying;
                    }
                    else                                              // Normal meat -> The dog eats it
                    {
                        itemPtr->location = e_LOCATION_GONE_FOREVER;
                        //PrintErrorMessage(gTextErrorAlreadySearched);  // "You've already frisked him"
                    }
                    PlayStream(gSceneActionDogEatingMeat);                    
                    LoadScene();
                    return;
                }
            }
			break;

		default:
			break;
		}
        // By default we drop the item if we try to throw it and nothing special happens
        DropItem(itemId);
	}
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

    case e_WORD_READ:
		ReadItem(gWordBuffer[1]);
        break;

    case e_WORD_USE:
		UseItem(gWordBuffer[1]);
        break;

    case e_WORD_COMBINE:
		CombineItems(gWordBuffer[1],gWordBuffer[2]);
        break;

    case e_WORD_OPEN:
		OpenItem(gWordBuffer[1]);
        break;

    case e_WORD_CLOSE:
		CloseItem(gWordBuffer[1]);
        break;

    case e_WORD_CLIMB:
		ClimbItem(gWordBuffer[1]);
        break;

    case e_WORD_LOOK:
		InspectItem(gWordBuffer[1]);
        break;

	case e_WORD_KILL:
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
				PrintErrorMessage(gTextErrorAlreadyDead);  // "Already dead"
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

				case e_ITEM_AlsatianDog:
					gScore+=50;
					itemPtr->flags|=ITEM_FLAG_DISABLED;
					itemPtr->description=gTextDogLying;  // "a dog lying";
					LoadScene();
					break;

				case e_ITEM_YoungGirl:
					PrintErrorMessage(gTextErrorShouldSaveGirl);  // "You are supposed to save her"
					break;
				}
			}
		}
		break;

	case e_WORD_FRISK:
	case e_WORD_SEARCH:
		{
			unsigned char itemId=gWordBuffer[1];
			item* itemPtr=&gItems[itemId];
			if (itemPtr->location != gCurrentLocation)
			{
				PrintErrorMessage(gTextErrorItsNotHere);   // "It's not here"
			}
			else
			{
				// Eventual list of things we can search
				switch (itemId)
				{
				case e_ITEM_Thug:
					if (!(itemPtr->flags & ITEM_FLAG_DISABLED))
					{
						PrintErrorMessage(gTextErrorShouldSubdue);    // "I should subdue him first"
					}
					else
					if (gItems[e_ITEM_Pistol].location!=e_LOCATION_NONE)
					{
						PrintErrorMessage(gTextErrorAlreadySearched);  // "You've already frisked him"
					}
					else
					{
						gScore+=50;
						gItems[e_ITEM_Pistol].location = e_LOCATION_MASTERBEDROOM;
						PrintInformationMessage(gTextFoundSomething);                // "You found something interesting"
						LoadScene();
					}
					break;
				}
			}
		}
		break;

    case e_WORD_THROW:
   		ThrowItem(gWordBuffer[1]);
        break;

#ifdef ENABLE_CHEATS
	case e_WORD_REVIVE:
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
		break;

	case e_WORD_TICKLE:
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
					LoadScene();
					break;

				case e_ITEM_AlsatianDog:
					gCurrentLocationPtr->script = gDescriptionDogAttacking;
					itemPtr->description=gTextDogJumpingAtMe;     // "a dog jumping at me"
					LoadScene();
					break;

				case e_ITEM_YoungGirl:
					PrintErrorMessage(gTextErrorInappropriate);   // "Probably impropriate"
					break;
				}
			}
		}
		break;

    case e_WORD_INVOKE:
        {
            // Wherever they are, give a specific item to the user
			unsigned char itemId=gWordBuffer[1];
			item* itemPtr=&gItems[itemId];
            itemPtr->location = e_LOCATION_INVENTORY;
            LoadScene();            
        }
        break;
#endif    

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

