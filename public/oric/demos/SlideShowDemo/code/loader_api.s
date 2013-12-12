; 
; Small code to implement the loading of data while a program is running.
; What it does is to call the loader module, it abstracts the actual loader implementation 
;

	.zero



	.text

_LoaderApiEntryIndex	.byt 0
_LoaderApiSaveIrqLow	.byt 0
_LoaderApiSaveIrqHigh	.byt 0


_LoadFile
.(
	ldx _LoaderApiEntryIndex
	jmp $fff7					; _LoadFile
.)

