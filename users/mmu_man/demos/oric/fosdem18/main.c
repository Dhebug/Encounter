/* FOSDEM schedule app for ORIC
 */
#include <lib.h>

const char *schedule[] = {
#include "data/schedule.h"
};

extern unsigned char logof[];

void main()
{
	char i;

	hires();
	memcpy((char*)0xa000, logof, 200*240/6);

	puts("RetroComputing Devroom - Feb. 4 2018");
	puts("press a key...");

	getchar();

	text();
	
	for (i = 0; schedule[i]; i++)
		printf("%s\n\n", schedule[i]);

	getchar();
}

