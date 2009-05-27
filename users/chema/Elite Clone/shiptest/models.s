__models_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ==================== Model description file =======================
;Shape Data clawed out from original 6502 elite data files by Ian Bell
;Conversion by modelimport. DO NOT EDIT BY HAND
;
;
; Ship format: type, number of vertices, number of faces
; Vertices, X coordinates, Y coordinates and Z coordinates
; Face data: num vertices-1, fill pattern, list of vertices
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Model of ship ADDER
ADDER
	.byt 0	; Ship type
	.byt 18	;Number of vertices
	.byt 14	;Number of faces

;Vertices List - X coordinate
	.byt $EE,$12,$1E,$1E,$12,$EE,$E2,$E2,$EE,$12,$EE,$12,$EE,$12,$F5,$0B,$0B,$F5

;Vertices List - Y coordinate
	.byt $00,$00,$00,$00,$F9,$F9,$00,$00,$07,$07,$07,$07,$F9,$F9,$03,$03,$04,$04

;Vertices List - Z coordinate
	.byt $28,$28,$E8,$D8,$D8,$D8,$D8,$E8,$D8,$D8,$0D,$0D,$0D,$0D,$1D,$1D,$18,$18

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 11,10,0,1,11


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,12,13,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,11,1,2


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,13,2,1 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,11,2,3,9


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,13,4,3 ; Inverted


	.byt 6	;Number of points
	.byt 0	;Fill pattern
	.byt 3,4,5,6,8,9,3


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 10,8,6,7,10


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,6,5,12,7 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 10,7,0,10


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,7,12,0 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 10,11,9,8,10


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 5,4,13,12,5 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 17,14,15,16,17


; End of ship ADDER data

; Model of ship ANACONDA
ANACONDA
	.byt 0	; Ship type
	.byt 15	;Number of vertices
	.byt 12	;Number of faces

;Vertices List - X coordinate
	.byt $00,$F0,$F6,$09,$0F,$00,$E6,$F0,$0F,$19,$F0,$E6,$00,$19,$0F

;Vertices List - Y coordinate
	.byt $02,$FB,$EE,$EE,$FB,$11,$05,$F1,$F1,$05,$13,$FF,$00,$FF,$13

;Vertices List - Z coordinate
	.byt $EA,$F2,$FE,$FE,$F2,$ED,$FA,$0E,$0E,$FA,$F7,$0B,$5E,$0B,$F7

; Face data
	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,1,0,4,3 ; Inverted


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 6,10,5,0,1,6


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 7,11,6,1,2,7


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 8,12,7,2,3,8


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 9,13,8,3,4,9


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 9,4,0,5,14,9 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 10,14,5,10


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 10,6,11,12,10 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,12,11,7 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,13,12,8 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 13,9,14,12,13 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 10,12,14,10 ; Inverted


; End of ship ANACONDA data

; Model of ship ASP
ASP
	.byt 0	; Ship type
	.byt 17	;Number of vertices
	.byt 13	;Number of faces

;Vertices List - X coordinate
	.byt $00,$00,$2B,$45,$2B,$D5,$BB,$D5,$1A,$E6,$2B,$D5,$00,$EF,$11,$00,$00

;Vertices List - Y coordinate
	.byt $EE,$F7,$00,$FD,$F2,$00,$FD,$F2,$F9,$F9,$0E,$0E,$09,$00,$00,$FC,$04

;Vertices List - Z coordinate
	.byt $00,$D3,$D3,$00,$1C,$D3,$00,$1C,$49,$49,$1C,$1C,$D3,$D3,$D3,$D3,$D3

; Face data
	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 8,9,7,0,4,8


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 3,4,0,1,2,3


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,7,6,5,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 11,10,12,11


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,8,10,11,9 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,11,12,5,6


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,12,10,3,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,4,3,8


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,7,9,6 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,10,8,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 9,11,6,9


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,1,5,12,2 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 14,15,13,16,14 ; Inverted


; End of ship ASP data

; Model of ship ASTEROID
ASTEROID
	.byt 0	; Ship type
	.byt 9	;Number of vertices
	.byt 14	;Number of faces

;Vertices List - X coordinate
	.byt $00,$B0,$00,$46,$3C,$32,$D8,$00,$00

;Vertices List - Y coordinate
	.byt $50,$F6,$B0,$D8,$32,$00,$00,$1E,$CE

;Vertices List - Z coordinate
	.byt $00,$00,$00,$00,$00,$3C,$46,$B5,$C4

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,0,6,5 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,5,6,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,0,1,6


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,6,1,2


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,5,2,3


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,5,3,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,5,4,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,7,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,7,8,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,8,7,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,8,2,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,8,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,3,7,4 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,7,0,4


; End of ship ASTEROID data

; Model of ship BARREL
BARREL
	.byt 0	; Ship type
	.byt 10	;Number of vertices
	.byt 7	;Number of faces

;Vertices List - X coordinate
	.byt $18,$18,$18,$18,$18,$E8,$E8,$E8,$E8,$E8

;Vertices List - Y coordinate
	.byt $10,$05,$F3,$F3,$05,$10,$05,$F3,$F3,$05

;Vertices List - Z coordinate
	.byt $00,$0F,$09,$F7,$F1,$00,$0F,$09,$F7,$F1

; Face data
	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 4,0,1,2,3,4


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,5,6,1 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,1,6,7,2 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,7,8,3 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 4,3,8,9,4 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,5,0,4,9


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 8,7,6,5,9,8 ; Inverted


; End of ship BARREL data

; Model of ship BOA
BOA
	.byt 0	; Ship type
	.byt 13	;Number of vertices
	.byt 13	;Number of faces

;Vertices List - X coordinate
	.byt $00,$00,$20,$DF,$DF,$20,$35,$14,$EB,$CA,$00,$0B,$F4

;Vertices List - Y coordinate
	.byt $00,$22,$EA,$EA,$22,$22,$00,$C7,$C7,$00,$06,$F8,$F8

;Vertices List - Z coordinate
	.byt $50,$B4,$AA,$AA,$CD,$CD,$C6,$BB,$BB,$C6,$A3,$A3,$A3

; Face data
	.byt 6	;Number of points
	.byt 0	;Fill pattern
	.byt 11,10,1,5,6,2,11


	.byt 6	;Number of points
	.byt 0	;Fill pattern
	.byt 12,11,2,7,8,3,12


	.byt 6	;Number of points
	.byt 0	;Fill pattern
	.byt 3,9,4,1,10,12,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,1,4,5


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,2,6,7


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,8,9,3


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,4,0,5


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 9,8,0,9


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,6,0,7


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,4,9,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,8,7,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,6,5,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 12,10,11,12


; End of ship BOA data

; Model of ship BOULDER
BOULDER
	.byt 0	; Ship type
	.byt 7	;Number of vertices
	.byt 10	;Number of faces

;Vertices List - X coordinate
	.byt $EE,$1E,$1C,$02,$E4,$05,$14

;Vertices List - Y coordinate
	.byt $25,$07,$F9,$00,$22,$F6,$11

;Vertices List - Z coordinate
	.byt $F5,$0C,$F4,$D9,$E2,$0D,$E2

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,4,5,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,5,1,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,5,2,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,5,3,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,5,4,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,6,0,1


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,6,1,2


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,6,2,3


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,6,3,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,4,0,6


; End of ship BOULDER data

; Model of ship CAPSULE
CAPSULE
	.byt 0	; Ship type
	.byt 4	;Number of vertices
	.byt 4	;Number of faces

;Vertices List - X coordinate
	.byt $F9,$F9,$F9,$15

;Vertices List - Y coordinate
	.byt $00,$F2,$0E,$00

;Vertices List - Z coordinate
	.byt $24,$F4,$F4,$00

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,1,2,3


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,0,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,3,0,1


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,2,1 ; Inverted


; End of ship CAPSULE data

; Model of ship COBRA
COBRA
	.byt 0	; Ship type
	.byt 28	;Number of vertices
	.byt 17	;Number of faces

;Vertices List - X coordinate
	.byt $16,$E9,$00,$AC,$53,$C2,$3D,$59,$A6,$00,$E9,$16,$E6,$FA,$05,$19,$19,$05,$FA,$E6,$00,$00,$C8,$C8,$C2,$37,$3D,$37

;Vertices List - Y coordinate
	.byt $00,$00,$12,$FD,$FD,$0B,$0B,$FA,$FA,$12,$EF,$EF,$05,$08,$08,$05,$F7,$F4,$F4,$F7,$00,$00,$FB,$04,$00,$04,$00,$FB

;Vertices List - Z coordinate
	.byt $35,$35,$10,$FA,$FA,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$35,$3E,$E4,$E4,$E4,$E4,$E4,$E4

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,2,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,1,2,5


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,0,6,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,1,5,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,0,4,6


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,2,9,5 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 9,2,6,9


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,3,5,8 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,6,4,7;7,4,6,7 ; Inverted


	.byt 7	;Number of points
	.byt 0	;Fill pattern
	.byt 7,11,10,8,5,9,6,7


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 10,1,3,8,10


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 10,11,0,1,10


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,4,0,11,7 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 17,14,15,16,17


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 19,12,13,18,19


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 23,22,24,23


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 27,25,26,27


; End of ship COBRA data

; Model of ship COBRAMK1
COBRAMK1
	.byt 0	; Ship type
	.byt 11	;Number of vertices
	.byt 10	;Number of faces

;Vertices List - X coordinate
	.byt $EE,$12,$BE,$42,$E0,$20,$CA,$36,$00,$00,$00

;Vertices List - Y coordinate
	.byt $FF,$FF,$00,$00,$0C,$0C,$F4,$F4,$0C,$FF,$FF

;Vertices List - Z coordinate
	.byt $32,$32,$07,$07,$DA,$DA,$DA,$DA,$FA,$32,$3C

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,1,8,0 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,7,1,0,6


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,0,8,4,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,0,2,6


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,3,5,8,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,7,3,1


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,8,5,4 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,6,4,5,7 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,4,6,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,7,5,3 ; Inverted


; End of ship COBRAMK1 data

; Model of ship CONSTRICTOR
CONSTRICTOR
	.byt 0	; Ship type
	.byt 17	;Number of vertices
	.byt 12	;Number of faces

;Vertices List - X coordinate
	.byt $14,$EC,$CA,$CA,$EC,$14,$36,$36,$14,$EC,$14,$EC,$19,$E7,$0F,$F1,$00

;Vertices List - Y coordinate
	.byt $F9,$F9,$F9,$F9,$0D,$0D,$F9,$F9,$0D,$0D,$F9,$F9,$F9,$F9,$F9,$F9,$F9

;Vertices List - Z coordinate
	.byt $50,$50,$28,$D8,$D8,$D8,$D8,$28,$05,$05,$3E,$3E,$E7,$E7,$F1,$F1,$00

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,8,9,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,9,2,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,7,8,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,6,8,7 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 9,3,2,9


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 9,4,3,9 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 8,5,4,9,8 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,6,5,8 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,3,4,5,6


	.byt 6	;Number of points
	.byt 0	;Fill pattern
	.byt 3,6,7,0,1,2,3


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 12,10,14,12 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 15,11,13,15 ; Inverted


; End of ship CONSTRICTOR data

; Model of ship CORIOLIS
CORIOLIS
	.byt 0	; Ship type
	.byt 16	;Number of vertices
	.byt 15	;Number of faces

;Vertices List - X coordinate
	.byt $42,$00,$BD,$00,$42,$42,$BD,$BD,$42,$00,$BD,$00,$04,$04,$FB,$FB

;Vertices List - Y coordinate
	.byt $00,$42,$00,$BD,$BD,$42,$42,$BD,$00,$42,$00,$BD,$F3,$0C,$0C,$F3

;Vertices List - Z coordinate
	.byt $42,$42,$42,$42,$00,$00,$00,$00,$BD,$BD,$BD,$BD,$42,$42,$42,$42

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 0,1,2,3,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,0,3,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,5,1,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,6,2,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,7,3,2 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 4,3,7,11,4 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 8,5,0,4,8


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 10,7,2,6,10


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,5,9,6,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 11,7,10,11


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 11,8,4,11 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 9,5,8,9


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 10,6,9,10


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 11,10,9,8,11


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 15,12,13,14,15


; End of ship CORIOLIS data

; Model of ship COUGAR
COUGAR
	.byt 0	; Ship type
	.byt 20	;Number of vertices
	.byt 14	;Number of faces

;Vertices List - X coordinate
	.byt $00,$EC,$D8,$00,$00,$14,$28,$DC,$C4,$24,$3C,$00,$00,$F4,$0C,$F6,$F6,$0A,$0A,$00

;Vertices List - Y coordinate
	.byt $05,$00,$00,$0E,$F2,$00,$00,$00,$00,$00,$00,$07,$08,$02,$02,$06,$FA,$FA,$06,$00

;Vertices List - Z coordinate
	.byt $43,$28,$D8,$D8,$D8,$28,$D8,$38,$EC,$38,$EC,$23,$19,$2D,$2D,$D8,$D8,$D8,$D8,$D8

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,1,0,3,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,1,2,4


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 4,5,0,1,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,5,4,6


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 5,6,3,0,5 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,4,2,3,6


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,8,2,1,7 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,8,2,1,7 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,10,6,5,9 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,10,6,5,9 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 19,16,15,19 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 19,18,17,19


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 12,13,11,12 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 11,14,12,11


; End of ship COUGAR data

; Model of ship DODO
DODO
	.byt 0	; Ship type
	.byt 24	;Number of vertices
	.byt 13	;Number of faces

;Vertices List - X coordinate
	.byt $00,$36,$21,$DE,$C9,$00,$57,$36,$C9,$A8,$36,$57,$00,$A8,$C9,$21,$36,$00,$C9,$DE,$F9,$F9,$06,$06

;Vertices List - Y coordinate
	.byt $39,$11,$D2,$D2,$11,$5C,$1C,$B5,$B5,$1C,$4A,$E3,$A3,$E3,$4A,$2D,$EE,$C6,$EE,$2D,$0C,$F3,$0C,$F3

;Vertices List - Z coordinate
	.byt $4A,$4A,$4A,$4A,$4A,$11,$11,$11,$11,$11,$EE,$EE,$EE,$EE,$EE,$B5,$B5,$B5,$B5,$B5,$4A,$4A,$4A,$4A

; Face data
	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,1,0,4,3 ; Inverted


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 6,10,5,0,1,6


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 7,11,6,1,2,7


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 8,12,7,2,3,8


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 9,13,8,3,4,9


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 5,14,9,4,0,5


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 15,19,14,5,10,15


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 16,15,10,6,11,16


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 17,16,11,7,12,17


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 18,17,12,8,13,18


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 19,18,13,9,14,19


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 19,15,16,17,18,19


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 22,20,21,23,22


; End of ship DODO data

; Model of ship FERDELANCE
FERDELANCE
	.byt 0	; Ship type
	.byt 19	;Number of vertices
	.byt 13	;Number of faces

;Vertices List - X coordinate
	.byt $00,$DD,$F5,$0A,$22,$DD,$F5,$0A,$22,$00,$FD,$E9,$F2,$02,$16,$0D,$00,$F3,$0C

;Vertices List - Y coordinate
	.byt $F3,$F3,$F3,$F3,$F3,$0C,$01,$01,$0C,$0F,$F6,$06,$0C,$F6,$06,$0C,$F3,$F3,$F3

;Vertices List - Z coordinate
	.byt $5D,$FC,$D3,$D3,$FC,$FC,$D3,$D3,$FC,$EE,$53,$0F,$FC,$53,$0F,$FC,$EE,$25,$25

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 5,0,8,9,5 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,5,1,0 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,1,5,6,2 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,6,7,3 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 4,3,7,8,4 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,8,0,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,9,6,5 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,9,7,6 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,9,8,7 ; Inverted


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 4,0,1,2,3,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 16,18,17,16 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 11,10,12,11 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 15,13,14,15


; End of ship FERDELANCE data

; Model of ship GECKO
GECKO
	.byt 0	; Ship type
	.byt 12	;Number of vertices
	.byt 9	;Number of faces

;Vertices List - X coordinate
	.byt $F6,$0A,$F0,$10,$BE,$42,$EC,$14,$F8,$08,$F8,$08

;Vertices List - Y coordinate
	.byt $FC,$FC,$08,$08,$00,$00,$F2,$F2,$FA,$FA,$F3,$F3

;Vertices List - Z coordinate
	.byt $2F,$2F,$E9,$E9,$FD,$FD,$E9,$E9,$21,$21,$F0,$F0

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,0,1,3


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,1,5,3


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,1,7,5 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,6,7,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,6,0,4 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,2,4,0


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,2,6,4 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,3,7,6,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,7,3,5 ; Inverted


; End of ship GECKO data

; Model of ship KRAIT
KRAIT
	.byt 0	; Ship type
	.byt 17	;Number of vertices
	.byt 10	;Number of faces

;Vertices List - X coordinate
	.byt $00,$00,$00,$43,$BC,$43,$BC,$00,$00,$F2,$0D,$0D,$0D,$1B,$F2,$F2,$E4

;Vertices List - Y coordinate
	.byt $00,$0D,$F2,$00,$00,$00,$00,$03,$05,$05,$05,$08,$F7,$00,$08,$F7,$00

;Vertices List - Z coordinate
	.byt $48,$DB,$DB,$FD,$FD,$41,$41,$27,$1C,$0E,$0E,$E2,$E2,$E9,$E2,$E2,$E9

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,3,1,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,3,0,2


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,4,2,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,4,0,1


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,1,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,1,2,4 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 12,11,13,12


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 16,14,15,16


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,10,8,7 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,9,7,8 ; Inverted


; End of ship KRAIT data

; Model of ship MAMBA
MAMBA
	.byt 0	; Ship type
	.byt 25	;Number of vertices
	.byt 11	;Number of faces

;Vertices List - X coordinate
	.byt $00,$C0,$E0,$20,$40,$FC,$04,$08,$F8,$EC,$14,$E8,$F0,$10,$18,$F8,$08,$08,$F8,$E0,$20,$24,$DC,$DA,$26

;Vertices List - Y coordinate
	.byt $00,$F8,$08,$08,$F8,$04,$04,$03,$03,$FC,$FC,$F9,$F9,$F9,$F9,$04,$04,$FC,$FC,$04,$04,$FC,$FC,$00,$00

;Vertices List - Z coordinate
	.byt $40,$E0,$E0,$E0,$E0,$10,$10,$1C,$1C,$10,$10,$EC,$EC,$EC,$EC,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,4,0,1


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,0,3,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,2,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,0,4,3


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,2,3,4,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 11,12,9,11


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 17,18,15,16,17


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,6,5,8,7 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 13,14,10,13


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 20,24,21,20 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 22,23,19,22


; End of ship MAMBA data

; Model of ship MISSILE
MISSILE
	.byt 0	; Ship type
	.byt 17	;Number of vertices
	.byt 17	;Number of faces

;Vertices List - X coordinate
	.byt $00,$08,$F8,$F8,$08,$08,$F8,$F8,$08,$0C,$F4,$F4,$0C,$08,$F8,$F8,$08

;Vertices List - Y coordinate
	.byt $00,$08,$08,$F8,$F8,$08,$08,$F8,$F8,$0C,$0C,$F4,$F4,$08,$08,$F8,$F8

;Vertices List - Z coordinate
	.byt $44,$24,$24,$24,$24,$D4,$D4,$D4,$D4,$D4,$D4,$D4,$D4,$F4,$F4,$F4,$F4

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,1,0,4 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,1,2,0


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,2,3,0


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,3,4,0


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 4,8,5,1,4 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 5,6,2,1,5 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,6,7,3,2


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,7,8,4,3


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 8,7,6,5,8 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,9,13,5


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 13,9,5,13 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 14,10,6,14 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,10,14,6


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 15,11,7,15 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 15,11,7,15 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 16,12,8,16 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,12,16,8


; End of ship MISSILE data

; Model of ship MORAY
MORAY
	.byt 0	; Ship type
	.byt 14	;Number of vertices
	.byt 10	;Number of faces

;Vertices List - X coordinate
	.byt $0F,$F1,$00,$C4,$3C,$1E,$E2,$F7,$09,$00,$0D,$06,$F3,$FA

;Vertices List - Y coordinate
	.byt $00,$00,$12,$00,$00,$E5,$E5,$FC,$FC,$EE,$03,$00,$03,$00

;Vertices List - Z coordinate
	.byt $41,$41,$D8,$00,$00,$F6,$F6,$E7,$E7,$F0,$31,$41,$31,$41

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,2,1,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,2,3,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,2,0,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,6,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,2,5,6


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,2,4,5


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 6,1,3,6


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,5,0,1,6


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,0,5,4 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,9,7,8


; End of ship MORAY data

; Model of ship PLATELET
PLATELET
	.byt 0	; Ship type
	.byt 4	;Number of vertices
	.byt 2	;Number of faces

;Vertices List - X coordinate
	.byt $F1,$F1,$13,$0A

;Vertices List - Y coordinate
	.byt $EA,$26,$20,$D2

;Vertices List - Z coordinate
	.byt $F7,$F7,$0B,$06

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,1,0,3 ; Inverted

	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,0,1,2,3; 3,2,1,0,3 ; Inverted



; End of ship PLATELET data

; Model of ship PYTHON
PYTHON
	.byt 0	; Ship type
	.byt 11	;Number of vertices
	.byt 13	;Number of faces

;Vertices List - X coordinate
	.byt $00,$00,$28,$D7,$00,$00,$EB,$14,$00,$00,$00

;Vertices List - Y coordinate
	.byt $00,$14,$00,$00,$14,$0A,$00,$00,$EB,$EB,$F5

;Vertices List - Z coordinate
	.byt $5E,$14,$F9,$F9,$F2,$D1,$D1,$D1,$14,$F2,$D1

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,1,3,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,1,0,2


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,3,8,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,2,0,8


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,1,4,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,1,2,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,9,8,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,9,2,8


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 4,5,6,3,4 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,7,5,4,2


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,10,7,2,9 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,6,10,9,3


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 5,7,10,6,5 ; Inverted


; End of ship PYTHON data

; Model of ship SIDEWINDER
SIDEWINDER
	.byt 0	; Ship type
	.byt 10	;Number of vertices
	.byt 8	;Number of faces

;Vertices List - X coordinate
	.byt $E0,$20,$40,$C0,$00,$00,$F4,$0C,$0C,$F4

;Vertices List - Y coordinate
	.byt $00,$00,$00,$00,$10,$F0,$06,$06,$FA,$FA

;Vertices List - Z coordinate
	.byt $24,$24,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,0,1,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 4,3,0,4


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,4,1,2


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,5,3,4,2


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,0,3,5


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,5,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,1,5,2 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 8,9,6,7,8


; End of ship SIDEWINDER data

; Model of ship SHUTTLE
SHUTTLE
	.byt 0	; Ship type
	.byt 19	;Number of vertices
	.byt 16	;Number of faces

;Vertices List - X coordinate
	.byt $00,$EF,$00,$12,$EC,$EC,$14,$14,$05,$00,$FB,$00,$00,$03,$04,$0B,$FD,$FD,$F6

;Vertices List - Y coordinate
	.byt $EF,$00,$12,$00,$EC,$14,$14,$EC,$00,$FE,$00,$03,$F7,$FF,$0B,$04,$FF,$0B,$04

;Vertices List - Z coordinate
	.byt $17,$17,$17,$17,$E5,$E5,$E5,$E5,$E5,$E5,$E5,$E5,$23,$1F,$19,$19,$1F,$19,$19

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,12,1,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,4,7,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,4,0,1


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,5,4,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,5,1,2


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,6,5,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,6,2,3


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,7,6,3 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,7,3,0 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,4,5,6,7


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,12,2,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,12,3,2 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,12,0,3


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 11,8,9,10,11


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 14,13,15,14 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 18,16,17,18


; End of ship SHUTTLE data

; Model of ship SPLINTER
SPLINTER
	.byt 0	; Ship type
	.byt 4	;Number of vertices
	.byt 4	;Number of faces

;Vertices List - X coordinate
	.byt $E8,$00,$0B,$0C

;Vertices List - Y coordinate
	.byt $E7,$0C,$FA,$2A

;Vertices List - Z coordinate
	.byt $10,$F6,$02,$07

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,1,3


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,2,3,0


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,3,1 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,0,1,2 ; Inverted


; End of ship SPLINTER data

; Model of ship THARGLET
THARGLET
	.byt 0	; Ship type
	.byt 10	;Number of vertices
	.byt 7	;Number of faces

;Vertices List - X coordinate
	.byt $F7,$F7,$F7,$F7,$F7,$09,$09,$09,$09,$09

;Vertices List - Y coordinate
	.byt $00,$DA,$E8,$18,$26,$00,$F6,$FA,$06,$0A

;Vertices List - Z coordinate
	.byt $28,$0C,$E0,$E0,$0C,$F8,$F1,$E6,$E6,$F1

; Face data
	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,1,0,4,3 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,5,0,1,6


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,6,1,2,7


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 8,7,2,3,8


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,8,3,4,9


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 4,0,5,9,4 ; Inverted


	.byt 5	;Number of points
	.byt 0	;Fill pattern
	.byt 9,5,6,7,8,9


; End of ship THARGLET data

; Model of ship THARGOID
THARGOID
	.byt 0	; Ship type
	.byt 20	;Number of vertices
	.byt 10	;Number of faces

;Vertices List - X coordinate
	.byt $12,$12,$12,$12,$12,$12,$12,$12,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2,$F2

;Vertices List - Y coordinate
	.byt $E4,$D9,$E4,$00,$1B,$26,$1B,$00,$BE,$A3,$BE,$00,$41,$5C,$41,$00,$24,$24,$DB,$DB

;Vertices List - Z coordinate
	.byt $1B,$00,$E4,$D9,$E4,$00,$1B,$26,$41,$00,$BE,$A3,$BE,$00,$41,$5C,$2D,$D2,$D2,$2D

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,8,9,1 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,1,9,10,2 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,2,10,11,3 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 4,3,11,12,4 ; Inverted


	.byt 8	;Number of points
	.byt 0	;Fill pattern
	.byt 0,1,2,3,4,5,6,7,0 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 5,4,12,13,5 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,5,13,14,6 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 7,6,14,15,7 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 15,8,0,7,15


	.byt 8	;Number of points
	.byt 0	;Fill pattern
	.byt 15,14,13,12,11,10,9,8,15


; End of ship THARGOID data

; Model of ship TRANSPORTER
TRANSPORTER
	.byt 0	; Ship type
	.byt 37	;Number of vertices
	.byt 15	;Number of faces

;Vertices List - X coordinate
	.byt $00,$E7,$E4,$E7,$1A,$1D,$1A,$00,$E2,$DF,$21,$1E,$F5,$F3,$0E,$0B,$FB,$EE,$FB,$EE,$F5,$F5,$05,$12,$0B,$05,$12,$0B,$0B,$F0,$F0,$11,$11,$F3,$0D,$09,$F8

;Vertices List - Y coordinate
	.byt $0A,$04,$FD,$F8,$F8,$FD,$04,$06,$FF,$F8,$F8,$FF,$FE,$F8,$F8,$FE,$06,$03,$07,$04,$06,$05,$07,$04,$05,$06,$03,$04,$05,$F8,$F8,$F8,$F8,$FD,$FD,$03,$03

;Vertices List - Z coordinate
	.byt $E6,$E6,$E6,$E6,$E6,$E6,$E6,$0C,$0C,$0C,$0C,$0C,$1E,$1E,$1E,$1E,$02,$02,$F9,$F9,$F2,$F9,$F2,$F2,$F9,$FD,$FD,$08,$FD,$F3,$10,$F3,$10,$E6,$E6,$E6,$E6

; Face data
	.byt 7	;Number of points
	.byt 0	;Fill pattern
	.byt 5,4,3,2,1,0,6,5 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,8,1,2,9


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 3,9,2,3


	.byt 6	;Number of points
	.byt 0	;Fill pattern
	.byt 14,13,9,3,4,10,14


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 5,10,4,5


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 11,10,5,6,11


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,0,7,11,6 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 8,7,0,1,8


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 8,12,7,8


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 13,12,8,9,13


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 15,14,10,11,15


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,15,11,7 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,12,15,7 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 15,12,13,14,15


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 35,34,33,36,35 ; Inverted


; End of ship TRANSPORTER data

; Model of ship VIPER
VIPER
	.byt 0	; Ship type
	.byt 15	;Number of vertices
	.byt 9	;Number of faces

;Vertices List - X coordinate
	.byt $00,$00,$00,$30,$D0,$18,$E8,$18,$E8,$E0,$20,$08,$F8,$F8,$08

;Vertices List - Y coordinate
	.byt $00,$10,$F0,$00,$00,$F0,$F0,$10,$10,$00,$00,$08,$08,$F8,$F8

;Vertices List - Z coordinate
	.byt $48,$18,$18,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8

; Face data
	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 7,8,1,7


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 8,4,0,1,8


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 3,7,1,0,3


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,0,4,6,2 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 0,2,5,3,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 2,6,5,2 ; Inverted


	.byt 6	;Number of points
	.byt 0	;Fill pattern
	.byt 4,8,7,3,5,6,4 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 12,13,9,12


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 10,14,11,10 ; Inverted


; End of ship VIPER data

; Model of ship WORM
WORM
	.byt 0	; Ship type
	.byt 10	;Number of vertices
	.byt 8	;Number of faces

;Vertices List - X coordinate
	.byt $0A,$F6,$05,$FB,$0F,$F1,$1A,$E6,$08,$F8

;Vertices List - Y coordinate
	.byt $F6,$F6,$06,$06,$F6,$F6,$F6,$F6,$0E,$0E

;Vertices List - Z coordinate
	.byt $23,$23,$0F,$0F,$19,$19,$E7,$E7,$E7,$E7

; Face data
	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 1,0,2,3,1 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 9,3,2,8,9


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 0,4,2,0 ; Inverted


	.byt 3	;Number of points
	.byt 0	;Fill pattern
	.byt 1,3,5,1 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 2,4,6,8,2 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 5,3,9,7,5 ; Inverted


	.byt 4	;Number of points
	.byt 0	;Fill pattern
	.byt 6,7,9,8,6 ; Inverted


	.byt 6	;Number of points
	.byt 0	;Fill pattern
	.byt 4,0,1,5,7,6,4


; End of ship WORM data





 ; Model pointers:
	 .byt 30 ; Number of models
ShipsLo
	 .byt <(ADDER), <(ANACONDA), <(ASP), <(ASTEROID), <(BARREL), <(BOA), <(BOULDER), <(CAPSULE), <(COBRA), <(COBRAMK1), <(CONSTRICTOR), <(CORIOLIS), <(COUGAR), <(DODO), <(FERDELANCE), <(GECKO), <(KRAIT), <(MAMBA), <(MISSILE), <(MORAY), <(PLATELET), <(PYTHON), <(SIDEWINDER), <(SHUTTLE), <(SPLINTER), <(THARGLET), <(THARGOID), <(TRANSPORTER), <(VIPER), <(WORM)
ShipsHi
	 .byt >(ADDER), >(ANACONDA), >(ASP), >(ASTEROID), >(BARREL), >(BOA), >(BOULDER), >(CAPSULE), >(COBRA), >(COBRAMK1), >(CONSTRICTOR), >(CORIOLIS), >(COUGAR), >(DODO), >(FERDELANCE), >(GECKO), >(KRAIT), >(MAMBA), >(MISSILE), >(MORAY), >(PLATELET), >(PYTHON), >(SIDEWINDER), >(SHUTTLE), >(SPLINTER), >(THARGLET), >(THARGOID), >(TRANSPORTER), >(VIPER), >(WORM)

__models_end

#echo Size of models in bytes:
#print (__models_end - __models_start)
#echo