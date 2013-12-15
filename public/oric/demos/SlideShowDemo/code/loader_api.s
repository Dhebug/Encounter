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
	ldx _LoaderApiEntryIndex
	jmp $fff7					; _LoadFile

_SetLoadAddress
	lda _LoaderApiAddressLow
	ldy _LoaderApiAddressHigh
	ldx _LoaderApiEntryIndex
	jmp $fff4					; SetLoadAddress



