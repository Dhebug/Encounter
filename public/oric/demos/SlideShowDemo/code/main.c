//
// This program simply display a picture on the hires screen
//
#include <lib.h>

#include "floppy_description.h"

// irq.s
extern void System_InstallIRQ_SimpleVbl();
extern void VSync();
extern void Stop();

// player.s
extern volatile unsigned char MusicPlaying;
extern unsigned int MusicLength;
extern Mym_Initialize();
extern Mym_ReInitialize();

// transitions.s
extern unsigned char PictureLoadBuffer[];
extern void PictureTransitionFromTopAndBottom();
extern void PictureTransitionVenicianStore();
extern void PictureTransitionUnroll();

extern void PictureDoTransition();

//extern void PrintDescription();


extern void InitTransitionData();

// scroller.s
extern unsigned char FontBuffer[];
extern void ScrollerInit();
extern void TestScroller();

// loader_api.s
extern unsigned char LoaderApiEntryIndex;
extern unsigned char LoaderApiAddressLow;
extern unsigned char LoaderApiAddressHigh;
extern void* LoaderApiAddress;

extern void SetLoadAddress();
extern void LoadFile();

void Pause(int delay)
{
	int wasPlayingMusic=MusicPlaying;
	int i;

	for (i=0;i<delay;i++)
	{
		VSync();
		if (MusicPlaying!=wasPlayingMusic)
		{
			break;
		}
	}
}

extern void Player_SetMusic_Birthday();

unsigned char CurrentMusic=0;
unsigned char CurrentPicture=0;

void RetroIntro()
{
	// Load and play the music
	LoaderApiEntryIndex=LOADER_INTRO_MUSIC;		// BeBop music
	LoadFile();
	MusicLength=50*3;		// 3 seconds
	MusicLength=50*30;		// 3 seconds
	MusicLength=50*20;		// 3 seconds
	MusicLength=50*25;		// 3 seconds
	//MusicLength=50*28;		// 3 seconds
	MusicLength=50*24;		// 3 seconds
	Mym_Initialize();

	for (LoaderApiEntryIndex=LOADER_FIRST_INTRO_PICTURE;LoaderApiEntryIndex<LOADER_LAST_INTRO_PICTURE;LoaderApiEntryIndex++)
	{
		LoaderApiAddress=PictureLoadBuffer;
		SetLoadAddress();
		LoadFile();

		PictureTransitionUnroll();

		Pause(50*4);
	}


	while (MusicPlaying);

	// Clear the screen again
	memset((unsigned char*)0xa000,64,8000);
}


void main()
{
	// Clear the screen
	//memset((unsigned char*)0xa000,64,8000);
	memset((unsigned char*)0x9900,0,0xbfe0-0x9900);	

	// Load the 6x8 font
	LoaderApiEntryIndex=LOADER_FONT_6x8_ARTDECO;
	LoadFile();

    // Load the 12x16 font
	LoaderApiEntryIndex=LOADER_FONT_12x16_ARTDECO;	// 3040 bytes
	LoaderApiAddress=FontBuffer;
	SetLoadAddress();
	LoadFile();

	// Some basic inits
	InitTransitionData();

	// Install the IRQ handler
	System_InstallIRQ_SimpleVbl();

	// Play the black & white retro intro
	//RetroIntro();

	// Start the scroller
	ScrollerInit();

	while (1)
	{		
		// Change the music if necessary
		if (!MusicPlaying)
		{
			if ( (CurrentMusic<LOADER_FIRST_MUSIC) || (CurrentMusic>=LOADER_LAST_MUSIC) )
			{
				CurrentMusic=LOADER_FIRST_MUSIC;
			}
			LoaderApiEntryIndex=CurrentMusic++;
			LoadFile();
			Mym_Initialize();
		}

		// Next picture
		if ( (CurrentPicture<LOADER_FIRST_PICTURE) || (CurrentPicture>=LOADER_LAST_PICTURE) )
		{
			CurrentPicture=LOADER_FIRST_PICTURE;
		}
		LoaderApiEntryIndex=CurrentPicture++;			
		LoaderApiAddress=PictureLoadBuffer;
		SetLoadAddress();
		LoadFile();

		PictureDoTransition();
		//PictureTransitionVenicianStore();

		Pause(50*15);

		VSync();
	}

	//memset((unsigned char*)0xa000,0,8000);	
}




