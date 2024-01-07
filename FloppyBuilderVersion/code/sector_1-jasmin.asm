;
; This is the bootsector for the Jasmin drives.
; No particular magic to do here, all the versions of the Jasmin system load the boot sector in page 4,
; so we can just assemble the bootsector code using $400 as the base address
;
; Warning: This whole code CANNOT be more than 256 bytes (ie: the size of the sector)

; FDC registers
#define FDC_command_register    $03f4
#define FDC_status_register     $03f4
#define FDC_track_register      $03f5
#define FDC_sector_register     $03f6
#define FDC_data                $03f7
#define FDC_flags               $03f8	; Only bit 0: side select
; DRQ is not readable in any address other than corresponding bit (1) in STATUS register
;#define FDC_drq                $03FC 	

#define FDC_ovl_control         $03FA
#define FDC_rom_control         $03FB

; I am not sure why the Read Sector command is here $8c instead of $80
; with flags S and E active, but C kept inactive:
; 	C	Side Compare Flag (0: disable side compare, 1: enable side comp)
;	E	15 ms delay (0: no 15ms delay, 1: 15 ms delay)
;	S	Side Compare Flag (0: compare for side 0, 1: compare for side 1)
; True that in 1772 FDD from WD these bits are (for a READ SECTOR command) C=0, E and H:
;	H 	Motor On Flag (Bit 3) 1=Enable Spin-up Sequence
; so maybe they are trying to add 15ms of delay and enabling the spin-up sequence, but
; the Jasmin has a 1773, not a 1772.
#define CMD_ReadSector          $8c
#define CMD_Seek                $1F


#include "../build/floppy_description.h"       ; This file is generated by the floppy builder

; Some information from the Oric Hardware Programming Guide (http://oric.free.fr/programming.html#disc)
; The FDC 1793 (or 1773) is accessible through locations [...] 03F4-03F7 in Jasmin's electronics.
; Jasmin's electronics also features buffers for side/drive selecting, and memory signals, 
; but the DRQ line is connected to the system IRQ line so it allows for interrupt-driven transfers 
; (however, two consecutives bytes are separated by 31.25 micro-seconds, so the interrupt routine 
; has to be fast ! As an example, FT-DOS uses a dedicated interrupt routine, and does not even have 
; time to save registers: the interrupt routine lasts 28 cycles) The end of a command has to be 
; detected by reading the busy bit of the Status Register of the FDC.
; location 03F8 -> bit 0: side select 
; location 03F9 : disk controller reset (writing any value will reset the FDC) 
; location 03FA -> bit 0: overlay ram access (1 means overlay ram enabled) 
; location 03FB -> bit 0: ROMDIS (1 means internal Basic rom disabled) 
; locations 03FC, 03FD, 03FE, 03FF : writing to one of these locations will select the corresponding drive 

    .zero
    
    *=$00
    
retry_counter		.dsb 1	; Number of attempts at loading data (ie: not quite clear what happens when this fails...)	
    
    .text
    
    *=$400
    
    jmp JasminStart ;.byt $01,$00,$00
    .byt $00,$00,$00,$00,$00,$20,$20,$20,$20,$20,$20,$20,$20
    .byt $00,$00,$03,$00,$00,$00,$01,$00,$53,$45,$44,$4F,$52,$49,$43,$20
    .byt $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
    .byt $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
    
JasminStart
    ;
    ; Here starts the actual executable part, maximum available size is 233 bytes (256-23)
    ;
    
    sei               	; Disable interruptions
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
    ; Enable Overlay ram
    lda #1
    sta FDC_ovl_control ; Enable Overlay
    lda #1
    sta FDC_rom_control ; Disable ROM
    
    
    ;
    ; Read sector data
    ; 
    ldy #4
    sty retry_counter
read_sectors_loop

readretryloop    
    ;
    ; Check if we are on the correct track already and if not
    ; then send a SEEK command to the FDC to move the head to
    ; the correct track.
    ;
    ldx #FLOPPY_LOADER_TRACK
    cpx FDC_track_register
    beq track_ok
    
    ; Write the track number in the FDC data register
    stx FDC_data
        
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
    ldy #5
r_wait_completion
    dey
    bne r_wait_completion
r2_wait_completion
    lda FDC_status_register
    lsr
    bcs r2_wait_completion

track_ok	
    ; This was needed for real Microdisc, I copied it here
    ; Chema: Here is the thing... the COLOR macro takes 14 cycles...
    ; This one is a bit longer
    ldy #3
waitcommand
    dey	;2
    bne waitcommand;2+1
    ; = 16 cycles
    ; Write the sector number in the FDC sector register
__auto__sector_index
    lda #FLOPPY_LOADER_SECTOR
    sta FDC_sector_register
    
    ;
    ; Send a READSECTOR command
    ;
    lda #CMD_ReadSector
    sta FDC_command_register
    
    ; Chema: this loop is needed if checking for partial
    ; loading of a sector, as we cannot check the STATUS
    ; directly after issuing a command. 
    ; Fabrice provided this table and the code, which takes 21 cycles+extra (ldy beq lda):
    ; Operation	Next Operation	Delay required (MFM mode)
    ; Write to Command Reg.	Read Busy Bit (bit 0)	24 msec
    ; Write to Command Reg.	Read Status bits 1-7	32 msec
    ; Write Register	Read Same Register	16 msec
    ldy #4	
tempoloop 
    dey	
    bne tempoloop 	
    
    ;
    ; Read the sector data
    ;
    ldy #0
    beq waitdrq
checkbusy	
    bpl end_of_command
waitdrq	
    lda FDC_status_register
    lsr
    ror
    bcc checkbusy
    lda FDC_data
__auto_write_address
    sta FLOPPY_LOADER_ADDRESS,y
    
    iny
    jmp waitdrq
end_of_command	
    
    and #($3C>>2)
        
    beq sector_OK
    dec retry_counter
    bne readretryloop
    
sector_OK
    inc __auto__sector_index+1
    inc __auto_write_address+2
    dec sector_counter
    bne read_sectors_loop
    
    ;
    ; Data successfully loaded (we hope)
    ;
    sei
    ;lda #%10000001 			; Disable the FDC (Eprom select + FDC Interrupt request)
    ;sta FDC_flags
    ; That was for Microdisc. In Jasmin it does not work this way.
    ; We can enable overlay ram by writing 1s in bit 0 of 
    ; FDC_ovl_control ($03FA) and FDC_rom_control ($03FB) but these have already been
    ; set, and disk side (which accessible in FDC_flags) and drive are correct. Else, how did this boot?
    ; There is no way to disable IRQs, but only DRQ issues them, so we need to keep interrupts disabled while
    ; reading/writing data (as done above).
    
    ldx #1                      ; 1 = Jasmin initialisation code
    jmp FLOPPY_LOADER_ADDRESS
    
sector_counter      .byt (($FFFF-FLOPPY_LOADER_ADDRESS)+1)/256

_END_

