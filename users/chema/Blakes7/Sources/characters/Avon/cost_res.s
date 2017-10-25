.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 11
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
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 16, 17, 18, 19, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 31, 32, 33, 34, 35
.byt 36, 37, 38, 39, 40
.byt 41, 42, 43, 44, 45
.byt 46, 47, 48, 49, 50
.byt 51, 52, 53, 54, 55
.byt 0, 56, 57, 58, 59
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 16, 17, 18, 19, 20
.byt 21, 22, 23, 24, 25
.byt 60, 61, 62, 29, 30
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 31, 32, 33, 34, 35
.byt 36, 37, 38, 39, 40
.byt 41, 42, 43, 44, 45
.byt 63, 64, 65, 49, 66
.byt 67, 68, 69, 54, 70
.byt 0, 71, 72, 73, 74
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 75, 76, 77, 78, 79
.byt 80, 81, 82, 83, 84
.byt 85, 86, 87, 88, 89
.byt 90, 91, 92, 93, 94
.byt 95, 96, 97, 98, 99
.byt 100, 101, 102, 103, 30
; Animatory state 5 (05-stepd1.png)
.byt 0, 104, 105, 106, 0
.byt 107, 108, 109, 110, 111
.byt 112, 113, 114, 115, 116
.byt 117, 118, 119, 120, 15
.byt 121, 122, 123, 124, 125
.byt 126, 127, 128, 129, 15
.byt 0, 130, 131, 132, 133
; Animatory state 6 (06-stepd2.png)
.byt 0, 104, 105, 106, 0
.byt 107, 108, 109, 110, 111
.byt 112, 113, 114, 115, 116
.byt 117, 118, 119, 120, 15
.byt 134, 135, 123, 136, 137
.byt 138, 139, 128, 140, 141
.byt 142, 143, 144, 145, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 46, 146, 147, 148, 5
.byt 149, 150, 151, 152, 153
.byt 154, 155, 156, 157, 158
.byt 159, 160, 161, 162, 94
.byt 163, 164, 164, 165, 166
.byt 167, 23, 168, 169, 30
; Animatory state 8 (08-stepdb1.png)
.byt 0, 170, 171, 79, 0
.byt 172, 173, 174, 175, 176
.byt 177, 178, 179, 180, 181
.byt 182, 183, 184, 185, 186
.byt 187, 188, 23, 189, 190
.byt 0, 191, 192, 193, 0
.byt 0, 194, 195, 196, 133
; Animatory state 9 (09-stepdb2.png)
.byt 0, 170, 171, 79, 0
.byt 172, 173, 174, 175, 176
.byt 177, 178, 179, 180, 181
.byt 197, 198, 184, 199, 15
.byt 200, 201, 23, 202, 203
.byt 0, 191, 204, 193, 0
.byt 142, 196, 205, 206, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 75, 76, 77, 78, 79
.byt 80, 81, 82, 83, 84
.byt 85, 86, 207, 208, 89
.byt 90, 209, 210, 211, 94
.byt 95, 96, 97, 98, 99
.byt 100, 101, 102, 103, 30
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 212, 213, 15
.byt 16, 214, 215, 216, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $1, $2
; Tile graphic 2
.byt $0, $0, $5, $a, $15, $2a, $10, $20
; Tile graphic 3
.byt $0, $28, $15, $2a, $11, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $0, $28, $14, $8, $0, $0
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $1, $2, $5, $a, $4, $a, $5, $8
; Tile graphic 7
.byt $3, $7, $f, $f, $e, $1d, $1f, $3e
; Tile graphic 8
.byt $29, $3f, $3f, $3f, $7, $3b, $3, $2b
; Tile graphic 9
.byt $1d, $3c, $3e, $3e, $22, $1c, $2, $14
; Tile graphic 10
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 11
.byt $2, $6, $7, $3, $0, $0, $0, $0
; Tile graphic 12
.byt $1f, $2f, $2f, $3f, $3f, $f, $1f, $7
; Tile graphic 13
.byt $37, $3f, $3f, $3c, $3e, $3f, $31, $3f
; Tile graphic 14
.byt $26, $3e, $3e, $1e, $3e, $3e, $e, $3c
; Tile graphic 15
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $0, $0, $0, $0, $2, $3, $0, $0
; Tile graphic 17
.byt $b, $5, $a, $2c, $31, $8, $30, $9
; Tile graphic 18
.byt $3c, $3f, $7, $38, $6, $38, $3f, $0
; Tile graphic 19
.byt $18, $38, $30, $4, $22, $5, $22, $14
; Tile graphic 20
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 21
.byt $0, $7, $0, $f, $e, $e, $f, $0
; Tile graphic 22
.byt $10, $11, $10, $29, $28, $0, $20, $0
; Tile graphic 23
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 24
.byt $4, $14, $4, $13, $3, $1, $3, $0
; Tile graphic 25
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $0, $3, $0, $0
; Tile graphic 27
.byt $2a, $0, $0, $0, $0, $28, $0, $0
; Tile graphic 28
.byt $2a, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 29
.byt $28, $0, $0, $0, $0, $1f, $0, $0
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 31
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 32
.byt $0, $0, $0, $1, $2, $5, $a, $14
; Tile graphic 33
.byt $0, $5, $2a, $15, $2a, $10, $0, $0
; Tile graphic 34
.byt $0, $0, $28, $15, $a, $1, $0, $0
; Tile graphic 35
.byt $0, $0, $0, $0, $20, $0, $0, $0
; Tile graphic 36
.byt $0, $0, $0, $1, $0, $1, $0, $1
; Tile graphic 37
.byt $8, $10, $29, $11, $21, $13, $2b, $7
; Tile graphic 38
.byt $1d, $3f, $3f, $3f, $30, $2f, $38, $35
; Tile graphic 39
.byt $b, $3f, $3f, $3f, $3c, $1b, $18, $1a
; Tile graphic 40
.byt $28, $20, $30, $30, $10, $20, $10, $20
; Tile graphic 41
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 42
.byt $13, $35, $3d, $1f, $7, $1, $3, $0
; Tile graphic 43
.byt $3e, $3f, $3f, $3f, $3f, $3f, $3e, $3f
; Tile graphic 44
.byt $3c, $3f, $3f, $23, $37, $3f, $9, $3f
; Tile graphic 45
.byt $30, $30, $30, $30, $30, $30, $30, $20
; Tile graphic 46
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 47
.byt $1, $0, $1, $5, $6, $1, $0, $0
; Tile graphic 48
.byt $1f, $2f, $10, $27, $8, $27, $7, $28
; Tile graphic 49
.byt $23, $3f, $3e, $0, $34, $0, $3c, $2
; Tile graphic 50
.byt $0, $0, $0, $0, $0, $22, $16, $2e
; Tile graphic 51
.byt $2, $1, $e, $f, $e, $e, $0, $0
; Tile graphic 52
.byt $1, $1, $1, $0, $0, $0, $0, $0
; Tile graphic 53
.byt $0, $8, $0, $28, $20, $0, $0, $0
; Tile graphic 54
.byt $0, $2, $0, $2, $0, $0, $0, $0
; Tile graphic 55
.byt $2e, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 56
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 57
.byt $15, $8, $24, $22, $d, $0, $0, $0
; Tile graphic 58
.byt $15, $0, $0, $0, $3, $20, $0, $0
; Tile graphic 59
.byt $0, $0, $0, $0, $20, $0, $0, $0
; Tile graphic 60
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 61
.byt $2a, $0, $0, $0, $0, $2, $0, $0
; Tile graphic 62
.byt $2a, $0, $0, $8, $4, $3a, $2, $2
; Tile graphic 63
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 64
.byt $1, $0, $1, $5, $6, $19, $6, $1
; Tile graphic 65
.byt $1f, $2f, $10, $27, $8, $7, $7, $8
; Tile graphic 66
.byt $0, $0, $0, $20, $10, $28, $10, $20
; Tile graphic 67
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 68
.byt $a, $a, $1, $2, $2, $5, $5, $0
; Tile graphic 69
.byt $0, $8, $0, $38, $3c, $3c, $30, $0
; Tile graphic 70
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 71
.byt $5, $0, $0, $0, $0, $2, $0, $0
; Tile graphic 72
.byt $15, $0, $0, $0, $0, $38, $0, $0
; Tile graphic 73
.byt $15, $0, $0, $7, $0, $0, $0, $0
; Tile graphic 74
.byt $0, $0, $0, $30, $0, $0, $0, $0
; Tile graphic 75
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 76
.byt $0, $0, $2, $1, $a, $14, $20, $0
; Tile graphic 77
.byt $0, $10, $2a, $15, $22, $0, $0, $0
; Tile graphic 78
.byt $0, $0, $0, $10, $28, $10, $2, $1
; Tile graphic 79
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 80
.byt $0, $0, $2, $4, $2, $4, $2, $4
; Tile graphic 81
.byt $7, $f, $1f, $1f, $18, $17, $3c, $1a
; Tile graphic 82
.byt $12, $3f, $3f, $3f, $1e, $2d, $c, $2d
; Tile graphic 83
.byt $30, $38, $3c, $3c, $c, $34, $e, $14
; Tile graphic 84
.byt $0, $0, $20, $10, $20, $10, $20, $10
; Tile graphic 85
.byt $0, $3, $3, $1, $0, $0, $0, $0
; Tile graphic 86
.byt $1f, $1f, $1f, $3f, $1f, $1f, $1f, $f
; Tile graphic 87
.byt $1e, $3f, $3f, $31, $3b, $3f, $4, $3f
; Tile graphic 88
.byt $1c, $3d, $3d, $3f, $3c, $3c, $3c, $38
; Tile graphic 89
.byt $0, $20, $20, $0, $0, $0, $0, $0
; Tile graphic 90
.byt $0, $0, $0, $0, $1, $1, $0, $0
; Tile graphic 91
.byt $7, $b, $1, $14, $18, $24, $18, $5
; Tile graphic 92
.byt $31, $3f, $3f, $0, $0, $38, $3e, $1
; Tile graphic 93
.byt $38, $30, $28, $14, $d, $13, $c, $10
; Tile graphic 94
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 95
.byt $0, $3, $0, $7, $7, $6, $7, $0
; Tile graphic 96
.byt $8, $9, $8, $5, $4, $0, $0, $0
; Tile graphic 97
.byt $0, $1, $0, $1, $0, $0, $0, $0
; Tile graphic 98
.byt $8, $9, $8, $11, $11, $0, $1, $0
; Tile graphic 99
.byt $0, $20, $0, $30, $30, $30, $30, $0
; Tile graphic 100
.byt $0, $0, $0, $0, $0, $1, $0, $0
; Tile graphic 101
.byt $15, $0, $0, $0, $0, $28, $0, $0
; Tile graphic 102
.byt $15, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 103
.byt $14, $0, $0, $0, $0, $b, $0, $0
; Tile graphic 104
.byt $0, $0, $0, $0, $0, $0, $2, $1
; Tile graphic 105
.byt $0, $0, $0, $0, $0, $10, $2a, $15
; Tile graphic 106
.byt $0, $0, $0, $0, $0, $0, $0, $10
; Tile graphic 107
.byt $0, $0, $0, $1, $0, $0, $2, $4
; Tile graphic 108
.byt $a, $14, $20, $0, $7, $f, $1f, $1f
; Tile graphic 109
.byt $22, $0, $0, $0, $12, $3f, $3f, $3f
; Tile graphic 110
.byt $28, $10, $2, $1, $30, $38, $3c, $3c
; Tile graphic 111
.byt $0, $0, $0, $0, $0, $0, $20, $10
; Tile graphic 112
.byt $2, $4, $2, $4, $0, $3, $3, $1
; Tile graphic 113
.byt $18, $17, $3c, $1a, $1f, $1f, $1f, $3f
; Tile graphic 114
.byt $1e, $2d, $c, $2d, $1e, $3f, $3f, $31
; Tile graphic 115
.byt $c, $34, $e, $14, $1c, $3d, $3d, $3f
; Tile graphic 116
.byt $20, $10, $20, $10, $0, $20, $20, $0
; Tile graphic 117
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 118
.byt $1f, $1f, $1f, $f, $7, $b, $1, $14
; Tile graphic 119
.byt $3b, $3f, $4, $3f, $31, $3f, $3f, $0
; Tile graphic 120
.byt $3c, $3c, $3c, $38, $38, $30, $28, $14
; Tile graphic 121
.byt $1, $1, $0, $0, $6, $7, $7, $7
; Tile graphic 122
.byt $18, $24, $18, $5, $28, $29, $28, $25
; Tile graphic 123
.byt $0, $38, $3e, $1, $0, $1, $0, $1
; Tile graphic 124
.byt $d, $13, $c, $10, $8, $9, $8, $11
; Tile graphic 125
.byt $0, $0, $0, $0, $0, $20, $0, $0
; Tile graphic 126
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 127
.byt $4, $0, $0, $0, $15, $0, $0, $0
; Tile graphic 128
.byt $0, $0, $0, $0, $15, $0, $0, $0
; Tile graphic 129
.byt $11, $0, $0, $0, $14, $0, $0, $0
; Tile graphic 130
.byt $a, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 131
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 132
.byt $0, $e, $0, $0, $0, $0, $0, $0
; Tile graphic 133
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 134
.byt $1, $1, $0, $0, $0, $3, $0, $1
; Tile graphic 135
.byt $18, $24, $18, $5, $8, $9, $8, $5
; Tile graphic 136
.byt $d, $13, $c, $10, $a, $b, $b, $13
; Tile graphic 137
.byt $0, $0, $0, $0, $30, $30, $30, $30
; Tile graphic 138
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 139
.byt $4, $0, $0, $0, $15, $0, $0, $0
; Tile graphic 140
.byt $10, $0, $0, $0, $14, $0, $0, $0
; Tile graphic 141
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 142
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 143
.byt $0, $38, $0, $0, $0, $0, $0, $0
; Tile graphic 144
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 145
.byt $28, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 146
.byt $0, $0, $0, $2, $1, $a, $14, $20
; Tile graphic 147
.byt $0, $0, $10, $2a, $15, $0, $0, $0
; Tile graphic 148
.byt $0, $0, $0, $0, $10, $28, $10, $2
; Tile graphic 149
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 150
.byt $0, $2, $0, $a, $0, $8, $0, $8
; Tile graphic 151
.byt $0, $2, $0, $2a, $0, $2a, $0, $8
; Tile graphic 152
.byt $1, $0, $0, $0, $0, $28, $0, $8
; Tile graphic 153
.byt $0, $0, $0, $20, $10, $0, $0, $0
; Tile graphic 154
.byt $0, $0, $2, $1, $0, $0, $0, $0
; Tile graphic 155
.byt $0, $0, $0, $0, $0, $0, $4, $2
; Tile graphic 156
.byt $0, $8, $0, $0, $0, $0, $0, $0
; Tile graphic 157
.byt $0, $8, $0, $0, $0, $0, $0, $20
; Tile graphic 158
.byt $10, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 159
.byt $0, $0, $0, $0, $1, $0, $0, $0
; Tile graphic 160
.byt $15, $7, $10, $20, $0, $0, $0, $0
; Tile graphic 161
.byt $15, $3f, $0, $0, $0, $0, $0, $0
; Tile graphic 162
.byt $10, $34, $a, $4, $1, $3, $0, $0
; Tile graphic 163
.byt $3, $0, $7, $7, $6, $7, $0, $0
; Tile graphic 164
.byt $0, $0, $0, $0, $0, $0, $0, $15
; Tile graphic 165
.byt $1, $0, $1, $1, $0, $1, $0, $14
; Tile graphic 166
.byt $20, $0, $30, $30, $30, $30, $0, $0
; Tile graphic 167
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 168
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 169
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 170
.byt $0, $0, $0, $0, $0, $0, $0, $2
; Tile graphic 171
.byt $0, $0, $0, $0, $0, $0, $10, $2a
; Tile graphic 172
.byt $0, $0, $0, $0, $1, $0, $0, $0
; Tile graphic 173
.byt $1, $a, $14, $20, $0, $2, $0, $a
; Tile graphic 174
.byt $15, $0, $0, $0, $0, $2, $0, $2a
; Tile graphic 175
.byt $10, $28, $10, $2, $1, $0, $0, $0
; Tile graphic 176
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 177
.byt $0, $0, $0, $0, $0, $0, $2, $1
; Tile graphic 178
.byt $0, $8, $0, $8, $0, $0, $0, $0
; Tile graphic 179
.byt $0, $2a, $0, $8, $0, $8, $0, $0
; Tile graphic 180
.byt $0, $28, $0, $8, $0, $8, $0, $0
; Tile graphic 181
.byt $10, $0, $0, $0, $10, $0, $0, $0
; Tile graphic 182
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 183
.byt $0, $0, $0, $2, $5, $17, $28, $10
; Tile graphic 184
.byt $0, $0, $0, $0, $15, $3f, $0, $0
; Tile graphic 185
.byt $0, $0, $10, $20, $14, $32, $5, $0
; Tile graphic 186
.byt $0, $0, $0, $0, $0, $30, $18, $28
; Tile graphic 187
.byt $0, $0, $0, $3, $7, $7, $7, $0
; Tile graphic 188
.byt $0, $10, $0, $0, $20, $0, $0, $0
; Tile graphic 189
.byt $2, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 190
.byt $30, $10, $10, $0, $0, $0, $0, $0
; Tile graphic 191
.byt $0, $0, $0, $15, $0, $0, $0, $0
; Tile graphic 192
.byt $0, $0, $0, $15, $0, $0, $0, $0
; Tile graphic 193
.byt $0, $0, $0, $14, $0, $0, $0, $0
; Tile graphic 194
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 195
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 196
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 197
.byt $0, $0, $0, $0, $0, $6, $d, $a
; Tile graphic 198
.byt $0, $0, $4, $2, $15, $27, $10, $0
; Tile graphic 199
.byt $0, $0, $0, $20, $10, $34, $a, $4
; Tile graphic 200
.byt $6, $4, $4, $0, $0, $0, $0, $0
; Tile graphic 201
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 202
.byt $0, $4, $0, $1, $3, $1, $1, $0
; Tile graphic 203
.byt $0, $0, $0, $20, $30, $30, $30, $0
; Tile graphic 204
.byt $0, $0, $0, $15, $0, $0, $0, $8
; Tile graphic 205
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 206
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 207
.byt $1e, $3f, $3f, $31, $3b, $3f, $0, $21
; Tile graphic 208
.byt $1c, $3d, $3d, $3f, $3c, $3c, $3c, $3c
; Tile graphic 209
.byt $f, $7, $3, $15, $18, $24, $18, $5
; Tile graphic 210
.byt $3f, $31, $3f, $3f, $0, $38, $3e, $1
; Tile graphic 211
.byt $38, $38, $30, $24, $d, $13, $c, $10
; Tile graphic 212
.byt $37, $3f, $3f, $3c, $3e, $3f, $38, $38
; Tile graphic 213
.byt $26, $3e, $3e, $1e, $3e, $3e, $e, $1c
; Tile graphic 214
.byt $b, $5, $8, $2e, $31, $8, $30, $9
; Tile graphic 215
.byt $3f, $3c, $3f, $7, $38, $38, $3f, $0
; Tile graphic 216
.byt $3c, $18, $38, $34, $2, $5, $22, $14
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $7e, $7c, $78, $70
; Tile mask 2
.byt $7c, $70, $60, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $4f, $47, $43, $41, $41, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 6
.byt $70, $70, $60, $60, $60, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $5f, $4f, $4f, $4f, $4f, $4f, $5f, $5f
; Tile mask 11
.byt $40, $60, $70, $70, $78, $7c, $7e, $ff
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 15
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 16
.byt $ff, $ff, $7e, $7c, $78, $70, $70, $70
; Tile mask 17
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $41, $43, $41, $40, $40, $40, $40, $40
; Tile mask 20
.byt $ff, $ff, $ff, $ff, $5f, $5f, $5f, $ff
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
.byt $7e, $7e, $ff, $7e, $7c, $78, $78, $78
; Tile mask 27
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 28
.byt $40, $40, $40, $50, $50, $50, $50, $7c
; Tile mask 29
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 31
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 32
.byt $ff, $7e, $7c, $78, $70, $60, $40, $40
; Tile mask 33
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $47, $41, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $ff, $ff, $ff, $5f, $4f, $4f, $47, $43
; Tile mask 36
.byt $7e, $7e, $7c, $7c, $7c, $78, $78, $78
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $43, $41, $41, $41, $41, $41, $43, $43
; Tile mask 41
.byt $78, $7c, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 42
.byt $40, $40, $40, $40, $40, $60, $70, $78
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 45
.byt $43, $47, $47, $47, $47, $47, $47, $4f
; Tile mask 46
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7c
; Tile mask 47
.byt $7c, $7c, $70, $60, $60, $40, $40, $40
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $4f, $5f, $4f, $47, $41, $40, $40, $40
; Tile mask 51
.byt $78, $70, $60, $60, $60, $60, $71, $ff
; Tile mask 52
.byt $40, $40, $50, $50, $50, $78, $78, $78
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 55
.byt $40, $51, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 56
.byt $7c, $7e, $7e, $7e, $7c, $7c, $ff, $ff
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $61, $ff
; Tile mask 58
.byt $40, $41, $40, $40, $40, $40, $40, $61
; Tile mask 59
.byt $5f, $ff, $ff, $5f, $4f, $47, $47, $ff
; Tile mask 60
.byt $7e, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 62
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7e
; Tile mask 64
.byt $7c, $7c, $70, $60, $40, $40, $40, $40
; Tile mask 65
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 66
.byt $4f, $5f, $4f, $47, $43, $43, $43, $47
; Tile mask 67
.byt $7e, $7c, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 68
.byt $40, $40, $40, $40, $40, $60, $70, $70
; Tile mask 69
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 70
.byt $4f, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 71
.byt $70, $70, $70, $70, $60, $40, $40, $70
; Tile mask 72
.byt $40, $40, $40, $41, $47, $43, $41, $41
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $70, $ff
; Tile mask 74
.byt $5f, $5f, $4f, $47, $43, $43, $ff, $ff
; Tile mask 75
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7c, $78
; Tile mask 76
.byt $ff, $7c, $78, $70, $40, $40, $40, $40
; Tile mask 77
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $ff, $5f, $4f, $43, $41, $40, $40, $40
; Tile mask 79
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $4f
; Tile mask 80
.byt $78, $78, $70, $70, $70, $60, $60, $60
; Tile mask 81
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 82
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 84
.byt $4f, $4f, $47, $47, $47, $43, $43, $43
; Tile mask 85
.byt $60, $70, $78, $78, $7c, $7e, $7e, $ff
; Tile mask 86
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 89
.byt $43, $47, $4f, $4f, $5f, $ff, $ff, $ff
; Tile mask 90
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 91
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 92
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 93
.byt $43, $43, $41, $40, $40, $40, $40, $40
; Tile mask 94
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $4f
; Tile mask 95
.byt $78, $78, $78, $70, $70, $70, $70, $78
; Tile mask 96
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 97
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 98
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 99
.byt $4f, $4f, $4f, $47, $47, $47, $47, $4f
; Tile mask 100
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $7c
; Tile mask 101
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 102
.byt $40, $40, $40, $48, $48, $48, $48, $ff
; Tile mask 103
.byt $41, $41, $41, $41, $40, $40, $40, $40
; Tile mask 104
.byt $ff, $ff, $ff, $ff, $ff, $7c, $78, $70
; Tile mask 105
.byt $ff, $ff, $ff, $ff, $41, $40, $40, $40
; Tile mask 106
.byt $ff, $ff, $ff, $ff, $ff, $5f, $4f, $43
; Tile mask 107
.byt $ff, $7e, $7c, $78, $78, $78, $70, $70
; Tile mask 108
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 109
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 110
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 111
.byt $ff, $ff, $5f, $4f, $4f, $4f, $47, $47
; Tile mask 112
.byt $70, $60, $60, $60, $60, $70, $78, $78
; Tile mask 113
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 114
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 115
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $47, $43, $43, $43, $43, $47, $4f, $4f
; Tile mask 117
.byt $7c, $7e, $7e, $ff, $ff, $ff, $ff, $7e
; Tile mask 118
.byt $40, $40, $40, $40, $60, $60, $40, $40
; Tile mask 119
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 120
.byt $40, $40, $40, $41, $43, $43, $41, $40
; Tile mask 121
.byt $7c, $78, $78, $78, $70, $70, $70, $70
; Tile mask 122
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 123
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 124
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 125
.byt $5f, $4f, $4f, $4f, $4f, $4f, $5f, $5f
; Tile mask 126
.byt $78, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 127
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 128
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 129
.byt $40, $40, $41, $41, $41, $41, $41, $41
; Tile mask 130
.byt $60, $70, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 131
.byt $58, $78, $78, $7e, $ff, $ff, $ff, $ff
; Tile mask 132
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 133
.byt $ff, $5f, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 134
.byt $7c, $78, $78, $78, $78, $78, $7c, $7c
; Tile mask 135
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 136
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 137
.byt $5f, $4f, $4f, $4f, $47, $47, $47, $47
; Tile mask 138
.byt $7c, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 139
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 140
.byt $40, $41, $41, $41, $41, $41, $41, $43
; Tile mask 141
.byt $4f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 142
.byt $7e, $7c, $7c, $7c, $ff, $ff, $ff, $ff
; Tile mask 143
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 144
.byt $4c, $4e, $4f, $ff, $ff, $ff, $ff, $ff
; Tile mask 145
.byt $43, $47, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 146
.byt $ff, $ff, $7c, $78, $70, $40, $40, $40
; Tile mask 147
.byt $ff, $41, $40, $40, $40, $40, $40, $40
; Tile mask 148
.byt $ff, $ff, $5f, $4f, $43, $41, $40, $40
; Tile mask 149
.byt $78, $78, $78, $70, $70, $70, $60, $60
; Tile mask 150
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 151
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 152
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 153
.byt $4f, $4f, $4f, $47, $47, $47, $43, $43
; Tile mask 154
.byt $60, $60, $70, $78, $7c, $7e, $7e, $ff
; Tile mask 155
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 156
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 157
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 158
.byt $43, $43, $47, $4f, $5f, $ff, $ff, $ff
; Tile mask 159
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 160
.byt $40, $60, $40, $40, $40, $40, $40, $40
; Tile mask 161
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 162
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 163
.byt $78, $78, $70, $70, $70, $70, $78, $ff
; Tile mask 164
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 165
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 166
.byt $4f, $4f, $47, $47, $47, $47, $4f, $ff
; Tile mask 167
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $7c
; Tile mask 168
.byt $40, $40, $40, $48, $40, $48, $48, $7e
; Tile mask 169
.byt $41, $41, $41, $41, $40, $40, $40, $40
; Tile mask 170
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7c, $78
; Tile mask 171
.byt $ff, $ff, $ff, $ff, $ff, $41, $40, $40
; Tile mask 172
.byt $ff, $ff, $7e, $7c, $78, $78, $78, $70
; Tile mask 173
.byt $70, $40, $40, $40, $40, $40, $40, $40
; Tile mask 174
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 175
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 176
.byt $ff, $ff, $ff, $5f, $4f, $4f, $4f, $47
; Tile mask 177
.byt $70, $70, $60, $60, $60, $60, $70, $78
; Tile mask 178
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 179
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 180
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 181
.byt $47, $47, $43, $43, $43, $43, $47, $4f
; Tile mask 182
.byt $7c, $7e, $7e, $ff, $ff, $ff, $7e, $7e
; Tile mask 183
.byt $40, $40, $40, $40, $60, $40, $40, $40
; Tile mask 184
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 185
.byt $40, $40, $40, $41, $41, $40, $40, $40
; Tile mask 186
.byt $5f, $ff, $ff, $ff, $4f, $47, $43, $43
; Tile mask 187
.byt $7c, $78, $78, $70, $70, $70, $70, $78
; Tile mask 188
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 189
.byt $40, $40, $40, $40, $40, $41, $41, $41
; Tile mask 190
.byt $43, $47, $47, $4f, $5f, $ff, $ff, $ff
; Tile mask 191
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 192
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 193
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile mask 194
.byt $60, $60, $70, $ff, $ff, $ff, $ff, $ff
; Tile mask 195
.byt $40, $48, $58, $7e, $ff, $ff, $ff, $ff
; Tile mask 196
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 197
.byt $7c, $7e, $7e, $ff, $79, $70, $60, $60
; Tile mask 198
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 199
.byt $40, $40, $40, $41, $43, $41, $40, $40
; Tile mask 200
.byt $60, $70, $70, $78, $7c, $ff, $ff, $ff
; Tile mask 201
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 202
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 203
.byt $5f, $4f, $4f, $47, $47, $47, $47, $4f
; Tile mask 204
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 205
.byt $40, $48, $4c, $ff, $ff, $ff, $ff, $ff
; Tile mask 206
.byt $43, $43, $47, $ff, $ff, $ff, $ff, $ff
; Tile mask 207
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 208
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 209
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 210
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 211
.byt $43, $43, $41, $40, $40, $40, $40, $40
; Tile mask 212
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 213
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 214
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 215
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 216
.byt $41, $43, $41, $40, $40, $40, $40, $40
res_end
.)

