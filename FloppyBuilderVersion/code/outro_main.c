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

    //delay=1;

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


#define AddSprite(width,height,stride,src_offset,dst_offset)  {  gDrawWidth=width;gDrawHeight=height;gSourceStride=stride;gDrawSourceAddress=SecondImageBuffer+src_offset; gDrawAddress=ImageBuffer+dst_offset;BlitSprite(); }

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
   
    AddSprite(28,92,40,0,35*40+6);          // Add the letter
    AddSprite(10,62,40,30,61*40+30);        // Add the glass of whisky
    BlitBufferToHiresWindow();

    // Ask the name
	ResetInput();

	HandleHighScore();

	// Just to let the last click sound to keep playing
	WaitFrames(4);

    AddSprite(10,55,40,63*40+30,5*40+1);   // Add the Polaroid camera
    BlitBufferToHiresWindow();
#endif

#ifdef TEST_MODE    
    while (1){
#endif    
    // =============================== Thank you ===============================
    DisplayText(gTextThanks,50*5);

    LoadFileAt(OUTRO_SPRITE_PHOTOS,SecondImageBuffer);  // Photos + glass of whisky
    
    AddSprite(17,75,20,0,37*40+20);             // Add the first photo hidden behind the glass
    AddSprite(10,62,20,152*20+10,61*40+30);     // Add the glass of whisky on top of the glass
    BlitBufferToHiresWindow();

    // =============================== Credits ===============================
    DisplayText(gTextCredits,50*8);
    
    AddSprite(17,75,20,20*76,56*40+13);         // Add the second photo
    AddSprite(10,25,20,20*213,84*40+30);        // Lower the glass content
    BlitBufferToHiresWindow();

    // =============================== About the game ===============================
    DisplayText(gTextGameDescription,50*12);
    
    AddSprite(10,61,20,20*152,48*40+16);        // Add the third photo
    AddSprite(10,22,20,20*215+10,88*40+30);     // Lower the glass content even more
    BlitBufferToHiresWindow();

    // =============================== External Information ===============================
    DisplayText(gTextExternalInformation,50*12);

    AddSprite(10,20,20,20*238,92*40+30);     // Lower the glass content even more
    BlitBufferToHiresWindow();

    // =============================== Greetings ===============================
    DisplayText(gTextGreetings,50*16);

    AddSprite(10,17,20,20*238+10,96*40+30);     // Lower the glass content even more
    BlitBufferToHiresWindow();

#ifdef TEST_MODE    
    }
#endif    

    memset(0xbb80+40*16,' ',40*12);   // erase the bottom part of the screen


    memset(ImageBuffer,64,40*128);    // Erase the image in the view
	BlitBufferToHiresWindow();

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the intro
	InitializeFileAt(LOADER_INTRO_PROGRAM,0x400);
}

