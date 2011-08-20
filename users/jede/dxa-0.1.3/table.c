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

/* table.c */
#define _TABLE_C_

#include <stdlib.h>
#include "proto.h"

static unsigned int firstunused = 0;

#ifndef __STDC__
table *
FindNextEntryType (entry, andmask, eormask)
     table *entry;
     unsigned char andmask;
     unsigned char eormask;
#else
table *FindNextEntryType (table *entry, unsigned char andmask,
                          unsigned char eormask)
#endif
{
  if (!scantable) return NULL;

  if (!entry || entry >= &scantable[entrycount])
    entry = scantable;
  else if (++entry >= &scantable[entrycount])
    return NULL;

  for (; entry < &scantable[entrycount]; entry++)
    if (entry->type && !((entry->type & andmask) ^ eormask))
      return entry;

  return NULL;
}

#ifndef __STDC__
table *
FindNextEntryTypeParent (entry, parent, andmask, eormask)
     table *entry;
     ADDR_T parent;
     unsigned char andmask;
     unsigned char eormask;
#else
table *FindNextEntryTypeParent (table *entry, ADDR_T parent,
                            unsigned char andmask, unsigned char eormask)
#endif
{
  if (!scantable) return NULL;


  if (!entry || entry >= &scantable[entrycount])
    entry = scantable;
  else if (++entry >= &scantable[entrycount])
    return NULL;

  for (; entry < &scantable[entrycount]; entry++)
    if (entry->parent == parent && entry->type &&
        !((entry->type & andmask) ^ eormask))
      return entry;

  return NULL;
}

#ifndef __STDC__
table *
FindNextEntry (entry, address, andmask, eormask)
     table *entry;
     ADDR_T address;
     unsigned char andmask;
     unsigned char eormask;
#else
table *FindNextEntry (table *entry, ADDR_T address,
                      unsigned char andmask, unsigned char eormask)
#endif
{
  if (!scantable) return NULL;

  if (!entry || entry >= &scantable[entrycount])
    entry = scantable;
  else if (++entry >= &scantable[entrycount])
    return NULL;

  for (; entry < &scantable[entrycount]; entry++)
    if (entry->address == address && entry->type &&
        !((entry->type & andmask) ^ eormask))
      return entry;

  return NULL;
}

#ifndef __STDC__
void
AddEntry (address, parent, type)
     ADDR_T address;
     ADDR_T parent;
     unsigned char type;
#else
void AddEntry (ADDR_T address, ADDR_T parent, unsigned char type)
#endif
{
  if (firstunused < entrycount) {
    scantable[firstunused].address = address;
    scantable[firstunused].parent = parent;
    scantable[firstunused].type = type;

    while (++firstunused < entrycount && scantable[firstunused].type);
  }
  else {
    scantable = scantable ?
      realloc (scantable, (entrycount + 1) * sizeof *scantable) :
      malloc (sizeof *scantable);

    scantable[entrycount].address = address;
    scantable[entrycount].parent = parent;
    scantable[entrycount].type = type;

    firstunused = ++entrycount;
  }
}

#ifndef __STDC__
void
DeleteEntry (entry)
     table *entry;
#else
void DeleteEntry (table *entry)
#endif
{
  entry -> type = TBL_DELETED;

  if (firstunused > entry - scantable)
    firstunused = entry - scantable;
}
