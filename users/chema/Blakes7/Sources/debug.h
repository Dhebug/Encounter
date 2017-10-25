/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

/* Debugging errors and codes */

// Level A (correct facing directions when moving, for instance)
#ifdef DOCHECKS_A
#endif
	

// Catch engine exceptions (no memory...)
#ifdef DOCHECKS_B
#define ERR_UNKNOWN 		0
#define ERR_NOMEMORY		1
#define ERR_NOTHREAD		2
#define ERR_NOTWALKBOX		3
#define ERR_NOROOMOBJ		4
#define ERR_NOSCRIPT		5
#define ERR_WRONGREFS		6
#endif

// Catch some basic scripting exceptions
#ifdef DOCHECKS_C
#define ERR_UNKWOWN		0
#define ERR_NORESOURCE 		1
#define ERR_NOACTOR		2
#define ERR_UNDEFOPCODE		3
#define ERR_NOWALKBOX		4
#endif
