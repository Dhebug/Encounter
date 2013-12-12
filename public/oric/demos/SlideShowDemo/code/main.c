//
// This program simply display a picture on the hires screen
//
#include <lib.h>

#include "floppy_description.h"

// irq.s
extern void System_InstallIRQ_SimpleVbl();
extern void VSync();

// player.s
extern unsigned char MusicLooped;
extern Mym_Initialize();
extern Mym_ReInitialize();

// loader_api.s
extern unsigned char LoaderApiEntryIndex;
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
//int CounterMusicWhatever=50*2;

void main()
{
	int y;
	if (!is_overlay_enabled())
	{
		hires();
	}
	MusicLooped=1;

	System_InstallIRQ_SimpleVbl();
	LoaderApiEntryIndex=LOADER_FIRST_MUSIC+1;
	//LoadFile();
	//Mym_ReInitialize();

	while (1)
	{		
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
		
		//--CounterMusicWhatever;
         
		for (LoaderApiEntryIndex=LOADER_FIRST_PICTURE;LoaderApiEntryIndex<LOADER_LAST_PICTURE;LoaderApiEntryIndex++)
		{
			LoadFile();
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

	memset((unsigned char*)0xa000,0,8000);	
}

