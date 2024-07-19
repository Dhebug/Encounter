//
// Stuff which is common to the intro and the game
// (c) 2023-2024 Dbug / Defence Force
//

#include "common.h"

extern unsigned char gAchievements[];           // Moved to the last 32 bytes so it can be shared with the other modules
extern unsigned char gAchievementsChanged;      // Moved to the last 32 bytes so it can be shared with the other modules



// TODO: Should probably be somewhere else, but good enough right now
void UnlockAchievementAsm()
{
    unsigned char assignment = param0.uchar;
    unsigned char* assignementPtr = &gAchievements[assignment/8];
    unsigned char bitmask = 1<<(assignment&7);
    unsigned char previousValue = *assignementPtr;
    *assignementPtr |= 1<<(assignment&7);
    if (previousValue!=*assignementPtr)
    {
        gAchievementsChanged = 1;
    }
}
