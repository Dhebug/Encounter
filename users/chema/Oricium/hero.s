;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code to handle hero movement

#include "sfx.h"

#define NUM_KEYS 7

tab_banks 		.byt 1,4,4,4,4,4,4
tab_bits 		.byt %00100000,%00010000,%00000001,%10000000,%00100000,%01000000,%00001000
tab_routinel 	.byt <pause_game,<kjump,<shoot,<kright,<kleft,<kdown,<kup
tab_routineh 	.byt >pause_game,>kjump,>shoot,>kright,>kleft,>kdown,>kup

pause_game
.(
loopr
	jsr waitirq
	lda MusicPlaying
	beq skipmus
	jsr ProcessMusic
skipmus	
	jsr ReadKeyboard
	jsr _ReadKeyNoBounce
	beq loopr
	
	; Get rid of context and return
	pla
	pla
	rts
.)
	


user_control
.(
	; If there is a secondary command, execute it
	lda ccommand_h
	beq noccommand2
	sta smc_cont+2
	lda ccommand_l
	sta smc_cont+1
smc_cont
	jsr $1234	
	
noccommand2
	; If there is a primary command, jump to it
	; no user control possible
	lda pcommand_h
	beq noautocommand
	sta smc_jmp+2
	lda pcommand_l
	sta smc_jmp+1
smc_jmp
	jmp $1234

noautocommand
	; Process player input
	; By default stop vertical movement
	lda #0
	sta speedv
	
	ldy #NUM_KEYS-1
loop
	ldx tab_banks,y	
	lda _KeyBank,x
	and tab_bits,y
	beq skip
	lda tab_routinel,y
	sta smc_command+1
	lda tab_routineh,y
	sta smc_command+2
	sty keysavy+1
smc_command
	jsr $1234
+keysavy
	ldy #0
skip	
	dey
	bpl loop
	rts
.)

kdown
	lda #1
	.byt $2c	
kup	
	lda #$ff
	sta speedv
	rts
kright
	; Kludge!
	ldx tab_banks+1,y
	lda _KeyBank,x
	and tab_bits+1,y
	beq nojump
	; Jump!
kjump	
	pla
	pla
	jmp jump_hero
nojump	
	lda direction
	bne deccelerate
	beq accelerate
kleft	
	lda direction
	beq deccelerate
	;bne accelerate
accelerate
.(
	lda speedp
	cmp #7
	beq skip
	inc speedp
skip
	rts
.)
deccelerate
.(
	lda speedp
	bne doit
	jmp loop_hero
doit
	dec speedp
	rts
.)
shoot
.(
	lda just_shot
	beq cando
	rts
cando
	ldx #FIRST_SHOT
	lda quick_shot
	bne loopss
	inx
	inx
	inx
	inx
loopss	
	lda sprite_status,x
	beq found
	inx
	inx
	cpx #MAX_SPRITES+1
	bcc loopss
	rts
	
found	
	lda #5
	sta just_shot
	
	inc sprite_status,x
	inc sprite_status+1,x
	
	lda direction
	bne skip1
	lda #1+1
	.byt $2c
skip1
	lda #$ff-1
	sta sprite_dir,x
	sta sprite_dir+1,x
	lda sprite_cols
	sta sprite_cols,x
	sta sprite_cols+1,x
	lda sprite_rows
	sta sprite_rows,x
	clc
	adc #1
	sta sprite_rows+1,x
	
	lda #7
	sta speedp,x
	sta speedp+1,x
	
	/* Set the graphic for the shot, depending on type */
	lda super_shot
	asl
	tay
	lda ssl,y
	sta sprite_grapl,x
	lda ssh,y
	sta sprite_graph,x	
	lda ssl+1,y
	sta sprite_grapl+1,x
	lda ssh+1,y
	sta sprite_graph+1,x
	lda mml,y
	sta sprite_maskl,x
	lda mmh,y
	sta sprite_maskh,x
	lda mml+1,y
	sta sprite_maskl+1,x
	lda mmh+1,y
	sta sprite_maskh+1,x
	

	lda #SHOOT
	jsr _PlaySfx
	
	jsr control_shot
	inx
	jmp control_shot

.)


change_direction
.(
	lda direction
	eor #$ff
	sta direction
	beq toright2
	lda #$ff
	.byt $2c
toright2
	lda #$1
	sta sprite_dir
	sta sprite_dir+1
	
+update_pointers_flat
	lda #<_sprite_manta
	sta sprite_grapl
	lda #>_sprite_manta
	sta sprite_graph
	lda #<_mask_manta
	sta sprite_maskl
	sta sprite_maskl+1
	lda #>_mask_manta
	sta sprite_maskh
	sta sprite_maskh+1
	rts
.)
