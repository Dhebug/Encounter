/* infocom.c
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
 * $Header: RCS/infocom.c,v 3.0 1992/10/21 16:56:19 pds Stab $
 */
#include <string.h>
#include "infocom.h"

#define COPYRIGHT   "\n\
    This program comes with ABSOLUTELY NO WARRANTY.\n\
    This program is free software, and you are welcome to redistribute it\n\
    under certain conditions; see the file COPYING in the source directory\n\
    for full details.\n"

#define USAGE       "Usage: %-8s [-aAehoOpPstTvV] [-c context] [-i indent] [-l lines]\n\t\t[-m margin] [-r savefile] "
#define OPTIONS     "aAc:ehi:l:m:oOpPr:stTvV"

#ifndef RMARGIN
#define RMARGIN 2
#endif
#ifndef LMARGIN
#define LMARGIN 0
#endif
#ifndef CONTEXT
#define CONTEXT 2
#endif


header_t    data_head;
obj_info_t  objd;
gflags_t    gflags;
file_t      file_info;
word        random1;
word        random2;
word        pc_offset;
word        pc_page;
word        resident_blocks;
word        save_blocks;
byte        *base_ptr;
byte        *vocab;
byte        *global_ptr;
byte        *end_res_p;
word        *stack_base;
extern word        *stack_var_ptr;
extern word        *stack;
byte	*prog_block_ptr;


/* Input Routine Variables */

byte        *wsbf_strt;
byte        *end_of_sentence;
word        num_vocab_words;
word        vocab_entry_size;
byte        *strt_vocab_table;
byte        *end_vocab_table;


/* Print Routine Variables */

byte        *common_word_ptr;
print_buf_t *pbf_p;

char ws_table[] = { ' ','\t','\r','.',',','?','\0','\0' };

char table[] =
{
    'a','b','c','d','e','f','g','h','i','j','k','l','m',
    'n','o','p','q','r','s','t','u','v','w','x','y','z',
    'A','B','C','D','E','F','G','H','I','J','K','L','M',
    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
    ' ',' ','0','1','2','3','4','5','6','7','8','9','.',
    ',','!','?','_','#','\'','"','/','\\','-',':','(',')',
    '\0','\0'
};


int
main ()
{

    extern int atoi (const char *);
    extern word     random1;
    extern word     random2;
   
    /*extern word     resident_blocks;
    extern word     save_blocks;
    extern header_t data_head;
    extern file_t   file_info;
    extern byte     *base_ptr;
    extern byte     *vocab;
    extern byte     *global_ptr;
    extern byte     *common_word_ptr;
    extern byte     *end_res_p;
    extern word     *stack_base;

    extern byte     *wsbf_strt;
    extern char     ws_table[];
    extern char     table[];
    extern byte     *end_of_sentence;
    extern word     vocab_entry_size;
    extern word     num_vocab_words;
    extern byte     *strt_vocab_table;
    extern byte     *end_vocab_table;*/
    extern print_buf_t thetext, room;
    extern print_buf_t  *pbf_p;
    extern int      scr_columns;
   
    unsigned long   i;
    word            num;
    byte            *p, *q;

   printf("\024\014\n\004\033J\033C Pinforic Standard Release 1.0.2\004\n\n\033Cby Jose-Maria Enguita & Fabrice Frances\n\n");

#define play 1
   gflags.paged = 1;
   gflags.pr_status = 1;
   
   gflags.game_state = NOT_INIT;

#ifdef USE_OCC
   base_ptr = (byte *)ORIC_BASE_MEM;
#ifdef TRACE
   printf("%d bytes free\n",(byte *)ORIC_HIMEM-base_ptr);
#endif
#endif
   
   /*
	* Open the game file, if possible...
	*/
   
   /* ORIC PORT: Here it goes the code for opening the game file.
	* in Oric this won't be done in this way.
	*/
   
#ifndef USE_OCC
   if(open_file("game.dat")==NULL) return (1);
#endif	    

    read_header(&data_head);
    
   /* check_version */
   if (data_head.z_version!=3) {
     printf("No Standard Series game found.\024\021\n");
     return 1;
   }
   
    resident_blocks = (data_head.resident_bytes + BLOCK_SIZE-1) / BLOCK_SIZE;

    i = data_head.verify_length * 2;
    file_info.pages = i / BLOCK_SIZE;
    file_info.offset = i % BLOCK_SIZE;

    /*
     * Try to calculate how much resident storage we'll need.  We need
     * enough for the resident blocks, pluse the stack, plus any extra
     * whitespace characters (say 100 bytes: way too much but...)
     */
#ifndef USE_OCC
    i = (resident_blocks * BLOCK_SIZE) + STACK_SIZE + 100;
    printf("resident storage...%d bytes (%d)\n",i,data_head.resident_bytes);
    base_ptr = (byte *)xmalloc(i);
    
#else
    /* With Oric, Z-stack and whitespace buffer is in overlay ram so
     * we only check the resident blocks storage
    */
#ifdef TRACE
    printf("resident size : %d bytes\n",data_head.resident_bytes);
#endif
    if ( base_ptr+resident_blocks*BLOCK_SIZE > (byte *)ORIC_HIMEM ) 
	 {
		printf("Resident part too large\n");
		exit(1);
	 }   
	   
#endif

    /*
     * Load resident memory
     */
#ifdef TRACE
   printf("Loading resident memory..");
#endif
   load_page(0, resident_blocks, base_ptr);

    /*
     * Set up pointers into resident storage, and information related
     * to it.
     */
    global_ptr = base_ptr + data_head.variable_o;
    common_word_ptr = base_ptr + data_head.common_word_o;
    save_blocks = data_head.save_bytes / BLOCK_SIZE;
    if (data_head.save_bytes % BLOCK_SIZE)
        ++save_blocks;

    /*
     * Set up object information.  I don't know why there's an offset
     * before the object offset in the file and the actual start of
     * the object list, but there is.  I found the correct values by
     * writing a little loop that tried each value incrementally until
     * one worked! :-)
     */

    /* ORIC PORT: Don't recognize objects from version > 3 games */
    objd.obj_base = base_ptr + data_head.object_o;
	   
    objd.obj_size = 9;
    objd.obj_offset = 0x35;
 
    /*
     * If we have alternate alphabets, then load them in.
     */
	if (data_head.alphabet_o != 0)
    {
        word    page;
        word    offset;

        page = data_head.alphabet_o / BLOCK_SIZE;
        offset = data_head.alphabet_o % BLOCK_SIZE;

        for (i = 0; i < 78/*3 * 26*/; ++i) {
            table[i] = get_byte(page, offset);
	    offset++;
	    if (offset==BLOCK_SIZE) {
		offset=0;
		page++;
	    }
	}
    }

    /*
     * Now set up information that comes after the resident storage,
     * such as the stack and the whitespace list.
     */
#ifndef USE_OCC
    end_res_p = base_ptr + (resident_blocks * BLOCK_SIZE);

    stack_base = (word *)(end_res_p + STACK_SIZE);

    wsbf_strt = (byte *)stack_base;
#else
    /* put them in overlay ram */
    end_res_p = (byte *)OVERLAY_START ;

    stack_base = (word *)(end_res_p + TEXT_BUFFER_SIZE + STACK_SIZE);

    wsbf_strt = (byte *)stack_base;
	
#endif

    /*
     * Set up the vocabulary information: first read in the
     * end-of-sentence punctuation marks, then get the size of each
     * vocabulary entry and the number of words in it, and mark the
     * start and end of the vocab table.
     */
    vocab = base_ptr + data_head.vocab_o;

    p = vocab;
    num = Z_TO_BYTE_I(p);
    q = wsbf_strt;
    while (num-- > 0)
        *q++ = *p++;
    end_of_sentence = q;

    vocab_entry_size = Z_TO_BYTE_I(p);
    num_vocab_words = Z_TO_WORD_I(p);

    strt_vocab_table = p;
    end_vocab_table = strt_vocab_table +
        (vocab_entry_size * (num_vocab_words-1));

    p = (byte *)ws_table;
    while (*p)
		 *q++ = *p++;

	*q = 0;
   
   /*
	* Set up the page table, random number generator, and print
	* buffers.
	*/
   pg_init();    

#ifdef NO_RANDOM
    random1 = 0xFFFF;
    random2 = 0xFFFF;
#else
    random1 = time(0) >> 16;
    random2 = time(0) & 0xFFFF;
#endif
   /* Init printing */   
   
    thetext.len = 0;
    thetext.max = TEXT_BUFFER_SIZE;
    thetext.buf = (byte*)OVERLAY_START;

    pbf_p = &thetext;

    room.max = BUFMIN;
#ifndef USE_OCC   
    room.buf = (byte *)xmalloc(room.max + 1);
#else
    room.buf = wsbf_strt + 100;
#endif
    room.buf[0] = ' ';
    room.len = 1;
   
   
   gflags.game_state = INIT_GAME;
   change_status();

   /* Start the zMachine... */
   interp(); 
   
   return (0);   
}
