; change by mmu_man 20140516:
; added logo overlay

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

_DisplayJSun
	lda	#<(_angle+40*23)
	sta	_js_mod_angle+1
	lda	#>(_angle+40*23)
	sta	_js_mod_angle+2

	lda	#<(_prof+40*23)
	sta	_js_mod_prof+1
	lda	#>(_prof+40*23)
	sta	_js_mod_prof+2

	lda	#<($a000+40*(46-20))
	sta	_js_mod_screen+1
	lda	#>($a000+40*(47-20))
	sta	_js_mod_screen+2

	lda	#<($a000+40*(47-20))
	sta	_js_mod_screen2+1
	lda	#>($a000+40*(47-20))
	sta	_js_mod_screen2+2

	lda	#<($a000+40*(48-20))
	sta	_js_mod_screen3+1
	lda	#>($a000+40*(48-20))
	sta	_js_mod_screen3+2


	lda	#<(_logobuf+40*0)
	sta	_js_mod_logo1+1
	lda	#>(_logobuf+40*0)
	sta	_js_mod_logo1+2

	lda	#<(_logobuf+40*1)
	sta	_js_mod_logo2+1
	lda	#>(_logobuf+40*1)
	sta	_js_mod_logo2+2

	lda	#<(_logobuf+40*2)
	sta	_js_mod_logo3+1
	lda	#>(_logobuf+40*2)
	sta	_js_mod_logo3+2


;	lda	_IncX
;	sta	_js_mod_text+1	; Lowbyte of Texture adress

;	lda	_IncY
;	and	#31
;	clc
;	adc	#>(_Texture)
;	sta	_js_mod_text_high+1	; High byte of Texture adress

	;
	; Start of display
	;
	clc
	ldy	#55
_js_loop_y
	sty	oldy

	ldx	#39

	;--------------------------------

_js_loop_x

_js_mod_angle
	lda	$1234,x 	; Load ANGLE from table[x][y]
;;	 clc
;_js_mod_text_high
;	adc	#$12		; Add texture > byte
;	sta	_js_mod_text+2

;_js_mod_prof
;	ldy	$1234,x 	; Get prof
;_js_mod_text
;	lda	_Texture,y	; Get pixel from texture

	clc
; add current angle
	adc	_IncY

; if (angle / 16) % 2
	and #16

;   set color / pattern
	bne _js_color2


_js_color1
	ldy #$40 ; 17
	jmp _js_coldone
_js_color2

_js_mod_prof
	lda	$1234,x 	; Get prof

	clc
	sbc _IncX
	and #$C0
	beq _js_color1


	ldy #$7f ; 18
_js_coldone

	; save pattern
	;tay

_js_mod_logo1
	lda $1234,x
	;cmp #$41
	;bpl _js_mod_screen
	cpy #$40
	beq _js_mod_screen
	;tya
	;cmp #$40
	;bmi _js_mod_screen
	eor #$80

_js_mod_screen
	sta	$1234,x 	; Put pixel on screen

_js_mod_logo2
	lda $1234,x
	;cmp #$41
	;bpl _js_mod_screen2
	cpy #$40
	beq _js_mod_screen2
	;tya
	;cmp #$40
	;bmi _js_mod_screen2
	eor #$80

_js_mod_screen2
	sta	$1234,x 	; Put pixel on screen

_js_mod_logo3
	lda $1234,x
	;cmp #$41
	;bpl _js_mod_screen3
	cpy #$40
	beq _js_mod_screen3
	;tya
	;cmp #$40
	;bmi _js_mod_screen3
	eor #$80

_js_mod_screen3
	sta	$1234,x 	; Put pixel on screen

	dex
	;cpx	#40
	bpl	_js_loop_x

	;--------------------------------

	;
	; Inc screen adress
	;
	clc
	lda	_js_mod_screen+1
	adc	#120
	sta	_js_mod_screen+1
	bcc _js_noinc_screen
	inc _js_mod_screen+2
_js_noinc_screen

	clc
	lda	_js_mod_screen2+1
	adc	#120
	sta	_js_mod_screen2+1
	bcc _js_noinc_screen2
	inc _js_mod_screen2+2
_js_noinc_screen2

	clc
	lda	_js_mod_screen3+1
	adc	#120
	sta	_js_mod_screen3+1
	bcc _js_noinc_screen3
	inc _js_mod_screen3+2
_js_noinc_screen3

	clc
	lda	_js_mod_logo1+1
	adc	#120
	sta	_js_mod_logo1+1
	bcc _js_noinc_logo1
	inc _js_mod_logo1+2
_js_noinc_logo1

	clc
	lda	_js_mod_logo2+1
	adc	#120
	sta	_js_mod_logo2+1
	bcc _js_noinc_logo2
	inc _js_mod_logo2+2
_js_noinc_logo2

	clc
	lda	_js_mod_logo3+1
	adc	#120
	sta	_js_mod_logo3+1
	bcc _js_noinc_logo3
	inc _js_mod_logo3+2
_js_noinc_logo3


	clc
	lda	_js_mod_angle+1
	adc	#40
	sta	_js_mod_angle+1
	bcc _js_noinc_angle
	inc _js_mod_angle+2
_js_noinc_angle

	clc
	lda	_js_mod_prof+1
	adc	#40
	sta	_js_mod_prof+1
	bcc _js_noinc_prof
	inc _js_mod_prof+2
_js_noinc_prof

	;
	; End loop Y
	;
	ldy	oldy
	dey
	bne	_js_loop_y_


	rts
; relative jump too far
_js_loop_y_
	jmp _js_loop_y
