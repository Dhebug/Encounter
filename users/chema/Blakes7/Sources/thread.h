/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

/* Definitions for threads */

#define MAX_THREADS 		16

#define TH_STATE_EMPTY		0
#define TH_STATE_RUNNING	1
#define TH_STATE_PENDED		2
#define TH_STATE_DELAYED	3
#define TH_STATE_FROZEN		4
#define TH_STATE_WAITING	5

