//
// Global Game Jam 2015
// (c) 2015 Mickael Pointier and Funcom
//

#include <lib.h>

#include "defines.h"
#include "floppy_description.h"

// irq.s
extern void System_InstallIRQ_SimpleVbl();
extern void VSync();
extern void Stop();
extern unsigned char KeyboardState;
extern unsigned char KeyboardStateMemorized;

// buffer.s
extern unsigned char Font6x6[];

extern unsigned char TableDivBy6[];
extern unsigned char TableModulo6[];

extern char BufferPicture1[];
extern char BufferPicture2[];
extern char BufferPicture3[];
extern char BufferPicture4[];


extern void InitializeTables();

// screen.s
extern unsigned char OsloLocation;
extern unsigned char ShowingOsloMap;
extern unsigned char NextLocation;
extern unsigned char AvailableActions;
extern unsigned char CurrentMenuAction;
extern unsigned char GameOver;

extern unsigned char VisitedLocations[];

// loader_api.s
extern unsigned char LoaderApiEntryIndex;
extern unsigned char LoaderApiAddressLow;
extern unsigned char LoaderApiAddressHigh;
extern char* LoaderApiAddress;

extern void SetLoadAddress();
extern void LoadFile();

// messages.s
extern char* PrintScreenPtr;
extern char* PrintMessagePtr;
extern char MessagePressFireToStart[];
extern char MessageGameMenu[];
extern char MessageTodayBestScores[];
extern char MessageGameStory[];

extern char MessageCurrentLocation[];
extern char MessageNextLocation[];
extern char MessageAlreadyVisited[];

extern char MessageCopyright[];


//extern char MessagePlace_Viggeland[];



	char* screen;
	char* picture;
	int x,y;



void Pause(int delay)
{
	int i;

	for (i=0;i<delay;i++)
	{
		VSync();
	}
}


void PauseCheckKeyboard(int delay)
{
	int i;

	for (i=0;i<delay;i++)
	{
		if (KeyboardStateMemorized & 16)
		{
			return;
		} 
		VSync();
	}
}


char IsHires=1;

void EraseBottomTextArea()
{
	memset((unsigned char*)0xbb80+40*25,32,40*3);
}

void EraseAllHires()
{
	memset((unsigned char*)0xa000,64,40*200);	
}

void SwitchToText()
{
	if (IsHires)
	{
		// If not in TEXT; we need to switch from HIRES to TEXT
		memset((unsigned char*)0xa000,0,40*200);									// Clear the entire HIRES area with black ink
		poke((char*)0xbfdf,26);														// 50hz Text attribute
		VSync();
		VSync();
		memcpy((unsigned char*)0xb400,(unsigned char*)0x9800,0xbb80-0xb400);		// Move the charsets from BOTTOM to TOP
		memset((unsigned char*)0xbb80,32,40*25);									// Fill the entire HIRES area with spaces
	}
	IsHires=0;
}

void SwitchToHires()
{
	if (!IsHires)
	{
		// If not in HIRES; we need to switch from TEXT to HIRES
		memcpy((unsigned char*)0x9800,(unsigned char*)0xb400,0xbb80-0xb400);		// Move the charsets from TOP to BOTTOM
		memset((unsigned char*)0xa000,0,40*200);									// Clear the entire HIRES area with black ink
		poke((char*)0xbfdf,30);														// 50hz Graphics attribute
		VSync();
		VSync();
		memset((unsigned char*)0xa000,64,40*200);									// Fill the entire HIRES area with neutral 64 value
	}
	IsHires=1;
    InitialiseFontColors();		// Hack to get the color attributes inside the first bytes of the font so I get colors in HIRES
}


//
// The menu is shown in TEXT mode
//
void ShowGameMenu()
{
	SwitchToText();

	strcpy((char*)0xbb80+40*5+9,MessageGameMenu);
	

	Pause(50);

	SwitchToHires();
}


//
// People are always happy to see their best scores
//
void ShowHighScoreTable()
{
	SwitchToText();

	strcpy((char*)0xbb80+40*5+9,MessageTodayBestScores);

	if (!(KeyboardStateMemorized & 16)) PauseCheckKeyboard(50*2);
}



void ShowStoryPage()
{
	SwitchToHires();

	InitTransitionDataBuffer4();
	PictureTransitionVenicianStore();

	if (!(KeyboardStateMemorized & 16)) PauseCheckKeyboard(50*12);
}

void ShowGameJamLogo()
{
	SwitchToHires();

	InitTransitionDataBuffer1();
	PictureTransitionUnroll();

	if (!(KeyboardStateMemorized & 16)) PauseCheckKeyboard(50*2);
}


void ShowFuncomLogo()
{
	SwitchToHires();

	InitTransitionDataBuffer2();
	PictureTransitionVenicianStore();

	if (!(KeyboardStateMemorized & 16)) PauseCheckKeyboard(50*2);
}


void ShowValpAnimation()
{
	SwitchToHires();

	// Put the colors
	screen=(char*)0xa000;
	for (y=0;y<200;y++)
	{
		if (y<163)
		{
			screen[0]=4;		// Blue ink
			memset(screen+1+x,64+1+2+4+8+16+32,39);
		}
		else
		{
			screen[0]=0;		// Black ink (ground)
		}
		screen+=40;
	}

	// Scroll the car
	for (x=0;x<38;x++)
	{	
		screen=(char*)0xa000+40*50;
		picture=BufferPicture3+40*50;
		for (y=50;y<163;y++)
		{
			memcpy(screen+1,picture+39-x,x+1);
			screen+=40;
			picture+=40;
		}
		VSync();
		VSync();
	}

	Pause(50);

	// Add the Defence Force logo
	// 8x88
	screen=(char*)0xa000+40*88+7;
	picture=BufferPicture3+40*168+8;
	for (y=0;y<16;y++)
	{
		screen[-1]=2;	// Green Ink
		screen[28]=4;	// Blue Ink
		memcpy(screen,picture,28);
		screen+=40;
		picture+=40;
	}

	Pause(50*4);
}


void UpdateClockDisplay()
{
	ShowTimeOfTheDay();
}




void ShowMockupUi()
{
	SwitchToHires();

	// Place description at the bottom
	EraseBottomTextArea();

	// Date at the top
	screen=(char*)0xa000;
	memset(screen,(16+4)|128,40);
	screen+=40;
	for (y=0;y<8;y++)
	{
		memset(screen,64,29);
		screen+=40;
	}
	memset(screen,(16+4)|128,29);
	screen+=40;
	ShowTimeOfTheDay();

	// Options at the right
	screen=(char*)0xa000+40;
	for (y=0;y<198;y++)
	{
		screen[29]=(16+4)|128;
		screen[30]=6;
		memset(screen+31,64,9);
		screen+=40;
	}
	ShowPlayerStatus();

	// Name of the place at the bottom
	screen=(char*)0xa000+40*190;
	memset(screen,(16+4)|128,29);
	screen+=40;
	for (y=0;y<8;y++)
	{
		screen[0]=16+4;
		screen[1]=6;
		memset(screen+2,64,27);
		screen+=40;
	}
	memset(screen,(16+4)|128,40);

	if (ShowingOsloMap)
	{
		LoaderApiEntryIndex=LOADER_OSLO_MAP;
	}
	else
	{
		LoaderApiEntryIndex=OsloLocation;		
		//ShowActionMenu();
	}

	// Picture at the center
	//LoaderApiEntryIndex=OsloLocation;
	LoaderApiAddress=BufferPicture1;
	SetLoadAddress();
	LoadFile();

	screen=(char*)0xa000+40*10;
	picture=BufferPicture1;
	for (y=0;y<180;y++)
	{
		memcpy(screen,picture,29);
		screen+=40;
		picture+=29;
	}

	// Description of  the place at the bottom
	//LoaderApiEntryIndex=OsloLocation;
	PrintScreenPtr=(char*)0xbb80+40*25;
	PrintText();

	// Name of the place
	//LoaderApiEntryIndex=OsloLocation;
	PrintScreenPtr=(char*)0xa000+40*191+2;
	PrintHires();
	
	if (ShowingOsloMap)
	{
		//_MessageCurrentLocation	.byt "Current Location:",0
		//_MessageNextLocation	.byt "Now, go to:",0
		PrintMessagePtr=MessageCurrentLocation;
		PrintScreenPtr=(char*)0xbb80+40*26;
		PrintSelectedText();

		LoaderApiEntryIndex=OsloLocation;		
		PrintLocationText();
	}

	//Pause(50*2);
}


void ShowNextLocation()
{
	PrintMessagePtr=MessageNextLocation;
	PrintScreenPtr=(char*)0xbb80+40*27;
	PrintSelectedText();

	LoaderApiEntryIndex=NextLocation;		
	PrintLocationText();

	// Display if the place was already visited or not
	if (VisitedLocations[NextLocation-LOADER_LOCATION_FIRST])
	{
		PrintMessagePtr=MessageAlreadyVisited;
		PrintSelectedText();
	}

	PrintScreenPtr[0]=0;  // Black attribute at the end of the location text
}


void ChooseLocation()
{
	ShowingOsloMap=1;
	NextLocation=OsloLocation;
	ShowMockupUi();	
	ShowNextLocation();	
	// Anti bounce
	while (KeyboardState) {}
	do
	{	
		if (KeyboardState&(MOVEMENT_LEFT|MOVEMENT_UP))
		{
			NextLocation--;
			if (NextLocation<LOADER_LOCATION_FIRST)
			{
				NextLocation=LOADER_LOCATION_LAST-1;
			}
			ShowNextLocation();	
			// Anti bounce
			while (KeyboardState) {}
		}
		else
		if (KeyboardState&(MOVEMENT_RIGHT|MOVEMENT_DOWN))
		{
			NextLocation++;
			if (NextLocation>=LOADER_LOCATION_LAST)
			{
				NextLocation=LOADER_LOCATION_FIRST;
			}
			ShowNextLocation();	
			// Anti bounce
			while (KeyboardState) {}
		}

		ShowLocationTarget();  // Temp
		VSync();
		VSync();
		ShowLocationTarget();  // Temp
		VSync();
		VSync();

		//DecrementMoney();  // Test
	}
	while ( (!(KeyboardState&MOVEMENT_FIRE)) && (!GameOver));

	ShowingOsloMap=0;

	//
	// New destination selected
	//
	if (NextLocation!=OsloLocation)
	{
		// The new destination is different from the current one,
		// we need to display the transportation mode to go from point A to point B
		MoveToNewLocation();
	}
}



void ManageLocation()
{
	while (1)
	{
		// Set the list of available options for the player in the menu
		GetPossibleActionsForLocation();
		//AvailableActions=255;
		CurrentMenuAction=0;

		ShowMockupUi();		

		while (KeyboardState) {}

		LoaderApiEntryIndex=OsloLocation;
		ShowActionMenu();

		do
		{
			//IncrementTime();
			UpdateClockDisplay();
			VSync();

			if (KeyboardState&(MOVEMENT_LEFT|MOVEMENT_UP))
			{
				do
				{
					CurrentMenuAction=(CurrentMenuAction-1)&7;
				}
				while (!(AvailableActions & (1<<CurrentMenuAction)));

				LoaderApiEntryIndex=OsloLocation;
				ShowActionMenu();
				// Anti bounce
				while (KeyboardState) {}
			}
			else
			if (KeyboardState&(MOVEMENT_RIGHT|MOVEMENT_DOWN))
			{
				do
				{
					CurrentMenuAction=(CurrentMenuAction+1)&7;
				}
				while (!(AvailableActions & (1<<CurrentMenuAction)));

				LoaderApiEntryIndex=OsloLocation;
				ShowActionMenu();
				// Anti bounce
				while (KeyboardState) {}
			}
		}
		while ( (!(KeyboardState&MOVEMENT_FIRE)) && (!GameOver));

		// Check the selected options
		if (CurrentMenuAction==ACTION_GIVE_UP)
		{
			GameOver=GAMEOVER_GAVEUP;
		}
		else
		if (CurrentMenuAction==ACTION_BUY_PASS)
		{
			BuyOsloPass();
		}
		else
		if (CurrentMenuAction==ACTION_DISCOVER)
		{
			VisitLocation();
		}
		else			
		if (CurrentMenuAction==ACTION_LEAVE)
		{
			// We go to the location selection screen
			return;
		}
		else			
		if (CurrentMenuAction==ACTION_AIRPORT)
		{
			// We go to the location selection screen
			GameOver=GAMEOVER_VICTORY;
			return;
		}

		if (GameOver)
		{
			return;
		}
	}
}


void ShowTitleScreen()
{
	SwitchToHires();

	LoaderApiEntryIndex=LOADER_TITLE_SCREEN;
	LoaderApiAddress=BufferPicture1;
	SetLoadAddress();
	LoadFile();

	InitTransitionDataBuffer1();
	PictureTransitionUnroll();

	EraseBottomTextArea();	

	Pause(50);

	PrintMessagePtr=MessageCopyright;
	PrintScreenPtr=(char*)0xbb80+40*26+2;
	PrintSelectedText();

	Pause(50*3);

	EraseBottomTextArea();	

	Pause(50);

	//EraseAllHires();
}


void ShowAttractMode()
{
	ShowTitleScreen();

	//
	// Load all the pictures we need for the attract sequence
	//
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

#ifdef ENABLE_STORY_PAGE
	LoaderApiEntryIndex=LOADER_HOW_TO_PLAY;
	LoaderApiAddress=BufferPicture4;
	SetLoadAddress();
	LoadFile();
#endif		

	// Erase the three bottom lines of text
	EraseBottomTextArea();

	// Anti bounce
	while (KeyboardState & 16) {}

	// Print the 'PressFireToStart' message
	strcpy((char*)0xbb80+40*26+9,MessagePressFireToStart);
	strcpy((char*)0xbb80+40*27+9,MessagePressFireToStart);

	// Wait for the fire button to be pressed
	//poke((char*)0xbb80+40*25,16+1);
	KeyboardStateMemorized=0;
	while (!(KeyboardStateMemorized & 16)) 
	{
#ifdef ENABLE_STORY_PAGE
		if (!(KeyboardStateMemorized & 16))  ShowStoryPage();
#endif		

#ifdef ENABLE_GAMEJAM_LOGO
		if (!(KeyboardStateMemorized & 16))  ShowGameJamLogo();
#endif		

#ifdef ENABLE_FUNCOM_LOGO
		if (!(KeyboardStateMemorized & 16))  ShowFuncomLogo();
#endif				

#ifdef ENABLE_VALP_ANIMATION	
		if (!(KeyboardStateMemorized & 16))  ShowValpAnimation();
#endif		

#ifdef ENABLE_SHOW_HIGH_SCORES
		// Show the high scores
		if (!(KeyboardStateMemorized & 16))  ShowHighScoreTable();
#endif		


#ifdef ENABLE_SHOW_GAME_STORY		
		// Show the story of the game
		if (!(KeyboardStateMemorized & 16))  ShowGameStory();
#endif		
	}
	EraseBottomTextArea();

	// Anti bounce
	//poke((char*)0xbb80+40*25,16+2);
	while (KeyboardState & 16) {}
}


extern char MessageTotalScore[];
extern char MessageScoreValue[];

void ShowTotalScore()
{
	EraseBottomTextArea();	

	ComputeScore();

	Pause(50*3);
}


// Load some logos and stuff
void GameLoop()	
{
	while (1)
	{
#ifdef ENABLE_INTRO_SEQUENCE		
		ShowAttractMode();
#endif
		InitialiseGame();

		while (!GameOver)
		{
			// Select the location
			ChooseLocation();

			if (!GameOver)
			{
				// Handle the location menus
				ManageLocation();				
			}
		}

		// Let's say it's a game over man!
		if (GameOver==GAMEOVER_GAVEUP)
		{
			LoaderApiEntryIndex=LOADER_ENDING_GIVEUP;			
		}
		else
		if (GameOver==GAMEOVER_NO_MORE_MONEY)
		{
			LoaderApiEntryIndex=LOADER_ENDING_OUT_OF_MONEY;			
		}
		else
		if (GameOver==GAMEOVER_TIME_UP)
		{
			LoaderApiEntryIndex=LOADER_ENDING_OUT_OF_TIME;			
		}
		else
		if (GameOver==GAMEOVER_VICTORY)
		{
			LoaderApiEntryIndex=LOADER_ENDING_VICTORY;			
		}
		else
		{
			LoaderApiEntryIndex=LOADER_ENDING_GIVEUP;			
		}
		LoaderApiAddress=BufferPicture1;
		SetLoadAddress();
		LoadFile();

		InitTransitionDataBuffer1();
		PictureTransitionUnroll();

		EraseBottomTextArea();

		ShowTotalScore();


		Pause(50*2);
	
	}
}


//
// Press START is shown in the three bottom lines of the screen
//
void ShowPressFireMessage()
{
	// Erase the three bottom lines of text
	memset((unsigned char*)0xbb80+40*25,16+4,40*3);

	// Anti bounce
	while (KeyboardState & 16) {}

	// Print the 'PressFireToStart' message
	strcpy((char*)0xbb80+40*26+9,MessagePressFireToStart);
	strcpy((char*)0xbb80+40*27+9,MessagePressFireToStart);

	// Wait for the fire button to be pressed
	poke((char*)0xbb80+40*25,16+1);
	while (!(KeyboardState & 16)) 
	{
#ifdef ENABLE_VALP_ANIMATION	
		ShowValpAnimation();
#endif		

#ifdef ENABLE_GAMEJAM_LOGO
		ShowGameJamLogo();
#endif		

#ifdef ENABLE_SHOW_HIGH_SCORES
		// Show the high scores
		ShowHighScoreTable();
#endif		

#ifdef ENABLE_FUNCOM_LOGO
		ShowFuncomLogo();
#endif				
	}

	// Anti bounce
	poke((char*)0xbb80+40*25,16+2);
	while (KeyboardState & 16) {}

	// Erase the three bottom lines of text
	memset((unsigned char*)0xbb80+40*25,64,40*3);
}




void main()
{
	// Clear the screen
	IsHires=1;
	memset((unsigned char*)0xa000,64,8000);
	memset((unsigned char*)0xbb80+25*40,32,40*3);

	// Install the IRQ handler
	System_InstallIRQ_SimpleVbl();

	// Initialize stuff
	InitializeTables();

	// Load the 6x8 font
	LoaderApiEntryIndex=LOADER_FONT_6x8;
	LoadFile();


	GameLoop();

}

