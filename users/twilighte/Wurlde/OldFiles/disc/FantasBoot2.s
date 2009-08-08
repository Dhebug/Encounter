;Modify boot routine to load sector2 into FD00-FEFF then jump FE09
;	+17C,$FD
;	+5C,$4C
;	+5D,$09
;	+5E,$FE

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


*=$FD00

;FD00-FDEF(FF00-FFEF)
;First half of sector (240) holds FAT Table which is organised
;into 80 x 3 byte records..
;+00 Sector
;	Bits 0-4 Sector(0-31)
;	Bits 5-7 Future Flags
;+01 Side/Track
;+02 Number of Sectors
FATSectorFlags
 .dsb 80,1
FATSideTrack
 .dsb 80,0
FATSectorSize
 .dsb 80,0

;FDF0(FFF0) Number of Tracks on Disc
DiskTracks
 .byt 82

;FDF1(FFF1) Number of Sides on Disc(1-2)
DiskSides
 .byt 2

;FDF2(FFF2) Number of Sectors Per Track Plus One
DiskSectors
 .byt 10

;FDF3(FFF3) FDC Offset
FDC_Offset
 .byt 0	;Set in FEXX Routine

;FDF4(FFF4) Machine Type
MachineType
 .byt 0	;Set in FEXX Routine

;FDF5(FFF5) First File Load Address High
FirstFileLoadHi
 .byt $04	;Set in DSKBuilder

;FDF6(FFF6) Temporary location used by generic routines
temp01
 .byt 0

;FDF7-FDF8(FFF7-FFF8) First File Exec Address
FirstFileExec
 .byt $00,$04	;Set in DSKBuilder

;FDF9(FFF9) Number of Files on Disk (Excludes Boot Sectors 1 and 2)

 .byt 0	;Set in DSKBuilder

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
	ldx #$F9
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
	jmp (FirstFileExec)

LookupFAT
	;Fetch and Store Side
	;Jasmin - $3F8 Bit 0
	;Microdisc - $314 Bit 4
	lda FATSideTrack,x
	and #01

	bit machine_type
	bvc select_side
	asl
	asl
	asl
	asl
	ora #$84
select_side
	;Y $10 or $F4
	sta $0304,y

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
	sta temp01
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
	;Store parsed values
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


loop1	lda fdc_Status,y
	and #%00000010
	beq loop1

	lda fdc_Data,y
Vector1	sta $DE00,x
	inx
	bne loop1
	inc Vector1+2


loop2	lda fdc_Status,y
	and #%00000010
	beq loop2

	lda fdc_Data,y
Vector2	sta $DE00,x
	inx
	bne loop2

	inc Vector2+2

	;Wait on Command End
	jsr WaitOnCommandEnd

	;Progress Sector
	lda fdc_Sector,y
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
	dec Temp01
	bne loop3
.)
	rts

;FEXX - GR - Save Sector
SaveSector
;FEXX - GR - Set Drive
SetDrive
