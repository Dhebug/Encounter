/*
 *	hosttraps.c - exit traps
 *	AYM 2003-08-16
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


#include "config.h"
#include <stdio.h>
#include <stdlib.h>

#include <signal.h>

#include "caloric.h"
#include "hosttraps.h"


static void hosttraps_sighandler (int signum);

/* All the signals for which the default handler calls _exit() */
static const int fatal_signals[] =
{
#ifdef SIGHUP
  SIGHUP,
#endif
  SIGINT,
#ifdef SIGQUIT
  SIGQUIT,
#endif
  SIGILL,
  SIGABRT,
  SIGFPE,
  SIGSEGV,
#ifdef SIGPIPE
  SIGPIPE,
#endif
#ifdef SIGALRM
  SIGALRM,
#endif
  SIGTERM,
#ifdef SIGUSR1
  SIGUSR1,
#endif
#ifdef SIGUSR2
  SIGUSR2,
#endif
#ifdef SIGBUS
  SIGBUS,
#endif
#ifdef SIGPOLL
  SIGPOLL,
#endif
#ifdef SIGPROF
  SIGPROF,
#endif
#ifdef SIGSYS
  SIGSYS,
#endif
#ifdef SIGTRAP
  SIGTRAP,
#endif
#ifdef SIGVTALRM
  SIGVTALRM,
#endif
#ifdef SIGXCPU
  SIGXCPU,
#endif
#ifdef SIGXCPU
  SIGXCPU,
#endif
#ifdef SIGIOT
  SIGIOT,
#endif
#ifdef SIGEMT
  SIGEMT,
#endif
#ifdef SIGSTKFLT
  SIGSTKFLT,
#endif
#ifdef SIGIO
  SIGIO,
#endif
#ifdef SIGPWR
  SIGPWR,
#endif
#ifdef SIGUNUSED
  SIGUNUSED
#endif
};

/* This could be a list but we just need one for the moment */
static hosttraps_callback_t hosttraps_callback = NULL;


/*
 *	hosttraps_register - register an exit callback
 *
 *	The argument is added to the "list" of exit callbacks. When the
 *	process dies (as a result of exit() or a fatal signal), the exit
 *	callbacks are called in reverse order of their registration. If
 *	the process dies as a result of calling _exit(), the callbacks
 *	are not called.
 *
 *	An attempt to register more callbacks than the maximum causes
 *	the program to exit() with a non-zero status. The maximum number
 *	of callbacks is 1. Have a nice day.
 *
 *	There is no way to deregister a callback.
 */
void hosttraps_register (hosttraps_callback_t func)
{
  /* There's only room for registering one function */
  if (hosttraps_callback != NULL)
  {
    err ("hosttraps_register: too many functions");
    exit (1);
  }

  hosttraps_callback = func;

  /* Trap exit() */
  atexit (func);

  /* Trap fatal signals */
  {
#ifdef HAVE_SIGACTION
    struct sigaction sigact;
    size_t s;

    sigact.sa_handler = hosttraps_sighandler;
    sigemptyset (&sigact.sa_mask);
    for (s = 0; s < sizeof fatal_signals / sizeof *fatal_signals; s++)
      sigaddset (&sigact.sa_mask, fatal_signals[s]);
    sigact.sa_flags = 0;

    for (s = 0; s < sizeof fatal_signals / sizeof *fatal_signals; s++)
      sigaction (fatal_signals[s], &sigact, NULL);
#endif
  }
}


/*
 *	hosttraps_sighandler - handler for fatal signals
 *
 *	Just a wrapper around the registered exit callback (the
 *	prototypes don't match).
 */
static void hosttraps_sighandler (int signum)
{
  err ("caught signal %d", signum);
  hosttraps_callback ();
  exit (1);
}

