
;
; L'algo de base, avant optimisation et changement de format:
;
;   ptr_screen=(unsigned char*)0xa000;
;   ptr_line=ptr_screen;
;   ptr_angle=angle;
;   ptr_prof =prof;
;   ix=IncX;
;   iy=IncY;
;   for (y=0;y<100;y++)
;   {
;		for (x=0;x<40;x++)
;		{
;			tx=(ptr_angle[x]+ix) & 63;
;			ty=(ptr_prof[x]+iy) & 63;
;			ptr_line[x]=Texture[tx][ty];
;		}
;		ptr_line+=80;
;		ptr_angle+=40;
;		ptr_prof+=40;
;   }
;   IncX++;
;   IncY++;



;oldx	equ	tmp5
;oldy	equ	tmp5+1

_DisplayTunel
	lda	#<(_TableAngle)
	sta	_mod_angle+1
	lda	#>(_TableAngle)
	sta	_mod_angle+2

	lda	#<(_prof)
	sta	_mod_prof+1
	lda	#>(_prof)
	sta	_mod_prof+2

	lda	#<($bb80+3)
	sta	_mod_screen+1
	lda	#>($bb80+3)
	sta	_mod_screen+2

	lda	_IncX
	sta	_mod_angle_inc+1

	lda	_IncY
	sta	_mod_prof_inc+1

	;
	; Start of display
	;
	ldy	#25
loop_y
	;sty	oldy

	ldx	#0

	;--------------------------------

loop_x

_mod_prof
	lda	$1234,x 	; Load ANGLE from table[x][y]
	clc
_mod_prof_inc
	adc	#$12		; Add IncY
	sta	_mod_text+1

_mod_angle
	lda	$1234,x 	; Get prof
	clc
_mod_angle_inc
	adc	#$12		; Add IncY
	and #63
	clc
	adc	#>(_Picture)
	sta _mod_text+2;

_mod_text
	lda	_Picture	; Get pixel from texture

_mod_screen
	sta	$1234,x 	; Put pixel on screen

	inx
	cpx	#37
	bne	loop_x

	;--------------------------------

	;
	; Inc screen adress
	;
	clc
	lda	_mod_screen+1
	adc	#40
	sta	_mod_screen+1
	lda	_mod_screen+2
	adc	#0
	sta	_mod_screen+2

	clc
	lda	_mod_angle+1
	adc	#<(40*4)
	sta	_mod_angle+1
	lda	_mod_angle+2
	adc	#>(40*4)
	sta	_mod_angle+2

	clc
	lda	_mod_prof+1
	adc	#<(40*4)
	sta	_mod_prof+1
	lda	_mod_prof+2
	adc	#>(40*4)
	sta	_mod_prof+2

	;
	; End loop Y
	;
	;ldy	oldy
	dey
	bne	loop_y


	rts

