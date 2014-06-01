
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




#define ix		tmp3
#define iy		tmp3+1
#define angle	tmp4
#define prof	tmp4+1
#define oldx	tmp5
#define oldy	tmp5+1

_DisplayTunel
	lda	#<(_angle+40*23)
	sta	_mod_angle+1
	lda	#>(_angle+40*23)
	sta	_mod_angle+2

	lda	#<(_prof+40*23)
	sta	_mod_prof+1
	lda	#>(_prof+40*23)
	sta	_mod_prof+2

	lda	#<($a000+40*46)
	sta	_mod_screen+1
	lda	#>($a000+40*46)
	sta	_mod_screen+2

	lda	_IncX
	sta	_mod_text+1	; Lowbyte of Texture adress

	lda	_IncY
	and	#31
	clc
	adc	#>(_Texture)
	sta	_mod_text_high+1	; High byte of Texture adress

	;
	; Start of display
	;
	clc
	ldy	#55
loop_y
	sty	oldy

	ldx	#0

	;--------------------------------

loop_x

_mod_angle
	lda	$1234,x 	; Load ANGLE from table[x][y]
;	 clc
_mod_text_high
	adc	#$12		; Add texture > byte
	sta	_mod_text+2

_mod_prof
	ldy	$1234,x 	; Get prof
_mod_text
	lda	_Texture,y	; Get pixel from texture

_mod_screen
	sta	$1234,x 	; Put pixel on screen

	inx
	cpx	#40
	bne	loop_x

	;--------------------------------

	;
	; Inc screen adress
	;
	clc
	lda	_mod_screen+1
	adc	#80
	sta	_mod_screen+1
	lda	_mod_screen+2
	adc	#0
	sta	_mod_screen+2

	clc
	lda	_mod_angle+1
	adc	#40
	sta	_mod_angle+1
	lda	_mod_angle+2
	adc	#0
	sta	_mod_angle+2

	clc
	lda	_mod_prof+1
	adc	#40
	sta	_mod_prof+1
	lda	_mod_prof+2
	adc	#0
	sta	_mod_prof+2

	;
	; End loop Y
	;
	ldy	oldy
	dey
	bne	loop_y


	rts

