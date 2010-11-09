;Patch Tape - When loading from tape ROM erases BB80-BBA2 before calling game so we need to restore the score
;with the data below..

RestoreTapeLoad
	ldx #34
.(
loop1	lda PatchMemory,x
	sta $BB80,x
	dex
	bpl loop1
.)
	rts
PatchMemory
 .byt $06,$C1,$6F,$7A,$E1,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$E1,$DE,$40,$66,$66,$4C,$E1,$40,$66,$66,$E1,$C0,$C1,$E1,$7F
