/*\
 *  dxa v0.1.1 -- symbolic 65xx disassembler
 *
 *  Copyright (C) 1993, 1994 Marko M\"akel\"a
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

/* options.h - constant definitions for program options */
#ifndef _OPTIONS_H_
#define _OPTIONS_H_

/************** USER DEFINED SETTINGS ... you may change these **************/

/* #define LONG_OPTIONS	*//* turn on if you want them -- needs getopt_long() */

/******************* WHITE HATS ONLY BELOW THIS POINT !! ********************/

#ifndef _MAIN_C_
extern
#endif
unsigned int Options;

/****************\
* OUTPUT OPTIONS *
\****************/

#define M_ADDRESSES   12 /* ADDRESS INFORMATION PRODUCTION */
#define O_ADR_NOTHING 0  /* do not include addresses in the output */
#define O_ADR_ADRPFIX 8  /* begin each line with its assembling address */
#define O_ADR_ADR_DMP 12 /* begin each line with a hexadecimal dump of
                            its address and the bytes it contains */

                         /* LABEL INFORMATION PRODUCTION */
#define B_LBL_NO_EXT  0  /* do not produce labels for referred
                            addresses outside the program's area */
#define B_LBL_ALWAYS  16 /* substitute all found address references
                            with label references */

#define M_ADR_TABLES  96 /* ADDRESS TABLE DETECTION */
#define O_TBL_IGNORE  0  /* do not detect any address tables */
#define O_TBL_DETECT  32 /* detect address tables and provide them
                            with label statements */
#define O_TBL_NOEXT   64 /* detect only addresses that belong to
                            the program file */

                         /* ADDRESS STATEMENT INTERPRETATION */
#define B_STM_IGNORE  0  /* do not detect or interpret statements
                            like lda #<label */
#define B_STM_DETECT  128 /* provide load instructions with label
                            statements when possible*/

			/* TAB OR COLON */
#define B_LABTAB	0 /* use tabs to separate labels from text */
#define B_LABCOL	262144 /* use colon and newline */

/********************\
* PROCESSING OPTIONS *
\********************/

			  /* STARTING ADDRESS */
#define B_SA_WORD     65536 /* write the starting address as .word to file */
#define B_SA_NO_WORD  0   /* ... or don't */
#define B_GET_SA	131072 /* read the first 2 bytes as starting address */
#define B_NO_GET_SA	0	/* ... or expect them on the command line */

                          /* CUSTOM STACK HANDLING COMPATIBILITY */
#define B_STK_SUSPECT 0   /* assume that a JSR might not return to the
                             following address; mark the routines
                             following a JSR as "potential". */
#define B_STK_BALANCE 256 /* expect the rest of the routine following
                             a JSR to be valid */

                          /* ROUTINE DETECTION */
#define B_RSC_LOUSE   0   /* all routines that consist of plain single-byte
                             instruction (e.g. RTI or RTS) are valid */
#define B_RSC_STRICT  512 /* routines found by scanning remaining
                             unprocessed bytes must consist of more
                             than one instruction to be valid */

#define M_DATA_BLOCKS 3072 /* DATA BLOCK DETECTION */
#define O_DBL_IGNORE  0    /* list the whole file as a program; dump hex
                              only if the area is marked as a data block */
#define O_DBL_DETECT  1024 /* if a "suspected" routine contains invalid
                              code or jumps to any routine that leads to
                              any routine containing invalid code, the
                              start byte of it is marked to be data */
#define O_DBL_NOSCAN  2048 /* skip the scanning in the fourth phase (3.4):
                              list as data all the bytes that have remained
                              unprocessed in the previous phases */
#define O_DBL_STRICT  3072 /* if a "sure" routine contains illegal code,
                              exit the unassembling process immediately */

                           /* IMPROVED DATA BLOCK DETECTION */
#define B_JMP_LOUSE   0    /* `stupid' jumps cause only warnings to the
                              output listing */
#define B_JMP_STRICT  4096 /* valid routines may not contain unreasonable
                              branches or jumps like `BNE *' (D0 FE),
                              `JMP *' or `JSR *' */
#define B_BRK_ACCEPT  0    /* a BRK or STP is considered to mark the end of
                              a routine */
#define B_BRK_REJECT  8192 /* any routine that contains a BRK or an STP is
                               invalid */

#define B_SCEPTIC    16384 /* determines if the program should suspect also
                              the target addresses of relative branches */

#define B_CROSSREF   32768 /* determines if a cross-reference should
                              be created */

#endif /* _OPTIONS_H_ */
