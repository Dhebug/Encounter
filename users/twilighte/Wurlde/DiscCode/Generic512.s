;Modify boot routine to load sector2 into FD00-FEFF then jump FE09
;	+17C,$FD
;	+5C,$4C
;	+5D,$09
;	+5E,$FE
#define fdc_Command     $0300
#define fdc_Status      $0300
#define fdc_Track       $0301
#define fdc_Sector      $0302
#define fdc_Data        $0303
#define fdc_Control     $0304

#define	FATSectorFlags	$FF00
#define	FATSideTrack	$FF50
#define	FATSectorSize	$FFA0
#define	DiskTracks	$FFF0
#define	Version		$FFF1
#define	DiskSectors	$FFF2
#define	FDC_Offset	$FFF3
#define	MachineType	$FFF4
#define	FirstFileLoadHi	$FFF5
#define	SectorCount	$FFF6
#define	FirstFileExec	$FFF7
;$47 FDC Offset
;	$10	Microdisc/Telestrat
;	$F4	Jasmin
;$00 Machine Type
;	$20	Jasmin
;	$40	Atmos Microdisc Controller
;	$C0	Telestrat

;Sector 2 Structure
;FD00-FDF9 File Address Tables
;
;FE00 - JMP Load Datablock
;FE03 - JMP Save Sector
;FE06 - JMP Set Drive
;FE09 - Transfer FD00-FDF9 >> FF00-FFF9
;	Transfer FDC Offset($47) to FFF3
;	Transfer Machine Type($00) to FFF4
;	Initialise Loading first data block
;FEXX - GR - Load DataBlock
;FEXX - GR - Save Sector
;FEXX - GR - Set Drive

 .text
*=$FD00

;FD00-FDEF(FF00-FFEF)
;First half of sector (240) holds FAT Table which is organised
;into 80 x 3 byte records..
;+00 Sector
;	Bits 0-4 Sector(0-31)
;	Bits 5-7 Future Flags
;+01 Side/Track
;+02 Number of Sectors
tFATSectorFlags	;Generic512 Offset +00
 .dsb 80,1
tFATSideTrack	;Generic512 Offset +80
 .dsb 80,0
tFATSectorSize	;Generic512 Offset +160
 .dsb 80,0

;FDF0(FFF0) Number of Tracks/Sides on Disc
tDiskTracks	;Generic512 Offset +240
 .byt 1+82*2

;FDF1(FFF1) Version
tVersion
 .byt 1

;FDF2(FFF2) Number of Sectors Per Track Plus One
tDiskSectors	;Generic512 Offset +241
 .byt 10

;FDF3(FFF3) FDC Offset
tFDC_Offset
 .byt 0	;Set in FEXX Routine

;FDF4(FFF4) Machine Type
tMachineType
 .byt 0	;Set in FEXX Routine

;FDF5(FFF5) First File Load Address High
tFirstFileLoadHi	;Generic512 Offset +244
 .byt $04	;Set in DSKBuilder

;FDF6(FFF6) Temporary location for Counting the total Sectors to Load
tTempDrive
tSectorCount
 .byt 0

;FDF7-FDF8(FFF7-FFF8) First File Exec Address
tFirstFileExec	;Generic512 Offset +246/7
tDriveNumber	;
 .byt $00
 .byt $04	;Set in DSKBuilder

;FDF9(FFF9) Number of Files on Disk (Excludes Boot Sectors 1 and 2)

 .byt 0		;Generic512 Offset +248

;FDFA-FDFF Wasted space

 .byt "Twi-08"

;FE00 - JMP Load Datablock

	jmp LoadDataBlock

;FE03 - JMP Save Sector

	jmp SaveSector

;FE06 - JMP Set Drive

	jmp SetDrive

;FE09 - Transfer FD00-FDF9 >> FF00-FFF9
;	Transfer FDC Offset($47) to FFF3
;	Transfer Machine Type($00) to FFF4
;	Initialise Loading first data block

InitialiseFirstLoad
	; Transfer FD00-FDF9 >> FF00-FFF9
;.(
;loop1	lda #65
;	sta $bb80
;	jmp loop1
;.)
	ldx #$FA
.(
loop1	lda $FCFF,x
	sta $FEFF,x
	dex
	bne loop1
.)
	; Transfer FDC Offset($47) to FFF3
	lda $47
	sta $FFF3

	; Transfer Machine Type($00) to FFF4
	lda $00
	sta $FFF4

	; Initialise Loading first data block
	lda FirstFileLoadHi
	ldx #00
	jsr LoadDataBlock
	;Reset Stack
	ldx #$FF
	txs
	jmp (FirstFileExec)

LookupFAT
	;Fetch and Store Side
	;Jasmin - $3F8 Bit 0
	;Microdisc - $314 Bit 4
	lda FATSideTrack,x
	and #01
	bit MachineType
.(
	bvc skip1
	asl
	asl
	asl
	asl
	ora #$84
skip1	sta $0304,y
.)
	;Fetch and Seek Track
	lda FATSideTrack,x
	lsr
	sta fdc_Data,y
	lda #%00011000
	sta fdc_Command,y
	jsr WaitOnCommandEnd
	;Fetch and store Sector
	lda FATSectorFlags,x
	sta fdc_Sector,y
	;Fetch and store Sector Size
	lda FATSectorSize,x
	sta SectorCount
	rts

ReadSectorHalf
RSHLoop	lda fdc_Status,y
	and #%00000010
	beq RSHLoop
	lda fdc_Data,y
Vector1	sta $DE00,x
	inx
	bne RSHLoop
	inc Vector1+2
	rts

WaitOnCommandEnd
	lda fdc_Status,y
	lsr
	bcs WaitOnCommandEnd
	asl
	and #$1C
	rts

;FEXX - GR - Load DataBlock
LoadDataBlock
	php
	sei
	;Store parsed High Load Address
	sta Vector1+2
	;Locate address
	ldy FDC_Offset
	jsr LookupFAT
	;
	ldx #00
	;Read Sector
.(
loop3	lda #$84
	sta fdc_Command,y
	jsr ReadSectorHalf
	jsr ReadSectorHalf
	jsr WaitOnCommandEnd
	;Error Check
	beq skip2
	dec Vector1+2	;Reload Sector
       	dec Vector1+2
	jmp LoadDataBlock
skip2	;Progress Sector
	lda fdc_Sector,y
	clc
	adc #01
	cmp DiskSectors
	bcc skip1
	;Progress Track
	lda #$5B
	sta fdc_Command,y
	jsr WaitOnCommandEnd
	lda #01
skip1	sta fdc_Sector,y
	;Progress Sector Count
	dec SectorCount
	bne loop3
.)
	plp
	rts

;FEXX - GR - Save Sector
SaveSector
;FEXX - GR - Set Drive
;X - Drive 0-3
SetDrive
	lda tFDC_Offset
	;$10	Microdisc/Telestrat
	;$F4	Jasmin
.(
	bmi SetJasminDrive
SetMicrodiscDrive
	lda $314
	and #%10011111
	ora DriveBitPair,x
	sta $314
	jmp rent1
SetJasminDrive
	sta $3FC,x
rent1	stx tDriveNumber
.)
	rts
DriveBitPair
 .byt %00000000
 .byt %00100000
 .byt %01000000
 .byt %01100000

 .dsb 256-(*&255)
