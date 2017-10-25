.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 0
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (cameraA.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 1, 2, 0, 0
.byt 0, 3, 4, 5, 0
.byt 6, 7, 8, 9, 0
.byt 10, 11, 12, 0, 0
; Animatory state 1 (cameraB.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 13, 14, 0, 0
.byt 0, 15, 16, 17, 0
.byt 6, 18, 19, 20, 0
.byt 10, 11, 12, 0, 0
; Animatory state 2 (cameraC.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 21, 2, 0, 0
.byt 6, 22, 23, 0, 0
.byt 24, 25, 26, 0, 0
.byt 10, 11, 12, 0, 0
; Animatory state 3 (cameraD.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 13, 27, 0, 0
.byt 28, 29, 30, 0, 0
.byt 31, 32, 33, 0, 0
.byt 10, 11, 12, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $7, $8, $12
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $30, $8, $24
; Tile graphic 3
.byt $24, $2a, $25, $2a, $15, $a, $9, $8
; Tile graphic 4
.byt $2, $1, $0, $2a, $10, $27, $c, $29
; Tile graphic 5
.byt $0, $0, $20, $10, $8, $24, $34, $14
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $1, $1, $1
; Tile graphic 7
.byt $8, $8, $8, $18, $20, $0, $0, $8
; Tile graphic 8
.byt $8, $c, $27, $20, $27, $24, $24, $24
; Tile graphic 9
.byt $14, $34, $24, $8, $30, $0, $0, $0
; Tile graphic 10
.byt $1, $1, $1, $1, $0, $0, $0, $0
; Tile graphic 11
.byt $8, $7, $0, $0, $20, $10, $f, $0
; Tile graphic 12
.byt $24, $4, $4, $4, $8, $10, $20, $0
; Tile graphic 13
.byt $0, $0, $0, $0, $0, $3, $4, $9
; Tile graphic 14
.byt $0, $0, $0, $0, $0, $30, $8, $14
; Tile graphic 15
.byt $12, $14, $12, $15, $12, $14, $9, $9
; Tile graphic 16
.byt $4, $2, $2, $15, $1, $3c, $26, $a
; Tile graphic 17
.byt $0, $0, $0, $0, $0, $20, $20, $20
; Tile graphic 18
.byt $9, $9, $8, $1a, $20, $0, $0, $8
; Tile graphic 19
.byt $2, $26, $3c, $1, $3e, $24, $24, $24
; Tile graphic 20
.byt $20, $20, $20, $0, $0, $0, $0, $0
; Tile graphic 21
.byt $0, $0, $0, $0, $0, $3, $4, $a
; Tile graphic 22
.byt $8, $10, $10, $2a, $20, $f, $19, $14
; Tile graphic 23
.byt $12, $a, $12, $2a, $12, $a, $24, $24
; Tile graphic 24
.byt $1, $1, $1, $0, $0, $0, $1, $1
; Tile graphic 25
.byt $10, $19, $f, $20, $1f, $20, $0, $8
; Tile graphic 26
.byt $24, $24, $4, $14, $4, $24, $24, $24
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $38, $4, $12
; Tile graphic 28
.byt $0, $0, $1, $2, $4, $9, $b, $a
; Tile graphic 29
.byt $10, $20, $0, $15, $2, $39, $c, $25
; Tile graphic 30
.byt $9, $15, $29, $15, $2a, $14, $28, $10
; Tile graphic 31
.byt $a, $b, $9, $4, $3, $1, $1, $1
; Tile graphic 32
.byt $4, $d, $3a, $4, $38, $0, $0, $8
; Tile graphic 33
.byt $28, $8, $28, $28, $24, $24, $24, $24
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $78, $70, $60
; Tile mask 2
.byt $ff, $ff, $ff, $ff, $ff, $4f, $47, $43
; Tile mask 3
.byt $40, $40, $40, $40, $60, $70, $70, $70
; Tile mask 4
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $5f, $4f, $47, $43, $43, $43
; Tile mask 6
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7e, $7e
; Tile mask 7
.byt $70, $70, $70, $60, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $43, $43, $43
; Tile mask 9
.byt $43, $43, $43, $47, $4f, $ff, $ff, $ff
; Tile mask 10
.byt $7e, $7e, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 11
.byt $40, $40, $40, $40, $40, $60, $70, $ff
; Tile mask 12
.byt $43, $43, $43, $43, $47, $4f, $5f, $ff
; Tile mask 13
.byt $ff, $ff, $ff, $ff, $ff, $7c, $78, $70
; Tile mask 14
.byt $ff, $ff, $ff, $ff, $ff, $4f, $47, $43
; Tile mask 15
.byt $60, $60, $60, $60, $60, $60, $70, $70
; Tile mask 16
.byt $43, $41, $41, $40, $40, $40, $40, $40
; Tile mask 17
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 18
.byt $70, $70, $70, $60, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $41, $43, $43, $43
; Tile mask 20
.byt $5f, $5f, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 21
.byt $ff, $ff, $ff, $ff, $ff, $7c, $78, $70
; Tile mask 22
.byt $70, $60, $60, $40, $40, $40, $40, $40
; Tile mask 23
.byt $41, $41, $41, $41, $41, $41, $43, $43
; Tile mask 24
.byt $7e, $7e, $7e, $ff, $ff, $ff, $7e, $7e
; Tile mask 25
.byt $40, $40, $40, $40, $60, $40, $40, $40
; Tile mask 26
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile mask 27
.byt $ff, $ff, $ff, $ff, $ff, $47, $43, $41
; Tile mask 28
.byt $ff, $ff, $7e, $7c, $78, $70, $70, $70
; Tile mask 29
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $40, $40, $40, $40, $41, $43, $47, $4f
; Tile mask 31
.byt $70, $70, $70, $78, $7c, $7e, $7e, $7e
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $47, $47, $47, $47, $43, $43, $43, $43
res_end
.)

