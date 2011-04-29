#define FINAL_ADRESS $a000+50*40
;c000

_Reloc
;BreakPointjmp BreakPoint

     sei               ; No interruptions

     lda #$60     ; RTS Opcode
     sta $00          ; Write in $00 Page => take one less byte
LABEL=*+2
     jsr $0000     ; JSR on the RTS immediately return.
_BEGIN_COPY_
     tsx               ; Get stack offset
     dex
     clc
     lda $0100,x     ; Get LOW adress byte
     adc #<(_END_COPY_-_BEGIN_COPY_+1)
     sta $00
     lda $0101,x     ; Get HIGH adress byte
     adc #>(_END_COPY_-_BEGIN_COPY_+1)
     sta $01

     ; Now $00 and $01 contain the adress of LABEL
     ; We can now copy the whole code to it's new
     ; location
     ldy #0
copy_loop
     lda ($00),y
     sta FINAL_ADRESS,y
     iny
     cpy _END_-_BEGIN_
     bne copy_loop

     jmp FINAL_ADRESS
_END_COPY_


; Here is some code compiled at a fixed
; adress in memory.

     *=FINAL_ADRESS

_BEGIN_

/*                                  ICI loading du loader en RAM VIA le Boot sector      */

#include<asm2k2.h>


#define FDC_command	$0310
#define FDC_status	$0310
#define FDC_track	$0311
#define FDC_sector	$0312
#define FDC_data	$0313
#define MICRODISC	$0314

#define first_sect		17	; number of sectors before the progs on side 1
#define track_loader 0
#define sector_loader 5

;*=$b902
;Boot sector !!!
Initialize
;	sei ; IRQ déjà annulée en haut

_init_disk

	ldy #<(irq_handler)
	lda #>(irq_handler)
	sty $fffe
	sta $ffff

	lda #$7F
	sta $030D ; Lock VIA IRQ
/*VIP4 Boot sector !*/

load_prog
	lda #sector_loader ; First sector for the loader
	sta FDC_sector ; on set le secteur
	sta sect_low ; for count


loader
	lda #nb_sectors_loader ; nb of page à charger
	sta pages ; Fpor count
start_read
	jsr sectread
load_prog_ok
	sei
	lda #%10000001 ; Read finished stop FDC
	sta $0314
	jmp location_loader ; execute the prgm


/*Lecture************************************************************/

readlinsect


	ldx #track_loader ; We get the track of the loader
	cpx FDC_track ; Is it the current track ?

	beq set_sector ; Yes we set sector now !
	stx FDC_data ; On  force la track à changer

wait_drive2
	lda $318 ; We are waiting for the drive maybe not useful if drive is ready after the eprom boot
	bmi wait_drive2

	lda #$1F ; ordre de chgt de track
	sta FDC_command
	jsr wait_completion ; We are waiting for FDC


set_sector

	lda sect_low
	sta FDC_sector ; on set le secteur

	; Interdire les IRQ du fdc ICI !
	lda #%10000101 ; on force les le Microdisk en side0, drive A ... Set le bit de données !!!
	sta MICRODISC



	lda #$80 ; Demande de lecture #80

command
	sta FDC_command

waitcommand_again
	ldy #wait_status_floppy
waitcommand
	nop ; Not useful but for old Floppy drive maybe
	nop ; Not useful but for old Floppy drive maybe
	dey

	bne waitcommand

readwrite_data

read_sector
	ldy #0
microdisc_read_data
	lda $0318
	bmi microdisc_read_data
	lda $0313
page_to_load
	sta location_loader,y
page_to_load2

	iny
	bne microdisc_read_data
	lda FDC_status
	and #$1C

	rts


/*Lecture du secteur !*/
sectread
	ldy #4
	sta retry
sectreadloop

readretryloop
	jsr readlinsect ; on lit le secteur
	beq sector_OK
	dec retry
	bne readretryloop
sector_OK
	inc sect_low ; on avance le ptr de secteur
	inc page_to_load+2
	dec pages
	bne sectreadloop

	rts

wait_completion
	ldy #4
r_wait_completion
	dey
	bne r_wait_completion
r2_wait_completion
	lda $0310
	lsr
	bcs r2_wait_completion
	asl
	rts

irq_handler
	pla		; get rid of IRQ context
	pla
	pla
	lda #%10000001
	sta $0314	; disables disk irq
	lda $0310	; gets status and resets irq
	and #$7c
	rts


sect_low
	.byt  0
pages
	.byt  0
retry
	.byt  0

_END_
