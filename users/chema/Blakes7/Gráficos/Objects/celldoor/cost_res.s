.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 200
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (cell-A.png)
.byt 1, 2, 2, 0, 0
.byt 3, 2, 2, 0, 0
.byt 4, 2, 2, 0, 0
.byt 5, 2, 6, 0, 0
.byt 5, 2, 7, 0, 0
.byt 8, 9, 10, 0, 0
.byt 11, 12, 12, 0, 0
; Animatory state 1 (cell-B.png)
.byt 1, 2, 2, 0, 0
.byt 13, 2, 2, 0, 0
.byt 14, 2, 2, 0, 0
.byt 15, 2, 6, 0, 0
.byt 15, 2, 7, 0, 0
.byt 16, 9, 10, 0, 0
.byt 17, 12, 12, 0, 0
; Animatory state 2 (cell-C.png)
.byt 1, 2, 2, 0, 0
.byt 13, 2, 2, 0, 0
.byt 18, 2, 2, 0, 0
.byt 2, 2, 6, 0, 0
.byt 2, 2, 7, 0, 0
.byt 19, 9, 10, 0, 0
.byt 17, 12, 12, 0, 0
costume_tiles
; Tile graphic 1
.byt $2a, $14, $28, $14, $28, $14, $28, $14
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $24, $14, $24, $14, $24, $14, $24, $14
; Tile graphic 4
.byt $24, $4, $24, $4, $24, $24, $24, $24
; Tile graphic 5
.byt $24, $24, $24, $24, $24, $24, $24, $24
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $1, $0, $1
; Tile graphic 7
.byt $0, $1, $2, $1, $2, $1, $2, $1
; Tile graphic 8
.byt $24, $24, $24, $24, $24, $24, $20, $21
; Tile graphic 9
.byt $0, $0, $0, $0, $0, $15, $2a, $15
; Tile graphic 10
.byt $2, $5, $2, $0, $0, $15, $2a, $15
; Tile graphic 11
.byt $22, $5, $a, $15, $2a, $15, $2a, $15
; Tile graphic 12
.byt $2a, $15, $2a, $15, $2a, $15, $2a, $15
; Tile graphic 13
.byt $20, $10, $20, $10, $20, $10, $20, $10
; Tile graphic 14
.byt $30, $10, $30, $10, $10, $10, $10, $10
; Tile graphic 15
.byt $10, $10, $10, $10, $10, $10, $10, $10
; Tile graphic 16
.byt $10, $10, $10, $10, $10, $10, $10, $11
; Tile graphic 17
.byt $2, $5, $a, $15, $2a, $15, $2a, $15
; Tile graphic 18
.byt $30, $10, $20, $0, $0, $0, $0, $0
; Tile graphic 19
.byt $0, $0, $0, $0, $0, $0, $0, $1
costume_masks
; Tile mask 1
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

