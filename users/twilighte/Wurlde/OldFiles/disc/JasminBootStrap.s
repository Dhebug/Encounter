;Jasmin Boot Strap Sector - Builds to jasmin.bss
;1) Disable ROM
;2) Disable EPROM
;3) Load routine(Track 0 Sector 4) into FE00-FEFF
;4) Load FAT(Track 0 Sector 3) into FF00-FFFF
;5) Set FFFA-FFFF
;6) Set System(Jasmin) Flag
;7) Call to Load and exec first File

#define jsm_Command	$03F4
#define jsm_Status	$03F4
#define jsm_Track	$03F5
#define jsm_Sector	$03F6
#define jsm_Data	$03F7
#define jsm_SideSelect	$03F8	;B0 Side 0(0) or 1(1)
#define jsm_FDCReset	$03F9	;Write any value
#define jsm_Overlay	$03FA	;B0 Overlay(1)
#define jsm_ROMDIS	$03FB	;B0 Disable ROM(1)
#define jsm_DriveA	$03FC	;Write any Value
#define jsm_DriveB	$03FD	;Write any Value
#define jsm_DriveC	$03FE   ;Write any Value
#define jsm_DriveD	$03FF   ;Write any Value
#define via_ier		$030E

#define	SystemFlag	$FF08	;00(Microdisc) E4(Jasmin)
#define SectorCount	$FF08
#define TrackSectors	$FF09	;Number of Sectors in a Track
#define	FAT		$FF0A
;Page 4 is not actually ideal since the eventual program load should be given to this page.

*=$400
JasminBootStrap
	;Loop for testing
	sei
	clc
	bcc JasminBootStrap

	lda #01
	sta jsm_ROMDIS
	sta jsm_Overlay
	;Load Sector 4 into FE00
	lda #4
	ldx #$FF
	jsr LoadSector
	;Load Sector 3 into FF00
	lda #5
	ldx #$FE
	jsr LoadSector
	;Set Reset to FD00
	lda #$00
	sta $FFFC
	lda #$FD
	sta $FFFD
	;Set System Flag to Jasmin
	lda #$E4
	sta SystemFlag
	;Place final code into page 2 so that we can potentially use Page 4 at start
	ldy #5
.(
loop1	lda TempVector,y
	sta $FF00,y
	dey
	bpl loop1
.)
	;Load and exec first file from FAT
	ldx #00
	lda #04
	jmp $FF00

TempVector
	jsr $FE00
	jmp $0400

LoadSector
	sta jsm_Sector
.(
	stx vector1+2
	ldx #00
loop3	lda #%10001100
	sta jsm_Command
	;Rely on DRQ flag in status register for DataByte ready

loop1	lda jsm_Status
	and #%00000010
	beq loop1
	;Fetch next byte
	lda jsm_Data
vector1	sta $0400,x
	;Update index
	inx
	bne loop1
	;Wait on Command End
loop2	lda jsm_Status
	lsr
	bcs loop2

	;Check for Error - Reload sector
	lda jsm_Status	;This should also reset FDC IRQ
	and #%00011100
	bne loop3
.)
	rts


;Currently 108 Bytes
 .dsb 256-(*&255)
