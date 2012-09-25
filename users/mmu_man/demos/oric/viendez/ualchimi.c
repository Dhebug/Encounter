/* -*- c-basic-offset: 8 -*-
 * (c) 2011, Francois Revol <revol@free.fr>
 *
 */

#include "stdlib.h"
#include "global.h"


#define CLIP_TOP	(6*6)
#define CLIP_H		(20*6)
#define CLIP_BOTTOM	(CLIP_TOP + CLIP_H)

static const char *sText = "   VIENDEZ  -  microAlchimie  -  les 13 et 14 octobre 2012  -  Tain l'hermitage  -  \x0eLes places sont limitees !!!\x0a                               ";

// RASTERS

#define NRASTCOLORS 4
#define RASTERSBG A_BGMAGENTA

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
	{ 110, 3, 0, {A_BGBLUE, A_BGCYAN, A_BGCYAN, A_BGCYAN}, NULL },
	{ 40, -1, 0, {A_BGGREEN, A_BGRED, A_BGCYAN, A_BGCYAN}, NULL }
	
};
#define NRASTS (sizeof(gRasters)/sizeof(struct _raster))


static uint8 sAnimBubble = 13;
static uint8 sAnimStar = 0;


// main stuff


void ualchimi_start(void)
{
	unsigned char *p = p0;
	int i;

	// logo

	hires_scroll_text_set(sText, A_FWRED);

	LZ77_UnCompress(uAlchimie2Picture,p0);

	// hide the sprites

	for (i = 0; i < CLIP_TOP; i++, p += 39) {
		*p++ = A_BGBLACK;
		*p = A_FWBLACK;
	}
	p += CLIP_H * 40;
	for (i = 0; i < 200 - CLIP_BOTTOM; i++, p += 39) {
		*p++ = A_BGBLACK;
		*p = A_FWBLACK;
	}

	// move attributes to where we want
	*(GR_BASE + 72 * 40 + 20 - 1) = A_FWRED;
	*(GR_BASE + 72 * 40 + 20) = 0x40;// 0;
	*(GR_BASE + 73 * 40 + 20 - 1) = A_FWRED;
	*(GR_BASE + 73 * 40 + 20) = 0x40;//0;
/*
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
*/
	for (i = 0; i < NRASTS; i++) {
		struct _raster *r = &gRasters[i];
		r->p = p0 + (40 * r->y);
	}
	
}



static void ualchimi_raster_slice(void)
{
	uint8 *p = p0;
	char i;
	for (i = 0; i < NRASTS; i++) {
		struct _raster *r = &gRasters[i];

		// erase
		*r->p = RASTERSBG;
		// calc new line
		r->y += r->speed;
		if (r->y > CLIP_BOTTOM - 1) {
			if (r->y > CLIP_BOTTOM + 10) {
				/* overflowed */
				r->y = CLIP_TOP;
			} else
				r->y = CLIP_BOTTOM - 1;
			r->speed = -r->speed;
		}
		if (r->y < CLIP_TOP) {
			r->y = CLIP_TOP;
			r->speed = -r->speed;
		}
		//printf("%s\n", r->y);
		ASSERT(r->y >= CLIP_TOP);
		ASSERT(r->y < CLIP_BOTTOM);
		r->p = p0 + (40 * r->y);
		// display
		*r->p = r->colors[r->cycle];
		//*r->p = A_BGRED;
		// cycle color
		r->cycle = (r->cycle + 1) % NRASTCOLORS;
	}
}


static void ualchimi_anim_bubble_slice(void)
{
	uint8 *p = GR_BASE + 20 * 6 * 40 + 2;
	uint8 *s = NULL;
	uint8 l = 36;

	sAnimBubble--;
	//printf("%d\n", sAnimBubble);

	if (sAnimBubble == 10) {
		s = GR_BASE + 0 * 40 + 2;
	} else if (sAnimBubble == 7) {
		s = GR_BASE + 0 * 40 + (2 + 7);
	} else if (sAnimBubble == 5) {
		s = GR_BASE + 0 * 40 + (2 + 7 * 2);
	} else if (sAnimBubble == 3) {
		s = GR_BASE + 0 * 40 + (2 + 7 * 3);
	} else if (sAnimBubble == 2) {
		s = GR_BASE + 0 * 40 + (2 + 7 * 4);
	} else if (sAnimBubble == 1) {
		s = GR_BASE + 27 * 6 * 40 + (2 + 7 * 3);
	} else if (sAnimBubble == 0) {
		sAnimBubble = 4;
		s = GR_BASE + 27 * 6 * 40 + (2 + 7 * 4);
	}

	if (!s)
		return;

	for (; l > 0; l--) {
		*p++ = *s++;
		*p++ = *s++;
		*p++ = *s++;
		*p++ = *s++;
		*p++ = *s++;
		*p++ = *s++;
		*p++ = *s++;
		p+= 40 - 7;
		s+= 40 - 7;
	}
}

static void ualchimi_idots_slice(void)
{
	uint8 *p = GR_BASE + 72 * 40 + 20 - 1;
	char i = 9;
	static char c = 0;

	for (; i > 0; i--, p += 40) {
		*p = A_FWBLACK + c;
	}
	
	c += 1;
	c = c % 8;
}


void ualchimi_slice(void)
{
	hires_scroll_text_slice(1);
	ualchimi_raster_slice();
	ualchimi_anim_bubble_slice();
	spin(1);
	ualchimi_raster_slice();
	hires_scroll_text_slice(1);
	//spin(1);
	//ualchimi_raster_slice();
	spin(1);
	ualchimi_idots_slice();
}


void ualchimi_do(void)
{
	do {
		ualchimi_slice();
	} while (!hires_scroll_text_is_once());
	// once more!
	hires_scroll_text_set(sText, A_FWRED);
	do {
		ualchimi_slice();
	} while (!hires_scroll_text_is_once());
}

