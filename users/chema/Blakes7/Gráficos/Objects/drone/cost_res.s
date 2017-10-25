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
; Animatory state 0 (drone.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $1, $6, $6, $9, $f, $9
; Tile graphic 2
.byt $0, $0, $38, $36, $36, $39, $f, $39
; Tile graphic 3
.byt $0, $0, $0, $0, $4, $4, $4, $4
; Tile graphic 4
.byt $7, $4, $1, $6, $f, $0, $f, $0
; Tile graphic 5
.byt $16, $0, $1f, $f, $3f, $0, $3f, $0
; Tile graphic 6
.byt $24, $0, $2e, $4, $3a, $6, $34, $0
costume_masks
; Tile mask 1
.byt $ff, $7e, $78, $70, $60, $60, $60, $60
; Tile mask 2
.byt $ff, $47, $41, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $ff, $ff, $7b, $71, $51, $51, $51
; Tile mask 4
.byt $60, $70, $78, $70, $60, $60, $60, $60
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $41, $40, $40, $40, $40, $40, $41, $43
res_end
.)

