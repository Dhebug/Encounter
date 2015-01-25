

	.zero

OldByte		.dsb 1
ShiftCount	.dsb 1

_xpos		.dsb 1
_xdir		.dsb 1

_ypos		.dsb 1
_ydir		.dsb 1

_BigAngle	.dsb 1

	
	.text
	
IncTmp0
	clc 
	lda tmp0+0
	adc #1
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1
	rts

Add40Tmp1
.(	
	clc
	lda tmp1
	adc #40
	sta tmp1
	bcc skip_dst
	inc tmp1+1
skip_dst
	rts
.)


DefenceForceMelonStyle
	.byt 10,"Defence"		; Force"
	.byt "F"+128
	.byt "o"+128
	.byt "r"+128
	.byt "c"+128
	.byt "e"+128
	.byt "."
DefenceForceMelonStyleEnd

_DrawDefenceForceLogo
.(
	ldx #DefenceForceMelonStyleEnd-DefenceForceMelonStyle
loop	
	lda DefenceForceMelonStyle-1,x
	;eor #128
	sta $bb80+27*40-(DefenceForceMelonStyleEnd-DefenceForceMelonStyle)-1,x
	sta $bb80+28*40-(DefenceForceMelonStyleEnd-DefenceForceMelonStyle)-1,x
	dex
	bne loop
	rts
.)


_ColorTable
	.byt 4
	.byt 6
	.byt 4
	.byt 4
	.byt 4
	.byt 4
	.byt 1
	.byt 4
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 1
	.byt 3
	.byt 1
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 7
	.byt 3
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 6
	.byt 7
	.byt 6
	.byt 6
	.byt 6
	.byt 6


_FadeToBlackBetweenRasters
.(
	lda #<$a000+55*40
	sta tmp1+0
	lda #>$a000+55*40
	sta tmp1+1

	ldx #142
loop_y
	lda #64

	ldy #39
loop_x
	sta (tmp1),y
	dey 
	bpl loop_x

	jsr Add40Tmp1

	dex
	bne loop_y		

	rts
.)


_EraseHalfScreen
	lda #<$a000+55*40
	sta tmp1+0
	lda #>$a000+55*40
	sta tmp1+1

	ldx #142
	jmp DoErase

_EraseScreen
	lda #<$a000+1
	sta tmp1+0
	lda #>$a000+1
	sta tmp1+1

	ldx #200
DoErase
.(
loop_y
	ldy #1
loop_x
	lda #64
	sta (tmp1),y
	iny 
	cpy #40
	bne loop_x

	jsr Add40Tmp1

	dex
	bne loop_y		
	rts
.)


_DisplayLogoSize	.byt 1

_ScaleCounter		.byt 0

_DisplayMusicLogoStretch
	lda #<_LogoBuffer_MUsic
	sta tmp0+0
	lda #>_LogoBuffer_MUsic
	sta tmp0+1
.(	
	sec
	lda #100+50
	sbc _DisplayLogoSize
	tax

	;ldx #70
	clc
	lda _ScreenAddrLow,x
	adc #10
	sta tmp1+0
	lda _ScreenAddrHigh,x
	adc #0
	sta tmp1+1

	lda #0
	sta _ScaleCounter

	.(
	ldx #10
loop_clear	
	; Black line on top
	ldy #0
	lda #64
loop_x
	sta (tmp1),y
	iny 
	cpy #20
	bne loop_x
	jsr Add40Tmp1
	dex
	bne loop_clear
	.)

	.(
	; Rescale logo 
	ldx _DisplayLogoSize
loop_y
	ldy #0
loop_x
	lda (tmp0),y
	sta (tmp1),y
	iny 
	cpy #20
	bne loop_x

loop_scale_add
	clc
	lda tmp0
	adc #20
	sta tmp0
	bcc skip_src
	inc tmp0+1
	clc
skip_src

	clc
	lda _ScaleCounter
	adc _DisplayLogoSize
	sta _ScaleCounter

	cmp #100
	bcc loop_scale_add

	sec
	lda _ScaleCounter
	sbc #100
	sta _ScaleCounter


	jsr Add40Tmp1

	dex
	bne loop_y	
	.)

	.(
	; Black line on bottom
	ldy #0
	lda #64
loop_x
	sta (tmp1),y
	iny 
	cpy #20
	bne loop_x
	jsr Add40Tmp1
	.)
	rts	
.)


_DisplayMusicLogo
	lda #<_LogoBuffer_MUsic
	sta tmp0+0
	lda #>_LogoBuffer_MUsic
	sta tmp0+1
	jmp DisplayLogoCommon

_DisplayHeadLogo
	lda #<_LogoBuffer_Headed
	sta tmp0+0
	lda #>_LogoBuffer_Headed
	sta tmp0+1
	jmp DisplayLogoCommon

_DisplayFireLogo
	lda #<_LogoBuffer_Fire
	sta tmp0+0
	lda #>_LogoBuffer_Fire
	sta tmp0+1
	jmp DisplayLogoCommon

DisplayLogoCommon
.(	
	lda #<$a000+10+40*70
	sta tmp1+0
	lda #>$a000+10+40*70
	sta tmp1+1

	ldx #100
loop_y
	ldy #0
loop_x
	lda (tmp0),y
	sta (tmp1),y
	iny 
	cpy #20
	bne loop_x

	clc
	lda tmp0
	adc #20
	sta tmp0
	bcc skip_src
	inc tmp0+1
	clc
skip_src

	jsr Add40Tmp1

	dex
	bne loop_y	
	rts	
.)


DisplayMakeShiftedLogo
.(	
	ldx #100
loop_y
	lda #0
	sta OldByte
	ldy #0
loop_x
	lda (tmp0),y
	pha
	and #63
	lsr 
	ora	OldByte
	ora #64
	sta (tmp1),y

	pla
	and #1
	asl
	asl
	asl
	asl
	asl
	sta OldByte

	iny 
	cpy #20
	bne loop_x

	ldy #0
	lda (tmp0),y
	and #63
	lsr 
	ora	OldByte
	ora #64
	sta (tmp1),y

	clc
	lda tmp0
	adc #24
	sta tmp0
	bcc skip_src
	inc tmp0+1
	clc
skip_src

	lda tmp1
	adc #24
	sta tmp1
	bcc skip_dst
	inc tmp1+1
skip_dst

	dex
	bne loop_y
	rts
.)




; From _LogoBuffer
; To   _ShiftedLogo
; Size: 20 bytes * 100 lines
_PreshiftSprite
.(
	lda #<_LogoBuffer
	sta tmp0+0
	lda #>_LogoBuffer
	sta tmp0+1

	lda #<_ShiftedLogo
	sta tmp1+0
	lda #>_ShiftedLogo
	sta tmp1+1

	ldx #100
loop_y

	; Copy the current scanline to the first line of the preshift buffer
	ldy #0
loop_x
	lda (tmp0),y
	sta (tmp1),y
	iny 
	cpy #20
	bne loop_x

	lda #6
	sta ShiftCount
loop_shift_count	
	; Then shift this first entry to the second line of the preshift buffer
	; tmp1=current line
	; tmp2=second line
	clc
	lda tmp1+0
	adc #20
	sta tmp2+0 
	lda tmp1+1
	adc #0
	sta tmp2+1 

	lda #0
	sta OldByte
	ldy #0
loop_shift_x
	lda (tmp1),y
	pha
	and #63
	lsr 
	ora	OldByte
	ora #64
	sta (tmp2),y

	pla
	and #1
	asl
	asl
	asl
	asl
	asl
	sta OldByte

	iny 
	cpy #20
	bne loop_shift_x

	ldy #0
	lda (tmp1),y
	and #63
	lsr 
	ora	OldByte
	ora #64
	sta (tmp2),y

	lda tmp2+0
	sta tmp1+0
	lda tmp2+1
	sta tmp1+1

	dec ShiftCount
	bne loop_shift_count


	; Get the next line of the logo
	clc
	lda tmp0+0
	adc #20
	sta tmp0+0 
	lda tmp0+1
	adc #0
	sta tmp0+1 

	dex
	bne loop_y

	rts
.)




; From _LogoBuffer
; To   _ShiftedLogo
; Size: 20 bytes * 100 lines
_PreshiftSprite_WorkingSimpleCopy
.(
	lda #<_LogoBuffer
	sta tmp0+0
	lda #>_LogoBuffer
	sta tmp0+1

	lda #<_ShiftedLogo
	sta tmp1+0
	lda #>_ShiftedLogo
	sta tmp1+1

	ldx #100
loop_y

	ldy #0
loop_x
	lda (tmp0),y
	sta (tmp1),y

	iny 
	cpy #20
	bne loop_x

	clc
	lda tmp0+0
	adc #20
	sta tmp0+0 
	lda tmp0+1
	adc #0
	sta tmp0+1 

	clc
	lda tmp1+0
	adc #20*6
	sta tmp1+0 
	lda tmp1+1
	adc #0
	sta tmp1+1 

	dex
	bne loop_y

	rts
.)


CrossWordCount	.byt 0
CrossWordXPos	.byt 0
CrossWordYPos	.byt 0
CrossWordDirection	.byt 0

DisplayCrossWord
	;jmp DisplayHorizontalWord
.(
	lda #<$a000+40*57
	sta tmp1+0
	lda #>$a000+40*57
	sta tmp1+1

	ldy #0
	lda (tmp0),y
	sta CrossWordXPos
	iny 
	lda (tmp0),y
	sta CrossWordYPos

	; Add xpos
	clc 
	lda tmp1+0
	adc CrossWordXPos
	sta tmp1+0
	lda tmp1+1
	adc #0
	sta tmp1+1

	; Add ypos
loop_y_inc	
	dec CrossWordYPos
	bmi end_y_inc
	clc 
	lda tmp1+0
	adc #40*6
	sta tmp1+0
	lda tmp1+1
	adc #0
	sta tmp1+1
	jmp loop_y_inc
end_y_inc

	clc 
	lda tmp0+0
	adc #2
	sta tmp0+0
	lda tmp0+1
	adc #0
	sta tmp0+1

	ldy #0
loop_car
	; Get ASCII value
	lda (tmp0),y
	beq done

	; The font starts at the space character, and is stored per scanline (96 bytes wide)
	clc
	adc #<_Font6x6-32
	sta tmp2+0
	lda #0
	adc #>_Font6x6-32
	sta tmp2+1

	lda CrossWordDirection
	bne vertical_move
horizontal_move	
	clc
	lda tmp1+0
	sta tmp3+0
	adc #1
	sta tmp1+0
	lda tmp1+1
	sta tmp3+1
	adc #0
	sta tmp1+1
	jmp draw_char
vertical_move
	clc
	lda tmp1+0
	sta tmp3+0
	adc #40*6
	sta tmp1+0
	lda tmp1+1
	sta tmp3+1
	adc #0
	sta tmp1+1
	jmp draw_char

draw_char
	ldy #0
	ldx #6
loop_y
	lda (tmp2),y
	eor #128
	sta (tmp3),y

	clc 
	lda tmp2+0
	adc #96
	sta tmp2+0
	lda tmp2+1
	adc #0
	sta tmp2+1

	clc 
	lda tmp3+0
	adc #40
	sta tmp3+0
	lda tmp3+1
	adc #0
	sta tmp3+1

	dex
	bne loop_y

	;jsr _VSync
	jsr _VSync
	jsr _VSync

	jsr IncTmp0

	jmp loop_car
done
	jsr IncTmp0
	rts
.)



_DrawCrossWords
.(
	lda #<CrossWordsHorizontal
	sta tmp0+0
	lda #>CrossWordsHorizontal
	sta tmp0+1

	lda #0
	sta CrossWordDirection

	lda #16
	sta CrossWordCount
loop_horizontal	
	jsr DisplayCrossWord	
	dec CrossWordCount
	bne loop_horizontal

	lda #1
	sta CrossWordDirection

	lda #18
	sta CrossWordCount
loop_vertical
	jsr DisplayCrossWord	
	dec CrossWordCount
	bne loop_vertical

	rts
.)


CrossWordsHorizontal
	.BYT 8,10,"APANBEPAN",0
	.BYT 24,20,"#ATARI(FR|SCNE)",0
	.BYT 20,16,"BOOZEDESIGN",0
	.BYT 23,22,"CENSORDESIGN",0
	.BYT 12,19,"CYG^BLABLA",0
	.BYT 22,18,"HOAXERS",0
	.BYT 30,4,"EXCESS",0
	.BYT 2,16,"KVASIGEN",0
	.BYT 17,4,"LOONIES",0
	.BYT 3,8,"NOSFE",0
	.BYT 1,13,"OFENCE",0
	.BYT 15,6,"OUTRACKS",0
	.BYT 21,1,"PENUMBRA",0
	.BYT 16,12,"PLAYPSYCHO",0
	.BYT 27,14,"YOUTHUPRISING",0
	.BYT 28,6,"TUFS",0

CrossWordsVertical
	.BYT 32,9,"BAUDSURFER^RSI",0
	.BYT 28,8,"BOOZOHOLICS",0
	.BYT 4,11,"CONTRAZ",0
	.BYT 16,8,"CONSPIRACY",0
	.BYT 24,5,"DARKLIGHT",0
	.BYT 13,9,"DEADROMAN",0
	.BYT 34,8,"KEYBOARDERS",0
	.BYT 9,9,"EPHIDRENA",0
	.BYT 30,6,"FAIRLIGHT",0
	.BYT 6,8,"FNUQUE",0
	.BYT 37,9,"GENESISPROJECT",0
	.BYT 35,2,"INSANE",0
	.BYT 22,0,"KEWLERS",0
	.BYT 3,3,"OXYRON",0
	.BYT 11,8,"PANDACUBE",0
	.BYT 18,6,"RESISTANCE",0
	.BYT 20,11,"SPACEBALLS",0
	.BYT 39,5,"WRATHDESIGN",0

	.byt 0,0,"A",0
	.byt 0,0,"A",0
	.byt 0,0,"A",0
	.byt 0,0,"A",0


	.byt "Twilighte",0
	.byt "Chema",0
	.BYT 21,2,"PWP",0


LogoFrameCounter	.byt 0
LogoHeight			.byt 0
LogoWidth			.byt 0



_ShowSmallDefenceForce
	lda #<_PictureLoadingBuffer+20*100
	sta tmp0+0
	lda #>_PictureLoadingBuffer+20*100
	sta tmp0+1

	lda #<$a000+(52+22)*40+10
	sta tmp1+0
	lda #>$a000+(52+22)*40+10
	sta tmp1+1

	lda #20
	sta LogoWidth

	lda #100
	sta LogoHeight

	jmp ShowDefenceForce

_ShowLargeDefenceForce
.(
	lda #<_PictureLoadingBuffer
	sta tmp0+0
	lda #>_PictureLoadingBuffer
	sta tmp0+1

	lda #<$a000
	sta tmp1+0
	lda #>$a000
	sta tmp1+1

	lda #40
	sta LogoWidth

	lda #200
	sta LogoHeight

+ShowDefenceForce
	ldx LogoHeight
loop_y
	ldy #0
loop_x
	lda (tmp0),y
	sta (tmp1),y
	iny
	cpy LogoWidth
	bne loop_x

	cpx #0
	beq end_blue
	cpx #1
	beq end_cyan
	cpx #2
	beq end_white

	lda #16+7
	ldy #40*3
	sta (tmp1),y
end_white

	lda #16+6
	ldy #40*2
	sta (tmp1),y
end_cyan

	lda #16+4
	ldy #40*1
	sta (tmp1),y
end_blue

	clc
	lda tmp0
	adc LogoWidth
	sta tmp0
	bcc skip_src
	inc tmp0+1
skip_src

	jsr Add40Tmp1

	jsr _VSync

	dex
	bne loop_y

	rts
.)



_ShowTinyKindergardenLogo
	lda #<_PictureLoadBuffer60x50+10*151
	sta tmp3+0
	lda #>_PictureLoadBuffer60x50+10*151
	sta tmp3+1



	lda #<$a000+(52+22+38+13)*40+10+5
	sta tmp2+0
	lda #>$a000+(52+22+38+13)*40+10+5
	sta tmp2+1

	lda #10
	sta LogoWidth

	lda #13
	sta LogoHeight

	jmp ShowKindergardenLogo

_ShowSmallKindergardenLogo
	lda #<_PictureLoadingBuffer+20*271
	sta tmp3+0
	lda #>_PictureLoadingBuffer+20*271
	sta tmp3+1

	lda #<$a000+40*(100)+10
	sta tmp2+0
	lda #>$a000+40*(100)+10
	sta tmp2+1

	lda #20
	sta LogoWidth

	lda #26
	sta LogoHeight

	jmp ShowKindergardenLogo

_ShowLargeKindergardenLogo
	;jmp _ShowKindergardenLogo
.(
	lda #<_PictureLoadingBuffer
	sta tmp3+0
	lda #>_PictureLoadingBuffer
	sta tmp3+1

	lda #<$a000+40*52
	sta tmp2+0
	lda #>$a000+40*52
	sta tmp2+1

	lda #40
	sta LogoWidth

	lda #53
	sta LogoHeight

+ShowKindergardenLogo
	ldx #1
loop_frame
	stx LogoFrameCounter

	sec
	lda tmp2+0
	sbc #40
	sta tmp1+0
	sta tmp2+0
	lda tmp2+1
	sbc #0
	sta tmp1+1
	sta tmp2+1

	lda tmp3+0
	sta tmp0+0
	lda tmp3+1
	sta tmp0+1

loop_y
	ldy #0
loop_x
	lda (tmp0),y
	sta (tmp1),y
	iny
	cpy LogoWidth
	bne loop_x

	clc
	lda tmp0
	adc LogoWidth
	sta tmp0
	bcc skip_src
	inc tmp0+1
skip_src

	jsr Add40Tmp1

	dex
	bne loop_y

	jsr _VSync

	ldx LogoFrameCounter
	inx
	cpx LogoHeight
	bne loop_frame

	rts
.)



_HideLargeKindergardenLogo
	;jmp _HideLargeKindergardenLogo
.(
	lda #53
	sta LogoFrameCounter

loop_frame
	lda #<$a000+40*52
	sta tmp0+0
	lda #>$a000+40*52
	sta tmp0+1

	ldx #52
loop_y

	sec
	lda tmp0+0
	sta tmp1+0
	sbc #40
	sta tmp0+0

	lda tmp0+1
	sta tmp1+1
	sbc #0
	sta tmp0+1

	ldy #0
loop_x
	lda (tmp0),y
	sta (tmp1),y
	iny
	cpy #40
	bne loop_x

	dex
	bne loop_y

	jsr _VSync

	dec LogoFrameCounter
	bne loop_frame

	rts
.)



_PatchAttributesBirthdayCake
.(
	; column 22, row 1, 31 high
	lda #<_PictureLoadingBuffer+(40*1)
	sta tmp1+0
	lda #>_PictureLoadingBuffer+(40*1)
	sta tmp1+1

	ldx #31
loop	
	lda #64
	ldy #22
	sta (tmp1),y

	jsr Add40Tmp1

	dex
	bne loop
	rts
.)


_BadeStampColors
	.byt 7
	.byt 7
	.byt 6
	.byt 7
	.byt 6
	.byt 6
	.byt 2
	.byt 6
	.byt 2
	.byt 2
	.byt 5
	.byt 2
	.byt 5
	.byt 5
	.byt 2
	.byt 5
	.byt 2
	.byt 2
	.byt 6
	.byt 2
	.byt 6
	.byt 6
	.byt 7
	.byt 6
	.byt 6
	.byt 7
	.byt 7
	.byt 6
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 3
	.byt 7
	.byt 7
	.byt 3
	.byt 7
	.byt 3
	.byt 3
	.byt 7
	.byt 7
	.byt 3
	.byt 3
	.byt 3
	.byt 3
	.byt 7
	.byt 3
	.byt 3
	.byt 7
	.byt 3
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7
	.byt 7



