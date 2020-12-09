stack_start = $b800
    .zero
    *= $4a
_stack	.dsb 2
_stack_var_ptr .dsb 2
_pc_ptr .dsb 2

ap      .dsb 2
fp      .dsb 2
sp      .dsb 2
tmp     .dsb 2
        .dsb 2
tmp0    .dsb 2
tmp1    .dsb 2
tmp2    .dsb 2
tmp3    .dsb 2
tmp4    .dsb 2
tmp5    .dsb 2
tmp6    .dsb 2
tmp7    .dsb 2

op1     .dsb 2
op2     .dsb 2

reg0    .dsb 2
reg1	.dsb 2
reg2	.dsb 2
reg3	.dsb 2
reg4	.dsb 2
reg5	.dsb 2
reg6	.dsb 2
reg7	.dsb 2

    .text

*=$500

        sta _machine_type
        and #$80
        bmi init_telestrat

        lda #$22
        sta $026A
        lda #0
        sta $026B
        lda #7
        sta $026C
        jmp machine_dependant_done

init_telestrat
        
machine_dependant_done
        jsr switch_to_ram
        jsr _init_disk
        cli
        lda #$C0
        sta $030E
        lda #$40
        sta $030B
        jsr go_main
        jsr switch_to_rom

        ldy #0
        lda #< reset_message
        sta (sp),y
        iny
        lda #> reset_message
        sta (sp),y
        jsr _printf

wait_reset jmp wait_reset

go_main
        tsx
        stx retstack
	lda #< stack_start
	sta sp
	lda #> stack_start
	sta sp+1
	ldy #0
        jmp _main


retstack .byt 0

_machine_type   .byt 0

switch_to_rom
        php
        pha
        bit _machine_type
        bvc jasmin_switch_to_rom
        lda #$86
        sta $0314
        lda #7
        sta $032F
        pla
        plp
        rts
jasmin_switch_to_rom
        lda #0
        sta $03fb
        lda #0
        sta $03fa
        pla
        plp
        rts

switch_to_ram
        php
        pha
        bit _machine_type
        bvc jasmin_switch_to_ram
        lda #$84
        sta $0314
        lda #0
        sta $032F
        pla
        plp
        rts
jasmin_switch_to_ram
        lda #1
        sta $03fa
        pla
        plp
        rts

_myputchar
        jsr switch_to_rom
        bit statusline_flag
        bmi statusline_putchar
        bit _machine_type
        bmi telestrat_putchar
        jsr $0238
        jmp switch_to_ram
telestrat_putchar
        pha
        txa
        cmp #$7f
        bne *+4
         lda #8
        brk
        .byt $10
        pla
        jmp switch_to_ram
statusline_putchar
        jsr tx_stbuff
        jmp switch_to_ram

_mygetchar
        jsr switch_to_rom
        bit _machine_type
        bmi telestrat_getchar
        jsr $023B
        bpl *-3
        tax
        lda #0
        jmp switch_to_ram
telestrat_getchar
        brk
        .byt $0C
        tax
        lda #0
        jmp switch_to_ram

enter
	sty tmp
	stx tmp+1
	asl
	sta op2
	tax
	beq noregstosave
savereg	lda reg0-1,x
	sta (sp),y
	iny
	dex
	bne savereg
noregstosave
	sty op2+1
	lda ap
	sta (sp),y
	iny
	lda ap+1
	sta (sp),y
	iny
	lda fp
	sta (sp),y
	iny
	lda fp+1
	sta (sp),y
	iny
	lda op2
	sta (sp),y
	iny
	lda tmp
	sta (sp),y
	clc
	lda sp
	sta ap
	adc op2+1
	sta fp
	lda sp+1
	sta ap+1
	adc #0
	sta fp+1
	lda tmp+1
	adc fp
	sta sp
	lda fp+1
	adc #0
	sta sp+1
	rts

leave
	stx op2
	sta op2+1
	lda ap
	sta sp
	lda ap+1
	sta sp+1
	ldy #4
	lda (fp),y
	tax
	iny
	lda (fp),y
	tay
	txa
	beq noregstorestore
restorereg
	lda (sp),y
	sta reg0-1,x
	iny
	dex
	bne restorereg
noregstorestore
	ldy #0
	lda (fp),y
	sta ap
	iny
	lda (fp),y
	sta ap+1
	iny
	lda (fp),y
	tax
	iny
	lda (fp),y
	stx fp
	sta fp+1
	ldx op2
	lda op2+1
	rts

jsrvect jmp (0000)

reset_message .byt $0d,$0a
        .byt "Remove disk and press reset"
        .byt 0
