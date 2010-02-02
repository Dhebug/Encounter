
#include <lib.h>

// --------------------------------------
//   CircleBench
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
// e-mail: enguita@gmail.com
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
// ===== circle.s =====
//
extern unsigned int CentreX;			// Coordinate X of the circle centre
extern unsigned int CentreY;			// Coordinate Y of the circle centre
extern unsigned int Radius;				// Circle radius

void circleMidpoint();



void circle_Chema()
{
	CentreX=10;
	CentreY=160;
	for (Radius=1;Radius<200;Radius++)
	{
		circleMidpoint();
	}
}


void circle_basic()
{
	unsigned int i;
	curset(120,100,0);
	for (i=1;i<99;i++)
		circle(i,1);
}


void test()
{
	unsigned int delay;
		
	while (1)
	{
		// Chema routine first
		printf("\nChema test: ");
		*(unsigned int*)0x276=0;
		circle_Chema();
		delay=65536-(*(unsigned int*)0x276);
		printf(" duration (in 100th of second): %d",delay);
						
		// Basic routine second
		/*
		printf("\nBasic: ");
		*(unsigned int*)0x276=0;
		circle_basic();
		delay=65536-(*(unsigned int*)0x276);
		printf(" duration (in 100th of second): %d",delay);
		*/

	}
}

int x,y;

void main()
{	

	GenerateTables();
	hires();
	paper(4);
	test();
}


