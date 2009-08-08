;GameTitle.s(Also incorperates Game Intro)

;At game start
;1) Set HIRES
;2) Disable 6522 IRQ, Enable IRQ
;3) Load Game HIRES


 .zero
*=$00
#include "zeropage.s"

 .text
*=$500

Driver
	;Perform Soft HIRES
	lda #28
	sta $bfdf
	lda #<$A000
	sta screen
	lda #>$A000
	sta screen+1
	ldx #200
	clc
.(
loop2	ldy #39
	lda #64
loop1	sta (screen),y
	dey
	bpl loop1
	lda screen
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	dex
	bne loop2
.)
	;Freeze
.(
loop1	nop
	jmp loop1
.)
