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
; Animatory state 0 (cadoor.png)
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 7
.byt 10, 11, 12, 13, 11
.byt 14, 15, 8, 4, 16
.byt 17, 18, 8, 4, 16
.byt 19, 20, 21, 22, 23
.byt 4, 24, 25, 9, 24
; Animatory state 1 (cadoor1.png)
.byt 1, 26, 27, 27, 27
.byt 6, 27, 27, 27, 27
.byt 28, 27, 27, 27, 27
.byt 4, 27, 27, 27, 27
.byt 4, 27, 27, 27, 27
.byt 4, 27, 27, 27, 27
.byt 4, 27, 29, 27, 27
costume_tiles
; Tile graphic 1
.byt $e, $35, $36, $c, $38, $20, $0, $0
; Tile graphic 2
.byt $2a, $4, $0, $8, $8, $18, $18, $18
; Tile graphic 3
.byt $0, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 4
.byt $20, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 5
.byt $0, $0, $0, $8, $8, $18, $18, $18
; Tile graphic 6
.byt $20, $0, $20, $0, $20, $0, $20, $20
; Tile graphic 7
.byt $18, $18, $18, $18, $18, $18, $18, $10
; Tile graphic 8
.byt $1, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 9
.byt $20, $20, $20, $20, $20, $20, $20, $0
; Tile graphic 10
.byt $1f, $15, $1f, $1f, $20, $20, $0, $0
; Tile graphic 11
.byt $3f, $2d, $3f, $3f, $10, $18, $18, $18
; Tile graphic 12
.byt $3f, $2d, $3f, $3f, $1, $1, $1, $1
; Tile graphic 13
.byt $3f, $2d, $3f, $3f, $0, $20, $20, $20
; Tile graphic 14
.byt $3f, $0, $1f, $3f, $39, $30, $39, $39
; Tile graphic 15
.byt $3c, $14, $2c, $34, $34, $34, $34, $34
; Tile graphic 16
.byt $18, $18, $18, $18, $18, $18, $18, $18
; Tile graphic 17
.byt $1f, $0, $3f, $20, $20, $20, $20, $20
; Tile graphic 18
.byt $2c, $14, $3c, $18, $18, $18, $18, $18
; Tile graphic 19
.byt $1f, $15, $1f, $1f, $20, $20, $20, $20
; Tile graphic 20
.byt $3f, $2d, $3f, $3f, $8, $18, $18, $18
; Tile graphic 21
.byt $3f, $2d, $3f, $3f, $0, $1, $1, $1
; Tile graphic 22
.byt $3f, $2d, $3f, $3f, $20, $20, $20, $20
; Tile graphic 23
.byt $3f, $3d, $3f, $3f, $8, $18, $18, $18
; Tile graphic 24
.byt $18, $18, $18, $18, $18, $8, $8, $0
; Tile graphic 25
.byt $1, $1, $1, $1, $1, $9, $30, $11
; Tile graphic 26
.byt $2a, $4, $0, $0, $0, $0, $0, $0
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 28
.byt $0, $0, $0, $20, $20, $20, $20, $20
; Tile graphic 29
.byt $0, $0, $0, $0, $0, $8, $30, $11
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
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
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
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 26
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 27
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

