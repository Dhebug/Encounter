


_Fx_CutSound
.(
	// Canal settings
	ldy #7
	ldx #%11111111
	jsr _PsgSetRegister

	// Volume
	ldy #8
	ldx #0
	jsr _PsgSetRegister
	ldy #9
	ldx #0
	jsr _PsgSetRegister
	ldy #10
	ldx #0
	jsr _PsgSetRegister

	rts
.)



// A normal TV mire with color bars, and a disturbing sound
// blanc, jaune, cyan, vert, viloet, rouge, bleu, noir
_Fx_TvMire
.(
	//
	// Switch to the right resolution
	//
	jsr _SwitchToHires
	jsr _ClearHiresScreen


	//
	// Display the bars
	//
	lda #<$a000
	sta tmp0+0
	lda #>$a000
	sta tmp0+1

	.(
	ldx #200
loop
	lda #16+7
	ldy #0
	sta (tmp0),y

	lda #16+3
	ldy #5
	sta (tmp0),y

	lda #16+6
	ldy #10
	sta (tmp0),y

	lda #16+2
	ldy #15
	sta (tmp0),y

	lda #16+5
	ldy #20
	sta (tmp0),y

	lda #16+1
	ldy #25
	sta (tmp0),y

	lda #16+4
	ldy #30
	sta (tmp0),y

	lda #16+0
	ldy #35
	sta (tmp0),y

	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip

	dex
	bne loop
	.)

	//
	// Do awfull sounds
	//
	// Freq 0
	ldy #0
	ldx #150
	jsr _PsgSetRegister

	ldy #1
	ldx #0	
	jsr _PsgSetRegister

	// Canal settings
	ldy #7
	ldx #%11111110
	jsr _PsgSetRegister

	// Volume
	ldy #8
	ldx #15
	jsr _PsgSetRegister


	//
	// Temporisation
	//
	ldx #150	// 3 seconds
loop
	jsr _VSync
	dex
	bne loop

	jsr _Fx_CutSound

	rts
.)


// ========================
//			Fx Snow
// ========================

_Fx_Snow
.(
	//
	// Make sure we are in TEXT mode
	//
	jsr	_SwitchToText
	jsr _ClearTextScreen

	//
	// Cause an awfull sound
	//

	// Noise Freq (5 bits
	ldy #6
	ldx #15
	jsr _PsgSetRegister

	ldy #1
	ldx #0
	jsr _PsgSetRegister

	// Canal settings
	ldy #7
	ldx #%11000111
	jsr _PsgSetRegister

	// Volume
	ldy #8
	ldx #8
	jsr _PsgSetRegister
	ldy #9
	ldx #8
	jsr _PsgSetRegister
	ldy #10
	ldx #8
	jsr _PsgSetRegister

	//
	// Display the patterns
	//
	jsr _Fx_Snow_Effect
	jsr _Fx_Snow_FillScreen


	//
	// Temporisation
	//
	ldx #150	// 3 seconds
loop
	txa
	pha
	jsr _Fx_Snow_Effect
	jsr _VSync
	pla
	tax
	dex
	bne loop

	jsr _Fx_CutSound
	rts
.)





_Fx_Snow_FillScreen
.(
	lda #<$bb80-1
	sta tmp0+0
	lda #>$bb80-1
	sta tmp0+1

	ldx #28
loop_y

	ldy #40
loop_x
	jsr _GetRand
	lda _RandomValue
	lsr
	lsr
	lsr
	lsr
	clc
	adc #65

	sta (tmp0),y
	dey
	bne loop_x

	.(
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	dex
	bne loop_y
	rts
.)




_Fx_Snow_Effect
.(
	//
	// Generate dithered characters
	//
	jsr _GetRand
	lda _RandomValue
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc #<_PatternSnow
	sta __src+1
	lda #>_PatternSnow
	adc #0
	sta __src+2

	lda #<$b400+65*8
	sta tmp1+0
	lda #>$b400+65*8
	sta tmp1+1

	ldy #0

	ldx #16
	stx tmp2+0
loop_outer

	ldx #4
	stx tmp2+1
loop_inner
	jsr _GetRand
	lda _RandomValue
	lsr
	lsr
	lsr
	lsr
	lsr
	tax

__src
	lda $1234,x
	sta (tmp1),y
	iny
	lda _PatternSnow,x
	sta (tmp1),y
	iny

	dec tmp2+1
	bne loop_inner

	dec tmp2+0
	bne loop_outer

	rts
.)




// ========================
//			Fx Digit
// ========================


#define	SEG_THICK	7

#define	SEG_SEP		SEG_THICK+2

#define	SEG_WIDTH	SEG_THICK*9
#define	SEG_HEIGHT	SEG_THICK*9



_Fx_DigitTableX
	.byt 78+SEG_SEP
	.byt 78
	.byt 78+SEG_SEP*2+SEG_WIDTH+SEG_THICK
	.byt 78+SEG_SEP
	.byt 78
	.byt 78+SEG_SEP*2+SEG_WIDTH+SEG_THICK
	.byt 78+SEG_SEP

_Fx_DigitTableY
	.byt 10
	.byt 10+SEG_SEP
	.byt 10+SEG_SEP
	.byt 10+SEG_HEIGHT+SEG_SEP*2+SEG_THICK
	.byt 10+SEG_HEIGHT+SEG_SEP*2+SEG_THICK+SEG_SEP
	.byt 10+SEG_HEIGHT+SEG_SEP*2+SEG_THICK+SEG_SEP
	.byt 10+SEG_HEIGHT+SEG_SEP*2+SEG_THICK+SEG_HEIGHT+SEG_SEP*2+SEG_THICK

_Fx_DigitTableW
	.byt 1+SEG_WIDTH
	.byt 1+0
	.byt 1+0
	.byt 1+SEG_WIDTH
	.byt 1+0
	.byt 1+0
	.byt 1+SEG_WIDTH

_Fx_DigitTableH
	.byt 1+0
	.byt 1+SEG_HEIGHT
	.byt 1+SEG_HEIGHT
	.byt 1+0
	.byt 1+SEG_HEIGHT
	.byt 1+SEG_HEIGHT
	.byt 1+0

_Fx_Digit_Shift	.byt 0


//
//   1
// 2   4
//   8
// 16  32
//   64
//

#define LCD_DIGIT_0 1+2+4+16+32+64
#define LCD_DIGIT_1 4+32
#define LCD_DIGIT_2 1+4+8+16+64
#define LCD_DIGIT_3 1+4+8+32+64
#define LCD_DIGIT_4 2+4+8+32
#define LCD_DIGIT_5 1+2+8+32+64
#define LCD_DIGIT_6 1+2+8+16+32+64
#define LCD_DIGIT_7 1+4+32
#define LCD_DIGIT_8 1+2+4+8+16+32+64
#define LCD_DIGIT_9 1+2+4+8+32+64


_Fx_DigitMask	.byt 0

_Fx_DrawDigit_0
	lda #LCD_DIGIT_0
	jmp Fx_DrawDigit
	rts

_Fx_DrawDigit_1
	lda #LCD_DIGIT_1
	jmp Fx_DrawDigit
	rts

_Fx_DrawDigit_2
	lda #LCD_DIGIT_2
	jmp Fx_DrawDigit
	rts

_Fx_DrawDigit_3
	lda #LCD_DIGIT_3
	jmp Fx_DrawDigit
	rts

_Fx_DrawDigit_4
	lda #LCD_DIGIT_4
	jmp Fx_DrawDigit
	rts

_Fx_DrawDigit_5
	lda #LCD_DIGIT_5
	jmp Fx_DrawDigit
	rts

_Fx_DrawDigit_6
	lda #LCD_DIGIT_6
	jmp Fx_DrawDigit
	rts

_Fx_DrawDigit_7
	lda #LCD_DIGIT_7
	jmp Fx_DrawDigit
	rts

_Fx_DrawDigit_8
	lda #LCD_DIGIT_8
	jmp Fx_DrawDigit
	rts

_Fx_DrawDigit_9
	lda #LCD_DIGIT_9
	jmp Fx_DrawDigit
	rts



Fx_DrawDigit
.(
	ldx #1
	stx _Fx_Digit_Shift 

	ldx #0
loop	
	pha
	eor _Fx_DigitMask
	and _Fx_Digit_Shift
	beq skip

	lda _Fx_DigitMask
	eor _Fx_Digit_Shift
	sta _Fx_DigitMask

	pha
	txa
	pha
	tya
	pha

	jsr Fx_DrawSegment

	pla
	tay
	pla
	tax
	pla
	
skip
	asl _Fx_Digit_Shift

	pla

	inx
	cpx #7
	bne loop

	//
	// Do a stupid beep
	//
	ldy #0
	ldx #150
	jsr _PsgSetRegister

	ldy #1
	ldx #0	
	jsr _PsgSetRegister

	ldy #2
	ldx #149
	jsr _PsgSetRegister

	ldy #3
	ldx #0	
	jsr _PsgSetRegister

	ldy #4
	ldx #147
	jsr _PsgSetRegister

	ldy #5
	ldx #0	
	jsr _PsgSetRegister


	// Canal settings
	ldy #7
	ldx #%11111000
	jsr _PsgSetRegister

	// Volume => Use enveloppe
	ldy #8
	ldx #16
	jsr _PsgSetRegister
	ldy #9
	ldx #16
	jsr _PsgSetRegister
	ldy #10
	ldx #16
	jsr _PsgSetRegister

#define FX_DIGIT_BEEP_DURATION $2FF

	// Enveloppe duration
	ldy #11
	ldx #<FX_DIGIT_BEEP_DURATION
	jsr _PsgSetRegister

	ldy #12
	ldx #>FX_DIGIT_BEEP_DURATION
	jsr _PsgSetRegister

	// Enveloppe shape => \___
	ldy #13
	ldx #0
	jsr _PsgSetRegister

	rts
.)


// X: Number of segment to draw
Fx_DrawSegment
.(
	lda _Fx_DigitTableX,x
	sta _CurrentPixelX
	clc
	adc _Fx_DigitTableW,x
	sta _OtherPixelX

	lda _Fx_DigitTableY,x
	sta _CurrentPixelY
	sta _OtherPixelY

	// Top part
	.(
	ldy #SEG_THICK
loop
	jsr _DrawHLine

	dec _CurrentPixelX
	inc _OtherPixelX
	inc _CurrentPixelY
	inc _OtherPixelY

	dey
	bne loop
	.)

	// Middle part
	.(
	ldy _Fx_DigitTableH,x
loop
	jsr _DrawHLine

	inc _CurrentPixelY
	inc _OtherPixelY

	dey
	bne loop
	.)

	// Bottom part
	.(
	ldy #SEG_THICK
loop
	inc _CurrentPixelX
	dec _OtherPixelX

	jsr _DrawHLine

	inc _CurrentPixelY
	inc _OtherPixelY

	dey
	bne loop
	.)

	rts
.)



_Fx_DisplayMessage
.(
	//
	// Display warning text in TEXT
	//	
	jsr _SwitchToText
	jsr _ClearTextScreen
	jsr _Text_RedefineCharset	

	.(
	lda #<$bb80
	sta tmp0+0
	lda #>$bb80
	sta tmp0+1

loop_line
	ldy #0
loop_char
	pha
	txa
	pha
	tya
	pha

	.(
	ldy #0
	lda (greetings_pointer),y
	sta tmp2
	inc greetings_pointer+0
	bne skip
	inc greetings_pointer+1
skip
	.)

	pla
	tay
	pla
	tax
	pla

	lda tmp2
	cmp #255
	beq end_message
	cmp #254
	beq new_line
	cmp #253
	beq skip_9

	sta (tmp0),y

	iny
	jmp loop_char

skip_9
	tya
	clc
	adc #9
	tay
	jmp loop_char

new_line
	.(
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	jmp loop_line

end_message
	.)


	//
	// Temporisation
	//
	.(
	ldx #250
loop	
	jsr _VSync
	dex
	bne loop
	.)
	

	rts
.)

/*
.....ooo.x.oooo..o...ooo.
....o...x..o...o.o..o...o
...o...x.o.o...o.o.o.....
...o..x..o.oooo..o.o.....
...o.x...o.o.o...o.o.....
....x...o..o..o..o..o...o
...x.ooo...o...o.o...ooo.
..xxxxxxxxxxxxxxxxxxxxxxxx
*/

Fx_PcMessage
	.byt 10,"This is no",3,"PC",7,"DEMO",254
	.byt 10,"This is no",1,"PC",7,"DEMO",254
	.byt 254
	.byt 254
	.byt 10,"    This is no",6,"Farbraush",7,"demo",254
	.byt 10,"    This is no",4,"Farbraush",7,"demo",254
	.byt 254
	.byt 254
	.byt 10,"        This is no",4,"C= 64",7,"demo",254
	.byt 10,"        This is no",1,"C= 64",7,"demo",254
	.byt 254
	.byt 254
	.byt 10,3,"          This is just a 64k",254
	.byt 10,1,"          This is just a 64k",254

	.byt 254
	.byt 254

	.byt 16,16,16,16,16,16,23,23,23,16,17,16,23,23,23,23,16,16,23,16,16,16,23,23,23,16,16,254
	.byt 16,16,16,16,16,23,16,16,16,17,16,16,23,16,16,16,23,16,23,16,16,23,16,16,16,23,16,254
	.byt 16,16,16,16,23,16,16,16,17,16,23,16,23,16,16,16,23,16,23,16,23,16,16,16,16,16,16,254
	.byt 16,16,16,16,23,16,16,17,16,16,23,16,23,23,23,23,16,16,23,16,23,16,16,16,16,16,16,254
	.byt 16,16,16,16,23,16,17,16,16,16,23,16,23,16,23,16,16,16,23,16,23,16,16,16,16,16,16,254
	.byt 16,16,16,16,16,17,16,16,16,23,16,16,23,16,16,23,16,16,23,16,16,23,16,16,16,23,16,254
	.byt 16,16,16,16,17,16,23,23,23,16,16,16,23,16,16,16,23,16,23,16,16,16,23,23,23,16,16,254
	.byt 16,16,16,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,16,254

	.byt 254
	.byt 254

	.byt 10,"             intro",254
	.byt 10,"             intro",254

	.byt 255




_Fx_PcWarning
.(
	lda #<Fx_PcMessage	
	sta greetings_pointer+0
	lda #>Fx_PcMessage	
	sta greetings_pointer+1

	jsr _Fx_DisplayMessage
	rts
.)  



// ========================
//			Fx Bear
// ========================

Fx_BearMessage
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+4,254	    
	.byt 16+4,254	    
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 16+7,253,16+4,"  ",16+7,254
	.byt 254
	.byt 17,254
	.byt 17,3,14,"      SURGEON GENERAL WARNING:",254
	.byt 17,3,14,"      SURGEON GENERAL WARNING:",254
	.byt 17,254
	.byt 16,254
	.byt 16+7,254
	.byt 16+7,4,"  Drinking Finish",1,"Bears",4,"may cause",254
	.byt 16+7,254
	.byt 16+7,4,"    serious harm to your health.",254
	.byt 16+7,254
	.byt 16,254
	.byt 255





_Fx_BearWarning
.(
	lda #<Fx_BearMessage	
	sta greetings_pointer+0
	lda #>Fx_BearMessage	
	sta greetings_pointer+1

	jsr _Fx_DisplayMessage
	

	//
	// Display the Bear in HIRES
	//
	jsr _SwitchToHires
	jsr _ClearHiresScreen


	// Source adress
	lda #<_Picture_Karhu
	sta tmp0+0
	lda #>_Picture_Karhu
	sta tmp0+1

	// Destination adress
	lda #<_BigBuffer
	sta tmp1+0
	lda #>_BigBuffer
	sta tmp1+1

	jsr _System_DataUnpack

	//
	// And then copy the buffer to screen
	//
	.(
	// Source
	lda #<_BigBuffer
	sta tmp0+0
	lda #>_BigBuffer
	sta tmp0+1

	lda #<_BigBuffer+40*199
	sta tmp2+0
	lda #>_BigBuffer+40*199
	sta tmp2+1

	// Dest
	lda #<$a000
	sta tmp1+0
	lda #>$a000
	sta tmp1+1

	lda #<$a000+40*199
	sta tmp3+0
	lda #>$a000+40*199
	sta tmp3+1

	ldx #100
loop_y
	ldy #0
loop_x
	lda (tmp0),y
	sta (tmp1),y

	lda (tmp2),y
	sta (tmp3),y

	iny
	cpy #40
	bne loop_x

	.(
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)

	.(
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip
	.)

	.(
	sec
	lda tmp2+0
	sbc #40
	sta tmp2+0
	bcs skip
	dec tmp2+1
skip
	.)

	.(
	sec
	lda tmp3+0
	sbc #40
	sta tmp3+0
	bcs skip
	dec tmp3+1
skip
	.)

	jsr _VSync

	dex
	beq end
	jmp loop_y
end	
	.)


	//
	// Temporisation
	//
	.(
	ldx #250
loop	
	jsr _VSync
	dex
	bne loop
	.)

	rts	
.)

#define FX_TEXT_OFFSET(size)	19-((size)*3-1)/2


_FxTitle_NameList
	.byt FX_TEXT_OFFSET(8),0,"YOU HAVE",0
	.byt FX_TEXT_OFFSET(4),0,"BEEN",0
	.byt FX_TEXT_OFFSET(8),0,"WATCHING",0
	.byt 2,0," ",0
	.byt FX_TEXT_OFFSET(11),28,".BUGGY BOY.",0
	.byt 2,0," ",0
	.byt FX_TEXT_OFFSET(7),0,"A 36415",0
	.byt FX_TEXT_OFFSET(10),0,"BYTES LONG",0
	.byt FX_TEXT_OFFSET(10),0,"ORIC INTRO",0
	.byt FX_TEXT_OFFSET(2) ,0,"BY",0
	.byt FX_TEXT_OFFSET(12),28,"DEFENCEFORCE",0
	.byt FX_TEXT_OFFSET(11),28,"AND FRIENDS",0
	.byt FX_TEXT_OFFSET(7),0,"FOR THE",0
	.byt FX_TEXT_OFFSET(8),56,"LCP 2004",0
	.byt FX_TEXT_OFFSET(2),0,"IN",0
	.byt FX_TEXT_OFFSET(9),0,"LINKOPING",0
	.byt FX_TEXT_OFFSET(6),0,"SWEDEN",0
	.byt 2,0," ",0
	.byt FX_TEXT_OFFSET(6),28,"THANKS",0
	.byt 2,0," ",0
	.byt 2,0," ",0
	.byt 2,0," ",0
	.byt FX_TEXT_OFFSET(9) ,56,"LAST NOTE",0
	.byt FX_TEXT_OFFSET(10),84,"WORSHIPING",0
	.byt FX_TEXT_OFFSET(11),84,"RABBITS MAY",0
	.byt FX_TEXT_OFFSET(9) ,84,"ALSO CAUSE",0
	.byt FX_TEXT_OFFSET(8) ,84,"TROUBLES",0
	.byt 2,0," ",0
	.byt 0


; Alternative implementation for scroller:
; Generate a buffer of 199 LDA $a000+40*1,x STA $a000+40*0,x -> 3+3=6 bytes * 199 = 1194 bytes
; $BD $00 $A0   LDA $a000,x
; $9D $00 $A0   STA $a000,x
; $60           RTS

_FxTitleScroll_GenerateCopyBuffer
	;jmp _FxTitleScroll_GenerateCopyBuffer
.(
	lda #<$a000
	sta tmp0+0
	lda #>$a000
	sta tmp0+1

	lda #<_Final_Scroll_Buffer
	sta tmp1+0
	lda #>_Final_Scroll_Buffer
	sta tmp1+1

	ldx #198
loop
	ldy #3
	lda #$9D          ; STA abs,x
	sta (tmp1),y
	iny
	lda tmp0+0
	sta (tmp1),y
	iny
	lda tmp0+1
	sta (tmp1),y
	iny

	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1

	ldy #0
	lda #$BD          ; LDA abs,x
	sta (tmp1),y
	iny
	lda tmp0+0
	sta (tmp1),y
	iny
	lda tmp0+1
	sta (tmp1),y
	iny


	clc
	lda tmp1+0
	adc #6
	sta tmp1+0
	lda tmp1+1
	adc #0
	sta tmp1+1

	dex 
	bne loop	

	ldy #0
	lda #$60          ; RTS
	sta (tmp1),y

	rts
.)



_FxTitle_Scroll
.(
	lda #28
	sta tmp2
big_loop

	ldx #0
	jsr _Final_Scroll_Buffer

	ldx #2
loop_x	
	jsr _Final_Scroll_Buffer
	inx 
	cpx #40
	bne loop_x
	
	//jsr _VSync

	dec tmp2
	bne big_loop

	rts
.)  


#define MANDEL_NAME_AREA $a000+40*170

_FxTitle_InitBorderColors
.(
	lda #<MANDEL_NAME_AREA	
	sta tmp0+0
	lda #>MANDEL_NAME_AREA	
	sta tmp0+1

	ldx #28
loop_y
	ldy #1
	lda #0
	sta (tmp0),y

	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
		
	dex
	bne loop_y

	rts
.)



_Fx_DrawTitle
.(
	//
	// Prepare the tone mapping
	//
	jsr _VScroll_GenerateScrollMapping
	jsr _FxTitle_InitBorderColors

	jsr _FxTitleScroll_GenerateCopyBuffer

	lda #<_FxTitle_NameList	
	sta greetings_pointer+0
	lda #>_FxTitle_NameList	
	sta greetings_pointer+1

	.(
	// First part of scroller, in blue
	lda #30
	sta tmp3
loop
	jsr _Mandel_DisplayGreetings
	jsr _FxTitle_Scroll
	dec tmp3
	bne loop
	.)

	rts
.)



	


