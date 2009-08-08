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

#define	SystemFlag	$0200	;00(Microdisc) E4(Jasmin)
#define	SectorCount	$0201
#define TrackSectors	$0202	;Number of Sectors in a Track
#define	DiskTracks	$0203	;Number of Tracks on Disk?

#define	FAT		$FF00

*=$FE00
GenericLOAD
	sei
	;Store the Save Address
.(
	sta vector1+2

	;Multiply File Number by 2 to get FAT index
	txa
	asl
	tay

	;Fetch and Store FAT Side
	lda FAT,y
	lsr		;Pushes Side into Carry leaving Track in Acc
	pha
	ldx SystemFlag	;Branch on System
	bne skip3
	lda fdc_Control	;Deal Microdisc
	and #%11101111
	bcc skip1
	ora #%00010000
skip1	sta fdc_Control
	jmp skip2
skip3	rol             ;Deal Jasmin
	sta jsm_Side
skip2
.)
	;Fetch and Seek FAT Track
	pla
	sta fdc_Data,x
	lda #%00011000
	sta fdc_Command,x
loop1	lda fdc_Status,x
	lsr
	bcs loop1

	;Fetch and store FAT Sector
	lda FAT+1,y
	lsr
	lsr
	lsr
	sta fdc_Sector,x

	;Fetch and Store FAT Length
	lda FAT+1,y
	and #7
	tay
	lda SectorCounts,y
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
	bne loop1
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
.)
	;Re enable IRQ and End
	cli
	rts



