#define LOW(x) <(x)
#define HIGH(x) >(x)


#define NUM_SECT_PERSSC 63 
#define SECT_INIT 100
#define NUM_SECT_TOTAL_LOAD 152

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Routines to be called from Wurlde
;
;     load_ssc ; Loads ssc into $c0000. ssc # is passed in reg A
;              ; sector where that ssc resides in disk is
;              ; in the next table. If all sscs are equal size
;              ; no need for table; can be calculated...
;     total_load ; Loads 152 sectors into $500 and up.
;				; number of total_load is passed in reg A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#define NUM_SSC 2
ssc_sector_table

.word  SECT_INIT
.word  SECT_INIT+NUM_SECT_PERSSC
.word  SECT_INIT+NUM_SECT_PERSSC*2
.word  SECT_INIT+NUM_SECT_PERSSC*3
.word  SECT_INIT+NUM_SECT_PERSSC*4
.word  SECT_INIT+NUM_SECT_PERSSC*5

#define FIRST_TOTAL_LOAD SECT_INIT+NUM_SECT_PERSSC*NUM_SSC

total_sector_table
.word  FIRST_TOTAL_LOAD
.word  FIRST_TOTAL_LOAD + NUM_SECT_TOTAL_LOAD
.word  FIRST_TOTAL_LOAD + NUM_SECT_TOTAL_LOAD*2


load_ssc
.(

	; Get sector for specified ssc
	asl	; Multiply for 2-byte entries
	tax
	lda ssc_sector_table,x
	sta init_sector
	lda ssc_sector_table+1,x
	sta init_sector+1

	lda #NUM_SECT_PERSSC
	sta num_sectors

    lda #<$c000
    sta destination
    lda #>$c000
    sta destination+1

    jmp load_chunk	; This is jsr/rts
.)




total_load
.(

	; Get sector for specified total load
	asl	; Multiply for 2-byte entries
	tax

	lda total_sector_table,x
	sta init_sector
	lda total_sector_table+1,x
	sta init_sector+1

	lda #NUM_SECT_TOTAL_LOAD
	sta num_sectors

    lda #<$500
    sta destination
    lda #>$500
    sta destination+1

    jmp load_chunk	; This is jsr/rts

.)



; load memory chunk

destination .word $0000 
num_sectors	.byt 00
init_sector	.word $0000 

load_chunk
.(

	php
	sei
    ; Save old irq handler...
    lda $fffe
    sta oldirql+1
    lda $ffff
    sta oldirqh+1	

    ; Install disk irq handler
    lda #LOW(irq_handler) 
    sta $fffe 
    lda #HIGH(irq_handler) 
    sta $ffff 
	
	cli

    jsr _init_disk

    ; Sector to read    
    lda init_sector
    ldy #0
    sta (sp),y
	lda init_sector+1
    iny
    sta (sp),y

    ; Address of buffer
    iny
    lda destination
    sta (sp),y
    lda destination+1
    iny
    sta (sp),y

    lda num_sectors
    sta tmp
loop
    jsr _sect_read
    
    ;; Increment address
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
    iny
    lda (sp),y
    adc #0
    sta (sp),y
    
	
	dec tmp
    bne loop


oldirql
	lda #0
	sta $fffe
oldirqh
	lda #0
	sta $ffff

	plp
    rts
.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;            Routines to manage disk...
; _switch_ovl switches between overlay ram and rom
; _init_disk sets the irq routine to access disk
; _sect_read  
; _sect_write read-write sector of disk. Uses C parameter passing, so
; 		   prototype is void sect_read(int sector, char * buffer);
;              or sect_write(int sector, char * buffer);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; This are defined when compiling with C, but not in other cases...

.zero
sp	.word 00
tmp	.byt 0

.text

__sectors_per_track .byt 17
__double_sided .byt $00
__stepping_rate .byt 0   ; 6 ms 
sectors_per_cyl .byt 0 

diskcntrl .byt $86

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



