/*
 *	screenshot.c - dump the video buffer to file
 *	AYM 2002-07-25
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


#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>

#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>

#include "caloric.h"
#include "screenshot.h"


int screenshot (void)
{
  DIR *dir;
  struct dirent *dirent;
  const char pattern[] = "caloric_%03u.ppm";
  /* Enough slack for 128-bit integers :-) */
  char filename[sizeof pattern + 39];
  FILE *fp;
  unsigned num = 0;

  /* Find the first available number */
  dir = opendir (".");
  if (dir == NULL)
  {
    err (".: %s", strerror (errno));
    return 1;
  }
  while ((dirent = readdir (dir)) != NULL)
  {
    unsigned n;

    if (sscanf (dirent->d_name, pattern, &n) == 1 && n >= num)
    {
      /* Two good reasons to sprintf() back and strcmp():
         1) eliminates caloric_000.ppmsomething
	 2) eliminates caloric_00.ppm */
      sprintf (filename, pattern, n);
      if (strcmp (filename, dirent->d_name) == 0)
	num = n + 1;
    }
  }
  closedir (dir);

  /* Dump screenshotbuf into a file */
  sprintf (filename, pattern, num);
  fp = fopen (filename, "wb");
  if (fp == NULL)
  {
    err ("%s: %s", filename, strerror (errno));
    return 1;
  }
  fputs ("P6\n", fp);
  fprintf (fp, "# Caloric %s\n", VERSION);
  /* gdk-imlib wants a newline between the width and maxval. It
     also doesn't handle maxval = 1 properly. The temptation to
     make a snide remark is great. */
  fprintf (fp, "%d %d\n1\n", VIDEO_WIDTH, VIDEO_HEIGHT);
  {
    size_t y;
    const char *p = buf;

    for (y = 0; y < VIDEO_HEIGHT; y++)
    {
      const char *pmax;

      for (pmax = p + VIDEO_WIDTH; p < pmax; p++)
      {
	fputc (!! (*p & 1), fp);
	fputc (!! (*p & 2), fp);
	fputc (!! (*p & 4), fp);
      }
      p++;				/* KLUDGE - skip over the boolean */
    }
  }

  if (fclose (fp) != 0)
  {
    err ("%s: %s", filename, strerror (errno));
    return 1;
  }
  err ("screenshot written to %s", filename);
  return 0;
}

