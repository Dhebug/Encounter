/* sys/graphics.h */

/* Routines needed for Oric text, lores or hires graphics */

#ifndef _SYS_GRAPHICS_

#define _SYS_GRAPHICS_


/* Serial Attributes, curses style :-| */

#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7
#define A_BGBLACK       16
#define A_BGRED         17
#define A_BGGREEN       18
#define A_BGYELLOW      19
#define A_BGBLUE        20
#define A_BGMAGENTA     21
#define A_BGCYAN        22
#define A_BGWHITE       23
#define A_STD            8
#define A_ALT            9
#define A_STD2H         10
#define A_ALT2H         11
#define A_STDFL         12
#define A_ALTFL         13
#define A_STD2HFL       14
#define A_ALT2HFL       15
#define A_TEXT60        24
#define A_TEXT50        26
#define A_HIRES60       28
#define A_HIRES50       30


/* Switch the screen to HIRES mode. */

extern void hires(void);


/* Switch the screen to TEXT mode. */

extern void text(void);


/* Select the INK (foreground) colour. */

extern int ink(int color);


/* Select the PAPER (background) colour. */

extern int paper(int color);


/* Set the position of the graphics cursor. */

   /* The mode argument can be one of the following: */

#define MODE_RESET 0
#define MODE_SET   1
#define MODE_XOR   2
#define MODE_NONE  3


extern int curset(int x,int y,int mode);


/* Move the graphics cursor to a new location. */

   /* The new location is given RELATIVE to the current position. */
   /* That is, you can use negative numbers. */

extern int curmov(int dx,int dy,int mode);


/* Move the cursor to a new location as in curmov(), and draw a line */
/* between the current and new locations. */

extern int draw(int dx,int dy,int mode);


/* Draw a circle of given radius at the current cursor location. */

extern int circle(int radius,int mode);


/* Draw the character c of the given character set at the current */
/* cursor position. */

extern int hchar(char c,int charset,int mode);


/* Fill an area with an attribute or bit pattern. */

   /* Width is in bytes, NOT pixels. */

extern int fill(int height,int width,char c);


/* Returns the bit value (ON/OFF) of the given pixel. */

extern int point(int x,int y);


/* Sets the 6-bit pattern used for drawing lines and circles. */

extern int pattern(char style);


#endif /* _SYS_GRAPHICS_ */

/* end of file sys/graphics.h */

