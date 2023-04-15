//
// Misc settings for the game testing
//
//#define ENABLE_INTRO         // Comment out to skip the intro
#define TESTING_MODE         // Comment out to play normally

// RControl -> Bank0 & 16
// LControl -> Bank2 & 16
// LShift   -> Bank4 & 16 
// RShift   -> Bank7 & 16 
// Arrows:  -> All on Bank 4

// Modifier keys
#define KEY_LSHIFT		1
#define KEY_RSHIFT		2
#define KEY_LCTRL		3
#define KET_RCTRL		4
#define KEY_FUNCT		5
// Actual normal keys
#define KEY_UP			6
#define KEY_LEFT		7
#define KEY_DOWN		8
#define KEY_RIGHT		9
#define KEY_ESC			10
#define KEY_DEL			11
#define KEY_RETURN		12



#define via_portb               $0300 
#define	via_ddrb				$0302	
#define	via_ddra				$0303
#define via_t1cl                $0304 
#define via_t1ch                $0305 
#define via_t1ll                $0306 
#define via_t1lh                $0307 
#define via_t2ll                $0308 
#define via_t2lh                $0309 
#define via_sr                  $030A 
#define via_acr                 $030b 
#define via_pcr                 $030c 
#define via_ifr                 $030D 
#define via_ier                 $030E 
#define via_porta               $030f 


#define OFFSET(x,y) x,y
#define RECTANGLE(x,y,w,h) x,y,w,h

#define COMMAND_END             0
#define COMMAND_RECTANGLE       1
#define COMMAND_FILL_RECTANGLE  2
#define COMMAND_TEXT            3
#define COMMAND_BUBBLE          4
#define COMMAND_WAIT            5

#define DELAY_FIRST_BUBBLE      25

