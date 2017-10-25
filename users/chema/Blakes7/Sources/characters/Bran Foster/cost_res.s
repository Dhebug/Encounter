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
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 16, 17, 18, 19, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 31, 32, 33, 34
.byt 35, 36, 37, 38, 39
.byt 40, 41, 42, 43, 44
.byt 45, 46, 47, 48, 49
.byt 50, 51, 52, 53, 54
.byt 0, 55, 56, 57, 58
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 12, 13, 14, 15
.byt 16, 17, 18, 19, 20
.byt 21, 22, 23, 24, 25
.byt 0, 59, 60, 29, 30
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 0, 31, 32, 33, 34
.byt 35, 36, 37, 38, 39
.byt 40, 41, 42, 43, 44
.byt 61, 62, 47, 48, 63
.byt 64, 65, 66, 53, 67
.byt 0, 68, 69, 70, 71
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
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 11, 72, 73, 74, 15
.byt 16, 75, 76, 77, 20
.byt 21, 22, 23, 24, 25
.byt 26, 27, 28, 29, 30
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $2
; Tile graphic 2
.byt $0, $0, $5, $a, $1, $0, $5, $22
; Tile graphic 3
.byt $0, $28, $15, $2b, $15, $b, $15, $2b
; Tile graphic 4
.byt $0, $0, $0, $28, $14, $3e, $15, $3e
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 6
.byt $4, $2, $5, $6, $d, $8, $c, $8
; Tile graphic 7
.byt $15, $28, $11, $23, $4, $3, $7, $26
; Tile graphic 8
.byt $15, $3a, $15, $3f, $7, $3b, $7, $2b
; Tile graphic 9
.byt $15, $3e, $15, $3e, $30, $2f, $31, $2a
; Tile graphic 10
.byt $0, $20, $0, $20, $0, $0, $0, $0
; Tile graphic 11
.byt $d, $8, $5, $1, $2, $0, $0, $0
; Tile graphic 12
.byt $17, $27, $3f, $3f, $37, $f, $17, $b
; Tile graphic 13
.byt $3f, $3f, $3f, $3b, $2c, $1f, $30, $3f
; Tile graphic 14
.byt $3f, $3f, $3f, $1f, $37, $3b, $e, $2e
; Tile graphic 15
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $0, $0, $5, $2, $5, $a, $15, $a
; Tile graphic 17
.byt $1, $24, $12, $29, $2, $2b, $3, $28
; Tile graphic 18
.byt $38, $3f, $1f, $0, $e, $e, $35, $4
; Tile graphic 19
.byt $1c, $3c, $30, $0, $25, $12, $35, $2
; Tile graphic 20
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 21
.byt $15, $0, $7, $0, $f, $f, $f, $0
; Tile graphic 22
.byt $2, $2, $1f, $0, $20, $f, $20, $0
; Tile graphic 23
.byt $0, $0, $39, $2, $1, $3f, $0, $0
; Tile graphic 24
.byt $5, $0, $12, $28, $13, $39, $3, $0
; Tile graphic 25
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $0, $3, $0, $0
; Tile graphic 27
.byt $1f, $1f, $0, $0, $0, $10, $0, $0
; Tile graphic 28
.byt $3f, $37, $0, $0, $0, $0, $0, $0
; Tile graphic 29
.byt $38, $38, $0, $0, $0, $b, $0, $0
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 31
.byt $0, $0, $0, $1, $0, $0, $0, $14
; Tile graphic 32
.byt $0, $5, $2a, $15, $a, $1, $2a, $15
; Tile graphic 33
.byt $0, $0, $28, $1d, $2a, $1f, $2a, $1f
; Tile graphic 34
.byt $0, $0, $0, $0, $20, $30, $28, $30
; Tile graphic 35
.byt $0, $0, $0, $0, $1, $1, $1, $1
; Tile graphic 36
.byt $22, $15, $2a, $34, $28, $0, $20, $4
; Tile graphic 37
.byt $2a, $7, $a, $1f, $20, $1f, $38, $35
; Tile graphic 38
.byt $2a, $17, $2a, $3f, $3e, $1d, $3e, $1d
; Tile graphic 39
.byt $28, $34, $28, $34, $0, $38, $8, $10
; Tile graphic 40
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 41
.byt $2a, $4, $2f, $f, $16, $1, $2, $1
; Tile graphic 42
.byt $3f, $3f, $3f, $3f, $3d, $3b, $3e, $1f
; Tile graphic 43
.byt $3f, $3f, $3f, $1b, $26, $3f, $1, $3d
; Tile graphic 44
.byt $38, $38, $38, $38, $38, $18, $30, $30
; Tile graphic 45
.byt $0, $0, $0, $1, $0, $0, $3, $0
; Tile graphic 46
.byt $0, $14, $2a, $15, $28, $15, $8, $21
; Tile graphic 47
.byt $f, $27, $13, $8, $11, $19, $1e, $0
; Tile graphic 48
.byt $3, $3f, $3e, $0, $34, $32, $2e, $20
; Tile graphic 49
.byt $20, $20, $0, $0, $1a, $6, $1e, $2e
; Tile graphic 50
.byt $7, $7, $7, $7, $0, $0, $0, $0
; Tile graphic 51
.byt $10, $20, $1, $0, $0, $1, $0, $0
; Tile graphic 52
.byt $10, $10, $3f, $0, $0, $3f, $0, $0
; Tile graphic 53
.byt $0, $0, $a, $15, $a, $3f, $0, $0
; Tile graphic 54
.byt $10, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 55
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 56
.byt $3b, $3c, $0, $0, $0, $7, $0, $0
; Tile graphic 57
.byt $3f, $3f, $0, $0, $0, $1, $0, $0
; Tile graphic 58
.byt $0, $0, $0, $0, $0, $3c, $0, $0
; Tile graphic 59
.byt $f, $f, $0, $0, $0, $0, $0, $0
; Tile graphic 60
.byt $3f, $3b, $4, $0, $0, $2c, $2, $0
; Tile graphic 61
.byt $0, $0, $0, $0, $0, $1, $2, $1
; Tile graphic 62
.byt $0, $4, $2a, $15, $28, $15, $28, $15
; Tile graphic 63
.byt $20, $20, $0, $0, $28, $10, $28, $0
; Tile graphic 64
.byt $2, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 65
.byt $20, $4, $b, $13, $17, $7, $0, $0
; Tile graphic 66
.byt $10, $8, $27, $30, $30, $f, $10, $0
; Tile graphic 67
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 68
.byt $3, $7, $0, $0, $0, $1, $0, $0
; Tile graphic 69
.byt $3f, $3c, $0, $0, $0, $38, $0, $0
; Tile graphic 70
.byt $1e, $3f, $0, $1, $0, $0, $0, $0
; Tile graphic 71
.byt $0, $0, $0, $30, $0, $0, $0, $0
; Tile graphic 72
.byt $17, $27, $3f, $3f, $37, $f, $17, $7
; Tile graphic 73
.byt $3f, $3f, $3f, $3b, $2c, $1f, $30, $38
; Tile graphic 74
.byt $3f, $3f, $3f, $1f, $37, $3b, $e, $1e
; Tile graphic 75
.byt $3, $25, $12, $29, $2, $2b, $3, $28
; Tile graphic 76
.byt $3f, $38, $3f, $f, $0, $e, $35, $4
; Tile graphic 77
.byt $2e, $1c, $3c, $30, $5, $12, $35, $2
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $7e, $7c, $78, $78
; Tile mask 2
.byt $7e, $78, $60, $40, $40, $40, $40, $40
; Tile mask 3
.byt $47, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $5f, $47, $43, $41, $40, $40, $40
; Tile mask 5
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f
; Tile mask 6
.byt $70, $70, $70, $70, $60, $60, $60, $60
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $5f, $4f, $4f, $4f, $5f, $5f, $5f, $5f
; Tile mask 11
.byt $60, $60, $70, $78, $78, $7c, $ff, $ff
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $5f, $5f, $5f, $5f, $5f, $5f, $ff, $ff
; Tile mask 16
.byt $7e, $78, $70, $70, $60, $60, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $41, $41, $41, $40, $40, $40, $40, $40
; Tile mask 20
.byt $ff, $ff, $ff, $ff, $5f, $5f, $4f, $4f
; Tile mask 21
.byt $40, $40, $70, $60, $60, $60, $60, $70
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $4f, $4f, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 26
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 27
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $40, $40, $40, $48, $48, $48, $48, $7e
; Tile mask 29
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 31
.byt $ff, $ff, $7c, $78, $70, $60, $40, $40
; Tile mask 32
.byt $70, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $ff, $43, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $ff, $ff, $ff, $5f, $4f, $47, $43, $43
; Tile mask 35
.byt $7e, $7e, $7e, $7e, $7c, $7c, $7c, $7c
; Tile mask 36
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $43, $41, $41, $41, $43, $43, $43, $43
; Tile mask 40
.byt $7c, $7c, $7e, $ff, $ff, $ff, $ff, $ff
; Tile mask 41
.byt $40, $40, $40, $40, $40, $60, $78, $78
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $43, $43, $43, $43, $43, $43, $47, $47
; Tile mask 45
.byt $ff, $ff, $7e, $7c, $7c, $7c, $78, $78
; Tile mask 46
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $4f, $4f, $47, $41, $40, $40, $40, $40
; Tile mask 50
.byt $70, $70, $70, $70, $78, $ff, $ff, $ff
; Tile mask 51
.byt $44, $4c, $4c, $5c, $7c, $7c, $7c, $7c
; Tile mask 52
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 54
.byt $41, $47, $47, $5f, $5f, $5f, $5f, $5f
; Tile mask 55
.byt $7c, $7c, $7c, $7e, $7c, $7c, $ff, $ff
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $60, $ff
; Tile mask 57
.byt $40, $40, $40, $40, $60, $40, $50, $78
; Tile mask 58
.byt $5f, $5f, $4f, $47, $43, $41, $41, $5f
; Tile mask 59
.byt $60, $60, $60, $60, $40, $40, $40, $60
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $ff, $ff, $7e, $7e, $7c, $7c, $78, $78
; Tile mask 62
.byt $70, $40, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $4f, $4f, $4f, $47, $43, $43, $43, $47
; Tile mask 64
.byt $78, $78, $78, $7c, $ff, $ff, $ff, $ff
; Tile mask 65
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $4f, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 68
.byt $70, $70, $70, $60, $40, $40, $40, $70
; Tile mask 69
.byt $40, $40, $41, $47, $43, $41, $41, $41
; Tile mask 70
.byt $40, $40, $40, $40, $40, $40, $70, $ff
; Tile mask 71
.byt $5f, $5f, $4f, $47, $43, $43, $ff, $ff
; Tile mask 72
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 77
.byt $40, $41, $41, $40, $40, $40, $40, $40
res_end
.)

