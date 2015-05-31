
#include "defines.h"
#include "script.h"
#include "floppy_description.h"

	.zero

	*=20  ; Before is the load zero page stuff...

tmp0                        .dsb 2
tmp1                        .dsb 2

_MessageScrollerPtr			.dsb 2

_OverlayStartPtr            .dsb 2     	; Pointer to the current starting line
_OverlayCounter             .dsb 1 		; How many lines we want to move
_OverlayDirection           .dsb 1 		; Direction for the decount (0=does not move)
_OverlayLineInc             .dsb 1      ; How much we increment between each line (a big hack to not show the overlay at all)

character_offset	.dsb 1
character_width		.dsb 1

_BackgroundMapActive	.dsb 1
_BackgroundMapX			.dsb 1        	; Map position
_BackgroundMapDX		.dsb 1 			; Map increment (signed)

_BackgroundBottomActive	.dsb 1
_BackgroundBottomX		.dsb 1        	; Map position
_BackgroundBottomDX		.dsb 1 			; Map increment (signed)

_ScrollerCommand			.dsb 1
_ScrollerCommandParam1		.dsb 1
_ScrollerCommandParam2		.dsb 1
_ScrollerCommandParam3		.dsb 1
_ScrollerCommandParam4		.dsb 1


	.text

_main
_TechTechInit
//	jmp _TechTechInit
.(
	// Clear the screen
	// $9800 + 32*8 = $9900
	lda #0
	ldy #$c0-$98
loop_clear_outer
	ldx #0	
loop_clear_inner
	sta $9800,x
	inx
	bne loop_clear_inner
	inc loop_clear_inner+2
	dey
	bne loop_clear_outer


;bloooo jmp bloooo

	// Put the text attribute at the bottom right to foce us back to TEXT mode
	// poke((char*)0xbfdf,26);														// 50hz Text attribute
	lda #26
	sta $a000
	sta $bfdf

	// Load files
	// Load the 6x8 font
	ldx #LOADER_FONT_6x8
	jsr _LoadFileRegister

	// Load the VIP scroll stuff (HAS TO BE BEFORE _BufferCharset30x40)
	ldx #LOADER_VIP_SCROLL
	lda #<_BufferCharset
	ldy #>_BufferCharset
	jsr _LoadFileAtAddressRegister

	// Copy the 96*8=768 bytes of charset data while adding an attribute neutral value bit to avoid glitches in case of screen conflict
	ldx #0
loop_copy_std_charset
	lda _BufferCharset+CHARMAP_SIZE+256*0,x
	ora #64
	sta $b400+8*32+256*0,x
	lda _BufferCharset+CHARMAP_SIZE+256*1,x
	ora #64
	sta $b400+8*32+256*1,x
	lda _BufferCharset+CHARMAP_SIZE+256*2,x
	ora #64
	sta $b400+8*32+256*2,x
	inx
	bne loop_copy_std_charset

	// Load the BIG scroll stuff (HAS TO BE BEFORE _BufferInverseVideo)
	ldx #LOADER_FONT_30x40
	lda #<_BufferCharset30x40
	ldy #>_BufferCharset30x40
	jsr _LoadFileAtAddressRegister

	// Copy the 15*8=768 bytes of charset data while adding an attribute neutral value bit to avoid glitches in case of screen conflict
	ldx #127
loop_copy_alt_charset
	lda _BufferCharset30x40+BIGFONT_SIZE+256*0,x
	ora #64
	sta $b800+8*32+256*0,x
	dex
	bpl loop_copy_alt_charset	

	//
	// Load the 36x128 overlay file (#define LOADER_OVERLAY_SIZE 5376)
	//
	ldx #LOADER_OVERLAY;
	lda #<_BufferInverseVideo
	ldy #>_BufferInverseVideo
	jsr _LoadFileAtAddressRegister   // <-- memory overwrite at the moment, need to fix that

	// Filter the content of the buffer to only have zeroes and 128 values
	// 36*128=4608 bytes = 18*256
	.(
	lda #0
	ldy #18
loop_inverse_outer
	ldx #0	
loop_inverse_inner
	sec
load_value	
	lda _BufferInverseVideo,x 		; 32/33
	sbc #32
	beq skip
	lda #128
skip	
update_value
	sta _BufferInverseVideo,x
	inx
	bne loop_inverse_inner
	inc load_value+2
	inc update_value+2
	dey
	bne loop_inverse_outer
	.)

	lda #<_BufferInverseVideo
	sta _OverlayStartPtr+0
	lda #>_BufferInverseVideo
	sta _OverlayStartPtr+1

	lda #128-16
	sta _OverlayCounter

	lda #0
	sta _OverlayDirection

	lda #0
	sta _OverlayLineInc

	// Load the sample sound
	ldx #LOADER_SAMPLE_BOOMTSCHACK;
	lda #<_SampleSound
	ldy #>_SampleSound
	jsr _LoadFileAtAddressRegister

	// Load the second sample sound
	ldx #LOADER_SAMPLE_DEFENCE;
	lda #<_SampleSoundDefence
	ldy #>_SampleSoundDefence
	jsr _LoadFileAtAddressRegister

	// Load the second sample sound
	ldx #LOADER_SAMPLE_FORCE;
	lda #<_SampleSoundForce
	ldy #>_SampleSoundForce
	jsr _LoadFileAtAddressRegister
	
	// Load the second sample sound
	ldx #LOADER_SAMPLE_MUSIC_NON_STOP;
	lda #<_SampleSoundMusicNonStop
	ldy #>_SampleSoundMusicNonStop
	jsr _LoadFileAtAddressRegister

	// Load the second sample sound
	ldx #LOADER_SAMPLE_TECHNO_POP;
	lda #<_SampleSoundTechnoPop
	ldy #>_SampleSoundTechnoPop
	jsr _LoadFileAtAddressRegister

	// Load the second sample sound
	ldx #LOADER_SAMPLE_CHIME_START;
	lda #<_SampleSoundChimeStart
	ldy #>_SampleSoundChimeStart
	jsr _LoadFileAtAddressRegister

	// Load the second sample sound
	ldx #LOADER_SAMPLE_CHIME_END;
	lda #<_SampleSoundChimeEnd
	ldy #>_SampleSoundChimeEnd
	jsr _LoadFileAtAddressRegister

	// Initialize the various elements of the big text scroller
	jsr _BigScrollerInit

	// Initialize the colortext mode
	/*
	screen=(char*)0xa000;
	for (y=0;y<200;y++)
	{
		if ((y<=128) || (y>=160))
		{			
			screen[0]=   RastersInk[y];			    // Color
			screen[1]=16+RastersPaper[y];			// Color

			screen[2]=26;				// TEXT
		}
		screen+=40;
	}
	*/
	// First part is the hires setup loop
	.(
;bla jmp bla

	lda #<$a000
	sta tmp0+0
	lda #>$a000
	sta tmp0+1
	ldx #0
loop_hires	
	; The 128-159 zone is where the text scroller is located, it also overlaps the area with the charsets
	cpx #128
	bcc top_rasters
	cpx #168
	bcc skip

bottom_rasters
	ldy #1
	lda _RastersPaper-168+120-1,x 	; Paper color
	//lda #16+5  ;_RastersPaper-168+128,x 	; Paper color
	ora #16
	sta (tmp0),y

	iny
	lda #26  				; TEXT attribute
	sta (tmp0),y
	jmp skip

top_rasters
	ldy #0 				
	lda _RastersInk,x 		; Ink color
	sta (tmp0),y

	iny
	lda _RastersPaper,x 	; Paper color
	ora #16
	sta (tmp0),y

	iny
	lda #26  				; TEXT attribute
	sta (tmp0),y
	jmp skip


skip	
	jsr _PtrPlus40
	inx
	cpx #176
	bne loop_hires
	.)

	// Second part is the TEXT setup loop
	// From Line 16, need to clear 5 lines of TEXT
	lda #32
	ldx #40*5	
loop_clear_scroller
	sta $bb80+40*16-1,x
	dex
	bne loop_clear_scroller

	/*
	screen=(char*)0xbb80;
	for (y=0;y<28;y++)
	{
		if (y>=25)
		{
			// 3 last lines of TEXT
			screen[0]=   1;
			screen[1]=16+7;

			screen[2]=26;				// TEXT
			screen[39]=26;				// TEXT
		}
		else
		if ((y<16) || (y>=21) )
		{			
			// Rest of the screen
			screen[2]=26;				// TEXT
			screen[39]=30;				// HIRES
		}
		else
		{
			// ALT font scroller
			screen[0]=26;				// TEXT
			screen[1]=(16+RastersPaper[y*8])|128;			// Color
			screen[2]=9|128;				// ALT
			screen[39]=0|128;				// whatever
		}
		screen+=40;
	}

	*/	
	.(
;bla jmp bla

	lda #<$bb80
	sta tmp0+0
	lda #>$bb80
	sta tmp0+1
	ldx #0
loop_text
	cpx #25
	bcs lastLinesOfText
	cpx #21
	bcs bottomOfTheScreen
	cpx #16
	bcs altFontScroller

restOfTheScreen
	ldy #0 				
	lda #26  				; TEXT attribute
	sta (tmp0),y

	ldy #39
	lda #30					; HIRES attribute
	sta (tmp0),y

	jmp skip

altFontScroller
	ldy #0 				
	;lda #26  				; TEXT attribute
	lda #9 					; ALT mode
	sta (tmp0),y

	iny
	lda #16+4+128			; Paper color
	sta (tmp0),y

	;iny
	;lda #9+128 				; ALT mode
	;sta (tmp0),y

	ldy #39
	lda #0|128				; Whatever (in video inverse)
	sta (tmp0),y

	jmp skip

bottomOfTheScreen
	ldy #0 				
	lda #1  				; RED ink
	sta (tmp0),y

	iny
	lda #16+0  				; BLACK paper
	sta (tmp0),y

	iny
	lda #16+0  				; BLACK paper
	sta (tmp0),y

	ldy #39
	lda #16+0				; BLACK paper
	sta (tmp0),y

	jmp skip

lastLinesOfText
	ldy #0 				
	lda #1					; Ink color
	sta (tmp0),y

	iny
	lda #16+0 				; Paper color
	sta (tmp0),y

	iny
	lda #26  				; TEXT attribute
	sta (tmp0),y
	ldy #39
	sta (tmp0),y

	jmp skip

skip	
	jsr _PtrPlus40
	inx
	cpx #28
	bne loop_text
	.)


	lda #0
	ldx #39
loop_clean_line	
	sta $bb80+40*21+1,x				// neutral attribute to hide characters under
	dex
	bne loop_clean_line
	lda #26
	sta $a000+40*21*8+2				// First byte of the line 21 -> go to texthires to show the rasters
	lda #30
	sta $bb80+40*21+0 				// First byte of the line 21 -> back to hires to show the rasters


	/*
	lda #26
	sta $a000+40*128+0 				// First byte of the ALT scroller area -> back to text
	lda #9
	sta $a000+40*128+1 				// First byte of the ALT scroller area -> back to text

	lda #26
	sta $a000+40*127+0 				// First byte of the ALT scroller area -> back to text


	lda #16+1
	sta $bb80+40*16+1 				// First byte of the line 21 -> back to hires to show the rasters
	*/

	lda #26
	sta $a000+40*128+39 				// First byte of the ALT scroller area -> back to text


	; b900=start of the reconfigurated area


	// Then initialize the sample player
	jsr _DigiPlayer_InstallIrq


	//
	// And now the actual demo main loop
	//
	/*
	while (1)
	{
		VSync();
		BigScrollerUpdate();
		DisplayBackground();
	}
	*/
demo_loop

	.(
wait_sync		
	lda _VblCounter
	beq wait_sync
	lda #0
	sta _VblCounter
	.)

	jsr _BigScrollerUpdate
	jsr _DisplayBackground
	jmp demo_loop


	rts
.)

_PtrPlus40
.(
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip	
	rts
.)



_BigScrollerInit
	;jmp _BigScrollerInit
.(
	; Start by initializing the arrays
	ldx #0	
loop_init
	lda #0
	sta _BigFontOffset,x
	lda #1
	sta _BigFontWidth,x

	inx
	cpx #128
	bne loop_init

	; Then for each known character, set the actual correct information
	ldx #0
	lda #0
loop
	ldy _BigFontCharacter,x
	beq end

	sta _BigFontOffset,y			; Save the offset

	sta tmp0
	lda _BigFontCharacterWidth,x	; Load the width
	sta _BigFontWidth,y				; Save the width
	clc
	adc tmp0

	inx
	jmp loop
end	

	jsr ScrollerDisplayReset

	lda #0
	sta character_offset
	sta character_width
	sta _BackgroundMapActive
	sta _BackgroundMapDX
	sta _BackgroundBottomActive
	sta _BackgroundBottomDX

	lda #36
	sta _BackgroundMapX
	sta _BackgroundBottomX
	rts
.)	

_BigFontOffset	.dsb 128		; Where in the picture does the letter start
_BigFontWidth	.dsb 128		; How many column wide is the character

ScrollerDisplayReset
	lda #<_BigScrollMessage
	sta _MessageScrollerPtr
	lda #>_BigScrollMessage
	sta _MessageScrollerPtr+1
	rts

ScrollerIncPointer	
	inc _MessageScrollerPtr
	bne skipscrollermove
	inc _MessageScrollerPtr+1
skipscrollermove
	rts

_BigScrollerUpdate
.(
	; Scroll the entire thing to the left by one character
	ldx #2
loop
	lda $bb80+40*16+1,x
	sta $bb80+40*16+0,x

	lda $bb80+40*17+1,x
	sta $bb80+40*17+0,x

	lda $bb80+40*18+1,x
	sta $bb80+40*18+0,x

	lda $bb80+40*19+1,x
	sta $bb80+40*19+0,x

	lda $bb80+40*20+1,x
	sta $bb80+40*20+0,x

	inx
	cpx #38
	bne loop	

	; Then we introduce one new line of characters
	; The font description is BIGFONT_WIDTH (184 characters) wide at this point
	ldx character_offset	; New column
	dec character_width		; Check if it was the last one
	bpl continue_character

new_character
    ldy #0
	lda (_MessageScrollerPtr),y
	jsr ScrollerIncPointer
	cmp #32
	bcc SpecialCommand

	tay
	ldx _BigFontOffset,y
	stx character_offset
	lda _BigFontWidth,y
	sta character_width
	jmp insert_column

continue_character	
	bne insert_column
	ldx #0					; Insert the separator between characters so they are not all glued together
insert_column
	lda _BufferCharset30x40+BIGFONT_WIDTH*0,x
	sta $bb80+40*16+38
	lda _BufferCharset30x40+BIGFONT_WIDTH*1,x
	sta $bb80+40*17+38
	lda _BufferCharset30x40+BIGFONT_WIDTH*2,x
	sta $bb80+40*18+38
	lda _BufferCharset30x40+BIGFONT_WIDTH*3,x
	sta $bb80+40*19+38
	lda _BufferCharset30x40+BIGFONT_WIDTH*4,x
	sta $bb80+40*20+38

	inc character_offset

	rts


SpecialCommand	
	//jmp SpecialCommand

	cmp #SCROLLER_TOP_ACTIVE
	beq ScrollerTopActive
	cmp #SCROLLER_TOP_SET_X
	beq ScrollerTopSetX
	cmp #SCROLLER_TOP_SET_DX
	beq ScrollerTopSetDX

	cmp #SCROLLER_BOTTOM_ACTIVE
	beq ScrollerBottomActive
	cmp #SCROLLER_BOTTOM_SET_X
	beq ScrollerBottomSetX
	cmp #SCROLLER_BOTTOM_SET_DX
	beq ScrollerBottomSetDX

	cmp #SCROLLER_OVERLAY_SET_Y
	beq ScrollerOverlaySetY
	cmp #SCROLLER_OVERLAY_SET_LINEINC
	beq ScrollerOverlaySetLineInc
	cmp #SCROLLER_OVERLAY_SET_DIRECTION
	beq ScrollerOverlaySetDirection

	//; Anything else we treat as an end of scroll
	jsr ScrollerDisplayReset
	jmp new_character


ScrollerTopActive
	lda (_MessageScrollerPtr),y
	sta _BackgroundMapActive
	jmp IncrementAndReadBack

ScrollerTopSetX
	clc
	lda (_MessageScrollerPtr),y
	adc #36
	sta _BackgroundMapX
	jmp IncrementAndReadBack

ScrollerTopSetDX
	lda (_MessageScrollerPtr),y
	sta _BackgroundMapDX
	jmp IncrementAndReadBack

ScrollerBottomActive
	lda (_MessageScrollerPtr),y
	sta _BackgroundBottomActive
	jmp IncrementAndReadBack

ScrollerBottomSetX
	clc
	lda (_MessageScrollerPtr),y
	adc #36
	sta _BackgroundBottomX
	jmp IncrementAndReadBack

ScrollerBottomSetDX
	lda (_MessageScrollerPtr),y
	sta _BackgroundBottomDX
	jmp IncrementAndReadBack

ScrollerOverlaySetY
	lda (_MessageScrollerPtr),y
	sta _OverlayStartPtr+0
	jsr ScrollerIncPointer
	lda (_MessageScrollerPtr),y
	sta _OverlayStartPtr+1
	jmp IncrementAndReadBack

ScrollerOverlaySetLineInc
	lda (_MessageScrollerPtr),y
	sta _OverlayLineInc
	jmp IncrementAndReadBack

ScrollerOverlaySetDirection
	lda (_MessageScrollerPtr),y
	sta _OverlayDirection
	jmp IncrementAndReadBack

IncrementAndReadBack
	jsr ScrollerIncPointer
	jmp new_character

.)


/*
#define PAINT(XX,YY)   sta _BufferInverseVideo+INVERSE_WIDTH*YY+XX

PaintCrap
	lda #128
	PAINT(0,0)
	PAINT(1,1)
	PAINT(2,2)
	PAINT(3,3)
	rts
*/


_DisplayBackground
 .(
	lda _BackgroundMapActive
	bne continue
	jmp end_top

continue	
	//jsr PaintCrap

	;
	; Update the overlay position based on the current coordinate
	;
	.(
	lda #<_patch_ora+1
	sta tmp0+0
	lda #>_patch_ora+1
	sta tmp0+1

	lda _OverlayStartPtr+0
	sta tmp1+0
	lda _OverlayStartPtr+1
	sta tmp1+1

	ldx #15
loop_patch	
	ldy #0
	lda tmp1+0
	sta (tmp0),y 	; Low byte
	clc
	adc _OverlayLineInc		;#INVERSE_WIDTH
	sta  tmp1+0

	iny
	lda tmp1+1
	sta (tmp0),y 	; High byte
	adc #0
	sta  tmp1+1

	clc
	lda tmp0+0
	adc #(_patch_ora2-_patch_ora)
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	dex
	bne loop_patch


	lda _OverlayDirection
	beq go_end
	bmi go_up

go_down
	clc
	lda _OverlayStartPtr+0
	adc #INVERSE_WIDTH
	sta _OverlayStartPtr+0
	lda _OverlayStartPtr+1
	adc #0
	sta _OverlayStartPtr+1

	dec _OverlayCounter
	bne go_end
	lda #255
	sta _OverlayDirection
	lda #128-16
	sta _OverlayCounter
	jmp go_end

go_up
	sec
	lda _OverlayStartPtr+0
	sbc #INVERSE_WIDTH
	sta _OverlayStartPtr+0
	lda _OverlayStartPtr+1
	sbc #0
	sta _OverlayStartPtr+1

	dec _OverlayCounter
	bne go_end
	lda #1
	sta _OverlayDirection
	lda #128-16
	sta _OverlayCounter
	jmp go_end

go_end

	/*
	lda #<_BufferInverseVideo
	sta _OverlayStartPtr+0
	lda #>_BufferInverseVideo
	sta _OverlayStartPtr+1
	lda #128-28
	sta _OverlayCounter
	lda #1
	sta _OverlayDirection
	*/

	.)




	;
	; Display the top part
	;
	clc
	lda _BackgroundMapX
	tay
	adc _BackgroundMapDX
	sta _BackgroundMapX

	ldx #36
loop_top
	; Top part
	lda _BufferCharset+CHARMAP_WIDTH*0-1,y
_patch_ora	
	ora _BufferInverseVideo+INVERSE_WIDTH*0-1,x
	sta $bb80+40*0+2,x

	lda _BufferCharset+CHARMAP_WIDTH*1-1,y
_patch_ora2	
	ora _BufferInverseVideo+INVERSE_WIDTH*1-1,x
	sta $bb80+40*1+2,x

	lda _BufferCharset+CHARMAP_WIDTH*2-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*2-1,x
	sta $bb80+40*2+2,x

	lda _BufferCharset+CHARMAP_WIDTH*3-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*3-1,x
	sta $bb80+40*3+2,x

	lda _BufferCharset+CHARMAP_WIDTH*4-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*4-1,x
	sta $bb80+40*4+2,x

	lda _BufferCharset+CHARMAP_WIDTH*5-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*5-1,x
	sta $bb80+40*5+2,x

	lda _BufferCharset+CHARMAP_WIDTH*6-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*6-1,x
	sta $bb80+40*6+2,x

	lda _BufferCharset+CHARMAP_WIDTH*7-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*7-1,x
	sta $bb80+40*7+2,x

	lda _BufferCharset+CHARMAP_WIDTH*8-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*8-1,x
	sta $bb80+40*8+2,x

	lda _BufferCharset+CHARMAP_WIDTH*9-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*9-1,x
	sta $bb80+40*9+2,x

	lda _BufferCharset+CHARMAP_WIDTH*10-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*10-1,x
	sta $bb80+40*10+2,x

	lda _BufferCharset+CHARMAP_WIDTH*11-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*11-1,x
	sta $bb80+40*11+2,x

	lda _BufferCharset+CHARMAP_WIDTH*12-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*12-1,x
	sta $bb80+40*12+2,x

	lda _BufferCharset+CHARMAP_WIDTH*13-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*13-1,x
	sta $bb80+40*13+2,x

	lda _BufferCharset+CHARMAP_WIDTH*14-1,y
	ora _BufferInverseVideo+INVERSE_WIDTH*14-1,x
	sta $bb80+40*14+2,x

	dey
	dex
	beq end_top
	jmp loop_top
end_top


	;
	; Display the Bottom part
	;   
	lda _BackgroundBottomActive
	beq end_bottom

	;
	; Display the top part
	;
	clc
	lda _BackgroundBottomX
	tay
	adc _BackgroundBottomDX
	sta _BackgroundBottomX

	ldx #36
loop_bottom
	lda _BufferCharset+CHARMAP_WIDTH*15-1,y
	sta $bb80+40*22+2,x

	lda _BufferCharset+CHARMAP_WIDTH*16-1,y
	sta $bb80+40*23+2,x

	lda _BufferCharset+CHARMAP_WIDTH*17-1,y
	sta $bb80+40*24+2,x

	lda _BufferCharset+CHARMAP_WIDTH*18-1,y
	sta $bb80+40*25+2,x

	lda _BufferCharset+CHARMAP_WIDTH*19-1,y
	sta $bb80+40*26+2,x

	lda _BufferCharset+CHARMAP_WIDTH*20-1,y
	sta $bb80+40*27+2,x

	dey
	dex
	bne loop_bottom
end_bottom


	; Force hires on the last byte
	lda #30
	sta $bfdf

	;lda #26
	;sta $a000+40*128+0

	rts
.)

_BigFontCharacter
	.byt " ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789?()!-.,;",0
	
_BigFontCharacterWidth
	.byt 2 	                  ; space
	.byt 5,5,5,5,5,5,5,5,2,5  ; ABCDEFGHIJ
	.byt 5,5,5,5,5,5,5,5,5,5  ; KLMNOPQRST
	.byt 5,5,5,5,5,5          ; UVWXYZ
	.byt 3,5,5,5,5,5,5,5,5    ; 123456789
	.byt 5,3,3,2,3,1,2,2      ; ?()!-.,;

_BigScrollMessage

	.byt "HELLO EVERYBODY AT VIP 2O15!!!       "

	.byt "I (DBUG) WISH I WAS THERE WITH YOU...         "
	.byt SCROLLER_TOP_ACTIVE,1

	.byt "THIS LITTLE INTRO IS MY WAY OF SAYING THANKS ;)     "
	.byt SCROLLER_BOTTOM_ACTIVE,1
	.byt "AND AS USUAL BARELY MADE THE DEADLINE...       "
	.byt SCROLLER_BOTTOM_SET_DX,1

	.byt "LET MOVE THINGS AROUND!!!       "
	.byt SCROLLER_TOP_SET_DX,255

	.byt "I GUESS WE CAN STILL ADD STUFF???       "
	.byt SetOverlayPosition(0)
	.byt SCROLLER_OVERLAY_SET_LINEINC,INVERSE_WIDTH       ; Show the overlay

	.byt "LET MOVE THAT ONE TOO!!!       "
	.byt SCROLLER_OVERLAY_SET_DIRECTION,1
	.byt SCROLLER_TOP_SET_DX,1

	.byt "INTRO MUSIC BY MAD MAX, THIS MUSIC BY KRAFTWERK, REMAINING STUFF BY DBUG... "

	.byt SCROLLER_TOP_SET_DX,0
	//.byt SCROLLER_TOP_SET_X,0
	.byt "GREETING TO: POPSY TEAM, LNX, AAA, "
	.byt SCROLLER_BOTTOM_SET_DX,2
	.byt "X-MEN, HMD, DRIFTERS, "
	.byt SCROLLER_TOP_SET_DX,1
	.byt "RIBBON, MOV, VORTEX, "
	.byt SCROLLER_BOTTOM_SET_DX,3
	.byt "CALODOX, ORION, JFF, CONDENSE, "
	.byt SCROLLER_TOP_SET_DX,255
	.byt "MDR, SYN(RJ), NOON, COCOON, MJJ, RAZOR, "
	.byt SCROLLER_BOTTOM_SET_DX,4
	.byt "REBELS, ADINPSZ, BRAINSTORM, NO EXTRA, KIKI, SECTOR 1 "
	.byt SCROLLER_BOTTOM_SET_DX,253
	.byt "TCB, OVR, TBL, WCZ, TKZ348, AND YOU SINCE YOU ARE WATCHING IT! "
	.byt SCROLLER_BOTTOM_SET_DX,0

	.byt "I HOPE YOU LIKED IT! "
	.byt "LET'S WRAP NOW... "
	.byt "                 "
	.byt SCROLLER_END
