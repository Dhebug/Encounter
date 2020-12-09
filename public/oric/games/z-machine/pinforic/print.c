/* print.c
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
 * $Header: RCS/print.c,v 3.0 1992/10/21 16:56:19 pds Stab $
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "infocom.h"

extern word param[];

#define LONG_SCORE_WIDTH    60
#define MAX_MOVES           1599
#define STATLEN             38

int     print_mode;     /* General Printing Mode           */
int     single_mode;    /* Mode for printing the next char */

static word word_bank;  /* There are 3 banks of common     */
                        /* words, each 32 words long.      */

print_buf_t thetext, room;

void
print_num(void)
{
#ifndef USE_OCC
    Bool    neg;
    int     num;
    char    buf[15], *cp;

    num = (signed_word)number;
    if (neg = (num < 0))
        num = -num;

    cp = buf;
    do
    {
        *(cp++) = '0' + (num % 10);
        num /= 10;
    }
    while (num > 0);

    if (neg)
        *cp = '-';
    else
        --cp;

    for (; cp >= buf; --cp) {
        param[0]= *cp;
        print_char();
#else
    register char * cp = itoa((signed_word)param[0]);
    
    while(*cp) {
     param[0]= *cp++;
     print_char();
   }
#endif   
}

/*
 * Print a hex number in a fixed-width space -- NOTE: this function
 * cannot be called with a value > 0xff if !is_eobj, or 0xffff if
 * is_eobj.
 */
/* ORIC PORT: We won't need this function. Code was removed. */

void
print2 ()
{
    extern word param[];
    word    page;
    word    offset;

    page = param[0] >> 8;
    offset = (param[0] & 0xFF) << 1;
    prt_coded(&page, &offset);
}

void
print1 ()
{
    extern word param[];
    word    page;
    word    offset;

    page = param[0] / BLOCK_SIZE;
    offset = param[0] % BLOCK_SIZE;
    prt_coded(&page, &offset);
}

void
p_obj(void)
{
    object_t    *obj;
    word        address;
    word        page;
    word        offset;

    obj = obj_addr(param[0]);
    address = Z_TO_WORD(obj->data);
    page = address / BLOCK_SIZE;
    offset = address % BLOCK_SIZE;
    /*
     * The first byte at the address is the length of the data: if
     * it's 0 then there's nothing to print, so don't.
     */
    if (get_byte(page, offset) > 0)
    {
	offset++;
	if (offset==BLOCK_SIZE) {
	    offset=0;
	    page++;
	}
        prt_coded(&page, &offset);
    }
}

void
wrt()
{
    extern word     pc_page;
    extern word     pc_offset;

    prt_coded(&pc_page, &pc_offset);
    fix_pc();
}

void
writeln()
{
    wrt();
    new_line();
    param[0]=1;
    rtn();
}

void
new_line()
{
    extern print_buf_t  *pbf_p;

    pbf_p->buf[pbf_p->len] = '\0';
    scr_putline((char *)pbf_p->buf);
    pbf_p->len = 0;
}

void
print_char()
{
    extern print_buf_t *pbf_p;
#ifndef USE_OCC
    /*
     * If we're at the end of the buffer then get some more memory...
     */
    if (pbf_p->len == pbf_p->max)
    {
        pbf_p->max += BUFMIN;
        pbf_p->buf = (byte *)xrealloc(pbf_p->buf, pbf_p->max + 1);
    }
     pbf_p->buf[pbf_p->len++] = (byte)ch;
#else
   /* With real Oric mem is exhausted... */
   /*if (pbf_p->len == pbf_p->max)
   {
	  printf("Buf out!\n");
   }
   else*/	
    pbf_p->buf[pbf_p->len++] = (byte)param[0];
#endif   
}

void
prt_coded (word *page_p, word *offset_p)
{
    register word    data;
    word page= *page_p;
    word offset= *offset_p;

    /*
     * Print mode = < 0 :   Common Word;
     *              = 0 :   Lower Case Letter;
     *              = 1 :   Upper Case Letter;
     *              = 2 :   Number or Symbol;
     *              = 3 :   ASCII Letter - first byte;
     *              > 3 :   ASCII Letter - second byte;
     */
    print_mode = 0;
    single_mode = 0;

    /* Last word has high bit set */
    do
    {
        data = get_word(page, offset);
        offset+=2;
	if (offset>=BLOCK_SIZE) {
	    offset-=BLOCK_SIZE;
	    page++;
	}
        decode(data);
    }
    while (!(data & 0x8000));
    *page_p=page;
    *offset_p=offset;
}

static void
letter (char ch)
{
    extern char     table[];

    if (ch == 0)
    {
	param[0]=' ';
        print_char();
        single_mode = print_mode;
        return;
    }

    if (ch <= 3)
    {
        /* Set single_mode to "Common Word" & set word_bank */

        single_mode |= 0x80;
        word_bank = (ch - 1) << 6;
        return;
    }

    if ((ch == 4) || (ch == 5))
    {
        /* Switch printing modes */

        if (single_mode == 0)
            single_mode = ch - 3;
        else
        {
            if (single_mode == ch - 3)
                single_mode = 0;
            print_mode = single_mode;
        }
        return;
    }

    if ((ch == 6) && (single_mode == 2))
    {
        /* Increment printing mode to 3 - ASCII Letter. */

        ++single_mode;
        return;
    }

    if ((ch == 7) && (single_mode == 2))
    {
        /* Print a Carriage Return */

        new_line();
        single_mode = print_mode;
        return;
    }

    /* None of the above, so this must be a single character */

    param[0]=table[(single_mode * 26) + ch - 6];
    print_char();
    single_mode = print_mode;
}

void
decode (word data)
{
    extern byte     *common_word_ptr;

    word            page;
    word            offset;
    word            code;
    int             i;
    byte            *ptr;
    char            ch[3];

    /* Reduce word to 3 characters of 5 bits */

    code = data;
    for (i = 0; i <= 2; i++)
    {
        ch[i] = code & 0x1F;
        code >>= 5;
    }

    /* Print each character */

    for (i = 2; i >= 0; i--)
    {
        if (single_mode & 0x80)
        {
            /* Print a Special Word */
            ptr = common_word_ptr + word_bank + (int)(ch[i] << 1);
            page = Z_TO_BYTE_I(ptr);
            offset = Z_TO_BYTE(ptr) << 1;
            prt_coded(&page, &offset);
            single_mode = print_mode;
            continue;
        }
        if (single_mode < 3)
        {
            /* Print a single character */

            letter(ch[i]);
            continue;
        }
        if (single_mode == 3)
        {
            /*
             * Print ASCII character - store the high 3 bits of
             * char in the low 3 bits of the current printing mode.
             */

            single_mode = 0x40 + ch[i];
            continue;
        }
        if (single_mode & 0x40)
        {
            /*
             * Print an ASCII character - consists of the current
             * character as the low 5 bits and the high 3 bits coming
             * from the low 3 bits of the current printing mode.
             */

            ch[i] += (single_mode & 0x03) << 5;
	    param[0]=ch[i];
            print_char();
            single_mode = print_mode;
        }
    }
}

void
set_score()
{
#ifdef USE_OCC	      
    extern print_buf_t  *pbf_p;
/* set_score should not modify param[0], so we save and restore its value */
/* set_score is called in functions which do not expect set_score to change param[0] */
    word save_param=param[0];
    
   /* For ORIC PORT we'll print status from this function directly... */
    register unsigned info1;
    register unsigned info2;
    char c;

    /*
     * Set the description
     */
    pbf_p = &room;
    room.len = 1;
    param[0]=load_var(0x10);
    p_obj();
    room.buf[room.len] = '\0';
    pbf_p = &thetext;

    /*
     * Fill in the score or time fields...
     */
   info1 = load_var(0x11);
   info2 = load_var(0x12);
 
	 /* Delete status line */
     for(c=0; c<40; c++) *(byte *)(48000+c)=32;

    if (F1_IS_SET(B_USE_TIME))
    {
	   if(info2<10) c=48; else c=0;
	   stprintf("\02 Time: %d:%c%d -%s ",info1,c,info2,(char *)room.buf);
    }
    else
	 {
		/* ORIC PORT: Here when the moves were > MAX_MOVES the string to print was
		 * GST and not Score... What does it mean?. */
		stprintf("\02 Score: %d Moves: %d -%s ",(short int)info1, info2, (char  *)room.buf);
	 }

    param[0]=save_param;
#endif
}
