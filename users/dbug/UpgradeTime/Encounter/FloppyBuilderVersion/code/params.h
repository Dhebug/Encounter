//
// Misc settings for the game testing
//
//#define ENABLE_INTRO         // Comment out to skip the intro
#define TESTING_MODE         // Comment out to play normally
//#define DISABLE_FADES        // Comment out to enable the fancy fades
#define ENABLE_CHEATS          // When enabled, allows to use special words to test things, like "Revive"

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

#define DELAY_FIRST_BUBBLE      25

#define OFFSET(x,y) x,y
#define BLOCK_SIZE(w,h) w,h
#define STRIDE(b) b
#define RECTANGLE(x,y,w,h) x,y,w,h

// Command opcodes
#define COMMAND_END             0
#define COMMAND_RECTANGLE       1
#define COMMAND_FILL_RECTANGLE  2
#define COMMAND_TEXT            3
#define COMMAND_BUBBLE          4
#define COMMAND_WAIT            5
#define COMMAND_BITMAP          6
#define COMMAND_FADE_BUFFER     7
#define COMMAND_JUMP            8      // Really, that's a GOTO :p
#define COMMAND_JUMP_IF_TRUE    9
#define COMMAND_JUMP_IF_FALSE   10

// Operator opcodes
#define OPERATOR_CHECK_ITEM_LOCATION 0
#define OPERATOR_CHECK_ITEM_FLAG     1

#define END                                  .byt COMMAND_END
#define WAIT(duration)                       .byt COMMAND_WAIT,duration
#define JUMP(label)                          .byt COMMAND_JUMP,<label,>label
#define JUMP_IF_FALSE(label,expression)      .byt COMMAND_JUMP_IF_FALSE,<label,>label,expression
#define CHECK_ITEM_LOCATION(item,location)   OPERATOR_CHECK_ITEM_LOCATION,item,location
#define CHECK_ITEM_FLAG(item,flag)           OPERATOR_CHECK_ITEM_FLAG,item,flag

#define DRAW_BITMAP(imageId,size,stride,src,dst)     .byt COMMAND_BITMAP,imageId,size,stride,<src,>src,<dst,>dst

// Audio commands
#define SOUND_NOT_PLAYING        255

#define SOUND_COMMAND_END        0      // End of the sound
#define SOUND_COMMAND_END_FRAME  1      // End of command list for this frame
#define SOUND_COMMAND_SET_BANK   2      // Change a complete set of sounds: <14 values copied to registers 0 to 13>
#define SOUND_COMMAND_SET_VALUE  3      // Set a register value: <register index> <value to set>
#define SOUND_COMMAND_ADD_VALUE  4      // Add to a register:    <register index> <value to add>
#define SOUND_COMMAND_REPEAT     5      // Defines the start of a block that will repeat "n" times: <repeat count>
#define SOUND_COMMAND_ENDREPEAT  6      // Defines the end of a repeating block

