.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 13
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
.byt 16, 17, 18, 19, 0
.byt 20, 21, 22, 23, 0
.byt 24, 25, 26, 27, 0
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 28, 29, 30, 31, 32
.byt 33, 34, 35, 36, 37
.byt 33, 38, 39, 40, 41
.byt 42, 43, 44, 45, 46
.byt 47, 48, 49, 50, 51
.byt 0, 52, 53, 54, 55
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 16, 17, 18, 19, 0
.byt 20, 21, 22, 23, 0
.byt 56, 57, 58, 27, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 28, 29, 30, 31, 32
.byt 33, 34, 35, 36, 37
.byt 33, 38, 39, 40, 41
.byt 59, 60, 61, 45, 62
.byt 63, 64, 65, 66, 0
.byt 0, 67, 68, 69, 70
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 16, 17, 18, 19, 0
.byt 20, 21, 22, 23, 0
.byt 24, 25, 26, 27, 0
; Animatory state 5 (05-stepd1.png)
.byt 71, 72, 73, 74, 0
.byt 75, 76, 77, 78, 79
.byt 80, 81, 82, 83, 84
.byt 85, 86, 87, 88, 0
.byt 89, 90, 91, 92, 0
.byt 93, 94, 95, 96, 0
.byt 97, 98, 99, 100, 0
; Animatory state 6 (06-stepd2.png)
.byt 71, 72, 73, 74, 0
.byt 75, 76, 77, 78, 79
.byt 80, 81, 82, 83, 84
.byt 85, 101, 87, 102, 0
.byt 103, 104, 105, 106, 0
.byt 107, 108, 109, 10, 0
.byt 110, 111, 112, 15, 0
; Animatory state 7 (07-back.png)
.byt 0, 113, 0, 0, 0
.byt 1, 114, 115, 116, 5
.byt 117, 118, 119, 120, 10
.byt 121, 122, 123, 124, 15
.byt 125, 126, 127, 128, 0
.byt 129, 130, 131, 132, 0
.byt 133, 134, 135, 136, 0
; Animatory state 8 (08-stepdb1.png)
.byt 71, 137, 138, 139, 0
.byt 140, 141, 142, 143, 79
.byt 144, 145, 146, 147, 84
.byt 148, 149, 150, 151, 0
.byt 152, 153, 154, 155, 0
.byt 93, 156, 157, 158, 0
.byt 0, 159, 160, 161, 0
; Animatory state 9 (09-stepdb2.png)
.byt 71, 137, 138, 139, 0
.byt 140, 141, 142, 143, 79
.byt 144, 145, 146, 147, 84
.byt 148, 149, 150, 151, 0
.byt 162, 163, 164, 165, 0
.byt 166, 167, 168, 0, 0
.byt 169, 170, 171, 0, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 172, 173, 174, 14, 15
.byt 16, 175, 176, 177, 0
.byt 20, 21, 22, 23, 0
.byt 24, 25, 26, 27, 0
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 172, 173, 174, 14, 15
.byt 16, 175, 176, 177, 0
.byt 20, 21, 22, 23, 0
.byt 24, 25, 26, 27, 0
; Animatory state 12 (12-armsup.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 178, 179, 13, 180, 181
.byt 182, 17, 18, 183, 0
.byt 93, 21, 22, 10, 0
.byt 24, 25, 26, 27, 0
costume_tiles
; Tile graphic 1
.byt $0, $1, $2, $5, $b, $15, $b, $15
; Tile graphic 2
.byt $0, $11, $3a, $15, $3c, $15, $2a, $14
; Tile graphic 3
.byt $0, $15, $2a, $1f, $2a, $17, $2, $11
; Tile graphic 4
.byt $0, $0, $28, $14, $2a, $35, $2a, $15
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $a, $14, $8, $14, $8, $14, $a, $14
; Tile graphic 7
.byt $28, $15, $0, $5, $f, $21, $1e, $31
; Tile graphic 8
.byt $38, $15, $3e, $3f, $3f, $38, $33, $30
; Tile graphic 9
.byt $a, $5, $22, $11, $22, $1, $2, $21
; Tile graphic 10
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 11
.byt $a, $14, $8, $10, $9, $11, $9, $10
; Tile graphic 12
.byt $2a, $3d, $3f, $3f, $3f, $3f, $3c, $3f
; Tile graphic 13
.byt $35, $3f, $3f, $3f, $f, $3f, $3, $3f
; Tile graphic 14
.byt $12, $30, $32, $30, $32, $30, $22, $20
; Tile graphic 15
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $28, $14, $2a, $b, $6, $7, $e, $e
; Tile graphic 17
.byt $1f, $f, $33, $1c, $23, $3c, $3f, $1d
; Tile graphic 18
.byt $f, $3e, $38, $6, $39, $7, $3f, $2e
; Tile graphic 19
.byt $2, $0, $8, $28, $30, $30, $10, $10
; Tile graphic 20
.byt $c, $1e, $1f, $0, $1e, $19, $1e, $0
; Tile graphic 21
.byt $b, $1f, $1f, $0, $2a, $0, $3f, $1f
; Tile graphic 22
.byt $34, $3e, $3e, $0, $2a, $0, $3e, $3f
; Tile graphic 23
.byt $18, $38, $3c, $0, $1c, $4, $1c, $0
; Tile graphic 24
.byt $0, $0, $1, $1, $7, $0, $f, $0
; Tile graphic 25
.byt $0, $3c, $38, $38, $3c, $1c, $38, $0
; Tile graphic 26
.byt $0, $1e, $f, $f, $1f, $1c, $f, $0
; Tile graphic 27
.byt $0, $0, $0, $0, $30, $0, $38, $0
; Tile graphic 28
.byt $0, $0, $0, $0, $1, $2, $1, $2
; Tile graphic 29
.byt $0, $a, $17, $2a, $1f, $2a, $1d, $2a
; Tile graphic 30
.byt $0, $a, $15, $2b, $25, $2a, $10, $22
; Tile graphic 31
.byt $0, $28, $15, $3a, $15, $3e, $15, $a
; Tile graphic 32
.byt $0, $0, $0, $20, $10, $28, $10, $28
; Tile graphic 33
.byt $1, $2, $1, $2, $1, $2, $1, $2
; Tile graphic 34
.byt $15, $22, $0, $20, $1, $24, $13, $26
; Tile graphic 35
.byt $7, $2a, $7, $2f, $3f, $f, $36, $e
; Tile graphic 36
.byt $1, $28, $34, $3a, $3c, $0, $18, $4
; Tile graphic 37
.byt $10, $28, $10, $8, $10, $8, $10, $8
; Tile graphic 38
.byt $15, $27, $7, $7, $f, $f, $f, $7
; Tile graphic 39
.byt $16, $2f, $3f, $3f, $39, $3f, $20, $3f
; Tile graphic 40
.byt $2a, $3e, $3e, $3e, $3e, $3e, $1c, $3c
; Tile graphic 41
.byt $10, $0, $10, $0, $10, $0, $10, $0
; Tile graphic 42
.byt $5, $2, $5, $1, $0, $0, $1, $7
; Tile graphic 43
.byt $3, $21, $16, $1b, $34, $3f, $37, $23
; Tile graphic 44
.byt $39, $3f, $1f, $20, $1f, $20, $3f, $2d
; Tile graphic 45
.byt $38, $30, $1, $35, $e, $3e, $3a, $32
; Tile graphic 46
.byt $10, $0, $0, $0, $0, $28, $18, $38
; Tile graphic 47
.byt $3, $1c, $1e, $1c, $1c, $0, $0, $0
; Tile graphic 48
.byt $1, $3, $3, $0, $5, $0, $7, $3
; Tile graphic 49
.byt $1e, $3f, $3f, $0, $15, $0, $3f, $3f
; Tile graphic 50
.byt $20, $30, $30, $0, $10, $0, $30, $30
; Tile graphic 51
.byt $38, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 52
.byt $0, $0, $2, $3, $7, $1, $0, $0
; Tile graphic 53
.byt $0, $f, $7, $33, $b, $33, $1, $0
; Tile graphic 54
.byt $0, $20, $20, $3c, $30, $3f, $38, $0
; Tile graphic 55
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 56
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 57
.byt $0, $3c, $1e, $1e, $3f, $38, $1f, $0
; Tile graphic 58
.byt $0, $1e, $f, $f, $2f, $4, $37, $0
; Tile graphic 59
.byt $5, $2, $5, $1, $0, $0, $1, $3
; Tile graphic 60
.byt $3, $21, $16, $1b, $34, $3f, $37, $32
; Tile graphic 61
.byt $39, $3f, $1f, $20, $1f, $20, $3f, $3d
; Tile graphic 62
.byt $10, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 63
.byt $3, $3, $3, $1, $0, $0, $0, $0
; Tile graphic 64
.byt $24, $a, $3c, $3b, $33, $17, $7, $0
; Tile graphic 65
.byt $3e, $3f, $f, $20, $35, $30, $f, $3f
; Tile graphic 66
.byt $20, $30, $30, $0, $10, $0, $30, $30
; Tile graphic 67
.byt $0, $7, $7, $f, $1f, $1e, $f, $0
; Tile graphic 68
.byt $0, $39, $31, $30, $30, $0, $38, $0
; Tile graphic 69
.byt $0, $38, $3c, $3f, $1c, $f, $0, $0
; Tile graphic 70
.byt $0, $0, $0, $0, $10, $20, $0, $0
; Tile graphic 71
.byt $0, $0, $0, $0, $0, $1, $2, $5
; Tile graphic 72
.byt $0, $0, $0, $0, $0, $11, $3a, $15
; Tile graphic 73
.byt $0, $0, $0, $0, $0, $15, $2a, $1f
; Tile graphic 74
.byt $0, $0, $0, $0, $0, $0, $28, $14
; Tile graphic 75
.byt $b, $15, $b, $15, $a, $14, $8, $14
; Tile graphic 76
.byt $3c, $15, $2a, $14, $28, $15, $0, $5
; Tile graphic 77
.byt $2a, $17, $2, $11, $38, $15, $3e, $3f
; Tile graphic 78
.byt $2a, $35, $2a, $15, $a, $5, $22, $11
; Tile graphic 79
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 80
.byt $8, $14, $a, $14, $a, $14, $8, $10
; Tile graphic 81
.byt $f, $21, $1e, $31, $2a, $3d, $3f, $3f
; Tile graphic 82
.byt $3f, $38, $33, $30, $35, $3f, $3f, $3f
; Tile graphic 83
.byt $22, $1, $2, $21, $12, $30, $32, $30
; Tile graphic 84
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 85
.byt $9, $11, $9, $10, $28, $14, $2a, $b
; Tile graphic 86
.byt $3f, $3f, $3c, $3f, $1f, $f, $33, $1c
; Tile graphic 87
.byt $f, $3f, $3, $3f, $f, $3e, $38, $6
; Tile graphic 88
.byt $32, $30, $22, $20, $2, $0, $8, $28
; Tile graphic 89
.byt $6, $7, $0, $e, $c, $e, $0, $0
; Tile graphic 90
.byt $23, $3c, $3f, $1d, $b, $1f, $1f, $0
; Tile graphic 91
.byt $39, $7, $3f, $2e, $34, $3e, $3e, $0
; Tile graphic 92
.byt $30, $30, $10, $10, $10, $0, $20, $0
; Tile graphic 93
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 94
.byt $2a, $0, $3f, $3f, $0, $3c, $18, $0
; Tile graphic 95
.byt $2a, $0, $3e, $3f, $0, $1e, $f, $f
; Tile graphic 96
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 97
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 98
.byt $3c, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 99
.byt $1f, $1c, $f, $0, $0, $0, $0, $0
; Tile graphic 100
.byt $20, $0, $30, $0, $0, $0, $0, $0
; Tile graphic 101
.byt $3f, $3f, $3c, $3f, $1f, $f, $33, $2c
; Tile graphic 102
.byt $32, $30, $22, $20, $2, $0, $8, $24
; Tile graphic 103
.byt $3, $3, $2, $2, $2, $0, $1, $0
; Tile graphic 104
.byt $33, $3c, $3f, $1d, $b, $1f, $1f, $0
; Tile graphic 105
.byt $39, $6, $3f, $2e, $34, $3e, $3e, $0
; Tile graphic 106
.byt $38, $38, $0, $14, $1c, $1c, $0, $0
; Tile graphic 107
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 108
.byt $15, $0, $1f, $3f, $0, $1e, $3c, $3c
; Tile graphic 109
.byt $15, $0, $3f, $3f, $0, $f, $6, $0
; Tile graphic 110
.byt $1, $0, $3, $0, $0, $0, $0, $0
; Tile graphic 111
.byt $3e, $e, $3c, $0, $0, $0, $0, $0
; Tile graphic 112
.byt $f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 113
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 114
.byt $8, $11, $3a, $15, $3c, $15, $2a, $15
; Tile graphic 115
.byt $0, $14, $2a, $1f, $2a, $17, $2a, $15
; Tile graphic 116
.byt $0, $0, $20, $14, $2a, $35, $2a, $15
; Tile graphic 117
.byt $a, $14, $8, $15, $8, $15, $a, $15
; Tile graphic 118
.byt $28, $11, $2a, $11, $2a, $11, $22, $1
; Tile graphic 119
.byt $2a, $11, $22, $15, $22, $11, $28, $15
; Tile graphic 120
.byt $2a, $15, $a, $5, $2a, $1, $2a, $11
; Tile graphic 121
.byt $a, $15, $a, $14, $a, $14, $a, $15
; Tile graphic 122
.byt $2a, $5, $a, $1, $20, $15, $20, $15
; Tile graphic 123
.byt $0, $5, $22, $5, $2a, $15, $8, $4
; Tile graphic 124
.byt $a, $14, $a, $4, $22, $14, $22, $10
; Tile graphic 125
.byt $a, $14, $8, $18, $4, $6, $e, $e
; Tile graphic 126
.byt $2a, $5, $2, $14, $2a, $3d, $3f, $3f
; Tile graphic 127
.byt $2a, $4, $28, $4, $28, $16, $3e, $3e
; Tile graphic 128
.byt $22, $0, $a, $c, $10, $30, $30, $30
; Tile graphic 129
.byt $6, $1e, $1e, $0, $1e, $18, $1e, $0
; Tile graphic 130
.byt $3f, $3f, $3f, $0, $2a, $0, $3f, $3f
; Tile graphic 131
.byt $3e, $3e, $3e, $0, $2a, $0, $3e, $3e
; Tile graphic 132
.byt $20, $38, $3c, $0, $3c, $c, $3c, $0
; Tile graphic 133
.byt $0, $0, $1, $3, $7, $f, $f, $0
; Tile graphic 134
.byt $0, $3c, $38, $38, $3c, $3c, $38, $0
; Tile graphic 135
.byt $0, $1e, $f, $f, $1f, $1f, $f, $0
; Tile graphic 136
.byt $0, $0, $0, $0, $30, $30, $38, $0
; Tile graphic 137
.byt $0, $0, $0, $0, $8, $11, $3a, $15
; Tile graphic 138
.byt $0, $0, $0, $0, $0, $14, $2a, $1f
; Tile graphic 139
.byt $0, $0, $0, $0, $0, $0, $20, $14
; Tile graphic 140
.byt $b, $15, $b, $15, $a, $14, $8, $15
; Tile graphic 141
.byt $3c, $15, $2a, $15, $28, $11, $2a, $11
; Tile graphic 142
.byt $2a, $17, $2a, $15, $2a, $11, $22, $15
; Tile graphic 143
.byt $2a, $35, $2a, $15, $2a, $15, $a, $5
; Tile graphic 144
.byt $8, $15, $a, $15, $a, $15, $a, $14
; Tile graphic 145
.byt $2a, $11, $22, $1, $2a, $5, $a, $1
; Tile graphic 146
.byt $22, $11, $28, $15, $0, $5, $22, $5
; Tile graphic 147
.byt $2a, $1, $2a, $11, $a, $14, $a, $4
; Tile graphic 148
.byt $a, $14, $a, $15, $a, $14, $8, $18
; Tile graphic 149
.byt $20, $15, $20, $15, $2a, $5, $2, $14
; Tile graphic 150
.byt $2a, $15, $8, $4, $2a, $4, $28, $4
; Tile graphic 151
.byt $22, $14, $22, $10, $22, $0, $a, $c
; Tile graphic 152
.byt $4, $6, $0, $c, $e, $e, $0, $0
; Tile graphic 153
.byt $2a, $3d, $3f, $3f, $3f, $3f, $3f, $0
; Tile graphic 154
.byt $28, $16, $3e, $3e, $3e, $3e, $3e, $0
; Tile graphic 155
.byt $10, $24, $30, $30, $0, $0, $0, $0
; Tile graphic 156
.byt $2a, $0, $3f, $27, $0, $3c, $0, $3c
; Tile graphic 157
.byt $2a, $0, $3e, $3e, $0, $1e, $f, $f
; Tile graphic 158
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 159
.byt $0, $18, $0, $0, $0, $0, $0, $0
; Tile graphic 160
.byt $1f, $1f, $1f, $0, $0, $0, $0, $0
; Tile graphic 161
.byt $20, $20, $20, $0, $0, $0, $0, $0
; Tile graphic 162
.byt $24, $12, $6, $6, $0, $0, $0, $0
; Tile graphic 163
.byt $2a, $3a, $3f, $3f, $3f, $3f, $3f, $0
; Tile graphic 164
.byt $28, $2e, $3e, $3e, $3e, $3e, $3e, $0
; Tile graphic 165
.byt $10, $30, $0, $18, $38, $38, $0, $0
; Tile graphic 166
.byt $0, $0, $0, $0, $0, $0, $1, $1
; Tile graphic 167
.byt $2a, $0, $3f, $3f, $0, $3c, $38, $38
; Tile graphic 168
.byt $2a, $0, $3e, $32, $0, $1e, $0, $1e
; Tile graphic 169
.byt $3, $3, $3, $0, $0, $0, $0, $0
; Tile graphic 170
.byt $3c, $3c, $3c, $0, $0, $0, $0, $0
; Tile graphic 171
.byt $0, $c, $0, $0, $0, $0, $0, $0
; Tile graphic 172
.byt $a, $14, $8, $10, $9, $11, $9, $11
; Tile graphic 173
.byt $2a, $3d, $3f, $3f, $3f, $3f, $3c, $3e
; Tile graphic 174
.byt $35, $3f, $3f, $3f, $f, $3f, $3, $7
; Tile graphic 175
.byt $3f, $1f, $2f, $13, $24, $3c, $3f, $1d
; Tile graphic 176
.byt $3f, $f, $3e, $38, $1, $7, $3f, $2e
; Tile graphic 177
.byt $22, $0, $8, $28, $30, $30, $10, $10
; Tile graphic 178
.byt $8, $14, $7, $7, $7, $3, $8, $e
; Tile graphic 179
.byt $2a, $d, $17, $27, $37, $37, $c, $3f
; Tile graphic 180
.byt $12, $31, $31, $30, $33, $33, $27, $27
; Tile graphic 181
.byt $20, $14, $2c, $3c, $1c, $0, $0, $0
; Tile graphic 182
.byt $2e, $e, $2e, $f, $7, $5, $0, $0
; Tile graphic 183
.byt $e, $1e, $1e, $3c, $38, $0, $0, $0
costume_masks
; Tile mask 1
.byt $7e, $7c, $78, $70, $60, $40, $40, $40
; Tile mask 2
.byt $48, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $47, $43, $41, $40, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 16
.byt $40, $40, $40, $70, $70, $70, $60, $60
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $41, $43, $47, $47, $47, $47, $47
; Tile mask 20
.byt $60, $40, $40, $40, $40, $40, $40, $60
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $43, $43, $41, $43, $41, $41, $41, $43
; Tile mask 24
.byt $7e, $7e, $7c, $78, $70, $60, $60, $60
; Tile mask 25
.byt $40, $41, $43, $43, $41, $41, $41, $47
; Tile mask 26
.byt $40, $40, $60, $60, $40, $40, $40, $70
; Tile mask 27
.byt $ff, $ff, $5f, $4f, $47, $43, $43, $43
; Tile mask 28
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 29
.byt $71, $60, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $47, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $ff, $ff, $5f, $4f, $47, $43, $43, $43
; Tile mask 33
.byt $78, $78, $78, $78, $78, $78, $78, $78
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $43, $47, $47, $47, $47, $47, $47, $47
; Tile mask 42
.byt $78, $78, $78, $7e, $7e, $7c, $78, $70
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $47, $4f, $5f, $ff, $47, $43, $43, $43
; Tile mask 47
.byt $60, $40, $40, $40, $41, $63, $ff, $ff
; Tile mask 48
.byt $40, $70, $70, $70, $70, $70, $70, $70
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $40, $46, $47, $47, $47, $47, $47, $47
; Tile mask 51
.byt $43, $47, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 52
.byt $70, $78, $78, $78, $70, $70, $7e, $ff
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $48, $7e
; Tile mask 54
.byt $47, $47, $43, $41, $40, $40, $40, $47
; Tile mask 55
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $ff
; Tile mask 56
.byt $7e, $7e, $ff, $ff, $7e, $7e, $7e, $ff
; Tile mask 57
.byt $40, $41, $40, $40, $40, $40, $40, $60
; Tile mask 58
.byt $40, $40, $60, $40, $40, $40, $40, $40
; Tile mask 59
.byt $78, $78, $78, $7e, $7e, $7c, $78, $78
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 62
.byt $47, $4f, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 63
.byt $78, $78, $78, $7c, $7e, $ff, $ff, $ff
; Tile mask 64
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 65
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 66
.byt $41, $47, $47, $47, $47, $47, $47, $47
; Tile mask 67
.byt $70, $70, $70, $60, $40, $40, $40, $70
; Tile mask 68
.byt $40, $40, $40, $44, $47, $43, $43, $43
; Tile mask 69
.byt $47, $43, $40, $40, $40, $60, $60, $ff
; Tile mask 70
.byt $ff, $ff, $ff, $4f, $47, $47, $4f, $ff
; Tile mask 71
.byt $ff, $ff, $ff, $ff, $7e, $7c, $78, $70
; Tile mask 72
.byt $ff, $ff, $ff, $ff, $48, $40, $40, $40
; Tile mask 73
.byt $ff, $ff, $ff, $ff, $40, $40, $40, $40
; Tile mask 74
.byt $ff, $ff, $ff, $ff, $ff, $47, $43, $41
; Tile mask 75
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 77
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $ff, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 80
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 81
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 82
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 84
.byt $5f, $5f, $5f, $5f, $5f, $ff, $ff, $ff
; Tile mask 85
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 86
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 88
.byt $40, $40, $40, $40, $40, $41, $43, $47
; Tile mask 89
.byt $70, $70, $60, $60, $60, $60, $70, $7e
; Tile mask 90
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 91
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 92
.byt $47, $47, $47, $47, $47, $4f, $4f, $5f
; Tile mask 93
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e
; Tile mask 94
.byt $40, $40, $40, $40, $40, $41, $41, $41
; Tile mask 95
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 96
.byt $ff, $ff, $5f, $5f, $ff, $ff, $5f, $5f
; Tile mask 97
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 98
.byt $41, $43, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 99
.byt $40, $40, $40, $70, $ff, $ff, $ff, $ff
; Tile mask 100
.byt $4f, $47, $47, $47, $ff, $ff, $ff, $ff
; Tile mask 101
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 102
.byt $40, $40, $40, $40, $40, $41, $43, $43
; Tile mask 103
.byt $78, $78, $78, $78, $78, $7c, $7c, $7e
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 106
.byt $43, $43, $43, $41, $41, $41, $43, $5f
; Tile mask 107
.byt $ff, $ff, $7e, $7e, $ff, $ff, $7e, $7e
; Tile mask 108
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 109
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 110
.byt $7c, $78, $78, $78, $ff, $ff, $ff, $ff
; Tile mask 111
.byt $40, $40, $40, $43, $ff, $ff, $ff, $ff
; Tile mask 112
.byt $60, $70, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 113
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $77
; Tile mask 114
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 115
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $ff, $4f, $41, $40, $40, $40, $40, $40
; Tile mask 117
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 118
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 119
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 121
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 122
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 123
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 124
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 125
.byt $40, $40, $40, $60, $70, $70, $60, $60
; Tile mask 126
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 127
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 128
.byt $40, $40, $40, $41, $43, $47, $47, $47
; Tile mask 129
.byt $60, $40, $40, $40, $40, $40, $40, $60
; Tile mask 130
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 131
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 132
.byt $43, $43, $41, $41, $41, $41, $41, $43
; Tile mask 133
.byt $7e, $7e, $7c, $78, $70, $60, $60, $60
; Tile mask 134
.byt $40, $41, $43, $43, $41, $41, $41, $47
; Tile mask 135
.byt $40, $40, $60, $60, $40, $40, $40, $70
; Tile mask 136
.byt $ff, $ff, $5f, $4f, $47, $43, $43, $43
; Tile mask 137
.byt $ff, $ff, $ff, $77, $40, $40, $40, $40
; Tile mask 138
.byt $ff, $ff, $ff, $ff, $41, $40, $40, $40
; Tile mask 139
.byt $ff, $ff, $ff, $ff, $ff, $4f, $41, $40
; Tile mask 140
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 141
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 142
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 143
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 144
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 145
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 146
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 147
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 148
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 149
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 150
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 151
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 152
.byt $70, $70, $70, $60, $60, $60, $70, $7e
; Tile mask 153
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 154
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 155
.byt $43, $41, $43, $47, $4f, $ff, $ff, $ff
; Tile mask 156
.byt $40, $40, $40, $40, $40, $41, $41, $41
; Tile mask 157
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 158
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f
; Tile mask 159
.byt $41, $43, $67, $ff, $ff, $ff, $ff, $ff
; Tile mask 160
.byt $40, $40, $40, $60, $ff, $ff, $ff, $ff
; Tile mask 161
.byt $4f, $4f, $4f, $4f, $ff, $ff, $ff, $ff
; Tile mask 162
.byt $40, $40, $60, $70, $78, $7e, $7e, $7e
; Tile mask 163
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 164
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 165
.byt $43, $47, $47, $43, $43, $43, $47, $ff
; Tile mask 166
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7c, $7c
; Tile mask 167
.byt $40, $40, $40, $40, $40, $41, $43, $43
; Tile mask 168
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 169
.byt $78, $78, $78, $78, $ff, $ff, $ff, $ff
; Tile mask 170
.byt $41, $41, $41, $43, $ff, $ff, $ff, $ff
; Tile mask 171
.byt $41, $61, $73, $ff, $ff, $ff, $ff, $ff
; Tile mask 172
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 173
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 174
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 175
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 176
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 177
.byt $40, $41, $43, $47, $47, $47, $47, $47
; Tile mask 178
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 179
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 180
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 181
.byt $43, $41, $41, $41, $41, $43, $5f, $5f
; Tile mask 182
.byt $40, $40, $40, $60, $60, $60, $70, $7c
; Tile mask 183
.byt $40, $40, $40, $41, $43, $47, $5f, $5f
res_end
.)

