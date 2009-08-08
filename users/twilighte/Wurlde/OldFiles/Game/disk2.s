;


DiscInit
	;Switch out ROM and enable Mode1 control for detecting data ready
	lda fdc_control
	and #%11111100
	sta fdc_control
.(
loop2	;Move Track to 0
	lda #%00001100
	;     0000hVqr
	sta fdc_Command
loop1	lda fdc_INTRQ
	bmi loop1
	lda fdc_Status
	and #%00010000
	bne loop2
.)
	rts


DiscLoad
	;Wait for Disc inactivity
loop1	lda fdc_Status
	lsr
	bcs loop1
	;
	ldx FileIndex
	lda DiscFileTrack,x
	;Seek Track
	sta fdc_Data
	lda #%00010000
	sta fdc_Command
loop1	lda fdc_DRQState
	bmi loop1
	;Setup Sector
	lda DiscFileSector,x
	sta fdc_Sector
	;Setup File Load Address and Length(256 Blocks)
	lda DiscFileLoadLo,x
	sta source
	lda DiscFileLoadHi,x
	sta source
	lda DiscFileLength,x
	tax
	ldy #00
loop3	;Read Sector
	lda %10000000
	sta fdc_Command
loop2	lda fdc_DRQState
	bmi loop2
	;Capture byte
	lda fdc_Data
	sta (source),y
	iny
	bne loop1
	inc source+1
	;Increment Track
	lda #01000000
	sta fdc_Command
	;Wait on command completion
loop1	lda fdc_Status
	lsr
	bcs loop1
	dex
	bne loop3
	rts
