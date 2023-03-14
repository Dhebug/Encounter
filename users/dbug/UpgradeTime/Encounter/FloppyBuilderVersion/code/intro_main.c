//
// EncounterHD - Game Intro
// (c) 2020-2023 Dbug / Defence Force
//

#include <lib.h>

#include "params.h"

#include "loader_api.h"

extern void System_InstallIRQ_SimpleVbl();
extern void System_RestoreIRQ_SimpleVbl();

extern char WaitKey();

// Display.h
extern unsigned char ImageBuffer[40*128];
extern void ClearHiresWindow();
extern void BlitBufferToHiresWindow();

int k;


extern char Text_CopyrightSevernSoftware[];
extern char Text_CopyrightDefenceForce[];
extern char Text_FirstLine[];

void main()
{
	// Load the charset
	LoadFileAt(LOADER_FONT_6x8,0x9900);

	strcpy((char*)0xbb80+40*25,Text_FirstLine);
	strcpy((char*)0xbb80+40*26,Text_CopyrightSevernSoftware);
	strcpy((char*)0xbb80+40*27,Text_CopyrightDefenceForce);

	// Load the first picture at the default address specified in the script
	LoadFileAt(LOADER_PICTURE_TITLE,0xa000);

	// Install the IRQ so we can use the keyboard
	System_InstallIRQ_SimpleVbl();

	// Wait until the player presses Enter or space
	do
	{
		k=WaitKey();
	}
	while ( (k!=KEY_RETURN) && (k!=' ') );

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the loader
	InitializeFileAt(LOADER_PROGRAM_SECOND,0x400);
}

