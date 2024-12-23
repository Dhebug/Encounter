//
// Misc settings for the game testing
//
#define ENABLE_SPLASH                   // Comment out to skip the splash screen with the Severn Software and Defence Force logo
#define ENABLE_INTRO                    // Comment out to skip the intro
#define ENABLE_GAME                     // Comment out to disable the game (and go in the outro immediately)
#define INTRO_ENABLE_ATTRACT_MODE       // Comment out to skip to the type writer section
#define INTRO_SHOW_TITLE_PICTURE        // Comment out to hide the title picture
#define INTRO_SHOW_LEADERBOARD          // Comment out to hide the leaderboard
#define INTRO_SHOW_ACHIEVEMENTS         // Comment out to hide the achievements
#define INTRO_SHOW_USER_MANUAL          // Comment out to hide the instructions page
#define INTRO_SHOW_STORY                // Comment out to hide the typewriter story page
#define INTRO_SHOW_STORY_SCROLL         // Comment out to disable the office parallax scroll
//#define INTRO_ENABLE_SOUNDBOARD         // Comment out to disable the sound testing module
#define ENABLE_MUSIC                    // Comment out to disable the music
#define ENABLE_SOUND_EFFECTS            // Comment out to disable sound effects

//#define USE_MUSIC_EVENTS                // Comment out to disable events (not used in Encounter)

#define ENABLE_DEBUG_TEXT               // Commment out to disabled messages like "main(643): AskInput()"
#ifdef MODULE_GAME
#endif


#ifdef FREQUENCY_60HZ
// 60hz
#define ATTRIBUTE_TEXT    24
#define ATTRIBUTE_HIRES   28
#else
#ifdef FREQUENCY_50HZ
// 50hz
#define ATTRIBUTE_TEXT    26
#define ATTRIBUTE_HIRES   31
#else
// Undefined
#error "FREQUENCY should be set to either 60 or 50"
#endif
#endif

//#define TESTING_MODE         // Comment out to play normally
//#define DISABLE_FADES        // Comment out to enable the fancy fades

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

#define KEYBOARD_QWERTY 0
#define KEYBOARD_AZERTY 1
#define KEYBOARD_QWERTZ 2

#define MAX_WORDS 5         // In practice in the game we have COMBINE A B max, so three words

// 6502 opcodes for dynamic code patching
#define OPCODE_NOP              $EA
#define OPCODE_RTS              $60
#define OPCODE_JMP              $4C
#define OPCODE_BNE              $D0
#define OPCODE_BEQ              $F0
#define OPCODE_CLC              $18
#define OPCODE_SEC              $38

// Page 3 / VIA addresses
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

#include "scripting.h"


//
// Hack-ish code to reduce the size of memset calls from 29 bytes to 5+3
//
#ifdef ASSEMBLER    // 6502 Assembler API
#define MEMSET_ENTRY(address,value,size)   .byt <address,>address,value,<size,>size
#define MEMSET_JMP(label)                   ldx #<(label-_MemSetDataBase):jmp _MemsetTableSystem
#define MEMSET_JSR(label)                   ldx #<(label-_MemSetDataBase):jsr _MemsetTableSystem
#define MEMSET_VALUE_JMP(label,fill_value)  ldx fill_value:stx label+2:ldx #<(label-_MemSetDataBase):jmp _MemsetTableSystem
#define MEMSET_VALUE_JSR(label,fill_value)  ldx fill_value:stx label+2:ldx #<(label-_MemSetDataBase):jsr _MemsetTableSystem

#define MEMCPY_ENTRY(address1,address2,size)   .byt <address1,>address1,<address2,>address2,<size,>size
#define MEMCPY_JMP(label)                   ldx #<(label-_MemCpyDataBase):jmp _MemcpyTableSystem
#define MEMCPY_JSR(label)                   ldx #<(label-_MemCpyDataBase):jsr _MemcpyTableSystem
#endif

