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

#define _LABEL_C_

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "proto.h"
#include "options.h"
#include "opcodes.h"

label *labeltable;
char defaultlabel[5];
unsigned numLabels = 0;

#ifndef __STDC__
void
AddLabel (address, name)
     ADDR_T address;
     char *name;
#else
void AddLabel (ADDR_T address, char *name)
#endif
{
  label *entry;
  char *buffer;

  if (!((buffer = malloc (strlen (name)))))
    return;

  entry = numLabels ?
    realloc (labeltable, (numLabels + 1) * sizeof *entry) :
    malloc (sizeof *entry);

  if (!entry) return;

  labeltable = entry;
  entry = &labeltable[numLabels++];

  entry->address = address;
  entry->name = buffer;
  while ((*buffer++ = *name++));
}

#ifndef __STDC__
char *
Label (address, admode)
     ADDR_T address;
     int admode;
#else
char *Label (ADDR_T address, int admode)
#endif
{
  label *entry;

  if (!IsLabeled (address)) {

	/* dirty kludge to allow zero page stuff to still work. this sometimes
		guesses wrong */
	if (admode == zp)
    		sprintf (defaultlabel, "$%02x", address);
	else
    		sprintf (defaultlabel, "$%04x", address);
    return defaultlabel;
  }

  for (entry = &labeltable[numLabels]; entry-- > labeltable;)
    if (entry->address == address)
      return entry->name;

  sprintf (defaultlabel, "l%x", address);

  return defaultlabel;
}

#ifndef __STDC__
void
Collect ()
#else
void Collect (void)
#endif
{
  unsigned counter = 0;
  table *entry = NULL, *entry2;
  label *labels;

  if (fVerbose)
    fprintf (stderr, "%s: collecting garbage.\n", prog);

  while ((entry = entry2 = FindNextEntryType (entry, 0, 0))) {
    counter++;

    PutLabel (entry->address);
    PutLowByte (entry->address);
    PutHighByte (entry->address);

    while ((entry2 = FindNextEntry (entry2, entry->address,
                                    ~0, entry->type)))
      DeleteEntry (entry2); /* remove duplicate warnings */
  }

  if ((entry = malloc (counter * sizeof *entry))) { /* compact the table */
    entrycount = counter;

    for (entry2 = scantable; counter; entry2++) {
      if (!entry2->type) continue;

      memcpy (&entry[--counter], entry2, sizeof *entry);
    }

    free (scantable);
    scantable = entry;
  }

  for (labels = &labeltable[numLabels]; labels-- > labeltable;)
    if ((ADDR_T)(labels->address - StartAddress) <
        (ADDR_T)(EndAddress - StartAddress)) {
      PutLabel (labels->address);
      PutLowByte (labels->address);
      PutHighByte (labels->address);
    }
}
