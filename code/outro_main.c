//
// EncounterHD - Outro
// (c) 2020-2024 Dbug / Defence Force
//
#include <lib.h>

#include "common.h"

#include "game_defines.h"
#include "input_system.h"
#include "score.h"

extern char TypewriterMusic[];


// Bunch of "no-op" functions and tables, these are required by the game, but not for the high scores
keyword gWordsArray[] = { { 0,  e_WORD_COUNT_ } };

WORDS AskInputCallback()
{   
    return e_WORD_CONTINUE;
}

WORDS ProcessPlayerNameAnswer()
{
	// We accept anything, it's the player name so...
    if (gInputBufferPos>=1)
    {
    	return e_WORD_QUIT;
    }
    else
    {
        return e_WORD_CONTINUE;   
    }
}

void PrintStatusMessageAsm()
{
   sprintf(gStatusMessageLocation+1,"%c%s",param1.uchar,param0.ptr);
}


void SaveScoreFile()
{
    memcpy(gSaveGameFile.achievements,gAchievements,ACHIEVEMENT_BYTE_COUNT);
    SaveFileAt(LOADER_HIGH_SCORES,&gSaveGameFile);
    gAchievementsChanged=0;
}



// See data/scores.s for some useful comments
typedef struct 
{
    int bonus_value;
    char character_offset;
} TimeBonusInfo;

// "1:59:39"
// Basically we count 0.5 point per second
TimeBonusInfo TimeBonusInfoTable[]=
{
    { 1800, 0},  // Hours
    {  300, 2},  // 10 of minutes
    {   30, 3},  // Minutes
    {    5, 5},  // 10s of seconds
    {    1, 6},  // Seconds (should be 0.5, but feeling generous)
    {    0, 0},
};

char* ptrTimeString=(char*)0xbb80+16*40+31;
char flip=0;

void PlayFlipClick()
{
    if (flip)   
    {
        PlaySound(KeyClickLData);
    }
    else        
    {
        PlaySound(KeyClickHData);
    }
    flip=1-flip;
}


void ApplyTimeBonus()
{
    TimeBonusInfo* timeBonusInfoPtr=TimeBonusInfoTable;

    // Show the score in yellow to move the atention to it
    WaitFrames(50);
    sprintf((char*)0xbb80+16*40+1,gTextBaseScore,3,gScore);
    WaitFrames(50);

    if (gGameOverCondition == e_SCORE_SOLVED_THE_CASE)
    {
        // Add the time as bonus points (half a point per remaining second)
        do
        {
            char offset=timeBonusInfoPtr->character_offset;
            if (ptrTimeString[offset]>'0')
            {
                ptrTimeString[offset]--;
                gScore+=timeBonusInfoPtr->bonus_value;
                PlayFlipClick();
                WaitFrames(5);
            }
            else
            {
                ++timeBonusInfoPtr;
            }
            sprintf((char*)0xbb80+16*40+1,gTextBaseScore,3,gScore);
        }
        while (timeBonusInfoPtr->bonus_value);
    }
    else
    {
        sprintf((char*)0xbb80+40*24,gTextNoTimeBonus,1,0);        
        WaitFrames(50*2);
    }

    // Erase the remaining time
    memset(ptrTimeString,32,7);
    WaitFrames(50*2);
}

// gSaveGameFile.achievements = Achievements from disk
// gAchievements              = Currently unlocked achievements
void ShowNewAchievements()
{
    int entry;
    int unlockedCount = 0;
    int achievementDelay = 70; 
    unsigned char achievementOffset = 0;
    unsigned char achievementMask = 1;
    for (entry=0;entry<ACHIEVEMENT_COUNT_;entry++)
    {		
        unsigned char achievementByte;
        char* achievementMessage = AchievementMessages[entry];
        if (achievementMask==0)
        {
            achievementMask=1;
            achievementOffset++;
        }
        // Is it unlocked?
        achievementByte = gAchievements[achievementOffset] & achievementMask;
        if (achievementByte)  
        {
            unlockedCount++;
            // Is it a new unlock (ie: not unlocked in the save game)
            if (achievementByte & (~gSaveGameFile.achievements[achievementOffset]) )
            {
                gSaveGameFile.achievements[achievementOffset] |= achievementMask;
                gAchievementsChanged = 1;
                sprintf((char*)0xbb80+40*24,gTextNewAchievement,5,3,achievementMessage,0);
                PlayFlipClick();
                WaitFrames(1+achievementDelay);
                if (achievementDelay>10)
                {
                    achievementDelay-=3;
                }
            }             
        }
        achievementMask <<= 1;
    }

    if (unlockedCount)
    {
        memset((char*)0xbb80+40*25,0,40);   // Clear the background before printing the text line to avoid having garbage on the right side
        sprintf((char*)0xbb80+40*25,Text_AchievementCount,unlockedCount,ACHIEVEMENT_COUNT_,unlockedCount*100/ACHIEVEMENT_COUNT_);
        WaitFrames(50*3);
    }

    // Erase the achievements before proceeding to asking the player name
    memset((char*)0xbb80+40*24,32,40*2);
    WaitFrames(50*1);
}


void HandleHighScore()
{
	int entry;
	int score;
	score_entry* ptrScore=gHighScores;

	// Load the highscores from the disk
	LoadFileAt(LOADER_HIGH_SCORES,&gSaveGameFile);

#if 0  // Just to test the different ending conditions
    gScore = -1800;
    gGameOverCondition = e_SCORE_SOLVED_THE_CASE;
  	sprintf((char*)0xbb80+16*40+1,"%cScore:%d%c",4,gScore,1);   // "Score:"
  	sprintf(ptrTimeString,"1:59:39");                           // "1:59:39"
    UnlockAchievement(ACHIEVEMENT_MAIMED_BY_DOG);
    UnlockAchievement(ACHIEVEMENT_USED_THE_ROPE);
    UnlockAchievement(ACHIEVEMENT_READ_THE_NEWSPAPER);
    UnlockAchievement(ACHIEVEMENT_WATCHED_THE_INTRO);
    UnlockAchievement(ACHIEVEMENT_FRISKED_THE_THUG);
    memset(gAchievements,255,ACHIEVEMENT_BYTE_COUNT);           // Unlock ALL the achievements
#endif
    // Show a congratulation/failure message related to their actual ending condition
    gPrintWidth = 40;
    gPrintTerminator=0;    
    PrintStringAt(gScoreConditionsArray[gGameOverCondition],(char*)0xbb80+40*18);

    ApplyTimeBonus();

    ShowNewAchievements();


	for (entry=0;entry<SCORE_COUNT;entry++)
	{		
        char nameOk;

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
            gStatusMessageLocation = (unsigned char*)0xbb80+40*25;
            SetKeyboardLayout();
            gInputMaxSize = 15;
            gAnswerProcessingCallback = ProcessPlayerNameAnswer;
            AskInput(gTextHighScoreAskForName,0);   // "New highscore! Your name please?"
            WaitReleasedKey();

			ptrScore->score = gScore+32768;
			ptrScore->condition = gGameOverCondition;   // Need to get that from the game
			memset(ptrScore->name,' ',15);              // Fill the entry with spaces
			// Force the name to the right to be formatted like the rest of the default scores
			memcpy(ptrScore->name+15-gInputBufferPos,gInputBuffer,gInputBufferPos);

            // This is a highscore
            UnlockAchievement(ACHIEVEMENT_GOT_A_HIGHSCORE);
            if (entry==0)
            {
                // Which also happens to be the best score
                UnlockAchievement(ACHIEVEMENT_GOT_THE_BEST_SCORE);
            }

			// Save back the highscores in the slot
            SaveScoreFile();
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
#define SECURITY_OVERWRITE_MARGIN 5   // To catch eventual errors with bad texts, else it will overwrite the code

char TextBuffer[40*(12+SECURITY_OVERWRITE_MARGIN)];

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

    gPrintWidth = 40;
    gPrintTerminator=TEXT_END;    
    PrintStringAt(text,TextBuffer);

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
        if (Wait(1))
        {
            return 1;
        }
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
        if (Wait(1))
        {
            return 1;
        }
    }
    return 0;
}

unsigned char* gSpritBasePointer=SecondImageBuffer;     // So we can point on different images - important when preloading data
extern unsigned char ThirdImageBuffer[];                // Additional buffer for the image preloading to avoid disturbing the music


#define AddSprite(width,height,stride,src_offset,dst_offset)  {  gDrawWidth=width;gDrawHeight=height;gSourceStride=stride;gDrawSourceAddress=gSpritBasePointer+src_offset; gDrawAddress=ImageBuffer+dst_offset;BlitSprite(); }

void main()
{
    //Panic();

	// Install the 50hz IRQ
	System_InstallIRQ_SimpleVbl();

    // We need to preload all the images before we start the music
    // Load the desk picture
    LoadFileAt(OUTRO_PICTURE_DESK,ImageBuffer);
    LoadFileAt(OUTRO_SPRITE_DESK,SecondImageBuffer);  // Paper + glass of whisky
    LoadFileAt(OUTRO_SPRITE_PHOTOS,ThirdImageBuffer);  // Photos + glass of whisky

    memset(0xbb80+40*16+15,16+0,10);        // Erase the bottom \/ of the arrow block
	BlitBufferToHiresWindow();              // Show the empty desk

#ifndef TEST_MODE
    gSpritBasePointer=SecondImageBuffer;

    AddSprite(28,92,40,0,35*40+6);          // Add the letter
    AddSprite(10,62,40,30,61*40+30);        // Add the glass of whisky
    BlitBufferToHiresWindow();

    // Ask the name
	ResetInput();

	HandleHighScore();

    if (gAchievementsChanged)
    {        
        // Save back the highscores in the slot
        SaveScoreFile();
    }

	// Just to let the last click sound to keep playing
	WaitFrames(4);

    AddSprite(10,55,40,63*40+30,5*40+1);   // Add the Polaroid camera
    BlitBufferToHiresWindow();
#endif

    // Now we start the typewriter music
    PlayMusic(TypewriterMusic);

#ifdef TEST_MODE    
    while (1){
#endif    
    // =============================== Thank you ===============================
    gSpritBasePointer=ThirdImageBuffer;

    if (DisplayText(gTextThanks,50*5))
    {
        goto EndCredits;
    }
    
    AddSprite(17,75,20,0,37*40+20);             // Add the first photo hidden behind the glass
    AddSprite(10,62,20,152*20+10,61*40+30);     // Add the glass of whisky on top of the glass
    BlitBufferToHiresWindow();

    // =============================== Credits ===============================
    if (DisplayText(gTextCredits,50*8))
    {
        goto EndCredits;
    }
    
    AddSprite(17,75,20,20*76,56*40+13);         // Add the second photo
    BlitBufferToHiresWindow();

    // =============================== Additional Credits ===============================
    if (DisplayText(gTextAdditionalCredits,50*8))
    {
        goto EndCredits;
    }
    
    AddSprite(10,25,20,20*213,84*40+30);        // Lower the glass content
    BlitBufferToHiresWindow();

    // =============================== About the game ===============================
    if (DisplayText(gTextGameDescription,50*12))
    {
        goto EndCredits;
    }
    
    AddSprite(10,61,20,20*152,48*40+16);        // Add the third photo (Missing girl)
    if (gGameOverCondition == e_SCORE_SOLVED_THE_CASE)
    {
        AddSprite(10,14,20,20*258,(45+48)*40+16);        // Patch the image with "Rescued" if the player actually won
    }
    AddSprite(10,22,20,20*215+10,88*40+30);     // Lower the glass content even more
    BlitBufferToHiresWindow();

    // =============================== External Information ===============================
    if (DisplayText(gTextExternalInformation,50*12))
    {
        goto EndCredits;
    }

    AddSprite(10,20,20,20*238,92*40+30);     // Lower the glass content even more
    BlitBufferToHiresWindow();

    // =============================== Greetings ===============================
    if (DisplayText(gTextGreetings,50*16))
    {
        goto EndCredits;
    }

    AddSprite(10,17,20,20*238+10,96*40+30);     // Lower the glass content even more
    BlitBufferToHiresWindow();

#ifdef TEST_MODE    
    }
#endif    

    UnlockAchievement(ACHIEVEMENT_WATCHED_THE_OUTRO);
    if (gAchievementsChanged)
    {        
        // Save back the highscores in the slot
        SaveScoreFile();
    }

EndCredits:
    memset(0xbb80+40*16,' ',40*12);   // erase the bottom part of the screen

    memset(ImageBuffer,64,40*128);    // Erase the image in the view
    BlitBufferToHiresWindowNoFrameNoArrows();


	System_RestoreIRQ_SimpleVbl();
    EndMusic();
    PsgStopSoundAndForceUpdate();

	// Quit and return to the intro
	InitializeFileAt(LOADER_INTRO_PROGRAM,0x400);
}

