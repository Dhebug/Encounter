#ifndef COCKPIT_H
#define COCKPIT_H


/* HUD strings */

#define STR_INCOMING_MISSILE	0
#define STR_GAME_OVER			1
#define STR_PRESSSPACE			2
#define STR_LOADNEW				3
#define STR_TARGET_LOCKED		4
#define STR_TARGET_LOST			5
#define STR_GALACTIC_HYPER		6
#define STR_RIGHTONCOMMANDER	7
#define STR_ENERGY_LOW			8
#define STR_HYPERSPACE			9


/* These have parameterers */
#define STR_ITEM_DESTROYED		(128|0)
#define STR_BOUNTY				(128|1)
#define STR_SCOOPCARGO			(128|2)


/* Frames a message should stay in the HUD */
#define HUD_MESSAGE_DELAY		40

/* Row where HUD messages are printed */
#define HUD_MSG_Y				110

#endif


