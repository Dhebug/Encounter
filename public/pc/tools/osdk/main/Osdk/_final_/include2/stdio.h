/* stdio.h */

#ifndef _STDIO_

#define _STDIO_

#ifndef NULL
#define NULL (0)	/* for contiki */
#endif

/* Print a character on the screen */

extern void putchar(char c);

/* Get a character from the keyboard (and echo it) */
/* Note: there's no keyboard buffer for this routine, it waits until the
        user emits an ascii char */

extern int getchar(void);

/* Print a string on the screen */
/* This is the prefered way for outputting a message to the screen, the
        routine is much smaller than 'printf/sprintf' */

extern void puts(char *s);

/* Get a line from the keyboard */
/* Like 'puts', the routine is much smaller than 'scanf/sscanf' */
/* Note: the Del key is active, allowing limited editing. All control chars
        except Return are rejected */
/* Caution: nothing prevents the user to exceed the buffer space, so this
        implementation has been limited to a 256-bytes entry : this way, a
        256-bytes buffer will never be exceeded */

extern void gets(char buf[]);


/* Format and print to standard output */
/* Allowed specifiers are :
        %c : character image
        %d : integer value
        %f : floating point value (note: the printed value may be an integer
                if the value has no fractional part)
        %s : string
        %x : hexadecimal value
*/

extern void printf(const char *format,...);

/* Format and print to a buffer */

extern void sprintf(char buf[], const char *format,...);

/* Scan formatted data from the keyboard */
/* Note: this is implemented as a 'gets' followed by a 'sscanf'. An internal
        256-bytes buffer is used for gets, which will only read one line.
        This means 'scanf' will only parse one entry line. Also, extra
        data won't be retained for future scans */

extern int scanf(const char *format,...);

/* Scan formatted data from a string */

extern int sscanf(char buf[], const char *format,...);

#endif /* _STDIO_ */

/* end of file */

