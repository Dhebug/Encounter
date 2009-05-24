/* sys/oric.h */

/* Contains Oric platform-specific stuff, like */
/* pointers to memory areas (video RAM etc).   */

#ifndef _SYS_ORIC_

#define _SYS_ORIC_

#include <stdlib.h>


extern char *sbrk();
extern char *brk();


/* Pointers to memory areas. */

static const char *mem[65536]=(char*)NULL;    /* The whole memory */


/* PEEK, POKE, DEEK, DOKE */

#define peek(a) mem[a]
#define deek(a) (* (int *)(mem+a))

#define poke(a,x) (mem[a]=(x))
#define doke(a,x) (* (int *)(mem+a) = (x))


/* Get and set the system flags at 0x26a. */

#define CURSOR     0x01  /* Cursor on             (ctrl-q) */
#define SCREEN     0x02  /* Printout to screen on (ctrl-s) */
#define NOKEYCLICK 0x08  /* Turn keyclick off     (ctrl-f) */
#define PROTECT    0x20  /* Protect columns 0-1   (ctrl-]) */

#define getflags()  peek(0x26a)

#define setflags(x) poke(0x26a,x)


/* Get memory size */

#define ORIC16k      1
#define ORIC48k      0

#define getmemsize() peek(0x220)

/* call machine code routines */

void call(int address);

/* invoke '!' handler : argument is the string which is interpreted by
	the handler. This can be used to call Sedoric/Oricdos routines. E.g :
		
			bang("SAVE\"CHARSET.CHR\",A#B400,E#B7FF") 
*/

void bang(char *command);

/* Outputting to the printer : 
	as file access routines are not available yet, this is done with
	printf-like command */

lprintf(const char *format,...);

/* Installing a IRQ handler */

void install_irq_handler( void *handler() );

/* Chaining a handler to the current IRQ handler : the newly added
	routine will be invoked first */

void chain_irq_handler( void *handler() );

/* Uninstalling a IRQ handler : this will remove the latest added handler */

void uninstall_irq_handler();

#endif /* _SYS_ORIC */

/* end of file sys/oric.h */

