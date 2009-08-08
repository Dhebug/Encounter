;MicroDisc Boot Strap Sector - Builds to microdisc.bss
;1) Disable ROM
;2) Disable EPROM
;3) Load routine(Track 0 Sector 4) into FE00-FEFF
;4) Load FAT(Track 0 Sector 3) into FF00-FFFF
;5) Set FFFA-FFFF
;6) Set System(Jasmin) Flag
;7) Call to Load and exec first File

#define fdc_Command     $0310
#define fdc_Status      $0310
#define fdc_Track       $0311
#define fdc_Sector      $0312
#define fdc_Data        $0313
#define fdc_Control     $0314
#define fdc_DRQState    $0318
#define via_ier         $030E

#define SectorCounts	$FF00
#define	SystemFlag	$FF08	;00(Microdisc) E4(Jasmin)
#define SectorCount	$FF08
#define TrackSectors	$FF09	;Number of Sectors in a Track
#define	FAT		$FF0A
;Page 4 is not actually ideal since the eventual program load should be given to this page.

*=$400
MicroDiscBootStrap
	;Loop for testing
	sei
	clc
	bcc MicroDiscBootStrap

	;Disable EPROM, enable Overlay
	lda #%10000100
	sta fdc_Control
        ;Load Sector 4 into FE00
        lda #4
        ldx #$FE
        jsr LoadSector
        ;Load Sector 3 into FF00
        lda #3
        ldx #$FF
        jsr LoadSector
        ;Set Reset to FD00
        lda #$00
        sta $FFFC
        lda #$FD
        sta $FFFD
        ;Set System Flag to Microdisc
        lda #$00
        sta SystemFlag
        ;Place final code into page 2 so that we can potentially use Page 4 at start
        ldy #5
.(
loop1   lda Page2Code,y
        sta $201,y
        dey
        bpl loop1
.)
        ;Load and exec first file from FAT
        ldx #00
        lda #04
        jmp $201

Page2Code
        jsr $FE00
        jmp $0400

LoadSector
        sta fdc_Sector
.(
        stx vector1+2
        ldx #00
loop3   lda #%10001100
        sta fdc_Command
        ;Rely on DRQ flag in status register for DataByte ready

loop1	lda fdc_DRQState
	bmi loop1
        ;Fetch next byte
        lda fdc_Data
vector1 sta $0400,x
        ;Update index
        inx
        bne loop1
        ;Wait on Command End
loop2	lda fdc_Control
	bmi loop2
        ;Check for Error - Reload sector
        lda fdc_Status  ;This should also reset FDC IRQ
        and #%00011100
        bne loop3
.)
        rts


;Currently 102 Bytes
 .dsb 256-(*&255)

	lda zp
	sec
	sbc #bit8
	sta zp
	bcs
	sec
	dec zp+1
