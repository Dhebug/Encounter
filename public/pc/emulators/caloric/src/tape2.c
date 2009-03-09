/*
 *	tape2.c - Xeuphoric tape I/O emulation (part of it anyway)
 *	AYM 2003-06-27
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


#include <ctype.h>
#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#include "caloric.h"


extern FILE *Write_Handle;		/* defined in traps.S */


static int tap_mkpathname (char *buf, size_t bufsz,
    const char *cname, int lowcase, int addextension);


/*
 *	tap_open_read -
 */
FILE *tap_open_read (const char *cname)
{
  FILE *fp = NULL;
  static char truename[1024];
  static time_t lasttry = 0;
  time_t now;
  int n;
  int r;

  time (&now);
  if (now == lasttry)
    return NULL;
  lasttry = now;

  err ("CLOAD: given \"%s\"", cname);	/* DEBUG */

  n = 0;
  while ((r = tap_pathname (&n, truename, sizeof truename, cname)) != 1)
  {
    if (r > 1)
    {
      err ("  #%d name too long", n);
      continue; /* FIXME */
    }

    fp = fopen (truename, "rb");
    if (fp == NULL)
    {
      err ("  #%d %s: %s", n, truename, strerror (errno));
      if (errno == ENOENT)
	continue;
      else
	break;
    }
    else
    {
      err ("  #%d %s: bingo!", n, truename);
      break;
    }
  }

  return fp;
}


/*
 *	tap_open_write -
 */
void tap_open_write (const char *cname)
{
  static char pathname[1024];
  int n;
  static int firsttime = 1;
  int append;

  /* Close the current file */
  if (Write_Handle != NULL)
    if (fclose (Write_Handle) != 0)
      err ("%s: %s", pathname, strerror (errno));

  n = 0;
  if (tap_pathname (&n, pathname, sizeof pathname, cname) != 0)
  {
    err ("CSAVE\"%s\": name too long");  /* Can't happen */
    if (atmos)
      Oric_Mem[0x02b1]++;
    return;
  }

  /* The second and subsequent CSAVE"" *append* to ________.tap */
  append = 0;
  if (*cname == '\0')
  {
    if (! firsttime)
      append = 1;
    firsttime = 0;
  }

  err ("CSAVE\"%s\": %s%s", cname, append ? ">>" : ">", pathname);
  Write_Handle = fopen (pathname, append ? "ab" : "wb");
  if (Write_Handle == NULL)
  {
    err ("%s: %s", pathname, strerror (errno));
    if (atmos)
      Oric_Mem[0x02b1]++;
  }
  else
  {
    putc ('\x16', Write_Handle);
    putc ('\x16', Write_Handle);
    putc ('\x16', Write_Handle);
    if (fflush (Write_Handle) != 0)
    {
      err ("%s: %s", pathname, strerror (errno));
      if (atmos)
	Oric_Mem[0x02b1]++;
    }
  }
}


/*
 *	tap_pathname - get the next possible pathname for a tape name
 *
 *	cname is the argument of the CLOAD or CSAVE Oric command
 *	(NUL-terminated string).
 *
 *	state is a pointer to an int where the sequence number
 *	is saved between calls. Initialise it to zero before
 *	calling the function. Don't change it between calls.
 *
 *	Don't change the contents of cname between calls unless
 *	you also reset *state.
 *
 *	Return value :
 *	0   success, new pathname in buf
 *	1   end of list (no more pathnames)
 *	>1  an error occurred (buffer too small)
 */
int tap_pathname (int *state, char *buf, size_t bufsz, const char *cname)
{
  const char *result;
  const char error[] = "";

  if (*cname == '\0')
  {
    if (*state == 0)
      result = "________.tap";
    else if (*state == 1)
      result = "________.TAP";
    else if (*state == 2)
      result = "________";
    else
      result = NULL;
  }
  else
  {
    if (*state == 0)
      if (tap_mkpathname (buf, bufsz, cname, 1, 1) != 0)
        result = error;
      else
	result = buf;
    else if (*state == 1)
      if (tap_mkpathname (buf, bufsz, cname, 0, 1) != 0)
        result = error;
      else
	result = buf;
    else if (*state == 2)
      if (tap_mkpathname (buf, bufsz, cname, 1, 0) != 0)
        result = error;
      else
	result = buf;
    else if (*state == 3)
      if (tap_mkpathname (buf, bufsz, cname, 0, 0) != 0)
        result = error;
      else
	result = buf;
    else
      result = NULL;
  }

  if (result == NULL)
    return 1;

  (*state)++;
  if (result == error)
    return 2;
  if (result != buf)
  {
    if (strlen (result) + 1 > bufsz)
      return 2;
    strcpy (buf, result);
  }
  return 0;
}


/*
 *	tap_mkpathname - convert an Oric-side name to a host pathname
 *
 *	Return 0 on success, 1 on failure (buffer too small)
 */
static int tap_mkpathname (char *buf, size_t bufsz,
    const char *cname, int lowcase, int addextension)
{
  size_t n;

  if (bufsz < 1)
    return 1;

  for (n = 0; cname[n] != '\0'; n++)
  {
    if (n >= bufsz - 1)
      return 1;
    if (lowcase)
      buf[n] = tolower (cname[n]);
    else
      buf[n] = cname[n];
  }
  buf[n] = '\0';

  if (addextension)
  {
    if (n + 5 >= bufsz - 1)
      return 1;
    strcpy (buf + n, lowcase ? ".tap" : ".TAP");
  }

  return 0;
}

