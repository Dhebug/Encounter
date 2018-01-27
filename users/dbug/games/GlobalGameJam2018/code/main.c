//
// Global Game Jam 2016
// (c) 2016 Mickael Pointier
//

#include <lib.h>

#include "loader_api.h"

extern void System_InstallIRQ_SimpleVbl();
extern unsigned char Font6x6[];
extern void InitializeTables();

char MyString[]="This is a test";

void BigHackTestYeahhhh()
{
    poke(0xbfdf,26);    // Back to TEXT mode by poking on the last byte of the screen with the TEXT 50hz attribute

    //memcpy((void*)(0xB400),(void*)(0x9800),1024);

    memset(0xbb80,64,64);   // Whatever
    poke(0xbb80,16+1);      // Red paper on the first byte

	while (1)
	{

	}

    memcpy((void*)(0xbb80+1),MyString,14);

	poke(0xbb80+40,65);
}


void LoadTitleScreen()
{
	LoadFileAt(LOADER_TITLE_SCREEN,0xa000); 	
}


void main()
{
	// Install the IRQ handler
	System_InstallIRQ_SimpleVbl();

	InitializeTables();

	// Load the 6x8 font
	LoadFileAt(LOADER_FONT_6x8,0x9900);
	LoadFileAt(LOADER_FONT_6x6,Font6x6);
	PatchFont();


    //BigHackTestYeahhhh();


    // Load the title picture
    LoadFileAt(LOADER_GAMEJAM_LOGO,0xa000); 

    // Let's call the assembler game sequence...
    GameStart();
}

