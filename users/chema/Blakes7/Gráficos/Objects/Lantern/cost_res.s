.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 202
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (lantern.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
.byt 7, 8, 9, 0, 0
costume_tiles
; Tile graphic 1
.byt $1d, $3f, $37, $3f, $1f, $3f, $3f, $3e
; Tile graphic 2
.byt $37, $3f, $3f, $3f, $31, $20, $0, $0
; Tile graphic 3
.byt $1d, $3f, $37, $3f, $3d, $3f, $1f, $f
; Tile graphic 4
.byt $1e, $3e, $3f, $3f, $1f, $3f, $3f, $3f
; Tile graphic 5
.byt $0, $3b, $1b, $0, $1b, $2a, $2a, $20
; Tile graphic 6
.byt $f, $2f, $1f, $1f, $1f, $3f, $3f, $3f
; Tile graphic 7
.byt $1f, $3f, $3f, $3f, $1f, $3f, $37, $3f
; Tile graphic 8
.byt $31, $3b, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 9
.byt $3f, $3f, $3f, $3f, $3d, $3f, $37, $3f
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
res_end
.)

