//
// EncounterHD - Game Intro
// (c) 2020-2023 Dbug / Defence Force
//

#include <lib.h>

#include "params.h"

#include "loader_api.h"

extern void System_InstallIRQ_SimpleVbl();
extern void System_RestoreIRQ_SimpleVbl();
extern void WaitIRQ();

extern char WaitKey();
extern char ReadKey();
extern char ReadKeyNoBounce();

// Display.h
extern unsigned char ImageBuffer[40*200];

extern char Text_CopyrightSevernSoftware[];
extern char Text_CopyrightDefenceForce[];
extern char Text_FirstLine[];
extern char Text_HowToPlay[];
extern char Text_MovementVerbs[];
extern char Text_Notes[];

int k;

char gIsHires = 1;
char* gPrintAddress = (char*)0xbb80;

void SetLineAddress(char* address)
{
	gPrintAddress=address;
}

void PrintLine(const char* message)
{
	strcpy(gPrintAddress,message);	
	gPrintAddress+=40;
}


void Text(char paperColor,char inkColor)
{
	int y;
	memset((char*)0xa000,paperColor,0xbfe0-0xa000);	
	poke(0xbfdf,26);
	WaitIRQ();
	WaitIRQ();
	if (gIsHires)
	{
		memcpy((char*)0xb500,(char*)0x9900,8*96);
		gIsHires=0;	
	}
	for (y=0;y<28;y++)
	{
		poke(0xbb80+y*40+1,inkColor);
		memset(0xbb80+y*40+2,32,38);
	}
}


void Hires(char paperColor,char inkColor)
{
	int y;
	if (!gIsHires)
	{
		memcpy((char*)0x9900,(char*)0xb500,8*96);
		gIsHires=1;
	}
	memset((char*)0xa000,paperColor,0xbfe0-0xa000);   // Blinks for some reason, bug in memset???
	poke(0xbfdf,31);
	WaitIRQ();
	WaitIRQ();
	for (y=0;y<200;y++) 
	{
		poke(0xa000+y*40+0,paperColor);
		poke(0xa000+y*40+1,inkColor);
	}
	for (y=0;y<3;y++)
	{
		poke(0xbb80+40*25+y*40+0,paperColor);
		poke(0xbb80+40*25+y*40+1,inkColor);
	}
}


int Wait(int frameCount)
{
	while (frameCount--)
	{
		WaitIRQ();

		k=ReadKey();
		if ((k==KEY_RETURN) || (k==' ') )
		{
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

		if (DisplayUserManual())
		{
			break;
		}
	}

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the loader
	InitializeFileAt(LOADER_PROGRAM_SECOND,0x400);
}

