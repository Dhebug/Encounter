/* -*- c-basic-offset: 8 -*-
 * (c) 2008, Francois Revol <revol@free.fr>
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include <inttypes.h>
#include <SupportDefs.h>

#if 0
#include "global.h"
#include "stdlib.h"
//#include "fpmath.h"
#include "math.h"
#endif

#define DONTDRAW 1


//#define OPT_ 1
#define USETRIGO 1

int8 costable[256];

#define atn atan




struct _transform {
	/*
	char x;
	char y;
	*/
	char rot;
	char zoom; // actually number of << for qq
	char zx;
	char zy;
	char duration;
	//char noerase;
	//char scroll;
	char *name;
};

#define D1 40

static struct _transform gTransformList[] = {
	{ 0, 0, 0, 2, D1, "" },
	{ 0, 1, 0, 0, D1 },
	{ 0, 2, 0, 0, D1 },
	{ 0, 4, 0, 0, 4*D1 },
	//{ 0, 0, 2, 0, D1 },
	//{ 0, 1, 0, 0, D1 }
};

#define NTRANS (sizeof(gTransformList)/sizeof(struct _transform))

static uint8 gTransform;

static struct _transform *gTr;
static struct _transform *gNextTr;


/* we'll use a 192x192 window (16*6*2)x(16*6*2) */


#define WW (16*6*2)
//#define WW (16*4*2)
#define WH WW

#define TAB_W 16
#define TAB_H 16

#define MBW (WW/TAB_W)
#define MBH (WH/TAB_H)

#define TAB_S (TAB_W*TAB_H)

#define O_X (-WW/2+MBW/2)
#define O_Y (-WH/2+MBH/2)

#define D_X (WW/TAB_W)
#define D_Y (WH/TAB_H)

#define DIV_X (TAB_W/WW)
#define DIV_Y (TAB_H/WH)

#define DO_X ((240 - WW)/2)
#define DO_Y ((200 - WH)/2)

/*
struct _vec {
	char x;
	char y;
};
*/

static int8 tab1x[TAB_S];
static int8 tab1y[TAB_S];
// angle of each block
static uint8 taba[TAB_S];

static char tabI;

static uint8 tab_gen_y;

void stars_gen_tab_slice(void)
{
	static char X;
	static char Y;
	static char tx;
	static char ty;
	static char ox;
	static char oy;
	static uint16 oy2;
	static uint16 ox2;
	static uint16 q; // = ox^2 + oy^2
	static char vx;
	static char vy;
	uint8 toy;
	int8 *tab_x;
	int8 *tab_y;
	uint8 *tab_a;
	
	X = O_X;
	ty = tab_gen_y;
	ox = -TAB_W/2;
	oy = ty - TAB_H/2;
	oy2 = oy*oy;
	ox2 = ox*ox;



	//OPTIMIZED:
	//toy = TAB_W * ty;
	toy = ty << 4;

	tab_x = tab1x + toy;
	tab_y = tab1y + toy;
	tab_a = taba + toy;
	
	Y = O_Y + WH * oy;
	for (tx = 0; tx < TAB_W; tx++, ox++) {
		char qq;
		int8 co = costable[*tab_a];
		int8 si = costable[(uint8)(*tab_a+256/4)];
		// first reset the table
		*tab_x=0;
		*tab_y=0;

		X += D_X;
		// OPTIMISED: (a+1)^2 = a^2 + 2a + 1
		//ox2 = ox*ox;
		// at end of loop

		q = ox2 + oy2;
		qq = q >> 5;
		if (qq == 0)
			qq = 1;
		//printf("%d,%d %d,%d %d,%d q:%d\n", tx, ty, ox, oy, X, Y, q);
		if (gNextTr->zoom) {
			//printf("qq:%d\n", qq);
			// we use zoom as a shift factor instead of mul
			// for speed
#ifndef USETRIGO
			*tab_x += ((ox>0)?qq:-qq)<<gNextTr->zoom;
			*tab_y += ((oy>0)?qq:-qq)<<gNextTr->zoom;
#else
			//*tab_x += co>>(3-gNextTr->zoom);
			//*tab_y += si>>(3-gNextTr->zoom);
			//printf("co %d si %d\n", co, si);
			*tab_x += co>>(7-gNextTr->zoom);
			*tab_y += si>>(7-gNextTr->zoom);
#endif

		}

		if (gNextTr->zx) {
			*tab_x += ((ox>0)?qq:-qq)<<gNextTr->zx;
		}

		if (gNextTr->zy) {
			*tab_y += ((oy>0)?qq:-qq)<<gNextTr->zy;
		}

		tab_x++;
		tab_y++;
		tab_a++;

		// OPTIMIZED from ox*ox above
		//ox2 = ox2 + ox*2 + 1;
		ox2 = ox2 + (int8)((uint8)ox<<1) + 1;

	}
	tab_gen_y++;
}

void stars_gen_tab(void)
{
	for (tab_gen_y = 0; tab_gen_y < TAB_H;)
		stars_gen_tab_slice();
	//tabI = (tabI+1)%2;
	     
}

// generate angle table
void stars_gen_taba(void)
{
	uint8 x, y;
	for (y = TAB_H/2; y < TAB_H; y++) {
		int16 oy = y - TAB_H/2;
		for (x = TAB_W/2; x < TAB_W; x++) {

			int16 ox = x - TAB_W/2 ;
			uint16 c;
			uint8 a;
			if (ox == 0)
				a = 64;
			else
				a = (atn((double)oy/ox)) * (double)128 / M_PI;
			//printf("%d,%d a %d\n", x, y, a);
#if 0
			uint16 qq = (ox*ox+oy*oy);
			qq = sqrt(qq);
			if (qq == 0)
				qq = 1;
			if (ox < 0)
				ox = (0-ox);
			c = ox * (double)128 / ((double)(TAB_W/2)*qq);
			a = myacos(c);
			printf("%d,%d cos %d a %d\n", x, y, c, a);
#endif
			taba[(uint8)(y*TAB_W)+x] = a;
			taba[(uint8)((TAB_H-y-1)*TAB_W)+(TAB_W-x-1)] = 128+a;
			//taba[(uint8)(y<<4)+(TAB_W-x)] = 128-a;
			taba[(uint8)((TAB_H-y-1)*TAB_W)+x] = (uint8)(-(int8)a);
			taba[(uint8)(x*TAB_W)+(TAB_W-y-1)] = a+64;
		}
	}
}

void stars_dump_tab(int8 *tabx, int8 *taby)
{
	char x, y;
	//printf("   ");
	//	for (x = 0; x < TAB_W; x++)
	//printf("%d");
	for (y = 0; y < TAB_H; y++) {
		//printf("");
		for (x = 0; x < TAB_W; x++) {
			
			printf("%-3d:%-3d ", *tabx++, *taby++);
		}
		printf("\n");
		//get();
	}
	//get();
}


static void dump_tab_c(int8 *tab)
{
	char x, y;
	//printf("   ");
	//	for (x = 0; x < TAB_W; x++)
	for (y = 0; y < TAB_H; y++) {
		//printf("");
		for (x = 0; x < TAB_W; x++) {
			
			printf("%d, ", (int8)(*tab++));
		}
		printf("\n");
		//get();
	}
}

void stars_dump_tab_c(int8 *tabx, int8 *taby, int nth)
{
	char x, y;
	//printf("   ");
	//	for (x = 0; x < TAB_W; x++)
	printf("static int8 tabx_%d[%d] = {\n", nth, TAB_S);
	dump_tab_c(tabx);
	printf("};\n");
	printf("static int8 taby_%d[%d] = {\n", nth, TAB_S);
	dump_tab_c(taby);
	printf("};\n");
}

void stars_dump_taba(uint8 *tab)
{
	char x, y;
	//printf("   ");
	//	for (x = 0; x < TAB_W; x++)
	//printf("%d");
	for (y = 0; y < TAB_H; y++) {
		//printf("");
		for (x = 0; x < TAB_W; x++) {
			
			printf("%.3d ", *tab++);
		}
		printf("\n");
		//get();
	}
	//get();
}


void stars_do(void)
{
	char uno = 1; /* either 1 or -1 to avoid 0 in some places */
	int nth = 0;

	do {
		
		int8 *tabx = tab1x;
		int8 *taby = tab1y;
		gTr = &gTransformList[gTransform];
		gNextTr = &gTransformList[gTransform+1];

		//if (gTr->scroll)
		//	hires_scroll_text_set(sText, A_FWWHITE);

		//printf("T%d tab%d\n", gTransform, tabI);
		
		tab_gen_y = 0;

		stars_dump_tab_c(tabx, taby, nth++);
		//stars_dump_tab(tabx, taby);
		stars_gen_tab();


		//stars_gen_tab();

		tab_gen_y = 0;
		tabI = (tabI+1)%2;

	} while (gTransform++ < NTRANS-1);



}

void stars_start(void)
{
	char o;
	gTransform = 0;
	gTr = &gTransformList[0];
	gNextTr = &gTransformList[0];
	tabI = 0;
	tab_gen_y = 0;
	//XXX:
	//printf("G\n");

#ifdef USETRIGO
	stars_gen_taba();
	//stars_dump_taba(taba);
#endif

	stars_gen_tab();
#ifdef DONTDRAW
	//stars_dump_tab(tab1x, tab1y);
#endif
	tabI = 1;
	//printf("GD\n");

}

int main(int argc, char **argv)
{
	int i;
	for (i = 0; i < 256; i++)
		costable[i] = cos(i*2*M_PI/256) * 128;
	stars_start();
	stars_do();
	//stars_gen_tab();
}
