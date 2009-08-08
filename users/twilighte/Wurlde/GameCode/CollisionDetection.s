;CollisionDetection.s



;CheckBackgroundExit
;	;Also use this opportunity to locate any background exit
;	ldy ScreenID
;	lda LevelBackgroundEntrancesVectorsLo,y
;.(
;	sta vector1+1
;	lda LevelBackgroundEntrancesVectorsHi,y
;	sta vector1+2
;	ldx HeroX
;vector1	ldy $dead,x
;.)
;	sty CurrentBGExit
;.(
;	beq skip1
;	;Found Exit to BG - Glow Devils Head
;	lda #gh_Glowing
;	sta HeadAction
;	rts
;skip1	;No Exit - Remove Glow
;.)
;	lda #gh_Normal
;	sta HeadAction
;	rts

UpdateExitArrows
	;Check Right Exit
	lda ssc_ScreenRules
	ldy #gf_Normal
	and #%00001000
.(
	beq skip1
	;Set Devils hand to Point Right
	ldy #gf_Pointing
	lda #00
	sta RightHandIndex
skip1	sty RightHandAction
.)
	lda ssc_ScreenRules
	ldy #gf_Normal
	and #%00000100
.(
	beq skip1
	;Set Devils hand to Point Left
	ldy #gf_Pointing
	lda #00
	sta LeftHandIndex
skip1	sty LeftHandAction
.)
	rts


