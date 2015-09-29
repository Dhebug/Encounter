/*
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
*/

/* Sound effects header file */

/* Main definitions for sound routines */

#define ayc_Register $FF
#define ayc_Write    $FD
#define ayc_Inactive $DD


#define AY_AToneLSB		0
#define AY_AToneMSB		1
#define AY_BToneLSB		2
#define AY_BToneMSB		3
#define AY_CToneLSB		4
#define AY_CToneMSB		5
#define AY_Noise		6
#define AY_Status		7
#define AY_AAmplitude	8
#define AY_BAmplitude	9
#define AY_CAmplitude	10
#define AY_EnvelopeLSB	11
#define AY_EnvelopeMSB	12
#define AY_EnvelopeCy	13
#define AY_IOPort		14



/* Commands available in a pattern list (channel in a song) */
#define END 	%10000000
#define ENV 	%10000001
#define ORN 	%10000010
#define NON 	%10000011
#define NOFF	%10000100
#define TON		%10000101
#define TOFF	%10000110
#define NVAL	%10000111
#define NOFFSET %10001000
#define LOOP	%10001001
#define SETVOL 	%10001010
#define WAITFLG %10001011

/* Commands available inside a pattern */

#define END 	%10000000
#define RST 	%10010000
#define SIL 	%10100000
#define PNON 	%10110000
#define PNOFF	%11000000
#define PTON	%11010000
#define PTOFF	%11100000

/* Notes */
#define C_	0
#define CS_	1
#define D_	2
#define DS_	3
#define E_	4
#define F_	5
#define FS_	6
#define G_	7
#define GS_	8
#define A_	9
#define AS_	10
#define B_	11

/* ADSHR hold index */
#define HOLD_TEMPO 3