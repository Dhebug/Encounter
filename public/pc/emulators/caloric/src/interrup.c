/*
 *	interrup.c - interrupt handling
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
#include <stdio.h>
#include <signal.h>
#include <string.h>
#ifdef HAVE_SYS_IOCTL_H
#include <sys/ioctl.h>
#endif
#include <fcntl.h>
#include <sys/time.h>
#ifdef B_ZETA_VERSION
#include <itimer.h>
#endif

#include <SDL/SDL.h>
#include <SDL/SDL_timer.h>

#include "caloric.h"
#include "stats.h"
#include "timer.h"

extern void keyboard_handler(SDL_Event *ev);
extern void quit_handler(SDL_Event *ev);
void poll_keyboard(void);

extern char delayed_key_flag;
extern int serial;
extern int Com_port;
extern int disk;
extern char serial_name[];

#ifdef HAVE_SIGACTION
static struct sigaction oldsiga_segv, oldsiga_kill;
#endif
#ifdef HAVE_SETITIMER
static struct itimerval itimer1, itimer2;
#endif
static SDL_TimerID timer1;

extern unsigned char Tick;

extern char windowChanging;

void alarm_handler()
{
	synchronize();
	stats.polls++;
//    poll_keyboard();
#ifdef SIGALRM
	signal(SIGALRM,alarm_handler);
#endif
}


Uint32 sdl_timer_callback(Uint32 interval, void *param)
{
printf("sdl callback\n");
	alarm_handler();
	return interval;
}


void close_keyboard()
{
#ifdef HAVE_SIGACTION
	sigaction(SIGSEGV, &oldsiga_segv, NULL);
#ifdef SIGKILL
	sigaction(SIGKILL, &oldsiga_kill, NULL);
#endif
#endif
}


static void handle_segv() {
	close_keyboard();
#ifdef HAVE_SIGACTION
	sigaction(SIGSEGV, &oldsiga_segv, NULL);
#endif
	raise(SIGSEGV);
}

static void handle_kill() {
	close_keyboard();
#ifdef HAVE_SIGACTION
#ifdef SIGKILL
	sigaction(SIGKILL, &oldsiga_kill, NULL);
	raise(SIGKILL);
#endif
#endif
}
void open_keyboard(void)
{
#ifdef HAVE_SIGACTION
	struct sigaction siga;
	siga.sa_handler = handle_segv;
	siga.sa_flags = 0;
	memset(&siga.sa_mask, 0, sizeof siga.sa_mask);
	sigaction(SIGSEGV, &siga, &oldsiga_segv);
	siga.sa_handler = handle_kill;
#ifdef SIGKILL
	sigaction(SIGKILL, &siga, &oldsiga_kill);
#endif
#endif
}

void poll_keyboard(void)
{
    if(!windowChanging) {
        SDL_Event event;
        windowChanging = 1;

        while (SDL_PollEvent(&event)) {
            switch (event.type) {
            case SDL_KEYDOWN:
            case SDL_KEYUP:
                keyboard_handler(&event);
                break;
            case SDL_QUIT:
	        quit_handler(&event);
                break;
            default:
                break;
            }
        }
        windowChanging = 0;
    }
}

void hook_interrupts(void)
{
#ifdef SIGALRM
	signal(SIGALRM,alarm_handler);
#endif
#warning MINGW: timer
#ifdef HAVE_SETITIMER
	itimer1.it_interval.tv_usec=itimer1.it_value.tv_usec=20000L;
	setitimer(ITIMER_REAL,&itimer1,&itimer2);
#endif
	timer1 = SDL_AddTimer(20, sdl_timer_callback, NULL);
}

void restore_interrupts(void)
{
#ifdef HAVE_SETITIMER
	itimer1.it_interval.tv_usec=itimer1.it_value.tv_usec=0L;
	setitimer(ITIMER_REAL,&itimer1,&itimer2);
#endif
	SDL_RemoveTimer(timer1);
	close_keyboard();

}
