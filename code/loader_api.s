; 
; Small code to implement the loading of data while a program is running.
; What it does is to call the loader module, it abstracts the actual loader implementation 
;
	;.bss

  ;*=$FFEF

_LoaderApiLoadingAnimation = $FFE9
_LoaderApiSaveData	       =$FFEC  

_LoaderApiFileStartSector =$FFEF
_LoaderApiFileStartTrack  =$FFF0

_LoaderApiFileSize       =$FFF1
_LoaderApiFileSizeLow 	 =$FFF1
_LoaderApiFileSizeHigh 	 =$FFF2

_LoaderApiJump		     =$FFF3
_LoaderApiAddress        =$FFF4
_LoaderApiAddressLow 	 =$FFF4
_LoaderApiAddressHigh 	 =$FFF5

_LoaderFDCRegisterOffset =$FFF6

_LoaderApiLoadFile		 =$FFF7

	.text

	;*=_LoaderApiFileStartSector-1500
;
; Include the directory information from the floppy builder generated file
;
#define ASSEMBLER
#define LOADER                        ; We request the actual table data to be included in the file
#include "../build/floppy_description.h"       ; This file is generated by the floppy builder

_LoaderApiEntryIndex			.byt 0

; Assumes that _LoaderApiEntryIndex contains a valid value (temp)
; As well as _LoaderApiAddress
; It fills the rest
_LoadApiInitializeFileFromDirectory
	ldx _LoaderApiEntryIndex

	lda FileStartSector,x
	sta _LoaderApiFileStartSector

	lda FileStartTrack,x
	sta _LoaderApiFileStartTrack

	lda FileSizeLow,x
	sta _LoaderApiFileSizeLow

	lda FileSizeHigh,x
	sta _LoaderApiFileSizeHigh
    rts

_LoadApiLoadFileFromDirectory
    jsr _LoadApiInitializeFileFromDirectory
	jmp _LoaderApiLoadFile

; CHEMA: Support saving
; Assumes that _LoaderApiEntryIndex contains a valid value (temp)
; As well as _LoaderApiAddress
; It fills the rest
_LoadApiSaveFileFromDirectory
	jsr _LoadApiInitializeFileFromDirectory
	jmp _LoaderApiSaveData
