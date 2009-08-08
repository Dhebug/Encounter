;wmsl_Common.s - Common Routines used in WMSL

;Evaluates the entity passed as either a value(0-223) or a variable(224-255)
;and returns the value.
; A Entity
;Returned
; A Value
;Corrupts
; A
wmsl_EvaluateValue
	cmp #224
.(
	bcc skip1
	stx wmsl_eval_temp
	tax
	lda wmsl_VariableValue-224,x
	ldx wmsl_eval_temp
skip1	rts
.)


;wmsl_CommonBranchCheck - Common to BranchBack and BranchForth
; (wmsl_Script)+1	Script based Condition
; (wmsl_Script)+2	Script based Parameter1
; (wmsl_Script)+3	Script based Parameter2
wmsl_CommonBranchCheck
	;Fetch Condition
	lda (wmsl_Script),y

	;Set up jump vector for condition
	tax
	lda wmsl_BranchConditionVectorLo,x
.(
	sta vector1+1
	lda wmsl_BranchConditionVectorHi,x
	sta vector1+2

	;Fetch and Evaluate Param1
	iny
	lda (wmsl_Script),y
	jsr wmsl_EvaluateValue
	sta wmsl_externaltemp01

	;Fetch and evaluate Param2
	iny
	lda (wmsl_Script),y
	jsr wmsl_EvaluateValue

	;Perform Comparison
vector1	jsr $DEAD
.)
	rts


;wmsl_Comparison_varEQvar = Branch Comparison Equal
; wmsl_externaltemp01  - Value to Compare
; A		   - Value to Compare
wmsl_Comparison_varEQvar
	cmp wmsl_externaltemp01
.(
	beq skip1
	clc
skip1	rts
.)

;wmsl_Comparison_varLSvar = Branch Comparison Less
; wmsl_externaltemp01  - Value to Compare
; A		   - Value to Compare
wmsl_Comparison_varLSvar
	cmp wmsl_externaltemp01
.(
	bcc skip1
	clc
	rts
skip1	sec
	rts
.)

;wmsl_Comparison_varMRvar = Branch Comparison More
; wmsl_externaltemp01  - Value to Compare
; A		   - Value to Compare
wmsl_Comparison_varMRvar
	cmp wmsl_externaltemp01
.(
	bne skip1
	clc
skip1	rts
.)

;wmsl_Comparison_varNTvar = Branch Comparison Not Equal
; wmsl_externaltemp01  - Value to Compare
; A		   - Value to Compare
wmsl_Comparison_varNTvar
	cmp wmsl_externaltemp01
.(
	bne skip1
	sec
	rts
skip1	clc
	rts
.)

;wmsl_Comparison_varLEvar = Branch Comparison Less or Equal
; wmsl_externaltemp01  - Value to Compare
; A		   - Value to Compare
wmsl_Comparison_varLEvar
	cmp wmsl_externaltemp01
.(
	beq skip1
	bcc skip1
	clc
	rts
skip1	sec
	rts
.)

;wmsl_Comparison_varMEvar = Branch Comparison More or Equal
; wmsl_externaltemp01  - Value to Compare
; A		   - Value to Compare
wmsl_Comparison_varMEvar
	cmp wmsl_externaltemp01
	rts


;
;
wmsl_CommonScrollSetup
	; Fetch BufferID
	lda (wmsl_Script),y
	tax
	and #31
	tay

	;
	jsr wmsl_CommonDimensionsSetup

	clc
	rts

;wmsl_CommonDimensionsSetup - ?
;Parsed
;x == Area index (0-31) vflag(32)
;y == buffer index (0-31)
wmsl_CommonDimensionsSetup
	; Fetch Area address
	lda wmsl_bp_BufferLo,x
	sta wmsl_source
	lda wmsl_bp_BufferHi,x
	sta wmsl_source+1

	; Fetch Area Height
	lda wmsl_bp_BufferHeight,x
	sta wmsl_internaltemp01

	; Fetch Area Width
	lda wmsl_bp_BufferWidth,x
	sta wmsl_internaltemp02

	; Fetch Buffer Width
	lda wmsl_bp_BufferWidth,y
	sta wmsl_internaltemp03
	rts


;wmsl_addsource - Add a value to the 16bit zp source
;Note - Carry must be clear before entering.
;Parsed
; A Value to Add to Source
wmsl_AddSource
	adc wmsl_source
	sta wmsl_source
	lda wmsl_source+1
	adc #00
	sta wmsl_source+1
	rts

;wmsl_addsource2 - Add a value to the 16bit zp source2
;Note - Carry must be clear before entering.
;Parsed
; A Value to Add to Source2
wmsl_AddMask
wmsl_AddDestination
wmsl_AddSource2
	adc wmsl_source2
	sta wmsl_source2
	lda wmsl_source2+1
	adc #00
	sta wmsl_source2+1
	rts

;wmsl_Multiply
;Multiply an 8bit number with an 8bit number and produce a 16bit result
;wmsl_mx_mx	Multiplier
;wmsl_mx_vl	Value to multiply
;wmsl_mx_Lo	16 Bit Result
;wmsl_mx_Hi	16 Bit Result
;* If the Multiplier is more than 10 locate the table to speed up
wmsl_Multiply
	; Setup
	lda #00
	sta wmsl_mx_lo
	sta wmsl_mx_hi
.(
	; Branch if multiplier is Null
	ldx wmsl_mx_mx
	beq skip1

	; Saves 2 cycles keeping CLC out of loop
	clc

loop1	;
	lda wmsl_mx_lo
	adc wmsl_mx_vl
	sta wmsl_mx_lo
	lda wmsl_mx_hi
	adc #00
	sta wmsl_mx_hi
	dex
	bne loop1
skip1	rts
.)
