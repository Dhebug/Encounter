.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 10
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
.byt 10, 11, 12, 13, 0
.byt 14, 15, 16, 17, 0
.byt 18, 19, 20, 21, 0
.byt 22, 23, 24, 25, 0
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 26, 27, 28, 29, 30
.byt 31, 32, 33, 34, 35
.byt 36, 37, 38, 39, 40
.byt 41, 42, 43, 44, 45
.byt 46, 47, 48, 49, 50
.byt 0, 51, 52, 53, 54
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 9
.byt 10, 11, 12, 13, 0
.byt 14, 15, 16, 17, 0
.byt 18, 19, 20, 21, 0
.byt 55, 56, 57, 58, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 26, 27, 28, 29, 30
.byt 31, 32, 33, 34, 35
.byt 36, 37, 38, 39, 40
.byt 59, 60, 43, 44, 61
.byt 62, 63, 64, 49, 0
.byt 65, 66, 67, 68, 69
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 70, 71, 72, 73, 74
.byt 75, 76, 77, 78, 79
.byt 80, 81, 82, 83, 84
.byt 85, 86, 87, 88, 89
.byt 90, 91, 92, 93, 94
.byt 95, 96, 97, 98, 99
; Animatory state 5 (05-stepd1.png)
.byt 0, 100, 101, 102, 0
.byt 103, 104, 105, 106, 107
.byt 108, 109, 110, 111, 112
.byt 113, 114, 115, 116, 117
.byt 118, 119, 120, 121, 122
.byt 0, 123, 124, 125, 0
.byt 0, 126, 127, 128, 129
; Animatory state 6 (06-stepd2.png)
.byt 0, 100, 101, 102, 0
.byt 103, 104, 105, 106, 107
.byt 108, 109, 110, 111, 112
.byt 130, 131, 115, 132, 133
.byt 134, 135, 136, 137, 138
.byt 139, 140, 141, 142, 0
.byt 143, 144, 145, 146, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 70, 147, 148, 149, 74
.byt 75, 150, 151, 152, 79
.byt 153, 154, 155, 156, 84
.byt 85, 157, 158, 159, 89
.byt 160, 161, 162, 93, 163
.byt 95, 164, 165, 166, 99
; Animatory state 8 (08-stepdb1.png)
.byt 0, 100, 101, 102, 0
.byt 103, 167, 168, 169, 170
.byt 171, 172, 173, 174, 112
.byt 113, 175, 176, 177, 178
.byt 179, 180, 181, 182, 183
.byt 0, 184, 185, 125, 0
.byt 0, 186, 187, 188, 129
; Animatory state 9 (09-stepdb2.png)
.byt 0, 100, 101, 102, 0
.byt 103, 167, 168, 169, 107
.byt 171, 172, 173, 174, 112
.byt 189, 190, 176, 191, 133
.byt 192, 193, 181, 194, 195
.byt 139, 140, 196, 197, 0
.byt 143, 198, 199, 200, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 70, 71, 72, 73, 74
.byt 75, 76, 77, 78, 79
.byt 80, 81, 201, 83, 84
.byt 85, 202, 203, 204, 89
.byt 90, 91, 92, 93, 94
.byt 95, 96, 97, 98, 99
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 9
.byt 10, 11, 205, 206, 0
.byt 14, 207, 208, 209, 0
.byt 18, 19, 20, 21, 0
.byt 22, 23, 24, 25, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $1, $2, $1, $2, $5
; Tile graphic 2
.byt $0, $0, $2, $11, $2a, $11, $22, $7
; Tile graphic 3
.byt $0, $0, $0, $15, $22, $1d, $2e, $3f
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $10, $28, $3c
; Tile graphic 5
.byt $a, $4, $2, $5, $0, $5, $0, $0
; Tile graphic 6
.byt $2b, $7, $23, $7, $e, $1c, $f, $e
; Tile graphic 7
.byt $3f, $3f, $3f, $3f, $7, $3f, $3, $2b
; Tile graphic 8
.byt $3c, $3c, $3e, $3e, $30, $2c, $2, $14
; Tile graphic 9
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 10
.byt $0, $6, $3, $3, $1, $0, $0, $0
; Tile graphic 11
.byt $f, $f, $1f, $3f, $2f, $1f, $3f, $2f
; Tile graphic 12
.byt $37, $3f, $3f, $3f, $3e, $3f, $31, $3f
; Tile graphic 13
.byt $e, $3e, $3e, $3c, $1c, $3c, $c, $38
; Tile graphic 14
.byt $0, $3, $3, $7, $f, $f, $f, $f
; Tile graphic 15
.byt $17, $1, $28, $2a, $23, $10, $0, $18
; Tile graphic 16
.byt $3c, $3f, $e, $10, $5, $18, $d, $0
; Tile graphic 17
.byt $18, $30, $28, $14, $c, $24, $24, $4
; Tile graphic 18
.byt $e, $e, $0, $1f, $1d, $1c, $1f, $0
; Tile graphic 19
.byt $3e, $3f, $3f, $1f, $1f, $0, $1f, $0
; Tile graphic 20
.byt $15, $28, $15, $20, $15, $0, $15, $0
; Tile graphic 21
.byt $14, $24, $10, $26, $16, $2, $36, $0
; Tile graphic 22
.byt $1, $1, $0, $1, $2, $7, $7, $0
; Tile graphic 23
.byt $3f, $3f, $0, $3e, $e, $3e, $3c, $0
; Tile graphic 24
.byt $3f, $1f, $0, $f, $f, $f, $7, $0
; Tile graphic 25
.byt $30, $30, $0, $38, $4, $3e, $3e, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 27
.byt $0, $0, $0, $a, $15, $a, $14, $28
; Tile graphic 28
.byt $0, $0, $10, $a, $14, $b, $15, $3f
; Tile graphic 29
.byt $0, $0, $0, $28, $10, $2a, $35, $3f
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 31
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 32
.byt $15, $20, $14, $28, $1, $2b, $1, $1
; Tile graphic 33
.byt $1f, $3f, $1f, $3f, $30, $27, $38, $35
; Tile graphic 34
.byt $3f, $3f, $3f, $3f, $3e, $3d, $18, $1a
; Tile graphic 35
.byt $20, $20, $30, $30, $0, $20, $10, $20
; Tile graphic 36
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 37
.byt $1, $31, $1b, $1f, $d, $3, $7, $5
; Tile graphic 38
.byt $3e, $3f, $3f, $3f, $3f, $3f, $3e, $3f
; Tile graphic 39
.byt $39, $3f, $3f, $3f, $33, $3f, $9, $3f
; Tile graphic 40
.byt $30, $30, $30, $20, $20, $20, $20, $0
; Tile graphic 41
.byt $0, $0, $0, $0, $0, $3, $1, $e
; Tile graphic 42
.byt $2, $8, $d, $1d, $3c, $3a, $20, $3
; Tile graphic 43
.byt $3f, $f, $1, $12, $18, $3, $1, $0
; Tile graphic 44
.byt $23, $3e, $35, $2, $29, $4, $2c, $0
; Tile graphic 45
.byt $0, $0, $0, $0, $20, $14, $c, $1c
; Tile graphic 46
.byt $f, $e, $e, $0, $0, $0, $0, $0
; Tile graphic 47
.byt $7, $7, $7, $3, $3, $0, $3, $0
; Tile graphic 48
.byt $32, $3d, $3a, $3c, $3a, $0, $3a, $0
; Tile graphic 49
.byt $2a, $4, $2a, $4, $2a, $0, $2e, $0
; Tile graphic 50
.byt $1c, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 51
.byt $1, $0, $1, $1, $3, $0, $0, $0
; Tile graphic 52
.byt $3f, $7, $3, $38, $25, $39, $0, $0
; Tile graphic 53
.byt $8, $30, $30, $e, $38, $3f, $3c, $0
; Tile graphic 54
.byt $0, $0, $0, $0, $0, $20, $0, $0
; Tile graphic 55
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 56
.byt $3f, $3f, $0, $3f, $3c, $3f, $1f, $0
; Tile graphic 57
.byt $3f, $2f, $0, $2f, $16, $3b, $3b, $0
; Tile graphic 58
.byt $20, $20, $0, $30, $8, $3c, $3c, $0
; Tile graphic 59
.byt $0, $0, $0, $0, $0, $1, $1, $1
; Tile graphic 60
.byt $2, $c, $1d, $3d, $3c, $3a, $38, $3b
; Tile graphic 61
.byt $0, $0, $0, $20, $20, $20, $0, $0
; Tile graphic 62
.byt $3, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 63
.byt $33, $25, $3e, $3d, $19, $b, $3, $0
; Tile graphic 64
.byt $32, $3d, $2, $30, $3a, $38, $26, $0
; Tile graphic 65
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 66
.byt $f, $f, $1, $1e, $3f, $3c, $1f, $0
; Tile graphic 67
.byt $3f, $3c, $30, $0, $30, $0, $38, $0
; Tile graphic 68
.byt $3f, $3c, $3, $1e, $1f, $f, $0, $0
; Tile graphic 69
.byt $0, $0, $20, $0, $38, $0, $0, $0
; Tile graphic 70
.byt $0, $0, $0, $0, $0, $1, $2, $0
; Tile graphic 71
.byt $0, $0, $0, $5, $22, $5, $f, $1f
; Tile graphic 72
.byt $0, $0, $0, $15, $8, $1d, $3f, $3f
; Tile graphic 73
.byt $0, $0, $0, $10, $22, $11, $38, $3c
; Tile graphic 74
.byt $0, $0, $0, $0, $0, $0, $20, $0
; Tile graphic 75
.byt $2, $5, $2, $4, $2, $0, $0, $1
; Tile graphic 76
.byt $2f, $f, $2f, $1f, $38, $33, $1c, $1a
; Tile graphic 77
.byt $3f, $3f, $3f, $3f, $1e, $3f, $c, $2d
; Tile graphic 78
.byt $3a, $39, $3a, $3c, $6, $32, $e, $15
; Tile graphic 79
.byt $20, $10, $20, $10, $20, $0, $0, $0
; Tile graphic 80
.byt $1, $1, $1, $1, $0, $0, $0, $0
; Tile graphic 81
.byt $1f, $1f, $3f, $3f, $3f, $3f, $1e, $1f
; Tile graphic 82
.byt $1e, $3f, $3f, $3f, $33, $3f, $8, $3f
; Tile graphic 83
.byt $3d, $3d, $3f, $3f, $3e, $3e, $3c, $3c
; Tile graphic 84
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 85
.byt $0, $0, $0, $1, $3, $3, $3, $7
; Tile graphic 86
.byt $f, $7, $1, $22, $2c, $21, $0, $0
; Tile graphic 87
.byt $23, $3f, $37, $0, $21, $3, $37, $0
; Tile graphic 88
.byt $38, $30, $2, $2b, $13, $9, $15, $29
; Tile graphic 89
.byt $0, $0, $0, $0, $20, $20, $20, $30
; Tile graphic 90
.byt $7, $7, $0, $f, $f, $e, $f, $0
; Tile graphic 91
.byt $19, $1e, $1d, $1e, $1d, $0, $1f, $0
; Tile graphic 92
.byt $15, $22, $15, $2, $15, $0, $15, $0
; Tile graphic 93
.byt $15, $29, $14, $29, $15, $0, $3d, $0
; Tile graphic 94
.byt $30, $30, $0, $38, $38, $38, $38, $0
; Tile graphic 95
.byt $0, $0, $0, $0, $1, $3, $3, $0
; Tile graphic 96
.byt $1f, $1f, $0, $3f, $7, $3f, $3f, $0
; Tile graphic 97
.byt $3f, $37, $0, $23, $23, $23, $1, $0
; Tile graphic 98
.byt $3c, $3c, $0, $3e, $31, $3f, $3f, $0
; Tile graphic 99
.byt $0, $0, $0, $0, $0, $20, $20, $0
; Tile graphic 100
.byt $0, $0, $0, $0, $0, $0, $0, $5
; Tile graphic 101
.byt $0, $0, $0, $0, $0, $0, $0, $15
; Tile graphic 102
.byt $0, $0, $0, $0, $0, $0, $0, $10
; Tile graphic 103
.byt $0, $1, $2, $0, $2, $5, $2, $4
; Tile graphic 104
.byt $22, $5, $f, $1f, $2f, $f, $2f, $1f
; Tile graphic 105
.byt $8, $1d, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 106
.byt $22, $11, $38, $3c, $3a, $39, $3a, $3c
; Tile graphic 107
.byt $0, $0, $20, $0, $20, $10, $20, $10
; Tile graphic 108
.byt $2, $0, $0, $1, $1, $1, $1, $1
; Tile graphic 109
.byt $38, $33, $1c, $1a, $1f, $1f, $3f, $3f
; Tile graphic 110
.byt $1e, $3f, $c, $2d, $1e, $3f, $3f, $3f
; Tile graphic 111
.byt $6, $32, $e, $15, $3d, $3d, $3f, $3f
; Tile graphic 112
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 113
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 114
.byt $3f, $3f, $1e, $1f, $f, $7, $1, $22
; Tile graphic 115
.byt $33, $3f, $8, $3f, $23, $3f, $37, $0
; Tile graphic 116
.byt $3e, $3e, $3c, $3c, $38, $30, $2, $2a
; Tile graphic 117
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 118
.byt $3, $0, $3, $3, $3, $3, $0, $0
; Tile graphic 119
.byt $2c, $1, $20, $20, $29, $2e, $d, $1e
; Tile graphic 120
.byt $21, $3, $37, $0, $15, $22, $15, $2
; Tile graphic 121
.byt $13, $9, $15, $29, $14, $29, $14, $28
; Tile graphic 122
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 123
.byt $1d, $0, $1f, $0, $1f, $1f, $1f, $f
; Tile graphic 124
.byt $15, $0, $15, $0, $3f, $37, $20, $23
; Tile graphic 125
.byt $14, $0, $3c, $0, $3c, $3c, $0, $3e
; Tile graphic 126
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 127
.byt $3, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 128
.byt $20, $3f, $3f, $0, $0, $0, $0, $0
; Tile graphic 129
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 130
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 131
.byt $3f, $3f, $1e, $1f, $f, $7, $21, $2a
; Tile graphic 132
.byt $3e, $3e, $3c, $3c, $38, $34, $0, $23
; Tile graphic 133
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 134
.byt $1, $1, $1, $1, $0, $1, $0, $0
; Tile graphic 135
.byt $25, $9, $15, $a, $15, $a, $15, $a
; Tile graphic 136
.byt $2, $21, $36, $0, $15, $22, $15, $20
; Tile graphic 137
.byt $1b, $0, $3, $3, $b, $3b, $18, $3c
; Tile graphic 138
.byt $20, $0, $20, $20, $20, $20, $0, $0
; Tile graphic 139
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 140
.byt $15, $0, $1f, $0, $1f, $1f, $0, $3f
; Tile graphic 141
.byt $15, $0, $15, $0, $3f, $37, $3, $23
; Tile graphic 142
.byt $1c, $0, $3c, $0, $3c, $3c, $3c, $38
; Tile graphic 143
.byt $0, $1, $1, $0, $0, $0, $0, $0
; Tile graphic 144
.byt $3, $3f, $3f, $0, $0, $0, $0, $0
; Tile graphic 145
.byt $20, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 146
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 147
.byt $0, $0, $0, $5, $22, $5, $a, $14
; Tile graphic 148
.byt $0, $0, $0, $15, $8, $15, $22, $11
; Tile graphic 149
.byt $0, $0, $0, $10, $22, $11, $8, $14
; Tile graphic 150
.byt $2a, $5, $8, $15, $28, $15, $2, $15
; Tile graphic 151
.byt $2a, $11, $2a, $15, $22, $14, $9, $12
; Tile graphic 152
.byt $2a, $1, $2a, $14, $2a, $4, $14, $8
; Tile graphic 153
.byt $0, $1, $0, $1, $0, $0, $0, $0
; Tile graphic 154
.byt $2a, $4, $2a, $15, $22, $15, $8, $15
; Tile graphic 155
.byt $28, $14, $2a, $14, $a, $15, $20, $15
; Tile graphic 156
.byt $8, $11, $2a, $11, $2a, $14, $20, $14
; Tile graphic 157
.byt $8, $7, $20, $2a, $25, $2a, $5, $a
; Tile graphic 158
.byt $0, $3f, $0, $2a, $15, $22, $15, $22
; Tile graphic 159
.byt $8, $30, $2, $2b, $13, $29, $11, $29
; Tile graphic 160
.byt $7, $7, $0, $f, $d, $c, $f, $0
; Tile graphic 161
.byt $15, $a, $15, $a, $15, $0, $1f, $0
; Tile graphic 162
.byt $15, $22, $15, $2a, $15, $0, $3f, $0
; Tile graphic 163
.byt $30, $30, $0, $38, $18, $18, $38, $0
; Tile graphic 164
.byt $1f, $1f, $0, $3f, $3f, $3f, $3f, $0
; Tile graphic 165
.byt $21, $37, $0, $23, $23, $23, $1, $0
; Tile graphic 166
.byt $3c, $3c, $0, $3e, $3f, $3f, $3f, $0
; Tile graphic 167
.byt $22, $5, $a, $14, $2a, $5, $8, $15
; Tile graphic 168
.byt $8, $15, $22, $11, $2a, $11, $2a, $15
; Tile graphic 169
.byt $22, $11, $8, $14, $2a, $1, $2a, $14
; Tile graphic 170
.byt $0, $0, $20, $0, $20, $0, $20, $0
; Tile graphic 171
.byt $2, $0, $0, $1, $0, $1, $0, $1
; Tile graphic 172
.byt $28, $15, $2, $15, $2a, $4, $2a, $15
; Tile graphic 173
.byt $22, $14, $9, $12, $28, $14, $2a, $14
; Tile graphic 174
.byt $2a, $4, $14, $8, $8, $11, $2a, $11
; Tile graphic 175
.byt $22, $15, $8, $15, $8, $7, $20, $2a
; Tile graphic 176
.byt $a, $15, $20, $15, $0, $3f, $0, $2a
; Tile graphic 177
.byt $2a, $14, $20, $14, $8, $31, $2, $2b
; Tile graphic 178
.byt $0, $0, $0, $0, $0, $20, $20, $0
; Tile graphic 179
.byt $3, $0, $7, $7, $7, $7, $0, $0
; Tile graphic 180
.byt $25, $a, $5, $2a, $5, $2a, $15, $a
; Tile graphic 181
.byt $15, $22, $15, $22, $15, $22, $15, $2a
; Tile graphic 182
.byt $11, $29, $10, $28, $14, $28, $14, $28
; Tile graphic 183
.byt $20, $20, $20, $0, $0, $0, $0, $0
; Tile graphic 184
.byt $15, $0, $1f, $0, $10, $f, $1f, $1f
; Tile graphic 185
.byt $15, $0, $3f, $0, $21, $17, $20, $23
; Tile graphic 186
.byt $1f, $f, $0, $0, $0, $0, $0, $0
; Tile graphic 187
.byt $23, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 188
.byt $3e, $3f, $3f, $0, $0, $0, $0, $0
; Tile graphic 189
.byt $0, $0, $0, $0, $0, $3, $2, $1
; Tile graphic 190
.byt $22, $15, $8, $15, $8, $7, $20, $2a
; Tile graphic 191
.byt $2a, $14, $20, $14, $8, $30, $2, $2b
; Tile graphic 192
.byt $3, $3, $2, $0, $0, $0, $0, $0
; Tile graphic 193
.byt $5, $a, $5, $a, $15, $a, $15, $a
; Tile graphic 194
.byt $13, $28, $11, $2b, $11, $2b, $14, $28
; Tile graphic 195
.byt $20, $0, $30, $30, $30, $30, $0, $0
; Tile graphic 196
.byt $15, $0, $3f, $0, $2, $35, $3, $23
; Tile graphic 197
.byt $14, $0, $3c, $0, $4, $38, $3c, $3c
; Tile graphic 198
.byt $3f, $3f, $3f, $0, $0, $0, $0, $0
; Tile graphic 199
.byt $23, $21, $0, $0, $0, $0, $0, $0
; Tile graphic 200
.byt $3c, $38, $0, $0, $0, $0, $0, $0
; Tile graphic 201
.byt $1e, $3f, $3f, $3f, $33, $3f, $0, $1
; Tile graphic 202
.byt $f, $f, $7, $21, $2c, $21, $0, $0
; Tile graphic 203
.byt $3f, $23, $3f, $37, $0, $3, $37, $0
; Tile graphic 204
.byt $38, $38, $32, $b, $13, $9, $15, $29
; Tile graphic 205
.byt $37, $3f, $3f, $3f, $3e, $3f, $30, $38
; Tile graphic 206
.byt $e, $3e, $3e, $3c, $1c, $3c, $c, $1c
; Tile graphic 207
.byt $f, $7, $29, $2a, $23, $10, $0, $18
; Tile graphic 208
.byt $3f, $3c, $3f, $e, $10, $18, $d, $0
; Tile graphic 209
.byt $38, $18, $30, $24, $c, $24, $24, $4
costume_masks
; Tile mask 1
.byt $ff, $ff, $7e, $7c, $78, $70, $70, $60
; Tile mask 2
.byt $ff, $60, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $41, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $5f, $47, $43, $41, $41, $40
; Tile mask 5
.byt $60, $60, $60, $60, $60, $60, $70, $70
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $ff, $5f, $5f, $5f, $5f, $5f, $5f, $ff
; Tile mask 10
.byt $70, $70, $70, $78, $78, $78, $7c, $7e
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $41, $41, $41, $41, $43
; Tile mask 14
.byt $7c, $78, $78, $70, $60, $60, $60, $60
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $43, $47, $43, $41, $41, $41, $41, $41
; Tile mask 18
.byt $60, $60, $60, $40, $40, $40, $40, $60
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $41, $41, $41, $40, $40, $40, $40, $41
; Tile mask 22
.byt $7c, $7c, $7c, $7c, $78, $70, $70, $70
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 24
.byt $40, $40, $40, $60, $60, $60, $60, $78
; Tile mask 25
.byt $47, $47, $47, $43, $41, $40, $40, $40
; Tile mask 26
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7e, $7c
; Tile mask 27
.byt $ff, $7c, $70, $60, $40, $40, $40, $40
; Tile mask 28
.byt $ff, $40, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $ff, $4f, $43, $40, $40, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $47
; Tile mask 31
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7e, $7e
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $47, $43, $43, $43, $43, $43, $43, $47
; Tile mask 36
.byt $7e, $7e, $7e, $ff, $ff, $ff, $ff, $ff
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $60, $70
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $47, $47, $47, $4f, $4f, $4f, $4f, $5f
; Tile mask 41
.byt $ff, $ff, $ff, $7e, $7c, $78, $70, $60
; Tile mask 42
.byt $60, $60, $40, $40, $40, $40, $40, $50
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 45
.byt $5f, $ff, $5f, $5f, $43, $41, $41, $41
; Tile mask 46
.byt $60, $60, $60, $71, $ff, $ff, $ff, $ff
; Tile mask 47
.byt $50, $50, $70, $78, $78, $78, $78, $78
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $41, $43, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 51
.byt $7c, $7c, $7c, $7c, $78, $78, $ff, $ff
; Tile mask 52
.byt $40, $40, $40, $40, $40, $40, $44, $ff
; Tile mask 53
.byt $43, $43, $41, $40, $40, $40, $40, $43
; Tile mask 54
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $ff
; Tile mask 55
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7e, $ff
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $4f, $4f, $4f, $47, $43, $41, $41, $41
; Tile mask 59
.byt $ff, $ff, $ff, $7e, $7e, $7c, $7c, $7c
; Tile mask 60
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $5f, $ff, $5f, $4f, $4f, $4f, $5f, $ff
; Tile mask 62
.byt $78, $78, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 63
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 64
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $ff, $ff, $ff, $ff, $7e, $7e, $7e, $ff
; Tile mask 66
.byt $60, $60, $60, $40, $40, $40, $40, $60
; Tile mask 67
.byt $40, $40, $43, $4f, $47, $43, $43, $43
; Tile mask 68
.byt $40, $40, $40, $40, $40, $40, $70, $ff
; Tile mask 69
.byt $5f, $5f, $4f, $47, $43, $43, $ff, $ff
; Tile mask 70
.byt $ff, $ff, $ff, $ff, $7c, $7c, $78, $78
; Tile mask 71
.byt $ff, $7e, $60, $40, $40, $40, $40, $40
; Tile mask 72
.byt $ff, $40, $40, $40, $40, $40, $40, $40
; Tile mask 73
.byt $ff, $ff, $4f, $41, $40, $40, $40, $40
; Tile mask 74
.byt $ff, $ff, $ff, $ff, $5f, $5f, $4f, $4f
; Tile mask 75
.byt $70, $70, $70, $70, $78, $78, $78, $78
; Tile mask 76
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 77
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $47, $47, $47, $47, $4f, $4f, $4f, $4f
; Tile mask 80
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7e, $ff
; Tile mask 81
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 82
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 84
.byt $5f, $5f, $5f, $5f, $5f, $5f, $ff, $ff
; Tile mask 85
.byt $ff, $ff, $7e, $7c, $78, $78, $78, $70
; Tile mask 86
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 88
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 89
.byt $ff, $ff, $ff, $5f, $4f, $4f, $4f, $47
; Tile mask 90
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 91
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 92
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 93
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 94
.byt $47, $47, $47, $43, $43, $43, $43, $47
; Tile mask 95
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 96
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 97
.byt $40, $40, $40, $48, $48, $48, $48, $7e
; Tile mask 98
.byt $41, $41, $41, $40, $40, $40, $40, $40
; Tile mask 99
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $4f
; Tile mask 100
.byt $ff, $ff, $ff, $ff, $ff, $7e, $60, $40
; Tile mask 101
.byt $ff, $ff, $ff, $ff, $ff, $40, $40, $40
; Tile mask 102
.byt $ff, $ff, $ff, $ff, $ff, $ff, $4f, $41
; Tile mask 103
.byt $7c, $7c, $78, $78, $70, $70, $70, $70
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 106
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 107
.byt $5f, $5f, $4f, $4f, $47, $47, $47, $47
; Tile mask 108
.byt $78, $78, $78, $78, $7c, $7c, $7c, $7c
; Tile mask 109
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 110
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 111
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 112
.byt $4f, $4f, $4f, $4f, $5f, $5f, $5f, $5f
; Tile mask 113
.byt $7c, $7c, $7e, $ff, $ff, $ff, $7e, $7c
; Tile mask 114
.byt $40, $40, $40, $40, $60, $40, $40, $40
; Tile mask 115
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $40, $40, $40, $41, $43, $41, $40, $40
; Tile mask 117
.byt $5f, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 118
.byt $78, $78, $78, $70, $70, $70, $7c, $ff
; Tile mask 119
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 121
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 122
.byt $5f, $5f, $5f, $5f, $5f, $5f, $5f, $ff
; Tile mask 123
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 124
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 125
.byt $41, $41, $41, $41, $41, $41, $41, $40
; Tile mask 126
.byt $60, $70, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 127
.byt $58, $78, $78, $7e, $ff, $ff, $ff, $ff
; Tile mask 128
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 129
.byt $ff, $5f, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 130
.byt $7c, $7c, $7e, $ff, $ff, $ff, $7e, $7e
; Tile mask 131
.byt $40, $40, $40, $40, $60, $40, $40, $40
; Tile mask 132
.byt $40, $40, $40, $41, $43, $41, $40, $40
; Tile mask 133
.byt $5f, $5f, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 134
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $ff
; Tile mask 135
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 136
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 137
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 138
.byt $4f, $4f, $4f, $47, $47, $47, $5f, $ff
; Tile mask 139
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 140
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 141
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 142
.byt $41, $41, $41, $41, $41, $41, $41, $43
; Tile mask 143
.byt $7e, $7c, $7c, $7c, $ff, $ff, $ff, $ff
; Tile mask 144
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 145
.byt $4c, $4e, $4f, $ff, $ff, $ff, $ff, $ff
; Tile mask 146
.byt $43, $47, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 147
.byt $ff, $7e, $60, $40, $40, $40, $40, $40
; Tile mask 148
.byt $ff, $40, $40, $40, $40, $40, $40, $40
; Tile mask 149
.byt $ff, $ff, $4f, $41, $40, $40, $40, $40
; Tile mask 150
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 151
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 152
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 153
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7e, $ff
; Tile mask 154
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 155
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 156
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 157
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 158
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 159
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 160
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 161
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 162
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 163
.byt $47, $47, $47, $43, $43, $43, $43, $47
; Tile mask 164
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 165
.byt $40, $40, $40, $48, $48, $48, $48, $7e
; Tile mask 166
.byt $41, $41, $41, $40, $40, $40, $40, $40
; Tile mask 167
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 168
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 169
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 170
.byt $5f, $5f, $4f, $4f, $4f, $5f, $4f, $5f
; Tile mask 171
.byt $78, $78, $78, $78, $7c, $7c, $7c, $7c
; Tile mask 172
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 173
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 174
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 175
.byt $40, $40, $40, $40, $60, $40, $40, $40
; Tile mask 176
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 177
.byt $40, $40, $40, $41, $40, $40, $40, $40
; Tile mask 178
.byt $5f, $5f, $ff, $ff, $5f, $4f, $4f, $4f
; Tile mask 179
.byt $78, $78, $70, $70, $70, $70, $78, $ff
; Tile mask 180
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 181
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 182
.byt $40, $40, $40, $41, $41, $41, $41, $41
; Tile mask 183
.byt $4f, $4f, $4f, $5f, $ff, $ff, $ff, $ff
; Tile mask 184
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 185
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 186
.byt $40, $60, $70, $ff, $ff, $ff, $ff, $ff
; Tile mask 187
.byt $48, $58, $78, $7e, $ff, $ff, $ff, $ff
; Tile mask 188
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 189
.byt $7c, $7c, $7e, $ff, $7c, $78, $78, $78
; Tile mask 190
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 191
.byt $40, $40, $43, $41, $43, $41, $40, $40
; Tile mask 192
.byt $78, $78, $78, $7d, $ff, $ff, $ff, $ff
; Tile mask 193
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 194
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 195
.byt $4f, $4f, $47, $47, $47, $47, $4f, $ff
; Tile mask 196
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 197
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile mask 198
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 199
.byt $48, $4c, $4e, $ff, $ff, $ff, $ff, $ff
; Tile mask 200
.byt $41, $43, $47, $ff, $ff, $ff, $ff, $ff
; Tile mask 201
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 202
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 203
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 204
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 205
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 206
.byt $40, $40, $40, $41, $41, $41, $41, $41
; Tile mask 207
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 208
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 209
.byt $43, $43, $43, $41, $41, $41, $41, $41
res_end
.)

