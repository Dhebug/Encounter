//
// Kindergarden 2014
//
// Candidate titles:
// - Lost In Time
// - Backward
// - Memories
// - Inception
// - Timelords

// - BACKWARD <-> DRAWKCAB
// - LostInTime <-> emit ni tsol
//
// Greetings to:
// Contraz - Spaceballs - Outracks - Playpsycho - Darklight - Keyboarders - Apan Bepan - Nosfe - Conspiracy - #atari(fr|scne) - boozoholics - kewlers - penumbra - genesis project 
// Oxyron - Censor Design - Booze Design - Offence - Fairlight - Insane - Hoaxers - Resistance - Wrath Design - Panda Cube - Kvasigen - Dead Roman - Excess - Loonies - Fnuque - Youth Uprising - Ephidrena - Tufs - PWP
// From Fra: cyg^blabla, baudsurfer^rsi
// -> check the Solskogen/Kindergarden release lists
//

#define ENABLE_MUSIC

#define ENABLE_BOUNCING_TRIANGLE

#define ENABLE_MAIN_DEFENCE_FORCE_LOGO
#define ENABLE_AMIGA_RASTERS
#define ENABLE_KINDERGARDEN_LOGO
#define ENABLE_BIG_SCREEN_SEQUENCE
#define ENABLE_PARTY_OUTSIDE
#define ENABLE_TRIANGLES
#define ENABLE_CREDITS
#define ENABLE_BADE_STAMP
#define ENABLE_GREETINGS
#define ENABLE_CAKE_EFFECT
#define ENABLE_CAKE_FLAMES
#define ENABLE_TITLE_SCREEN

//#define ENABLE_AMIGA_RASTERS
//#define ENABLE_TRIANGLES
//#define ENABLE_PARTY_OUTSIDE
//#define ENABLE_TITLE_SCREEN

#define PARTY_OUTSIDE_DURATION	30	// 20=too short 		// 100=too long


#include <lib.h>

#include "floppy_description.h"
#include "loader_api.h"

extern void HandleRasters(unsigned int counter,unsigned char xposition);
extern void UpdateRasters(unsigned char xposition,unsigned char WhatToShow);

// irq.s
extern void System_InstallIRQ_SimpleVbl();
extern void VSync();
extern void Stop();

// player.s
extern volatile unsigned char MusicPlaying;
extern volatile unsigned int MusicResetCounter;
extern volatile unsigned int MusicTimer;

extern unsigned int MusicLength;
extern void Mym_MusicStart();
extern void Mym_MusicStop();

// buffer.s
extern unsigned char LogoBuffer[];
extern unsigned char PictureLoadingBuffer[];
extern unsigned char PictureLoadBuffer60x50[];
extern unsigned char LogoBuffer_MUsic[];
extern unsigned char LogoBuffer_Headed[];
extern unsigned char LogoBuffer_Fire[];
extern unsigned char ShiftedLogo[];

extern unsigned char Font6x6[];

extern unsigned char TableDivBy6[];
extern unsigned char TableModulo6[];
extern unsigned char BaseCosTable[];

extern void InitializeTables();

// sprites.s
void PreshiftSprite();



int EffectCounter=0;


#define _STRINGIFY(s) #s
#define STRINGIFY(s) _STRINGIFY(s)

// This one is to be used with the music counter
#define TIMING_ADDRESS ((unsigned char*)0xbb80+40*26+10) // 01 34 67
#define ComputePosition(minute,seconde,frame)		((minute*50*60)+(seconde*50)+frame)

#ifdef ENABLE_TIMING_DEBUGGING
#define WaitPosition(minute,seconde,frame)   {TIMING_ADDRESS[0]='0'+(minute/10);TIMING_ADDRESS[1]='0'+(minute%10);TIMING_ADDRESS[3]='0'+(seconde/10);TIMING_ADDRESS[4]='0'+(seconde%10);TIMING_ADDRESS[6]='0'+(frame/10);TIMING_ADDRESS[7]='0'+(frame%10);WaitPosition2(ComputePosition(minute,seconde,frame));}
#else
#define WaitPosition(minute,seconde,frame)   {WaitPosition2(ComputePosition(minute,seconde,frame));}
#endif

#define TestPosition(minute,seconde,frame)   (MusicTimer<ComputePosition(minute,seconde,frame))

void WaitPosition2(unsigned int positionToWait)
{
#ifdef ENABLE_TIMING_DEBUGGING
	TIMING_ADDRESS[-1]=2;
#endif	
	while (MusicTimer<positionToWait)
	{
		VSync();	
	}
#ifdef ENABLE_TIMING_DEBUGGING
	TIMING_ADDRESS[-1]=1;
#endif	
	//memset(TIMING_ADDRESS,32,8);
}



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

unsigned char CurrentMusic=0;
unsigned char CurrentPicture=0;
unsigned int PictureDelay=0;


int logoId=1;


extern unsigned char ColorTable[];

extern unsigned char xpos;
extern char xdir;

extern unsigned char ypos;
extern char ydir;

extern unsigned char BigAngle;

/*
#define MAX_X	(42)
#define MAX_Y	(97)

void ShowLogo()
{
	unsigned char angle;
	int y;
	unsigned char* buffer;
	unsigned char* screen;
	int shift_offset;

	unsigned char distortX;
	unsigned char bufferOffset;
	unsigned char screenOffset;

	xpos=xpos+xdir;
	if (xdir>0)
	{
		if (xpos>=MAX_X)
		{
			xpos=MAX_X;
			xdir=-xdir;
		}
	}
	else
	{
		if (xpos<=0)
		{
			xpos=0;
			xdir=-xdir;
		}
	}

	ypos=ypos+ydir;
	if (ydir>0)
	{
		if (ypos>=MAX_Y)
		{
			ypos=MAX_Y;
			ydir=-ydir;
		}
	}
	else
	{
		if (ypos<=53)
		{
			ypos=53;
			ydir=-ydir;
		}
	}

	angle=BigAngle;

	buffer=ShiftedLogo;		//+(xpos%6)*20;		//+logoId*2000;
	shift_offset=TableModulo6[xpos]*20;
	screen=(unsigned char*)0xa000+ypos*40+1;

	memset(screen,64,39);
	screen+=40;
	for (y=0;y<100;y++)
	{
		distortX=xpos+(BaseCosTable[angle]>>2);				// 0-255 /2=128 /4=64 /8=32
		angle+=1;
		bufferOffset=TableModulo6[distortX]*20;
		screenOffset=TableDivBy6[distortX];

		screen[screenOffset]=ColorTable[(ypos+y)&31];
		screen[screenOffset+21]=64;
		memcpy(screen+screenOffset+1,buffer+bufferOffset,20);
		screen+=40;
		buffer+=20*6;
	}
	memset(screen,64,39);

	BigAngle=BigAngle+1;

	//logoId=(logoId+1)%3;
}
*/

unsigned char* StartScreen120x100=(unsigned char*)0xa000+(52+22)*40+10;
unsigned char* StartScreen60x50  =(unsigned char*)0xa000+(52+22)*40+10+(38)*40+5;

void EraseScreen120(unsigned int offset,unsigned char height,unsigned char optionalpaper)
{
	unsigned char y;
	unsigned char* screen;

	screen=StartScreen120x100+offset;
	for (y=0;y<height;y++)
	{
		memset(screen,64,20);
		screen[-1]=16+0;
		if (optionalpaper)
		{
			screen[19]=optionalpaper;
		}		
		screen[20]=7;
		screen+=40;
	}
}


void EraseScreen60(unsigned int offset,unsigned char height,unsigned char optionalpaper)
{
	unsigned char y;
	unsigned char* screen;

	screen=StartScreen60x50+offset;
	for (y=0;y<height;y++)
	{
		memset(screen,64,10);
		screen[-1]=16+0;
		if (optionalpaper)
		{
			screen[9]=optionalpaper;
		}		
		screen[10]=7;
		screen+=40;
	}
}


/*
void ShowScreen120(unsigned int offset,unsigned char height,unsigned char* pictureStart)
{
	unsigned char y;
	unsigned char* screen;

	screen=StartScreen120x100+offset;
	for (y=0;y<height;y++)
	{
		memcpy(screen,pictureStart,20);
		screen[-1]=16+0;
		//screen[19]=7;
		screen[20]=7;
		screen+=40;
		pictureStart+=20;
	}
}
*/


unsigned char CurrentLogo=0;
extern unsigned char DisplayLogoSize;

extern unsigned char RegisterChanAFrequency;
extern unsigned char RegisterChanBFrequency;
extern unsigned char RegisterChanCFrequency;

extern unsigned char RegisterChanAVolume;
extern unsigned char RegisterChanBVolume;
extern unsigned char RegisterChanCVolume;

extern unsigned char CosTable[256];

void BounceTriangle(unsigned int duration)
{
	unsigned char angle;

	// Load the three logos
	LoadFileAt(LOADER_TRIANGLE_LOGOS,LogoBuffer);

	//DisplayLogoSize=50+RegisterChanBVolume;
	angle=0;
	while (duration--)
	{
		DisplayLogoSize=100-(CosTable[angle]>>2);
		DisplayMusicLogoStretch();
		VSync();
		angle+=7;
		//DisplayLogoSize--;
		/*
		while (DisplayLogoSize<100)
		{
			DisplayMusicLogoStretch();
			VSync();
			DisplayLogoSize++;
		}
		while (DisplayLogoSize>2)
		{
			DisplayMusicLogoStretch();
			VSync();
			DisplayLogoSize--;
		}
		*/
	}

    //while (1)
    {

    }
}

#if 0
void TriangleSequence(unsigned char finalLogo)
{
	int delayCount;
	int counter;
	int counterIncrement;

	// Load the kindergarden logo on the top of the screen in the buffer
	// Load the three logos
	LoadFileAt(LOADER_TRIANGLE_LOGOS,LogoBuffer);

	FadeToBlackBetweenRasters();
	ShowRasters();

	counter=1;
	counterIncrement=0;
	while ((counter<50) || (CurrentLogo!=finalLogo))
	{
		switch (CurrentLogo)
		{
		case 0:			
			DisplayMusicLogo();
			CurrentLogo=1;
			break;

		case 1:			
			DisplayHeadLogo();
			CurrentLogo=2;
			break;

		case 2:			
			DisplayFireLogo();
			CurrentLogo=0;
			break;
		}		
		if (counter>0)
		{
			Pause(counter);		
		}		
		counter+=counterIncrement;
		counterIncrement++;
	}

	/*
	// Display the triangle logos
	EffectCounter=2;
	while (EffectCounter--)
	{	
		Pause(50);
		DisplayMusicLogo();
		Pause(50);
		DisplayHeadLogo();
		Pause(50);
		DisplayFireLogo();
	}
	Pause(50);
	*/
}
#endif

#define EFFECT_FROM_TOP_TO_BOTTOM			0
#define EFFECT_FROM_OUTSIDE_TO_CENTER		1
#define FINISH_WITH_16                      64
#define EFFECT_VSYNC						128

void ShowPicture(unsigned char* destination,unsigned char* source,unsigned char height,unsigned char width,unsigned char effect)
{
	unsigned char y;
	unsigned char vsync;
	unsigned char finishWith16;

	vsync=0;
	if (effect&EFFECT_VSYNC)
	{
		vsync=1;
		effect&=~EFFECT_VSYNC;
	}

	finishWith16=0;
	if (effect&FINISH_WITH_16)
	{
		finishWith16=1;
		effect&=~FINISH_WITH_16;
	}

	if (effect==EFFECT_FROM_TOP_TO_BOTTOM)
	{	
		// From Top to Bottom
		for (y=0;y<height;y++)
		{
			if (finishWith16)
			{
				destination[width]=16;
			}
			memcpy(destination,source,width);
			destination+=40;
			source+=width;
			if (vsync)
			{
				VSync();
			}
		}
	}
	else
	if (effect==EFFECT_FROM_OUTSIDE_TO_CENTER)
	{	
		// From Top to Center and Bottom to Center
		unsigned char* destination2;
		unsigned char* source2;

		destination2=destination+40*height;
		source2     =source+width*height;
		for (y=0;y<height/2;y++)
		{
			if (finishWith16)
			{
				destination[width]=16;
			}
			memcpy(destination,source,width);
			destination+=40;
			source+=width;

			destination2-=40;
			source2-=width;
			if (finishWith16)
			{
				destination2[width]=16;
			}
			memcpy(destination2,source2,width);

			if (vsync)
			{
				VSync();
			}
		}
	}
}





typedef struct
{
	unsigned char *ptr_table;
	unsigned char prof;
	unsigned char angle;
	unsigned char speed;
}BIGRASTER;

typedef struct
{
	unsigned char *ptr_table;
	unsigned char prof;
	unsigned char y;
	unsigned char direction;
	unsigned char speed;
	unsigned char size_table;
}SMALLRASTER;



extern unsigned char BufferZ[];
extern unsigned char BufferPaper[];
extern unsigned char BufferInk[];
extern unsigned char RastersXOffset;


void RastersClearBuffer();
void RastersDisplayBuffer();

extern BIGRASTER	*RasterPointerBig;
void RastersDrawBig();

extern SMALLRASTER	*RasterPointerSmall;
void RastersDrawSmall();









/*
	0 16 noir
	1 17 rouge
	2 18 vert
	3 19 jaune
	4 20 bleu
	5 21 violet
	6 22 cyan
	7 23 blanc

*/

#define RASTERCOLOR(c0)	(16+c0)


// ================================= SMALL RASTERS
unsigned char SmallRedTable[]=
{
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(1),
	RASTERCOLOR(5),
	RASTERCOLOR(5),
	RASTERCOLOR(5),
	RASTERCOLOR(1),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	0
};

unsigned char SmallBlueTable[]=
{
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(4),
	RASTERCOLOR(6),
	RASTERCOLOR(7),
	RASTERCOLOR(6),
	RASTERCOLOR(4),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	0
};

unsigned char SmallGreenTable[]=
{
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(2),
	RASTERCOLOR(6),
	RASTERCOLOR(7),
	RASTERCOLOR(6),
	RASTERCOLOR(2),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	0
};

unsigned char SmallYellowTable[]=
{
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(1),
	RASTERCOLOR(3),
	RASTERCOLOR(7),
	RASTERCOLOR(3),
	RASTERCOLOR(1),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	0
};

unsigned char SmallPureGreenTable[]=
{
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(2),
	RASTERCOLOR(2),
	RASTERCOLOR(7),
	RASTERCOLOR(2),
	RASTERCOLOR(2),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	0
};

/*
	0 16 noir
	1 17 rouge
	2 18 vert
	3 19 jaune
	4 20 bleu
	5 21 violet
	6 22 cyan
	7 23 blanc
*/





SMALLRASTER	RasterSmallBlue=
{
	SmallBlueTable,
	51,
	15,
	0,
	2,
	10
};

SMALLRASTER	RasterSmallGreen=
{
	SmallGreenTable,
	52,
	30,
	0,
	2,
	10
};

SMALLRASTER	RasterSmallYellow=
{
	SmallYellowTable,
	53,
	45,
	0,
	2,
	10
};


SMALLRASTER	RasterSmallPureGreen=
{
	SmallPureGreenTable,
	54,
	60,
	0,
	2,
	10
};

SMALLRASTER	RasterSmallRed=
{
	SmallRedTable,
	55,
	75,
	0,
	2,
	10
};


unsigned char BigRedTable[]=
{
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(1),
	RASTERCOLOR(0),
	RASTERCOLOR(1),
	RASTERCOLOR(1),
	RASTERCOLOR(3),
	RASTERCOLOR(1),
	RASTERCOLOR(3),
	RASTERCOLOR(3),
	RASTERCOLOR(7),
	RASTERCOLOR(3),
	RASTERCOLOR(3),
	RASTERCOLOR(1),
	RASTERCOLOR(3),
	RASTERCOLOR(1),
	RASTERCOLOR(1),
	RASTERCOLOR(0),
	RASTERCOLOR(1),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	0
};



unsigned char BigBlueTable[]=
{
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(4),
	RASTERCOLOR(4),
	RASTERCOLOR(4),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(7),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(4),
	RASTERCOLOR(4),
	RASTERCOLOR(4),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	0
};

unsigned char BigGreenTable[]=
{
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(2),
	RASTERCOLOR(2),
	RASTERCOLOR(2),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(7),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(6),
	RASTERCOLOR(2),
	RASTERCOLOR(2),
	RASTERCOLOR(2),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	RASTERCOLOR(0),
	0
};



// Color table
// Z value
// Angle
// Speed
BIGRASTER	RasterBigRed=
{
	BigRedTable,
	40,
	0,
	3
};

BIGRASTER	RasterBigRed2=
{
	BigRedTable,
	41,
	15,
	3
};

BIGRASTER	RasterBigRed3=
{
	BigRedTable,
	42,
	30,
	3
};

BIGRASTER	RasterBigRed4=
{
	BigRedTable,
	43,
	45,
	3
};

BIGRASTER	RasterBigRed5=
{
	BigRedTable,
	44,
	60,
	3
};


BIGRASTER	RasterBigBlue=
{
	BigBlueTable,
	41,
	15,
	4
};

BIGRASTER	RasterBigGreen=
{
	BigGreenTable,
	42,
	30,
	4
};




/*
Jede
Dbug
Romu
Zone
Twilighte
Exocet
*/



void UpdateRasters(unsigned char xposition,unsigned char WhatToShow)
{
	RastersClearBuffer();

	switch (WhatToShow)
	{
	case 10:
		// Red
		RasterPointerSmall=&RasterSmallRed;
		RastersDrawSmall();
	case 9:
		// Blue
		RasterPointerSmall=&RasterSmallBlue;
		RastersDrawSmall();
	case 8:
		// Green
		RasterPointerSmall=&RasterSmallGreen;
		RastersDrawSmall();
	case 7:
		// Yellow
		RasterPointerSmall=&RasterSmallYellow;
		RastersDrawSmall();
	case 6:
		// Pure green
		RasterPointerSmall=&RasterSmallPureGreen;
		RastersDrawSmall();
	case 5:
		RasterPointerBig=&RasterBigRed;
		RastersDrawBig();
	case 4:
		RasterPointerBig=&RasterBigRed2;
		RastersDrawBig();
	case 3:
		RasterPointerBig=&RasterBigRed3;
		RastersDrawBig();
	case 2:
		RasterPointerBig=&RasterBigRed4;
		RastersDrawBig();
	case 1:
		RasterPointerBig=&RasterBigRed5;
		RastersDrawBig();
	case 0:
		break;
	}
	
	RastersXOffset=xposition;
	RastersDisplayBuffer();
}


void HandleRasters(unsigned int counter,unsigned char xposition)
{
	while (counter)
	{
		UpdateRasters(xposition,5);


		VSync();
	}
}

extern unsigned char AmigaColors[];
extern unsigned char BadeStampColors[];
unsigned char StampRasterPos=0;

void DrawBadeStampRasters(unsigned char* basescreen,unsigned int duration)
{
	while (duration--)
	{
		unsigned char y,x;
		unsigned char* screen;

		screen=basescreen;
		for (y=0;y<142;y++)
		{
			//screen[0]=(y+yy)&7;
			screen[0]=BadeStampColors[(y+StampRasterPos)&63]&7;
			screen+=40;
		}
		StampRasterPos++;
		VSync();
	}
}



void main()
{
	// Clear the screen
	memset((unsigned char*)0xa000,64,8000);
	memset((unsigned char*)0xbb80+25*40,32,40*3);

	// Install the IRQ handler
	System_InstallIRQ_SimpleVbl();

	// Initialize stuff
	InitializeTables();

	// Load the 6x8 font
	LoadFileAt(LOADER_FONT_6x8_ARTDECO,0x9900);

	// Start the calendar
	InstallCalendarDecount();

	// Small pause
	Pause(50);

#ifdef ENABLE_MUSIC
	// Load and play the music
	LoadFileAt(LOADER_INTRO_MUSIC,0xc000);
	Mym_MusicStart();
#endif


#ifdef ENABLE_MAIN_DEFENCE_FORCE_LOGO
	// Load the defence force logo
	LoadFileAt(LOADER_DEFENCEFORCE_LOGO,PictureLoadingBuffer);

	WaitPosition(0,7,40);	// --------------------------------------------------------------------- Defence Force logo appears

	// Make the defence force logo appear with a blue raster highlighte scrolling down
	ShowLargeDefenceForce();

	// Small pause
	//Pause(50*2);
#endif

	WaitPosition(0,15,30);	// --------------------------------------------------------------------- Defence Force logo disappear with Amiga style rasters

#ifdef ENABLE_AMIGA_RASTERS
	// Start the raster bars
	// Start the amiga style rasters
	InstallAmigaRasterLine();

	// Wait a bit for the rasters to reach the bottom (200 frames roughly)
	Pause(50*3);

	// Write the mini Defence Force logo
	DrawDefenceForceLogo();
	Pause(50);
#endif

	// Load the 6x6 font
	LoadFileAt(LOADER_FONT_6x6,Font6x6);

	

#ifdef ENABLE_KINDERGARDEN_LOGO
	// Load the kindergarden logo on the top of the screen in the buffer
	LoadFileAt(LOADER_KINDERGARDEN_LOGO,PictureLoadingBuffer);

	Pause(50);

	ShowLargeKindergardenLogo(); // --------------------------------------------------------------------- kindergarden logo to appear scrolling from the raster bar
#endif



#ifdef ENABLE_BIG_SCREEN_SEQUENCE
	// Load the big screen picture
	LoadFileAt(LOADER_BIGSCREEN,PictureLoadingBuffer);

	WaitPosition(0,23,0);	// --------------------------------------------------------------------- Show the big screen

	ShowPicture((unsigned char*)0xa000+40*55,PictureLoadingBuffer,142,40,EFFECT_FROM_OUTSIDE_TO_CENTER|EFFECT_VSYNC);
	//memcpy((unsigned char*)0xa000+40*55,PictureLoadingBuffer,40*142);

	//Pause(50*5,(unsigned char*)0xa000+40*55,);

	// Load the smallscreenpictures
	LoadFileAt(LOADER_SMALLSCREEN,PictureLoadingBuffer);

	// Load the ultrasmallscreenpictures
	LoadFileAt(LOADER_SCREEN_60x50,PictureLoadBuffer60x50);

	WaitPosition(0,25,0);	// --------------------------------------------------------------------- Oldskool compo starts NOW! (LARGE)
	EraseScreen120(0,100,0);
	ShowPicture(StartScreen120x100,PictureLoadingBuffer,100,20,EFFECT_FROM_TOP_TO_BOTTOM|EFFECT_VSYNC);

	WaitPosition(0,29,0);	// --------------------------------------------------------------------- #1 entry, by defence force (LARGE)	
	EraseScreen120(0,100,0);
	ShowPicture(StartScreen120x100,PictureLoadingBuffer+20*297,100,20,EFFECT_FROM_TOP_TO_BOTTOM);
	Pause(50*4);

	WaitPosition(0,33,0);	// --------------------------------------------------------------------- Temporisation with black screen for few more seconds
	EraseScreen120(0,100,0);


	WaitPosition(0,34,0);	// --------------------------------------------------------------------- Show the smaller defence force logo
	EraseScreen120(0,100,16);
	ShowSmallDefenceForce();
	Pause(50*2);

	InstallAmigaRasterLine_HalfSize(); // 0,37
	Pause(98);

	// Erase Defence Force and draw the top Kindergarden logo
	//EraseScreen120(0,100,0);
	ShowSmallKindergardenLogo();		// 0,39


	//Pause(50*2);

	WaitPosition(0,46,0);	// --------------------------------------------------------------------- Draw the scene inside the scene  0,41
	ShowPicture(StartScreen120x100+40*28,PictureLoadingBuffer+20*200,71,20,EFFECT_FROM_OUTSIDE_TO_CENTER|EFFECT_VSYNC|FINISH_WITH_16);

	Pause(50*2);

	// Start drawing the ultra small elements

	// Oldskool compo starts NOW! 0,43
	EraseScreen60(0,50,0);
	ShowPicture(StartScreen60x50,PictureLoadBuffer60x50,50,10,EFFECT_FROM_TOP_TO_BOTTOM|EFFECT_VSYNC);
	Pause(50*3);

	// #1 entry, by defence force  0,46
	EraseScreen60(0,50,0);
	ShowPicture(StartScreen60x50,PictureLoadBuffer60x50+10*50,50,10,EFFECT_FROM_TOP_TO_BOTTOM);
	Pause(50*2);

	// Temporisation with black screen for few more seconds
	EraseScreen60(0,50,0);
	Pause(50*2);

	// Defence Force logo appears 0,47
	EraseScreen60(0,50,16);
	ShowPicture(StartScreen60x50,PictureLoadBuffer60x50+10*100,50,10,EFFECT_FROM_OUTSIDE_TO_CENTER|EFFECT_VSYNC);
	Pause(50*2);

	// 0,51
	InstallAmigaRasterLine_QuarterSize();
	Pause(49);

	// 0,52
	ShowTinyKindergardenLogo();

	//Pause(50*3);

	// Then we get out of the inception mode
	// The Real Party Is Outside (60x50)  -> 60x35
	WaitPosition(1,11,0);	// --------------------------------------------------------------------- Show the real party is outside (quarter)
	ShowPicture(StartScreen60x50+40*14,PictureLoadBuffer60x50+10*164,35,10,EFFECT_FROM_TOP_TO_BOTTOM);

	WaitPosition(1,12,0);	// --------------------------------------------------------------------- Show the real party is outside (half)
	RemoveAmigaRasterLine_QuarterSize();
	ShowPicture(StartScreen120x100+40*27,PictureLoadingBuffer+20*397,71,20,EFFECT_FROM_TOP_TO_BOTTOM);

	// Load the kindergarden party outside
	LoadFileAt(LOADER_REAL_PARTY,PictureLoadingBuffer);

// 1.07
// 1.09

	WaitPosition(1,13,0);	// --------------------------------------------------------------------- Show the real party is outside (bigger)
	RemoveAmigaRasterLine_HalfSize();

	// Big "The Real Party is Outside"
	memcpy((unsigned char*)0xa000+40*55,PictureLoadingBuffer,40*142);
	//Pause(50*4);
#endif

	WaitPosition(1,16,0);	// --------------------------------------------------------------------- Starting the actual demo


//#ifdef ENABLE_TRIANGLES
//	TriangleSequence(2);		// Fire
//#endif	


#ifdef ENABLE_PARTY_OUTSIDE
	{	
		unsigned char x;
		unsigned char* flameAnimation;
		unsigned char* smokeAnimation;

		// Load the kindergarden party outside
		LoadFileAt(LOADER_PARTY_OUTSIDE,PictureLoadingBuffer);
		FadeToBlackBetweenRasters();
		memcpy((unsigned char*)0xa000+40*55,PictureLoadingBuffer,40*142);

		// Load the flame animation
		flameAnimation=PictureLoadingBuffer;
		LoadFileAt(LOADER_FLAME_ANIM,flameAnimation);

		// Load the smoke animation
		smokeAnimation=flameAnimation+30*3*5;
		LoadFileAt(LOADER_SMOKE_ANIM,smokeAnimation);


		EffectCounter=0;
		while (EffectCounter<PARTY_OUTSIDE_DURATION)
		{
			int frame;
			int delay;
			int y;
			unsigned char* screen;
			unsigned char* pictureStart;

			EffectCounter++;

			// Flame
			pictureStart=flameAnimation+30*3*(EffectCounter%5);
			screen=(unsigned char*)0xa000+40*(55+97)+12;
			for (y=0;y<30;y++)
			{
				memcpy(screen,pictureStart,3);
				//screen[-1]=16+0;
				//screen[19]=7;
				//screen[20]=7;
				screen+=40;
				pictureStart+=3;
			}

			// Smoke
			pictureStart=smokeAnimation+2*(EffectCounter%6);
			screen=(unsigned char*)0xa000+40*(55+10)+13;
			for (y=0;y<66;y++)
			{
				memcpy(screen,pictureStart,2);
				//screen[-1]=16+0;
				//screen[19]=7;
				//screen[20]=7;
				screen+=40;
				pictureStart+=12;
			}

			delay=10;	//+(EffectCounter&3)<<1;
			while (delay--)
			{
				VSync();
			}
		}
		x=38;
		while (x!=0)
		{
			UpdateRasters(x,5);
			VSync();
			x--;
		}
	}
#endif	

	// Keep the rasters for a while, but remove them one by one
	{
		unsigned char WhatToShow=6;
		while (WhatToShow)
		{
			unsigned char counter;
			WhatToShow--;
			for (counter=0;counter<50;counter++)
			{
				UpdateRasters(0,WhatToShow);
				VSync();			
			}
		}
	}
	//HandleRasters(1,0);

#ifdef ENABLE_BOUNCING_TRIANGLE
	BounceTriangle(2*50);
	EraseHalfScreen();
	//WaitPosition(1,35,0);	// --------------------------------------------------------------------- Display credits: Fra
#endif


#ifdef ENABLE_CREDITS
	{
		unsigned char x;

		// Load the credits
		LoadFileAt(LOADER_CREDITS,PictureLoadingBuffer);

		//Pause(50);

		// Display the credits (Each name takes 64 pixels high)
		//FadeToBlackBetweenRasters();
		//SetBlackPaper();
	WaitPosition(1,30,0);	// --------------------------------------------------------------------- Display credits: Fra
		memcpy((unsigned char*)0xa000+85*40,PictureLoadingBuffer+40*64*0,64*40);
		//Pause(50*5);
	WaitPosition(1,40,0);	// --------------------------------------------------------------------- Display credits: Count 0
		memcpy((unsigned char*)0xa000+85*40,PictureLoadingBuffer+40*64*1,64*40);
		//Pause(50*5);
	WaitPosition(1,43,0);	// --------------------------------------------------------------------- Display credits: Dbug
		memcpy((unsigned char*)0xa000+85*40,PictureLoadingBuffer+40*64*2,64*40);
		//Pause(50*5);
		//FadeToBlackBetweenRasters();

	WaitPosition(1,47,0);	// --------------------------------------------------------------------- Show the raster to erase the credits

		// Erase the credits with some more rasters
		x=38;
		while (x!=0)
		{
			UpdateRasters(x,10);
			VSync();
			x--;
		}

		// Keep the rasters for a while, but remove them one by one
		{
			unsigned char WhatToShow=11;
			while (WhatToShow)
			{
				unsigned char counter;
				WhatToShow--;
				for (counter=0;counter<50;counter++)
				{
					UpdateRasters(0,WhatToShow);
					VSync();			
				}
			}
		}
	}
#endif	


#ifdef ENABLE_TRIANGLES
//	TriangleSequence(1);		// People
#endif	



#ifdef ENABLE_BADE_STAMP
	{
		unsigned char yy;

		// Load the badestamp picture
		LoadFileAt(LOADER_BADESTAMP,PictureLoadingBuffer);
		FadeToBlackBetweenRasters();
		DrawBadeStampRasters(PictureLoadingBuffer,1);
		memcpy((unsigned char*)0xa000+40*55,PictureLoadingBuffer,40*142);

		// paint retard rasters
		DrawBadeStampRasters((unsigned char*)0xa000+55*40,50*7);
		EraseHalfScreen();
		//Pause(50*5);
	}
#endif


#ifdef ENABLE_TRIANGLES
//	TriangleSequence(0);		// Music
#endif	


#ifdef ENABLE_GREETINGS
	{
	WaitPosition(2,17,0);	// --------------------------------------------------------------------- Show the crossword greetings

		// Erase the screen
		FadeToBlackBetweenRasters();
		ShowRasters();
		DrawCrossWords();
		Pause(50*5);
	}
#endif	


//#ifdef ENABLE_TRIANGLES
//	TriangleSequence();
//#endif	


#ifdef ENABLE_KINDERGARDEN_LOGO
	// Make the kindergarden logo to disappear scrolling from the raster bar
	HideLargeKindergardenLogo();
#endif

	// Preload the cake picture
	LoadFileAt(LOADER_BIRTHDAY,PictureLoadingBuffer);
	PatchAttributesBirthdayCake();			// Hide the PictConv helper codes

#ifdef ENABLE_AMIGA_RASTERS
	// Stop the amiga style rasters
	StopAmigaRasterLine();
	Pause(200);
#endif

#ifdef ENABLE_CAKE_EFFECT
	// Display the cake picture
	memcpy((void*)0xa000,PictureLoadingBuffer,8000);

	// Load the title screen
	LoadFileAt(LOADER_TITLE_SCREEN,PictureLoadingBuffer);

#ifdef ENABLE_CAKE_FLAMES
	// Load the flame animation
	LoadFileAt(LOADER_FLAME_ANIM,PictureLoadBuffer60x50);

	// Erase the countdown
	memset((unsigned char*)0xbb80+25*40,32,20);
	memset((unsigned char*)0xbb80+26*40,32,20);
	memset((unsigned char*)0xbb80+27*40,32,20);

	EffectCounter=0;
	//while (EffectCounter<7)
	while (TestPosition(2,49,0))
	{
		int frame;
		int delay;
		int y;
		unsigned char* screen;
		unsigned char* pictureStart;
		unsigned char* pictureStart2;

		EffectCounter++;

		for (frame=0;frame<5;frame++)
		{
			pictureStart=PictureLoadBuffer60x50+30*3*frame;
			pictureStart2=PictureLoadBuffer60x50+30*3*((frame+1)%5);
			screen=(unsigned char*)0xa000+40*(4)+14;
			for (y=0;y<30;y++)
			{
				memcpy(screen,pictureStart,3);
				memcpy(screen+6-40*3,pictureStart2,3);
				//screen[-1]=16+0;
				//screen[19]=7;
				//screen[20]=7;
				screen+=40;
				pictureStart+=3;
				pictureStart2+=3;
			}

			delay=4+(EffectCounter&3)<<1;
			while ((delay--) && TestPosition(2,49,0))
			{
				VSync();
			}
		}
	}
	memset((unsigned char*)0xa000,64,8000);
#endif
#endif

#ifdef ENABLE_TITLE_SCREEN
	WaitPosition(2,49,0);	// --------------------------------------------------------------------- Show the end title picture

	// Black screen
	memset((unsigned char*)0xa000,64,8000);
	Pause(50*1);

	// Show the title picture
	memcpy((void*)0xa000,PictureLoadingBuffer,8000);

	Pause(50*5);

	memset((unsigned char*)0xa000,64,8000);

	Pause(50*2);

	// Erase the three final lines of text
	memset((unsigned char*)0xbb80+25*40,32,40*3);

	
#endif	
	// And final forever loop
	while(1)
	{
	}
}


