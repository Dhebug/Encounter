/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

/* Definition of verbs (user actions) */

/* The verb menu is arranged as
 GIVE  PICK UP USE 
 OPEN  LOOK AT PUSH 
 CLOSE TALK TO PULL 
 despite the languaje used. Verbs are
 numbered from 0 to 8 (from left to right, 
 top to bottom). Verb #9 is Walk To
 */
 
#define VERB_UNKNOWN 		$ff
#define VERB_GIVE		0
#define VERB_PICKUP		1
#define VERB_USE		2
#define VERB_OPEN		3
#define VERB_LOOKAT		4
#define VERB_PUSH		5
#define VERB_CLOSE		6
#define VERB_TALKTO		7
#define VERB_PULL		8
#define VERB_WALKTO		9

/* Colors for selected/unselected/unusable verbs */
#define UNSEL_VERB_COLOR	6
#define SEL_VERB_COLOR		2
#define INACTIVE_VERB_COLOR	4


/* Character set size */
#define CHARSET_HEIGHT		8
#define CHARSET_WIDTH		6
