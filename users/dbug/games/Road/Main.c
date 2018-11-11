// --------------------------------------
// Racing
// --------------------------------------
// (c) 2002 Mickael Pointier.
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

#include "lib.h"
#include "profile.h"


extern void TurnLeftSimple();
extern void TurnRightSimple();

void VSync();

extern unsigned int VSyncCounter1;
extern unsigned int VSyncCounter2;

void VSyncGetCounter();

void IrqOff();

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


extern unsigned char picture_font_1[];

extern unsigned char CosTable[];
extern unsigned char LeftTable[];


int RoadMiddleTable[128];
int RoadOffsetTable[128];

char RoadWidthTable[128];

extern unsigned char Rasters[];





// =================== color cycle test

char Raster1[32]= { 3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1 };

int	DivTable[256];




void CreateDivTable()
{
	int		y;

	for (y=0;y<128;y++)
	{
		//
		// Fill div table
		//
		DivTable[y]=4096/(y+16);
	}
}



int	Position=0;



void ScrollColors()
{
	int		f;
	int		y;
	char	*adr;
	int		position;

	PROFILE_ENTER(ROUTINE_SCROLL_COLORS);

	position=Position;
	Position+=2;
	adr=((char*)0xa000)+40*72;

	for (y=0;y<128;y++)
	{
		f=(DivTable[y]+position)>>3;

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

	for (y=0;y<128;y++)
	{
		//LeftTable[y]	=20;
		//MiddleTable[y]	=120-(100*y)/128;

		RoadMiddleTable[y]	=0;
		RoadWidthTable[y]	=-(100*y)/128;

		RoadOffsetTable[y]	=((int)LeftTable[y]-(120+(int)RoadWidthTable[y]))*2;	// *256/128
	}
}






void RoadDraw()
{
	unsigned int dx;
	int	x,y;

	PROFILE_ENTER(ROUTINE_DRAW_ROAD);
	ScrollColors();		

	PROFILE_ENTER(ROUTINE_DRAW_LOOP);
	for (y=0;y<128;y++)
	{
		x=RoadMiddleTable[y]/256;

		/*
		curset(120+x+RoadWidthTable[y],72+y,1);
		curset(120+x-RoadWidthTable[y],72+y,1);
		*/

		if (y&1)
		{
		curset(120+x+RoadWidthTable[y]-10,72+y,0);
		draw(10,0,0);
		draw(-RoadWidthTable[y]*2,0,1);
		draw(10,0,0);
		}

		/*
		curset(12,72+y,0);
		dx=239-12;
		draw(120+x+RoadWidthTable[y]-12,0,0);
		draw(-RoadWidthTable[y]*2,0,1);
		draw(10,0,0);
		*/
		/*
		dx-=120+x+RoadWidthTable[y]-12;
		draw(RoadWidthTable[y]*2,0,1);
		dx-=RoadWidthTable[y]*2;
		draw(dx,0,0);
		*/
	}
	PROFILE_LEAVE(ROUTINE_DRAW_LOOP);
	PROFILE_LEAVE(ROUTINE_DRAW_ROAD);
}


void TurnLeft(unsigned char count)
{
	unsigned char y;
	PROFILE_ENTER(ROUTINE_TURN_LOOP);
	while (count--)
	{
		TurnLeftSimple();
		/*
		for (y=0;y<128;y++)
		{
			RoadMiddleTable[y]+=RoadOffsetTable[y];
		}
		*/
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
		/*
		for (y=0;y<128;y++)
		{
			RoadMiddleTable[y]-=RoadOffsetTable[y];
		}
		*/
	}
	PROFILE_LEAVE(ROUTINE_TURN_LOOP);
}



void RacingTest()
{
	unsigned char a0,a1,a2,a3;
	unsigned char mode;
	unsigned char key;
	int x,y;

	CreateTable();

	DrawRasters();

	while (1)
	{
		for (x=0;x<128;x++)
		{
			ProfilerNextFrame();
			PROFILE_ENTER(ROUTINE_MAIN_LOOP);
			//RoadErase();
			RoadDraw();
			TurnLeft(1);
			PROFILE_LEAVE(ROUTINE_MAIN_LOOP);
			ProfilerDisplay();
		}
		for (x=0;x<256;x++)
		{
			ProfilerNextFrame();
			PROFILE_ENTER(ROUTINE_MAIN_LOOP);
			//RoadErase();
			RoadDraw();
			TurnRight(1);
			PROFILE_LEAVE(ROUTINE_MAIN_LOOP);
			ProfilerDisplay();
		}
		for (x=0;x<128;x++)
		{
			ProfilerNextFrame();
			PROFILE_ENTER(ROUTINE_MAIN_LOOP);
			//RoadErase();
			RoadDraw();
			TurnLeft(1);
			PROFILE_LEAVE(ROUTINE_MAIN_LOOP);
			ProfilerDisplay();
		}
	}
}





void main()
{
	ProfilerInitialize();
	hires();

	//
	// Create the carpet while displaying 
	// a cool message.
	//
	CreateDivTable();

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

*/







