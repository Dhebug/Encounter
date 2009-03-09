/*
 *	stats.c - statistics for Xeuphoric
 *	AYM 2002-01-30
 */

/*
This file is copyright André Majorel 2002.

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
#include <time.h>

#include "caloric.h"
#include "stats.h"


stats_t stats;


void stats_init (void)
{
  time (&stats.time0);
  stats.frames = 0;
  stats.scanlines = 0;
}


void stats_dump (FILE *fp)
{
  time_t timenow;
  time_t seconds;

  time (&timenow);
  seconds = timenow - stats.time0;
  fprintf (fp, "seconds %lu", (unsigned long) seconds);

  fprintf (fp, ", frames %lu", stats.frames);
  if (seconds != 0)
    fprintf (fp, " (%.1f/s)", (double) stats.frames / seconds);

  fprintf (fp, ", scanlines %lu", stats.scanlines);
  if (stats.frames != 0)
    fprintf (fp, " (%.1f/f)", (double) stats.scanlines / stats.frames);

  fprintf (fp, ", polls %lu", stats.polls);
  if (seconds != 0)
    fprintf (fp, " (%.1f/s)", (double) stats.polls / seconds);

  fputc ('\n', fp);
}

