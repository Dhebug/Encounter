/* support.c
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
 * $Header: RCS/support.c,v 3.0 1992/10/21 16:56:19 pds Stab $
 */

#include <stdio.h>
#include "infocom.h"

#ifndef USE_OCC
ptr_t
xmalloc (unsigned int len)
{
#ifndef malloc
    extern ptr_t malloc();
#endif
    ptr_t p;
   
    if ((p = malloc(len)) == NULL)
    {
        extern void exit (int);

        printf("xmalloc(%ud): Out of memory!\n", len);
        exit(1);
    }

    return (p);
}

ptr_t
xrealloc (ptr_t p, unsigned int len)
{
#ifndef realloc
    extern ptr_t realloc();
#endif

    if ((p = realloc(p, len)) == NULL)
    {
        extern void exit (int);

        printf("xrealloc(%ud): Out of memory!\n", len);
        exit(1);
    }

    return (p);
}
#endif

void
change_status()
{
    extern header_t     data_head;
    extern print_buf_t  *pbf_p;
    extern word         save_blocks;
    extern word         pc_page;
    extern word         pc_offset;
    extern word         *stack_base;
    extern word         *stack_var_ptr;
    extern word         *stack;
    extern byte         *base_ptr;

    unsigned int i;
#define GAME_OFFSET     (data_head.game_o)

    if (gflags.game_state == RESTART_GAME)
        load_page(0, save_blocks, base_ptr);
   
    stack_var_ptr = stack_base;
    stack = --stack_var_ptr;

    pbf_p->len = 0;
    pc_page = GAME_OFFSET / BLOCK_SIZE;
    pc_offset = GAME_OFFSET % BLOCK_SIZE;
    fix_pc();
 
    gflags.game_state = PLAY_GAME;
}

void
restart()
{
    new_line();
    gflags.game_state = RESTART_GAME;
    change_status();
}

void
quit()
{
    extern void exit(int);

    if (gflags.game_state == NOT_INIT)
        exit(1);

    gflags.game_state = QUIT_GAME;
    scr_putline("");
#ifndef USE_OCC 
   close_file();
#endif
}

/* ORIC PORT: I think there will be no problem if we 
 * don't use verifying functions... Code was removed.
 */

#ifndef ASSEMBLY
void
store (word value)
{
    extern word *stack;

    register word var;

    var=NEXT_BYTE();
    if (!var)
        *(--stack) = value;
    else {
	param[0]=var; param[1]=value;
        put_var();
    }
}

void
ret_value (word result)
{
    extern word pc_offset;

    register word branch;

    branch=NEXT_BYTE();

    /* Test bit 7 */
    if ((branch & 0x80))
    {
        /* Clear bit 7 */
        branch &= 0x7F;
        ++result;
    }

    /* Test bit 6 */
    if (!(branch & 0x40))
    {
	   branch = (branch << 8) + NEXT_BYTE() ;
        /* Test bit D. If set, make branch negative. */
        if (branch & 0x2000)
            branch |= 0xC000;
    }
    else
        /* Clear bit 6 */
        branch &= 0xBF;

    if ((--result))
    {
        switch (branch)
        {
            case 0 :    rtn0();
                        break;
            case 1 :    rtn1();
                        break;
            default :   pc_offset += (branch - 2);
                        fix_pc();
        }
    }
}

byte
get_byte (word page, word offset)
{
   extern word      resident_blocks;
   extern byte     *base_ptr;
   extern header_t  data_head;
   extern byte     *global_ptr;
   extern byte     *vocab;
       
   byte *ptr;

   if (page < resident_blocks)
       	ptr = base_ptr+(page * BLOCK_SIZE) + offset;
   else
	ptr = fetch_page(page) + offset;
   
    return *ptr;
}

word
get_word (word page, word offset)
{
    word    temp;

    temp = get_byte(page, offset) << 8;
    offset++;
    if (offset==BLOCK_SIZE) {
	offset=0;
	page++;
    }
    return ((word)(temp + get_byte(page, offset)));
}

word
next_word()
{
    register word    temp;

    temp = NEXT_BYTE() << 8;   
    return ((word)(temp + NEXT_BYTE()));
}
#endif

