.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 17
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 2
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
	.byt <(anim_states2 - res_start), >(anim_states2 - res_start)
anim_states
; Animatory state 0 (00-lookRight.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 0
.byt 15, 16, 17, 18, 0
.byt 19, 20, 21, 22, 0
.byt 23, 24, 25, 26, 0
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 27, 28, 29, 30, 31
.byt 32, 33, 34, 35, 36
.byt 37, 38, 39, 40, 41
.byt 42, 43, 44, 45, 46
.byt 47, 48, 49, 50, 51
.byt 0, 52, 53, 54, 55
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 0
.byt 56, 57, 17, 58, 0
.byt 59, 60, 21, 61, 62
.byt 63, 64, 65, 66, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 27, 28, 29, 30, 31
.byt 32, 33, 34, 35, 36
.byt 37, 38, 39, 40, 41
.byt 67, 68, 69, 45, 70
.byt 71, 72, 73, 74, 0
.byt 0, 75, 76, 77, 78
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 79, 29, 80, 81, 0
.byt 82, 34, 35, 83, 84
.byt 85, 86, 87, 88, 89
.byt 90, 91, 92, 93, 0
.byt 59, 94, 95, 96, 97
.byt 98, 99, 100, 101, 0
; Animatory state 5 (05-stepd1.png)
.byt 102, 103, 104, 105, 0
.byt 106, 107, 108, 109, 110
.byt 111, 112, 113, 114, 115
.byt 116, 117, 118, 119, 0
.byt 120, 121, 122, 123, 0
.byt 124, 125, 126, 127, 0
.byt 128, 129, 130, 131, 0
; Animatory state 6 (06-stepd2.png)
.byt 102, 103, 104, 105, 0
.byt 106, 107, 108, 109, 110
.byt 111, 112, 113, 114, 115
.byt 116, 132, 133, 134, 0
.byt 135, 136, 137, 138, 139
.byt 32, 140, 141, 142, 0
.byt 143, 144, 145, 146, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 147, 148, 149, 150, 0
.byt 151, 152, 153, 154, 155
.byt 156, 157, 158, 159, 160
.byt 161, 162, 163, 164, 0
.byt 165, 166, 167, 168, 97
.byt 169, 170, 171, 172, 0
; Animatory state 8 (08-stepdb1.png)
.byt 173, 174, 175, 176, 0
.byt 177, 178, 179, 180, 5
.byt 181, 182, 183, 184, 10
.byt 185, 186, 187, 188, 0
.byt 189, 190, 191, 192, 0
.byt 193, 194, 195, 196, 0
.byt 0, 197, 198, 199, 0
; Animatory state 9 (09-stepdb2.png)
.byt 102, 103, 200, 105, 0
.byt 201, 202, 203, 204, 110
.byt 205, 206, 207, 208, 115
.byt 209, 210, 211, 212, 0
.byt 213, 214, 215, 216, 217
.byt 218, 219, 220, 221, 222
.byt 223, 224, 225, 226, 0
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 79, 29, 80, 81, 0
.byt 82, 34, 35, 83, 84
.byt 227, 228, 229, 230, 89
.byt 231, 232, 233, 234, 0
.byt 59, 94, 95, 96, 97
.byt 98, 99, 100, 101, 0
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 235, 236, 237, 238, 0
.byt 15, 239, 240, 241, 0
.byt 19, 20, 21, 22, 0
.byt 23, 24, 25, 26, 0


; Costume 1
anim_states2
; Animatory state 0 (12-lookRight-armed.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 0
.byt 15, 242, 17, 18, 0
.byt 243, 244, 245, 22, 0
.byt 23, 24, 25, 26, 0
; Animatory state 1 (14-handup-armed.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 247, 248, 249, 250
.byt 235, 236, 237, 251, 252
.byt 15, 246, 240, 253, 254
.byt 243, 244, 245, 255, 0
.byt 23, 24, 25, 26, 0

; Animatory state 2
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 3
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 4
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 5
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 6
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 7
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 8
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 9
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 10
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0

; Animatory state 11 (13-TalkRight-armed.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 235, 236, 237, 238, 0
.byt 15, 246, 240, 241, 0
.byt 243, 244, 245, 22, 0
.byt 23, 24, 25, 26, 0


costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $1, $2, $1, $2, $4
; Tile graphic 2
.byt $0, $1, $a, $0, $3, $f, $f, $1f
; Tile graphic 3
.byt $0, $15, $2a, $0, $0, $20, $3f, $3f
; Tile graphic 4
.byt $0, $0, $28, $0, $10, $3a, $39, $3e
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $2, $0, $0, $4, $2, $1, $0, $3
; Tile graphic 7
.byt $1f, $1f, $f, $f, $c, $19, $e, $1d
; Tile graphic 8
.byt $3f, $3f, $3f, $3f, $f, $36, $6, $16
; Tile graphic 9
.byt $3d, $3e, $3e, $3f, $2, $39, $4, $28
; Tile graphic 10
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 11
.byt $3, $3, $1, $0, $0, $1, $c, $e
; Tile graphic 12
.byt $f, $1f, $2f, $17, $2f, $17, $2a, $14
; Tile graphic 13
.byt $2e, $3f, $3f, $26, $28, $15, $20, $1f
; Tile graphic 14
.byt $1c, $1c, $3e, $3c, $3e, $1c, $28, $24
; Tile graphic 15
.byt $e, $7, $4, $3, $3, $7, $f, $f
; Tile graphic 16
.byt $a, $5, $22, $11, $28, $12, $15, $16
; Tile graphic 17
.byt $30, $15, $2a, $15, $a, $0, $1e, $2e
; Tile graphic 18
.byt $28, $10, $28, $10, $24, $14, $24, $24
; Tile graphic 19
.byt $f, $e, $0, $1f, $1d, $1c, $1f, $0
; Tile graphic 20
.byt $1a, $1b, $1d, $1d, $1d, $0, $1e, $3e
; Tile graphic 21
.byt $35, $1b, $1b, $2a, $2a, $0, $2a, $2a
; Tile graphic 22
.byt $24, $14, $10, $26, $26, $2, $26, $20
; Tile graphic 23
.byt $1, $1, $1, $1, $3, $0, $7, $0
; Tile graphic 24
.byt $3e, $3e, $3e, $3e, $3e, $0, $3e, $0
; Tile graphic 25
.byt $2a, $2a, $2a, $2a, $2a, $0, $3, $0
; Tile graphic 26
.byt $20, $20, $20, $28, $28, $0, $3e, $0
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 28
.byt $0, $0, $1, $8, $10, $9, $11, $23
; Tile graphic 29
.byt $0, $a, $15, $0, $18, $3c, $3f, $3f
; Tile graphic 30
.byt $0, $28, $15, $0, $2, $7, $3f, $3f
; Tile graphic 31
.byt $0, $0, $0, $0, $0, $10, $8, $30
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 33
.byt $13, $3, $1, $21, $11, $b, $1, $1b
; Tile graphic 34
.byt $3f, $3f, $3f, $3f, $21, $e, $30, $2a
; Tile graphic 35
.byt $3f, $3f, $3f, $3f, $38, $37, $30, $35
; Tile graphic 36
.byt $28, $30, $30, $38, $10, $8, $20, $0
; Tile graphic 37
.byt $0, $0, $0, $0, $0, $0, $1, $1
; Tile graphic 38
.byt $19, $1b, $d, $2, $5, $a, $25, $32
; Tile graphic 39
.byt $3d, $3f, $3f, $3c, $3d, $3a, $14, $23
; Tile graphic 40
.byt $33, $3b, $3f, $37, $7, $2b, $5, $3c
; Tile graphic 41
.byt $20, $20, $30, $20, $30, $20, $0, $20
; Tile graphic 42
.byt $1, $0, $0, $0, $0, $3, $3, $7
; Tile graphic 43
.byt $31, $18, $4, $1a, $3d, $36, $2e, $26
; Tile graphic 44
.byt $16, $2a, $15, $a, $1, $10, $2b, $35
; Tile graphic 45
.byt $5, $2a, $15, $2a, $14, $2, $34, $34
; Tile graphic 46
.byt $0, $0, $0, $0, $0, $10, $2e, $2e
; Tile graphic 47
.byt $7, $f, $e, $d, $b, $3, $0, $0
; Tile graphic 48
.byt $27, $7, $33, $23, $33, $30, $3, $7
; Tile graphic 49
.byt $16, $1b, $2b, $2d, $2d, $0, $35, $35
; Tile graphic 50
.byt $2d, $1b, $1b, $16, $16, $0, $16, $17
; Tile graphic 51
.byt $e, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 52
.byt $7, $6, $f, $b, $f, $1f, $18, $0
; Tile graphic 53
.byt $35, $35, $35, $35, $35, $0, $0, $0
; Tile graphic 54
.byt $16, $17, $16, $17, $10, $3, $0, $0
; Tile graphic 55
.byt $0, $0, $20, $0, $1c, $20, $0, $0
; Tile graphic 56
.byt $e, $7, $0, $3, $7, $7, $7, $7
; Tile graphic 57
.byt $a, $5, $2, $1, $20, $10, $24, $6
; Tile graphic 58
.byt $28, $10, $28, $10, $20, $12, $22, $2
; Tile graphic 59
.byt $e, $f, $18, $7, $e, $e, $f, $0
; Tile graphic 60
.byt $2a, $b, $2d, $5, $29, $0, $2e, $1e
; Tile graphic 61
.byt $2b, $13, $1b, $30, $33, $1, $3b, $30
; Tile graphic 62
.byt $0, $0, $20, $20, $0, $0, $0, $0
; Tile graphic 63
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 64
.byt $2e, $1e, $2e, $1e, $2e, $0, $1f, $0
; Tile graphic 65
.byt $2a, $2a, $2a, $2a, $28, $0, $33, $0
; Tile graphic 66
.byt $38, $30, $38, $30, $38, $0, $3c, $0
; Tile graphic 67
.byt $1, $0, $0, $0, $0, $1, $1, $1
; Tile graphic 68
.byt $31, $0, $24, $22, $39, $2a, $36, $22
; Tile graphic 69
.byt $16, $2a, $15, $a, $1, $10, $b, $35
; Tile graphic 70
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 71
.byt $1, $1, $1, $0, $0, $0, $0, $0
; Tile graphic 72
.byt $14, $3d, $3b, $3a, $1d, $4, $8, $7
; Tile graphic 73
.byt $16, $b, $b, $2d, $d, $0, $35, $35
; Tile graphic 74
.byt $2c, $1a, $1a, $16, $16, $6, $16, $14
; Tile graphic 75
.byt $3, $7, $b, $7, $b, $10, $f, $0
; Tile graphic 76
.byt $35, $35, $15, $35, $35, $0, $30, $0
; Tile graphic 77
.byt $16, $15, $16, $16, $11, $6, $10, $0
; Tile graphic 78
.byt $0, $0, $20, $0, $20, $0, $0, $0
; Tile graphic 79
.byt $0, $0, $1, $0, $0, $1, $1, $3
; Tile graphic 80
.byt $0, $35, $a, $0, $1, $3, $3f, $3f
; Tile graphic 81
.byt $0, $0, $28, $0, $20, $38, $38, $3c
; Tile graphic 82
.byt $3, $3, $1, $1, $1, $b, $1, $b
; Tile graphic 83
.byt $3c, $3c, $38, $38, $18, $d, $38, $1d
; Tile graphic 84
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 85
.byt $9, $b, $d, $2, $5, $2, $1, $0
; Tile graphic 86
.byt $3d, $3f, $3e, $3c, $3d, $3a, $14, $23
; Tile graphic 87
.byt $33, $37, $3f, $33, $b, $35, $2, $3c
; Tile graphic 88
.byt $39, $3d, $3a, $34, $38, $34, $28, $10
; Tile graphic 89
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 90
.byt $1, $0, $0, $2, $6, $7, $7, $7
; Tile graphic 91
.byt $16, $2a, $15, $a, $21, $18, $29, $2
; Tile graphic 92
.byt $6, $35, $a, $35, $8, $1, $33, $2a
; Tile graphic 93
.byt $20, $10, $20, $c, $2e, $2e, $1e, $e
; Tile graphic 94
.byt $2a, $5, $2d, $5, $21, $0, $d, $15
; Tile graphic 95
.byt $29, $16, $17, $16, $14, $0, $17, $16
; Tile graphic 96
.byt $17, $f, $11, $e, $17, $7, $f, $20
; Tile graphic 97
.byt $0, $0, $20, $0, $0, $0, $0, $0
; Tile graphic 98
.byt $0, $0, $0, $0, $0, $0, $3, $0
; Tile graphic 99
.byt $2d, $1d, $2d, $1d, $2d, $0, $3f, $0
; Tile graphic 100
.byt $17, $17, $17, $17, $17, $0, $f, $0
; Tile graphic 101
.byt $10, $20, $10, $20, $10, $0, $3c, $0
; Tile graphic 102
.byt $0, $0, $0, $0, $0, $0, $1, $0
; Tile graphic 103
.byt $0, $0, $0, $0, $0, $a, $15, $0
; Tile graphic 104
.byt $0, $0, $0, $0, $0, $35, $a, $0
; Tile graphic 105
.byt $0, $0, $0, $0, $0, $0, $28, $0
; Tile graphic 106
.byt $0, $1, $1, $3, $3, $3, $1, $1
; Tile graphic 107
.byt $18, $3c, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 108
.byt $1, $3, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 109
.byt $20, $38, $38, $3c, $3c, $3c, $38, $38
; Tile graphic 110
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 111
.byt $1, $b, $1, $b, $9, $b, $d, $2
; Tile graphic 112
.byt $21, $e, $30, $2a, $3d, $3f, $3e, $3c
; Tile graphic 113
.byt $38, $37, $30, $35, $33, $37, $3f, $33
; Tile graphic 114
.byt $18, $d, $38, $1d, $39, $3d, $3a, $34
; Tile graphic 115
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 116
.byt $5, $2, $1, $0, $0, $0, $0, $1
; Tile graphic 117
.byt $3d, $3a, $14, $23, $16, $22, $11, $a
; Tile graphic 118
.byt $b, $35, $2, $3c, $6, $35, $8, $1
; Tile graphic 119
.byt $38, $34, $2a, $10, $28, $10, $20, $4
; Tile graphic 120
.byt $1, $3, $3, $7, $4, $5, $1, $1
; Tile graphic 121
.byt $31, $3c, $1c, $1d, $5, $32, $3a, $3a
; Tile graphic 122
.byt $8, $0, $39, $15, $14, $2b, $2b, $2b
; Tile graphic 123
.byt $16, $32, $2a, $2, $2a, $2, $28, $0
; Tile graphic 124
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 125
.byt $38, $0, $16, $a, $16, $e, $14, $a
; Tile graphic 126
.byt $2a, $0, $2b, $2b, $2b, $2b, $2b, $2b
; Tile graphic 127
.byt $8, $0, $20, $10, $28, $30, $28, $30
; Tile graphic 128
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 129
.byt $3e, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 130
.byt $2b, $0, $7, $0, $0, $0, $0, $0
; Tile graphic 131
.byt $28, $0, $3c, $0, $0, $0, $0, $0
; Tile graphic 132
.byt $3d, $3a, $14, $23, $16, $2a, $15, $a
; Tile graphic 133
.byt $b, $35, $2, $3c, $6, $35, $a, $35
; Tile graphic 134
.byt $38, $34, $28, $10, $28, $10, $20, $4
; Tile graphic 135
.byt $3, $2, $2, $2, $2, $2, $0, $0
; Tile graphic 136
.byt $11, $18, $2c, $5, $2b, $6, $2e, $6
; Tile graphic 137
.byt $8, $0, $39, $15, $15, $2a, $2a, $2a
; Tile graphic 138
.byt $1c, $3e, $36, $37, $1, $1d, $3c, $3c
; Tile graphic 139
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 140
.byt $22, $0, $e, $16, $2e, $1e, $2e, $1e
; Tile graphic 141
.byt $28, $0, $2b, $2a, $2b, $2b, $29, $2a
; Tile graphic 142
.byt $3c, $0, $10, $20, $10, $20, $10, $20
; Tile graphic 143
.byt $0, $0, $1, $0, $0, $0, $0, $0
; Tile graphic 144
.byt $2e, $0, $3f, $0, $0, $0, $0, $0
; Tile graphic 145
.byt $2b, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 146
.byt $38, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 147
.byt $0, $0, $0, $1, $0, $0, $2, $1
; Tile graphic 148
.byt $0, $0, $a, $15, $0, $0, $0, $0
; Tile graphic 149
.byt $0, $0, $1, $2, $0, $0, $0, $20
; Tile graphic 150
.byt $0, $0, $0, $28, $0, $28, $0, $28
; Tile graphic 151
.byt $0, $1, $0, $1, $2, $4, $0, $0
; Tile graphic 152
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 153
.byt $10, $28, $10, $8, $10, $8, $0, $8
; Tile graphic 154
.byt $0, $a, $0, $a, $0, $2, $0, $2
; Tile graphic 155
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 156
.byt $0, $0, $8, $8, $4, $1, $1, $0
; Tile graphic 157
.byt $0, $0, $20, $10, $f, $3f, $3f, $3a
; Tile graphic 158
.byt $0, $0, $0, $0, $38, $3f, $3f, $3d
; Tile graphic 159
.byt $0, $1, $1, $2, $2, $34, $1c, $38
; Tile graphic 160
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 161
.byt $0, $1, $1, $2, $6, $7, $6, $e
; Tile graphic 162
.byt $35, $17, $21, $12, $23, $19, $3d, $1e
; Tile graphic 163
.byt $3a, $3d, $3c, $3a, $34, $31, $37, $37
; Tile graphic 164
.byt $20, $0, $8, $14, $36, $36, $36, $26
; Tile graphic 165
.byt $e, $e, $18, $6, $e, $e, $e, $0
; Tile graphic 166
.byt $3e, $1f, $3f, $1f, $2b, $0, $f, $17
; Tile graphic 167
.byt $2f, $1f, $3f, $3f, $3f, $0, $3f, $3e
; Tile graphic 168
.byt $37, $27, $31, $26, $17, $7, $7, $20
; Tile graphic 169
.byt $0, $0, $0, $0, $0, $1, $2, $0
; Tile graphic 170
.byt $2f, $1f, $2f, $1f, $2f, $3f, $0, $0
; Tile graphic 171
.byt $3f, $3f, $3f, $3f, $3f, $3f, $0, $0
; Tile graphic 172
.byt $10, $20, $10, $20, $10, $38, $4, $0
; Tile graphic 173
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 174
.byt $0, $0, $0, $0, $0, $0, $a, $15
; Tile graphic 175
.byt $0, $0, $0, $0, $0, $0, $1, $2
; Tile graphic 176
.byt $0, $0, $0, $0, $0, $0, $0, $28
; Tile graphic 177
.byt $0, $0, $2, $1, $0, $1, $0, $1
; Tile graphic 178
.byt $0, $0, $0, $0, $20, $0, $0, $0
; Tile graphic 179
.byt $0, $0, $0, $20, $10, $28, $10, $8
; Tile graphic 180
.byt $0, $28, $0, $28, $0, $a, $0, $a
; Tile graphic 181
.byt $2, $4, $0, $0, $0, $0, $8, $8
; Tile graphic 182
.byt $0, $0, $0, $0, $0, $0, $20, $10
; Tile graphic 183
.byt $10, $8, $0, $8, $0, $0, $0, $0
; Tile graphic 184
.byt $0, $2, $0, $2, $0, $1, $1, $2
; Tile graphic 185
.byt $4, $1, $2, $3, $0, $1, $1, $2
; Tile graphic 186
.byt $f, $3d, $3f, $3a, $35, $1f, $1, $16
; Tile graphic 187
.byt $3e, $3f, $3e, $3d, $3f, $3f, $3c, $3a
; Tile graphic 188
.byt $2, $20, $30, $30, $20, $6, $a, $14
; Tile graphic 189
.byt $6, $6, $6, $f, $f, $f, $8, $7
; Tile graphic 190
.byt $23, $19, $3d, $1e, $1e, $1f, $1f, $1f
; Tile graphic 191
.byt $34, $31, $37, $37, $2f, $1f, $3f, $3f
; Tile graphic 192
.byt $36, $36, $36, $22, $32, $20, $30, $20
; Tile graphic 193
.byt $7, $7, $0, $0, $0, $0, $0, $0
; Tile graphic 194
.byt $2b, $0, $f, $17, $2b, $10, $20, $5
; Tile graphic 195
.byt $3f, $0, $3f, $3e, $3f, $3f, $1f, $1f
; Tile graphic 196
.byt $10, $0, $0, $20, $10, $20, $10, $20
; Tile graphic 197
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 198
.byt $1f, $1f, $0, $0, $0, $0, $0, $0
; Tile graphic 199
.byt $10, $38, $4, $0, $0, $0, $0, $0
; Tile graphic 200
.byt $0, $0, $0, $0, $0, $1, $2, $0
; Tile graphic 201
.byt $0, $2, $1, $0, $1, $0, $1, $2
; Tile graphic 202
.byt $0, $0, $0, $20, $0, $0, $0, $0
; Tile graphic 203
.byt $0, $0, $20, $10, $28, $10, $8, $10
; Tile graphic 204
.byt $28, $0, $28, $0, $a, $0, $a, $0
; Tile graphic 205
.byt $4, $0, $0, $0, $0, $8, $8, $4
; Tile graphic 206
.byt $0, $0, $0, $0, $0, $20, $10, $1f
; Tile graphic 207
.byt $8, $0, $8, $0, $0, $0, $0, $3c
; Tile graphic 208
.byt $2, $0, $2, $0, $1, $1, $2, $2
; Tile graphic 209
.byt $4, $1, $1, $0, $0, $6, $5, $2
; Tile graphic 210
.byt $3d, $3f, $3a, $35, $1f, $3, $8, $23
; Tile graphic 211
.byt $3f, $3e, $3d, $3f, $3f, $3e, $3e, $1d
; Tile graphic 212
.byt $4, $38, $30, $20, $8, $38, $38, $24
; Tile graphic 213
.byt $6, $6, $6, $4, $4, $0, $0, $0
; Tile graphic 214
.byt $31, $38, $3e, $1f, $3f, $1f, $3f, $1f
; Tile graphic 215
.byt $3a, $39, $3b, $1b, $17, $2f, $3f, $3f
; Tile graphic 216
.byt $16, $26, $36, $2f, $2f, $2f, $21, $2e
; Tile graphic 217
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 218
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 219
.byt $2b, $0, $f, $17, $2f, $1f, $2f, $1f
; Tile graphic 220
.byt $3f, $0, $3f, $3e, $3d, $30, $20, $2a
; Tile graphic 221
.byt $e, $e, $0, $20, $10, $20, $10, $0
; Tile graphic 222
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 223
.byt $0, $1, $2, $0, $0, $0, $0, $0
; Tile graphic 224
.byt $2f, $3f, $0, $0, $0, $0, $0, $0
; Tile graphic 225
.byt $20, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 226
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 227
.byt $9, $b, $d, $2, $5, $2, $0, $1
; Tile graphic 228
.byt $3d, $3f, $3e, $3c, $3d, $3a, $30, $14
; Tile graphic 229
.byt $33, $37, $3f, $33, $b, $35, $0, $2
; Tile graphic 230
.byt $39, $3d, $3a, $34, $38, $34, $30, $28
; Tile graphic 231
.byt $0, $1, $0, $0, $6, $6, $7, $7
; Tile graphic 232
.byt $23, $16, $2a, $15, $a, $21, $18, $29
; Tile graphic 233
.byt $3c, $6, $35, $a, $35, $8, $1, $33
; Tile graphic 234
.byt $10, $20, $10, $24, $e, $2e, $2e, $1e
; Tile graphic 235
.byt $3, $3, $1, $0, $0, $0, $c, $e
; Tile graphic 236
.byt $f, $1f, $2f, $17, $f, $27, $17, $2a
; Tile graphic 237
.byt $2e, $3f, $3f, $26, $28, $15, $0, $20
; Tile graphic 238
.byt $1c, $1c, $3e, $3c, $3e, $1c, $1c, $28
; Tile graphic 239
.byt $14, $a, $25, $12, $29, $10, $14, $16
; Tile graphic 240
.byt $1f, $30, $15, $2a, $15, $a, $0, $2e
; Tile graphic 241
.byt $24, $28, $10, $28, $14, $24, $4, $24
; Tile graphic 242
.byt $a, $5, $22, $11, $28, $12, $15, $6
; Tile graphic 243
.byt $e, $e, $6, $6, $2, $1, $0, $1
; Tile graphic 244
.byt $13, $28, $2f, $28, $1, $0, $2, $26
; Tile graphic 245
.byt $3f, $3, $35, $3, $3e, $0, $2a, $2a
; Tile graphic 246
.byt $14, $a, $25, $12, $29, $10, $14, $6
; Tile graphic 247
.byt $1f, $1f, $f, $c, $9, $1f, $e, $1d
; Tile graphic 248
.byt $3f, $3f, $3f, $f, $36, $3f, $6, $16
; Tile graphic 249
.byt $3d, $3e, $3e, $3, $38, $3f, $4, $28
; Tile graphic 250
.byt $0, $0, $0, $0, $0, $0, $18, $24
; Tile graphic 251
.byt $1c, $1c, $3e, $3c, $3e, $1c, $1d, $29
; Tile graphic 252
.byt $34, $34, $18, $20, $3c, $3c, $3c, $38
; Tile graphic 253
.byt $25, $29, $13, $2b, $17, $26, $0, $20
; Tile graphic 254
.byt $30, $30, $20, $20, $20, $0, $0, $0
; Tile graphic 255
.byt $20, $10, $10, $20, $20, $0, $20, $20
costume_masks
; Tile mask 1
.byt $ff, $ff, $7e, $7c, $78, $78, $70, $70
; Tile mask 2
.byt $7e, $74, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $57, $43, $41, $40, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f
; Tile mask 6
.byt $70, $70, $70, $70, $70, $70, $70, $70
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $5f, $5f, $5f, $5f, $5f, $5f, $5f, $ff
; Tile mask 11
.byt $70, $70, $78, $7c, $7c, $60, $60, $60
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 15
.byt $60, $70, $70, $70, $70, $70, $60, $60
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $41, $43, $43, $43, $41, $41, $41, $41
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
.byt $40, $40, $40, $40, $40, $40, $50, $7c
; Tile mask 26
.byt $47, $47, $47, $43, $41, $40, $40, $40
; Tile mask 27
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7e
; Tile mask 28
.byt $ff, $7e, $70, $60, $40, $40, $40, $40
; Tile mask 29
.byt $70, $60, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $47, $42, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $ff, $ff, $5f, $4f, $47, $47, $43, $43
; Tile mask 32
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $43, $43, $43, $43, $43, $43, $43, $47
; Tile mask 37
.byt $7e, $7e, $ff, $ff, $ff, $7c, $7c, $7c
; Tile mask 38
.byt $40, $40, $40, $60, $60, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $47, $47, $47, $47, $47, $47, $4f, $4f
; Tile mask 42
.byt $7c, $7e, $7e, $7e, $7c, $78, $78, $70
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $4f, $5f, $4f, $4f, $47, $41, $40, $40
; Tile mask 47
.byt $70, $60, $60, $60, $60, $70, $7c, $ff
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $40, $41, $41, $43, $57, $5f, $5f, $5f
; Tile mask 52
.byt $70, $70, $60, $60, $60, $40, $40, $40
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $40, $ff
; Tile mask 55
.byt $5f, $4f, $47, $41, $41, $41, $5f, $ff
; Tile mask 56
.byt $60, $70, $70, $70, $70, $70, $70, $70
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $41, $43, $41, $41, $41, $40, $40, $40
; Tile mask 59
.byt $60, $60, $40, $40, $60, $60, $60, $70
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 62
.byt $5f, $5f, $4f, $4f, $4f, $5f, $5f, $ff
; Tile mask 63
.byt $7e, $7e, $7e, $7e, $7e, $7e, $ff, $ff
; Tile mask 64
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $40, $40, $40, $40, $40, $40, $40, $48
; Tile mask 66
.byt $43, $43, $43, $47, $43, $43, $41, $41
; Tile mask 67
.byt $7c, $7e, $7e, $7c, $7c, $7c, $7c, $7c
; Tile mask 68
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 69
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 70
.byt $4f, $5f, $5f, $5f, $5f, $ff, $ff, $ff
; Tile mask 71
.byt $7c, $7c, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 72
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $70, $70, $60, $60, $60, $40, $40, $40
; Tile mask 76
.byt $40, $40, $40, $40, $40, $40, $40, $4f
; Tile mask 77
.byt $40, $40, $40, $40, $40, $40, $41, $4f
; Tile mask 78
.byt $5f, $5f, $4f, $4f, $47, $47, $ff, $ff
; Tile mask 79
.byt $ff, $7e, $78, $70, $70, $70, $70, $70
; Tile mask 80
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 81
.byt $ff, $57, $41, $41, $40, $40, $40, $40
; Tile mask 82
.byt $70, $60, $60, $60, $60, $60, $60, $60
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 84
.byt $ff, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 85
.byt $60, $60, $60, $70, $70, $78, $78, $78
; Tile mask 86
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 88
.byt $40, $40, $40, $40, $41, $41, $43, $43
; Tile mask 89
.byt $5f, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 90
.byt $78, $7c, $7c, $78, $70, $70, $70, $70
; Tile mask 91
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 92
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 93
.byt $43, $47, $43, $41, $40, $40, $40, $40
; Tile mask 94
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 95
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 96
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 97
.byt $5f, $5f, $4f, $4f, $5f, $5f, $5f, $ff
; Tile mask 98
.byt $7e, $7e, $7e, $7e, $7c, $78, $78, $78
; Tile mask 99
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 100
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 101
.byt $47, $47, $47, $47, $43, $41, $41, $41
; Tile mask 102
.byt $ff, $ff, $ff, $ff, $ff, $7e, $78, $70
; Tile mask 103
.byt $ff, $ff, $ff, $ff, $70, $60, $40, $40
; Tile mask 104
.byt $ff, $ff, $ff, $ff, $40, $40, $40, $40
; Tile mask 105
.byt $ff, $ff, $ff, $ff, $ff, $57, $41, $41
; Tile mask 106
.byt $70, $70, $70, $70, $70, $60, $60, $60
; Tile mask 107
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 108
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 109
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 110
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 111
.byt $60, $60, $60, $60, $60, $60, $60, $70
; Tile mask 112
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 113
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 114
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 115
.byt $5f, $5f, $5f, $5f, $5f, $5f, $ff, $ff
; Tile mask 116
.byt $70, $78, $78, $7c, $7c, $7e, $7e, $7c
; Tile mask 117
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 118
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 119
.byt $41, $40, $40, $41, $41, $43, $41, $41
; Tile mask 120
.byt $7c, $78, $78, $70, $70, $70, $78, $7c
; Tile mask 121
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 122
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 123
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 124
.byt $7c, $7e, $ff, $ff, $ff, $ff, $7e, $7e
; Tile mask 125
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 126
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 127
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile mask 128
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 129
.byt $40, $40, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 130
.byt $40, $40, $70, $78, $ff, $ff, $ff, $ff
; Tile mask 131
.byt $43, $43, $41, $41, $ff, $ff, $ff, $ff
; Tile mask 132
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 133
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 134
.byt $41, $41, $43, $41, $41, $43, $41, $41
; Tile mask 135
.byt $78, $78, $78, $78, $78, $78, $7c, $7c
; Tile mask 136
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 137
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 138
.byt $41, $40, $40, $40, $40, $40, $40, $41
; Tile mask 139
.byt $ff, $ff, $ff, $5f, $5f, $5f, $ff, $ff
; Tile mask 140
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 141
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 142
.byt $41, $43, $47, $47, $47, $47, $43, $43
; Tile mask 143
.byt $7e, $7e, $7c, $7c, $ff, $ff, $ff, $ff
; Tile mask 144
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 145
.byt $40, $40, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 146
.byt $43, $47, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 147
.byt $ff, $ff, $7e, $78, $70, $70, $70, $70
; Tile mask 148
.byt $ff, $70, $60, $40, $40, $40, $40, $40
; Tile mask 149
.byt $ff, $40, $40, $40, $40, $40, $40, $40
; Tile mask 150
.byt $ff, $ff, $57, $41, $41, $40, $40, $40
; Tile mask 151
.byt $70, $70, $60, $60, $60, $60, $60, $60
; Tile mask 152
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 153
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 154
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 155
.byt $ff, $ff, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 156
.byt $60, $60, $60, $60, $70, $70, $70, $78
; Tile mask 157
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 158
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 159
.byt $40, $40, $40, $40, $40, $41, $41, $43
; Tile mask 160
.byt $5f, $5f, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 161
.byt $78, $7c, $7c, $78, $70, $70, $70, $60
; Tile mask 162
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 163
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 164
.byt $43, $47, $43, $41, $40, $40, $40, $40
; Tile mask 165
.byt $60, $60, $40, $40, $60, $60, $60, $70
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
.byt $40, $40, $40, $40, $40, $40, $40, $70
; Tile mask 172
.byt $47, $47, $47, $47, $43, $41, $41, $41
; Tile mask 173
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $78
; Tile mask 174
.byt $ff, $ff, $ff, $ff, $ff, $70, $60, $40
; Tile mask 175
.byt $ff, $ff, $ff, $ff, $ff, $40, $40, $40
; Tile mask 176
.byt $ff, $ff, $ff, $ff, $ff, $ff, $57, $41
; Tile mask 177
.byt $70, $70, $70, $70, $70, $70, $60, $60
; Tile mask 178
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 179
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 180
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 181
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile mask 182
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 183
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 184
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 185
.byt $70, $70, $70, $78, $78, $7c, $7c, $78
; Tile mask 186
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 187
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 188
.byt $40, $41, $41, $43, $41, $40, $40, $40
; Tile mask 189
.byt $70, $70, $70, $60, $60, $60, $60, $60
; Tile mask 190
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 191
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 192
.byt $40, $40, $40, $40, $40, $45, $45, $47
; Tile mask 193
.byt $60, $70, $78, $7e, $7e, $7e, $7e, $7e
; Tile mask 194
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 195
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 196
.byt $47, $47, $47, $47, $47, $47, $47, $43
; Tile mask 197
.byt $40, $40, $60, $ff, $ff, $ff, $ff, $ff
; Tile mask 198
.byt $40, $40, $40, $70, $ff, $ff, $ff, $ff
; Tile mask 199
.byt $43, $41, $41, $41, $ff, $ff, $ff, $ff
; Tile mask 200
.byt $ff, $ff, $ff, $ff, $40, $40, $40, $40
; Tile mask 201
.byt $70, $70, $70, $70, $70, $60, $60, $60
; Tile mask 202
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 203
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 204
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 205
.byt $60, $60, $60, $60, $60, $60, $60, $70
; Tile mask 206
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 207
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 208
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 209
.byt $70, $78, $78, $7c, $78, $70, $70, $70
; Tile mask 210
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 211
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 212
.byt $41, $41, $43, $47, $43, $43, $43, $41
; Tile mask 213
.byt $70, $70, $70, $70, $70, $7a, $7a, $7e
; Tile mask 214
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 215
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 216
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 217
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $5f
; Tile mask 218
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7c
; Tile mask 219
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 220
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 221
.byt $40, $40, $41, $47, $47, $47, $47, $47
; Tile mask 222
.byt $5f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 223
.byt $7c, $78, $78, $78, $ff, $ff, $ff, $ff
; Tile mask 224
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 225
.byt $40, $40, $40, $ff, $ff, $ff, $ff, $ff
; Tile mask 226
.byt $4f, $4f, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 227
.byt $60, $60, $60, $70, $70, $78, $78, $78
; Tile mask 228
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 229
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 230
.byt $40, $40, $40, $40, $41, $41, $43, $43
; Tile mask 231
.byt $78, $78, $7c, $78, $70, $70, $70, $70
; Tile mask 232
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 233
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 234
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 235
.byt $70, $70, $78, $7c, $7c, $60, $60, $60
; Tile mask 236
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 237
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 238
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 239
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 240
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 241
.byt $41, $41, $43, $43, $41, $41, $41, $41
; Tile mask 242
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 243
.byt $60, $60, $70, $70, $78, $78, $7c, $7c
; Tile mask 244
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 245
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 246
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 247
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 248
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 249
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 250
.byt $5f, $5f, $5f, $5f, $5f, $43, $41, $41
; Tile mask 251
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 252
.byt $41, $41, $43, $41, $41, $41, $41, $43
; Tile mask 253
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 254
.byt $47, $47, $4f, $4f, $4f, $5f, $ff, $ff
; Tile mask 255
.byt $47, $47, $47, $47, $47, $47, $47, $47
res_end
.)

