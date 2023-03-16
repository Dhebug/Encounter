//
// EncounterHD - Game Intro
// (c) 2020-2023 Dbug / Defence Force
//

#include <lib.h>

#include "common.h"



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
			WaitIRQ();
			WaitIRQ();
			WaitIRQ();
			WaitIRQ();
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

