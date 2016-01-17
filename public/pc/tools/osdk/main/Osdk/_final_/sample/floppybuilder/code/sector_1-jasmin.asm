;
; This is the bootsector for the Jasmin drives.
; No particular magic to do here, all the versions of the Jasmin system load the boot sector in page 4,
; so we can just assemble the bootsector code using $400 as the base address
;
; Warning: This whole code CANNOT be more than 256 bytes (ie: the size of the sector)

#define FINAL_ADDRESS                 $0400

#define FDC_command_register          $03f4
#define FDC_status_register           $03f4
#define FDC_track_register            $03f5
#define FDC_sector_register           $03f6
#define FDC_data                      $03f7
#define FDC_flags                     $03f8
#define FDC_drq                       $03fc

#define FDC_ovl_control               $3fa
#define FDC_rom_control               $3fb

#define FDC_Offset                    $e4

#define CMD_Restore                   $00
#define CMD_ForceInterrupt            $d0

#define CMD_WriteSector               $ac
#define CMD_ReadSector                $8c
#define CMD_Seek                      $1f
#define FDC_Flag_DiscSide             %00000001

#include "disk_info.h"

    .text
    *=FINAL_ADDRESS

    jmp JasminStart
;   .byt $01,$00,$00
    .byt             $00,$00,$00,$00,$00,$20,$20,$20,$20,$20,$20,$20,$20
    .byt $00,$00,$03,$00,$00,$00,$01,$00,$53,$45,$44,$4F,$52,$49,$43,$20
    .byt $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
    .byt $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

    ;
    ; Here starts the actual executable part, maximum available size is 192 bytes (256-64)
    ;

JasminStart

    ; Disable interruptions
    sei

    ; Enable Overlay ram
    lda #1
    sta FDC_ovl_control

    ; Disable ROM
    lda #1
    sta FDC_rom_control

    ; Disable Eprom and FDC Interrupt request
    lda #%10000000
    sta FDC_flags

    ldx #0
next_logo
    lda logo,x
    beq clr_stat
    sta $bb80,x
    inx
    bne next_logo

clr_stat
    lda #$20
next_stat
    sta $bb80,x
    inx
    cpx #40
    bcc next_stat

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
    lda FDC_drq                 ; We are waiting for the drive maybe not useful if drive is ready after the eprom boot
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
    sta FDC_sector_register

    ;
    ; Send a READSECTOR command
    ;
    lda #CMD_ReadSector
    sta FDC_command_register

    ldy #wait_status_floppy
waitcommand
    nop                     ; Not useful but for old Floppy drive maybe
    nop                     ; Not useful but for old Floppy drive maybe
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

    ; Initialize Jasmin specific FDC parameters
    lda #FDC_Offset
    sta location_fdc_offset
    lda #CMD_WriteSector
    sta location_cmd_writesector
    lda #CMD_ReadSector
    sta location_cmd_readsector
    lda #CMD_Seek
    sta location_cmd_seek
    lda #CMD_ForceInterrupt
    sta location_cmd_forceinterrupt
    lda #FDC_Flag_DiscSide
    sta location_fdc_flag_discside

    ; Make sure the stack is correctly setup, and clear the decimal flag
    ldx #$ff
    txs
    cld

    ; Finally call the main loader
    jmp location_loader

logo
    .asc "JASMIN Booting",0

; Number of attempts at loading data (ie: not quite clear what happens when this fails...)
retry_counter
    .dsb 1

sector_counter
    .byt (($FFFF-location_loader)+1)/256

_END_
