
	.zero

_PrintScreenX       .dsb 1
_PrintScreenColor   .dsb 1

_PrintHiresX       .dsb 1
_PrintHiresColor   .dsb 1

_PrintMessagePtr	.dsb 2      ; The address of the message to display

	.text

_PrintSelectedText
.(
	ldy #255
loop_line
	jsr _ScrollUpText
	ldx _PrintScreenX
	lda _PrintScreenColor
	jmp printOut
loop_name
    iny
	lda (_PrintMessagePtr),y
	beq end_name
	cmp #13
	bne printOut
    ; Carriage return
    jmp loop_line
printOut	
	sta $BB80+40*27,x

	inx
	cpx #38
	bne loop_name	
	ldx #0
	jmp loop_line
end_name
    stx _PrintScreenX
	rts
.)


#define SCROLLUP(ypos)  lda $bb80+40*(ypos+1),x:sta $bb80+40*ypos,x


; 40*28=1120 bytes
_ScrollUpText
    ;jmp _ScrollUpText
.(
	pha
	txa
	pha

	ldx #0
loop
	SCROLLUP(25)
	SCROLLUP(26)

	lda #32
	sta $bb80+40*27,x
	inx
	cpx #40
	beq end
	jmp loop
end	
	pla 
	tax 
	pla
	rts
.)

_EraseTextArea
.(
	ldx #0
loop
	lda #32
	sta $bb80+40*25,x
	inx 
	cpx #40*3
	bne loop	
	rts
.)

; _Font6x6
saveY  .byt 0

_PrintTextHiresNoScroll
	ldy #255
	jmp do_print

_PrintTextHires
.(
	ldy #255
loop_line
	jsr _ScrollUpHires
+do_print	
	ldx _PrintHiresX
	lda _PrintHiresColor
	jmp printOut
loop_name
    iny
	lda (_PrintMessagePtr),y
	beq end_name
	cmp #13
	bne printOut
    ; Carriage return
    jmp loop_line
printOut	
	sty saveY
	tay
    lda _Font6x6+256*0,y
	sta $a000+40*6*32+40*0,x

    lda _Font6x6+256*1,y
	sta $a000+40*6*32+40*1,x

    lda _Font6x6+256*2,y
	sta $a000+40*6*32+40*2,x

    lda _Font6x6+256*3,y
	sta $a000+40*6*32+40*3,x

    lda _Font6x6+256*4,y
	sta $a000+40*6*32+40*4,x

    lda _Font6x6+256*5,y
	sta $a000+40*6*32+40*5,x

	ldy saveY

	inx
	cpx #40
	bne loop_name	
	ldx #0
	jmp loop_line
end_name
    stx _PrintHiresX
	rts
.)



_PatchFont
.(
	ldx #0
loop_code	
	txa
	sta _Font6x6+256*0,x
	sta _Font6x6+256*1,x
	sta _Font6x6+256*2,x
	sta _Font6x6+256*3,x
	sta _Font6x6+256*4,x
	sta _Font6x6+256*5,x
	inx
	cpx #32
	bne loop_code
	rts
.)

; 40*28=1120 bytes
; We scroll the hires screen by 6 scanlines

_ScrollUpHires
    ;jmp _ScrollUpHires
.(
	pha
	txa
	pha
	tya
	pha

	lda #<$a000
	sta tmp1+0
	lda #>$a000
	sta tmp1+1

	lda #<$a000+40*6
	sta tmp2+0
	lda #>$a000+40*6
	sta tmp2+1

	ldx #32   ; 33*6=198
loop_y
	ldy #0
loop_x
	lda (tmp2),y
	sta (tmp1),y
	iny
	cpy #240
	bne loop_x

	jsr Add240Tmp1
	jsr Add240Tmp2

	dex
	bne loop_y

	; Clean the last line
	ldy #0
loop_x_clean
	lda #64
	sta (tmp1),y
	iny
	cpy #40*6
	bne loop_x_clean

	pla 
	tay
	pla 
	tax 
	pla
;bla jmp bla	
	rts
.)


; Let's have the messages of the game:


_MessageWelcomeToTelegraphHero
	.byt 13,7,"Welcome to Telegraph Hero",13,13
	.byt 7,"Please wait",13
	.byt 0


_MessageMorseCodeLetter
	.byt 13,7,16+4,"Morse code for '"
_MessageMorse_PATCH_character	
	.byt "?"                     // This '?' get patched with the actual value of the letter/character to display
	.byt "' is "
_MessageMorse_PATCH_code
	.byt "?"                     // This series of '?' will be patched with dots and dashes representing the morse code value
	.byt "?"
	.byt "?"
	.byt "?"
	.byt "?"
	.byt "?"
	.byt 0

_ArrayDashOrDot
    .byt "."
    .byt "-"



; What would I do
_MessagePlayerChoice	.byt 1,12,16+7,"What would Mickael do? ",16+0,0

_MessageBadChoice
	.byt 13,5,"That was not very logical!",13
	.byt 5,"I'm probably still sleeping...",13
	.byt 5,"Another weird dream???",13,13,13
	.byt 0

