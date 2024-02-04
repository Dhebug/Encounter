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



void main()
{
    //Panic();

	// Install the 50hz IRQ
	System_InstallIRQ_SimpleVbl();


    // Load the desk picture
    LoadFileAt(OUTRO_PICTURE_DESK,ImageBuffer);
    //memcpy((char*)0xa000,ImageBuffer,40*128);

    memset(0xbb80+40*16+15,16+0,10);        // Erase the bottom \/ of the arrow block
	BlitBufferToHiresWindow();





	ResetInput();

	HandleHighScore();

	// Just to let the last click sound to keep playing
	WaitFrames(4);

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the intro
	InitializeFileAt(LOADER_INTRO_PROGRAM,0x400);
}

