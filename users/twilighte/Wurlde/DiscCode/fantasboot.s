;Fantasmagoric boot sector (512 Bytes)
#define machine_type 	0
#define tmp		1

; definitions
#define buf 		$A200
#define FDC_command	$0300
#define FDC_status	$0300
#define FDC_track	$0301
#define FDC_sector	$0302
#define FDC_data	$0303

 .zero
*=$40

 page 		.dsb 1 ; temporary variables in page 0
 nbsect 	.dsb 1
 addrbuf 	.dsb 1
 addrbufh  	.dsb 1
 sector		.dsb 1
 side 		.dsb 1
 type 		.dsb 1
 fdc_offset 	.dsb 1

 .text


; this allows load_addr to be in $9fd0, see below
;9fd0-11
*=$9fc5

page1
; first page of the Fantasmagoric boot sector, containing
; - Microdisc and Cumana "boot" sector (system parameters)
; - OricDos directory
; - OricDos and Cumana "system", in record format


; Microdisc wants this to be not null (# of tracks)
; this is also used as the track of the next directory sector
; and also the track of the next sector of the loaded file
off_00
 .byt 40

; next directory sector, and also next sector of file
; a 0 value means no next sector
off_01
 .byt 0

; only one entry in this directory
off_02
 .byt 1

; skip this directory entry (things are too intricated here)
; record header
off_03
 .byt 0

; where to load this record
off_04
 .byt <load_addr,>load_addr

off_06
 .byt <last,>last

; this should be the exec addr, but it is copied elsewhere and
; gets overriden by second page of the sector
off_08
 .byt 0,0

; record size
off_0A
 .byt last - load_addr

load_addr ; load_addr=$9fd0, thus the copyright message starts now (empty)

; Bios Parameter Block for the PC starts here but MSDOS and Windows don't seem
; to use it anymore, and seem to rely on the type byte found in the FAT

; microdisc copyright message is copied from here to the status line
off_0B
 .byt 0

off_0C
 .byt 0

; cumana copyright message is copied from here to the status line
off_0D
 .byt 0

off_0E
 .byt 0,0

; OricDos parameters - first free sector location, but copied to the second part
off_10
 .byt 0,0

; OricDos parameters - directory sector #
off_12
 .byt 1

; OricDos parameters - directory track #
; OricDos directory - 0 means skip this directory entry (things are way too intricated here !)
off_13
 .byt 0

; OricDos parameters - # of free sectors, copied to the second part
off_14
 .byt 0,0

; OricDos parameters - # of used sectors, copied to the second part
off_16
 .byt 1,0

off_18
 .byt 0,0

off_1A
 .byt 0,0

; definition tables for floppy types 720KB, 180KB, 360KB
; a third table (dataside) use the OricDos directory entry just below
dirsect
 .byt 8,6,6

datasect
 .byt 6,1,4
 .byt 0

; here we are more comfortable to store an OricDos directory entry
off_23
 .byt "Boot  3.0"

; this saves some place since table is 1,0,1

; BOOT is 1 sector
dataside
 .byt 1

; it starts at track 0 sector 1
 .byt 0,1

; so it ends at same sector
 .byt 0,1

; flags
 .byt 0,$80

; let's start some code at last

microdisc_start
	sei
	ldx #0
microdisc_move ; copy the second part of the sector
	lda $C123,x ; which has not been transfered by the eprom code
	sta page2,x
	inx
	bne microdisc_move
	lda #$40
	sta machine_type ; flag a microdisc controller
	ldx #$10
	stx fdc_offset
	lda #$84
	sta $0314 ; switch to overlay ram, disables FDC interrupts, disables EPROM

all_start ; here is the common code for all machine types
	lda #$7F
	sta $030E ; disables VIA interrupts
	ldx #2 ; first FAT sector
	stx sector
	lda #0
	sta side
	jsr buf_readsect ; get it in buffer

***
	;The above has loaded sector 2 into FD00
	jmp $FE09

***


	lda buf ; floppy type
	sec
	sbc #$F9
.(
	beq skip1
	sbc #2
	sta type ; now we have types 0 (720KB), 1 (180KB) , 2 (360KB)
skip1	tax
.)
	jsr search_system

	lda buf+$1C,x ; compute the number of sectors used, minus 1 (the first one)
	sec
	sbc #1
	lda buf+$1D,x
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
	jsr step_in ; if it's on side 0 (180KB floppy), it's on track 1

loadfirst ; load first data sector
	jsr buf_readsect

	sec ; initialize transfer address
	lda buf+1
	sbc #5
	sta addrbuf
	lda buf+2
	sbc #0
	sta addrbufh
	sta page

	ldy #5 ; and transfer the first sector (except first 5 bytes)
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

nextsect ; compute next sector
	ldx sector
	inx
	cpx #10 ; # of sectors per track
	bne readnext
	inc side
	ldx type
	lda dataside,x ; 1 if double-sided disk, 0 if single_sided
	cmp side
	bcs readnext
	jsr step_in
	ldx #0
	stx side
	inx

readnext ; read next sector
	stx sector
	inc page
	inc page
.(
loop1	lda page
	sta addrbufh
	jsr readsect
	bne loop1
.)
	dec nbsect
	bne nextsect

	lda machine_type
	jmp ($A203) ; start the system

last
 .byt 0


; second part (offsets $100-$1ff) of the fantasmagoric boot sector, this contains -
; - boot for Telestrat
; - boot for Jasmin
; - values overriding Microdisc and Cumana variables due to a sector too big

; we are at offset $100 from the beginning
;page1+$100
; .dsb 256-(*&255)
 .dsb $C4-$a9,0
;*=$A0C5
page2

; Jasmin loads the boot sector in $0400, Telestrat loads it in $C100.
; both Telestrat and Jasmin override first page of the sector with second page.
; Jasmin starts exec at offset 0,
; Telestrat has a five byte header and starts exec at offset 5.

; Telestrat needs 0 at offset 0 for a bootable disk
; Microdisc system parameter copy - first free sector being 0 means no sector (lucky me)
; Jasmin interprets this instruction as BRK #9, hopefully no harm is done
 .byt 0

; Telestrat - # of sectors per track
; Microdisc system parameter copy - track # of the first free sector (none, see above)
 .byt 9

; Telestrat takes here the number of sectors of the DOS to load
; Microdisc system parameter copy - directory sector (lucky again)
; Jasmin interprets this instruction as ORA (00,X), again no harm is done
 .byt 1

; Telestrat - LSB of DOS loading address, one dummy sector will be read there only
; Microdisc system parameter copy - directory sector (lucky again)
 .byt 0

; Telestrat - MSB of DOS loading address, chosen for the Jasmin usage below
; Jasmin interprets this instruction as a BIT nnnn so it skips the following instruction
; Microdisc system parameter copy - LSB of # of free sectors (can't be always lucky)
 .byt $2C
umm1	beq telestrat_start
; flag Z is set when the telestrat does JSR $C105
; Microdisc system parameter copy of # of free and used sectors are wrong, hard to do better
umm2	beq jasmin_start
; at last we can take control on the Jasmin

; this matching pattern overrides the one at $C12C on Microdisc
; Cumana cannot use a matching pattern with wildcards here
off_109
 .byt "Boot 3.0"

; this space could be used for my local variables in the future
;reserve 6
 .byt 0,0,0,0,0,0

off_117
 .byt 6

; this byte ($C12B) on the microdisc is copied to $C000
off_118
 .byt 0
 .byt $FF

; this space could be used for my local variables in the future
;reserve 2
 .byt 0,0

; this byte ($C13F) on the microdisc is tested against 0
off_11C
 .byt 0

; this space could be used for my local variables in the future
;reserve 11
 .byt 0,0,0,0,0,0,0,0,0,0,0

; this word ($C14B) is used as exec addr for microdisc
off_128
 .byt <microdisc_start,>microdisc_start

; this word ($C14D) is used as exec addr for cumana
off_12A
 .byt <microdisc_start,>microdisc_start

jasmin_start
	sta $03FB ; 0-ROMDIS selects ROM
	bit $FFFC
	bmi atmos
	jsr $F888
	bne thingy
atmos	jsr $F8B8
	ldy #1
thingy	sty $03FA ; 1-ORMA selects overlay ram
	lda #4 ; we are curently running in page 4
	sta readboot_jsr+2-page2+$400 ; so, adjust the JSR address
	ldy #$20 ; flag a Jasmin controller
	ldx #$F4 ; FDC location in page 3
	bne half_sector_only

telestrat_start
	lda #$7F
	sta $032E ; disable VIA2 interrupts
	sta $031D ; disable ACIA interrupts too
	lda $031D ; clear ACIA interrupt in case...

	ldy #$C0 ; flag Telestrat hardware and Microdisc hardware
	ldx #$10 ; FDC location in page 3

half_sector_only ; load the full boot sector, we only have one half for now !
	sei
	sty machine_type
	stx fdc_offset
	ldx #1 ; sector 1
	stx sector
	dex
	stx side ; side 0

reloadboot
	ldy #<page1
	lda #>page1
	sty addrbuf
	sta addrbufh
readboot_jsr
	jsr readsect-page2+$C100 ; the routine is not in its final location yet, so...
	bne reloadboot
	jmp all_start

buf_readsect ; read a sector in my buffer
	ldy #<buf
	sty addrbuf
	lda #>buf
	sta addrbufh
	jsr readsect
	bne buf_readsect ; minimal error handling, retry forever until it works
	rts


readsect
	ldx fdc_offset
	lda side
	bit machine_type
	bvc select_side
	asl
	asl
	asl
	asl
	ora #$84
select_side
	sta $0304,x

	lda sector
	sta FDC_sector,x

	lda #$84
	bne command

step_in
	ldx fdc_offset
	lda #$5B

command
	sta FDC_command,x
	ldy #4
.(
loop1	dey
	bne loop1
.)
	beq wait_command_end

get_data
	lda FDC_data,x
	sta (addrbuf),y
	iny
	bne wait_command_end
	inc addrbufh

wait_command_end
	lda FDC_status,x
	and #3
	lsr
	bne get_data
	bcs wait_command_end
	lda FDC_status,x
	and #$1C
	rts

search_system
	lda dirsect,x ; get the first directory sector
	sta sector

	jsr buf_readsect


	ldy #11

compare_name
	rts
;	lda buf,x
;	cmp dos_name,y
;	bne next_name
;	dex
;	dey
;	bpl compare_name
;	iny
;	beq found_name
;	rts
;
;
;cluster_to_physical
;	ldx #$ff
;
;compute_cylinder
;	;A/__sectors_per_cyl
;	inx
;	sec
;	sbc #01	;__sectors_per_cyl
;	bcs compute_cylinder
;	dey
;	bpl compute_cylinder
;	adc #01	;__sectors_per_cyl
;
;;	stx __cylinder
;	nop
;	nop
;
;	ldy #0
;	cmp #17	;__sectors_per_track
;	bcc store_side
;	iny
;	sbc #17	;__sectors_per_track
;store_side
;
;;	sty __side
;	nop
;	nop
;
;	tay
;	iny
;
;;	sty __sector
;	nop
;	nop
;
;	rts
;*=$A1C4
 .dsb $C3-$96,0
; .dsb 256-(*&255)
; thus we have a full 512-bytes loader
end_of_sector
	rts
