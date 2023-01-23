;
; Tape 2 Disk
;
; Tape loading code based on Au Coeur de l'Oric Atmos
;
; Sedoric access code based on "Routines pour Sedoric" by Simon G,
; published in CEO MAG No 153 (Janvier 2003), page 31
;

; Usefule tape ROM routines
SetupTape       = $e76a 	; Prepare VIA for take reading
RestoreVIAState = $e93d 	; Restore the VIA state
TapeSync		= $e4ac 	; Read the header
GetTapeData     = $e4e0 	; Actual loading of the tape content
PrintSearching  = $e57d 	; Display "searching..." in the status bar
PrintLoading    = $e59b 	; Display "loading ..." in the status bar
PrintSaving     = $e585   ; Display "saving..." in the status bar

	.zero       ; Zero page addresses

	*=$50		; Our zero page addresses

_LoadAdress	          .dsb 2

_OriginalStartAddress .dsb 2
_OriginalEndAddress   .dsb 2
_FileSize             .dsb 2

	*=$E9		; System zero page addresses

_system_txtptr		.dsb 2		; $E9 -Position pointer in program	

	.bss 

	*=$293		; System page 2 addresses

_tape_file_name		.dsb 17     ; $293 - Name of the file loaded from the tape
_tape_unknown1      .dsb 5      ; $2a4/$2a5/$2a6/$2a7/$2a8 - ???
_tape_start_addr	.dsb 2		; $2a9 - Start address of the program on the tape
_tape_end_addr		.dsb 2		; $2ab - End address of the program on the tape
_tape_auto_flag     .dsb 1      ; $2ad - Auto indicator (0 means OFF)

	*=$BFF2      ; Area just before the ROM

; Sedoric accepts 9.3 filenames
; 123456789.123
; DBUG_0500.TR1

; 'NNNN-000.TR1'
_FileName  ; Any valid name, without quotes or jokers, finished by $00 right after the end of the name
	.dsb 4			; $BFF2 - the Prefix
	.dsb 1          ; $BFF6 - A
_FileLoadAddress	
	.dsb 4			; $BFF7 - the load address
_FileExtension	
	.dsb 1          ; .
	.dsb 2			; TR
_FileNumber	
	.dsb 1          ; $BFFE - Number
	.dsb 0          ; $BFFF - Null terminator

; BFF2 O
; BFF3 S
; BFF4 D
; BFF5 K
; BFF6 -
; BFF7 0
; BFF8 0
; BFF9 0
; BFFA 0
; BFFB .
; BFFC T
; BFFD R
; BFFE 1
; BFFF 0
; C000 ---- ROM


	*=$C04d		; SEDORIC system variables and constants

#define overlay_switch	$04F2 	; enable or disable Overlay RAM

#define SEDORIC_SAVEU  $C0
#define SEDORIC_SAVEO  $00

_sedoric_vsalo0		.dsb 1      ; $C04d - b6=",V"  b7=",N"
_sedoric_vsalo1     .dsb 1      ; $C04e - b6=",A"  b7=",J"
_sedoric_lgsalo		.dsb 2 		; $C04F - Length of the file (FISALO-DESALO)
_sedoric_ftype      .dsb 1      ; $C051 - Type of the file ($40=machine code, no auto run)
_sedoric_desalo		.dsb 2 		; $C052 - Start address of a file (DE=Debut)
_sedoric_fisalo 	.dsb 2 		; $C054 - End address of a file (FI=Fin)

	.text 

main
	/*
	lda #16+1
	sta $BB80
	lda #16+2
	sta $BB80
	jmp main
	*/
load_from_tape
	jsr SetupTape		; Prepare VIA for take reading
	jsr PrintSearching	; Display "searching..." (not mandatory)
	jsr TapeSync		; Read the header

	inc _FileNumber     ; One more file
	lda _FileNumber     ; Display the number on the status line
	sta $BB80+39
	lda #2
	sta $BB80+38

;wait: jmp wait	

	; Store the start address
	lda	_tape_start_addr+0
	sta	_OriginalStartAddress+0
	jsr byte_to_ascii
	sty _FileLoadAddress+3
	sta _FileLoadAddress+2
	lda	_tape_start_addr+1
	sta	_OriginalStartAddress+1
	jsr byte_to_ascii
	sty _FileLoadAddress+1
	sta _FileLoadAddress+0

	; Store the end address
	lda	_tape_end_addr+0
	sta	_OriginalEndAddress+0
	lda	_tape_end_addr+1
	sta	_OriginalEndAddress+1

	sec
	lda	_tape_end_addr+0
	sbc _tape_start_addr+0
	sta _FileSize+0
	lda	_tape_end_addr+1
	sbc _tape_start_addr+1
	sta _FileSize+1


	clc   ; +1 on the filesize
	lda	_LoadAdress+0
	sta	_tape_start_addr+0
	adc _FileSize+0
	sta	_tape_end_addr+0
	lda	_LoadAdress+1
	sta	_tape_start_addr+1
	adc _FileSize+1
	sta	_tape_end_addr+1

	lda #0
	sta _tape_auto_flag

	jsr PrintLoading	; Display "loading ..." (not mandatory)
	jsr GetTapeData		; Actual loading
	jsr RestoreVIAState	; Restore the VIA state

save_to_disk
	jsr PrintSaving  	; Display "saving ..." (not mandatory)

	lda #<_FileName 	; set TXTPTR to point on the filename
	sta _system_txtptr+0
	lda #>_FileName
	sta _system_txtptr+1

	jsr overlay_switch 	; enable overlay ram

	lda #0 				; verify filename and copy it to bufnom (C028)
	jsr $d454 	

	ldx #3 				; Copy the four bytes containing the start and end address to DESALO and FISALO
loop	
	lda _tape_start_addr,x
	sta _sedoric_desalo,x
	dex
	bpl loop

	lda #SEDORIC_SAVEO   ; store the code of the command to execute (saveu or saveo) in vsalo0
	sta _sedoric_vsalo0	

	lda #$00 			 ; no parameters to store in vsalo1
	sta _sedoric_vsalo1

	lda #$40 			; store ftype: machine code,
	sta _sedoric_ftype 	; not auto

	jsr $de0b 			; computes lgsalo and call xsaveb
	jsr overlay_switch 	; disable overlay ram

	jmp load_from_tape


; http://forum.6502.org/viewtopic.php?t=3164
;  A = entry value
;  A = MSN ASCII char
;  Y = LSN ASCII char
byte_to_ascii
	sed        ;2  @2
	tax        ;2  @4
	and #$0F   ;2  @6
	cmp #9+1   ;2  @8
	adc #$30   ;2  @10
	tay        ;2  @12
	txa        ;2  @14
	lsr        ;2  @16
	lsr        ;2  @18
	lsr        ;2  @20
	lsr        ;2  @22
	cmp #9+1   ;2  @24
	adc #$30   ;2  @26
	cld        ;2  @28
	rts


_BufferLoad

