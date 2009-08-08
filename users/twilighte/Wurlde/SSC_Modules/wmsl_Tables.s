;wmsl_Tables.s

wmsl_SecondsDelay		.byt 0
HundredCounter		.byt 100
wmsl_MilliDelay		.byt 0
wmsl_CurrentScriptRow         .byt 0
wmsl_eval_temp		.byt 0

;Allocated Memory Pointer
wmsl_am_lo		.byt 0
wmsl_am_hi		.byt 0

;Temporary Variables
wmsl_Engine_RowListIndex	.byt 0	;Used in setting up row table

;Instruction Lookup Tables
wmsl_Instruction_Threshhold
 .byt 000	;wmsl_iSETALL
 .byt 001 ;wmsl_iSETV0
 .byt 033 ;wmsl_iSETALLOC
 .byt 034 ;wmsl_iTRANSFERV0
 .byt 066 ;wmsl_iINCADDRESS
 .byt 067 ;wmsl_iINCV0
 .byt 099 ;wmsl_iDECADDRESS
 .byt 100 ;wmsl_iDECV0
 .byt 132 ;wmsl_iBRANCHBACK
 .byt 133 ;wmsl_iBRANCHFORTH
 .byt 134 ;wmsl_iMOVE
 .byt 135 ;wmsl_iSCROLLPIXELLEFT
 .byt 136 ;wmsl_iSCROLLBYTERIGHT
 .byt 137 ;wmsl_iSCROLLBYTEUP
 .byt 138 ;wmsl_iSCROLLBYTEDOWN
 .byt 139 ;wmsl_iSCROLLPIXELRIGHT
 .byt 140 ;wmsl_iSCROLLBYTELEFT
 .byt 141 ;wmsl_iMASK
 .byt 142 ;wmsl_iDELAY
 .byt 143 ;wmsl_iFILL
 .byt 144 ;wmsl_iBIT
 .byt 145 ;wmsl_iRANDOMV0
 .byt 177 ;wmsl_iEND

wmsl_InstructionThreshold_VectorLo
 .byt <wmsl_iSETALL
 .byt <wmsl_iSETV0
 .byt <wmsl_iSETALLOC
 .byt <wmsl_iTRANSFERV0
 .byt <wmsl_iINCADDRESS
 .byt <wmsl_iINCV0
 .byt <wmsl_iDECADDRESS
 .byt <wmsl_iDECV0
 .byt <wmsl_iBRANCHBACK
 .byt <wmsl_iBRANCHFORTH
 .byt <wmsl_iMOVE
 .byt <wmsl_iSCROLLPIXELLEFT
 .byt <wmsl_iSCROLLBYTERIGHT
 .byt <wmsl_iSCROLLBYTEUP
 .byt <wmsl_iSCROLLBYTEDOWN
 .byt <wmsl_iSCROLLPIXELRIGHT
 .byt <wmsl_iSCROLLBYTELEFT
 .byt <wmsl_iMASK
 .byt <wmsl_iDELAY
 .byt <wmsl_iFILL
 .byt <wmsl_iBIT
 .byt <wmsl_iRANDOMV0
 .byt <wmsl_iEND

wmsl_InstructionThreshold_VectorHi
 .byt >wmsl_iSETALL
 .byt >wmsl_iSETV0
 .byt >wmsl_iSETALLOC
 .byt >wmsl_iTRANSFERV0
 .byt >wmsl_iINCADDRESS
 .byt >wmsl_iINCV0
 .byt >wmsl_iDECADDRESS
 .byt >wmsl_iDECV0
 .byt >wmsl_iBRANCHBACK
 .byt >wmsl_iBRANCHFORTH
 .byt >wmsl_iMOVE
 .byt >wmsl_iSCROLLPIXELLEFT
 .byt >wmsl_iSCROLLBYTERIGHT
 .byt >wmsl_iSCROLLBYTEUP
 .byt >wmsl_iSCROLLBYTEDOWN
 .byt >wmsl_iSCROLLPIXELRIGHT
 .byt >wmsl_iSCROLLBYTELEFT
 .byt >wmsl_iMASK
 .byt >wmsl_iDELAY
 .byt >wmsl_iFILL
 .byt >wmsl_iBIT
 .byt >wmsl_iRANDOMV0
 .byt >wmsl_iEND

wmsl_Instruction_Bytes
 .byt 6	;00 wmsl_SETALL
 .byt 2   ;01 wmsl_SETV0
 .byt 3   ;02 wmsl_SETALLOC
 .byt 2   ;03 wmsl_TRANSFERV0
 .byt 3   ;04 wmsl_INCADDRESS
 .byt 2   ;05 wmsl_INCV0
 .byt 3   ;06 wmsl_DECADDRESS
 .byt 2   ;07 wmsl_DECV0
 .byt 5   ;08 wmsl_BRANCHBACK
 .byt 5   ;09 wmsl_BRANCHFORTH
 .byt 3   ;10 wmsl_MOVE
 .byt 3   ;11 wmsl_SCROLLLEFT6
 .byt 3   ;12 wmsl_SCROLLRIGHT6
 .byt 3   ;13 wmsl_SCROLLUP1
 .byt 3   ;14 wmsl_SCROLLDOWN1
 .byt 3   ;15 wmsl_SCROLLLEFT1
 .byt 3   ;16 wmsl_SCROLLRIGHT1
 .byt 4   ;17 wmsl_MASKMOVE
 .byt 3   ;18 wmsl_DELAY
 .byt 3   ;19 wmsl_FILL
 .byt 4   ;20 wmsl_BIT
 .byt 2   ;21 wmsl_RANDOMV0
 .byt 1   ;22 wmsl_END
 .byt 0   ;23 Reserved for Initialisation of Row

wmsl_BranchConditionVectorLo
 .byt <wmsl_Comparison_varEQvar
 .byt <wmsl_Comparison_varLSvar
 .byt <wmsl_Comparison_varMRvar
 .byt <wmsl_Comparison_varNTvar
 .byt <wmsl_Comparison_varLEvar
 .byt <wmsl_Comparison_varMEvar
wmsl_BranchConditionVectorHi
 .byt >wmsl_Comparison_varEQvar
 .byt >wmsl_Comparison_varLSvar
 .byt >wmsl_Comparison_varMRvar
 .byt >wmsl_Comparison_varNTvar
 .byt >wmsl_Comparison_varLEvar
 .byt >wmsl_Comparison_varMEvar
wmsl_Param1	.byt 0

;Buffer Property Tables(32 Buffers)
;The tables are organised as Buffer,Offset so VFlag adds 32 to index
wmsl_bp_BufferLo
 .dsb 32,0
wmsl_bp_VisibleLo
 .dsb 32,0
wmsl_bp_BufferHi
 .dsb 32,0
wmsl_bp_VisibleHi
 .dsb 32,0
wmsl_bp_BufferWidth
 .dsb 32,0
wmsl_bp_VisibleWidth
 .dsb 32,0
wmsl_bp_BufferHeight
 .dsb 32,0
wmsl_bp_VisibleHeight
 .dsb 32,0

;WMSL Variable List(32)
wmsl_VariableValue
 .dsb 32,0

