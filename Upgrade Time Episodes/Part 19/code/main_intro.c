//
// EncounterHD - Game Intro
// (c) 2020 Dbug / Defence Force
//

#include <lib.h>

#include "loader_api.h"

void main()
{
	// Load the charset
	LoadFileAt(LOADER_FONT_6x8,0x9900);

	strcpy((char*)0xbb80+40*27,"Intro");

	// Load the first picture at the default address specified in the script
	LoadFileAt(LOADER_PICTURE_TITLE,0xa000);
	//LoadFileAt(LOADER_PICTURE_LOCATIONS_START+1,0xa000);


	// Quit and return to the loader
	InitializeFileAt(LOADER_PROGRAM_SECOND,0x400);
}

