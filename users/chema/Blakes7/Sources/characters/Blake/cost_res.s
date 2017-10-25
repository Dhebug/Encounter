.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 0
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
; Animatory state 1 (01-step1.png)
.byt 0, 30, 31, 32, 0
.byt 33, 34, 35, 36, 37
.byt 38, 39, 40, 41, 42
.byt 43, 44, 45, 46, 47
.byt 48, 49, 50, 51, 52
.byt 53, 54, 55, 56, 57
.byt 0, 58, 59, 60, 61
; Animatory state 2 (02-step2.png)
.byt 0, 1, 2, 3, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 16, 17, 0
.byt 18, 19, 20, 62, 0
.byt 22, 23, 24, 25, 0
.byt 63, 64, 65, 66, 0
; Animatory state 3 (03-step3.png)
.byt 0, 30, 31, 32, 0
.byt 33, 34, 35, 36, 37
.byt 38, 39, 40, 41, 42
.byt 43, 44, 45, 46, 47
.byt 67, 68, 50, 69, 70
.byt 71, 72, 73, 74, 0
.byt 75, 76, 77, 78, 79
; Animatory state 4 (04-front.png)
.byt 80, 81, 82, 0, 0
.byt 83, 84, 85, 86, 87
.byt 88, 89, 90, 91, 92
.byt 93, 94, 95, 96, 0
.byt 97, 98, 99, 100, 101
.byt 102, 103, 104, 105, 106
.byt 107, 27, 108, 109, 0
; Animatory state 5 (05-stepd1.png)
.byt 110, 111, 112, 113, 0
.byt 114, 115, 116, 117, 118
.byt 119, 120, 121, 122, 123
.byt 124, 125, 126, 127, 0
.byt 128, 129, 130, 131, 132
.byt 75, 133, 134, 135, 0
.byt 0, 136, 137, 138, 0
; Animatory state 6 (06-stepd2.png)
.byt 110, 111, 112, 113, 0
.byt 114, 115, 116, 117, 118
.byt 119, 120, 121, 122, 123
.byt 139, 125, 126, 140, 141
.byt 142, 143, 130, 144, 145
.byt 63, 133, 146, 147, 0
.byt 148, 149, 150, 151, 0
; Animatory state 7 (07-back.png)
.byt 80, 81, 82, 0, 0
.byt 83, 84, 152, 86, 87
.byt 153, 154, 155, 156, 92
.byt 157, 158, 159, 160, 0
.byt 161, 162, 163, 164, 101
.byt 165, 166, 167, 168, 106
.byt 169, 170, 171, 172, 0
; Animatory state 8 (08-stepdb1.png)
.byt 110, 111, 112, 113, 0
.byt 173, 174, 175, 176, 118
.byt 177, 178, 179, 180, 123
.byt 181, 182, 183, 184, 185
.byt 186, 187, 188, 189, 190
.byt 63, 191, 192, 193, 0
.byt 194, 195, 196, 197, 0
; Animatory state 9 (09-stepdb2.png)
.byt 110, 111, 112, 113, 0
.byt 173, 174, 175, 176, 118
.byt 177, 178, 179, 180, 123
.byt 198, 199, 183, 200, 141
.byt 201, 187, 188, 202, 203
.byt 63, 204, 205, 206, 0
.byt 207, 208, 209, 210, 0
; Animatory state 10 (10-frontTalk.png)
.byt 80, 81, 82, 0, 0
.byt 83, 84, 85, 86, 87
.byt 88, 89, 90, 91, 92
.byt 93, 211, 212, 213, 0
.byt 97, 214, 215, 216, 101
.byt 102, 103, 104, 105, 106
.byt 107, 27, 108, 109, 0
; Animatory state 11 (12-rightTalk.png)
.byt 0, 1, 2, 3, 0
.byt 4, 5, 6, 7, 8
.byt 9, 10, 11, 12, 13
.byt 14, 15, 217, 218, 0
.byt 18, 219, 220, 221, 0
.byt 22, 23, 24, 25, 0
.byt 26, 27, 28, 29, 0
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
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 31
.byt $0, $0, $0, $0, $0, $0, $2, $14
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $0, $20, $10
; Tile graphic 33
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 34
.byt $0, $4, $2, $11, $2a, $15, $20, $14
; Tile graphic 35
.byt $28, $15, $2a, $15, $2, $15, $0, $0
; Tile graphic 36
.byt $2a, $15, $28, $15, $0, $15, $0, $1
; Tile graphic 37
.byt $0, $0, $20, $0, $0, $10, $8, $10
; Tile graphic 38
.byt $0, $1, $0, $1, $2, $1, $0, $0
; Tile graphic 39
.byt $0, $0, $20, $11, $9, $11, $1, $19
; Tile graphic 40
.byt $c, $1f, $3f, $20, $f, $31, $2a, $3d
; Tile graphic 41
.byt $3, $3f, $3f, $38, $37, $30, $35, $3b
; Tile graphic 42
.byt $28, $24, $28, $10, $20, $20, $0, $20
; Tile graphic 43
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 44
.byt $1b, $f, $3, $7, $7, $7, $3, $5
; Tile graphic 45
.byt $3f, $3f, $3e, $3f, $3f, $3c, $3f, $3e
; Tile graphic 46
.byt $3f, $3f, $37, $2f, $3f, $b, $3f, $7
; Tile graphic 47
.byt $20, $20, $20, $20, $20, $20, $0, $0
; Tile graphic 48
.byt $0, $0, $0, $0, $0, $3, $1, $e
; Tile graphic 49
.byt $2, $1, $8, $14, $2a, $10, $22, $1
; Tile graphic 50
.byt $3f, $f, $23, $18, $25, $38, $3e, $1f
; Tile graphic 51
.byt $3e, $3e, $38, $4, $32, $24, $1c, $1c
; Tile graphic 52
.byt $0, $0, $0, $0, $20, $14, $c, $1c
; Tile graphic 53
.byt $f, $e, $e, $0, $0, $0, $0, $0
; Tile graphic 54
.byt $2, $1, $2, $1, $2, $0, $2, $0
; Tile graphic 55
.byt $1f, $1f, $2f, $f, $2e, $1, $2a, $0
; Tile graphic 56
.byt $1c, $1a, $38, $3a, $8, $30, $c, $0
; Tile graphic 57
.byt $1c, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 58
.byt $1, $0, $1, $1, $3, $0, $0, $0
; Tile graphic 59
.byt $3f, $7, $3, $38, $25, $39, $0, $0
; Tile graphic 60
.byt $8, $30, $30, $e, $38, $3f, $3c, $0
; Tile graphic 61
.byt $0, $0, $0, $0, $0, $20, $0, $0
; Tile graphic 62
.byt $30, $30, $0, $20, $10, $24, $20, $24
; Tile graphic 63
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 64
.byt $3f, $3f, $3f, $0, $3f, $3e, $3f, $0
; Tile graphic 65
.byt $3f, $2f, $2f, $0, $2f, $7, $33, $0
; Tile graphic 66
.byt $20, $20, $20, $0, $30, $0, $3c, $0
; Tile graphic 67
.byt $0, $0, $0, $0, $0, $1, $0, $1
; Tile graphic 68
.byt $2, $1, $8, $14, $22, $10, $2a, $39
; Tile graphic 69
.byt $3e, $3e, $39, $4, $32, $24, $1c, $1c
; Tile graphic 70
.byt $0, $0, $0, $20, $0, $20, $0, $0
; Tile graphic 71
.byt $3, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 72
.byt $32, $25, $3e, $3d, $19, $b, $3, $0
; Tile graphic 73
.byt $1f, $1f, $7, $33, $3a, $39, $26, $0
; Tile graphic 74
.byt $1c, $1a, $38, $3a, $8, $30, $8, $6
; Tile graphic 75
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 76
.byt $f, $f, $1, $1e, $3f, $3c, $1f, $0
; Tile graphic 77
.byt $3f, $3c, $30, $0, $30, $0, $38, $0
; Tile graphic 78
.byt $3f, $3c, $3, $1e, $1f, $f, $0, $0
; Tile graphic 79
.byt $0, $0, $20, $0, $38, $0, $0, $0
; Tile graphic 80
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 81
.byt $0, $0, $0, $0, $0, $0, $1, $a
; Tile graphic 82
.byt $0, $0, $0, $0, $0, $0, $10, $8
; Tile graphic 83
.byt $0, $0, $0, $2, $4, $2, $14, $1
; Tile graphic 84
.byt $14, $a, $15, $2a, $1, $2a, $0, $0
; Tile graphic 85
.byt $15, $2a, $14, $2a, $0, $2a, $0, $0
; Tile graphic 86
.byt $10, $28, $10, $20, $0, $2a, $1, $2a
; Tile graphic 87
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 88
.byt $12, $0, $4, $8, $12, $8, $0, $0
; Tile graphic 89
.byt $6, $f, $1f, $30, $27, $38, $35, $3e
; Tile graphic 90
.byt $1, $3f, $3f, $3c, $1b, $38, $1a, $3d
; Tile graphic 91
.byt $32, $38, $31, $18, $2a, $18, $28, $38
; Tile graphic 92
.byt $0, $20, $0, $20, $0, $0, $0, $0
; Tile graphic 93
.byt $0, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 94
.byt $3f, $3f, $3f, $3f, $3f, $1e, $1f, $2f
; Tile graphic 95
.byt $3f, $3f, $1b, $27, $3f, $5, $3f, $3
; Tile graphic 96
.byt $3c, $38, $38, $38, $38, $30, $30, $28
; Tile graphic 97
.byt $0, $0, $0, $2, $0, $2, $4, $6
; Tile graphic 98
.byt $7, $23, $11, $c, $12, $1c, $1f, $2f
; Tile graphic 99
.byt $3f, $3f, $3c, $1, $3a, $11, $7, $2f
; Tile graphic 100
.byt $20, $8, $10, $22, $10, $32, $31, $2b
; Tile graphic 101
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 102
.byt $6, $6, $0, $e, $e, $c, $e, $0
; Tile graphic 103
.byt $f, $2f, $17, $27, $17, $0, $15, $0
; Tile graphic 104
.byt $2f, $2f, $2f, $2f, $7, $38, $5, $0
; Tile graphic 105
.byt $23, $2b, $10, $b, $13, $1, $13, $0
; Tile graphic 106
.byt $0, $0, $0, $20, $20, $20, $20, $0
; Tile graphic 107
.byt $0, $0, $0, $0, $1, $0, $3, $0
; Tile graphic 108
.byt $3f, $27, $2f, $0, $7, $7, $3, $0
; Tile graphic 109
.byt $38, $38, $38, $0, $3c, $0, $3e, $0
; Tile graphic 110
.byt $0, $0, $0, $0, $0, $0, $0, $2
; Tile graphic 111
.byt $0, $0, $1, $a, $14, $a, $15, $2a
; Tile graphic 112
.byt $0, $0, $10, $8, $15, $2a, $14, $2a
; Tile graphic 113
.byt $0, $0, $0, $0, $10, $28, $10, $20
; Tile graphic 114
.byt $4, $2, $14, $1, $12, $0, $4, $8
; Tile graphic 115
.byt $1, $2a, $0, $0, $6, $f, $1f, $30
; Tile graphic 116
.byt $0, $2a, $0, $0, $1, $3f, $3f, $3c
; Tile graphic 117
.byt $0, $2a, $1, $2a, $32, $38, $31, $18
; Tile graphic 118
.byt $0, $0, $0, $0, $0, $20, $0, $20
; Tile graphic 119
.byt $12, $8, $0, $0, $0, $1, $0, $0
; Tile graphic 120
.byt $27, $38, $35, $3e, $3f, $3f, $3f, $3f
; Tile graphic 121
.byt $1b, $38, $1a, $3d, $3f, $3f, $1b, $27
; Tile graphic 122
.byt $2a, $18, $28, $38, $3c, $38, $38, $38
; Tile graphic 123
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 124
.byt $0, $0, $0, $0, $0, $0, $2, $7
; Tile graphic 125
.byt $3f, $1e, $1f, $2f, $7, $23, $11, $c
; Tile graphic 126
.byt $3f, $5, $3f, $3, $3f, $3f, $3c, $1
; Tile graphic 127
.byt $38, $30, $30, $28, $20, $8, $10, $22
; Tile graphic 128
.byt $0, $d, $e, $d, $e, $0, $0, $0
; Tile graphic 129
.byt $12, $1c, $1f, $f, $f, $2f, $17, $7
; Tile graphic 130
.byt $3a, $11, $7, $2f, $2f, $2f, $2f, $2f
; Tile graphic 131
.byt $10, $32, $31, $2b, $22, $28, $10, $8
; Tile graphic 132
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 133
.byt $17, $0, $15, $0, $3f, $3f, $3f, $0
; Tile graphic 134
.byt $7, $38, $5, $0, $3f, $27, $2f, $0
; Tile graphic 135
.byt $10, $0, $10, $0, $38, $38, $38, $0
; Tile graphic 136
.byt $1e, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 137
.byt $7, $4, $7, $0, $0, $0, $0, $0
; Tile graphic 138
.byt $38, $0, $3c, $0, $0, $0, $0, $0
; Tile graphic 139
.byt $0, $0, $0, $0, $0, $0, $0, $2
; Tile graphic 140
.byt $38, $30, $30, $28, $30, $8, $32, $27
; Tile graphic 141
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 142
.byt $0, $2, $4, $6, $2, $0, $0, $0
; Tile graphic 143
.byt $12, $1c, $1f, $2f, $f, $2f, $17, $27
; Tile graphic 144
.byt $10, $35, $33, $25, $23, $28, $10, $0
; Tile graphic 145
.byt $0, $20, $20, $20, $20, $0, $0, $0
; Tile graphic 146
.byt $7, $38, $5, $0, $3f, $f, $2f, $0
; Tile graphic 147
.byt $10, $0, $10, $0, $38, $38, $38, $0
; Tile graphic 148
.byt $0, $0, $1, $0, $0, $0, $0, $0
; Tile graphic 149
.byt $3f, $1, $3f, $0, $0, $0, $0, $0
; Tile graphic 150
.byt $3, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 151
.byt $30, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 152
.byt $15, $2a, $14, $2a, $0, $2a, $0, $22
; Tile graphic 153
.byt $12, $0, $5, $8, $12, $8, $0, $0
; Tile graphic 154
.byt $11, $2, $1, $0, $1, $22, $1, $2
; Tile graphic 155
.byt $0, $20, $0, $22, $0, $22, $4, $2
; Tile graphic 156
.byt $2, $8, $1, $2a, $0, $2, $0, $a
; Tile graphic 157
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 158
.byt $0, $0, $0, $8, $0, $2, $10, $a
; Tile graphic 159
.byt $4, $20, $0, $8, $0, $a, $0, $2a
; Tile graphic 160
.byt $0, $8, $0, $8, $0, $0, $30, $0
; Tile graphic 161
.byt $1, $0, $0, $2, $0, $2, $4, $6
; Tile graphic 162
.byt $15, $f, $17, $2f, $17, $2f, $17, $2b
; Tile graphic 163
.byt $3d, $3f, $3f, $3f, $3f, $3f, $3f, $3e
; Tile graphic 164
.byt $14, $22, $10, $2a, $10, $2a, $11, $2b
; Tile graphic 165
.byt $6, $6, $0, $e, $e, $8, $e, $0
; Tile graphic 166
.byt $17, $2b, $17, $2b, $15, $0, $15, $0
; Tile graphic 167
.byt $3f, $3e, $3f, $3e, $3d, $0, $15, $0
; Tile graphic 168
.byt $13, $2b, $10, $2b, $13, $0, $13, $0
; Tile graphic 169
.byt $0, $0, $0, $0, $0, $1, $3, $0
; Tile graphic 170
.byt $3f, $3c, $3f, $3f, $0, $3f, $3f, $0
; Tile graphic 171
.byt $3f, $2, $2f, $7, $0, $7, $7, $0
; Tile graphic 172
.byt $38, $38, $38, $38, $0, $3c, $3e, $0
; Tile graphic 173
.byt $4, $2, $14, $1, $12, $0, $5, $8
; Tile graphic 174
.byt $1, $2a, $0, $0, $11, $2, $1, $0
; Tile graphic 175
.byt $0, $2a, $0, $22, $0, $20, $0, $22
; Tile graphic 176
.byt $0, $2a, $1, $2a, $2, $8, $1, $2a
; Tile graphic 177
.byt $12, $8, $0, $0, $1, $0, $0, $0
; Tile graphic 178
.byt $1, $22, $1, $2, $0, $0, $0, $8
; Tile graphic 179
.byt $0, $22, $4, $2, $4, $20, $0, $8
; Tile graphic 180
.byt $0, $2, $0, $a, $0, $8, $0, $8
; Tile graphic 181
.byt $0, $0, $0, $0, $1, $0, $0, $2
; Tile graphic 182
.byt $0, $2, $10, $a, $15, $f, $17, $2f
; Tile graphic 183
.byt $0, $a, $0, $2a, $3d, $3f, $3f, $3f
; Tile graphic 184
.byt $0, $0, $30, $1, $4, $22, $14, $22
; Tile graphic 185
.byt $0, $0, $0, $20, $30, $10, $20, $0
; Tile graphic 186
.byt $4, $2, $c, $1e, $1c, $1c, $0, $0
; Tile graphic 187
.byt $17, $2f, $17, $2b, $17, $2b, $17, $2b
; Tile graphic 188
.byt $3f, $3f, $3f, $3e, $3f, $3e, $3f, $3e
; Tile graphic 189
.byt $10, $2a, $10, $28, $10, $28, $10, $28
; Tile graphic 190
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 191
.byt $15, $0, $15, $0, $3f, $20, $0, $0
; Tile graphic 192
.byt $3d, $0, $15, $0, $3f, $2, $2f, $7
; Tile graphic 193
.byt $10, $0, $10, $0, $38, $38, $38, $38
; Tile graphic 194
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 195
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 196
.byt $0, $7, $7, $0, $0, $0, $0, $0
; Tile graphic 197
.byt $0, $3c, $3e, $0, $0, $0, $0, $0
; Tile graphic 198
.byt $0, $0, $0, $c, $19, $12, $9, $2
; Tile graphic 199
.byt $0, $2, $10, $2, $5, $f, $17, $f
; Tile graphic 200
.byt $0, $0, $30, $20, $14, $20, $10, $2a
; Tile graphic 201
.byt $8, $2, $0, $0, $0, $0, $0, $0
; Tile graphic 202
.byt $11, $2a, $11, $2b, $11, $29, $10, $28
; Tile graphic 203
.byt $0, $0, $20, $30, $30, $30, $0, $0
; Tile graphic 204
.byt $15, $0, $15, $0, $3f, $3a, $3f, $3f
; Tile graphic 205
.byt $3d, $0, $15, $0, $3f, $0, $28, $0
; Tile graphic 206
.byt $10, $0, $10, $0, $38, $8, $0, $0
; Tile graphic 207
.byt $0, $1, $3, $0, $0, $0, $0, $0
; Tile graphic 208
.byt $0, $3f, $3f, $0, $0, $0, $0, $0
; Tile graphic 209
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 210
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 211
.byt $3f, $3f, $3f, $3f, $3f, $1f, $1f, $2f
; Tile graphic 212
.byt $3f, $3f, $1b, $27, $3f, $1, $3, $3f
; Tile graphic 213
.byt $3c, $38, $38, $38, $38, $30, $30, $30
; Tile graphic 214
.byt $f, $27, $13, $c, $12, $1c, $1f, $2f
; Tile graphic 215
.byt $23, $3f, $3f, $3c, $0, $11, $7, $2f
; Tile graphic 216
.byt $20, $28, $10, $22, $10, $32, $31, $2b
; Tile graphic 217
.byt $3f, $3f, $36, $3d, $3f, $30, $31, $3f
; Tile graphic 218
.byt $3c, $3c, $3c, $3c, $3c, $3c, $38, $38
; Tile graphic 219
.byt $17, $b, $4, $23, $14, $7, $17, $b
; Tile graphic 220
.byt $31, $3f, $3f, $1f, $20, $4, $33, $3b
; Tile graphic 221
.byt $38, $30, $20, $4, $10, $24, $20, $24
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
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7c
; Tile mask 31
.byt $ff, $ff, $ff, $ff, $ff, $ff, $40, $40
; Tile mask 32
.byt $ff, $ff, $ff, $ff, $ff, $ff, $47, $41
; Tile mask 33
.byt $ff, $ff, $ff, $ff, $7e, $7e, $7e, $7e
; Tile mask 34
.byt $78, $60, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $ff, $5f, $4f, $4f, $47, $43, $41, $41
; Tile mask 38
.byt $7e, $7c, $7c, $78, $78, $78, $7c, $7c
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $41, $41, $43, $43, $43, $43, $47, $47
; Tile mask 43
.byt $7c, $7c, $7c, $7e, $7e, $ff, $ff, $ff
; Tile mask 44
.byt $40, $40, $40, $40, $40, $60, $70, $70
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $47, $47, $47, $4f, $4f, $4f, $5f, $5f
; Tile mask 48
.byt $ff, $ff, $ff, $7e, $7c, $78, $70, $60
; Tile mask 49
.byt $60, $60, $40, $40, $40, $40, $48, $58
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 52
.byt $ff, $5f, $5f, $5f, $43, $41, $41, $41
; Tile mask 53
.byt $60, $60, $60, $71, $ff, $ff, $ff, $ff
; Tile mask 54
.byt $58, $58, $78, $78, $78, $78, $78, $78
; Tile mask 55
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $40, $40, $40, $40, $40, $41, $41, $41
; Tile mask 57
.byt $41, $43, $6f, $ff, $ff, $ff, $ff, $ff
; Tile mask 58
.byt $7c, $7c, $7c, $7c, $78, $78, $ff, $ff
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $44, $ff
; Tile mask 60
.byt $43, $43, $41, $40, $40, $40, $40, $43
; Tile mask 61
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $ff
; Tile mask 62
.byt $47, $47, $47, $43, $43, $41, $41, $41
; Tile mask 63
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e
; Tile mask 64
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 66
.byt $4f, $4f, $4f, $4f, $47, $43, $41, $41
; Tile mask 67
.byt $ff, $ff, $ff, $7e, $7e, $7c, $7c, $7c
; Tile mask 68
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 69
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 70
.byt $ff, $ff, $5f, $4f, $4f, $4f, $5f, $ff
; Tile mask 71
.byt $78, $78, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 72
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $ff, $ff, $ff, $ff, $7e, $7e, $7e, $ff
; Tile mask 76
.byt $60, $60, $60, $40, $40, $40, $40, $60
; Tile mask 77
.byt $40, $40, $43, $4f, $47, $43, $43, $43
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $70, $ff
; Tile mask 79
.byt $5f, $5f, $4f, $47, $43, $43, $ff, $ff
; Tile mask 80
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 81
.byt $ff, $ff, $ff, $ff, $ff, $ff, $60, $40
; Tile mask 82
.byt $ff, $ff, $ff, $ff, $ff, $ff, $43, $40
; Tile mask 83
.byt $7e, $7c, $78, $78, $70, $60, $60, $60
; Tile mask 84
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 85
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 86
.byt $47, $47, $43, $41, $41, $40, $40, $40
; Tile mask 87
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f
; Tile mask 88
.byt $60, $60, $60, $60, $60, $70, $70, $78
; Tile mask 89
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 90
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 91
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 92
.byt $5f, $5f, $5f, $5f, $5f, $ff, $ff, $ff
; Tile mask 93
.byt $7c, $7c, $7c, $7e, $7e, $ff, $7e, $7e
; Tile mask 94
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 95
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 96
.byt $41, $41, $43, $43, $43, $47, $43, $43
; Tile mask 97
.byt $7c, $78, $78, $78, $78, $70, $70, $70
; Tile mask 98
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 99
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 100
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 101
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 102
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 103
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 106
.byt $5f, $5f, $5f, $4f, $4f, $4f, $4f, $5f
; Tile mask 107
.byt $7e, $7e, $7e, $7e, $7c, $78, $78, $78
; Tile mask 108
.byt $40, $40, $40, $50, $50, $50, $50, $7c
; Tile mask 109
.byt $43, $43, $43, $43, $41, $40, $40, $40
; Tile mask 110
.byt $ff, $ff, $ff, $7e, $7e, $7c, $78, $78
; Tile mask 111
.byt $ff, $ff, $60, $40, $40, $40, $40, $40
; Tile mask 112
.byt $ff, $ff, $43, $40, $40, $40, $40, $40
; Tile mask 113
.byt $ff, $ff, $ff, $ff, $47, $47, $43, $41
; Tile mask 114
.byt $70, $60, $60, $60, $60, $60, $60, $60
; Tile mask 115
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 117
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 118
.byt $ff, $ff, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 119
.byt $60, $70, $70, $78, $7c, $7c, $7c, $7e
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 121
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 122
.byt $40, $40, $40, $41, $41, $41, $43, $43
; Tile mask 123
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 124
.byt $7e, $ff, $7e, $7e, $7c, $78, $78, $70
; Tile mask 125
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 126
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 127
.byt $43, $47, $43, $43, $41, $40, $40, $40
; Tile mask 128
.byt $70, $60, $60, $60, $60, $70, $ff, $ff
; Tile mask 129
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 130
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 131
.byt $40, $40, $40, $40, $40, $41, $43, $43
; Tile mask 132
.byt $ff, $5f, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 133
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 134
.byt $40, $40, $40, $40, $40, $40, $40, $50
; Tile mask 135
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile mask 136
.byt $40, $60, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 137
.byt $50, $70, $70, $70, $ff, $ff, $ff, $ff
; Tile mask 138
.byt $43, $43, $41, $41, $ff, $ff, $ff, $ff
; Tile mask 139
.byt $7e, $ff, $7e, $7e, $7c, $78, $78, $78
; Tile mask 140
.byt $43, $47, $43, $43, $41, $40, $40, $40
; Tile mask 141
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 142
.byt $78, $70, $70, $70, $78, $7c, $7e, $7e
; Tile mask 143
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 144
.byt $40, $40, $40, $40, $40, $40, $47, $4f
; Tile mask 145
.byt $5f, $4f, $4f, $4f, $4f, $5f, $ff, $ff
; Tile mask 146
.byt $40, $40, $40, $40, $40, $40, $40, $50
; Tile mask 147
.byt $47, $47, $47, $47, $43, $43, $43, $47
; Tile mask 148
.byt $7e, $7e, $7c, $7c, $ff, $ff, $ff, $ff
; Tile mask 149
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 150
.byt $50, $58, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 151
.byt $47, $4f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 152
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 153
.byt $60, $60, $60, $60, $60, $70, $70, $78
; Tile mask 154
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 155
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 156
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 157
.byt $7c, $7c, $7c, $7e, $7e, $ff, $ff, $7e
; Tile mask 158
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 159
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 160
.byt $40, $41, $43, $43, $43, $47, $43, $43
; Tile mask 161
.byt $7c, $78, $78, $78, $78, $70, $70, $70
; Tile mask 162
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 163
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 164
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 165
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 166
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 167
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 168
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 169
.byt $7e, $7e, $7e, $7e, $7c, $78, $78, $78
; Tile mask 170
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 171
.byt $40, $40, $40, $50, $50, $50, $50, $50
; Tile mask 172
.byt $43, $43, $43, $43, $41, $40, $40, $40
; Tile mask 173
.byt $70, $60, $60, $60, $60, $60, $60, $60
; Tile mask 174
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 175
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 176
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 177
.byt $60, $70, $70, $78, $7c, $7c, $7c, $7e
; Tile mask 178
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 179
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 180
.byt $40, $40, $40, $40, $40, $41, $43, $43
; Tile mask 181
.byt $7e, $ff, $ff, $7e, $7c, $78, $78, $70
; Tile mask 182
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 183
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 184
.byt $43, $47, $42, $40, $40, $40, $40, $40
; Tile mask 185
.byt $ff, $ff, $5f, $4f, $47, $47, $47, $4f
; Tile mask 186
.byt $60, $60, $40, $40, $40, $40, $62, $7e
; Tile mask 187
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 188
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 189
.byt $40, $40, $40, $43, $43, $43, $43, $43
; Tile mask 190
.byt $4f, $4f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 191
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 192
.byt $40, $40, $40, $40, $40, $40, $40, $50
; Tile mask 193
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile mask 194
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 195
.byt $40, $40, $61, $ff, $ff, $ff, $ff, $ff
; Tile mask 196
.byt $50, $70, $70, $70, $ff, $ff, $ff, $ff
; Tile mask 197
.byt $41, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 198
.byt $7e, $ff, $72, $60, $40, $40, $40, $60
; Tile mask 199
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 200
.byt $43, $47, $47, $43, $41, $40, $40, $40
; Tile mask 201
.byt $60, $60, $78, $7e, $7e, $7e, $7e, $7e
; Tile mask 202
.byt $40, $40, $40, $40, $40, $40, $42, $43
; Tile mask 203
.byt $4f, $4f, $47, $47, $47, $47, $4f, $ff
; Tile mask 204
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 205
.byt $40, $40, $40, $40, $40, $40, $40, $50
; Tile mask 206
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile mask 207
.byt $7c, $78, $78, $78, $ff, $ff, $ff, $ff
; Tile mask 208
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 209
.byt $50, $58, $5c, $5f, $ff, $ff, $ff, $ff
; Tile mask 210
.byt $43, $47, $4f, $ff, $ff, $ff, $ff, $ff
; Tile mask 211
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 212
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 213
.byt $41, $41, $43, $43, $43, $47, $43, $43
; Tile mask 214
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 215
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 216
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 217
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 218
.byt $40, $40, $40, $41, $41, $41, $43, $43
; Tile mask 219
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 220
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 221
.byt $43, $47, $43, $41, $41, $41, $41, $41
res_end
.)

