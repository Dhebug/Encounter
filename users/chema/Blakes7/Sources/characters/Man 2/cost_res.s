.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 6
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
.byt 17, 18, 19, 20, 21
.byt 22, 23, 24, 25, 26
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 27, 28, 29, 30
.byt 0, 31, 32, 33, 34
.byt 0, 35, 36, 37, 38
.byt 39, 40, 41, 42, 43
.byt 44, 45, 46, 47, 48
.byt 0, 49, 50, 51, 52
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 53, 54, 55, 56, 0
.byt 57, 58, 59, 60, 0
.byt 61, 62, 63, 64, 0
.byt 65, 66, 67, 68, 0
.byt 69, 70, 71, 72, 0
.byt 73, 74, 75, 76, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 77, 78, 79, 80, 0
.byt 81, 82, 83, 84, 85
.byt 86, 87, 88, 89, 90
.byt 91, 92, 93, 94, 95
.byt 96, 97, 98, 99, 0
.byt 0, 100, 101, 102, 103
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 5 (05-stepd1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 6 (06-stepd2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 7 (07-back.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 8 (08-stepdb1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 9 (09-stepdb2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
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
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 104, 105, 106, 0
.byt 13, 107, 108, 109, 0
.byt 17, 18, 19, 20, 21
.byt 22, 23, 24, 25, 26
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $0, $5, $b, $17, $2b
; Tile graphic 3
.byt $0, $0, $0, $2a, $15, $3f, $3f, $3f
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $30, $38, $3c
; Tile graphic 5
.byt $1, $2, $1, $2, $1, $2, $1, $1
; Tile graphic 6
.byt $1f, $2b, $1f, $2f, $16, $d, $37, $16
; Tile graphic 7
.byt $3f, $3f, $3f, $3f, $7, $3b, $7, $2b
; Tile graphic 8
.byt $3c, $3e, $3e, $3e, $30, $2e, $30, $2a
; Tile graphic 9
.byt $1, $1, $1, $1, $0, $0, $0, $0
; Tile graphic 10
.byt $13, $27, $3b, $37, $23, $5, $2, $11
; Tile graphic 11
.byt $3f, $3f, $3f, $3c, $3e, $35, $28, $17
; Tile graphic 12
.byt $2e, $3e, $3e, $e, $2c, $14, $8, $30
; Tile graphic 13
.byt $0, $0, $0, $1, $2, $1, $2, $1
; Tile graphic 14
.byt $8, $20, $29, $15, $2a, $14, $22, $14
; Tile graphic 15
.byt $28, $15, $a, $30, $37, $38, $3f, $3f
; Tile graphic 16
.byt $8, $10, $24, $2, $4, $32, $20, $2a
; Tile graphic 17
.byt $2, $1, $0, $7, $7, $7, $7, $0
; Tile graphic 18
.byt $2a, $5, $a, $35, $32, $30, $35, $a
; Tile graphic 19
.byt $1f, $1f, $1f, $1f, $1f, $0, $15, $2a
; Tile graphic 20
.byt $20, $2a, $10, $b, $13, $1, $13, $28
; Tile graphic 21
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 22
.byt $0, $0, $0, $0, $0, $3, $0, $0
; Tile graphic 23
.byt $15, $a, $15, $0, $0, $30, $0, $0
; Tile graphic 24
.byt $11, $20, $4, $0, $0, $0, $0, $0
; Tile graphic 25
.byt $10, $28, $10, $0, $0, $1f, $0, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $1, $2, $5
; Tile graphic 28
.byt $0, $0, $0, $5, $2a, $1f, $3f, $1f
; Tile graphic 29
.byt $0, $0, $0, $10, $28, $3e, $3f, $3f
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 31
.byt $b, $15, $b, $15, $a, $11, $e, $a
; Tile graphic 32
.byt $3f, $1f, $3f, $3f, $30, $2f, $38, $35
; Tile graphic 33
.byt $3f, $3f, $3f, $3f, $3e, $1d, $3e, $1d
; Tile graphic 34
.byt $20, $30, $30, $30, $0, $30, $0, $10
; Tile graphic 35
.byt $a, $c, $f, $e, $4, $0, $0, $2
; Tile graphic 36
.byt $1f, $3f, $1f, $3f, $1f, $2e, $15, $a
; Tile graphic 37
.byt $3d, $3f, $3f, $21, $35, $2a, $1, $3e
; Tile graphic 38
.byt $30, $30, $30, $30, $20, $20, $0, $0
; Tile graphic 39
.byt $0, $0, $0, $0, $0, $0, $3, $1
; Tile graphic 40
.byt $1, $4, $5, $a, $15, $2a, $10, $22
; Tile graphic 41
.byt $5, $2, $9, $2e, $16, $27, $17, $27
; Tile graphic 42
.byt $1, $2a, $14, $0, $38, $6, $3c, $3d
; Tile graphic 43
.byt $0, $0, $0, $0, $14, $c, $1c, $1c
; Tile graphic 44
.byt $e, $f, $e, $e, $0, $0, $0, $0
; Tile graphic 45
.byt $1, $2, $1, $2, $1, $0, $2, $1
; Tile graphic 46
.byt $13, $2b, $13, $2b, $13, $0, $2a, $15
; Tile graphic 47
.byt $3c, $3d, $3a, $39, $3a, $0, $2a, $11
; Tile graphic 48
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 49
.byt $0, $0, $1, $0, $0, $0, $0, $0
; Tile graphic 50
.byt $2a, $5, $12, $0, $0, $e, $0, $0
; Tile graphic 51
.byt $28, $14, $2a, $0, $0, $3, $0, $0
; Tile graphic 52
.byt $0, $0, $0, $0, $0, $38, $0, $0
; Tile graphic 53
.byt $0, $0, $0, $0, $0, $0, $1, $2
; Tile graphic 54
.byt $0, $0, $0, $2, $15, $2f, $1f, $2f
; Tile graphic 55
.byt $0, $0, $0, $28, $14, $3f, $3f, $3f
; Tile graphic 56
.byt $0, $0, $0, $0, $0, $0, $20, $30
; Tile graphic 57
.byt $5, $a, $5, $a, $5, $8, $7, $5
; Tile graphic 58
.byt $3f, $2f, $3f, $3f, $18, $37, $1c, $1a
; Tile graphic 59
.byt $3f, $3f, $3f, $3f, $1f, $2e, $1f, $2e
; Tile graphic 60
.byt $30, $38, $38, $38, $0, $38, $0, $28
; Tile graphic 61
.byt $5, $6, $7, $7, $2, $0, $0, $1
; Tile graphic 62
.byt $f, $1f, $2f, $1f, $f, $17, $a, $5
; Tile graphic 63
.byt $3e, $3f, $3f, $30, $3a, $15, $20, $1f
; Tile graphic 64
.byt $38, $38, $38, $38, $30, $10, $20, $0
; Tile graphic 65
.byt $0, $2, $2, $5, $a, $5, $a, $5
; Tile graphic 66
.byt $22, $1, $24, $17, $2b, $13, $b, $13
; Tile graphic 67
.byt $20, $15, $2a, $0, $1c, $23, $3e, $3e
; Tile graphic 68
.byt $20, $0, $10, $8, $10, $8, $0, $28
; Tile graphic 69
.byt $a, $4, $0, $1f, $1f, $1f, $1f, $0
; Tile graphic 70
.byt $29, $15, $29, $15, $9, $0, $15, $2a
; Tile graphic 71
.byt $3e, $3e, $3d, $3c, $3d, $0, $15, $2a
; Tile graphic 72
.byt $0, $28, $0, $2c, $c, $4, $c, $20
; Tile graphic 73
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 74
.byt $15, $2a, $15, $0, $0, $3, $0, $0
; Tile graphic 75
.byt $5, $22, $5, $0, $8, $35, $4, $4
; Tile graphic 76
.byt $0, $20, $0, $0, $0, $3c, $0, $0
; Tile graphic 77
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 78
.byt $0, $0, $0, $0, $2, $5, $b, $15
; Tile graphic 79
.byt $0, $0, $0, $15, $2a, $3f, $3f, $3f
; Tile graphic 80
.byt $0, $0, $0, $0, $20, $38, $3c, $3e
; Tile graphic 81
.byt $0, $1, $0, $1, $0, $1, $0, $0
; Tile graphic 82
.byt $2f, $15, $2f, $17, $2b, $6, $3b, $2b
; Tile graphic 83
.byt $3f, $3f, $3f, $3f, $3, $3d, $23, $15
; Tile graphic 84
.byt $3e, $3f, $3f, $3f, $38, $37, $38, $35
; Tile graphic 85
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 86
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 87
.byt $29, $33, $3d, $3b, $11, $2, $1, $8
; Tile graphic 88
.byt $3f, $3f, $3f, $3e, $3f, $3a, $14, $2b
; Tile graphic 89
.byt $37, $3f, $3f, $7, $16, $2a, $4, $38
; Tile graphic 90
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 91
.byt $0, $0, $0, $0, $1, $0, $1, $0
; Tile graphic 92
.byt $4, $10, $14, $2a, $15, $2a, $11, $2a
; Tile graphic 93
.byt $14, $a, $25, $38, $1b, $1c, $1f, $1f
; Tile graphic 94
.byt $4, $28, $12, $1, $20, $19, $30, $34
; Tile graphic 95
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 96
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 97
.byt $19, $32, $2f, $1a, $c, $5, $1, $4
; Tile graphic 98
.byt $f, $2f, $3, $39, $3d, $3c, $32, $5
; Tile graphic 99
.byt $30, $34, $28, $24, $28, $0, $28, $14
; Tile graphic 100
.byt $2, $5, $0, $0, $0, $1, $0, $0
; Tile graphic 101
.byt $2a, $14, $28, $0, $0, $38, $0, $0
; Tile graphic 102
.byt $2a, $14, $0, $1, $0, $0, $0, $0
; Tile graphic 103
.byt $0, $0, $0, $30, $0, $0, $0, $0
; Tile graphic 104
.byt $13, $27, $3b, $37, $23, $5, $2, $12
; Tile graphic 105
.byt $3f, $3f, $3f, $3c, $3e, $35, $28, $28
; Tile graphic 106
.byt $2e, $3e, $3e, $e, $2c, $14, $8, $18
; Tile graphic 107
.byt $9, $20, $28, $15, $2a, $14, $22, $14
; Tile graphic 108
.byt $17, $28, $15, $a, $30, $38, $3f, $3f
; Tile graphic 109
.byt $30, $8, $10, $22, $4, $32, $20, $2a
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7c
; Tile mask 2
.byt $ff, $ff, $7e, $78, $60, $40, $40, $40
; Tile mask 3
.byt $ff, $ff, $41, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $ff, $5f, $4f, $47, $43, $41
; Tile mask 5
.byt $7c, $78, $78, $78, $78, $78, $78, $78
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $78, $78, $7c, $7c, $7e, $7e, $ff, $ff
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $41, $41, $41, $41
; Tile mask 13
.byt $ff, $7e, $7c, $7c, $78, $78, $78, $78
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $43, $43, $41, $40, $40, $40, $40, $40
; Tile mask 17
.byt $78, $78, $78, $70, $70, $70, $70, $78
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 22
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $48, $48, $48, $48, $7e
; Tile mask 25
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 26
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 27
.byt $ff, $ff, $ff, $ff, $7c, $78, $70, $60
; Tile mask 28
.byt $ff, $ff, $70, $40, $40, $40, $40, $40
; Tile mask 29
.byt $ff, $ff, $4f, $43, $41, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $4f
; Tile mask 31
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $4f, $47, $47, $47, $47, $47, $47, $47
; Tile mask 35
.byt $40, $40, $60, $60, $70, $70, $78, $78
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $47, $47, $47, $47, $4f, $4f, $4f, $4f
; Tile mask 39
.byt $ff, $ff, $ff, $ff, $7e, $7c, $78, $70
; Tile mask 40
.byt $78, $70, $60, $40, $40, $40, $40, $48
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $5f, $5f, $4f, $43, $41, $41, $41, $41
; Tile mask 44
.byt $60, $60, $60, $60, $71, $ff, $ff, $ff
; Tile mask 45
.byt $58, $58, $58, $78, $78, $78, $78, $78
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $43, $4f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 49
.byt $7c, $7c, $7c, $7c, $78, $78, $ff, $ff
; Tile mask 50
.byt $40, $40, $40, $40, $41, $40, $40, $ff
; Tile mask 51
.byt $40, $40, $40, $40, $40, $40, $60, $70
; Tile mask 52
.byt $ff, $ff, $5f, $4f, $47, $43, $43, $ff
; Tile mask 53
.byt $ff, $ff, $ff, $ff, $7e, $7c, $78, $70
; Tile mask 54
.byt $ff, $ff, $78, $60, $40, $40, $40, $40
; Tile mask 55
.byt $ff, $ff, $47, $41, $40, $40, $40, $40
; Tile mask 56
.byt $ff, $ff, $ff, $ff, $ff, $5f, $4f, $47
; Tile mask 57
.byt $70, $60, $60, $60, $60, $60, $60, $60
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $47, $43, $43, $43, $43, $43, $43, $43
; Tile mask 61
.byt $60, $60, $70, $70, $78, $78, $7c, $7c
; Tile mask 62
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 64
.byt $43, $43, $43, $43, $47, $47, $47, $47
; Tile mask 65
.byt $7c, $78, $70, $70, $60, $60, $60, $60
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $4f, $4f, $47, $43, $43, $43, $43, $43
; Tile mask 69
.byt $60, $60, $60, $40, $40, $40, $40, $60
; Tile mask 70
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 72
.byt $43, $43, $43, $41, $41, $41, $41, $43
; Tile mask 73
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $4f, $4f, $4f, $47, $43, $41, $41, $41
; Tile mask 77
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7e
; Tile mask 78
.byt $ff, $ff, $ff, $7c, $70, $60, $40, $40
; Tile mask 79
.byt $ff, $ff, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $ff, $ff, $ff, $4f, $47, $43, $41, $40
; Tile mask 81
.byt $7e, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 82
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 83
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 84
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 85
.byt $ff, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 86
.byt $7c, $7c, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 87
.byt $40, $40, $40, $40, $40, $40, $60, $60
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 89
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 90
.byt $5f, $5f, $5f, $5f, $ff, $ff, $ff, $ff
; Tile mask 91
.byt $ff, $ff, $7e, $7e, $7c, $7c, $7c, $7c
; Tile mask 92
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 93
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 94
.byt $41, $41, $40, $40, $40, $40, $40, $41
; Tile mask 95
.byt $ff, $ff, $ff, $5f, $5f, $5f, $ff, $ff
; Tile mask 96
.byt $7c, $7c, $7e, $ff, $ff, $ff, $ff, $ff
; Tile mask 97
.byt $40, $40, $40, $40, $60, $70, $70, $70
; Tile mask 98
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 99
.byt $41, $41, $41, $41, $41, $41, $41, $40
; Tile mask 100
.byt $70, $70, $70, $60, $40, $40, $40, $70
; Tile mask 101
.byt $40, $40, $41, $47, $43, $41, $41, $41
; Tile mask 102
.byt $40, $40, $40, $40, $40, $40, $70, $ff
; Tile mask 103
.byt $5f, $5f, $4f, $47, $43, $43, $ff, $ff
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 105
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 106
.byt $40, $40, $40, $40, $41, $41, $41, $41
; Tile mask 107
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 108
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 109
.byt $41, $43, $41, $40, $40, $40, $40, $40
res_end
.)

