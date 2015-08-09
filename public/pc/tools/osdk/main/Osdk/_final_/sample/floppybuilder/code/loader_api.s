; 
; Small code to implement the loading of data while a program is running.
; What it does is to call the loader module, it abstracts the actual loader implementation 
;

	.zero



	.text

_LoaderApiEntryIndex	.byt 0

_LoaderApiAddress
_LoaderApiAddressLow	.byt 0
_LoaderApiAddressHigh	.byt 0


_LoadFile
	; Draw the 'Loading Data message'
	;ldx #126
	;stx $bb80+40*26+39
	;inx
	;stx $bb80+40*27+39
	ldx _LoaderApiEntryIndex
_LoadFileRegister	
	jsr $fff7					; _LoadFile

	; Erase the 'Loading Data message'
	;ldx #16
	;stx $bb80+40*26+39
	;stx $bb80+40*27+39
	rts

_SetLoadAddress
	lda _LoaderApiAddressLow
	ldy _LoaderApiAddressHigh
	ldx _LoaderApiEntryIndex
_SetLoadAddressRegister	
	jmp $fff4					; SetLoadAddress


; x: file index
; a: Low part of address
; y: High part of address
_LoadFileAtAddressRegister
	jsr $fff4					; SetLoadAddress
	jmp $fff7					; _LoadFile
