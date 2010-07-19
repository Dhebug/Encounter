// ============================================================================
//
//						Sequences.s
//
// ============================================================================
//
// Just the various parts shown in the demo
//
// ============================================================================


_LogoColor	.byt 7,7,7,3,7,3,3,1,3,1,1,3,1,3,3,3
_EarthColor	.byt 4,4,4,6,4,6,6,2,6,2,2,6,2,6,6,6

i0 .byt 0
i1 .byt 0

ii0 .byt 0
ii1 .byt 0

_W	.byt 0
_H	.byt 0


_ColorsFadeStartPtr		.word 0	
_ColorsFadeCurrentPtr	.word 0	

_ColorPaperDarkGreen
	.byt 2
	.byt 16+2,16+0
	
_ColorPaperBlack
	.byt 1
	.byt 16+0

_ColorPaperDarkBlue	
	.byt 2
	.byt 16+4,16+0
		
_ColorPaperBlue	
	.byt 1
	.byt 16+4

_ColorPaperDarkCyan	
	.byt 2
	.byt 16+6,16+4
		
_ColorPaperCyan	
	.byt 1
	.byt 16+6

_ColorPaperDarkWhite
	.byt 2
	.byt 16+7,16+6

_ColorPaperWhite
	.byt 1
	.byt 16+7
		
_ColorPaperYellow
	.byt 1
	.byt 16+3
		
_ColorPaperRed	
	.byt 1
	.byt 16+1
		
_ColorInkYellow
	.byt 1
	.byt 3
	
_ColorInkBlack	
	.byt 1
	.byt 0
	
_ColorInkWhite	
	.byt 1
	.byt 7

_ColorInkBlue
	.byt 1
	.byt 4

_ColorInkCyan
	.byt 1
	.byt 6

_ColorInkDarkCyan
	.byt 2
	.byt 6,4

_ColorInkOrange
	.byt 2
	.byt 1,3
		
_ColorInkRed
	.byt 1
	.byt 1
				
; 1,2,4 = default
; 4,2,1 = interesting

_ColorInkDefaultRGB
	.byt 3
	.byt 1,2,4

_ColorInkAlternateRGB
	.byt 3
	.byt 2,4,1

	
_ColorsCrescentMoon
	.byt 19,10,70,<_ColorsFadeList,>_ColorsFadeList		; X,Y,H,Fadelist
			
_ColorsDoublePlanet
	.byt 20,20,70,<_ColorsFadeList,>_ColorsFadeList		; X,Y,H,Fadelist

_ColorsBarbaraBain
	.byt 24,51,55,<_ColorsFadeList,>_ColorsFadeList		; X,Y,H,Fadelist

_ColorsSylviaAnderson
	.byt 11,117,55,<_ColorsFadeList,>_ColorsFadeList	; X,Y,H,Fadelist
		
_ColorsTwilighte
	.byt 1,80,120,<_ColorsFadeList,>_ColorsFadeList	; X,Y,H,Fadelist
	
_ColorsQuote1
	.byt 0,0,50,<_ColorsFadeList,>_ColorsFadeList		; X,Y,H,Fadelist

_ColorsQuote2
	.byt 0,50,50,<_ColorsFadeList,>_ColorsFadeList		; X,Y,H,Fadelist

_ColorsQuote3
	.byt 0,100,70,<_ColorsFadeList,>_ColorsFadeList		; X,Y,H,Fadelist

_ColorsQuote4
	.byt 0,170,30,<_ColorsFadeList,>_ColorsFadeList			; X,Y,H,Fadelist
			
_ColorsQuoteAll
	.byt 0,0,200,<_ColorsFadeListOut,>_ColorsFadeListOut	; X,Y,H,Fadelist

_ColorsFadeToWhite
	.byt 0,0,200,<_ColorsPaperFadeList,>_ColorsPaperFadeList	; X,Y,H,Fadelist
				
_ColorsFadeList	
	.byt <_ColorInkBlack,>_ColorInkBlack
	.byt <_ColorInkBlue,>_ColorInkBlue
	.byt <_ColorInkCyan,>_ColorInkCyan
	.byt <_ColorInkWhite,>_ColorInkWhite
_ColorsFadeListOut	
	.byt <_ColorInkYellow,>_ColorInkYellow
	.byt <_ColorInkRed,>_ColorInkRed
	.byt <_ColorInkBlue,>_ColorInkBlue
	.byt <_ColorInkBlack,>_ColorInkBlack
			

_ColorsPaperFadeList
	.byt <_ColorPaperBlack,>_ColorPaperBlack
	.byt <_ColorPaperBlack,>_ColorPaperBlack
	.byt <_ColorPaperDarkBlue,>_ColorPaperDarkBlue
	.byt <_ColorPaperBlue,>_ColorPaperBlue
	.byt <_ColorPaperDarkCyan,>_ColorPaperDarkCyan
	.byt <_ColorPaperCyan,>_ColorPaperCyan
	.byt <_ColorPaperDarkWhite,>_ColorPaperDarkWhite
	.byt <_ColorPaperWhite,>_ColorPaperWhite
_ColorsPaperFadeListOut	
	.byt <_ColorPaperYellow,>_ColorPaperYellow
	.byt <_ColorPaperRed,>_ColorPaperRed
	.byt <_ColorPaperBlue,>_ColorPaperBlue
	.byt <_ColorPaperBlack,>_ColorPaperBlack
	
		
_ColorCyclespace1999Logo
.(
	lda #128
	sta _FrameCounter
couterloop
	; ii0=i0;
	; ii1=i1;
	lda i0
	sta ii0
	
	lda i1
	sta ii1

	; pLine=(unsigned char*)0xa000+2;
	lda #<$a000+2
	sta tmp0+0
	lda #>$a000+2
	sta tmp0+1

	ldx #0	
loop_y
	txa
	and #1
	beq logo
	
earth
	lda ii1
	and #15
	tay
	lda _EarthColor,y
	iny
	sty ii1
	jmp end
	
logo
	lda ii0
	and #15
	tay
	lda _LogoColor,y
	iny
	sty ii0
	jmp end

end
	ldy #0
	sta (tmp0),y
		
	; pLine+=40;
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1
	
	inx
	cpx #90
	bne loop_y

	inc i0
	dec i1

	lda #3
	sta _TimerCounter
wait
	lda _TimerCounter
	bne wait		
		
	dec _FrameCounter
	bne couterloop
	
	rts
.)


; Call with a/x pointing on the file to unpack
; Will unpack to the _BufferUnpack
_FileUnpackToBuffer
.(
	sta ptr_source+0
	stx ptr_source+1

	lda #<_BufferUnpack
	sta ptr_destination+0
	lda #>_BufferUnpack
	sta ptr_destination+1
	
	jmp _FileUnpack
.)

_SequenceSpace1999Logo
	lda #<_LabelPictureLogo
	ldx #>_LabelPictureLogo
	jsr _FileUnpackToBuffer
	
	jsr _FlipToScreen
	
	; color_cycle(255);//64);
	jmp _ColorCyclespace1999Logo


_SequenceItcLogo
	lda #<_LabelPictureItcLogo
	ldx #>_LabelPictureItcLogo
	jsr _FileUnpackToBuffer

	jsr _FlipToScreen
	
	ldx #4
	jmp _WaitSecond


_SequenceDefenceForceLogo
.(
	jsr _BlackScreen
	
	lda #<_ColorsFadeToWhite
	ldx #>_ColorsFadeToWhite
	jsr _ColorsFadeInit
	
	jsr _UnpackFont
	lda #<_Message_ProducedBy
	ldx #>_Message_ProducedBy
	jsr _DrawTextAsm
	
	lda #<_LabelPictureDefenceForce
	ldx #>_LabelPictureDefenceForce
	jsr _FileUnpackToBuffer
	
	jsr _FadeInOrOut
	jsr _FadeInOrOut
	jsr _DisplayPaperSet
	
	jsr _DisplayMakeShiftedLogos
	jsr _DisplayDefenceForceFrame

	lda #100
	sta _FrameCounter
loop	
	jsr _DisplayScrappIt
	dec _FrameCounter
	bne loop

	jsr _BlackScreen	
	rts
.)








_UnpackFont
.(
	lda #<_LabelPictureFont
	sta ptr_source+0
	lda #>_LabelPictureFont
	sta ptr_source+1
	
	lda #<_BufferUnpack
	sta ptr_destination+0
	lda #>_BufferUnpack
	sta ptr_destination+1
	
	jmp _FileUnpack
.)





; tmp0=pointer on color
; _X=start column
; _Y=start row
; _H=height	
_SetColorBand
	;jmp _SetColorBand
.(
	; pdst_line=(unsigned char*)0xa000+Y*40; -> tmp5
	ldy _Y
	clc
	lda _HiresAddrLow,y
	adc _X
	sta __patch_hires+1
	lda _HiresAddrHigh,y
	adc #0
	sta __patch_hires+2
	
	ldy #0
	lda (tmp0),y
	sta __patch_wrap+1
	inc __patch_wrap+1
	
	lda tmp0+0
	sta __patch_colors+1
	lda tmp0+1
	sta __patch_colors+2
	
	ldx #1
	ldy _H
loop_y
__patch_colors
	lda $1234,x
__patch_hires	
	sta $a000
	
	clc
	lda __patch_hires+1
	adc #40
	sta __patch_hires+1
	lda __patch_hires+2
	adc #0
	sta __patch_hires+2
	
	inx
__patch_wrap
	cpx #$12
	bne skip
	ldx #1	
skip	
	
	dey
	bne loop_y	
	rts
.)

; a/x=pointer on color
_SetPaperColor
	sta tmp0+0
	stx tmp0+1

	lda #0
	sta _X
	
	lda #0
	sta _Y
	
	lda #200
	sta _H
	
	jmp _SetColorBand

; a/x=pointer on color
_SetInkColor
	sta tmp0+0
	stx tmp0+1
	
	lda #1
	sta _X
	
	lda #0
	sta _Y
	
	lda #200
	sta _H
	
	jmp _SetColorBand

_SetInkYellow
	lda #<_ColorInkYellow
	ldx #>_ColorInkYellow
	jmp _SetInkColor
	
_SetInkBlack
	lda #<_ColorInkBlack
	ldx #>_ColorInkBlack
	jmp _SetInkColor

_SetInkWhite
	lda #<_ColorInkWhite
	ldx #>_ColorInkWhite
	jmp _SetInkColor

	
; a=low adr
; x=high adr
_ColorsFadeInit
	sta _ColorsFadeStartPtr+0
	stx _ColorsFadeStartPtr+1
	
	clc
	adc #3
	sta tmp0+0
	txa
	adc #0
	sta tmp0+1

	ldy #0
	lda (tmp0),y
	sta _ColorsFadeCurrentPtr+0
	iny
	lda (tmp0),y
	sta _ColorsFadeCurrentPtr+1
		
	jmp _ColorsFadeDo

_ColorsFadeDo
	lda _ColorsFadeStartPtr+0
	sta tmp0+0
	lda _ColorsFadeStartPtr+1
	sta tmp0+1
	
	ldy #0
	lda (tmp0),y
	sta _X
	
	iny 
	lda (tmp0),y
	sta _Y
	
	iny 
	lda (tmp0),y
	sta _H
	
	clc
	lda _ColorsFadeCurrentPtr+0
	sta tmp1+0
	adc #2
	sta _ColorsFadeCurrentPtr+0
	lda _ColorsFadeCurrentPtr+1
	sta tmp1+1
	adc #0
	sta _ColorsFadeCurrentPtr+1
	
	ldy #0
	lda (tmp1),y
	sta tmp0+0
	
	iny 
	lda (tmp1),y
	sta tmp0+1
	
	jsr _SetColorBand

	rts

	
	
DrawRatingBox
.(
	.(
	; The thick horizontal lines
	ldx #36
	lda #%01111111
loop_horizontal
	sta $a001+40*119,x
	sta $a001+40*120,x
	
	sta $a001+40*142,x
	sta $a001+40*143,x

	sta $a001+40*158,x
		
	sta $a001+40*173,x
	sta $a001+40*174,x
	dex
	bne loop_horizontal
	.)
	
	.(
	; The vertical lines on each side to close the box
	lda #<$a001+40*119
	sta tmp0+0
	lda #>$a001+40*119
	sta tmp0+1	
	ldx #56
loop_vertical
	lda #%01000011
	ldy #0
	sta (tmp0),y	

	lda #%01110000
	ldy #37
	sta (tmp0),y	
		
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1
	
	dex
	bne loop_vertical	
	.)

	.(
	; The small line to split the box with the General Audiences texte
	lda #<$a001+40*121
	sta tmp0+0
	lda #>$a001+40*121
	sta tmp0+1	
	ldx #21
loop_vertical
	lda #%01110000
	ldy #5
	sta (tmp0),y	
		
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1
	
	dex
	bne loop_vertical
	.)	
		
	rts	
.)


_SequenceRating
.(
	jsr _UnpackFont
	
	jsr _SetInkBlack
				
	lda #<_Message_Rating
	ldx #>_Message_Rating
	jsr _DrawTextAsm	

	lda #<_Message_Rating_Bottom
	ldx #>_Message_Rating_Bottom
	sta tmp0+1
	jsr _DrawTextAsm	
	
	lda #<_ColorPaperDarkGreen
	ldx #>_ColorPaperDarkGreen
	jsr _SetPaperColor
	jsr _SetInkWhite
	
	jsr DrawRatingBox
		
	ldx #6
	jmp _WaitSecond
.)


_SequenceMartinLandau
	lda #<_LabelPictureMartinLandau
	ldx #>_LabelPictureMartinLandau
	jsr _FileUnpackToBuffer
	
	jsr _FlipToScreen
	
	jsr _UnpackFont
	
	lda #<_Message_StarringMartinLandau
	ldx #>_Message_StarringMartinLandau
	jsr _DrawTextAsm
	
	ldx #3
	jmp _WaitSecond
	

_SequenceSylviaAnderson
.(
	lda #0
	jsr _ShowPictureBlueGalaxies
	
	lda #<_ColorsSylviaAnderson
	ldx #>_ColorsSylviaAnderson
	jsr _ColorsFadeInit
		
	jsr _UnpackFont
	
	lda #<_Message_SylviaAnderson
	ldx #>_Message_SylviaAnderson
	jmp _DrawTextAndFadeInAndOut
	
	jsr _UnpackFont
	
	lda #<_Message_SylviaAnderson
	ldx #>_Message_SylviaAnderson
	jsr _DrawTextAsm
	
	ldx #4
	jmp _WaitSecond
.)


; a=0/1 for color set	
_ShowPictureBlueGalaxies
.(
	pha
	lda #<_LabelPictureSylviaAnderson
	ldx #>_LabelPictureSylviaAnderson
	jsr _FileUnpackToBuffer	
	
	jsr _FlipToScreen
	pla

	beq default_colors
	jsr SetAlternateRGB
	jmp end
default_colors	
	jsr SetDefaultRGB
end	
	; Forces the second set of colors, reusing the previous value in tmp0
	lda #17
	sta _X
	
	lda #81
	sta _Y
	
	lda #35
	sta _H
	
	jsr _SetColorBand
	
	; Forces the third set of colors, reusing the previous value in tmp0
	lda #29
	sta _X
	
	lda #114
	sta _Y
	
	lda #35
	sta _H
	
	jsr _SetColorBand

	; Forces the fourth set of colors, reusing the previous value in tmp0
	lda #33
	sta _X
	
	lda #147
	sta _Y
	
	lda #35
	sta _H
	
	jsr _SetColorBand
		
	rts
.)


; a=0/1 for color set	
_ShowPictureCrescentMoon
	pha 
	lda #<_LabelPictureBarryMorse
	ldx #>_LabelPictureBarryMorse
	jsr _FileUnpackToBuffer	
	
	jsr _FlipToScreen
	pla
	bne SetAlternateRGB
	jmp SetDefaultRGB
	
; a=0/1 for color set	
_ShowPictureDoublePlanet
	pha 
	lda #<_LabelPictureProducer
	ldx #>_LabelPictureProducer
	jsr _FileUnpackToBuffer
	
	jsr _FlipToScreen
	pla
	bne SetAlternateRGB
	jmp SetDefaultRGB
	
SetDefaultRGB	
	lda #<_ColorInkDefaultRGB
	ldx #>_ColorInkDefaultRGB
	jmp _SetPaperColor

SetAlternateRGB	
	lda #<_ColorInkAlternateRGB
	ldx #>_ColorInkAlternateRGB
	jmp _SetPaperColor

	
_SequenceBarryMorse
	lda #0
	jsr _ShowPictureCrescentMoon

	lda #<_ColorsCrescentMoon
	ldx #>_ColorsCrescentMoon
	jsr _ColorsFadeInit
		
	jsr _UnpackFont
	
	lda #<_Message_StarringBarryMorse
	ldx #>_Message_StarringBarryMorse
	jmp _DrawTextAndFadeInAndOut

	
_SequenceChema
	lda #1
	jsr _ShowPictureCrescentMoon
	
	lda #<_ColorsCrescentMoon
	ldx #>_ColorsCrescentMoon
	jsr _ColorsFadeInit
		
	jsr _UnpackFont
		
	lda #<_Message_Chema
	ldx #>_Message_Chema
	jmp _DrawTextAndFadeInAndOut
	
	
_SequenceDbug
	lda #1
	jsr _ShowPictureDoublePlanet
	
	lda #<_ColorsDoublePlanet
	ldx #>_ColorsDoublePlanet
	jsr _ColorsFadeInit
	
	jsr _UnpackFont
	
	lda #<_Message_Dbug
	ldx #>_Message_Dbug	
	jsr _DrawTextAndFadeInAndOut

	ldx #1
	jsr _WaitSecond
		
	rts
	

	
_SequenceGerryAnderson
	lda #0
	jsr _ShowPictureDoublePlanet

	lda #<_ColorsDoublePlanet
	ldx #>_ColorsDoublePlanet
	jsr _ColorsFadeInit
		
	jsr _UnpackFont
	
	lda #<_Message_GerryAnderson
	ldx #>_Message_GerryAnderson
	jmp _DrawTextAndFadeInAndOut
	
	
_DrawTextAndFadeInAndOut
	jsr _DrawTextAsm
qsdqsd
	;jmp qsdqsd	
	jsr _ColorsFadeDo	; Blue Ink
	jsr _WaitTenFrames
	jsr _ColorsFadeDo	; Cyan Ink	
	jsr _WaitTenFrames
	jsr _ColorsFadeDo	; White Ink
	ldx #3
	jsr _WaitSecond
	jsr _ColorsFadeDo	; Yellow Ink	
	jsr _WaitTenFrames
	jsr _ColorsFadeDo	; Red Ink
	jsr _WaitTenFrames
	jsr _ColorsFadeDo	; Blue Ink
	jsr _WaitTenFrames
	jsr _ColorsFadeDo	; Black Ink
	jmp _BlackScreen	

_FadeInOrOut
	jsr _ColorsFadeDo	; Blue Ink
	jsr _WaitTenFrames
	jsr _ColorsFadeDo	; Cyan Ink	
	jsr _WaitTenFrames
	jsr _ColorsFadeDo	; White Ink
	rts	

_SequenceTwilighte
	lda #1
	jsr _ShowPictureBlueGalaxies
		
	lda #<_ColorsTwilighte
	ldx #>_ColorsTwilighte
	jsr _ColorsFadeInit
	
	jsr _UnpackFont
	
	lda #<_Message_Music
	ldx #>_Message_Music
	jsr _DrawTextAsm

	lda #<_Message_Twilighte
	ldx #>_Message_Twilighte
	jmp _DrawTextAndFadeInAndOut

	
_SequenceEndMessage
	jsr _BlackScreen
	
	jsr _UnpackFont
	
	lda #<_Message_Title
	ldx #>_Message_Title
	jsr _DrawTextAsm
	
	ldx #1
	jsr _WaitSecond

	lda #<_Message_Exclusive
	ldx #>_Message_Exclusive
	jsr _DrawTextAsm
	
	ldx #1
	jsr _WaitSecond

	lda #<_Message_Website
	ldx #>_Message_Website
	jsr _DrawTextAsm
		
	ldx #5
	jmp _WaitSecond

	
_RectangleThisEpisode	.byt <_BufferUnpack,>_BufferUnpack,<$a000+(40*81)+3,>$a000+(40*81)+3,33,37
_RectangleSeptember		.byt <_BufferUnpack+(40*37),>_BufferUnpack+(40*37),<$a000+(40*81)+3,>$a000+(40*81)+3,33,44
_Rectangle13th			.byt <_BufferUnpack+(40*81),>_BufferUnpack+(40*81),<$a000+(40*65)+6,>$a000+(40*65)+6,28,70

_Rectangle1999_1		.byt <_BufferUnpack+(40*81),>_BufferUnpack+(40*81),<$a000+(40*65)+3,>$a000+(40*65)+3,6,70
_Rectangle1999_2		.byt <_BufferUnpack+(40*81)+29,>_BufferUnpack+(40*81)+29,<$a000+(40*65)+9,>$a000+(40*65)+9,9,70
_Rectangle1999_3		.byt <_BufferUnpack+(40*81)+29,>_BufferUnpack+(40*81)+29,<$a000+(40*65)+18,>$a000+(40*65)+18,9,70
_Rectangle1999_4		.byt <_BufferUnpack+(40*81)+29,>_BufferUnpack+(40*81)+29,<$a000+(40*65)+27,>$a000+(40*65)+27,9,70

_RectangleMoonBase		.byt <_BufferUnpack+(40*89)+1,>_BufferUnpack+(40*89)+1,<$a000+(40*89)+1,>$a000+(40*89)+1,39,111

_RectangleMoonBaseLogo	.byt <_BufferUnpack,>_BufferUnpack,<$a000+(40*10)+12,>$a000+(40*10)+12,16,53

_SequenceThisEpisode
	jsr _BlackScreen
	lda #<_LabelPictureEpisode
	ldx #>_LabelPictureEpisode
	jsr _FileUnpackToBuffer
	jsr _SetInkBlack
		
	lda #<_RectangleThisEpisode
	ldx #>_RectangleThisEpisode
	jsr _CopyRectangle
	
	jsr _SetInkYellow
	
	ldx #1
	jsr _WaitSecond

	jmp _SetInkBlack

	
_Sequence13September1999
	jsr _BlackScreen
	
	lda #<_LabelPictureEpisode
	ldx #>_LabelPictureEpisode
	jsr _FileUnpackToBuffer
	
	jsr _SetInkBlack	
	lda #<_RectangleSeptember
	ldx #>_RectangleSeptember
	jsr _CopyRectangle	
	jsr _SetInkYellow
	
	ldx #1
	jsr _WaitSecond

	jsr _SetInkBlack
	jsr _BlackScreen
	jsr _SetInkBlack
	lda #<_Rectangle13th
	ldx #>_Rectangle13th
	jsr _CopyRectangle
	jsr _SetInkYellow
	
	ldx #1
	jsr _WaitSecond

	jsr _SetInkBlack
	jsr _BlackScreen
	jsr _SetInkBlack
	lda #<_Rectangle1999_1
	ldx #>_Rectangle1999_1
	jsr _CopyRectangle
	lda #<_Rectangle1999_2
	ldx #>_Rectangle1999_2
	jsr _CopyRectangle
	lda #<_Rectangle1999_3
	ldx #>_Rectangle1999_3
	jsr _CopyRectangle
	lda #<_Rectangle1999_4
	ldx #>_Rectangle1999_4
	jsr _CopyRectangle
	jsr _SetInkYellow
	
	ldx #1
	jsr _WaitSecond

	jmp _SetInkBlack

	
_SequenceQuotes
	jsr _BlackScreen
	jsr _UnpackFont
	
	; Force all ink back
	lda #<_ColorInkBlack
	ldx #>_ColorInkBlack
	jsr _SetPaperColor
			
	; Display all the texts
	lda #<_Message_Quote1
	ldx #>_Message_Quote1
	jsr _DrawTextAsm

	lda #<_Message_Quote2
	ldx #>_Message_Quote2
	jsr _DrawTextAsm	

	lda #<_Message_Quote3
	ldx #>_Message_Quote3
	jsr _DrawTextAsm	

	lda #<_Message_Quote4
	ldx #>_Message_Quote4
	jsr _DrawTextAsm	

	; Fade in all the texts one by one				
	lda #<_ColorsQuote1
	ldx #>_ColorsQuote1
	jsr _ColorsFadeInit
	jsr _FadeInOrOut
		
	ldx #3
	jsr _WaitSecond

	lda #<_ColorsQuote2
	ldx #>_ColorsQuote2
	jsr _ColorsFadeInit
	jsr _FadeInOrOut
			
	ldx #3
	jsr _WaitSecond

	lda #<_ColorsQuote3
	ldx #>_ColorsQuote3
	jsr _ColorsFadeInit
	jsr _FadeInOrOut
	
	ldx #5
	jsr _WaitSecond

	lda #<_ColorsQuote4
	ldx #>_ColorsQuote4
	jsr _ColorsFadeInit
	jsr _FadeInOrOut		
		
	ldx #2+3
	jsr _WaitSecond
	
	lda #<_ColorsQuoteAll
	ldx #>_ColorsQuoteAll
	jsr _ColorsFadeInit
	jsr _FadeInOrOut		
	
	jmp _BlackScreen	


_SequenceBarbaraBain
	lda #<_LabelPictureBarbaraBain
	ldx #>_LabelPictureBarbaraBain
	jsr _FileUnpackToBuffer
	
	jsr _FlipToScreen
	
	jsr SetDefaultRGB	
	
	lda #<_ColorsBarbaraBain
	ldx #>_ColorsBarbaraBain
	jsr _ColorsFadeInit
	
	jsr _UnpackFont
	
	lda #<_Message_StarringBarbaraBain
	ldx #>_Message_StarringBarbaraBain
	jmp _DrawTextAndFadeInAndOut
	

	
/*	
void MoonExplodes()
{
	BoomColorBase=0;

	// Glow	
	while (BoomColorBase<40)
	{
		memcpy(BoomColorMinus16+10+BoomColorBase,GlowColor,6);
		DrawNuclearBoom();
		BoomColorBase++;
	}

	// Deglow
	while (BoomColorBase>0)
	{
		BoomColorBase--;
		memcpy(BoomColorMinus16+10+BoomColorBase,GlowColor,6);
		DrawNuclearBoom();
	}
}
extern unsigned char GlowColor[6];
extern unsigned char BoomColorMinus16[37+16];

*/	

; x=table offset
_MoonExplodeUpdateGlow
	lda _GlowColor+0
	sta _BoomColorMinus16+10,x
	lda _GlowColor+1
	sta _BoomColorMinus16+11,x
	lda _GlowColor+2
	sta _BoomColorMinus16+12,x
	lda _GlowColor+3
	sta _BoomColorMinus16+13,x
	lda _GlowColor+4
	sta _BoomColorMinus16+14,x
	lda _GlowColor+5
	sta _BoomColorMinus16+15,x
	
	jsr _DrawNuclearBoom
	rts

_MoonExplodeGlow
.(
loop
	ldx _BoomColorBase
	cpx #40
	beq exit
	jsr _MoonExplodeUpdateGlow
	inc _BoomColorBase
	jmp loop
exit
	rts
.)	
	
_MoonExplodeDeGlow
.(
loop
	ldx _BoomColorBase
	beq exit

	dex
	stx _BoomColorBase		
	jsr _MoonExplodeUpdateGlow
	jmp loop
exit
	rts
.)	


_SequenceMoonExplodes	
	jsr _BlackScreen

	lda #<_LabelPictureLogo
	ldx #>_LabelPictureLogo
	jsr _FileUnpackToBuffer
		
	lda #<_RectangleMoonBase
	ldx #>_RectangleMoonBase
	jsr _CopyRectangle	

	jsr _GenerateSquareTables

	jsr _CreateHalfDisc
	jsr _MirrorTheDisc
	jsr _FilterTheDisc1
	jsr _FilterTheDisc2
	
	lda #0
	sta _BoomColorBase
	jsr _MoonExplodeGlow
	jsr _MoonExplodeDeGlow
	
	;jsr _MoonExplodes
	jsr _MoonScrollsDown
	rts	

	
_SequenceEmergency
	jsr _BlackScreen
	
	lda #<_LabelPictureMisc
	ldx #>_LabelPictureMisc
	jsr _FileUnpackToBuffer
	
	lda #<_RectangleMoonBaseLogo
	ldx #>_RectangleMoonBaseLogo
	jsr _CopyRectangle
	
	lda #<_ColorPaperDarkBlue
	ldx #>_ColorPaperDarkBlue
	jsr _SetPaperColor

	lda #<_ColorInkCyan
	ldx #>_ColorInkCyan
	jsr _SetInkColor
			
	jsr _UnpackFont
	
	lda #<_Message_EmergencyRedAlert
	ldx #>_Message_EmergencyRedAlert

	jsr _DrawTextAsm

	lda #<_ColorInkCyan
	ldx #>_ColorInkCyan
	jsr _SetInkColor

	ldx #1
	jsr _WaitSecond
	
	lda #<_ColorInkOrange
	ldx #>_ColorInkOrange
	jsr _SetInkColor
		
	ldx #1
	jsr _WaitSecond
		
	lda #<_ColorInkCyan
	ldx #>_ColorInkCyan
	jsr _SetInkColor

	ldx #1
	jsr _WaitSecond
	
	lda #<_ColorInkOrange
	ldx #>_ColorInkOrange
	jsr _SetInkColor
		
	ldx #1
	jsr _WaitSecond
	
	jsr _BlackScreen
	;ldx #15
	;jsr _WaitSecond
	rts


	