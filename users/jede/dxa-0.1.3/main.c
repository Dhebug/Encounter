/*\
 *  dxa v0.1.3 -- symbolic 65xx disassembler
 *
 *  Based on d65 Copyright (C) 1993, 1994 Marko M\"akel\"a
 *  Changes for dxa (C) 2005, 2006 Cameron Kaiser
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

#define _MAIN_C_
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef __GNUC__
#include <unistd.h>
#endif
#ifdef LONG_OPTIONS
#include <getopt.h>
#endif /* __GNUC__ */
#include "proto.h"
#include "options.h"
#include "opcodes.h"

#ifndef __STDC__
int
main (argc, argv)
     int argc;
     char **argv;
#else
int main (int argc, char **argv)
#endif
{
  FILE *file;
  unsigned address1, address2;
#ifdef LONG_OPTIONS
  int option_index;
#endif
  int fFinished = FALSE, fType;
  char labelname[MAXLINE], strig[MAXLINE], *scanner;

  extern char *optarg;
  extern int optind;

#ifdef LONG_OPTIONS
  static struct option cmd_options [] = {
    { "datablock", 1, 0, 'b' }, /* an address range to be marked
                                   as a data block */
    { "datablocks", 1, 0, 'B' },/* a file containing the address ranges
                                   to be marked as data blocks */
    { "labels", 1, 0, 'l' },    /* a file containing labels to be translated
                                   in the output phase */
    { "routine", 1, 0, 'r' },   /* an address of a routine */
    { "routines", 1, 0, 'R' },  /* a file containing the addresses */

    { "listing-width", 1, 0, 'L' },
                                /* maximum number of dumped bytes per line */
    { "addresses", 1, 0, 'a' }, /* dumping addresses in the output phase */
    { "datablock-detection", 1, 0, 'd' },
                                /* data block detection options */
    { "processor", 1, 0, 'p' }, /* instruction set */
    { "no-colon-newline", 0, 0, 'n' },
    { "colon-newline", 0, 0, 'N' },
    { "no-external-labels", 0, 0, 'e' },
    { "external-labels", 0, 0, 'E' },
    { "address-tables", 0, 0, 't' },
    { "no-address-statements", 0, 0, 's' },
    { "address-statements", 0, 0, 'S' },
    { "suspect-jsr", 0, 0, 'J' },
    { "no-suspect-jsr", 0, 0, 'j' },
    { "one-byte-routines", 0, 0, 'O' },
    { "no-one-byte-routines", 0, 0, 'o' },
    { "stupid-jumps", 0, 0, 'M' },
    { "no-stupid-jumps", 0, 0, 'm' },
    { "allow-brk", 0, 0, 'W' },
    { "no-allow-brk", 0, 0, 'w' },
    { "suspect-branches", 0, 0, 'C' },
    { "no-suspect-branches", 0, 0, 'c' },
    { "cross-reference", 0, 0, 'X' },
    { "no-cross-reference", 0, 0, 'x' },
    { "verbose", 0, 0, 'v' },
    { "help", 0, 0, '?' },
    { "word-sa", 0, 0, 'Q' },
    { "no-word-sa", 0, 0, 'q' },
    { "get-sa", 0, 0, 'G' },
    { "no-get-sa", 0, 0, 'g' },
    { NULL, 0, 0, 0 }
  };
#endif /* LONG_OPTIONS */

  opset = standard_nmos6502;

  StartAddress = 0;
  Options = O_ADR_ADR_DMP | B_LBL_ALWAYS | O_TBL_NOEXT |
    B_STM_DETECT | B_STK_BALANCE | B_RSC_STRICT | O_DBL_STRICT |
    B_JMP_STRICT | B_BRK_REJECT;

	/* dxa defaults */
        Options = (Options & ~M_ADDRESSES) | O_ADR_NOTHING;
        Options = (Options & ~M_DATA_BLOCKS) | O_DBL_IGNORE;
        Options &= ~B_LBL_ALWAYS;
	Options &= ~B_LABCOL;
	Options |= B_SA_WORD;
	Options |= B_GET_SA;

  for (address1 = sizeof MemType / sizeof *MemType; address1--;
       MemType[address1] = 0);

  for (address1 = sizeof MemFlag / sizeof *MemFlag; address1--;
       MemFlag[address1] = MemLabel[address1] = 0);

  for (address1 = sizeof LowByte / sizeof *LowByte; address1--;
       HighByte[address1] = LowByte[address1] = 0);

  for (prog = *argv; *prog; prog++);
  for (;prog > *argv; prog--)
    if (*prog == '/') {
      prog++;
      break;
    }

  while (!fFinished)
#ifdef LONG_OPTIONS
    switch (getopt_long (argc, argv,
			 "?b:B:L:r:R:h:l:a:d:p:g:t:eEnNsSjJoOcCmMvVwWxXqQG",
                         cmd_options, &option_index)) {
#else
    switch (getopt (argc, argv,
	"?b:B:L:r:R:h:l:a:d:p:g:t:eEnNsSjJoOcCmMvVwWxXqQG")){
#endif /* LONG_OPTIONS */
    case -1:
    case ':':
      fFinished = TRUE;
      break;

    case '?':
    case 'V':
      goto Usage;

    case 'b':
      if (*optarg == '!') {
        fType = MEM_PARAMETER;
        optarg++;
      }
      else if (*optarg == '?') {
        fType = MEM_UNPROCESSED;
        optarg++;
      }
      else
        fType = MEM_DATA;

      if (!sscanf (optarg, "%X-%X", &address1, &address2) ||
          address1 > 65535 || address2 > 65535) {
        fprintf (stderr, "%s: Error in data block address range `%s'.\n\n",
                 prog, optarg);
        goto Usage;
      }

      for (; (ADDR_T)address1 != address2; address1++) {
        SetMemType (address1, fType);
        SetMemFlag (address1);
      }

      SetMemType (address1, fType);
      SetMemFlag (address1);

      break;

    case 'B':
      if (!((file = fopen (optarg, "rt")))) {
        fprintf (stderr, "%s: Could not open %s.\n", prog, optarg);
        return 2;
      }

      while (!feof (file)) {
        if ('!' == (fType = fgetc (file)))
          fType = MEM_PARAMETER;
        else if ('?' == fType)
          fType = MEM_UNPROCESSED;
        else {
          ungetc (fType, file);
          fType = MEM_DATA;
        }

        if (!fscanf (file, "%X-%X\n", &address1, &address2) ||
            address1 > 65535 || address2 > 65535) {
          fprintf (stderr, "%s: Error in data block address file %s.\n",
                   prog, optarg);

          fclose (file);
          return 3;
        }

        for (; (ADDR_T)address1 != address2; address1++) {
          SetMemType (address1, fType);
          SetMemFlag (address1);
        }

        SetMemType (address1, fType);
        SetMemFlag (address1);
      }

      fclose (file);
      break;

    case 'r':
      if (!sscanf (optarg, "%X", &address1) || address1 > 65535) {
        fprintf (stderr, "%s: Error in routine address `%s'.\n\n",
                 prog, optarg);
        goto Usage;
      }

      AddEntry (address1, address1, RTN_SURE);
      break;

    case 'R':
      if (!((file = fopen (optarg, "rt")))) {
        fprintf (stderr, "%s: Could not open %s.\n", prog, optarg);
        return 2;
      }

      while (!feof (file)) {
        if (!fscanf (file, "%X\n", &address1) || address1 > 65535) {
          fprintf (stderr, "%s: Error in data block address file `%s'.\n",
                   prog, optarg);

          fclose (file);
          return 3;
        }

        AddEntry (address1, address1, RTN_SURE);
      }

      fclose (file);
      break;

    case 'L':
      if (0 > (listwidth = atoi (optarg))) {
	fprintf (stderr, "%s: Illegal listing width specified.\n\n", prog);
	goto Usage;
      }

      break;

    case 'a':
      if (!strcmp (optarg, "disabled"))
        Options = (Options & ~M_ADDRESSES) | O_ADR_NOTHING;
      else if (!strcmp (optarg, "enabled"))
        Options = (Options & ~M_ADDRESSES) | O_ADR_ADRPFIX;
      else if (!strcmp (optarg, "dump"))
        Options = (Options & ~M_ADDRESSES) | O_ADR_ADR_DMP;
      else {
        fprintf (stderr, "%s: Unrecognized option for dumping addresses.\n\n",
                 prog);
        goto Usage;
      }
      break;

    case 'd':
      if (!strcmp (optarg, "poor"))
        Options = (Options & ~M_DATA_BLOCKS) | O_DBL_IGNORE;
      else if (!strcmp (optarg, "extended"))
        Options = (Options & ~M_DATA_BLOCKS) | O_DBL_DETECT;
      else if (!strcmp (optarg, "skip-scanning"))
        Options = (Options & ~M_DATA_BLOCKS) | O_DBL_NOSCAN;
      else if (!strcmp (optarg, "strict"))
        Options = (Options & ~M_DATA_BLOCKS) | O_DBL_STRICT;
      else {
        fprintf (stderr,
                 "%s: Unrecognized option for detecting data blocks.\n\n",
                 prog);
        goto Usage;
      }
      break;

    case 'p':
      if (!strcmp (optarg, "all-nmos6502"))
        opset = all_nmos6502;
      else if (!strcmp (optarg, "rational-nmos6502"))
        opset = rational_nmos6502;
      else if (!strcmp (optarg, "useful-nmos6502"))
        opset = useful_nmos6502;
      else if (!strcmp (optarg, "traditional-nmos6502"))
        opset = traditional_nmos6502;
      else if (!strcmp (optarg, "r65c02"))
        opset = r65c02;
      else if (!strcmp (optarg, "standard-nmos6502"))
        opset = standard_nmos6502;
      else {
        fprintf (stderr, "%s: Unsupported instruction set `%s'.\n\n",
                 prog, optarg);
        goto Usage;
      }
      break;

    case 'e':
      Options &= ~B_LBL_ALWAYS;
      break;
    case 'E':
      Options |= B_LBL_ALWAYS;
      break;

    case 't':
      if (!strcmp (optarg, "ignore"))
        Options = (Options & ~M_ADR_TABLES) | O_TBL_IGNORE;
      else if (!strcmp (optarg, "detect-all"))
        Options = (Options & ~M_ADR_TABLES) | O_TBL_DETECT;
      else if (!strcmp (optarg, "detect-internal"))
        Options = (Options & ~M_ADR_TABLES) | O_TBL_NOEXT;
      else {
        fprintf (stderr,
                 "%s: Unknown address table detection option `%s'.\n\n",
                 prog, optarg);
        goto Usage;
      }
      break;

    case 's':
      Options &= ~B_STM_DETECT;
      break;
    case 'S':
      Options |= B_STM_DETECT;
      break;

    case 'J':
      Options &= ~B_STK_BALANCE;
      break;
    case 'j':
      Options |= B_STK_BALANCE;
      break;

    case 'o':
      Options &= ~B_RSC_STRICT;
      break;
    case 'O':
      Options |= B_RSC_STRICT;
      break;

    case 'c':
      Options &= ~B_SCEPTIC;
      break;
    case 'C':
      Options |= B_SCEPTIC;
      break;

    case 'M':
      Options &= ~B_JMP_STRICT;
      break;
    case 'm':
      Options |= B_JMP_STRICT;
      break;

    case 'v':
      fVerbose = TRUE;
      break;

    case 'W':
      Options &= ~B_BRK_REJECT;
      break;
    case 'w':
      Options |= B_BRK_REJECT;
      break;

    case 'x':
      Options &= ~B_CROSSREF;
      break;
    case 'X':
      Options |= B_CROSSREF;
      break;

/* new or altered dxa options */
    case 'n':
	Options &= ~B_LABCOL;
	break;
    case 'N':
	Options |= B_LABCOL;
	break;
    case 'q':
	Options &= ~B_SA_WORD;
	break;
    case 'Q':
	Options |= B_SA_WORD;
	break;
    case 'G':
	Options |= B_GET_SA;
	break;
    case 'g':
	Options &= ~B_GET_SA;
        if (!sscanf (optarg, "%X", &address1) || address1 > 65535) {
          fprintf (stderr, "%s: Error specifying starting address `%s'.\n\n",
                 prog, optarg);
          goto Usage;
        }
	StartAddress = address1;
	break;
    case 'l':
      if (!((file = fopen (optarg, "rt")))) {
        fprintf (stderr,
                 "%s: Label file %s could not be opened for reading.\n\n",
                 prog, optarg);

        goto Usage;
      }

      while (!feof (file)) {
        fType = fgetc (file);

        if (feof (file))
          break;

        ungetc (fType, file);

#if(0)
	/* This is the old behaviour. -- Cameron */
        if (!fscanf (file, "%X:", &address1) || address1 > 65535 || 
            !fgets (labelname, sizeof labelname, file)) {
#else
	/* This is the xa-compatible label scanner. */
	if (!fscanf(file, "%s%i", labelname, &address1) ||
		address1 > 65535 ||
		!fgets(strig, sizeof strig, file)) {
#endif
	LabelError:
          fprintf (stderr, "%s: Error in label file %s.\n", prog, optarg);
	  fprintf (stderr, "Address(?): 0x%x ... Label(?): \"%s\"\n\n",
		address1, labelname);
          fclose (file);
          return 3;
        }

        for (scanner = labelname; *scanner; scanner++);

#if(0)
        if (scanner[-1] != '\n') goto LabelError; /* line too long */
#endif

        while (--scanner > labelname && (
		*(unsigned char *)scanner < 32 ||
		*(unsigned char *)scanner == 44)) /* and commas */
          *scanner = 0;         /* remove trailing control characters */

        for (scanner = labelname; *(unsigned char *)scanner < 32; scanner++)
          if (!*scanner) goto LabelError;         /* label name missing */

        AddLabel (address1, scanner);
      }

      fclose (file);
    }

  if (argc - optind > 1) {
  Usage:
    fprintf (stderr, "%s v0.1.3 -- symbolic 65xx disassembler\n", prog);
    fprintf (stderr, "Based on d65 copyright (C) 1993-4 Marko M\"akel\"a\n");
    fprintf (stderr, "Changes for dxa copyright (c) 2006-7 Cameron Kaiser\n\n");
    fprintf (stderr, "Usage: %s [options] [filename]\n", prog);
    return 1;
  }

	/* Fix, Need "rb" (binary mode) on Windows to avoid termintating on $1A */
  if (!(file = (argc - optind) ? fopen (argv[argc - 1], "rb") : stdin)) {
    fprintf (stderr, "%s: Couldn't open input file.\n", prog);
    return 2;
  }

  if (Options & B_GET_SA) {
  	StartAddress = (unsigned)fgetc (file);
  	StartAddress |= (unsigned)fgetc (file) << 8;
  }


  if (feof (file)) {
    fprintf (stderr, "%s: Error reading the file.\n", prog);
    return 3;
  }

/* this doesn't work so well */
/* AddEntry (StartAddress, StartAddress, RTN_SURE); */
  EndAddress = StartAddress + fread (&Memory[StartAddress], sizeof (char),
                                     65536 - StartAddress, file);

  if (!feof (file)) {
    if ((EndAddress = fread (Memory, sizeof (char), StartAddress, file)))
      fprintf (stderr, "%s: Warning: Input file caused an address overflow.\n",
               prog);

    if (!feof (file)) {
      fprintf (stderr, "%s: Error: Input file is longer than 64 kilobytes.\n",
               prog);
      fclose (file);
      return 3;
    }
  }

  fclose (file);

  if (fVerbose)
    fprintf (stderr, "%s: disassembling %X-%X\n", prog,
             StartAddress, EndAddress);

  if (ScanSpecified ()) {
    fprintf (stderr, "\n%s: Invalid routine address(es) specified. Stop.\n",
             prog);

    return 4;
  }

  ScanPotentials ();
  ScanTheRest ();
  Collect ();
  SearchVectors ();
  Dump ();

  return 0;
}
