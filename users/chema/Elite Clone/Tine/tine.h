#ifndef TINE_H
#define TINE_H

/* Some defines for TINE */
/* Maximum number of simultaneous ships */

#define MAXSHIPS 128 // With less ships radar fails firing a missile to the infinity (?)

// Values for the _flags field

#define IS_EXPLODING        1 
#define IS_DISAPPEARING     2 
#define IS_HYPERSPACING     4 
#define IS_DOCKING          8 


// Values for the _ai_state field

#define IS_AICONTROLLED     128

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



