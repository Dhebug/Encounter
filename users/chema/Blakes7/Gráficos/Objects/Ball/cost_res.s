.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 15
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (0-ballleft.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 0, 16, 17, 18, 0
; Animatory state 1 (1-ballfront.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 19, 20, 21, 22, 5
.byt 23, 24, 25, 26, 10
.byt 27, 28, 29, 30, 31
.byt 0, 16, 17, 18, 0
; Animatory state 2 (2-ballright.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 19, 32, 33, 34, 35
.byt 23, 8, 9, 36, 37
.byt 38, 39, 40, 41, 31
.byt 0, 16, 17, 18, 0
; Animatory state 3 (3-ballback.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 19, 42, 43, 44, 5
.byt 23, 45, 46, 26, 10
.byt 27, 28, 29, 30, 31
.byt 0, 16, 17, 18, 0
; Animatory state 4 (4-hit1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 47, 48, 3, 4, 5
.byt 49, 50, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 0, 16, 17, 18, 0
; Animatory state 5 (5-hit2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 51, 52, 53, 54, 5
.byt 55, 56, 57, 58, 10
.byt 59, 60, 61, 62, 15
.byt 63, 16, 64, 18, 0
; Animatory state 6 (6-exp1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 65, 66, 67, 54, 5
.byt 68, 69, 70, 71, 10
.byt 72, 73, 74, 75, 15
.byt 63, 16, 64, 18, 0
; Animatory state 7 (7-exp2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 76, 77, 78, 79, 80
.byt 81, 82, 83, 84, 85
.byt 86, 87, 88, 89, 90
.byt 91, 92, 93, 94, 95
; Animatory state 8 (8-exp3.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 96, 97, 98, 99, 100
.byt 101, 102, 103, 104, 105
.byt 106, 107, 108, 109, 110
.byt 0, 0, 111, 112, 0
; Animatory state 9 (9-exp4.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 113, 0, 114, 0
.byt 115, 116, 0, 117, 0
.byt 118, 119, 120, 121, 0
.byt 0, 0, 0, 0, 0
; Animatory state 10 (a-projectile.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 122
.byt 0, 0, 0, 0, 123
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $1, $2, $5, $a, $a
; Tile graphic 2
.byt $1, $6, $38, $0, $30, $8, $24, $24
; Tile graphic 3
.byt $3f, $0, $0, $0, $0, $0, $21, $21
; Tile graphic 4
.byt $0, $30, $c, $2, $1, $0, $2, $2
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $20, $10, $10
; Tile graphic 6
.byt $a, $9, $10, $10, $f, $8, $f, $10
; Tile graphic 7
.byt $4, $8, $30, $0, $3f, $0, $3f, $0
; Tile graphic 8
.byt $21, $0, $0, $0, $3f, $0, $3f, $0
; Tile graphic 9
.byt $2, $0, $0, $0, $3f, $0, $3f, $0
; Tile graphic 10
.byt $8, $8, $4, $4, $38, $8, $38, $4
; Tile graphic 11
.byt $10, $8, $b, $4, $4, $2, $1, $0
; Tile graphic 12
.byt $0, $0, $1b, $0, $0, $30, $8, $24
; Tile graphic 13
.byt $0, $0, $1b, $0, $0, $0, $0, $0
; Tile graphic 14
.byt $0, $0, $1b, $0, $0, $6, $9, $12
; Tile graphic 15
.byt $4, $8, $8, $10, $10, $20, $0, $0
; Tile graphic 16
.byt $18, $6, $1, $0, $0, $0, $0, $0
; Tile graphic 17
.byt $0, $0, $3f, $0, $0, $0, $0, $0
; Tile graphic 18
.byt $c, $30, $0, $0, $0, $0, $0, $0
; Tile graphic 19
.byt $0, $0, $0, $0, $1, $2, $4, $4
; Tile graphic 20
.byt $1, $6, $18, $21, $1, $2, $12, $12
; Tile graphic 21
.byt $3f, $0, $1c, $23, $9, $4, $4, $0
; Tile graphic 22
.byt $0, $30, $c, $2, $1, $20, $24, $24
; Tile graphic 23
.byt $8, $8, $10, $10, $f, $8, $f, $10
; Tile graphic 24
.byt $11, $1, $0, $0, $3f, $0, $3f, $0
; Tile graphic 25
.byt $1, $23, $1c, $0, $3f, $0, $3f, $0
; Tile graphic 26
.byt $4, $0, $0, $0, $3f, $0, $3f, $0
; Tile graphic 27
.byt $10, $8, $a, $4, $4, $2, $1, $0
; Tile graphic 28
.byt $0, $0, $36, $0, $0, $1, $2, $24
; Tile graphic 29
.byt $0, $0, $36, $0, $0, $3f, $0, $0
; Tile graphic 30
.byt $0, $0, $36, $0, $0, $0, $21, $12
; Tile graphic 31
.byt $4, $8, $28, $10, $10, $20, $0, $0
; Tile graphic 32
.byt $1, $6, $18, $20, $0, $0, $21, $21
; Tile graphic 33
.byt $3f, $0, $0, $0, $0, $0, $2, $2
; Tile graphic 34
.byt $0, $30, $e, $1, $6, $9, $12, $12
; Tile graphic 35
.byt $0, $0, $0, $0, $20, $10, $28, $28
; Tile graphic 36
.byt $10, $9, $6, $0, $3f, $0, $3f, $0
; Tile graphic 37
.byt $28, $8, $4, $4, $38, $8, $38, $4
; Tile graphic 38
.byt $10, $8, $9, $4, $4, $2, $1, $0
; Tile graphic 39
.byt $0, $0, $2d, $0, $0, $30, $8, $24
; Tile graphic 40
.byt $0, $0, $2d, $0, $0, $0, $0, $0
; Tile graphic 41
.byt $0, $0, $2d, $0, $0, $6, $9, $12
; Tile graphic 42
.byt $1, $6, $18, $20, $0, $0, $10, $10
; Tile graphic 43
.byt $3f, $0, $8, $1c, $8, $0, $8, $8
; Tile graphic 44
.byt $0, $30, $c, $2, $1, $0, $4, $4
; Tile graphic 45
.byt $10, $0, $0, $0, $3f, $0, $3f, $0
; Tile graphic 46
.byt $8, $0, $0, $0, $3f, $0, $3f, $0
; Tile graphic 47
.byt $0, $0, $0, $1, $2, $5, $e, $18
; Tile graphic 48
.byt $21, $36, $38, $30, $28, $8, $6, $1
; Tile graphic 49
.byt $e, $9, $11, $10, $f, $8, $f, $10
; Tile graphic 50
.byt $6, $8, $10, $30, $3f, $30, $3f, $0
; Tile graphic 51
.byt $1, $d, $13, $9, $6, $4, $6, $8
; Tile graphic 52
.byt $11, $16, $18, $10, $9, $2b, $1e, $1
; Tile graphic 53
.byt $3f, $2, $4, $f, $3c, $4, $26, $22
; Tile graphic 54
.byt $22, $c, $c, $3a, $1, $0, $2, $2
; Tile graphic 55
.byt $e, $9, $11, $11, $f, $9, $f, $13
; Tile graphic 56
.byt $36, $28, $16, $33, $3f, $1, $3f, $1
; Tile graphic 57
.byt $23, $0, $0, $0, $3f, $0, $3f, $38
; Tile graphic 58
.byt $22, $0, $0, $0, $3f, $0, $3f, $0
; Tile graphic 59
.byt $1e, $20, $2b, $2c, $c, $12, $2b, $a
; Tile graphic 60
.byt $1, $1, $1b, $e, $8, $30, $9, $26
; Tile graphic 61
.byt $7, $0, $3b, $8, $f, $8, $38, $c
; Tile graphic 62
.byt $30, $0, $1b, $0, $30, $1e, $9, $12
; Tile graphic 63
.byt $a, $4, $0, $0, $0, $0, $0, $0
; Tile graphic 64
.byt $4, $4, $37, $14, $14, $8, $0, $0
; Tile graphic 65
.byt $1, $d, $16, $8, $8, $10, $10, $10
; Tile graphic 66
.byt $11, $3e, $6, $1, $1, $0, $0, $0
; Tile graphic 67
.byt $3f, $2, $4, $f, $3c, $24, $26, $22
; Tile graphic 68
.byt $10, $8, $18, $17, $c, $8, $10, $20
; Tile graphic 69
.byt $0, $1, $1, $3f, $7, $3, $1, $0
; Tile graphic 70
.byt $27, $8, $10, $20, $20, $20, $20, $20
; Tile graphic 71
.byt $32, $8, $4, $2, $3, $2, $3, $2
; Tile graphic 72
.byt $20, $20, $20, $20, $10, $18, $2c, $b
; Tile graphic 73
.byt $0, $0, $0, $0, $1, $2, $5, $3e
; Tile graphic 74
.byt $30, $28, $3f, $28, $f, $8, $38, $c
; Tile graphic 75
.byt $4, $8, $3b, $0, $30, $1e, $9, $12
; Tile graphic 76
.byt $1, $d, $16, $8, $10, $10, $20, $20
; Tile graphic 77
.byt $1f, $20, $0, $0, $0, $1, $1, $1
; Tile graphic 78
.byt $3f, $1a, $6, $1f, $21, $0, $0, $0
; Tile graphic 79
.byt $23, $c, $c, $3f, $0, $20, $20, $20
; Tile graphic 80
.byt $30, $8, $8, $30, $20, $10, $8, $4
; Tile graphic 81
.byt $20, $20, $27, $18, $10, $20, $20, $20
; Tile graphic 82
.byt $1, $0, $0, $30, $10, $8, $8, $8
; Tile graphic 83
.byt $0, $21, $1e, $10, $10, $11, $6, $18
; Tile graphic 84
.byt $20, $0, $0, $0, $0, $3e, $1, $0
; Tile graphic 85
.byt $4, $2, $2, $2, $2, $2, $24, $14
; Tile graphic 86
.byt $20, $30, $28, $2f, $c, $18, $28, $8
; Tile graphic 87
.byt $f, $10, $30, $1, $1, $1, $1, $1
; Tile graphic 88
.byt $30, $20, $20, $0, $0, $0, $0, $0
; Tile graphic 89
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 90
.byt $c, $4, $4, $2, $2, $2, $2, $2
; Tile graphic 91
.byt $8, $8, $0, $4, $2, $1, $0, $0
; Tile graphic 92
.byt $0, $0, $0, $0, $0, $0, $30, $f
; Tile graphic 93
.byt $20, $20, $10, $8, $7, $4, $18, $20
; Tile graphic 94
.byt $0, $0, $0, $0, $1, $3e, $0, $0
; Tile graphic 95
.byt $4, $4, $8, $10, $20, $0, $0, $0
; Tile graphic 96
.byt $0, $0, $0, $1, $1, $2, $2, $e
; Tile graphic 97
.byt $0, $0, $1c, $23, $1, $0, $0, $0
; Tile graphic 98
.byt $7, $8, $10, $10, $8, $27, $22, $24
; Tile graphic 99
.byt $0, $20, $10, $1e, $21, $0, $0, $0
; Tile graphic 100
.byt $0, $0, $0, $0, $20, $10, $10, $8
; Tile graphic 101
.byt $11, $20, $20, $20, $11, $e, $1, $6
; Tile graphic 102
.byt $1, $23, $3c, $20, $0, $0, $30, $c
; Tile graphic 103
.byt $4, $4, $4, $2, $2, $1, $0, $1
; Tile graphic 104
.byt $0, $0, $0, $0, $0, $21, $1e, $38
; Tile graphic 105
.byt $8, $8, $8, $10, $10, $20, $0, $0
; Tile graphic 106
.byt $4, $8, $8, $8, $4, $6, $1, $0
; Tile graphic 107
.byt $4, $2, $2, $2, $4, $c, $30, $0
; Tile graphic 108
.byt $6, $8, $8, $10, $10, $10, $10, $8
; Tile graphic 109
.byt $6, $1, $1, $0, $0, $0, $0, $1
; Tile graphic 110
.byt $0, $0, $0, $20, $20, $20, $20, $0
; Tile graphic 111
.byt $8, $6, $1, $0, $0, $0, $0, $0
; Tile graphic 112
.byt $1, $6, $38, $0, $0, $0, $0, $0
; Tile graphic 113
.byt $0, $0, $0, $0, $c, $12, $21, $21
; Tile graphic 114
.byt $0, $0, $0, $0, $0, $0, $0, $c
; Tile graphic 115
.byt $0, $0, $0, $1c, $22, $22, $1c, $0
; Tile graphic 116
.byt $32, $c, $0, $0, $0, $0, $0, $0
; Tile graphic 117
.byt $12, $12, $c, $0, $0, $0, $0, $0
; Tile graphic 118
.byt $0, $0, $3, $4, $4, $3, $0, $0
; Tile graphic 119
.byt $0, $0, $0, $20, $20, $0, $0, $0
; Tile graphic 120
.byt $0, $0, $0, $0, $1, $1, $1, $0
; Tile graphic 121
.byt $0, $0, $0, $30, $8, $8, $8, $30
; Tile graphic 122
.byt $1, $1, $0, $c, $12, $21, $21, $12
; Tile graphic 123
.byt $c, $0, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $7e, $7c, $78, $70, $70
; Tile mask 2
.byt $7e, $78, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $4f, $43, $41, $40, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $ff, $5f, $4f, $4f
; Tile mask 6
.byt $70, $70, $60, $60, $70, $70, $70, $60
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $47, $47, $43, $43, $47, $47, $47, $43
; Tile mask 11
.byt $60, $70, $70, $78, $78, $7c, $7e, $ff
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 15
.byt $43, $47, $47, $4f, $4f, $5f, $ff, $ff
; Tile mask 16
.byt $60, $78, $7e, $ff, $ff, $ff, $ff, $ff
; Tile mask 17
.byt $40, $40, $40, $ff, $ff, $ff, $ff, $ff
; Tile mask 18
.byt $43, $4f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 19
.byt $ff, $ff, $ff, $ff, $7e, $7c, $78, $78
; Tile mask 20
.byt $7e, $78, $60, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $ff, $4f, $43, $41, $40, $40, $40, $40
; Tile mask 23
.byt $70, $70, $60, $60, $70, $70, $70, $60
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 26
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 27
.byt $60, $70, $70, $78, $78, $7c, $7e, $ff
; Tile mask 28
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 31
.byt $43, $47, $47, $4f, $4f, $5f, $ff, $ff
; Tile mask 32
.byt $7e, $78, $60, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $ff, $4f, $41, $40, $40, $40, $40, $40
; Tile mask 35
.byt $ff, $ff, $ff, $ff, $5f, $4f, $47, $47
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $47, $47, $43, $43, $47, $47, $47, $43
; Tile mask 38
.byt $60, $70, $70, $78, $78, $7c, $7e, $ff
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 42
.byt $7e, $78, $60, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $ff, $4f, $43, $41, $40, $40, $40, $40
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $ff, $ff, $ff, $7e, $7c, $78, $70, $60
; Tile mask 48
.byt $5e, $48, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $70, $70, $60, $60, $70, $70, $70, $60
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $7e, $72, $60, $70, $78, $78, $78, $70
; Tile mask 52
.byt $4e, $48, $40, $40, $40, $40, $40, $40
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 54
.byt $41, $43, $43, $41, $40, $40, $40, $40
; Tile mask 55
.byt $70, $70, $60, $60, $70, $70, $70, $60
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $60, $40, $40, $40, $40, $40, $50, $71
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 62
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 63
.byt $71, $7b, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 64
.byt $40, $40, $40, $63, $63, $77, $ff, $ff
; Tile mask 65
.byt $7e, $72, $60, $70, $70, $60, $60, $60
; Tile mask 66
.byt $4e, $40, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $60, $70, $60, $60, $70, $70, $60, $40
; Tile mask 69
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 70
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $40, $40, $40, $40, $40, $40, $50, $70
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 76
.byt $7e, $72, $60, $70, $60, $60, $40, $40
; Tile mask 77
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $4f, $47, $47, $4f, $5f, $4f, $47, $43
; Tile mask 81
.byt $40, $40, $40, $60, $60, $40, $40, $40
; Tile mask 82
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 84
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 85
.byt $43, $41, $41, $41, $41, $41, $43, $43
; Tile mask 86
.byt $40, $40, $40, $40, $40, $40, $50, $70
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 89
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 90
.byt $43, $43, $43, $41, $41, $41, $41, $41
; Tile mask 91
.byt $70, $70, $78, $78, $7c, $7e, $ff, $ff
; Tile mask 92
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 93
.byt $40, $40, $40, $40, $40, $43, $47, $5f
; Tile mask 94
.byt $40, $40, $40, $40, $40, $41, $ff, $ff
; Tile mask 95
.byt $43, $43, $47, $4f, $5f, $ff, $ff, $ff
; Tile mask 96
.byt $ff, $ff, $ff, $7e, $7e, $7c, $7c, $70
; Tile mask 97
.byt $ff, $ff, $63, $40, $40, $40, $40, $40
; Tile mask 98
.byt $78, $70, $60, $60, $70, $58, $5c, $58
; Tile mask 99
.byt $ff, $5f, $4f, $41, $40, $40, $40, $40
; Tile mask 100
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $47
; Tile mask 101
.byt $60, $40, $40, $40, $60, $71, $7e, $78
; Tile mask 102
.byt $40, $40, $43, $5f, $ff, $ff, $4f, $43
; Tile mask 103
.byt $78, $78, $78, $7c, $7c, $7e, $ff, $7e
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $61, $47
; Tile mask 105
.byt $47, $47, $47, $4f, $4f, $5f, $ff, $ff
; Tile mask 106
.byt $78, $70, $70, $70, $78, $78, $7e, $ff
; Tile mask 107
.byt $43, $41, $41, $41, $43, $43, $4f, $ff
; Tile mask 108
.byt $78, $70, $70, $60, $60, $60, $60, $70
; Tile mask 109
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 110
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 111
.byt $70, $78, $7e, $ff, $ff, $ff, $ff, $ff
; Tile mask 112
.byt $40, $41, $47, $ff, $ff, $ff, $ff, $ff
; Tile mask 113
.byt $ff, $ff, $ff, $ff, $73, $61, $40, $40
; Tile mask 114
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $73
; Tile mask 115
.byt $ff, $ff, $ff, $63, $41, $41, $63, $ff
; Tile mask 116
.byt $41, $73, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 117
.byt $61, $61, $73, $ff, $ff, $ff, $ff, $ff
; Tile mask 118
.byt $ff, $ff, $7c, $78, $78, $7c, $ff, $ff
; Tile mask 119
.byt $ff, $ff, $ff, $5f, $5f, $ff, $ff, $ff
; Tile mask 120
.byt $ff, $ff, $ff, $ff, $7e, $7e, $7e, $ff
; Tile mask 121
.byt $ff, $ff, $ff, $4f, $47, $47, $47, $4f
; Tile mask 122
.byt $7e, $7e, $ff, $73, $61, $40, $40, $61
; Tile mask 123
.byt $73, $ff, $ff, $ff, $ff, $ff, $ff, $ff
res_end
.)

