#ifndef TINE_H
#define TINE_H

#include "oobj3d/obj3d.h"

/* Some defines for TINE */

/* Maximum number of simultaneous ships */
#define MAXSHIPS MAXOBJS

/* Maximum number of simultaneous Vipers and Thargoids */
#define MAXCOPS	 2
#define MAXTHARG 1

/* Maximum number of simultaneous missiles (for AI ships)   */
#define MAX_MISSILES 2

/* Maximum number of objects in radar */
#define MAX_RADAR_POINTS 10

/* Number of stars (-1) */
#define NSTARS 15

/* Some definitions for frameskipping when rate ges too low */
/* Use the technique of drawing odd/all/odd/all... scans    */
//#define ALTSCANS

/* The next thresholds are in units of IRQs... now at 25hz  */
/* Threshold for alternate scan technique, the lower one	*/
#define MAXFRAMETIME1 8 
/* Threshold for complete frame skipping, the higher one    */
#ifdef ALTSCANS
#define MAXFRAMETIME2 (MAXFRAMETIME1+1)
#else
#define MAXFRAMETIME2 MAXFRAMETIME1
#endif


/* Uncomment to have debug values plotted on screen. 
   Default is frame duration */

//#define DBGVALUES

/* Use rolls based on a table, instead of directly the a_* values. 
   This permits a kind of exponential behaviour  */
#define TABBEDROLLS

/* Uncomment to have a real random generator */
#define REALRANDOM

/* Define to perform automatic RAMSAVE */
//#define RAMSAVE

/* Values for planet distance various thresholds */

#define PDIST_DOCK		$09
#define PDIST_MASSLOCK	$12
#define PDIST_TOOFAR	$60
#define PDIST_TOOFAR2	$70

/* Values for the _flags field */

#define IS_EXPLODING        1 
#define IS_DISAPPEARING     2 
#define IS_HYPERSPACING     4 
#define IS_DOCKING          8 
#define FLG_FLY_TO_PLANET   16
#define FLG_FLY_TO_HYPER    32
#define FLG_INNOCENT		64
#define FLG_HARD		   128	


/* Values for the _ai_state field */

#define IS_AICONTROLED     128

#define FLG_SLOW              1
#define FLG_BOLD              2
#define FLG_POLICE            4
#define FLG_DEFENCELESS       8 
#define FLG_TRADER			 16
#define FLG_BOUNTYHUNTER     32
#define FLG_PIRATE			 64



/* Values for _target field */

#define IS_ANGRY            128

/* Values for equipment (user Byte in OBJ3D record) */
#define HAS_ECM             1
#define HAS_MILLASER        2
#define HAS_ESCAPEPOD       4
#define HAS_ANTIRADAR       8
#define HAS_GALHYPER        16
#define HAS_SCOOPS          32
#define HAS_EXTRACARGO      64
#define HAS_ITEM3           128


/* Values for the _missile_armed variable */
#define ARMED				$ff
#define UNARMED				0


/* Damage for lasers (only player lasers) & missiles */
#define PULSE_LASER		4
#define BEAM_LASER		7
#define MILITARY_LASER	10

// This was $40 in the code ?
#define MISSILE_DAMAGE  40


// Position for some needed buffers

/* select where the space for object records starts...*/
#define OBS ($fffa-MAXOBJS*ObjSize)

#endif



