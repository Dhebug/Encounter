/*
 *	oric.c - main
 *	FF sometime in 1994-1997
 */

/*
Parts of this file copyright 1994-1997 Fabrice Francès.
Parts of this file copyright 2000-2003 André Majorel.

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

//  -lgmodule-2.0
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
//#if HAVE_DEBUGGER
//#include <pthread.h>
//#endif

#include "caloric.h"
#include "dsp.h"
#include "screenshot.h"
#include "stats.h"

/* FIXME use headers */
extern int init(char argc, char *argv[]);
extern void setup(char *env[]);
extern int  sdl_start(void);
extern void sdl_end(void);
extern void adlib_init(void);
extern void hook_interrupts(void);
extern void redirect_output(void);
extern void delete_output(void);
extern void init_time(void);
extern void Restart(void);
extern void Reset(void);
extern void restore_time(void);
extern void restore_interrupts(void);
extern void adlib_end(void);
extern void *watch(void *arg);
extern char restart_flag;
extern int debugger;

/*http://sourceware.org/pthreads-win32/*/

int main(int argc, char *argv[], char *env[])
{
#if HAVE_DEBUGGER
    pthread_t watcher;
    int id;
#endif
	stats_init();
	if (argc>=2 && strcmp(argv[1],"--help")==0) {
		puts(
"caloric - an Oric emulator\n"
"http://punk.lnxscene.org/~jylam/caloric\n"
"Usage:\n"
" caloric  --help\n"
" caloric  --version\n"
" caloric  [-1|a|t] [-djJpQr] [-A file] [-s num] [-S arts|auto|oss]\n"
"    [-X always|auto|never] [-z num] file ...\n"
"Options:\n"
"  --help     print usage on standard output and exit successfully\n"
"  --version  print version number on standard output and exit successfully\n"
"  -1         emulate an Oric-1\n"
"  -a         emulate an Oric Atmos (this is the default)\n"
"  -A file    pathname of OSS audio device (default /dev/dsp)\n"
"  -d         emulate a Microdisk floppy disk drive\n"
"  -j         emulate a Jasmin floppy disk drive\n"
"  -J         emulate a Telestrat joystick\n"
"  -p         emulate a P.A.S.E. joystick interface\n"
"  -Q         quit on illegal instructions\n"
"  -r         restart from a dump\n"
"  -s num     emulate at num percent of the normal speed (default 100)\n"
"  -S alsa|arts|auto|oss  sound output method (default is auto)\n"
"  -t         emulate a Telestrat\n"
"  -X always|auto|never  XShm usage policy (default is auto)\n"
"  -z num     set zoom factor to num (1, 2 or 3, default 1)\n"
"  -g         start debugger");
		exit(0);
	}
	if (argc>=2 && strcmp(argv[1],"--version")==0) {
		sprintf(stderr, VERSION);
		if (fflush(stdout))
			exit(1);
		exit(0);
	}

	setup(env);
	keyboard_map_init();
    initSDL_display();
	restart_flag=init(argc,argv);

    if(!sdl_start()) {
        fprintf(stderr, "Can't open graphics (8bpp). Too bad AH!\n");
        return -1;
    }

	sound_open();
	hook_interrupts();
	init_time();
	redirect_output();


    /* Watcher thread */
    if(debugger == 1) {
#if HAVE_DEBUGGER
       printf("Debugger on\n");
        pthread_create(&watcher,NULL,watch,&id);
#else
        fprintf(stderr, "Please compile caloric with debugger support.\n");
#endif
    }

	if (restart_flag) {
        Restart();
    } else {
        Reset();
    }
	return 0;			/* NOT REACHED */
}

void Quit(void)
{
	restore_time();
	restore_interrupts();

	sdl_end();

	if (sound)
	  sound_close();
	stats_dump(stderr);		/* stdout does not work */
	exit(0);
}

