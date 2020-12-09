/* oric.c
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
 * $Header: RCS/oric.c,v 3.0 1992/10/21 16:56:19 pds Stab $
 */

#include <stdio.h>
#include <string.h>

#include "infocom.h"

/* ORIC PORT: This is the source for managing screen input and output, and
 * other OS-dependant functions
 * With Oric some variables and functions are not used, so they are commented
 * out or just deleted to make the program smaller.
 */

short scr_lineco;
int scr_columns=40;
 
#ifndef ASSEMBLY


/* This function stands for a macro from infocom.h and tries to save
 * some bytes (though slow down the program). And it *does* save bytes!
 */
 
word Z_TO_WORD(byte * p)
 {
	return ((word)(((*(p)&0xff)<<8)+((p)[1]&0xff)));
 }

/* In Real Oric executable, this function is written in assembler, and
 * included in support.asm
 */
byte next_byte()
 {
	extern word pc_offset; 
	extern byte *prog_block_ptr;
   
	register byte res=Z_TO_BYTE(prog_block_ptr+pc_offset++);
	if(pc_offset==BLOCK_SIZE) fix_pc();
	return res;
 }
#endif
  
/*
 * This is a function to print a buffer.  If flags==0 then
 * print with paging and a final newline.  If flags & 1 then print
 * without paging.  If flags & 2 then print up to but not including
 * the last lineful, and return a pointer to it (a prompt).
 */
#define PB_NO_PAGING    (0x01)
#define PB_PROMPT       (0x02)

const char *
scr_putbuf (int flags, const char * buf)
{
    register const char *sp;
    register const char *ptr;
    register int i;

    for (sp = buf; ;)
    {
	 
	/*
	 * Find the current length; if it's <= max already then we're done.
	 */
	   if ((i = strlen((char *)sp)) <= scr_columns)
		 ptr=&sp[i];
	   else
		 {
			/*
			 * Find the last space at or before buf[max]
			 */
		for (ptr = &sp[scr_columns-1]; (*ptr != ' ') && (ptr > sp); --ptr);
			
		 }
	   
			
       if ( (*ptr) || !(flags & PB_PROMPT))
       {
		const char *p;
		if ( (scr_lineco++ >= 25))
		  {
                   printf("\033D--More--\r");
                   mygetchar();
                   putchar('\016');
		   scr_lineco = 0;
                  }

           for (p = sp; p < ptr; ++p) putchar(*p);

           printf("\n");
        }

        if (!(*ptr))
            break;

        sp = ptr + 1;
    }

    return (sp);
}


/*
 * Function:    scr_putline()
 *
 * Arguments:
 *      buffer          Line to be printed.
 *
 * Description:
 *      This function is passed a nul-terminated string and it should
 *      display the string on the terminal.  It will *not* contain a
 *      newline character.
 *
 *      This function should perform whatever wrapping, paging, etc.
 *      is necessary, print the string, and generate a final linefeed.
 *
 *      If the TI supports proportional-width fonts,
 *      F2_IS_SET(B_FIXED_FONT) should be checked as appropriate.
 *
 *      If the TI supports scripting, F2_IS_SET(B_SCRIPTING) should be
 *      checked as appropriate.
 */
#ifndef USE_OCC
void
scr_putline (const char * buffer)
{
    scr_putbuf(!gflags.paged, buffer);
}
#endif


/*
 * Function:    scr_getline()
 *
 * Arguments:
 *      prompt    - prompt to be printed
 *      length    - total size of BUFFER
 *      buffer    - buffer to return nul-terminated response in
 *
 * Returns:
 *      # of chars stored in BUFFER
 *
 * Description:
 *      Reads a line of input and returns it.  Handles all "special
 *      operations" such as readline history support, shell escapes,
 *      etc. invisibly to the caller.  Note that the returned BUFFER
 *      will be at most LENGTH-1 chars long because the last char will
 *      always be the nul character.
 *
 *      If the command begins with ESC_CHAR then it's an interpreter
 *      escape command; call ti_escape() with the rest of the line,
 *      then ask for another command.
 *
 * Notes:
 *      May print the STATUS buffer more than once if necessary (i.e.,
 *      a shell escape messed up the screen, a history listing was
 *      generated, etc.).
 */
int
scr_getline ( const char * prompt,
              int          length,
              char *       buffer )
{
    register const char *pp;
    register unsigned char cp,c;
   
    scr_lineco = 0;

   /* 
	* Print all the prompt except the last line
 	*/
    pp = scr_putbuf(PB_PROMPT, prompt);
   
   /*
	* Print prompt and read user input
	*/
   
    printf(pp);

    buffer[0] = '\0';
    buffer[length-2] = '\0';

#ifdef USE_OCC
    putchar(17);
    putchar(129);

   /* This fucntion gets a string from the user. I found it in the sources
	* of Alexio's Font Editor. When testing under Linux this is not used and 
	* it's replaced whith standard functions.
	*/   
     for(buffer[cp=0]=c=0;(c!=13);){
          switch(c=mygetchar()){
		       case 127:
                    if(cp){
                         cp--;
                         putchar(c);
                    }
                    break;
               case 20:
               case 13:
                    break;
               default:
                    if(c>31){
                         buffer[cp]=c;
                         cp++;
                         putchar(c);
                    }
                               else putchar(7);
          }
     }
    putchar(135);
    printf("\n");
    buffer[cp]=0;
    putchar(17);

    return cp;
#else
    fgets(buffer, length, stdin); 
   /*
	* Punt the last \n...
	*/
   length = strlen(buffer) - 1;
   buffer[length] = '\0';
   return (length);
#endif

}

void bell(void)
{
        putchar(7);
}
