;

;B0-1 Mode
;B2-3 Packed Bits or SubMode if Mode is 3
;B4-7 Packed Bits

;B0-1
;    3 - Mode 0(1 Bit Samples)
;B2
;    Sample +5
;B3
;    Sample +4
;B4
;    Sample +3
;B5
;    Sample +2
;B6
;    Sample +1
;B7
;    Sample +0

;B0-1
;    2 - Mode 1(2 Bit Samples)
;B2-3
;    Sample +2
;B4-5
;    Sample +1
;B6-7
;    Sample +0

;B0-1
;    1 - Mode 2(3 Bit Samples)
;B2-4
;    Sample +1
;B5-7
;    Sample +0

;B0-1
;    0 - Mode 3(4 Bit Sample)
;B2-3
;    3 - 4 Bit Sample
;B4-7
;    Sample +0

;B0-1
;    0 - Mode 5(Short Interval)
;B2-3
;    2 - Short Interval
;B4-7
;    Interval Period

;B0-1
;    0 - Mode 5(Long Interval)
;B2-3
;    1 - Long Interval
;B4-7
;    Interval Period + next byte to form 12 Bit interval period

;B0-1
;    0 - End
;B2-3
;    0 - End
;B4-7
;    Final Volume

 .zero
*=$00
sample			.dsb 2
PackedBits		.dsb 1
CurrentVolume		.dsb 1
IntervalPeriodLo		.dsb 1
IntervalPeriodHi              .dsb 1

 .text
*=$600

	lda (sample),y
	sta PackedBits
	and #3
	tax
	;0==1bit
	;1==2bit
	;2==3bit
	;3==4bit
	lda #00
loop1	asl PackedBits
	rol
	dex
	bpl loop1
	
	
	
	
	
	

DecodeSampleByte
	ldy #00
BigSampleLoop
	lda IntervalPeriodLo
.(
	bne skip2
	lda IntervalPeriodHi
	beq skip1
	dec IntervalPeriodHi
skip2	dec IntervalPeriodLo
	jsr StrobeTime
	jmp BigSampleLoop

skip1	lda (sample),y
.)
	sta PackedBits
	and #3
	beq ProcessMode4
	cmp #2
	bcc ProcessMode2
	beq ProcessMode1
ProcessMode0
	;Process 1 Bit samples
	ldx #6
	;Play cycle the 6x1 bits of Mode 0
.(
loop1	lda CurrentVolume
	asl PackedBits
	bcs skip1
	lda #00
skip1	sta VIA_PORTA
	jsr StrobeTime
	dex
	bne loop1
.)
	jmp ProceedSampleByte
ProcessMode1
	;Process 2 bit samples
	ldx #3
	;Play cycle the 3x2 bits of Mode 1
.(
loop1	lda #00
	asl PackedBits
	rol
	asl PackedBits
	rol
	asl
	asl
skip1	sta VIA_PORTA
	sta CurrentVolume
	jsr StrobeTime
	dex
	bne loop1
.)
	jmp ProceedSampleByte
ProcessMode2
	;Process 3 bit samples
	ldx #2
	;Play cycle the 2x3 bits of Mode 2
.(
loop1	lda #00
	asl PackedBits
	rol
	asl PackedBits
	rol
	asl PackedBits
	rol
	asl
skip1	sta VIA_PORTA
	sta CurrentVolume
	jsr StrobeTime
	dex
	bne loop1
.)
	jmp ProceedSampleByte
ProcessMode3
	;Process 4 Bit samples, Interval or End
	lda (sample),y
	and #%00001100
	beq EndSample
	cmp #%00001000
	bcc ProcessLongInterval
	beq ProcessShortInterval
Process4BitSample
	lda (sample),y
	lsr
	lsr
	lsr
	lsr
	sta VIA_PORTA
	sta CurrentVolume
	jsr StrobeTime
	jmp ProceedSampleByte
ProcessLongInterval
	lda (Sample),y
	lsr
	lsr
	lsr
	lsr
	sta IntervalPeriodHi
	iny
.(
	bne skip1
	inc sample+1
skip1	lda (sample),y
.)
	sta IntervalPeriodLo
	jmp ProceedSampleByte
ProcessShortInterval
	lda (Sample),y
	lsr
	lsr
	lsr
	lsr
	sta IntervalPeriodLo
	lda #00
	sta IntervalPeriodHi
ProceedSampleByte
	iny
.(
	bne skip1
	inc sample+1
skip1	jmp BigSampleLoop
.)
EndSample	rts
	
StrobeTime
	lda VIA_IFR
	and #%00100000
	beq StrobeTime
	lda #0
	sta VIA_T2CH
	rts
	
	
	
	
	