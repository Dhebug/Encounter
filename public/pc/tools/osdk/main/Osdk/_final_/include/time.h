/* time.h */

#ifndef _TIME_
#define _TIME_

#ifndef NULL
#define NULL (0)	/* for contiki */
#endif


typedef unsigned clock_t;

#define CLOCKS_PER_SEC 100
#define CLK_TCK 100 /* For contiki */

/* clock returns the number of clock ticks since an arbitrary time.
	This is useful for measuring the time elapsed since an earlier call.
	E.g:
		clock_t TIME0, TIME1;

		TIME0 = clock();
		....
		TIME1 = clock();
		printf("duration : %fs\n", (double)( TIME1-TIME0 ) / CLOCKS_PER_SEC);
*/

clock_t clock();
#endif /* _TIME_ */