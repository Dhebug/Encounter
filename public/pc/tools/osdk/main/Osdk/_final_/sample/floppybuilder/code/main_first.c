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
	LoadFile(LOADER_PICTURE_FIRSTPROGRAM);

	// Quit and return to the loader
}
