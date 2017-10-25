.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 200
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
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 31, 32, 33, 15
.byt 16, 17, 34, 35, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 36, 7, 8, 9, 37
.byt 38, 39, 40, 41, 42
.byt 16, 17, 34, 35, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 43, 44, 45, 46, 47
.byt 0, 48, 49, 50, 51
.byt 16, 17, 34, 35, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 52, 53, 54, 20
.byt 0, 48, 49, 50, 51
.byt 16, 17, 34, 35, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 5 (05-stepd1.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 16, 55, 56, 19, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 6 (06-stepd2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 57, 14, 15
.byt 16, 58, 59, 60, 20
.byt 21, 22, 61, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 7 (07-back.png)
.byt 0, 0, 62, 63, 0
.byt 64, 65, 66, 67, 68
.byt 69, 70, 71, 72, 73
.byt 11, 74, 75, 14, 15
.byt 16, 76, 77, 78, 79
.byt 21, 22, 80, 81, 82
.byt 26, 27, 83, 29, 30
; Animatory state 8 (08-stepdb1.png)
.byt 0, 84, 85, 86, 87
.byt 88, 89, 90, 91, 92
.byt 93, 94, 95, 96, 97
.byt 98, 99, 100, 101, 102
.byt 103, 104, 105, 106, 107
.byt 21, 22, 108, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 9 (09-stepdb2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 109, 0, 110, 111
.byt 112, 113, 114, 115, 116
.byt 117, 118, 119, 120, 121
.byt 122, 123, 124, 125, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 10 (10-frontTalk.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 11 (11-rightTalk.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 126, 14, 15
.byt 16, 17, 127, 128, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $14
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $4, $2, $4
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 7
.byt $2, $4, $9, $3, $7, $4, $b, $e
; Tile graphic 8
.byt $20, $1f, $3f, $3f, $3f, $f, $3f, $f
; Tile graphic 9
.byt $8, $30, $3c, $3e, $3e, $2, $3d, $7
; Tile graphic 10
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 11
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 12
.byt $d, $f, $f, $7, $7, $7, $7, $b
; Tile graphic 13
.byt $16, $3f, $3f, $3b, $39, $3f, $32, $3d
; Tile graphic 14
.byt $2b, $3f, $3f, $3f, $3e, $3c, $1e, $3c
; Tile graphic 15
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $0, $0, $0, $1, $1, $3, $3, $3
; Tile graphic 17
.byt $3, $9, $2c, $35, $36, $f, $2f, $27
; Tile graphic 18
.byt $3f, $3f, $1f, $0, $2d, $12, $2d, $2d
; Tile graphic 19
.byt $38, $30, $a, $1a, $16, $37, $3b, $33
; Tile graphic 20
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 21
.byt $7, $7, $6, $f, $e, $e, $f, $0
; Tile graphic 22
.byt $10, $17, $17, $2f, $2a, $7, $27, $0
; Tile graphic 23
.byt $33, $3f, $3f, $3f, $2a, $3f, $3f, $0
; Tile graphic 24
.byt $b, $33, $37, $3b, $2b, $31, $33, $0
; Tile graphic 25
.byt $0, $0, $0, $20, $20, $20, $20, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $1, $0, $3, $0
; Tile graphic 27
.byt $f, $f, $1f, $0, $3f, $2f, $3f, $0
; Tile graphic 28
.byt $37, $23, $1, $0, $23, $23, $1, $0
; Tile graphic 29
.byt $38, $3c, $3c, $0, $3f, $34, $3f, $0
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $20, $0
; Tile graphic 31
.byt $d, $f, $f, $7, $7, $7, $6, $8
; Tile graphic 32
.byt $16, $3f, $3f, $3b, $39, $3f, $0, $15
; Tile graphic 33
.byt $2b, $3f, $3f, $3f, $3e, $3c, $6, $10
; Tile graphic 34
.byt $28, $1f, $1f, $0, $2d, $12, $2d, $2d
; Tile graphic 35
.byt $28, $30, $a, $1a, $16, $37, $3b, $33
; Tile graphic 36
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 37
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 38
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $d, $f, $0, $3, $5, $2, $7, $b
; Tile graphic 40
.byt $16, $0, $f, $3f, $38, $35, $0, $15
; Tile graphic 41
.byt $2b, $1f, $0, $3f, $3c, $1a, $4, $14
; Tile graphic 42
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 43
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 44
.byt $2, $4, $9, $2, $0, $7, $e, $d
; Tile graphic 45
.byt $20, $1f, $3f, $0, $3e, $f, $37, $a
; Tile graphic 46
.byt $8, $30, $3c, $2, $38, $26, $1b, $25
; Tile graphic 47
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 48
.byt $d, $e, $f, $3, $5, $2, $7, $b
; Tile graphic 49
.byt $a, $37, $f, $3f, $38, $35, $0, $15
; Tile graphic 50
.byt $25, $1b, $27, $3f, $3c, $1a, $4, $14
; Tile graphic 51
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 52
.byt $0, $0, $1, $3, $7, $7, $e, $d
; Tile graphic 53
.byt $0, $1f, $26, $d, $3e, $f, $37, $a
; Tile graphic 54
.byt $0, $30, $3c, $12, $3e, $26, $1b, $25
; Tile graphic 55
.byt $3, $9, $2d, $35, $37, $f, $2f, $27
; Tile graphic 56
.byt $3f, $23, $1, $1, $1, $22, $3d, $2d
; Tile graphic 57
.byt $1e, $37, $37, $37, $35, $37, $22, $1
; Tile graphic 58
.byt $c, $c, $2f, $35, $36, $f, $2f, $27
; Tile graphic 59
.byt $0, $0, $1, $22, $35, $16, $35, $35
; Tile graphic 60
.byt $18, $18, $2a, $1a, $16, $37, $3b, $33
; Tile graphic 61
.byt $37, $37, $3f, $3f, $2a, $3f, $3f, $0
; Tile graphic 62
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 63
.byt $0, $0, $0, $0, $0, $0, $0, $2
; Tile graphic 64
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 65
.byt $0, $0, $0, $0, $0, $0, $4, $7
; Tile graphic 66
.byt $0, $0, $0, $1, $1, $1, $3, $16
; Tile graphic 67
.byt $0, $0, $0, $0, $0, $4, $2, $4
; Tile graphic 68
.byt $0, $0, $0, $0, $2, $2, $4, $0
; Tile graphic 69
.byt $0, $0, $0, $0, $0, $3, $6, $0
; Tile graphic 70
.byt $3, $4, $9, $7, $3c, $24, $b, $e
; Tile graphic 71
.byt $22, $f, $23, $3f, $7, $3, $39, $c
; Tile graphic 72
.byt $8, $30, $30, $6, $3e, $2, $3d, $7
; Tile graphic 73
.byt $10, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 74
.byt $d, $f, $f, $11, $20, $20, $20, $11
; Tile graphic 75
.byt $12, $33, $33, $33, $33, $33, $21, $21
; Tile graphic 76
.byt $f, $e, $38, $20, $20, $18, $2e, $27
; Tile graphic 77
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 78
.byt $38, $18, $6, $7, $8, $10, $20, $20
; Tile graphic 79
.byt $0, $0, $0, $20, $10, $8, $4, $4
; Tile graphic 80
.byt $21, $21, $33, $33, $32, $33, $33, $12
; Tile graphic 81
.byt $20, $20, $20, $30, $28, $37, $33, $0
; Tile graphic 82
.byt $4, $4, $4, $8, $10, $20, $20, $0
; Tile graphic 83
.byt $3f, $2f, $d, $c, $2f, $2b, $1, $0
; Tile graphic 84
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 85
.byt $0, $0, $0, $0, $0, $0, $0, $2
; Tile graphic 86
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 87
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 88
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 89
.byt $0, $8, $8, $8, $8, $8, $8, $19
; Tile graphic 90
.byt $2, $2, $2, $5, $5, $5, $5, $15
; Tile graphic 91
.byt $0, $0, $0, $3, $4, $18, $10, $20
; Tile graphic 92
.byt $0, $0, $0, $30, $c, $2, $2, $1
; Tile graphic 93
.byt $0, $0, $0, $0, $1, $6, $8, $10
; Tile graphic 94
.byt $12, $14, $9, $3, $3f, $2, $1, $1
; Tile graphic 95
.byt $25, $18, $38, $38, $38, $8, $30, $0
; Tile graphic 96
.byt $20, $20, $20, $20, $20, $20, $18, $4
; Tile graphic 97
.byt $1, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 98
.byt $10, $20, $20, $20, $20, $20, $10, $10
; Tile graphic 99
.byt $6, $18, $8, $6, $1, $0, $0, $0
; Tile graphic 100
.byt $0, $0, $0, $0, $0, $30, $38, $38
; Tile graphic 101
.byt $3, $0, $0, $3, $7, $1c, $3e, $3c
; Tile graphic 102
.byt $1, $32, $26, $8, $30, $0, $0, $0
; Tile graphic 103
.byt $8, $6, $1, $1, $1, $3, $3, $3
; Tile graphic 104
.byt $1, $7, $3c, $35, $36, $f, $2f, $27
; Tile graphic 105
.byt $38, $38, $18, $5, $2d, $15, $2d, $2d
; Tile graphic 106
.byt $38, $30, $2a, $1a, $16, $37, $3b, $33
; Tile graphic 107
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 108
.byt $35, $3f, $3f, $3f, $2a, $3f, $3f, $0
; Tile graphic 109
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 110
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 111
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 112
.byt $0, $0, $0, $0, $0, $0, $1, $2
; Tile graphic 113
.byt $0, $0, $1, $2, $7, $7, $3e, $d
; Tile graphic 114
.byt $0, $1f, $29, $10, $30, $10, $39, $e
; Tile graphic 115
.byt $0, $30, $25, $32, $3c, $28, $18, $28
; Tile graphic 116
.byt $0, $0, $30, $8, $4, $2, $2, $2
; Tile graphic 117
.byt $4, $4, $4, $2, $1, $0, $0, $0
; Tile graphic 118
.byt $5, $6, $7, $b, $30, $0, $5, $8
; Tile graphic 119
.byt $a, $27, $f, $1f, $18, $35, $0, $15
; Tile graphic 120
.byt $28, $18, $24, $3e, $3d, $1a, $1c, $22
; Tile graphic 121
.byt $2, $2, $4, $8, $30, $0, $0, $0
; Tile graphic 122
.byt $0, $0, $0, $1, $1, $3, $3, $3
; Tile graphic 123
.byt $2, $8, $2c, $35, $36, $f, $2f, $27
; Tile graphic 124
.byt $29, $1f, $1f, $0, $2d, $12, $2d, $2d
; Tile graphic 125
.byt $1, $1, $1, $22, $1e, $37, $3b, $33
; Tile graphic 126
.byt $16, $3f, $3f, $3b, $39, $3f, $30, $38
; Tile graphic 127
.byt $3f, $3f, $3f, $1f, $20, $12, $2d, $2d
; Tile graphic 128
.byt $38, $38, $32, $a, $16, $37, $3b, $33
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 2
.byt $ff, $ff, $ff, $7c, $78, $60, $40, $40
; Tile mask 3
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $5f, $43, $41, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $4f
; Tile mask 6
.byt $7e, $7e, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $4f, $47, $47, $43, $43, $43, $43, $43
; Tile mask 11
.byt $78, $78, $78, $78, $7c, $7e, $ff, $ff
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 15
.byt $43, $43, $43, $43, $47, $47, $4f, $ff
; Tile mask 16
.byt $ff, $ff, $7e, $7c, $7c, $78, $78, $78
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 21
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $5f, $5f, $5f, $4f, $4f, $4f, $4f, $5f
; Tile mask 26
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 27
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $40, $48, $5c, $5c, $48, $48, $48, $7e
; Tile mask 29
.byt $43, $41, $41, $40, $40, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $5f, $4f, $4f, $4f
; Tile mask 31
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $7e, $7e, $7c, $7c, $7c, $7c, $7c, $7e
; Tile mask 37
.byt $4f, $47, $47, $43, $43, $43, $43, $47
; Tile mask 38
.byt $7e, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 39
.byt $40, $40, $60, $60, $70, $70, $70, $60
; Tile mask 40
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 42
.byt $47, $47, $4f, $5f, $ff, $ff, $ff, $ff
; Tile mask 43
.byt $7e, $7e, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $4f, $4f, $4f, $4f, $5f, $5f, $5f, $5f
; Tile mask 48
.byt $60, $60, $60, $60, $70, $70, $70, $60
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 51
.byt $5f, $5f, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 52
.byt $ff, $7e, $7c, $78, $70, $60, $60, $60
; Tile mask 53
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 54
.byt $4f, $43, $41, $40, $40, $40, $40, $40
; Tile mask 55
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 62
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7b, $78
; Tile mask 63
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7c
; Tile mask 64
.byt $ff, $ff, $79, $7c, $ff, $ff, $ff, $7e
; Tile mask 65
.byt $ff, $ff, $ff, $4c, $40, $60, $40, $40
; Tile mask 66
.byt $7e, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $50, $47, $4f, $43, $41, $40, $40, $40
; Tile mask 68
.byt $ff, $ff, $ff, $ff, $79, $71, $43, $47
; Tile mask 69
.byt $7e, $7e, $7c, $7c, $7c, $78, $40, $7c
; Tile mask 70
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 73
.byt $4f, $47, $47, $43, $43, $43, $43, $43
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 77
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 78
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $ff, $ff, $ff, $5f, $4f, $47, $43, $43
; Tile mask 80
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 81
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 82
.byt $43, $43, $43, $47, $4f, $4f, $4f, $5f
; Tile mask 83
.byt $40, $40, $50, $50, $40, $40, $48, $7e
; Tile mask 84
.byt $ff, $ff, $ff, $ff, $ff, $ff, $79, $7b
; Tile mask 85
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7d
; Tile mask 86
.byt $ff, $ff, $ff, $ff, $ff, $67, $77, $7b
; Tile mask 87
.byt $ff, $ff, $ff, $ff, $ff, $ff, $77, $4f
; Tile mask 88
.byt $ff, $ff, $78, $7e, $ff, $ff, $5f, $66
; Tile mask 89
.byt $7b, $73, $47, $44, $70, $60, $40, $40
; Tile mask 90
.byt $7d, $7d, $40, $40, $40, $40, $40, $40
; Tile mask 91
.byt $78, $7d, $53, $40, $40, $40, $40, $40
; Tile mask 92
.byt $5f, $ff, $ff, $4f, $43, $41, $41, $40
; Tile mask 93
.byt $76, $78, $7c, $7c, $7c, $78, $70, $60
; Tile mask 94
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 95
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 96
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 97
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 98
.byt $60, $40, $40, $40, $40, $40, $60, $60
; Tile mask 99
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 100
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 101
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 102
.byt $40, $41, $41, $43, $46, $40, $43, $4f
; Tile mask 103
.byt $70, $78, $7e, $7c, $7c, $78, $78, $78
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 106
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 107
.byt $67, $77, $77, $73, $79, $5f, $5f, $5f
; Tile mask 108
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 109
.byt $ff, $ff, $ff, $ff, $ff, $ff, $73, $67
; Tile mask 110
.byt $ff, $ff, $ff, $ff, $ff, $4f, $67, $73
; Tile mask 111
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $6f
; Tile mask 112
.byt $7e, $7e, $7e, $ff, $ff, $ff, $7e, $7c
; Tile mask 113
.byt $47, $72, $78, $78, $70, $60, $40, $40
; Tile mask 114
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 115
.byt $48, $41, $40, $40, $40, $40, $40, $40
; Tile mask 116
.byt $5f, $ff, $4f, $47, $43, $41, $41, $41
; Tile mask 117
.byt $78, $78, $78, $7c, $7e, $ff, $ff, $ff
; Tile mask 118
.byt $40, $40, $40, $40, $40, $70, $60, $60
; Tile mask 119
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 121
.byt $41, $41, $43, $47, $4f, $ff, $ff, $ff
; Tile mask 122
.byt $7c, $ff, $7e, $7c, $7c, $78, $78, $78
; Tile mask 123
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 124
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 125
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 126
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 127
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 128
.byt $43, $41, $40, $40, $40, $40, $40, $40
res_end
.)

