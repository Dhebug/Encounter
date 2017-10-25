.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 201
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (mug.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
costume_tiles
; Tile graphic 1
.byt $3, $4, $b, $9, $a, $b, $b, $a
; Tile graphic 2
.byt $3f, $0, $3f, $3e, $1, $3f, $1b, $3d
; Tile graphic 3
.byt $0, $20, $10, $10, $10, $8, $34, $14
; Tile graphic 4
.byt $a, $a, $a, $b, $5, $2, $1, $0
; Tile graphic 5
.byt $25, $25, $1, $3, $3e, $1, $3e, $0
; Tile graphic 6
.byt $14, $34, $8, $10, $20, $0, $0, $0
costume_masks
; Tile mask 1
.byt $7c, $78, $70, $70, $70, $70, $70, $70
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $5f, $4f, $4f, $4f, $47, $43, $43
; Tile mask 4
.byt $70, $70, $70, $70, $78, $7c, $7e, $ff
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $41, $ff
; Tile mask 6
.byt $43, $43, $47, $4f, $5f, $ff, $ff, $ff
res_end
.)

