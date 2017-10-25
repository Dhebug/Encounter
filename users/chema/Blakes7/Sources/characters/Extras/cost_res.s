.(
.byt RESOURCE_COSTUME|$80
.word (res_end - res_start + 4)
.byt 210
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (00-BlakeGun.png)
.byt 0, 1, 2, 3, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 16, 17, 0
.byt 18, 19, 20, 21, 0
.byt 22, 23, 24, 25, 0
.byt 26, 27, 28, 29, 0
; Animatory state 1 (01-AvonGun.png)
.byt 0, 0, 0, 0, 0
.byt 30, 31, 32, 33, 34
.byt 35, 36, 37, 38, 39
.byt 40, 41, 42, 43, 44
.byt 45, 46, 47, 48, 49
.byt 50, 51, 52, 53, 54
.byt 55, 56, 57, 58, 59
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $2
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $14, $22
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $2, $5, $2, $4, $2
; Tile graphic 5
.byt $5, $22, $15, $a, $10, $2a, $0, $20
; Tile graphic 6
.byt $5, $2a, $15, $2a, $10, $2a, $0, $0
; Tile graphic 7
.byt $10, $28, $4, $28, $0, $2a, $1, $a
; Tile graphic 8
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 9
.byt $0, $8, $4, $a, $11, $a, $0, $3
; Tile graphic 10
.byt $1, $3, $7, $c, $9, $e, $d, $f
; Tile graphic 11
.byt $20, $3f, $3f, $7, $3e, $e, $16, $2f
; Tile graphic 12
.byt $1d, $3c, $3d, $2, $3c, $4, $28, $1c
; Tile graphic 13
.byt $0, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 14
.byt $3, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 15
.byt $1f, $3f, $1f, $3f, $3f, $3f, $1f, $2f
; Tile graphic 16
.byt $3f, $3f, $36, $3d, $3f, $21, $3f, $30
; Tile graphic 17
.byt $3c, $3c, $3c, $3c, $3c, $1c, $38, $38
; Tile graphic 18
.byt $0, $0, $1, $2, $4, $a, $5, $a
; Tile graphic 19
.byt $17, $9, $4, $23, $14, $7, $17, $6
; Tile graphic 20
.byt $3f, $3f, $1f, $0, $2e, $4, $33, $2f
; Tile graphic 21
.byt $30, $30, $8, $24, $10, $24, $20, $24
; Tile graphic 22
.byt $e, $e, $6, $6, $2, $1, $0, $1
; Tile graphic 23
.byt $13, $28, $2f, $28, $1, $0, $2, $26
; Tile graphic 24
.byt $3f, $3, $35, $3, $3f, $0, $2b, $2a
; Tile graphic 25
.byt $24, $14, $0, $16, $6, $2, $36, $0
; Tile graphic 26
.byt $1, $1, $1, $0, $1, $0, $7, $0
; Tile graphic 27
.byt $3f, $3f, $3f, $0, $3f, $f, $3e, $0
; Tile graphic 28
.byt $3f, $2f, $2f, $0, $7, $7, $3, $0
; Tile graphic 29
.byt $30, $30, $30, $0, $38, $20, $3e, $0
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $1, $2
; Tile graphic 31
.byt $0, $0, $5, $a, $15, $2a, $10, $20
; Tile graphic 32
.byt $0, $28, $15, $2a, $11, $0, $0, $0
; Tile graphic 33
.byt $0, $0, $0, $28, $14, $8, $0, $0
; Tile graphic 34
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 35
.byt $1, $2, $5, $a, $4, $a, $5, $8
; Tile graphic 36
.byt $3, $7, $f, $f, $e, $1d, $1f, $3e
; Tile graphic 37
.byt $29, $3f, $3f, $3f, $7, $3b, $3, $2b
; Tile graphic 38
.byt $1d, $3c, $3e, $3e, $22, $1c, $2, $14
; Tile graphic 39
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 40
.byt $2, $6, $7, $3, $0, $0, $0, $0
; Tile graphic 41
.byt $1f, $2f, $2f, $3f, $3f, $f, $1f, $7
; Tile graphic 42
.byt $37, $3f, $3f, $3c, $3e, $3f, $31, $3f
; Tile graphic 43
.byt $26, $3e, $3e, $1e, $3e, $3e, $e, $3c
; Tile graphic 44
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 45
.byt $0, $0, $0, $0, $2, $7, $4, $0
; Tile graphic 46
.byt $b, $5, $a, $2c, $31, $8, $30, $9
; Tile graphic 47
.byt $3c, $3f, $7, $38, $6, $38, $3f, $0
; Tile graphic 48
.byt $18, $38, $30, $4, $22, $5, $22, $14
; Tile graphic 49
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 50
.byt $0, $1, $3, $3, $1, $1, $0, $0
; Tile graphic 51
.byt $22, $9, $14, $17, $14, $9, $16, $0
; Tile graphic 52
.byt $0, $3e, $1, $3a, $1, $3e, $0, $0
; Tile graphic 53
.byt $4, $14, $4, $13, $3, $1, $3, $0
; Tile graphic 54
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 55
.byt $0, $0, $0, $0, $0, $3, $0, $0
; Tile graphic 56
.byt $2a, $0, $0, $0, $0, $28, $0, $0
; Tile graphic 57
.byt $2a, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 58
.byt $28, $0, $0, $0, $0, $1f, $0, $0
; Tile graphic 59
.byt $0, $0, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $78, $60
; Tile mask 2
.byt $ff, $ff, $ff, $ff, $ff, $ff, $40, $40
; Tile mask 3
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $4f
; Tile mask 4
.byt $ff, $7c, $78, $78, $70, $70, $70, $70
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $47, $43, $41, $41, $40, $40, $40, $40
; Tile mask 8
.byt $ff, $ff, $ff, $ff, $ff, $5f, $4f, $4f
; Tile mask 9
.byt $70, $60, $60, $40, $40, $40, $60, $60
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $4f, $4f, $5f, $5f, $5f, $5f, $ff, $ff
; Tile mask 14
.byt $60, $60, $60, $70, $70, $7c, $7e, $7e
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $41, $41, $41, $43, $43
; Tile mask 18
.byt $7c, $78, $78, $70, $70, $60, $60, $60
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $47, $47, $43, $41, $41, $41, $41, $41
; Tile mask 22
.byt $60, $60, $60, $70, $78, $78, $7c, $7c
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $41, $41, $41, $40, $40, $40, $40, $41
; Tile mask 26
.byt $7c, $7c, $7c, $7c, $78, $70, $70, $70
; Tile mask 27
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 28
.byt $40, $40, $40, $40, $50, $50, $50, $7c
; Tile mask 29
.byt $47, $47, $47, $47, $41, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $7e, $7c, $78, $70
; Tile mask 31
.byt $7c, $70, $60, $40, $40, $40, $40, $40
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $ff, $4f, $47, $43, $41, $41, $40, $40
; Tile mask 34
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 35
.byt $70, $70, $60, $60, $60, $40, $40, $40
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $5f, $4f, $4f, $4f, $4f, $4f, $5f, $5f
; Tile mask 40
.byt $40, $60, $70, $70, $78, $7c, $7e, $ff
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 44
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 45
.byt $ff, $ff, $7e, $7c, $78, $70, $70, $70
; Tile mask 46
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $41, $43, $41, $40, $40, $40, $40, $40
; Tile mask 49
.byt $ff, $ff, $ff, $ff, $5f, $5f, $5f, $ff
; Tile mask 50
.byt $70, $70, $70, $78, $78, $7c, $7c, $7e
; Tile mask 51
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 52
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 54
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 55
.byt $7e, $7e, $ff, $7e, $7c, $78, $78, $78
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 57
.byt $40, $40, $40, $50, $50, $50, $50, $7c
; Tile mask 58
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 59
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
res_end
.)

