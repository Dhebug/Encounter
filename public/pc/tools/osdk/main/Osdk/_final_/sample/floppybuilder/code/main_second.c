//
// FLoppyBuilder sample code
// Second part
// (c) 2015 Dbug / Defence Force
//

#include <lib.h>

#include "file_loader.h"

void main()
{
	// Load the second picture at the default address specified in the script
	LoadFile(LOADER_PICTURE_SECONDPROGRAM);

	// Quit and return to the loader
}
