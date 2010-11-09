;Play Signed 8 bit mono 8Khz Sample

#define	VIA_T2LL		$0308
#define	VIA_T2CH		$0309
#define	VIA_PCR		$030C
#define	VIA_PORTA		$030F
#define	VIA_IFR		$030D
;#define	VIA_
;#define	VIA_

 .zero
*=$00
SampleEnd		.dsb 2
MaxVal		.dsb 1
 .text
*=$600


PlaySample
	sei
	lda #00
	sta MaxVal
	;Setup sample start vector
	lda #<$1000
	sta SamVector+1
	lda #>$1000
	sta SamVector+2
	
	;Setup basic AY register values
	ldx #<InitialisedAYRegisters
	ldy #>InitialisedAYRegisters
	jsr $FA86
	
	;Return current register to Volume A
	ldx #0
	lda #8
	jsr $F590
	
	;Also set Timer2 to 8Khz
	lda #00
	sta VIA_T2CH
	lda #250
	sta VIA_T2LL
	
	;Set CB2 high/CA2 low
	lda #$FD
	sta VIA_PCR

SamLoop	;Play Sample
SamVector	lda $dead
;	lsr
;	lsr
;	lsr
	sta VIA_PORTA
	
	;store max val
	cmp MaxVal
.(
	bcc skip1
	sta MaxVal
skip1
.)
	;Strobe T2 Timeout(125==8Khz)
InnerStrobingLoop
	lda VIA_IFR
	and #%00100000
	beq InnerStrobingLoop

	;Reset IRQ and set latch values again
	lda #0
	sta VIA_T2CH

	;proceed to end of sample
	lda SamVector+1
	clc
	adc #02
	sta SamVector+1
	lda SamVector+2
	adc #00
	sta SamVector+2

	cmp SampleEnd+1
	bcc SamLoop
	lda SamVector+1
	cmp SampleEnd
	bcc SamLoop

	;Restore original 6522 settings
	lda #$DD
	sta VIA_PCR

	cli
	rts
	
InitialisedAYRegisters
 .byt 0,0,0
 .byt 0,0,0
 .byt 0
 .byt %01111111
 .byt 0
 .byt 0
 .byt 0
 .byt 0,0
 .byt 0

