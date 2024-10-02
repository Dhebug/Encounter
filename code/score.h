
#include "game_enums.h"

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


typedef struct 
{
    int             score;          // The score can actually be negative if the player is doing stupid things on purpose (plus or minus 32768 because of assembler reasons)
    unsigned char   condition;      // The reason why the game ended (victory, abandon, death, ...)
    unsigned char   name[15];       // The name of the character  
} score_entry;

typedef struct
{
    score_entry scores[SCORE_COUNT];   // 18*24=432
    unsigned char achievements[ACHIEVEMENT_BYTE_COUNT];     // Enough for 6*8=48 achievements
    char free_data[80-1-ACHIEVEMENT_BYTE_COUNT];
    unsigned char launchCount;
} save_game_file;                      // sizeof(save_game_file)=512

extern score_entry gHighScores[SCORE_COUNT];  //char gHighScores[512];  
extern save_game_file gSaveGameFile;          // Actually points to the same location as gHighScores
extern const char* gScoreConditionsArray[];

extern int gScore;                              // Moved to the last 32 bytes so it can be shared with the other modules
extern unsigned char gAchievements[];           // Moved to the last 32 bytes so it can be shared with the other modules
extern unsigned char gAchievementsChanged;      // Moved to the last 32 bytes so it can be shared with the other modules
extern unsigned char gGameOverCondition;        // Moved to the last 32 bytes so it can be shared with the other modules

extern const char gTextHighScoreAskForName[];   // "New highscore! Your name please?"
extern const char gTextHighScoreInvalidName[];  // Between 0 and 15 characters

extern const char gTextThanks[];
extern const char gTextCredits[];
extern const char gTextGameDescription[];
extern const char gTextExternalInformation[];
extern const char gTextGreetings[];

