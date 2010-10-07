;Generic Code

nl_screen
	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts

AddBGBuff
	clc
	adc bgbuff
	sta bgbuff
	lda bgbuff+1
	adc #00
	sta bgbuff+1
	rts

DestroyNPC	;Passed in X
	cpx NPCUltimateIndex
.(
	beq skip1
	ldy NPCUltimateIndex
	lda NPC_Activity,y
	sta NPC_Activity,x
	lda NPC_Progress,y
	sta NPC_Progress,x
	lda NPC_ScreenX,y
	sta NPC_ScreenX,x
	lda NPC_ScreenY,y
	sta NPC_ScreenY,x
	lda NPC_ScreenXOrigin,y
	sta NPC_ScreenXOrigin,x
	lda NPC_ScreenYOrigin,y
	sta NPC_ScreenYOrigin,x
	lda NPC_Count,y
	sta NPC_Count,x
	lda NPC_Special,y
	sta NPC_Special,x
skip1	dec NPCUltimateIndex
.)
	rts
