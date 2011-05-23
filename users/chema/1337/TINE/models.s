__models_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ==================== Model description file =======================
;Shape Data clawed out from original 6502 elite data files by Ian Bell
;Conversion by modelimport. DO NOT EDIT BY HAND
;
; Ship format is type, number of vertices, number of faces
; Vertices, X coordinates, Y coordinates and Z coordinates
; Face data is num vertices-1, fill pattern, list of vertices
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Model of ship ADDER
ADDER
	.byt 0	; Ship type
	.byt 18	;Number of vertices
	.byt 14	;Number of faces

;Normals List - X coordinate
	.byt $00,$00,$B4,$B4,$D1,$D1,$00,$2F,$2F,$4C,$4C,$00,$00,$00
;Normals List - Y coordinate
	.byt $5C,$A4,$37,$C9,$52,$AE,$00,$52,$AE,$37,$C9,$5F,$A1,$5C
;Normals List - Z coordinate
	.byt $E9,$E9,$F2,$F2,$00,$00,$5F,$00,$00,$F2,$F2,$00,$00,$E9;

;Vertices List - X coordinate
	.byt $EE,$12,$1E,$1E,$12,$EE,$E2,$E2,$EE,$12,$EE,$12,$EE,$12,$F5,$0B,$0B,$F5

;Vertices List - Y coordinate
	.byt $00,$00,$00,$00,$07,$07,$00,$00,$F9,$F9,$F9,$F9,$07,$07,$FD,$FD,$FC,$FC

;Vertices List - Z coordinate
	.byt $28,$28,$E8,$D8,$D8,$D8,$D8,$E8,$D8,$D8,$0D,$0D,$0D,$0D,$1D,$1D,$18,$18

; Face data
	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,10,0,1,11


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 13,12,0,1,13


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,11,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,13,1,2


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,11,2,3,9


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,13,2,3,4


	.byt 6	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,4,5,6,8,9,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 10,8,6,7,10


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,5,6,7,12


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 10,7,0,10


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,7,0,12


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 10,11,9,8,10


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,13,4,5,12


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 17,14,15,16,17


; End of ship ADDER data

; Model of ship ANACONDA
ANACONDA
	.byt 0	; Ship type
	.byt 15	;Number of vertices
	.byt 12	;Number of faces

;Normals List - X coordinate
	.byt $00,$2F,$4A,$00,$B6,$D1,$00,$4A,$4D,$B3,$B6,$00
;Normals List - Y coordinate
	.byt $BC,$10,$C9,$A3,$C9,$10,$5D,$37,$D0,$D0,$37,$5D
;Normals List - Z coordinate
	.byt $41,$50,$12,$F0,$12,$50,$10,$EE,$E8,$E8,$EE,$EF;

;Vertices List - X coordinate
	.byt $00,$F0,$F6,$09,$0F,$00,$E6,$F0,$0F,$19,$F0,$E6,$00,$19,$0F

;Vertices List - Y coordinate
	.byt $FE,$05,$12,$12,$05,$EF,$FB,$0F,$0F,$FB,$ED,$01,$00,$01,$ED

;Vertices List - Z coordinate
	.byt $EA,$F2,$FE,$FE,$F2,$ED,$FA,$0E,$0E,$FA,$F7,$0B,$5E,$0B,$F7

; Face data
	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,0,1,2,3,4


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,10,5,0,1,6


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,11,6,1,2,7


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,12,7,2,3,8


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,13,8,3,4,9


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 14,5,0,4,9,14


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 10,14,5,10


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,11,6,10,12


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,12,7,11


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,13,8,12


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,14,9,13,12


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 14,12,10,14


; End of ship ANACONDA data

; Model of ship ASP
ASP
	.byt 0	; Ship type
	.byt 17	;Number of vertices
	.byt 13	;Number of faces

;Normals List - X coordinate
	.byt $00,$ED,$13,$00,$00,$13,$ED,$C4,$3C,$B8,$48,$00,$00
;Normals List - Y coordinate
	.byt $A2,$A5,$A5,$5E,$56,$5C,$5C,$BF,$BF,$29,$29,$00,$00
;Normals List - Z coordinate
	.byt $F3,$10,$10,$03,$DA,$06,$06,$E1,$E1,$D3,$D3,$5F,$5F;

;Vertices List - X coordinate
	.byt $00,$00,$2B,$45,$2B,$D5,$BB,$D5,$1A,$E6,$2B,$D5,$00,$EF,$11,$00,$00

;Vertices List - Y coordinate
	.byt $12,$09,$00,$03,$0E,$00,$03,$0E,$07,$07,$F2,$F2,$F7,$00,$00,$04,$FC

;Vertices List - Z coordinate
	.byt $00,$D3,$D3,$00,$1C,$D3,$00,$1C,$49,$49,$1C,$1C,$D3,$D3,$D3,$D3,$D3

; Face data
	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,9,7,0,4,8


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,4,0,1,2,3


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,6,7,0,1,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,10,12,11


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,10,8,9,11


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,11,12,5,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,10,12,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,4,3,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,7,6,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,10,3,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,11,6,9


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,5,1,2,12


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 16,13,15,14,16


; End of ship ASP data

; Model of ship ASTEROID
ASTEROID
	.byt 0	; Ship type
	.byt 9	;Number of vertices
	.byt 14	;Number of faces

;Normals List - X coordinate
	.byt $F8,$F8,$43,$38,$DA,$A5,$E0,$40,$3C,$C2,$3A,$D5,$B8,$DC
;Normals List - Y coordinate
	.byt $3B,$C5,$3C,$C0,$BD,$0A,$41,$39,$F3,$F3,$BE,$B5,$08,$48
;Normals List - Z coordinate
	.byt $B7,$B7,$E3,$D7,$C9,$E9,$C4,$26,$48,$46,$21,$25,$3C,$30;

;Vertices List - X coordinate
	.byt $00,$B0,$00,$46,$3C,$32,$D8,$00,$00

;Vertices List - Y coordinate
	.byt $B0,$0A,$50,$28,$CE,$00,$00,$E2,$32

;Vertices List - Z coordinate
	.byt $00,$00,$00,$00,$00,$3C,$46,$B5,$C4

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,0,5,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,5,2,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,0,1,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,6,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,5,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,5,3,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,5,0,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,0,1,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,7,1,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,8,3,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,8,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,2,3,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,3,4,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,7,0,4


; End of ship ASTEROID data

; Model of ship BARREL
BARREL
	.byt 0	; Ship type
	.byt 10	;Number of vertices
	.byt 7	;Number of faces

;Normals List - X coordinate
	.byt $A1,$00,$00,$00,$00,$00,$5F
;Normals List - Y coordinate
	.byt $00,$4C,$DF,$A1,$DF,$4C,$00
;Normals List - Z coordinate
	.byt $00,$C8,$A8,$00,$58,$38,$00;

;Vertices List - X coordinate
	.byt $18,$18,$18,$18,$18,$E8,$E8,$E8,$E8,$E8

;Vertices List - Y coordinate
	.byt $F0,$FB,$0D,$0D,$FB,$F0,$FB,$0D,$0D,$FB

;Vertices List - Z coordinate
	.byt $00,$0F,$09,$F7,$F1,$00,$0F,$09,$F7,$F1

; Face data
	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,0,1,2,3,4


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,5,0,1,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,6,1,2,7


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,7,2,3,8


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,8,3,4,9


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,5,0,4,9


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,5,6,7,8,9


; End of ship BARREL data

; Model of ship BOA
BOA
	.byt 0	; Ship type
	.byt 13	;Number of vertices
	.byt 13	;Number of faces

;Normals List - X coordinate
	.byt $CF,$00,$31,$00,$AF,$51,$00,$4B,$B5,$50,$00,$B0,$00
;Normals List - Y coordinate
	.byt $2A,$D6,$2A,$5F,$D7,$D7,$5B,$CF,$CF,$28,$A8,$28,$00
;Normals List - Z coordinate
	.byt $45,$54,$45,$00,$1A,$1A,$E9,$E3,$E3,$E2,$DE,$E2,$5F;

;Vertices List - X coordinate
	.byt $00,$00,$20,$DF,$DF,$20,$35,$14,$EB,$CA,$00,$0B,$F4

;Vertices List - Y coordinate
	.byt $00,$DE,$16,$16,$DE,$DE,$00,$39,$39,$00,$FA,$08,$08

;Vertices List - Z coordinate
	.byt $50,$B4,$AA,$AA,$CD,$CD,$C6,$BB,$BB,$C6,$A3,$A3,$A3

; Face data
	.byt 6	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,10,1,5,6,2,11


	.byt 6	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,11,2,7,8,3,12


	.byt 6	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,10,1,4,9,3,12


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,1,4,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,2,6,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,8,9,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,4,0,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,8,0,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,6,0,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,4,0,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,8,0,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,6,0,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,10,11,12


; End of ship BOA data

; Model of ship BOULDER
BOULDER
	.byt 0	; Ship type
	.byt 7	;Number of vertices
	.byt 10	;Number of faces

;Normals List - X coordinate
	.byt $52,$14,$CF,$07,$49,$D1,$A5,$C3,$F3,$E2
;Normals List - Y coordinate
	.byt $F0,$22,$B8,$A3,$C6,$51,$11,$E4,$23,$54
;Normals List - Z coordinate
	.byt $D4,$AA,$DC,$10,$0E,$F9,$11,$42,$56,$1D;

;Vertices List - X coordinate
	.byt $EE,$1E,$1C,$02,$E4,$05,$14

;Vertices List - Y coordinate
	.byt $DB,$F9,$07,$00,$DE,$0A,$EF

;Vertices List - Z coordinate
	.byt $F5,$0C,$F4,$D9,$E2,$0D,$E2

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,4,0,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,5,0,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,5,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,5,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,5,3,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,6,0,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,6,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,6,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,6,3,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,4,0,6


; End of ship BOULDER data

; Model of ship CAPSULE
CAPSULE
	.byt 0	; Ship type
	.byt 4	;Number of vertices
	.byt 4	;Number of faces

;Normals List - X coordinate
	.byt $DB,$E0,$E0,$5F
;Normals List - Y coordinate
	.byt $00,$55,$AB,$00
;Normals List - Z coordinate
	.byt $57,$E8,$E8,$00;

;Vertices List - X coordinate
	.byt $F9,$F9,$F9,$15

;Vertices List - Y coordinate
	.byt $00,$0E,$F2,$00

;Vertices List - Z coordinate
	.byt $24,$F4,$F4,$00

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,1,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,2,3,0


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,3,0,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,0,1,2


; End of ship CAPSULE data

; Model of ship COBRA
COBRA
	.byt 0	; Ship type
	.byt 28-2	;Number of vertices
	.byt 17	;Number of faces

;Normals List - X coordinate
	.byt $00,$1C,$E4,$1B,$E5,$1B,$E5,$30,$D0,$00,$0F,$00,$F1,$00,$00,$00,$00
;Normals List - Y coordinate
	.byt $54,$57,$57,$57,$57,$5B,$5B,$51,$51,$00,$A5,$A3,$A5,$00,$00,$00,$00
;Normals List - Z coordinate
	.byt $D6,$E7,$E7,$E9,$E9,$00,$00,$00,$00,$5F,$ED,$EE,$ED,$5F,$5F,$5F,$5F;

;Vertices List - X coordinate
	;.byt $16,$E9,$00,$AC,$53,$C2,$3D,$59,$A6,$00,$E9,$16,$E6,$FA,$05,$19,$19,$05,$FA,$E6,$00,$00,$C8,$C8,$C2,$37,$3D,$37
	.byt $16,$E9,$00,$AC,$53,$C2,$3D,$59,$A6,$00,$E9,$16,$E6,$FA,$05,$19,$19,$05,$FA,$E6,$C8,$C8,$C2,$37,$3D,$37

;Vertices List - Y coordinate
	;.byt $00,$00,$EE,$03,$03,$F5,$F5,$06,$06,$EE,$11,$11,$FB,$F8,$F8,$FB,$09,$0C,$0C,$09,$00,$00,$05,$FC,$00,$FC,$00,$05
	.byt $00,$00,$EE,$03,$03,$F5,$F5,$06,$06,$EE,$11,$11,$FB,$F8,$F8,$FB,$09,$0C,$0C,$09,$05,$FC,$00,$FC,$00,$05

;Vertices List - Z coordinate
	;.byt $35,$35,$10,$FA,$FA,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$35,$3E,$E4,$E4,$E4,$E4,$E4,$E4
	.byt $35,$35,$10,$FA,$FA,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,0,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,1,2,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,0,2,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,1,3,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,0,4,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,2,5,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,2,6,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,3,8,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,4,7,6


	.byt 7	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,11,10,8,5,9,6,7


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 10,1,3,8,10


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 10,11,0,1,10


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,0,4,7,11


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 17,14,15,16,17


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 19,12,13,18,19


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 23-2,22-2,24-2,23-2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 27-2,25-2,26-2,27-2


; End of ship COBRA data

; Model of ship COBRAMK1
COBRAMK1
	.byt 0	; Ship type
	.byt 11-2	;Number of vertices
	.byt 10	;Number of faces

;Normals List - X coordinate
	.byt $00,$00,$10,$13,$F0,$ED,$00,$00,$41,$BF
;Normals List - Y coordinate
	.byt $5C,$A2,$5C,$A5,$5C,$A5,$5F,$00,$3C,$3C
;Normals List - Z coordinate
	.byt $EA,$F6,$F0,$ED,$F0,$ED,$00,$5F,$21,$21;

;Vertices List - X coordinate
	.byt $EE,$12,$BE,$42,$E0,$20,$CA,$36,$00;,$00,$00

;Vertices List - Y coordinate
	.byt $01,$01,$00,$00,$F4,$F4,$0C,$0C,$F4;,$01,$01

;Vertices List - Z coordinate
	.byt $32,$32,$07,$07,$DA,$DA,$DA,$DA,$FA;,$32,$3C

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,1,0,8


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,7,1,0,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,8,0,2,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,0,2,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,5,3,1,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,7,3,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,8,4,5


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,4,6,7,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,4,2,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,7,3,5


; End of ship COBRAMK1 data

; Model of ship CONSTRICTOR
CONSTRICTOR
	.byt 0	; Ship type
	.byt 17-1	;Number of vertices
	.byt 12	;Number of faces

;Normals List - X coordinate
	.byt $00,$1C,$E4,$D0,$30,$30,$00,$D0,$00,$00,$00,$00
;Normals List - Y coordinate
	.byt $5B,$57,$57,$51,$51,$51,$5F,$51,$00,$A1,$A1,$A1
;Normals List - Z coordinate
	.byt $E8,$E9,$E9,$00,$00,$00,$00,$00,$5F,$00,$00,$00;

;Vertices List - X coordinate
	.byt $14,$EC,$CA,$CA,$EC,$14,$36,$36,$14,$EC,$14,$EC,$19,$E7,$0F,$F1;,$00

;Vertices List - Y coordinate
	.byt $07,$07,$07,$07,$F3,$F3,$07,$07,$F3,$F3,$07,$07,$07,$07,$07,$07;,$07

;Vertices List - Z coordinate
	.byt $50,$50,$28,$D8,$D8,$D8,$D8,$28,$05,$05,$3E,$3E,$E7,$E7,$F1,$F1;,$00

; Face data
	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,8,0,1,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,9,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,7,0,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,6,7,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,3,2,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,4,9,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,4,5,8,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,6,8,5


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,3,4,5,6


	.byt 6	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,6,7,0,1,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 14,10,12,14


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 13,11,15,13


; End of ship CONSTRICTOR data


; Model of ship COUGAR
COUGAR
	.byt 0	; Ship type
	.byt 20	;Number of vertices
	.byt 14	;Number of faces

;Normals List - X coordinate
	.byt $1F,$1F,$00,$E1,$E1,$00,$1F,$1F,$E1,$E1,$00,$00,$1F,$E1
;Normals List - Y coordinate
	.byt $59,$A7,$A3,$A7,$59,$00,$A7,$59,$59,$A7,$00,$00,$59,$59
;Normals List - Z coordinate
	.byt $F9,$F9,$EF,$F9,$F9,$5F,$F9,$F9,$F9,$F9,$5F,$5F,$F9,$F9;

;Vertices List - X coordinate
	.byt $00,$EC,$D8,$00,$00,$14,$28,$DC,$C4,$24,$3C,$00,$00,$F4,$0C,$F6,$F6,$0A,$0A,$00

;Vertices List - Y coordinate
	.byt $FB,$00,$00,$F2,$0E,$00,$00,$00,$00,$00,$00,$F9,$F8,$FE,$FE,$FA,$06,$06,$FA,$00

;Vertices List - Z coordinate
	.byt $43,$28,$D8,$D8,$D8,$28,$D8,$38,$EC,$38,$EC,$23,$19,$2D,$2D,$D8,$D8,$D8,$D8,$D8

; Face data
	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,0,1,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,1,2,4


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,5,0,1,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,5,4,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,3,6,5,0


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,4,2,3,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,2,8,7,1


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,2,8,7,1


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,6,10,9,5


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,6,10,9,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 15,16,19,15


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 19,18,17,19


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,13,12,11


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,14,12,11


; End of ship COUGAR data

; Model of ship FERDELANCE
FERDELANCE
	.byt 0	; Ship type
	.byt 19	;Number of vertices
	.byt 13	;Number of faces

;Normals List - X coordinate
	.byt $00,$59,$51,$00,$AF,$A7,$16,$00,$EA,$00,$00,$00,$00
;Normals List - Y coordinate
	.byt $5C,$00,$00,$00,$00,$00,$55,$55,$55,$A1,$A1,$5C,$5C
;Normals List - Z coordinate
	.byt $E9,$E1,$30,$5F,$30,$E1,$23,$29,$23,$00,$00,$E9,$E9;

;Vertices List - X coordinate
	.byt $00,$DD,$F5,$0A,$22,$DD,$F5,$0A,$22,$00,$FD,$E9,$F2,$02,$16,$0D,$00,$F3,$0C

;Vertices List - Y coordinate
	.byt $0D,$0D,$0D,$0D,$0D,$F4,$FF,$FF,$F4,$F1,$0A,$FA,$F4,$0A,$FA,$F4,$0D,$0D,$0D

;Vertices List - Z coordinate
	.byt $5D,$FC,$D3,$D3,$FC,$FC,$D3,$D3,$FC,$EE,$53,$0F,$FC,$53,$0F,$FC,$EE,$25,$25

; Face data
	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,8,0,5,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,5,0,1


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,5,1,2,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,6,2,3,7


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,7,3,4,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,8,0,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,9,5,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,9,6,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,9,7,8


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,0,1,2,3,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 17,18,16,17


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,10,11,12


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 15,13,14,15


; End of ship FERDELANCE data

; Model of ship GECKO
GECKO
	.byt 0	; Ship type
	.byt 12-4	;Number of vertices
	.byt 9	;Number of faces

;Normals List - X coordinate
	.byt $00,$F8,$EB,$00,$15,$08,$24,$00,$DC
;Normals List - Y coordinate
	.byt $5D,$5D,$A5,$A2,$A5,$5D,$06,$00,$06
;Normals List - Z coordinate
	.byt $F1,$F0,$F0,$F3,$F0,$F0,$57,$5F,$57;

;Vertices List - X coordinate
	.byt $F6,$0A,$F0,$10,$BE,$42,$EC,$14;,$F8,$08,$F8,$08

;Vertices List - Y coordinate
	.byt $04,$04,$F8,$F8,$00,$00,$0E,$0E;,$06,$06,$0D,$0D

;Vertices List - Z coordinate
	.byt $2F,$2F,$E9,$E9,$FD,$FD,$E9,$E9;,$21,$21,$F0,$F0

; Face data
	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,2,0,1,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,1,5,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,1,5,7


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,6,0,1,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,6,4,0


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,2,4,0


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,2,4,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,7,3,2,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,7,5,3


; End of ship GECKO data

; Model of ship KRAIT
KRAIT
	.byt 0	; Ship type
	.byt 17-2	;Number of vertices
	.byt 10	;Number of faces

;Normals List - X coordinate
	.byt $F5,$F5,$0B,$0B,$D6,$2A,$D6,$2A,$F5,$0B
;Normals List - Y coordinate
	.byt $5D,$A3,$A3,$5D,$00,$00,$00,$00,$5D,$5D
;Normals List - Z coordinate
	.byt $F5,$F5,$F5,$F5,$55,$55,$55,$55,$F5,$F5;

;Vertices List - X coordinate
	;.byt $00,$00,$00,$43,$BC,$43,$BC,$00,$00,$F2,$0D,$0D,$0D,$1B,$F2,$F2,$E4
	.byt $00,$00,$00,$43,$BC,$00,$00,$F2,$0D,$0D,$0D,$1B,$F2,$F2,$E4

;Vertices List - Y coordinate
	;.byt $00,$F3,$0E,$00,$00,$00,$00,$FD,$FB,$FB,$FB,$F8,$09,$00,$F8,$09,$00
	.byt $00,$F3,$0E,$00,$00,$FD,$FB,$FB,$FB,$F8,$09,$00,$F8,$09,$00

;Vertices List - Z coordinate
	;.byt $48,$DB,$DB,$FD,$FD,$41,$41,$27,$1C,$0E,$0E,$E2,$E2,$E9,$E2,$E2,$E9
	.byt $48,$DB,$DB,$FD,$FD,$27,$1C,$0E,$0E,$E2,$E2,$E9,$E2,$E2,$E9

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,3,0,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,3,0,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,4,0,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,4,0,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,2,3,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,1,4,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 12-2,11-2,13-2,12-2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 16-2,14-2,15-2,16-2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8-2,10-2,7-2,8-2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7-2,9-2,8-2,7-2


; End of ship KRAIT data

; Model of ship MAMBA
MAMBA
	.byt 0	; Ship type
	.byt 25	;Number of vertices
	.byt 11	;Number of faces

;Normals List - X coordinate
	.byt $00,$00,$29,$D7,$00,$00,$00,$00,$00,$00,$00
;Normals List - Y coordinate
	.byt $A2,$5E,$52,$52,$00,$A2,$00,$5E,$A2,$00,$00
;Normals List - Z coordinate
	.byt $F9,$F9,$EC,$EC,$5F,$F9,$5F,$F9,$F9,$5F,$5F;

;Vertices List - X coordinate
	.byt $00,$C0,$E0,$20,$40,$FC,$04,$08,$F8,$EC,$14,$E8,$F0,$10,$18,$F8,$08,$08,$F8,$E0,$20,$24,$DC,$DA,$26

;Vertices List - Y coordinate
	.byt $00,$08,$F8,$F8,$08,$FC,$FC,$FD,$FD,$04,$04,$07,$07,$07,$07,$FC,$FC,$04,$04,$FC,$FC,$04,$04,$00,$00

;Vertices List - Z coordinate
	.byt $40,$E0,$E0,$E0,$E0,$10,$10,$1C,$1C,$10,$10,$EC,$EC,$EC,$EC,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,4,0,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,0,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,0,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,0,4,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,3,2,1,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,12,9,11


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 17,18,15,16,17


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,5,6,7,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 13,14,10,13


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 21,24,20,21


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 22,23,19,22


; End of ship MAMBA data

; Model of ship MISSILE
MISSILE
#ifdef ELITEMISSILE
	.byt 0	; Ship type
	.byt 17	;Number of vertices
	.byt 17	;Number of faces

;Normals List - X coordinate
	.byt $A4,$00,$5C,$00,$A1,$00,$5F,$00,$00,$A1,$00,$5F,$00,$5F,$00,$A1,$00
;Normals List - Y coordinate
	.byt $00,$5C,$00,$A4,$00,$5F,$00,$A1,$00,$00,$5F,$00,$5F,$00,$A1,$00,$A1
;Normals List - Z coordinate
	.byt $E9,$E9,$E9,$E9,$00,$00,$00,$00,$5F,$00,$00,$00,$00,$00,$00,$00,$00;

;Vertices List - X coordinate
	.byt $00,$08,$F8,$F8,$08,$08,$F8,$F8,$08,$0C,$F4,$F4,$0C,$08,$F8,$F8,$08

;Vertices List - Y coordinate
	.byt $00,$F8,$F8,$08,$08,$F8,$F8,$08,$08,$F4,$F4,$0C,$0C,$F8,$F8,$08,$08

;Vertices List - Z coordinate
	.byt $44,$24,$24,$24,$24,$D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4,$F4,$F4,$F4,$F4

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,1,4,0


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,1,2,0


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,2,3,0


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,3,4,0


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,5,8,4,1


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,2,6,5,1


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,6,7,3,2


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,7,8,4,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,6,7,8,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,9,13,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,9,13,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,10,14,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,10,14,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,11,15,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,11,15,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,12,16,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,12,16,8

#else
	.byt 0	; Ship type
	.byt 4	;Number of vertices
	.byt 4	;Number of faces

;Normals List - X coordinate
	.byt $00,$AC,$00,$54
;Normals List - Y coordinate
	.byt $00,$2A,$A2,$2A
;Normals List - Z coordinate
	.byt $5F,$FD,$F8,$FD;

;Vertices List - X coordinate
	.byt $00,$F6,$00,$0A

;Vertices List - Y coordinate
	.byt $00,$0A,$F6,$0A

;Vertices List - Z coordinate
	.byt $44,$D4,$D4,$D4

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,2,3,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,3,2,0


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,0,1,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,0,2,1
#endif


; End of ship MISSILE data

; Model of ship MORAY
MORAY
	.byt 0	; Ship type
	.byt 10	;Number of vertices
	.byt 10	;Number of faces

;Normals List - X coordinate
	.byt $00,$12,$EE,$2E,$00,$D2,$33,$00,$CD,$00
;Normals List - Y coordinate
	.byt $5D,$5C,$5C,$EA,$CC,$EA,$B9,$A7,$B9,$CC
;Normals List - Z coordinate
	.byt $F1,$F3,$F3,$4F,$4F,$4F,$DD,$E0,$DD,$4F;

;Vertices List - X coordinate
	.byt $0F,$F1,$00,$C4,$3C,$1E,$E2,$F7,$09,$00;,$0D,$06,$F3,$FA

;Vertices List - Y coordinate
	.byt $00,$00,$EE,$00,$00,$1B,$1B,$04,$04,$12;,$FD,$00,$FD,$00

;Vertices List - Z coordinate
	.byt $41,$41,$D8,$00,$00,$F6,$F6,$E7,$E7,$F0;,$31,$41,$31,$41

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,2,0,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,2,1,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,2,0,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,2,3,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,2,5,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,2,4,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,1,3,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,5,0,1,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,0,4,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,9,7,8


; End of ship MORAY data

; Model of ship PLATELET
PLATELET
	.byt 0	; Ship type
	.byt 4	;Number of vertices
	.byt 1	;Number of faces

;Normals List - X coordinate
	.byt $00
;Normals List - Y coordinate
	.byt $00
;Normals List - Z coordinate
	.byt $00;

;Vertices List - X coordinate
	.byt $F1,$F1,$13,$0A

;Vertices List - Y coordinate
	.byt $16,$DA,$E0,$2E

;Vertices List - Z coordinate
	.byt $F7,$F7,$0B,$06

; Face data
	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,1,2,3,0


; End of ship PLATELET data

; Model of ship PYTHON
PYTHON
	.byt 0	; Ship type
	.byt 11	;Number of vertices
	.byt 13	;Number of faces

;Normals List - X coordinate
	.byt $33,$CD,$33,$CD,$2A,$D6,$2A,$D6,$33,$CD,$CD,$33,$00
;Normals List - Y coordinate
	.byt $4C,$4C,$B4,$B4,$54,$54,$AC,$AC,$4C,$4C,$B4,$B4,$00
;Normals List - Z coordinate
	.byt $EB,$EB,$EB,$EB,$00,$00,$00,$00,$16,$16,$16,$16,$5F;

;Vertices List - X coordinate
	.byt $00,$00,$28,$D7,$00,$00,$EB,$14,$00,$00,$00

;Vertices List - Y coordinate
	.byt $00,$EC,$00,$00,$EC,$F6,$00,$00,$15,$15,$0B

;Vertices List - Z coordinate
	.byt $5E,$14,$F9,$F9,$F2,$D1,$D1,$D1,$14,$F2,$D1

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,1,0,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,1,0,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,3,0,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,2,0,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,1,3,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,1,2,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,9,3,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,9,2,8


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,6,5,4,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,7,5,4,2


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,7,10,9,2


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,6,10,9,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,10,7,5,6


; End of ship PYTHON data

; Model of ship SIDEWINDER
SIDEWINDER
	.byt 0	; Ship type
	.byt 10	;Number of vertices
	.byt 8	;Number of faces

;Normals List - X coordinate
	.byt $00,$17,$E9,$00,$17,$00,$E9,$00
;Normals List - Y coordinate
	.byt $5C,$5B,$5B,$00,$A5,$A4,$A5,$00
;Normals List - Z coordinate
	.byt $E9,$F5,$F5,$5F,$F5,$E9,$F5,$5F;

;Vertices List - X coordinate
	.byt $E0,$20,$40,$C0,$00,$00,$F4,$0C,$0C,$F4

;Vertices List - Y coordinate
	.byt $00,$00,$00,$00,$F0,$10,$FA,$FA,$06,$06

;Vertices List - Z coordinate
	.byt $24,$24,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,0,1,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,3,0,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,4,1,2


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,5,3,4,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,0,3,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,0,1,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,1,2,5


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,9,6,7,8


; End of ship SIDEWINDER data

; Model of ship SHUTTLE
SHUTTLE
	.byt 0	; Ship type
	.byt 19	;Number of vertices
	.byt 16	;Number of faces

;Normals List - X coordinate
	.byt $3B,$00,$3F,$5E,$3F,$00,$C1,$A2,$C1,$00,$24,$DC,$C5,$00,$DC,$24
;Normals List - Y coordinate
	.byt $C5,$A2,$C1,$00,$3F,$5E,$3F,$00,$C1,$00,$24,$24,$C5,$00,$24,$24
;Normals List - Z coordinate
	.byt $D5,$FB,$E4,$FB,$E4,$FB,$E4,$FB,$E4,$5F,$B1,$B1,$D5,$5F,$B1,$B1;

;Vertices List - X coordinate
	.byt $00,$EF,$00,$12,$EC,$EC,$14,$14,$05,$00,$FB,$00,$00,$03,$04,$0B,$FD,$FD,$F6

;Vertices List - Y coordinate
	.byt $11,$00,$EE,$00,$14,$EC,$EC,$14,$00,$02,$00,$FD,$09,$01,$F5,$FC,$01,$F5,$FC

;Vertices List - Z coordinate
	.byt $17,$17,$17,$17,$E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5,$23,$1F,$19,$19,$1F,$19,$19

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,12,0,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,4,0,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 1,4,0,1


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,5,1,4


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,5,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,6,2,5


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,6,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,7,3,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,7,0,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,4,5,6,7


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,12,1,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,12,2,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,12,0,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,8,9,10,11


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 15,13,14,15


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 18,16,17,18


; End of ship SHUTTLE data

; Model of ship SPLINTER
SPLINTER
	.byt 0	; Ship type
	.byt 4	;Number of vertices
	.byt 4	;Number of faces

;Normals List - X coordinate
	.byt $B7,$D9,$53,$02
;Normals List - Y coordinate
	.byt $04,$F7,$2A,$CB
;Normals List - Z coordinate
	.byt $3C,$AB,$10,$4E;

;Vertices List - X coordinate
	.byt $E8,$00,$0B,$0C

;Vertices List - Y coordinate
	.byt $19,$F4,$06,$D6

;Vertices List - Z coordinate
	.byt $10,$F6,$02,$07

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,2,1,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,2,3,0


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,1,0,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 0,1,2,0


; End of ship SPLINTER data

; Model of ship THARGLET
THARGLET
	.byt 0	; Ship type
	.byt 10	;Number of vertices
	.byt 7	;Number of faces

;Normals List - X coordinate
	.byt $5F,$A9,$BC,$E1,$BC,$A9,$A1
;Normals List - Y coordinate
	.byt $00,$EB,$C2,$00,$3E,$15,$00
;Normals List - Z coordinate
	.byt $00,$E2,$14,$59,$14,$E2,$00;

;Vertices List - X coordinate
	.byt $F7,$F7,$F7,$F7,$F7,$09,$09,$09,$09,$09

;Vertices List - Y coordinate
	.byt $00,$26,$18,$E8,$DA,$00,$0A,$06,$FA,$F6

;Vertices List - Z coordinate
	.byt $28,$0C,$E0,$E0,$0C,$F8,$F1,$E6,$E6,$F1

; Face data
	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,0,1,2,3,4


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,5,0,1,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,6,1,2,7


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,7,2,3,8


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,8,3,4,9


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,5,0,4,9


	.byt 5	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,5,6,7,8,9


; End of ship THARGLET data

; Model of ship THARGOID
THARGOID
	.byt 0	; Ship type
	.byt 16;20	;Number of vertices
	.byt 10	;Number of faces

;Normals List - X coordinate
	.byt $B0,$B0,$B0,$B0,$A1,$B0,$B0,$B0,$B0,$5F
;Normals List - Y coordinate
	.byt $D2,$D2,$ED,$13,$00,$2E,$2E,$13,$ED,$00
;Normals List - Z coordinate
	.byt $ED,$13,$2E,$2E,$00,$13,$ED,$D2,$D2,$00;

;Vertices List - X coordinate
	.byt $12,$12,$12,$12,$12,$12,$12,$12,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2;,$F2,$F2,$F2,$F2

;Vertices List - Y coordinate
	.byt $1C,$27,$1C,$00,$E5,$DA,$E5,$00,$42,$5D,$42,$00,$BF,$A4,$BF,$00;,$DC,$DC,$25,$25

;Vertices List - Z coordinate
	.byt $1B,$00,$E4,$D9,$E4,$00,$1B,$26,$41,$00,$BE,$A3,$BE,$00,$41,$5C;,$2D,$D2,$D2,$2D

; Face data
	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,8,0,1,9


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 10,9,1,2,10


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,10,2,3,11


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,11,3,4,12


	.byt 8	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,6,5,4,3,2,1,0,7


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 13,12,4,5,13


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 14,13,5,6,14


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 15,14,6,7,15


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 15,8,0,7,15


	.byt 8	;Number of points
	;.byt 0	;Fill pattern
	.byt 15,14,13,12,11,10,9,8,15


; End of ship THARGOID data

; Model of ship TRANSPORTER
TRANSPORTER
	.byt 0	; Ship type
	.byt 20 ;37	;Number of vertices
	.byt 15	;Number of faces

;Normals List - X coordinate
	.byt $00,$57,$50,$00,$B0,$A9,$EA,$16,$14,$3E,$C2,$EC,$00,$00,$00
;Normals List - Y coordinate
	.byt $00,$25,$D0,$A1,$D0,$25,$5B,$5B,$58,$1A,$1A,$58,$56,$00,$00
;Normals List - Z coordinate
	.byt $5F,$05,$10,$00,$10,$05,$F8,$F8,$E4,$BE,$BE,$E4,$DA,$A1,$5F;

;Vertices List - X coordinate
	;.byt $00,$E7,$E4,$E7,$1A,$1D,$1A,$00,$E2,$DF,$21,$1E,$F5,$F3,$0E,$0B,$FB,$EE,$FB,$EE,$F5,$F5,$05,$12,$0B,$05,$12,$0B,$0B,$F0,$F0,$11,$11,$F3,$0D,$09,$F8
	.byt $00,$E7,$E4,$E7,$1A,$1D,$1A,$00,$E2,$DF,$21,$1E,$F5,$F3,$0E,$0B,$F3,$0D,$09,$F8

;Vertices List - Y coordinate
	;.byt $F6,$FC,$03,$08,$08,$03,$FC,$FA,$01,$08,$08,$01,$02,$08,$08,$02,$FA,$FD,$F9,$FC,$FA,$FB,$F9,$FC,$FB,$FA,$FD,$FC,$FB,$08,$08,$08,$08,$03,$03,$FD,$FD
	.byt $F6,$FC,$03,$08,$08,$03,$FC,$FA,$01,$08,$08,$01,$02,$08,$08,$02,$03,$03,$FD,$FD

;Vertices List - Z coordinate
	;.byt $E6,$E6,$E6,$E6,$E6,$E6,$E6,$0C,$0C,$0C,$0C,$0C,$1E,$1E,$1E,$1E,$02,$02,$F9,$F9,$F2,$F9,$F2,$F2,$F9,$FD,$FD,$08,$FD,$F3,$10,$F3,$10,$E6,$E6,$E6,$E6
	.byt $E6,$E6,$E6,$E6,$E6,$E6,$E6,$0C,$0C,$0C,$0C,$0C,$1E,$1E,$1E,$1E,$E6,$E6,$E6,$E6

; Face data
	.byt 7	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,0,1,2,3,4,5,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,8,1,2,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,9,2,3


	.byt 6	;Number of points
	;.byt 0	;Fill pattern
	.byt 14,13,9,3,4,10,14


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,10,4,5


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,10,5,6,11


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,7,0,6,11


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,7,0,1,8


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,12,7,8


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 13,12,8,9,13


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 15,14,10,11,15


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,15,7,11


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 15,12,7,15


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 15,12,13,14,15


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 36-17,33-17,34-17,35-17,36-17


; End of ship TRANSPORTER data

; Model of ship VIPER
VIPER
	.byt 0	; Ship type
	.byt 15	;Number of vertices
	.byt 9	;Number of faces

;Normals List - X coordinate
	.byt $00,$32,$CE,$32,$CE,$00,$00,$00,$00
;Normals List - Y coordinate
	.byt $5F,$4C,$4C,$B4,$B4,$A1,$00,$00,$00
;Normals List - Z coordinate
	.byt $00,$E7,$E7,$E7,$E7,$00,$5F,$5F,$5F;

;Vertices List - X coordinate
	.byt $00,$00,$00,$30,$D0,$18,$E8,$18,$E8,$E0,$20,$08,$F8,$F8,$08

;Vertices List - Y coordinate
	.byt $00,$F0,$10,$00,$00,$10,$10,$F0,$F0,$00,$00,$F8,$F8,$08,$08

;Vertices List - Z coordinate
	.byt $48,$18,$18,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8

; Face data
	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,8,1,7


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,4,0,1,8


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,7,1,0,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,4,0,2,6


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,5,2,0,3


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,6,2,5


	.byt 6	;Number of points
	;.byt 0	;Fill pattern
	.byt 6,5,3,7,8,4,6


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 12,13,9,12


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 11,14,10,11


; End of ship VIPER data

; Model of ship WORM
WORM
	.byt 0	; Ship type
	.byt 10	;Number of vertices
	.byt 8	;Number of faces

;Normals List - X coordinate
	.byt $00,$00,$C0,$40,$B6,$4A,$00,$00
;Normals List - Y coordinate
	.byt $4A,$5D,$3D,$3D,$38,$38,$00,$A1
;Normals List - Z coordinate
	.byt $C5,$EE,$E0,$E0,$F0,$F0,$5F,$00;

;Vertices List - X coordinate
	.byt $0A,$F6,$05,$FB,$0F,$F1,$1A,$E6,$08,$F8

;Vertices List - Y coordinate
	.byt $0A,$0A,$FA,$FA,$0A,$0A,$0A,$0A,$F2,$F2

;Vertices List - Z coordinate
	.byt $23,$23,$0F,$0F,$19,$19,$E7,$E7,$E7,$E7

; Face data
	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 3,2,0,1,3


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 9,3,2,8,9


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 2,4,0,2


	.byt 3	;Number of points
	;.byt 0	;Fill pattern
	.byt 5,3,1,5


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,6,4,2,8


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 7,9,3,5,7


	.byt 4	;Number of points
	;.byt 0	;Fill pattern
	.byt 8,9,7,6,8


	.byt 6	;Number of points
	;.byt 0	;Fill pattern
	.byt 4,0,1,5,7,6,4


; End of ship WORM data



__models_end

#echo Size of models in bytes:
#print (__models_end - __models_start)
#echo


