/*\
 *  dxa v0.1.3 -- symbolic 65xx disassembler
 *
 *  Copyright (C) 1993, 1994 Marko M\"akel\"a
 *  Changes for dxa (C) 2004, 2006 Cameron Kaiser
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
 *  Marko does not maintain dxa, so questions specific to dxa should be
 *  sent to me at ckaiser@floodgap.com . Otherwise,
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

#define _DUMP_C_
#include <stdio.h>
#include <stdlib.h>

#include "proto.h"
#include "options.h"
#include "opcodes.h"

#ifndef __STDC__
void
Dump ()
#else
void Dump (void)
#endif
{
  ADDR_T address, addr;
  unsigned counter, size, maxwidth;
  char *lineprefix, *lineinfix;
  table *entry;
  opcodes *instr;

  if (fVerbose)
    fprintf (stderr, "%s: Dumping the source code.\n", prog);

  /* determine the maximum amount of bytes dumped per line */

  maxwidth = listwidth < 2 ? 2 : listwidth;

  for (counter = 0; counter < 256; counter++)
    if (maxwidth < sizes[opset[counter].admode])
      maxwidth = sizes[opset[counter].admode];

  /* create prefix string for lines without address information */
  switch (Options & M_ADDRESSES) {
  case O_ADR_ADRPFIX:
    counter = 5;
    break;

  case O_ADR_ADR_DMP:
    counter = 5 + 3 * maxwidth;
    break;

  default:
    counter = 0;
  }

  lineprefix = malloc (counter + 1);

  if (counter >= 5) {
    lineinfix = lineprefix + 5;

    for (lineprefix[counter] = 0; counter--; lineprefix[counter] = ' ');
  }
  else {
    *lineprefix = 0;
    lineinfix = lineprefix;
  }

  /* print the label definitions */

  for (address = EndAddress < StartAddress ? EndAddress : 0;
       address != StartAddress; address++)
    if (IsLabeled (address))
      fprintf (stdout, "%s%s = $%x\n", lineprefix, Label (address, abso),
	address);

  if (EndAddress >= StartAddress)
    for (address = EndAddress; address; address++)
      if (IsLabeled (address))
        fprintf (stdout, "%s%s = $%x\n", lineprefix, Label (address, abso),
		address);

  /* dump the program */

  if(Options & B_SA_WORD)
	fprintf(stdout, "%s\t.word $%04x", lineprefix, StartAddress);
  fprintf (stdout, "\n%s\t* = $%04x\n\n", lineprefix, StartAddress);

  for (address = StartAddress; (ADDR_T)(address - StartAddress) <
       (ADDR_T)(EndAddress - StartAddress); address += size)
    if (GetMemType (address) == MEM_INSTRUCTION) {
      if (IsLabeled (address)) {
	if (Options & M_ADDRESSES)
	  fprintf (stdout, "%04x %s%s:\n", address,
                   lineinfix, Label (address, abso));
	else {
	  fprintf (stdout, "%s", Label (address, abso));
		if (Options & B_LABCOL)
			fprintf(stdout, ":\n");
	}
      }

      instr = &opset[Memory[address]];
      size = sizes[instr->admode];

      for (counter = 1; counter < size; counter++) {
        if (IsLabeled (address + counter)) {
	  if (Options & M_ADDRESSES)
	    fprintf (stdout, "\t%04x %s%s = * + %u\n",
                     (ADDR_T)(address + counter),
		     lineinfix, Label (address + counter, abso), counter);
	  else
	    fprintf (stdout, "\t%s = * + %u\n",
		     Label (address + counter, abso), counter);
	}

        if (FindNextEntry (NULL, address, ~0, WRN_INSTR_WRITTEN_TO))
          fprintf (stdout, "%s; Instruction opcode accessed.\n", lineprefix);

        entry = NULL;

        while ((entry = FindNextEntry (entry, address + counter, 0, 0)))
          switch (entry->type) {
          case WRN_PARAM_WRITTEN_TO:
            fprintf (stdout, "%s; Instruction parameter accessed.\n",
		     lineprefix);
            break;

          case WRN_PARAM_JUMPED_TO:
            fprintf (stdout, "%s; Instruction parameter jumped to.\n",
		     lineprefix);
            break;
          }
      }

      switch (Options & M_ADDRESSES) {
      case O_ADR_ADRPFIX:
	fprintf (stdout, "%04x ", address);
	break;

      case O_ADR_ADR_DMP:
	fprintf (stdout, "%04x ", address);

	for (counter = 0; counter < size; counter++)
	  fprintf (stdout, "%02x ", Memory[(ADDR_T)(address + counter)]);

	fputs (lineinfix + 3 * counter, stdout);
      }

      fputs ("\t", stdout);

      switch (instr->admode) {
      case accu:
      case impl:
        fprintf (stdout, "%s%s\n", mne[instr->mnemonic],
                 postfix[instr->admode]);
        break;
      case imm:
        addr = Memory[(ADDR_T)(address + 1)];
        fprintf (stdout, "%s #$%02x\n", mne[instr->mnemonic], addr);
        break;
      case abso:
      case absx:
      case absy:
      case iabs:
      case iabsx:
        addr = Memory[(ADDR_T)(address + 1)] |
          (Memory[(ADDR_T)(address + 2)] << 8);
          /* Fix to ensure 16-bit addresses to zero-page are maintained as 16-bit */
          fprintf (stdout, "%s %s%s%s%s\n", mne[instr->mnemonic],
		prefix[instr->admode],
                   ((addr < 256 && instr->mnemonic != S_JMP &&
			instr->mnemonic != S_JSR) ? "!" : ""),
                   Label (addr, abso),postfix[instr->admode]);
        break;
      case zp:
      case zpx:
      case zpy:
      case ind:
      case indx:
      case indy:
        addr = Memory[(ADDR_T)(address + 1)];
        fprintf (stdout, "%s %s%s%s\n", mne[instr->mnemonic],
                 prefix[instr->admode], Label (addr, zp),
                 postfix[instr->admode]);
        break;
      case rel:
        addr = (int)(char)Memory[(ADDR_T)(address + 1)];
	/* addr -= (addr > 127) ? 256 : 0; BUGFIX: sign extend already done */
/*fprintf(stderr, "%d %d %d\n", address, size, addr);*/
        addr += address + size;
        fprintf (stdout, "%s %s%s%s\n", mne[instr->mnemonic],
                 prefix[instr->admode], Label (addr, abso),
                 postfix[instr->admode]);
        break;
      case zrel: /* BBR0, etc. 65C02 instructions */
        addr = (int)(char)Memory[(ADDR_T)(address + 2)];
	/* addr -= (addr > 127) ? 256 : 0; BUGFIX: sign extend already done */
        addr += address + size;
        fprintf (stdout, "%s %s, %s\n", mne[instr->mnemonic],
                Label (Memory[(ADDR_T)(address + 1)], abso),
		Label (addr, abso));
        break;
      }
    }
    else if (address != (addr = WordTableEnd (address))) { /* word table */
      for (size = (ADDR_T)(addr - address); size;
	   address += (counter = size > (maxwidth & ~1) ?
                       (maxwidth & ~1) : size), size -= counter) {
	if (IsLabeled (address)) {
	  if (Options & M_ADDRESSES)
	    fprintf (stdout, "%04x %s%s:\n", address, lineinfix,
                     Label (address, abso));
	  else
	    fprintf (stdout, "%s ", Label (address, abso));
	}
	for (counter = size > (maxwidth & ~1) ? (maxwidth & ~1) : size,
	     addr = address + 1; --counter; addr++)
	  if (IsLabeled (addr)) {
	    if (Options & M_ADDRESSES)
	      fprintf (stdout, "%04x %s%s = * + %u\n", addr, lineinfix,
		       Label (addr, abso), (ADDR_T)(addr - address));
	    else
	      fprintf (stdout, "\t%s = * + %u\n", Label (addr, abso),
		       (ADDR_T)(addr - address));
	  }

	if (Options & M_ADDRESSES)
	  fprintf (stdout, "%04x ", address);

	if ((Options & M_ADDRESSES) == O_ADR_ADR_DMP) {
	  for (counter = size > (maxwidth & ~1) ? (maxwidth & ~1) : size,
	       addr = address; counter--; addr++) {
	    fprintf (stdout, "%02x ", Memory[addr]);
	  }
	  fputs (lineinfix + 3 * (size > (maxwidth & ~1) ?
				  (maxwidth & ~1) : size), stdout);
	}

	fprintf (stdout, "  .word %s",
		 Label (Memory[address] |
                 (Memory[(ADDR_T)(address + 1)] << 8), abso));

	for (counter = size > (maxwidth & ~1) ? (maxwidth & ~1) : size,
	     addr = address + 2; counter -= 2; addr += 2)
	  fprintf (stdout, ",%s",
		   Label (Memory[addr] | (Memory[(ADDR_T)(addr + 1)] << 8),
			abso));
			

	fputc ('\n', stdout);
      }
    }
    else { /* data block */
      for (size = 1; size < maxwidth; size++) { /* determine the size */
	addr = address + size; 

	if (GetMemType (addr) == MEM_INSTRUCTION ||
	    addr != WordTableEnd (addr))
	  break;
      }

      if (IsLabeled (address)) {
	if (Options & M_ADDRESSES)
	  fprintf (stdout, "%04x %s%s:\n", address, lineinfix,
		   Label (address, abso));
	else
	  fprintf (stdout, "%s ", Label (address, abso));
      }

      for (counter = size, addr = address + 1; --counter; addr++)
        if (IsLabeled (addr)) {
	  if (Options & M_ADDRESSES)
	    fprintf (stdout, "%04x %s%s = * + %u\n", addr, lineinfix,
		     Label (addr, abso), (ADDR_T)(addr - address));
	  else
	    fprintf (stdout, "\t%s = * + %u\n", Label (addr, abso),
		     (ADDR_T)(addr - address));
        }

      if (Options & M_ADDRESSES)
	fprintf (stdout, "%04x ", address);

      if ((Options & M_ADDRESSES) == O_ADR_ADR_DMP) {
	for (counter = size, addr = address; counter--; addr++)
	  fprintf (stdout, "%02x ", Memory[addr]);

	fputs (lineinfix + 3 * size, stdout);
      }

      fprintf (stdout, "\t.byt $%02x", Memory[address]);

      for (counter = size, addr = address + 1; --counter; addr++)
	if (addr < EndAddress) /* problems with this overflowing */
		fprintf (stdout, ",$%02x", Memory[addr]);

      fputc ('\n', stdout);
    }
}
