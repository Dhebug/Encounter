/* -*- c-basic-offset: 8 -*-
 * (c) 2008, Francois Revol <revol@free.fr>
 *
 */

#include "global.h"
#include "stdlib.h"
//#include "fpmath.h"
#include "math.h"

#include "stars_tabs.h"

//#define DONTDRAW 1


//#define OPT_ 1
//#define USETRIGO 1

extern char div8u(char a,char b);
extern char div8s(char a,char b);


static const char *sText = "plop";
 /*"    THIS IS THE END - THANKS FOR WATCHING - SEE YOU NEXT TIME     Credits:    Code: mmu_man - Music: mmu_man :D - pictures: my webcam ";*/

#define CN "\007"
#define CT "\007"
#define CL "\002" /* labels */
#define CU "\004" /* urls */
#define CS "\002" /* separator */
#define CSEP "|"
#define SEP CS CSEP CN


static const char *sTexts[] = {
	/*
	"You are invited to : Alchimie 2k9" SEP "6-8 novembre 2009",
	"Demo party / Conferences / Stands",
	"Themes : Creation / Robotique / Developpement durable",
	"DemoParty : OldSchool / NewSchool / Graph / Musique / Wild",
	"Platefomes : Amiga / Atari / Linux / Haiku / ORIC / Ti92 ...",
	"\x02Stands :\007assos\x02/\x07G3L\x02/\x07revendeurs Amiga... ",
	"\x04http://triplea.fr/\x07",
	"Greets : Cicile & Fabounio - TripleA - G3L - Corto - ",
	"Rajah Lone / Renaissance - purelamers - Pops / woodtower - ",
	"_DBug_ / Defence Force - PopsyTeam - Hello / SECTOR ONE - MJJ Prods",
	"Credits : Code: mmu_man - Music : mmu_man",
	*/
	NULL
};


extern int8 costable[256];



#if 1


struct _transform {
	int8 *tabx;
	int8 *taby;
	char duration;
	char rasters;
	char equalizer;
	//char noerase;
	const char *text;
};

#define D1 40

static struct _transform gTransformList[] = {
	{ tabx_0, taby_0, D1, 0, 1, CL"You are invited to :"CN" Alchimie 2k9" SEP "6-8 novembre 2009   " },
	{ tabx_1, taby_1, D1, 0, 0, CN"Demo party"SEP"Conferences"SEP"Stands   " },
	{ tabx_2, taby_2, D1, 0, 0, CL"Themes :"CN"Creation"SEP"Robotique"SEP"Developpement durable   " },
	{ tabx_3, taby_3, 4*D1, 0, 0, CL"DemoParty :"CN"OldSchool"SEP"NewSchool"SEP"Graph"SEP"Musique"SEP"Wild   " },
	{ tabx_1, taby_1, D1, 0, 0, CL"Platefomes :"CN"Amiga"SEP"Atari"SEP"Linux"SEP"Haiku"SEP"ORIC"SEP"Ti92 ...   " },
	{ tabx_1, taby_1, D1, 0, 0, CL"Stands :"CN"assos"SEP"G3L"SEP"Voxel Amiga Shop"SEP"...   " },
	{ tabx_1, taby_1, D1, 0, 0, CU"http://triplea.fr/   " },
	{ tabx_1, taby_1, D1, 1, 0, CL"Greets :"CN"Cicile & Fabounio"SEP"TripleA"SEP"G3L"SEP"Corto"SEP"Rajah Lone / Renaissance"SEP"purelamers"SEP"Pops / woodtower"SEP"_DBug_ / Defence Force"SEP"PopsyTeam"SEP"Hello / SECTOR ONE"SEP"MJJ Prods   " },
	{ tabx_1, taby_1, D1, 0, 0, CL"Credits :"CN"Code: mmu_man"SEP"Music : mmu_man   " },
	{ tabx_1, taby_1, D1, 0, 0, CL"                 \001</HADOPI>                                       "},

	//{ 0, 0, 2, 0, D1, 0 },
	//{ 0, 1, 0, 0, D1, 1 }
};

#define NTRANS (sizeof(gTransformList)/sizeof(struct _transform))

static uint8 gTransform;

static struct _transform *gTr;


/* we'll use a 192x192 window (16*6*2)x(16*6*2) */


#define WW (16*6*2)
//#define WW (16*4*2)
#define WH WW

#define TAB_W 16
#define TAB_H 16

#define TAB_S (TAB_W*TAB_H)

#define O_X (-WW/2)
#define O_Y (-WH/2)

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

static uint8 duration;

struct _star {
	char oldx;
	char oldy;
	char x;
	char y;
	char tx;
	char ty;
	char sz;
};

#define NSTARS 10

struct _star gStars[NSTARS];

static uint8 sMusicDelay = 0;
//#define MUSIC_DELAY 4

void stars_do(void)
{
	char uno = 1; /* either 1 or -1 to avoid 0 in some places */
#ifndef DONTDRAW
	//StopInterrupt();
#endif


	do {
		int8 *tabx;
		int8 *taby;
		gTr = &gTransformList[gTransform];
		tabx = gTr->tabx;
		taby = gTr->taby;

		if (gTr->text)
			hires_scroll_text_set(gTr->text, A_FWWHITE);

		if (gTr->rasters)
			raster_start();

		//printf("T%d\n", gTransform);
		
		duration = gTr->duration;
		// 1line/ tick -> must have time to regen whole tab
		if (duration < TAB_H)
			duration = TAB_H;

#ifdef DONTDRAW
		stars_dump_tab(tabx, taby);
		get();
#endif
		do {
			char o;
			struct _star *s = gStars;
			for (o = 0; o < NSTARS; o++, s++) {
				uint8 tabo;
				// update 
				if (!s->x && !s->y) {
					uint16 x = ((uint16)rand() % WW);
					uint16 y = ((uint16)rand() % WH);
					//s->tx = x / D_X;
					s->tx = div8s(x, D_X);
					s->x = x + O_X;
					//s->ty = y / D_Y;
					s->ty = div8s(y, D_Y);
					s->y = y + O_Y;
					s->oldx=s->x;
					s->oldy=s->y;
					
					//printf("US[%d] %d,%d %d,%d\n", o, s->x, s->y, s->tx, s->ty);
				}
				//OPTIMIZED:
				//tabo = TAB_W * s->ty + s->tx;
				tabo = (((uint8)s->ty) << 4) | s->tx;
				
				//printf("tab[%d,%d:%d] %d,%d\n", s->tx, s->ty, tabo, tabx[tabo], taby[tabo]);
				s->x = s->oldx + tabx[tabo];
				s->y = s->oldy + taby[tabo];

				// XXX: is it really needed ?
				// maybe only for rotations


#ifndef DONTDRAW

				//if (!gTr->noerase) {
#if 1
				GCLRPIX((uint8)(/*(uint16)*/DO_X-O_X+s->oldx), 
					(uint8)(/*(uint16)*/DO_Y-O_Y+s->oldy));
#endif
#if 0
				curset(DO_X-O_X+s->oldx,DO_Y-O_Y+s->oldy,3);
				hchar('a',0,0);
#endif
				//}
#endif

				// out of screen ?
				if (s->x < O_X || s->x > O_X+WW-1) {
					s->x = 0;
					s->y = 0;
					continue;
				}
				if (s->y < O_Y || s->y > O_Y+WH-1) {
					s->x = 0;
					s->y = 0;
					continue;
				}

				//#ifdef IM_NOT_SURE_ABOUT_THAT
#if 0
				s->tx = (s->x / D_X) + TAB_W/2;
				s->ty = (s->y / D_Y) + TAB_H/2;
#endif
				s->tx = div8s(s->x, D_X) + TAB_W/2;
				s->ty = div8s(s->y, D_Y) + TAB_H/2;
				//#endif

				//ASSERT(s->x != s->oldx || s->y != s->oldy);
#ifndef DONTDRAW
#if 1
				GSETPIX((uint8)(/*(uint16)*/DO_X-O_X+s->x), 
					(uint8)(/*(uint16)*/DO_Y-O_Y+s->y));
#endif
#if 0
				curset(DO_X-O_X+s->x,DO_Y-O_Y+s->y,3);
				hchar('a',0,1);
#endif
#endif /* DONTDRAW */
				s->oldx=s->x;
				s->oldy=s->y;
				
			}
			//
#ifdef DONTDRAW
			//get();
#endif
			
			// update

			if (gTr->text)
				hires_scroll_text_slice(0);
			if (gTr->rasters)
				raster_slice();
			if (gTr->equalizer)
				eq_update();
			//duration--;
			music_slice();
		} while (duration && !hires_scroll_text_is_once());
		if (gTr->rasters)
			raster_stop();
		if (gTr->equalizer)
			eq_fini();

	} while (gTransform++ < NTRANS-1);



#ifndef DONTDRAW
	//RestoreInterrupt();
#endif
}

void stars_start(void)
{
	char o;
	gTransform = 0;
	gTr = &gTransformList[0];
	//XXX:
#ifdef DONTDRAW
	DO_TEXT();
#endif
	cls();
	//printf("G\n");

#ifdef USETRIGO
	//stars_dump_taba(taba);
#endif

#ifdef DONTDRAW
	//stars_dump_tab(tab1x, tab1y);
#endif
	//printf("GD\n");
	for (o = 0; o < NSTARS; o++) {
		gStars[o].x = 0;
		gStars[o].y = 0;
	}

}


#endif
