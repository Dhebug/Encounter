;OSS_LanguageDefines
#define	PLAYERA			0
#define	PLAYERB			1

#define	DEFAULT_EXPLOSIONSCRIPT	63
#define	EAST			0
#define	SOUTHEAST                     1
#define	SOUTH                         2
#define	SOUTHWEST                     3
#define	WEST                          4
#define	NORTHWEST                     5
#define	NORTH                         6
#define	NORTHEAST                     7

#define	BRANCHING_ISUNCONDITIONAL     0
#define	BRANCHING_ONNOTFACINGHERO     1
#define	BRANCHING_ONNOTFACINGEAST     2
#define	BRANCHING_ONCOUNTERNOTZERO	3
#define	BRANCHING_ON2PLAYER		4

#define	MULTIPART			128

#define	PROJ_EASTBOUNDWHITECELL                    	0
#define	PROJ_SOUTHEASTBOUNDWHITECELL                      1
#define	PROJ_SOUTHBOUNDWHITECELL                          2
#define	PROJ_SOUTHWESTBOUNDWHITECELL                      3
#define	PROJ_WESTBOUNDWHITECELL                           4
#define	PROJ_NORTHWESTBOUNDWHITECELL                      5
#define	PROJ_NORTHBOUNDWHITECELL                          6
#define	PROJ_NORTHEASTBOUNDWHITECELL                      7
#define	PROJ_BOUNDBYCURRENTFACINGDIRECTIONWHITECELL       8
#define	PROJ_EASTBOUNDMISSILE                             9
#define	PROJ_WESTBOUNDMISSILE                             10
#define	PROJ_HOMINGMISSILE                                11

;Movement Commands
#define	SCROLL_SOUTH		0	; Step
#define	MOVE_EAST			1	; -	
#define	MOVE_SOUTH		2	; Step	
#define	MOVE_WEST			3	; -
#define	MOVE_NORTH		4	; Step
#define	MOVE_FORWARD		5	; -
#define	MOVE_TOWARDS_HERO		6	; -
#define	MOVE_XY			7	; X,Y

;Process Control
#define	SET_FRAMEFORDIRECTION	8	; Direction,Frame
#define	SET_EXPLOSION		9	; Script
#define	SET_COUNTER		10	; Count
#define	SET_CONDITION		11	; ConditionID
#define	SET_TARGET		12	; TargetID
#define	SET_HITINDEX		26	; Script
#define	SET_FRAME			13	; FrameID
#define	SET_ATTRIBUTES		28	; Attributes
#define	SET_HITPOINTS		29	; Hitpoints,Health
#define	SET_BONUSES		30	; Bonuses
#define	SET_WIDTH			32	; Width

#define	DECREMENT_FRAME		14	; -
#define	INCREMENT_FRAME		15	; -
#define	TURN_CLOCKWISE		16	; -
#define	TURN_ANTICLOCKWISE		17	; -
#define	TURN_TOWARDS_HERO		18	; -
#define	SPAWN_SCRIPT		19	; Script,Multipart Flag(128)
#define	SPAWN_SCRIPTXY		20	; X,Y,Script,Multipart Flag(128)
#define	SPAWN_PROJECTILE		25	; Projectile Type,Hitpoints

#define	BRANCH			21	; Index
#define	DISPLAY_SPRITE		22	; -
#define	TERMINATE			23	; -
#define	WAIT			24	; Period

#define	CALL_SPECIAL		27	; Low Address,High Address
#define	JUMP_SCRIPT		31	; Script

