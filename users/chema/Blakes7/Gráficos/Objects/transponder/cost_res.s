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
; Animatory state 0 (transponder.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 0, 0, 0
.byt 3, 4, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $1, $6, $7, $5, $2
; Tile graphic 2
.byt $0, $0, $0, $0, $10, $28, $20, $28
; Tile graphic 3
.byt $5, $7, $5, $4, $4, $6, $1, $0
; Tile graphic 4
.byt $20, $28, $20, $28, $20, $28, $20, $0
costume_masks
; Tile mask 1
.byt $6f, $6f, $6c, $68, $60, $60, $60, $60
; Tile mask 2
.byt $ff, $ff, $ff, $4f, $43, $43, $43, $43
; Tile mask 3
.byt $70, $70, $70, $70, $70, $70, $78, $7e
; Tile mask 4
.byt $43, $43, $43, $43, $43, $43, $43, $47
res_end
.)

