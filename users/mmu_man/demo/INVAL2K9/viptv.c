/* -*- c-basic-offset: 8 -*-
 * (c) 2008, Francois Revol <revol@free.fr>
 *
 */

#include "global.h"
#include "stdlib.h"


static const char *sText = "THIS IS VIP 2008 - HMMMMMMmmmmm RASTERS!    Je sais, la zik est moche et prend du CPU, mais on fera mieux la prochaine fois   ";



void vip_font_set(void)
{
	
}


// RASTERS

#define NRASTCOLORS 4

struct _raster {
	uint8 y;
	char speed; // 4.4 fixed pt
	uint8 cycle;
	uint8 colors[NRASTCOLORS];
	uint8 *p;
};

static struct _raster gRasters[] = {
	{ 50,  1, 0, {A_BGRED, A_BGRED, A_BGRED, A_BGRED}, NULL },
	{ 52,  1, 0, {A_BGRED, A_BGBLUE, A_BGMAGENTA, A_BGRED}, NULL },
	{ 54,  1, 0, {A_BGGREEN, A_BGBLUE, A_BGGREEN, A_BGYELLOW}, NULL },
	//{ 55,  1, 0, {A_BGCYAN, A_BGCYAN, A_BGCYAN, A_BGBLUE}, NULL },
	//{ 56,  1, 0, {A_BGGREEN, A_BGBLUE, A_BGGREEN, A_BGYELLOW}, NULL },

	{ 80, -2, 0, {A_BGRED, A_BGRED, A_BGRED, A_BGRED}, NULL },
	{ 81, -2, 0, {A_BGRED, A_BGBLUE, A_BGRED, A_BGRED}, NULL },
	{ 180, 3, 0, {A_BGBLUE, A_BGCYAN, A_BGCYAN, A_BGCYAN}, NULL },
	//{ 20, -1, 0, {A_BGGREEN, A_BGRED, A_BGCYAN, A_BGCYAN}, NULL }
	
};
#define NRASTS (sizeof(gRasters)/sizeof(struct _raster))

void viptv_raster_start(void)
{
	char i;
	for (i = 0; i < NRASTS; i++) {
		struct _raster *r = &gRasters[i];
		r->p = p0 + (40 * r->y);
	}
}


void viptv_raster_slice(void)
{
	uint8 *p = p0;
	char i;
	for (i = 0; i < NRASTS; i++) {
		struct _raster *r = &gRasters[i];

		// erase
		*r->p = A_BGBLACK;
		// calc new line
		r->y += r->speed;
		if (r->y > 200 - 1) {
			if (r->y > 210) {
				r->y = 0;
			} else
				r->y = 200-1;
			r->speed = -r->speed;
		}
		ASSERT(r->y >= 0);
		ASSERT(r->y < 200);
		r->p = p0 + (40 * r->y);
		// display
		*r->p = r->colors[r->cycle];
		//*r->p = A_BGRED;
		// cycle color
		r->cycle = (r->cycle + 1) % NRASTCOLORS;
	}
}



// main stuff


void viptv_start(void)
{
	// logo

	hires_scroll_text_set(sText, A_FWCYAN);
	
}


void viptv_slice(void)
{
	viptv_raster_slice();
	music_slice();
	hires_scroll_text_slice(1);
	music_slice();
	viptv_raster_slice();
	music_slice();
}


void viptv_do(void)
{
	do {
		viptv_slice();
	} while (!hires_scroll_text_is_once());
}

void viptv_fade_center(void)
{
	uint8 i;
	uint8 *p;
	uint8 *q;
	p = p0;
	q = p + 200*240/6 - 40;

	for (i = 0; i < 100; i++) {
		memset(p, 0x40, 40);
		memset(q, 0x40, 40);
		p += 40;
		q -= 40;
		//music_slice();
		spin(1);
		//get();
	}
}
