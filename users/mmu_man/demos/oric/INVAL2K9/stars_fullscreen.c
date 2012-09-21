/* -*- c-basic-offset: 8 -*-
 * (c) 2008, Francois Revol <revol@free.fr>
 *
 */

#include "global.h"
#include "stdlib.h"
#include "fpmath.h"

//#define DONTDRAW 1


#if 1

void stars_setchr(void)
{
	
}



struct _transform {
	/*
	char x;
	char y;
	*/
	char rot;
	char zoom;
	char zx;
	char zy;
	char duration;
};

static struct _transform gTransformList[] = {
	{ 0, 2, 0, 0, 10 },
	{ 0, 0, 0, 0, 10 }
};

#define NTRANS (sizeof(gTransformList)/sizeof(struct _transform))

static uint8 gTransform;

static struct _transform *gTr;
static struct _transform *gNextTr = &gTransformList[0];


#define TAB_W 16
#define TAB_H 16

#define TAB_S (TAB_W*TAB_H)

#define O_X (-240/2)
#define O_Y (-200/2)

#define D_X (240/TAB_W)
#define D_Y (200/TAB_H)

#define DIV_X (TAB_W/240)
#define DIV_Y (TAB_H/200)

/*
struct _vec {
	char x;
	char y;
};
*/

static uint8 duration;

static uint8 tab1x[TAB_S];
static uint8 tab1y[TAB_S];
static uint8 tab2x[TAB_S];
static uint8 tab2y[TAB_S];

static char tab;

static char tab_gen_y;

void stars_gen_tab_slice(void)
{
	char X = O_X;
	char Y;
	char tx;
	char ty = tab_gen_y;
	char ox = -TAB_W/2;
	char oy = ty - TAB_H/2;
	uint16 oy2 = ox*ox;
	uint16 q; // = ox^2 + oy^2

	char vx;
	char vy;

	uint8 *tabx = (tab?tab2x:tab1x) + TAB_W * ty;
	uint8 *taby = (tab?tab2y:tab1y) + TAB_W * ty;
	
	Y = O_Y + 200 * oy;
	for (tx = 0; tx < TAB_W; tx++, ox++) {
		char qq;
		X += D_X;
		q = ox*ox + oy2;
		qq = q >> 4;
		//printf("%d,%d %d,%d %d,%d q:%d\n", tx, ty, ox, oy, X, Y, q);
		if (gNextTr->zoom) {
			//printf("qq:%d\n", qq);
			*tabx += (ox>0)?qq:-qq;
			*taby += (oy>0)?qq:-qq;
		}

		tabx++;
		taby++;
	}
	tab_gen_y++;
}

void stars_gen_tab(void)
{
	for (tab_gen_y = 0; tab_gen_y < TAB_H;)
		stars_gen_tab_slice();
	tab = (tab+1)%1;
	     
}


struct _star {
	char oldx;
	char oldy;
	char x;
	char y;
	char tx;
	char ty;
	char sz;
};

#define NSTARS 20

struct _star gStars[NSTARS];



void stars_do(void)
{
	char uno = 1; /* either 1 or -1 to avoid 0 in some places */
	StopInterrupt();


	do {
		
		uint8 *tabx = ((!tab)?tab2x:tab1x);
		uint8 *taby = ((!tab)?tab2y:tab1y);
		gTr = &gTransformList[gTransform];
		gNextTr = &gTransformList[gTransform+1];


		printf("T%d\n", gTransform);
		
		duration = gTr->duration;
		// 1line/ tick -> must have time to regen whole tab
		if (duration < TAB_H)
			duration = TAB_H;
		tab_gen_y = 0;

		do {
			char o;
			struct _star *s = gStars;
			for (o = 0; o < NSTARS; o++, s++) {
				uint8 tabo;
				// update 
				if (!s->x && !s->y) {
					s->x = rand() % 240;
					s->tx = s->x / D_X;
					s->x += O_X;
					s->y = rand() % 200;
					s->ty = s->y / D_Y;
					s->y += O_Y;
					s->oldx=s->x;
					s->oldy=s->y;
					
					printf("US[%d] %d,%d %d,%d\n", o, s->x, s->y, s->tx, s->ty);
				}
				tabo = TAB_W * s->ty + s->tx;
				
				s->x = s->oldx + tabx[tabo];
				s->y = s->oldy + taby[tabo];

				//t->tx = 
#ifndef DONTDRAW
				GCLRPIX((uint8)O_X+s->oldx, 
					(uint8)O_Y+s->oldy);
#endif

				// out of screen ?
				if (s->x < O_X || s->x > O_X+240-1) {
					s->x = 0;
					s->y = 0;
					continue;
				}
				if (s->y < O_Y || s->y > O_Y+200-1) {
					s->x = 0;
					s->y = 0;
					continue;
				}
				//ASSERT(s->x != s->oldx || s->y != s->oldy);
#ifndef DONTDRAW
				GSETPIX((uint8)O_X+s->x, 
					(uint8)O_Y+s->y);
#endif /* DONTDRAW */
				s->oldx=s->x;
				s->oldy=s->y;
				
			}
			// update
			if (tab_gen_y < TAB_H) {
				stars_gen_tab_slice();
				tab_gen_y++;
			}
			
		} while (duration--);


		tab = (tab+1)%1;

	} while (gTransform++ < NTRANS-1);



	RestoreInterrupt();
}

void stars_start(void)
{
	gTransform = 0;
	tab = 0;
	tab_gen_y = 0;

	//XXX:
#ifdef DONTDRAW
	DO_TEXT();
#endif
	printf("G\n");
	stars_gen_tab();
	printf("GD\n");

}


#endif
