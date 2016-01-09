; 
; Small code to implement the loading of data while a program is running.
; What it does is to call the loader module, it abstracts the actual loader implementation 
;
	.text

_LoaderApiEntryIndex	.byt 0

_LoaderApiAddress
_LoaderApiAddressLow	.byt 0
_LoaderApiAddressHigh	.byt 0

_LoaderApiLoadFile
	ldx _LoaderApiEntryIndex
_LoaderApiLoadFileRegister	
	jmp $fff7					; _LoadFile

_LoaderApiSetLoadAddress
	lda _LoaderApiAddressLow
	ldy _LoaderApiAddressHigh
	ldx _LoaderApiEntryIndex
_LoaderApiSetLoadAddressRegister	
	jmp $fff4					; SetLoadAddress


; x: file index
; a: Low part of address
; y: High part of address
_LoaderApiLoadFileAtAddressRegister
	jsr $fff4					; SetLoadAddress
	jmp $fff7					; _LoadFile
