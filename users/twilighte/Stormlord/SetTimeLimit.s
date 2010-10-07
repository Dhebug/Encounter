;SetTimeLimit.s

	
SetTimeLimit	
	;Sunmoon speed is based on level aswell as difficulty
	;Difficulty == 0-2
	;level == 0-2
	lda MapX
	cmp #237
.(
	beq skip1
	lda Option_Difficulty
	asl
	asl
	ora LevelID
rent1	tax
	lda TimeLimit,x
	sta CounterReference

	lda #00
	sta usm_SunMoonYPos
	sta usm_RowIndex
	jmp UpdateSunMoon_Cont
skip1	lda Option_Difficulty
	asl
	asl
	ora #3
	jmp rent1
.)

TimeLimit
 .byt 160	;Level 1 Novice
 .byt 165	;Level 2 Novice
 .byt 180	;Level 3 Novice
 .byt 20	;Bonus Novice
 .byt 110	;Level 1 Normal
 .byt 120	;Level 2 Normal
 .byt 135	;Level 3 Normal
 .byt 10	;Bonus Normal
 .byt 65	;Level 1 Insane - Perfect
 .byt 80	;Level 2 Insane - Perfect
 .byt 95	;Level 3 Insane - ?
 .byt 2	;Bonus Insane

;;Sunmoon rates based on Difficulty
;GameSpeed
; .byt 200	;Easy
; .byt 160	;Normal
; .byt 140 ;Insane
