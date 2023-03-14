
/*This keys don't have an ASCII code assigned, so we will
 use consecutive values outside the usual alphanumeric 
 space.
*/

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



