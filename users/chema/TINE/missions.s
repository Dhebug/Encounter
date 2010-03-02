
#include "..\main.h"
#include "..\ships.h"


// tine.h cannot be included... defines here.

/* Values for the _flags field */

#define IS_EXPLODING        1 
#define IS_DISAPPEARING     2 
#define IS_HYPERSPACING     4 
#define IS_DOCKING          8 
#define FLG_FLY_TO_PLANET   16
#define FLG_FLY_TO_HYPER    32
#define FLG_INNOCENT		64


/* Values for the _ai_state field */

#define IS_AICONTROLED     128

#define FLG_SLOW              1
#define FLG_BOLD              2
#define FLG_POLICE            4
#define FLG_DEFENCELESS       8 
#define FLG_TRADER			 16
#define FLG_BOUNTYHUNTER     32
#define FLG_PIRATE			 64



/* Values for _target field */

#define IS_ANGRY            128

/* Values for equipment (user Byte in OBJ3D record) */
#define HAS_ECM             1
#define HAS_MILLASER        2
#define HAS_ESCAPEPOD       4
#define HAS_ANTIRADAR       8
#define HAS_GALHYPER        16
#define HAS_SCOOPS          32
#define HAS_EXTRACARGO      64
#define HAS_ITEM3           128



#ifdef HAVE_MISSIONS

#define TXTPTRLO $fe
#define TXTPTRHI $ff


// Jump table for routines accessible from mission code

#define IndAddSpaceObject	MISSION_CODE_START-3*6
#define IndSetShipEquip     MISSION_CODE_START-3*5
#define IndRnd				MISSION_CODE_START-3*4
#define IndSetCurOb			MISSION_CODE_START-3*3
#define IndLaunchShip		MISSION_CODE_START-3*2
#define IndGetShipPos		MISSION_CODE_START-3*1

// Variables accessible from mission code

// From page 0
#define tmp0			$06
#define tmp1			$08
#define tmp2			$0a
#define tmp3			$0c
#define op1				$16
#define op2				$18
#define tmp				$1a


// From page 4

// Player's data
#define _name			$400
#define _shipshold		$40b
#define _currentplanet	$41c
#define _galaxynum		$41d
#define _cash			$41e
#define _fuel			$422
#define _holdspace		$424
#define _legal_status	$425
#define _score_rem		$426
#define _score			$427
#define _mission		$429
#define _equip			$42a

// Used for getting ship's position
#define _PosX			$4e7
#define _PosY			$4e9
#define _PosZ			$4eb

// frame counter
#define frame_number	$4f9

// From overlay ram, ship data
#define _target			$fa41
#define _flags			$fa61
#define _ttl			$fa81
#define _energy			$faa1
#define _missiles		$fac1
#define _ai_state		$fae1


*=MISSION_CODE_START

.(
__start_mission1_code
// Jump table to mission functions    
// These are kind of event handlers   
// OnPlayerXXX. The idea is patching these with the necessary jumps. If returns C=1 it means
// that text is to be plotted to screen (brief or debrief). 

OnPlayerLaunch
	jmp MissionStart
OnPlayerDock
	jmp MissionSuccess
OnPlayerHyper
	jmp MissionSuccess
OnExplodeShip
	jmp ShipKilled
OnDockedShip
	jmp ShipDocked
OnHyperShip
	clc
	rts
	.byt 00
OnEnteringSystem
	jmp MissionEncounters
OnNewEncounter
	clc
	rts
	.byt 00
	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary

// Some internal variables and code 

ShipToProtect	.byt 00
Succeeded		.byt 00

MissionStart
.(
	lda _mission
	bne nolaunch
	lda _score+1
	beq nolaunch

	; launch mission
	inc _mission
	lda #<str_MissionBrief
	sta TXTPTRLO
	lda #>str_MissionBrief
	sta TXTPTRHI

	sec
	rts
nolaunch
	clc
	rts
.)

MissionEncounters
.(
	lda _mission
	cmp #1
	bne nolaunch
	lda _galaxynum
	cmp #2
	bne nolaunch
	lda _currentplanet
	cmp #$1b
	bne nolaunch
	jsr CreateMissionShips
	inc _mission
	clc
	rts
nolaunch
	clc
	rts
.)

MissionSuccess
.(
	lda _mission
	cmp #2
	bne notlaunched

	lda Succeeded
	beq failure

	lda #4
	sta _mission

	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	dec NeedsDiskLoad

	sec
	rts

failure
	lda #<str_MissionFailure
	sta TXTPTRLO
	lda #>str_MissionFailure
	sta TXTPTRHI

	lda #$ff
	sta _mission
	sec
	rts

notlaunched
	clc
	rts
.)

POS1
	.word 0
	.word 0
	.word 0
POS2
	.word 4500
	.word 0
	.word -6000
POS3
	.word -4500
	.word 0
	.word -6000
POS4
	.word -4500
	.word -4500
	.word -6000

CreateMissionShips
.(
	; Create ship fleeing...
    lda #<POS1
    sta tmp0
    lda #>POS1   
    sta tmp0+1
    lda #SHIP_COBRA1
    jsr IndAddSpaceObject
	stx ShipToProtect
	lda #(FLG_FLY_TO_PLANET|FLG_INNOCENT)
	sta _flags,x
	lda #(IS_AICONTROLED|FLG_DEFENCELESS|FLG_BOLD)
	sta _ai_state,x
	lda #2
	sta _target,x

	; Create bad guys
    lda #<POS2
    sta tmp0
    lda #>POS2   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda ShipToProtect
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x

    lda #<POS3
    sta tmp0
    lda #>POS3   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda ShipToProtect
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x

    lda #<POS4
    sta tmp0
    lda #>POS4   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_PIRATE)
	sta _ai_state,x
	lda ShipToProtect
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x
	clc
	rts

.)

ShipDocked
.(
	lda _mission
	cmp #2
	beq cont
nothing
	clc
	rts
cont
	cpx ShipToProtect
	bne nothing
	dec Succeeded	
	lda #<str_hedocked
	sta TXTPTRLO
	lda #>str_hedocked
	sta TXTPTRHI
	sec
	rts
.)


ShipKilled
.(
	lda _mission
	cmp #2
	beq cont
nothing
	clc
	rts
cont
	cpx ShipToProtect
	bne nothing
	lda #<str_hekilled
	sta TXTPTRLO
	lda #>str_hekilled
	sta TXTPTRHI
	sec
	rts
.)

str_MissionBrief
	.asc "   MAYDAY -- MAYDAY "
	.byt 13
	.asc "My Cobra-I ship is damaged and"
	.byt 13
	.asc "I am pursued by pirates on Beanen."
	.byt 13
	.byt 13
	.asc "Please help me!."
	.byt 13
	.asc "---MESSAGE ENDS."
	.byt 0

str_MissionDebrief
	.asc "You have saved my life and I shall"
	.byt 13
	.asc "remember. ---MESSAGE ENDS."
	.byt 0

str_MissionFailure
	.asc "Thanks for your attempt. Sadly you did"
	.byt 13
	.asc "not succeed. It was clearly too much"
	.byt 13
	.asc "for your skills. ---MESSAGE ENDS."
	.byt 0
str_hedocked
	.asc "Zantor docked safely!"
	.byt 13
	.asc "Mission successful"
	.byt 0
str_hekilled
	.asc "Zantor has been killed!"
	.byt 13
	.asc "Mission failed"
	.byt 0
str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Go to Beanen. Save Zantor from pirates"
	.byt 13
	.byt 2
	.asc "so he can land safely."
	.byt 0

__end_mission1_code

#echo ***** Missions start:
#print (__start_mission1_code)
#echo ***** Mission memory:
#print (__end_mission1_code - __start_mission1_code)
#echo


.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mission two
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.dsb $a000-*
*=MISSION_CODE_START
.(

__start_mission2_code
// Jump table to mission functions    
// These are kind of event handlers   
// OnPlayerXXX. The idea is patching these with the necessary jumps. If returns C=1 it means
// that text is to be plotted to screen (brief or debrief). 

OnPlayerLaunch
	jmp MissionStart
OnPlayerDock
	jmp MissionSuccess
OnPlayerHyper
	jmp MissionSuccess
OnExplodeShip
	jmp ShipKilled
OnDockedShip
	jmp ShipDocked
OnHyperShip
	clc
	rts
	.byt 00
OnEnteringSystem
	jmp MissionEncounters
OnNewEncounter
	clc
	rts
	.byt 00
	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary

// Some internal variables and code 

ShipToProtect	.byt 00
Succeeded		.byt 00

MissionStart
.(
	lda _mission
	cmp #4
	bne nolaunch
	lda _score+1
	beq nolaunch

	; launch mission
	inc _mission
	lda #<str_MissionBrief
	sta TXTPTRLO
	lda #>str_MissionBrief
	sta TXTPTRHI

	sec
	rts
nolaunch
	clc
	rts
.)

MissionEncounters
.(
	lda _mission
	cmp #5
	bne nolaunch
	lda _galaxynum
	cmp #2
	bne nolaunch
	lda _currentplanet
	cmp #$8
	bne nolaunch
	jsr CreateMissionShips
	inc _mission
	clc
	rts
nolaunch
	clc
	rts
.)

MissionSuccess
.(
	lda _mission
	cmp #6
	bne notlaunched

	lda Succeeded
	beq failure

	lda #8
	sta _mission

	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	sec
	rts

failure
	lda #<str_MissionFailure
	sta TXTPTRLO
	lda #>str_MissionFailure
	sta TXTPTRHI

	lda #$ff
	sta _mission
	sec
	rts

notlaunched
	clc
	rts
.)

POS1
	.word 0
	.word 0
	.word 0
POS2
	.word 4500
	.word 0
	.word -6000
POS3
	.word -4500
	.word 0
	.word -6000
POS4
	.word -4500
	.word -4500
	.word -6000

CreateMissionShips
.(
	; Create ship fleeing...
    lda #<POS1
    sta tmp0
    lda #>POS1   
    sta tmp0+1
    lda #SHIP_COBRA1
    jsr IndAddSpaceObject
	stx ShipToProtect
	lda #(FLG_FLY_TO_PLANET|FLG_INNOCENT)
	sta _flags,x
	lda #(IS_AICONTROLED|FLG_DEFENCELESS|FLG_BOLD)
	sta _ai_state,x
	lda #2
	sta _target,x

	; Create bad guys
    lda #<POS2
    sta tmp0
    lda #>POS2   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda ShipToProtect
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x

    lda #<POS3
    sta tmp0
    lda #>POS3   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_BOLD|FLG_PIRATE)
	sta _ai_state,x
	lda ShipToProtect
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x

    lda #<POS4
    sta tmp0
    lda #>POS4   
    sta tmp0+1
	lda #SHIP_MAMBA
    jsr IndAddSpaceObject
	lda #(IS_AICONTROLED|FLG_PIRATE)
	sta _ai_state,x
	lda ShipToProtect
	ora #IS_ANGRY
	sta _target,x

	; Set number of missiles to zero
	lda #%11111000
	and _missiles,x
	sta _missiles,x
	clc
	rts

.)

ShipDocked
.(
	lda _mission
	cmp #6
	beq cont
nothing
	clc
	rts
cont
	cpx ShipToProtect
	bne nothing
	dec Succeeded	
	lda #<str_hedocked
	sta TXTPTRLO
	lda #>str_hedocked
	sta TXTPTRHI
	sec
	rts
.)


ShipKilled
.(
	lda _mission
	cmp #6
	beq cont
nothing
	clc
	rts
cont
	cpx ShipToProtect
	bne nothing
	lda #<str_hekilled
	sta TXTPTRLO
	lda #>str_hekilled
	sta TXTPTRHI
	sec
	rts
.)

str_MissionBrief
	.asc "   MAYDAY -- MAYDAY "
	.byt 13
	.asc "My Cobra-I ship is damaged and"
	.byt 13
	.asc "I am pursued by pirates on Esrasoce."
	.byt 13
	.byt 13
	.asc "Please help me!."
	.byt 13
	.asc "---MESSAGE ENDS."
	.byt 0

str_MissionDebrief
	.asc "You have saved my life and I shall"
	.byt 13
	.asc "remember. ---MESSAGE ENDS."
	.byt 0

str_MissionFailure
	.asc "Thanks for your attempt. Sadly you did"
	.byt 13
	.asc "not succeed. It was clearly too much"
	.byt 13
	.asc "for your skills. ---MESSAGE ENDS."
	.byt 0
str_hedocked
	.asc "Zantor docked safely!"
	.byt 13
	.asc "Mission successful"
	.byt 0
str_hekilled
	.asc "Zantor has been killed!"
	.byt 13
	.asc "Mission failed"
	.byt 0
str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Go to Esrasoce. Save Zantor from"
	.byt 13
	.byt 2
	.asc "pirates so he can land safely."
	.byt 0

__end_mission2_code

#echo ***** Missions start:
#print (__start_mission2_code)
#echo ***** Mission memory:
#print (__end_mission2_code - __start_mission2_code)
#echo

.)






#endif 


