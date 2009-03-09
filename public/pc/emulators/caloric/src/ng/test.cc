/* AYM 2003-08-23 */

/* Compiled with -O3, takes about 1.7 s.
   Compiled with -fomit-frame-pointer, takes about 1.4 s.
   This means about 0.15 s to go perform 1 million function calls.
   Max speed = 6x. */


#include <stdio.h>


static unsigned long calls;

static void func ()
{
  calls++;
}


int main (int argc, char *argv[])
{
  const unsigned long million = 1000000;
  static void (*funcvector[10])();

  for (unsigned long f = 0; f < sizeof funcvector / sizeof *funcvector; f++)
    funcvector[f] = func;

  for (unsigned long n = 10 * million; n != 0; n--)
  {
    funcvector[0] ();
    funcvector[1] ();
    funcvector[2] ();
    funcvector[3] ();
    funcvector[4] ();
    funcvector[5] ();
    funcvector[6] ();
    funcvector[7] ();
    funcvector[8] ();
    funcvector[9] ();
  }

  printf ("%lu function calls\n", calls);
}


