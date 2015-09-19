/* -*- c-basic-offset: 8 -*-
 * (c) 2015, Francois Revol <revol@free.fr>
 *
 */

#include "stdlib.h"
#include "global.h"

//#define DEBUGME

extern unsigned char VIPSplash[];
uint8 * volatile p0;

void a0xb_start(void)
{
	DO_HIRES();
	// no cursor no clic
	*(uint8 *)0x26a = (*(uint8 *)0x26a) & 0xfe;
	*(uint8 *)0x26a = (*(uint8 *)0x26a) | 0x08;
	p0 = (uint8 *)0xa000;
	GCLRSCR();
	
	LZ77_UnCompress(VIPSplash, (uint8 *)0xa000);
}


void a0xb_do(void)
{
	while(1) {
		if (key() == 27)
			break;
	}
}

