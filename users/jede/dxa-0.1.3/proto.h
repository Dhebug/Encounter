/*\
 *  dxa v0.1.1 -- symbolic 65xx disassembler
 *
 *  Copyright (C) 1993, 1994 Marko M\"akel\"a
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Contacting the author:
 *
 *   Via Internet E-mail:
 *      <Marko.Makela@FTP.FUNET.FI>
 *
 *   Via Snail Mail:
 *      Marko M\"akel\"a
 *      Sillitie 10 A
 *      FIN-01480 VANTAA
 *      Finland
\*/

#include "structures.h"

#ifdef __STDC__
#define PROTO(x) x
#else
#define PROTO(x) ()
#endif

/* scan.c */

int ScanSpecified PROTO((void));   /* scan all "sure" routines */
void ScanPotentials PROTO((void)); /* scan the "potential" routines */
void ScanTheRest PROTO((void));    /* scan unprocessed memory places
                                      for routines */

/* table.c */

table *FindNextEntryType PROTO((table *entry, unsigned char andmask,
                                unsigned char eormask));
table *FindNextEntryTypeParent PROTO((table *entry, ADDR_T parent,
                                      unsigned char andmask,
                                      unsigned char eormask));
table *FindNextEntry PROTO((table *entry, ADDR_T address,
                            unsigned char andmask, unsigned char eormask));
void AddEntry PROTO((ADDR_T address, ADDR_T parent, unsigned char type));
void DeleteEntry PROTO((table *entry));

/* label.c */

void AddLabel PROTO((ADDR_T address, char *name));
char *Label PROTO((ADDR_T address, int admode));
void Collect PROTO((void)); /* garbage collection */

/* vector.c */

void SearchVectors PROTO((void));
ADDR_T WordTableEnd PROTO((ADDR_T Start));

/* dump.c */

void Dump PROTO((void)); /* dump the program */
