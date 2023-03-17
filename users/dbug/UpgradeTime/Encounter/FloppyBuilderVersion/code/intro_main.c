//
// EncounterHD - Game Intro
// (c) 2020-2023 Dbug / Defence Force
//

#include <lib.h>

#include "common.h"

// intro_utils
extern char Text_FirstLine[];
extern char Text_CopyrightSevernSoftware[];
extern char Text_CopyrightDefenceForce[];

extern char Text_HowToPlay[];
extern char Text_MovementVerbs[];
extern char Text_Notes[];

extern char Text_Leaderboard[];


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
			PlaySound(KeyClickLData);
			WaitFrames(4);
			return 1;
		}
	}
	return 0;
}


int DisplayIntroPage()
{
	Hires(16+3,4);

	SetLineAddress((char*)0xbb80+40*25);
	PrintLine(Text_FirstLine);
	PrintLine(Text_CopyrightSevernSoftware);
	PrintLine(Text_CopyrightDefenceForce);

	memcpy((char*)0xa000,ImageBuffer,8000);

	return Wait(50*2);
}


int DisplayUserManual()
{
	Text(16+3,0);

	SetLineAddress((char*)0xbb80+40*1+2);
	PrintLine(Text_HowToPlay);
	PrintLine("");
	PrintLine("Your task is to find and rescue a");
	PrintLine("young girl kidnapped by thugs.");
	PrintLine("");
	PrintLine("Give orders using VERBS and NOUNS");
	PrintLine("eg:EMP(ty) BOT(tle) or GET KEY(s)");
	PrintLine("");
	PrintLine(Text_MovementVerbs);
	PrintLine("");
	PrintLine("N:NORTH S:SOUTH   GET DROP THROW KILL");
	PrintLine("W:WEST E:EAST     HIT MAKE CLIMB QUIT"   );
	PrintLine("U:UP D:DOWN       OPEN LOAD FRISK USE");
	PrintLine("L:Look                READ PRESS BLOW");
	PrintLine(Text_Notes);
	PrintLine("");
	PrintLine("Everything you need is here but you");
	PrintLine("may have to manufacture some items.");
	PrintLine("");
	PrintLine("The mission fails if the movement or");
	PrintLine("alarm counters reaches zero.");
	PrintLine("");
	PrintLine("Drawing and annotating a map helps." );
	PrintLine("");
	PrintLine("Good luck, you will need it..." );

	return Wait(50*2);
 }


//
// Typewriter intro style presentation.
// Characters are displayed one by one, and it's possible to quit at any time
//
// Now we could do something smarter, write at the bottom of the screen and scroll up the result
// 
int DisplayStory()
{
	int result;

	Text(16+7,0);

	SetLineAddress((char*)0xbb80+40*26+2);

	// By using || it's possible to early exit the function when the player presses a key
	result = TypeWriterPrintCharacter("Wednesday, September 1st, 1982\n\n\n")
	|| TypeWriterPrintCharacter("I remember it like if it was yesterday\n\n")
	|| TypeWriterPrintCharacter("My client had asked me to save their\ndaughter who had been kidnapped by\n")
	|| TypeWriterPrintCharacter("some vilains who hide in a posh house\nin the middle of nowhere.\n\n")
	|| TypeWriterPrintCharacter("I was given carte blanche on how to\nsolve the issue...\n")
	|| TypeWriterPrintCharacter("...using lethal force if necessary.\n\n\n")
	|| TypeWriterPrintCharacter("I parked my car on the market place\nand approached discretely by foot to\n")
	|| TypeWriterPrintCharacter("not alert them from my presence...\n\n")
	|| Wait(50*2);

	return result;
}

int TypeWriterPrintCharacter(const char *message)
{
	char car;
	char *line = gPrintAddress;
	while (car = *message++)
	{
		if (car == '\n')
		{
			line = gPrintAddress;
			if (Wait(5 + (rand() & 3)))
			{
				return 1;
			}
			PlaySound(KeyClickLData);
			// PlaySound(PingData);
			if (Wait(20 + (rand() & 15)))
			{
				return 1;
			}
			memcpy((char *)0xbb80, (char *)0xbb80 + 40, 40 * 27); // Scroll up the entire screen
		}
		else if (car == ' ')
		{
			*line++ = car;
			// PlaySound(KeyClickLData);
			if (Wait(5 + (rand() & 3)))
			{
				return 1;
			}
		}
		else
		{
			*line++ = car;
			PlaySound(KeyClickHData);
		}
		if (Wait(2 + (rand() & 3)))
		{
			return 1;
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
		memcpy(gPrintAddress,ptrScore->name,16);
		
		score=ptrScore->score-32768;
		sprintf(gPrintAddress+16+((score>=0)?1:0),"%c%d",4,score);

		condition=ptrScore->condition;
		if (condition<=e_SCORE_GAVE_UP)
		{
			sprintf(gPrintAddress+22,"%s",gScoreConditionsArray[condition]);
		}
		ptrScore++;		
		if (Wait(10))
		{
			return 1;
		}
	}

	return Wait(50*2);
}


void main()
{
	// Load the charset
	LoadFileAt(LOADER_FONT_6x8,0x9900);

	// Load the first picture at the default address specified in the script
	LoadFileAt(LOADER_PICTURE_TITLE,ImageBuffer);

	// Install the IRQ so we can use the keyboard
	System_InstallIRQ_SimpleVbl();

	while (1)
	{
		if (DisplayIntroPage())
		{
			break;
		}

		if (DisplayHighScoresTable())
		{
			break;
		}

		if (DisplayUserManual())
		{
			break;
		}

		if (DisplayStory())
		{
			break;
		}
	}

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the loader
	InitializeFileAt(LOADER_PROGRAM_SECOND,0x400);
}

