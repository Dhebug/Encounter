/* stdlib.h */

#ifndef _STDLIB_

#define _STDLIB_


#ifdef __OLD__

#include <old/stdlib.h>

#else


/* Include alloc.h, the memory allocation functions. */

#include <alloc.h>



/* The NULL pointer. */

#define NULL ((void*)0x0000)


/* Exit the program. Return an exit code of retval. */

   /* retval is currently ignored on the Oric. The */
   /* operating system has no need for it.         */

extern void exit(int retval);


/* Convert an integer i to a string */

extern char *itoa(int i);

/* random generator */

#define RAND_MAX 32767

int rand(void);
int random(void);    /* rand and random are the same function */

int srandom(int seed); /* initialize the random generator */

#endif /* __OLD__ */

#endif /* _STDLIB_ */

/* end of file stdlib.h */
