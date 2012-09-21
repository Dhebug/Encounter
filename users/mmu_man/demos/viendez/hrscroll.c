/* -*- c-basic-offset: 8 -*-
 * (c) 2008, Francois Revol <revol@free.fr>
 *
 */

#include "global.h"

static char *gText;
static int gLen;
static char *gPtr;
static char *gPtr2;
static int gOffset;
static char gOnce;

#define OFFSET_X 0
#define OFFSET_Y 1


void hires_scroll_text_set(const char *str, char color)
{
	gText = (char *)str;
	gLen = strlen(str);
	gOffset = 0;
	gOnce = 0;
	gPtr = (char *)(TEXTVRAM+40*25+40*OFFSET_Y+OFFSET_X);
	gPtr2 = gPtr + 40;
	gPtr[0] = A_STD2H;
	gPtr[1] = color;
	gPtr2[0] = A_STD2H;
	gPtr2[1] = color;
}

void hires_scroll_text_slice(char domusic)
{
	char i;
	char *p = &gPtr[2];
	char *q = &gPtr2[2];
	char *t;
	int o = gOffset;
	o %= gLen;
	t = &gText[o];
	for (i = 2; i < 40; i++, o++) {
		char c;
		if (o >= gLen) {
			o = 0;
			t = &gText[0];
		}
		if (i == 2 && !(*p & 0x60)) {
			/* attribute, keep it */
			*(p-1) = *p;
			*(q-1) = *p;
		}

			
		//o %= gLen;
		//c = gText[o];
		c = *t++;
		*p++ = c;
		*q++ = c;
		//gPtr[i] = c;
		//gPtr2[i] = c;
		// schedule playing
		if (domusic && i == 20)
			music_slice();
	}
	gOffset++;
	gOffset %= gLen;
	if (!gOffset)
		gOnce = 1;
}

void hires_scroll_text_slice_nomusic_old(void)
{
	char i;
	char *p = &gPtr[2];
	char *q = &gPtr2[2];
	char *t;
	int o = gOffset;
	for (i = 2; i < 40; i++, o++) {
		char c;
		o %= gLen;
		c = gText[o];
		*p++ = c;
		*q++ = c;
		//gPtr[i] = c;
		//gPtr2[i] = c;
		// schedule playing
		//if (i == 20)
		//music_slice();
	}
	gOffset++;
	gOffset %= gLen;
	if (!gOffset)
		gOnce = 1;
}

char hires_scroll_text_is_once(void)
{
	return gOnce;
}

