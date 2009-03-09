/*
 *	caloric - common definitions for Caloric
 *	AYM sometime in 2000
 */

/*
Parts of this file copyright 1994-1997 Fabrice Francès.
Parts of this file copyright 2000-2004 André Majorel.

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

#define VIDEO_WIDTH    240
#define VIDEO_HEIGHT   224
#define TEXT_COLUMNS   40
#define CHAR_HEIGHT    8
#define COLOURS        8
#define CHARSET0_TEXT  0xB400
#define CHARSET0_HIRES 0x9800
#define CHARSET1_TEXT  0xB800
#define CHARSET1_HIRES 0x9C00
#define RAM_TEXT       0xBB80
#define RAM_HIRES      0xA000

/* banks.S */
extern unsigned char Oric_Mem[];

/* datapath.c */
extern const char *datapath[];

/* host.c */
int Open_Tape(const char *name);
void protect_tape(void);
void unprotect_tape(void);
void Close_Tape (void);
void Create_Tape(void);
int Open_Disk(char *name,int drive);
void Close_Disk(int drive);
int Create_Disk(int drive);
int tap_name (char *buf, size_t bufsz, const char *pathname,
    int lowcase, int addextension);
extern char atmos;

/* keyb_us.c */
void keyboard_map_init (void);

/* locate.c */
char *locate_file (const char *basename, const char **dirlist);
char *expand_path (const char *raw);

/* misc.c */
void err (const char *fmt, ...);

/* rcfiles.c */
extern const char *rcfiles[];

/* tape2.c */
int tap_pathname (int *state, char *buf, size_t bufsz, const char *cname);

/* ula.c */
extern char buf[(VIDEO_WIDTH + 1) * VIDEO_HEIGHT];
extern int frametouched;
void render_frame (void);

/* version.c */
extern const char version[];

/* sdl.c */
extern int zoom;
int sdl_start(void);
void sdl_end(void);
void display_frame(void);
void Reset_Screen(void);

extern int xputimage_in_progress;
extern int hires;

/*
#define LOCK_SDL()     while(windowChanging) { fprintf(stderr, "Wait %s:%d\n", __FILE__, __LINE__);usleep(10); } windowChanging = 1;fprintf(stderr, "Locked %s:%d\n",  __FILE__, __LINE__);
#define UNLOCK_SDL()   windowChanging = 0;fprintf(stderr, "Unlocked %s:%d\n",  __FILE__, __LINE__);
*/
