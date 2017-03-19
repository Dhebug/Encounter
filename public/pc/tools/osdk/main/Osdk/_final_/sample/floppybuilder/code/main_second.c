//
// FLoppyBuilder sample code
// Second part
// (c) 2015 Dbug / Defence Force
//

#include <lib.h>

#include "loader_api.h"

void main()
{
	// Load the second picture at the default address specified in the script
	LoadFileAt(LOADER_PICTURE_SECONDPROGRAM,0xa000);

	// Quit and return to the loader
	InitializeFileAt(LOADER_GAME_PROGRAM,0x400);
}
