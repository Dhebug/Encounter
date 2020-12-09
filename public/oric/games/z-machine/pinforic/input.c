/* input.c
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
 * $Header: RCS/input.c,v 3.0 1992/10/21 16:56:19 pds Stab $
 */

#include <string.h>
/*#include <errno.h>*/
#include <ctype.h>

#include "infocom.h"

#ifdef NEED_ERRNO
extern int errno;
#endif

extern header_t data_head;

word    coded[2];
#if 0
static word
convert (char ch)
{
    extern char     table[];

    register char            *ptr;
    register word            code;

    ptr = table;
    while ((*ptr != ch) && (*ptr != 0))
        ++ptr;
    if (*ptr == 0)
        return (0);
    code = (ptr - table) + 6;
    while (code >= 0x20)
        code -= 0x1A;
    return (code);
}
#endif
#if 0
static word
find_mode (char ch)
{
    if (ch == 0)
        return (3);
    if ((ch >= 'a') && (ch <= 'z'))
        return (0);
    if ((ch >= 'A') && (ch <= 'Z'))
        return (1);
    return (2);
}
#endif

void encode (byte* the_word)
{

    extern char     table[];
   
    word    data[6];
    word    mode;
    word    offset;
    register byte    *ptr;
    register byte    ch;
    register int     count;
    register char    *ptr2;
   
    count = 0;
    ptr = the_word;
    while (count < 6)
    {
        ch = *ptr++;
        if (!ch)
        {
            /* Finished, so fill with blanks */

            while (count < 6)
                data[count++] = 5;
        }
        else
        {
            /* Get Character Print-Mode */
		   if (!ch ) mode=3;
		   else
			 if ((ch >= 'a') && (ch <= 'z')) mode=0;
		     else 
			   if ((ch >= 'A') && (ch <= 'Z')) mode=1;
		     else mode=2;
 
            if (mode)
                data[count++] = mode + 3;

            /* Get offset of character in Table[] */

            if (count < 6)
			 {
			   ptr2 = table;
			   while ((*ptr2 != ch) && (*ptr2 ))
				 ++ptr2;
			   if (!*ptr2)
				 offset=0;
				else
				  {
					 offset = (ptr2 - table) + 6;
					 while (offset >= 0x20)
					   offset -= 0x1A;
				  }
				   
                if (!offset)
                {
                    /* Character not in Table[], so use ASCII */

                    data[count++] = 6;
                    if (count < 6)
                        data[count++] = ch >> 5;
                    if (count < 6)
                        data[count++] = ch & 0x1F;
                }
                else
                    data[count++] = offset;
            }
        }
    }

    /* Encrypt */

    coded[0] = (data[0] << 10) | (data[1] << 5) | data[2];
    coded[1] = (data[3] << 10) | (data[4] << 5) | data[5];
    coded[1] |= 0x8000;
}

static byte
*read_line (byte* prompt, byte* buffer)
{
    extern char script_fn[];
   
    register char *cp;

    set_score();

    cp = (char *)&(buffer[1]);
    scr_getline((char *)prompt, *buffer, cp);
   
    /*
     * Lowercase all the input, then return a ptr to the end of the
     * buffer.  ANSI C tolower() accepts non-uppercase chars and does
     * the right thing, but not everyone does...
     */

    for (; *cp != '\0'; ++cp)
        *cp = tolower((int)*cp);


    /*
     * If we're not already scripting and the command is not "script"
     * we're done.  Otherwise call scr_open_sf().  If it succeeds,
     * we're done.  If not, print a failure and get a new command
     */
    
    /* ORIC_PORT: With Oric no scripting avaliable... 
     *            Code was removed. 
     */
   
    return ((byte *)cp);
}

#ifndef USE_OCC
static void
look_up (byte* the_word, byte* word_ptr)
{
    extern word     num_vocab_words;
    extern word     vocab_entry_size;
    extern byte     *base_ptr;
    extern byte     *strt_vocab_table;
    extern byte     *end_vocab_table;
    extern byte     *vocab;

    register byte    *vocab_strt;
    register byte    *v_ptr;
    register word    first;
    register word    second;
    register word    shift;
    register word    chop;
    register word    offset;
    Bool             found;

    encode(the_word);

    shift = num_vocab_words;
    chop = vocab_entry_size;
    shift >>= 1;
    do
    {
        chop <<= 1;
        shift >>= 1;
    }
    while (shift);
    vocab_strt = strt_vocab_table + chop - vocab_entry_size;

    found = 0;
    do
    {
        chop >>= 1;
        v_ptr = vocab_strt;
        first = Z_TO_WORD_I(v_ptr);
        if (first == coded[0])
        {
            second = Z_TO_WORD_I(v_ptr);
            if (second == coded[1])
                found = 1;
            else
            {
                if (coded[1] > second)
                {
                    vocab_strt += chop;
                    if (vocab_strt > end_vocab_table)
                        vocab_strt = end_vocab_table;
                }
                else
                    vocab_strt -= chop;
            }
        }
        else
        {
            if (coded[0] > first)
            {
                vocab_strt += chop;
                if (vocab_strt > end_vocab_table)
                    vocab_strt = end_vocab_table;
            }
            else
                vocab_strt -= chop;
        }
    }
    while ((chop >= vocab_entry_size) && (!found));

    if (!found) offset = 0;
    else
	offset = vocab_strt - base_ptr;
    
    *(word_ptr + 1) = (byte)offset;
    *word_ptr = (byte)(offset >> 8);

}
#endif


static void
parse (byte* inb_strt, byte* inb_end, byte* word_buff_strt)
{
    extern byte      *wsbf_strt;
    extern byte      *end_of_sentence;

    byte             *last_word;
    register byte    *word_ptr;
    register byte    *char_ptr;
    register byte    *ws;
    byte             the_word[8];
    register byte    word_count;
    register byte    ch;
    register int     i;
    register Bool    white_space;
    
    
    word_count = 0;
    char_ptr = inb_strt + 1;
    word_ptr = word_buff_strt + 2;
    i = 0;
    while ((char_ptr != inb_end) || (i))
    {
        i = 0;
        last_word = char_ptr;
        white_space = 0;

        while ((char_ptr != inb_end) && (!white_space))
        {
            ch = *char_ptr++;
            ws = wsbf_strt;
            while ((*ws != ch) && (*ws != '\0'))
			 ++ws;
			 		   
            if (*ws == ch)
            {
			   white_space = 1;
			   if (i != 0)
				 --char_ptr;
			   if ((i == 0) && (ws < end_of_sentence))
				 the_word[i++] = ch;
            }
            else
            {
                if (i < 6)
                    the_word[i++] = ch;
            }
        }

        if (i)
        {
           /* First byte of buffer contains the buffer length */
		   ++word_count;
		   *(word_ptr + 2) = (byte)(char_ptr - last_word);
		   *(word_ptr + 3) = (byte)(last_word - inb_strt);
		   the_word[i] = 0;

		   look_up(the_word, word_ptr);
		   word_ptr += 4;
        }
    }

   word_buff_strt[1] = word_count;

}

void
input ()
{
    extern print_buf_t  *pbf_p;
    extern byte         *base_ptr;
    extern word          param[];
    register byte       *inb_strt;
    register byte       *inb_end;

#ifdef USE_OCC
    byte * p;
    byte * q;
    word char_offset=param[0];
    word word_offset=param[1];
    extern byte   * global_ptr;
#endif

    /*
     * Get an input line and parse it
     */
    pbf_p->buf[pbf_p->len] = '\0';
   
    /* ORIC PORT: HEY!!! here char_offset & word_offset
	 * have values that will make the pointer inb_strt
	 * fall in the variable zone, which is here in 
	 * overlay ram... (There could be more like this...)
	 */
#ifdef USE_OCC
    inb_strt = base_ptr + char_offset;
    inb_end = read_line(pbf_p->buf, inb_strt);
    parse(inb_strt, inb_end, base_ptr + word_offset);
#else
    inb_strt = base_ptr + param[0];
    inb_end = read_line(pbf_p->buf, inb_strt);
    parse(inb_strt, inb_end, base_ptr + param[1]);
#endif
    pbf_p->len = 0;
}
