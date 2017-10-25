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
; Animatory state 0 (sandwich.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $3, $4, $b, $17
; Tile graphic 2
.byt $7, $8, $17, $2f, $1d, $3f, $36, $1f
; Tile graphic 3
.byt $0, $30, $c, $33, $1c, $3f, $37, $3e
; Tile graphic 4
.byt $0, $0, $0, $0, $30, $8, $14, $24
; Tile graphic 5
.byt $11, $14, $8, $4, $3, $0, $0, $0
; Tile graphic 6
.byt $3b, $1e, $7, $22, $10, $23, $1c, $3
; Tile graphic 7
.byt $2c, $39, $30, $d, $12, $24, $18, $20
; Tile graphic 8
.byt $28, $10, $20, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $7c, $78, $70, $60
; Tile mask 2
.byt $78, $70, $60, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $4f, $43, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $ff, $ff, $4f, $47, $43, $43
; Tile mask 5
.byt $60, $60, $70, $78, $7c, $ff, $ff, $ff
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $60, $7c
; Tile mask 7
.byt $40, $40, $40, $40, $41, $43, $47, $5f
; Tile mask 8
.byt $47, $4f, $5f, $ff, $ff, $ff, $ff, $ff
res_end
.)

