
#ifdef HAVE_MISSIONS
#include "main.h"
#include "tine.h"

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
	jmp cont
nodb
	jsr clr_hires
cont
	ldx #12
	ldy #25
	jsr gotoXY
	lda $fe
	ldx $ff
	jsr print
rkey
	jsr ReadKeyNoBounce
	beq rkey
	rts
.)



.dsb MISSION_CODE_START-*

__start_mission_code

/* Jump table to main functions */


/* CheckMissionEncounters. The idea is call this whenever random encounters could
   exist and return Z=0 if encounters occur. */

CheckMissionEncounters
	jmp MissionEncounters

/* OnPlayerXXX. The idea is patching these with the necessary jumps. If returns Z=0 it means
   that text is to be plotted to screen (brief or debrief). */

OnPlayerLaunch
	jmp MissionStart
OnPlayerDock
	jmp MissionSuccess
OnPlayerHyper
	jmp MissionSuccess
	;lda #0
	;rts
OnExplodeShip
	lda #0
	rts
OnDockedShip
	jmp ShipDocked
OnHyperShip
	lda #0
	rts

NextMission	.byt 4


ShipToProtect .byt 00
Succeeded	  .byt 00

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

	lda #$ff
	rts
nolaunch
	lda #0
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
	lda #$ff
	rts
nolaunch
	lda #00
	rts
.)

MissionSuccess
.(
	lda _mission
	cmp #2
	bne notlaunched

	lda Succeeded
	beq failure

	lda NextMission
	sta _mission

	lda #<str_MissionDebrief
	sta TXTPTRLO
	lda #>str_MissionDebrief
	sta TXTPTRHI

	lda #$ff
	rts

failure
	lda #<str_MissionFailure
	sta TXTPTRLO
	lda #>str_MissionFailure
	sta TXTPTRHI

	lda #$ff
	sta NextMission

	rts

notlaunched
	lda #00
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

	rts

.)

ShipDocked
.(
	lda _mission
	cmp #2
	bne cont

	cpx ShipToProtect
	bne cont
	dec Succeeded	
cont
	rts
.)


str_MissionBrief
	.asc "Greetings Commander, I am 
	.byt 13
	.asc "Captain Curruthers of Her"
	.byt 13
	.asc "Majesty's Space Navy and I beg"
	.byt 13
	.asc "a moment of your valuable time.
	.byt 13
	.asc "We would like you to do a little 
	.byt 13
	.asc "job for us. ---MESSAGE ENDS."
	.byt 0

str_MissionDebrief
	.asc "You have served us well and we shall"
	.byt 13
	.asc "remember. ---MESSAGE ENDS."
	.byt 0

str_MissionFailure
	.asc "Thanks for your attempt. Sadly we did"
	.byt 13
	.asc "not succeed. It was clearly too much"
	.byt 13
	.asc "for your skills. ---MESSAGE ENDS."
	.byt 0

__end_mission_code
#endif //HAVE_MISSIONS


; Here will go everything that will be put in overlay ram Check osdk_config.bat

.bss
*=$c000
