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
; Animatory state 0 (cell.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 7, 7, 8
costume_tiles
; Tile graphic 1
.byt $0, $0, $1e, $16, $1e, $16, $16, $1e
; Tile graphic 2
.byt $0, $0, $0, $3f, $0, $1f, $0, $0
; Tile graphic 3
.byt $0, $0, $0, $3f, $0, $37, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $3f, $0, $36, $0, $0
; Tile graphic 5
.byt $0, $0, $1e, $1e, $1a, $1e, $1a, $1e
; Tile graphic 6
.byt $16, $1e, $0, $0, $0, $0, $0, $0
; Tile graphic 7
.byt $3f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 8
.byt $1a, $1e, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $61, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 5
.byt $ff, $61, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $40, $40, $61, $ff, $ff, $ff, $ff, $ff
; Tile mask 7
.byt $40, $40, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 8
.byt $40, $40, $61, $ff, $ff, $ff, $ff, $ff
res_end
.)

