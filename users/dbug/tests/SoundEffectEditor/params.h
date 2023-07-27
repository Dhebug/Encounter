
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


#define VIA_IORB    $300  ; Data register for I/O port B
#define VIA_IORA    $301  ; Data register for I/O port A

#define VIA_DDRB    $302  ; Data direction register port B
#define VIA_DDRA    $303  ; direction register port A

#define VIA_T1C_L	$304
#define VIA_T1C_H	$305

#define VIA_T1L_L	$306
#define VIA_T1L_H	$307

#define VIA_T2C_L	$308
#define VIA_T2C_H	$309

#define VIA_SR      $30a

#define VIA_ACR     $30b

#define VIA_PCR     $30c
#define VIA_ORA     $30f


#define SOUND_NOT_PLAYING        255

#define SOUND_COMMAND_END        0      // End of the sound
#define SOUND_COMMAND_END_FRAME  1      // End of command list for this frame
#define SOUND_COMMAND_SET_BANK   2      // Change a complete set of sounds: <14 values copied to registers 0 to 13>
#define SOUND_COMMAND_SET_VALUE  3      // Set a register value: <register index> <value to set>
#define SOUND_COMMAND_ADD_VALUE  4      // Add to a register:    <register index> <value to add>
#define SOUND_COMMAND_REPEAT     5      // Defines the start of a block that will repeat "n" times: <repeat count>
#define SOUND_COMMAND_ENDREPEAT  6      // Defines the end of a repeating block

