;WurldeDisc
;Read data file from disk. This routine does not use the FDC Interrupt
;and is based on a disk formatted with 256 bytes/sector, 17 Sectors/Track
;with the file held from Sector 1, Track 0 for 31 Sectors(31x256==7936 Bytes).

#define fdc_Command	$0310
#define fdc_Status	$0310
#define fdc_Track	$0311
#define fdc_Sector	$0312
#define fdc_Data	$0313

#define fdc_Control	$0314
#define fdc_DRQState	$0318
#define via_ier		$030E


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

 .zero
*=$00

source		.dsb 2
SectorCount	.dsb 1

 .text
*=$500

WaitOnCommandEnd
.(
loop1	lda fdc_Control
	bmi loop1
.)
	rts
InitialiseDisc
	;$509 - Disable CPU interrupts
	sei
	lda #%10000100
	sta fdc_Control
	lda #%00001000	;Restore Track 0
	sta fdc_Command
	jsr WaitOnCommandEnd
LoadFile
	;Move to LOAD Track
	ldx GameFileIndex
	lda FileStartTrack,x
	;Load Data register with desired track
	sta fdc_Data
	lda #%00011000	;0001??00
	sta fdc_Command
	jsr WaitOnCommandEnd
	lda FileStartSector,x
	sta fdc_Sector
	lda FileStartMemoryHi,x
.(
	sta vector1+2
	ldy #00
	lda FileSectorCount,x
	sta SectorCount
loop2	lda #%10001000
	sta fdc_Command
loop1	lda fdc_DRQState
	bmi loop1
	lda fdc_Data
vector1	sta $A000,y
	iny
	bne loop1
	jsr WaitOnCommandEnd
	lda fdc_Status
	and #%00011100
	bne loop2
	inc vector1+2
	lda fdc_Sector
	adc #01
	cmp #18	;17 Sectors per track
	bcc skip2
	lda #%01011000	;010???00
	sta fdc_Command
	ldy #03
loop5	dey
	bne loop5
	jsr WaitOnCommandEnd
	lda #01
skip2	sta fdc_Sector
	dec SectorCount
	bne loop2
.)
	rts


GameFileIndex	.byt 0

FileStartTrack
 .byt 0
FileStartSector
 .byt 1

FileStartMemoryHi
 .byt >$A000
FileSectorCount	;Multiples of 256
 .byt 31
