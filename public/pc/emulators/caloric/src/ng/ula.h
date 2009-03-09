/*
 *	ula.h
 *	AYM 2003-08-04
 */

/*
This file is copyright André Majorel 2003.

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


#ifndef ULA_H
#define ULA_H


class Ula : public Component
{
  public :

  protected :
    unsigned char buf[240 * 224];

  private :
    bool hires;
    bool h;
    char buf[(VIDEO_WIDTH + 1) * VIDEO_HEIGHT];
					/* Each cell contains the pixel colour
					   (0 through 7). The 241st column is a
					   boolean that says whether this
					   scanline has changed since the last
					   time. The boolean is embedded in the
					   buffer instead in the hope of
					   keeping the cache miss rate down (as
					   all writes occur in the same
					   area).
					 
					   This array is not static because
					   it's needed by the X11 rendering
					   function and the screenshot
					   function. */

    int frametouched;

    int hires = 0;			/* The ULA powers up in text mode. Not
					   static because config.c needs it. */
    int initialised = 0;		/* Internal use */

    int framenum = 0;			/* Frame counter (for blinking) */

#define BLINK_HALF_PERIOD_F 32		/* Half period of blinking in frames */

    unsigned bg;
    unsigned fg;
    int      set;
    int      dheight;
    int      blink;
    const unsigned char *chargen[2];

    int x;
    int y;
    int touched = 0;
};


/*
 *	Ula::cycle - one clock cycle (render 6 pixels)
 */
void Ula::cycle (void)
{
  const unsigned char *mem = (const unsigned char *) Oric_Mem;
  char *b;
  const unsigned char *from[2];
  int h;				/* The difference between hires and h
					   is that hires is what the ULA
					   remembers and h is how the next cell
					   is going to be rendered. h is
					   usually equal to hires except when
					   rendering the text part at the
					   bottom of a hires screen : hires is
					   still true but h is false. */

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

  if (hires)
  {
    h = 1;
    chargen[0] = mem + CHARSET0_HIRES;
    chargen[1] = mem + CHARSET1_HIRES;
  }
  else
  {
    h = 0;
    chargen[0] = mem + CHARSET0_TEXT;
    chargen[1] = mem + CHARSET1_TEXT;
  }

  /* Some attributes are reset at the beginning of every scan line */
  if (x == 0)
  {
    bg      = 0;
    fg      = 7;
    set     = 0;
    dheight = 0;
    blink   = 0;
  }

  /* Render six pixels */
  {
    unsigned char cell = (from[h][x] & 0x7f);
    int video_inverse = (from[h][x] & 0x80);
    unsigned char pattern;

    /* "Parse" one cell */
    if (cell >= 0x20)
    {
      if (h)
      {
	pattern = (cell & 0x3f);
      }
      else
      {
	if (dheight)
	  pattern = chargen[set][CHAR_HEIGHT * cell + (y / 2) % CHAR_HEIGHT];
	else
	  pattern = chargen[set][CHAR_HEIGHT * cell + y % CHAR_HEIGHT];
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
      {
	if (cell & 4)
	{
	  hires = 1;
	  if (h == 0)
	  {
	    if (y < 200)
	      h = 1;
	    chargen[0] = mem + CHARSET0_HIRES;
	    chargen[1] = mem + CHARSET1_HIRES;
	  }
	}
	else
	{
	  hires = 0;
	  if (h == 1)
	  {
	    h = 0;
	    chargen[0] = mem + CHARSET0_TEXT;
	    chargen[1] = mem + CHARSET1_TEXT;
	  }
	}
      }
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

  x++;
  if (x >= TEXT_COLUMNS)
  {
    x = 0;

    from[1] += x;
    if (y % CHAR_HEIGHT == CHAR_HEIGHT - 1)
      from[0] += x;

    *b++ = (char) touched;		/* KLUDGEy eh ? */
    if (touched)
      frametouched = 1;

    y++;
    /* Force text mode at the bottom */
    if (y == 200 && h)
    {
      h = 0;
    }
    if (y >= VIDEO_HEIGHT)
    {
      y = 0;
      oric.vsync = true;
      b = buf;
      frametouched = 0;
      framenum++;
      if (framenum >= 2 * BLINK_HALF_PERIOD_F)
	framenum = 0;
    }
  }
}

#endif
