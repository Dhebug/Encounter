
#include "main.h"
#include "tine.h"

#ifdef HAVE_MISSIONS

#define TXTPTRLO $fe
#define TXTPTRHI $ff

/* General routines for missions, which are fixed and NOT
   loaded from disk */

print_mission_message
.(
	lda double_buff
	beq nodb
	jsr clr_hires2
	jsr set_ink2
	jsr dump_buf
	ldx #6
	ldy #25
	jmp cont
nodb
	jsr clr_hires
	jsr set_ink2
	ldx #6
	ldy #(25+11)
cont
	jsr gotoXY
	lda $fe
	ldx $ff
	jsr print
rkey
	jsr ReadKeyNoBounce
	beq rkey

	lda NeedsDiskLoad
	rts
.)


.dsb MISSION_CODE_START-*

__start_mission_code

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
	.word 1000
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
    jsr AddSpaceObject
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
    jsr AddSpaceObject
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
    jsr AddSpaceObject
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
    jsr AddSpaceObject
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


__end_mission_code
#endif 


; Here will go everything that will be put in overlay ram Check osdk_config.bat

.bss
*=$c000


