/* -*- c-basic-offset: 8 -*-
 * (c) 2008, Francois Revol <revol@free.fr>
 *
 */

#include "global.h"
//#include "stdlib.h"


static const char *sText = "     COME TO SOLSKOGEN 2008 JULY 2008... - HEY WAIT! That's not supposed to be an intro for Solskogen!   ";
static const char *sText2 = "    THIS IS \xa0 V.I.P. \xa0 !!! . o ( ROX )    ";
// scratch in page 4
static uint8 *sBuffer = (uint8 *)0x400;


/*
--------
|###   |
|## ###|
|# ##  |
|# # ##|
| ## ##|
| ## ##|
| ### #|
|##### |
--------
*/
static const uint8 sSpr1[] = { \
	GR_DM | 0x07, 
	GR_DM | 0x08, 
	GR_DM | 0x13, 
	GR_DM | 0x14, 
	GR_DM | 0x24, 
	GR_DM | 0x24, 
	GR_DM | 0x22, 
	GR_DM | 0x01
};

static uint8 *gPtr;
static uint8 gLine;
static char sRolled;


void fake_ss_start(void)
{
	LZ77_UnCompress(SsPicture,(unsigned char*)0xa000);
	hires_scroll_text_set(sText, A_FWGREEN);
}


void fake_ss_slice(void)
{
	music_slice();
	spin(1);
	hires_scroll_text_slice(1);
}

static uint8 sBrush[] = {
	0x41, 0x42,
	0x44, 0x41,
	0x40, 0x45,
	0x40, 0x40,
	0x4f, 0x70,
	0x5f, 0x79,

	0x5f, 0x7c,
	0x4f, 0x70,
	0x45, 0x43,
	0x43, 0x4c,
	0x44, 0x42,
	0x40, 0x40,

};

static uint8 sTagOffsets[][2] = {
	// V
	{ 6, 6 },
	{ 6, 7 },
	{ 6, 8 },
	{ 7, 10 },
	{ 7, 11 },
	{ 7, 12 },
	{ 7, 13 },
	{ 8, 15 },
	{ 8, 16 },
	{ 8, 17 },
	{ 8, 18 },
	{ 9, 20 },
	{ 11, 18 },
	{ 11, 17 },
	{ 11, 16 },
	{ 11, 15 },
	{ 12, 13 },
	{ 12, 12 },
	{ 12, 11 },
	{ 12, 10 },

	// i
	{ 15, 10 },
	{ 15, 11 },
	{ 15, 12 },
	{ 15, 13 },
	{ 15, 14 },
	{ 15, 15 },
	{ 15, 16 },
	{ 16, 17 },
	{ 15, 7 },

	// P
	{ 18, 5 },
	{ 18, 6 },
	{ 18, 7 },
	{ 18, 8 },
	{ 18, 9 },
	{ 18, 10 },
	{ 18, 11 },
	{ 18, 12 },
	{ 18, 13 },
	//
	{ 21, 4 },
	{ 22, 5 },
	{ 23, 6 },
	{ 23, 7 },
	{ 23, 8 },
	{ 22, 9 },
	{ 21, 10 },

	// souligné
	{ 15, 25 },
	{ 16, 24 },
	{ 18, 23 },
	{ 20, 22 },
	{ 22, 22 },
	{ 24, 22 },
	{ 27, 21 },
};
#define NTAGS (sizeof(sTagOffsets)/(sizeof(uint8)*2))

static uint8 sTagI;
static uint8 sTagLastX;
static uint8 sTagLastY;

static void putsprhr(uint8 x, uint8 y)
{
	uint8 *p = p0 + 40 * 6 * y + x;
	uint8 *b = sBrush;
	char i;
	for (i = 0; i < 12; i++) {
		if (sTagLastY != y || sTagLastX <= x - 3 || sTagLastX > x)
			p[-1] = A_FWRED;
		p[0] |= b[0];
		p[1] |= b[1];
		p[2] = A_FWWHITE;
		p += 40;
		b += 2;
	}
	sTagLastX = x;
	sTagLastY = y;
}


void fake_ss_tag_do(void)
{
	sTagLastX = 0;

	hires_scroll_text_set(sText2, A_FWRED);

	for (sTagI = 0; sTagI < NTAGS; sTagI++) {
		uint8 i;
		putsprhr(sTagOffsets[sTagI][0], 
			 sTagOffsets[sTagI][1]);
		
		
		music_slice();
		hires_scroll_text_slice(1);
	}

}



void fake_ss_rolldown_start(void)
{
	uint8 *p;
	char i;
	/*	
	p = (uint8 *)0xa000;
	for (i = 0; i < 6; i++) {
		p[40*i] = 0x40 + PIXMASK(i);
		p[40*i+2] = 0xc0 + PIXMASK(i);
	}
	*/
	
	sRolled = 0;
	gPtr = (uint8 *)0xa000;
	gLine = 0;
	p = gPtr;
	/*
	for (i = 0; i < 8; i++) {
		int j;
		for (j = 39; j > 0; j--)
			p[j] = 0xc0 | (p[j-1] & 0x3f);
		p+=40;
	}
	gPtr += 8 * 40;
	*/
}

void fake_ss_rolldown_slice(void)
{
	char i;
	char j;
	uint8 *p;
	// copie
	//if (gLine > 200 - sRolled)
	//	return;

	memcpy(sBuffer, gPtr, 40);

	music_slice();

	//
	p = gPtr;
	for (i = 0; i < sRolled-2; i++) {
		memcpy(p, p-80, 40);
		p -= 40;
	}
	if (sRolled < 7) 
		sRolled++;
	ASSERT(p >= (uint8 *)0xa000);
	for (j = 39; j > 0; j--)
		//p[j] = 0xc0 | (sBuffer[j-1] & 0x3f);
		p[j] = 0x80 | (sBuffer[j-1]);
	memset(p-40, 0x40, 40);


	gLine ++;
	gPtr += 40;
	//get();
}

void fake_ss_rolldown_do(void)
{
	do {
		fake_ss_rolldown_slice();
		music_slice();
		hires_scroll_text_slice(1);
	} while (gLine < 200);
}

void fake_ss_end(void)
{
	//LZ77_UnCompress(VipPicture,(unsigned char*)0xa000);

}

