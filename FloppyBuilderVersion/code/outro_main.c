//
// EncounterHD - Outro
// (c) 2020-2024 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"

#include "game_defines.h"
#include "input_system.h"
#include "score.h"



// Bunch of "no-op" functions and tables, these are required by the game, but not for the high scores
keyword gWordsArray[] = { { 0,  e_WORD_COUNT_ } };
void HandleByteStream()
{    
}

WORDS ProcessPlayerNameAnswer()
{
	// We accept anything, it's the player name so...
	return e_WORD_QUIT;
}


void PrintStatusMessageAsm()
{
   sprintf((char*)0xbb80+40*22+1,"%c%s",param1.uchar,param0.ptr);
}


void HandleHighScore()
{
	int entry;
	int score;
	score_entry* ptrScore=gHighScores;

	// Load the highscores from the disk
	LoadFileAt(LOADER_HIGH_SCORES,gHighScores);

	for (entry=0;entry<SCORE_COUNT;entry++)
	{		
		// Check if our score is higher than the next one in the list
		score=ptrScore->score-32768;
		if (gScore>score)
		{	
			// First, we scroll down the rest, but since we don't have "memmov" we need to manually start from the end
			// else the result will be corrupted because of overwrites.
			score_entry* ptrScoreCopy = gHighScores+SCORE_COUNT-1;
			while (ptrScoreCopy>ptrScore)
			{
				--ptrScoreCopy;
				ptrScoreCopy[1] = ptrScoreCopy[0];
			}

			// Ask the player their name
			AskInput(gTextHighScoreAskForName,ProcessPlayerNameAnswer, 0);   // "New highscore! Your name please?"
			ptrScore->score = gScore+32768;
			ptrScore->condition = e_SCORE_GAVE_UP;  // Need to get that from the game
			memset(ptrScore->name,' ',15);          // Fill the entry with spaces
			if (gInputBufferPos>15)
			{
				// Just copy the first 16 characters if it's too long
				gInputBufferPos=15;
			}
			// Force the name to the right to be formatted like the rest of the default scores
			memcpy(ptrScore->name+15-gInputBufferPos,gInputBuffer,gInputBufferPos);

			// Save back the highscores in the slot
			SaveFileAt(LOADER_HIGH_SCORES,gHighScores);
			return;
		}
		++ptrScore;
	}
}


// Some quite ugly function which waits a certain number of frames
// while detecting key presses and returns 1 if either space or enter are pressed
int Wait(int frameCount)
{	
	int k;

	while (frameCount--)
	{
		WaitIRQ();

		k=ReadKey();
		if ((k==KEY_RETURN) || (k==' ') )
		{
			//PlaySound(KeyClickLData);
			WaitFrames(4);
			return 1;
		}
	}
	return 0;
}

//#define TEST_MODE

char TextBuffer[40*12];

int DisplayText(const char* text,int delay)
{
    int x;
    char* screenPtr=(char*)0xbb80+40*16;
    char* sourcePtr=TextBuffer;

#ifdef TEST_MODE    
    memset(TextBuffer,'.',40*12);   // erase the bottom part of the screen
#else
    memset(TextBuffer,' ',40*12);   // erase the bottom part of the screen
#endif
    memcpy(screenPtr,sourcePtr,40*12);  // Force erase the screen in case there was still something there

	SetLineAddress((char*)TextBuffer+1);
    PrintMultiLine(text);

    // Appear
    for (x=0;x<40;x++)
    {
        int y;
        for (y=0;y<12;y++)
        {
            screenPtr[y*40]=sourcePtr[y*40];
        }
        screenPtr++;
        sourcePtr++;
        WaitIRQ();
    }

    // Wait a bit
    Wait(delay);

    // Disppear
    for (x=0;x<40;x++)
    {
        int y;
        screenPtr--;
        sourcePtr--;
        for (y=0;y<12;y++)
        {
            screenPtr[y*40]=' ';   // Space
        }
        WaitIRQ();
    }
}



void main()
{
    //Panic();

	// Install the 50hz IRQ
	System_InstallIRQ_SimpleVbl();


    // Load the desk picture
    LoadFileAt(OUTRO_PICTURE_DESK,ImageBuffer);
    //memcpy((char*)0xa000,ImageBuffer,40*128);

    memset(0xbb80+40*16+15,16+0,10);        // Erase the bottom \/ of the arrow block
	BlitBufferToHiresWindow();              // Show the empty desk

#ifndef TEST_MODE
    LoadFileAt(OUTRO_SPRITE_DESK,SecondImageBuffer);  // Paper + glass of whisky

    // Show the paper
    gDrawWidth  = 28;
    gDrawHeight = 92;
    gSourceStride = 40;
    gDrawSourceAddress = SecondImageBuffer;
    gDrawAddress       = ImageBuffer+35*40+6;
    BlitSprite();
    //BlitBufferToHiresWindow();  // Show the paper

    // Show the glass
    gDrawWidth  = 10;
    gDrawHeight = 62;
    gSourceStride = 40;
    gDrawSourceAddress = SecondImageBuffer+30;
    gDrawAddress       = ImageBuffer+61*40+30;
    BlitSprite();
    BlitBufferToHiresWindow();  // Show the glass

    // Ask the name
	ResetInput();

	HandleHighScore();

	// Just to let the last click sound to keep playing
	WaitFrames(4);

    // Show the camera
    gDrawWidth  = 10;
    gDrawHeight = 55;
    gSourceStride = 40;
    gDrawSourceAddress = SecondImageBuffer+63*40+30;
    gDrawAddress       = ImageBuffer+5*40+1;
    BlitSprite();
    BlitBufferToHiresWindow();  // Show the camera
#endif

#ifdef TEST_MODE    
    while (1)
#endif    
    {
        DisplayText(gTextThanks,50*5);

    LoadFileAt(OUTRO_SPRITE_PHOTOS,SecondImageBuffer);  // Photos + glass of whisky

    // Show the first photo
    gDrawWidth  = 17;
    gDrawHeight = 75;
    gSourceStride = 20;
    gDrawSourceAddress = SecondImageBuffer;
    gDrawAddress       = ImageBuffer+37*40+20;
    BlitSprite();

    // Show the glass of whisky
    gDrawWidth  = 10;
    gDrawHeight = 62;
    gSourceStride = 20;
    gDrawSourceAddress = SecondImageBuffer+155*20+10;
    gDrawAddress       = ImageBuffer+61*40+30;
    BlitSprite();

    BlitBufferToHiresWindow();  // Show the first photo

        DisplayText(gTextCredits,50*8);

    // Show the second photo
    gDrawWidth  = 17;
    gDrawHeight = 75;
    gSourceStride = 20;
    gDrawSourceAddress = SecondImageBuffer+20*76;
    gDrawAddress       = ImageBuffer+56*40+13;
    BlitSprite();
    BlitBufferToHiresWindow();  // Show the second photo

        DisplayText(gTextGameDescription,50*12);

    // Show the third photo
    gDrawWidth  = 10;
    gDrawHeight = 61;
    gSourceStride = 20;
    gDrawSourceAddress = SecondImageBuffer+20*155;
    gDrawAddress       = ImageBuffer+48*40+16;
    BlitSprite();
    BlitBufferToHiresWindow();  // Show the third photo

        DisplayText(gTextExternalInformation,50*12);

        DisplayText(gTextGreetings,50*16);
    }

    memset(0xbb80+40*16,' ',40*12);   // erase the bottom part of the screen


    memset(ImageBuffer,64,40*128);    // Erase the image in the view
	BlitBufferToHiresWindow();

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the intro
	InitializeFileAt(LOADER_INTRO_PROGRAM,0x400);
}

