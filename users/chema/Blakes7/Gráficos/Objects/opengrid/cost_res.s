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
; Animatory state 0 (opengrid.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 3, 4
.byt 5, 6, 7, 7, 8
.byt 9, 10, 10, 10, 11
costume_tiles
; Tile graphic 1
.byt $0, $14, $0, $14, $0, $14, $0, $14
; Tile graphic 2
.byt $3f, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 3
.byt $3f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $3f, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 5
.byt $0, $3c, $0, $14, $28, $14, $28, $14
; Tile graphic 6
.byt $20, $20, $20, $20, $20, $20, $3f, $20
; Tile graphic 7
.byt $0, $0, $0, $0, $0, $0, $3f, $0
; Tile graphic 8
.byt $1, $1, $1, $1, $1, $1, $3f, $1
; Tile graphic 9
.byt $2b, $16, $2c, $1b, $30, $2f, $20, $0
; Tile graphic 10
.byt $0, $3f, $0, $3f, $0, $3f, $0, $0
; Tile graphic 11
.byt $2, $3f, $6, $3d, $a, $35, $2a, $0
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
res_end
.)

