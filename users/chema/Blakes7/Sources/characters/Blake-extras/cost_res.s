.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 14
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (20-hands.png)
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 16, 17, 0
.byt 18, 19, 20, 21, 22
.byt 23, 24, 25, 26, 27
.byt 28, 29, 30, 31, 0
; Animatory state 1 (21-fire1.png)
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 16, 17, 0
.byt 18, 32, 33, 21, 22
.byt 23, 24, 25, 26, 27
.byt 28, 29, 30, 31, 0
; Animatory state 2 (22-fire2.png)
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 34, 17, 0
.byt 18, 35, 36, 21, 22
.byt 23, 24, 25, 26, 27
.byt 28, 29, 30, 31, 0
; Animatory state 3 (23-fire4.png)
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 37, 38, 17, 0
.byt 18, 39, 40, 21, 22
.byt 23, 24, 25, 26, 27
.byt 28, 29, 30, 31, 0
; Animatory state 4 (24-fire3.png)
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 37, 38, 17, 0
.byt 18, 41, 42, 21, 22
.byt 23, 24, 25, 26, 27
.byt 28, 29, 30, 31, 0
; Animatory state 5 (30-lookRight.png)
.byt 0, 43, 44, 45, 0
.byt 46, 47, 48, 49, 50
.byt 51, 52, 53, 54, 55
.byt 56, 57, 58, 59, 0
.byt 60, 61, 62, 63, 64
.byt 65, 66, 67, 68, 69
.byt 70, 29, 71, 72, 0
; Animatory state 6 (31-lookRight.png)
.byt 0, 43, 44, 45, 0
.byt 46, 47, 48, 49, 50
.byt 73, 74, 75, 76, 77
.byt 78, 79, 80, 81, 82
.byt 83, 84, 85, 86, 87
.byt 88, 89, 90, 91, 0
.byt 70, 29, 71, 72, 0
; Animatory state 7 (32-lookRight.png)
.byt 0, 43, 44, 45, 0
.byt 46, 47, 48, 49, 50
.byt 92, 93, 53, 54, 94
.byt 95, 96, 97, 81, 82
.byt 83, 84, 85, 86, 87
.byt 88, 89, 90, 91, 0
.byt 70, 29, 71, 72, 0
; Animatory state 8 (40-Teleport1.png)
.byt 1, 98, 99, 100, 0
.byt 101, 102, 102, 103, 104
.byt 105, 102, 102, 102, 106
.byt 107, 102, 102, 108, 109
.byt 110, 102, 102, 111, 0
.byt 105, 102, 102, 112, 22
.byt 113, 114, 115, 116, 117
; Animatory state 9 (41-Teleport2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 118, 0, 0
.byt 0, 119, 120, 121, 0
.byt 0, 122, 123, 124, 0
.byt 0, 125, 126, 127, 0
.byt 0, 128, 129, 130, 0
.byt 0, 0, 0, 0, 0
; Animatory state 10 (42-Teleport3.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 131, 0, 0
.byt 0, 132, 133, 134, 0
.byt 0, 0, 135, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 11 (43-Teleport4.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 136, 0, 0
.byt 0, 137, 138, 0, 0
.byt 0, 0, 139, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $1, $a
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $10, $8
; Tile graphic 4
.byt $0, $0, $0, $2, $4, $2, $14, $1
; Tile graphic 5
.byt $14, $a, $15, $2a, $1, $2a, $0, $0
; Tile graphic 6
.byt $15, $2a, $14, $2a, $0, $2a, $0, $0
; Tile graphic 7
.byt $10, $28, $10, $20, $0, $2a, $1, $2a
; Tile graphic 8
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 9
.byt $12, $0, $4, $8, $12, $8, $0, $0
; Tile graphic 10
.byt $6, $f, $1f, $30, $27, $38, $35, $3e
; Tile graphic 11
.byt $1, $3f, $3f, $3c, $1b, $38, $1a, $3d
; Tile graphic 12
.byt $32, $38, $31, $18, $2a, $18, $28, $38
; Tile graphic 13
.byt $0, $20, $0, $20, $0, $0, $0, $0
; Tile graphic 14
.byt $0, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 15
.byt $3f, $3f, $3f, $3f, $3f, $1e, $1f, $2f
; Tile graphic 16
.byt $3f, $3f, $1b, $27, $3f, $5, $3f, $3
; Tile graphic 17
.byt $3c, $38, $38, $38, $38, $30, $30, $28
; Tile graphic 18
.byt $0, $0, $0, $2, $4, $2, $5, $3
; Tile graphic 19
.byt $7, $23, $11, $c, $12, $1c, $1f, $28
; Tile graphic 20
.byt $3f, $3f, $3c, $1, $3a, $11, $7, $10
; Tile graphic 21
.byt $20, $8, $10, $22, $11, $32, $35, $2e
; Tile graphic 22
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 23
.byt $5, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 24
.byt $36, $37, $37, $17, $0, $0, $15, $0
; Tile graphic 25
.byt $2b, $2f, $2f, $2f, $10, $38, $5, $0
; Tile graphic 26
.byt $1d, $1e, $1c, $10, $0, $0, $10, $0
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 28
.byt $0, $0, $0, $0, $1, $0, $3, $0
; Tile graphic 29
.byt $3f, $3f, $3f, $0, $3f, $f, $3e, $0
; Tile graphic 30
.byt $3f, $27, $2f, $0, $7, $7, $3, $0
; Tile graphic 31
.byt $38, $38, $38, $0, $3c, $0, $3e, $0
; Tile graphic 32
.byt $7, $23, $13, $f, $12, $1d, $1f, $28
; Tile graphic 33
.byt $3f, $3f, $1a, $2b, $2a, $17, $2f, $10
; Tile graphic 34
.byt $3f, $3f, $1b, $27, $3f, $5, $2f, $13
; Tile graphic 35
.byt $7, $22, $12, $e, $12, $1d, $1f, $28
; Tile graphic 36
.byt $17, $3b, $3a, $2b, $2a, $17, $2f, $10
; Tile graphic 37
.byt $3f, $3f, $3f, $3f, $3f, $1e, $1f, $2e
; Tile graphic 38
.byt $3f, $3f, $1b, $27, $3f, $5, $3f, $13
; Tile graphic 39
.byt $7, $27, $17, $e, $12, $1f, $1f, $28
; Tile graphic 40
.byt $2b, $1d, $14, $2b, $2a, $15, $2f, $10
; Tile graphic 41
.byt $6, $25, $15, $e, $12, $1d, $1f, $28
; Tile graphic 42
.byt $2f, $37, $16, $2b, $2a, $17, $2f, $10
; Tile graphic 43
.byt $0, $0, $0, $0, $0, $0, $0, $2
; Tile graphic 44
.byt $0, $0, $0, $0, $0, $0, $14, $22
; Tile graphic 45
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 46
.byt $0, $0, $0, $2, $5, $2, $4, $2
; Tile graphic 47
.byt $5, $22, $15, $a, $10, $2a, $0, $20
; Tile graphic 48
.byt $5, $2a, $15, $2a, $10, $2a, $0, $0
; Tile graphic 49
.byt $10, $28, $4, $28, $0, $2a, $1, $a
; Tile graphic 50
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 51
.byt $0, $8, $4, $a, $11, $a, $0, $3
; Tile graphic 52
.byt $1, $3, $7, $c, $9, $e, $d, $f
; Tile graphic 53
.byt $20, $3f, $3f, $7, $3e, $e, $16, $2f
; Tile graphic 54
.byt $1d, $3c, $3d, $2, $3c, $4, $28, $1c
; Tile graphic 55
.byt $0, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 56
.byt $3, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 57
.byt $1f, $3f, $1f, $3f, $3f, $3f, $1f, $2f
; Tile graphic 58
.byt $3f, $3f, $36, $3d, $3f, $21, $3f, $30
; Tile graphic 59
.byt $3c, $3c, $3c, $3c, $3c, $1c, $38, $38
; Tile graphic 60
.byt $0, $0, $1, $2, $1, $2, $1, $2
; Tile graphic 61
.byt $17, $9, $4, $23, $5, $21, $4, $31
; Tile graphic 62
.byt $3f, $3f, $1f, $0, $a, $30, $3, $3b
; Tile graphic 63
.byt $30, $30, $8, $24, $10, $24, $20, $24
; Tile graphic 64
.byt $0, $20, $24, $24, $24, $24, $24, $3c
; Tile graphic 65
.byt $1, $3, $1, $2, $1, $0, $1, $0
; Tile graphic 66
.byt $3d, $3d, $3d, $0, $15, $0, $15, $0
; Tile graphic 67
.byt $31, $3d, $3d, $1, $31, $e, $11, $0
; Tile graphic 68
.byt $25, $12, $6, $11, $0, $0, $30, $0
; Tile graphic 69
.byt $10, $30, $30, $0, $0, $0, $0, $0
; Tile graphic 70
.byt $1, $1, $1, $0, $1, $0, $7, $0
; Tile graphic 71
.byt $3f, $2f, $2f, $0, $7, $7, $3, $0
; Tile graphic 72
.byt $30, $30, $30, $0, $38, $20, $3e, $0
; Tile graphic 73
.byt $0, $8, $4, $a, $11, $a, $0, $2
; Tile graphic 74
.byt $1, $3, $7, $c, $9, $e, $8, $7
; Tile graphic 75
.byt $20, $3f, $3f, $7, $3e, $e, $16, $0
; Tile graphic 76
.byt $1d, $3c, $3d, $2, $3c, $4, $28, $0
; Tile graphic 77
.byt $0, $20, $0, $2, $2, $2, $2, $0
; Tile graphic 78
.byt $0, $1, $15, $b, $17, $f, $1f, $e
; Tile graphic 79
.byt $1e, $2f, $37, $30, $37, $2f, $1f, $f
; Tile graphic 80
.byt $f, $2f, $26, $1d, $3f, $31, $3f, $30
; Tile graphic 81
.byt $3c, $3c, $3c, $3c, $3c, $1c, $38, $38
; Tile graphic 82
.byt $2, $2, $2, $0, $6, $e, $e, $2e
; Tile graphic 83
.byt $0, $0, $1, $2, $1, $1, $0, $1
; Tile graphic 84
.byt $17, $9, $4, $23, $4, $17, $27, $b
; Tile graphic 85
.byt $3f, $3f, $1f, $0, $2e, $4, $33, $3b
; Tile graphic 86
.byt $31, $33, $b, $25, $12, $20, $20, $20
; Tile graphic 87
.byt $26, $30, $30, $20, $0, $0, $0, $0
; Tile graphic 88
.byt $0, $1, $0, $1, $0, $1, $0, $0
; Tile graphic 89
.byt $2b, $13, $25, $11, $5, $10, $5, $0
; Tile graphic 90
.byt $3b, $3b, $3f, $3f, $31, $e, $11, $0
; Tile graphic 91
.byt $20, $10, $0, $10, $0, $0, $30, $0
; Tile graphic 92
.byt $0, $8, $4, $a, $11, $a, $0, $0
; Tile graphic 93
.byt $1, $3, $7, $c, $9, $e, $5, $3b
; Tile graphic 94
.byt $0, $20, $0, $2, $2, $2, $2, $0
; Tile graphic 95
.byt $3, $5, $16, $e, $17, $f, $1f, $e
; Tile graphic 96
.byt $31, $3d, $3d, $3, $37, $2f, $1f, $f
; Tile graphic 97
.byt $3f, $3f, $36, $3d, $3f, $31, $3f, $30
; Tile graphic 98
.byt $0, $0, $0, $0, $0, $0, $f, $30
; Tile graphic 99
.byt $0, $0, $0, $0, $0, $0, $3c, $3
; Tile graphic 100
.byt $0, $0, $0, $0, $0, $0, $0, $30
; Tile graphic 101
.byt $1, $2, $4, $8, $8, $10, $10, $10
; Tile graphic 102
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 103
.byt $c, $2, $1, $1, $0, $0, $0, $0
; Tile graphic 104
.byt $0, $0, $0, $0, $20, $20, $20, $10
; Tile graphic 105
.byt $10, $10, $10, $10, $10, $10, $10, $10
; Tile graphic 106
.byt $10, $10, $10, $20, $20, $20, $20, $20
; Tile graphic 107
.byt $10, $10, $10, $8, $8, $4, $2, $2
; Tile graphic 108
.byt $0, $1, $1, $1, $2, $2, $4, $4
; Tile graphic 109
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 110
.byt $2, $2, $4, $8, $8, $10, $10, $10
; Tile graphic 111
.byt $4, $4, $4, $4, $2, $2, $2, $2
; Tile graphic 112
.byt $2, $2, $2, $1, $1, $1, $1, $1
; Tile graphic 113
.byt $8, $4, $4, $4, $4, $8, $f, $0
; Tile graphic 114
.byt $0, $0, $0, $1, $1, $1, $3f, $0
; Tile graphic 115
.byt $0, $0, $38, $4, $4, $4, $7, $0
; Tile graphic 116
.byt $2, $4, $4, $4, $2, $1, $3f, $0
; Tile graphic 117
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 118
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 119
.byt $0, $3, $2, $4, $4, $4, $4, $4
; Tile graphic 120
.byt $3e, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 121
.byt $0, $0, $20, $10, $10, $10, $10, $10
; Tile graphic 122
.byt $4, $4, $4, $2, $2, $2, $2, $4
; Tile graphic 123
.byt $0, $0, $0, $1, $1, $1, $0, $0
; Tile graphic 124
.byt $10, $30, $20, $0, $0, $0, $20, $20
; Tile graphic 125
.byt $4, $4, $4, $4, $2, $2, $4, $7
; Tile graphic 126
.byt $0, $0, $0, $0, $1, $1, $18, $37
; Tile graphic 127
.byt $20, $20, $20, $20, $0, $20, $20, $20
; Tile graphic 128
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 129
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 130
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 131
.byt $0, $0, $0, $0, $8, $8, $8, $8
; Tile graphic 132
.byt $0, $0, $1, $6, $1, $0, $0, $0
; Tile graphic 133
.byt $8, $14, $23, $0, $23, $14, $8, $8
; Tile graphic 134
.byt $0, $0, $0, $30, $0, $0, $0, $0
; Tile graphic 135
.byt $8, $8, $8, $0, $0, $0, $0, $0
; Tile graphic 136
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 137
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 138
.byt $8, $8, $1c, $3e, $1c, $8, $8, $0
; Tile graphic 139
.byt $0, $0, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 2
.byt $ff, $ff, $ff, $ff, $ff, $ff, $60, $40
; Tile mask 3
.byt $ff, $ff, $ff, $ff, $ff, $ff, $43, $40
; Tile mask 4
.byt $7e, $7c, $78, $78, $70, $60, $60, $60
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $47, $47, $43, $41, $41, $40, $40, $40
; Tile mask 8
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f
; Tile mask 9
.byt $60, $60, $60, $60, $60, $70, $70, $78
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 13
.byt $5f, $5f, $5f, $5f, $5f, $ff, $ff, $ff
; Tile mask 14
.byt $7c, $7c, $7c, $7e, $7e, $ff, $7e, $7e
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $41, $41, $43, $43, $43, $47, $43, $43
; Tile mask 18
.byt $7c, $78, $78, $70, $70, $70, $70, $70
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $5f
; Tile mask 23
.byt $70, $78, $7c, $7e, $7e, $7e, $7e, $7e
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 26
.byt $40, $40, $41, $43, $43, $43, $43, $43
; Tile mask 27
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 28
.byt $7e, $7e, $7e, $7e, $7c, $78, $78, $78
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 30
.byt $40, $40, $40, $50, $50, $50, $50, $7c
; Tile mask 31
.byt $43, $43, $43, $43, $41, $40, $40, $40
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $ff, $ff, $ff, $ff, $ff, $ff, $78, $60
; Tile mask 44
.byt $ff, $ff, $ff, $ff, $ff, $ff, $40, $40
; Tile mask 45
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $4f
; Tile mask 46
.byt $ff, $7c, $78, $78, $70, $70, $70, $70
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $47, $43, $41, $41, $40, $40, $40, $40
; Tile mask 50
.byt $ff, $ff, $ff, $ff, $ff, $5f, $4f, $4f
; Tile mask 51
.byt $70, $60, $60, $40, $40, $40, $60, $60
; Tile mask 52
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 55
.byt $4f, $4f, $5f, $5f, $5f, $5f, $ff, $ff
; Tile mask 56
.byt $60, $60, $60, $70, $70, $7c, $7e, $7e
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $40, $40, $40, $41, $41, $41, $43, $43
; Tile mask 60
.byt $7c, $78, $78, $78, $78, $78, $78, $78
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 62
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $47, $46, $42, $40, $40, $40, $40, $40
; Tile mask 64
.byt $5f, $4b, $41, $41, $41, $41, $41, $41
; Tile mask 65
.byt $78, $78, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 66
.byt $40, $40, $40, $42, $40, $40, $40, $40
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $40, $40, $40, $40, $47, $47, $47, $47
; Tile mask 69
.byt $43, $47, $47, $4f, $ff, $ff, $ff, $ff
; Tile mask 70
.byt $7c, $7c, $7c, $7c, $78, $70, $70, $70
; Tile mask 71
.byt $40, $40, $40, $40, $50, $50, $50, $7c
; Tile mask 72
.byt $47, $47, $47, $47, $41, $40, $40, $40
; Tile mask 73
.byt $70, $60, $60, $40, $40, $40, $60, $60
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 77
.byt $4f, $4f, $5d, $58, $58, $58, $78, $40
; Tile mask 78
.byt $60, $60, $40, $40, $40, $40, $40, $60
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 81
.byt $40, $40, $40, $41, $41, $41, $43, $42
; Tile mask 82
.byt $78, $78, $78, $70, $60, $60, $40, $40
; Tile mask 83
.byt $70, $78, $78, $78, $7c, $7c, $7c, $7c
; Tile mask 84
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 85
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 86
.byt $44, $40, $40, $40, $40, $40, $47, $47
; Tile mask 87
.byt $40, $41, $47, $4f, $5f, $ff, $ff, $ff
; Tile mask 88
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 89
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 90
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 91
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 92
.byt $70, $60, $60, $40, $40, $40, $60, $60
; Tile mask 93
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 94
.byt $4f, $4f, $5d, $58, $58, $58, $78, $78
; Tile mask 95
.byt $60, $60, $40, $40, $40, $40, $40, $60
; Tile mask 96
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 97
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 98
.byt $ff, $ff, $ff, $ff, $ff, $70, $40, $40
; Tile mask 99
.byt $ff, $ff, $ff, $ff, $ff, $43, $40, $40
; Tile mask 100
.byt $ff, $ff, $ff, $ff, $ff, $ff, $47, $43
; Tile mask 101
.byt $7c, $78, $70, $60, $60, $40, $40, $40
; Tile mask 102
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 103
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 104
.byt $ff, $ff, $5f, $5f, $4f, $4f, $4f, $47
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 106
.byt $47, $47, $47, $4f, $4f, $4f, $4f, $4f
; Tile mask 107
.byt $40, $40, $40, $60, $60, $70, $78, $78
; Tile mask 108
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 109
.byt $4f, $5f, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 110
.byt $78, $78, $70, $60, $60, $40, $40, $40
; Tile mask 111
.byt $41, $41, $41, $41, $40, $40, $40, $40
; Tile mask 112
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 113
.byt $60, $70, $70, $70, $70, $60, $60, $70
; Tile mask 114
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 115
.byt $40, $40, $40, $40, $50, $50, $50, $50
; Tile mask 116
.byt $40, $41, $41, $41, $40, $40, $40, $40
; Tile mask 117
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $ff
; Tile mask 118
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $41
; Tile mask 119
.byt $7c, $78, $78, $70, $70, $70, $70, $70
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 121
.byt $ff, $5f, $4f, $47, $47, $47, $47, $47
; Tile mask 122
.byt $70, $70, $70, $78, $78, $78, $78, $70
; Tile mask 123
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 124
.byt $47, $4f, $4f, $5f, $5f, $5f, $4f, $4f
; Tile mask 125
.byt $70, $70, $70, $70, $70, $78, $70, $70
; Tile mask 126
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 127
.byt $4f, $4f, $4f, $4f, $5f, $5f, $4f, $4f
; Tile mask 128
.byt $70, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 129
.byt $48, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 130
.byt $4f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 131
.byt $ff, $77, $77, $77, $63, $63, $63, $63
; Tile mask 132
.byt $ff, $7e, $78, $70, $78, $7e, $ff, $ff
; Tile mask 133
.byt $63, $40, $40, $40, $40, $40, $63, $63
; Tile mask 134
.byt $ff, $ff, $4f, $47, $4f, $ff, $ff, $ff
; Tile mask 135
.byt $63, $63, $63, $77, $77, $77, $ff, $ff
; Tile mask 136
.byt $ff, $ff, $ff, $ff, $ff, $77, $77, $77
; Tile mask 137
.byt $ff, $ff, $ff, $7e, $ff, $ff, $ff, $ff
; Tile mask 138
.byt $63, $63, $41, $40, $41, $63, $63, $77
; Tile mask 139
.byt $77, $77, $ff, $ff, $ff, $ff, $ff, $ff
res_end
.)

