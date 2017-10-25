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
; Animatory state 0 (rope.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 0, 0, 0, 0
.byt 2, 0, 0, 0, 0
.byt 3, 0, 0, 0, 0
.byt 4, 0, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $34, $29, $8, $28, $29, $2a, $29, $28
; Tile graphic 2
.byt $11, $e, $9, $23, $2b, $2b, $28, $a
; Tile graphic 3
.byt $8, $2a, $8, $2a, $8, $a, $9, $2a
; Tile graphic 4
.byt $9, $2a, $9, $2a, $9, $2a, $9, $a
costume_masks
; Tile mask 1
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

