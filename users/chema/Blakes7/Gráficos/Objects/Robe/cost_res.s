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
; Animatory state 0 (robe.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
.byt 3, 4, 0, 0, 0
.byt 5, 6, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $3c, $3a, $16, $2a, $f, $20, $20
; Tile graphic 2
.byt $0, $1f, $3f, $35, $3a, $3c, $1, $1
; Tile graphic 3
.byt $20, $20, $24, $24, $24, $26, $22, $23
; Tile graphic 4
.byt $1, $1, $11, $11, $11, $11, $11, $11
; Tile graphic 5
.byt $21, $10, $10, $10, $10, $10, $f, $1
; Tile graphic 6
.byt $11, $11, $11, $13, $2, $6, $4, $3c
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
res_end
.)

