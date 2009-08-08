;SSCModuleHeader.s
;Holds defines of SSC Header

#Define ssc_ScreenInit		$C000	;Called on loading SSC Module
#define ssc_ScreenRun		$C003	;Called at runtime
#define ssc_BackgroundCollision $C006	;Called on Hero movement
#define ssc_ProcAction		$C009	;Called on Hero pressing Action Key

#define ssc_ScreenProseVectorLo $C018
#define ssc_ScreenProseVectorHi $C019
#define ssc_ScreenNameVectorLo	$C01A	;Name of screen
#define ssc_ScreenNameVectorHi	$C01B	;Name of screen
;Each Bit represents SSC specific Rules
;B0 Freeze Hero (Don't plot or permit hero control until this bit Reset)
;B1 Prohibit Jump
;B2 Left Exit
;B3 Right Exit
;B4
;B5
;B6
;B7 Sync at 25Hz
#Define ssc_ScreenRules		$C01C	;Rules to apply to Hero in respect to screen
#define ssc_LocationID		$C01D	;
;Each Bit represents a separate Action that the hero may perform to trigger ProcAction
;B0 Action Key Pressed
;B1 Inventory Key Pressed
;B2 Drop
;B3 Pickup
;B4 Up Key Pressed
;B5
;B6
;B7
#define ssc_RecognisedAction	$C01E	;Recognised Actions that may affect screen
#define ssc_CollisionType	$C01F
#define ssc_CollisionTablesLo $C020
#define ssc_CollisionTablesHi $C021
#define ssc_ScreenInlayLo	$C022
#define ssc_ScreenInlayHi	$C023
;Enteringtext refers to welcome text given when hero enters the screens only building
#define ssc_EnteringTextVectorLo	$C024
#define ssc_EnteringTextVectorHi	$C025
#define ssc_InteractionHeaderVectorLo	$C026
#define ssc_InteractionHeaderVectorHi	$C027
#define ssc_CharacterListVectorLo	$C028
#define ssc_CharacterListVectorHi	$C029
#define ssc_CharacterInfoVectorLo	$C02A
#define ssc_CharacterInfoVectorHi	$C02B

#define SUBGAME_TEMPLESGREATHORNSEARCH	1