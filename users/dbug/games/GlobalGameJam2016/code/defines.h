#ifndef _DEFINES_INCLUDED_ALREADY_H_
#define _DEFINES_INCLUDED_ALREADY_H_

//
// Comment out these defines to enable or disable the various features of the engine
//
#define ENABLE_INTRO_SEQUENCE
#define ENABLE_STORY_PAGE
//#define ENABLE_FUNCOM_LOGO_INTRO
//#define ENABLE_FUNCOM_JINGLE
#define ENABLE_GAMEJAM_LOGO
#define ENABLE_FUNCOM_LOGO
//#define ENABLE_VALP_ANIMATION
#define ENABLE_PRESS_FIRE_TO_START
//#define ENABLE_SHOW_HIGH_SCORES
#define ENABLE_MAIN_MENU
#define ENABLE_UI_MOCKUP


// Here are the possible values to mask the KeyboardState with.
// Apply multiple flags to handle things like combinations (diagonals)
#define MOVEMENT_LEFT	1
#define MOVEMENT_RIGHT  2
#define MOVEMENT_UP     4
#define MOVEMENT_DOWN   8
#define MOVEMENT_FIRE   16


// The various menu options that appear in the game that the player can choose
#define ACTION_LEAVE    0
#define ACTION_DISCOVER 1
#define ACTION_EAT      2
#define ACTION_DRINK    3
#define ACTION_REST     4
#define ACTION_BUY_PASS 5
#define ACTION_AIRPORT 6		// Option to complete the game
#define ACTION_GIVE_UP  7		// End the game

#define GAMEOVER_STILL_OK   	0   // The player has not yet lost
#define GAMEOVER_GAVEUP     	1   // The player gave up
#define GAMEOVER_NO_MORE_MONEY  2   // The player has no more money to spend
#define GAMEOVER_EXHAUSTED      3   // The player is exhausted, and finished a the hospital
#define GAMEOVER_TIME_UP        4   // The player is still in Oslo and missed his plane back home
#define GAMEOVER_VICTORY        5   // The player managed to get back home on time

#endif // _DEFINES_INCLUDED_ALREADY_H_

