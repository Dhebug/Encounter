/* -*- c-basic-offset: 8 -*-
 * microAlchimie2 Invitation for ORIC
 * (c) 2012, Francois Revol <revol@free.fr>
 */

#include "global.h"

uint8 * volatile p0;

// DEBUG: skip parts

/* skin parts to what's to debug */
//#define SKIP




int main()
{
	int i;
	ASSERT(sizeof(uint8)==1);
	ASSERT(sizeof(int8)==1);
	ASSERT(sizeof(uint16)==2);
	ASSERT(sizeof(int16)==2);

	//setflags((getflags() & ~CURSOR) | NOKEYCLICK);
	//CURON=0
	//*(char *)0x271 = 0;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xfe;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x08;
	//*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x80;

	fixup_ascii();
	// FIXED POINT INIT
	//_fp_init();
	paper(A_FWBLACK);
	ink(A_FWWHITE);
	// Ctrl-q Ctrl-f
	//puts("\x11\x06");


	//StopInterrupt();

	DO_HIRES();
	p0 = (uint8 *)0xa000;
	fixup_ascii();
	setflags(getflags() & ~CURSOR);
    //*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xfe;


	demoinsi_start();
	demoinsi_do();

	ualchimi_start();
	ualchimi_do();


	// no cursor no clic
	*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xfe;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x08;

	p0 = (uint8 *)0xa000;
	GCLRSCR();

	// cleanup
	//get();
	//GCLRSCR();
	DO_TEXT();
	cls();

	// show cursor
	//setflags((getflags() | CURSOR) & ~NOKEYCLICK);
	//CURON=1
	//*(char *)0x270 = 1;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x1;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xf7;

	puts("code + gfx: mmu_man");
	puts("gfx: cicile");

	return 0;
}
