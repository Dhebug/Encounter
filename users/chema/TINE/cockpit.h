#ifndef COCKPIT_H
#define COCKPIT_H


/* HUD strings */

#define STR_INCOMING_MISSILE	0
#define STR_GAME_OVER			1
#define STR_PRESSSPACE			2
#define STR_LOADNEW				3
#define STR_TARGET_LOCKED		4
#define STR_TARGET_LOST			5
#define STR_MASS_LOCKED			6
#define STR_HYPRANGE			7
#define STR_GALACTIC_HYPER		8
#define STR_RIGHTONCOMMANDER	9
#define STR_ENERGY_LOW			10
#define STR_HYPERSPACE			12


/* These have parameterers */
#define STR_ITEM_DESTROYED		(128|0)
#define STR_BOUNTY				(128|1)
#define STR_SCOOPCARGO			(128|2)


/* Frames a message should stay in the HUD */
#define HUD_MESSAGE_DELAY		40

/* Row where HUD messages are printed */
#define HUD_MSG_Y				110



/* Inversed color codes... for flashing light */
#define INV_BLACK	$80
#define INV_RED		$81
#define INV_GREEN	$82
#define INV_YELLOW	$83
#define INV_BLUE	$84
#define INV_MAGENTA	$85
#define INV_CYAN	$86
#define INV_WHITE	$87


#endif


