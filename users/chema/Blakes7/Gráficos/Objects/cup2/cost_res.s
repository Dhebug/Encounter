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
; Animatory state 0 (cup0.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $3f
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 5
.byt $2f, $1e, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7e
; Tile mask 2
.byt $ff, $ff, $ff, $ff, $ff, $ff, $40, $40
; Tile mask 3
.byt $ff, $ff, $ff, $ff, $ff, $ff, $4f, $4f
; Tile mask 4
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 5
.byt $40, $40, $61, $ff, $ff, $ff, $ff, $ff
; Tile mask 6
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
res_end
.)

