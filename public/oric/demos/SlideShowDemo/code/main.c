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
extern unsigned char MusicLooped;
extern Mym_Initialize();
extern Mym_ReInitialize();

// transitions.s
extern unsigned char PictureLoadBuffer[];
extern void PictureTransitionFromTopAndBottom();
extern void PictureTransitionVenicianStore();
extern void PictureTransitionUnroll();

extern void PictureDoTransition();

extern void PrintDescription();


extern void InitTransitionData();

// scroller.s
extern unsigned char FontBuffer[];


// loader_api.s
extern unsigned char LoaderApiEntryIndex;
extern unsigned char LoaderApiAddressLow;
extern unsigned char LoaderApiAddressHigh;
extern void* LoaderApiAddress;

extern void SetLoadAddress();
extern void LoadFile();

void Pause()
{
	int i;
	for (i=0;i<50*5;i++)
	{
		VSync();
	}
}

extern void Player_SetMusic_Birthday();

unsigned char CurrentMusic=LOADER_FIRST_MUSIC;

/*
void PrintDescription(const char* author,const char* name)
{
	char* textLine;

	textLine=(char*)0xbb80+40*25;
	memset(textLine,32,40);

	memcpy(textLine,author,strlen(author));
	memcpy(textLine+20,name,strlen(name));
}
*/

void main()
{
	int y;
	if (!is_overlay_enabled())
	{
		hires();
	}
	MusicLooped=1;

	// Load the 6x8 font
	LoaderApiEntryIndex=LOADER_FONT_6x8_ARTDECO;
	LoadFile();

	// Some basic inits
	InitTransitionData();

	System_InstallIRQ_SimpleVbl();

	// Load and play the music
	LoaderApiEntryIndex=LOADER_FIRST_MUSIC+2;
	LoadFile();
	Mym_ReInitialize();

    // Load the font
	LoaderApiEntryIndex=LOADER_FONT_24x20;
	LoaderApiAddress=FontBuffer;
	SetLoadAddress();
	LoadFile();

	/*
	// Test load compressed file
	LoaderApiEntryIndex=LOADER_COMPRESSED_TEST;
	LoaderApiAddress=PictureLoadBuffer+8;
	SetLoadAddress();
	LoadFile();

	PictureLoadBuffer[0]='L';
	PictureLoadBuffer[1]='Z';
	PictureLoadBuffer[2]='7';
	PictureLoadBuffer[3]='7';
	*((int*)(PictureLoadBuffer+4))=8000;		// Src size
	*((int*)(PictureLoadBuffer+6))=8000;		// Dst size

	Stop();
	file_unpack((unsigned char*)0xa000,PictureLoadBuffer);
	*/


	while (1)
	{		
		/*
		if (MusicLooped)
		{
			poke(0xbb80+40*25,16 | ((peek(0xbb80+40*25)+1)&7) );
			//MusicPlaying=1;
			if ( (CurrentMusic<LOADER_FIRST_MUSIC) || (CurrentMusic>=LOADER_LAST_MUSIC) )
			{
				CurrentMusic=LOADER_FIRST_MUSIC;
			}
			LoaderApiEntryIndex=CurrentMusic;
			LoadFile();
			Mym_ReInitialize();
			++CurrentMusic;
		}
		*/
         
		for (LoaderApiEntryIndex=LOADER_FIRST_PICTURE;LoaderApiEntryIndex<LOADER_LAST_PICTURE;LoaderApiEntryIndex++)
		{
			LoaderApiAddress=PictureLoadBuffer;
			SetLoadAddress();
			LoadFile();

			//memcpy((unsigned char*)0xa000,PictureLoadBuffer,8000);
			//PictureTransitionFromTopAndBottom();
			//PictureTransitionVenicianStore();
			//PictureTransitionUnroll();
			//PrintDescription("Twilighte","Barbitoric");
			PrintDescription();
			PictureDoTransition();

			Pause();
		}

		/*
		for (LoaderApiEntryIndex=LOADER_FIRST_MUSIC;LoaderApiEntryIndex<LOADER_LAST_MUSIC;LoaderApiEntryIndex++)
		{
			LoadFile();
			Mym_Initialize();
			//Pause();
		}
		*/
		VSync();
	}

	//memset((unsigned char*)0xa000,0,8000);	
}




