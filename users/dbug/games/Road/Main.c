// --------------------------------------
//        Quantum Fx Turbo Ultra
// --------------------------------------
// (c) 2002-2018 Mickael Pointier.
// This code is provided as-is.
// I do not assume any responsability
// concerning the fact this is a bug-free
// software !!!
// Except that, you can use this example
// without any limitation !
// If you manage to do something with that
// please, contact me :)
// --------------------------------------
// --------------------------------------
// For more information, please contact me
// on internet:
// e-mail: mike@defence-force.org
// URL: http://www.defence-force.org
// --------------------------------------
// Note: This text was typed with a Win32
// editor. So perhaps the text will not be
// displayed correctly with other OS.
// --------------------------------------
// Release Notes:
// V1.0 - Dec 16 2018
// - First version sent to CEO
//
// V1.1
// - Added the version number on the attract mode page
// - Fixed some issues with the road curvature
// - Enabled audio on race start when filling energy
// - Added some basic scoring system
//



#include "lib.h"
#include "profile.h"

extern void Tables_InitialiseScreenAddrTable();

extern void TurnLeftSimple();
extern void TurnRightSimple();
extern void ScrollColors();

void VSync();

void Temporize();

void ReadKeyboard();

extern unsigned char DrawBarX;
extern unsigned char DrawBarValue;

void DrawBar();

unsigned char RasterY=72;


// === Resol.s ===
void ResolSwitchToHires();
void ResolClearText();


void RoadErase();

void DrawGameLogo();
void AnimateGameLogoRasters();

void EraseDrawRoadSign();
void DrawRoadSign();
void ClearRoadArea();
void DisplayEnergySpeed();


void DrawText();
void EraseEvenLines();
void System_Initialize();

void HandleGamePlay();	

void PsgStopSound();


extern unsigned char picture_font_1[];

extern unsigned char CosTable[];
extern unsigned char LeftTable[];


//extern int RoadMiddleTable[128];
extern char RoadMiddleTableLow[];
extern char RoadMiddleTableHigh[];

//extern int RoadOffsetTable[128];
extern char RoadOffsetTableLow[];
extern char RoadOffsetTableHigh[];

extern char RoadWidthTable[];

extern unsigned char Rasters[];
extern unsigned char AttractModeSequence;


extern unsigned char* TrackDataPtr;
extern unsigned char TrackData[];

extern unsigned char RoadSignLow;
extern unsigned char RoadSignHigh;

extern int	Position;

extern char Raster1[];

extern unsigned char DivTable[];



extern UpdatePsgRegisters();

extern unsigned int  PsgfreqA;          //  0 1
extern unsigned int  PsgfreqB;          //  2 3
extern unsigned int  PsgfreqC;          //  4 5
extern unsigned char PsgfreqNoise;     //  6
extern unsigned char Psgmixer;         //  7
extern unsigned char PsgvolumeA;       //  8
extern unsigned char PsgvolumeB;       //  9
extern unsigned char PsgvolumeC;       // 10
extern unsigned int  PsgfreqShape;      // 11 12 
extern unsigned char PsgenvShape;      // 13

extern unsigned char PlayerEnergy;
extern unsigned char PlayerSpeed;


void PressSpaceToStart()
{
	memset((char*)0xbb80+25*40,32,40*3);
	sprintf((char*)0xbb80+26*40+1,"\16\7ACTIVATE QUANTUM ACTIVATOR TO START");
	sprintf((char*)0xbb80+27*40+1,"\16\6ACTIVATE QUANTUM ACTIVATOR TO START");
}


void EraseSpaceToStart()
{
	memset((char*)0xbb80+25*40,32,40*3);
}



void CreateDivTable()
{
	int		y;

	for (y=0;y<128;y++)
	{
		//
		// Fill div table
		//
		DivTable[y]=(4096/(y+16))>>2;
	}
}




void ScrollColorsC()
{
	unsigned char 	f;
	int		y;
	char	*adr;
	int		position;

	PROFILE_ENTER(ROUTINE_SCROLL_COLORS);

	position=Position;
	//Position+=2;
	Position+=1;
	adr=((char*)0xa000)+40*72;

	for (y=0;y<128;y++)
	{
		f=(DivTable[y]+position);

		if (y&1)
		{
			adr[1]=Raster1[f&31];
		}

		adr+=40;
	}
	PROFILE_LEAVE(ROUTINE_SCROLL_COLORS);
}




void DrawRasters()
{
	unsigned char *ptr_screen;
	unsigned char y;

	ptr_screen=(unsigned char*)0xa000;
	for (y=0;y<200;y++)
	{
		*ptr_screen=Rasters[y];
		ptr_screen+=40;
	}
}






void CreateTable()
{
	int y;
	int offset;

	for (y=0;y<128;y++)
	{
		RoadMiddleTableLow[y]	=0;
		RoadMiddleTableHigh[y]	=0;

		RoadWidthTable[y]	=-(100*y)/128;

		offset=((int)LeftTable[y]-(120+(int)RoadWidthTable[y]))*2;	// *256/128
		RoadOffsetTableLow[y]	=offset&255;
		RoadOffsetTableHigh[y]	=(offset>>8)&255;
	}
}


extern unsigned char gKey;
extern unsigned char PlayerPodX;
extern unsigned char BackgroundPosition;

void RoadDrawLoopASM();
void DrawBackground();
void DrawPlayerPod();
void AttractModeTextDisplay();
void EraseEvenLines();

void PlayerPodMoveLeft();
void PlayerPodMoveRight();

void DrawTriangularRoadArea();


void FillUpEnergy();


void EraseTopOfScreen()
{
	int y;
	for (y=0;y<65;y++)
	{
		memset(0xa000+y*40+2,64,38);
	}
}


void StartGame()
{
	TrackDataPtr=TrackData;
	PlayerPodX=100;

	AttractModeSequence=0;
	EraseEvenLines();
	EraseSpaceToStart();
	EraseTopOfScreen();

	ClearRoadArea();
	CreateTable();
	DisplayEnergySpeed();

	DrawTriangularRoadArea();
	RoadDrawLoopASM();
	DrawPlayerPod();
	EraseSpaceToStart();
	DisplayScore();

	FillUpEnergy();
}


void StartAttractMode()
{
	PlayerEnergy=255;
	AttractModeSequence=1;
	PsgStopSound();

	EraseEvenLines();
	EraseTopOfScreen();

	ClearRoadArea();
	CreateTable();

	DrawRasters();

	DrawGameLogo();

	DrawTriangularRoadArea();
	RoadDrawLoopASM();

	PressSpaceToStart();

	TrackDataPtr=TrackData;
}

void GameOver()
{
	PsgExplode();

	//PsgStopSound();

	memset((char*)0xbb80+25*40,32,40*3);
	sprintf((char*)0xbb80+26*40+9,"\16\3QUANTUM POD DENERGIZED");
	sprintf((char*)0xbb80+27*40+9,"\16\1QUANTUM POD DENERGIZED");

	KeyboardFlush();
	while (gKey==0)
	{

	}

	PsgStopSound();
	StartAttractMode();	
}


char RoadDraw()
{
	char shouldRestart=0;

	PROFILE_ENTER(ROUTINE_DRAW_ROAD);
	ScrollColors();		
	//ScrollColorsC();

	PROFILE_ENTER(ROUTINE_DRAW_LOOP);
	RoadDrawLoopASM();


	PROFILE_LEAVE(ROUTINE_DRAW_LOOP);


	DrawBackground();

	if (AttractModeSequence)
	{
		// Attract mode
		if (gKey)
		{
			// Quit attract mode
			StartGame();
			shouldRestart=1;
		}
		else
		{
			AnimateGameLogoRasters();
			AttractModeTextDisplay();
		}
	}
	else
	{
		DrawPlayerPod();

		// Game mode
		if (gKey & 1)
		{
			PlayerPodMoveLeft();
			PlayerPodMoveLeft();
			if (gKey & 16)
			{
				// Turbo boost
				PlayerPodMoveLeft();
				PlayerPodMoveLeft();
				DecreaseEnergy();
			}
		}
		else
		if (gKey & 2)
		{
			PlayerPodMoveRight();
			PlayerPodMoveRight();
			if (gKey & 16)
			{
				// Turbo boost
				PlayerPodMoveRight();
				PlayerPodMoveRight();
				DecreaseEnergy();		
			}
		}
		else
		if (gKey & 16)			
		{
			// Pointless use of the turbo boost, just uses energy for nothing
			DecreaseEnergy();
		}

		IncrementScore();
	}

	// Centrifugal check
	{
		// RoadMiddleTableHigh[1] => position on the far corner of the road
		char centrifugal=RoadMiddleTableHigh[1];
		if (centrifugal<0)
		{
			if (centrifugal<-10)
			{
				BackgroundPosition--;
				PlayerPodMoveRight();
			}
			if (centrifugal<-20)
			{
				BackgroundPosition--;
				PlayerPodMoveRight();
			}
			if (centrifugal<-60)
			{
				BackgroundPosition--;
				PlayerPodMoveRight();
			}
		}
		else
		{
			if (centrifugal>10)
			{
				BackgroundPosition++;
				PlayerPodMoveLeft();
			}
			if (centrifugal>20)
			{
				BackgroundPosition++;
				PlayerPodMoveLeft();
			}
			if (centrifugal>60)
			{
				BackgroundPosition++;
				PlayerPodMoveLeft();
			}
		}
	}


	PROFILE_LEAVE(ROUTINE_DRAW_ROAD);

	return shouldRestart;
}


void TurnLeft(unsigned char count)
{
	unsigned char y;
	PROFILE_ENTER(ROUTINE_TURN_LOOP);
	while (count--)
	{
		TurnLeftSimple();
	}
	PROFILE_LEAVE(ROUTINE_TURN_LOOP);
}

void TurnRight(unsigned char count)
{
	unsigned char y;
	PROFILE_ENTER(ROUTINE_TURN_LOOP);

	while (count--)
	{
		TurnRightSimple();
	}
	PROFILE_LEAVE(ROUTINE_TURN_LOOP);
}



void RacingTest()
{
	StartAttractMode();

	TrackDataPtr=TrackData;

	while (1)
	{
		unsigned char counter=*TrackDataPtr++;
		if (!counter)
		{
			TrackDataPtr=TrackData;
		}
		else
		{
			if (counter==1)
			{
				// Road sign
				RoadSignLow=*TrackDataPtr++;
				RoadSignHigh=*TrackDataPtr++;
				if (!AttractModeSequence)
				{
					DrawRoadSign();				
				}
			}
			else
			{	
				char direction=(char)*TrackDataPtr++;
				//sprintf((char*)0xbb80+27*40,"Counter:%d Directiom:%d   ",counter,direction);
				while (counter--)
				{
					/*
					if (!AttractModeSequence)
					{
						sprintf((char*)0xbb80+25*40,"Energy:%d Speed:%d   ",PlayerEnergy,PlayerSpeed);
					}
					*/
					if (RoadDraw())
					{
						// Restart
						break;
					}
					if (direction)
					{
						if (direction<0)
						{
							TurnLeft(-direction);
						}
						else
						{
							TurnRight(direction);
						}
					}
					HandleGamePlay();
					if (PlayerEnergy==0)	
					{
						// Player is out of energy
						GameOver();						
					}
				}
			}
		}
	}
}



void main()
{
	paper(0);
	
	ProfilerInitialize();
	hires();
	ink(0);

	InitializeAlternateCharset();

	Tables_InitialiseScreenAddrTable();
	CreateDivTable();

	ClearRoadArea();
	CreateTable();

	DrawTriangularRoadArea();

	System_Initialize();

	//GameOver();

	RacingTest();
	ProfilerTerminate();
}


/*

Profiling results:

Frame:0014 Time=1BB1E0
0x01 1BB174 MainLoop
1x01 1B3DFC DrawRoad
2x01 00ABD7 ScrollColors
3x01 006F5E TurnLoop
4x01 1A8F2F DrawLoop
5x00 000000 Asm
-----------------------------
Frame:0001 Time=1B456A
0x01 1B44FE MainLoop
1x01 1B2E5A DrawRoad
2x01 00ABD7 ScrollColors
3x01 0012CC TurnLoop                   <- simple assembler version for TurnLeft and TurnRight
4x01 1A7F8D DrawLoop
-----------------------------
Frame:0001 Time=1B4451                 <- Removed "Main Loop"
0x01 1B2D5A DrawRoad
1x01 00ABD7 ScrollColors
2x01 001254 TurnLoop
3x01 1A7F8D DrawLoop
------------------------------------------------------
Frame:0001 Time=18F1B6                 <- The tables are now 8 bit instead of 16
0x01 18DAD1 DrawRoad
1x01 0001F7 ScrollColors
2x01 001242 TurnLoop
3x01 18D8C1 DrawLoop
------------------------------------------------------
Frame:0001 Time=004B65 (19301)         <- ScrollColors in assembler as well as main draw loop
0x01 0036EC DrawRoad
1x01 000671 ScrollColors
2x01 001242 TurnLoop
3x01 003062 DrawLoop
------------------------------------------------------
Frame:0001 Time=004AE5 (19173)         <- Inlined the color computation
0x01 00366C DrawRoad
1x01 0004F1 ScrollColors
2x01 001242 TurnLoop
3x01 003062 DrawLoop
------------------------------------------------------
Frame:0001 Time=0031E5 (12773)         <- Inlined the entire road computation
0x01 001D6C DrawRoad
1x01 0004F1 ScrollColors
2x01 001242 TurnLoop
3x01 001762 DrawLoop
------------------------------------------------------
Frame:0001 Time=0026E4 (9956)          <- Inlined left and right turn
0x01 001D6C DrawRoad
1x01 0004F1 ScrollColors
2x01 000741 TurnLoop
3x01 001762 DrawLoop
------------------------------------------------------
Frame:0001 Time=002264 (8804)          <- Added the ora #64 at the table generation time
0x01 0018EC DrawRoad
1x01 0004F1 ScrollColors
2x01 000741 TurnLoop
3x01 0012E2 DrawLoop
------------------------------------------------------
Frame:0001 Time=002215 (8725)          <- "Position" is now a zero page variable
0x01 00189D DrawRoad
1x01 0004A2 ScrollColors
2x01 000741 TurnLoop
3x01 0012E2 DrawLoop




Paralax effect:
---------------
Need 6 times preshifted graphics and brute force copy

Screen is 40 bytes large, makes it 128 bytes large with duplicated 64 bytes
64 bytes is 384 pixels

Using a position pixel counter on one byte we can address 256 pixels
256 pixels is 42.6 bytes
512 pixels is 85.3 bytes

86 bytes * 6 shifts = 516 bytes


Fake title:
-----------
F-Zero
Wipeout
Quantum Redshift
Rush
Riders
Cyber
Drome
Purple Saturn Day

"Quantum FX Turbo Ultra"  -> Zuber Future € by Qbotype Fonts 

Fonts:
- Ethnocentric
- Fingerpop
- Good Times
- HarvestItal Regular
- Nasalization
- PhrasticMedium Regular


ENERGY

SPEED


*/







