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
#ifdef OLDROUTINES
   cli 
#endif
   lda #0 
   sta pbufl 
   lda __buffer+1 
   sta pbufh 
   ldy __buffer 
   lda readwrite 
   cmp #$a0 
   beq write_data 

#ifdef OLDROUTINES  
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

#else
read_data
/*   
     lda $0310
     lsr
     bcc end_read
     lda $0318
     bmi read_data
*/

	 bit $0314
	 bpl end_read
     bit $0318
     bmi read_data

     lda $0313
     sta (pbufl),y
     iny
     bne read_data
     inc pbufh
     jmp read_data
end_read
     lda $0310
     rts

write_data
/*
     lda $0310
     lsr
     bcc end_write
     lda $0318
     bmi write_data
*/

     bit $0314
     bpl end_write
     bit $0318
     bmi write_data

     lda (pbufl),y
     sta $0313
     iny
     bne write_data
     inc pbufh
     jmp write_data
end_write
     rts



#endif    
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

#ifdef OLDROUTINES
   /* As there is no more IRQ, we have to do this differently  */
   /* instead of simply lda __status, we need to read it here. */
   lda $0310   ; gets status
   and #$7c 
   sta __status 
#else
   lda __status
#endif

   beq success 
   dec restart_counter 
   bne again 
success 

   jsr restore_ier 
   plp 
   rts 
    


irq_handler
.(
#ifdef OLDROUTINES
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
#else
  bit $030D
  bpl fdc_irq
  pha             ; cancel any VIA interrupt when overlay ram is active
  lda #$7F
  sta $030D
  pla
  rti
fdc_irq 
   lda $0310   ; gets status and resets irq 
   rti 
#endif
.)

