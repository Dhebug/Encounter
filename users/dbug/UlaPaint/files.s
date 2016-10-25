
_FileFlagForceAdress	.byt	0
_FileAdress				.byt	0,0
_FileSize				.byt	0,0

; =========================================
;		Load a file from tape
; =========================================
_FileLoad
	;jmp	_FileLoad
	php
	jsr $e76a			; Disable keyboard, enable tape engine remote 

	jsr $e4ac			; Read tape header

	lda	_FileFlagForceAdress
	beq	continue_load

	; Patch load start and end adress
	clc
	lda	_FileAdress
	sta	$2a9
	adc #<8000-1
	sta	$2ab
	lda	_FileAdress+1
	sta	$2aa
	adc #>8000-1
	sta	$2ac
continue_load

	jsr $e4e0			; Perform loading of data

	jsr $e93d			; Restore keyboard, and stop engine remote
	plp
	rts



; =========================================
;		Save a file from tape
; =========================================
_FileSave
	php
	jsr $e76a			; Disable keyboard, enable tape engine remote 

	; Fast mode
	lda #0
	sta $24d

	; Binary mode
	lda #80
	sta $24e


	; Patch save start and end adress
	clc
	lda	_FileAdress
	sta	$2a9
	adc #<8000-1
	sta	$2ab
	lda	_FileAdress+1
	sta	$2aa
	adc #>8000-1
	sta	$2ac

	jsr $e75e			; Write synchronisation bytes
	jsr $e607			; Write tape header
	jsr $e62e			; Perform saving of data

	jsr $e93d			; Restore keyboard, and stop engine remote
	plp
	rts

