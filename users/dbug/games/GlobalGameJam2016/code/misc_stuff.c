


#ifdef ENABLE_FUNCOM_LOGO_INTRO
	// Load the Funcom Logo and put it on the screen hidden
	{
		char* screen;
		int y;

		LoaderApiEntryIndex=LOADER_FUNCOM_LOGO;
		LoaderApiAddress=(void*)0x400;
		SetLoadAddress();
		LoadFile();

		screen=(char*)0xa000;
		for (y=0;y<200;y++)
		{
			screen[0]=0;		// Black ink
			memcpy(screen+1,LoaderApiAddress+1,39);
			screen+=40;
			LoaderApiAddress+=40;
		}
	}
#endif

	/*
	// Check the keyboard status
	while (1)
	{
		unsigned char* screen=(unsigned char*)0xbb80+40*25;
		if (KeyboardState & 1)	*screen++=16+1; else *screen++=16+2;
		if (KeyboardState & 2)	*screen++=16+1; else *screen++=16+2;
		if (KeyboardState & 4)	*screen++=16+1; else *screen++=16+2;
		if (KeyboardState & 8)	*screen++=16+1; else *screen++=16+2;
		if (KeyboardState & 16)	*screen++=16+1; else *screen++=16+2;
	}
	*/

	/*
// Entry #5 '..\build\files\FuncomJingle.raw'
// - Loads at address 1024 starts on track 1 sector 6 and is 22 sectors long (5610 compressed bytes: 17% of 32918 bytes).
	LoaderApiEntryIndex=LOADER_FUNCOM_JINGLE;
	//LoaderApiAddress=PictureLoadingBuffer;
	//SetLoadAddress();
	LoadFile();
	*/

#ifdef ENABLE_FUNCOM_JINGLE
	// Play the digit
	DigiPlayer_InstallIrq();
#endif

#ifdef ENABLE_FUNCOM_LOGO_INTRO
	// Show the funcom logo progressively while the sample plays
	{
		char* screen1;
		char* screen2;
		int y,i;

		screen1=(char*)0xa000;
		screen2=(char*)0xa000+199*40;
		for (y=0;y<100;y++)
		{
			screen1[40*0]=1;		// Red ink
			screen1[40*1]=3;		// Yellow ink
			screen1[40*2]=7;		// White ink
			screen1+=40;

			screen2[-40*2]=7;		// White ink
			screen2[-40*1]=3;		// Yellow ink
			screen2[-40*0]=1;		// Red ink
			screen2-=40;

			for (i=0;i<450;i++)
			{

			}
		}

		// Then all in yellow
		screen1=(char*)0xa000;
		for (y=0;y<200;y++)
		{
			screen1[40*0]=3;		// Yellow ink
			screen1+=40;
		}	

		// Then all in white
		screen1=(char*)0xa000;
		for (y=0;y<200;y++)
		{
			screen1[40*0]=7;		// White ink
			screen1+=40;
		}

		// Then all in cyan
		screen1=(char*)0xa000;
		for (y=0;y<200;y++)
		{
			screen1[40*0]=6;		// Cyan ink
			screen1+=40;
		}

		// Then all in blue
		screen1=(char*)0xa000;
		for (y=0;y<200;y++)
		{
			screen1[40*0]=4;		// Blue ink
			screen1+=40;
		}

	}
#endif



	{
#ifdef ENABLE_GAMEJAM_LOGO
		LoaderApiEntryIndex=LOADER_GAMEJAM_LOGO;
		LoaderApiAddress=BufferPicture1;
		SetLoadAddress();
		LoadFile();
#endif		

#ifdef ENABLE_FUNCOM_LOGO
		LoaderApiEntryIndex=LOADER_FUNCOM_LOGO;
		LoaderApiAddress=BufferPicture2;
		SetLoadAddress();
		LoadFile();
#endif	

#ifdef ENABLE_VALP_ANIMATION	
		LoaderApiEntryIndex=LOADER_VALP_OUTLINE;
		LoaderApiAddress=BufferPicture3;
		SetLoadAddress();
		LoadFile();
#endif		
	}

	// And final forever loop
	while(1)
	{
#ifdef ENABLE_PRESS_FIRE_TO_START
		ShowPressFireMessage();
#endif	

#ifdef ENABLE_MAIN_MENU
		ShowGameMenu();
#endif		

	}




/*

Funcom Jingle:
- 66398 bytes - 8 bits mono 8khz
- 32918 bytes - 4 bits modo 4khz

Total amount of memory available:
from $400 to $9800 = 37888 bytes


*/

