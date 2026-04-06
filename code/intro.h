
// Intro page indices - shared between intro_main.c and intro_utils.s
// Note: The demo version inserts an extra page after the title picture


#ifdef PRODUCT_TYPE_GAME_DEMO
#define INTRO_TITLE_PICTURE         0
#define INTRO_DEMO_FEATURES         1
#define INTRO_USER_MANUAL_PAGE1     2
#define INTRO_LEADERBOARD           3
#define INTRO_USER_MANUAL_PAGE2     4
#define INTRO_ACHIEVEMENTS          5
#define INTRO_USER_MANUAL_PAGE3     6
#define INTRO_STORY                 7
#define _INTRO_COUNT_               8
#else
#define INTRO_TITLE_PICTURE         0
#define INTRO_USER_MANUAL_PAGE1     1
#define INTRO_LEADERBOARD           2
#define INTRO_USER_MANUAL_PAGE2     3
#define INTRO_ACHIEVEMENTS          4
#define INTRO_USER_MANUAL_PAGE3     5
#define INTRO_STORY                 6
#define _INTRO_COUNT_               7
#endif


#ifndef ASSEMBLER    // 6502 Assembler API
// Wait, Wait2 and WaitAndFade have been converted to assembly in intro_utils.s
// OSDK C calling convention: int return value is X (low byte) + A (high byte)
extern int WaitAsm();
extern int Wait2Asm();
extern int WaitAndFadeAsm();
#define Wait(frames)         (param0.uint=(frames),WaitAsm())
#define Wait2(frames,ref)    (param0.uint=(frames),param1.uchar=(ref),Wait2Asm())
#define WaitAndFade(frames)  (param0.uint=(frames),WaitAndFadeAsm())
#endif
