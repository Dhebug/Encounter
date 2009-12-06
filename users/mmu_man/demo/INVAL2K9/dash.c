/* -*- c-basic-offset: 8 -*-
 * (c) 2008, Francois Revol <revol@free.fr>
 *
 */

#include "global.h"

#define PR_X 20
#define PR_Y 0

const char *llabel="Loading ";

void dash_load_progress(char progress)
{
	char *p;
	char i;
	p = (char *)(TEXTVRAM+40*25+40*PR_Y+PR_X);
	i = strlen(llabel);
	if (progress < 0) {
		memset(p, ' ', i + 12);
		return;
	}
	memcpy(p, llabel, i);
	p += i;
	*p++ = '[';
	for (i = 0; i < progress && i < 10; i++)
		*p++ = '\x7f';
	for (; i < 10; i++)
		*p++ = ' ';
	*p++ = ']';

}

void dash_cpu(int cpu)
{
	
}

/* music debug */
#ifdef DEBUG_MUSIC

#define M_X 24
#define M_Y 0
static int music_early_count = 0;
void dash_music_early(void)
{
	char *p;
	char i;
	//char buf[5];

	p = (char *)(TEXTVRAM+40*25+40*M_Y+M_X);
	music_early_count++;
	//p+=3;
	//sprintf(buf, "%ud", music_early_count);
	//memcpy(p, buf, strlen(buf));
}

void dash_music_slice(char pat, char line)
{
	char *p;
	char i;
	char buf[10];
	p = (char *)(TEXTVRAM+40*25+40*M_Y+M_X);
	music_early_count = 0;
	//gotoxy(M_X + 3, M_Y);
	p+=3;
	sprintf(buf, "%d;%d", pat, line);
	memcpy(p, buf, strlen(buf));
}
#endif
