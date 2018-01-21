//
// Global Game Jam 2016
// (c) 2016 Mickael Pointier
//

#include <lib.h>

#include "loader_api.h"

extern void System_InstallIRQ_SimpleVbl();
extern unsigned char Font6x6[];


void LoadTitleScreen()
{
	LoadFileAt(LOADER_TITLE_SCREEN,0xa000); 	
}


void main()
{
	// Install the IRQ handler
	System_InstallIRQ_SimpleVbl();

	// Load the 6x8 font
	LoadFileAt(LOADER_FONT_6x8,0x9900);
	LoadFileAt(LOADER_FONT_6x6,Font6x6);
	PatchFont();

    // Load the title picture
    LoadFileAt(LOADER_GAMEJAM_LOGO,0xa000); 

    // Let's call the assembler game sequence...
    GameStart();
}

