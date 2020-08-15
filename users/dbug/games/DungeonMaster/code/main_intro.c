//
// Dungeon Master - Game Intro
// (c) 2020 Dbug / Defence Force
//

#include <lib.h>

#include "loader_api.h"

extern void System_InstallIRQ_SimpleVbl();
extern void System_RestoreIRQ_SimpleVbl();

extern char WaitKey();
extern void WaitVbl();

extern UpdatePsgRegisters();

extern unsigned int  PsgfreqA;         //  0 1
extern unsigned int  PsgfreqB;         //  2 3
extern unsigned int  PsgfreqC;         //  4 5
extern unsigned char PsgfreqNoise;     //  6
extern unsigned char Psgmixer;         //  7
extern unsigned char PsgvolumeA;       //  8
extern unsigned char PsgvolumeB;       //  9
extern unsigned char PsgvolumeC;       // 10
extern unsigned int  PsgfreqShape;     // 11 12 
extern unsigned char PsgenvShape;      // 13

extern unsigned char PsgNeedUpdate;

extern unsigned char SwooshData[];

enum IntroGraphics
{
	INTRO_PRESENTS,	
	INTRO_FTL,	
	INTRO_MASTER,	
	INTRO_DUNGEON_11,	
	INTRO_DUNGEON_10,	
	INTRO_DUNGEON_9,	
	INTRO_DUNGEON_8,	
	INTRO_DUNGEON_7,	
	INTRO_DUNGEON_6,	
	INTRO_DUNGEON_5,	
	INTRO_DUNGEON_4,	
	INTRO_DUNGEON_3,	
	INTRO_DUNGEON_2,	
	INTRO_DUNGEON_1,	
	_INTRO_MAX_
};

int GraphicOffset[_INTRO_MAX_+1]=
{
	1,
	18,
	107,
	145,
	206,
	262,
	313,
	361,
	406,
	448,
	487,
	521,
	553,
	578,
	595
};


void WaitVBL(int delay)
{
	while (delay--)
	{
		WaitVbl();
	}
}


void FillScreen(unsigned char value)
{
	memset((unsigned char*)0xa000,value,8000);
}


void ApplyAttributes(unsigned char* startAddress,int stride, int lineCounter,char a1,char a2)
{
	while (lineCounter--)
	{
		startAddress[0]=a1;
		startAddress[1]=a2;
		startAddress+=stride;
	}
}


void FancyDitheredFade(int delay, char a1,char a2)
{
	ApplyAttributes((unsigned char*)0xa000,160,50,a1,a2);
	WaitVBL(delay);
	ApplyAttributes((unsigned char*)0xa000+80,160,50,a1,a2);
	WaitVBL(delay);
	ApplyAttributes((unsigned char*)0xa000+40,160,50,a1,a2);
	WaitVBL(delay);
	ApplyAttributes((unsigned char*)0xa000+120,160,50,a1,a2);
	WaitVBL(delay);
}


void FadeOut()
{
	ApplyAttributes((unsigned char*)0xa000,40,200,16,7);
	WaitVBL(5);
	ApplyAttributes((unsigned char*)0xa000,40,200,16,6);
	WaitVBL(5);
	ApplyAttributes((unsigned char*)0xa000,40,200,16,3);
	WaitVBL(5);
	ApplyAttributes((unsigned char*)0xa000,40,200,16,4);
	WaitVBL(5);
	ApplyAttributes((unsigned char*)0xa000,40,200,16,0);
}


void BlitBlock(int blockId,int destinationOffset)
{
	int yStart,yEnd,height;
	yStart=GraphicOffset[blockId];
	yEnd  =GraphicOffset[blockId+1]-2;
	height=1+yEnd-yStart;

	memcpy((unsigned char*)0xa000+40*(destinationOffset+100-height/2),SwooshData+yStart*40, height*40);
}



void ShowSwooshingFTL()
{
	unsigned char* screenAddress;
	unsigned char* sourceAddress;

	int yStart,yEnd,height,y;
	yStart=GraphicOffset[INTRO_FTL];
	yEnd  =GraphicOffset[INTRO_FTL+1]-2;
	height=1+yEnd-yStart;

	sourceAddress=SwooshData+yEnd*40;
	screenAddress=(unsigned char*)0xa000+40*(100-height/2+height)-40;

	Psgmixer=1+2+4+8+16+32+64+128 & ~8;  // NOISE on CANAL A active

	FillScreen(64);

	for (y=0;y<88;y++)
	{
		if (PsgvolumeA<15)
		{
			PsgvolumeA++;
		}
		if (y<32)
		{
			PsgfreqNoise++;
		}
		else
		if ( (PsgfreqNoise>0) && (y&1))
		{
			PsgfreqNoise--;
		}

		PsgNeedUpdate=1;

		memcpy(screenAddress,sourceAddress,40);
		screenAddress[1+40*0]=1;
		screenAddress[1+40*1]=3;
		screenAddress[1+40*2]=7;

		sourceAddress-=40;
		screenAddress-=40;

		WaitVbl();
	}
	BlitBlock(INTRO_FTL,0);
	PsgStopSound();
	WaitVBL(50);
	FadeOut();
	FillScreen(64);
}



void ShowPresents()
{
	FillScreen(64);

	BlitBlock(INTRO_PRESENTS,0);
	ApplyAttributes((unsigned char*)0xa000,40,200,16,0);
	WaitVBL(5);
	ApplyAttributes((unsigned char*)0xa000,40,200,16,4);
	WaitVBL(5);
	ApplyAttributes((unsigned char*)0xa000,40,200,16,3);
	WaitVBL(5);
	ApplyAttributes((unsigned char*)0xa000,40,200,16,6);
	WaitVBL(5);
	ApplyAttributes((unsigned char*)0xa000,40,200,16,7);
	WaitVBL(5);
	WaitVBL(50);
	FadeOut();

	FillScreen(0);

	WaitVBL(50);
}


void ShowZoomingDungeonLogo()
{
	int zoomFactor;
	FillScreen(64);

	FancyDitheredFade(15,16+4,3);

	for (zoomFactor=INTRO_DUNGEON_1;zoomFactor!=INTRO_MASTER;zoomFactor--)
	{
		BlitBlock(zoomFactor,0);
		WaitVbl();
	}
	WaitVBL(25);
	BlitBlock(INTRO_MASTER,50);
	WaitVBL(50);

	FancyDitheredFade(10,16,1);
	FancyDitheredFade(10,16,0);

	FillScreen(64);
}


void ShowCredits()
{
	LoadFileAt(LOADER_SCROLL_CREDITS,0xA000);
	WaitVBL(50*3);
	FillScreen(16);
}


void main()
{
	System_InstallIRQ_SimpleVbl();

	ApplyAttributes(SwooshData+40*GraphicOffset[INTRO_PRESENTS],40,GraphicOffset[INTRO_FTL]-GraphicOffset[INTRO_PRESENTS],16,0);
	ApplyAttributes(SwooshData+40*GraphicOffset[INTRO_MASTER],40,GraphicOffset[INTRO_DUNGEON_11]-GraphicOffset[INTRO_MASTER],16+4,1);
	ApplyAttributes(SwooshData+40*GraphicOffset[INTRO_DUNGEON_11],40,GraphicOffset[_INTRO_MAX_]-GraphicOffset[INTRO_DUNGEON_11],16+4,3);

	ShowSwooshingFTL();
	ShowPresents();
	ShowZoomingDungeonLogo();
	ShowCredits();

	WaitKey();

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the loader
	InitializeFileAt(LOADER_PROGRAM_SECOND,0x400);
}

