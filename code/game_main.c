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

extern char ScenePreLoadScript[];              // Script that runs before the scene even loads - used to move the girl around

char gColoredSeparator[]=" ";


extern WORDS ProcessContainerAnswer();
extern void HandleKeywordHighlight();


// MARK:Print Inventory
// The inventory display is done in two passes, using an intermediate buffer to limit flickering.
// The first pass displays all the non empty containers and their associated content
// The second pass displays the rest
// And finally the buffer is copied back to video memory.
void PrintInventory()
{	
    int pass;
	int itemId;

    gCurrentItemCount = 0;

    ClearTemporaryBuffer479();  //memset((char*)TemporaryBuffer479,' ',40*4);
    gPrintWidth=38;
    gPrintRemovePrefix=1;
    for (pass=0;pass<2;pass++)
    {
    	item* itemPtr = gItems;
        for (itemId=0;itemId<e_ITEM_COUNT_;itemId++)
        {
            if (itemPtr->location == e_LOC_INVENTORY)
            {
                char* screenPtr = (char*)TemporaryBuffer479+40*(gCurrentItemCount/2)+(gCurrentItemCount&1)*20;
                unsigned char associatedItemId = itemPtr->associated_item;
                 gColoredSeparator[0] = (gCurrentItemCount&1)^((gCurrentItemCount&2)>>1)  ?7:3;  // Alternate the ink colors based on the counter

                if (pass==0)
                {
                    // First pass: Only the containers with something inside
                    if ( (itemPtr->flags & ITEM_FLAG_IS_CONTAINER) && (associatedItemId!=255) )
                    {
                        PrintStringAt(gColoredSeparator,screenPtr);
                        PrintStringAt(itemPtr->description,screenPtr+1);  // Print the container
                        PrintString(":");
                        PrintString(gItems[associatedItemId].description);
                        gCurrentItemCount+=2;
                    }
                }
                else
                {
                    // Second pass: Everything else
                    if (associatedItemId==255)
                    {
                        PrintStringAt(gColoredSeparator,screenPtr);

                        PrintStringAt(itemPtr->description,screenPtr+1);  // Print the item
                        gCurrentItemCount++;
                    }
                }
            }
            ++itemPtr;
        }
    }
    BlittTemporaryBuffer479();
    gPrintRemovePrefix=0;
}


extern int PrintSceneObjectsInit();

// MARK:Print Objects
void PrintSceneObjects()
{
    char itemPrinted = 0;
	int itemCount = 0;
    int maxOffset = -40*3;
	int item;

    itemCount = PrintSceneObjectsInit();
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
                        if (gPrintLineTruncated)
                        {
                            maxOffset+=40;
                        }
                    }
                    if ((gPrintPos+1)<=gPrintWidth)
                    {
                        PrintString(" ");
                        if (gPrintLineTruncated)
                        {
                            maxOffset+=40;
                        }
                    }
                }
                PrintString(gItems[item].description);
                if (gPrintLineTruncated)
                {
                    maxOffset+=40;
                }
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
    
    if (gInventoryOffset>maxOffset)
    {
        gInventoryOffset=maxOffset;
    }
    if (gInventoryOffset<0)
    {
        gInventoryOffset=0;
    }

	memcpy((char*)0xbb80+40*18,TemporaryBuffer479+gInventoryOffset,40*4);
}


// MARK:Display Scene
void PrintSceneInformation()
{
    // Display the score
	sprintf((char*)0xbb80+16*40+1,"%c%s%d%c",5,gTextScore,gScore,7);   // "Score:"

	PrintSceneDirections();

	PrintSceneObjects();

	PrintInventory();
}

// MARK:Load Scene
void LoadScene()
{
	gCurrentLocationPtr = &gLocations[gCurrentLocation];
    gSceneImage = LOADER_PICTURE_LOCATIONS_START+gCurrentLocation;

    // Run the Scene "preload" script
    PlayStream(ScenePreLoadScript);    

	// Set the byte stream pointer
	SetByteStream(gCurrentLocationPtr->script);
    
	ClearMessageWindow(16+4);

	LoadFileAt(gSceneImage,ImageBuffer);	

	// And run the first set of commands for this scene
	HandleByteStream();

    if (gGameOverCondition)
    {
        // If we have reach game over, we don't draw the rest of information
        return;
    }

    // We need to print the scene information *after* the script has been launched, else the moved items will not appear until the next refresh
	PrintSceneInformation();

	BlitBufferToHiresWindow();
}


// MARK:Player Move
void PlayerMove()
{
    unsigned char direction = gWordBuffer[0]-e_WORD_NORTH;
	unsigned char requestedScene = gCurrentLocationPtr->directions[direction];
	if (requestedScene==e_LOC_NONE)
	{
        UnlockAchievement(ACHIEVEMENT_WRONG_DIRECTION)
		PrintErrorMessageShort(gTextErrorInvalidDirection);   // "Impossible to move in that direction"
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
    if (TimeOut)
    {
        // Should probably add a check to not interrupt import scripts
        // Problematic ones are the market place and the stair case, where the animations make the script to never stop.
        const char* savedStream = gCurrentStream;
        PlayStream(TimeOutGameOver);
        gCurrentStream = savedStream;
        return e_WORD_QUIT;
    }

    HandleKeywordHighlight();

    return e_WORD_CONTINUE;
}




// MARK:Take Item
void TakeItem()
{
    unsigned char itemId = gWordBuffer[1];
    item* itemPtr=&gItems[itemId];
	if (itemId>=e_ITEM_COUNT_)
	{
        if (gWordCount<=1)
        {
    		PrintErrorMessage(gTextErrorNeedMoreDetails);   // "Could you be more precise please?"
        }
        else
        {
    		PrintErrorMessage(gTextErrorCantTakeNoSee);     // "You can only take something you see"
        }
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

    if (gCurrentItemCount>=8)
    {
        PrintErrorMessage(gTextErrorInventoryFull);      // "I need to drop something first"
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
        WORDS containerId;
        AnswerProcessingFun previousCallback = gAnswerProcessingCallback;
        gAnswerProcessingCallback = ProcessContainerAnswer;
        gInputAcceptsEmpty = 1;
        containerId = AskInput(gTextCarryInWhat,1 );    // "Carry it in what?"
        gAnswerProcessingCallback = previousCallback;
        gInputAcceptsEmpty = 0;
        if ( (containerId > e_ITEM__Last_Container) || (!(itemPtr->usable_containers & (1<<containerId))) )
        {
            PrintErrorMessage(gTextErrorThatWillNotWork);    // "That will not work"
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
                // But it's on the scene, so we pick-it up automatically (except if we don't have room for it)
                if ((gCurrentItemCount+1)>=8)
                {
                    PrintErrorMessage(gTextErrorInventoryFull);      // "I need to drop something first"
                    return;
                }
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

        ClearMessageWindow(16+4);

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



char FindActionMapping();
void RunAction();

extern action_mapping* gActionMappingPtr;

// MARK:Answer
WORDS ProcessAnswer()
{
    if (FindActionMapping())
    {
        RunAction();
        // Test for game over
        if (gGameOverCondition!=0)
        {
            // The player has reached a game over condition
            return e_WORD_QUIT;
        }

        // Continue, clear the prompt
        if (gTextAskInput[0])
        {
            gTextAskInput[0]=0;
        }
        return e_WORD_CONTINUE;
    }


	// Not recognized: Warn the player and continue
    UnlockAchievement(ACHIEVEMENT_CAN_YOU_REPEAT);
    PrintErrorMessage(gTextErrorDidNotUnderstand);      // "I do not understand, sorry"
	PlaySound(ErrorPlop);
 	return e_WORD_CONTINUE;
}



// MARK: SHOW HELP
void ShowHelp()
{
    char counter=0;
    keyword* keywordPtr = gWordsArray;

    ClearMessageAndInventoryWindow(16+4);

    gPrintWidth=38;
    gPrintPos = 0;
    SetLineAddress((char*)0xbb80+40*19+1);

    while (keywordPtr->word)   // The list is terminated by a null pointer entry
    {
        if  ( (keywordPtr->id>e_ITEM_COUNT_) && (keywordPtr->id<e_WORD_COUNT_) )
        {
            if (gPrintPos==0)
            {
                // New line
                counter=0;
            }
            else
            {
                counter++;
            }
            PrintString(keywordPtr->word);
            if (gPrintLineTruncated)
            {
                counter=0;
            }
            gColoredSeparator[0] = (counter&1)?7:3;  // Alternate the ink colors based on the counter

            PrintString(gColoredSeparator);
        }
        ++keywordPtr;
    }
    PrintString(gTextUseShiftToHighlight);    
    WaitKey();
    LoadScene();
}


// MARK:Inits
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
	LoadFileAt(LOADER_FONT_PALATINO_12x14,gFont12x14);

	// Perform some initializations for the text display system
	ComputeFancyFontWidth();
	GenerateShiftBuffer();
	GenerateMul40Table();
    SetKeyboardLayout();

#ifdef TESTING_MODE
    // Mike: Only available on my machine, it's a set of preconditions to test the game, but it's technically the game solution, so...
    #include "game_tests.c"
    StartClock();
#else
	// In normal gameplay, the player starts from the marketplace with an empty inventory
	gCurrentLocation = e_LOC_MARKETPLACE;
#endif	

	gScore = 0;
    gCurrentStream = 0;
    gStreamSkipPoint = 0;
    gDelayStream = 0;
    gGameOverCondition = 0;
    gInventoryOffset = 0;

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
    UnlockAchievement(ACHIEVEMENT_LAUNCHED_THE_GAME);

	Initializations();	

#ifdef ENABLE_GAME
    gStatusMessageLocation = (unsigned char*)0xbb80+40*21;
    gInputMaxSize = 35;
    gAnswerProcessingCallback = ProcessAnswer;
    WaitReleasedKey();
	AskInput(gTextAskInput,1);
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

