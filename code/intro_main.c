//
// EncounterHD - Game Intro
// (c) 2020-2024 Dbug / Defence Force
//

#include <lib.h>

#include "common.h"
#include "score.h"
#include "game_enums.h"

// intro_utils
extern char Text_TitlePicture[];

extern char Text_GameInstructions[];

extern char Text_Leaderboard[];
extern char Text_Achievements[];
extern char Text_TypeWriterMessage[];

extern const char* gLoadingMessagesArray[];

extern unsigned char TypeWriterPaperWidth;
extern unsigned char TypeWriterBorderWidth;
extern unsigned char TypeWriterPaperPattern;

extern char* TypeWriterPaperRead;
extern char* TypeWriterPaperWrite;
extern char* TypeWriterBorderRead;
extern char* TypeWriterBorderWrite;

extern void CopyTypeWriterLine();

extern char IntroMusic[];
extern char TypewriterMusic[];


extern unsigned char ImageBuffer2[40*200];
extern unsigned char GradientTable[];

unsigned char CompressedTitleImage[LOADER_PICTURE_TITLE_SIZE_COMPRESSED];
unsigned char UnCompressedGameTitle[LOADER_PICTURE_GAME_TITLE_SIZE_UNCOMPRESSED];

extern unsigned char CompressedOfficeImage[INTRO_PICTURE_PRIVATE_INVESTIGATOR_SIZE_COMPRESSED];
extern unsigned char CompressedTypeWriterImage[INTRO_PICTURE_TYPEWRITER_COMPRESSED];


enum
{
    INTRO_TITLE_PICTURE = 0,
    INTRO_USER_MANUAL,
    INTRO_LEADERBOARD,
    INTRO_ACHIEVEMENTS,
    INTRO_STORY,
    _INTRO_COUNT_
};

char gIntroPage = INTRO_TITLE_PICTURE;
char gShouldExit = 0;



int gXPos=0;
int gYPos=0;
char gStoryShownAlready = 0;
char gGameStarting = 0;


int FadeToBlack()
{
    char y,height;
    char* ptrTop;
    char* ptrBottom;
    char blocHeight;
    if (gIsHires)
    {
        height    =200/2;
        blocHeight=3;
        ptrTop    =(char*)0xa000;
        ptrBottom =ptrTop+200*40;
        memset((char*)0xbb80+25*40,0,3*40);   // Erase the last 3 lines of the TEXT part of the HIRES screen
    }
    else
    {
        height    =28/2;
        blocHeight=1;
        ptrTop    =(char*)0xbb80;
        ptrBottom =ptrTop+28*40;
    }

    for (y=0;y<=height/blocHeight;y++)
    {
        int blocSize=40*blocHeight;
        memset(ptrTop,0,blocSize);
        ptrTop+=blocSize;

        ptrBottom-=blocSize;
        memset(ptrBottom,0,blocSize);
        if (Wait(1))
        {
            return 1;
        }
    }
    return 0;
}


// Some quite ugly function which waits a certain number of frames
// while detecting key presses and returns 1 if either space or enter are pressed
int Wait(int frameCount)
{	
	int k;

	while (frameCount--)
	{
		WaitIRQ();

		k=ReadKeyNoBounce();
		if ((k==KEY_RETURN) || (k==' ') )
		{
            gShouldExit = 1;
			return 1;
		}
        if (k==KEY_LEFT)
        {
            gIntroPage = (gIntroPage+_INTRO_COUNT_)-2;
            if (gIntroPage>=_INTRO_COUNT_)
            {
                gIntroPage-=_INTRO_COUNT_;
            }
            return 1;
        }
        if (k==KEY_RIGHT)
        {
            return 1;
        }
	}
	return 0;
}


int Wait2(unsigned int frameCount,unsigned char referenceFrame)
{	
	int k;

	while ( (VblCounter-referenceFrame) < frameCount)
	{
		WaitIRQ();

		k=ReadKeyNoBounce();
		if ((k==KEY_RETURN) || (k==' ') )
		{
			//PlaySound(KeyClickLData);
			WaitFrames(4);
			return 1;
		}
	}
	return 0;
}


int WaitAndFade(int frameCount)
{
	if (Wait(frameCount))
    {
        return 1;
    }
    return FadeToBlack();
}

// Before calling this function, CompressedTitleImage must have been properly populated with the compressed title picture
int DisplayIntroPage()
{
	// Uncompress the preloaded title picture (240x200)
    file_unpack_raw(ImageBuffer,CompressedTitleImage,8000);

    {
        // Paint the logo
        int y;
        unsigned char* ptr=UnCompressedGameTitle;
        for (y=0;y<39;y++)
        {
            ptr[0]=16+3;       // Yellow paper
            ptr[1]=3;          // Yellow ink
            ptr+=40;
        }

    }

	// Copy the preloaded game title picture (240x39) on top
    // Note: for some reason, using the compressed picture ended up with a corrupted last line
    memcpy(ImageBuffer+40*2,UnCompressedGameTitle,40*39);


	Hires(16+3,4);

    gPrintWidth=40;
    gPrintTerminator=TEXT_END;
	PrintStringAt(Text_TitlePicture,0xbb80+40*25);

	memcpy((char*)0xa000,ImageBuffer,8000);

    {
        // Color cycle the logo
        int frame;
        for (frame=0;frame<50*5;frame++)
        {
            int y;
            unsigned char* ptr=(unsigned char*)0xa000+40*3;
            unsigned char* ptrGradient=GradientTable+(frame&127);
            for (y=0;y<39;y++)
            {
                ptr[1]=ptrGradient[y]&7;          // Magenta ink
                ptr+=40;
            }
            if (Wait(1))
            {
                return 1;
            }
        }
    }
    return FadeToBlack();
}


int DisplayUserManual()
{
	Text(16+3,0);

    gPrintWidth=40;
    gPrintTerminator=TEXT_END;
    PrintStringAt(Text_GameInstructions,0xbb80+40*1+2);
    return WaitAndFade(50*12);
 }



//
// Typewriter intro style presentation.
// Characters are displayed one by one, and it's possible to quit at any time
//
// Now we could do something smarter, write at the bottom of the screen and scroll up the result
// 
int DisplayStory()
{
	int result = 0;

	Hires(16,0);

	// Decompress the images
    file_unpack_raw(ImageBuffer,CompressedOfficeImage,8000);
    file_unpack_raw(ImageBuffer2,CompressedTypeWriterImage,8000);

#ifdef INTRO_SHOW_STORY_SCROLL
	// Animation scrolling the office and the typewriter for cinematic effect
    if ( (!gGameStarting) || (gGameStarting && !gStoryShownAlready) )
    {
        {
            int y;
            int size_top;
            int size_bottom;
            char* screen_position_top;
            char* screen_position_bottom;

            unsigned char* buffer_start_top;
            unsigned char* buffer_start_bottom;

            buffer_start_top    = ImageBuffer;
            buffer_start_bottom = ImageBuffer2;

            screen_position_top   =(char*)0xa000;
            screen_position_bottom=(char*)0xa000+40*200;

            size_top=8000;
            size_bottom=0;
            for (y=0;y<=100;y++)
            {
                memcpy(screen_position_top   	,buffer_start_top    ,size_top);
                memcpy(screen_position_bottom	,buffer_start_bottom ,size_bottom);

                buffer_start_top +=40;
                size_top         -=40*2;

                screen_position_bottom -=40*2;
                size_bottom            +=40*2;

                //VSync();
                if (Wait(1))
                {
                    return 1;
                }
            }

            if (Wait(50*2))
            {
                return 1;
            }

            for (y=0;y<45;y+=2)
            {
                memcpy(screen_position_top   	,buffer_start_top    ,size_top);
                memcpy(screen_position_bottom	,buffer_start_bottom ,size_bottom);

                buffer_start_top -=40*2;
                size_top         +=40*2*2;

                screen_position_bottom +=40*2*2;
                size_bottom            -=40*2*2;

                //VSync();
                if (Wait(1))
                {
                    return 1;
                }
            }

            gStoryShownAlready = 1;
        }

        if (Wait(50*2))
        {
            return 1;
        }
    }
    else
    {
        // Just show directly the composite image with the office and the typewriter
        memcpy((char*)0xa000   		,ImageBuffer+40*57    	,40*86);
        memcpy((char*)0xa000+40*86	,ImageBuffer2 			,40*114);
    }
#else
	// Just show directly the composite image with the office and the typewriter
	memcpy((char*)0xa000   		,ImageBuffer+40*57    	,40*86);
	memcpy((char*)0xa000+40*86	,ImageBuffer2 			,40*114);
#endif

    if (gGameStarting)
    {
        // Now we start the second music
        PlayMusic(TypewriterMusic);

        // Copy the composite image to the image buffer to rebuild the background
        memcpy(ImageBuffer2,(char*)0xa000,8000);


        // Prepare the image buffer by drawing a one pixel outline on the paper.
        // For performance reason the paper is limited to 39 columns so the logic to complete the left 
        // and right borders can be simplified by eliminating the case where the paper is shown in the
        // center of the screen without any border to draw at all.
        memset(ImageBuffer,127,8000);    		// All white
        {
            int y;
            for (y=0;y<200;y++)
            {
                ImageBuffer[y*40]   =127&~32;
                ImageBuffer[y*40+38]=127&~1;
            }
        }
        memset(ImageBuffer,64,39);       		// Top is black
        memset(ImageBuffer+40*199,64,39);       // Bottom is black

        SetLineAddress((char*)ImageBuffer+40*8+1);
        gXPos=0;
        gYPos=0;

        // By using || it's possible to early exit the function when the player presses a key
        result = TypeWriterPrintCharacter(Text_TypeWriterMessage)
        || Wait(50*2);

        // And we restore the main music track
        //PlayMusic(IntroMusic);
        EndMusic();
    }

#if 0
    while (1) {}
	memcpy((char*)0xa000,ImageBuffer,8000);       // Show the entire text picture to make sure the text looks ok
	while(1) {}
#endif

	return FadeToBlack() | result;
}


extern char TableRotateOffset[];
extern char TableDitherPatternOffset[];


void DisplayPaperSheet()
{
#if 0
	// Debugging code
	gXPos = 17;
	gYPos = 25;
#endif		
	{
	int y;
	int height                 = (gYPos+2)*8;
    int heightBy40             = height*40;
	char* sourcePtr            = (char*)ImageBuffer+heightBy40;
    int globalOffset           = (136*40) - (gYPos*8+8)*40+heightBy40;
	char* destPtr              = (char*)0xa000       + globalOffset;
	char* sourcePtrBackground  = (char*)ImageBuffer2 + globalOffset;

	int borderOffset = 0;
	int sourceOffset = 0;
	int destOffset   = 0;

    if (gXPos<19)
	{
		// Border on the left side of the paper
		borderOffset          = 0;
        TypeWriterBorderWidth = 19-gXPos;
		destOffset            = TypeWriterBorderWidth;
	}
	else
	{
		// Border on the right side	of the paper
		TypeWriterBorderWidth = gXPos-18;
		borderOffset          = 40-TypeWriterBorderWidth;
		sourceOffset          = TypeWriterBorderWidth-1;
	}
	TypeWriterPaperWidth = 40-TypeWriterBorderWidth;
#if 0	
	sprintf((char*)0xbb80+40*25,"gXPos:%d gYPos:%d",gXPos,gYPos);
	sprintf((char*)0xbb80+40*26,"W:%d BW:%d",width,borderWidth);
	sprintf((char*)0xbb80+40*27,"DO:%d SO:%d BO:%d",destOffset, sourceOffset,borderOffset);
#endif

    //TypeWriterBorderWidth = borderWidth;

    TypeWriterBorderRead  = sourcePtrBackground+borderOffset-1;
    TypeWriterBorderWrite = destPtr+borderOffset-1;

	// Print the paper
	for (y=0;y<height;y++)
	{
		destPtr            -=40;
		sourcePtr          -=TableRotateOffset[y];
		TypeWriterBorderRead -=40;
        TypeWriterBorderWrite-=40;
		if (sourcePtr<(char*)ImageBuffer)
		{
			break;
		}
		if ( (destPtr<(char*)0xa000+(120*40)) || (destPtr>(char*)0xa000+(126*40)) )
		{
            TypeWriterPaperPattern=TableDitherPatternOffset[y];

            TypeWriterPaperRead   = sourcePtr+sourceOffset-1;           
            TypeWriterPaperWrite  = destPtr+destOffset-1;

            CopyTypeWriterLine();
		}
	}		
	}
}


void CarriageReturn()
{
	gYPos++;
	DisplayPaperSheet();
    PlaySound(ScrollPageData);
	while (gXPos>2)
	{
		gXPos-=4;
		DisplayPaperSheet();
	}
	gXPos=1;
	DisplayPaperSheet();
}

int TypeWriterPrintCharacter(const char *message)
{
	char car;
	char *line = gPrintAddress;
	while (car = *message++)
	{
		if ( (car == 10) || (car == 13) )
		{
			gPrintAddress+=40*8;
			line = gPrintAddress;

			CarriageReturn();
			if (Wait(20 + (rand() & 15)))
			{
				return 1;
			}
		}
		else if (car == ' ')
		{
            unsigned char referenceFrame=VblCounter;
            if (gXPos>35)
            {
    			PlaySound(PingData);
            }
            else
            {
    			PlaySound(SpaceBarData);
            }
			gXPos++;
			line++;
			DisplayPaperSheet();
			if (Wait2(4 + (rand() & 7),referenceFrame))
			{
				return 1;
			}
		}
		else
		{
            unsigned char referenceFrame=VblCounter;
			char* charset=(char*)0x9900+(car-32)*8;
            if (gXPos>35)
            {
    			PlaySound(PingData);
            }
            else
            {
    			PlaySound(TypeWriterData);
            }
			line[40*0] = (charset[0]^63)|64;
			line[40*1] = (charset[1]^63)|64;
			line[40*2] = (charset[2]^63)|64;
			line[40*3] = (charset[3]^63)|64;
			line[40*4] = (charset[4]^63)|64;
			line[40*5] = (charset[5]^63)|64;
			line[40*6] = (charset[6]^63)|64;
			line[40*7] = (charset[7]^63)|64;

			gXPos++;
			line++;
			DisplayPaperSheet();
            if (Wait2(3 + (rand() & 7),referenceFrame))
            {
                return 1;
            }
		}
	}
	return 0;
}


int DisplayHighScoresTable()
{
	int entry;
	int score;
	unsigned char condition;
	score_entry* ptrScore=gHighScores;

	Text(16+0,7);

    gPrintWidth=40;
    gPrintTerminator=TEXT_END;
	PrintStringAt(Text_Leaderboard,0xbb80+40*0+0);

	for (entry=0;entry<SCORE_COUNT;entry++)
	{		
		gPrintAddress+=40;
		memcpy(gPrintAddress,ptrScore->name,15);
		
		score=ptrScore->score-32768;
		sprintf(gPrintAddress+15+0,"%c%d",4,score);

		condition=ptrScore->condition;
		if (condition<=e_SCORE_GAVE_UP)
		{
			sprintf(gPrintAddress+20,"%s",gScoreConditionsArray[condition]);
		}
		ptrScore++;		
		if (Wait(10))
		{
			return 1;
		}
	}
    return WaitAndFade(50*7);
}



int DisplayAchievements()
{
	Text(16+4,7);

    gPrintWidth=40;
    gPrintTerminator=TEXT_END;
	PrintStringAt(Text_Achievements,0xbb80+40*0+0);
    {
    	int entry;
        int unlockedCount = 0;
        unsigned char achievementOffset = 0;
        unsigned char achievementMask = 1;
        gPrintAddress+=40+1;
        for (entry=0;entry<ACHIEVEMENT_COUNT_;entry++)
        {		
            char* achievementMessage = AchievementMessages[entry];
            if (achievementMask==0)
            {
                achievementMask=1;
                achievementOffset++;
            }
            if (!(gAchievements[achievementOffset] & achievementMask))
            {
                achievementMessage = Text_AchievementStillLocked;
            }
            else
            {
                unlockedCount++;
            }
            sprintf(gPrintAddress,"%s",achievementMessage);
            gPrintAddress+=20;
            achievementMask <<= 1;
        }
        if (unlockedCount)
        {
            sprintf((char*)0xbb80+40*27,Text_AchievementCount,unlockedCount,ACHIEVEMENT_COUNT_,unlockedCount*100/ACHIEVEMENT_COUNT_);
        }
        else
        {
            sprintf((char*)0xbb80+40*27,Text_AchievementNone);
        }
    }

    return WaitAndFade(50*5);
}



#ifdef INTRO_ENABLE_SOUNDBOARD    
void PrintYMRegisters()
{
    char i;
    char* address;
    unsigned char mixer=Psgmixer;
    SetLineAddress((char*)0xbb80+40*4+2);
    address=gPrintAddress+10;
    sprintf(address+40*0,"%d   ", PsgfreqA);
    sprintf(address+40*1,"%d   ", PsgfreqB);
    sprintf(address+40*2,"%d   ", PsgfreqC);
    sprintf(address+40*3,"%d   ", PsgfreqNoise);
    sprintf(address+40*4,"%d   ", mixer);
    //poke(address+40*4+4,'0');
  
    sprintf(address+40*2+8,"Snd Nse");
    sprintf(address+40*3+8,"ABC ABC");
    for (i=0;i<6;i++)
    {
        poke(address+40*4+8+i+((i>=3)?1:0),'1'-(mixer&1));
        mixer>>=1;
    }
    
    sprintf(address+40*5,"%d   ", PsgvolumeA);
    sprintf(address+40*6,"%d   ", PsgvolumeB);
    sprintf(address+40*7,"%d   ", PsgvolumeC);
    sprintf(address+40*8,"%d   ", PsgfreqShape);
    sprintf(address+40*9,"%d   ", PsgenvShape);

    sprintf(address+40*11,"Pattern:%d Event:%d", MusicLoopIndex,MusicEvent);
}

void SoundBoard()
{
    Text(16+3,0);
    SetLineAddress((char*)0xbb80+40*0+2);

    PrintString("1/2=Select music 0=Stop music");
    PrintString("P=PING Z=ZAP X=Explode S=Shoot");
    PrintString("K/L=Key click SPACE/Other=Type writer");

    SetLineAddress((char*)0xbb80+40*4+2);
    PrintString("Freq A");
    PrintString("Freq B");
    PrintString("Freq C");
    PrintString("Noise");
    PrintString("Mixer");
    PrintString("Vol A");
    PrintString("Vol B");
    PrintString("Vol C");
    PrintString("Freq Env");
    PrintString("Shap Env");

    while (1)
    {
        char car;

        VSync();
        PrintYMRegisters();

        car = ReadKeyNoBounce();
        switch (car)
        {
        case 0:
            break;

        case '0':
        case ')':
            EndMusic();
            break;

        case '1':
        case '!':
            PlayMusic(IntroMusic);
            break;

        case '2':
        case '@':
            PlayMusic(TypewriterMusic);
            break;

        case 'Z':
        case 'z':
            PlaySound(ZapData);
            break;

        case 'K':
        case 'k':
            PlaySound(KeyClickHData);
            break;

        case 'L':
        case 'l':
            PlaySound(KeyClickLData);
            break;

        case 'X':
        case 'x':
            PlaySound(ExplodeData);
            break;

        case 'S':
        case 's':
            PlaySound(ShootData);
            break;

        case 'P':
        case 'p':
            PlaySound(PingData);
            break;

        case 32:
        case 13:
            PlaySound(SpaceBarData);
            break;

        case 't':
        case 'T':
            PlaySound(ScrollPageData);
            break;

        default:  
            PlaySound(TypeWriterData);
            break;
        }
    }
}
#endif

void main()
{
	// Load the charset
	//LoadFileAt(LOADER_FONT_6x8,0x9900);              // Art Deco font
	LoadFileAt(LOADER_FONT_TYPEWRITER_6x8,0x9900);     // Typewriter font

#ifndef ENABLE_INTRO
	// By using a goto instead of a comment or #ifdefing out the whole code block,
	// we ensure that the code is actually compiled, so that limits the chances to
	// break the intro when working on the game
	goto endIntro;
#endif

    //
    // Loading data perturbs the music playing, so to avoid scruntches we preload the big bitmaps.
    // Since we don't have enough memory to store many 8000 bytes images, we keep them compressed.
    //
#ifdef INTRO_SHOW_TITLE_PICTURE
    // Load the title picture
    LoadFileUncompressedAt(LOADER_PICTURE_TITLE,CompressedTitleImage,LOADER_PICTURE_TITLE_SIZE_COMPRESSED);
    LoadFileAt(LOADER_PICTURE_GAME_TITLE,UnCompressedGameTitle);    
#endif

#if defined(INTRO_SHOW_LEADERBOARD) || defined(INTRO_SHOW_ACHIEVEMENTS)
    // Load the high score table on the first access
    LoadFileAt(LOADER_HIGH_SCORES,&gSaveGameFile);
    memcpy(gAchievements,gSaveGameFile.achievements,ACHIEVEMENT_BYTE_COUNT);
#endif

#if defined(INTRO_SHOW_STORY) || defined(INTRO_SHOW_STORY_SCROLL)
    // Load the two pictures of the "private investigator" intro    
    LoadFileUncompressedAt(INTRO_PICTURE_PRIVATE_INVESTIGATOR,CompressedOfficeImage,INTRO_PICTURE_PRIVATE_INVESTIGATOR_SIZE_COMPRESSED);
    LoadFileUncompressedAt(INTRO_PICTURE_TYPEWRITER,CompressedTypeWriterImage,INTRO_PICTURE_TYPEWRITER_COMPRESSED);
#endif

	// Install the IRQ so we can use the keyboard
	System_InstallIRQ_SimpleVbl();

#ifdef INTRO_ENABLE_SOUNDBOARD    
    SoundBoard();
#else    
#ifdef INTRO_ENABLE_ATTRACT_MODE
    PlayMusic(IntroMusic);
	while (!gShouldExit)
	{
        switch (gIntroPage)
        {
#ifdef INTRO_SHOW_TITLE_PICTURE
        case INTRO_TITLE_PICTURE:
            DisplayIntroPage();
            break;
#endif        

#ifdef INTRO_SHOW_USER_MANUAL
        case INTRO_USER_MANUAL:
		    DisplayUserManual();
            break;
#endif

#ifdef INTRO_SHOW_LEADERBOARD
        case INTRO_LEADERBOARD:
    		DisplayHighScoresTable();
            break;
#endif

#ifdef INTRO_SHOW_ACHIEVEMENTS
        case INTRO_ACHIEVEMENTS:
    		DisplayAchievements();
            break;
#endif

#ifdef INTRO_SHOW_STORY
        case INTRO_STORY:
    		DisplayStory();
            UnlockAchievement(ACHIEVEMENT_WATCHED_THE_INTRO);
            break;
#endif        
        }
        if (gIntroPage<_INTRO_COUNT_)
        {
            gIntroPage++;
        }
        else
        {
            gIntroPage=0;
        }
	}
#endif
#endif

    //
    // Now we display the typewriter
    //
    gGameStarting = 1;
#if defined(INTRO_SHOW_STORY) || defined(INTRO_SHOW_STORY_SCROLL)
    if (DisplayStory())
    {
        //break;
    }
#endif

    //
    // Fade to black
    //
    FadeToBlack();

	System_RestoreIRQ_SimpleVbl();
    EndMusic();
    PsgStopSoundAndForceUpdate();

    if (gAchievementsChanged)
    {        
        // Save back the highscores in the slot
        SaveFileAt(LOADER_HIGH_SCORES,gHighScores);
        gAchievementsChanged=0;
    }

#ifndef ENABLE_INTRO
endIntro:
#endif
    // Ensure that the screen is erased even if the player pressed a key
    memset((char*)0xa000,64,8000);

	// Show some informative message for the player to patient during loading
    gPrintWidth = 40;
    gPrintTerminator=0;    
    PrintStringAt(gLoadingMessagesArray[gSaveGameFile.launchCount&3],(char*)0xbb80+40*25);


	// Quit and return to the loader
	InitializeFileAt(LOADER_GAME_PROGRAM,LOADER_GAME_PROGRAM_ADDRESS);   // 0x400
}

