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

extern char LoadSceneScript[];


// MARK:Print Directions
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


// MARK:Print Inventory
// The inventory display is done in two passes, using an intermediate buffer to limit flickering.
// The first pass displays all the non empty containers and their associated content
// The second pass displays the rest
// And finally the buffer is copied back to video memory.
void PrintInventory()
{	
    int pass;
	int itemId;
	int inventoryCell =0;

#ifdef ENABLE_PRINTER    
    PrinterSendString("\n- Inventory: ");
#endif

	memset((char*)TemporaryBuffer479,' ',40*4);
    gPrintWidth=38;
    for (pass=0;pass<2;pass++)
    {
    	item* itemPtr = gItems;
        for (itemId=0;itemId<e_ITEM_COUNT_;itemId++)
        {
            if (itemPtr->location == e_LOC_INVENTORY)
            {
                char* screenPtr = (char*)TemporaryBuffer479+40*(inventoryCell/2)+(inventoryCell&1)*20;
                unsigned char associatedItemId = itemPtr->associated_item;

                if (pass==0)
                {
                    // First pass: Only the containers with something inside
                    if ( (itemPtr->flags & ITEM_FLAG_IS_CONTAINER) && (associatedItemId!=255) )
                    {
                        PrintStringAt(itemPtr->description,screenPtr);  // Print the container
                        PrintString(":");
                        PrintString(gItems[associatedItemId].description);
                        inventoryCell+=2;
                    #ifdef ENABLE_PRINTER    
                        PrinterSendString(", ");
                    #endif
                    }
                }
                else
                {
                    // Second pass: Everything else
                    if (associatedItemId==255)
                    {
                        PrintStringAt(itemPtr->description,screenPtr);  // Print the container
                        inventoryCell++;
                    #ifdef ENABLE_PRINTER    
                        PrinterSendString(", ");
                    #endif
                    }
                }
            }
            ++itemPtr;
        }
    }
	memcpy((char*)0xbb80+40*24,TemporaryBuffer479,40*4);
}


// MARK:Print Objects
void PrintSceneObjects()
{
    char itemPrinted = 0;
	int itemCount = 0;
	int item;

#ifdef ENABLE_PRINTER    
    PrinterSendString("\n- Scene items: ");
#endif

	//memset((char*)TemporaryBuffer479,' ',40*4);
    memcpy(TemporaryBuffer479,(char*)0xbb80+40*18,40*4);

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
        gPrintWidth=38;
        PrintStringAt(gTextCanSee,TemporaryBuffer479+2);
        for (item=0;item<e_ITEM_COUNT_;item++)
        {
            if (gItems[item].location == gCurrentLocation)
            {
                if (itemPrinted) 
                {
                    // We only print the comma if we already have an item printed out, and we are not at the start of a new line
                    if ((gPrintPos+1)<=gPrintWidth)
                    {
                        PrintString(",");
                    }
                    if ((gPrintPos+1)<=gPrintWidth)
                    {
                        PrintString(" ");
                    }
                }
                PrintString(gItems[item].description);
                itemPrinted = 1;
            }
        }
        if ((gPrintPos+2)<=gPrintWidth)
        {
            // We only print the final dot if we already have an item printed out, and we are not at the start of a new line
            PrintString(".");
        }
	}
	else
	{
		sprintf((char*)TemporaryBuffer479+1,"%c%s",3,gTextNothingHere);  // "There is nothing of interest here"
	}
	memcpy((char*)0xbb80+40*18,TemporaryBuffer479,40*4);
}


// MARK:Display Scenes
void PrintSceneInformation()
{
	// Print the description of the place at the top (centered)
    PrintTopDescription(gDescription);  //gCurrentLocationPtr->description);

    // Display the score
	sprintf((char*)0xbb80+16*40+1,"%c%s%d%c",4,gTextScore,gScore,7);   // "Score:"

#ifdef ENABLE_PRINTER
    // If the printer is enable, we print the content
    // sta $bb80+16*40+39-6-1-2,x
    PrinterSendString("\n\n--------[");
    PrinterSendMemory((char*)0xbb80+40*17,40);                    // You are in a deserted market square 
    PrinterSendString("][");
    PrinterSendMemory((char*)0xbb80+40*16+30,10);                 // Time stamp
    PrinterSendString("][");
    PrinterSendMemory((char*)0xbb80+40*16+0,13);                  // Score
    PrinterSendString("]--------");
#endif    

	PrintSceneDirections();

	PrintSceneObjects();

	PrintInventory();

#ifdef ENABLE_PRINTER
    PrinterSendCrlf();
#endif    
}

// MARK:Load Scene
void LoadScene()
{
	gCurrentLocationPtr = &gLocations[gCurrentLocation];
    gSceneImage = LOADER_PICTURE_LOCATIONS_START+gCurrentLocation;
    PlayStream(LoadSceneScript);    

	// Set the byte stream pointer
	SetByteStream(gCurrentLocationPtr->script);
    
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


// MARK:Player Move
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


char ShowingKeyWords = 0;
char ShouldShowKeyWords = 0;

char OneHourAlarmWarningShown = 0;
extern char OneHourAlarmWarning[];
extern char TimeOutGameOver[];

// MARK:Input Callback
WORDS AskInputCallback()
{
    HandleByteStream();
    if ( (gGameOverCondition!=0) && (gCurrentStream==0) )
    {
        // The player has reached a game over condition and the end of the current stream
        return e_WORD_QUIT;
    }

    // We check the Hours digit to see if it reached zero
    // If it does then we play the "hurry up" sequence!
    if ( (TimeHours=='0') && (!OneHourAlarmWarningShown) )
    {
        // Should probably add a check to not interrupt import scripts
        // Problematic ones are the market place and the stair case, where the animations make the script to never stop.
        const char* savedStream = gCurrentStream;
        PlayStream(OneHourAlarmWarning);
        gCurrentStream = savedStream;
        OneHourAlarmWarningShown=1;
    }
    if (TimeHours=='9')
    {
        // Should probably add a check to not interrupt import scripts
        // Problematic ones are the market place and the stair case, where the animations make the script to never stop.
        const char* savedStream = gCurrentStream;
        PlayStream(TimeOutGameOver);
        gCurrentStream = savedStream;
        return e_WORD_QUIT;
    }

    // When the player presses SHIFT we redraw the item list with highlights
    ShouldShowKeyWords = (KeyBank[4] & 16);
    if (ShowingKeyWords != ShouldShowKeyWords)
    {
        gShowHighlights = ShouldShowKeyWords;

        PrintSceneObjects();

        PrintInventory();

        ShowingKeyWords = ShouldShowKeyWords;
    }

    return e_WORD_CONTINUE;
}

WORDS ProcessContainerAnswer()
{
    return gWordBuffer[0];
}

// MARK:Token Check
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


// MARK:Item Checks
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

// MARK:Take Item
void TakeItem()
{
    unsigned char itemId = gWordBuffer[1];
    item* itemPtr=&gItems[itemId];
	if (itemId>=e_ITEM_COUNT_)
	{
		PrintErrorMessage(gTextErrorCantTakeNoSee);     // "You can only take something you see"
        return;
	}
    
    if (itemPtr->location == e_LOC_INVENTORY)           // Do we already have the item?
    {
        PrintErrorMessage(gTextErrorAlreadyHaveItem);   // "You already have this item"
        return;
    }

    if (itemPtr->location != gCurrentLocation)          // Is the item in the scene?
    {
        PrintErrorMessage(gTextErrorItemNotPresent);    // "This item does not seem to be present"
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


// MARK:Drop Item
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
        unsigned char linkedItemId = itemPtr->associated_item;

        itemPtr->location = gCurrentLocation;
        if (linkedItemId != 255)
        {
            // Break the link between the two items
            item* linkedItemPtr=&gItems[linkedItemId];
            itemPtr->associated_item = 255;
            linkedItemPtr->associated_item = 255;
            if (itemPtr->flags & ITEM_FLAG_IS_CONTAINER)
            {
                // When the item is a container we need to drop both the container and the content
                linkedItemPtr->location = gCurrentLocation;
                DispatchStream(gDropItemMappingsArray,linkedItemId);    // Execute the stream to perform any item specific operation
            }
        }
        DispatchStream(gDropItemMappingsArray,itemId);    // Execute the stream to perform any item specific operation
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

#ifdef ENABLE_PRINTER
void PrinterEnableDisable()
{
    if (gUsePrinter)
    {
        PrintStatusMessage(5,"Printer Output Disabled");
    }
    gUsePrinter = gUsePrinter?0:255;
    if (gUsePrinter)
    {
        PrintStatusMessage(2,"Printer Output Enabled");
    }
    WaitFrames(50);
}
#endif

// MARK:Answer
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
                	ClearMessageWindow(16+4);

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


// MARK:Inits
void Initializations()
{
    PrinterSendString("\n\n\n--------< New Game started >--------\n\n");

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
   StartClock();
#else
	// In normal gameplay, the player starts from the marketplace with an empty inventory
	gCurrentLocation = e_LOC_MARKETPLACE;
#endif	

	gScore = 0;
    gCurrentStream = 0;
    gDelayStream = 0;
    gGameOverCondition = 0;

    // The redefined charcters to draw the bottom part of the directional arrows \v/
	poke(0xbb80+16*40+16,9);                      // ALT charset
	memcpy((char*)0xbb80+16*40+17,";<=>?@",6);

#ifdef ENABLE_GAME
	LoadScene();
	DisplayClock();
#endif
	ResetInput();
}


// MARK:main
void main()
{
    gUsePrinter = 0;

    UnlockAchievement(ACHIEVEMENT_LAUNCHED_THE_GAME);

	Initializations();	

#ifdef ENABLE_GAME
	AskInput(gTextAskInput,ProcessAnswer,1);
#else
    // Directly go to the end credits    
    gScore = 999;
    gGameOverCondition = e_SCORE_SOLVED_THE_CASE;
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

