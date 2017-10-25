.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 203
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (0-empty.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 6, 7, 0
; Animatory state 1 (0-empty2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 8, 2, 3, 4, 0
.byt 5, 6, 6, 7, 0
; Animatory state 2 (1-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 9, 10, 3, 4, 0
.byt 5, 6, 6, 7, 0
; Animatory state 3 (2-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 9, 11, 12, 4, 0
.byt 5, 6, 6, 7, 0
; Animatory state 4 (3-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 14, 15, 4, 0
.byt 5, 6, 6, 7, 0
; Animatory state 5 (4-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 16, 17, 4, 0
.byt 5, 6, 6, 7, 0
; Animatory state 6 (5-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 16, 17, 4, 0
.byt 18, 19, 6, 7, 0
; Animatory state 7 (6-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 16, 17, 4, 0
.byt 18, 19, 20, 7, 0
; Animatory state 8 (7-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 16, 17, 4, 0
.byt 21, 22, 20, 7, 0
; Animatory state 9 (8-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 16, 17, 4, 0
.byt 21, 23, 24, 7, 0
; Animatory state 10 (9-.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 13, 16, 17, 4, 0
.byt 21, 23, 25, 7, 0
costume_tiles
; Tile graphic 1
.byt $20, $1f, $18, $10, $10, $10, $10, $10
; Tile graphic 2
.byt $0, $3f, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $0, $3f, $0, $0, $1, $0, $0, $0
; Tile graphic 4
.byt $1, $3e, $6, $2, $2, $22, $22, $22
; Tile graphic 5
.byt $10, $10, $10, $10, $10, $18, $1f, $20
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $0, $3f, $0
; Tile graphic 7
.byt $22, $22, $2, $2, $2, $6, $3e, $1
; Tile graphic 8
.byt $20, $1f, $18, $10, $10, $12, $10, $10
; Tile graphic 9
.byt $20, $1f, $18, $10, $10, $13, $10, $10
; Tile graphic 10
.byt $0, $3f, $0, $0, $0, $28, $0, $0
; Tile graphic 11
.byt $0, $3f, $0, $0, $0, $2b, $0, $0
; Tile graphic 12
.byt $0, $3f, $0, $0, $1, $18, $0, $0
; Tile graphic 13
.byt $20, $1f, $18, $10, $10, $13, $10, $12
; Tile graphic 14
.byt $0, $3f, $0, $0, $0, $2b, $0, $30
; Tile graphic 15
.byt $0, $3f, $0, $0, $1, $1a, $0, $0
; Tile graphic 16
.byt $0, $3f, $0, $0, $0, $2b, $0, $37
; Tile graphic 17
.byt $0, $3f, $0, $0, $1, $1a, $0, $1c
; Tile graphic 18
.byt $10, $13, $10, $10, $10, $18, $1f, $20
; Tile graphic 19
.byt $0, $16, $0, $0, $0, $0, $3f, $0
; Tile graphic 20
.byt $0, $3a, $0, $0, $0, $0, $3f, $0
; Tile graphic 21
.byt $10, $13, $10, $13, $10, $18, $1f, $20
; Tile graphic 22
.byt $0, $16, $0, $30, $0, $0, $3f, $0
; Tile graphic 23
.byt $0, $16, $0, $35, $0, $0, $3f, $0
; Tile graphic 24
.byt $0, $3a, $0, $28, $0, $0, $3f, $0
; Tile graphic 25
.byt $0, $3a, $0, $20, $0, $0, $3f, $0
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
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

