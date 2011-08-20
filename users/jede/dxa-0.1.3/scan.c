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

#define _SCAN_C_
#include <stdio.h>
#include "proto.h"
#include "opcodes.h"
#include "options.h"

int ScanSure PROTO((ADDR_T scanstart));
int ScanPotential PROTO((ADDR_T scanstart));
void UnDoScan PROTO((ADDR_T scanstart));
void DeleteSuspectedParents PROTO((ADDR_T child));

#ifndef __STDC__
int
ScanSure (scanstart)
     ADDR_T scanstart;
#else
int ScanSure (ADDR_T scanstart)
#endif
{
  ADDR_T address, addr;
  opcodes *instr;

  unsigned int size, counter;

  for (address = scanstart;; address += size) {
    if (GetMemFlag (address)) /* rest of routine not valid */
      return ((Options & M_DATA_BLOCKS) == O_DBL_STRICT);

    instr = &opset[Memory[address]];

    if (!instr->mnemonic) /* invalid opcode */
      return ((Options & M_DATA_BLOCKS) == O_DBL_STRICT);

    size = sizes[instr->admode];
    if ((ADDR_T)(address + size - StartAddress) >
        (ADDR_T)(EndAddress - StartAddress))
      break; /* end of program code encountered */

    switch (GetMemType (address)) {
    case MEM_INSTRUCTION:
      return 0; /* The rest of the routine has already been processed. */

    case MEM_DATA:
      AddEntry (address, scanstart, WRN_INSTR_WRITTEN_TO);
      break;

    case MEM_PARAMETER:
      AddEntry (address, scanstart, WRN_PARAM_JUMPED_TO);
    }

    SetMemType (address, MEM_INSTRUCTION);

    for (counter = size, addr = address + 1; --counter; addr++)
      switch GetMemType(addr) {
      case MEM_INSTRUCTION:
        AddEntry (addr, scanstart, WRN_PARAM_JUMPED_TO);
        break;
      case MEM_DATA:
        AddEntry (addr, scanstart, WRN_PARAM_WRITTEN_TO);
        /* fall through */
      default:
        SetMemType (addr, MEM_PARAMETER);
      }

    if (instr->admode == zrel) {
      addr = Memory[(ADDR_T)(address + 1)];

      if (GetMemFlag (addr) && GetMemType (addr) == MEM_UNPROCESSED)
	return (Options & M_DATA_BLOCKS) == O_DBL_STRICT;

      if (((ADDR_T)(addr - StartAddress) <
	   (ADDR_T)(EndAddress - StartAddress) ||
	   Options & B_LBL_ALWAYS)) {
	PutLabel (addr);
	PutLowByte (addr);
	PutHighByte (addr);
      }

      addr = (ADDR_T)((int)(char)Memory[(ADDR_T)(address + 2)] +
		      address + size);
      goto IsJump;
    }

    if (instr->admode == rel) {
      addr = (ADDR_T)((int)(char)Memory[(ADDR_T)(address + 1)] +
                      address + size);

      goto IsJump;
    }
    if ((instr->mnemonic == S_JSR || instr->mnemonic == S_JMP) &&
        instr->admode == abso) {
      addr = Memory[(ADDR_T)(address + 1)] +
        (Memory[(ADDR_T)(address + 2)] << 8);

    IsJump:
      if (GetMemFlag (addr))
        return ((Options & M_DATA_BLOCKS) == O_DBL_STRICT);

      if ((ADDR_T)(addr - StartAddress) <
          (ADDR_T)(EndAddress - StartAddress)) {
        if (GetMemType (addr) == MEM_INSTRUCTION) {
          PutLabel (addr);
          PutLowByte (addr);
          PutHighByte (addr);
        }
        else
          AddEntry (addr, scanstart, Options & B_SCEPTIC &&
                    instr->admode == rel && instr->mnemonic != S_BRA ?
                    RTN_POTENTIAL : RTN_SURE);
      }
      else if (Options & B_LBL_ALWAYS) {
        PutLabel (addr);
        PutLowByte (addr);
        PutHighByte (addr);
      }

      if ((Options & M_DATA_BLOCKS) == O_DBL_STRICT &&
	  Options & B_JMP_STRICT &&
	  addr == address && instr->mnemonic != S_BVC)
        return 1;
    }

    switch (instr->mnemonic) {
    case S_JMP:
      addr = Memory[(ADDR_T)(address + 1)] +
	(Memory[(ADDR_T)(address + 2)] << 8);

      if (instr->admode == iabs && (ADDR_T)(addr - StartAddress) <
	  (ADDR_T)(EndAddress - StartAddress)) {
	PutLabel (addr);
	PutLowByte (addr);
	PutHighByte (addr);

	/* Mark pointer as data. */
	switch (GetMemType (addr)) {
	case MEM_UNPROCESSED:
	  SetMemType (addr, MEM_DATA);
	  break;
	case MEM_INSTRUCTION:
	  AddEntry (addr, scanstart, WRN_INSTR_WRITTEN_TO);
	  break;
	case MEM_PARAMETER:
	  AddEntry (addr, scanstart, WRN_PARAM_WRITTEN_TO);
	  break;
	}

	addr++;

	if ((ADDR_T)(addr - StartAddress) <
	    (ADDR_T)(EndAddress - StartAddress))
	  switch (GetMemType (addr)) {
	  case MEM_UNPROCESSED:
	    SetMemType (addr, MEM_DATA);
	    break;
	  case MEM_INSTRUCTION:
	    AddEntry (addr, scanstart, WRN_INSTR_WRITTEN_TO);
	    break;
	  case MEM_PARAMETER:
	    AddEntry (addr, scanstart, WRN_PARAM_WRITTEN_TO);
	    break;
	  }
      }
      else if (Options & B_LBL_ALWAYS) {
	PutLabel (addr);
	PutLowByte (addr);
	PutHighByte (addr);
      }
    case S_BRA:
    case S_RTS:
    case S_RTI:
      return 0;

    case S_BRK:
    case S_STP:
      return (Options & M_DATA_BLOCKS) == O_DBL_STRICT &&
	Options & B_BRK_REJECT;
    }

    if (instr->admode == rel) {
      if ((ADDR_T)(addr - scanstart) >= (ADDR_T)(address - scanstart)
          || GetMemType (addr) != MEM_INSTRUCTION) {
        if (GetMemType (address + size) != MEM_INSTRUCTION)
          AddEntry (address + size, scanstart, RTN_POTENTIAL);

        return 0;
      }

      continue;
    }

    if (instr->mnemonic == S_JSR) {
      if (!(Options & B_STK_BALANCE)) {
        if (GetMemType (address + size) != MEM_INSTRUCTION)
          AddEntry (address + size, scanstart, RTN_POTENTIAL);

        return 0;
      }

      continue;
    }

    switch (size) {
    case 2:
      addr = Memory[(ADDR_T)(address + 1)];
      break;
    case 3:
      addr = Memory[(ADDR_T)(address + 1)] +
        (Memory[(ADDR_T)(address + 2)] << 8);
      break;
    }

    if (types[instr->admode] != impimm && GetMemFlag (addr) &&
	GetMemType (addr) == MEM_UNPROCESSED)
      return (Options & M_DATA_BLOCKS) == O_DBL_STRICT;

    if (types[instr->admode] != impimm &&
        ((ADDR_T)(addr - StartAddress) <
        (ADDR_T)(EndAddress - StartAddress) ||
        Options & B_LBL_ALWAYS)) {
      PutLabel (addr);
      PutLowByte (addr);
      PutHighByte (addr);
    }

    if (types[instr->admode] != other && types[instr->admode] != impimm) {
      if ((ADDR_T)(addr - StartAddress) <
          (ADDR_T)(EndAddress - StartAddress)) {
        switch (GetMemType (addr)) {
        case MEM_UNPROCESSED:
          SetMemType (addr, MEM_DATA);
          break;
        case MEM_INSTRUCTION:
          AddEntry (addr, scanstart, WRN_INSTR_WRITTEN_TO);
          break;
        case MEM_PARAMETER:
          AddEntry (addr, scanstart, WRN_PARAM_WRITTEN_TO);
          break;
        }

        if (types[instr->admode] == absindir) { /* indirect mode */
          addr++; /* set flags for upper vector byte */

          if ((ADDR_T)(addr - StartAddress) <
              (ADDR_T)(EndAddress - StartAddress))
            switch (GetMemType (addr)) {
            case MEM_UNPROCESSED:
              SetMemType (addr, MEM_DATA);
              break;
            case MEM_INSTRUCTION:
              AddEntry (addr, scanstart, WRN_INSTR_WRITTEN_TO);
              break;
            case MEM_PARAMETER:
              AddEntry (addr, scanstart, WRN_PARAM_WRITTEN_TO);
              break;
            }
        }
      }
    }
  }

  /* end of program (unexpectedly) encountered */

  if (Options & O_DBL_STRICT) return 1;

  AddEntry (EndAddress, scanstart, WRN_RTN_TRUNCATED);
  return 0;
}

#ifndef __STDC__
int
ScanPotential (scanstart)
     ADDR_T scanstart;
#else
int ScanPotential (ADDR_T scanstart)
#endif
{
  ADDR_T address, addr;
  opcodes *instr;

  unsigned int size, counter;

  for (address = scanstart;; address += size) {
    if (GetMemFlag (address)) /* rest of routine not valid */
      return 1;

    instr = &opset[Memory[address]];

    if (!instr->mnemonic) { /* invalid opcode */
      SetMemFlag (address);

      if (GetMemType (address) == MEM_UNPROCESSED)
        SetMemType (address, MEM_DATA);
      return 1;
    }

    size = sizes[instr->admode];
    if ((ADDR_T)(address + size - StartAddress) >
        (ADDR_T)(EndAddress - StartAddress))
      break; /* end of program code encountered */

    if (GetMemType (address) == MEM_INSTRUCTION)
      return 0; /* The rest of the routine has already been processed. */

    if (instr->admode == zrel) {
      addr = Memory[(ADDR_T)(address + 1)];

      if (GetMemFlag (addr) && GetMemType (addr) == MEM_UNPROCESSED)
	goto Failure;

      if (((ADDR_T)(addr - StartAddress) <
	   (ADDR_T)(EndAddress - StartAddress) ||
	   Options & B_LBL_ALWAYS))
	AddEntry (addr, scanstart, WRN_I_LABEL_NEEDED | WRN_B_TEMPORARY);

      addr = (ADDR_T)((int)(char)Memory[(ADDR_T)(address + 1)] +
                      address + size);

      goto IsJump;
    }

    if (instr->admode == rel) {
      addr = (ADDR_T)((int)(char)Memory[(ADDR_T)(address + 1)] +
                      address + size);

      goto IsJump;
    }

    switch (size) {
    case 2:
      addr = Memory[(ADDR_T)(address + 1)];
      break;
    case 3:
      addr = Memory[(ADDR_T)(address + 1)] +
        (Memory[(ADDR_T)(address + 2)] << 8);
      break;
    default:
      addr = address;
    }

    if (types[instr->admode] != impimm && GetMemFlag (addr) &&
        GetMemType (addr) == MEM_UNPROCESSED) {
    Failure:
      SetMemFlag (address);

      if (GetMemType (address) == MEM_UNPROCESSED)
        SetMemType (address, MEM_DATA);
      return 1;
    }

    if ((instr->mnemonic == S_JSR || instr->mnemonic == S_JMP) &&
        instr->admode == abso) {
    IsJump:
      if (GetMemFlag (addr)) {
        SetMemFlag (address);

        if (GetMemType (address) == MEM_UNPROCESSED)
          SetMemType (address, MEM_DATA);
        return 1;
      }

      if ((ADDR_T)(addr - StartAddress) <
          (ADDR_T)(EndAddress - StartAddress))
        AddEntry (addr, scanstart, Options & B_SCEPTIC &&
                  instr->admode == rel && instr->mnemonic != S_BRA ?
                  RTN_SUSP_POT : RTN_SUSPECTED);
      else if (Options & B_LBL_ALWAYS)
        AddEntry (addr, scanstart, WRN_I_LABEL_NEEDED | WRN_B_TEMPORARY);

      if (Options & B_JMP_STRICT && addr == address &&
          instr->mnemonic != S_BVC) {
        SetMemFlag (address);

        if (GetMemType (address) == MEM_UNPROCESSED)
          SetMemType (address, MEM_DATA);
        return 1;
      }
    }

    switch (instr->mnemonic) {
    case S_BRK:
    case S_STP:
      if (Options & B_BRK_REJECT) {
        SetMemFlag (address);

        if (GetMemType (address) == MEM_UNPROCESSED)
          SetMemType (address, MEM_DATA);
        return 1;
      }
    }

    if (!GetMemFlag (address))
      switch (GetMemType (address)) {
      case MEM_DATA:
        AddEntry (address, scanstart, WRN_INSTR_WRITTEN_TO | WRN_B_TEMPORARY);
        break;

      case MEM_PARAMETER:
        AddEntry (address, scanstart, WRN_PARAM_JUMPED_TO | WRN_B_TEMPORARY);
      }

    SetMemType (address, MEM_INSTRUCTION);

    for (counter = size, addr = address + 1; --counter; addr++)
      switch (GetMemType (addr)) {
      case MEM_INSTRUCTION:
        AddEntry (addr, scanstart, WRN_PARAM_JUMPED_TO | WRN_B_TEMPORARY);
        break;
      case MEM_DATA:
        if (!GetMemFlag (addr))
          AddEntry (addr, scanstart, WRN_PARAM_WRITTEN_TO | WRN_B_TEMPORARY);
        break;
      default:
        SetMemType (addr, MEM_PARAMETER);
      }

    switch (instr->mnemonic) {
    case S_BRK:
    case S_STP:
    case S_RTS:
    case S_BRA:
    case S_RTI:
      return 0;

    case S_JMP:
      addr = Memory[(ADDR_T)(address + 1)] +
	(Memory[(ADDR_T)(address + 2)] << 8);

      if (instr->admode == iabs && (ADDR_T)(addr - StartAddress) <
	  (ADDR_T)(EndAddress - StartAddress)) {
	AddEntry (addr, scanstart, WRN_I_LABEL_NEEDED | WRN_B_TEMPORARY);

	/* Mark pointer as data. */
	switch (GetMemType (addr)) {
	case MEM_UNPROCESSED:
	  AddEntry (addr, scanstart, WRN_I_ACCESSED | WRN_B_TEMPORARY);
	  break;
	case MEM_INSTRUCTION:
	  AddEntry (addr, scanstart, WRN_INSTR_WRITTEN_TO | WRN_B_TEMPORARY);
	  break;
	case MEM_PARAMETER:
	  AddEntry (addr, scanstart, WRN_PARAM_WRITTEN_TO | WRN_B_TEMPORARY);
	  break;
	}

	addr++;

	if ((ADDR_T)(addr - StartAddress) <
	    (ADDR_T)(EndAddress - StartAddress))
	  switch (GetMemType (addr)) {
	  case MEM_UNPROCESSED:
	    AddEntry (addr, scanstart, WRN_I_ACCESSED | WRN_B_TEMPORARY);
	    break;
	  case MEM_INSTRUCTION:
	    AddEntry (addr, scanstart,
		      WRN_INSTR_WRITTEN_TO | WRN_B_TEMPORARY);
	    break;
	  case MEM_PARAMETER:
	    AddEntry (addr, scanstart,
		      WRN_PARAM_WRITTEN_TO | WRN_B_TEMPORARY);
	    break;
	  }
      }
      else if (Options & B_LBL_ALWAYS)
	AddEntry (addr, scanstart, WRN_I_LABEL_NEEDED | WRN_B_TEMPORARY);

      return 0;
    }

    if (instr->admode == rel &&
        GetMemType (address + size) != MEM_INSTRUCTION) {
      AddEntry (address + size, scanstart, RTN_SUSP_POT);

      return 0;
    }

    if (instr->mnemonic == S_JSR) {
      if (!(Options & B_STK_BALANCE)) {
        if (GetMemType (address + size) != MEM_INSTRUCTION)
          AddEntry (address + size, scanstart, RTN_SUSP_POT);

        return 0;
      }

      continue;
    }

    switch (size) {
    case 2:
      addr = Memory[(ADDR_T)(address + 1)];
      break;
    case 3:
      addr = Memory[(ADDR_T)(address + 1)] +
        (Memory[(ADDR_T)(address + 2)] << 8);
      break;
    }

    if (types[instr->admode] != impimm &&
        ((ADDR_T)(addr - StartAddress) <
        (ADDR_T)(EndAddress - StartAddress) ||
        Options & B_LBL_ALWAYS))
      AddEntry (addr, scanstart, WRN_I_LABEL_NEEDED | WRN_B_TEMPORARY);

    if (types[instr->admode] != other && types[instr->admode] != impimm) {
      if ((ADDR_T)(addr - StartAddress) <
          (ADDR_T)(EndAddress - StartAddress)) {
        switch (GetMemType (addr)) {
        case MEM_UNPROCESSED:
          AddEntry (addr, scanstart, WRN_I_ACCESSED | WRN_B_TEMPORARY);
          break;
        case MEM_INSTRUCTION:
          AddEntry (addr, scanstart, WRN_INSTR_WRITTEN_TO | WRN_B_TEMPORARY);
          break;
        case MEM_PARAMETER:
          AddEntry (addr, scanstart, WRN_PARAM_WRITTEN_TO | WRN_B_TEMPORARY);
          break;
        }

        if (types[instr->admode] == absindir) { /* indirect mode */
          addr++; /* set flags for upper vector byte */

          if ((ADDR_T)(addr - StartAddress) <
              (ADDR_T)(EndAddress - StartAddress))
            switch (GetMemType (addr)) {
            case MEM_UNPROCESSED:
              AddEntry (addr, scanstart, WRN_I_ACCESSED | WRN_B_TEMPORARY);
              break;
            case MEM_INSTRUCTION:
              AddEntry (addr, scanstart,
                        WRN_INSTR_WRITTEN_TO | WRN_B_TEMPORARY);
              break;
            case MEM_PARAMETER:
              AddEntry (addr, scanstart,
                        WRN_PARAM_WRITTEN_TO | WRN_B_TEMPORARY);
              break;
            }
        }
      }
    }
  }

  /* end of program (unexpectedly) encountered */

  return 1;
}

#ifndef __STDC__
int
ScanSpecified ()
#else
int ScanSpecified (void)
#endif
{
  table *entry;

  if (fVerbose)
    fprintf (stderr, "%s: scanning the routines at specified address(es)",
             prog);

  while ((entry = FindNextEntryType (NULL, ~0, RTN_SURE))) {
    PutLabel (entry->address);
    PutLowByte (entry->address);
    PutHighByte (entry->address);

    if (ScanSure (entry->address)) {
		fprintf(stderr,"For routine specified at %i:",
			(unsigned int)entry->address);
		return 1;
	}
    DeleteEntry (entry);
  }

  return 0;
}

#ifndef __STDC__
void
UnDoScan (scanstart)
     ADDR_T scanstart;
#else
void UnDoScan (ADDR_T scanstart)
#endif
{
  opcodes *instr;
  unsigned counter;
  ADDR_T address;

  for (address = scanstart; address != EndAddress; address++) {
    if (GetMemFlag (address)) return;

    switch (GetMemType (address)) {
    case MEM_UNPROCESSED:
      return;

    case MEM_INSTRUCTION:
      SetMemFlag (address);
      SetMemType (address, MEM_DATA); /* This could cause WRN_PARAM_WRITTEN_TO
					 in vain. */
      instr = &opset[Memory[address++]];
      for (counter = sizes[instr->admode]; --counter; address++)
        if (GetMemType (address) == MEM_PARAMETER)
          SetMemType (address, MEM_UNPROCESSED);
        else if (GetMemType (address) == MEM_INSTRUCTION)
          break;

      if (instr->mnemonic == S_STP || instr->mnemonic == S_BRK ||
          instr->mnemonic == S_RTI || instr->mnemonic == S_RTS ||
          instr->mnemonic == S_JMP || instr->admode == rel)
        return;

      address--;
      break;

    case MEM_PARAMETER:
      SetMemType (address, MEM_UNPROCESSED);
    }
  }
}

#ifndef __STDC__
void
DeleteSuspectedParents (child)
     ADDR_T child;
#else
void DeleteSuspectedParents (ADDR_T child)
#endif
{
  table *entry = NULL;

  while ((entry = FindNextEntry (entry, child, ~(RTN_B_PROCESSED |
                                                 RTN_B_TEMPORARY),
                                 RTN_SUSPECTED))) {
    if (entry->type & RTN_B_PROCESSED && entry->parent != child)
      DeleteSuspectedParents (entry->parent);

    DeleteEntry (entry);
  }

  entry = NULL;

  while ((entry = FindNextEntryTypeParent (entry, child, ~0, RTN_SUSP_POT)))
    DeleteEntry (entry);

  entry = NULL;

  while ((entry = FindNextEntryTypeParent (entry, child,
                                           MASK_ANY | WRN_B_TEMPORARY,
                                           WRN_ANY | WRN_B_TEMPORARY))) {
    if (entry->type == (WRN_PARAM_JUMPED_TO | WRN_B_TEMPORARY))
      SetMemType (entry->address, MEM_PARAMETER);

    DeleteEntry (entry);
  }

  UnDoScan (child);
}

#ifndef __STDC__
void
ScanPotentials ()
#else
void ScanPotentials (void)
#endif
{
  table *entry;
  ADDR_T address;

  if (fVerbose)
    fprintf (stderr, "\n%s: scanning potential routines\n", prog);

  while ((entry = FindNextEntryType (NULL, ~0, RTN_POTENTIAL))) {
    address = entry->address;
    DeleteEntry (entry);

    if (!ScanPotential (address)) {
      while ((entry = FindNextEntryType (NULL, ~RTN_B_TEMPORARY,
                                         RTN_SUSPECTED))) {
        entry->type |= RTN_B_PROCESSED;

        if (ScanPotential (entry->address) &&
            (Options & M_DATA_BLOCKS) != O_DBL_IGNORE) {
          DeleteSuspectedParents (entry->address);
          SetMemType (address, MEM_DATA);
        }
      }

      if (GetMemType (address) != MEM_DATA) {
        PutLabel (address);
        PutLowByte (address);
        PutHighByte (address);
      }

      entry = NULL;

      while ((entry = FindNextEntryType (entry, ~0, RTN_B_TEMPORARY |
                                         RTN_SUSPECTED | RTN_B_PROCESSED)))
        DeleteEntry (entry);

      entry = NULL;

      while ((entry = FindNextEntryType (entry, ~0,
                                         RTN_SUSPECTED | RTN_B_PROCESSED))) {
        PutLabel (entry->address);
        PutLowByte (entry->address);
        PutHighByte (entry->address);
        DeleteEntry (entry);
      }

      entry = NULL;

      while ((entry = FindNextEntryType (entry, ~0, RTN_SUSP_POT)))
        entry->type = RTN_POTENTIAL;

      entry = NULL;

      while ((entry = FindNextEntryType (entry, MASK_ANY | WRN_B_TEMPORARY,
                                         WRN_ANY | WRN_B_TEMPORARY))) {
        switch (entry->type & ~WRN_B_TEMPORARY) {
        case WRN_PARAM_WRITTEN_TO:
          if (GetMemType (entry->address) == MEM_DATA)
            SetMemType (entry->address, MEM_PARAMETER);
          entry->type &= ~WRN_B_TEMPORARY;
          break;

        case WRN_INSTR_WRITTEN_TO:
          if (GetMemType (entry->address) == MEM_DATA)
            SetMemType (entry->address, MEM_INSTRUCTION);
          entry->type &= ~WRN_B_TEMPORARY;
          break;

        case WRN_I_ACCESSED:
          SetMemType (entry->address, MEM_DATA);
          /* fall through */
        case WRN_I_LABEL_NEEDED:
          PutLabel (entry->address);
          PutLowByte (entry->address);
          PutHighByte (entry->address);
          DeleteEntry (entry);
          break;

        default:
          entry->type &= ~WRN_B_TEMPORARY;
        }
      }
    }
    else {
      DeleteSuspectedParents (address);
      SetMemType (address, MEM_DATA);
    }
  }
}

#ifndef __STDC__
void
ScanTheRest ()
#else
void ScanTheRest (void)
#endif
{
  ADDR_T address;
  table *entry;
  unsigned int fPotentials;

  if ((Options & M_DATA_BLOCKS) == O_DBL_NOSCAN) {
    for (address = StartAddress; address != EndAddress; address++)
      if (GetMemType (address) == MEM_UNPROCESSED)
        SetMemType (address, MEM_DATA);

    return;
  }

  if (fVerbose)
    fprintf (stderr, "%s: scanning the remaining bytes for routines\n", prog);

  for (address = StartAddress; address != EndAddress; address++) {
    if (GetMemType (address) || GetMemFlag (address))
      continue; /* scan only unprocessed bytes */

    if (Options & B_RSC_STRICT)
      switch (opset[Memory[address]].mnemonic) {
      case S_RTI:
      case S_RTS:
      case S_BRK:
      case S_STP:
        continue;

      case S_BRA:
        break;

      default:
        if (opset[Memory[address]].admode == rel &&
            GetMemType (address + sizes[rel]) != MEM_INSTRUCTION)
          AddEntry (address + sizes[rel], address,
                    RTN_SUSPECTED | RTN_B_TEMPORARY);
      }

    if (fVerbose)
      fprintf (stderr, "\r%s: scanning at %X", prog, address);

    if (!ScanPotential (address)) {
      while ((entry = FindNextEntryType (NULL, ~RTN_B_TEMPORARY,
                                         RTN_SUSPECTED))) {
        entry->type |= RTN_B_PROCESSED;

        if (ScanPotential (entry->address) &&
            (Options & M_DATA_BLOCKS) != O_DBL_IGNORE) {
          DeleteSuspectedParents (entry->address);
          SetMemType (address, MEM_DATA);
        }
      }

      if (GetMemType (address) != MEM_DATA) {
        PutLabel (address);
        PutLowByte (address);
        PutHighByte (address);
      }

      fPotentials = FALSE;
      entry = NULL;

      while ((entry = FindNextEntryType (entry, ~0, RTN_SUSP_POT))) {
        fPotentials = TRUE;
        entry->type = RTN_POTENTIAL;
      }

      entry = NULL;

      while ((entry = FindNextEntryType (entry, ~0, RTN_B_TEMPORARY |
                                         RTN_SUSPECTED | RTN_B_PROCESSED)))
        DeleteEntry (entry);

      entry = NULL;

      while ((entry = FindNextEntryType (entry, ~0,
                                         RTN_SUSPECTED | RTN_B_PROCESSED))) {
        PutLabel (entry->address);
        PutLowByte (entry->address);
        PutHighByte (entry->address);
        DeleteEntry (entry);
      }

      entry = NULL;

      while ((entry = FindNextEntryType (entry, MASK_ANY | WRN_B_TEMPORARY,
                                         WRN_ANY | WRN_B_TEMPORARY))) {
        switch (entry->type & ~WRN_B_TEMPORARY) {
        case WRN_PARAM_WRITTEN_TO:
          if (GetMemType (entry->address) == MEM_DATA)
            SetMemType (entry->address, MEM_PARAMETER);
          entry->type &= ~WRN_B_TEMPORARY;
          break;

        case WRN_INSTR_WRITTEN_TO:
          if (GetMemType (entry->address) == MEM_DATA)
            SetMemType (entry->address, MEM_INSTRUCTION);
          entry->type &= ~WRN_B_TEMPORARY;
          break;

        case WRN_I_ACCESSED:
          SetMemType (entry->address, MEM_DATA);
          /* fall through */
        case WRN_I_LABEL_NEEDED:
          PutLabel (entry->address);
          PutLowByte (entry->address);
          PutHighByte (entry->address);
          DeleteEntry (entry);
          break;

        default:
          entry->type &= ~WRN_B_TEMPORARY;
        }
      }

      if (fPotentials) ScanPotentials ();
    }
    else {
      DeleteSuspectedParents (address);
      SetMemType (address, MEM_DATA);
    }
  }

  if (fVerbose)
    fprintf (stderr, "\n");

  for (address = StartAddress; address != EndAddress; address++)
    if (GetMemType (address) == MEM_UNPROCESSED) {
      fPotentials = GetMemFlag (address) ? MEM_PARAMETER : MEM_DATA;
      SetMemType (address, fPotentials);
    }
}
