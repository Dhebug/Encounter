#ifndef TINE_H
#define TINE_H

/* Some defines for TINE */
/* Maximum number of simultaneous ships */

#define MAXSHIPS 20

//#define OLDROLLS

// Values for the _flags field

#define IS_EXPLODING        1 
#define IS_DISAPPEARING     2 
#define IS_HYPERSPACING     4 
#define IS_DOCKING          8 


// Values for the _ai_state field

#define IS_AICONTROLLED     128

#define FLG_FLY_TO_PLANET     1
#define FLG_FLY_TO_HYPER      2
#define FLG_SLOW              4
#define FLG_BOLD              8
#define FLG_POLICE           16
#define FLG_DEFENCELESS      32


// Values for _target field

#define IS_ANGRY            128

// Values for equipment (user Byte in OBJ3D record)
#define HAS_ECM             1
#define HAS_MILLASER        2
#define HAS_ESCAPEPOD       4
#define HAS_ANTIRADAR       8
#define HAS_GALHYPER        16
#define HAS_SCOOPS          32
#define HAS_EXTRACARGO      64
#define HAS_ITEM3           128


#endif



