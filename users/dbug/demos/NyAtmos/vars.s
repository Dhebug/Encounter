
	.bss

	
;
; Allign the content of BSS section to a byte boudary
;
	.dsb 256-(*&255)

_BssStart_

	.dsb 256-(*&255)

_HiresAddrLow			.dsb 201

	.dsb 256-(*&255)

_HiresAddrHigh			.dsb 201
						
	.dsb 256-(*&255)

_TableDiv6				.dsb 256

	;.dsb 256-(*&255)

_TableBit6Reverse		.dsb 256

	;.dsb 256-(*&255)
	

_BssEnd_

	.text
	
	


