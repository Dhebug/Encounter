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
; Animatory state 0 (0-off.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
; Animatory state 1 (1-on.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 3, 2, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $f, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $2a, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $0, $0, $f, $0, $0, $c, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $40, $40, $40, $40, $40, $40, $ff
; Tile mask 2
.byt $ff, $40, $40, $40, $40, $40, $40, $ff
; Tile mask 3
.byt $ff, $40, $40, $40, $40, $40, $40, $ff
res_end
.)

