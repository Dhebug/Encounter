/* -*- c-basic-offset: 8 -*-
 * (c) 2008, Francois Revol <revol@free.fr>
 *
 */

#include "stdlib.h"
#include "global.h"



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

void raster_start(void)
{
	char i;
	for (i = 0; i < NRASTS; i++) {
		struct _raster *r = &gRasters[i];
		r->p = p0 + (40 * r->y);
	}
}

void raster_stop(void)
{
	char i;
	unsigned char *p;
	for (i = 0, p = p0; i < 25; i++, p+=40)
	  *p = A_BGBLACK;
}


void raster_slice(void)
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



