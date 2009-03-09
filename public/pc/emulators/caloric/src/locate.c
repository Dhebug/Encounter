/*
 *	locate.c - look for a file in a list of directories
 *	AYM 2002-01-28
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
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <unistd.h>

#include "caloric.h"

#ifdef WIN32
#define DELIM '\\'
#define DELIMS "\\"
#else
#define DELIM '/'
#define DELIMS "/"
#endif

static int pathname_exists (const char *pathname);
static int path_is_absolute (const char *path);
static char *mystrdup (const char *string);


/*
 *	locate_file - find a file by basename
 *
 *	dirlist is a NULL-terminated list of paths. A "~" in a
 *	path represents the contents of the HOME variable (or
 *	the empty string if HOME is not set).
 *
 *	Example code :
 *
 *	const char *list = { ".", "~/.glurg", "/usr/share/glurg", NULL };
 *	char *pathname = locate_file ("glurgrc", list);
 *	if (pathname == NULL)
 *	  puts ("not found");
 *	else
 *	  puts (pathname);
 *
 *	Return NULL on failure, otherwise a pointer on a
 *	malloc()'d buffer containing the pathname of the
 *	requested file.
 */

char *locate_file (const char *basename, const char **dirlist)
{
  const char **p;
printf("locate_file(%s,)\n", basename);

  if (path_is_absolute (basename))
  {
    if (! pathname_exists (basename))
      return NULL;
    return mystrdup (basename);
  }

  for (p = dirlist; *p != NULL; p++)
  {
    char *path;
    char *pathname;
    struct stat st;

    /* Build the pathname of the possible file */
    path = expand_path (*p);
    pathname = malloc (strlen (path) + 1 + strlen (basename) + 1);
    if (pathname == NULL)
    {
      err ("not enough memory");
      exit (1);
    }
    strcpy (pathname, path);
    if (strlen (path) > 0 && path[strlen (path) - 1] != DELIM)
      strcat (pathname, DELIMS);
    free (path);
    strcat (pathname, basename);
    if (0)
      err ("locating %s: examining %s", basename, pathname);

    /* If it exists, return that */
    if (stat (pathname, &st) == 0 || errno != ENOENT)
      return pathname;

    free (pathname);
  }
  return NULL;				/* Not found */
}


#ifdef TEST
int main (int argc, char *argv[])
{
  int n;

  for (n = 1; n < argc; n++)
  {
    char *pathname = locate_file (argv[n]);
    printf ("%s: %s\n", argv[n], pathname == NULL ? "(not found)" : pathname);
  }
  return 0;
}
#endif


/*
 *	expand_path - expand macros in a path
 *
 *	Expands ~ into $HOME.
 *
 *	Return a pointer on a malloc()'d buffer containing the
 *	expanded pathname.
 */
char *expand_path (const char *raw)
{
  const char *home;
  const char *p;
  size_t result_len = 0;
  char *result_buf;
printf("expand_path(%s)\n", raw);

  home = getenv ("HOME");
  if (home == NULL)
  {
    static int warned_once = 0;
    if (! warned_once)
    {
      err ("warning: HOME is not set");
      warned_once = 1;
    }
    home = "";
  }

  for (p = raw; *p != '\0'; p++)	/* Expands into how many characters ? */
  {
    if (*p == '~')
      result_len += strlen (home);
    else
      result_len++;
  }

  result_buf = malloc (result_len + 1);	/* Expand */
  if (result_buf == NULL)
  {
    err ("not enough memory");
    exit (1);
  }
  {
    char *result_p = result_buf;
    for (p = raw; *p != '\0'; p++)
    {
      if (*p == '~')
      {
	strcpy (result_p, home);
	result_p += strlen (home);
      }
      else
      {
	*result_p++ = *p;
      }
    }
    *result_p = '\0';
  }
  return result_buf;
}


/*
 *	pathname_exists - determine whether a pathname exists
 */
static int pathname_exists (const char *pathname)
{
  struct stat s;

  return stat (pathname, &s) == 0 || errno != ENOENT;
}


/*
 *	path_is_absolute - determine whether a path is absolute
 *
 *	Paths relative to current directory (i.e. beginning with
 *	"." or "..") are considered absolute.
 */
static int path_is_absolute (const char *path)
{
  return path[0] == DELIM
    || (path[0] == '.'
				      && (path[1] == DELIM || path[1] == '\0'))
    || (path[0] == '.' && path[1] == '.'
				      && (path[2] == DELIM || path[2] == '\0'));
}


/*
 *	mystrdup - home-grown strdup()
 */
static char *mystrdup (const char *string)
{
  char *copy;

  copy = malloc (strlen (string) + 1);
  if (copy == NULL)
  {
    err ("not enough memory");
    exit (1);
  }
  strcpy (copy, string);
  return copy;
}


