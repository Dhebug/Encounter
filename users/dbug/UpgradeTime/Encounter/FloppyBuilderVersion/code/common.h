
#include "params.h"

#include "loader_api.h"

// Irq
extern void System_InstallIRQ_SimpleVbl();
extern void System_RestoreIRQ_SimpleVbl();
extern void WaitIRQ();

extern unsigned char VblCounter;

// Keyboard
extern char WaitKey();
extern char ReadKey();
extern char ReadKeyNoBounce();

extern unsigned char KeyBank[8]; // .dsb 8   ; The virtual Key Matrix


// Display
extern unsigned char ImageBuffer[40*200];


// Audio
extern void PlaySound(const char* registerList);

extern char PsgNeedUpdate;
extern char PsgVirtualRegisters[];
extern char ExplodeData[];
extern char ShootData[];
extern char PingData[];
extern char ZapData[];
extern char KeyClickHData[];
extern char KeyClickLData[];


// Common
extern void SetLineAddress(char* address);
extern void PrintLine(const char* message);
extern void PrintWord(const char* message);

extern void Text(char paperColor,char inkColor);
extern void Hires(char paperColor,char inkColor);
extern void WaitFrames(int frames);

extern char gIsHires;
extern char* gPrintAddress;

/*
;
; Data generator for the high scores
;
; Each entry occupies 19 bytes:
;  2 bytes for the score (+32768)
;  1 byte for the game ending condition
; 16 bytes for the name (padded with spaces)
;-------------------------------------------
; 19 bytes per entry * 24 entries = 456 bytes total
;
#define ENTRY(type,score,name) .word (score+32768) : .byt type : .asc name
*/
#define SCORE_COUNT  24

enum SCORE_CONDITION
{
    e_SCORE_UNNITIALIZED    = 0,
    e_SCORE_SOLVED_THE_CASE = 1,
    e_SCORE_MAIMED_BY_DOG   = 2,
    e_SCORE_SHOT_BY_THUG    = 3,
    e_SCORE_FELL_INTO_PIT   = 4,
    e_SCORE_TRIPPED_ALARM   = 5,
    e_SCORE_RAN_OUT_OF_TIME = 6,
    e_SCORE_BLOWN_INTO_BITS = 7,
    e_SCORE_SIMPLY_VANISHED = 8,
    e_SCORE_GAVE_UP         = 9
};

typedef struct 
{
    int             score;          // The score can actually be negative if the player is doing stupid things on purpose
    unsigned char   condition;      // The reason why the game ended (victory, abandon, death, ...)
    unsigned char   name[16];       // The name of the character  
} score_entry;

extern score_entry gHighScores[SCORE_COUNT];
extern const char* gScoreConditionsArray[];
