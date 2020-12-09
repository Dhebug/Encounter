/* infocom.h
 *
 *  ``pinfocom'' -- a portable Infocom Inc. data file interpreter.
 *  Copyright (C) 1987-1992  InfoTaskForce
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
 *  along with this program; see the file COPYING.  If not, write to the
 *  Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/*
 * $Header: RCS/infocom.h,v 3.0 1992/10/21 16:56:19 pds Stab $
 */

/*
 *      STANDARD SERIES INFOCOM INTERPRETER
 */

#define VERSION     3
#define USE_OCC
#define ASSEMBLY

#ifdef USE_OCC
#define puts printf
#endif

//#include <stdlib.h>


#ifdef USE_DBMALLOC
#include <sys/types.h>
#include "dbmalloc.h"
#endif

#include "defines.h"  /* ORIC PORT: Makefile settings in defines.h */

/*
 * Universal Type Definitions.
 *
 *  'byte'                  - 8 bits       ; unsigned.
 *  'word'                  - 16 bits      ; unsigned.
 *  'signed_word'           - 16 bits      ; signed.
 *  'long_word'             - 32 bits      ; signed.
 */
#define         byte            unsigned char
#define         word            unsigned int
#define         signed_word     int
/* We'll have problems 'cause long is 16 bit in occ */
#define         long_word       long        

/*
 * Constants
 */

#define         MAXPATHLEN              20
#define         LOCAL_VARS              0x10
#define         STACK_SIZE              0x0200
#define         BLOCK_SIZE              0x0200
#define         MAX_MEM                 0xFFFF

/*
 * Game State Codes
 */

#define         NOT_INIT                0x00 /* Must be 0 */
#define         INIT_GAME               0x01
#define         PLAY_GAME               0x02
#define         RESTART_GAME            0x03
#define         LOAD_GAME               0x04
#define         QUIT_GAME               0x05

/*
 * scr_*_sf() Type Codes
 */

#define         SF_SAVE                 0x00
#define         SF_RESTORE              0x01
#define         SF_SCRIPT               0x02

/*
 * ANSI C compatibility stuff
 */

#if defined(__STDC__) || defined(__TURBOC__)

typedef void *  ptr_t;

#else

typedef char *  ptr_t;

#if !defined(sun)
#define void    int
#endif

#define const

#endif

/*
 * Bitfield Macros:
 *
 * These macros modify the flag bits; they should be used instead of
 * direct bit-twiddling for the header flags fields.  They may only be
 * used after init() has been called.
 */
#define F1_IS_SET(_b)   (base_ptr[1]&(_b))
#define F1_SETB(_b)     (base_ptr[1]|=(_b))
#define F1_RESETB(_b)   (base_ptr[1]&=(~(_b)))

#define F2_IS_SET(_b)   (base_ptr[17]&(_b))
#define F2_SETB(_b)     (base_ptr[17]|=(_b))
#define F2_RESETB(_b)   (base_ptr[17]&=(~(_b)))

/*
 * These are possible bits to be examine in header.flags_1:
 */
#define B_USE_TIME      (0x02)              /* Readonly */
#define B_TANDY         (0x08)
#define B_ALT_PROMPT    (0x10)
#define B_STATUS_WIN    (0x20)

/*
 * These are possible bits to examine in header.flags_2:
 */
#define B_SCRIPTING     (0x01)
#define B_FIXED_FONT    (0x02)
#define B_SOUND         (0x10)


/*
 * Conversion Macros:
 *
 * These macros convert from data file info into the current machine's
 * byte order, etc.
 */

/* 
 * ORIC PORT: Some of the next macros have been redefined as functions
 * to save space.
 */

word Z_TO_WORD(byte* p);
#define Z_TO_BYTE(_p)   ((byte)(*(_p)&0xff))
#define Z_TO_BYTE_I(_p) ((byte)(*(_p++)&0xff))
#define Z_TO_WORD_I(_p) (((_p)+=2),Z_TO_WORD((byte*)(_p-2)))

/*#define Z_TO_WORD_I(_p) ((_p)+=2,((word)(((_p)[-2]&0xff)<<8)+((_p)[-1]&0xff)))*/
/*#define Z_TO_WORD(_p)   ((word)((((_p)[0]&0xff)<<8)+((_p)[1]&0xff)))*/


/*
 * Speed Macros:
 *
 * These macro-ize certain bottlenecks (discovered using the UNIX
 * utility prof(1)).  Use NEXT_BYTE() like a function returning void.
 */
/*
#define NEXT_BYTE(_v) do{ extern word pc_offset; extern byte *prog_block_ptr;\
                          (_v)=Z_TO_BYTE(prog_block_ptr+pc_offset++);\
                          if(pc_offset==BLOCK_SIZE)fix_pc(); }while (0)

*/
/* ORIC PORT: We will put it back as a function to save space */
extern byte next_byte();
#define NEXT_BYTE next_byte


/* ORIC PORT: We put an interface function as a macro... */ 
#ifdef USE_OCC
#define scr_putline(_p)    scr_putbuf(!gflags.paged, (_p));
#endif

/*
 * Type Definitions
 */

typedef int     Bool;
typedef byte    *property;

/*
 * Global Flags Structure
 *
 * Contains flags and other information used globally by both the
 * interpreter and the terminal interface.
 */
typedef struct gflags
{
    int         game_state;                 /* Game state */
    Bool        pr_status;                  /* Print status line */
    Bool        paged;                      /* Page long output */
    Bool        echo;                       /* Echo input lines */
} gflags_t;

/*
 * File Information Structure
 *
 * This structure contains various interesing bits of information
 * related to the file we're examining.
 */
typedef struct file
{
    word    pages;
    word    offset;
} file_t;

/*
 * Object Structure Definition.
 *
 * Since version 4/5/6 objects are a different size than version 3
 * objects, we define both styles here.  The obj_addr() function will
 * use the information in the obj_info_t structure to find the object
 * list correctly.
 *
 * The interpreter code assumes ver. 3 style objects, but the higher
 * versions are understood for object listings.
 */
typedef struct obj_info
{
    byte    *obj_base;                      /* Start of obj table */
    int     obj_size;                       /* Size of each obj entry */
    int     obj_offset;                     /* start of objs */
} obj_info_t;

typedef struct object
{
    byte    attributes[4];
    byte    parent;
    byte    sibling;
    byte    child;
    byte    data[2];
} object_t;


/*
 * Print Buffer Structure
 *
 *  buf     Points to the buffer to be filled in
 *  len     Current length of filled-in data
 *  max     The maximum size of the buffer (not including the nul char)
 */
typedef struct print_buf
{
    byte    *buf;
    int     len;
    int     max;
} print_buf_t;

/*
 * Infocom Game Header Structure
 *
 *  The 'z_version' byte has the following meaning:
 *      00 : Game compiled for an early version of the interpreter
 *      01 : Game compiled for an early version of the interpreter
 *      02 : Game compiled for an early version of the interpreter
 *      03 : Standard Series Interpreter
 *      04 : Plus Series Interpreter
 *      05 : Solid Gold Interactive Fiction
 *      06 : Graphic Interactive Fiction
 *
 *  The 'flags_1' byte contains the following information:
 *      Bit #   Usage                   CLEAR       SET
 *      -----   ---------------------   -----       -----
 *        0     Game Header             OK          Error
 *        1     Status Bar display      SCORE       TIME
 *        5     Save file indicator      ??          ??
 *
 *  The 'flags_2' word is used by Z-CODE to set printing modes
 *  for use by the interpreter:
 *      Bit #   Usage                   CLEAR       SET
 *      -----   ---------------------   -----       -----
 *       0      Script mode             OFF         ON
 *       1      Font type               -any-       fixed-width
 *       4      Sound                   NO          YES
 */

typedef struct header
{
        byte    z_version;              /* Game's Z-CODE Version Number    */
        byte    flags_1;                /* Status indicator flags          */
        word    release;                /* Game Release Number             */
        word    resident_bytes;         /* No. bytes in the Resident Area  */
        word    game_o;                 /* Offset to Start of Game         */
        word    vocab_o;                /* Offset to Vocab List            */
        word    object_o;               /* Offset to Object/Room List      */
        word    variable_o;             /* Offset to Global Variables      */
        word    save_bytes;             /* No. bytes in the Save Game Area */
        word    flags_2;                /* Z-CODE printing modes           */
        char    serial_no[6];           /* Game's Serial Number            */
        word    common_word_o;          /* Offset to Common Word List      */
        word    verify_length;          /* No. words in the Game File      */
        word    verify_checksum;        /* Game Checksum - used by Verify  */
        word    padding1[8];
        word    fkey_o;                 /* Fkey offset (?)                 */
        word    padding2[2];
        word    alphabet_o;             /* Offset of alternate alphabets   */
        word    padding3[5];
} header_t;

/*
 * Global Variables
 */

extern obj_info_t   objd;
extern gflags_t     gflags;
extern byte *       base_ptr;

/*
 * Function Prototypes
 */

#define E extern

/*
 * file.c
 */
E void          read_header (header_t *);
E const char *  open_file (const char *);
E void          close_file (void);
E void          load_page (word, word, byte *);
E void          save (void);
E void          restore (void);
/*
 * funcs.c
 */
E void          pi_random (void);
E void          compare (void);
E void          cp_zero (void);
E void          or (void);
E void          and (void);
E void          bit (void);
E void          not (void);
E void          plus (void);
E void          minus (void);
E void          multiply (void);
E void          divide (void);
E void          mod (void);
E void          LTE (void);
E void          GTE (void);

/*
 * infocom.c
 */

/*
 * init.c
 */
E void          init (void);
/*
 * input.c
 */
E void          input (void);
/*
 * interp.c
 */
E void          interp (void);
/*
 * jump.c
 */
E void          gosub (void);
E void          rtn (void);
E void          rts (void);
E void          rtn1 (void);
E void          rtn0 (void);
E void          jump (void);
E void          push(void);
E void          pop(void);
E void          pop_stack(void);
/*
 * object.c
 */
E void          transfer (void);
E void          remove_obj (void);
E void          test_attr (void);
E void          set_attr (void);
E void          clr_attr (void);
E void          get_loc (void);
E void          get_holds (void);
E void          get_link (void);
E void          check_loc (void);
E object_t *    obj_addr (word);
/*
 * options.c
 */
/*
 * page.c
 */
E void          pg_init (void);
E byte *        fetch_page (word);
E void          fix_pc (void);
/*
 * print.c
 */
E const char *  chop_buf (const char *);
E void          print_init (void);
E void          print_num (void);
E void          print_str (const char *);
E void          print2 (void);
E void          print1 (void);
E void          p_obj (void);
E void          wrt (void);
E void          writeln (void);
E void          new_line (void);
E void          print_char (void);
E void          prt_coded (word *, word *);
E void          decode (word);
E void          set_score (void);
/*
 * property.c
 */
E void          next_prop (void);
E void          put_prop (void);
E void          get_prop (void);
E void          get_prop_addr (void);
E void          get_prop_len (void);
E void          load_word_array (void);
E void          load_byte_array (void);
E void          save_word_array (void);
E void          save_byte_array (void);
/*
 * support.c
 */
E ptr_t         xmalloc (unsigned int);
E ptr_t         xrealloc (ptr_t, unsigned int);
E void          null (void);
E void          change_status (void);
E void          restart (void);
E void          quit (void);
E void          store (word);
E void          ret_value (word);
E void          error (const char *, int);
E byte          get_byte (word, word);
E word          get_word (word, word);
E word          next_word (void);
/*
 * variable.c
 */
E word          load_var (word);
E void          put_var (void);
E void          inc_chk (void);
E void          dec_chk(void);
E void          inc_var(void);
E void          dec_var(void);
E void          get_var(void);
/*
 * Terminal interface functions
 */
/*E void          scr_putline (const char *);*/
E void          scr_putscore (void);
E void          scr_putmesg (const char *, Bool);
E int           scr_getline (const char *, int, char *);
E void		bell (void);

#undef E
