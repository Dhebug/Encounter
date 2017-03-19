//
// FLoppyBuilder sample code
// First part
// (c) 2015 Dbug / Defence Force
//

#include <lib.h>

#include "loader_api.h"

void main()
{
	// Load the first picture at the default address specified in the script
	LoadFileAt(LOADER_PICTURE_FIRSTPROGRAM,0xa000);

	// Quit and return to the loader
	InitializeFileAt(LOADER_PROGRAM_SECOND,0x400);
}
