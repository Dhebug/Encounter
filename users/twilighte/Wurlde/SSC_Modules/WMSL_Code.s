;********* New Mini Script Language for Cut Scenes in Wurlde **************
;Run wmsl_EngineInitialisation first to scan script for rows
;then run wmsl_EngineDriver every 100 milliseconds
#include "wmsl_Defines.s"

 .zero
*=$E0

#include "wmsl_zpage.s"

 .text
*=$C000



;Executed every 100th Second
wmsl_EngineDriver
	;Wait on Seconds delay
	lda wmsl_SecondsDelay
.(
	beq skip2
	dec HundredCounter
	bne skip1
	lda #100
	sta HundredCounter
	dec wmsl_SecondsDelay
skip1	rts

skip2	lda wmsl_MilliDelay
	beq skip3
	dec wmsl_MilliDelay
	rts
skip3	jmp wmsl_ProcessCommands
.)

#include "wmsl_Data.s"
#include "wmsl_common.s"
#include "wmsl_tables.s"

wmsl_EngineInitialisation
	;Check if row list set up by reading first hi address in list(0 not setup)
	lda wmsl_ra_RowListHi
.(
	bne EndOfScript
	;Scan Script to Build Row Address List
	lda #<wmsl_ScriptList
	sta wmsl_Script
	lda #>wmsl_ScriptList
	sta wmsl_Script+1
	ldy #00

loop1	lda wmsl_Script
	ldy wmsl_Engine_RowListIndex
	sta wmsl_ra_RowListLo,y
	lda wmsl_Script+1
	sta wmsl_ra_RowListHi,y
	ldy #00
	lda (wmsl_Script),y
	cmp #22
	beq EndOfScript
	jsr wmsl_EstablishVector
	;Instruction Index in X
	lda wmsl_Script
	clc
	adc wmsl_Instruction_Bytes,x
	sta wmsl_Script
	lda wmsl_Script+1
	adc #00
	sta wmsl_Script+1
	inc wmsl_Engine_RowListIndex
	jmp loop1
EndOfScript
.)
	rts



wmsl_FetchScriptRowAddress
	lda wmsl_ra_RowListLo,x
	sta wmsl_Script
	lda wmsl_ra_RowListHi,x
	sta wmsl_Script+1
	ldy #00
	rts

wmsl_EstablishVector
	ldx #22	;NumberInstructions-1
.(
loop1	cmp wmsl_Instruction_Threshhold,x
	bcs skip1
	dex
	bpl loop1
	;Instruction threshhold table must be corrupt! - RTS Engine
	pla
	pla
	rts
skip1	ldy wmsl_InstructionThreshold_VectorLo,x
.)
	sty wmsl_Vector
	ldy wmsl_InstructionThreshold_VectorHi,x
	sty wmsl_Vector+1
	ldy #01
	sbc wmsl_Instruction_Threshhold,x
	rts

wmsl_ProcessCommands
	ldx wmsl_CurrentScriptRow
	jsr wmsl_FetchScriptRowAddress
	lda (wmsl_Script),y
	cmp #wmsl_END
.(
	beq skip1
	jsr wmsl_EstablishVector
	jmp (wmsl_Vector)
skip1	;End of Script
.)
	rts

;SETALL - Set all parameters associated to a buffer
;For Buffer Area
;+00 BufferID(0-31)
;+01 Width of Area (Variable(0-31) or Value(33-255(0-223)))
;+02 Height of Area (Variable(0-31) or Value(33-255(0-223)))
;+03 Low Address of Buffer (00-FF) or Low Offset of Visible (00-FF)
;+04 High Address of Buffer (Allocate(0) or Value(01-FF) or High Offset of Visible
wmsl_iSETALL
	; Fetch BufferID
	lda (wmsl_Script),y
	tax

	; Fetch Width
	iny
	lda (wmsl_Script),y
	sta wmsl_bp_BufferWidth,x
	sta wmsl_mx_vl

	; Fetch Height
	iny
	lda (wmsl_Script),y
	sta wmsl_bp_BufferHeight,x

	;Branch if dealing with Visible Area
	cpx #32
.(
	bcs skip2

	; Fetch Low Address
	iny
	lda (wmsl_Script),y
	sta wmsl_bp_BufferLo,x

	; Fetch High Address
	iny
	lda (wmsl_Script),y
	beq skip1
	sta wmsl_bp_BufferHi,x

	rts

skip1	;Calculate Buffer size by multiplying Width with Height
	sta wmsl_mx_mx
	jsr wmsl_Multiply

	;Allocate memory
	lda wmsl_am_lo
	sta wmsl_bp_BufferLo,x
	clc
	adc wmsl_mx_lo
	sta wmsl_am_lo

	lda wmsl_am_hi
	sta wmsl_bp_BufferHi,x
	adc wmsl_mx_hi
	sta wmsl_am_hi

	rts

skip2	; Calculate Visible Absolute Location from 16 Bit Offset
.)
	lda wmsl_bp_BufferLo-32,x
	clc
	iny
	adc (wmsl_Script),y
	sta wmsl_bp_VisibleLo-32,x
	lda wmsl_bp_BufferHi-32,x
	iny
	adc (wmsl_Script),y
	sta wmsl_bp_VisibleHi-32,x
	rts

;SETVx - Sets a variables value from a value or another variable
;+00 Variable(0-31) or Value(32-255(0-223))
wmsl_iSETV0
	tax
	lda (wmsl_Script),y
	jsr wmsl_EvaluateValue
	sta wmsl_VariableValue,x
	rts

;SETALLOC - Sets the Auto-Memory Allocation pointer to a specific location
;+00 Low Address(00-FF)
;+01 High Address(00-FF)
wmsl_iSETALLOC
	lda (wmsl_Script),y
	sta wmsl_am_lo
	iny
	lda (wmsl_Script),y
	sta wmsl_am_hi
	rts


;NOT USED
wmsl_iTRANSFERV0
	rts

;INCADDRESS Increment the Buffer or Visible Address Pointer
;+00 BufferID(0-31) VFlag(32)
;+01 Variable(0-31) or Value(33-255(0-223))
wmsl_iINCADDRESS
	lda (wmsl_Script),y
	tax
	iny
	lda (wmsl_Script),y
	jsr wmsl_EvaluateValue
	clc
	adc wmsl_bp_BufferLo,x
	sta wmsl_bp_BufferLo,x
	lda wmsl_bp_BufferHi,x
	adc #00
	sta wmsl_bp_BufferHi,x
	rts


;INCVx - Increments a variables value by an amount specified in a value or another variable
;+00 Variable(0-31) or Value(32-255(0-223))
wmsl_iINCV0
	;A contains embedded variable index
	tax
	lda (wmsl_Script),y
	jsr wmsl_EvaluateValue
	clc
	adc wmsl_VariableValue,x
	sta wmsl_VariableValue,x
	rts

;DECADDRESS Decrement the Buffer or Visible Address Pointer
;+00 BufferID(0-31) VFlag(32)
;+01 Variable(0-31) or Value(33-255(0-223))
wmsl_iDECADDRESS
	lda (wmsl_Script),y
	tax
	iny
	lda (wmsl_Script),y
	jsr wmsl_EvaluateValue
	sta wmsl_internaltemp01
	lda wmsl_bp_BufferLo,x
	sec
	sbc wmsl_internaltemp01
	sta wmsl_bp_BufferLo,x
	lda wmsl_bp_BufferHi,x
	sbc #00
	sta wmsl_bp_BufferHi,x
	rts

;DECVx - Decrements a variables value by an amount specified in a value or another variable
;+00 Variable(0-31) or Value(32-255(0-223))
wmsl_iDECV0
	;A contains embedded variable index
	tax
	lda (wmsl_Script),y
	jsr wmsl_EvaluateValue
	sta wmsl_internaltemp01
	lda wmsl_VariableValue,x
	sec
	sbc wmsl_internaltemp01
	sta wmsl_VariableValue,x
	rts

;BRANCHBACK - Branch back on Condition
;+00 Condition(C)
;+01 Param1
;+02 Param2
;+03 Rows Back
;The branch is performed if..
;C
;0  Param1 is equal to Param2
;1  Param1 is less than Param2
;2  Param1 is more than Param2
;3  Param1 is not Equal to Param2
;4  Param1 is less or equal to Param2
;5  Param1 is more or equal to Param2
wmsl_iBRANCHBACK
	;Use common routine for handling branch so that BranchForth can use it too
	jsr wmsl_CommonBranchCheck

	;Validate Result
.(
	bcc skip1

	;Calculate Row to jump to
	iny
	lda (wmsl_Script),y
	sta wmsl_internaltemp01
	lda wmsl_CurrentScriptRow
	sbc wmsl_internaltemp01
	sta wmsl_CurrentScriptRow

skip1	rts
.)

;BRANCHFORTH - Branch Forward on Condition
;+00 Condition(C)
;+01 Param1
;+02 Param2
;+03 Rows Forward
;The branch is performed if..
;C
;0  Param1 is equal to Param2
;1  Param1 is less than Param2
;2  Param1 is more than Param2
;3  Param1 is not Equal to Param2
;4  Param1 is less or equal to Param2
;5  Param1 is more or equal to Param2
wmsl_iBRANCHFORTH
	;Use common routine for handling branch so that BranchForth can use it too
	jsr wmsl_CommonBranchCheck

	;Validate Result
.(
	bcc skip1

	;Calculate Row to jump to
	iny
	lda (wmsl_Script),y
	clc
	adc wmsl_CurrentScriptRow
	sta wmsl_CurrentScriptRow

skip1	rts
.)


;MOVE - Transfer data from one buffer to the other observing buffer dimension differences.
;+00 Destination BufferID(0-31) VFlag(32)
;+01 Source BufferID(0-31) VFlag(32)
wmsl_iMOVE
	; Fetch Destination Address
	lda (wmsl_Script),y
	tax
	lda wmsl_bp_BufferLo,x
	sta wmsl_destination
	lda wmsl_bp_BufferHi,x
	sta wmsl_destination+1

	; Fetch Source Address
	iny
	lda (wmsl_Script),y
	tay
	lda wmsl_bp_BufferLo,y
	sta wmsl_source
	lda wmsl_bp_BufferHi,y
	sta wmsl_source+1

	; Fetch Destination Buffer Width
	txa
	and #31
	tax
	lda wmsl_bp_BufferWidth,y
	sta wmsl_internaltemp03

	; Fetch specified (Visible or Buffer) Source height
	ldx wmsl_bp_BufferHeight,y

	; Fetch specified(Visible or Buffer) Source Width
	lda wmsl_bp_BufferWidth,y
	sta wmsl_internaltemp01

	; Fetch Source Buffer width
	tya
	and #31
	tay
	lda wmsl_bp_BufferWidth,y
	sta wmsl_internaltemp02

	clc
.(
loop2	ldy wmsl_internaltemp01
	dey
loop1	lda (wmsl_source),y
	sta (wmsl_destination),y
	dey
	bpl loop1

	lda wmsl_internaltemp02	;source buffer width
	jsr wmsl_AddSource

	lda wmsl_internaltemp03	;destination buffer width
	jsr wmsl_AddDestination

	dex
	bne loop2
.)
	rts

;SCROLLPIXELLEFT - Pixel Scroll Left
;+00 BufferID(0-31) VFlag(32)
wmsl_iSCROLLPIXELLEFT
	; Use common routine to set up horizontal parameters
	jsr wmsl_CommonScrollSetup

	; Perform Scroll - Scanning Right to Left
	ldx wmsl_internaltemp01	;area height
.(
loop2	ldy wmsl_internaltemp02	;area width
	dey

	; Perform pixel scroll
loop1	lda (wmsl_source),y	;Fetch next byte
	rol		;Scroll and add previous bit
	and #%01111111	;Clip Bitmap flag
	cmp #%01000000	;Capture B5 into Carry
	ora #%01000000	;Set Bitmap flag
	sta (wmsl_source),y	;And Store

	dey
	bpl loop1

	lda wmsl_internaltemp03	;buffer width
	clc
	jsr wmsl_AddSource

	dex
	bne loop2
.)
	rts

;SCROLLPIXELRIGHT - Pixel Scroll Right
;+00 BufferID(0-31) VFlag(32)
wmsl_iSCROLLPIXELRIGHT
	; Use common routine to set up horizontal parameters
	jsr wmsl_CommonScrollSetup

	; Perform Scroll - Scanning Left to Right
	ldx wmsl_internaltemp01	;area height
.(
loop2	ldy #00			;area width

	; Perform pixel scroll
loop1	lda (wmsl_source),y	;Fetch next byte
	and #%00111111	;Remove Bitmap Flag
	bcc skip1		;Branch if no bit to add
	ora #%01000000	;Add new bit
skip1	lsr		;Scroll out B0 into carry
	ora #%01000000	;Add Bitmap Flag
	sta (wmsl_source),y ;And Store

	iny
	cpy wmsl_internaltemp02
	bcc loop1

	lda wmsl_internaltemp03	;buffer width
	clc
	jsr wmsl_AddSource

	dex
	bne loop2
.)
	rts

;SCROLLBYTELEFT - Byte Scroll Left
;+00 BufferID(0-31) VFlag(32)
wmsl_iSCROLLBYTELEFT
	; Use common routine to set up horizontal parameters
	jsr wmsl_CommonScrollSetup

	; Perform Scroll - Scanning Left to Right
	ldx wmsl_internaltemp01	;area height
.(
loop2	ldy #01	;area width

	; Perform byte scroll
loop1	lda (wmsl_source),y	;Fetch next byte
	dey
	sta (wmsl_source),y	;And Store
	iny
	iny
	cpy wmsl_internaltemp02
	bcc loop1

	lda wmsl_internaltemp03	;buffer width
	clc
	jsr wmsl_AddSource

	dex
	bne loop2
.)
	rts

;SCROLLBYTERIGHT - Byte Scroll Right
;+00 BufferID(0-31) VFlag(32)
wmsl_iSCROLLBYTERIGHT
	; Use common routine to set up horizontal parameters
	jsr wmsl_CommonScrollSetup

	; Perform Scroll - Scanning Right to Left
	ldx wmsl_internaltemp01	;area height
.(
loop2	ldy wmsl_internaltemp02	;area width
	dey

	; Perform byte scroll
loop1	dey
	lda (wmsl_source),y	;Fetch next byte
	iny
	sta (wmsl_source),y	;And Store

	dey
	bpl loop1


	lda wmsl_internaltemp03	;buffer width
	jsr wmsl_AddSource

	dex
	bne loop2
.)
	rts

;SCROLLBYTEUP - Scroll Byte up
;+00 BufferID(0-31) VFlag(32)
wmsl_iSCROLLBYTEUP
	; Use common routine to set up parameters
	jsr wmsl_CommonScrollSetup

	; Set up source2 to one source buffer row below
	lda wmsl_source
	adc wmsl_bp_BufferWidth,y
	sta wmsl_source2
	lda wmsl_source+1
	adc #00
	sta wmsl_source2+1

	;Work Top Down
	ldx wmsl_internaltemp01
.(
loop2	ldy wmsl_internaltemp02	;source area width
	dey
loop1	lda (wmsl_source2),y	;row 1
	sta (wmsl_source),y		;row 0
	dey
	bpl loop1


	lda wmsl_internaltemp03	;buffer width
	jsr wmsl_AddSource

	lda wmsl_internaltemp03	;buffer width
	jsr wmsl_AddSource2

	dex
	bne loop2
.)
	rts

;SCROLLBYTEDOWN - Scroll Byte down
;+00 BufferID(0-31) VFlag(32)
wmsl_iSCROLLBYTEDOWN
	; Use common routine to set up parameters
	jsr wmsl_CommonScrollSetup

	; Calculate the penultimate row in the area
	ldx wmsl_internaltemp01
	dex
.(
loop3	lda wmsl_source
	sta wmsl_source2
	adc wmsl_bp_BufferWidth,y
	sta wmsl_source
	lda wmsl_source+1
	sta wmsl_source2+1
	adc #00
	sta wmsl_source+1
	dex
	bne loop3

	;Work Top Down

loop2	ldy wmsl_internaltemp02	;source area width
	dey
loop1	lda (wmsl_source2),y	;row 0
	sta (wmsl_source),y		;row 1
	dey
	bpl loop1


	lda wmsl_source2
	sta wmsl_source
	sec
	sbc wmsl_internaltemp03	;buffer width
	sta wmsl_source2
	lda wmsl_source2+1
	sta wmsl_source+1
	sbc #00
	sta wmsl_source2+1

	dex
	bne loop2
.)
	rts

;MASK - Mask one buffer with another
;+00 Mask BufferID(0-31) VFlag(32)
;+01 Source BufferID(0-31) VFlag(32)
wmsl_iMASK
	; Fetch Mask Address
	lda (wmsl_Script),y
	tax
	lda wmsl_bp_BufferLo,x
	sta wmsl_mask
	lda wmsl_bp_BufferHi,x
	sta wmsl_mask+1

	; Fetch Source Address
	iny
	lda (wmsl_Script),y
	tay
	lda wmsl_bp_BufferLo,y
	sta wmsl_source
	lda wmsl_bp_BufferHi,y
	sta wmsl_source+1

	; Fetch Mask Buffer Width
	txa
	and #31
	tax
	lda wmsl_bp_BufferWidth,y
	sta wmsl_internaltemp03

	; Fetch specified area Source height
	ldx wmsl_bp_BufferHeight,y

	; Fetch specified area Source Width
	lda wmsl_bp_BufferWidth,y
	sta wmsl_internaltemp01

	; Fetch Source Buffer width
	tya
	and #31
	tay
	lda wmsl_bp_BufferWidth,y
	sta wmsl_internaltemp02

	clc
.(
loop2	ldy wmsl_internaltemp01
	dey
loop1	lda (wmsl_source),y
	and (wmsl_mask),y
	sta (wmsl_source),y
	dey
	bpl loop1

	lda wmsl_internaltemp02	;source buffer width
	jsr wmsl_AddSource

	lda wmsl_internaltemp03	;destination buffer width
	jsr wmsl_AddMask

	dex
	bne loop2
.)
	rts

;DELAY - Delay the sequence by seconds and milliseconds
;+00 Seconds (0-255)
;+01 Milliseconds (0-99)
wmsl_iDELAY
	lda (wmsl_Script),y
	sta wmsl_SecondsDelay
	iny
	lda (wmsl_Script),y
	sta wmsl_MilliDelay
	rts


;FILL - Fill a buffer with a value
;+00 BufferID(0-31) VFlag(32)
;+01 Value
wmsl_iFILL
	; Fetch BufferID
	lda (wmsl_Script),y
	tax

	; Fetch Value
	iny
	lda (wmsl_Script),y
	pha

	;
	txa
	and #31
	tay
	jsr wmsl_CommonDimensionsSetup

	;Work Top Down
	ldx wmsl_internaltemp01

	;
	pla
	sta wmsl_internaltemp01

.(
loop2	ldy wmsl_internaltemp02	;source area width
	dey
	lda wmsl_internaltemp01
loop1	sta (wmsl_source),y		;row 0
	dey
	bpl loop1


	lda wmsl_internaltemp03	;buffer width
	jsr wmsl_AddSource

	dex
	bne loop2
.)
	rts


;BIT - Set Bits in Buffer
;+00 BufferID(0-31) VFlag(32)
;+01 Bits
;+02 Mask
wmsl_iBIT
	; Fetch BufferID
	lda (wmsl_Script),y
	tax

	; Fetch Bits
	iny
	lda (wmsl_Script),y
	sta wmsl_internaltemp04

	; Fetch Mask
	iny
	lda (wmsl_Script),y
	sta wmsl_internaltemp05

	;
	txa
	and #31
	tay
	jsr wmsl_CommonDimensionsSetup

	; Work Top Down
	ldx wmsl_internaltemp01

.(
loop2	ldy wmsl_internaltemp02	;source area width
	dey

loop1	lda (wmsl_source),y		;row 0
	and wmsl_internaltemp05
	ora wmsl_internaltemp04
	sta (wmsl_source),y
	dey
	bpl loop1


	lda wmsl_internaltemp03	;buffer width
	jsr wmsl_AddSource

	dex
	bne loop2
.)
	rts

;RANDOMVx - Assign a random number to a variable
;+00 Scope of Random number (0-255)
wmsl_iRANDOMV0
	tax
	lda (wmsl_Script),y
;	jsr GetRandRange
	sta wmsl_VariableValue,x
	rts

;END - End of Script
wmsl_iEND
;MIRROR - Horizontal Mirror of a Buffer
;EXTRACT - Extract rectanglefrom one buffer and deposit in another
