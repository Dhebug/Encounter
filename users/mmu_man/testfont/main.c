/* -*- c-basic-offset: 8 -*-
 * Test for ORIC Fonts
 * (c) 2009, Francois Revol <revol@free.fr>
 *
 */

#include <lib.h>
//#include <stdio.h>
#define NULL (0)

#include "ttf2oric/Fonts.h"
//#include "ttf2oric/Embassy_9.h"
struct {
	const char *name;
	char *font;
} gFonts[] = {
	#include "ttf2oric/FontList.h"
	//{ "Embassy_9_bits", Embassy_9_bits },
	{ NULL, NULL }
};

//#define ASSERT(cond) if (!(cond)) { printf("ASSERT:%s\n", #cond); getchar(); exit(0); }




static const char message[] = 
	"The quick brown fox jumps over the lazy dog\n"
	"Portez ce vieux whisky au juge blond qui fume\n"
	"Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n"
	"Fusce sit amet diam et wisi malesuada varius. \n"
	"Morbi erat velit, egestas ut, blandit sed, venenatis adipiscing, ipsum.\n"
	"Maecenas risus. Donec ac magna. Cras sed justo. Etiam et sem.\n"
	"Praesent euismod sem sit amet enim auctor pulvinar. Quisque nunc.\n"
	" !\"#$%&'()*+,-./0123456789:;<=>?@\n"
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ \n"
	"abcdefghijklmnopqrstuvwxyz{|}  ";

static void set_font(char *fnt)
{
	memcpy(((char *)STDCHRTABLE + 32*8), fnt, 8*112);
}

static void set_font_alt(char *fnt)
{
	memcpy(((char *)ALTCHRTABLE + 32*8), fnt, 8*112);
}

int main()
{
	int i;
	text();
	cls();
	//setflags(getflags() & ~CURSOR);
	puts(message);
	for (i = 0; i < 10; i++) {
		gotoxy(0,i);
		//putchar(A_ALTFL);
		//printf("%c", A_ALTFL);
	}
	gotoxy(20,22);
	//putchar(A_BGBLACK); putchar(A_FWWHITE);
	//putchar(A_FWRED);
	gotoxy(20,23); puts("-    Previous");
	gotoxy(20,24); puts("any  Next");
	gotoxy(20,25); puts("Q    Quit");
	//putchar(A_FWWHITE);
	//putchar(A_FWRED);
	//putchar(A_FWWHITE);
	//putchar(A_BGBLACK); putchar(A_FWWHITE);
	//putchar(A_FWWHITE);

	//XXX FIXME
	for (i = 0; gFonts[i].name; i++) {
		int c;
		set_font(gFonts[i].font);
		gotoxy(2,21);
		puts(gFonts[i].name);
		c = getchar();
		if (c == '-' && i > 0) {
			i-=2;
			continue;
		}
		if (c == 'q' || c == 'Q')
			break;
	}
	return 0;
}
