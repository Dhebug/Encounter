/* -*- c-basic-offset: 8 -*-
 * (c) 2012, Francois Revol <revol@free.fr>
 *
 */

#include "stdlib.h"
#include "global.h"


static const char *sText = " Vous avez aime l'ALCHIMIE 111111...   ";

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
	{ 55,  1, 0, {A_BGCYAN, A_BGCYAN, A_BGCYAN, A_BGBLUE}, NULL },
	{ 56,  1, 0, {A_BGGREEN, A_BGBLUE, A_BGGREEN, A_BGYELLOW}, NULL },

	{ 80, -2, 0, {A_BGRED, A_BGRED, A_BGRED, A_BGRED}, NULL },
	{ 81, -2, 0, {A_BGRED, A_BGBLUE, A_BGRED, A_BGRED}, NULL },
	{ 82, -2, 0, {A_BGRED, A_BGBLUE, A_BGRED, A_BGRED}, NULL },
	{ 83, -2, 0, {A_BGRED, A_BGBLUE, A_BGRED, A_BGRED}, NULL },
	{ 180, 3, 0, {A_BGBLUE, A_BGCYAN, A_BGCYAN, A_BGCYAN}, NULL },
	{ 20, -1, 0, {A_BGGREEN, A_BGRED, A_BGCYAN, A_BGCYAN}, NULL }
	
};
#define NRASTS (sizeof(gRasters)/sizeof(struct _raster))




// main stuff


void demoinsi_start(void)
{
	unsigned char *p = p0;
	int i;

	// logo

	hires_scroll_text_set(sText, A_FWRED);

	LZ77_UnCompress(DemoInsidePicture,p0);

	p++;
	for (i = 0; i < 160; i++, p += 40)
		*p = A_FWBLUE;

	p -= 10 * 40;
	p += 150 / 6;
	for (i = 0; i < 25; i++, p += 40)
		*p = A_FWGREEN;
	p--; // 6pix left
	for (i = 0; i < 22; i++, p += 40)
		*p = A_FWGREEN;

	for (i = 0; i < NRASTS; i++) {
		struct _raster *r = &gRasters[i];
		r->p = p0 + (40 * r->y);
	}
	
}



void demoinsi_raster_slice(void)
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



void demoinsi_slice(void)
{
	hires_scroll_text_slice(1);
	demoinsi_raster_slice();
	spin(1);
	demoinsi_raster_slice();
	spin(1);
	demoinsi_raster_slice();
	spin(1);
}


void demoinsi_do(void)
{
	do {
		demoinsi_slice();
	} while (!hires_scroll_text_is_once());
}

