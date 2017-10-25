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
; Animatory state 0 (cagate1.png)
.byt 1, 2, 3, 4, 5
.byt 6, 7, 7, 7, 8
.byt 9, 9, 9, 9, 9
.byt 10, 10, 10, 10, 10
.byt 11, 11, 11, 11, 11
.byt 10, 10, 10, 10, 10
.byt 11, 11, 11, 11, 11
; Animatory state 1 (cagate2.png)
.byt 12, 13, 14, 15, 16
.byt 17, 9, 9, 9, 18
.byt 7, 7, 7, 7, 7
.byt 9, 9, 9, 9, 9
.byt 7, 7, 7, 7, 7
.byt 9, 9, 9, 9, 9
.byt 19, 19, 19, 19, 19
; Animatory state 2 (cagate3.png)
.byt 1, 2, 3, 4, 5
.byt 20, 10, 10, 10, 21
.byt 11, 11, 11, 11, 11
.byt 10, 10, 10, 10, 10
.byt 11, 11, 11, 11, 11
.byt 19, 19, 19, 19, 19
.byt 0, 0, 0, 0, 0
; Animatory state 3 (cagate4.png)
.byt 12, 13, 14, 15, 16
.byt 17, 9, 9, 9, 18
.byt 7, 7, 7, 7, 7
.byt 9, 9, 9, 9, 9
.byt 19, 19, 19, 19, 19
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 4 (cagate5.png)
.byt 1, 2, 3, 4, 5
.byt 20, 10, 10, 10, 21
.byt 11, 11, 11, 11, 11
.byt 19, 19, 19, 19, 19
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 5 (cagate6.png)
.byt 12, 13, 14, 15, 16
.byt 17, 9, 9, 9, 18
.byt 19, 19, 19, 19, 19
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $3f, $3f, $3f, $3f, $3f, $1f, $2c
; Tile graphic 2
.byt $0, $3e, $3e, $3e, $3e, $30, $4, $c
; Tile graphic 3
.byt $0, $3e, $3e, $3e, $0, $c, $c, $c
; Tile graphic 4
.byt $0, $3f, $3f, $3f, $3f, $3, $8, $c
; Tile graphic 5
.byt $0, $3f, $3f, $3f, $3f, $3f, $1e, $d
; Tile graphic 6
.byt $30, $34, $2c, $2c, $c, $c, $c, $c
; Tile graphic 7
.byt $c, $c, $c, $c, $c, $c, $c, $c
; Tile graphic 8
.byt $3, $b, $d, $d, $c, $c, $c, $c
; Tile graphic 9
.byt $1e, $36, $36, $1e, $c, $c, $c, $c
; Tile graphic 10
.byt $c, $c, $c, $c, $c, $c, $c, $1e
; Tile graphic 11
.byt $36, $36, $1e, $c, $c, $c, $c, $c
; Tile graphic 12
.byt $0, $3f, $3f, $3f, $3f, $3f, $1f, $2c
; Tile graphic 13
.byt $0, $3e, $3e, $3e, $3e, $30, $4, $c
; Tile graphic 14
.byt $0, $3e, $3e, $3e, $0, $c, $c, $c
; Tile graphic 15
.byt $0, $3f, $3f, $3f, $3f, $3, $8, $c
; Tile graphic 16
.byt $0, $3f, $3f, $3f, $3f, $3f, $1e, $d
; Tile graphic 17
.byt $32, $36, $26, $2e, $c, $c, $c, $c
; Tile graphic 18
.byt $13, $33, $35, $1d, $c, $c, $c, $c
; Tile graphic 19
.byt $c, $4, $0, $0, $0, $0, $0, $0
; Tile graphic 20
.byt $30, $34, $2c, $2c, $c, $c, $c, $1e
; Tile graphic 21
.byt $3, $b, $d, $d, $c, $c, $c, $1e
costume_masks
; Tile mask 1
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 2
.byt $40, $40, $40, $40, $40, $41, $61, $61
; Tile mask 3
.byt $40, $40, $40, $40, $40, $61, $61, $61
; Tile mask 4
.byt $40, $40, $40, $40, $40, $60, $61, $61
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 6
.byt $43, $41, $41, $41, $61, $61, $61, $61
; Tile mask 7
.byt $61, $61, $61, $61, $61, $61, $61, $61
; Tile mask 8
.byt $60, $60, $60, $60, $61, $61, $61, $61
; Tile mask 9
.byt $40, $40, $40, $40, $61, $61, $61, $61
; Tile mask 10
.byt $61, $61, $61, $61, $61, $61, $61, $40
; Tile mask 11
.byt $40, $40, $40, $61, $61, $61, $61, $61
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $61, $61, $61, $61
; Tile mask 18
.byt $40, $40, $40, $40, $61, $61, $61, $61
; Tile mask 19
.byt $61, $71, $7b, $ff, $ff, $ff, $ff, $ff
; Tile mask 20
.byt $43, $41, $41, $41, $61, $61, $61, $40
; Tile mask 21
.byt $60, $60, $60, $60, $61, $61, $61, $40
res_end
.)

