/* file.c
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
 * $Header: RCS/file.c,v 3.0 1992/10/21 16:56:19 pds Stab $
 */
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "infocom.h"

#ifdef NEED_ERRNO
extern int errno;
#endif

#ifdef USE_OCC
/* When compiling for Oric use low level i/o 
 * functions */
/* #include <disk.h> */
#endif

#ifndef USE_OCC
static FILE *game_file;
static char gname[MAXPATHLEN + 1];
#endif

int origin;
extern word resident_blocks;

static void
assign (header_t* headp, const header_t* buffer)
{
    register const byte  *ptr;
    register int         i;
    register header_t* head=headp;

    /*
     * Process the raw header data in "buffer" and put
     * it into the appropriate fields in "head". This
     * processing is required because of the way different
     * machines internally represent 'words'.
     */
    ptr = (const byte *)buffer;

    head->z_version       = Z_TO_BYTE_I(ptr);
    head->flags_1         = Z_TO_BYTE_I(ptr);
    head->release         = Z_TO_WORD_I(ptr);
    head->resident_bytes  = Z_TO_WORD_I(ptr);
   /* printf("Res bytes %d\n",head->resident_bytes);*/
    head->game_o          = Z_TO_WORD_I(ptr);
    /*printf("game offset %d\n",head->game_o);*/
    head->vocab_o         = Z_TO_WORD_I(ptr);
    /*printf("Vocab offset %d\n",head->vocab_o);*/
    head->object_o        = Z_TO_WORD_I(ptr);
    /*printf("Object offset %d\n",head->object_o);*/
    head->variable_o      = Z_TO_WORD_I(ptr);
    /*printf("Variable offset %d\n",head->variable_o);*/
    head->save_bytes      = Z_TO_WORD_I(ptr);
    head->flags_2         = Z_TO_WORD_I(ptr);
    for (i = 0; i < 6; ++i)
        head->serial_no[i] = Z_TO_BYTE_I(ptr);
    head->common_word_o   = Z_TO_WORD_I(ptr);
    /*printf("Common word offset %d\n",head->common_word_o);*/
    head->verify_length   = Z_TO_WORD_I(ptr);
    head->verify_checksum = Z_TO_WORD_I(ptr);
    for (i = 0; i < 8; ++i)
        head->padding1[i] = Z_TO_WORD_I(ptr);
    head->fkey_o          = Z_TO_WORD_I(ptr);
    for (i = 0; i < 2; ++i)
        head->padding2[i] = Z_TO_WORD_I(ptr);
    head->alphabet_o      = Z_TO_WORD_I(ptr);
    for (i = 0; i < 5; ++i)
        head->padding3[i] = Z_TO_WORD_I(ptr);
}

/*
 * Function:    read_header()
 *
 * Description:
 *      This function reads in the game data file's header info.  We
 *      only do this between scr_setup() and scr_begin(), so just use
 *      normal printf()'s if we find an error, and just exit if we
 *      can't continue.
 *
 * Notes:
 *      This routine does not read the data-file header directly into
 *      a header structure because certain machines like the VAX
 *      11/780 store integers in a different way to machines based on
 *      processors like the 68000 (a 68000 stores the high byte first,
 *      while a VAX stores the low byte first).  Consequently, if the
 *      header is read directly into a structure, the integer values
 *      are interpreted differently by the two machines.
 */
#ifdef USE_OCC
unsigned char *buffer=(unsigned char *)0xE000;
#endif
void
read_header (header_t* head)
{
    extern void exit (int);
    extern char _sectors_per_cyl;
    extern char _stepping_rate;
    int directory,size,cluster;
#ifdef TRACE
   printf("Reading Header\n");
#endif

   /* ORIC PORT: Read file sector based... */
   /* First, read FAT sector for type info */
    sect_read(1,buffer);
   /* this allows to know where the MSDOS directory is... */
   /* and the first data sector, the size of a cluster, etc. */
    switch (buffer[0]) {
       case 0xFC:  /* 5"1/4 180K */
         _stepping_rate=1;   /* give a 12 ms delay */
         _sectors_per_cyl=9; directory=5; origin=9; cluster=512; break;
       case 0xFD:  /* 5"1/4 360K */
         _stepping_rate=1;
         _sectors_per_cyl=18; directory=5; origin=12; cluster=1024; break;
       case 0xF9:  /* 3"1/2 720K */
       default:
         _stepping_rate=0;   /* a 6 ms delay should be enough */
         _sectors_per_cyl=18; directory=7; origin=14; cluster=1024;
    }
    sect_read(directory,buffer);

   /* add Pinforic size, found in the first directory entry */
   /*  (or second if a volume label is first)               */
   /* Size has to be rounded with regards to cluster size   */
    if (buffer[0x1D]) size=buffer[0x1C]+256*buffer[0x1D];
    else size=buffer[0x3C]+256*buffer[0x3D];
    size = ((size+cluster-1)/cluster)*cluster;
    origin += size/512;

   /* read the first block of data */
    sect_read(origin,buffer);
    assign(head, (header_t *)buffer);

}

/*
 * Open a file for reading; if the parameter is NULL then look through
 * the name,extension list pairs to try to find one there.  Return a
 * pointer to it, whatever it is.
 */
#ifndef USE_OCC
const char *
open_file (const char* filename)
{

   strcpy(gname,filename);
   printf("Opening game...\n");
   /* What to do about savefile name? */
   if ((game_file = fopen(gname, "rb")) == NULL)
	 {
		printf("no file\n");
		return NULL;
	 }
   		
   return filename;
}
#endif /*USE_OCC*/

#ifndef USE_OCC
void
close_file()
{
    if (fclose(game_file))
        printf("Can't close");
}
#endif

void
load_page (word block, word num_blocks, byte* ptr)
{
    extern file_t   file_info;

    long found;
    long offset;
    long num_bytes;

    /*
     * Read "num_block" blocks from Game File, starting with block
     * "block", into the location pointed to by "ptr".
     */
       
#ifndef USE_OCC
   offset = (long)block * BLOCK_SIZE;
   num_bytes = (long)num_blocks * BLOCK_SIZE;
   printf("Loading page %d\n",block);
   if (fseek(game_file, offset, 0) < 0)
    {
        printf("Error %d :SEEKING BLK\n", errno);
        quit();
    }
    else if ((found = fread(ptr, 1, num_bytes, game_file)) < num_bytes)
    {
        /*
         * Check if this is the last block: some games (notably
         * MS-DOS) don't have the full last block on the disk.  If
         * this isn't the last block, print an error.  Otherwise, zero
         * out the rest of the page.
         */
        if ((found / BLOCK_SIZE != num_blocks - 1)
            || (block + num_blocks - 1 != file_info.pages))
        {
            printf( "LD BLK\n");
            quit();
        }

        for (ptr += found; found < num_bytes; ++found, ++ptr)
            *ptr = '\0';
    }
#else
   /* ORIC PORT: Read file sector based.. */

	while(num_blocks)
	 {
		/*printf("Loading block %d at %x\n",block,(char*)ptr);*/
		/*if(((ptr>(unsigned char *)0xb1ff)&&(ptr<(unsigned char *)0xd000))||(ptr>(unsigned char*)0xfdf9)){
		   printf("No space\n");
		   return;
		}*/
		sect_read(origin+block,(char *)ptr);
		ptr+=512;block++;num_blocks--;
	 }
   
#ifdef TRACE
   printf("done\n");
#endif

#endif   
}

void
save()
{
#ifdef USE_OCC
    extern byte     *base_ptr;
    extern word     save_blocks;
    extern byte     *end_res_p;
    extern word     *stack;
    extern word     *stack_base;
    extern word     *stack_var_ptr;
    extern word     pc_page;
    extern word     pc_offset;
    extern header_t data_head;
    extern byte     *global_ptr;
    extern byte     *vocab;

    register int     j;
    register byte    *p; 
    register word    *stack_page;

    /*
     * We save the the program counter, the stack offset, the
     * stack_var offset, the stack itself, and finally the resident
     * impure storage.  This overwrites the lowest 8 bytes of the
     * stack; hopefully those aren't being used...
     */
   
     /* ORIC PORT: Warning! if the last block to save of variable
	  * area (overlay ram) includes bytes in positions > $FFFF this will
	  * save (and then will be restored) bytes from bottom memory.
	  */
   
    stack_page = (word *)( ((char *)stack_base)-512 );
    stack_page[0] = pc_page;
    stack_page[1] = pc_offset;
    stack_page[2] = stack_base - stack;
    stack_page[3] = stack_base - stack_var_ptr;
   
    j=origin+256; /* a program should not exceed 128KB, some do but it seems the end is empty */

    sect_write(j++,(char *)stack_page); /* STACK_SIZE < 512 */
    for (p=base_ptr ; p<base_ptr+data_head.save_bytes ; p+=512)
            sect_write(j++,(char *)p);
    
#endif
 	ret_value(1);
}


void
restore()
{
#ifdef USE_OCC
    extern byte     *base_ptr;
    extern word     save_blocks;
    extern byte     *end_res_p;
    extern word     *stack;
    extern word     *stack_base;
    extern word     *stack_var_ptr;
    extern word     pc_page;
    extern word     pc_offset;
    extern header_t data_head;
    extern byte     *global_ptr;
    extern byte     *vocab;
   
    word            *stack_page;
    register int    j;
    register byte   *p;
   
    stack_page = (word *)( ((char *)stack_base)-512 );

    j=origin+256; /* a program should not exceed 128KB, some do but it seems the end is empty */
    sect_read(j++,(char *)stack_page); /* STACK_SIZE < 512 */
    for (p=base_ptr ; p<base_ptr+data_head.save_bytes ; p+=512)
            sect_read(j++,(char *)p);

    pc_page         = stack_page[0];
    pc_offset       = stack_page[1];
    stack           = stack_base - stack_page[2];
    stack_var_ptr   = stack_base - stack_page[3];
   
    fix_pc();
    
#endif
    ret_value(1);
   
}
