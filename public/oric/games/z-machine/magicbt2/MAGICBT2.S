; Version 2: work around the Telestrat ULAs' bug

    .zero         ; temporary variables in page 0
* = 0
machine_type .dsb 1
status    .dsb 1
* = $40
page      .dsb 1
nbsect    .dsb 1
addrbuf   .dsb 1
addrbufh  .dsb 1
sector    .dsb 1
side      .dsb 1
type      .dsb 1

    .text
; * = $9fcf-11	; this allows load_addr to be in $9fcf, see below

_main
page1
; first page of the Fantasmagoric boot sector, containing :
; - Microdisc and Cumana "boot" sector (system parameters)
; - OricDos directory
; - OricDos and Cumana "system", in record format

off_00  .byt  40          ; Microdisc wants this to be not null (# of tracks)
                        ; this is also used as the track of the next directory sector
                        ; and also the track of the next sector of the loaded file
off_01  .byt  0           ; next directory sector, and also next sector of file
                        ; a 0 value means no next sector
off_02  .byt  1		; only one entry in this directory
off_03  .byt  0           ; skip this directory entry (things are too intricated here)
; record header
off_04  .word  load_addr	; where to load this record
off_06  .word  last
off_08  .word  0           ; this should be the exec addr, but it is copied elsewhere and
				; gets overriden by second page of the sector
off_0A  .byt  <(last-load_addr)   ; record size

load_addr       ; load_addr=$9fcf

; Bios Parameter Block for the PC starts here but MSDOS and Windows don't seem
; to use it anymore, and seem to rely on the type byte found in the FAT
off_0B  .byt  0
off_0C  .byt  0   ; microdisc copyright message is copied from here to the status line (empty)
off_0D  .byt  0
off_0E  .word  0   ; cumana copyright message is copied from here to the status line (empty)
off_10  .byt  0,0 ; OricDos parameters : first free sector location, but copied to the second part
off_12  .byt  1   ; OricDos parameters : directory sector #
off_13  .byt  0   ; OricDos parameters : directory track #
                ; OricDos directory : 0 means skip this directory entry (things are way too intricated here !)
off_14  .word  0   ; OricDos parameters : # of free sectors, copied to the second part
off_16  .word  1   ; OricDos parameters : # of used sectors, copied to the second part
off_18  .word  0
off_1A  .word  0

; definition tables for floppy types 720KB, 180KB, 360KB
; a third table (dataside) use the OricDos directory entry just below
dirsect .byt  8,6,6
datasect .byt 6,1,4
        .byt 0
; here we are more comfortable to store an OricDos directory entry
off_23  .byt "LOADERSYS"
dataside                ; this saves some place since table is 1,0,1
        .byt  1           ; BOOT is 1 sector
        .byt  0,1         ; it starts at track 0 sector 1
        .byt  0,1         ; so it ends at same sector
        .byt  0,$80       ; flags


; definitions
buf			= $A200
FDC_command	= $0310
FDC_status	= $0310
FDC_track	= $0311
FDC_sector	= $0312
FDC_data	= $0313


; let's start some code at last

microdisc_start
	sei
	ldx #0
microdisc_move		; copy the second part of the sector
	lda $C123,x             ; which has not been transfered by the eprom code
	sta page2,x
	inx
	bne microdisc_move
	lda #$40
	sta machine_type	; flag a microdisc controller
	
	lda #$7F
	sta $030E		; disables VIA interrupts
	lda #$85
	sta $0314
	ldy #<(irq_handler)
	lda #>(irq_handler)
	sty	$FFFE
	sta $FFFF
	cli

all_start			; here is the common code for all machine types
	ldx #2                  ; first FAT sector
	stx sector
	lda #0
	sta side
	jsr buf_readsect        ; get it in buffer

	lda buf         ; floppy type
	sec
	sbc #$F9
	beq *+4
	sbc #2
	sta type        ; now we have types 0 (720KB), 1 (180KB) , 2 (360KB)
	tax

	lda dirsect,x
	sta sector
	jsr buf_readsect
	
	lda buf+$1C		; compute the number of sectors used, minus 1 (the first one)
	ldy buf+$1D
	bne *+8
		lda buf+$3C
		ldy buf+$3D
	sec		
	sbc #1
	tya
	sbc #0
	lsr
	sta nbsect

                                ; get the location of the first data sector
	ldx type
	lda datasect,x
	sta sector
	lda dataside,x
	sta side
	bne loadfirst
	jsr step_in             ; if it's on side 0 (180KB floppy), it's on track 1

loadfirst                       ; load first data sector
 	jsr buf_readsect

	sec			; initialize transfer address
	lda buf+1
	sbc #5
	sta addrbuf
	lda buf+2
	sbc #0
	sta addrbufh
	sta page

	ldy #5          ; and transfer the first sector (except first 5 bytes)
	ldx #2
moveloop
	lda buf,y
	sta (addrbuf),y
	iny
	bne moveloop
	inc addrbufh
	inc moveloop+2
	dex
	bne moveloop

nextsect			; compute next sector
	ldx sector
	inx
	cpx #10                 ; # of sectors per track
	bne readnext
	inc side
	ldx type
	lda dataside,x          ; 1 if double-sided disk, 0 if single_sided 
	cmp side
	bcs sector1
	jsr step_in
	ldx #0
	stx side
sector1
	ldx #1

readnext			; read next sector
	stx sector
	inc page
	inc page
try
	lda page
	sta addrbufh
	jsr readsect
	bne try

	dec nbsect
	bne nextsect

	lda machine_type
	jmp (buf+3)		; start the system

last    .byt  0


; second part (offsets $100-$1ff) of the fantasmagoric boot sector: boot for Telestrat and Jasmin

    .dsb page1+256-*
page2

; Jasmin loads the boot sector in $0400, Telestrat loads it in $C100.
; both Telestrat and Jasmin override first page of the sector with second page.
; Jasmin starts exec at offset 0, 
; After loading this boot sector, Telestrat will start loading the DOS from the next sector,
; and then do a JSR $C105. So we load the next sector (first sector of FAT) in a dummy place.

 .byt 0 ; Telestrat needs 0 at offset 0 for a bootable disk
      ; Microdisc system parameter copy : first free sector being 0 means no sector (lucky me)
      ; Jasmin interprets this instruction as BRK #9, hopefully no harm is done
 .byt 9 ; Telestrat : # of sectors per track
      ; Microdisc system parameter copy : track # of the first free sector (none, see above)
 .byt 1 ; Telestrat takes here the number of sectors of the DOS to load
      ; Microdisc system parameter copy : directory sector (lucky again)
      ; Jasmin interprets this instruction as ORA (00,X), again no harm is done
 .byt 0 ; Telestrat : LSB of DOS loading address, one dummy sector will be read there only
      ; Microdisc system parameter copy : directory sector (lucky again)
 inx
      ; Telestrat : MSB of DOS loading address, thus sector 2 will be read in $E800
      ; Jasmin clears the zero flag when executing this
      ; Microdisc system parameter copy : LSB of # of free sectors (can't be always lucky)
 beq telestrat_start 
      ; flag Z is set when the telestrat does JSR $C105
      ; Microdisc system parameter copy of # of free and used sectors are wrong, hard to do better
 bne jasmin_start
      ; at last we can take control on the Jasmin
      
off_109 .byt "LOADERSYS"    ; this matching pattern overrides the one at $C12C on Microdisc
					; Cumana cannot use a matching pattern with wildcards here
        .dsb 6			; this space could be used for my local variables in the future
off_118 .byt  0   			; this byte ($C12B) on the microdisc is copied to $C000
        .byt  $FF
        .dsb 2			; this space could be used for my local variables in the future
off_11C .byt 0			; this byte ($C13F) on the microdisc is tested against 0
        .dsb 11		; this space could be used for my local variables in the future
off_128 .word  microdisc_start   ; this word ($C14B) is used as exec addr for microdisc
off_12A .word  microdisc_start   ; this word ($C14D) is used as exec addr for cumana
	
jasmin_start
	sty $03fa               ; 1->ORMA selects overlay ram
	ldy #$20			; flag a Jasmin controller
	lda #>($0400)
	sta readboot_jsr+2-page2+$0400	; adjusts the jsr readsect
	ldx #<(irq_jasmin-page2)
	bne loader

;trace
;	sta $BBA8
;	inc trace+1-page2+$C100
;	rts
	
telestrat_start        
	lda #$7F
	sta $030E       ; disable VIA interrupts
	sta $032E		; and VIA2 interrupts too
	sta $031D		; reset ACIA
	lda $031D       ; clear eventual ACIA interrupt
	ldy #$C0		; flag Telestrat hardware and Microdisc hardware
	lda #>($C100)
; jsr trace-page2+$C100
	ldx #<(irq_handler-page2)   ; set IRQ vector

loader
	sty machine_type ; bit 7: Telestrat, bit 6: Microdisc, bit 5: Jasmin
	stx $FFFE
	sta $FFFF
	ldx #1
	stx sector
	dex
	stx side
	
reloadboot	
	ldy #<(page1)
	lda #>(page1)
	sty addrbuf
	sta addrbufh
readboot_jsr
	jsr readsect-page2+$C100	; the routine is not in its final location yet, so...
	bne reloadboot
	jmp all_start

step_in
	ldy #$58
	bit machine_type
	bvs microdisc_command
	bvc jasmin_command

buf_readsect                ; read a sector in my buffer
	ldy #<(buf)
	sty addrbuf
	lda #>(buf)
	sta addrbufh
	jsr readsect
	bne buf_readsect    ; minimal error handling, retry forever until it works
	rts

readsect
	ldx sector
	lda side
	ldy #$80			; read command
	bit machine_type
	bvc readsect_jasmin
	asl
	asl
	asl
	asl
	ora #$85
	sta $0314
	
    .dsb 3-(*&3),$ea	; align the FDC writes for the Telestrat
write_FDC_sector_reg
	stx FDC_sector
	nop
	nop
microdisc_command
	sta FDC_data
	nop
	nop
	sty FDC_command
; tya
; lsr
; lsr
; lsr
; lsr
; ora #$30
; jsr trace-page2+$C100
	ldy #0
	cli
waitdrq
	lda $0318
	bmi waitdrq
	lda FDC_data
	sta (addrbuf),y
	iny
	bne waitdrq
	inc addrbufh
	bne waitdrq
	beq waitdrq

irq_handler
	pla
	pla
	pla
	lda FDC_status
; ora #$40
; jsr trace-page2+$C100
	and #$1C
	rts

readsect_jasmin
	sta $03f8
	stx $03f6
jasmin_command
	sta $03f7
	sty $03f4
	ldy #4
	dey
	bne *-1
waitnotbusy
	ldx $03f4
	stx status
	lsr status
	bcs waitnotbusy
	txa
	and #$1C
	rts

irq_jasmin
	lda $03f7
	sta (addrbuf),y
	iny
	bne *+4
	inc addrbuf+1
	rti

    .dsb page2+254-*
	.byt $55,$AA

 
