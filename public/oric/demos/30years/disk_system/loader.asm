
#include "disk_info.h"


#define COLOR(color) pha:lda #16+(color&7):sta $bb80+40*27:pla
#define STOP(color) pha:lda #16+(color&7):sta $bb80+40*27:jmp *:pla

	.zero
	
	*=$00
	
retry_counter		.dsb 1		; Number of attempts at loading data (ie: not quite clear what happens when this fails...)
sectors_to_go		.dsb 1		; How many sectors do we still need to load for this file
current_track		.dsb 1		; Index of the track being loaded
current_sector		.dsb 1		; Index of the sector being loaded
current_side		.dsb 1		; Has the bit 4 set to 0 or 1 to be used as a mask on the Microdisc control register (other bits have to be set to zero)

	.text

; FFF0
; FFF1
; FFF2
; FFF3
; FFF4
; FFF5
; FFF6
; FFF7
; FFF8
; FFF9 - Test Overlay
;
; FFFA - NMI Vector (Usually points to $0247)
; FFFB
;
; FFFC - RESET Vector (Usually points to $F88F)
; FFFD
;
; FFFE - IRQ Vector (Normally points to $0244)
; FFFF	
;
	*=location_loader


Initialize
	jsr SetUpIrqHandlers	
	jsr SoftHiresWithCopyCharset
	
	; Load the picture
	ldx #0
	jsr LoadData
	;STOP(1)	
	jsr ExecuteData
	
	
	; Load the rasters crap
	;STOP(1)
	;ldx #1
	;jsr LoadData
	;jsr SoftHires	; Delete the screen
	;STOP(2)
	;jsr ExecuteData
	
	; Load the demo
	jsr SoftHires	; Delete the screen
	;STOP(1)
	ldx #2
	jsr LoadData
	;STOP(2)
	jsr ExecuteData
	
	;
	; End of demo - Just stay there doing nothing
	;
	sei
.(	
loop
	jmp loop
.)
	
	
ClearZeroPage
.(
	lda #0
	tax
loop
	sta $00,x
	dex
	bne loop	
	rts	
.)	

	
SetUpIrqHandlers
	sei

	; Set-up a safe irq that does nothing - Good to avoid crashes
	lda #<IrqDoNothing
	sta $fffa
	sta $fffc
	lda #>IrqDoNothing
	sta $fffb
	sta $fffd
	
	ldy #<IrqHandler
	lda #>IrqHandler
    sty $fffe
	sta $ffff
	
	; Make sure the microdisc IRQ is disabled	
	jsr WaitCompletion
	
	lda #%10000100 			; Disable the FDC (Eprom select + FDC Interrupt request)
	sta MICRODISC
	
	rts	

		
SaveA	.byt 0	

IrqHandler
	sta SaveA
	pla
	and #%00010000	; Check the saved B flag to detect a BRK
	bne from_brk
	
from_irq
	lda SaveA
	pha
IrqDoNothing
	rti	
	
from_brk	
	lda #16+1
	sta $bb80+40*27	
	nop
	nop
	nop
	lda #16+2
	sta $bb80+40*27
	jmp from_brk


	
HexData	.byt "0123456789ABCDEF"
	
	
; X=File index
LoadData
	sei

	lda FileLoadAdressHigh,x
	sta __auto_execute_address+2
	sta __auto_write_address+2


	lda FileLoadAdressLow,x
	sta __auto_execute_address+1
	sta __auto_write_address+1


	; Start on side 0
	lda #0
	sta current_side

	; Starting track
	lda FileStartTrack,x
	sta current_track
	
	; If >128 it means it is on the other side
	sec
	sbc #128
	bmi same_side
	sta current_track

	lda #%00010000
	sta current_side
same_side

	; First sector
	lda FileStartSector,x
	sta current_sector

	; Number of sectors to load
	lda FileSectorCount,x 	
	sta sectors_to_go
	
	; Loop to read all the sectors	
read_sectors_loop	

	; Check if we have reached the end of the track
	lda current_sector
	
	cmp #17+1
	bne same_track
	
	; Next track
	inc current_track
		
	; Reset the sector position
	lda #1
	sta current_sector
same_track

	; Display debug info
	;jsr DisplayPosition


	lda current_sector
	sta FDC_sector_register
	inc current_sector
	
	; Check if the drive is on the correct track		
	lda current_track
	cmp FDC_track_register	
	beq stay_on_the_track
		
	; Set the new track
	sta	FDC_data
		
	lda #CMD_Seek
	sta FDC_command_register	
	jsr WaitCompletion
	
	lda #%10000100 ; on force les le Microdisk en side0, drive A ... Set le bit de données !!!
	ora current_side
	sta MICRODISC

stay_on_the_track
	lda #CMD_ReadSector
	sta FDC_command_register


	ldy #wait_status_floppy
waitcommand
	nop
	nop
	dey
	bne waitcommand

	;
	; Read the sector data
	;
	ldy #0
microdisc_read_data
	lda $0318
    bmi microdisc_read_data

	lda $313
__auto_write_address
	sta $c000,y
	iny

	bne microdisc_read_data

	lda FDC_status_register
	and #$1C

	; Next sector
	inc __auto_write_address+2
	dec sectors_to_go
	bne read_sectors_loop

	; Data successfully loaded (we hope)
	rts
	
ExecuteData	
	jsr SetUpIrqHandlers
	jsr ClearZeroPage
__auto_execute_address
	jsr $a000
	jsr SetUpIrqHandlers
	rts



WaitCompletion
	ldy #4
r_wait_completion
	dey
	bne r_wait_completion
r2_wait_completion
	lda FDC_status_register
	lsr
	bcs r2_wait_completion
	asl
	rts

	
DisplayPosition	
	.(
	lda current_side	
	lsr
	lsr
	lsr
	lsr
	tax
	lda HexData,x
	sta $bb80+40*27+0

	lda #3
	sta $bb80+40*27+1
		
	lda current_track
	lsr
	lsr
	lsr
	lsr
	tax
	lda HexData,x
	sta $bb80+40*27+2
	
	lda current_track
	and #15
	tax
	lda HexData,x
	sta $bb80+40*27+3

	lda #2	
	sta $bb80+40*27+4
		
	lda current_sector
	lsr
	lsr
	lsr
	lsr
	tax
	lda HexData,x
	sta $bb80+40*27+5
	
	lda current_sector
	and #15
	tax
	lda HexData,x
	sta $bb80+40*27+6
	
	;jsr WaitLoop
	rts
	.)

	
WaitLoop
	jsr WaitLoop2	
	jsr WaitLoop2	
	jsr WaitLoop2	
	jsr WaitLoop2	
	rts
	
WaitLoop2
	jsr WaitLoop3
	jsr WaitLoop3	
	jsr WaitLoop3	
	jsr WaitLoop3	
	rts
	
WaitLoop3
	jsr WaitLoop4
	jsr WaitLoop4	
	jsr WaitLoop4	
	jsr WaitLoop4	
	rts
	
WaitLoop4
.(
	ldx #0
loop	
	nop
	nop
	nop
	dex
	bne loop
	rts	
.)			


SoftHiresWithCopyCharset
	LDY #$00		;COPY CHARSET
HM_03
	LDA $B500,Y
	STA $9900,Y
	LDA $B600,Y
	STA $9A00,Y
	LDA $B700,Y
	STA $9B00,Y
	LDA $B900,Y
	STA $9D00,Y
	LDA $BA00,Y
	STA $9E00,Y
	LDA $BB00,Y
	STA $9F00,Y
	DEY
	BNE HM_03
SoftHires	
	LDA #$A0             ;CLEAR DOWN ALL MEMORY AREA WITH ZERO
STA $01
	LDA #$00
STA $00
	LDX #$20
HM_01 STA ($00),Y
	INY
	BNE HM_01
	INC $01
	DEX
	BNE HM_01
	LDA #30			;WRITE HIRES SWITCH
	STA $BF40
	LDA #$A0		;CLEAR HIRES WITH #$40
	STA $01
	LDX #$20
	LDX #64
HM_04
	LDY #124
HM_05
	LDA #$40
	STA ($00),Y
	DEY
	BPL HM_05
	LDA $00
	ADC #125
	STA $00
	BCC HM_02
	INC $01
HM_02	DEX
	BNE HM_04
	RTS


		
	

#include<loader.cod>


