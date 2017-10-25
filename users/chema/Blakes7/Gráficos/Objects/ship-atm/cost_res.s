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
; Animatory state 0 (shipatm1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 1 (shipatm2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 4, 5, 6
.byt 0, 0, 0, 7, 8
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $3f, $7, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $1f, $3c, $38, $3c, $7, $0, $0, $0
; Tile graphic 3
.byt $30, $8, $14, $8, $30, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $f, $1, $0
; Tile graphic 5
.byt $0, $0, $0, $0, $7, $3f, $3e, $f
; Tile graphic 6
.byt $0, $0, $0, $0, $3c, $2, $5, $2
; Tile graphic 7
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 8
.byt $3c, $0, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $40, $78, $ff, $ff, $ff, $ff, $ff
; Tile mask 2
.byt $60, $40, $40, $40, $78, $ff, $ff, $ff
; Tile mask 3
.byt $4f, $47, $43, $47, $4f, $ff, $ff, $ff
; Tile mask 4
.byt $ff, $ff, $ff, $ff, $ff, $70, $7e, $ff
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $78, $40, $40, $70
; Tile mask 6
.byt $ff, $ff, $ff, $ff, $43, $41, $40, $41
; Tile mask 7
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 8
.byt $43, $ff, $ff, $ff, $ff, $ff, $ff, $ff
res_end
.)

