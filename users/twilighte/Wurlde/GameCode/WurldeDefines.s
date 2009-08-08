;WurldeDefines.s
#define	dsk_LoadFile	$FE00

#define pcr_Disabled    	$DD
#define pcr_Register    	$FF
#define pcr_Value       	$FD

#define via_portb       	$0300
#define via_t1cl        	$0304
#define via_t1ll		$0306
#define via_t1lh		$0307
#define via_pcr         	$030C
#define via_ifr		$030D
#define via_ier		$030E
#define via_porta       	$030F

#define hcLeftTurnRight         0
#define hcRightTurnLeft         1
#define hcRunLeft               2
#define hcRunRight              3
#define hcStandLeft             4
#define hcStandRight            5
#define hcJumpUpFacingLeft      6
#define hcJumpUpFacingRight     7
#define hcSwingFacingLeft       8
#define hcSwingFacingRight      9
#define hcClamberFacingLeft     10
#define hcClamberFacingRight    11
#define hcStandingJumpLeft      12
#define hcStandingJumpRight     13
#define hcRunningJumpLeft       14
#define hcRunningJumpRight      15
#define hcFallLeft              16
#define hcFallRight             17
#define hcPickupLeft            18
#define hcPickupRight           19
#define hcDropLeft              20
#define hcDropRight             21

#define ccFloorExtra    	60
#define ccLeftExit      	60
#define ccRightExit     	61
#define ccLeftBorder    	62
#define ccRightBorder   	63
#define ccInpenetrableWall    64
#define ccFloorExit     	65
#define ccFloorPain     	66

#define hap_Repeat      	128
#define hap_Grounded    	64
#define hap_AddCheck    	32
#define hap_ContKey     	16
#define hap_FRight      	8
#define hap_Still       	4

#define kcL             	1
#define kcR             	2
#define kcU             	4
#define kcD		8
#define kcA             	16
#define kcI             	32
#define kcM             	64

#define lsDisableHeroControl  1
#define lsProhibitJump        2

;Used for Devils Head and Hand Actions
#define gf_Pointing     	0
#define gf_Tapping      	4
#define gf_Normal       	128

#define gh_Normal       	0
#define gh_Glowing      	1

#define eve_Star        	0
#define eve_Flag        	1
#define eve_Flow        	2
#define eve_Lift        	3
#define eve_Flicker     	4
#define eve_Sluece      	5
#define eve_Wave        	6
#define eve_Seagulls    	7
#define eve_Moor        	8
#define eve_ShipFlag    	9
#define eve_EOL         	128

#define game_nlScreen	$403
#define game_AddItem    	$406
#define game_IncreaseHealth	$409
#define game_DecreaseHealth	$40C
#define game_UpdateItemText	$40F
#define game_GetRNDRange      $412
#define game_PlotHero	$415
#define game_PlotPlace	$418
#define game_Selector	$41B
#define game_ScreenCopy	$41E
#define game_EraseInlay	$421
#define game_BackgroundBuffer	$424
;#define game_BGBYLOCL_lo	$426
;#define game_BGBYLOCL_hi	$427
;#define game_BGBYLOCH_lo	$428
;#define game_BGBYLOCH_hi	$429
#define game_DeleteHero	$42A
#define game_CutSceneFlag	$42D
#define game_DisplayText	$42E
#define game_HAPVector	$431
#define game_DisplayPockets	$433
#define game_ReadKeyboard	$436

;200-23A Screen ylocl Table
#define game_sylocl		$200
;23B-275 Screen yloch Table
#define game_syloch		$23B
;276-2B0 BackgroundBuffer ylocl Table
#define game_bgbylocl	$276
;2B1-2EB BackgroundBuffer yloch Table
#define game_bgbyloch	$2B1

#define LS_OUTSIDEMAP	0
#define LS_INSIDEMAP	6
#define LS_HELDBYCREATURE	10
#define LS_HELDBYHERO	11
#define LS_HELDINGAME	12

;Threshhold by which the specified iq must be reached before the character will
;demand the hero has a drink at the same time as him.
#define WiseDrinkingThreshhold 8

#define DrunkArrestThreshhold	 15

#define HIRESInlayLocation	$A730
