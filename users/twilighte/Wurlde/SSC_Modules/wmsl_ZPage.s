;wmsl_ZPage.s

;Script Pointer
wmsl_Script	.dsb 2
;Vector for Jumps
wmsl_Vector	.dsb 2
wmsl_source	.dsb 2
wmsl_source2
wmsl_destination	.dsb 2
wmsl_mask		.dsb 2

;Multiplication Parameters
wmsl_mx_mx	.dsb 1	;Multiplier
wmsl_mx_vl	.dsb 1	;Value to multiply
wmsl_mx_lo	.dsb 1	;16 Bit Result
wmsl_mx_hi	.dsb 1	;16 Bit Result

;WMSL Temporary variables
wmsl_internaltemp01		.dsb 1
wmsl_internaltemp02		.dsb 1
wmsl_internaltemp03		.dsb 1
wmsl_internaltemp04		.dsb 1
wmsl_internaltemp05		.dsb 1
wmsl_externaltemp01		.dsb 1
wmsl_externaltemp02		.dsb 1
