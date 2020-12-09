__sectors_per_track		.byt 9
__stepping_rate			.byt 0	; 6 ms
__sectors_per_cyl		.byt 9

_init_disk
	php
	sei
	ldy #<(irq_handler)
	lda #>(irq_handler)
	ldx #$10
	bit _machine_type
	bpl *+6
	ldy #<(telestrat_irq_handler)
	lda #>(telestrat_irq_handler)
	bvs *+4
	ldx #$f4
	sty $fffe
	sta $ffff
	stx fdc_offset
	jsr restore_track0
	plp
	rts

_sect_write
	lda #$a0	; write command
	bne sect_rw
_sect_read
	lda #$80	; read command
sect_rw
	sta readwrite

	ldy #2
	lda (sp),y
	sta __buffer
	iny
	lda (sp),y
	sta __buffer+1

	jsr __linear_to_physical_sector
	jsr __sector_readwrite
	
	lda __status
	ldx #0
	rts

__linear_to_physical_sector
	ldy #0
	lda (sp),y
	tax
	iny
	lda (sp),y
	tay
	txa
	
	ldx #$ff
compute_cylinder
	inx
	sec
	sbc __sectors_per_cyl
	bcs compute_cylinder
	dey
	bpl compute_cylinder
	adc __sectors_per_cyl

	stx __cylinder
	ldy #0
	cmp __sectors_per_track
	bcc store_side
	iny
	sbc __sectors_per_track
store_side
	sty __side
	tay
	iny
	sty __sector

	rts


__sector	.byt 2
__cylinder	.byt 0
__side		.byt 0
__status	.byt 0
__buffer	.word 0
fdc_offset	.byt 0

restart_counter	.byt 0
readwrite		.byt 0
old_ier			.byt 0

save_ier
	ldy $030e
	sty old_ier
	ldy #$7f
	sty $030e
	rts

restore_ier
	ldy old_ier
	sty $030e
	rts

wait_completion
	ldy #4
	dey
	bne *-1
	lda $0300,x
	lsr
	bcs *-4
	asl
	rts

    .dsb 4-(*&3),$ea
	nop
write_command_register
	sta $0300,x
	rts
	nop
write_track_register
	sta $0301,x
	rts
	nop
write_sector_register
	sta $0302,x
	rts
	nop
write_data_register
	sta $0303,x
	rts


restore_track0
	lda #$0C
	ldx fdc_offset
	jsr write_command_register
	jsr wait_completion
	and #$10	; seek error ?
	bne restore_track0
	rts

seek_track
	lda #$1C
	ldx fdc_offset
	ora __stepping_rate
	jsr write_command_register
	jsr wait_completion
	and #$18	; seek error or CRC error ?
	beq seek_ok
	jsr restore_track0
	beq seek_track
seek_ok
	rts


		
__select_sector
	ldx fdc_offset
	lda __side
	bit _machine_type
	bvc *+8
	asl
	asl
	asl
	asl
	ora #$85
	sta $0304,x

	lda __cylinder
	jsr write_data_register
	cmp $0301,x
	beq *+5
	jsr seek_track
	lda __sector
	jsr write_sector_register
	rts

readwrite_data
	cli
	lda #0
	sta $f3
	lda __buffer+1
	sta $f4
	lda readwrite
	bit _machine_type
	bvc jasmin_readwrite
	ldy __buffer
	cmp #$a0
	beq microdisc_write_data
microdisc_read_data
	lda $0318
	bmi microdisc_read_data
	lda $0313
	sta ($f3),y
	iny
	bne microdisc_read_data
	inc $f4
	jmp microdisc_read_data

    .dsb 4-(*&3),$ea
	nop
microdisc_write_data
	lda $0318
	bmi microdisc_write_data
	lda ($f3),y
	sta $0313
	iny
	bne microdisc_write_data
	inc $f4
	jmp microdisc_write_data

jasmin_readwrite
	ldy #<(drq_read_handler)
	ldx #>(drq_read_handler)
	cmp #$80
	beq *+6
	ldy #<(drq_write_handler)
	ldx #>(drq_write_handler)
	sty $fffe
	stx $ffff
	ldy __buffer
jasmin_wait_completion
	ldx $03f4
	stx __status
	lsr __status
	bcs jasmin_wait_completion
	asl __status
	ldy #<(irq_handler)
	lda #>(irq_handler)
	sty $fffe
	sta $ffff
	rts

telestrat_irq_handler
	bit $0314
	bpl fdc_irq
	jmp $02fa

irq_handler
	bit $030D
	bpl fdc_irq
	pha				; cancel any VIA interrupt when overlay ram is active
	lda #$7F
	sta $030D
	pla
	rti
fdc_irq
	pla				; get rid of IRQ context
	pla
	pla
	lda #$84
	sta $0314		; disables disk irq
	lda $0310		; gets status and resets irq
	and #$7c
	sta __status
	rts

drq_read_handler
	lda $03f7
	sta ($f3),y
	iny
	bne *+4
	inc $f4
	rti

drq_write_handler
	lda ($f3),y
	sta $03f7
	iny
	bne *+4
	inc $f4
	rti

__sector_readwrite
	php
	sei
	jsr save_ier
	ldy #8
	sty restart_counter
again
	jsr __select_sector
	ldx fdc_offset
	lda readwrite
	jsr write_command_register
	jsr readwrite_data
	lda __status
	beq success
	dec restart_counter
	bne again
success
	jsr restore_ier
	plp
	rts

