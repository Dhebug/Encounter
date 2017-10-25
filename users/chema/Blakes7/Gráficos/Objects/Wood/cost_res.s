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
; Animatory state 0 (wood1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 0, 0, 0, 6, 7
; Animatory state 1 (wood2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 8, 9, 10, 11, 12
.byt 13, 14, 15, 16, 7
costume_tiles
; Tile graphic 1
.byt $0, $0, $e, $5, $3, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $10, $3f, $5, $0, $0
; Tile graphic 3
.byt $0, $0, $0, $0, $20, $15, $f, $0
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $0, $3f, $15
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $0, $c
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 7
.byt $2c, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 8
.byt $0, $0, $0, $0, $0, $0, $3, $15
; Tile graphic 9
.byt $0, $0, $0, $0, $0, $0, $38, $15
; Tile graphic 10
.byt $0, $0, $0, $0, $0, $0, $1, $15
; Tile graphic 11
.byt $0, $0, $0, $0, $0, $0, $3f, $15
; Tile graphic 12
.byt $0, $0, $0, $0, $0, $0, $2c, $c
; Tile graphic 13
.byt $1f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 14
.byt $3f, $5, $0, $0, $0, $0, $0, $0
; Tile graphic 15
.byt $3f, $14, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $3f, $0, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $71, $60, $60, $70, $7c, $ff, $ff
; Tile mask 2
.byt $ff, $ff, $4f, $40, $40, $40, $78, $ff
; Tile mask 3
.byt $ff, $ff, $ff, $5f, $40, $40, $40, $70
; Tile mask 4
.byt $ff, $ff, $ff, $ff, $5f, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $ff, $ff, $43, $41
; Tile mask 6
.byt $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 7
.byt $41, $43, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 8
.byt $ff, $ff, $ff, $ff, $ff, $7c, $60, $40
; Tile mask 9
.byt $ff, $ff, $ff, $ff, $ff, $47, $40, $40
; Tile mask 10
.byt $ff, $ff, $ff, $ff, $ff, $7e, $40, $40
; Tile mask 11
.byt $ff, $ff, $ff, $ff, $ff, $40, $40, $40
; Tile mask 12
.byt $ff, $ff, $ff, $ff, $ff, $43, $41, $41
; Tile mask 13
.byt $40, $60, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 14
.byt $40, $40, $78, $ff, $ff, $ff, $ff, $ff
; Tile mask 15
.byt $40, $40, $43, $ff, $ff, $ff, $ff, $ff
; Tile mask 16
.byt $40, $40, $ff, $ff, $ff, $ff, $ff, $ff
res_end
.)

