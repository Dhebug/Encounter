#define LOW(x) <(x)
#define HIGH(x) >(x)

;;;;;;;;;;;;;;;; Routines to manage disk...

__sectors_per_track .byt 17
__double_sided .byt $00
__stepping_rate .byt 0   ; 6 ms 
sectors_per_cyl .byt 0 

diskcntrl .byt $86

;oldirq  .word 0

.zero
pbufl .byt 0
pbufh .byt 0

.text


_load_overlay
.(
    ; Sector to read    
    lda #100
    ldy #0
    sta (sp),y
    tya
    iny
    sta (sp),y

    ; Address of buffer
    iny
    lda #<$c000
    sta (sp),y
    lda #>$c000
    iny
    sta (sp),y

	; Load everything into overlay
    lda #10
    sta tmp
loop
    jsr _sect_read
    jsr inc_disk_params

    dec tmp
    bne loop
.)
.(
    ; Sector to read    
    lda #114
    ldy #0
    sta (sp),y
    tya
    iny
    sta (sp),y

    ; Address of buffer
    iny
    lda #<$ca00
    sta (sp),y
    lda #>$ca00
    iny
    sta (sp),y

	; Load everything into overlay
    lda #5
    sta tmp
loop
    jsr _sect_read
    jsr inc_disk_params

    dec tmp
    bne loop
.)
	; Load 12 sectors from 100+32

.(
    ; Sector to read    
    lda #132
    ldy #0
    sta (sp),y
    tya
    iny
    sta (sp),y

    ; Address of buffer
    iny
    lda #<$cea0
    sta (sp),y
    lda #>$cea0
    iny
    sta (sp),y

	; Load everything into overlay
    lda #13
    sta tmp
loop
    jsr _sect_read
    jsr inc_disk_params

    dec tmp
    bne loop


	rts
.)


    
; Routine to increment disk reading/writting parameters
inc_disk_params
.(
    ; Increment address in 256 bytes
    ldy #3
    lda (sp),y
    clc
    adc #1
    sta (sp),y

    ; Increment sector to read
    ldy #0
    lda (sp),y
    clc
    adc #1
    sta (sp),y
//#ifdef 0
	pha
//#endif
	iny
	lda (sp),y
	adc #0
	sta (sp),y
//#ifdef 0
    ;Sedoric bug workaround 
	pla
	cmp #225 ;$f3
	bne nosedbug
	dey
	lda #226; $f4
	sta (sp),y	
	iny
nosedbug
//#endif
    rts
.)




_switch_ovl 
    php
    pha
	sei
 	lda diskcntrl
	eor #2
	sta diskcntrl
    sta $0314
    lda #0
    sta $032F
    pla
    plp
    rts	
#if 0
	php
	pha
	sei
	lda diskcntrl
	eor #2
	sta diskcntrl
	sta $0314
	pla
	plp
	rts
#endif

_init_disk 
   php 
   sei 
   lda #LOW(irq_handler) 
   sta $fffe 
   lda #HIGH(irq_handler) 
   sta $ffff 
   jsr restore_track0 
   plp 
   rts 

_sect_write 
   lda #$a0   ; write command 
   bne sect_rw 
_sect_read
   lda #$80   ; read command 
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

   ldx __sectors_per_track 
   stx sectors_per_cyl 
   ldx #$ff 
   bit __double_sided 
   bpl compute_cylinder 
   asl sectors_per_cyl 
compute_cylinder 
   inx 
   sec 
   sbc sectors_per_cyl 
   bcs compute_cylinder 
   dey 
   bpl compute_cylinder 
   adc sectors_per_cyl 

   stx __cylinder 
   ldy #0 
   cmp __sectors_per_track 
   bcc store_side 
   ldy #$10 
   sbc __sectors_per_track 
store_side 
   sty __side 
   tay 
   iny 
   sty __sector 

   rts 


__sector .byt 0 
__cylinder .byt 0 
__side .byt 0 
__status .byt 0 
__buffer .word 0 

restart_counter .byt 0 
readwrite .byt 0 
old_ier .byt 0 

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
   lda $0314 
   bmi wait_completion 
   lda $0310 
   rts 

restore_track0 
   lda #$0C 
   sta $0310 
   jsr wait_completion 
   and #$10   ; seek error ? 
   bne restore_track0 
   rts 

seek_track 
   lda #$1C 
   ora __stepping_rate 
   sta $0310 
   jsr wait_completion 
   and #$18   ; seek error or CRC error ? 
   beq seek_ok 
   jsr restore_track0 
   beq seek_track 
seek_ok 
   rts 
    
__select_sector 
   lda diskcntrl   ; current drive/side selection 
   and #$ef 
   ora __side 
   sta diskcntrl	; side updated 
   ora #$01   ; enables FDC interrupts 
   sta $0314 

   lda __cylinder 
   sta $0313 
   cmp $0311 
   beq *+5 
   jsr seek_track 
   lda __sector 
   sta $0312 
   rts 

readwrite_data 
   cli 
   lda #0 
   sta pbufl 
   lda __buffer+1 
   sta pbufh 
   ldy __buffer 
   lda readwrite 
   cmp #$a0 
   beq write_data 
read_data 
   lda $0318 
   bmi read_data 
   lda $0313 
   sta (pbufl),y 
   iny 
   bne read_data 
   inc pbufh 
   jmp read_data 
   
write_data 
   lda $0318 
   bmi write_data 
   lda (pbufl),y 
   sta $0313 
   iny 
   bne write_data 
   inc pbufh 
   jmp write_data 


    
irq_handler
.(
   ;bit $0314 
   ;bpl fdc_irq 
   ;jmp $04f5 
  bit $030D
  bpl fdc_irq
  pha             ; cancel any VIA interrupt when overlay ram is active
  lda #$7F
  sta $030D
  pla
  rti
fdc_irq 
   pla      ; get rid of IRQ context 
   pla 
   pla 
   lda diskcntrl 
   sta $0314   ; disables disk irq 
   lda $0310   ; gets status and resets irq 
   and #$7c 
   sta __status 
   rts 
.)
    
__sector_readwrite 
   php 
   sei 
   jsr save_ier 
   ldy #8 
   sty restart_counter 
again 
   jsr __select_sector 
   lda readwrite 
   sta $0310 
   jsr readwrite_data 
   lda __status 
   beq success 
   dec restart_counter 
   bne again 
success 

   jsr restore_ier 
   plp 
   rts 



