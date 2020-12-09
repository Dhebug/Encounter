#ifndef DEFINES_H
#define DEFINES_H

/*#define TRACE*/

#define NEED_ERRNO
#define NO_STRERROR
#define NO_SIGNALS
#define NO_RANDOM

#define BUFMIN              80

#ifdef USE_OCC
/* Compiling for real Oric: define mem constants... */

extern char _endcode;
/* Base of free memory..*/
#define ORIC_BASE_MEM (&_endcode)
/* End of free memory */
#define ORIC_HIMEM 0xb500
/* Overlay ram */
#define OVERLAY_START 0xD200
/* text buffer */
#define TEXT_BUFFER_SIZE 1024

#endif

#endif /* DEFINES_H */
