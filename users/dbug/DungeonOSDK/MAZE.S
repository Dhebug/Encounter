;
;
; 3D Maze gestion 6502 assembly library
; (c) 1996 Micka‰l POINTIER  (Dbug from NeXT)
;
;
; "_Level"              Numero literal du niveau
; "_LevelOffset"        Offset direct de la map (_Level*1024) [Decallages tres lents sur 6502]
;



_GetType
	;
	; Read Yposition
	;
	ldy	#2
	lda	(sp),y			; Y position
	bmi	gettype_out
	cmp	#32
	bcs	gettype_out

	;
	; Y*32
	;
	sta	gettype_readmap+1
	lda	#0

	asl	gettype_readmap+1
	rol	
	asl	gettype_readmap+1
	rol	
	asl	gettype_readmap+1
	rol	
	asl	gettype_readmap+1
	rol	
	asl	gettype_readmap+1
	rol	

	sta	gettype_readmap+2

	ldy	#0
	lda	(sp),y			; X position
	bmi	gettype_out
	cmp	#32
	bcs	gettype_out
	tax				; Memo X position

	;
	; +Level*1024
	;
	clc
	lda	gettype_readmap+1
	adc	_LevelOffset		; +Offset lower part
	sta	gettype_readmap+1
	lda	_LevelOffset+1
	adc	gettype_readmap+2
	sta	gettype_readmap+2


gettype_readmap
	ldy	$2211,x 		; Level*1024+y*32+x
	ldx	_GroundType,y
	lda	#0
	rts

gettype_out
	ldx	#1+4			; SOLIDE+OPAQUE
	lda	#0
	rts

;
; int GetType(int x,int y)
; {
;     if ((x<0) OR (y<0) OR (x>31) OR (y>31))	      return GROUND_SOLIDE|GROUND_OPAQUE;
;     else					      return GroundType[Map[Level][y][x]];
; }
;

