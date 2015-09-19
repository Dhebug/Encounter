/* -*- c-basic-offset: 8 -*-
 * Alchimie7 Invitation for ORIC
 * (c) 2007, Francois Revol <revol@free.fr>
 *
 */

// -D__16BIT__ -D__NOFLOAT__ -DATMOS

//#include <lib.h>
#include "global.h"
//#include "fpmath.h"

uint8 * volatile p0;

// DEBUG: skip parts

/* skin parts to what's to debug */
//#define SKIP

static void cleanup(void)
{
	DO_HIRES();
	DO_TEXT();
	cls();

	// show cursor
	//setflags((getflags() | CURSOR) & ~NOKEYCLICK);
	//CURON=1
	//*(char *)0x270 = 1;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xf7;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x3;
	//*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xf7;

	paper(A_FWWHITE);
	ink(A_FWBLACK);
	printf("plop\n");
	
}


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

	//dash_load_progress(0);
	fixup_ascii();
	// FIXED POINT INIT
	//_fp_init();
	paper(A_FWBLACK);
	ink(A_FWWHITE);
	// Ctrl-q Ctrl-f
	//puts("\x11\x06");



	//StopInterrupt();

	//poke(VIA_T1LH, 0x1);
	//poke(VIA_T1LL, 0xff);
	//poke(VIA_T2CL, 0x0);
	//poke(VIA_ACR, peek(VIA_ACR) | 0x10);

	//dash_load_progress(5);
	
#if 0
	{
		int i;
		for (i = 0; i < 255; i++)
			//printf("%d %d\n", *(char *)0x276, *(char *)0x277);
			printf("%d %d\n", *(char *)VIA_T1CL, *(char *)VIA_T1CH);
	}
#endif
	
	//	music_start();
	//music_set_ss();

/* 	music_set_1(); */

/* 	for (i = 0; i < 50; i++) { */
/* 		int j; */
/* 		for (j = 250; j; j--) */
/* 			; */
/* 		music_slice(); */
/* 	} */

/* 	music_till_once(); */

/* 	return; */


//	DO_HIRES();
//	p0 = (uint8 *)0xa000;
//	fixup_ascii();
	setflags(getflags() & ~CURSOR);
    //*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xfe;



	//stars_start();
	//stars_do();

	//hw_mode_init();
	//while (1) {};
	//hw_mode_test_win();
	//get();
	//hw_mode_fini();
//text();
//	destiny_start();
//while (1) {};


	//hexagones_init();

	//do_hexagones();

	//demoinsi_start();
	//demoinsi_do();

	//ualchimi_start();
	//ualchimi_do();
	//qric_start();
	//while (1);
	//o30_start();


	// no cursor no clic
	*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xfe;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x08;

	//dash_load_progress(7);
	//printf("Initializing...\n");
	//_fp_init();
	//text();
	a0xb_start();
	a0xb_do();
	//*p0 = 145;
	//spin(20);
	//mymemset(p0,146,10);


	cleanup();
	//get();
	//GCLRSCR();

	{
		int c, i;
		for (c = 32, i=0; c < 64; c++, i++)
			*(char *)(0xbbd0+i) = c;
	}
	//printf("%d:%c\n", '_', '_');
	return 0;
}
