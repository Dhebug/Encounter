//1K music player

//music is arranged in a similar format to PT3 but reduced alot

#define	via_portb		$0300
#define	via_t1cl		$0304
#define	via_t1ch		$0305
#define	via_t1ll		$0306
#define	via_t1lh		$0307
#define	via_t2ll		$0308
#define	via_t2ch		$0309
#define	via_sr			$030A
#define	via_acr			$030b
#define	via_pcr			$030c
#define	via_ifr			$030D
#define	via_ier			$030E
#define	via_porta		$030f

#define	FR08_WIDTH	205
#define FR08_HEIGHT	40

#define	FR08_X0		120-(FR08_WIDTH/2)
#define	FR08_Y0		100-(FR08_HEIGHT/2)

#define	FR08_X1		120+(FR08_WIDTH/2)
#define	FR08_Y1		100+(FR08_HEIGHT/2)

#define	FR08_DECOUNT	8


	.zero

//	*=$00	//6

runtime_pattern_addresses	.dsb 6	//		$00	//00-05
period_counter				.dsb 1	//		$06	//06/08/0a
current_period				.dsb 5	//		$07	//07/09/0b
current_effect				.dsb 3	//		$0c	//0c/0d/0e
effect_index				.dsb 3	// 		$10	//10,11,12
event_index					.dsb 1	//		$0f	//0f only
fade_flag					.dsb 1	//


	//.data
	.text


// 0 1
// 3 2
Fr08_Table_X
	.byt FR08_X0,FR08_X1,FR08_X1,FR08_X0,FR08_X0

Fr08_Table_Y
	.byt FR08_Y0,FR08_Y0,FR08_Y1,FR08_Y1,FR08_Y0

Fr08_Counter
	.byt FR08_DECOUNT

	.text

_Sequence_Fr08
	//jmp _Sequence_Fr08
.(
	// Switch to hire resolution
	// We need it to draw the rectangle
	jsr _SwitchToHires
	jsr _ClearHiresScreen

	// Draw the FR08 progression bar rectangle
	ldx #0
loop_draw_rectangle
	lda Fr08_Table_X,x
	sta _CurrentPixelX
	lda Fr08_Table_Y,x
	sta	_CurrentPixelY

	inx

	lda Fr08_Table_X,x	
	sta	_OtherPixelX
	lda Fr08_Table_Y,x	
	sta	_OtherPixelY

	txa
	pha
	jsr _DrawLine
	pla
	tax

	cpx #4
	bne loop_draw_rectangle


	//
	// Init position
	//
	lda #FR08_X0+2
	sta _CurrentPixelX
	lda #FR08_Y0+2
	sta	_CurrentPixelY

	lda #FR08_X0+2
	sta	_OtherPixelX
	lda #FR08_Y1-2
	sta	_OtherPixelY



	//init 6522 & ay
	sei

	/*
	lda #$10
	sta via_t1ll
	lda #$27
	sta via_t1lh
	*/
	lda #<20000
	sta via_t1ll
	lda #>20000
	sta via_t1lh


	lda #%10000000
	sta via_ier
	lda #%11000000
	sta via_ier
	lda #<irq_player
	sta $FFFE
	lda #>irq_player
	sta $FFFF
	ldx #01
	stx period_counter
	stx period_counter+2
	stx period_counter+4
	dex
	stx event_index
	stx current_effect
	stx current_effect+1
	stx current_effect+2
	stx fade_flag
	ldx #0
	stx _SystemEffectTrigger
	jsr proc_events

	ldx #04
irqd_01	
	jsr proc_pattern
	dex
	dex
	bpl irqd_01

	.(
	cli
indefinate_loop
	//
	// Draw a line
	//
	dec Fr08_Counter
	bne skip

	lda #FR08_DECOUNT
	sta Fr08_Counter

	jsr _DrawLine

	inc _CurrentPixelX
	inc _OtherPixelX
skip
	jsr _VSync

	nop
	nop
	lda _SystemEffectTrigger
	beq indefinate_loop
	.)

	//
	// Reinstall a stupid IRQ
	//
	jsr _System_InstallIRQ_SimpleVbl
	rts
.)



	//redirect irq
	//init music
	//rts

//1kdemopats
//Existing format?
//Method of conversion...
//1)Save patterns to disc, then load and save memory range to tape
//2)Remove header/convert to hex dump
//3)Isolate real patterns (Each pattern is always 128 bytes long) for each chan
//  arranged as 32 for A, then 32 for B then 32 for C
//4)replace "$fe,$00" with "rst" to easily isolate number of rests
//5)work through each pattern, using new format. Always use rests+1
//  Keep a copy of original intact, incase of mistakes.

// Event Format (No offsets, no repeats)


// 00-31 Pattern Number
// +128  Begin Fade because this is the Last Event

EventsA
	.byt 0,0,1,2,3
EventsB
	.byt 0,0,0,0,0
EventsC
	.byt 0,1,2,3,4+128

pattern_addressAlo
	.byt <patternA0,<patternA1,<patternA2,<patternA3
pattern_addressAhi
	.byt >patternA0,>patternA1,>patternA2,>patternA3
pattern_addressBlo
	.byt <patternB0
pattern_addressBhi
	.byt >patternB0
pattern_addressClo
	.byt <patternC0,<patternC1,<patternC2,<patternC3,<patternC4
pattern_addressChi
	.byt >patternC0,>patternC1,>patternC2,>patternC3,>patternC4


// Pattern format (30 bytes for this pattern!!)
//  000-127 Note
//  128-191 New Period
//  192-199 New Effect (0-7)
//  200-200 End of pattern

patternA0
    .byt 128+6,192,$18,128+2,$1f
    .byt 128+4,$1f,$18
    .byt 128+6,$18,128+2,$1f
    .byt 128+4,$1f,$18
    .byt 128+6,$18,128+2,$1f
    .byt 128+4,$1f,$18
    .byt 128+6,$18,128+2,$1f
    .byt 128+4,$1f,$13
    .byt 200

patternA1
    .byt 128+6,192,$21,128+2,$1c
    .byt 128+4,$1c,$21
    .byt 128+6,$21,128+2,$1c
    .byt 128+4,$1c,$15
    .byt 128+6,$1a,128+2,$1f
    .byt 128+4,$1f,$1a
    .byt 128+6,$1a,128+2,$1f
    .byt 128+4,$1f,$0e
    .byt 200

patternA2
    .byt 128+6,192,$1d,128+2,$24
    .byt 128+4,$24,$1d
    .byt 128+6,$1d,128+2,$24
    .byt 128+4,$24,$1d
    .byt 128+6,$18,128+2,$1f
    .byt 128+4,$1f,$18
    .byt 128+6,$18,128+2,$1f
    .byt 128+4,$1f,$1f
    .byt 200

patternA3
    .byt 128+6,192,$1f,128+2,$1a
    .byt 128+4,$1a,$1f
    .byt 128+6,$1f,128+2,$1a
    .byt 128+4,$1a,$1f
    .byt 128+6,$18,128+2,$1f
    .byt 128+4,$1f,$18
    .byt 128+6,$18,128+2,$1f
    .byt 128+4,$1f,$1f
    .byt 200

patternB0
   	.byt 128+4,192+2,$7d,192+1,$4e
   	.byt 192+2,$7d,192+1,128+2,$4e,$4e
	.byt 192+2,$7d,$7d,128+4,192+1,$4e
	.byt 192+2,$7d,128+2,192+1,$4e,$4e
	.byt 192+2,128+4,$7d,192+1,$4e
	.byt 192+2,$7d,128+2,192+1,$4e,$4e
	.byt 192+2,$7d,$7d,128+4,192+1,$4e
	.byt 192+2,$7d,128+2,192+1,$4e,$4e
	.byt 200

patternC0
	.byt 128+32,$7f,$7f,200

patternC1
	.byt 192+0,128+4,$34,128+2,$30,128+20,$2b
	.byt 128+2,$2b,$2d,128+4,$2e
	.byt $30,$32
	.byt 128+6,$34
	.byt 128+4,$35,128+2,$37,128+4,$39
	.byt 128+6,$3a
	.byt 200

patternC2
	.byt 128+2,192+0,$39,128+4,$37,128+20,$31
	.byt 128+2,$32,128+4,$34
	.byt $35,128+2,$37,128+4,$35
	.byt 128+6,$34
	.byt 128+2,$32,128+4,$34,$35
	.byt 128+6,$37
	.byt 200

patternC3
	.byt 192+0,128+2,$38,128+4,$37,128+20,$35
	.byt 128+2,$30,128+4,$32
	.byt 128+2,$34,128+4,$35,128+20,$37
	.byt 128+2,$34,$32,$30
	.byt 200

patternC4
	.byt 192+0,128+20,$37
	.byt 128+2,$37,128+4,$39
	.byt 128+2,$37,$33,$32
	.byt 128+32,$30
	.byt 200


effect_address_lo	//3 effects for this demo
	.byt <effect0,<effect1,<effect2
effect_address_hi	//3 effects for this demo
	.byt >effect0,>effect1,>effect2


effect0
	.byt 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,16,0
effect1
	.byt 15,5,16,0
effect2
	.byt 15+16,14+16,13+16,12+16,11+16,10+16,9+16,8+16,7+16,6+16,5+16,4+16,3+16
	.byt 2+16,1+16,16,0

	/*
effect0
	.byt 7,7,6,6,5,5,4,4,3,3,2,2,1,1,0,16,0
effect1
	.byt 7,3,16,0
effect2
	.byt 7+16,7+16,6+16,6+16,5+16,5+16,4+16,4+16,3+16,3+16,2+16,2+16,1+16
	.byt 1+16,1+16,16,0
*/


/*
effect0
	.byt 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,16,0
effect1
	.byt 15,5,16,0
effect2
	.byt 15+16,14+16,13+16,12+16,11+16,10+16,9+16,8+16,7+16,6+16,5+16,4+16,3+16
	.byt 2+16,1+16,16,0
	*/



irq_player
	// reserve registers
	// used to conserve bytes, not speed
	pha	
	tya
	pha
	txa
	pha

	inc _VblCounter

	// reset timer
	lda via_t1cl
	// delay music (10 tempo which equates to 25)
irqp_03	
	lda #00
	clc
	adc #51	// #25
	sta irqp_03+1
	bcc irqp_04
	// process music
	// Note - We use 4/2/0 index for two reasons...
	// 1) we can use lda (,x) opcode to fetch pattern entry
	// 2) we can directly index ay_table for pitch
	ldx #04
irqp_01	
	dec period_counter,x
	bne irqp_07
	jsr proc_pattern

	pha
	lda _SystemEffectTrigger
	beq continue
	pla
	jmp end_irq

continue
	pla


irqp_07	
	dex
	dex
	bpl irqp_01
irqp_04	
	//Delay SFX (4 which equates as 64)
irqp_05	
	lda #00
	adc #128
	sta irqp_05+1
	bcc irqp_06
	jsr proc_sfx
	//send_ay
irqp_06	
	ldx #$0a
irqp_02	
	stx via_porta
	lda #$ff
	sta via_pcr
	ldy #$dd
	sty via_pcr
	lda ay_table,x
	sta via_porta
	lda #$fd
	sta via_pcr
	sty via_pcr
	dex
	bpl irqp_02

end_irq
	//restore registers
	pla
	tax
	pla
	tay
	pla
	rti


proc_sfx	
	ldx #02
sfx_05	
	ldy current_effect,x
	lda effect_address_lo,y
	sta sfx_01+1
	lda effect_address_hi,y
	sta sfx_01+2
	ldy effect_index,x
sfx_01	
	lda $bf00,y
	pha
	and #15
	sta ay_table+8,x	//Store volume
	pla
	beq sfx_04
	and #%11110000
	lsr
	lsr
	lsr
	beq sfx_02
	sta ay_table+6	//Store noise
	lda ay_table+7	//fetch status
	and bitmask,x	//enable noise
	jmp sfx_03
sfx_02	
	lda ay_table+7	//fetch status
	ora bitpos,x	//disable noise
sfx_03	
	sta ay_table+7
	inc effect_index,x
sfx_04	
	//end
	//Add Tremelo to pitch
	txa
	asl
	tay
	lda ay_table,y
	eor #01
	sta ay_table,y
	dex
	bpl sfx_05
	rts

proc_pattern
pp_05	
	lda (runtime_pattern_addresses,x)
	//lda (00,x)	//xa doesn't like runtime_pattern_addresslo here
	ldy #03
pp_01	
	cmp pattern_entity_range,y
	bcs pp_02
	dey
	bpl pp_01
	//On Error, increment base and move onto next channel
pp_02	
	pha
	lda pattern_entity_range_vector_lo,y
	sta pp_03+1
	lda pattern_entity_range_vector_hi,y
	sta pp_03+2
	pla
	sbc pattern_entity_range,y
pp_03	
	jsr $bf00
	bcs pp_05
	rts

inc_pattern_entry
	inc runtime_pattern_addresses,x
	bne pp_04
	inc runtime_pattern_addresses+1,x
pp_04	
	rts

pattern_note
	//This is because the note would usually be based from 64
	//which is default event offset
//	adc #32
	and #127
	ldy #$ff	//Calculate pitch
	sec
cp_01	
	iny
	sbc #12
	bcs cp_01
	adc #12
	//y is octave
	//a is note
	//convert note to base pitch
	sty cp_02+1
	tay
	lda base_pitch_lo,y
	sta cp_05+1
	lda base_pitch_hi,y
	//shift base pitch to octave
cp_02	
	ldy #00
	beq cp_03
cp_04	
	lsr
	ror cp_05+1
	dey
	bne cp_04
cp_03	
	sta ay_table+1,x
cp_05	
	lda #00
	sta ay_table,x
	lda current_period,x
	sta period_counter,x
	txa
	lsr
	tay
	lda #00
	sta effect_index,y
	lda #15
	//lda #7	// Reduced volume
	sta ay_table+8,y
	clc
	jmp inc_pattern_entry
pattern_period
	sta current_period,x
	sec
	jmp inc_pattern_entry
pattern_effect
	pha
	txa
	lsr
	tay
	pla
	sta current_effect,y
	sec
	jmp inc_pattern_entry
pattern_eop
	stx peop_01+1
proc_events
	ldx fade_flag
	bne end_music
	ldx event_index
	ldy EventsA,x
	lda pattern_addressAlo,y
	sta runtime_pattern_addresses+0
	lda pattern_addressAhi,y
	sta runtime_pattern_addresses+1
	ldy EventsB,x
	lda pattern_addressBlo,y
	sta runtime_pattern_addresses+2
	lda pattern_addressBhi,y
	sta runtime_pattern_addresses+3
	lda EventsC,x
	bpl peop_02
	ldy #64
	sty fade_flag
	and #127
peop_02	
	tay
	lda pattern_addressClo,y
	sta runtime_pattern_addresses+4
	lda pattern_addressChi,y
	sta runtime_pattern_addresses+5
	inc event_index
peop_01	
	ldx #00
	rts

end_music	
	//jmp end_music
	lda #255	//Trigger mem
	sta _SystemEffectTrigger
	clc
	rts


//  000-127 Note
//  128-191 New Period
//  192-199 New Effect (0-7)
//  200-200 End of pattern
pattern_entity_range
 .byt 0,128,192,200
pattern_entity_range_vector_lo
 .byt <pattern_note,<pattern_period,<pattern_effect,<pattern_eop
pattern_entity_range_vector_hi
 .byt >pattern_note,>pattern_period,>pattern_effect,>pattern_eop
ay_table
 .byt 0,0		//a pitch lo/hi
 .byt 0,0		//b pitch lo/hi
 .byt 0,0		//c pitch lo/hi
 .byt 0		//Noise
 .byt 64+32+16+8	//Status (noise off by default)
 .byt 0,0,0	//Volumes a,b,c
base_pitch_lo
 .byt $ee,$16,$4c,$8e,$d8,$2e,$8e,$f6,$66,$e0,$60,$e8
base_pitch_hi
 .byt $0e,$0e,$0d,$0c,$0b,$0b,$0a,$09,$09,$08,$08,$07
bitmask	//for noise
 .byt 255-8,255-16,255-32
bitpos	//for noise
 .byt 8,16,32

end_of_music
 .byt 0




