
#include <lib.h>

// --------------------------------------
//   LineBench
// --------------------------------------
// (c) 2003-2008 Mickael Pointier.
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


// ============================================================================
//
//									Externals
//
// ============================================================================

#include "params.h"

//
// ===== Display.s =====
//
extern unsigned char CurrentPixelX;		// Coordinate X of edited pixel/byte
extern unsigned char CurrentPixelY;		// Coordinate Y of edited pixel/byte

extern unsigned char OtherPixelX;		// Coordinate X of other edited pixel/byte
extern unsigned char OtherPixelY;		// Coordinate Y of other edited pixel/byte


//
// ===== Buffer.s =====
//
void DrawLine();

//
// ===== Clip.s =====
//
void DrawClippedLine();
void Break();

extern int LargeX0;
extern int LargeY0;
extern int LargeX1;
extern int LargeY1;

extern int LargeX;
extern int LargeY;



void line_mike()
{
	int i;

	/*	
		CurrentPixelX=0;
		CurrentPixelY=0;
		OtherPixelX=0;
		OtherPixelY=199;

		DrawLine();
		*/
		
	for (i=0;i<239;i++)
	{
		LargeX0=i;
		LargeY0=0;
		LargeX1=239-i;
		LargeY1=199;
		
		DrawClippedLine();
	}
	for (i=0;i<199;i++)
	{
		LargeX0=0;
		LargeY0=i;
		LargeX1=239;
		LargeY1=199-i;
		
		DrawClippedLine();
	}
	/*
	for (i=0;i<239;i++)
	{
		OtherPixelX=i;
		OtherPixelY=0;
		CurrentPixelX=239-i;
		CurrentPixelY=199;

		DrawLine();
	}
	for (i=0;i<199;i++)
	{
		OtherPixelX=0;
		OtherPixelY=i;
		CurrentPixelX=239;
		CurrentPixelY=199-i;

		DrawLine();
	}
	*/
}


void line_basic()
{
	unsigned char i;
	for (i=0;i<239;i++)
	{
		curset(i,0,3);
		draw(239-i-i,199,2);
	}
	for (i=0;i<199;i++)
	{
		curset(0,i,3);
		draw(239,199-i-i,2);
	}
}


void test()
{
	unsigned int delay;
		
	while (1)
	{
		// Mike routine first
		printf("\nMike test: ");
		*(unsigned int*)0x276=0;
		line_mike();
		delay=65536-(*(unsigned int*)0x276);
		printf(" duration (in 100th of second): %d",delay);
						
		// Basic routine second
		printf("\nBasic: ");
		*(unsigned int*)0x276=0;
		line_basic();
		delay=65536-(*(unsigned int*)0x276);
		printf(" duration (in 100th of second): %d",delay);
	}
}


void main()
{	
	GenerateTables();
	hires();

	test();
}


