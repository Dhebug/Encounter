.(
.byt RESOURCE_COSTUME|$80
.word (res_end - res_start + 4)
.byt 251
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (00-lookRight.png)
.byt 0, 1, 2, 3, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 16, 17, 0
.byt 18, 19, 20, 21, 0
.byt 22, 23, 24, 25, 0
.byt 26, 27, 28, 29, 0
; Animatory state 1 (01-lookRight.png)
.byt 0, 0, 0, 0, 0
.byt 30, 31, 32, 33, 34
.byt 35, 36, 37, 38, 39
.byt 40, 41, 42, 43, 44
.byt 45, 46, 47, 48, 0
.byt 49, 50, 51, 52, 0
.byt 53, 54, 55, 56, 0
; Animatory state 2 (02-lookRight.png)
.byt 0, 0, 0, 0, 0
.byt 57, 58, 59, 60, 0
.byt 61, 62, 63, 64, 0
.byt 65, 66, 67, 68, 0
.byt 69, 70, 71, 72, 0
.byt 73, 74, 75, 76, 0
.byt 77, 78, 79, 80, 0
; Animatory state 3 (03-lookRight.png)
.byt 0, 81, 82, 0, 0
.byt 83, 84, 85, 86, 34
.byt 87, 88, 89, 90, 91
.byt 92, 93, 94, 95, 0
.byt 96, 97, 98, 99, 0
.byt 100, 101, 102, 103, 104
.byt 105, 106, 107, 108, 34
; Animatory state 4 (04-lookRight.png)
.byt 0, 0, 0, 0, 0
.byt 109, 110, 111, 112, 0
.byt 113, 114, 115, 116, 117
.byt 118, 119, 120, 121, 0
.byt 122, 123, 124, 125, 0
.byt 22, 126, 127, 128, 0
.byt 129, 130, 131, 132, 0
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
.byt $0, $0, $1, $2, $4, $a, $5, $f
; Tile graphic 19
.byt $17, $9, $4, $23, $14, $7, $17, $b
; Tile graphic 20
.byt $3f, $3f, $1f, $0, $2e, $4, $33, $3b
; Tile graphic 21
.byt $30, $30, $8, $24, $10, $24, $20, $24
; Tile graphic 22
.byt $e, $e, $0, $1f, $1d, $1c, $1f, $0
; Tile graphic 23
.byt $13, $2b, $15, $9, $15, $0, $15, $0
; Tile graphic 24
.byt $3b, $3b, $3f, $3f, $31, $e, $11, $0
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
.byt $0, $1, $2, $5, $b, $15, $b, $15
; Tile graphic 31
.byt $0, $11, $3a, $15, $3c, $15, $2a, $14
; Tile graphic 32
.byt $0, $15, $2a, $1f, $2a, $17, $2, $11
; Tile graphic 33
.byt $0, $0, $28, $14, $2a, $35, $2a, $15
; Tile graphic 34
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 35
.byt $a, $14, $8, $14, $8, $14, $a, $14
; Tile graphic 36
.byt $28, $15, $0, $5, $f, $21, $1e, $31
; Tile graphic 37
.byt $38, $15, $3e, $3f, $3f, $38, $33, $30
; Tile graphic 38
.byt $a, $5, $22, $11, $22, $1, $2, $21
; Tile graphic 39
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 40
.byt $a, $14, $8, $10, $9, $11, $9, $10
; Tile graphic 41
.byt $2a, $3d, $3f, $3f, $3f, $3f, $3c, $3f
; Tile graphic 42
.byt $35, $3f, $3f, $3f, $f, $3f, $3, $3f
; Tile graphic 43
.byt $12, $30, $32, $30, $32, $30, $22, $20
; Tile graphic 44
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 45
.byt $28, $14, $2a, $b, $6, $7, $e, $e
; Tile graphic 46
.byt $1f, $f, $33, $1c, $23, $3c, $3f, $1d
; Tile graphic 47
.byt $f, $3e, $38, $6, $39, $7, $3f, $2e
; Tile graphic 48
.byt $2, $0, $8, $28, $30, $30, $10, $10
; Tile graphic 49
.byt $c, $1e, $1f, $0, $1e, $19, $1e, $0
; Tile graphic 50
.byt $b, $1f, $1f, $0, $2a, $0, $3f, $1f
; Tile graphic 51
.byt $34, $3e, $3e, $0, $2a, $0, $3e, $3f
; Tile graphic 52
.byt $18, $38, $3c, $0, $1c, $4, $1c, $0
; Tile graphic 53
.byt $0, $0, $1, $1, $7, $0, $f, $0
; Tile graphic 54
.byt $0, $3c, $38, $38, $3c, $1c, $38, $0
; Tile graphic 55
.byt $0, $1e, $f, $f, $1f, $1c, $f, $0
; Tile graphic 56
.byt $0, $0, $0, $0, $30, $0, $38, $0
; Tile graphic 57
.byt $0, $0, $0, $1, $3, $7, $7, $7
; Tile graphic 58
.byt $0, $7, $3f, $3f, $3f, $3f, $3f, $3e
; Tile graphic 59
.byt $0, $31, $3b, $3f, $3b, $37, $28, $16
; Tile graphic 60
.byt $0, $30, $38, $38, $3c, $3c, $3e, $1e
; Tile graphic 61
.byt $f, $f, $f, $a, $5, $a, $4, $a
; Tile graphic 62
.byt $3d, $3b, $17, $2f, $1f, $10, $3f, $38
; Tile graphic 63
.byt $3f, $3f, $3f, $3f, $3f, $3c, $1b, $3c
; Tile graphic 64
.byt $e, $2e, $26, $34, $32, $a, $3a, $1a
; Tile graphic 65
.byt $c, $8, $c, $8, $1c, $18, $1c, $18
; Tile graphic 66
.byt $35, $3f, $3f, $3f, $3f, $3f, $1f, $f
; Tile graphic 67
.byt $1a, $3f, $3f, $3f, $33, $3f, $5, $33
; Tile graphic 68
.byt $2a, $3a, $3a, $3a, $39, $3a, $31, $32
; Tile graphic 69
.byt $14, $28, $11, $1, $1, $5, $0, $5
; Tile graphic 70
.byt $17, $2b, $4, $3, $1, $0, $3f, $0
; Tile graphic 71
.byt $3f, $3f, $3c, $2, $3c, $38, $17, $20
; Tile graphic 72
.byt $25, $9, $6, $10, $28, $20, $28, $10
; Tile graphic 73
.byt $2, $4, $a, $0, $1e, $1c, $1e, $0
; Tile graphic 74
.byt $0, $0, $0, $0, $2a, $15, $0, $0
; Tile graphic 75
.byt $10, $0, $0, $0, $3a, $1d, $0, $0
; Tile graphic 76
.byt $8, $10, $8, $4, $2c, $4, $c, $0
; Tile graphic 77
.byt $0, $0, $0, $0, $0, $7, $0, $0
; Tile graphic 78
.byt $0, $2a, $0, $0, $0, $20, $0, $4
; Tile graphic 79
.byt $0, $a, $0, $0, $0, $0, $0, $4
; Tile graphic 80
.byt $0, $20, $0, $0, $0, $3c, $0, $0
; Tile graphic 81
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 82
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 83
.byt $0, $0, $1, $2, $5, $a, $4, $a
; Tile graphic 84
.byt $5, $2a, $14, $28, $1, $7, $f, $7
; Tile graphic 85
.byt $15, $2a, $0, $0, $3c, $3f, $3f, $3f
; Tile graphic 86
.byt $0, $20, $14, $a, $0, $22, $31, $38
; Tile graphic 87
.byt $4, $8, $14, $a, $4, $8, $3, $3
; Tile graphic 88
.byt $f, $17, $f, $2f, $1e, $d, $e, $2f
; Tile graphic 89
.byt $3f, $3f, $3f, $7, $3b, $3, $2b, $37
; Tile graphic 90
.byt $39, $3c, $3c, $22, $2c, $2, $14, $2e
; Tile graphic 91
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 92
.byt $3, $3, $3, $1, $0, $0, $0, $0
; Tile graphic 93
.byt $3f, $3f, $3f, $2f, $1f, $1f, $17, $17
; Tile graphic 94
.byt $3f, $3f, $3c, $3e, $3f, $30, $3f, $3c
; Tile graphic 95
.byt $3e, $3e, $1e, $3e, $3e, $c, $3c, $18
; Tile graphic 96
.byt $0, $1, $2, $1, $6, $7, $7, $7
; Tile graphic 97
.byt $9, $6, $29, $14, $22, $0, $20, $20
; Tile graphic 98
.byt $3f, $1c, $20, $1f, $7, $12, $a, $d
; Tile graphic 99
.byt $38, $20, $14, $22, $8, $2, $22, $2
; Tile graphic 100
.byt $7, $7, $0, $f, $e, $e, $f, $0
; Tile graphic 101
.byt $0, $0, $0, $20, $20, $f, $20, $a
; Tile graphic 102
.byt $7, $2, $2, $0, $0, $3a, $8, $20
; Tile graphic 103
.byt $2, $2, $0, $3, $3, $39, $3, $28
; Tile graphic 104
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 105
.byt $0, $0, $0, $0, $0, $1, $0, $0
; Tile graphic 106
.byt $15, $a, $0, $0, $0, $34, $0, $0
; Tile graphic 107
.byt $11, $2a, $0, $0, $0, $0, $0, $0
; Tile graphic 108
.byt $10, $28, $0, $0, $0, $b, $0, $0
; Tile graphic 109
.byt $0, $0, $0, $1, $2, $1, $2, $5
; Tile graphic 110
.byt $0, $0, $2, $11, $2a, $11, $22, $7
; Tile graphic 111
.byt $0, $0, $0, $15, $22, $1d, $2e, $3f
; Tile graphic 112
.byt $0, $0, $0, $0, $0, $10, $28, $3c
; Tile graphic 113
.byt $a, $4, $2, $5, $0, $5, $0, $0
; Tile graphic 114
.byt $2b, $7, $23, $7, $e, $1c, $f, $e
; Tile graphic 115
.byt $3f, $3f, $3f, $3f, $7, $3f, $3, $2b
; Tile graphic 116
.byt $3c, $3c, $3e, $3e, $30, $2c, $2, $14
; Tile graphic 117
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 118
.byt $0, $6, $3, $3, $1, $0, $0, $0
; Tile graphic 119
.byt $f, $f, $1f, $3f, $2f, $1f, $3f, $2f
; Tile graphic 120
.byt $37, $3f, $3f, $3f, $3e, $3f, $31, $3f
; Tile graphic 121
.byt $e, $3e, $3e, $3c, $1c, $3c, $c, $38
; Tile graphic 122
.byt $0, $3, $3, $7, $f, $f, $f, $f
; Tile graphic 123
.byt $17, $1, $28, $2a, $23, $10, $0, $18
; Tile graphic 124
.byt $3c, $3f, $e, $10, $5, $18, $d, $0
; Tile graphic 125
.byt $18, $30, $28, $14, $c, $24, $24, $4
; Tile graphic 126
.byt $3e, $3f, $3f, $1f, $1f, $0, $1f, $0
; Tile graphic 127
.byt $15, $28, $15, $20, $15, $0, $15, $0
; Tile graphic 128
.byt $14, $24, $10, $26, $16, $2, $36, $0
; Tile graphic 129
.byt $1, $1, $0, $1, $2, $7, $7, $0
; Tile graphic 130
.byt $3f, $3f, $0, $3e, $e, $3e, $3c, $0
; Tile graphic 131
.byt $3f, $1f, $0, $f, $f, $f, $7, $0
; Tile graphic 132
.byt $30, $30, $0, $38, $4, $3e, $3e, $0
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
.byt $60, $60, $60, $40, $40, $40, $40, $60
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
.byt $7e, $7c, $78, $70, $60, $40, $40, $40
; Tile mask 31
.byt $48, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $ff, $47, $43, $41, $40, $40, $40, $40
; Tile mask 34
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 45
.byt $40, $40, $40, $70, $70, $70, $60, $60
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $40, $41, $43, $47, $47, $47, $47, $47
; Tile mask 49
.byt $60, $40, $40, $40, $40, $40, $40, $60
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 52
.byt $43, $43, $41, $43, $41, $41, $41, $43
; Tile mask 53
.byt $7e, $7e, $7c, $78, $70, $60, $60, $60
; Tile mask 54
.byt $40, $41, $43, $43, $41, $41, $41, $47
; Tile mask 55
.byt $40, $40, $60, $60, $40, $40, $40, $70
; Tile mask 56
.byt $ff, $ff, $5f, $4f, $47, $43, $43, $43
; Tile mask 57
.byt $ff, $ff, $7e, $7c, $78, $70, $70, $70
; Tile mask 58
.byt $78, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $4e, $44, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $4f, $47, $43, $43, $41, $41, $40, $40
; Tile mask 61
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 62
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 64
.byt $40, $40, $40, $41, $40, $40, $40, $40
; Tile mask 65
.byt $60, $60, $60, $60, $40, $40, $40, $40
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 69
.byt $40, $40, $40, $78, $78, $70, $70, $70
; Tile mask 70
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $40, $40, $40, $41, $43, $43, $43, $43
; Tile mask 73
.byt $70, $60, $60, $60, $40, $40, $40, $60
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $43, $43, $43, $41, $41, $41, $41, $43
; Tile mask 77
.byt $7e, $7e, $7e, $7c, $78, $70, $60, $60
; Tile mask 78
.byt $40, $40, $41, $41, $40, $40, $40, $41
; Tile mask 79
.byt $40, $60, $70, $70, $60, $60, $60, $70
; Tile mask 80
.byt $4f, $4f, $4f, $47, $43, $41, $40, $40
; Tile mask 81
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $78
; Tile mask 82
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $40
; Tile mask 83
.byt $ff, $7c, $78, $78, $70, $60, $60, $60
; Tile mask 84
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 85
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 86
.byt $4f, $43, $41, $40, $40, $40, $40, $40
; Tile mask 87
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 89
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 90
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 91
.byt $5f, $5f, $5f, $5f, $5f, $ff, $ff, $ff
; Tile mask 92
.byt $70, $70, $78, $7c, $7c, $7e, $ff, $ff
; Tile mask 93
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 94
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 95
.byt $40, $40, $40, $40, $40, $41, $41, $43
; Tile mask 96
.byt $7e, $7c, $78, $78, $70, $70, $70, $70
; Tile mask 97
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 98
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 99
.byt $43, $43, $41, $40, $40, $40, $40, $40
; Tile mask 100
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 101
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 102
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 103
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 104
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 105
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $7c
; Tile mask 106
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 107
.byt $40, $40, $40, $40, $48, $48, $48, $7e
; Tile mask 108
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 109
.byt $ff, $ff, $7e, $7c, $78, $70, $70, $60
; Tile mask 110
.byt $ff, $60, $40, $40, $40, $40, $40, $40
; Tile mask 111
.byt $ff, $41, $40, $40, $40, $40, $40, $40
; Tile mask 112
.byt $ff, $ff, $5f, $47, $43, $41, $41, $40
; Tile mask 113
.byt $60, $60, $60, $60, $60, $60, $70, $70
; Tile mask 114
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 115
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 117
.byt $ff, $5f, $5f, $5f, $5f, $5f, $5f, $ff
; Tile mask 118
.byt $70, $70, $70, $78, $78, $78, $7c, $7e
; Tile mask 119
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 121
.byt $40, $40, $40, $41, $41, $41, $41, $43
; Tile mask 122
.byt $7c, $78, $78, $70, $60, $60, $60, $60
; Tile mask 123
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 124
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 125
.byt $43, $47, $43, $41, $41, $41, $41, $41
; Tile mask 126
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 127
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 128
.byt $41, $41, $41, $40, $40, $40, $40, $41
; Tile mask 129
.byt $7c, $7c, $7c, $7c, $78, $70, $70, $70
; Tile mask 130
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 131
.byt $40, $40, $40, $60, $60, $60, $60, $78
; Tile mask 132
.byt $47, $47, $47, $43, $41, $40, $40, $40
res_end
.)

