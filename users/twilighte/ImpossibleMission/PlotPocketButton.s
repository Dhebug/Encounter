;PlotPocketButton.s
;Separate source file because of added complexity of shared display divisions

;PlotButtonUp
;	;Reduce CursorX from 0-4 to 0-3 and combine with Y to form 12 value index in A
;	jsr CreateButtonXYInA
;	
;	;Use to Fetch object
;	tax
;	lda UpButtonObject,x
;	sta Object_V
;	
;	;Now get the Button position
;	lda ButtonX,x
;	sta Object_X
;	lda ButtonY,x
;	sta Object_Y
;	
;	;And plot left button border column
;	jmp DisplayGraphicObject
	
PlotButtonDown
	;Reduce CursorX from 0-4 to 0-3 and combine with Y to form 12 value index in A
	jsr CreateButtonXYInA
	
	;Use to Fetch Left object
	tax
	lda DownButtonObject,x
	sta Object_V
	
	;Now get the Button position
	lda ButtonX,x
	sta Object_X
	lda ButtonY,x
	sta Object_Y
	
	;And plot left button border column
	jmp DisplayGraphicObject
	
CreateButtonXYInA
	ldx CursorX
	txa
.(
	bne skip1
	inx
skip1	dex
.)	
	;Combine with Y to create 12 value index
.(
	stx vector1+1
	tay
	lda CursorY,y
	asl
	asl
vector1	ora #00
.)
	rts



;UpButtonObject
; .byt OBJ_UPPOWER	 ;0,0
; .byt OBJ_UPFLIP	  ;1,0
; .byt OBJ_UPMIRROR	;2,0
; .byt OBJ_UPUNDO	  ;3,0
; .byt OBJ_UPDISK	  ;0,1
; .byt OBJ_UPAMBER	 ;1,1
; .byt OBJ_UPGREEN	 ;2,1
; .byt OBJ_UPWHITE	 ;3,1
; .byt OBJ_UPMODEM	 ;0,2
; .byt OBJ_UPSOUND	 ;1,2
; .byt OBJ_UPSTATS	 ;2,2
; .byt OBJ_UPPAUSE	 ;3,2
DownButtonObject
 .byt OBJ_DOWNPOWER		;0,0
 .byt OBJ_DOWNFLIP		 ;1,0
 .byt OBJ_DOWNMIRROR	;2,0
 .byt OBJ_DOWNUNDO		 ;3,0
 .byt OBJ_DOWNDISK		 ;0,1
 .byt OBJ_DOWNAMBER		;1,1
 .byt OBJ_DOWNGREEN		;2,1
 .byt OBJ_DOWNWHITE		;3,1
 .byt OBJ_DOWNMODEM		;0,2
 .byt OBJ_DOWNSOUND		;1,2
 .byt OBJ_DOWNSTATS		;2,2
 .byt OBJ_DOWNPAUSE		;3,2
ButtonX
 .byt 1	;gfx_DownPower	
 .byt 30	;gfx_DownFlip	
 .byt 33	;gfx_DownMirror
 .byt 36	;gfx_DownUndo	
 .byt 1	;gfx_DownDisk	
 .byt 30	;gfx_DownAmber	
 .byt 33	;gfx_DownGreen	
 .byt 36	;gfx_DownWhite	
 .byt 1	;gfx_DownModem	
 .byt 30	;gfx_DownSound	
 .byt 33	;gfx_DownStats	
 .byt 36	;gfx_DownPause	
ButtonY
 .byt 153	;gfx_DownPower	
 .byt 153	;gfx_DownFlip	
 .byt 153	;gfx_DownMirror
 .byt 153	;gfx_DownUndo	
 .byt 168	;gfx_DownDisk	
 .byt 168	;gfx_DownAmber	
 .byt 168	;gfx_DownGreen	
 .byt 168	;gfx_DownWhite	
 .byt 183	;gfx_DownModem	
 .byt 183	;gfx_DownSound	
 .byt 183	;gfx_DownStats	
 .byt 183	;gfx_DownPause	




