//
// EncounterHD - Game Intro
// (c) 2020-2024 Dbug / Defence Force
//

#include <lib.h>

#include "common.h"
#include "score.h"

// intro_utils
extern char Text_FirstLine[];
extern char Text_CopyrightSevernSoftware[];
extern char Text_CopyrightDefenceForce[];

extern char Text_GameInstructions[];

extern char Text_Leaderboard[];
extern char Text_TypeWriterMessage[];


extern unsigned char TypeWriterPaperWidth;
extern unsigned char TypeWriterBorderWidth;
extern unsigned char TypeWriterPaperPattern;

extern char* TypeWriterPaperRead;
extern char* TypeWriterPaperWrite;
extern char* TypeWriterBorderRead;
extern char* TypeWriterBorderWrite;

extern void CopyTypeWriterLine();



unsigned char ImageBuffer2[40*200];



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


int Wait2(unsigned int frameCount,unsigned char referenceFrame)
{	
	int k;

	while ( (VblCounter-referenceFrame) < frameCount)
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


int DisplayIntroPage()
{
	// Load the first picture at the default address specified in the script
	LoadFileAt(LOADER_PICTURE_TITLE,ImageBuffer);

	Hires(16+3,4);

	SetLineAddress((char*)0xbb80+40*25);
	PrintLine(Text_FirstLine);
	PrintLine(Text_CopyrightSevernSoftware);
	PrintLine(Text_CopyrightDefenceForce);

	memcpy((char*)0xa000,ImageBuffer,8000);

	return Wait(50*5);
}


int DisplayUserManual()
{
	Text(16+3,0);

	SetLineAddress((char*)0xbb80+40*1+2);
    PrintMultiLine(Text_GameInstructions);
	return Wait(50*8);
 }


int gXPos=0;
int gYPos=0;

//
// Typewriter intro style presentation.
// Characters are displayed one by one, and it's possible to quit at any time
//
// Now we could do something smarter, write at the bottom of the screen and scroll up the result
// 
int DisplayStory()
{
	int result;

	Hires(16,0);

	// Load the images
	LoadFileAt(INTRO_PICTURE_PRIVATE_INVESTIGATOR,ImageBuffer);
	LoadFileAt(INTRO_PICTURE_TYPEWRITER			 ,ImageBuffer2);

#ifdef INTRO_SHOW_STORY_SCROLL
	// Animation scrolling the office and the typewriter for cinematic effect
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
	}

	if (Wait(50*2))
    {
        return 1;
    }
#else
	// Just show directly the composite image with the office and the typewriter
	memcpy((char*)0xa000   		,ImageBuffer+40*57    	,40*86);
	memcpy((char*)0xa000+40*86	,ImageBuffer2 			,40*114);
#endif
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

#if 0
    while (1) {}
	memcpy((char*)0xa000,ImageBuffer,8000);       // Show the entire text picture to make sure the text looks ok
	while(1) {}
#endif

	return result;
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
	char* sourcePtr            = (char*)ImageBuffer+height*40;
	char* destPtr              = (char*)0xa000       + (136*40) - (gYPos*8+8)*40+height*40;
	char* sourcePtrBackground  = (char*)ImageBuffer2 + (136*40) - (gYPos*8+8)*40+height*40;

	int borderWidth  = 19-gXPos;
	int width        = 0;
	int borderOffset = 0;
	int sourceOffset = 0;
	int destOffset   = 0;

	if (borderWidth>0)
	{
		// Border on the left side of the paper
		borderOffset = 0;
		destOffset   = borderWidth;
	}
	else
	{
		// Border on the right side	of the paper
		borderWidth  = gXPos-18;
		borderOffset = 40-borderWidth;
		sourceOffset = borderWidth-1;
	}
	width        = 40-borderWidth;
#if 0	
	sprintf((char*)0xbb80+40*25,"gXPos:%d gYPos:%d",gXPos,gYPos);
	sprintf((char*)0xbb80+40*26,"W:%d BW:%d",width,borderWidth);
	sprintf((char*)0xbb80+40*27,"DO:%d SO:%d BO:%d",destOffset, sourceOffset,borderOffset);
#endif

    TypeWriterPaperWidth  = width;
    TypeWriterBorderWidth = borderWidth;

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
	while (gXPos>2)
	{
		gXPos-=2;
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
			PlaySound(SpaceBarData);
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
			PlaySound(TypeWriterData);
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

	if (ptrScore->condition == e_SCORE_UNNITIALIZED)
	{
		// Load the high score table on the first access
		LoadFileAt(LOADER_HIGH_SCORES,gHighScores);
	}

	SetLineAddress((char*)0xbb80+40*0+0);

	PrintLine(Text_Leaderboard);

	for (entry=0;entry<SCORE_COUNT;entry++)
	{		
		gPrintAddress+=40;
		memcpy(gPrintAddress,ptrScore->name,15);
		
		score=ptrScore->score-32768;
		sprintf(gPrintAddress+15+((score>=0)?1:0),"%c%d",4,score);

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

	return Wait(50*2);
}


extern char Intro_Subsong0[];
extern char Typewriter_Subsong1[];

#define PlayMusic(music)    { param0.ptr=music;asm("jsr _StartMusic"); }

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

	// Install the IRQ so we can use the keyboard
    PlayMusic(Intro_Subsong0);
	System_InstallIRQ_SimpleVbl();

	while (1)
	{
#ifdef INTRO_SHOW_TITLE_PICTURE
		if (DisplayIntroPage())
		{
			break;
		}
#endif        

#ifdef INTRO_SHOW_LEADERBOARD
		if (DisplayHighScoresTable())
		{
			break;
		}
#endif

#ifdef INTRO_SHOW_USER_MANUAL
		if (DisplayUserManual())
		{
			break;
		}
#endif

#ifdef INTRO_SHOW_STORY
        PlayMusic(Typewriter_Subsong1);
		if (DisplayStory())
		{
			break;
		}
        PlayMusic(Intro_Subsong0);
#endif
	}

	System_RestoreIRQ_SimpleVbl();
    EndMusic();

#ifndef ENABLE_INTRO
endIntro:
#endif
	// Quit and return to the loader
	InitializeFileAt(LOADER_GAME_PROGRAM,LOADER_GAME_PROGRAM_ADDRESS);   // 0x400
}

