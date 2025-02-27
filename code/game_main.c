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

extern char gColoredSeparator[];


extern WORDS ProcessContainerAnswer();
extern void HandleKeywordHighlight();

// MARK:Display Scene
void PrintSceneInformation()
{
    // Display the score
	sprintf((char*)0xbb80+16*40+1,"%s%d%c",gTextScore,gScore,7);   // "Score:"

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



void SelectContainer()
{
    if (gStreamItemPtr->usable_containers)
    {
        // Requires a container
        WORDS containerId;
        AnswerProcessingFun previousCallback = gAnswerProcessingCallback;
        const char* previousInputMessage = gInputMessage;
        gAnswerProcessingCallback = ProcessContainerAnswer;
        gInputAcceptsEmpty = 1;
        gInputMessage = gTextCarryInWhat;
        containerId = AskInput();    // "Carry it in what?"
        gSelectedKeyword = e_WORD_COUNT_;
        gInputMessage = previousInputMessage;
        gAnswerProcessingCallback = previousCallback;
        gInputAcceptsEmpty = 0;
        if ( (containerId > e_ITEM__Last_Container) || (!(gStreamItemPtr->usable_containers & (1<<containerId))) )
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
            gStreamItemPtr->associated_item 	  = containerId;
            containerPtr->associated_item = gCurrentItem;
        }
    }
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

    OsdkJoystickType = gJoystickType;
    joystick_type_select();

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
    gInputMessage = gTextAskInput;
	AskInput();
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

