
;
; This file should contain everything related to the display of text/sprites from a bitmap
;

; Our picture file contains a number of different fonts
; 6x12 lower case
; 8x9 upper case
; 11x19 lower case
; 18x18 Upper case
; each font contains letters from a-z, A-Z, numbers, and some punctation (9 signs)
; Total is 26+26+10+9=71 characters per font, 142 characters in total on the page

; For each character we need
; x0
; y0
; width
; height
; base line
; -> 5 bytes per character, x136=680 bytes

;                    a b c  d  e  f  g  h  i  j k l m n o p q r s t u v w x y z
;_FontCharX0		.byt 0,7,14,20,27,34,39,46,53,57
;_FontCharY0     .byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;_FontCharWidth  .byt 6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
;_FontCharHeight .byt 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
;_FontCharBase   .byt 8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8

; Should probably be exported automatically by PictConv with a dedicated format to extract rectangles.


	.zero

_CAR	.dsb 1

src_x	.dsb 1
src_y	.dsb 1
dst_x	.dsb 1
dst_y	.dsb 1
w 		.dsb 1
h 		.dsb 1


	.text


_FontInit
.(
	; Set the default base charset
	lda #0
	sta _FontCharOffset
	
	ldx #0
loop_clear
	sta _FontIndex,x
	inx
	bne loop_clear
	
loop_init	
	ldy _FontChars,x
	beq exit
	txa
	sta _FontIndex,y
	inx
	jmp loop_init
exit	
	rts
.)


; First, black paper attribute (16)
; Then replace by neutral (64) value
_BlackScreen
.(
	lda #16
	sta __patch_color+1
	jsr FillScreen
	lda #64
	sta __patch_color+1
	jsr FillScreen
	rts
	
FillScreen
__patch_color
	lda #16
	
	ldy #40
loop_x	
	sta $a000-1+40*0,y
	sta $a000-1+40*1,y
	sta $a000-1+40*2,y
	sta $a000-1+40*3,y
	sta $a000-1+40*4,y
	sta $a000-1+40*5,y
	sta $a000-1+40*6,y
	sta $a000-1+40*7,y
	sta $a000-1+40*8,y
	sta $a000-1+40*9,y
	
	sta $a000-1+40*10,y
	sta $a000-1+40*11,y
	sta $a000-1+40*12,y
	sta $a000-1+40*13,y
	sta $a000-1+40*14,y
	sta $a000-1+40*15,y
	sta $a000-1+40*16,y
	sta $a000-1+40*17,y
	sta $a000-1+40*18,y
	sta $a000-1+40*19,y
	
	sta $a000-1+40*20,y
	sta $a000-1+40*21,y
	sta $a000-1+40*22,y
	sta $a000-1+40*23,y
	sta $a000-1+40*24,y
	sta $a000-1+40*25,y
	sta $a000-1+40*26,y
	sta $a000-1+40*27,y
	sta $a000-1+40*28,y
	sta $a000-1+40*29,y

	sta $a000-1+40*30,y
	sta $a000-1+40*31,y
	sta $a000-1+40*32,y
	sta $a000-1+40*33,y
	sta $a000-1+40*34,y
	sta $a000-1+40*35,y
	sta $a000-1+40*36,y
	sta $a000-1+40*37,y
	sta $a000-1+40*38,y
	sta $a000-1+40*39,y

	sta $a000-1+40*40,y
	sta $a000-1+40*41,y
	sta $a000-1+40*42,y
	sta $a000-1+40*43,y
	sta $a000-1+40*44,y
	sta $a000-1+40*45,y
	sta $a000-1+40*46,y
	sta $a000-1+40*47,y
	sta $a000-1+40*48,y
	sta $a000-1+40*49,y
			
	sta $a000-1+40*50,y
	sta $a000-1+40*51,y
	sta $a000-1+40*52,y
	sta $a000-1+40*53,y
	sta $a000-1+40*54,y
	sta $a000-1+40*55,y
	sta $a000-1+40*56,y
	sta $a000-1+40*57,y
	sta $a000-1+40*58,y
	sta $a000-1+40*59,y
	
	sta $a000-1+40*60,y
	sta $a000-1+40*61,y
	sta $a000-1+40*62,y
	sta $a000-1+40*63,y
	sta $a000-1+40*64,y
	sta $a000-1+40*65,y
	sta $a000-1+40*66,y
	sta $a000-1+40*67,y
	sta $a000-1+40*68,y
	sta $a000-1+40*69,y
	
	sta $a000-1+40*70,y
	sta $a000-1+40*71,y
	sta $a000-1+40*72,y
	sta $a000-1+40*73,y
	sta $a000-1+40*74,y
	sta $a000-1+40*75,y
	sta $a000-1+40*76,y
	sta $a000-1+40*77,y
	sta $a000-1+40*78,y
	sta $a000-1+40*79,y

	sta $a000-1+40*80,y
	sta $a000-1+40*81,y
	sta $a000-1+40*82,y
	sta $a000-1+40*83,y
	sta $a000-1+40*84,y
	sta $a000-1+40*85,y
	sta $a000-1+40*86,y
	sta $a000-1+40*87,y
	sta $a000-1+40*88,y
	sta $a000-1+40*89,y

	sta $a000-1+40*90,y
	sta $a000-1+40*91,y
	sta $a000-1+40*92,y
	sta $a000-1+40*93,y
	sta $a000-1+40*94,y
	sta $a000-1+40*95,y
	sta $a000-1+40*96,y
	sta $a000-1+40*97,y
	sta $a000-1+40*98,y
	sta $a000-1+40*99,y
				
	sta $a000-1+40*100,y
	sta $a000-1+40*101,y
	sta $a000-1+40*102,y
	sta $a000-1+40*103,y
	sta $a000-1+40*104,y
	sta $a000-1+40*105,y
	sta $a000-1+40*106,y
	sta $a000-1+40*107,y
	sta $a000-1+40*108,y
	sta $a000-1+40*109,y
	
	sta $a000-1+40*110,y
	sta $a000-1+40*111,y
	sta $a000-1+40*112,y
	sta $a000-1+40*113,y
	sta $a000-1+40*114,y
	sta $a000-1+40*115,y
	sta $a000-1+40*116,y
	sta $a000-1+40*117,y
	sta $a000-1+40*118,y
	sta $a000-1+40*119,y
	
	sta $a000-1+40*120,y
	sta $a000-1+40*121,y
	sta $a000-1+40*122,y
	sta $a000-1+40*123,y
	sta $a000-1+40*124,y
	sta $a000-1+40*125,y
	sta $a000-1+40*126,y
	sta $a000-1+40*127,y
	sta $a000-1+40*128,y
	sta $a000-1+40*129,y

	sta $a000-1+40*130,y
	sta $a000-1+40*131,y
	sta $a000-1+40*132,y
	sta $a000-1+40*133,y
	sta $a000-1+40*134,y
	sta $a000-1+40*135,y
	sta $a000-1+40*136,y
	sta $a000-1+40*137,y
	sta $a000-1+40*138,y
	sta $a000-1+40*139,y

	sta $a000-1+40*140,y
	sta $a000-1+40*141,y
	sta $a000-1+40*142,y
	sta $a000-1+40*143,y
	sta $a000-1+40*144,y
	sta $a000-1+40*145,y
	sta $a000-1+40*146,y
	sta $a000-1+40*147,y
	sta $a000-1+40*148,y
	sta $a000-1+40*149,y
			
	sta $a000-1+40*150,y
	sta $a000-1+40*151,y
	sta $a000-1+40*152,y
	sta $a000-1+40*153,y
	sta $a000-1+40*154,y
	sta $a000-1+40*155,y
	sta $a000-1+40*156,y
	sta $a000-1+40*157,y
	sta $a000-1+40*158,y
	sta $a000-1+40*159,y
	
	sta $a000-1+40*160,y
	sta $a000-1+40*161,y
	sta $a000-1+40*162,y
	sta $a000-1+40*163,y
	sta $a000-1+40*164,y
	sta $a000-1+40*165,y
	sta $a000-1+40*166,y
	sta $a000-1+40*167,y
	sta $a000-1+40*168,y
	sta $a000-1+40*169,y
	
	sta $a000-1+40*170,y
	sta $a000-1+40*171,y
	sta $a000-1+40*172,y
	sta $a000-1+40*173,y
	sta $a000-1+40*174,y
	sta $a000-1+40*175,y
	sta $a000-1+40*176,y
	sta $a000-1+40*177,y
	sta $a000-1+40*178,y
	sta $a000-1+40*179,y

	sta $a000-1+40*180,y
	sta $a000-1+40*181,y
	sta $a000-1+40*182,y
	sta $a000-1+40*183,y
	sta $a000-1+40*184,y
	sta $a000-1+40*185,y
	sta $a000-1+40*186,y
	sta $a000-1+40*187,y
	sta $a000-1+40*188,y
	sta $a000-1+40*189,y

	sta $a000-1+40*190,y
	sta $a000-1+40*191,y
	sta $a000-1+40*192,y
	sta $a000-1+40*193,y
	sta $a000-1+40*194,y
	sta $a000-1+40*195,y
	sta $a000-1+40*196,y
	sta $a000-1+40*197,y
	sta $a000-1+40*198,y
	sta $a000-1+40*199,y
		
	dey
	beq end
	
	jmp loop_x
end	
	rts	
.)


_BlackScreenSlow
.(
	lda #16
	sta __patch_color+1
	jsr FillScreen
	lda #64
	sta __patch_color+1
	jsr FillScreen
	rts
	
FillScreen
	ldy #40
loop_x	
	lda #<$a000-1
	sta tmp0+0
	lda #>$a000-1
	sta tmp0+1
	
	ldx #200
loop_y
__patch_color
	lda #16
	sta (tmp0),y
	
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1
	
	dex
	bne loop_y
	
	dey
	bne loop_x
	rts	
.)

/*
void DrawCar()
{
	unsigned char *psrc_line;
	unsigned char *pdst_line;
	unsigned char src_x,src_y;
	unsigned char w,h;
	unsigned char x,y;
	
	CAR+=FontCharOffset;
	
	psrc_line=BufferUnpack;
	pdst_line=(unsigned char*)0xa000;
		
	src_x=FontTableX0[CAR];
	src_y=FontTableY0[CAR];
	w =FontTableWidth[CAR];
	h =FontTableHeight[CAR];

	psrc_line+=src_y*40;
	pdst_line+=Y*40;
		
	for (y=0;y<=h;y++)
	{
		for (x=0;x<=w;x++)
		{
			unsigned char *psrc=psrc_line+TableDiv6[src_x+x];
			unsigned char *pdst=pdst_line+TableDiv6[X+x];
			
			if ((*psrc)&TableBit6Reverse[src_x+x])
			{
				// Draw pixel
				(*pdst)|=TableBit6Reverse[X+x];
			}
			else
			{
				// Erase pixel
				(*pdst)&=~TableBit6Reverse[X+x];
			}			
		}
		psrc_line+=40;
		pdst_line+=40;
	}
	X+=w+1;
}
*/

; X,Y,CAR
_DrawCar
.(
	; CAR+=FontCharOffset;
	clc
	lda _FontCharOffset
	adc _CAR
	sta _CAR
	
	; src_x=FontTableX0[CAR];
	; src_y=FontTableY0[CAR];
	; w =FontTableWidth[CAR];
	; h =FontTableHeight[CAR];
	ldx _CAR
	lda _FontTableX0,x
	sta src_x
	lda _FontTableY0,x
	sta src_y
	lda _FontTableWidth,x
	sta w
	lda _FontTableHeight,x
	sta h
	
	
	; psrc_line=BufferUnpack+src_y*40; -> tmp4
	ldy src_y
	clc
	lda _HiresAddrLow,y
	adc #<_BufferUnpack-$a000
	sta tmp4
	lda _HiresAddrHigh,y
	adc #>_BufferUnpack-$a000
	sta tmp4+1
	
	
	; pdst_line=(unsigned char*)0xa000+Y*40; -> tmp5
	ldy _Y
	lda _HiresAddrLow,y
	sta tmp5
	lda _HiresAddrHigh,y
	sta tmp5+1
	
	lda #0
	sta y
loop_y
	lda tmp4+0
	sta tmp2+0
	lda tmp4+1
	sta tmp2+1

	lda tmp5+0
	sta tmp3+0
	lda tmp5+1
	sta tmp3+1
	
	ldx _CAR
	lda _FontTableX0,x
	sta src_x

	ldx _X
	stx dst_x
	
	lda #0
	sta x
loop_x
	;		unsigned char *psrc=psrc_line+TableDiv6[src_x+x];
	;		unsigned char *pdst=pdst_line+TableDiv6[X+x];
	;		
	;		if ((*psrc)&TableBit6Reverse[src_x+x])
	;		{
	;			// Draw pixel
	;			(*pdst)|=TableBit6Reverse[X+x];
	;		}
	;		else
	;		{
	;			// Erase pixel
	;			(*pdst)&=~TableBit6Reverse[X+x];
	;		}
	ldx src_x
	lda _TableDiv6,x
	tay
	lda (tmp4),y
	and _TableBit6Reverse,x
	beq erase_pixel
draw_pixel	

	ldx dst_x
	lda _TableDiv6,x
	tay
	lda (tmp5),y
	ora _TableBit6Reverse,x
	sta (tmp5),y

	jmp end_pixel
	
erase_pixel	

	;ldx dst_x
	;lda _TableDiv6,x
	;tay
	;lda (tmp5),y
	;ora _TableBit6Reverse,x
	;sta (tmp5),y

	jmp end_pixel
	
end_pixel

	inc src_x
	inc dst_x
	
	ldx x
	inx
	stx x
	cpx w
	bne loop_x
	
	; psrc_line+=40;
	; pdst_line+=40;
	
	clc
	lda tmp4+0
	adc #40
	sta tmp4+0
	lda tmp4+1
	adc #0
	sta tmp4+1

	clc
	lda tmp5+0
	adc #40
	sta tmp5+0
	lda tmp5+1
	adc #0
	sta tmp5+1
		
	ldy y
	iny
	sty y
	cpy h
	bne loop_y	
		
	; X+=w+1;
	
	sec
	lda _X
	adc w
	sta _X
	
	rts
.)



/*
void DrawText(char *text)
{
	unsigned char car,x,y;
	unsigned char base_x;
	unsigned char base_y;
	
	base_x=*text++;
	base_y=*text++;
		
	x=base_x;
	y=base_y;
	while (car=*text++)
	{
		if (car==' ')
		{
			x+=FontTableWidth[0];
		}
		else
		if (car==10)
		{
			x=base_x;
			y+=*text++;
		}
		else
		if (car==1)
		{
			FontCharOffset=*text++;
		}
		else
		{
			X=x;
			Y=y;
			CAR=FontIndex[car];
			DrawCar();
			x=X;
		}
	}
}
*/

base_x	.byt 0
base_y	.byt 0

; A+X = text adress
_DrawTextAsm
.(
	sta tmp0+0
	stx tmp0+1

	ldy #0
	lda (tmp0),y
	sta base_x
	sta _X
	iny
	
	lda (tmp0),y
	sta base_y
	sta _Y
	iny
	
loop_car	
	lda (tmp0),y
	beq exit
	iny 
	cmp #32
	beq space
	cmp #10
	beq new_line
	cmp #4
	beq copy_attributes
	cmp #3
	beq offset_y
	cmp #2
	beq offset_x
	cmp #1
	beq change_base	

drawcar
	tax
	lda _FontIndex,x
	sta _CAR	
	sty tmp1
	jsr _DrawCar		; X,Y,CAR
	ldy tmp1
	jmp loop_car
				
offset_x
	clc
	lda _X
	adc (tmp0),y
	sta _X
	iny 
	jmp loop_car
	
space
	clc
	lda _X
	adc _FontTableWidth
	sta _X
	jmp loop_car
	
new_line
	lda base_x
	sta _X
offset_y	
	clc
	lda _Y
	adc (tmp0),y
	sta _Y
	iny 
	jmp loop_car
	
change_base
	lda (tmp0),y
	iny
	sta _FontCharOffset
	jmp loop_car
	
exit
	
	rts

copy_attributes
	;jmp copy_attributes
.(
	sty tmp1
	
	clc
	lda _X
	adc #5
	tax 
	lda _TableDiv6,x
	sta __patch_x2+1
	
	lda (tmp0),y
	tax
	
	ldy _Y
	lda _HiresAddrLow,y
	sta tmp2+0
	lda _HiresAddrHigh,y
	sta tmp2+1
loop	
	ldy #0
	lda (tmp2),y
__patch_x2	
	ldy #1
	sta (tmp2),y
	
	clc
	lda tmp2+0
	adc #40
	sta tmp2+0
	lda tmp2+1
	adc #0
	sta tmp2+1
	
	dex
	bne loop
	
	ldy tmp1
	iny 
	jmp loop_car
.)
	
.)





_FontChars
	.byt "abcdefghijklmnopqrstuvwxyz"
	.byt "0123456789"
	.byt ".,",59,58,"!?/'-"
	.byt "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	.byt 0
	
_FontCharOffset
	.byt 0

_FontIndex
	.dsb 256

	
; Special codes:
; -  0=end of text
; -  1=select base character (followed by character index)
; -  2=offset X (followed by signed pixel offset)
; -  3=offset Y (followed by signed pixel offset)
; -  4=copy column zero attributes to next column (followed by number of lines to copy)
; - 10=carriage return (followed by number of scanlines to skip)
;
#define DONE	0
#define FONT	1
#define MOVX	2
#define MOVY	3

_Message_StarringMartinLandau
	.byt 50,72
	.byt 1,0,"starring",10,15,1,71,"Martin",10,21,"Landau"
	.byt DONE

_Message_StarringBarbaraBain
	.byt 160,51
	.byt 1,0,"starring",10,13,1,71,"Barbara",10,20,"Bain"
	.byt DONE
	
_Message_StarringBarryMorse
	.byt 152,17
	.byt 1,0,"also starring",10,15,1,71,"Barry",10,21,"Morse"
	.byt DONE

_Message_SylviaAnderson
	.byt 72,117
	.byt 1,0,"producer",10,15,1,71,"Sylvia",10,21,"Anderson"
	.byt DONE
	
_Message_GerryAnderson
	.byt 126,27
	.byt 1,0,"executive producer",10,15,1,71," Gerry",10,21," Anderson"
	.byt DONE
	
_Message_Music
	.byt 12,80
	.byt 1,0,"original theme",10,15
	.byt 1,71,"Barry",10,21
	.byt "Gray"
	.byt DONE
	
_Message_Chema
	.byt 120,10
	.byt 1,0,"designer/programmer",10,15
	.byt 1,71,"   Jose Maria",10,21
	.byt 1,0,"         'Chema'",10,11
	.byt 1,71,"        Enguita"
	.byt DONE
	
_Message_Twilighte
	.byt 110,130
	.byt 1,0,"adaptation",10,15
	.byt 1,71,"Jonathan",10,21
	.byt 1,0,"'Twilighte'",10,11
	.byt 1,71,"Bristow"
	.byt DONE
	
_Message_Dbug
	.byt 126,20
	.byt 1,0,"intro",10,15
	.byt 1,71," Mickael",10,22
	.byt 1,0,"  'Dbug'",10,13
	.byt 1,71,"  Pointier"
	.byt DONE

_Message_ProducedBy
	.byt 90,40
	.byt 1,0,"produced by"
	.byt DONE
	
_Message_Title
	.byt 20,60
	.byt 1,71,"'OUT OF MEMORY'"
	.byt DONE

_Message_Exclusive
	.byt 20,82
	.byt 1,0,"An exclusive Space:1999 episode for",10,13
	.byt 1,0,"    your Oric Microdisc system.",10,15
	.byt DONE
			
_Message_Website
	.byt 30,120
	.byt 1,0,"     Download it today on:",10,13
	.byt 1,0,"http",58,"/","/","space1999.defence-force.org",0

_Message_Quote1
	.byt 6,0
	.byt 1,0,"'Cult 1970s sci-fi plus obscure 1980s 8-bit",10,13
	.byt 1,0,"computer",58," something beautifully obscure.'",10,13
	.byt 1,0,"                           Malevolent"
	.byt DONE

_Message_Quote2
	.byt 6,50
	.byt 1,0,"'For modern gaming, check out Space",10,13
	.byt 1,0,"1999, a very nifty isometric adventure.'",10,13
	.byt 1,0,"                           Retrogamer"
	.byt DONE

_Message_Quote3
	.byt 6,100
	.byt 1,0,"'If only games like this were out for the",10,13
	.byt 1,0,"machine in the 80s.  I might not have",10,13
	.byt 1,0,"been quite so gutted when I got one of ",10,13
	.byt 1,0,"these for Christmas.'        Caffeinekid"
	.byt DONE
		
_Message_Quote4
	.byt 6,170
	.byt 1,0,"'Ay, caramba!'",10,13
	.byt 1,0,"                           Bart Simpson"
	.byt DONE
		

_Message_Rating
	.byt 12,20
	.byt 1,0,"THE FOLLOWING",1,71,MOVY,256-6,"PREVIEW",MOVY,6,1,0,"HAS BEEN",10,14
	.byt 1,0,"APPROVED FOR",10,16
	.byt 1,71,"      ALL AUDIENCES",10,28
	.byt 1,0," BY THE MOVING PIXELS ASSOCIATION",10,30
	.byt 1,0,"THE FILM ADVERTISED HAS BEEN RATED",10,20
	.byt DONE
	
_Message_Rating_Bottom	
	.byt 12,123
	.byt 1,71,MOVX,2,"G",1,0,MOVX,40,MOVY,3,"GENERAL AUDIENCES",10,22-3
	.byt 1,0,MOVX,3,"Some Material May Be Slow Or Ugly",10,15
	.byt 1,0,MOVX,3,"Isometric 3D does not require glasses"
	.byt DONE
	
_Message_EmergencyRedAlert
	.byt 55,80
	.byt 1,71
	.byt "EMERGENCY",10,40
	.byt MOVX,45,"RED",10,25
	.byt MOVX,35,"ALERT",10,30
	.byt DONE
	
	
_FontTableX0
	.byt 1,8,15,21,28,35,40,47,54,56,60,67,69,79,86,93
	.byt 100,107,111,116,120,126,134,146,153,160,167,172,176,181,186,191
	.byt 196,201,206,211,1,3,6,9,11,13,18,22,26,31,39,45
	.byt 53,60,66,71,80,87,89,94,100,105,115,122,131,137,146,152
	.byt 158,164,171,179,189,197,205,1,13,25,37,49,61,68,80,91
	.byt 95,101,112,116,134,145,157,169,181,187,195,202,213,223,1,13
	.byt 25,35,48,56,69,82,96,109,121,134,147,159,163,168,173,177
	.byt 181,192,201,209,1,18,30,49,64,74,83,103,115,119,128,141
	.byt 149,1,15,35,46,66,78,90,100,112,128,150,166,180
_FontTableY0
	.byt 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	.byt 2,2,2,2,15,15,15,15,15,15,15,15,15,15,15,15
	.byt 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
	.byt 15,15,15,15,15,15,15,32,32,32,32,32,32,32,32,32
	.byt 32,32,32,32,32,32,32,32,32,32,32,32,32,32,51,51
	.byt 51,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55
	.byt 55,55,55,55,76,76,76,76,76,76,76,76,76,76,76,76
	.byt 76,95,95,95,95,95,95,95,95,95,95,95,95,95
_FontTableWidth
	.byt 6,6,5,6,6,4,6,6,1,3,6,1,9,6,6,6
	.byt 6,3,4,3,5,7,11,6,6,6,4,3,4,4,4,4
	.byt 4,4,4,4,1,2,2,1,1,4,3,3,4,7,5,7
	.byt 6,5,4,8,6,1,4,5,4,9,6,8,5,8,5,5
	.byt 5,6,7,9,7,7,6,11,11,11,11,11,6,11,10,3
	.byt 5,10,3,17,10,11,11,11,5,7,6,10,9,15,11,11
	.byt 9,12,7,12,12,13,12,11,12,12,11,3,4,4,3,3
	.byt 10,8,7,7,16,11,18,14,9,8,19,11,3,8,12,7
	.byt 21,13,19,10,19,11,11,9,11,15,21,15,13,10
_FontTableHeight
	.byt 9,9,9,9,9,9,12,9,9,12,9,9,9,9,9,12
	.byt 12,9,9,9,9,9,9,9,12,9,9,9,9,9,9,9
	.byt 9,9,9,9,9,10,10,9,9,9,9,9,9,9,9,9
	.byt 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
	.byt 9,9,9,9,9,9,9,18,18,18,18,18,18,22,18,18
	.byt 22,18,18,18,18,18,22,22,18,18,18,18,18,18,18,22
	.byt 18,18,18,18,18,18,18,18,18,18,18,18,20,20,18,18
	.byt 18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18
	.byt 18,18,18,18,18,18,18,18,18,18,18,18,18,18
