/* -*- c-basic-offset: 8 -*-
 * (c) 2009, Francois Revol <revol@free.fr>
 *
 */

#include "global.h"
#include "stdlib.h"

// MUST be %6=0
#define EQ_ORIGIN_X 180
#define EQ_ORIGIN_Y 160
#define EQ_ORIGIN_ADDR (PIXADDR(GR_BASE, EQ_ORIGIN_X, EQ_ORIGIN_Y))
#define EQ_HEIGHT 16
#define EQ_SLICE_HSHIFT 1
#define EQ_SLICE_H (1 << EQ_SLICE_HSHIFT)
#define EQ_CHANS 8
#define EQ_WIDTH (6*EQ_CHANS)


#define EQ_BAR_OFF (GR_DM | 0x00)
#define EQ_BAR_ON  (GR_DM | 0x1f)



static uint8 *gPtr;
static uint8 gLine;
static char sRolled;


void eq_init_colors(void)
{
	uint8 i;
	/* colors */
	uint8 *p = EQ_ORIGIN_ADDR;
	for (i = 0; i < EQ_HEIGHT; i++) {
		int attr = A_FWBLACK;
		if ((i + 1) % EQ_SLICE_H) {
			if (i < EQ_HEIGHT / 4)
				attr = A_FWRED;
			else if (i < EQ_HEIGHT / 2)
				attr = A_FWYELLOW;
			else
				attr = A_FWGREEN;
		}
		*p = attr;
		p += GR_STRIDE;
	}
}

void eq_init(void)
{
	eq_init_colors();
}

void eq_fini(void)
{
	uint8 i;
	/* colors */
	uint8 *p = EQ_ORIGIN_ADDR;
	int attr = GR_DM;
	for (i = 0; i < EQ_HEIGHT; i++) {
		int j;
		for (j = 0; j < EQ_CHANS+1; j++) {
			*p++ = attr;
		}
		p += GR_STRIDE - EQ_CHANS - 1;
	}
	
}

void eq_update(void)
{
	uint8 i, x;
	/* colors */
	eq_init_colors();
	for (x = 0; x < EQ_CHANS; x++) {
		uint8 *p = (EQ_ORIGIN_ADDR + 1 + (EQ_HEIGHT - 1) * GR_STRIDE);
		uint8 peak = (i + (uint8)rand()) % EQ_HEIGHT;
		peak += (EQ_SLICE_H - 1);
		peak >>= EQ_SLICE_HSHIFT;
		peak <<= EQ_SLICE_HSHIFT;
		p += x;
		for (i = 0; i < EQ_HEIGHT; i++) {
			*p = (i < peak) ? EQ_BAR_ON : EQ_BAR_OFF;
			p -= GR_STRIDE;
		}
	}
	//for (x=0;x<255;x++);
}
