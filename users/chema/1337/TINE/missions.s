
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
#define FLG_HARD		   128	


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

#define IndFlightMessage	MISSION_CODE_START-3*8
#define IndAddSpaceObject	MISSION_CODE_START-3*7
#define IndSetShipEquip     MISSION_CODE_START-3*6
#define IndRnd				MISSION_CODE_START-3*5
#define IndSetCurOb			MISSION_CODE_START-3*4
#define IndLaunchShip		MISSION_CODE_START-3*3
#define IndGetShipPos		MISSION_CODE_START-3*2
#define IndGetShipType		MISSION_CODE_START-3*1

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
#define _rotz			$f9e1
#define _target			$fa41
#define _flags			$fa61
#define _ttl			$fa81
#define _energy			$faa1
#define _missiles		$fac1
#define _ai_state		$fae1

#define THISMISSION			0
#define NEXTMISSION			4
#define NEXTMISSIONFAIL		$fc


*=MISSION_CODE_START

#include "../missions/mission0.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START


#include "../missions/mission1.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION 28
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

#include "../missions/mission2.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP 16
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

#include "../missions/tutorial0.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

#include "../missions/tutorial1.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

#include "../missions/tutorial2.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP 0
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START


#include "../missions/tutorial3.s"



;;;;;;;;;;;;;; MISSION NUMBER 28 ;;;;;;;;;;;;;;;


;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP 32
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

#include "../missions/mission3.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

#include "../missions/mission4.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4+1
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START


#include "../missions/mission5.s"


;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

#include "../missions/mission6.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4-1
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

#include "../missions/mission7.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4+1
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

#include "../missions/mission8.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4-1
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START


#include "../missions/mission9.s"

;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START


#include "../missions/mission10.s"


;---

; This is fixed... each mission included has a number which is the previous
; plus 4.
#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP

; This should vary, as the next mission both in case of success or failure
; could not be the next in list, but any other...

#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION $f8
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$fc

.dsb $a000-*


*=MISSION_CODE_START

__start_mission0_code

#include "../missions/mission11.s"

__end_mission0_code


#echo ***** Missions start:
#print (__start_mission0_code)
#echo ***** Mission memory:
#print (__end_mission0_code - __start_mission0_code)
#echo




#ifdef TESTINGMISSIONS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mission minus one
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


*=MISSION_CODE_START

.(
__start_mission0_code
// Jump table to mission functions    
// These are kind of event handlers  
// OnPlayerXXX. The idea is patching these with the necessary jumps. If returns C=1 it means
// that text is to be plotted to screen (brief or debrief). 

OnPlayerLaunch
	jmp MissionStart
OnPlayerDock
	jmp MissionSuccess
OnPlayerHyper
	clc
	rts
	.byt 00
OnExplodeShip
	clc
	rts
	.byt 00
OnDockedShip
	clc
	rts
	.byt 00
OnHyperShip
	clc
	rts
	.byt 00
OnEnteringSystem
	clc
	rts
	.byt 00
OnNewEncounter
	jmp CreateItemForScoop

// OnScoopObject return with carry =1 if it has handled the scooping, so the main program
// avoids doing so.

OnScoopObject		
	jmp CheckScoop

	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary
MissionCargo		.byt 0	; Cargo for this mission

// Some internal variables and code 

Success				.byt 0	; Cannot use Success here, as it is not saved. Better inc _mission
IdItem				.byt 0	
ItemCreated			.byt 0	; Should get this to zero at hyper or launch, if not gotten. Else inconsistent if loading after saved game.

MissionStart
.(
	lda _mission
	cmp #THISMISSION
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


MissionSuccess
.(
	lda _mission
	cmp #THISMISSION+1
	bne notlaunched
	lda _galaxynum
	cmp #2
	bne notlaunched
	lda _currentplanet
	cmp #$8
	bne notlaunched

	lda Success
	beq notlaunched

	lda #<10000
	clc
	adc _cash
	sta _cash
	lda #>10000
	adc _cash+1
	sta _cash+1


	lda #NEXTMISSION
	sta _mission

	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	dec NeedsDiskLoad

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

CreateItemForScoop
.(

  	lda _mission
	cmp #THISMISSION+1
	bne nolaunch

	lda Success
	bne nolaunch

	ldx ItemCreated
	bne nolaunch
	inx
	stx ItemCreated

	lda _galaxynum
	cmp #2
	bne nolaunch
	lda _currentplanet
	cmp #$a5
	bne nolaunch

    lda #<POS1
    sta tmp0
    lda #>POS1   
    sta tmp0+1
    lda #SHIP_CARGO
    jsr IndAddSpaceObject
	stx IdItem
	clc
	rts

nolaunch
	clc
	rts
.)


CheckScoop
.(
	lda Success
	bne itsnot
	cpx IdItem
	bne itsnot
	inc Success
	lda #<str_gotit
	sta tmp0
	lda #>str_gotit
	sta tmp0+1
	ldx #0
	jsr IndFlightMessage
itsnot
	rts
.)


str_gotit
	.asc "Stolen Hi-Tech"
	.byt 0

str_MissionBrief
	.asc "I have a profitable bussiness for you."
	.byt 13
	.asc "Get cannister at GEMA and bring it"
	.byt 13
	.asc "to ESRASOCE"
	.byt 0

str_MissionDebrief
	.asc "Good job. I have sent the credits."
	.byt 0

str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Get cannister at Gema. Bring it to"
	.byt 13
	.byt 2 
	.asc "Esrasoce."
	.byt 0


__end_mission0_code

#echo ***** Missions start:
#print (__start_mission0_code)
#echo ***** Mission memory:
#print (__end_mission0_code - __start_mission0_code)
#echo


.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mission zero
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


.dsb $a000-*



#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP
#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$ff



*=MISSION_CODE_START

.(
__start_mission0_code
// Jump table to mission functions    
// These are kind of event handlers  
// OnPlayerXXX. The idea is patching these with the necessary jumps. If returns C=1 it means
// that text is to be plotted to screen (brief or debrief). 

OnPlayerLaunch
	jmp MissionStart
OnPlayerDock
	jmp MissionSuccess
OnPlayerHyper
	clc
	rts
	.byt 00
OnExplodeShip
	clc
	rts
	.byt 00
OnDockedShip
	clc
	rts
	.byt 00
OnHyperShip
	clc
	rts
	.byt 00
OnEnteringSystem
	clc
	rts
	.byt 00
OnNewEncounter
	clc
	rts
	.byt 00

// OnScoopObject return with carry =1 if it has handled the scooping, so the main program
// avoids doing so.

OnScoopObject		
	clc
	rts 
	.byt 00

	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary1
MissionCargo		.byt 0	; Cargo for this mission

// Some internal variables and code 


MissionStart
.(
	lda _mission
	cmp #THISMISSION+2
	bne firststart

	lda _galaxynum
	cmp #2
	bne nolaunch
	lda _currentplanet
	cmp #$a5
	bne nolaunch

	; Load Cargo
	lda _holdspace
	cmp #3
	bcs doit
	; No cargo left!
	lda #<str_MissionProblem
	sta TXTPTRLO
	lda #>str_MissionProblem
	sta TXTPTRHI

	sec
	rts

doit
	lda #3
	ldx #3
	clc
	adc _shipshold,x
	sta _shipshold,x
	lda _holdspace
	sec
	sbc #3
	sta _holdspace

	lda #0
	sta MissionCargo

	clc
	rts



firststart
	cmp #THISMISSION
	bne nolaunch
	lda _score+1
	beq nolaunch

	; launch mission
	inc _mission
	lda #<str_MissionBrief
	sta TXTPTRLO
	lda #>str_MissionBrief
	sta TXTPTRHI

	lda #3
	sta MissionCargo

	sec
	rts
nolaunch
	clc
	rts
.)


MissionSuccess
.(

	lda _mission
	cmp #THISMISSION+1
	bne finished
	lda _galaxynum
	cmp #2
	bne notlaunched
	lda _currentplanet
	cmp #$a5
	bne notlaunched

	; launch mission
	inc _mission
	lda #<str_MissionBrief2
	sta TXTPTRLO
	lda #>str_MissionBrief2
	sta TXTPTRHI

	lda #<str_Summary
	sta MissionSummary
	lda #>str_Summary
	sta MissionSummary+1


	sec
	rts


finished
	lda _mission
	cmp #THISMISSION+2
	bne notlaunched
	lda _galaxynum
	cmp #2
	bne notlaunched
	lda _currentplanet
	cmp #$3
	bne notlaunched

	; Remove cargo
	ldx #3
	lda _shipshold,x
	cmp #3 
	bcs okcargo

	lda #NEXTMISSIONFAIL
	sta _mission
	lda #<str_MissionFailed
	sta TXTPTRLO
	lda #>str_MissionFailed
	sta TXTPTRHI
	sec
	rts

okcargo
	sec
	sbc #3
	sta _shipshold,x
	clc
	lda #3
	adc _holdspace
	sta _holdspace

	lda #<10000
	clc
	adc _cash
	sta _cash
	lda #>10000
	adc _cash+1
	sta _cash+1
	

	lda #NEXTMISSION
	sta _mission

	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	dec NeedsDiskLoad

	sec
	rts


notlaunched
	clc
	rts
.)


str_MissionBrief
	.asc "I have a profitable bussiness for you."
	.byt 13
	.asc "Come to GEMA for a transport."
	.byt 0

str_MissionBrief2
	.asc "Transport 3 tons of slaves to Maisso."
	.byt 13
	.asc "Be sure to have such space free before"
	.byt 13
	.asc "leaving. You will be paid 1000 Cr."
	.byt 0

str_MissionDebrief
	.asc "Good job. I have sent the credits."
	.byt 0

str_MissionProblem
	.asc "You didn't have enough space for our cargo!"
	.byt 13
	.asc "Get back to GEMA inmediately!"
	.byt 0

str_MissionFailed
	.asc "What did you do with my cargo?"
	.byt 13
	.asc "I will make sure nobody else hires you!"
	.byt 0

str_Summary1
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Go to Gema for a transport."
	.byt 13
	.byt 0

str_Summary
	.byt 2
	.asc "Current mission:"
	.byt 13
	.byt 2 
	.asc "Transport slaves to Maisso."
	.byt 13
	.byt 0

__end_mission0_code

#echo ***** Missions start:
#print (__start_mission0_code)
#echo ***** Mission memory:
#print (__end_mission0_code - __start_mission0_code)
#echo


.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mission one
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.dsb $a000-*



#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP
#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$ff


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

// OnScoopObject return with carry =1 if it has handled the scooping, so the main program
// avoids doing so.

OnScoopObject		
	clc
	rts 
	.byt 00

	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary
MissionCargo		.byt 0	; Cargo for this mission

// Some internal variables and code 

ShipToProtect	.byt 00
Succeeded		.byt 00

MissionStart
.(
	lda _mission
	cmp #THISMISSION
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
	cmp #THISMISSION+1
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
	cmp #THISMISSION+2
	bne notlaunched

	lda Succeeded
	beq failure

	lda #NEXTMISSION
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

	lda #NEXTMISSIONFAIL
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
	cmp #THISMISSION+2
	beq cont
nothing
	clc
	rts
cont
	cpx ShipToProtect
	bne nothing
	dec Succeeded	
	lda #<str_hedocked
	sta tmp0
	lda #>str_hedocked
	sta tmp0+1
	ldx #0
	jsr IndFlightMessage

	clc
	rts
.)


ShipKilled
.(
	lda _mission
	cmp #THISMISSION+2
	beq cont
nothing
	clc
	rts
cont
	cpx ShipToProtect
	bne nothing
	lda #<str_hekilled
	sta tmp0
	lda #>str_hekilled
	sta tmp0+1
	ldx #0
	jsr IndFlightMessage

	clc
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
	.asc "remember."
	.byt 0

str_MissionFailure
	.asc "Thanks for your attempt. Sadly you did"
	.byt 13
	.asc "not succeed. It was clearly too much"
	.byt 13
	.asc "for your skills."
	.byt 0
str_hedocked
	.asc "Zantor docked safely!"
	.byt 0
	.asc "Mission successful"
	.byt 0
str_hekilled
	.asc "Zantor has been killed!"
	.byt 0
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


#define MISSIONTEMP THISMISSION+4 
#undef THISMISSION 
#define THISMISSION MISSIONTEMP
#undef MISSIONTEMP
#define MISSIONTEMP NEXTMISSION+4
#define NEXTMISSION MISSIONTEMP
#undef MISSIONTEMP
#undef NEXTMISSIONFAIL
#define NEXTMISSIONFAIL		$ff

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

// OnScoopObject return with carry =1 if it has handled the scooping, so the main program
// avoids doing so.

OnScoopObject		
	clc
	rts 
	.byt 00
	
// Some public variables 
NeedsDiskLoad		.byt 0	; Will be set to $ff when a new mission needs to be loaded from disk
MissionSummary		.word str_Summary
MissionCargo		.byt 0	; Cargo for this mission

// Some internal variables and code 

ShipToProtect	.byt 00
Succeeded		.byt 00

MissionStart
.(
	lda _mission
	cmp #THISMISSION
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
	cmp #THISMISSION+1
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
	cmp #THISMISSION+2
	bne notlaunched

	lda Succeeded
	beq failure

	lda #NEXTMISSION
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

	lda #NEXTMISSIONFAIL
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
	cmp #THISMISSION+2
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
	cmp #THISMISSION+2
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
	.asc "MAYDAY -- MAYDAY "
	.byt 13
	.asc "My Cobra-I ship is damaged and"
	.byt 13
	.asc "I am pursued by pirates on Esrasoce."
	.byt 13
	.asc "Please help me!."
	.byt 0

str_MissionDebrief
	.asc "You have saved my life and I shall"
	.byt 13
	.asc "remember."
	.byt 0

str_MissionFailure
	.asc "Thanks for your attempt. Sadly you did"
	.byt 13
	.asc "not succeed. It was clearly too much"
	.byt 13
	.asc "for your skills."
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


#endif  // TESTINGMISSIONS






#endif 


