/*
 *	misc.c - miscellaneous functions
 *	AYM 2002-01-23
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


#include <stdarg.h>
#include <stdio.h>

#include "caloric.h"


void heartbeat (void)
{
  static int n;

  putc ("/-\\|"[n++ & 3], stderr);
}

void printd (int n)
{
  fprintf (stderr, " #%d ", n);
}


void err (const char *fmt, ...)
{
  va_list list;

  if (stdout != NULL)
    fflush(stdout);
  if (stderr != NULL)
  {
    va_start(list, fmt);
    vfprintf(stderr, fmt, list);
    va_end(list);
    fputc('\n', stderr);
    fflush(stderr);  /* Paranoia */
  }
}
