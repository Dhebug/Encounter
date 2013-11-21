//
// This program simply display a picture on the hires screen
//
#include <lib.h>

#include "setup.h"
#include "script.h"


extern unsigned char LabelCharMap[];
extern unsigned char LabelCharDef[];


extern unsigned char ScrollerCommand;
extern unsigned char ScrollerCommandParam1;
extern unsigned char ScrollerCommandParam2;
extern unsigned char ScrollerCommandParam3;
extern unsigned char ScrollerCommandParam4;

extern unsigned char MapX;
extern unsigned char MapY;


extern unsigned char MusicResetCounter;
extern unsigned char MusicResetCounter2;

extern unsigned char CurrentFrame;

extern unsigned char CurrentAYRegister;

extern unsigned char PlayerVbl;

extern unsigned char PlayerRegValues[];
extern unsigned char VolumeMeter[];

extern unsigned int RegisterChanAFrequency;
extern unsigned int RegisterChanBFrequency;
extern unsigned int RegisterChanCFrequency;


void System_InstallIRQ_SimpleVbl();
void ScrollerInit();
void VSync();

void ClearScreen();
void InitCharMapAddr();
void HighlighteArea();


unsigned int MinFreqA=0xFFFF;
unsigned int MaxFreqA=0x0;
unsigned int DeltaFreqA=0x0;

unsigned int MinFreqB=0xFFFF;
unsigned int MaxFreqB=0x0;
unsigned int DeltaFreqB=0x0;

unsigned int MinFreqC=0xFFFF;
unsigned int MaxFreqC=0x0;
unsigned int DeltaFreqC=0x0;


void MoveMap(int x,int y)
{
	do
	{	
		if (MapX<x)		++MapX;
		else
		if (MapX>x)		--MapX;
	
		if (MapY<y)		++MapY;
		else
		if (MapY>y)		--MapY;
		
		ShowMap();
		VSync();
	}
	while ( (MapX!=x) || (MapY!=y));
}





void FilterMap()
{
	unsigned char* map;
	map   =LabelCharMap;
	while (map<LabelCharDef)
	{
		*map|=128;		// Inverse video -> White on Blue
		++map;
	}
	
}


char* hexData="0123456789ABCDEF";



void STOP(char color)
{
	*((char*)0xbb80+40*27)=16+(color&7);
	while (1)
	{
	}
}


extern void VSync();



void main()
{
	MapX=0;
	MapY=0;
		
	//
	// Clear the screen
	//
	ClearScreen();
	InitCharMapAddr();
	
	//
	// Redefine characters
	//
#ifdef ENABLE_MOTHERBOARD
	memcpy((unsigned char*)0xb400+8*32,LabelCharDef,96*8);
#endif	
	
	
	//
	// Pseudo hires switch
	//
	ScrollerInit();
	
	
	System_InstallIRQ_SimpleVbl();
		
	
	//
	// Filter the map
	//
#ifdef ENABLE_MOTHERBOARD
	FilterMap();
#endif
	
	
	while (1)
	{
		if (ScrollerCommand!=SCROLLER_NOTHING)
		{
			unsigned char command=ScrollerCommand;
			//STOP(1);
			ScrollerCommand=SCROLLER_NOTHING;		
			switch (command)
			{
			case SCROLLER_SHOW_MAP:
				MoveMap(MapX,MapY);
				break;
				
			case SCROLLER_MOVE_MAP:
				MoveMap(ScrollerCommandParam1,ScrollerCommandParam2);
				break;
				
			case SCROLLER_HIGHLIGHTE:
				HighlighteArea();
				break;

			case SCROLLER_END:
				break;
			}
		}
	}
}

