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
; Animatory state 0 (laundryrobot0.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 6, 7, 0
; Animatory state 1 (laundryrobot1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 8, 9, 7, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $f, $0, $d, $1, $d
; Tile graphic 2
.byt $0, $0, $0, $3f, $0, $3f, $23, $23
; Tile graphic 3
.byt $0, $0, $0, $3f, $0, $3f, $31, $31
; Tile graphic 4
.byt $0, $0, $0, $3c, $0, $2c, $20, $2c
; Tile graphic 5
.byt $1, $e, $0, $f, $0, $0, $3, $0
; Tile graphic 6
.byt $3f, $3f, $0, $3f, $0, $0, $3f, $0
; Tile graphic 7
.byt $20, $1c, $0, $3c, $0, $0, $30, $0
; Tile graphic 8
.byt $3e, $38, $0, $3f, $0, $0, $3f, $0
; Tile graphic 9
.byt $1f, $7, $0, $3f, $0, $0, $3f, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $70, $60, $60, $60, $60, $60
; Tile mask 2
.byt $7e, $7c, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $5f, $4f, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $43, $41, $41, $41, $41, $41
; Tile mask 5
.byt $60, $60, $60, $60, $60, $70, $78, $78
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $41, $41, $41, $41, $41, $43, $47, $47
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

