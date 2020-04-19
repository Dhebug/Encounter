//
// EncounterHD - Main Game
// (c) 2020 Dbug / Defence Force
//

#include <lib.h>

#include "loader_api.h"


void main()
{
	int i;

	// Cycle through all the pictures stored on the disk
	for (i=LOADER_PICTURE_LOCATIONS_START;i<LOADER_PICTURE_LOCATIONS_END;i++)
	{	
		sprintf((char*)0xbb80+40*27,"Game Image %d",i);

		LoadFileAt(i,0xa000);
	}

	// Quit and return to the intro
	InitializeFileAt(LOADER_INTRO_PROGRAM,0x400);
}
