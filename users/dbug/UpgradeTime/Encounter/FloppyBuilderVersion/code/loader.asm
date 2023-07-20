;
; Based on the loader version modified by Chema and Fabrice used in Blake's 7
; This version has the following changes:
; - Uses the Telestrat align macros to compensate for the Telestrat hardware controler bugs
; - Fixed Jasmin implementation
; - Support for saving files
;
#define OPCODE_RTS              $60
#define OPCODE_JMP              $4C

; These macros aling code to avoid the Telestrat bug
; It seems that maybe older Microdisc units have the
; same bug, so it is safer to keep them on.
; The thing is that the instruction following an access to an
; FDC register must have the lower two bits (0,1) with the same
; value as the register address.
; Access length is 3 bytes (e.g. lda FDC_Status), so alignmets of
; accesses must be:
; FDC Register		Memory address	Alingmment of access instruction
; Status/Cmd	(00)	$0310		xxxxxx01
; Track 	(01)	$0311		xxxxxx10
; Sector 	(10)	$0312		xxxxxx11
; Data	 	(11)	$0313		xxxxxx00
; Two versions: 
;  - PROTECT(X) aligns an access to FDC register X, made following the macros.
;  - PROTECT2(X,Y) same but the instruction is Y bytes ahead.
;
#define TELESTRAT_ALIGN
#ifdef TELESTRAT_ALIGN
#define PROTECT(X)  	.dsb (((X)&3)-((*+3)&3))&3,$ea
#define PROTECT2(X,Y)	.dsb (((X)&3)-((*+(Y)+3)&3))&3,$ea
#else
#define PROTECT(X)
#define PROTECT2(X,Y) 
#endif

;
; VIA registers definition
;
#define via_portb   $0300
#define via_ddrb    $0302
#define via_ddra    $0303
#define via_t1cl    $0304
#define via_t1ch    $0305
#define via_t1ll    $0306
#define via_t1lh    $0307
#define via_t2ll    $0308
#define via_t2ch    $0309
#define via_sr      $030a
#define via_acr     $030b
#define via_pcr     $030c
#define via_ifr     $030d
#define via_ier     $030e
#define via_porta   $030f


;
; Microdisc FDC register access addresses
;
#define FDC_command_register    $0310
#define FDC_status_register     $0310
#define FDC_track_register      $0311
#define FDC_sector_register     $0312
#define FDC_data                $0313

; On Microdisc, location $314 contains the following flags on write operations
; bit 7: Eprom select (active low) 
; bit 6-5: drive select (0 to 3) 
; bit 4: side select 
; bit 3: double density enable (0: double density, 1: single density) 
; bit 2: along with bit 3, selects the data separator clock divisor            (1: double density, 0: single-density) 
; bit 1: ROMDIS (active low). When 0, internal Basic rom is disabled. 
; bit 0: enable FDC INTRQ to appear on read location $0314 and to drive cpu IRQ	
; and $0318 bit 7 contains the state of DRQ

#define FDC_flags               $0314
#define FDC_drq                 $0318

#define FDC_Flags_Mask          %10000100       ; Disable ROM/EPROM, no FDC interrupt requests, A drive, Side 0
#define FDC_Flag_DiscSide       %00010000       ; Accesses second side of the disk

;		COMMAND SUMMARY (models 1791, 1792, 1793, 1794)
;
;	Type Command                 b7 b6 b5 b4 b3 b2 b1 b0
;	  I  Restore                  0  0  0  0  h  V r1 r0
;	  I  Seek                     0  0  0  1  h  V r1 r0
;	  I  Step                     0  0  1  T  h  V r1 r0
;	  I  Step-In                  0  1  0  T  h  V r1 r0
;	  I  Step-Out                 0  1  1  T  h  V r1 r0
;	 II  Read Sector              1  0  0  m  S  E  C  0
;	 II  Write Sector             1  0  1  m  S  E  C a0
;	III  Read Address             1  1  0  0  0  E  0  0
;	III  Read Track               1  1  1  0  0  E  0  0
;	III  Write Track              1  1  1  1  0  E  0  0
;	 IV  Force Interrupt          1  1  0  1 i3 i2 i1 i0
;	r1 r0	Stepping Motor Rate
;	V	Track Number Verify Flag (0: no verify, 1: verify on dest track);
;	h	Head Load Flag (1: load head at beginning, 0: unload head)
;	T	Track Update Flag (0: no update, 1: update Track Register)
;	a0	Data Address Mark (0: FB, 1: F8 (deleted DAM))
;	C	Side Compare Flag (0: disable side compare, 1: enable side comp)
;	E	15 ms delay (0: no 15ms delay, 1: 15 ms delay)
;	S	Side Compare Flag (0: compare for side 0, 1: compare for side 1)
;	m	Multiple Record Flag (0: single record, 1: multiple records)
;	i3 i2 i1 i0	Interrupt Condition Flags
;			i3-i0 = 0 Terminate with no interrupt (INTRQ)
;			i3 = 1 Immediate interrupt, requires a reset
;			i2 = 1 Index pulse
;			i1 = 1 Ready to not ready transition
;			i0 = 1 Not ready to ready transition
;	r1 r0 Stepping rate
;	 0  0    6 ms
;	 0  1   12 ms
;	 1  0   20 ms
;	 1  1   30 ms

#define CMD_ReadSector          $80
#define CMD_WriteSector         $a0 
#define CMD_Seek                $1F		; Fabrice uses 1C here (6ms stepping rate), which is faster, but 30ms works with old drives


;
; Jasmin FDC register access addresses
;
#define FDC_JASMIN_command_register  $03f4
#define FDC_JASMIN_status_register   $03f4
#define FDC_JASMIN_track_register    $03f5
#define FDC_JASMIN_sector_register   $03f6
#define FDC_JASMIN_data              $03f7

; In Jasmin there is no location to read DRQ alone.
; The corresponding bit in the status register should be polled.
; DRQ line is connected to the system IRQ line so it allows for 
; interrupt-driven transfers (however, two consecutives bytes are separated by 31.25 micro-seconds)
; - $03F8 bit 0: side select 
; - $03F9 disk controller reset (writing any value will reset the FDC) 
; - $03FA bit 0: overlay ram access (1 means overlay ram enabled) 
; - $03FB bit 0: ROMDIS (1 means internal Basic rom disabled) 
; - $03FC, $03FD, $03FE, $03FF : writing to one of these locations will select the corresponding drive 

#define FDC_JASMIN_flags          $03f8
#define FDC_JASMIN_Flag_DiscSide  %00000001


; I am not sure why the Read Sector command was redefined for Jasmin 
; with flags S and E active, but C kept inactive:
; 	C	Side Compare Flag (0: disable side compare, 1: enable side comp)
;	E	15 ms delay (0: no 15ms delay, 1: 15 ms delay)
;	S	Side Compare Flag (0: compare for side 0, 1: compare for side 1)
; True that in 1772 FDD from WD these bits are (for a READ SECTOR command) C=0, E and H:
;	H 	Motor On Flag (Bit 3) 1=Enable Spin-up Sequence
; so maybe they are trying to add 15ms of delay and enabling the spin-up sequence, but
; the Jasmin has a 1773, not a 1772.

#define CMD_JASMIN_ReadSector			$8c


#include "floppy_description.h"       ; This file is generated by the floppy builder

    .zero
    
    *=LOADER_BASE_ZERO_PAGE

; If you add or remove any variables, make sure that LOADER_BASE_ZERO_PAGE is still correct (defined in the floppy builder script) 	
current_track       .dsb 1      ; Index of the track being loaded
current_sector      .dsb 1      ; Index of the sector being loaded
current_side        .dsb 1      ; Has the bit 4 set to 0 or 1 to be used as a mask on the Microdisc control register (other bits have to be set to zero)

ptr_destination     .dsb 2      ; Destination adress where we depack
ptr_destination_end .dsb 2      ; Point on the end of the depacked stuff
ptr_source_back     .dsb 2      ; Temporary used to hold a pointer on depacked stuff
offset              .dsb 2      ; Used by the LZ depacker
mask_value          .dsb 1      ; Used by the LZ depacker
nb_dst              .dsb 1      ; used by the LZ depacker

    .text
    
    *=FLOPPY_LOADER_ADDRESS

; ------------------------------------------------------------------------------
;                                   Startup section
; ------------------------------------------------------------------------------
;
; This section of the loader can be overwritten after the loader has been installed in memory.
; It contains initialization code that just need to be run once at the start of the application.
; If there are specific initialization, setup of video mode, etc... you need to do, that's the place.
;
; By default the Microdisc/Jasmin setup code is performed here: 
; The code of the loader is setup to load things from a Microdisc, but if we are called with X not null,
; then we patch all the values to replace them by Jasmin equivalents
;
_LoaderTemporaryStart
    sei                             ; Make sure interrupts are disabled
    cld                             ; Force decimal mode
    
    cpx #0                          ; If we are on Jasmin, patch all the FDC related values
    beq end_jasmin_init
    
    lda #<FDC_JASMIN_command_register
    sta 1+__fdc_command_1
    sta 1+__fdc_command_2
    sta 1+__fdc_command_3
    sta 1+__fdc_command_w
    
    lda #<FDC_JASMIN_status_register
    sta 1+__fdc_status_1
    sta 1+__fdc_status_2
    sta 1+__fdc_status_3
    sta 1+__fdc_status_4
    sta 1+__fdc_status_w
    
    lda #<FDC_JASMIN_track_register
    sta 1+__fdc_track_1
    
    lda #<FDC_JASMIN_sector_register
    sta 1+__fdc_sector_1
    
    lda #<FDC_JASMIN_data
    sta 1+__fdc_data_1
    sta 1+__fdc_data_2
    sta 1+__fdc_data_w
    
    lda #<FDC_JASMIN_flags
    sta 1+__fdc_flags_1
    sta 1+__fdc_flags_2
    
    lda #CMD_JASMIN_ReadSector
    sta 1+__fdc_readsector
    
    lda #FDC_JASMIN_Flag_DiscSide
    sta 1+__fdc_discside
    sta 1+__fdc_discside1

end_jasmin_init	
    ldx #$ff	; Reset the stack pointer
    txs
    lda #$ff	; Initialize the VIA to known values (code is from Atmos ROM)
    sta via_ddra
    lda #$f7
    sta via_ddrb
    lda #$b7
    sta via_portb
    lda #$dd
    sta via_pcr
    lda #$7f
    sta via_ier
    lda #$40 
    sta via_acr
    lda #$c0
    sta via_ier
    lda #$10
    sta via_t1ll
    sta via_t1cl
    lda #$27
    sta via_t1lh
    sta via_t1ch

forever_loop
    jsr LoadData		; Load the main game  (parameters are directly initialized in the loader variables at the end of the file)
    cli			; Enable IRQs again	
    jsr _LoaderApiJump 				   ; Give control to the application and hope it knows what to do
    jmp forever_loop
        
    
; -------------------------------------------------------------------------------
;                                   Resident section
; ------------------------------------------------------------------------------- 
;
; This section of the loader stays in memory at all time.
; It contains all the code for loading, saving, as well as memory areas used by the
; API to communicated between the main application and the loader.
;
_LoaderResidentStart

;
; Sets the side,track and sector variables, by using the pair
; track/sector value in the file tables
;
SetSideTrackSector
    lda #FDC_Flags_Mask 		; Disable the FDC (Eprom select + FDC Interrupt request)
__fdc_flags_1
    sta FDC_flags
    
    ; Starting track	
    ldy #%00000000 			; Side 0
    lda _LoaderApiFileStartTrack    ; If the track id is larger than 128, it means it is on the other side of the floppy
    bpl first_side
    ; The file starts on the second side
__fdc_discside1	
    ldy #FDC_Flag_DiscSide	    	; Side 1
    and #%01111111              	; Mask out the extra bit
first_side
    sty current_side
    sta current_track
    
    ; First sector
    lda _LoaderApiFileStartSector
    and #%01111111                  ; Clear out the top bit (compressed flag)
    sta current_sector
    rts

;------------------------------------------
; Commands the floppy drive to
; SEEK for the track/sector
; if current_sector is bigger than
; the sectors per track, it automatically
; changes the track too.
;------------------------------------------
PrepareTrack
    lda current_sector			; Check if we have reached the end of the track
    cmp #FLOPPY_SECTOR_PER_TRACK+1
    bne end_change_track
    
    inc current_track			; Move to the next track
    lda current_track
    cmp #FLOPPY_TRACK_NUMBER
    bne end_side_change
    
    lda #0					; Reset to the first track on the other side
    sta current_track
__fdc_discside
    lda #FDC_Flag_DiscSide
    sta current_side	
end_side_change

    lda #1                                   ; Reset the sector position
    sta current_sector
end_change_track

    lda current_sector			 ; Update sector to read
    PROTECT(FDC_sector_register)
__fdc_sector_1	
    sta FDC_sector_register
    inc current_sector
        
    lda current_track                        ; Check if the drive is on the correct track		
    ; CHEMA: Trying to avoid the Cumulus bug!
    ; Description: Cumulus firmware version 0.5 has a bug in the WRITE_SECTOR command which issues 
    ; an extra DRQ at the end of the sector. This would not be a problem if it emulated properly
    ; the behaviour of the BUSY bit in the STATUS register, but it also doesn't (it is not flagged
    ; at all). As a result a tight loop writting several sectors on the same track may en up here before
    ; the extra DRQ is flagged. As the Track has not changed, this code is skipped and quickly gets
    ; back to the writing loop, which catches this extra DRQ, sending the first byte of the sector, which
    ; is not read by the Cumulus, and gets missed.
    ; Until a new firmware version is released, the only thing we can do is issuing a SEEK command even when
    ; we are on the correct track. As this takes time, a var will be used to flag when this will be done: only
    ; when writing.
    ldy avoid_cumulus_bug
    bne retryseek	
    
    ; If we are already on the correct track, don't issue a SEEK command
    PROTECT(FDC_track_register)
__fdc_track_1
    cmp FDC_track_register
    beq stay_on_the_track
    
    ; Do a SEEK command
retryseek
    PROTECT(FDC_data)
__fdc_data_1	
    sta FDC_data                             ; Set the new track		
    lda #CMD_Seek
    PROTECT(FDC_command_register)
__fdc_command_1
    sta FDC_command_register	
    jsr WaitCompletion			; Wait for the completion of the command
.(
    ; Chema: the same 16 cycle wait as in sector_2-microdisc. I am not sure if this
    ; is needed or why, but it was crucial for the disk to boot in sector_2-microdisc
    ; so no harm if done here again, I guess..
    ldy #3
waitc
    dey	;2
    bne waitc;2+1
    ; = 16 cycles
.)
    ; Added this for reliability
    ; What if there is a seek error???
    ; Do the restore_track0 code
    PROTECT(FDC_status_register)
__fdc_status_3	
    lda FDC_status_register
    and #$18
    beq stay_on_the_track
restore_track0		
    lda #$0c
    PROTECT(FDC_command_register)
__fdc_command_3
    sta FDC_command_register
    jsr WaitCompletion
    PROTECT(FDC_status_register)
__fdc_status_4	
    lda FDC_status_register
    and #$10
    bne restore_track0	; If error restoring track 0 loop forever
    beq retryseek		; Now that track0 is restored, do the seek command again
    
    ; We are now on the track
stay_on_the_track
    lda #FDC_Flags_Mask                      ; Apply the side selection mask
    ora current_side
__fdc_flags_2
    sta FDC_flags
    rts


;---------------------------------------
; Loads data from a file descriptor
; deals with both compressed and
; uncompressed files
; X=File index
;----------------------------------------
LoadData
    ldy #0
    sty __fetchByte+1
    
    ; We have to start somewhere no matter what, compressed or not
    jsr SetSideTrackSector
    
    clc
    lda _LoaderApiAddressLow
    sta ptr_destination+0
    adc _LoaderApiFileSizeLow
    sta ptr_destination_end+0
    
    lda _LoaderApiAddressHigh
    sta ptr_destination+1
    adc _LoaderApiFileSizeHigh
    sta ptr_destination_end+1
    
    ; Now at this stage we have to check if the data is compressed or not
    lda _LoaderApiFileStartSector
    bmi LoadCompressedData
;---------------------------------------
; This loads data which is uncompressed
; It will be loaded in the buffer and
; then copied to the destination.
; this is bad and good. Bad because it
; takes time. Good because it alows for
; loading chunks < 256 bytes :)
;---------------------------------------
LoadUncompressedData	
    ldy #0
read_sectors_loop
    jsr GetNextByte 	; Read from source stream
    sta (ptr_destination),y
    
    ; We increase the current destination pointer, by a given value, white checking if we reach the end of the buffer.
    inc ptr_destination
    bne skip_destination_inc1
    inc ptr_destination+1
skip_destination_inc1

    lda ptr_destination
    cmp ptr_destination_end
    lda ptr_destination+1
    sbc ptr_destination_end+1
    bcc read_sectors_loop 
    
    ; Data successfully loaded (we hope)
    jmp ClearLoadingPic	; CHEMA: Clears the loading picture (jsr/rts)

;--------------------------------------
; This loads data which is compressed
;--------------------------------------
LoadCompressedData
    ; Initialise variables
    ; We try to keep "y" null during all the code, so the block copy routine has to be sure that Y is null on exit
    lda #1
    sta mask_value
    
unpack_loop
    ; Handle bit mask
    lsr mask_value
    bne end_reload_mask
    
    jsr GetNextByte 	; Read from source stream
    
    ror 
    sta mask_value   
end_reload_mask
    bcc back_copy

write_byte
    ; Copy one byte from the source stream
    jsr GetNextByte 	; Read from source stream
    sta (ptr_destination),y
    
    lda #1
    sta nb_dst

_UnpackEndLoop
    ; We increase the current destination pointer, by a given value, white checking if we reach the end of the buffer.
    clc
    lda ptr_destination
    adc nb_dst
    sta ptr_destination
    
    bcc skip_destination_inc
    inc ptr_destination+1
skip_destination_inc
    
    cmp ptr_destination_end
    lda ptr_destination+1
    sbc ptr_destination_end+1
    bcc unpack_loop  
ClearLoadingPic	
    rts
    

back_copy
    ;BreakPoint jmp BreakPoint	
    ; Copy a number of bytes from the already unpacked stream
    ; Here we know that Y is null. So no need for clearing it: Just be sure it's still null at the end.
    ; At this point, the source pointer points to a two byte value that actually contains a 4 bits counter, and a 12 bit offset to point back into the depacked stream.
    ; The counter is in the 4 high order bits.
    ;clc  <== No need, since we access this routie from a BCC
    jsr GetNextByte 	; Read from source stream
    adc #1
    sta offset
    jsr GetNextByte 	; Read from source stream
    tax
    and #$0f
    adc #0
    sta offset+1
    
    txa
    lsr
    lsr
    lsr
    lsr
    clc
    adc #3
    sta nb_dst
    
    sec
    lda ptr_destination
    sbc offset
    sta ptr_source_back
    lda ptr_destination+1
    sbc offset+1
    sta ptr_source_back+1
    
    ; Beware, in that loop, the direction is important since RLE like depacking is done by recopying the
    ; very same byte just copied... Do not make it a reverse loop to achieve some speed gain...
.(
copy_loop
    lda (ptr_source_back),y	; Read from already unpacked stream
    sta (ptr_destination),y	; Write to destination buffer
    iny
    cpy nb_dst
    bne copy_loop
.)
    ldy #0
    beq _UnpackEndLoop
    rts

;-----------------------------------------
; Gets the next byte from the stream,
; reading data from disk to the buffer
; if necessary.
;-----------------------------------------
GetNextByte
    php
    lda __fetchByte+1
    bne __fetchByte
    jsr ReadNextSector
    ldx #0
    ldy #0
__fetchByte
    lda LOADER_SECTOR_BUFFER
    inc __fetchByte+1
    plp
    rts
    
;--------------------------------------------
; Reads the next sector of the current file
;---------------------------------------------
ReadNextSector
    ; CHEMA: this is the critical section. Disable IRQs here
    sei	
    jsr PrepareTrack
RetryRead
__fdc_readsector
    lda #CMD_ReadSector
    PROTECT(FDC_command_register)
__fdc_command_2
    sta FDC_command_register
    
    ; Chema: this loop is needed if checking for partial
    ; loading of a sector, as we cannot check the STATUS
    ; directly after issuing a command. 
    ; Fabrice provided this table and the code, which takes 21 cycles+extra (ldx and lda below) :
    ; Operation		Next Operation		Delay required (MFM mode)
    ; Write to Command Reg.	Read Busy Bit (bit 0)	24 탎ec
    ; Write to Command Reg.	Read Status bits 1-7	32 탎ec
    ; Write Register	Read Same Register	16 탎ec
    ldy #4	
tempoloop 
    dey
    bne tempoloop 	
    
    ; Read the sector data
    
    ; This is the code suggested by Fabrice, which
    ; makes use of the STATUS bit to check when the command
    ; finishes, so not only the status flags are correct after
    ; computing CRC, but also if it is aborted due to a read error.
    ; Additionaly, to support the Jasmin, DRQ at FDC_drq cannot be polled
    ; as this signal is not exhibited in any address. One should use bit 1 
    ; of the Status register. BTW, Fabrice provided a code that, after aligning
    ; the first access to the status register, does not need more nops for the data register
    ; so timing for the read loop is correct. In his own words:
    ; Worst case delay :
    ; lda status (2), lsr (2), ror (2), bcc (3), bpl (2), lda status (4), lsr (2), ror (2), bcc (2), lda data (4)
    ; => 25 cycles, that's not bad !
    ; (yeap, I tweaked the code for proper alignment :-)
    
    ldx #0
    beq waitdrq   ;<--- always jumps
    PROTECT2(FDC_status_register,2)
checkbusy
    bpl end_of_command
waitdrq
__fdc_status_1
    lda FDC_status_register
    lsr
    ror
    bcc checkbusy
    
    PROTECT(FDC_data)
__fdc_data_2    
    lda FDC_data
    sta LOADER_SECTOR_BUFFER,x ; Store the byte in the sector buffer
    inx
    jmp waitdrq
end_of_command
    and #($7c>>2) ; Chema changed the original vaue: 1C
    
    ; If error repeat forever:
    bne RetryRead
    
    ; Finished!
    cli
    rts

;---------------------------------------------
; Waits for the completion of a command
; As we have not set the FDC IRQ we cannot simply
; poll bit 7 in $318, we have to check the busy
; bit on the status register.
; According to the datasheet we have to wait 24us
; before reading the status after a write to a command register.
; The loop takes a bit longer: 26 us (see sector_2-microdisc)
;------------------------------------------------
WaitCompletion
    txa
    pha
    ldx #5
r_wait_completion
    dex
    bne r_wait_completion
    PROTECT(FDC_status_register)
r2_wait_completion
__fdc_status_2
    lda FDC_status_register
    lsr
    bcs r2_wait_completion	; If s0 (busy) is not zero, wait.
    pla
    tax
    rts

;-----------------------------
; Default ISRs for vectors.
;-----------------------------
IrqHandler	
    bit $304
IrqDoNothing
    rti	

;-------------------------------------
; Write data. Uncompressed and
; directly to disk (no buffering)
; so deals with 256-byte chunks only
;-------------------------------------	
; CHEMA: I am re-using the var ptr_destination, though it
; is now the ptr to the buffer to write.
WriteData
	;jmp WriteData
    ; Flag we want to start avoiding the cumulus bug in the write sector command
    inc avoid_cumulus_bug
    
    jsr SetSideTrackSector
    lda _LoaderApiAddressLow
    sta ptr_destination+0
    lda _LoaderApiAddressHigh
    sta ptr_destination+1
loopwrite	
    ; Begin of critical section
    sei
    jsr PrepareTrack	
retrywrite	
    ; Writes a sector to disk.
__fdc_writesector
    lda #CMD_WriteSector
    PROTECT(FDC_command_register)
__fdc_command_w
    sta FDC_command_register
    
    ; According to the datasheet table of needed delays:
    ; Write to Command Reg.	Read Status bits 1-7	32 탎ec
    ; The next loop is 23, plus some extra due to the beq / lda /tax /jmp (3+5+2+3=13)
    ; Total is 36... could do with 4 iterations... perhaps
    ldy #5	;2
w_wait_completion
    dey	;2
    bne w_wait_completion ;2+1
    ; = 23 cycles	
    
    ; This is the correct loop, which keeps track of all kind
    ; of errors, as it is done when reading data.
    ; It is necessary to feed data at the disk
    ; rate, which is (in double density) 250 Kbps, that is
    ; 1 byte ~every 30 usec.
    
    ;ldy #0
    beq next_byte
    PROTECT2(FDC_status_register,2)	
check_busy2
    bpl end_of_commandw
waitdrqw
__fdc_status_w
    lda FDC_status_register
    ; Check DRQ & BUSY
    lsr 
    ror
    bcc check_busy2
    PROTECT(FDC_data)
__fdc_data_w	
    stx FDC_data
    iny
next_byte
    lda (ptr_destination),y
    tax
    jmp waitdrqw
end_of_commandw
    and #($3c>>2) 
    bne retrywrite ; If error repeat forever:
    
    
    cli	
    ; Now onto next sector
    inc ptr_destination+1
    dec _LoaderApiFileSizeHigh
    bne loopwrite
    
    ; Flag we want to stop avoiding the cumulus bug in the write sector command
    dec avoid_cumulus_bug
    
    ; Clear loading pic and return
    jmp ClearLoadingPic	; This is jsr/rts


;****************** CHEMA added these variables ****************
; I ran out of space in ZP for the var needed to avoid
; the Cumulus Bug, so I'll define it here. Besides,
; this way I can give it a default value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
avoid_cumulus_bug	.byt 0

_EndLoaderCode

;
; This is free memory that can be used, when it reaches zero then the loader start address should be changed
;

    .dsb $FFEC - _EndLoaderCode

_Vectors

#if ( _Vectors <> $FFEC )
#error - Vector address is incorrect, loader will crash
#else

;
; Here are the functions that the user can call from his own application
;

; Chema: WriteSupport
_LoaderApiSaveData              .byt OPCODE_JMP,<WriteData,>WriteData   ; $FFEC-$FFEE

_LoaderApiFileStartSector       .byt LOADER_INTRO_PROGRAM_SECTOR        ; $FFEF
_LoaderApiFileStartTrack        .byt LOADER_INTRO_PROGRAM_TRACK         ; $FFF0

_LoaderApiFileSize
_LoaderApiFileSizeLow           .byt <LOADER_INTRO_PROGRAM_SIZE         ; $FFF1
_LoaderApiFileSizeHigh          .byt >LOADER_INTRO_PROGRAM_SIZE         ; $FFF2

; Could have a JMP here as well to launch the loaded program
_LoaderApiJump                  .byt OPCODE_JMP                         ; $FFF3
_LoaderApiAddress
_LoaderApiAddressLow            .byt <LOADER_INTRO_PROGRAM_ADDRESS      ; $FFF4
_LoaderApiAddressHigh           .byt >LOADER_INTRO_PROGRAM_ADDRESS      ; $FFF5
_LoaderXxxxxx_available         .byt 0                                  ; $FFF6
_LoaderApiLoadFile              .byt OPCODE_JMP,<LoadData,>LoadData     ; $FFF7-$FFF9

;
; These three HAVE to be at these precise adresses, they map to hardware registers
;
_VectorNMI          .word IrqDoNothing              ; $FFFA-$FFFB - NMI Vector (Usually points to $0247)
_VectorReset        .word IrqDoNothing              ; $FFFC-$FFFD - RESET Vector (Usually points to $F88F)
_VectorIRQ          .word IrqHandler                ; $FFFE-$FFFF - IRQ Vector (Normally points to $0244)

#echo Remaining space in the loader code:
#print (_Vectors - _EndLoaderCode) 

#endif

; End of the loader - Nothing should come after because it's out of the addressable memory range :)
