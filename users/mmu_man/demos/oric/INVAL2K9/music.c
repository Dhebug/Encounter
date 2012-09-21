/* -*- c-basic-offset: 8 -*-
 * (c) 2008, Francois Revol <revol@free.fr>
 *
 */

#include "global.h"
#include "stdlib.h"
//#include "oric.h"
//#include "sys/sound.h"

#define CHAN_1   1
#define CHAN_2   2
#define CHAN_3   3

/* octave 0-7 */

#define NOTE_DO    1
#define NOTE_DO_D  2
#define NOTE_RE    3
#define NOTE_RE_D  4
#define NOTE_MI    5
#define NOTE_FA    6
#define NOTE_FA_D  7
#define NOTE_SOL   8
#define NOTE_SOL_D 9
#define NOTE_LA   10
#define NOTE_LA_D 11
#define NOTE_SI   12


#define DV 10

/* notes/line */
#define NNOTES 3

#define PL(n1,n2,n3) { n1, n2, n3 }
//#define PL(n1,n2,n3) { n1, n2 }
//#define PL(n1,n2,n3) { n1 }


#define TIMER_A 0x276
#define TIMER_M 0xfc
//#define TIMER_A VIA_T1CL
//#define TIMER_M 0x80
//#define TIMER_A VIA_T1CH
//#define TIMER_M 0xf0
//#define TIMER_A VIA_T2CL
//#define TIMER_M 0x80



void chain_irq_handler( void (*handler)(void) );
void do_music(void);

struct _note {
	char o;
	char n;
	char v;
};

struct _line {
	struct _note notes[NNOTES];
};

struct _pattern {
	struct _note n[64][NNOTES];
	//struct _line lines[64];
};

struct _mod {
	int count;
	struct _pattern *patterns;
};

/*
struct foo {
	int n[2][3];
};

struct foo gFoo[] = { { { { 0, 1, 2}, { 0, 1, 2} } } };
*/

#define N(o,n,v) o,n,v

/* empty note */
#define EN N(0,0,0)
/* keep note */
#define KN N(0,-1,0)

struct _pattern kNumerica2Patterns[] = {
	{
		{

			//N(4,8,DV)
			//N(4,7,DV)
			//N(4,5,DV)
			//N(4,7,DV)
			//N(4,8,DV)
			//N(4,3,DV)
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(N(4,3,DV), N(2,8,DV), EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, EN, EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(N(4,3,DV), N(2,8,DV), EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, EN, EN),

			//
			//
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,10,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(N(4,3,DV), N(2,8,DV), EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,11,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, EN, EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,12,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(N(4,3,DV), N(2,8,DV), EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,12,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),

			PL(KN, EN, EN), //MUTE
			//
		}
	},
	{
		{

			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(N(4,3,DV), N(2,8,DV), EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, EN, EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(N(4,3,DV), N(2,8,DV), EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, EN, EN),

			//
			//
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(N(4,3,DV), N(2,8,DV), EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, EN, EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(N(4,3,DV), N(2,8,DV), EN),
			//
			PL(N(4,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(4,7,DV), EN, EN),
			PL(N(4,5,DV), EN, EN),
			PL(N(4,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(4,8,DV), N(2,8,DV), EN),

			PL(KN, EN, EN), //MUTE
			//
		}
	},
	{
		{

			//
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(5,7,DV), EN, EN),
			PL(N(5,5,DV), EN, EN),
			PL(N(5,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(N(5,3,DV), N(2,8,DV), EN),
			//
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(5,7,DV), EN, EN),
			PL(N(5,5,DV), EN, EN),
			PL(N(5,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, EN, EN),
			//
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(5,7,DV), EN, EN),
			PL(N(5,5,DV), EN, EN),
			PL(N(5,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(N(5,3,DV), N(2,8,DV), EN),
			//
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(5,7,DV), EN, EN),
			PL(N(5,5,DV), EN, EN),
			PL(N(5,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, EN, EN),
			//
			//
			//
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(5,7,DV), EN, EN),
			PL(N(5,5,DV), EN, EN),
			PL(N(5,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(N(5,3,DV), N(2,8,DV), EN),
			//
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(5,7,DV), EN, EN),
			PL(N(5,5,DV), EN, EN),
			PL(N(5,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, EN, EN),
			//
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(5,7,DV), EN, EN),
			PL(N(5,5,DV), EN, EN),
			PL(N(5,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(N(5,3,DV), N(2,8,DV), EN),
			//
			PL(N(5,8,DV), N(2,8,DV), EN),
			PL(KN, KN, EN),
			PL(N(5,7,DV), EN, EN),
			PL(N(5,5,DV), EN, EN),
			PL(N(5,7,DV), N(2,7,DV), EN),
			PL(KN, EN, EN),
			PL(N(5,8,DV), N(2,8,DV), EN),

			PL(KN, EN, EN), //MUTE
			//
		}
	}
};

struct _mod kNumerica2Mod = {
	sizeof(kNumerica2Patterns) / sizeof(struct _pattern),
	kNumerica2Patterns
};



#if 0
struct _pattern kStarTrekPatterns[1] = {
	{
		{
			//
			PL(N(3, NOTE_RE_D, DV), EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			//
			PL(N(3, NOTE_LA_D, DV), EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(N(4, NOTE_RE_D, DV), EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			//
			PL(N(4, NOTE_DO_D, DV), EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			PL(KN, EN, EN),
			//
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			//
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			//
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			//
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			//
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN),
			PL(EN, EN, EN)
		}}
};

struct _mod kStarTrekMod = {
	sizeof(kStarTrekPatterns) / sizeof(struct _pattern),
	kStarTrekPatterns
};
#endif

#if 0
struct _pattern kSsPatterns[] = {
	{
		{
			// Solskogen invitro melody:
			//N(3,11,DV)
			//N(4,1,DV)
			//N(4,2,DV)
			//N(3,7,DV)
			//N(4,2,DV)
			//N(4,1,DV)
			//
			PL(N(3,11,DV), N(0,11,DV), EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(4,1,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(4,2,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,7,DV), N(0,7,DV), EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(4,2,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(4,1,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,11,DV), N(0,9,DV), EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),

			PL(N(4,1,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(4,2,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(4,4,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,9,DV), N(0,6,DV), EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(EN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(EN, EN, EN), //MUTE
		}
	}
};

struct _mod kSsMod = {
	sizeof(kSsPatterns) / sizeof(struct _pattern),
	kSsPatterns
};

struct _pattern kVipPatterns[] = {
	{
		{
			// 8 1 4 9
			// 8 1 4 9 8 6 4
			//
			PL(N(3,8,DV), N(2,2,DV), EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,1,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,4,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,9,DV), N(2,2,DV), EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(KN, EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,8,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,1,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,4,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,9,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,8,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,6,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,4,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
		}
#if 1
	},
	{
		{
			//
			PL(N(3,8,DV), N(2,2,DV), EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,1,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,4,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,9,DV), N(2,2,DV), EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(KN, EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,8,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,9,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,8,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,4,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,1,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),

		}
#endif
#if 1
	},
	{
		{
			// 8 1 4 9
			// 8 1 4 9 8 6 4
			//
			PL(N(3,8,DV), N(2,2,DV), EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,1,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,4,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,9,DV), N(2,2,DV), N(5,1,DV)),
			PL(KN, KN, KN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, N(6,1,DV)),
			PL(KN, KN, KN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(KN, EN, N(5,1,DV)),
			PL(KN, KN, KN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, N(5,8,DV)),
			PL(KN, KN, KN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,8,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,1,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,4,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,9,DV), EN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,8,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			//
			PL(N(3,6,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(N(3,4,DV), KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
			PL(KN, KN, EN),
		}
	
#endif
	}
};

struct _mod kVipMod = {
	sizeof(kVipPatterns) / sizeof(struct _pattern),
	kVipPatterns
};
#endif

struct _player {
	struct _mod *mod;
	char pat;
	char line;
	unsigned char old; // old counter
	char once;
};

static struct _player gPlayer;

static char cpter = 0;

extern void MusicIrq(void);
void handler(void)
{
	//do_music();
	//return;
	if (cpter++ & 0x01 == 0) {
		char vol = 14;
		char oct = 3;
		if (!gPlayer.mod)
			return;
		
		music(1,oct,4,vol);
		//do_music();
	}
}


void music_start(void)
{
	play(7,0,0,0);
	play(7,0,1,3);
	//chain_irq_handler(handler);
	//install_irq_handler(handler);
}

int music_done_once(void)
{
	return gPlayer.once;
}


/* void music_slice(void) */
/* { */
/* 	unsigned char c; */
/* 	unsigned char t; */
/* 	struct _note *n; */
/* 	c = gPlayer.old; */
/* 	t = (*(unsigned char *)TIMER_A) & TIMER_M; */
/* 	if (t == c) */
/* 		return; */
/* 	if (!gPlayer.mod) */
/* 		return; */
/* 	if (t > c) { */
/* 		// next pattern */
/* 		gPlayer.pat++; */
/* 		if (gPlayer.pat >= gPlayer.mod->count) */
/* 			gPlayer.pat = 0; */
/* 	} */
/* 	gPlayer.old = t; */
/* 	gPlayer.line = (256-t) >> 2; */
/* 	printf("%d %d:%d\t", t, gPlayer.pat, gPlayer.line); */
/* 	n = gPlayer.mod->patterns[gPlayer.pat].n[gPlayer.line]; */
/* 	for (c = 0; c < NNOTES; c++) { */
/* 		//printf("{%d, %d, %d} ", n[c].o, n[c].n, n[c].v); */
/* 		if (n[c].n) */
/* 			music(c+1, n[c].o, n[c].n, n[c].v); */
/* 	} */
/* 	printf("\n"); */
/* } */


void music_slice(void)
{
	unsigned char c;
	unsigned char t;
	struct _note *n;
	c = gPlayer.old;
	t = (*(uint8 *)TIMER_A) & TIMER_M;


	//if ((*(uint8 *)VIA_T2CL) & 0x80)
	if (t == c) {
#ifdef DEBUG_MUSIC
		dash_music_early();
#endif
		return;
	}
	//while (!((*(uint8 *)VIA_T2CL) & 0x80));
	//	t = timer_sync();
	gPlayer.old = t;

	if (!gPlayer.mod)
		return;
#ifdef DEBUG_MUSIC
	dash_music_slice(gPlayer.pat, gPlayer.line);
#endif

	//printf("%d %d:%d\t", t, gPlayer.pat, gPlayer.line);
	n = gPlayer.mod->patterns[gPlayer.pat].n[gPlayer.line];
	//RestoreInterrupt();
	for (c = 0; c < 3; c++) {
		//printf("{%d, %d, %d} ", n[c].o, n[c].n, n[c].v);
		
		if (n[c].n > 0)
			music(c+1, n[c].o, n[c].n, n[c].v);
		else if (n[c].n == 0)
			/* play a real note with vol 0 to mute... */
			music(c+1, 0, 1, 0);
	}
	//StopInterrupt();

	gPlayer.line = (gPlayer.line + 1) & 0x3f;
	
	if (gPlayer.line == 0) {
		// next pattern
		gPlayer.pat = (gPlayer.pat + 1) % gPlayer.mod->count;
		if (gPlayer.pat == 0)
			gPlayer.once = 1;
	}

	//printf("\n");
}

void music_till_once(void)
{
	while (!gPlayer.once)
		music_slice();
}


void music_till_end_pat(void)
{
	do
		music_slice();
	while (gPlayer.line);
}

void music_till_end(void)
{
	do
		music_slice();
	while (gPlayer.pat || gPlayer.line);
}

int music_is_end_pat(void)
{
	return !gPlayer.line;
}

int music_is_end(void)
{
	return !(gPlayer.pat || gPlayer.line);
}



void music_set(struct _mod *mod)
{
	gPlayer.mod = NULL;
	gPlayer.pat = 0;
	gPlayer.line = 0;
	gPlayer.mod = mod;
	gPlayer.once = 0;
	// sync with timer
	//while (*(char *)TIMER_A & TIMER_M);
}

void music_set_ss(void)
{
}

void music_set_1(void)
{
	music_set(&kNumerica2Mod);
}

void music_set_2(void)
{
	//music_set(&kStarTrekMod);
	//music_set(&kVipMod);
}

void do_music(void)
{
	char vol = 14;
	char oct = 3;
	music(1,oct,4,vol);
}



void music_end(void)
{
	//uninstall_irq_handler();
	/* must be some reason I had that in older code*/
	music(1,0,0,0);
	music(0,0,0,0);
	play(0,0,0,0);
	play(1,0,0,0);
	play(0,0,0,0);
	/* Euphoric+XP: bloody NTVDM stays noisy... */
	kbdclick1();
}

