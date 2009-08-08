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
 .zero
*=$00

source		.dsb 2
SectorCount	.dsb 1

 .text
*=$500

InitialiseDisc
	;Test: This simply indicates that the tape file has loaded and is running
	lda #"A"
	sta $BB80
	;Test: We loop here to give time to press F11 and debug!
.(
loop	nop
	jmp loop
.)

	;$509 - Disable CPU interrupts
	sei

	;Disabling Internal VIA only prevents a build up of IRQ flags once disk
	;routine ends.
	lda #$7f
	sta via_ier

	;Disable FDC Interrupts	B0=0
	;Switch out ROM 	B1=0
	;Set DSCD		B2=1
	;Single Density		B3=0
	;Side 0			B4=0
	;Drive 0		B5-6=00
	;No RANDOS		B7=1
	lda #%10000100
	sta fdc_Control

	;Restore to Track Zero
	lda #%00001000	;0000??00
	sta fdc_Command

	;Wait until end of Command
.(
loop1	lda fdc_Control
	bmi loop1
.)

;To LOAD a file, we move the head to the desired track.
;We then load the sector into memory then advance sector/track
;and repeat until we have all the sectors.
LoadFile
	;Move to LOAD Track
	ldx GameFileIndex
	lda FileStartTrack,x
	;Load Data register with desired track
	sta fdc_Data
	lda #%00011000	;0001??00
	sta fdc_Command
	;Wait until end of Command - Will step until track reached
.(
loop1	lda fdc_Control
	bmi loop1
.)
	;Store the file sector
	lda FileStartSector,x
	sta fdc_Sector

	;Set up the file destination address
	lda FileStartMemoryHi,x
.(
	sta vector1+2
	ldy #00

	;Set up the number of Sectors to LOAD
	lda FileSectorCount,x
	sta SectorCount

loop2	;Set Read Sector Command
	lda #%10001000	;100??0?0
	sta fdc_Command

	;Read in 256 bytes
loop1	lda fdc_DRQState
	bmi loop1
	lda fdc_Data
vector1	sta $A000,y
	iny
	bne loop1

	;Then wait on Command completion
loop4	lda fdc_Control
	bmi loop4

	;Now Check for errors - Read Sector Again on Error
	lda fdc_Status
	and #%00011100
	bne loop2

	;Update Source(Hi)
	inc vector1+2

	;Update Sector/Track
	lda fdc_Sector
	adc #01
	cmp #18	;17 Sectors per track
	bcc skip2

	;Step In ThVqr
	lda #%01011000	;010???00
	sta fdc_Command

	;Wait for a short while(18 Cycles)
	ldy #03
loop5	dey
	bne loop5

	;Wait on INTRQ Flag
loop3	lda fdc_Control
	bmi loop3

	;Sectors start from 1
	lda #01

skip2	sta fdc_Sector

	;Count Sectors
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


If you held just the number of sectors in the FAT, then we'd need to be able
to calculate the side,track,sector for the start

;X holds FAT index
DetermineStartingSTS
	stx temp01
	lda #00
	sta Track
	sta Side
	lda #01
	sta Sector
	;If first file
	txa
	beq exit
	;Scan FAT for entry, adding sector lengths to templo/hi
	lda #00
	sta templo
	sta temphi
	clc
	ldx #00
loop1	lda FAT,x
	adc templo
	sta templo
	lda temphi
	adc #00
	sta temphi
	inx
	cpx temp01
	bcc loop1
	;now divide templo/hi by number of sectors in Track
	...

If we stored the Side,Track,Sector,SectorCount in the most compact format..

     	Bits	Range
Side 	1	0-1	Byte 0 Bit 0
Track	7	0-79	Byte 0 Bit 1-7
Sector	5	0-17	Byte 1 Bit 0-4
Count	8	1-252	Byte 2 Bit 0-7

Or use the other 3 bits of byte 1 to store up to 8 different sizes..

     	Bits	Range
Side 	1	0-1	Byte 0 Bit 0
Track	7	0-79	Byte 0 Bit 1-7
Sector	5	0-17	Byte 1 Bit 3-7
Count   3	0-7     Byte 1 Bit 0-2
