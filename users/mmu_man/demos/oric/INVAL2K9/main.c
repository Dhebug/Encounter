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




int main()
{
	int i;
	ASSERT(sizeof(uint8)==1);
	ASSERT(sizeof(int8)==1);
	ASSERT(sizeof(uint16)==2);
	ASSERT(sizeof(int16)==2);
	/*
	printf("div8s: %d\n", div8s(-25,12));
	printf("div8s: %d\n", div8s(25,12));
	printf("div8s: %d\n", div8s(40,12));
	return 0;
	*/

	//setflags((getflags() & ~CURSOR) | NOKEYCLICK);
	//CURON=0
	//*(char *)0x271 = 0;
       	*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xfe;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x08;
	//*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x80;

	dash_load_progress(0);
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

	dash_load_progress(5);
	
#if 0
	{
		int i;
		for (i = 0; i < 255; i++)
			//printf("%d %d\n", *(char *)0x276, *(char *)0x277);
			printf("%d %d\n", *(char *)VIA_T1CL, *(char *)VIA_T1CH);
	}
#endif
	
	music_start();
	music_set_ss();

/* 	music_set_1(); */

/* 	for (i = 0; i < 50; i++) { */
/* 		int j; */
/* 		for (j = 250; j; j--) */
/* 			; */
/* 		music_slice(); */
/* 	} */

/* 	music_till_once(); */

/* 	return; */


	DO_HIRES();


	// no cursor no clic
	*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xfe;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x08;

	dash_load_progress(7);
	//printf("Initializing...\n");
	//_fp_init();
	//text();
	p0 = (uint8 *)0xa000;
	GCLRSCR();
	//*p0 = 145;
	//spin(20);
	//mymemset(p0,146,10);

	dash_load_progress(10);

	dash_load_progress(-1);
	//eq_init();
	music_start();
	music_set_1();
#if 1
	stars_start();
	stars_do();
	music_till_once();
	music_end();
	i = 32000;
	//while (i--) eq_update();
	//getchar();
#endif
	

#if 0
	/* FAKE Solskogen introl C64 */

	fake_ss_start();


	dash_load_progress(10);

	dash_load_progress(-1);
	
#ifndef SKIP
	do {
		fake_ss_slice();
	} while (!hires_scroll_text_is_once());
	fake_ss_tag_do();
	
	do {
		fake_ss_slice();
	} while (!music_is_end());
	

#endif

	music_set_1();

	fake_ss_rolldown_start();

#ifndef SKIP
	fake_ss_rolldown_do();
	
	do {
		music_slice();
	} while (!music_is_end());
#endif

	fake_ss_end();


	// VIP TV

	//viptv_start();

#ifndef SKIP
	
	//viptv_do();


	//for (i = 0; i < 50; i++)
	//music_slice();
	//	spin(2);

	music_till_once();

#endif

	music_end();


	//viptv_fade_center();


	
	stars_start();
	stars_do();
	

	//spin(2);
	//do_sincos();
	//do_roto_sierp();
	// hide cursor
	/*  setflags(getflags() & ~CURSOR);
	    text();
	    printf("\n\n\n\nSYNTAX ERROR\n");
	    //delay(1);
	    // the real thing
	    //do_startrek_screen();
	    //stripattributes();
	    //do_matrix(3);
	    */

	//RestoreInterrupt();
#endif

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


	return 0;
}
