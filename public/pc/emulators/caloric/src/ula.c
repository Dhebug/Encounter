/*
 *	ula.c - emulate the ULA (video)
 *	AYM 2002-08-21
 */

/*
This file is copyright André Majorel 2002-2004.

This program is free software; you can redistribute it and/or modify it under
the terms of version 2 of the GNU General Public License as published by the
Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place, Suite 330, Boston, MA 02111-1307, USA.
*/


#include <stddef.h>

#include "caloric.h"


char buf[(VIDEO_WIDTH + 1) * VIDEO_HEIGHT];
					/* Each cell contains the pixel colour
					   (0 through 7). The 241st column is a
					   boolean that says whether this
					   scanline has changed since the last
					   time. The boolean is embedded in the
					   buffer in the hope of keeping the
					   cache miss rate down (as all writes
					   occur in the same area).

					   This array is not static because
					   it's needed by the X11 rendering
					   function and the screenshot
					   function. */

int frametouched;

int hires = 0;				/* The ULA powers up in text mode. Not
					   static because config.c needs it. */

int initialised = 0;			/* Internal use */

int framenum = 0;			/* Frame counter (for blinking) */

#define BLINK_HALF_PERIOD_F 32		/* Half period of blinking in frames */


void render_frame_init()
    {
     int y;

    /* Force a refresh the first time */
    for (y = 0; y < VIDEO_HEIGHT; y++)
      buf[y * (VIDEO_WIDTH + 1) + VIDEO_WIDTH] = 1;
    frametouched = 1;

    }



void render_frame (void)
{
  unsigned bg;
  unsigned fg;
  int      set;
  int      dheight;
  int      blink;
  const unsigned char *chargen[2][2];

  const unsigned char *mem = (const unsigned char *) Oric_Mem;
  char *b;
  const unsigned char *from[2];
  int y;
  int bottom;				/* True iff y >= 200. In the last 24
					   scan lines, all rendering is done in
					   character mode. */

  chargen[0][0] = mem + CHARSET0_TEXT;
  chargen[0][1] = mem + CHARSET1_TEXT;
  chargen[1][0] = mem + CHARSET0_HIRES;
  chargen[1][1] = mem + CHARSET1_HIRES;
  if (! initialised)
  {
    int y;

    /* Force a refresh the first time */
    for (y = 0; y < VIDEO_HEIGHT; y++)
      buf[y * (VIDEO_WIDTH + 1) + VIDEO_WIDTH] = 1;
    frametouched = 1;
    hires = 0;
    initialised = 1;
  }

  from[0] = mem + RAM_TEXT;
  from[1] = mem + RAM_HIRES;

  b = buf;
  frametouched = 0;
  for (y = 0; y < VIDEO_HEIGHT; y++)
  {
    int x;
    int touched = 0;

    bottom = (y >= 200);

    /* Some attributes are reset at the beginning of every scan line */
    bg      = 0;
    fg      = 7;
    set     = 0;
    dheight = 0;
    blink   = 0;

    /* Render one line */
    for (x = 0; x < TEXT_COLUMNS; x++)
    {
      unsigned char cell = (from[hires && ! bottom][x] & 0x7f);
      int video_inverse  = (from[hires && ! bottom][x] & 0x80);
      unsigned char pattern;

      /* "Parse" one cell */
      if (cell >= 0x20)
      {
	if (hires && ! bottom)
	{
	  pattern = (cell & 0x3f);
	}
	else
	{
	  if (dheight)
	    pattern = chargen[hires && bottom][set]
	      [CHAR_HEIGHT * cell + (y / 2) % CHAR_HEIGHT];
	  else
	    pattern = chargen[hires && bottom][set]
	      [CHAR_HEIGHT * cell + y % CHAR_HEIGHT];
	}
      }
      else
      {
	if ((cell & 0x78) == 0x00)
	  fg = (cell & (COLOURS - 1));
	else if ((cell & 0x78) == 0x08)
	{
	  set     = !!(cell & 1);
	  dheight = (cell & 2);
	  blink   = (cell & 4);
	}
	else if ((cell & 0x78) == 0x10)
	  bg = (cell & (COLOURS - 1));
	else if ((cell & 0x78) == 0x18)
	  hires = !! (cell & 4);
	pattern = 0;
      }

      /* Blinking : force everything to BG */
      if (blink && framenum >= BLINK_HALF_PERIOD_F)
	pattern = 0;

      /* Render the cell (6 pixels in a row) */
      if (video_inverse)
      {
	int bg_ = COLOURS - 1 - bg;
	int fg_ = COLOURS - 1 - fg;
	char pixel;

	pixel=(pattern&0x20)?fg_:bg_; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x10)?fg_:bg_; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x08)?fg_:bg_; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x04)?fg_:bg_; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x02)?fg_:bg_; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x01)?fg_:bg_; if(*b!=pixel){*b = pixel; touched=1;} b++;
      }
      else
      {
	char pixel;

	pixel=(pattern&0x20)?fg:bg; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x10)?fg:bg; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x08)?fg:bg; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x04)?fg:bg; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x02)?fg:bg; if(*b!=pixel){*b = pixel; touched=1;} b++;
	pixel=(pattern&0x01)?fg:bg; if(*b!=pixel){*b = pixel; touched=1;} b++;
      }
    }

    from[1] += x;
    if (y % CHAR_HEIGHT == CHAR_HEIGHT - 1)
      from[0] += x;

    *b++ = (char) touched;		/* KLUDGEy eh ?  -> comment from Jede : it put a flag at the end of the line -> touched=1 then the line has changed*/
    if (touched)
      frametouched = 1;
  }

  framenum++;
  if (framenum >= 2 * BLINK_HALF_PERIOD_F)
    framenum = 0;
}

