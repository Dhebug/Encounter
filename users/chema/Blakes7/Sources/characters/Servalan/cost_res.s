.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 8
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
.byt 13, 14, 15, 16, 17
.byt 18, 19, 20, 21, 22
.byt 23, 24, 25, 26, 27
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 28, 29, 30, 31
.byt 0, 32, 33, 34, 35
.byt 0, 36, 37, 38, 39
.byt 40, 41, 42, 43, 44
.byt 45, 46, 47, 48, 17
.byt 0, 49, 50, 51, 52
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 53, 54, 55, 56, 0
.byt 57, 58, 59, 60, 0
.byt 61, 62, 63, 64, 0
.byt 65, 66, 67, 68, 69
.byt 0, 70, 71, 72, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 0, 28, 29, 30, 31
.byt 0, 32, 33, 34, 35
.byt 0, 36, 37, 38, 39
.byt 0, 73, 74, 43, 75
.byt 0, 76, 77, 78, 17
.byt 0, 49, 79, 80, 81
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 82, 83, 3, 84, 0
.byt 85, 86, 87, 88, 89
.byt 90, 91, 92, 93, 69
.byt 13, 94, 95, 16, 17
.byt 18, 19, 20, 21, 22
.byt 23, 24, 25, 26, 27
; Animatory state 5 (05-stepd1.png)
.byt 0, 96, 97, 98, 0
.byt 99, 100, 101, 102, 103
.byt 104, 105, 106, 107, 108
.byt 109, 110, 111, 112, 0
.byt 113, 114, 115, 116, 0
.byt 0, 117, 118, 119, 0
.byt 0, 120, 121, 122, 0
; Animatory state 6 (06-stepd2.png)
.byt 0, 96, 97, 98, 0
.byt 99, 100, 101, 102, 103
.byt 104, 105, 106, 107, 108
.byt 123, 124, 111, 125, 0
.byt 126, 127, 128, 129, 69
.byt 0, 130, 131, 132, 0
.byt 133, 134, 135, 136, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 82, 137, 138, 139, 0
.byt 85, 140, 140, 141, 89
.byt 142, 143, 144, 145, 146
.byt 147, 148, 149, 150, 151
.byt 152, 153, 154, 155, 156
.byt 157, 158, 159, 160, 17
; Animatory state 8 (08-stepdb1.png)
.byt 0, 161, 162, 163, 0
.byt 99, 164, 140, 165, 103
.byt 166, 167, 140, 168, 169
.byt 170, 171, 172, 173, 174
.byt 175, 176, 177, 178, 179
.byt 0, 180, 181, 182, 183
.byt 0, 184, 185, 186, 187
; Animatory state 9 (09-stepdb2.png)
.byt 0, 188, 189, 190, 0
.byt 191, 140, 140, 192, 193
.byt 194, 195, 140, 196, 197
.byt 198, 199, 200, 201, 202
.byt 203, 204, 205, 206, 207
.byt 82, 208, 209, 210, 0
.byt 211, 186, 212, 213, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 82, 83, 3, 84, 0
.byt 85, 86, 87, 88, 89
.byt 90, 214, 215, 216, 69
.byt 13, 217, 218, 219, 17
.byt 18, 19, 20, 21, 22
.byt 23, 24, 25, 26, 27
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 220, 221, 222, 0
.byt 13, 223, 224, 219, 17
.byt 18, 19, 20, 21, 22
.byt 23, 24, 25, 26, 27
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
.byt $0, $0, $0, $0, $0, $0, $1, $1
; Tile graphic 6
.byt $5, $7, $f, $f, $18, $1f, $1c, $1a
; Tile graphic 7
.byt $a, $3f, $3f, $3f, $1e, $2d, $c, $2d
; Tile graphic 8
.byt $24, $3a, $3c, $3c, $4, $3c, $c, $14
; Tile graphic 9
.byt $1, $0, $0, $0, $0, $1, $1, $0
; Tile graphic 10
.byt $f, $2f, $1f, $1f, $1f, $2f, $37, $19
; Tile graphic 11
.byt $3f, $3f, $3f, $33, $3f, $20, $31, $3f
; Tile graphic 12
.byt $3c, $3c, $3c, $3c, $38, $38, $34, $28
; Tile graphic 13
.byt $0, $0, $0, $1, $1, $3, $3, $3
; Tile graphic 14
.byt $2e, $37, $39, $2e, $2f, $2f, $2e, $27
; Tile graphic 15
.byt $3f, $1e, $21, $1e, $21, $3f, $2b, $15
; Tile graphic 16
.byt $18, $34, $2e, $1e, $36, $37, $37, $27
; Tile graphic 17
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 18
.byt $7, $f, $0, $f, $e, $e, $f, $0
; Tile graphic 19
.byt $10, $17, $17, $2f, $2f, $f, $2f, $f
; Tile graphic 20
.byt $a, $35, $3a, $3d, $3e, $2b, $3f, $37
; Tile graphic 21
.byt $7, $27, $37, $10, $27, $39, $3b, $38
; Tile graphic 22
.byt $0, $0, $20, $0, $20, $20, $20, $0
; Tile graphic 23
.byt $0, $0, $0, $0, $1, $0, $3, $0
; Tile graphic 24
.byt $f, $f, $1f, $3f, $3f, $1f, $20, $3
; Tile graphic 25
.byt $3f, $37, $3f, $3f, $3f, $3f, $0, $9
; Tile graphic 26
.byt $38, $3c, $3c, $3e, $3f, $30, $f, $20
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $0, $20, $0
; Tile graphic 28
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 29
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 31
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 32
.byt $0, $0, $0, $0, $1, $1, $5, $5
; Tile graphic 33
.byt $14, $1f, $3f, $3f, $21, $3e, $30, $2a
; Tile graphic 34
.byt $2a, $3f, $3f, $3f, $38, $37, $30, $35
; Tile graphic 35
.byt $0, $0, $20, $20, $0, $20, $20, $0
; Tile graphic 36
.byt $4, $2, $1, $1, $1, $6, $7, $1
; Tile graphic 37
.byt $3f, $3f, $3f, $3f, $3f, $3e, $1f, $27
; Tile graphic 38
.byt $3f, $3f, $3f, $f, $3f, $3, $7, $3e
; Tile graphic 39
.byt $20, $20, $20, $20, $0, $0, $0, $20
; Tile graphic 40
.byt $0, $0, $0, $0, $0, $1, $1, $0
; Tile graphic 41
.byt $e, $1f, $3d, $3b, $39, $39, $21, $1c
; Tile graphic 42
.byt $3b, $1d, $26, $33, $3c, $3f, $35, $3a
; Tile graphic 43
.byt $3d, $3b, $6, $31, $e, $3e, $1e, $2c
; Tile graphic 44
.byt $20, $0, $1c, $1c, $1c, $0, $0, $0
; Tile graphic 45
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 46
.byt $38, $3c, $3c, $1, $0, $1, $0, $0
; Tile graphic 47
.byt $1, $3e, $3f, $3f, $3f, $3f, $2b, $3f
; Tile graphic 48
.byt $10, $2c, $16, $2a, $34, $3f, $3f, $3f
; Tile graphic 49
.byt $0, $0, $1, $1, $1, $3, $0, $1
; Tile graphic 50
.byt $3a, $3f, $3e, $3f, $3f, $3f, $0, $1
; Tile graphic 51
.byt $3f, $3f, $2f, $37, $3e, $3d, $0, $0
; Tile graphic 52
.byt $0, $20, $20, $20, $1c, $20, $0, $0
; Tile graphic 53
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 54
.byt $2, $3, $7, $7, $c, $f, $2e, $2d
; Tile graphic 55
.byt $25, $3f, $3f, $3f, $f, $36, $6, $16
; Tile graphic 56
.byt $10, $38, $3c, $3c, $0, $3c, $4, $28
; Tile graphic 57
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 58
.byt $27, $17, $f, $f, $f, $37, $3b, $c
; Tile graphic 59
.byt $3f, $3f, $3f, $39, $3f, $30, $38, $3f
; Tile graphic 60
.byt $3c, $3c, $3c, $3c, $38, $18, $38, $34
; Tile graphic 61
.byt $1, $1, $3, $3, $3, $3, $7, $7
; Tile graphic 62
.byt $37, $3b, $2c, $3e, $2f, $2f, $2f, $2f
; Tile graphic 63
.byt $1f, $2f, $30, $1e, $21, $3f, $2a, $15
; Tile graphic 64
.byt $2c, $1c, $34, $c, $36, $36, $36, $20
; Tile graphic 65
.byt $0, $3, $3, $3, $0, $0, $0, $0
; Tile graphic 66
.byt $0, $37, $27, $37, $7, $f, $7, $7
; Tile graphic 67
.byt $a, $35, $3a, $3d, $3a, $2f, $37, $3f
; Tile graphic 68
.byt $7, $23, $37, $10, $30, $30, $30, $30
; Tile graphic 69
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 70
.byt $7, $7, $f, $f, $f, $e, $1, $2
; Tile graphic 71
.byt $37, $3f, $37, $3f, $3f, $3, $3c, $2
; Tile graphic 72
.byt $30, $30, $30, $30, $30, $30, $0, $0
; Tile graphic 73
.byt $e, $f, $f, $f, $e, $f, $f, $f
; Tile graphic 74
.byt $3b, $1d, $26, $33, $1c, $21, $2e, $1e
; Tile graphic 75
.byt $20, $0, $20, $0, $0, $0, $0, $0
; Tile graphic 76
.byt $1, $0, $0, $1, $1, $1, $0, $0
; Tile graphic 77
.byt $1e, $1e, $21, $3f, $3f, $3f, $3f, $3f
; Tile graphic 78
.byt $10, $2c, $16, $2a, $34, $3f, $2f, $3f
; Tile graphic 79
.byt $3e, $3f, $3e, $3f, $3e, $1, $3e, $1
; Tile graphic 80
.byt $2f, $3f, $2f, $3f, $2b, $3c, $0, $30
; Tile graphic 81
.byt $20, $20, $30, $30, $20, $0, $0, $0
; Tile graphic 82
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 83
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 84
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 85
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 86
.byt $5, $7, $f, $f, $10, $1f, $18, $15
; Tile graphic 87
.byt $a, $3f, $3f, $3f, $3c, $1b, $18, $1a
; Tile graphic 88
.byt $20, $38, $38, $38, $8, $3c, $1c, $2d
; Tile graphic 89
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 90
.byt $1, $1, $0, $0, $0, $0, $1, $0
; Tile graphic 91
.byt $1f, $f, $2f, $1f, $1f, $f, $37, $1b
; Tile graphic 92
.byt $3f, $3f, $3f, $27, $3f, $1, $23, $3f
; Tile graphic 93
.byt $3d, $39, $3a, $3c, $38, $38, $34, $28
; Tile graphic 94
.byt $2d, $36, $39, $2e, $2f, $2f, $2e, $27
; Tile graphic 95
.byt $3f, $3e, $1, $1e, $21, $3f, $2b, $15
; Tile graphic 96
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 97
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 98
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 99
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 100
.byt $0, $0, $0, $0, $5, $7, $f, $f
; Tile graphic 101
.byt $0, $0, $0, $0, $a, $3f, $3f, $3f
; Tile graphic 102
.byt $0, $0, $0, $0, $20, $38, $38, $38
; Tile graphic 103
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 104
.byt $0, $0, $0, $1, $1, $1, $0, $0
; Tile graphic 105
.byt $10, $1f, $18, $15, $1f, $f, $2f, $1f
; Tile graphic 106
.byt $3c, $1b, $18, $1a, $3f, $3f, $3f, $27
; Tile graphic 107
.byt $8, $3c, $1c, $2d, $3d, $39, $3a, $3c
; Tile graphic 108
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 109
.byt $0, $0, $1, $0, $0, $0, $1, $1
; Tile graphic 110
.byt $1f, $f, $37, $1b, $2d, $36, $39, $2e
; Tile graphic 111
.byt $3f, $1, $23, $3f, $3f, $3e, $1, $1e
; Tile graphic 112
.byt $38, $38, $34, $28, $18, $36, $2e, $1e
; Tile graphic 113
.byt $3, $2, $2, $0, $0, $0, $0, $0
; Tile graphic 114
.byt $2f, $3, $38, $3d, $3c, $3d, $3, $f
; Tile graphic 115
.byt $21, $3f, $2b, $15, $a, $35, $3a, $3d
; Tile graphic 116
.byt $36, $34, $34, $24, $0, $20, $30, $10
; Tile graphic 117
.byt $f, $f, $f, $f, $f, $f, $1a, $1d
; Tile graphic 118
.byt $3e, $37, $3b, $37, $3b, $35, $3b, $17
; Tile graphic 119
.byt $20, $38, $38, $38, $38, $30, $30, $30
; Tile graphic 120
.byt $7, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 121
.byt $2b, $0, $7, $0, $0, $0, $0, $0
; Tile graphic 122
.byt $38, $4, $38, $0, $0, $0, $0, $0
; Tile graphic 123
.byt $0, $0, $1, $0, $0, $1, $1, $1
; Tile graphic 124
.byt $1f, $f, $37, $1b, $2d, $36, $39, $3e
; Tile graphic 125
.byt $38, $38, $34, $28, $18, $34, $2e, $16
; Tile graphic 126
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 127
.byt $2f, $2f, $2f, $26, $1, $6, $d, $a
; Tile graphic 128
.byt $21, $3f, $14, $2a, $10, $2e, $1f, $3f
; Tile graphic 129
.byt $37, $1, $1d, $3c, $3c, $3c, $0, $30
; Tile graphic 130
.byt $5, $1f, $1f, $1f, $1f, $e, $f, $f
; Tile graphic 131
.byt $3f, $2f, $1f, $2f, $1f, $2f, $1d, $2a
; Tile graphic 132
.byt $30, $30, $30, $30, $30, $30, $18, $38
; Tile graphic 133
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 134
.byt $1f, $20, $1f, $0, $0, $0, $0, $0
; Tile graphic 135
.byt $17, $0, $20, $0, $0, $0, $0, $0
; Tile graphic 136
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 137
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 138
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 139
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 140
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 141
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 142
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 143
.byt $0, $0, $20, $10, $27, $30, $1f, $1
; Tile graphic 144
.byt $0, $0, $0, $0, $0, $3f, $0, $3f
; Tile graphic 145
.byt $1, $1, $2, $0, $4, $39, $7, $3c
; Tile graphic 146
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 147
.byt $0, $0, $0, $0, $0, $1, $1, $1
; Tile graphic 148
.byt $e, $1f, $3f, $3f, $37, $37, $37, $33
; Tile graphic 149
.byt $0, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 150
.byt $0, $3e, $3e, $3b, $3b, $3b, $3b, $3b
; Tile graphic 151
.byt $0, $0, $0, $0, $0, $20, $20, $20
; Tile graphic 152
.byt $1, $1, $3, $0, $3, $3, $3, $0
; Tile graphic 153
.byt $33, $33, $37, $5, $37, $f, $2f, $f
; Tile graphic 154
.byt $3f, $3f, $3f, $15, $2b, $3f, $37, $3f
; Tile graphic 155
.byt $35, $35, $34, $1b, $3b, $38, $3b, $38
; Tile graphic 156
.byt $20, $30, $0, $30, $30, $30, $30, $0
; Tile graphic 157
.byt $0, $0, $0, $0, $0, $1, $0, $0
; Tile graphic 158
.byt $f, $1f, $1f, $3f, $3f, $3f, $0, $3
; Tile graphic 159
.byt $37, $3f, $37, $3f, $37, $3f, $0, $9
; Tile graphic 160
.byt $38, $38, $3c, $3e, $3e, $3f, $0, $20
; Tile graphic 161
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 162
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 163
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 164
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 165
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 166
.byt $0, $0, $0, $1, $1, $1, $0, $0
; Tile graphic 167
.byt $0, $0, $0, $0, $0, $0, $20, $10
; Tile graphic 168
.byt $0, $0, $0, $1, $1, $1, $2, $0
; Tile graphic 169
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 170
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 171
.byt $27, $30, $1f, $1, $e, $2f, $37, $37
; Tile graphic 172
.byt $0, $3f, $0, $3f, $0, $3f, $3f, $3f
; Tile graphic 173
.byt $4, $39, $7, $3c, $0, $3f, $3f, $3b
; Tile graphic 174
.byt $0, $0, $0, $20, $20, $0, $0, $0
; Tile graphic 175
.byt $1, $1, $0, $1, $3, $3, $3, $0
; Tile graphic 176
.byt $37, $37, $7, $2b, $33, $33, $27, $6
; Tile graphic 177
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $2a
; Tile graphic 178
.byt $3b, $38, $30, $30, $30, $38, $38, $28
; Tile graphic 179
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 180
.byt $7, $7, $7, $7, $f, $8, $3, $c
; Tile graphic 181
.byt $37, $3f, $3b, $3f, $3b, $1d, $f, $35
; Tile graphic 182
.byt $3c, $3c, $3c, $3c, $3e, $3e, $3f, $3f
; Tile graphic 183
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 184
.byt $f, $7, $0, $0, $0, $0, $0, $0
; Tile graphic 185
.byt $37, $23, $0, $0, $0, $0, $0, $0
; Tile graphic 186
.byt $3f, $3f, $0, $0, $0, $0, $0, $0
; Tile graphic 187
.byt $20, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 188
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 189
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 190
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 191
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 192
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 193
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 194
.byt $0, $0, $1, $1, $1, $0, $0, $0
; Tile graphic 195
.byt $0, $0, $0, $0, $0, $20, $10, $27
; Tile graphic 196
.byt $0, $0, $1, $1, $1, $2, $0, $4
; Tile graphic 197
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 198
.byt $0, $0, $0, $1, $1, $0, $0, $0
; Tile graphic 199
.byt $30, $1f, $21, $e, $1f, $3f, $3f, $37
; Tile graphic 200
.byt $3f, $0, $3f, $0, $3f, $3f, $3f, $3f
; Tile graphic 201
.byt $39, $7, $3c, $0, $3c, $3d, $3b, $3b
; Tile graphic 202
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 203
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 204
.byt $37, $7, $3, $3, $3, $7, $7, $5
; Tile graphic 205
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $15
; Tile graphic 206
.byt $3b, $3b, $38, $35, $33, $33, $39, $18
; Tile graphic 207
.byt $20, $20, $0, $20, $30, $30, $30, $0
; Tile graphic 208
.byt $f, $f, $f, $f, $1f, $1f, $3f, $3f
; Tile graphic 209
.byt $3b, $3f, $37, $3f, $37, $2e, $3c, $2b
; Tile graphic 210
.byt $38, $38, $38, $38, $3c, $4, $30, $c
; Tile graphic 211
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 212
.byt $3b, $31, $0, $0, $0, $0, $0, $0
; Tile graphic 213
.byt $3c, $38, $0, $0, $0, $0, $0, $0
; Tile graphic 214
.byt $1f, $f, $2f, $1f, $1f, $f, $2f, $17
; Tile graphic 215
.byt $3f, $3f, $3f, $27, $3f, $3, $3, $27
; Tile graphic 216
.byt $3d, $39, $3a, $3c, $38, $38, $38, $30
; Tile graphic 217
.byt $2b, $35, $38, $2e, $2f, $2f, $2e, $27
; Tile graphic 218
.byt $3f, $3f, $3e, $0, $21, $3f, $2b, $15
; Tile graphic 219
.byt $28, $14, $2e, $1e, $36, $37, $37, $27
; Tile graphic 220
.byt $f, $2f, $1f, $1f, $1f, $2f, $37, $13
; Tile graphic 221
.byt $3f, $3f, $3f, $33, $3f, $21, $21, $33
; Tile graphic 222
.byt $3c, $3c, $3c, $3c, $38, $38, $34, $30
; Tile graphic 223
.byt $29, $34, $39, $2e, $2f, $2f, $2e, $27
; Tile graphic 224
.byt $3f, $3f, $1e, $0, $21, $3f, $2b, $15
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7e, $7c
; Tile mask 2
.byt $ff, $7e, $78, $60, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $43, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $ff, $4f, $47, $43, $41, $41
; Tile mask 5
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $7c, $7c, $7c, $7e, $7e, $7c, $7c, $7e
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $41, $41, $41, $41, $43, $43, $41, $41
; Tile mask 13
.byt $7e, $7e, $7e, $7c, $7c, $78, $78, $78
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $41, $41, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 18
.byt $70, $60, $60, $60, $60, $60, $60, $70
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $5f, $5f, $4f, $4f, $4f, $4f, $4f, $5f
; Tile mask 23
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 24
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 26
.byt $43, $41, $41, $40, $40, $40, $40, $40
; Tile mask 27
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $4f
; Tile mask 28
.byt $ff, $ff, $ff, $7c, $78, $70, $70, $60
; Tile mask 29
.byt $ff, $70, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $ff, $5f, $47, $41, $40, $40, $40, $40
; Tile mask 31
.byt $ff, $ff, $ff, $ff, $ff, $5f, $4f, $4f
; Tile mask 32
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 36
.byt $60, $60, $60, $78, $78, $70, $70, $70
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $4f, $4f, $4f, $4f, $5f, $5f, $5f, $4f
; Tile mask 40
.byt $ff, $ff, $7e, $7e, $7e, $7c, $7c, $7e
; Tile mask 41
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $4f, $43, $41, $41, $41, $63, $ff, $ff
; Tile mask 45
.byt $7e, $7e, $7e, $ff, $ff, $ff, $ff, $ff
; Tile mask 46
.byt $40, $40, $40, $40, $7c, $7c, $7c, $7e
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $7e, $7e, $7c, $7c, $7c, $78, $78, $78
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $40, $40, $40, $40, $40, $40, $40, $4f
; Tile mask 52
.byt $5f, $4f, $47, $41, $41, $41, $5f, $ff
; Tile mask 53
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 55
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $7c, $7c, $7c, $ff, $ff, $7e, $7e, $7e
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $41, $41, $41, $41, $43, $43, $43, $41
; Tile mask 61
.byt $7c, $7c, $78, $78, $78, $78, $70, $70
; Tile mask 62
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 64
.byt $41, $41, $41, $41, $40, $40, $40, $40
; Tile mask 65
.byt $78, $78, $78, $78, $7c, $ff, $ff, $ff
; Tile mask 66
.byt $40, $40, $40, $40, $40, $60, $70, $70
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $40, $40, $40, $40, $47, $47, $47, $47
; Tile mask 69
.byt $5f, $5f, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 70
.byt $70, $70, $60, $60, $60, $60, $60, $70
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $47, $47, $47, $47, $47, $47, $47, $43
; Tile mask 73
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $4f, $4f, $4f, $4f, $5f, $5f, $5f, $ff
; Tile mask 76
.byt $70, $7c, $7c, $7c, $7c, $7c, $7e, $7e
; Tile mask 77
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 81
.byt $4f, $4f, $47, $47, $43, $41, $5f, $ff
; Tile mask 82
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7e
; Tile mask 83
.byt $ff, $7e, $78, $70, $60, $40, $40, $40
; Tile mask 84
.byt $ff, $ff, $ff, $4f, $43, $41, $40, $40
; Tile mask 85
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 86
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 89
.byt $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 90
.byt $7c, $7c, $7c, $7e, $ff, $7e, $7c, $7e
; Tile mask 91
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 92
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 93
.byt $40, $40, $40, $40, $43, $41, $41, $41
; Tile mask 94
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 95
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 96
.byt $ff, $ff, $ff, $ff, $ff, $7e, $78, $70
; Tile mask 97
.byt $ff, $ff, $ff, $ff, $ff, $43, $40, $40
; Tile mask 98
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $4f
; Tile mask 99
.byt $ff, $ff, $7e, $7e, $7c, $7c, $7c, $7c
; Tile mask 100
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 101
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 102
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 103
.byt $ff, $ff, $ff, $ff, $5f, $5f, $5f, $5f
; Tile mask 104
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7e
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 106
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 107
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 108
.byt $5f, $5f, $5f, $5f, $5f, $5f, $5f, $ff
; Tile mask 109
.byt $ff, $7e, $7c, $7e, $7e, $7e, $7c, $7c
; Tile mask 110
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 111
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 112
.byt $43, $41, $41, $41, $41, $40, $40, $40
; Tile mask 113
.byt $78, $78, $78, $7c, $7e, $7e, $ff, $ff
; Tile mask 114
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 115
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $40, $41, $41, $41, $43, $43, $47, $47
; Tile mask 117
.byt $60, $60, $60, $60, $60, $60, $40, $40
; Tile mask 118
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 119
.byt $47, $43, $43, $43, $43, $47, $47, $47
; Tile mask 120
.byt $60, $78, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 121
.byt $40, $40, $70, $70, $ff, $ff, $ff, $ff
; Tile mask 122
.byt $43, $41, $43, $43, $ff, $ff, $ff, $ff
; Tile mask 123
.byt $ff, $7e, $7c, $7e, $7e, $7c, $7c, $7c
; Tile mask 124
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 125
.byt $43, $41, $41, $41, $41, $41, $40, $40
; Tile mask 126
.byt $7c, $7e, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 127
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 128
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 129
.byt $40, $40, $40, $40, $41, $41, $43, $47
; Tile mask 130
.byt $60, $40, $40, $40, $40, $60, $60, $60
; Tile mask 131
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 132
.byt $47, $47, $47, $47, $47, $47, $43, $43
; Tile mask 133
.byt $ff, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 134
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 135
.byt $40, $40, $4f, $4f, $ff, $ff, $ff, $ff
; Tile mask 136
.byt $47, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 137
.byt $ff, $ff, $7e, $78, $60, $40, $40, $40
; Tile mask 138
.byt $ff, $60, $40, $40, $40, $40, $40, $40
; Tile mask 139
.byt $ff, $ff, $4f, $47, $43, $41, $40, $40
; Tile mask 140
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 141
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 142
.byt $7c, $7c, $7e, $ff, $7e, $7e, $ff, $ff
; Tile mask 143
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 144
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 145
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 146
.byt $5f, $5f, $ff, $ff, $ff, $5f, $5f, $ff
; Tile mask 147
.byt $ff, $ff, $7e, $7e, $7e, $7c, $7c, $7c
; Tile mask 148
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 149
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 150
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 151
.byt $ff, $ff, $ff, $5f, $5f, $4f, $4f, $4f
; Tile mask 152
.byt $7c, $7c, $78, $78, $78, $78, $78, $7c
; Tile mask 153
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 154
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 155
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 156
.byt $4f, $47, $47, $47, $47, $47, $47, $4f
; Tile mask 157
.byt $ff, $ff, $ff, $7e, $7e, $7c, $7c, $7c
; Tile mask 158
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 159
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 160
.byt $43, $43, $41, $40, $40, $40, $40, $40
; Tile mask 161
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $78
; Tile mask 162
.byt $ff, $ff, $ff, $ff, $ff, $60, $40, $40
; Tile mask 163
.byt $ff, $ff, $ff, $ff, $ff, $ff, $4f, $47
; Tile mask 164
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 165
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 166
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7e, $ff
; Tile mask 167
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 168
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 169
.byt $5f, $5f, $5f, $5f, $5f, $5f, $ff, $ff
; Tile mask 170
.byt $7e, $7e, $ff, $ff, $ff, $7e, $7e, $7c
; Tile mask 171
.byt $40, $40, $40, $60, $40, $40, $40, $40
; Tile mask 172
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 173
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 174
.byt $5f, $5f, $5f, $4f, $4f, $4f, $5f, $5f
; Tile mask 175
.byt $7c, $7c, $7c, $78, $78, $78, $78, $7c
; Tile mask 176
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 177
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 178
.byt $40, $40, $43, $43, $43, $43, $43, $43
; Tile mask 179
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 180
.byt $70, $70, $70, $70, $60, $60, $60, $60
; Tile mask 181
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 182
.byt $41, $41, $41, $41, $40, $40, $40, $40
; Tile mask 183
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f
; Tile mask 184
.byt $60, $70, $78, $ff, $ff, $ff, $ff, $ff
; Tile mask 185
.byt $40, $48, $58, $7c, $ff, $ff, $ff, $ff
; Tile mask 186
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 187
.byt $4f, $4f, $4f, $5f, $ff, $ff, $ff, $ff
; Tile mask 188
.byt $ff, $ff, $ff, $ff, $ff, $7e, $78, $60
; Tile mask 189
.byt $ff, $ff, $ff, $ff, $60, $40, $40, $40
; Tile mask 190
.byt $ff, $ff, $ff, $ff, $ff, $4f, $47, $43
; Tile mask 191
.byt $ff, $7e, $7e, $7c, $7c, $7c, $7c, $7c
; Tile mask 192
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 193
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $5f
; Tile mask 194
.byt $7c, $7c, $7c, $7c, $7c, $7e, $ff, $7e
; Tile mask 195
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 196
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 197
.byt $5f, $5f, $5f, $5f, $5f, $ff, $ff, $ff
; Tile mask 198
.byt $7e, $ff, $7e, $7c, $7c, $7c, $7e, $7e
; Tile mask 199
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 200
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 201
.byt $40, $40, $40, $41, $40, $40, $40, $40
; Tile mask 202
.byt $5f, $5f, $ff, $ff, $ff, $5f, $5f, $4f
; Tile mask 203
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 204
.byt $40, $40, $70, $70, $70, $70, $70, $70
; Tile mask 205
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 206
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 207
.byt $4f, $4f, $4f, $47, $47, $47, $47, $4f
; Tile mask 208
.byt $60, $60, $60, $60, $40, $40, $40, $40
; Tile mask 209
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 210
.byt $43, $43, $43, $43, $41, $41, $41, $41
; Tile mask 211
.byt $7c, $7c, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 212
.byt $40, $44, $46, $4f, $ff, $ff, $ff, $ff
; Tile mask 213
.byt $41, $43, $47, $ff, $ff, $ff, $ff, $ff
; Tile mask 214
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 215
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 216
.byt $40, $40, $40, $40, $43, $41, $41, $41
; Tile mask 217
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 218
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 219
.byt $41, $41, $40, $40, $40, $40, $40, $40
; Tile mask 220
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 221
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 222
.byt $41, $41, $41, $41, $43, $43, $41, $41
; Tile mask 223
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 224
.byt $40, $40, $40, $40, $40, $40, $40, $40
res_end
.)

