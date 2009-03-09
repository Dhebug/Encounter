/*
 *	stats.h - statistics for Xeuphoric
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


typedef struct
{
  time_t time0;
  unsigned long frames;
  unsigned long scanlines;
  unsigned long polls;
} stats_t;


extern stats_t stats;


void stats_init (void);
void stats_dump (FILE *fp);
