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

#define _VECTOR_C_

#include <stdio.h>
#include <stdlib.h>

#include "proto.h"
#include "options.h"

unsigned WordCount = 0;
words *WordTable = NULL;

void AddWordEntry PROTO((ADDR_T start, ADDR_T end));

#ifndef __STDC__
void
AddWordEntry (start, end)
     ADDR_T start;
     ADDR_T end;
#else
void AddWordEntry (ADDR_T start, ADDR_T end)
#endif
{
  words *entry;

  entry = WordCount ?
    realloc (WordTable, (WordCount + 1) * sizeof *entry) :
    malloc (sizeof *entry);

  if (!entry) return;

  WordTable = entry;
  entry += WordCount++;
  entry->start = start;
  entry->end = end;
}

#ifndef __STDC__
ADDR_T
WordTableEnd (start)
     ADDR_T start;
#else
ADDR_T WordTableEnd (ADDR_T start)
#endif
{
  words *entry;

  if (!((entry = &WordTable[WordCount])))
    return start;

  while (entry-- > WordTable)
    if (entry->start == start)
      return entry->end;

  return start;
}

#ifndef __STDC__
void
SearchVectors ()
#else
void SearchVectors (void)
#endif
{
  ADDR_T start, end, address;

  if ((Options & M_ADR_TABLES) == O_TBL_IGNORE) return;

  if (fVerbose)
    fprintf (stderr, "%s: Searching for address tables.\n", prog);

  for (start = StartAddress; start != EndAddress; start++) {
    if (GetMemType (start) != MEM_DATA || !IsLowByte (Memory[start]))
      continue;

    for (end = start; (end | 1) != (1 | EndAddress); end += 2) {
      if (GetMemType (end) != MEM_DATA || GetMemType (end + 1) != MEM_DATA)
        break;

      address = Memory[end] | (Memory[(ADDR_T)(end + 1)] << 8);

      if (!IsLabeled (address))
        break;

      if ((Options & M_ADR_TABLES) == O_TBL_NOEXT &&
          (ADDR_T)(address - StartAddress) >=
          (ADDR_T)(EndAddress - StartAddress))
        break;
    }

    if ((ADDR_T)(end - start) > 2) {
      AddWordEntry (start, end);
      if (EndAddress == (start = end)) break;
    }
  }
}
