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

/* structures.h - memory structures and related constants and macros */
#ifndef _STRUCTURES_H_
#define _STRUCTURES_H_

#ifndef FALSE
#define FALSE 0
#define TRUE !FALSE
#endif

#ifndef NULL
#define NULL (void *)0
#endif

#define MAXLINE 50 /* maximum amount of bytes used when reading a label in */

typedef unsigned short int ADDR_T; /* 16-bit unsigned integer */
typedef unsigned char      DATA_T; /* 8-bit unsigned integer */

/********************\
* Program code table *
\********************/

#ifndef _MAIN_C_
extern
#endif
DATA_T Memory[1 << 16];

/*************************\
* Memory place type table *
\*************************/

#ifndef _MAIN_C_
extern
#endif
unsigned MemType[(1 << 14) / sizeof(unsigned)];

#define GetMemType(address) \
     ((MemType[((ADDR_T)address) / (4 * sizeof *MemType)] >>    \
       ((address % (4 * sizeof *MemType)) << 1)) & 3)

#define SetMemType(address, type) \
     (MemType[((ADDR_T)address) / (4 * sizeof *MemType)] =      \
      (MemType[((ADDR_T)address) / (4 * sizeof *MemType)] &     \
       ~(3 << ((address % (4 * sizeof *MemType)) << 1))) |      \
      (type << ((address % (4 * sizeof *MemType)) << 1)))
 
/* The table consists of bit pairs with the following values: */

#define MEM_UNPROCESSED 0 /* the memory place has not been processed yet */
#define MEM_INSTRUCTION 1 /* a machine language instruction starts at
                             this memory place */
#define MEM_DATA        2 /* the memory place contains data */
#define MEM_PARAMETER   3 /* a parameter of a machine language
                             instruction is at this place */

/*************************\
* Memory place flag table *
\*************************/

#ifndef _MAIN_C_
extern
#endif
unsigned
     MemFlag[(1 << 13) / sizeof(unsigned)],
     MemLabel[(1 << 13) / sizeof(unsigned)],
     LowByte[(1 << 8) / sizeof(unsigned)],
     HighByte[(1 << 8) / sizeof(unsigned)];

#define GetMemFlag(address) \
     ((MemFlag[((ADDR_T)address) / (8 * sizeof *MemFlag)] >>    \
       (address % (8 * sizeof *MemFlag))) & 1)

#define SetMemFlag(address) \
     (MemFlag[((ADDR_T)address) / (8 * sizeof *MemFlag)] |=     \
      (1 << (address % (8 * sizeof *MemFlag))))

/* The flag table indicates if there may be a valid routine at the address.
   If a flag is set, there cannot be valid routines at the address. */

#define IsLabeled(address) \
     ((MemLabel[((ADDR_T)address) / (8 * sizeof *MemLabel)] >>  \
       (address % (8 * sizeof *MemLabel))) & 1)

#define PutLabel(address) \
     (MemLabel[((ADDR_T)address) / (8 * sizeof *MemLabel)] |=   \
      (1 << (address % (8 * sizeof *MemLabel))))

/* These macros tell if there is a label for a given address, or cause a
   label to be produced for an address. */

#define IsLowByte(address) \
     ((LowByte[((unsigned char)address) / (8 * sizeof *LowByte)] >>     \
       (address % (8 * sizeof *LowByte))) & 1)

#define PutLowByte(address) \
     (LowByte[((unsigned char)address) / (8 * sizeof *LowByte)] |=      \
      (1 << (address % (8 * sizeof *LowByte))))

/* Corresponding macros for the low byte address table. */

#define IsHighByte(address) \
     ((HighByte[(address >> 8) / (8 * sizeof *HighByte)] >>     \
       ((address >> 8) % (8 * sizeof *HighByte))) & 1)

#define PutHighByte(address) \
     (HighByte[(address >> 8) / (8 * sizeof *HighByte)] |=      \
      (1 << ((address >> 8) % (8 * sizeof *HighByte))))

/* Corresponding macros for the high byte address table. */

/***************************************\
* Routine/warning address table entries *
\***************************************/

typedef struct table
{
  ADDR_T address;
  ADDR_T parent;
  unsigned char type;
} table;

/* The table.type byte has the following format: */

#define RTN_SURE        0x80 /* address must point to a valid subprogram */
#define RTN_POTENTIAL   0x81 /* address may point to a valid subprogram (an
                                address following a conditional branch
                                instruction) */
#define RTN_SUSPECTED   0x82 /* address might point to a valid subprogram
                                (an address encountered during processing
                                an RTN_POTENTIAL entry) */
#define RTN_SUSP_POT    0x83 /* address might point to a subprogram (an
                                address following a conditional branch
                                instruction that was encountered during
                                processing an RTN_SUSPECTED or
                                RTN_POTENTIAL entry) */
#define RTN_B_TEMPORARY 0x10 /* declares the entry as temporary */
#define RTN_B_PROCESSED 0x20 /* address seems to point to a valid
                               subprogram (a successfully processed
                               RTN_SUSPECTED entry is
                               RTN_SUSPECTED | RTN_B_PROCESSED) */

#define MASK_ANY        0xc0 /* mask for determining the type of the entry */

#define RTN_ANY         0x80 /* mask for determining if an entry is a
                                routine or not */

#define WRN_PARAM_WRITTEN_TO 0x40 /* the parameter of the instruction is
                                     written to */
#define WRN_INSTR_WRITTEN_TO 0x41 /* the instruction is modified by the
                                     program */

#define WRN_PARAM_JUMPED_TO  0x42 /* a jump occurs in the middle of the
                                     instruction, e.g. BIT $01A9 */
#define WRN_RTN_TRUNCATED    0x43 /* the routine is truncated, the rest of
                                     the instructions are retrieved outside
                                     the loaded file (very fatal error) */
#define WRN_I_ACCESSED       0x44 /* not an actual warning: an unprocessed
                                     memory place is accessed by an
                                     RTN_POTENTIAL or RTN_SUSPECTED routine */
#define WRN_I_LABEL_NEEDED   0x45 /* not an actual warning: a label will be
                                     needed for this memory place */

#define WRN_B_TEMPORARY      0x20 /* mask for determining whether a warning
                                     is temporary and may be deleted later */

#define WRN_ANY              0x40 /* mask for determining whether an
                                     entry is a warning or not */

#define TBL_DELETED          0    /* the entry may be reused */

/*********************\
* Label table entries *
\*********************/

typedef struct label
{
  ADDR_T address;
  char *name;
} label;

/********************\
* Word table entries *
\********************/

typedef struct words
{
  ADDR_T start, end;
} words;

#ifndef _MAIN_C_
extern char *prog;
extern ADDR_T StartAddress, EndAddress;
extern int fVerbose;
#else
char *prog;
ADDR_T StartAddress, EndAddress;
int fVerbose = FALSE;
#endif /* _MAIN_C_ */

#ifndef _TABLE_C_
extern unsigned int entrycount;
extern table *scantable; /* table of all warnings generated or routines
                            encountered */
#else
unsigned int entrycount = 0;
table *scantable = NULL;
#endif /* _TABLE_C_ */

#ifndef _DUMP_C_
extern int listwidth; /* maximum amount of bytes dumped on a source line */
#else
int listwidth = 0;
#endif /* _DUMP_C_ */

#endif /* _STRUCTURES_H_ */
