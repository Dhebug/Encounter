

#define        via_portb               $0300 
#define        via_t1cl                $0304 
#define        via_t1ch                $0305 
#define        via_t1ll                $0306 
#define        via_t1lh                $0307 
#define        via_t2ll                $0308 
#define        via_t2ch                $0309 
#define        via_sr                  $030A 
#define        via_acr                 $030b 
#define        via_pcr                 $030c 
#define        via_ifr                 $030D 
#define        via_ier                 $030E 
#define        via_porta               $030f 


	.zero

_VblCounter					.dsb 1
vsync_save_a				.dsb 1

	.text
	
_System_InstallIRQ_SimpleVbl
.(
	sei
	// Set the VIA parameters
	lda #<19966		; 20000
	sta $306
	lda #>19966		; 20000
	sta $307

	lda #0
	sta _VblCounter
	
	; Install interrupt (this works only if overlay ram is accessible)
	lda #<_50Hz_InterruptHandler
	sta $FFFE
	lda #>_50Hz_InterruptHandler
	sta $FFFF

	cli
	rts	
.)



_VSync
	sta vsync_save_a
	lda _VblCounter
	beq _VSync
	lda #0
	sta _VblCounter
_DoNothing
	lda vsync_save_a
	rts


_50Hz_InterruptHandler
	bit $304
	inc _VblCounter
		
	pha
	txa
	pha
	tya
	pha
		
_InterruptCallBack_1		; Used by the transition animation that shows the name of the authors
	jsr _DoNothing			; Transformed to "jsr _PrintDescriptionCallback"

_InterruptCallBack_2		; Used by the scrolling code
	jsr _DoNothing			; Transformed to "jsr _ScrollerDisplay" -> 15675 cycles -> 15062

_InterruptCallBack_3		; Used by the music player
	jsr _DoNothing			; Transformed to "jsr _Mym_PlayFrame" -> 12 cycles

	pla
	tay
	pla
	tax
	pla

	rti



_AmigaColors
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+4
	.byt 16+0
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+1
	.byt 16+4
	.byt 16+1
	.byt 16+1
	.byt 16+1
	.byt 16+1
	.byt 16+1
	.byt 16+1
	.byt 16+3
	.byt 16+1
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+3
	.byt 16+2
	.byt 16+3
	.byt 16+2
	.byt 16+2
	.byt 16+2
	.byt 16+2
	.byt 16+2
	.byt 16+2
	.byt 16+6
	.byt 16+2
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+6
	.byt 16+4
	.byt 16+6
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+4
	.byt 16+0
	.byt 16+4
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0

	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0

	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0

	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0



ScrollPos				.byt 0
AmigaRasterTopPos		.byt 52
AmigaRasterBottomPos	.byt 197

ScrollPosHalf				.byt 0
AmigaRasterTopPosHalf		.byt 26
AmigaRasterBottomPosHalf	.byt 98

ScrollPosQuart				.byt 0
AmigaRasterTopPosQuart		.byt 13
AmigaRasterBottomPosQuart	.byt 49

 ; Install the quartsize raster lines
_InstallAmigaRasterLine_QuarterSize
	sei

	lda #13
	sta AmigaRasterTopPosQuart
	lda #49
	sta AmigaRasterBottomPosQuart

	lda #<_ScrollingAmigaRasterLinesAnimatedAppear_QuartSize
	sta _InterruptCallBack_1+1
	lda #>_ScrollingAmigaRasterLinesAnimatedAppear_QuartSize
	sta _InterruptCallBack_1+2
	cli
	rts

_RemoveAmigaRasterLine_QuarterSize
	sei
	lda #<_ScrollingAmigaRasterLinesHalf
	sta _InterruptCallBack_1+1
	lda #>_ScrollingAmigaRasterLinesHalf
	sta _InterruptCallBack_1+2
	cli
	rts

_ScrollingAmigaRasterLinesAnimatedAppear_QuartSize
.(
	;
	; Move down the top raster line
	;
	lda AmigaRasterTopPosQuart
	beq end_top_raster
	dec AmigaRasterTopPosQuart

	clc
	lda _auto_amiga_raster_top0_Quart+1
	sta _auto_amiga_raster_top_erase_Quart+1
	adc #40
	sta _auto_amiga_raster_top0_Quart+1
	lda _auto_amiga_raster_top0_Quart+2
	sta _auto_amiga_raster_top_erase_Quart+2
	adc #0
	sta _auto_amiga_raster_top0_Quart+2

	; Erase the previous line
	.(
	ldy #10
	lda #64
loop
+_auto_amiga_raster_top_erase_Quart
	sta $1234,y 
	dey
	bne loop
    .)
end_top_raster

	;
	; Move down the bottom raster line
	;
	lda AmigaRasterBottomPosQuart
	bne move_bottom_raster

	; End of scrolling, link to the fast IRQ
	lda #<_ScrollingAmigaRasterLinesQuart
	sta _InterruptCallBack_1+1
	lda #>_ScrollingAmigaRasterLinesQuart
	sta _InterruptCallBack_1+2
	jmp _ScrollingAmigaRasterLinesQuart

move_bottom_raster	
	dec AmigaRasterBottomPosQuart

	clc
	lda _auto_amiga_raster_bottom0_Quart+1
	sta _auto_amiga_raster_bottom_erase_Quart+1
	adc #40
	sta _auto_amiga_raster_bottom0_Quart+1
	lda _auto_amiga_raster_bottom0_Quart+2
	sta _auto_amiga_raster_bottom_erase_Quart+2
	adc #0
	sta _auto_amiga_raster_bottom0_Quart+2

	; Erase the previous line
	.(
	ldy #10
	lda #64
loop
+_auto_amiga_raster_bottom_erase_Quart
	sta $1234,y 
	dey
	bne loop
    .)
.)
_ScrollingAmigaRasterLinesQuart
	;rts
.(
	lda #16
	ldx ScrollPosQuart
	ldy #11
loop
+_auto_amiga_raster_top0_Quart
	sta $a000+(52+22+38)*40+10+5-1,y 	; 52
+_auto_amiga_raster_bottom0_Quart
	sta $a000+(52+22+38)*40+10+5-1,y 	; 197
	txa
	and #63
	tax
	lda _AmigaColors,x
	dex
	dey
	bne loop

	inc ScrollPosQuart

	jmp _ScrollingAmigaRasterLinesHalf
.)



; Install the halfsize raster lines
_InstallAmigaRasterLine_HalfSize
	sei

	lda #26
	sta AmigaRasterTopPosHalf
	lda #98
	sta AmigaRasterBottomPosHalf

	lda #<_ScrollingAmigaRasterLinesAnimatedAppear_HalfSize
	sta _InterruptCallBack_1+1
	lda #>_ScrollingAmigaRasterLinesAnimatedAppear_HalfSize
	sta _InterruptCallBack_1+2
	cli
	rts

_RemoveAmigaRasterLine_HalfSize
	sei
	lda #<_ScrollingAmigaRasterLines
	sta _InterruptCallBack_1+1
	lda #>_ScrollingAmigaRasterLines
	sta _InterruptCallBack_1+2
	cli
	rts

_ScrollingAmigaRasterLinesAnimatedAppear_HalfSize
.(
	;
	; Move down the top raster line
	;
	lda AmigaRasterTopPosHalf
	beq end_top_raster
	dec AmigaRasterTopPosHalf

	clc
	lda _auto_amiga_raster_top0_half+1
	sta _auto_amiga_raster_top_erase_half+1
	adc #40
	sta _auto_amiga_raster_top0_half+1
	lda _auto_amiga_raster_top0_half+2
	sta _auto_amiga_raster_top_erase_half+2
	adc #0
	sta _auto_amiga_raster_top0_half+2

	; Erase the previous line
	.(
	ldy #20
	lda #64
loop
+_auto_amiga_raster_top_erase_half
	sta $1234,y 
	dey
	bne loop
    .)
end_top_raster

	;
	; Move down the bottom raster line
	;
	lda AmigaRasterBottomPosHalf
	bne move_bottom_raster

	; End of scrolling, link to the fast IRQ
	lda #<_ScrollingAmigaRasterLinesHalf
	sta _InterruptCallBack_1+1
	lda #>_ScrollingAmigaRasterLinesHalf
	sta _InterruptCallBack_1+2
	jmp _ScrollingAmigaRasterLinesHalf

move_bottom_raster	
	dec AmigaRasterBottomPosHalf

	clc
	lda _auto_amiga_raster_bottom0_half+1
	sta _auto_amiga_raster_bottom_erase_half+1
	adc #40
	sta _auto_amiga_raster_bottom0_half+1
	lda _auto_amiga_raster_bottom0_half+2
	sta _auto_amiga_raster_bottom_erase_half+2
	adc #0
	sta _auto_amiga_raster_bottom0_half+2

	; Erase the previous line
	.(
	ldy #20
	lda #64
loop
+_auto_amiga_raster_bottom_erase_half
	sta $1234,y 
	dey
	bne loop
    .)
.)
_ScrollingAmigaRasterLinesHalf
	;rts
.(
	lda #16
	ldx ScrollPosHalf
	ldy #21
loop
+_auto_amiga_raster_top0_half
	sta $a000+(52+22)*40+10-1,y 	; 52

+_auto_amiga_raster_bottom0_half
	sta $a000+(52+22)*40+10-1,y 	; 197
	txa
	and #63
	tax
	lda _AmigaColors,x
	inx
	dey
	bne loop

	inc ScrollPosHalf

	jmp _ScrollingAmigaRasterLines
.)


; Install the raster lines
_InstallAmigaRasterLine
	sei

	lda #52
	sta AmigaRasterTopPos
	lda #197
	sta AmigaRasterBottomPos

	lda #<_ScrollingAmigaRasterLinesAnimatedAppear
	sta _InterruptCallBack_1+1
	lda #>_ScrollingAmigaRasterLinesAnimatedAppear
	sta _InterruptCallBack_1+2
	cli
	rts

_StopAmigaRasterLine
	sei

	lda #52
	sta AmigaRasterTopPos
	lda #197
	sta AmigaRasterBottomPos	

	lda #<_ScrollingAmigaRasterLinesAnimatedDisappear
	sta _InterruptCallBack_1+1
	lda #>_ScrollingAmigaRasterLinesAnimatedDisappear
	sta _InterruptCallBack_1+2
	cli
	rts


_ScrollingAmigaRasterLinesAnimatedDisappear
.(
	;
	; Move down the top raster line
	;
	lda AmigaRasterTopPos
	beq end_top_raster
	dec AmigaRasterTopPos

	sec
	lda _auto_amiga_raster_top0+1
	sbc #40
	sta _auto_amiga_raster_top0+1
	lda _auto_amiga_raster_top0+2
	sbc #0
	sta _auto_amiga_raster_top0+2

	sec
	lda _auto_amiga_raster_top1+1
	sbc #40
	sta _auto_amiga_raster_top1+1
	lda _auto_amiga_raster_top1+2
	sbc #0
	sta _auto_amiga_raster_top1+2

	sec
	lda _auto_amiga_raster_top2+1
	sta _auto_amiga_raster_top_clean+1
	sbc #40
	sta _auto_amiga_raster_top2+1
	lda _auto_amiga_raster_top2+2
	sta _auto_amiga_raster_top_clean+2
	sbc #0
	sta _auto_amiga_raster_top2+2

	; Erase the previous line
	.(
	ldy #40
	lda #64
loop
+_auto_amiga_raster_top_clean
	sta $a000+(40*0)-1,y 
	dey
	bne loop
    .)
end_top_raster

	;
	; Move down the bottom raster line
	;
	lda AmigaRasterBottomPos
	bne move_bottom_raster

	; End of scrolling, link to the fast IRQ
	lda #<_DoNothing
	sta _InterruptCallBack_1+1
	lda #>_DoNothing
	sta _InterruptCallBack_1+2
	jmp _ScrollingAmigaRasterLines

move_bottom_raster	
	dec AmigaRasterBottomPos

	sec
	lda _auto_amiga_raster_bottom0+1
	sbc #40
	sta _auto_amiga_raster_bottom0+1
	lda _auto_amiga_raster_bottom0+2
	sbc #0
	sta _auto_amiga_raster_bottom0+2

	sec
	lda _auto_amiga_raster_bottom1+1
	sbc #40
	sta _auto_amiga_raster_bottom1+1
	lda _auto_amiga_raster_bottom1+2
	sbc #0
	sta _auto_amiga_raster_bottom1+2

	sec
	lda _auto_amiga_raster_bottom2+1
	sta _auto_amiga_raster_bottom_clean+1
	sbc #40
	sta _auto_amiga_raster_bottom2+1
	lda _auto_amiga_raster_bottom2+2
	sta _auto_amiga_raster_bottom_clean+2
	sbc #0
	sta _auto_amiga_raster_bottom2+2

	sec
	lda _auto_amiga_raster_bottom_load+1
	sbc #40
	sta _auto_amiga_raster_bottom_load+1
	lda _auto_amiga_raster_bottom_load+2
	sbc #0
	sta _auto_amiga_raster_bottom_load+2

	; Erase the previous line
	.(
	ldy #40
	lda #64
loop
+_auto_amiga_raster_bottom_load
	lda _PictureLoadingBuffer+(40*200)-1,y
+_auto_amiga_raster_bottom_clean
	sta $a000+(40*0)-1,y 
	dey
	bne loop
    .)	
	jmp _ScrollingAmigaRasterLines
	rts
.)


_ScrollingAmigaRasterLinesAnimatedAppear
.(
	;
	; Move down the top raster line
	;
	lda AmigaRasterTopPos
	beq end_top_raster
	dec AmigaRasterTopPos

	clc
	lda _auto_amiga_raster_top0+1
	sta _auto_amiga_raster_top_erase+1
	adc #40
	sta _auto_amiga_raster_top0+1
	lda _auto_amiga_raster_top0+2
	sta _auto_amiga_raster_top_erase+2
	adc #0
	sta _auto_amiga_raster_top0+2

	clc
	lda _auto_amiga_raster_top1+1
	adc #40
	sta _auto_amiga_raster_top1+1
	lda _auto_amiga_raster_top1+2
	adc #0
	sta _auto_amiga_raster_top1+2

	clc
	lda _auto_amiga_raster_top2+1
	adc #40
	sta _auto_amiga_raster_top2+1
	lda _auto_amiga_raster_top2+2
	adc #0
	sta _auto_amiga_raster_top2+2

	; Erase the previous line
	.(
	ldy #40
	lda #64
loop
+_auto_amiga_raster_top_erase
	sta $a000+(40*0)-1,y 
	dey
	bne loop
    .)
end_top_raster

	;
	; Move down the bottom raster line
	;
	lda AmigaRasterBottomPos
	bne move_bottom_raster

	; End of scrolling, link to the fast IRQ
	lda #<_ScrollingAmigaRasterLines
	sta _InterruptCallBack_1+1
	lda #>_ScrollingAmigaRasterLines
	sta _InterruptCallBack_1+2
	jmp _ScrollingAmigaRasterLines

move_bottom_raster	
	dec AmigaRasterBottomPos

	clc
	lda _auto_amiga_raster_bottom0+1
	sta _auto_amiga_raster_bottom_erase+1
	adc #40
	sta _auto_amiga_raster_bottom0+1
	lda _auto_amiga_raster_bottom0+2
	sta _auto_amiga_raster_bottom_erase+2
	adc #0
	sta _auto_amiga_raster_bottom0+2

	clc
	lda _auto_amiga_raster_bottom1+1
	adc #40
	sta _auto_amiga_raster_bottom1+1
	lda _auto_amiga_raster_bottom1+2
	adc #0
	sta _auto_amiga_raster_bottom1+2

	clc
	lda _auto_amiga_raster_bottom2+1
	adc #40
	sta _auto_amiga_raster_bottom2+1
	lda _auto_amiga_raster_bottom2+2
	adc #0
	sta _auto_amiga_raster_bottom2+2

	; Erase the previous line
	.(
	ldy #40
	lda #64
loop
+_auto_amiga_raster_bottom_erase
	sta $a000+(40*0)-1,y 
	dey
	bne loop
    .)
.)
_ScrollingAmigaRasterLines
.(
	ldx ScrollPos
	ldy #40
loop
	txa
	and #63
	tax
	lda _AmigaColors,x
+_auto_amiga_raster_top0
	sta $a000+(40*0)-1,y 	; 52
+_auto_amiga_raster_top2
	sta $a000+(40*2)-1,y 	; 54

+_auto_amiga_raster_bottom0
	sta $a000+(40*0)-1,y 	; 197
+_auto_amiga_raster_bottom2	
	sta $a000+(40*2)-1,y 	; 199
	inx
	dey
	bne loop

	ldx ScrollPos
	ldy #0
loop2
	txa
	and #63
	tax
	lda _AmigaColors,x
	eor #7
+_auto_amiga_raster_top1
	sta $a000+(40*1),y 		; 53
+_auto_amiga_raster_bottom1	
	sta $a000+(40*1),y 		; 198
	inx
	iny
	cpy #40
	bne loop2

	inc ScrollPos

	rts
.)


;
;   0 scrolling raster
;   1 scrolling raster
;   2 scrolling raster

;   3 background
; ...
; 196 background

; 197 scrolling raster
; 198 scrolling raster
; 199 scrolling raster
;
BackgroundColor1	.byt 16
BackgroundColor2	.byt 16
BackgroundColorSync	.byt 0

_SetBlackPaper
	ldx #0
	ldy #0
	lda #0
	jmp SetRasters

_ShowRasters
	ldx #16+4
	ldy #16+0
	lda #1
	jmp SetRasters

SetRasters
.(
	stx BackgroundColor1
	sty BackgroundColor2
	sta BackgroundColorSync

	lda #<$a000+40*55
	sta tmp1+0
	lda #>$a000+40*55
	sta tmp1+1

	ldx #142
loop_y
	ldy #0
	lda BackgroundColor1
	sta (tmp1),y

	ldy BackgroundColor2
	sta BackgroundColor2
	sty BackgroundColor1

	;jsr _VSync

	clc
	lda tmp1
	adc #40
	sta tmp1
	bcc skip_dst
	inc tmp1+1
skip_dst

	dex
	bne loop_y		
	rts
.)



; Install the raster lines
_InstallCalendarDecount
	sei
	lda #<_DecrementCalendar
	sta _InterruptCallBack_2+1
	lda #>_DecrementCalendar
	sta _InterruptCallBack_2+2
	jsr _ShowCalendar
	cli
	rts

_StopCalendarDecount
	sei
	lda #<_DoNothing
	sta _InterruptCallBack_2+1
	lda #>_DoNothing
	sta _InterruptCallBack_2+2
	cli
	rts

/*
24.-25. September 1994

7th to the 9th of November 2014


Result: 7350 days
It is 7350 days from the start date to the end date, but not including the end date
Or 20 years, 1 month, 15 days excluding the end date

Alternative time units
7350 days can be converted to one of these units:
635,040,000 seconds
10,584,000 minutes
176,400 hours
7350 days
1050 weeks

Music: 2'49" -> 169 seconds -> 8450 frames

7350 days / 50 frames = 147 seconds = 
*/

_MonthNames
	.byt "JANR"
	.byt "FEBR"
	.byt "MARS"
	.byt "APRL"
	.byt "MAY "
	.byt "JUNE"
	.byt "JULY"
	.byt "AUGU"
	.byt "SEPT"
	.byt "OCTO"
	.byt "NOVB"
	.byt "DECB"

_YearNames
	;.byt "1"+128,"9"+128,"9"+128,"4"+128
	.byt "1"+128,"9"+128,"9"+128,"4"+128
	.byt "1"+128,"9"+128,"9"+128,"5"+128
	.byt "1"+128,"9"+128,"9"+128,"6"+128
	.byt "1"+128,"9"+128,"9"+128,"7"+128
	.byt "1"+128,"9"+128,"9"+128,"8"+128
	.byt "1"+128,"9"+128,"9"+128,"9"+128
	.byt "2"+128,"0"+128,"0"+128,"0"+128
	.byt "2"+128,"0"+128,"0"+128,"1"+128
	.byt "2"+128,"0"+128,"0"+128,"2"+128
	.byt "2"+128,"0"+128,"0"+128,"3"+128
	.byt "2"+128,"0"+128,"0"+128,"4"+128
	.byt "2"+128,"0"+128,"0"+128,"5"+128
	.byt "2"+128,"0"+128,"0"+128,"6"+128
	.byt "2"+128,"0"+128,"0"+128,"7"+128
	.byt "2"+128,"0"+128,"0"+128,"8"+128
	.byt "2"+128,"0"+128,"0"+128,"9"+128
	.byt "2"+128,"0"+128,"1"+128,"0"+128
	.byt "2"+128,"0"+128,"1"+128,"1"+128
	.byt "2"+128,"0"+128,"1"+128,"2"+128
	.byt "2"+128,"0"+128,"1"+128,"3"+128
	.byt "2"+128,"0"+128,"1"+128,"4"+128

Year	.byt 20
Month 	.byt 10

; /0123456789
; Start date: 7th to the 9th of November 2014
; End date:   24.-25. September 1994
_DecrementCalendar
.(	
	ldx $bb80+40*27+4 ; Day - right digit
	ldy $bb80+40*27+3 ; Day - left digit

	cpx #"4"+128
	bne decrement
	cpy #"2"+128
	bne decrement
	lda Year
	bne decrement
	lda Month
	cmp #8
	bne decrement

	; Make the calendar blink
	lda #12 	; blink
	sta $bb80+40*25+0
	sta $bb80+40*26+0
	sta $bb80+40*27+0

	lda #8 		; standard
	sta $bb80+40*25+8
	sta $bb80+40*26+8
	sta $bb80+40*27+8

	jsr _StopCalendarDecount
	rts

decrement
	; Day - right digit
	dex
	cpx #"/"+128
	bne skip_day_right
	; Decrement the left digit
	ldx #"9"+128
	; Day - left digit
	dey
	cpy #"/"+128
	bne skip_day_left
	; Reset the month to 28 (31 is too long)
	ldy #"3"+128
	ldx #"1"+128
	dec Month
	bpl skip_reset_month
	lda #11
	sta Month
	dec Year
skip_reset_month

skip_day_left	
	sty $bb80+40*27+3
skip_day_right	
	stx $bb80+40*27+4

	; Display the month
	lda Month
	asl
	asl
	tax 
	lda _MonthNames+0,x
	sta $bb80+40*26+2
	lda _MonthNames+1,x
	sta $bb80+40*26+3
	lda _MonthNames+2,x
	sta $bb80+40*26+4
	lda _MonthNames+3,x
	sta $bb80+40*26+5

	; Display the year
	lda Year
	asl
	asl
	tax 
	lda _YearNames+0,x
	sta $bb80+40*25+2
	lda _YearNames+1,x
	sta $bb80+40*25+3
	lda _YearNames+2,x
	sta $bb80+40*25+4
	lda _YearNames+3,x
	sta $bb80+40*25+5

	; 2014 nov 08
	;jsr _StopCalendarDecount
	rts
.)


_ShowCalendar
.(
	lda #"{"+128
	sta $bb80+40*25+1
	lda #"2"+128
	sta $bb80+40*25+2
	lda #"0"+128
	sta $bb80+40*25+3
	lda #"1"+128
	sta $bb80+40*25+4
	lda #"4"+128
	sta $bb80+40*25+5
	lda #"|"+128
	sta $bb80+40*25+6

	lda #16+1
	sta $bb80+40*26+1
	lda #"N"
	sta $bb80+40*26+2
	lda #"O"
	sta $bb80+40*26+3
	lda #"V"
	sta $bb80+40*26+4
	lda #"E"
	sta $bb80+40*26+5
	lda #" "
	sta $bb80+40*26+6
	lda #16
	sta $bb80+40*26+7

	lda #"}"+128
	sta $bb80+40*27+1
	lda #" "+128
	sta $bb80+40*27+2
	lda #"0"+128
	sta $bb80+40*27+3
	lda #"8"+128
	sta $bb80+40*27+4
	lda #" "+128
	sta $bb80+40*27+5
	lda #"~"+128
	sta $bb80+40*27+6
	lda #16
	sta $bb80+40*27+7

	rts
.)


; JANUARY
; FEBRUARY
; MARS
; APRIL
; MAY
; JUNE
; JULY
; AUGUST
; SEPTEMBER
; OCTOBER
; NOVEMBER
; DECEMBER


;2014
;MAR
;27

