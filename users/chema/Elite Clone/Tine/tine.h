#ifndef TINE_H
#define TINE_H

/* Some defines for TINE */
/* Maximum number of simultaneous ships */

#define MAXSHIPS 20 

// Values for the _flags field

#define IS_EXPLODING        1 
#define IS_DISAPPEARING     2 
#define IS_HYPERSPACING     4 
#define IS_DOCKING          8 


// Values for the _ai_state field

#define IS_AICONTROLLED     128

// Values for _target field

#define IS_ANGRY            128

#endif



