;Dual Boot Load

#define fdc_Command     $0310
#define fdc_Status      $0310
#define fdc_Track       $0311
#define fdc_Sector      $0312
#define fdc_Data        $0313

#define fdc_Control     $0314
#define fdc_DRQState    $0318
#define via_ier         $030E

#define jsm_Command     $03F4
#define jsm_Status      $03F4
#define jsm_Track       $03F5
#define jsm_Sector      $03F6
#define jsm_Data        $03F7
#define jsm_Side        $03F8   ;B0 Side 0(0) or 1(1)
#define jsm_FDCReset    $03F9   ;Write any value
#define jsm_Overlay     $03FA   ;B0 Overlay(1)
#define jsm_ROMDIS      $03FB   ;B0 Disable ROM(1)
#define jsm_DriveA      $03FC   ;Write any Value
#define jsm_DriveB      $03FD   ;Write any Value
#define jsm_DriveC      $03FE   ;Write any Value
#define jsm_DriveD      $03FF   ;Write any Value


#define	SystemFlag	$FF08	;00(Microdisc) E4(Jasmin)
#define SectorCount	$FF08
#define TrackSectors	$FF09	;Number of Sectors in a Track
#define	FAT		$FF0A

;FE00 GenericDiskLoad (Load File)
;FEXX GenericDiskSave (Save Sector)
;FEXX GenericDriveSel (Select Drive Number)
;FF00 Temporary Patch Code area
;FF08 SectorCount(During Call) or SystemFlag
;FF09 TrackSectors (Number of Sectors in a Track)
;FF0A FAT (80 x 3 Byte Records)
;     Byte 0 - Side(Bit 0) Track(Bits 1-7)
;     Byte 1 - Sector
;               00 No file present
;		01-18
;     Byte 2 - Number of Sectors
;FFFA -

*=$FE00
;X File Index
;A Load Address High
GenericDiskLOAD
	sei
	;Store the Save Address
.(
	sta vector1+2

	;Multiply File Number by 3 to get FAT index
	jsr FileIndex2FATIndex

	;Branch if FileIndex refers to non-existant File
	lda FAT+1,y
	beq skip1

	jsr SelectSide

	jsr SeekFATTrack


	jsr FetchFATSector

	;Fetch and Store FAT Length
	lda FAT+2,y
	sta SectorCount

	;Read Sector
	ldy #00
loop3	lda #%10001000
	sta fdc_Command,x
loop4	lda fdc_Status,x
	and #%00000010
	beq loop4
	lda fdc_Data,x
vector1	sta $DE00,y
	iny
	bne loop4
loop2	lda fdc_Status,x
	lsr
	bcs loop2
	and #%00001110
	bne loop3

	;Update Memory Pointer
	inc vector1+2

	;Update Sector/Track
	inc fdc_Sector,x
	lda fdc_Sector,x
	cmp TrackSectors
	bcc skip4
	lda #01
	sta fdc_Sector,x
	lda #%01011000
	sta fdc_Command,x
loop5	lda fdc_Status,x
	lsr
	bcs loop5
skip4

	;Count Sectors
	dec SectorCount
	bne loop3

	;Re enable IRQ and End
	stx SystemFlag
skip1	cli
.)
	rts

SelectSide
	;Fetch and Store FAT Side
	lda FAT,y
	lsr		;Pushes Side into Carry leaving Track in Acc
	pha
	ldx SystemFlag	;Branch on System
.(
	bne skip3
	lda fdc_Control	;Deal Microdisc
	and #%11101111
	bcc skip1
	ora #%00010000
skip1	sta fdc_Control
	jmp skip2
skip3	rol             ;Deal Jasmin
	sta jsm_Side
skip2   rts
.)

SeekFATTrack
	;Fetch and Seek FAT Track
	pla
	sta fdc_Data,x
	lda #%00011000
	sta fdc_Command,x
.(
loop1	lda fdc_Status,x
	lsr
	bcs loop1
.)
	rts

FetchFATSector
	;Fetch and store FAT Sector
	lda FAT+1,y
	sta fdc_Sector,x
	rts

FileIndex2FATIndex
	stx vector2+1
	txa
	asl
vector2	adc #00
	tay
	rts

;X File Index
;A Save Address High
GenericDiskSAVE	;Saves a single sector
	sei
	;Store the Save Address
.(
	sta vector1+2

	;Multiply File Number by 3 to get FAT index
	jsr FileIndex2FATIndex

	;Branch if FileIndex refers to non-existant File
	lda FAT+1,y
	beq skip1

	;Locate position on Disk
	jsr SelectSide
	jsr SeekFATTrack
	jsr FetchFATSector

	;Write Sector
loop3	lda #%10101000
	sta fdc_Command,x
loop4	lda fdc_Status,x
	and #%00000010
	bne loop4
vector1	lda $DE00,y
	sta fdc_Data,x
	iny
	bne loop4
loop2	lda fdc_Status,x
	lsr
	bcs loop2
	and #%00001110
	bne loop3
skip1	cli
.)
	rts

;Y - Drive Number 0-3
GenericDriveSel
	ldx SystemFlag
.(
	beq skip1
	;Deal with Jasmin
	lda #01
	sta jsm_DriveA,y
	rts
skip1	lda fdc_Control
.)
	and #%10011111
	ora DriveBitPair,y
	sta fdc_Control
	rts
DriveBitPair
 .byt %00000000
 .byt %00100000
 .byt %01000000
 .byt %01100000

;Fill remaining to ensure Vectors are always present
 .dsb 250-(*&255)

RoutineVectors
	jmp GenericDiskSAVE	;FEFA
	jmp GenericDriveSel	;FEFD

