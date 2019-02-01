
;void DisplayRotoZoom()
;{
;	unsigned char	*screen_adress;
;	unsigned int	x,y;
;
;	screen_adress	=(unsigned char*)0xBB80+3;
;	for (y=0;y<25;y++)
;	{
;		U=MU;
;		MU-=IV;
;
;		V=MV;
;		MV+=IU;
;
;		for (x=0;x<37;x++)
;		{			
;			Adress=(unsigned int)Picture;
;			*(((unsigned char*)&Adress)+0)+=*(((unsigned char*)&U)+1);
;			*(((unsigned char*)&Adress)+1)+=(*(((unsigned char*)&V)+1))&63;
;
;			*screen_adress=*((unsigned char*)Adress);
;
;			screen_adress++;
;			U+=IU;
;			V+=IV;
;		}
;		screen_adress+=3;
;	}
;}




#define SCREEN_TEXT	 $bb80


    .zero 

_U	 .dsb 1 ;   tmp1
_U1	 .dsb 1 ;	tmp1+1
_V	 .dsb 1 ;   tmp1+2
_V1	 .dsb 1 ;	tmp1+3
_IU	 .dsb 1 ;	tmp1+4
_IU1 .dsb 1 ;	tmp1+5
_IV	 .dsb 1 ;	tmp1+6
_IV1 .dsb 1 ;	tmp1+7
_MU	 .dsb 1 ;	tmp1+8
_MU1 .dsb 1 ;	tmp1+9
_MV	 .dsb 1 ;	tmp1+10
_MV1 .dsb 1 ;	tmp1+11

    .text


_DisplayRotoZoomLine

	;		U=MU;
	;		MU-=IV;
	
	sec
	lda _MU
	sta _U
	sbc _IV
	sta _MU

	lda _MU1
	sta _U1
	sbc _IV1
	sta _MU1

	;		V=MV;
	;		MV+=IU;

	clc
	lda _MV
	sta _V
	adc _IU
	sta _MV
	lda _MV1
	sta _V1
	adc _IU1
	sta _MV1

	;		for (x=0;x<37;x++)

	ldx	#37		; 37 columns
loop_draw_x

	;			Adress=(unsigned int)Picture;
	;			*(((unsigned char*)&Adress)+0)+=*(((unsigned char*)&U)+1);
	;			U+=IU;
	;			*(((unsigned char*)&Adress)+1)+=(*(((unsigned char*)&V)+1))&63;
	;			V+=IV;

	clc
	lda	_U
	adc _IU
	sta _U
	lda _U1
	adc _IU1
	sta _U1
	;clc
	;adc #<(_Picture)
	sta _adr_read_pixel+1

	clc
	lda	_V
	adc _IV
	sta _V
	lda _V1
	adc _IV1
	sta _V1
	and #63
	clc
	adc #>(_Picture)
	sta _adr_read_pixel+2

_adr_read_pixel
	lda	$1234

	;			*screen_adress=*((unsigned char*)Adress);
	;			screen_adress++;

screen_adr
	sta	$bb80,x

	dex
	bne	loop_draw_x

	;		screen_adress+=3;

	clc
	lda	screen_adr+1
	adc	#40
	sta	screen_adr+1
	lda	screen_adr+2
	adc	#0
	sta	screen_adr+2

	dey
	bne _DisplayRotoZoomLine
	rts


_DisplayRotoZoomAsm	
	;	screen_adress	=(unsigned char*)0xBB80+3;
	
	lda	#<(SCREEN_TEXT+2)
	sta	screen_adr+1
	lda	#>(SCREEN_TEXT+2)
	sta	screen_adr+2

	;	for (y=0;y<25;y++)
	ldy	#25
	jsr	_DisplayRotoZoomLine
	rts

	ldy	#6
	jsr	_DisplayRotoZoomLine
	;jsr	_PlayMusic
	ldy	#6
	jsr	_DisplayRotoZoomLine
	;jsr	_PlayMusic
	ldy	#6
	jsr	_DisplayRotoZoomLine
	;jsr	_PlayMusic
	ldy	#7
	jsr	_DisplayRotoZoomLine
	;jsr	_PlayMusic
	rts

	.dsb 256-(*&255)

_CosTable
    .byt       127 
    .byt       126 
    .byt       126 
    .byt       126 
    .byt       126 
    .byt       126 
    .byt       125 
    .byt       125 
    .byt       124 
    .byt       123 
    .byt       123 
    .byt       122 
    .byt       121 
    .byt       120 
    .byt       119 
    .byt       118 
    .byt       117 
    .byt       116 
    .byt       114 
    .byt       113 
    .byt       112 
    .byt       110 
    .byt       108 
    .byt       107 
    .byt       105 
    .byt       103 
    .byt       102 
    .byt       100 
    .byt       98 
    .byt       96 
    .byt       94 
    .byt       91 
    .byt       89 
    .byt       87 
    .byt       85 
    .byt       82 
    .byt       80 
    .byt       78 
    .byt       75 
    .byt       73 
    .byt       70 
    .byt       67 
    .byt       65 
    .byt       62 
    .byt       59 
    .byt       57 
    .byt       54 
    .byt       51 
    .byt       48 
    .byt       45 
    .byt       42 
    .byt       39 
    .byt       36 
    .byt       33 
    .byt       30 
    .byt       27 
    .byt       24 
    .byt       21 
    .byt       18 
    .byt       15 
    .byt       12 
    .byt       9 
    .byt       6 
    .byt       3 
    .byt       0 
    .byt      255-4 
    .byt      255-7 
    .byt      255-10 
    .byt      255-13 
    .byt      255-16 
    .byt      255-19 
    .byt      255-22 
    .byt      255-25 
    .byt      255-28 
    .byt      255-31 
    .byt      255-34 
    .byt      255-37 
    .byt      255-40 
    .byt      255-43 
    .byt      255-46 
    .byt      255-49 
    .byt      255-52 
    .byt      255-55 
    .byt      255-58 
    .byt      255-60 
    .byt      255-63 
    .byt      255-66 
    .byt      255-68 
    .byt      255-71 
    .byt      255-74 
    .byt      255-76 
    .byt      255-79 
    .byt      255-81 
    .byt      255-83 
    .byt      255-86 
    .byt      255-88 
    .byt      255-90 
    .byt      255-92 
    .byt      255-95 
    .byt      255-97 
    .byt      255-99 
    .byt      255-101 
    .byt      255-103 
    .byt      255-104 
    .byt      255-106 
    .byt      255-108 
    .byt      255-109 
    .byt      255-111 
    .byt      255-113 
    .byt      255-114 
    .byt      255-115 
    .byt      255-117 
    .byt      255-118 
    .byt      255-119 
    .byt      255-120 
    .byt      255-121 
    .byt      255-122 
    .byt      255-123 
    .byt      255-124 
    .byt      255-124 
    .byt      255-125 
    .byt      255-126 
    .byt      255-126 
    .byt      255-127 
    .byt      255-127 
    .byt      255-127 
    .byt      255-127 
    .byt      255-127 
    .byt      255-127 
    .byt      255-127 
    .byt      255-127 
    .byt      255-127 
    .byt      255-127 
    .byt      255-127 
    .byt      255-126 
    .byt      255-126 
    .byt      255-125 
    .byt      255-124 
    .byt      255-124 
    .byt      255-123 
    .byt      255-122 
    .byt      255-121 
    .byt      255-120 
    .byt      255-119 
    .byt      255-118 
    .byt      255-117 
    .byt      255-115 
    .byt      255-114 
    .byt      255-113 
    .byt      255-111 
    .byt      255-109 
    .byt      255-108 
    .byt      255-106 
    .byt      255-104 
    .byt      255-103 
    .byt      255-101 
    .byt      255-99 
    .byt      255-97 
    .byt      255-95 
    .byt      255-92 
    .byt      255-90 
    .byt      255-88 
    .byt      255-86 
    .byt      255-83 
    .byt      255-81 
    .byt      255-79 
    .byt      255-76 
    .byt      255-74 
    .byt      255-71 
    .byt      255-68 
    .byt      255-66 
    .byt      255-63 
    .byt      255-60 
    .byt      255-58 
    .byt      255-55 
    .byt      255-52 
    .byt      255-49 
    .byt      255-46 
    .byt      255-43 
    .byt      255-40 
    .byt      255-37 
    .byt      255-34 
    .byt      255-31 
    .byt      255-28 
    .byt      255-25 
    .byt      255-22 
    .byt      255-19 
    .byt      255-16 
    .byt      255-13 
    .byt      255-10 
    .byt      255-7 
    .byt      255-4 
    .byt      255-1 
    .byt       3 
    .byt       6 
    .byt       9 
    .byt       12 
    .byt       15 
    .byt       18 
    .byt       21 
    .byt       24 
    .byt       27 
    .byt       30 
    .byt       33 
    .byt       36 
    .byt       39 
    .byt       42 
    .byt       45 
    .byt       48 
    .byt       51 
    .byt       54 
    .byt       57 
    .byt       59 
    .byt       62 
    .byt       65 
    .byt       67 
    .byt       70 
    .byt       73 
    .byt       75 
    .byt       78 
    .byt       80 
    .byt       82 
    .byt       85 
    .byt       87 
    .byt       89 
    .byt       91 
    .byt       94 
    .byt       96 
    .byt       98 
    .byt       100 
    .byt       102 
    .byt       103 
    .byt       105 
    .byt       107 
    .byt       108 
    .byt       110 
    .byt       112 
    .byt       113 
    .byt       114 
    .byt       116 
    .byt       117 
    .byt       118 
    .byt       119 
    .byt       120 
    .byt       121 
    .byt       122 
    .byt       123 
    .byt       123 
    .byt       124 
    .byt       125 
    .byt       125 
    .byt       126 
    .byt       126 
    .byt       126 
    .byt       126 
    .byt       126 


