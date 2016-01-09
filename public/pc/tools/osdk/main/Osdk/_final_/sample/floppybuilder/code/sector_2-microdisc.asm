;
; This part of the code is a bit tricky: Basically the Atmos with Microdisc and the Telestrat despite using a similar boot 
; loading system are actually loading the boot sector at different addresses.
;
; Since the 6502 is not particularly well equiped to handle code that can be loaded at any address we had to find a trick.
; What we are doing is to make the code run at a particular address, and have a small module that makes sure that it is
; moved at the correct place wherever it was loaded in first place. That makes the code a lot easier to write :)
;
; Warning: This whole code CANNOT be more than 256 bytes (ie: the size of the sector)
;
; The bootloader will be placed in the screen area because we know that this is not going to be used by the operating system.
; By chosing an address in HIRES area, we also guarantee that it will not be visible on the screen (the Oric boots in TEXT).
;
//#define FINAL_ADRESS 	$a000+50*40
#define FINAL_ADRESS	$9800			; First 256 bytes of the STD charset are invisible


#define OPCODE_RTS				$60

#define MICRODISC_LOADER
#include "disk_info.h"

	.zero
	
	*=$00
	
retry_counter		.dsb 1	; Number of attempts at loading data (ie: not quite clear what happens when this fails...)
	

	.text

	;
	; These are the 23 header bytes that goes before the actual executable part of the bootsector
	;
	.byt $00,$00,$FF,$00,$D0,$9F,$D0,$9F,$02,$B9,$01,$00,$FF,$00,$00,$B9,$E4,$B9,$00,$00,$E6,$12,$00

	.text

	;
	; Here starts the actual executable part, maximum available size is 233 bytes (256-23)
	;

	;
	; Try to find the load address
	;
	sei               	; Disable interruptions

	lda #OPCODE_RTS
	sta $00          	; Write in $00 Page => take one less byte
	jsr $0000     		; JSR on the RTS immediately return.

	;
	; Compute the absolute address of where the code we want to copy begins,
	; and save it in zero page ($00 and $01)
	;	
_start_relocator_
	tsx               	; Get stack offset
	dex
	clc
	lda $0100,x     	; Get LOW adress byte
	adc #<(_end_relocator_-_start_relocator_+1)
	sta $00
	lda $0101,x     	; Get HIGH adress byte
	adc #>(_end_relocator_-_start_relocator_+1)
	sta $01

	; Now $00 and $01 contain the adress of LABEL
	; We can now copy the whole code to it's new
	; location
	ldy #0
copy_loop
	lda ($00),y  
	sta FINAL_ADRESS,y
	iny
	cpy #(_END_-_BEGIN_)
	bne copy_loop
	
	jmp FINAL_ADRESS
_end_relocator_


;
; Here is some code compiled at a fixed adress in memory.
;

     *=FINAL_ADRESS

_BEGIN_
	;
	; Switch to HIRES
	;
	ldy #39 			; From $9900 to $c000 is 39 pages (9984 bytes)
	lda #0
loop_hires_outer	
	tax
loop_hires_inner
__auto_hires
	sta $9900,x
	inx
	bne loop_hires_inner
	inc __auto_hires+2
	dey
	bne loop_hires_outer

	lda #30				; Write hires switch
	sta $bfdf


	;
	; Read sector data
	; 
	ldy #4
	sty retry_counter
read_sectors_loop

readretryloop
	nop
	nop
	nop
	
read_one_sector
	;
	; Check if we are on the correct track already and if not
	; then send a SEEK command to the FDC to move the head to
	; the correct track.
	;
	ldx #loader_track_position
	cpx FDC_track_register
	beq track_ok
	
	; Write the track number in the FDC data register
	stx FDC_data

wait_drive2
	lda FDC_drq 				; We are waiting for the drive maybe not useful if drive is ready after the eprom boot
	bmi wait_drive2
	
	;
	; Send a SEEK command (change track)
	;
	lda #CMD_Seek
	sta FDC_command_register
	; 
	; Command words should only be loaded in the Command Register when the Busy status bit is off (Status bit 0). The one exception is the Force Interrupt command. 
	; Whenever a command is being executed, the Busy status bit is set. 
	; When a command is completed, an interrupt is generated and the busy status bit is reset. 
	; The Status Register indicates whethter the completed command encountered an error or was fault free. For ease of discussion, commands are divided into four types (I, II, III, IV).
	ldy #4
r_wait_completion
	dey
	bne r_wait_completion
r2_wait_completion
	lda FDC_status_register
	lsr
	bcs r2_wait_completion
	asl

track_ok	

	; Write the sector number in the FDC sector register
__auto__sector_index
	lda #loader_sector_position
	sta FDC_sector_register ;
	
	; Interdire les IRQ du fdc ICI !
	;lda #%10000101 			; on force les le Microdisk en side0, drive A ... Set le bit de données !!!
	lda #%10000100 			; on force les le Microdisk en side0, drive A ... Set le bit de données !!!
	sta FDC_flags
			
	;
	; Send a READSECTOR command
	;
	lda #CMD_ReadSector
	sta FDC_command_register

	ldy #wait_status_floppy
waitcommand
	nop 					; Not useful but for old Floppy drive maybe
	nop 					; Not useful but for old Floppy drive maybe
	dey	
	bne waitcommand

	;
	; Read the sector data
	;
	ldy #0
fetch_bytes_from_FDC
	lda FDC_drq
	bmi fetch_bytes_from_FDC
	lda FDC_data
__auto_write_address
	sta location_loader,y

	iny
	bne fetch_bytes_from_FDC
	; Done loading the sector
	
	lda FDC_status_register
	and #$1C
		
	beq sector_OK
	dec retry_counter
	bne readretryloop
	
sector_OK
	inc __auto__sector_index+1
	inc __auto_write_address+2
	dec sector_counter
	bne read_sectors_loop

	;
	; Data successfully loader (we hope)
	;
	sei
	lda #%10000001 			; Disable the FDC (Eprom select + FDC Interrupt request)
	sta FDC_flags
	
	ldx #FDC_OFFSET_MICRODISC
	jmp location_loader


sector_counter		.byt (($FFFF-location_loader)+1)/256


_END_



; Type I commands
; 	The type I commands include the Restore, Seek, Step, Step-In and Step-
; 	Out commands. Each of the Type I commands contains a rate field r1 r0
; 	which determines the stepping motor rate.
; 		r1 r0 Stepping rate
; 		 0  0    6 ms
; 		 0  1   12 ms
; 		 1  0   20 ms
; 		 1  1   30 ms
; 	An optional verification of head position can be performed by settling
; 	bit 2 (V=1) in the command word. The track number from the first
; 	encountered ID Field is compared against the contents of the Track
; 	Register. If the track numbers compare (and the ID Field CRC is correct)
; 	the verify operation is complete and an INTRQ is generated with no
; 	errors. 
; 	
; Seek
; 	This command assumes that the Track Register contains the track number
; 	of the current position of the head and the Data Register contains the
; 	desired track number. The FD179X will update the Track Register and
; 	issue stepping pulses in the appropriate direction until the contents of
; 	the Track Register are equal to the contents of the Data Register. An
; 	interrupt is generated at the completion of the command. Note: when
; 	using multiple drives, the track register must be updated for the drive
; 	selected before seeks are issued.

; 
; Type II commands
; 	Type II commands are the Read Sector and Write Sector commands. Prior
; 	to loading the Type II command into the Command Register, the computer
; 	must load the Sector Register with the desired sector number. Upon
; 	receipt of the Type II command, the busy status bit is set. The FD179X
; 	must find an ID field with a matching Track number and Sector number,
; 	otherwise the Record not found status bit is set and the command is
; 	terminated with an interrupt. Each of the Type II commands contains an
; 	m flag which determines if multiple records (sectors) are to be read or
; 	written. If m=0, a single sector is read or written and an interrupt is
; 	generated at the completion of the command. If m=1, multiple records are
; 	read or written with the sector register internally updated so that an
; 	address verification can occur on the next record. The FD179X will
; 	continue to read or write multiple records and update the sector
; 	register in numerical ascending sequence until the sector register
; 	exceeds the number of sectors on the track or until the Force Interrupt
; 	command is loaded into the Command Register. The Type II commands for
; 	1791-94 also contain side select compare flags. When C=0 (bit 1), no
; 	comparison is made. When C=1, the LSB of the side number is read off the
; 	ID Field of the disk and compared with the contents of the S flag.
; 
; Read Sector
; 	Upon receipt of the command, the head is loaded, the busy status bit set
; 	and when an ID field is encountered that has the correct track number,
; 	correct sector number, correct side number, and correct CRC, the data
; 	field is presented to the computer. An DRQ is generated each time a byte
; 	is transferred to the DR. At the end of the Read operation, the type of
; 	Data Address Mark encountered in the data field is recorded in the
; 	Status Register (bit 5).
; 


/*
From: http://www.metabarn.com/v1050/docs/v1050_ProgTechDoc.txt

During a command which performs a data transfer such as diskette
read or write, data must be read from or written to the diskettes
byte-byâ€”byte via the Z-80A. This can be done either by polling
the WD1793 data request bit (DRQ, status bit 1) or by the DRQ
interrupt. Reading or writing the data register will reset both
the DRQ bit and interrupt. The total time between byte transfers
is 23 microseconds for 5" double density or 8" single density;
the polling loop or interrupt service routine must be shorter
than this to insure that no bytes are lost.

The diskette motors are turned on by resetting bit 6 of port A of
the miscellaneous 8255, and turned off by setting the same bit.
Our BIOS code turns the motors on, then leaves them on for two
seconds to save time in the case of multiple disk accesses.
After turning on the motors, you must wait 800 ms. to be sure
that the drives are up to speed before attempting to transfer
data. The Ready input of the WD1793 is supplied from pin 34 of
the drive interface; it indicates that the drive is loaded and
has made at least one revolution at > 50% of normal speed. Note
that the drive looks at the index pulse for this; if a hard-
sectored disk is inserted the results are invalid.

The reset line of the WD1793 is held in the reset mode by
hardware at power-on. A timing restriction is inherent in the
WD1793: after writing a command, the Z-80A must not read the
status register for 28 microseconds.

*/
