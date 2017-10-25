.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 1
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
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 13, 14, 15, 16, 0
.byt 17, 18, 19, 20, 0
.byt 21, 22, 23, 24, 0
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 25, 26, 27, 28, 29
.byt 30, 31, 32, 33, 34
.byt 35, 36, 37, 38, 39
.byt 40, 41, 42, 43, 44
.byt 45, 46, 47, 48, 49
.byt 0, 50, 51, 52, 53
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 54, 55, 56, 57, 0
.byt 58, 59, 60, 61, 0
.byt 62, 63, 64, 65, 0
.byt 13, 66, 67, 68, 0
.byt 17, 18, 19, 20, 0
.byt 69, 70, 71, 72, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 73, 74, 75, 76, 77
.byt 78, 79, 80, 81, 82
.byt 83, 84, 85, 86, 87
.byt 88, 89, 90, 91, 92
.byt 69, 93, 94, 95, 0
.byt 0, 96, 97, 98, 53
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 99, 100, 101, 102, 103
.byt 104, 105, 106, 107, 108
.byt 109, 110, 111, 112, 113
.byt 114, 115, 116, 117, 118
.byt 119, 120, 121, 122, 123
.byt 124, 125, 126, 127, 128
; Animatory state 5 (05-stepd1.png)
.byt 0, 129, 130, 131, 0
.byt 132, 133, 134, 135, 136
.byt 137, 138, 139, 140, 141
.byt 142, 143, 144, 145, 146
.byt 147, 148, 149, 150, 151
.byt 152, 153, 154, 155, 156
.byt 157, 158, 159, 160, 0
; Animatory state 6 (06-step2d.png)
.byt 0, 129, 130, 131, 0
.byt 132, 133, 134, 135, 136
.byt 137, 138, 139, 140, 141
.byt 161, 162, 144, 145, 146
.byt 163, 164, 149, 150, 165
.byt 166, 167, 154, 155, 168
.byt 0, 169, 170, 171, 172
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 25, 173, 174, 175, 176
.byt 177, 178, 179, 180, 181
.byt 182, 183, 184, 185, 186
.byt 187, 188, 189, 190, 191
.byt 192, 193, 194, 195, 196
.byt 124, 197, 198, 199, 200
; Animatory state 8 (08-stepu1.png)
.byt 0, 201, 202, 203, 204
.byt 205, 206, 207, 208, 209
.byt 177, 210, 211, 212, 213
.byt 214, 215, 216, 217, 218
.byt 219, 220, 221, 222, 223
.byt 166, 224, 225, 226, 0
.byt 0, 227, 228, 229, 230
; Animatory state 9 (09-stepu2.png)
.byt 0, 201, 202, 203, 204
.byt 205, 206, 207, 208, 209
.byt 177, 210, 211, 212, 213
.byt 231, 215, 216, 217, 218
.byt 232, 233, 221, 234, 235
.byt 0, 236, 237, 238, 156
.byt 157, 239, 240, 241, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 99, 100, 101, 102, 103
.byt 104, 105, 106, 107, 108
.byt 109, 110, 242, 112, 113
.byt 114, 115, 243, 117, 118
.byt 119, 120, 121, 122, 123
.byt 124, 125, 126, 127, 128
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 244, 12, 0
.byt 13, 245, 246, 16, 0
.byt 17, 18, 19, 20, 0
.byt 21, 22, 23, 24, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $1, $3, $7, $7, $7
; Tile graphic 2
.byt $0, $7, $3f, $3f, $3f, $3f, $3f, $3e
; Tile graphic 3
.byt $0, $31, $3b, $3f, $3b, $37, $28, $16
; Tile graphic 4
.byt $0, $30, $38, $38, $3c, $3c, $3e, $1e
; Tile graphic 5
.byt $f, $f, $f, $a, $5, $a, $4, $a
; Tile graphic 6
.byt $3d, $3b, $17, $2f, $1f, $10, $3f, $38
; Tile graphic 7
.byt $3f, $3f, $3f, $3f, $3f, $3c, $1b, $3c
; Tile graphic 8
.byt $e, $2e, $26, $34, $32, $a, $3a, $1a
; Tile graphic 9
.byt $c, $8, $c, $8, $1c, $18, $1c, $18
; Tile graphic 10
.byt $35, $3f, $3f, $3f, $3f, $3f, $1f, $f
; Tile graphic 11
.byt $1a, $3f, $3f, $3f, $33, $3f, $5, $33
; Tile graphic 12
.byt $2a, $3a, $3a, $3a, $39, $3a, $31, $32
; Tile graphic 13
.byt $14, $28, $11, $1, $1, $5, $0, $5
; Tile graphic 14
.byt $17, $2b, $4, $3, $1, $0, $3f, $0
; Tile graphic 15
.byt $3f, $3f, $3c, $2, $3c, $38, $17, $20
; Tile graphic 16
.byt $25, $9, $6, $10, $28, $20, $28, $10
; Tile graphic 17
.byt $2, $4, $a, $0, $1e, $1c, $1e, $0
; Tile graphic 18
.byt $0, $0, $0, $0, $2a, $15, $0, $0
; Tile graphic 19
.byt $10, $0, $0, $0, $3a, $1d, $0, $0
; Tile graphic 20
.byt $8, $10, $8, $4, $2c, $4, $c, $0
; Tile graphic 21
.byt $0, $0, $0, $0, $0, $7, $0, $0
; Tile graphic 22
.byt $0, $2a, $0, $0, $0, $20, $0, $4
; Tile graphic 23
.byt $0, $a, $0, $0, $0, $0, $0, $4
; Tile graphic 24
.byt $0, $20, $0, $0, $0, $3c, $0, $0
; Tile graphic 25
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 26
.byt $0, $0, $7, $f, $1f, $3f, $3f, $3f
; Tile graphic 27
.byt $0, $3e, $3f, $3f, $3f, $3e, $3d, $32
; Tile graphic 28
.byt $0, $e, $1f, $3f, $1f, $3f, $7, $33
; Tile graphic 29
.byt $0, $0, $0, $0, $20, $20, $30, $30
; Tile graphic 30
.byt $1, $1, $1, $1, $0, $1, $0, $1
; Tile graphic 31
.byt $3f, $3f, $3a, $15, $2b, $12, $27, $17
; Tile graphic 32
.byt $2f, $1f, $3f, $3f, $3f, $7, $3b, $7
; Tile graphic 33
.byt $39, $3d, $3c, $3e, $3e, $21, $1f, $23
; Tile graphic 34
.byt $30, $30, $30, $20, $10, $10, $10, $10
; Tile graphic 35
.byt $1, $1, $1, $1, $3, $3, $3, $3
; Tile graphic 36
.byt $26, $7, $27, $7, $27, $7, $23, $1
; Tile graphic 37
.byt $2b, $3f, $3f, $3f, $3e, $3f, $38, $3e
; Tile graphic 38
.byt $15, $3f, $3f, $3f, $1f, $3f, $2e, $1e
; Tile graphic 39
.byt $10, $10, $10, $10, $8, $10, $8, $10
; Tile graphic 40
.byt $2, $5, $2, $0, $0, $0, $0, $0
; Tile graphic 41
.byt $22, $5, $8, $8, $18, $28, $17, $20
; Tile graphic 42
.byt $3f, $1f, $23, $18, $f, $7, $3a, $4
; Tile graphic 43
.byt $3c, $38, $20, $11, $26, $5, $3d, $1
; Tile graphic 44
.byt $0, $0, $20, $10, $0, $30, $30, $30
; Tile graphic 45
.byt $1, $0, $3, $3, $3, $0, $0, $0
; Tile graphic 46
.byt $10, $0, $20, $20, $21, $2, $0, $0
; Tile graphic 47
.byt $2, $0, $0, $0, $17, $2b, $0, $0
; Tile graphic 48
.byt $0, $2, $0, $0, $14, $28, $0, $0
; Tile graphic 49
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 50
.byt $2, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 51
.byt $29, $10, $0, $2, $1, $2, $0, $0
; Tile graphic 52
.byt $14, $0, $0, $2, $1, $22, $0, $0
; Tile graphic 53
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 54
.byt $0, $0, $0, $1, $3, $3, $7, $7
; Tile graphic 55
.byt $0, $3, $1f, $3f, $3f, $3f, $3f, $3e
; Tile graphic 56
.byt $0, $38, $3d, $3f, $3b, $37, $28, $17
; Tile graphic 57
.byt $0, $30, $38, $3c, $3c, $3e, $3e, $1e
; Tile graphic 58
.byt $7, $f, $f, $a, $5, $a, $5, $a
; Tile graphic 59
.byt $3c, $39, $13, $27, $f, $28, $f, $c
; Tile graphic 60
.byt $3f, $3f, $3f, $3f, $3f, $1e, $2d, $1e
; Tile graphic 61
.byt $2e, $2e, $36, $34, $32, $2, $3a, $a
; Tile graphic 62
.byt $c, $a, $c, $a, $c, $1a, $1c, $18
; Tile graphic 63
.byt $a, $1f, $1f, $1f, $1f, $1f, $f, $f
; Tile graphic 64
.byt $2d, $3f, $3f, $3f, $39, $3f, $22, $39
; Tile graphic 65
.byt $12, $3a, $3a, $3a, $39, $3a, $39, $32
; Tile graphic 66
.byt $17, $29, $6, $3, $1, $0, $3f, $0
; Tile graphic 67
.byt $3f, $3f, $1c, $22, $3c, $38, $17, $20
; Tile graphic 68
.byt $35, $29, $6, $10, $28, $20, $28, $10
; Tile graphic 69
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 70
.byt $0, $a, $0, $0, $0, $1, $0, $4
; Tile graphic 71
.byt $0, $25, $20, $0, $0, $31, $0, $0
; Tile graphic 72
.byt $0, $0, $0, $0, $0, $20, $0, $0
; Tile graphic 73
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 74
.byt $0, $0, $3, $7, $1f, $1f, $3f, $3f
; Tile graphic 75
.byt $0, $3f, $3f, $3f, $3f, $3f, $3f, $3e
; Tile graphic 76
.byt $0, $c, $26, $2f, $17, $2f, $7, $3b
; Tile graphic 77
.byt $0, $0, $0, $0, $0, $20, $20, $20
; Tile graphic 78
.byt $1, $1, $1, $1, $1, $2, $1, $0
; Tile graphic 79
.byt $3f, $3e, $3d, $2a, $15, $2a, $15, $29
; Tile graphic 80
.byt $35, $2b, $1f, $3f, $3f, $21, $3e, $31
; Tile graphic 81
.byt $3d, $3c, $3e, $3e, $3e, $38, $37, $30
; Tile graphic 82
.byt $20, $20, $20, $20, $0, $0, $0, $0
; Tile graphic 83
.byt $1, $1, $1, $1, $3, $2, $3, $3
; Tile graphic 84
.byt $11, $29, $11, $23, $13, $23, $12, $22
; Tile graphic 85
.byt $2a, $3f, $3f, $3f, $3f, $3f, $3e, $3f
; Tile graphic 86
.byt $35, $3f, $3f, $3f, $27, $3f, $b, $26
; Tile graphic 87
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 88
.byt $3, $5, $2, $0, $0, $0, $0, $0
; Tile graphic 89
.byt $23, $5, $12, $2, $12, $22, $13, $28
; Tile graphic 90
.byt $1f, $27, $19, $e, $7, $3, $3d, $2
; Tile graphic 91
.byt $3e, $3d, $38, $2, $35, $24, $1d, $2
; Tile graphic 92
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 93
.byt $14, $26, $11, $b, $3, $1, $0, $0
; Tile graphic 94
.byt $1, $0, $20, $10, $32, $25, $0, $0
; Tile graphic 95
.byt $0, $2, $0, $0, $34, $18, $0, $0
; Tile graphic 96
.byt $0, $5, $0, $0, $0, $1, $0, $0
; Tile graphic 97
.byt $0, $11, $0, $0, $0, $30, $0, $0
; Tile graphic 98
.byt $0, $a, $20, $1, $2, $0, $0, $0
; Tile graphic 99
.byt $0, $0, $0, $0, $0, $1, $1, $1
; Tile graphic 100
.byt $0, $1, $f, $1f, $3f, $3f, $3f, $3f
; Tile graphic 101
.byt $0, $3c, $3e, $3f, $3e, $3d, $3a, $25
; Tile graphic 102
.byt $0, $1c, $3e, $3e, $3f, $3f, $f, $27
; Tile graphic 103
.byt $0, $0, $0, $0, $0, $0, $20, $20
; Tile graphic 104
.byt $3, $3, $3, $2, $1, $2, $1, $2
; Tile graphic 105
.byt $3f, $3e, $35, $2b, $17, $28, $f, $2c
; Tile graphic 106
.byt $1f, $3f, $3f, $3f, $3f, $1f, $2e, $1f
; Tile graphic 107
.byt $33, $3b, $39, $3d, $3c, $2, $3e, $6
; Tile graphic 108
.byt $20, $30, $30, $10, $20, $10, $20, $10
; Tile graphic 109
.byt $3, $2, $3, $2, $7, $6, $7, $6
; Tile graphic 110
.byt $a, $f, $f, $f, $f, $f, $7, $3
; Tile graphic 111
.byt $2e, $3f, $3f, $3f, $39, $3f, $22, $39
; Tile graphic 112
.byt $2a, $3e, $3e, $3e, $3e, $3e, $3c, $3c
; Tile graphic 113
.byt $20, $30, $10, $38, $18, $28, $10, $28
; Tile graphic 114
.byt $5, $2, $4, $0, $0, $1, $0, $1
; Tile graphic 115
.byt $5, $a, $11, $10, $10, $10, $f, $10
; Tile graphic 116
.byt $3f, $3f, $f, $30, $1f, $e, $35, $a
; Tile graphic 117
.byt $39, $32, $5, $29, $11, $21, $3e, $0
; Tile graphic 118
.byt $10, $18, $20, $0, $10, $0, $10, $20
; Tile graphic 119
.byt $0, $1, $2, $0, $7, $7, $7, $0
; Tile graphic 120
.byt $20, $0, $20, $0, $2a, $5, $20, $0
; Tile graphic 121
.byt $4, $0, $0, $0, $2f, $17, $0, $0
; Tile graphic 122
.byt $1, $0, $1, $0, $15, $2a, $0, $0
; Tile graphic 123
.byt $10, $20, $10, $0, $3c, $c, $3c, $0
; Tile graphic 124
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 125
.byt $0, $a, $0, $0, $0, $3c, $0, $0
; Tile graphic 126
.byt $0, $2a, $0, $0, $0, $0, $0, $20
; Tile graphic 127
.byt $0, $2a, $0, $0, $0, $7, $0, $20
; Tile graphic 128
.byt $0, $0, $0, $0, $0, $20, $0, $0
; Tile graphic 129
.byt $0, $0, $0, $0, $0, $1, $f, $1f
; Tile graphic 130
.byt $0, $0, $0, $0, $0, $3c, $3e, $3f
; Tile graphic 131
.byt $0, $0, $0, $0, $0, $1c, $3e, $3e
; Tile graphic 132
.byt $0, $1, $1, $1, $3, $3, $3, $2
; Tile graphic 133
.byt $3f, $3f, $3f, $3f, $3f, $3e, $35, $2b
; Tile graphic 134
.byt $3e, $3d, $3a, $25, $1f, $3f, $3f, $3f
; Tile graphic 135
.byt $3f, $3f, $f, $27, $33, $3b, $39, $3d
; Tile graphic 136
.byt $0, $0, $20, $20, $20, $30, $30, $10
; Tile graphic 137
.byt $1, $2, $1, $2, $3, $2, $3, $2
; Tile graphic 138
.byt $17, $28, $f, $2c, $a, $f, $f, $f
; Tile graphic 139
.byt $3f, $1f, $2e, $1f, $2e, $3f, $3f, $3f
; Tile graphic 140
.byt $3c, $2, $3e, $6, $2a, $3e, $3e, $3e
; Tile graphic 141
.byt $20, $10, $20, $10, $20, $30, $10, $38
; Tile graphic 142
.byt $7, $6, $7, $6, $5, $2, $4, $0
; Tile graphic 143
.byt $f, $f, $7, $3, $5, $a, $11, $10
; Tile graphic 144
.byt $39, $3f, $22, $39, $3f, $3f, $f, $30
; Tile graphic 145
.byt $3e, $3e, $3c, $3c, $39, $32, $5, $29
; Tile graphic 146
.byt $18, $28, $10, $28, $10, $18, $20, $0
; Tile graphic 147
.byt $0, $1, $0, $1, $0, $1, $0, $0
; Tile graphic 148
.byt $10, $10, $f, $10, $20, $0, $20, $0
; Tile graphic 149
.byt $1f, $e, $35, $a, $4, $0, $0, $0
; Tile graphic 150
.byt $11, $21, $3e, $0, $1, $0, $0, $1
; Tile graphic 151
.byt $10, $0, $10, $20, $10, $0, $38, $38
; Tile graphic 152
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 153
.byt $2a, $5, $0, $0, $0, $a, $0, $0
; Tile graphic 154
.byt $2f, $17, $0, $0, $0, $2a, $0, $0
; Tile graphic 155
.byt $15, $2a, $0, $0, $0, $2a, $0, $0
; Tile graphic 156
.byt $38, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 157
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 158
.byt $0, $3c, $0, $0, $0, $0, $0, $0
; Tile graphic 159
.byt $0, $0, $0, $20, $0, $0, $0, $0
; Tile graphic 160
.byt $14, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 161
.byt $7, $6, $7, $6, $5, $2, $6, $4
; Tile graphic 162
.byt $f, $f, $7, $3, $5, $a, $31, $10
; Tile graphic 163
.byt $1, $0, $1, $0, $1, $0, $3, $3
; Tile graphic 164
.byt $10, $10, $f, $20, $10, $0, $20, $30
; Tile graphic 165
.byt $0, $10, $0, $10, $20, $10, $20, $0
; Tile graphic 166
.byt $3, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 167
.byt $32, $5, $0, $0, $0, $a, $0, $0
; Tile graphic 168
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 169
.byt $5, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 170
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 171
.byt $0, $7, $0, $20, $0, $0, $0, $0
; Tile graphic 172
.byt $0, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 173
.byt $0, $0, $7, $f, $1f, $3e, $1e, $3d
; Tile graphic 174
.byt $0, $3e, $3f, $3f, $1f, $3f, $3f, $3f
; Tile graphic 175
.byt $0, $4, $1a, $35, $3a, $3d, $3a, $3b
; Tile graphic 176
.byt $0, $0, $0, $0, $20, $0, $20, $10
; Tile graphic 177
.byt $1, $0, $1, $0, $1, $0, $1, $0
; Tile graphic 178
.byt $1d, $3d, $3d, $3d, $3d, $3b, $3b, $3b
; Tile graphic 179
.byt $3f, $3f, $3f, $3f, $3b, $3b, $3b, $1b
; Tile graphic 180
.byt $3d, $3d, $3d, $2d, $2e, $2e, $2e, $36
; Tile graphic 181
.byt $20, $10, $20, $30, $20, $30, $20, $30
; Tile graphic 182
.byt $1, $0, $1, $0, $1, $2, $1, $3
; Tile graphic 183
.byt $37, $37, $3f, $37, $37, $37, $3f, $d
; Tile graphic 184
.byt $3b, $1b, $37, $17, $35, $17, $35, $e
; Tile graphic 185
.byt $16, $36, $16, $36, $17, $37, $1b, $3b
; Tile graphic 186
.byt $20, $30, $20, $30, $20, $10, $20, $10
; Tile graphic 187
.byt $2, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 188
.byt $22, $5, $8, $8, $8, $28, $7, $20
; Tile graphic 189
.byt $2d, $a, $24, $10, $0, $0, $3f, $0
; Tile graphic 190
.byt $1a, $29, $10, $22, $5, $4, $3d, $2
; Tile graphic 191
.byt $20, $0, $30, $0, $0, $0, $0, $0
; Tile graphic 192
.byt $0, $0, $1, $0, $3, $3, $3, $0
; Tile graphic 193
.byt $10, $20, $0, $0, $25, $22, $20, $0
; Tile graphic 194
.byt $0, $0, $0, $0, $15, $2a, $0, $0
; Tile graphic 195
.byt $1, $0, $1, $0, $15, $28, $1, $0
; Tile graphic 196
.byt $0, $0, $0, $20, $20, $20, $20, $0
; Tile graphic 197
.byt $0, $5, $0, $0, $0, $0, $0, $0
; Tile graphic 198
.byt $0, $11, $0, $0, $0, $0, $0, $0
; Tile graphic 199
.byt $0, $14, $0, $0, $0, $0, $0, $0
; Tile graphic 200
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 201
.byt $0, $0, $0, $0, $0, $0, $7, $f
; Tile graphic 202
.byt $0, $0, $0, $0, $0, $3e, $3f, $3f
; Tile graphic 203
.byt $0, $0, $0, $0, $0, $4, $1a, $35
; Tile graphic 204
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 205
.byt $0, $0, $0, $0, $1, $0, $1, $0
; Tile graphic 206
.byt $1f, $3e, $1e, $3d, $1d, $3d, $3d, $3d
; Tile graphic 207
.byt $1f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 208
.byt $3a, $3d, $3a, $3b, $3d, $3d, $3d, $2d
; Tile graphic 209
.byt $20, $0, $20, $10, $20, $10, $20, $30
; Tile graphic 210
.byt $3d, $3b, $3b, $3b, $37, $37, $3f, $37
; Tile graphic 211
.byt $3b, $3b, $3b, $1b, $3b, $1b, $37, $17
; Tile graphic 212
.byt $2e, $2e, $2e, $36, $16, $36, $16, $36
; Tile graphic 213
.byt $20, $30, $20, $30, $20, $30, $20, $30
; Tile graphic 214
.byt $1, $2, $1, $3, $2, $1, $0, $0
; Tile graphic 215
.byt $37, $37, $3f, $d, $22, $5, $8, $8
; Tile graphic 216
.byt $35, $17, $35, $e, $2d, $a, $24, $10
; Tile graphic 217
.byt $17, $37, $1b, $3b, $1a, $29, $10, $22
; Tile graphic 218
.byt $20, $10, $20, $10, $20, $0, $30, $0
; Tile graphic 219
.byt $0, $0, $0, $0, $0, $0, $3, $3
; Tile graphic 220
.byt $8, $28, $7, $20, $10, $0, $20, $20
; Tile graphic 221
.byt $0, $0, $3f, $0, $0, $0, $0, $0
; Tile graphic 222
.byt $5, $4, $3d, $2, $1, $0, $1, $0
; Tile graphic 223
.byt $0, $18, $18, $8, $0, $0, $0, $0
; Tile graphic 224
.byt $25, $a, $0, $0, $0, $7, $8, $0
; Tile graphic 225
.byt $15, $2a, $0, $0, $0, $21, $10, $8
; Tile graphic 226
.byt $15, $2a, $0, $0, $0, $14, $0, $0
; Tile graphic 227
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 228
.byt $8, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 229
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 230
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 231
.byt $1, $2, $1, $3, $2, $1, $0, $0
; Tile graphic 232
.byt $0, $3, $3, $2, $0, $0, $0, $0
; Tile graphic 233
.byt $8, $8, $17, $0, $10, $0, $10, $0
; Tile graphic 234
.byt $5, $4, $3c, $2, $1, $0, $0, $0
; Tile graphic 235
.byt $0, $20, $0, $20, $0, $0, $38, $38
; Tile graphic 236
.byt $15, $a, $0, $0, $0, $5, $0, $0
; Tile graphic 237
.byt $15, $2a, $0, $0, $0, $10, $1, $2
; Tile graphic 238
.byt $14, $2a, $0, $0, $0, $3c, $2, $0
; Tile graphic 239
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 240
.byt $2, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 241
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 242
.byt $2e, $3f, $3f, $3f, $39, $3f, $30, $30
; Tile graphic 243
.byt $39, $3f, $f, $30, $1f, $e, $35, $a
; Tile graphic 244
.byt $1a, $3f, $3f, $3f, $33, $3f, $21, $21
; Tile graphic 245
.byt $7, $23, $5, $2, $1, $0, $3f, $0
; Tile graphic 246
.byt $33, $3f, $3e, $1c, $2, $38, $17, $20
costume_masks
; Tile mask 1
.byt $ff, $ff, $7e, $7c, $78, $70, $70, $70
; Tile mask 2
.byt $78, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $4e, $44, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $4f, $47, $43, $43, $41, $41, $40, $40
; Tile mask 5
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $41, $40, $40, $40, $40
; Tile mask 9
.byt $60, $60, $60, $60, $40, $40, $40, $40
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $78, $78, $70, $70, $70
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $41, $43, $43, $43, $43
; Tile mask 17
.byt $70, $60, $60, $60, $40, $40, $40, $60
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $43, $43, $43, $41, $41, $41, $41, $43
; Tile mask 21
.byt $7e, $7e, $7e, $7c, $78, $70, $60, $60
; Tile mask 22
.byt $40, $40, $41, $41, $40, $40, $40, $41
; Tile mask 23
.byt $40, $60, $70, $70, $60, $60, $60, $70
; Tile mask 24
.byt $4f, $4f, $4f, $47, $43, $41, $40, $40
; Tile mask 25
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7e, $7e
; Tile mask 26
.byt $ff, $78, $70, $60, $40, $40, $40, $40
; Tile mask 27
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $71, $60, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $ff, $ff, $5f, $5f, $4f, $4f, $47, $47
; Tile mask 30
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 31
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $47, $47, $47, $4f, $47, $47, $47, $47
; Tile mask 35
.byt $7c, $7c, $7c, $7c, $78, $78, $78, $78
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 40
.byt $78, $78, $78, $ff, $ff, $7e, $7e, $7e
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $4f, $4f, $47, $47, $47, $47, $47, $47
; Tile mask 45
.byt $7c, $7c, $78, $78, $78, $7c, $ff, $ff
; Tile mask 46
.byt $40, $40, $40, $40, $48, $58, $78, $78
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $40, $40, $40, $41, $41, $41, $41, $41
; Tile mask 49
.byt $4f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 50
.byt $78, $ff, $ff, $ff, $7e, $7e, $7e, $ff
; Tile mask 51
.byt $40, $40, $40, $40, $40, $40, $40, $50
; Tile mask 52
.byt $41, $43, $43, $40, $40, $40, $60, $53
; Tile mask 53
.byt $ff, $ff, $ff, $5f, $4f, $5f, $ff, $ff
; Tile mask 54
.byt $ff, $ff, $7e, $7c, $78, $78, $70, $70
; Tile mask 55
.byt $7c, $60, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $47, $42, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $4f, $47, $43, $41, $41, $40, $40, $40
; Tile mask 58
.byt $70, $60, $60, $60, $60, $60, $60, $60
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $40, $40, $41, $40, $40, $40, $40
; Tile mask 62
.byt $60, $60, $60, $60, $60, $40, $40, $40
; Tile mask 63
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 64
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $40, $40, $40, $41, $43, $43, $43, $43
; Tile mask 69
.byt $7e, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 70
.byt $40, $60, $70, $70, $60, $60, $60, $70
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $4f, $5f, $5f, $ff, $5f, $4f, $47, $47
; Tile mask 73
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7e
; Tile mask 74
.byt $ff, $7c, $78, $60, $40, $40, $40, $40
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $73, $41, $40, $40, $40, $40, $40, $40
; Tile mask 77
.byt $ff, $ff, $ff, $5f, $5f, $4f, $4f, $4f
; Tile mask 78
.byt $7c, $7c, $7c, $7c, $7c, $78, $7c, $7c
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 81
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 82
.byt $4f, $4f, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 83
.byt $7c, $7c, $7c, $7c, $78, $78, $78, $78
; Tile mask 84
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 85
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 86
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 87
.byt $4f, $4f, $4f, $4f, $5f, $5f, $5f, $ff
; Tile mask 88
.byt $78, $78, $78, $ff, $ff, $7e, $7e, $7e
; Tile mask 89
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 90
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 91
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 92
.byt $ff, $5f, $ff, $5f, $5f, $5f, $5f, $5f
; Tile mask 93
.byt $40, $40, $40, $60, $70, $78, $78, $78
; Tile mask 94
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 95
.byt $40, $40, $40, $41, $41, $41, $41, $41
; Tile mask 96
.byt $70, $70, $70, $70, $60, $60, $74, $7c
; Tile mask 97
.byt $40, $44, $4c, $4c, $4e, $46, $43, $43
; Tile mask 98
.byt $41, $41, $40, $40, $40, $40, $51, $ff
; Tile mask 99
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $7c
; Tile mask 100
.byt $7e, $70, $60, $40, $40, $40, $40, $40
; Tile mask 101
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 102
.byt $63, $41, $40, $40, $40, $40, $40, $40
; Tile mask 103
.byt $ff, $ff, $ff, $ff, $5f, $5f, $4f, $4f
; Tile mask 104
.byt $78, $78, $78, $78, $78, $78, $78, $78
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 106
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 107
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 108
.byt $4f, $47, $47, $47, $47, $47, $47, $47
; Tile mask 109
.byt $78, $78, $78, $78, $70, $70, $70, $70
; Tile mask 110
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 111
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 112
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 113
.byt $47, $47, $47, $43, $43, $43, $43, $47
; Tile mask 114
.byt $70, $78, $70, $7e, $7e, $7c, $7c, $7c
; Tile mask 115
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 117
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 118
.byt $43, $43, $47, $4f, $47, $47, $47, $47
; Tile mask 119
.byt $7c, $78, $78, $78, $70, $70, $70, $78
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 121
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 122
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 123
.byt $47, $47, $47, $43, $41, $41, $41, $43
; Tile mask 124
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7c, $7c
; Tile mask 125
.byt $60, $60, $70, $60, $40, $40, $40, $40
; Tile mask 126
.byt $40, $40, $4e, $4e, $44, $44, $44, $4e
; Tile mask 127
.byt $40, $40, $41, $40, $40, $40, $40, $40
; Tile mask 128
.byt $ff, $ff, $ff, $ff, $5f, $4f, $47, $47
; Tile mask 129
.byt $ff, $ff, $ff, $ff, $7e, $70, $60, $40
; Tile mask 130
.byt $ff, $ff, $ff, $ff, $43, $41, $40, $40
; Tile mask 131
.byt $ff, $ff, $ff, $ff, $63, $41, $40, $40
; Tile mask 132
.byt $7e, $7c, $7c, $7c, $78, $78, $78, $78
; Tile mask 133
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 134
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 135
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 136
.byt $5f, $5f, $4f, $4f, $4f, $47, $47, $47
; Tile mask 137
.byt $78, $78, $78, $78, $78, $78, $78, $78
; Tile mask 138
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 139
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 140
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 141
.byt $47, $47, $47, $47, $47, $47, $47, $43
; Tile mask 142
.byt $70, $70, $70, $70, $70, $78, $70, $7e
; Tile mask 143
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 144
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 145
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 146
.byt $43, $43, $43, $47, $43, $43, $47, $4f
; Tile mask 147
.byt $7e, $7c, $7c, $7c, $7c, $7c, $7e, $7e
; Tile mask 148
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 149
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 150
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 151
.byt $47, $47, $47, $47, $47, $47, $43, $43
; Tile mask 152
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 153
.byt $40, $40, $60, $60, $60, $60, $70, $60
; Tile mask 154
.byt $40, $40, $40, $40, $40, $40, $4e, $4e
; Tile mask 155
.byt $40, $40, $40, $40, $40, $40, $41, $40
; Tile mask 156
.byt $43, $47, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 157
.byt $ff, $7e, $7c, $7c, $ff, $ff, $ff, $ff
; Tile mask 158
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 159
.byt $46, $47, $47, $4f, $ff, $ff, $ff, $ff
; Tile mask 160
.byt $40, $41, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 161
.byt $70, $70, $70, $70, $70, $78, $70, $78
; Tile mask 162
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 163
.byt $7c, $7c, $7c, $7c, $7c, $7c, $78, $78
; Tile mask 164
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 165
.byt $4f, $47, $47, $47, $47, $47, $4f, $4f
; Tile mask 166
.byt $78, $7c, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 167
.byt $40, $40, $60, $60, $60, $60, $70, $60
; Tile mask 168
.byt $4f, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 169
.byt $60, $70, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 170
.byt $4c, $5c, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 171
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 172
.byt $5f, $4f, $47, $47, $ff, $ff, $ff, $ff
; Tile mask 173
.byt $ff, $78, $70, $60, $40, $40, $40, $40
; Tile mask 174
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 175
.byt $71, $60, $40, $40, $40, $40, $40, $40
; Tile mask 176
.byt $ff, $ff, $5f, $5f, $4f, $4f, $47, $47
; Tile mask 177
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 178
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 179
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 180
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 181
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 182
.byt $7c, $7c, $7c, $7c, $78, $78, $78, $78
; Tile mask 183
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 184
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 185
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 186
.byt $47, $47, $47, $47, $4f, $47, $4f, $47
; Tile mask 187
.byt $78, $7c, $7a, $ff, $ff, $7e, $7e, $7e
; Tile mask 188
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 189
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 190
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 191
.byt $4f, $4f, $47, $4f, $5f, $5f, $5f, $5f
; Tile mask 192
.byt $7e, $7c, $7c, $7c, $78, $78, $78, $7c
; Tile mask 193
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 194
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 195
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 196
.byt $5f, $5f, $5f, $4f, $4f, $4f, $4f, $5f
; Tile mask 197
.byt $70, $70, $70, $60, $40, $40, $40, $40
; Tile mask 198
.byt $40, $44, $4e, $4e, $44, $44, $44, $6e
; Tile mask 199
.byt $41, $41, $41, $40, $40, $40, $40, $60
; Tile mask 200
.byt $ff, $ff, $ff, $ff, $5f, $4f, $47, $47
; Tile mask 201
.byt $ff, $ff, $ff, $ff, $ff, $78, $70, $60
; Tile mask 202
.byt $ff, $ff, $ff, $ff, $41, $40, $40, $40
; Tile mask 203
.byt $ff, $ff, $ff, $ff, $71, $60, $40, $40
; Tile mask 204
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f
; Tile mask 205
.byt $ff, $7e, $7e, $7e, $7c, $7c, $7c, $7c
; Tile mask 206
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 207
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 208
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 209
.byt $4f, $4f, $47, $47, $47, $47, $47, $47
; Tile mask 210
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 211
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 212
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 213
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 214
.byt $78, $78, $78, $78, $78, $7c, $7a, $ff
; Tile mask 215
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 216
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 217
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 218
.byt $4f, $47, $4f, $47, $4f, $4f, $47, $4f
; Tile mask 219
.byt $ff, $7e, $7e, $7e, $7e, $7c, $78, $78
; Tile mask 220
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 221
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 222
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 223
.byt $47, $43, $43, $43, $47, $4f, $5f, $5f
; Tile mask 224
.byt $40, $40, $70, $70, $70, $70, $60, $60
; Tile mask 225
.byt $40, $40, $40, $40, $40, $44, $46, $46
; Tile mask 226
.byt $40, $40, $41, $41, $41, $41, $41, $40
; Tile mask 227
.byt $70, $70, $78, $7c, $ff, $ff, $ff, $ff
; Tile mask 228
.byt $44, $4c, $5c, $7e, $ff, $ff, $ff, $ff
; Tile mask 229
.byt $40, $40, $40, $60, $ff, $ff, $ff, $ff
; Tile mask 230
.byt $5f, $4f, $47, $47, $ff, $ff, $ff, $ff
; Tile mask 231
.byt $78, $78, $78, $78, $78, $7c, $7a, $7e
; Tile mask 232
.byt $7c, $78, $78, $78, $7c, $7e, $ff, $ff
; Tile mask 233
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 234
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 235
.byt $47, $4f, $4f, $4f, $4f, $47, $43, $43
; Tile mask 236
.byt $60, $60, $70, $70, $70, $70, $70, $60
; Tile mask 237
.byt $40, $40, $40, $40, $40, $44, $4c, $4c
; Tile mask 238
.byt $40, $40, $41, $41, $41, $41, $40, $40
; Tile mask 239
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 240
.byt $44, $46, $47, $6f, $ff, $ff, $ff, $ff
; Tile mask 241
.byt $41, $41, $43, $67, $ff, $ff, $ff, $ff
; Tile mask 242
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 243
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 244
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 245
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 246
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

