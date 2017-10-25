.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 4
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
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 9
.byt 10, 11, 12, 13, 14
.byt 15, 16, 17, 18, 0
.byt 19, 20, 21, 22, 0
.byt 23, 24, 25, 26, 0
; Animatory state 1 (01-step1.png)
.byt 0, 0, 27, 0, 0
.byt 28, 29, 30, 31, 32
.byt 33, 34, 35, 36, 37
.byt 38, 39, 40, 41, 42
.byt 43, 44, 45, 46, 47
.byt 48, 49, 50, 51, 52
.byt 0, 53, 54, 55, 56
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 9
.byt 10, 11, 57, 58, 14
.byt 15, 16, 17, 18, 0
.byt 19, 20, 21, 22, 0
.byt 59, 60, 61, 62, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 27, 0, 0
.byt 28, 29, 30, 31, 32
.byt 33, 34, 35, 36, 37
.byt 38, 39, 40, 41, 42
.byt 63, 64, 65, 46, 66
.byt 67, 68, 69, 70, 0
.byt 71, 72, 73, 74, 75
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 76, 77, 78, 79, 80
.byt 81, 82, 83, 84, 85
.byt 86, 87, 88, 89, 90
.byt 91, 92, 93, 94, 95
.byt 96, 97, 98, 99, 100
.byt 101, 102, 103, 104, 105
; Animatory state 5 (05-stepd1.png)
.byt 0, 106, 107, 108, 0
.byt 109, 110, 111, 112, 113
.byt 114, 115, 116, 117, 118
.byt 119, 120, 121, 122, 123
.byt 124, 125, 126, 127, 128
.byt 0, 129, 130, 131, 0
.byt 0, 132, 133, 134, 0
; Animatory state 6 (06-stepd2.png)
.byt 0, 106, 107, 108, 0
.byt 109, 110, 111, 112, 113
.byt 114, 115, 116, 117, 118
.byt 135, 136, 121, 137, 138
.byt 139, 140, 141, 142, 143
.byt 0, 144, 145, 146, 0
.byt 147, 148, 149, 150, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 8 (08-stepdb1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 9 (09-stepdb2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 9
.byt 10, 151, 152, 13, 14
.byt 15, 153, 154, 155, 0
.byt 19, 20, 21, 22, 0
.byt 23, 24, 25, 26, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $2, $1
; Tile graphic 6
.byt $0, $0, $4, $7, $c, $b, $0, $29
; Tile graphic 7
.byt $0, $0, $f, $3f, $f, $36, $0, $16
; Tile graphic 8
.byt $0, $38, $34, $3c, $0, $1c, $20, $14
; Tile graphic 9
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 10
.byt $3, $3, $3, $3, $1, $0, $0, $0
; Tile graphic 11
.byt $2b, $3c, $3f, $3f, $2f, $1f, $3f, $17
; Tile graphic 12
.byt $36, $f, $3e, $3c, $3f, $3f, $30, $3f
; Tile graphic 13
.byt $3c, $2, $3e, $3e, $3e, $3c, $3c, $38
; Tile graphic 14
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 15
.byt $0, $2, $7, $7, $f, $f, $f, $f
; Tile graphic 16
.byt $13, $21, $14, $39, $1e, $3f, $10, $16
; Tile graphic 17
.byt $3f, $1f, $2f, $0, $12, $21, $3b, $37
; Tile graphic 18
.byt $38, $20, $0, $8, $3c, $34, $34, $34
; Tile graphic 19
.byt $e, $e, $0, $1f, $1d, $1c, $1f, $0
; Tile graphic 20
.byt $36, $39, $3f, $1f, $1f, $1f, $a, $37
; Tile graphic 21
.byt $3b, $37, $3b, $37, $3b, $37, $22, $3f
; Tile graphic 22
.byt $34, $34, $30, $36, $36, $32, $26, $10
; Tile graphic 23
.byt $1, $1, $0, $0, $3, $2, $7, $0
; Tile graphic 24
.byt $2f, $3f, $3f, $0, $3f, $2f, $3c, $0
; Tile graphic 25
.byt $3f, $2f, $2f, $0, $7, $7, $3, $0
; Tile graphic 26
.byt $20, $30, $30, $0, $3c, $14, $3e, $0
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 28
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 29
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 31
.byt $0, $0, $0, $0, $0, $0, $0, $7
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 33
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 34
.byt $0, $0, $1, $1, $10, $d, $1d, $1f
; Tile graphic 35
.byt $21, $3f, $21, $1e, $0, $a, $1e, $21
; Tile graphic 36
.byt $3e, $3f, $38, $33, $4, $32, $37, $38
; Tile graphic 37
.byt $20, $20, $0, $20, $0, $20, $20, $10
; Tile graphic 38
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $1f, $1f, $d, $3, $7, $2, $2, $4
; Tile graphic 40
.byt $3f, $3f, $3f, $3f, $3e, $3d, $1f, $b
; Tile graphic 41
.byt $37, $27, $3f, $3b, $7, $3f, $3f, $3c
; Tile graphic 42
.byt $30, $30, $30, $20, $20, $0, $0, $0
; Tile graphic 43
.byt $0, $0, $0, $0, $0, $3, $1, $e
; Tile graphic 44
.byt $2, $7, $f, $1f, $3a, $3a, $32, $3
; Tile graphic 45
.byt $25, $8, $32, $3c, $7, $36, $37, $e
; Tile graphic 46
.byt $38, $1, $17, $e, $1e, $3e, $1e, $3e
; Tile graphic 47
.byt $0, $0, $20, $20, $10, $1a, $16, $1e
; Tile graphic 48
.byt $f, $e, $e, $0, $0, $0, $0, $0
; Tile graphic 49
.byt $3, $3, $3, $3, $3, $3, $1, $0
; Tile graphic 50
.byt $3f, $3e, $3f, $3e, $14, $1f, $2c, $3f
; Tile graphic 51
.byt $1e, $3e, $1e, $3e, $14, $3c, $3c, $18
; Tile graphic 52
.byt $e, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 53
.byt $0, $0, $0, $1, $3, $0, $0, $0
; Tile graphic 54
.byt $3f, $7, $33, $38, $25, $39, $0, $0
; Tile graphic 55
.byt $20, $30, $30, $e, $38, $3f, $3c, $0
; Tile graphic 56
.byt $0, $0, $0, $0, $0, $20, $0, $0
; Tile graphic 57
.byt $36, $f, $3e, $3c, $3f, $3f, $30, $2f
; Tile graphic 58
.byt $3c, $2, $3e, $3e, $3e, $1c, $3c, $38
; Tile graphic 59
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 60
.byt $2f, $3f, $1f, $0, $3f, $3e, $3f, $0
; Tile graphic 61
.byt $3f, $2f, $2f, $0, $2f, $7, $33, $0
; Tile graphic 62
.byt $20, $20, $20, $0, $30, $0, $3c, $0
; Tile graphic 63
.byt $0, $0, $0, $0, $0, $1, $1, $1
; Tile graphic 64
.byt $2, $7, $f, $1f, $3c, $39, $33, $32
; Tile graphic 65
.byt $25, $8, $32, $3c, $3f, $3e, $3f, $e
; Tile graphic 66
.byt $0, $0, $20, $20, $20, $0, $0, $0
; Tile graphic 67
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 68
.byt $3d, $1d, $5, $1, $2, $3, $0, $1
; Tile graphic 69
.byt $33, $3a, $33, $36, $4, $2f, $37, $2f
; Tile graphic 70
.byt $1e, $3e, $1e, $3e, $14, $3c, $2c, $1e
; Tile graphic 71
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 72
.byt $3, $f, $1, $1e, $3f, $3c, $1f, $0
; Tile graphic 73
.byt $3e, $3c, $30, $0, $30, $0, $38, $0
; Tile graphic 74
.byt $3f, $1c, $3, $1e, $1f, $f, $0, $0
; Tile graphic 75
.byt $0, $0, $20, $0, $38, $0, $0, $0
; Tile graphic 76
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 77
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 78
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 79
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 80
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 81
.byt $0, $0, $0, $0, $0, $1, $0, $1
; Tile graphic 82
.byt $0, $0, $8, $f, $18, $17, $0, $12
; Tile graphic 83
.byt $0, $1, $1f, $3f, $1e, $2c, $1, $2c
; Tile graphic 84
.byt $0, $30, $24, $3c, $4, $3a, $0, $2a
; Tile graphic 85
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 86
.byt $1, $1, $1, $0, $0, $0, $0, $0
; Tile graphic 87
.byt $17, $38, $3f, $3f, $1f, $1f, $1f, $f
; Tile graphic 88
.byt $2d, $1e, $3d, $39, $3f, $3f, $21, $3f
; Tile graphic 89
.byt $3a, $6, $3e, $3e, $3c, $3c, $38, $38
; Tile graphic 90
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 91
.byt $0, $1, $3, $3, $3, $7, $7, $7
; Tile graphic 92
.byt $7, $1, $28, $22, $1c, $3f, $10, $16
; Tile graphic 93
.byt $3f, $3f, $1e, $0, $24, $21, $3b, $37
; Tile graphic 94
.byt $30, $2a, $16, $7, $3f, $3b, $3b, $3b
; Tile graphic 95
.byt $0, $0, $0, $0, $0, $20, $20, $20
; Tile graphic 96
.byt $7, $0, $f, $e, $e, $f, $0, $0
; Tile graphic 97
.byt $16, $19, $1f, $1f, $1f, $1f, $15, $b
; Tile graphic 98
.byt $3b, $37, $3b, $37, $3b, $3b, $15, $3e
; Tile graphic 99
.byt $3b, $38, $3b, $3a, $38, $3b, $10, $28
; Tile graphic 100
.byt $20, $0, $30, $30, $30, $30, $0, $0
; Tile graphic 101
.byt $0, $0, $0, $0, $1, $1, $3, $0
; Tile graphic 102
.byt $17, $1f, $1f, $0, $3f, $17, $3f, $0
; Tile graphic 103
.byt $3f, $37, $37, $0, $23, $23, $1, $0
; Tile graphic 104
.byt $30, $38, $38, $0, $3e, $2a, $3f, $0
; Tile graphic 105
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 106
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 107
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 108
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 109
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 110
.byt $0, $0, $0, $0, $0, $0, $8, $f
; Tile graphic 111
.byt $0, $0, $0, $0, $0, $1, $1f, $3f
; Tile graphic 112
.byt $0, $0, $0, $0, $0, $30, $24, $3c
; Tile graphic 113
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 114
.byt $0, $1, $0, $1, $1, $1, $1, $0
; Tile graphic 115
.byt $18, $17, $0, $12, $17, $38, $3f, $3f
; Tile graphic 116
.byt $1e, $2c, $1, $2c, $2d, $1e, $3d, $39
; Tile graphic 117
.byt $4, $3a, $0, $2a, $3a, $6, $3e, $3e
; Tile graphic 118
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 119
.byt $0, $0, $0, $0, $0, $1, $3, $3
; Tile graphic 120
.byt $1f, $1f, $1f, $f, $7, $1, $28, $22
; Tile graphic 121
.byt $3f, $3f, $21, $3f, $3f, $3f, $1e, $0
; Tile graphic 122
.byt $3c, $3c, $38, $38, $30, $2a, $16, $7
; Tile graphic 123
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 124
.byt $3, $7, $4, $3, $3, $3, $3, $0
; Tile graphic 125
.byt $1c, $1f, $0, $36, $36, $31, $37, $f
; Tile graphic 126
.byt $24, $21, $3b, $37, $3b, $37, $3b, $37
; Tile graphic 127
.byt $3f, $3b, $3a, $38, $3a, $38, $38, $38
; Tile graphic 128
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 129
.byt $1f, $1f, $15, $b, $17, $1f, $1f, $0
; Tile graphic 130
.byt $3b, $3b, $15, $3e, $3b, $37, $37, $0
; Tile graphic 131
.byt $38, $38, $10, $28, $30, $38, $38, $0
; Tile graphic 132
.byt $f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 133
.byt $3, $3, $3, $0, $0, $0, $0, $0
; Tile graphic 134
.byt $3c, $2a, $3e, $0, $0, $0, $0, $0
; Tile graphic 135
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 136
.byt $1f, $1f, $1f, $f, $7, $21, $34, $30
; Tile graphic 137
.byt $3c, $3c, $38, $38, $30, $29, $b, $23
; Tile graphic 138
.byt $0, $0, $0, $0, $0, $0, $20, $20
; Tile graphic 139
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 140
.byt $3e, $2f, $28, $b, $2b, $c, $f, $f
; Tile graphic 141
.byt $12, $3, $17, $1b, $17, $3b, $37, $3b
; Tile graphic 142
.byt $1d, $3d, $38, $37, $37, $37, $37, $38
; Tile graphic 143
.byt $20, $30, $10, $20, $20, $20, $20, $0
; Tile graphic 144
.byt $f, $f, $6, $b, $7, $f, $f, $0
; Tile graphic 145
.byt $37, $37, $2a, $3f, $2f, $37, $37, $0
; Tile graphic 146
.byt $3c, $3c, $28, $34, $38, $3c, $3c, $0
; Tile graphic 147
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 148
.byt $1f, $2b, $3f, $0, $0, $0, $0, $0
; Tile graphic 149
.byt $21, $20, $20, $0, $0, $0, $0, $0
; Tile graphic 150
.byt $38, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 151
.byt $2b, $3c, $3f, $3f, $2f, $1f, $3f, $1f
; Tile graphic 152
.byt $36, $f, $3e, $3c, $3f, $3f, $30, $31
; Tile graphic 153
.byt $17, $23, $11, $38, $1f, $3f, $10, $16
; Tile graphic 154
.byt $3f, $3f, $1f, $2f, $0, $21, $3b, $37
; Tile graphic 155
.byt $38, $30, $20, $8, $3c, $34, $34, $34
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $7e, $7c, $78, $78
; Tile mask 2
.byt $ff, $ff, $7c, $60, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $6f, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $5f, $47, $43, $41, $41, $40
; Tile mask 5
.byt $70, $60, $60, $60, $60, $60, $60, $60
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $ff, $5f, $5f, $5f, $5f, $5f, $5f, $4f
; Tile mask 10
.byt $60, $60, $60, $40, $60, $70, $78, $76
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $41, $41, $43
; Tile mask 14
.byt $57, $5f, $6f, $ff, $ff, $ff, $ff, $ff
; Tile mask 15
.byt $7c, $78, $70, $70, $60, $60, $60, $60
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $43, $47, $47, $43, $41, $41, $41, $41
; Tile mask 19
.byt $60, $60, $60, $40, $40, $40, $40, $60
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $41, $41, $41, $40, $40, $40, $40, $41
; Tile mask 23
.byt $7c, $7c, $7c, $7c, $78, $70, $70, $70
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 25
.byt $40, $40, $40, $50, $50, $50, $50, $7c
; Tile mask 26
.byt $47, $47, $47, $43, $41, $40, $40, $40
; Tile mask 27
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7d
; Tile mask 28
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7c
; Tile mask 29
.byt $ff, $7c, $70, $60, $40, $40, $40, $40
; Tile mask 30
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $43, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $ff, $ff, $5f, $4f, $4f, $47, $47, $43
; Tile mask 33
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $43, $43, $43, $43, $43, $41, $42, $43
; Tile mask 38
.byt $7c, $78, $7c, $7e, $ff, $7e, $ff, $ff
; Tile mask 39
.byt $40, $40, $40, $40, $40, $70, $60, $70
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $45, $47, $47, $4f, $4f, $5f, $5f, $ff
; Tile mask 43
.byt $ff, $ff, $ff, $7e, $7c, $78, $70, $60
; Tile mask 44
.byt $70, $60, $40, $40, $40, $40, $40, $48
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $ff, $5f, $4f, $4f, $41, $40, $40, $40
; Tile mask 48
.byt $60, $60, $60, $71, $ff, $ff, $ff, $ff
; Tile mask 49
.byt $58, $58, $78, $78, $78, $78, $78, $7e
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $40, $40, $40, $40, $40, $41, $41, $43
; Tile mask 52
.byt $40, $61, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 53
.byt $7e, $7e, $7c, $7c, $78, $78, $ff, $ff
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $44, $ff
; Tile mask 55
.byt $47, $47, $41, $40, $40, $40, $40, $43
; Tile mask 56
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $ff
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $40, $40, $40, $40, $40, $41, $41, $43
; Tile mask 59
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 62
.byt $4f, $4f, $4f, $4f, $47, $43, $41, $41
; Tile mask 63
.byt $ff, $ff, $ff, $7e, $7c, $7c, $7c, $7c
; Tile mask 64
.byt $70, $60, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 66
.byt $ff, $5f, $4f, $4f, $4f, $5f, $ff, $ff
; Tile mask 67
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 68
.byt $40, $40, $60, $70, $78, $78, $78, $7c
; Tile mask 69
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 70
.byt $40, $40, $40, $40, $40, $41, $41, $40
; Tile mask 71
.byt $ff, $ff, $ff, $ff, $7e, $7e, $7e, $ff
; Tile mask 72
.byt $70, $60, $60, $40, $40, $40, $40, $60
; Tile mask 73
.byt $40, $41, $43, $4f, $47, $43, $43, $43
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $70, $ff
; Tile mask 75
.byt $5f, $5f, $4f, $47, $43, $43, $ff, $ff
; Tile mask 76
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $78
; Tile mask 77
.byt $ff, $ff, $78, $40, $40, $40, $40, $40
; Tile mask 78
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $ff, $ff, $ff, $4f, $41, $40, $40, $40
; Tile mask 80
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 81
.byt $70, $70, $70, $70, $70, $70, $70, $70
; Tile mask 82
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 84
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 85
.byt $4f, $4f, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 86
.byt $70, $70, $60, $70, $78, $7c, $7b, $ff
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 89
.byt $40, $40, $40, $40, $40, $40, $43, $43
; Tile mask 90
.byt $47, $4f, $47, $4f, $5f, $ff, $5f, $ff
; Tile mask 91
.byt $7e, $7c, $78, $78, $78, $70, $70, $70
; Tile mask 92
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 93
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 94
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 95
.byt $ff, $ff, $ff, $5f, $5f, $4f, $4f, $4f
; Tile mask 96
.byt $70, $70, $60, $60, $60, $60, $70, $ff
; Tile mask 97
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 98
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 99
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 100
.byt $4f, $4f, $47, $47, $47, $47, $4f, $ff
; Tile mask 101
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 102
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 103
.byt $40, $40, $40, $48, $48, $48, $48, $7e
; Tile mask 104
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 105
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 106
.byt $ff, $ff, $ff, $ff, $ff, $ff, $78, $40
; Tile mask 107
.byt $ff, $ff, $ff, $ff, $ff, $ff, $40, $40
; Tile mask 108
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $4f
; Tile mask 109
.byt $7e, $7c, $7c, $78, $70, $70, $70, $70
; Tile mask 110
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 111
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 112
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 113
.byt $ff, $ff, $ff, $5f, $4f, $4f, $4f, $4f
; Tile mask 114
.byt $70, $70, $70, $70, $70, $70, $60, $70
; Tile mask 115
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 117
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 118
.byt $4f, $4f, $4f, $4f, $47, $4f, $47, $4f
; Tile mask 119
.byt $78, $7c, $7b, $ff, $7e, $7c, $78, $78
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 121
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 122
.byt $40, $40, $43, $43, $41, $40, $40, $40
; Tile mask 123
.byt $5f, $ff, $5f, $ff, $ff, $ff, $ff, $5f
; Tile mask 124
.byt $78, $70, $70, $70, $70, $78, $78, $7c
; Tile mask 125
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 126
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 127
.byt $40, $40, $40, $40, $40, $41, $43, $43
; Tile mask 128
.byt $5f, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 129
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 130
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 131
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile mask 132
.byt $60, $70, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 133
.byt $58, $78, $78, $7c, $ff, $ff, $ff, $ff
; Tile mask 134
.byt $41, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 135
.byt $78, $7c, $7b, $ff, $ff, $7e, $7e, $7c
; Tile mask 136
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 137
.byt $40, $40, $43, $43, $40, $40, $40, $40
; Tile mask 138
.byt $5f, $ff, $5f, $ff, $ff, $5f, $4f, $4f
; Tile mask 139
.byt $7c, $7c, $7e, $7e, $7e, $ff, $ff, $ff
; Tile mask 140
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 141
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 142
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 143
.byt $4f, $47, $47, $47, $47, $4f, $4f, $5f
; Tile mask 144
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 145
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 146
.byt $41, $41, $41, $41, $41, $41, $41, $43
; Tile mask 147
.byt $ff, $7e, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 148
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 149
.byt $4c, $4e, $4f, $5f, $ff, $ff, $ff, $ff
; Tile mask 150
.byt $43, $47, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 151
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 152
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 153
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 154
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 155
.byt $43, $47, $47, $43, $41, $41, $41, $41
res_end
.)

