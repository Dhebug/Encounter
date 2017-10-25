.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 16
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
.byt 0, 0, 1, 2, 0
.byt 3, 4, 5, 6, 7
.byt 8, 9, 10, 11, 12
.byt 13, 14, 15, 16, 17
.byt 18, 19, 20, 21, 22
.byt 23, 24, 25, 26, 27
.byt 28, 29, 30, 31, 32
; Animatory state 1 (01-step1.png)
.byt 0, 0, 33, 34, 0
.byt 0, 35, 36, 37, 38
.byt 39, 40, 41, 42, 43
.byt 44, 45, 46, 47, 48
.byt 49, 50, 51, 52, 53
.byt 54, 55, 56, 57, 58
.byt 0, 59, 60, 61, 62
; Animatory state 2 (02-step2.png)
.byt 0, 0, 1, 2, 0
.byt 3, 4, 5, 6, 7
.byt 8, 9, 10, 11, 12
.byt 13, 14, 15, 16, 17
.byt 18, 63, 20, 21, 22
.byt 23, 64, 25, 26, 65
.byt 0, 66, 67, 68, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 33, 34, 0
.byt 0, 35, 36, 37, 38
.byt 39, 40, 41, 42, 43
.byt 44, 45, 46, 47, 48
.byt 69, 70, 71, 72, 73
.byt 0, 74, 75, 76, 77
.byt 0, 78, 79, 80, 81
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 82, 83, 84, 85, 0
.byt 86, 87, 88, 89, 0
.byt 90, 91, 92, 93, 0
.byt 94, 95, 96, 97, 0
.byt 98, 99, 100, 101, 102
.byt 103, 104, 105, 106, 0
; Animatory state 5 (05-stepd1.png)
.byt 0, 107, 108, 2, 0
.byt 109, 110, 111, 112, 0
.byt 113, 114, 115, 116, 0
.byt 117, 118, 119, 120, 0
.byt 121, 122, 123, 124, 0
.byt 125, 126, 127, 128, 0
.byt 129, 130, 131, 132, 0
; Animatory state 6 (06-stepd2.png)
.byt 0, 107, 108, 2, 0
.byt 109, 110, 111, 112, 0
.byt 113, 114, 115, 133, 0
.byt 117, 118, 119, 134, 0
.byt 135, 136, 137, 138, 0
.byt 139, 140, 141, 142, 0
.byt 143, 144, 145, 146, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 82, 147, 148, 85, 0
.byt 149, 150, 150, 151, 0
.byt 152, 153, 150, 154, 0
.byt 155, 156, 157, 158, 0
.byt 159, 160, 161, 162, 102
.byt 163, 164, 165, 166, 0
; Animatory state 8 (08-stepdb1.png)
.byt 0, 107, 108, 2, 0
.byt 109, 167, 150, 168, 0
.byt 169, 170, 150, 171, 0
.byt 172, 173, 174, 175, 0
.byt 176, 177, 178, 179, 0
.byt 180, 181, 182, 183, 0
.byt 0, 184, 185, 186, 0
; Animatory state 9 (09-stepdb2.png)
.byt 0, 107, 108, 2, 0
.byt 109, 167, 150, 168, 0
.byt 187, 170, 150, 171, 0
.byt 188, 189, 190, 191, 0
.byt 192, 193, 194, 195, 0
.byt 196, 197, 198, 199, 0
.byt 200, 201, 202, 203, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 82, 83, 84, 85, 0
.byt 86, 87, 88, 89, 0
.byt 90, 204, 205, 93, 0
.byt 94, 206, 207, 97, 0
.byt 98, 99, 100, 101, 102
.byt 103, 104, 105, 106, 0
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 1, 2, 0
.byt 3, 4, 5, 6, 7
.byt 8, 9, 10, 11, 12
.byt 13, 208, 209, 210, 211
.byt 18, 212, 213, 214, 215
.byt 23, 24, 25, 26, 27
.byt 28, 29, 30, 31, 32
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $0, $0, $1, $3, $7, $f, $1e, $3d
; Tile graphic 5
.byt $f, $3f, $3f, $3f, $39, $27, $1f, $3f
; Tile graphic 6
.byt $20, $38, $3c, $3c, $3e, $26, $3b, $3b
; Tile graphic 7
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 8
.byt $1, $1, $3, $3, $7, $7, $f, $f
; Tile graphic 9
.byt $3b, $37, $36, $2c, $18, $10, $30, $20
; Tile graphic 10
.byt $30, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 11
.byt $d, $7, $3, $3, $1, $0, $0, $0
; Tile graphic 12
.byt $20, $20, $30, $30, $30, $38, $18, $18
; Tile graphic 13
.byt $1d, $1d, $1b, $b, $e, $e, $7, $7
; Tile graphic 14
.byt $24, $22, $25, $22, $33, $39, $1c, $2e
; Tile graphic 15
.byt $5, $2a, $14, $2a, $38, $3f, $3c, $f
; Tile graphic 16
.byt $1, $2a, $14, $2a, $14, $3c, $38, $31
; Tile graphic 17
.byt $18, $18, $10, $10, $30, $30, $20, $0
; Tile graphic 18
.byt $2, $1, $0, $1, $3, $3, $3, $3
; Tile graphic 19
.byt $7, $33, $8, $27, $39, $2a, $37, $23
; Tile graphic 20
.byt $7, $30, $38, $1f, $20, $3f, $1f, $20
; Tile graphic 21
.byt $23, $7, $1c, $32, $8, $39, $31, $9
; Tile graphic 22
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 23
.byt $7, $7, $c, $3, $7, $7, $7, $0
; Tile graphic 24
.byt $15, $23, $17, $23, $11, $0, $37, $b
; Tile graphic 25
.byt $3e, $3e, $3e, $3e, $3e, $0, $3e, $3e
; Tile graphic 26
.byt $3d, $39, $3d, $38, $39, $0, $3d, $38
; Tile graphic 27
.byt $20, $20, $30, $0, $20, $20, $20, $0
; Tile graphic 28
.byt $0, $0, $0, $0, $0, $0, $1, $0
; Tile graphic 29
.byt $17, $f, $17, $f, $17, $0, $3f, $0
; Tile graphic 30
.byt $3e, $3e, $3e, $3e, $3e, $0, $20, $0
; Tile graphic 31
.byt $3c, $38, $3c, $3a, $3d, $0, $3f, $0
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $0, $20, $0
; Tile graphic 33
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 34
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 35
.byt $0, $0, $0, $0, $1, $3, $7, $f
; Tile graphic 36
.byt $3, $f, $1f, $3f, $3e, $39, $27, $1f
; Tile graphic 37
.byt $38, $3e, $3f, $3f, $1f, $39, $3e, $3e
; Tile graphic 38
.byt $0, $0, $0, $0, $20, $20, $30, $30
; Tile graphic 39
.byt $0, $0, $0, $0, $1, $1, $3, $3
; Tile graphic 40
.byt $1e, $1d, $3d, $3b, $36, $34, $3c, $38
; Tile graphic 41
.byt $3c, $30, $20, $0, $0, $0, $0, $0
; Tile graphic 42
.byt $3, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 43
.byt $18, $38, $3c, $3c, $1c, $e, $6, $6
; Tile graphic 44
.byt $7, $7, $6, $2, $3, $3, $1, $1
; Tile graphic 45
.byt $19, $18, $39, $38, $2c, $2e, $37, $3b
; Tile graphic 46
.byt $1, $2a, $15, $2a, $3e, $1f, $f, $23
; Tile graphic 47
.byt $10, $2a, $5, $2a, $5, $3f, $e, $3c
; Tile graphic 48
.byt $16, $26, $4, $24, $c, $c, $8, $10
; Tile graphic 49
.byt $0, $0, $0, $0, $1, $3, $3, $7
; Tile graphic 50
.byt $21, $1c, $2, $19, $3e, $36, $2f, $27
; Tile graphic 51
.byt $31, $3c, $e, $37, $18, $2f, $37, $38
; Tile graphic 52
.byt $38, $1, $7, $3c, $2, $3e, $3c, $2
; Tile graphic 53
.byt $30, $30, $0, $20, $0, $10, $2e, $2e
; Tile graphic 54
.byt $7, $f, $e, $d, $b, $3, $0, $0
; Tile graphic 55
.byt $27, $7, $33, $23, $33, $30, $3, $7
; Tile graphic 56
.byt $3f, $3f, $3f, $3f, $3f, $0, $3f, $3a
; Tile graphic 57
.byt $2f, $2f, $2f, $2e, $2e, $0, $2e, $2f
; Tile graphic 58
.byt $e, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 59
.byt $7, $6, $f, $a, $f, $1f, $18, $0
; Tile graphic 60
.byt $3f, $2b, $3f, $2f, $3f, $3f, $0, $0
; Tile graphic 61
.byt $2e, $2f, $36, $37, $38, $3b, $0, $0
; Tile graphic 62
.byt $0, $0, $20, $0, $1c, $20, $0, $0
; Tile graphic 63
.byt $7, $33, $8, $27, $39, $2a, $37, $27
; Tile graphic 64
.byt $17, $27, $17, $23, $15, $0, $37, $f
; Tile graphic 65
.byt $20, $20, $30, $10, $20, $20, $20, $0
; Tile graphic 66
.byt $17, $f, $17, $f, $17, $0, $f, $0
; Tile graphic 67
.byt $3e, $3e, $3e, $3e, $3e, $0, $39, $0
; Tile graphic 68
.byt $3c, $38, $3c, $38, $3c, $0, $3e, $0
; Tile graphic 69
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 70
.byt $21, $1c, $2, $19, $1e, $1a, $1d, $18
; Tile graphic 71
.byt $31, $3c, $e, $37, $18, $2f, $27, $38
; Tile graphic 72
.byt $38, $1, $7, $3c, $3, $3e, $3c, $1
; Tile graphic 73
.byt $30, $30, $0, $0, $0, $0, $20, $0
; Tile graphic 74
.byt $15, $1f, $1e, $e, $7, $1, $2, $1
; Tile graphic 75
.byt $7, $1b, $33, $2b, $17, $0, $d, $3f
; Tile graphic 76
.byt $2e, $2d, $2e, $2d, $2e, $0, $e, $2f
; Tile graphic 77
.byt $20, $0, $20, $0, $0, $0, $20, $0
; Tile graphic 78
.byt $0, $1, $2, $1, $2, $4, $3, $0
; Tile graphic 79
.byt $3d, $3f, $35, $3f, $3f, $1, $3c, $0
; Tile graphic 80
.byt $2f, $1f, $1f, $1f, $1e, $19, $4, $0
; Tile graphic 81
.byt $20, $10, $28, $20, $18, $20, $0, $0
; Tile graphic 82
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 83
.byt $0, $3, $f, $1f, $1f, $3c, $33, $2f
; Tile graphic 84
.byt $0, $38, $3e, $3f, $3f, $7, $39, $3e
; Tile graphic 85
.byt $0, $0, $0, $0, $0, $20, $20, $30
; Tile graphic 86
.byt $1, $3, $3, $7, $7, $7, $e, $c
; Tile graphic 87
.byt $2f, $18, $30, $20, $20, $0, $0, $0
; Tile graphic 88
.byt $3e, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 89
.byt $30, $18, $38, $3c, $3c, $1c, $e, $6
; Tile graphic 90
.byt $c, $d, $c, $4, $4, $6, $6, $2
; Tile graphic 91
.byt $0, $1, $2a, $15, $2a, $14, $1f, $e
; Tile graphic 92
.byt $0, $10, $a, $15, $2a, $5, $1f, $e
; Tile graphic 93
.byt $6, $16, $26, $4, $24, $c, $c, $8
; Tile graphic 94
.byt $1, $1, $1, $2, $6, $7, $7, $7
; Tile graphic 95
.byt $7, $23, $30, $1c, $27, $18, $2f, $7
; Tile graphic 96
.byt $3c, $38, $1, $7, $3c, $1, $1f, $1e
; Tile graphic 97
.byt $10, $30, $30, $c, $2e, $2e, $1e, $e
; Tile graphic 98
.byt $e, $f, $18, $7, $e, $e, $f, $0
; Tile graphic 99
.byt $2b, $7, $2f, $7, $23, $0, $f, $17
; Tile graphic 100
.byt $1d, $1e, $1f, $1e, $1c, $0, $1f, $1e
; Tile graphic 101
.byt $17, $f, $11, $e, $17, $7, $f, $20
; Tile graphic 102
.byt $0, $0, $20, $0, $0, $0, $0, $0
; Tile graphic 103
.byt $0, $0, $0, $0, $0, $0, $3, $0
; Tile graphic 104
.byt $2f, $1f, $2f, $1f, $2f, $0, $3f, $0
; Tile graphic 105
.byt $1f, $1f, $1f, $1f, $1f, $0, $f, $0
; Tile graphic 106
.byt $10, $20, $10, $20, $10, $0, $3c, $0
; Tile graphic 107
.byt $0, $0, $0, $0, $0, $3, $f, $1f
; Tile graphic 108
.byt $0, $0, $0, $0, $0, $38, $3e, $3f
; Tile graphic 109
.byt $0, $0, $0, $1, $1, $3, $3, $7
; Tile graphic 110
.byt $1f, $3c, $33, $2f, $2f, $18, $30, $20
; Tile graphic 111
.byt $3f, $7, $39, $3e, $3e, $3, $1, $0
; Tile graphic 112
.byt $0, $20, $20, $30, $30, $18, $38, $3c
; Tile graphic 113
.byt $7, $7, $e, $c, $c, $d, $c, $4
; Tile graphic 114
.byt $20, $0, $0, $0, $0, $1, $2a, $15
; Tile graphic 115
.byt $0, $0, $0, $0, $0, $10, $a, $15
; Tile graphic 116
.byt $3c, $1c, $e, $6, $6, $16, $26, $4
; Tile graphic 117
.byt $4, $6, $6, $2, $1, $1, $1, $2
; Tile graphic 118
.byt $2a, $14, $1f, $e, $7, $23, $30, $1c
; Tile graphic 119
.byt $2a, $5, $1f, $e, $3c, $38, $1, $7
; Tile graphic 120
.byt $24, $c, $c, $8, $10, $30, $30, $8
; Tile graphic 121
.byt $3, $7, $6, $e, $8, $b, $3, $3
; Tile graphic 122
.byt $27, $38, $3f, $3f, $b, $27, $37, $37
; Tile graphic 123
.byt $3c, $1, $1f, $1e, $1d, $1e, $1f, $1e
; Tile graphic 124
.byt $2c, $24, $14, $4, $14, $4, $10, $0
; Tile graphic 125
.byt $3, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 126
.byt $33, $0, $2f, $17, $2f, $1f, $2b, $15
; Tile graphic 127
.byt $1c, $0, $1f, $1e, $1f, $1f, $1f, $1f
; Tile graphic 128
.byt $10, $0, $0, $20, $10, $20, $10, $20
; Tile graphic 129
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 130
.byt $3f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 131
.byt $1f, $0, $f, $0, $0, $0, $0, $0
; Tile graphic 132
.byt $10, $0, $38, $0, $0, $0, $0, $0
; Tile graphic 133
.byt $3c, $1c, $e, $6, $6, $16, $26, $4
; Tile graphic 134
.byt $24, $c, $c, $8, $10, $30, $30, $8
; Tile graphic 135
.byt $6, $4, $5, $4, $5, $4, $1, $0
; Tile graphic 136
.byt $27, $30, $1f, $f, $17, $f, $1f, $f
; Tile graphic 137
.byt $3c, $1, $1f, $1f, $1a, $1c, $1d, $1d
; Tile graphic 138
.byt $38, $3c, $2c, $2e, $2, $3a, $38, $38
; Tile graphic 139
.byt $1, $0, $0, $0, $1, $0, $1, $0
; Tile graphic 140
.byt $7, $0, $1f, $2f, $1f, $3f, $1f, $3f
; Tile graphic 141
.byt $19, $0, $1e, $1d, $1e, $1f, $1a, $15
; Tile graphic 142
.byt $38, $0, $20, $0, $20, $0, $20, $0
; Tile graphic 143
.byt $1, $0, $3, $0, $0, $0, $0, $0
; Tile graphic 144
.byt $1f, $0, $3e, $0, $0, $0, $0, $0
; Tile graphic 145
.byt $1f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 146
.byt $30, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 147
.byt $0, $3, $f, $1f, $1f, $3f, $3f, $3f
; Tile graphic 148
.byt $0, $38, $3e, $3f, $3f, $3f, $3f, $3f
; Tile graphic 149
.byt $1, $3, $3, $7, $7, $7, $f, $f
; Tile graphic 150
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 151
.byt $30, $38, $38, $3c, $3c, $3c, $3e, $3e
; Tile graphic 152
.byt $f, $f, $f, $7, $7, $7, $5, $2
; Tile graphic 153
.byt $3f, $3f, $3f, $3b, $3f, $3d, $3f, $1e
; Tile graphic 154
.byt $36, $36, $36, $34, $34, $2c, $2c, $10
; Tile graphic 155
.byt $0, $1, $1, $2, $6, $7, $6, $e
; Tile graphic 156
.byt $2f, $7, $31, $16, $23, $19, $3d, $1e
; Tile graphic 157
.byt $3e, $3d, $3d, $3a, $34, $31, $37, $37
; Tile graphic 158
.byt $20, $0, $8, $14, $36, $36, $36, $26
; Tile graphic 159
.byt $e, $e, $18, $6, $e, $e, $e, $0
; Tile graphic 160
.byt $3e, $1f, $3f, $1f, $2b, $0, $f, $17
; Tile graphic 161
.byt $2f, $1f, $3f, $3f, $3f, $0, $3f, $3e
; Tile graphic 162
.byt $37, $27, $31, $26, $17, $7, $7, $20
; Tile graphic 163
.byt $0, $0, $0, $0, $0, $1, $2, $0
; Tile graphic 164
.byt $2f, $1f, $2f, $1f, $2f, $3f, $0, $0
; Tile graphic 165
.byt $3f, $3f, $3f, $3f, $3f, $3f, $0, $0
; Tile graphic 166
.byt $10, $20, $10, $20, $10, $38, $4, $0
; Tile graphic 167
.byt $1f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 168
.byt $0, $20, $20, $30, $30, $38, $38, $3c
; Tile graphic 169
.byt $7, $7, $f, $f, $f, $f, $f, $7
; Tile graphic 170
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3b
; Tile graphic 171
.byt $3c, $3c, $3e, $3e, $36, $36, $36, $34
; Tile graphic 172
.byt $7, $7, $5, $2, $0, $1, $1, $2
; Tile graphic 173
.byt $3f, $3d, $3f, $1e, $2f, $7, $31, $16
; Tile graphic 174
.byt $3f, $3f, $3f, $3f, $3e, $3d, $3d, $3a
; Tile graphic 175
.byt $34, $2c, $2c, $10, $20, $6, $a, $14
; Tile graphic 176
.byt $6, $6, $6, $f, $f, $f, $8, $7
; Tile graphic 177
.byt $23, $19, $3d, $1e, $1e, $1f, $1f, $1f
; Tile graphic 178
.byt $34, $31, $37, $37, $2f, $1f, $3f, $3f
; Tile graphic 179
.byt $36, $36, $36, $22, $32, $20, $30, $20
; Tile graphic 180
.byt $7, $7, $0, $0, $0, $0, $0, $0
; Tile graphic 181
.byt $2b, $0, $f, $17, $2b, $10, $20, $5
; Tile graphic 182
.byt $3f, $0, $3f, $3e, $3f, $3f, $1f, $1f
; Tile graphic 183
.byt $10, $0, $0, $20, $10, $20, $10, $20
; Tile graphic 184
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 185
.byt $1f, $1f, $0, $0, $0, $0, $0, $0
; Tile graphic 186
.byt $10, $38, $4, $0, $0, $0, $0, $0
; Tile graphic 187
.byt $7, $7, $f, $f, $f, $f, $d, $5
; Tile graphic 188
.byt $5, $6, $0, $2, $0, $c, $a, $5
; Tile graphic 189
.byt $3f, $3d, $3f, $1e, $f, $7, $11, $6
; Tile graphic 190
.byt $3f, $3f, $3f, $3f, $3e, $3d, $3d, $3b
; Tile graphic 191
.byt $34, $2c, $2c, $10, $30, $30, $30, $8
; Tile graphic 192
.byt $d, $d, $d, $8, $9, $0, $1, $0
; Tile graphic 193
.byt $23, $31, $3d, $3e, $3e, $3f, $3f, $3f
; Tile graphic 194
.byt $34, $33, $37, $37, $2f, $1f, $3f, $3f
; Tile graphic 195
.byt $2c, $c, $2c, $1e, $1e, $1e, $2, $1c
; Tile graphic 196
.byt $1, $0, $0, $0, $1, $0, $1, $0
; Tile graphic 197
.byt $1f, $0, $1f, $2f, $1f, $3f, $1f, $3f
; Tile graphic 198
.byt $3a, $0, $3e, $3d, $3a, $21, $0, $14
; Tile graphic 199
.byt $3c, $1c, $0, $0, $20, $0, $20, $0
; Tile graphic 200
.byt $1, $3, $4, $0, $0, $0, $0, $0
; Tile graphic 201
.byt $1f, $3f, $0, $0, $0, $0, $0, $0
; Tile graphic 202
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 203
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 204
.byt $0, $1, $2a, $15, $2a, $18, $1c, $1f
; Tile graphic 205
.byt $0, $10, $a, $15, $2a, $3, $7, $1f
; Tile graphic 206
.byt $e, $27, $33, $18, $24, $1b, $2c, $7
; Tile graphic 207
.byt $e, $3c, $39, $3, $4, $39, $7, $1e
; Tile graphic 208
.byt $24, $22, $25, $27, $37, $33, $19, $2c
; Tile graphic 209
.byt $5, $2a, $14, $2a, $30, $38, $3f, $3c
; Tile graphic 210
.byt $1, $2a, $14, $2a, $4, $1c, $3c, $38
; Tile graphic 211
.byt $18, $18, $18, $10, $30, $30, $30, $20
; Tile graphic 212
.byt $e, $37, $b, $24, $39, $2a, $37, $23
; Tile graphic 213
.byt $f, $7, $30, $38, $1f, $20, $1f, $20
; Tile graphic 214
.byt $31, $23, $6, $1c, $30, $9, $31, $9
; Tile graphic 215
.byt $0, $0, $0, $0, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $70
; Tile mask 2
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 3
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 4
.byt $ff, $7e, $7c, $78, $70, $60, $40, $40
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $47, $43, $41, $41, $40, $40, $40, $40
; Tile mask 7
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f
; Tile mask 8
.byt $7c, $7c, $78, $78, $70, $70, $60, $60
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $4f, $4f, $47, $47, $47, $43, $43, $43
; Tile mask 13
.byt $40, $40, $40, $60, $60, $60, $70, $70
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $43, $43, $43, $47, $47, $47, $4f, $4f
; Tile mask 18
.byt $78, $78, $7c, $7c, $78, $78, $78, $78
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $5f, $5f, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 23
.byt $70, $70, $60, $60, $70, $70, $70, $78
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 26
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 27
.byt $4f, $4f, $47, $47, $4f, $4f, $4f, $5f
; Tile mask 28
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $7c
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $40, $40, $40, $40, $40, $40, $44, $5f
; Tile mask 31
.byt $41, $41, $41, $40, $40, $40, $40, $40
; Tile mask 32
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $4f
; Tile mask 33
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7c
; Tile mask 34
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $47
; Tile mask 35
.byt $ff, $ff, $ff, $7e, $7c, $78, $70, $60
; Tile mask 36
.byt $70, $60, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $ff, $ff, $5f, $5f, $4f, $4f, $47, $47
; Tile mask 39
.byt $ff, $ff, $7e, $7e, $7c, $7c, $78, $78
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $43, $43, $41, $41, $41, $40, $40, $40
; Tile mask 44
.byt $70, $70, $70, $78, $78, $78, $7c, $7c
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $40, $40, $40, $41, $41, $41, $43, $43
; Tile mask 49
.byt $7e, $7e, $ff, $7e, $7c, $78, $78, $70
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 52
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 53
.byt $47, $47, $4f, $4f, $47, $41, $40, $40
; Tile mask 54
.byt $70, $60, $60, $60, $60, $70, $7c, $ff
; Tile mask 55
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $40, $41, $41, $43, $57, $5f, $5f, $5f
; Tile mask 59
.byt $70, $70, $60, $60, $60, $40, $40, $40
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $ff
; Tile mask 62
.byt $5f, $4f, $47, $41, $41, $41, $5f, $ff
; Tile mask 63
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 64
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $4f, $4f, $47, $47, $47, $4f, $4f, $5f
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $44
; Tile mask 68
.byt $41, $41, $41, $43, $41, $41, $40, $40
; Tile mask 69
.byt $7e, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 70
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 73
.byt $47, $47, $47, $47, $47, $4f, $4f, $4f
; Tile mask 74
.byt $40, $40, $40, $60, $70, $78, $78, $78
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 77
.byt $4f, $4f, $4f, $5f, $5f, $4f, $4f, $4f
; Tile mask 78
.byt $7c, $7c, $78, $78, $78, $70, $70, $70
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 80
.byt $40, $40, $40, $40, $40, $40, $40, $73
; Tile mask 81
.byt $47, $47, $43, $43, $41, $41, $5f, $ff
; Tile mask 82
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7e, $7c
; Tile mask 83
.byt $7c, $70, $60, $40, $40, $40, $40, $40
; Tile mask 84
.byt $47, $41, $40, $40, $40, $40, $40, $40
; Tile mask 85
.byt $ff, $ff, $ff, $5f, $5f, $4f, $4f, $47
; Tile mask 86
.byt $7c, $78, $78, $70, $70, $70, $60, $60
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 89
.byt $47, $43, $43, $41, $41, $41, $40, $40
; Tile mask 90
.byt $60, $60, $60, $60, $70, $70, $70, $78
; Tile mask 91
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 92
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 93
.byt $40, $40, $40, $40, $41, $41, $41, $43
; Tile mask 94
.byt $78, $7c, $7c, $78, $70, $70, $70, $70
; Tile mask 95
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 96
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 97
.byt $43, $47, $43, $41, $40, $40, $40, $40
; Tile mask 98
.byt $60, $60, $40, $40, $60, $60, $60, $70
; Tile mask 99
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 100
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 101
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 102
.byt $5f, $5f, $4f, $4f, $5f, $5f, $5f, $ff
; Tile mask 103
.byt $7e, $7e, $7e, $7e, $7c, $78, $78, $78
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 106
.byt $47, $47, $47, $47, $43, $41, $41, $41
; Tile mask 107
.byt $ff, $ff, $ff, $ff, $7c, $70, $60, $40
; Tile mask 108
.byt $ff, $ff, $ff, $ff, $47, $41, $40, $40
; Tile mask 109
.byt $ff, $7e, $7e, $7c, $7c, $78, $78, $70
; Tile mask 110
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 111
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 112
.byt $5f, $4f, $4f, $47, $47, $43, $43, $41
; Tile mask 113
.byt $70, $70, $60, $60, $60, $60, $60, $60
; Tile mask 114
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 115
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $41, $41, $40, $40, $40, $40, $40, $41
; Tile mask 117
.byt $70, $70, $70, $78, $78, $7c, $7c, $78
; Tile mask 118
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 119
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 120
.byt $41, $41, $41, $41, $43, $47, $43, $43
; Tile mask 121
.byt $78, $70, $70, $60, $60, $60, $70, $78
; Tile mask 122
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 123
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 124
.byt $41, $41, $41, $41, $41, $41, $43, $43
; Tile mask 125
.byt $78, $7c, $7e, $7e, $7e, $7e, $7c, $7c
; Tile mask 126
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 127
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 128
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 129
.byt $7c, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 130
.byt $40, $40, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 131
.byt $40, $60, $60, $70, $ff, $ff, $ff, $ff
; Tile mask 132
.byt $47, $47, $43, $43, $ff, $ff, $ff, $ff
; Tile mask 133
.byt $41, $41, $40, $40, $40, $40, $40, $40
; Tile mask 134
.byt $41, $41, $41, $43, $43, $47, $43, $43
; Tile mask 135
.byt $70, $70, $70, $70, $70, $70, $78, $78
; Tile mask 136
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 137
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 138
.byt $43, $41, $41, $40, $40, $40, $41, $43
; Tile mask 139
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 140
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 141
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 142
.byt $43, $47, $4f, $4f, $4f, $4f, $47, $47
; Tile mask 143
.byt $7c, $7c, $78, $78, $ff, $ff, $ff, $ff
; Tile mask 144
.byt $40, $40, $40, $41, $ff, $ff, $ff, $ff
; Tile mask 145
.byt $40, $60, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 146
.byt $47, $4f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 147
.byt $7c, $70, $60, $40, $40, $40, $40, $40
; Tile mask 148
.byt $47, $41, $40, $40, $40, $40, $40, $40
; Tile mask 149
.byt $7c, $78, $78, $70, $70, $70, $60, $60
; Tile mask 150
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 151
.byt $47, $43, $43, $41, $41, $41, $40, $40
; Tile mask 152
.byt $60, $60, $60, $60, $70, $70, $70, $78
; Tile mask 153
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 154
.byt $40, $40, $40, $40, $41, $41, $41, $43
; Tile mask 155
.byt $78, $7c, $7c, $78, $70, $70, $70, $60
; Tile mask 156
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 157
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 158
.byt $43, $47, $43, $41, $40, $40, $40, $40
; Tile mask 159
.byt $60, $60, $40, $40, $60, $60, $60, $70
; Tile mask 160
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 161
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 162
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 163
.byt $7e, $7e, $7e, $7e, $7c, $78, $78, $78
; Tile mask 164
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 165
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 166
.byt $47, $47, $47, $47, $43, $41, $41, $41
; Tile mask 167
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 168
.byt $5f, $4f, $4f, $47, $47, $43, $43, $41
; Tile mask 169
.byt $70, $70, $60, $60, $60, $60, $60, $60
; Tile mask 170
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 171
.byt $41, $41, $40, $40, $40, $40, $40, $40
; Tile mask 172
.byt $70, $70, $70, $78, $78, $7c, $7c, $78
; Tile mask 173
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 174
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 175
.byt $41, $41, $41, $43, $41, $40, $40, $40
; Tile mask 176
.byt $70, $70, $70, $60, $60, $60, $60, $60
; Tile mask 177
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 178
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 179
.byt $40, $40, $40, $40, $40, $45, $45, $47
; Tile mask 180
.byt $60, $70, $78, $7e, $7e, $7e, $7e, $7e
; Tile mask 181
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 182
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 183
.byt $47, $47, $47, $47, $47, $47, $47, $43
; Tile mask 184
.byt $40, $40, $60, $ff, $ff, $ff, $ff, $ff
; Tile mask 185
.byt $40, $40, $40, $70, $ff, $ff, $ff, $ff
; Tile mask 186
.byt $43, $41, $41, $41, $ff, $ff, $ff, $ff
; Tile mask 187
.byt $70, $70, $60, $60, $60, $60, $60, $60
; Tile mask 188
.byt $70, $70, $78, $78, $70, $60, $60, $60
; Tile mask 189
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 190
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 191
.byt $41, $41, $41, $43, $43, $47, $47, $43
; Tile mask 192
.byt $60, $60, $60, $60, $60, $74, $74, $7c
; Tile mask 193
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 194
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 195
.byt $41, $41, $41, $40, $40, $40, $40, $40
; Tile mask 196
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $78
; Tile mask 197
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 198
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 199
.byt $40, $41, $43, $4f, $4f, $4f, $4f, $4f
; Tile mask 200
.byt $78, $70, $70, $70, $ff, $ff, $ff, $ff
; Tile mask 201
.byt $40, $40, $40, $41, $ff, $ff, $ff, $ff
; Tile mask 202
.byt $40, $40, $40, $ff, $ff, $ff, $ff, $ff
; Tile mask 203
.byt $5f, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 204
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 205
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 206
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 207
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 208
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 209
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 210
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 211
.byt $43, $43, $43, $47, $47, $47, $47, $4f
; Tile mask 212
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 213
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 214
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 215
.byt $4f, $5f, $5f, $ff, $ff, $5f, $5f, $5f
res_end
.)

