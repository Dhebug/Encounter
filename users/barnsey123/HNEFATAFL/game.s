
_setcheckmode1
	lda #1
	sta _checkroutemode
	rts
	
_setcheckmode2
	lda #2
	sta _checkroutemode
	rts
	
_setcheckmode3
	lda #3
	sta _checkroutemode
	rts	

_setcheckmode4
	lda #4
	sta _checkroutemode
	rts
	
_incmodeone
	inc _modeonevalid
	rts
	
_incroute
	inc _route
	rts

_decroute
	dec _route
	rts

_incpoints
	inc _points
	rts
	
_decpoints
.(
	dec _points
	bne end
	inc _points
end
	rts
.)	
	
_setpoints
	lda #10
	sta _points
	rts
; adds ten to points value 	OR adds hightarget to points
_doublepoints
	clc
	lda _points
	adc #10
	;adc _hightarget
	sta _points
	rts

_incsurround
	inc _surrounded
	rts
	
; multiply the points around king depending on the "surrounded" figure	
_surroundpoints
.(
	lda _points
	ldx _surrounded
loop	
	beq end
	clc
	adc #10
	dex
	bne loop
end	
	sta _point
	rts
.)	
	
_inccounter
	inc _counter
	rts

_zeroarrow
	lda #0
	sta _arrow
	rts
	
_zerocounter
	lda #0
	sta _counter
	rts

_zerofoundpiece
	lda #0
	sta _foundpiece
	rts