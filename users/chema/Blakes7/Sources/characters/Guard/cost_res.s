.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 3
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
.byt 0, 35, 36, 37, 38
.byt 39, 40, 41, 42, 43
.byt 44, 45, 46, 47, 48
.byt 0, 49, 50, 51, 52
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 13, 14, 15, 53, 0
.byt 54, 55, 56, 20, 0
.byt 57, 58, 59, 60, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 61, 62, 63, 64, 65
.byt 66, 67, 68, 69, 70
.byt 71, 72, 73, 74, 75
.byt 76, 77, 78, 79, 80
.byt 81, 82, 83, 84, 0
.byt 85, 86, 87, 88, 89
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 90, 91, 92, 93, 94
.byt 95, 96, 97, 98, 99
.byt 100, 101, 37, 102, 0
.byt 103, 104, 105, 106, 94
.byt 107, 108, 109, 110, 111
.byt 21, 112, 113, 114, 0
; Animatory state 5 (05-stepd1.png)
.byt 115, 116, 117, 118, 0
.byt 119, 120, 121, 122, 123
.byt 124, 125, 126, 127, 0
.byt 128, 129, 130, 131, 0
.byt 132, 133, 134, 135, 136
.byt 85, 137, 138, 139, 0
.byt 0, 140, 141, 142, 0
; Animatory state 6 (06-stepd2.png)
.byt 115, 116, 117, 118, 0
.byt 119, 120, 121, 122, 123
.byt 124, 125, 126, 127, 0
.byt 143, 144, 145, 146, 147
.byt 148, 149, 150, 151, 152
.byt 153, 154, 155, 156, 0
.byt 157, 158, 159, 160, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 90, 161, 162, 93, 94
.byt 163, 164, 164, 165, 99
.byt 100, 166, 167, 168, 0
.byt 169, 170, 171, 172, 94
.byt 173, 174, 175, 176, 111
.byt 177, 178, 179, 180, 0
; Animatory state 8 (08-stepdb1.png)
.byt 115, 116, 117, 118, 0
.byt 119, 122, 122, 122, 123
.byt 181, 182, 183, 184, 0
.byt 185, 186, 187, 188, 189
.byt 190, 191, 192, 193, 160
.byt 194, 195, 196, 197, 0
.byt 198, 199, 200, 201, 0
; Animatory state 9 (09-stepdb2.png)
.byt 115, 116, 117, 118, 0
.byt 119, 122, 122, 122, 123
.byt 181, 202, 203, 184, 0
.byt 204, 205, 187, 206, 0
.byt 207, 191, 192, 208, 209
.byt 210, 211, 212, 213, 0
.byt 214, 215, 216, 217, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 90, 91, 92, 93, 94
.byt 95, 96, 97, 98, 99
.byt 100, 218, 219, 102, 0
.byt 103, 220, 221, 106, 94
.byt 107, 108, 109, 110, 111
.byt 21, 112, 113, 114, 0
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 222, 223, 0
.byt 13, 14, 224, 225, 0
.byt 17, 18, 19, 20, 0
.byt 21, 22, 23, 24, 0
; Animatory state 12 (12-rifle.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 226, 227, 228, 229, 230
.byt 231, 232, 233, 234, 235
.byt 21, 22, 23, 24, 0
; Animatory state 13 (13-coffee1.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 236
.byt 13, 14, 15, 237, 238
.byt 17, 18, 19, 239, 0
.byt 21, 22, 23, 24, 0
; Animatory state 14 (14-coffee2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 240, 241, 0
.byt 13, 14, 242, 243, 244
.byt 17, 18, 19, 245, 0
.byt 21, 22, 23, 24, 0
; Animatory state 15 (15-coffee3.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 246, 247, 0
.byt 13, 14, 248, 249, 250
.byt 17, 18, 19, 245, 0
.byt 21, 22, 23, 24, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $1f, $1f, $15
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $3e, $3e, $14
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $4
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $e, $e, $4
; Tile graphic 5
.byt $a, $15, $1f, $0, $0, $0, $0, $5
; Tile graphic 6
.byt $2a, $14, $3e, $20, $11, $10, $9, $6
; Tile graphic 7
.byt $a, $4, $0, $20, $4, $24, $4, $4
; Tile graphic 8
.byt $a, $4, $e, $0, $4, $4, $8, $10
; Tile graphic 9
.byt $2, $5, $2, $1, $0, $0, $0, $0
; Tile graphic 10
.byt $21, $10, $28, $14, $28, $14, $8, $0
; Tile graphic 11
.byt $3b, $0, $e, $11, $24, $2a, $24, $11
; Tile graphic 12
.byt $20, $0, $0, $0, $20, $20, $20, $0
; Tile graphic 13
.byt $1, $0, $0, $0, $0, $0, $1, $1e
; Tile graphic 14
.byt $10, $2c, $13, $28, $4, $22, $1, $0
; Tile graphic 15
.byt $e, $0, $0, $3f, $0, $0, $0, $20
; Tile graphic 16
.byt $0, $0, $20, $8, $0, $28, $10, $28
; Tile graphic 17
.byt $1, $0, $0, $2, $3, $0, $0, $1
; Tile graphic 18
.byt $0, $0, $20, $20, $0, $1f, $20, $0
; Tile graphic 19
.byt $10, $8, $4, $2, $1, $35, $e, $0
; Tile graphic 20
.byt $a, $8, $8, $0, $0, $34, $0, $0
; Tile graphic 21
.byt $0, $0, $0, $0, $0, $3, $0, $0
; Tile graphic 22
.byt $0, $0, $0, $0, $0, $28, $0, $0
; Tile graphic 23
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 24
.byt $0, $0, $0, $0, $0, $16, $0, $0
; Tile graphic 25
.byt $0, $0, $0, $0, $0, $1, $1, $1
; Tile graphic 26
.byt $0, $0, $0, $0, $0, $3f, $3f, $15
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $38, $38, $10
; Tile graphic 28
.byt $0, $0, $0, $0, $0, $0, $0, $10
; Tile graphic 29
.byt $0, $0, $0, $0, $0, $38, $38, $10
; Tile graphic 30
.byt $0, $1, $1, $0, $0, $0, $0, $0
; Tile graphic 31
.byt $2a, $15, $3f, $2, $1, $1, $0, $14
; Tile graphic 32
.byt $28, $10, $38, $2, $4, $2, $24, $18
; Tile graphic 33
.byt $28, $10, $0, $0, $10, $10, $10, $11
; Tile graphic 34
.byt $28, $10, $38, $0, $10, $10, $20, $0
; Tile graphic 35
.byt $a, $15, $a, $5, $2, $1, $0, $4
; Tile graphic 36
.byt $7, $0, $20, $11, $22, $12, $22, $0
; Tile graphic 37
.byt $2e, $0, $38, $4, $12, $2a, $12, $4
; Tile graphic 38
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $0, $0, $0, $0, $0, $0, $6, $1
; Tile graphic 40
.byt $3, $0, $5, $1, $4, $0, $0, $0
; Tile graphic 41
.byt $0, $20, $10, $8, $23, $10, $8, $8
; Tile graphic 42
.byt $38, $0, $2, $4, $30, $5, $2, $4
; Tile graphic 43
.byt $0, $0, $0, $0, $10, $0, $20, $20
; Tile graphic 44
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 45
.byt $0, $0, $0, $0, $0, $0, $3, $0
; Tile graphic 46
.byt $4, $2, $1, $0, $0, $3, $3c, $0
; Tile graphic 47
.byt $0, $0, $0, $20, $e, $30, $0, $0
; Tile graphic 48
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 49
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 50
.byt $0, $4, $2, $1, $c, $2, $0, $0
; Tile graphic 51
.byt $0, $0, $0, $0, $f, $0, $0, $0
; Tile graphic 52
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 53
.byt $0, $0, $20, $8, $0, $20, $10, $28
; Tile graphic 54
.byt $1, $0, $0, $2, $3, $0, $0, $0
; Tile graphic 55
.byt $0, $0, $20, $20, $0, $1f, $0, $0
; Tile graphic 56
.byt $10, $8, $4, $2, $1, $35, $0, $0
; Tile graphic 57
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 58
.byt $0, $0, $1f, $0, $0, $1, $0, $0
; Tile graphic 59
.byt $0, $8, $37, $10, $0, $30, $8, $0
; Tile graphic 60
.byt $0, $0, $0, $0, $0, $18, $0, $0
; Tile graphic 61
.byt $0, $0, $0, $0, $0, $3, $3, $2
; Tile graphic 62
.byt $0, $0, $0, $0, $0, $3f, $3f, $2a
; Tile graphic 63
.byt $0, $0, $0, $0, $0, $30, $30, $20
; Tile graphic 64
.byt $0, $0, $0, $0, $0, $1, $1, $20
; Tile graphic 65
.byt $0, $0, $0, $0, $0, $30, $30, $20
; Tile graphic 66
.byt $1, $2, $3, $0, $0, $0, $0, $0
; Tile graphic 67
.byt $15, $2a, $3f, $4, $2, $2, $1, $28
; Tile graphic 68
.byt $11, $20, $30, $4, $8, $4, $8, $30
; Tile graphic 69
.byt $11, $20, $1, $0, $20, $20, $21, $22
; Tile graphic 70
.byt $10, $20, $30, $0, $20, $20, $0, $0
; Tile graphic 71
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 72
.byt $14, $2a, $15, $a, $5, $2, $1, $0
; Tile graphic 73
.byt $f, $0, $1, $22, $4, $25, $4, $2
; Tile graphic 74
.byt $1c, $0, $30, $8, $24, $14, $24, $0
; Tile graphic 75
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 76
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 77
.byt $a, $5, $2, $5, $0, $8, $8, $0
; Tile graphic 78
.byt $1, $0, $20, $8, $23, $10, $8, $8
; Tile graphic 79
.byt $30, $2, $2, $4, $30, $4, $2, $4
; Tile graphic 80
.byt $0, $0, $0, $20, $0, $20, $0, $0
; Tile graphic 81
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 82
.byt $8, $6, $9, $1, $11, $e, $1, $0
; Tile graphic 83
.byt $4, $2, $1, $0, $0, $d, $30, $0
; Tile graphic 84
.byt $0, $0, $0, $20, $1e, $10, $0, $0
; Tile graphic 85
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 86
.byt $0, $0, $e, $1, $0, $3, $0, $0
; Tile graphic 87
.byt $0, $0, $0, $20, $0, $38, $0, $0
; Tile graphic 88
.byt $0, $3, $1c, $1, $0, $0, $0, $0
; Tile graphic 89
.byt $0, $0, $0, $30, $0, $0, $0, $0
; Tile graphic 90
.byt $0, $0, $0, $0, $0, $7, $7, $2
; Tile graphic 91
.byt $0, $0, $0, $0, $0, $3c, $3c, $28
; Tile graphic 92
.byt $0, $0, $0, $0, $0, $1, $1, $10
; Tile graphic 93
.byt $0, $0, $0, $0, $0, $3f, $3f, $2a
; Tile graphic 94
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 95
.byt $5, $2, $7, $0, $0, $0, $0, $1
; Tile graphic 96
.byt $14, $28, $3c, $0, $20, $20, $10, $c
; Tile graphic 97
.byt $29, $10, $1, $0, $10, $10, $10, $11
; Tile graphic 98
.byt $15, $2a, $3f, $0, $8, $8, $10, $24
; Tile graphic 99
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 100
.byt $0, $1, $0, $1, $0, $0, $0, $0
; Tile graphic 101
.byt $23, $0, $20, $11, $22, $12, $2, $1
; Tile graphic 102
.byt $8, $4, $8, $14, $8, $10, $0, $0
; Tile graphic 103
.byt $0, $0, $1, $0, $1, $0, $1, $0
; Tile graphic 104
.byt $20, $20, $10, $c, $6, $2, $1, $1
; Tile graphic 105
.byt $38, $0, $0, $1, $3a, $0, $0, $0
; Tile graphic 106
.byt $0, $8, $14, $24, $0, $24, $14, $20
; Tile graphic 107
.byt $1, $0, $1, $0, $1, $2, $1, $0
; Tile graphic 108
.byt $0, $0, $0, $0, $0, $1f, $0, $0
; Tile graphic 109
.byt $20, $10, $8, $4, $2, $2b, $1c, $0
; Tile graphic 110
.byt $4, $4, $0, $4, $0, $3a, $0, $0
; Tile graphic 111
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 112
.byt $0, $0, $0, $3f, $0, $10, $0, $0
; Tile graphic 113
.byt $0, $18, $10, $7, $0, $0, $0, $0
; Tile graphic 114
.byt $0, $0, $0, $38, $0, $16, $0, $0
; Tile graphic 115
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 116
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 117
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 118
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 119
.byt $0, $7, $7, $2, $5, $2, $7, $0
; Tile graphic 120
.byt $0, $3c, $3c, $28, $14, $28, $3c, $0
; Tile graphic 121
.byt $0, $1, $1, $10, $29, $10, $1, $0
; Tile graphic 122
.byt $0, $3f, $3f, $2a, $15, $2a, $3f, $0
; Tile graphic 123
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 124
.byt $0, $0, $0, $1, $0, $1, $0, $1
; Tile graphic 125
.byt $20, $20, $10, $c, $23, $0, $20, $11
; Tile graphic 126
.byt $10, $10, $10, $11, $2e, $0, $38, $4
; Tile graphic 127
.byt $8, $8, $10, $24, $8, $4, $8, $14
; Tile graphic 128
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 129
.byt $22, $12, $2, $11, $8, $24, $12, $29
; Tile graphic 130
.byt $12, $2a, $12, $4, $38, $0, $1, $1
; Tile graphic 131
.byt $8, $10, $0, $10, $24, $24, $4, $20
; Tile graphic 132
.byt $0, $7, $2, $1, $0, $0, $0, $0
; Tile graphic 133
.byt $24, $2, $21, $1, $20, $20, $0, $0
; Tile graphic 134
.byt $3a, $0, $0, $0, $20, $10, $8, $4
; Tile graphic 135
.byt $4, $20, $14, $20, $4, $0, $0, $0
; Tile graphic 136
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 137
.byt $1f, $0, $0, $0, $0, $0, $20, $1f
; Tile graphic 138
.byt $2b, $1c, $0, $0, $c, $10, $20, $7
; Tile graphic 139
.byt $38, $0, $0, $0, $0, $0, $0, $30
; Tile graphic 140
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 141
.byt $0, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 142
.byt $0, $18, $0, $0, $0, $0, $0, $0
; Tile graphic 143
.byt $0, $0, $0, $0, $1, $1, $1, $0
; Tile graphic 144
.byt $22, $12, $2, $11, $8, $4, $6, $2
; Tile graphic 145
.byt $12, $2a, $12, $4, $38, $1, $2, $3c
; Tile graphic 146
.byt $8, $10, $0, $10, $20, $0, $0, $8
; Tile graphic 147
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 148
.byt $1, $0, $1, $0, $1, $0, $0, $0
; Tile graphic 149
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 150
.byt $1, $20, $21, $10, $8, $4, $4, $2
; Tile graphic 151
.byt $8, $27, $a, $4, $8, $8, $0, $0
; Tile graphic 152
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 153
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 154
.byt $3e, $1, $0, $0, $1, $0, $0, $1f
; Tile graphic 155
.byt $2f, $30, $0, $0, $20, $10, $8, $7
; Tile graphic 156
.byt $30, $0, $0, $0, $0, $0, $8, $30
; Tile graphic 157
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 158
.byt $0, $34, $0, $0, $0, $0, $0, $0
; Tile graphic 159
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 160
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 161
.byt $0, $0, $0, $0, $0, $3f, $3f, $2a
; Tile graphic 162
.byt $0, $0, $0, $0, $0, $3f, $3f, $2a
; Tile graphic 163
.byt $5, $2, $7, $0, $0, $0, $0, $1
; Tile graphic 164
.byt $15, $2a, $3f, $0, $0, $0, $0, $0
; Tile graphic 165
.byt $15, $2a, $3f, $0, $0, $0, $0, $4
; Tile graphic 166
.byt $20, $0, $20, $14, $2a, $15, $0, $1
; Tile graphic 167
.byt $0, $0, $0, $0, $2a, $15, $0, $15
; Tile graphic 168
.byt $8, $4, $8, $14, $28, $10, $0, $0
; Tile graphic 169
.byt $0, $0, $0, $0, $0, $1, $1, $0
; Tile graphic 170
.byt $0, $0, $20, $0, $0, $0, $0, $1
; Tile graphic 171
.byt $0, $0, $1, $2, $4, $8, $30, $0
; Tile graphic 172
.byt $0, $20, $8, $0, $0, $4, $4, $4
; Tile graphic 173
.byt $1, $0, $5, $0, $0, $6, $0, $0
; Tile graphic 174
.byt $2, $4, $8, $10, $15, $0, $0, $0
; Tile graphic 175
.byt $0, $0, $0, $0, $15, $0, $0, $0
; Tile graphic 176
.byt $0, $4, $5, $0, $10, $3, $0, $0
; Tile graphic 177
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 178
.byt $0, $3, $0, $0, $3f, $0, $0, $0
; Tile graphic 179
.byt $0, $3d, $0, $0, $7, $0, $0, $0
; Tile graphic 180
.byt $0, $0, $0, $0, $38, $2, $0, $0
; Tile graphic 181
.byt $0, $0, $0, $1, $0, $1, $0, $1
; Tile graphic 182
.byt $0, $0, $0, $0, $20, $0, $20, $10
; Tile graphic 183
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 184
.byt $0, $0, $0, $4, $8, $4, $8, $14
; Tile graphic 185
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 186
.byt $2a, $15, $0, $1, $0, $20, $0, $20
; Tile graphic 187
.byt $2a, $15, $0, $15, $0, $0, $1, $2
; Tile graphic 188
.byt $28, $10, $0, $0, $10, $30, $11, $8
; Tile graphic 189
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 190
.byt $1, $1, $18, $5, $0, $1, $0, $0
; Tile graphic 191
.byt $0, $0, $0, $1, $2, $4, $8, $20
; Tile graphic 192
.byt $4, $8, $30, $0, $0, $0, $0, $0
; Tile graphic 193
.byt $0, $4, $4, $0, $0, $0, $0, $8
; Tile graphic 194
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 195
.byt $15, $0, $0, $0, $1e, $21, $0, $0
; Tile graphic 196
.byt $15, $0, $0, $0, $0, $1d, $20, $0
; Tile graphic 197
.byt $10, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 198
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 199
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 200
.byt $7, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 201
.byt $38, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 202
.byt $0, $0, $0, $0, $20, $0, $20, $14
; Tile graphic 203
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 204
.byt $0, $0, $0, $0, $0, $0, $4, $8
; Tile graphic 205
.byt $2a, $15, $0, $1, $0, $10, $10, $20
; Tile graphic 206
.byt $28, $10, $0, $0, $0, $28, $0, $8
; Tile graphic 207
.byt $0, $1, $1, $0, $0, $0, $0, $0
; Tile graphic 208
.byt $4, $4, $0, $5, $0, $4, $0, $8
; Tile graphic 209
.byt $0, $0, $30, $0, $0, $0, $0, $0
; Tile graphic 210
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 211
.byt $15, $0, $0, $0, $0, $5, $0, $0
; Tile graphic 212
.byt $15, $0, $0, $0, $3, $34, $8, $0
; Tile graphic 213
.byt $10, $0, $0, $0, $30, $8, $0, $0
; Tile graphic 214
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 215
.byt $3f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 216
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 217
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 218
.byt $23, $0, $20, $10, $21, $12, $2, $2
; Tile graphic 219
.byt $2e, $0, $0, $38, $4, $12, $2a, $12
; Tile graphic 220
.byt $21, $20, $10, $c, $6, $2, $1, $1
; Tile graphic 221
.byt $4, $38, $0, $1, $3a, $0, $0, $0
; Tile graphic 222
.byt $3b, $0, $0, $e, $11, $24, $2a, $24
; Tile graphic 223
.byt $20, $0, $0, $0, $0, $20, $20, $20
; Tile graphic 224
.byt $11, $e, $0, $3f, $0, $0, $0, $20
; Tile graphic 225
.byt $0, $0, $0, $8, $0, $28, $10, $28
; Tile graphic 226
.byt $1, $0, $0, $0, $0, $1, $0, $2
; Tile graphic 227
.byt $10, $2c, $13, $28, $4, $22, $0, $3
; Tile graphic 228
.byt $e, $0, $0, $3f, $0, $0, $3f, $c
; Tile graphic 229
.byt $0, $0, $20, $0, $0, $20, $3f, $28
; Tile graphic 230
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 231
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 232
.byt $c, $31, $1, $10, $6, $f, $0, $0
; Tile graphic 233
.byt $22, $4, $7, $38, $0, $34, $e, $0
; Tile graphic 234
.byt $28, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 235
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 236
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 237
.byt $0, $0, $20, $8, $0, $28, $10, $20
; Tile graphic 238
.byt $0, $0, $0, $0, $0, $1e, $2c, $0
; Tile graphic 239
.byt $0, $0, $0, $0, $0, $30, $0, $0
; Tile graphic 240
.byt $3b, $0, $e, $11, $24, $2a, $20, $13
; Tile graphic 241
.byt $20, $0, $0, $0, $20, $20, $0, $30
; Tile graphic 242
.byt $d, $0, $0, $3f, $0, $0, $0, $20
; Tile graphic 243
.byt $20, $10, $20, $8, $0, $28, $10, $20
; Tile graphic 244
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 245
.byt $0, $0, $0, $0, $0, $30, $0, $0
; Tile graphic 246
.byt $3b, $0, $e, $11, $24, $29, $23, $11
; Tile graphic 247
.byt $20, $0, $0, $0, $0, $20, $30, $20
; Tile graphic 248
.byt $c, $0, $0, $3f, $0, $0, $0, $20
; Tile graphic 249
.byt $0, $10, $20, $8, $0, $28, $10, $20
; Tile graphic 250
.byt $0, $0, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $7e, $7c, $78, $60, $40, $40, $40
; Tile mask 2
.byt $78, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $43, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $5f, $47, $47, $41, $40, $40, $40
; Tile mask 5
.byt $40, $40, $40, $60, $70, $70, $78, $70
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $41, $41, $41, $41, $41
; Tile mask 9
.byt $70, $70, $78, $78, $7c, $7c, $7e, $7e
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $41, $43, $43, $43, $43, $47, $47, $4f
; Tile mask 13
.byt $7c, $78, $70, $70, $60, $60, $60, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $47, $47, $43, $41, $41, $41, $41, $41
; Tile mask 17
.byt $60, $60, $40, $40, $40, $40, $40, $60
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $41, $41, $40, $40, $40, $40, $41
; Tile mask 21
.byt $7e, $7e, $ff, $7e, $7c, $78, $78, $78
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 23
.byt $40, $40, $40, $40, $50, $50, $50, $7c
; Tile mask 24
.byt $47, $4f, $47, $43, $41, $40, $40, $40
; Tile mask 25
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $7c
; Tile mask 26
.byt $ff, $78, $70, $60, $40, $40, $40, $40
; Tile mask 27
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $4f, $41, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $ff, $ff, $5f, $5f, $47, $43, $43, $43
; Tile mask 30
.byt $7c, $7c, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 31
.byt $40, $40, $40, $40, $40, $40, $60, $40
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $43, $43, $43, $47, $47, $47, $47, $47
; Tile mask 35
.byt $40, $40, $60, $60, $70, $70, $78, $70
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $47, $4f, $4f, $4f, $4f, $5f, $5f, $5f
; Tile mask 39
.byt $ff, $ff, $ff, $7e, $7c, $78, $70, $60
; Tile mask 40
.byt $60, $60, $40, $40, $40, $40, $48, $58
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $ff, $5f, $5f, $4f, $43, $41, $41, $41
; Tile mask 44
.byt $60, $60, $62, $73, $ff, $ff, $ff, $ff
; Tile mask 45
.byt $58, $58, $78, $78, $78, $78, $78, $78
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $40, $40, $40, $40, $40, $41, $41, $41
; Tile mask 48
.byt $41, $63, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 49
.byt $7c, $7c, $7c, $78, $78, $78, $ff, $ff
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $ff
; Tile mask 51
.byt $43, $43, $41, $40, $40, $40, $40, $43
; Tile mask 52
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $ff
; Tile mask 53
.byt $47, $47, $43, $41, $41, $41, $41, $41
; Tile mask 54
.byt $60, $60, $40, $40, $40, $40, $40, $60
; Tile mask 55
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $7e, $7e, $ff, $ff, $7e, $7e, $7e, $7e
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $4f, $4f, $5f, $4f, $47, $43, $41, $41
; Tile mask 61
.byt $ff, $ff, $ff, $ff, $7c, $78, $78, $78
; Tile mask 62
.byt $ff, $70, $60, $40, $40, $40, $40, $40
; Tile mask 63
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 64
.byt $5f, $43, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $ff, $ff, $ff, $ff, $4f, $47, $47, $47
; Tile mask 66
.byt $78, $78, $78, $7c, $7e, $7e, $ff, $7e
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 69
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 70
.byt $47, $47, $47, $4f, $4f, $4f, $4f, $4f
; Tile mask 71
.byt $7e, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 72
.byt $40, $40, $40, $40, $60, $60, $70, $70
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 75
.byt $4f, $5f, $5f, $5f, $5f, $ff, $ff, $ff
; Tile mask 76
.byt $ff, $ff, $7e, $7e, $7c, $7c, $7c, $7c
; Tile mask 77
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $ff, $ff, $5f, $4f, $4f, $4f, $5f, $5f
; Tile mask 81
.byt $78, $78, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 82
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 84
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 85
.byt $ff, $ff, $ff, $ff, $7e, $7e, $7e, $ff
; Tile mask 86
.byt $60, $60, $60, $40, $40, $40, $40, $60
; Tile mask 87
.byt $40, $40, $43, $4f, $47, $43, $43, $43
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $70, $ff
; Tile mask 89
.byt $5f, $5f, $4f, $47, $43, $43, $ff, $ff
; Tile mask 90
.byt $ff, $ff, $ff, $7e, $78, $70, $70, $70
; Tile mask 91
.byt $78, $60, $40, $40, $40, $40, $40, $40
; Tile mask 92
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 93
.byt $ff, $4f, $47, $43, $40, $40, $40, $40
; Tile mask 94
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 95
.byt $70, $70, $70, $78, $7c, $7c, $7e, $7c
; Tile mask 96
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 97
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 98
.byt $40, $40, $40, $40, $41, $41, $43, $41
; Tile mask 99
.byt $5f, $5f, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 100
.byt $7c, $7c, $7c, $7c, $7e, $7e, $ff, $ff
; Tile mask 101
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 102
.byt $41, $41, $41, $41, $43, $43, $47, $47
; Tile mask 103
.byt $7c, $78, $78, $78, $78, $70, $70, $70
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 106
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 107
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 108
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 109
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 110
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 111
.byt $5f, $5f, $5f, $4f, $4f, $4f, $4f, $5f
; Tile mask 112
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 113
.byt $40, $40, $40, $40, $50, $50, $50, $7c
; Tile mask 114
.byt $43, $43, $47, $43, $41, $40, $40, $40
; Tile mask 115
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 116
.byt $ff, $ff, $ff, $ff, $78, $60, $40, $40
; Tile mask 117
.byt $ff, $ff, $ff, $ff, $40, $40, $40, $40
; Tile mask 118
.byt $ff, $ff, $ff, $ff, $ff, $4f, $47, $43
; Tile mask 119
.byt $78, $70, $70, $70, $70, $70, $70, $78
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 121
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 122
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 123
.byt $ff, $5f, $5f, $5f, $5f, $5f, $5f, $ff
; Tile mask 124
.byt $7c, $7c, $7e, $7c, $7c, $7c, $7c, $7c
; Tile mask 125
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 126
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 127
.byt $41, $41, $43, $41, $41, $41, $41, $41
; Tile mask 128
.byt $7e, $7e, $ff, $7e, $7c, $78, $78, $70
; Tile mask 129
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 130
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 131
.byt $43, $43, $47, $43, $41, $40, $40, $40
; Tile mask 132
.byt $70, $60, $60, $60, $60, $70, $ff, $ff
; Tile mask 133
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 134
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 135
.byt $40, $40, $40, $40, $40, $41, $43, $43
; Tile mask 136
.byt $ff, $5f, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 137
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 138
.byt $40, $40, $40, $40, $40, $40, $40, $50
; Tile mask 139
.byt $43, $43, $43, $43, $43, $43, $43, $47
; Tile mask 140
.byt $40, $60, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 141
.byt $58, $70, $70, $70, $ff, $ff, $ff, $ff
; Tile mask 142
.byt $47, $43, $41, $41, $ff, $ff, $ff, $ff
; Tile mask 143
.byt $7e, $7e, $ff, $7e, $7c, $78, $78, $78
; Tile mask 144
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 145
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 146
.byt $43, $43, $47, $43, $41, $40, $40, $40
; Tile mask 147
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 148
.byt $78, $70, $70, $70, $78, $7c, $7e, $7e
; Tile mask 149
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 150
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 151
.byt $40, $40, $40, $40, $40, $40, $47, $47
; Tile mask 152
.byt $5f, $4f, $4f, $4f, $4f, $5f, $ff, $ff
; Tile mask 153
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7e, $ff
; Tile mask 154
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 155
.byt $40, $40, $40, $40, $40, $40, $40, $50
; Tile mask 156
.byt $47, $47, $47, $47, $43, $43, $43, $47
; Tile mask 157
.byt $ff, $7e, $7c, $7c, $ff, $ff, $ff, $ff
; Tile mask 158
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 159
.byt $70, $58, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 160
.byt $47, $4f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 161
.byt $78, $60, $40, $40, $40, $40, $40, $40
; Tile mask 162
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 163
.byt $70, $70, $70, $78, $7c, $7c, $7c, $7c
; Tile mask 164
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 165
.byt $40, $40, $40, $40, $41, $41, $41, $41
; Tile mask 166
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 167
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 168
.byt $41, $41, $41, $41, $43, $43, $47, $47
; Tile mask 169
.byt $ff, $7e, $7c, $78, $78, $70, $70, $70
; Tile mask 170
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 171
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 172
.byt $43, $43, $41, $40, $40, $40, $40, $40
; Tile mask 173
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 174
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 175
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 176
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 177
.byt $7e, $7e, $7e, $ff, $7c, $78, $78, $78
; Tile mask 178
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 179
.byt $40, $40, $40, $50, $50, $50, $50, $50
; Tile mask 180
.byt $43, $43, $43, $47, $41, $40, $40, $40
; Tile mask 181
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 182
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 183
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 184
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile mask 185
.byt $7e, $7e, $ff, $ff, $ff, $7e, $7c, $78
; Tile mask 186
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 187
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 188
.byt $43, $43, $47, $47, $42, $40, $40, $40
; Tile mask 189
.byt $ff, $ff, $ff, $ff, $5f, $4f, $47, $47
; Tile mask 190
.byt $60, $60, $40, $40, $40, $40, $62, $7e
; Tile mask 191
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 192
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 193
.byt $40, $40, $40, $43, $43, $43, $43, $43
; Tile mask 194
.byt $7e, $7e, $7e, $7e, $ff, $7e, $7e, $7e
; Tile mask 195
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 196
.byt $40, $40, $40, $40, $40, $40, $40, $50
; Tile mask 197
.byt $43, $43, $43, $43, $43, $43, $47, $47
; Tile mask 198
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 199
.byt $40, $40, $61, $ff, $ff, $ff, $ff, $ff
; Tile mask 200
.byt $50, $70, $70, $70, $ff, $ff, $ff, $ff
; Tile mask 201
.byt $41, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 202
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 203
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 204
.byt $7e, $7e, $ff, $ff, $72, $60, $40, $40
; Tile mask 205
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 206
.byt $43, $43, $47, $47, $47, $43, $41, $40
; Tile mask 207
.byt $40, $60, $78, $7e, $7e, $7e, $7e, $7e
; Tile mask 208
.byt $40, $40, $40, $40, $40, $40, $42, $43
; Tile mask 209
.byt $4f, $4f, $47, $47, $47, $47, $4f, $ff
; Tile mask 210
.byt $7e, $7e, $7e, $7e, $7e, $7e, $ff, $ff
; Tile mask 211
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 212
.byt $40, $40, $40, $40, $40, $40, $40, $50
; Tile mask 213
.byt $43, $43, $43, $43, $47, $43, $43, $43
; Tile mask 214
.byt $7c, $78, $78, $78, $ff, $ff, $ff, $ff
; Tile mask 215
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 216
.byt $50, $58, $5c, $5f, $ff, $ff, $ff, $ff
; Tile mask 217
.byt $43, $47, $4f, $ff, $ff, $ff, $ff, $ff
; Tile mask 218
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 219
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 220
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 221
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 222
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 223
.byt $41, $43, $43, $43, $43, $47, $47, $4f
; Tile mask 224
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 225
.byt $47, $47, $43, $41, $41, $41, $41, $41
; Tile mask 226
.byt $7c, $78, $70, $60, $60, $40, $40, $40
; Tile mask 227
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 228
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 229
.byt $47, $43, $43, $43, $43, $43, $40, $40
; Tile mask 230
.byt $ff, $ff, $ff, $ff, $ff, $ff, $4f, $47
; Tile mask 231
.byt $60, $60, $70, $78, $7e, $ff, $ff, $ff
; Tile mask 232
.byt $40, $40, $40, $40, $40, $60, $60, $40
; Tile mask 233
.byt $40, $40, $40, $40, $40, $41, $40, $40
; Tile mask 234
.byt $40, $47, $43, $ff, $47, $ff, $47, $47
; Tile mask 235
.byt $47, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 236
.byt $ff, $ff, $ff, $ff, $ff, $6f, $75, $6e
; Tile mask 237
.byt $47, $47, $43, $41, $40, $40, $40, $40
; Tile mask 238
.byt $75, $7e, $75, $5f, $40, $40, $41, $53
; Tile mask 239
.byt $41, $47, $47, $47, $47, $47, $47, $47
; Tile mask 240
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 241
.byt $41, $43, $43, $43, $43, $47, $47, $43
; Tile mask 242
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 243
.byt $41, $41, $40, $40, $40, $40, $40, $41
; Tile mask 244
.byt $ff, $ff, $ff, $5f, $5f, $5f, $ff, $ff
; Tile mask 245
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 246
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 247
.byt $41, $43, $43, $43, $43, $47, $43, $43
; Tile mask 248
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 249
.byt $41, $40, $40, $40, $40, $40, $41, $43
; Tile mask 250
.byt $ff, $ff, $5f, $5f, $5f, $ff, $ff, $ff
res_end
.)

