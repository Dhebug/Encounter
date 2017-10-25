.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 12
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
.byt 0, 1, 2, 0, 0
.byt 3, 4, 5, 6, 7
.byt 8, 9, 10, 11, 12
.byt 13, 14, 15, 16, 0
.byt 17, 18, 19, 20, 0
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 7
; Animatory state 1 (01-step1.png)
.byt 0, 1, 30, 31, 0
.byt 32, 33, 34, 35, 36
.byt 37, 38, 39, 40, 41
.byt 42, 43, 44, 45, 46
.byt 47, 48, 49, 50, 51
.byt 52, 53, 54, 55, 56
.byt 0, 57, 58, 59, 60
; Animatory state 2 (02-step2.png)
.byt 0, 1, 2, 0, 0
.byt 3, 4, 5, 6, 7
.byt 8, 9, 10, 11, 12
.byt 13, 14, 15, 16, 0
.byt 17, 18, 19, 20, 0
.byt 21, 22, 23, 24, 25
.byt 0, 61, 62, 63, 7
; Animatory state 3 (03-step3.png)
.byt 0, 0, 2, 64, 0
.byt 65, 66, 67, 68, 69
.byt 70, 71, 72, 73, 74
.byt 75, 76, 77, 78, 79
.byt 80, 81, 82, 83, 84
.byt 85, 86, 87, 88, 89
.byt 0, 90, 91, 92, 93
; Animatory state 4 (04-front.png)
.byt 0, 94, 2, 95, 0
.byt 96, 97, 98, 99, 100
.byt 101, 102, 103, 104, 105
.byt 106, 107, 108, 109, 110
.byt 111, 112, 113, 114, 115
.byt 116, 117, 118, 119, 120
.byt 121, 122, 123, 124, 7
; Animatory state 5 (05-stepd1.png)
.byt 94, 125, 126, 127, 128
.byt 129, 130, 131, 132, 133
.byt 134, 135, 136, 137, 138
.byt 139, 140, 141, 142, 143
.byt 144, 145, 146, 147, 148
.byt 0, 149, 150, 151, 0
.byt 0, 152, 153, 154, 155
; Animatory state 6 (06-stepd2.png)
.byt 94, 125, 126, 127, 128
.byt 129, 130, 131, 132, 133
.byt 134, 135, 136, 137, 138
.byt 94, 156, 157, 158, 159
.byt 75, 160, 161, 162, 163
.byt 0, 164, 165, 166, 0
.byt 167, 168, 169, 170, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 171, 172, 173, 174, 175
.byt 176, 177, 178, 179, 180
.byt 181, 182, 183, 184, 185
.byt 186, 187, 188, 189, 115
.byt 190, 191, 192, 193, 194
.byt 121, 195, 196, 197, 7
; Animatory state 8 (08-stepdb1.png)
.byt 0, 198, 199, 200, 143
.byt 201, 202, 203, 204, 205
.byt 206, 207, 208, 209, 210
.byt 94, 211, 212, 213, 214
.byt 215, 216, 188, 217, 218
.byt 0, 219, 220, 221, 0
.byt 0, 222, 223, 224, 155
; Animatory state 9 (09-stepdb2.png)
.byt 0, 198, 199, 200, 143
.byt 201, 202, 203, 204, 205
.byt 206, 207, 208, 209, 210
.byt 225, 226, 212, 227, 159
.byt 228, 229, 188, 230, 231
.byt 0, 232, 233, 234, 0
.byt 0, 235, 236, 237, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 94, 2, 95, 0
.byt 96, 97, 98, 99, 100
.byt 101, 102, 103, 104, 105
.byt 106, 238, 239, 240, 110
.byt 111, 241, 242, 243, 115
.byt 116, 117, 118, 119, 120
.byt 121, 122, 123, 124, 7
; Animatory state 11 (11-rightTalk.png)
.byt 0, 1, 2, 0, 0
.byt 3, 4, 5, 6, 7
.byt 8, 9, 10, 11, 12
.byt 13, 14, 244, 245, 0
.byt 17, 246, 247, 248, 0
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 7
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $0, $0, $1, $2, $5, $a, $4, $a
; Tile graphic 4
.byt $5, $2a, $14, $28, $1, $7, $f, $7
; Tile graphic 5
.byt $15, $2a, $0, $0, $3c, $3f, $3f, $3f
; Tile graphic 6
.byt $0, $20, $14, $a, $0, $22, $31, $38
; Tile graphic 7
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 8
.byt $4, $8, $14, $a, $4, $8, $3, $3
; Tile graphic 9
.byt $f, $17, $f, $2f, $1e, $d, $e, $2f
; Tile graphic 10
.byt $3f, $3f, $3f, $7, $3b, $3, $2b, $37
; Tile graphic 11
.byt $39, $3c, $3c, $22, $2c, $2, $14, $2e
; Tile graphic 12
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 13
.byt $3, $3, $3, $1, $0, $0, $0, $0
; Tile graphic 14
.byt $3f, $3f, $3f, $2f, $1f, $1f, $17, $17
; Tile graphic 15
.byt $3f, $3f, $3c, $3e, $3f, $30, $3f, $3c
; Tile graphic 16
.byt $3e, $3e, $1e, $3e, $3e, $c, $3c, $18
; Tile graphic 17
.byt $0, $1, $2, $1, $6, $7, $7, $7
; Tile graphic 18
.byt $9, $6, $29, $14, $22, $0, $20, $20
; Tile graphic 19
.byt $3f, $1c, $20, $1f, $7, $12, $a, $d
; Tile graphic 20
.byt $38, $20, $14, $22, $8, $2, $22, $2
; Tile graphic 21
.byt $7, $7, $0, $f, $e, $e, $f, $0
; Tile graphic 22
.byt $0, $0, $0, $20, $20, $f, $20, $a
; Tile graphic 23
.byt $7, $2, $2, $0, $0, $3a, $8, $20
; Tile graphic 24
.byt $2, $2, $0, $3, $3, $39, $3, $28
; Tile graphic 25
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $0, $1, $0, $0
; Tile graphic 27
.byt $15, $a, $0, $0, $0, $34, $0, $0
; Tile graphic 28
.byt $11, $2a, $0, $0, $0, $0, $0, $0
; Tile graphic 29
.byt $10, $28, $0, $0, $0, $b, $0, $0
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $2a
; Tile graphic 31
.byt $0, $0, $0, $0, $0, $0, $0, $28
; Tile graphic 32
.byt $0, $0, $0, $0, $1, $0, $1, $0
; Tile graphic 33
.byt $5, $a, $15, $28, $10, $21, $10, $21
; Tile graphic 34
.byt $15, $20, $0, $f, $3f, $3f, $3f, $3f
; Tile graphic 35
.byt $14, $2, $1, $20, $3c, $3e, $3f, $3f
; Tile graphic 36
.byt $0, $20, $10, $0, $10, $8, $0, $8
; Tile graphic 37
.byt $1, $2, $1, $0, $1, $0, $0, $0
; Tile graphic 38
.byt $2, $21, $15, $23, $1, $19, $1d, $1f
; Tile graphic 39
.byt $3f, $3f, $38, $37, $28, $35, $3e, $3f
; Tile graphic 40
.byt $3f, $3f, $3c, $1d, $18, $1a, $3d, $3f
; Tile graphic 41
.byt $20, $20, $10, $20, $10, $20, $30, $30
; Tile graphic 42
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 43
.byt $1f, $1f, $d, $3, $3, $2, $2, $1
; Tile graphic 44
.byt $3f, $3f, $3f, $3f, $3e, $3f, $3f, $f
; Tile graphic 45
.byt $3f, $23, $37, $3f, $1, $3f, $23, $3f
; Tile graphic 46
.byt $30, $30, $30, $30, $20, $20, $0, $0
; Tile graphic 47
.byt $0, $0, $0, $0, $0, $1, $3, $1
; Tile graphic 48
.byt $8, $15, $a, $14, $38, $3c, $3c, $38
; Tile graphic 49
.byt $33, $c, $23, $10, $2, $1, $1, $0
; Tile graphic 50
.byt $24, $2, $3c, $39, $10, $14, $28, $38
; Tile graphic 51
.byt $0, $20, $10, $0, $10, $1a, $16, $1e
; Tile graphic 52
.byt $e, $f, $e, $e, $0, $0, $0, $0
; Tile graphic 53
.byt $10, $0, $0, $0, $7, $0, $1, $2
; Tile graphic 54
.byt $0, $0, $0, $0, $3f, $1, $14, $2a
; Tile graphic 55
.byt $10, $10, $0, $0, $17, $0, $5, $a
; Tile graphic 56
.byt $1e, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 57
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 58
.byt $15, $0, $24, $22, $d, $0, $0, $0
; Tile graphic 59
.byt $15, $0, $0, $0, $3, $20, $0, $0
; Tile graphic 60
.byt $0, $0, $0, $0, $20, $0, $0, $0
; Tile graphic 61
.byt $15, $a, $0, $0, $0, $2, $0, $0
; Tile graphic 62
.byt $11, $2a, $0, $8, $4, $3a, $2, $2
; Tile graphic 63
.byt $10, $28, $0, $0, $0, $1f, $0, $0
; Tile graphic 64
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 65
.byt $0, $0, $0, $0, $0, $1, $0, $1
; Tile graphic 66
.byt $0, $5, $a, $15, $28, $10, $21, $10
; Tile graphic 67
.byt $2a, $15, $20, $0, $f, $3f, $3f, $3f
; Tile graphic 68
.byt $28, $14, $2, $1, $20, $3c, $3e, $3f
; Tile graphic 69
.byt $0, $0, $20, $10, $0, $10, $8, $0
; Tile graphic 70
.byt $0, $1, $2, $1, $0, $1, $0, $0
; Tile graphic 71
.byt $21, $2, $21, $15, $23, $1, $19, $1d
; Tile graphic 72
.byt $3f, $3f, $3f, $38, $37, $28, $35, $3e
; Tile graphic 73
.byt $3f, $3f, $3f, $3c, $1d, $18, $1a, $3d
; Tile graphic 74
.byt $8, $20, $20, $10, $20, $10, $20, $30
; Tile graphic 75
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 76
.byt $1f, $1f, $1f, $d, $3, $3, $2, $2
; Tile graphic 77
.byt $3f, $3f, $3f, $3f, $3f, $3e, $3f, $3f
; Tile graphic 78
.byt $3f, $3f, $23, $37, $3f, $1, $3f, $23
; Tile graphic 79
.byt $30, $30, $30, $30, $30, $20, $20, $0
; Tile graphic 80
.byt $0, $0, $0, $0, $1, $1, $3, $3
; Tile graphic 81
.byt $1, $8, $15, $a, $24, $30, $38, $38
; Tile graphic 82
.byt $f, $33, $c, $23, $10, $2, $1, $1
; Tile graphic 83
.byt $3f, $24, $2, $3c, $39, $10, $14, $28
; Tile graphic 84
.byt $0, $0, $20, $10, $0, $10, $10, $0
; Tile graphic 85
.byt $3, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 86
.byt $24, $3e, $3d, $1b, $7, $3, $0, $1
; Tile graphic 87
.byt $0, $0, $30, $28, $18, $33, $1, $14
; Tile graphic 88
.byt $38, $10, $10, $0, $0, $17, $0, $5
; Tile graphic 89
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 90
.byt $2, $1, $0, $0, $0, $2, $0, $0
; Tile graphic 91
.byt $2a, $15, $0, $0, $0, $38, $0, $0
; Tile graphic 92
.byt $a, $15, $0, $7, $0, $0, $0, $0
; Tile graphic 93
.byt $0, $0, $0, $30, $0, $0, $0, $0
; Tile graphic 94
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 95
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 96
.byt $0, $0, $0, $0, $1, $0, $1, $0
; Tile graphic 97
.byt $1, $2, $14, $28, $19, $27, $7, $2f
; Tile graphic 98
.byt $15, $2a, $0, $0, $3f, $3f, $3f, $3f
; Tile graphic 99
.byt $10, $28, $5, $2, $30, $3c, $3e, $3f
; Tile graphic 100
.byt $0, $0, $0, $20, $0, $20, $10, $0
; Tile graphic 101
.byt $0, $0, $0, $0, $0, $1, $1, $1
; Tile graphic 102
.byt $1f, $3f, $1c, $3b, $1c, $a, $1f, $1f
; Tile graphic 103
.byt $3f, $3f, $1e, $2d, $c, $2d, $1e, $3f
; Tile graphic 104
.byt $3e, $3f, $e, $37, $a, $16, $3c, $3e
; Tile graphic 105
.byt $10, $0, $0, $0, $20, $0, $20, $20
; Tile graphic 106
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 107
.byt $3f, $3f, $1f, $1f, $f, $f, $3, $1
; Tile graphic 108
.byt $3f, $31, $3b, $3f, $0, $3f, $31, $3f
; Tile graphic 109
.byt $3f, $3f, $3e, $3e, $1c, $3c, $38, $34
; Tile graphic 110
.byt $20, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 111
.byt $0, $0, $0, $0, $0, $0, $1, $1
; Tile graphic 112
.byt $2, $9, $14, $28, $0, $0, $30, $30
; Tile graphic 113
.byt $19, $0, $3f, $e, $24, $15, $b, $e
; Tile graphic 114
.byt $a, $5, $22, $0, $22, $0, $0, $1
; Tile graphic 115
.byt $0, $0, $0, $0, $0, $0, $0, $30
; Tile graphic 116
.byt $1, $1, $0, $3, $3, $3, $3, $0
; Tile graphic 117
.byt $30, $30, $0, $30, $10, $17, $20, $5
; Tile graphic 118
.byt $4, $4, $0, $0, $0, $35, $10, $1
; Tile graphic 119
.byt $1, $1, $0, $1, $1, $34, $9, $14
; Tile graphic 120
.byt $30, $30, $0, $38, $18, $18, $38, $0
; Tile graphic 121
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 122
.byt $a, $5, $2, $5, $0, $34, $0, $0
; Tile graphic 123
.byt $22, $11, $2a, $11, $0, $0, $0, $0
; Tile graphic 124
.byt $28, $14, $28, $14, $0, $b, $0, $0
; Tile graphic 125
.byt $0, $0, $0, $0, $1, $2, $14, $28
; Tile graphic 126
.byt $0, $0, $0, $0, $15, $2a, $0, $0
; Tile graphic 127
.byt $0, $0, $0, $0, $10, $28, $5, $2
; Tile graphic 128
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 129
.byt $1, $0, $1, $0, $0, $0, $0, $0
; Tile graphic 130
.byt $19, $27, $7, $2f, $1f, $3f, $1c, $3b
; Tile graphic 131
.byt $3f, $3f, $3f, $3f, $3f, $3f, $1e, $2d
; Tile graphic 132
.byt $30, $3c, $3e, $3f, $3e, $3f, $e, $37
; Tile graphic 133
.byt $0, $20, $10, $0, $10, $0, $0, $0
; Tile graphic 134
.byt $0, $1, $1, $1, $1, $1, $0, $0
; Tile graphic 135
.byt $1c, $a, $1f, $1f, $3f, $3f, $1f, $1f
; Tile graphic 136
.byt $c, $2d, $1e, $3f, $3f, $31, $3b, $3f
; Tile graphic 137
.byt $a, $16, $3c, $3e, $3f, $3f, $3e, $3e
; Tile graphic 138
.byt $20, $0, $20, $20, $20, $20, $0, $0
; Tile graphic 139
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 140
.byt $f, $f, $3, $9, $14, $28, $11, $0
; Tile graphic 141
.byt $0, $3f, $31, $3f, $33, $0, $3f, $1c
; Tile graphic 142
.byt $1c, $3c, $38, $30, $8, $4, $a, $5
; Tile graphic 143
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 144
.byt $0, $2, $1, $1, $1, $0, $0, $0
; Tile graphic 145
.byt $11, $0, $30, $30, $30, $0, $0, $0
; Tile graphic 146
.byt $9, $2a, $34, $1c, $8, $8, $0, $0
; Tile graphic 147
.byt $0, $0, $0, $2, $0, $2, $0, $0
; Tile graphic 148
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 149
.byt $0, $b, $4, $a, $5, $a, $5, $a
; Tile graphic 150
.byt $0, $2b, $2, $20, $11, $22, $15, $22
; Tile graphic 151
.byt $0, $38, $0, $28, $10, $28, $10, $28
; Tile graphic 152
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 153
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 154
.byt $0, $b, $0, $0, $0, $0, $0, $0
; Tile graphic 155
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 156
.byt $f, $f, $3, $1, $2, $9, $14, $28
; Tile graphic 157
.byt $0, $3f, $31, $3f, $19, $0, $3f, $e
; Tile graphic 158
.byt $1c, $3c, $38, $34, $a, $5, $22, $0
; Tile graphic 159
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 160
.byt $0, $0, $0, $10, $0, $10, $0, $0
; Tile graphic 161
.byt $24, $15, $b, $e, $4, $4, $0, $0
; Tile graphic 162
.byt $22, $0, $3, $3, $3, $0, $0, $0
; Tile graphic 163
.byt $0, $10, $20, $20, $20, $0, $0, $0
; Tile graphic 164
.byt $0, $7, $0, $5, $2, $5, $2, $5
; Tile graphic 165
.byt $0, $35, $10, $1, $22, $11, $2a, $11
; Tile graphic 166
.byt $0, $34, $8, $14, $28, $14, $28, $14
; Tile graphic 167
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 168
.byt $0, $34, $0, $0, $0, $0, $0, $0
; Tile graphic 169
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 170
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 171
.byt $0, $0, $0, $0, $0, $1, $0, $1
; Tile graphic 172
.byt $0, $1, $0, $10, $20, $8, $4, $0
; Tile graphic 173
.byt $0, $0, $0, $0, $0, $0, $11, $0
; Tile graphic 174
.byt $0, $10, $0, $1, $0, $0, $14, $0
; Tile graphic 175
.byt $0, $0, $0, $0, $20, $0, $0, $10
; Tile graphic 176
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 177
.byt $4, $0, $15, $0, $11, $0, $0, $0
; Tile graphic 178
.byt $11, $0, $15, $0, $5, $0, $4, $0
; Tile graphic 179
.byt $5, $0, $1, $0, $11, $0, $10, $0
; Tile graphic 180
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 181
.byt $1, $1, $1, $0, $0, $0, $0, $0
; Tile graphic 182
.byt $0, $0, $0, $0, $12, $9, $a, $0
; Tile graphic 183
.byt $4, $0, $0, $0, $0, $0, $2a, $11
; Tile graphic 184
.byt $10, $0, $0, $0, $0, $10, $28, $0
; Tile graphic 185
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 186
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 187
.byt $8, $14, $8, $0, $8, $0, $0, $30
; Tile graphic 188
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 189
.byt $2, $5, $2, $0, $2, $0, $0, $1
; Tile graphic 190
.byt $1, $1, $1, $3, $3, $3, $3, $0
; Tile graphic 191
.byt $30, $10, $30, $30, $37, $0, $32, $5
; Tile graphic 192
.byt $0, $0, $0, $0, $3f, $0, $2a, $15
; Tile graphic 193
.byt $1, $1, $1, $1, $3d, $0, $29, $14
; Tile graphic 194
.byt $30, $10, $30, $38, $38, $18, $38, $0
; Tile graphic 195
.byt $2, $5, $2, $5, $0, $0, $0, $0
; Tile graphic 196
.byt $2a, $0, $2a, $11, $0, $0, $0, $0
; Tile graphic 197
.byt $28, $14, $28, $14, $0, $0, $0, $0
; Tile graphic 198
.byt $0, $0, $0, $0, $0, $1, $0, $10
; Tile graphic 199
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 200
.byt $0, $0, $0, $0, $0, $10, $0, $1
; Tile graphic 201
.byt $0, $1, $0, $1, $0, $0, $0, $0
; Tile graphic 202
.byt $20, $8, $4, $0, $4, $0, $15, $0
; Tile graphic 203
.byt $0, $0, $11, $0, $11, $0, $15, $0
; Tile graphic 204
.byt $0, $0, $14, $0, $5, $0, $1, $0
; Tile graphic 205
.byt $20, $0, $0, $10, $0, $0, $0, $0
; Tile graphic 206
.byt $0, $0, $0, $0, $1, $1, $1, $0
; Tile graphic 207
.byt $11, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 208
.byt $5, $0, $4, $0, $4, $0, $0, $0
; Tile graphic 209
.byt $11, $0, $10, $0, $10, $0, $0, $0
; Tile graphic 210
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 211
.byt $12, $9, $a, $0, $a, $4, $0, $0
; Tile graphic 212
.byt $0, $0, $2a, $11, $0, $0, $0, $0
; Tile graphic 213
.byt $0, $10, $28, $0, $a, $5, $0, $2
; Tile graphic 214
.byt $0, $0, $0, $0, $30, $18, $28, $30
; Tile graphic 215
.byt $0, $0, $1, $3, $3, $3, $0, $0
; Tile graphic 216
.byt $20, $0, $20, $30, $20, $20, $0, $0
; Tile graphic 217
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 218
.byt $10, $10, $0, $0, $0, $0, $0, $0
; Tile graphic 219
.byt $7, $0, $2, $5, $2, $0, $0, $0
; Tile graphic 220
.byt $3f, $0, $2a, $15, $2a, $0, $2, $1
; Tile graphic 221
.byt $3c, $0, $28, $14, $28, $14, $28, $14
; Tile graphic 222
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 223
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 224
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 225
.byt $0, $0, $0, $0, $1, $3, $2, $1
; Tile graphic 226
.byt $12, $9, $a, $10, $28, $14, $20, $28
; Tile graphic 227
.byt $0, $10, $28, $0, $2, $5, $2, $0
; Tile graphic 228
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 229
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 230
.byt $0, $0, $0, $1, $0, $0, $0, $0
; Tile graphic 231
.byt $0, $0, $30, $38, $38, $38, $0, $0
; Tile graphic 232
.byt $7, $0, $2, $5, $2, $5, $2, $5
; Tile graphic 233
.byt $3f, $0, $2a, $15, $2a, $0, $28, $10
; Tile graphic 234
.byt $3c, $0, $28, $14, $28, $0, $0, $0
; Tile graphic 235
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 236
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 237
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 238
.byt $3f, $3f, $1f, $1f, $f, $f, $7, $3
; Tile graphic 239
.byt $3f, $31, $3b, $3f, $0, $20, $3f, $31
; Tile graphic 240
.byt $3f, $3f, $3e, $3e, $1c, $3c, $3c, $38
; Tile graphic 241
.byt $1, $8, $14, $28, $0, $0, $30, $30
; Tile graphic 242
.byt $3f, $19, $0, $e, $24, $15, $b, $e
; Tile graphic 243
.byt $30, $5, $2, $0, $22, $0, $0, $1
; Tile graphic 244
.byt $3f, $3f, $3c, $3e, $3f, $30, $38, $3f
; Tile graphic 245
.byt $3e, $3e, $1e, $3e, $3e, $c, $1c, $3c
; Tile graphic 246
.byt $b, $1, $2e, $14, $22, $0, $20, $20
; Tile graphic 247
.byt $3c, $3f, $1c, $20, $7, $12, $a, $d
; Tile graphic 248
.byt $18, $38, $24, $2, $8, $2, $22, $2
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $78
; Tile mask 2
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $40
; Tile mask 3
.byt $ff, $7c, $78, $78, $70, $60, $60, $60
; Tile mask 4
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $4f, $43, $41, $40, $40, $40, $40, $40
; Tile mask 7
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 8
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $5f, $5f, $5f, $5f, $5f, $ff, $ff, $ff
; Tile mask 13
.byt $70, $70, $78, $7c, $7c, $7e, $ff, $ff
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $41, $41, $43
; Tile mask 17
.byt $7e, $7c, $78, $78, $70, $70, $70, $70
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $43, $43, $41, $40, $40, $40, $40, $40
; Tile mask 21
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 26
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $7c
; Tile mask 27
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $40, $40, $40, $40, $48, $48, $48, $7e
; Tile mask 29
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $ff, $ff, $40, $40
; Tile mask 31
.byt $ff, $ff, $ff, $ff, $ff, $ff, $47, $41
; Tile mask 32
.byt $ff, $ff, $ff, $7e, $7c, $7c, $7c, $78
; Tile mask 33
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $5f, $4f, $47, $47, $43, $43, $43, $43
; Tile mask 37
.byt $78, $78, $78, $78, $7c, $7c, $7c, $7e
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $43, $43, $43, $43, $47, $47, $47, $47
; Tile mask 42
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 43
.byt $40, $40, $60, $60, $70, $78, $78, $70
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $47, $47, $47, $47, $4f, $4f, $5f, $5f
; Tile mask 47
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $70
; Tile mask 48
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $5f, $4f, $47, $47, $41, $40, $40, $40
; Tile mask 52
.byt $60, $60, $60, $60, $71, $ff, $ff, $ff
; Tile mask 53
.byt $40, $40, $50, $70, $70, $78, $78, $78
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 55
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $40, $41, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 57
.byt $78, $78, $7e, $7e, $7c, $7c, $ff, $ff
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $61, $ff
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $61
; Tile mask 60
.byt $5f, $5f, $ff, $5f, $4f, $47, $47, $ff
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 62
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 64
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $47
; Tile mask 65
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $7c
; Tile mask 66
.byt $78, $60, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 69
.byt $ff, $5f, $4f, $47, $47, $43, $43, $43
; Tile mask 70
.byt $78, $78, $78, $78, $78, $7c, $7c, $7c
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $43, $43, $43, $43, $43, $47, $47, $47
; Tile mask 75
.byt $7e, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 76
.byt $40, $40, $40, $60, $60, $70, $78, $78
; Tile mask 77
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $47, $47, $47, $47, $47, $4f, $4f, $5f
; Tile mask 80
.byt $ff, $ff, $ff, $7e, $7c, $7c, $78, $78
; Tile mask 81
.byt $70, $60, $40, $40, $40, $40, $40, $40
; Tile mask 82
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 84
.byt $5f, $5f, $4f, $47, $47, $47, $47, $4f
; Tile mask 85
.byt $78, $7c, $7e, $ff, $ff, $ff, $ff, $ff
; Tile mask 86
.byt $40, $40, $40, $40, $60, $70, $7c, $78
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 89
.byt $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 90
.byt $78, $78, $70, $70, $60, $40, $40, $70
; Tile mask 91
.byt $40, $40, $40, $41, $47, $43, $41, $41
; Tile mask 92
.byt $40, $40, $40, $40, $40, $40, $70, $ff
; Tile mask 93
.byt $5f, $5f, $4f, $47, $43, $43, $ff, $ff
; Tile mask 94
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 95
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $4f
; Tile mask 96
.byt $ff, $ff, $ff, $7e, $7c, $7c, $78, $78
; Tile mask 97
.byt $78, $60, $40, $40, $40, $40, $40, $40
; Tile mask 98
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 99
.byt $43, $40, $40, $40, $40, $40, $40, $40
; Tile mask 100
.byt $ff, $ff, $5f, $4f, $4f, $47, $47, $47
; Tile mask 101
.byt $78, $78, $78, $78, $78, $78, $78, $78
; Tile mask 102
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 103
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 105
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 106
.byt $78, $7c, $7e, $ff, $ff, $ff, $ff, $ff
; Tile mask 107
.byt $40, $40, $40, $40, $60, $60, $70, $70
; Tile mask 108
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 109
.byt $40, $40, $40, $40, $41, $41, $43, $41
; Tile mask 110
.byt $4f, $4f, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 111
.byt $ff, $ff, $ff, $7e, $7e, $7c, $7c, $7c
; Tile mask 112
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 113
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 114
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 115
.byt $ff, $5f, $5f, $4f, $4f, $47, $47, $47
; Tile mask 116
.byt $7c, $7c, $7c, $78, $78, $78, $78, $7c
; Tile mask 117
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 118
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 119
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 120
.byt $47, $47, $47, $43, $43, $43, $43, $47
; Tile mask 121
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7e, $7e
; Tile mask 122
.byt $60, $70, $70, $60, $40, $40, $40, $40
; Tile mask 123
.byt $40, $40, $40, $44, $44, $44, $44, $5f
; Tile mask 124
.byt $41, $41, $41, $41, $40, $40, $40, $40
; Tile mask 125
.byt $ff, $ff, $ff, $7e, $78, $60, $40, $40
; Tile mask 126
.byt $ff, $ff, $ff, $40, $40, $40, $40, $40
; Tile mask 127
.byt $ff, $ff, $ff, $4f, $43, $40, $40, $40
; Tile mask 128
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $4f
; Tile mask 129
.byt $7c, $7c, $78, $78, $78, $78, $78, $78
; Tile mask 130
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 131
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 132
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 133
.byt $4f, $47, $47, $47, $47, $47, $47, $47
; Tile mask 134
.byt $78, $78, $78, $78, $78, $7c, $7e, $ff
; Tile mask 135
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 136
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 137
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 138
.byt $47, $47, $47, $47, $4f, $4f, $5f, $ff
; Tile mask 139
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7e, $7c
; Tile mask 140
.byt $60, $60, $70, $60, $40, $40, $40, $40
; Tile mask 141
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 142
.byt $41, $41, $43, $47, $41, $40, $40, $40
; Tile mask 143
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 144
.byt $7c, $78, $7c, $7c, $7c, $7e, $ff, $ff
; Tile mask 145
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 146
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 147
.byt $40, $40, $40, $40, $40, $40, $41, $43
; Tile mask 148
.byt $5f, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 149
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 150
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 151
.byt $43, $43, $43, $43, $43, $43, $43, $41
; Tile mask 152
.byt $70, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 153
.byt $58, $78, $78, $7e, $ff, $ff, $ff, $ff
; Tile mask 154
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 155
.byt $ff, $5f, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 156
.byt $60, $60, $70, $70, $60, $40, $40, $40
; Tile mask 157
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 158
.byt $41, $41, $43, $41, $40, $40, $40, $40
; Tile mask 159
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $4f
; Tile mask 160
.byt $40, $40, $40, $40, $40, $40, $60, $70
; Tile mask 161
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 162
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 163
.byt $4f, $47, $4f, $4f, $4f, $5f, $ff, $ff
; Tile mask 164
.byt $70, $70, $70, $70, $70, $70, $70, $60
; Tile mask 165
.byt $40, $40, $40, $40, $40, $40, $40, $44
; Tile mask 166
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile mask 167
.byt $ff, $7e, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 168
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 169
.byt $46, $47, $47, $5f, $ff, $ff, $ff, $ff
; Tile mask 170
.byt $43, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 171
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $78
; Tile mask 172
.byt $7e, $78, $60, $40, $40, $40, $40, $40
; Tile mask 173
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 174
.byt $4f, $43, $40, $40, $40, $40, $40, $40
; Tile mask 175
.byt $ff, $ff, $ff, $5f, $4f, $4f, $47, $47
; Tile mask 176
.byt $78, $78, $78, $78, $78, $78, $78, $78
; Tile mask 177
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 178
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 179
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 180
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 181
.byt $78, $78, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 182
.byt $40, $40, $40, $40, $40, $60, $60, $70
; Tile mask 183
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 184
.byt $40, $40, $40, $40, $40, $41, $41, $41
; Tile mask 185
.byt $47, $4f, $4f, $5f, $ff, $ff, $ff, $ff
; Tile mask 186
.byt $ff, $ff, $ff, $7e, $7e, $7c, $7c, $7c
; Tile mask 187
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 188
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 189
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 190
.byt $7c, $7c, $7c, $78, $78, $78, $78, $7c
; Tile mask 191
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 192
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 193
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 194
.byt $47, $47, $47, $43, $43, $43, $43, $47
; Tile mask 195
.byt $70, $70, $70, $60, $40, $40, $40, $40
; Tile mask 196
.byt $40, $40, $40, $44, $44, $44, $44, $5f
; Tile mask 197
.byt $41, $41, $41, $41, $40, $40, $40, $40
; Tile mask 198
.byt $ff, $ff, $ff, $ff, $7e, $78, $60, $40
; Tile mask 199
.byt $ff, $ff, $ff, $ff, $40, $40, $40, $40
; Tile mask 200
.byt $ff, $ff, $ff, $ff, $4f, $43, $40, $40
; Tile mask 201
.byt $7e, $7c, $7c, $78, $78, $78, $78, $78
; Tile mask 202
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 203
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 204
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 205
.byt $4f, $4f, $47, $47, $47, $47, $47, $47
; Tile mask 206
.byt $78, $78, $78, $78, $78, $78, $7c, $7e
; Tile mask 207
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 208
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 209
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 210
.byt $47, $47, $47, $47, $47, $4f, $4f, $5f
; Tile mask 211
.byt $40, $60, $60, $70, $60, $40, $40, $40
; Tile mask 212
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 213
.byt $40, $41, $41, $41, $40, $40, $40, $40
; Tile mask 214
.byt $ff, $ff, $ff, $4f, $47, $43, $43, $43
; Tile mask 215
.byt $7c, $7c, $78, $78, $78, $78, $7c, $ff
; Tile mask 216
.byt $40, $40, $40, $40, $40, $40, $50, $70
; Tile mask 217
.byt $40, $40, $40, $40, $41, $41, $41, $41
; Tile mask 218
.byt $47, $47, $4f, $5f, $ff, $ff, $ff, $ff
; Tile mask 219
.byt $70, $70, $70, $70, $70, $70, $70, $70
; Tile mask 220
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 221
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile mask 222
.byt $70, $78, $7c, $ff, $ff, $ff, $ff, $ff
; Tile mask 223
.byt $40, $44, $4c, $ff, $ff, $ff, $ff, $ff
; Tile mask 224
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 225
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 226
.byt $40, $60, $60, $40, $40, $40, $40, $40
; Tile mask 227
.byt $40, $41, $41, $41, $40, $40, $40, $40
; Tile mask 228
.byt $7c, $7c, $7e, $ff, $ff, $ff, $ff, $ff
; Tile mask 229
.byt $40, $40, $40, $40, $70, $70, $70, $70
; Tile mask 230
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 231
.byt $47, $47, $43, $43, $43, $43, $47, $ff
; Tile mask 232
.byt $70, $70, $70, $70, $70, $70, $70, $70
; Tile mask 233
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 234
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile mask 235
.byt $60, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 236
.byt $40, $44, $46, $5f, $ff, $ff, $ff, $ff
; Tile mask 237
.byt $41, $43, $47, $ff, $ff, $ff, $ff, $ff
; Tile mask 238
.byt $40, $40, $40, $40, $60, $60, $70, $70
; Tile mask 239
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 240
.byt $40, $40, $40, $40, $41, $41, $41, $43
; Tile mask 241
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 242
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 243
.byt $42, $40, $40, $40, $40, $40, $40, $40
; Tile mask 244
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 245
.byt $40, $40, $40, $40, $40, $41, $41, $41
; Tile mask 246
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 247
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 248
.byt $43, $43, $41, $40, $40, $40, $40, $40
res_end
.)

