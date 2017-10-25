.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 7
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
.byt 31, 32, 33, 34, 35
.byt 36, 37, 38, 39, 40
.byt 41, 42, 43, 44, 45
.byt 46, 47, 48, 49, 50
.byt 0, 51, 52, 53, 54
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 13, 14, 15, 16, 0
.byt 55, 56, 19, 20, 21
.byt 57, 58, 59, 60, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 0, 27, 28, 29, 30
.byt 31, 32, 33, 34, 35
.byt 36, 37, 38, 39, 40
.byt 61, 62, 43, 44, 63
.byt 64, 65, 66, 67, 68
.byt 0, 69, 70, 71, 72
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
.byt 9, 10, 73, 12, 0
.byt 13, 74, 75, 76, 0
.byt 17, 18, 19, 20, 21
.byt 22, 23, 24, 25, 26
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $2, $4, $0, $0, $5
; Tile graphic 3
.byt $0, $0, $0, $28, $5, $0, $0, $1c
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $1, $3
; Tile graphic 6
.byt $a, $1, $0, $1, $2, $4, $2, $5
; Tile graphic 7
.byt $2a, $1f, $f, $7, $26, $5, $6, $5
; Tile graphic 8
.byt $28, $3c, $3c, $3c, $6, $3a, $e, $16
; Tile graphic 9
.byt $3, $3, $3, $3, $1, $0, $0, $0
; Tile graphic 10
.byt $22, $20, $30, $3f, $2f, $f, $f, $17
; Tile graphic 11
.byt $e, $f, $1f, $3f, $38, $3f, $31, $3f
; Tile graphic 12
.byt $3e, $3e, $3e, $3c, $3c, $3c, $18, $38
; Tile graphic 13
.byt $0, $0, $1, $2, $0, $0, $0, $0
; Tile graphic 14
.byt $3, $21, $8, $14, $4, $12, $12, $21
; Tile graphic 15
.byt $38, $3f, $1f, $0, $0, $9, $e, $4
; Tile graphic 16
.byt $30, $34, $20, $4, $a, $c, $14, $14
; Tile graphic 17
.byt $0, $f, $0, $0, $9, $9, $4, $1
; Tile graphic 18
.byt $20, $0, $20, $10, $10, $3a, $10, $20
; Tile graphic 19
.byt $26, $20, $11, $11, $a, $2a, $0, $0
; Tile graphic 20
.byt $24, $24, $4, $3, $3, $29, $3, $0
; Tile graphic 21
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 22
.byt $0, $0, $0, $0, $1, $0, $0, $0
; Tile graphic 23
.byt $0, $0, $0, $0, $10, $0, $0, $0
; Tile graphic 24
.byt $0, $8, $0, $0, $0, $0, $0, $0
; Tile graphic 25
.byt $0, $0, $0, $0, $a, $0, $0, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 27
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 28
.byt $0, $0, $0, $15, $20, $0, $0, $2b
; Tile graphic 29
.byt $0, $0, $0, $0, $28, $0, $0, $20
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 31
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 32
.byt $1, $0, $0, $0, $0, $0, $8, $18
; Tile graphic 33
.byt $15, $b, $1, $8, $14, $20, $10, $28
; Tile graphic 34
.byt $15, $3f, $3f, $3f, $30, $2f, $31, $2a
; Tile graphic 35
.byt $0, $20, $20, $20, $30, $10, $30, $30
; Tile graphic 36
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 37
.byt $1c, $1c, $1e, $1f, $d, $1, $1, $2
; Tile graphic 38
.byt $11, $1, $3, $3f, $3f, $3f, $3e, $3f
; Tile graphic 39
.byt $37, $3f, $3f, $3f, $7, $3f, $b, $3f
; Tile graphic 40
.byt $30, $30, $30, $20, $20, $20, $0, $0
; Tile graphic 41
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 42
.byt $0, $0, $5, $8, $0, $6, $a, $0
; Tile graphic 43
.byt $1f, $f, $3, $20, $20, $11, $11, $8
; Tile graphic 44
.byt $6, $3e, $3c, $0, $1, $9, $32, $22
; Tile graphic 45
.byt $0, $0, $0, $20, $14, $c, $1c, $1c
; Tile graphic 46
.byt $0, $e, $11, $10, $4, $0, $0, $0
; Tile graphic 47
.byt $0, $0, $0, $0, $0, $1, $0, $0
; Tile graphic 48
.byt $4, $4, $2, $2, $1, $15, $0, $0
; Tile graphic 49
.byt $34, $4, $8, $8, $10, $15, $0, $0
; Tile graphic 50
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 51
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 52
.byt $0, $8, $4, $2, $1, $a, $0, $0
; Tile graphic 53
.byt $0, $0, $0, $0, $1, $0, $0, $0
; Tile graphic 54
.byt $0, $0, $0, $0, $10, $0, $0, $0
; Tile graphic 55
.byt $0, $0, $f, $0, $0, $9, $9, $4
; Tile graphic 56
.byt $20, $20, $0, $20, $10, $12, $38, $10
; Tile graphic 57
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 58
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 59
.byt $0, $10, $8, $8, $0, $14, $2, $0
; Tile graphic 60
.byt $0, $0, $0, $0, $0, $14, $0, $0
; Tile graphic 61
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 62
.byt $0, $4, $9, $12, $0, $2, $2, $4
; Tile graphic 63
.byt $0, $20, $0, $20, $10, $20, $20, $20
; Tile graphic 64
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 65
.byt $4, $4, $2, $1, $1, $2, $3, $0
; Tile graphic 66
.byt $4, $4, $6, $32, $9, $19, $20, $0
; Tile graphic 67
.byt $34, $4, $8, $8, $10, $15, $0, $20
; Tile graphic 68
.byt $20, $20, $20, $0, $0, $0, $0, $0
; Tile graphic 69
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 70
.byt $0, $1, $0, $0, $0, $28, $0, $0
; Tile graphic 71
.byt $20, $0, $0, $1, $0, $0, $0, $0
; Tile graphic 72
.byt $0, $0, $0, $10, $0, $0, $0, $0
; Tile graphic 73
.byt $e, $f, $1f, $3f, $38, $3f, $30, $38
; Tile graphic 74
.byt $7, $23, $8, $14, $4, $12, $12, $21
; Tile graphic 75
.byt $3f, $38, $3f, $f, $0, $9, $e, $4
; Tile graphic 76
.byt $38, $34, $30, $24, $a, $c, $14, $14
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $7e, $7e, $7c, $78
; Tile mask 2
.byt $ff, $78, $60, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $43, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $5f, $4f, $47, $47, $43, $43
; Tile mask 5
.byt $78, $78, $70, $70, $70, $70, $70, $70
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $43, $41, $41, $41, $40, $40, $40, $40
; Tile mask 9
.byt $70, $70, $78, $78, $7c, $7e, $ff, $7e
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $41, $41, $41, $43, $43
; Tile mask 13
.byt $ff, $7c, $7c, $78, $78, $70, $70, $70
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $43, $41, $41, $40, $40, $40, $40, $40
; Tile mask 17
.byt $70, $70, $70, $60, $60, $60, $60, $70
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 22
.byt $7e, $7e, $ff, $7e, $7c, $78, $78, $78
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $48, $48, $48, $48, $7e
; Tile mask 25
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 26
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 27
.byt $ff, $ff, $7c, $78, $70, $70, $60, $40
; Tile mask 28
.byt $ff, $40, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $ff, $5f, $43, $41, $40, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $5f
; Tile mask 31
.byt $ff, $ff, $7e, $7e, $7e, $7e, $7e, $7e
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $5f, $4f, $4f, $4f, $47, $47, $47, $47
; Tile mask 36
.byt $7e, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 37
.byt $40, $40, $40, $40, $60, $70, $78, $70
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $47, $47, $47, $4f, $4f, $4f, $5f, $5f
; Tile mask 41
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7c, $78
; Tile mask 42
.byt $78, $78, $70, $60, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 45
.byt $5f, $ff, $4f, $43, $41, $41, $41, $41
; Tile mask 46
.byt $70, $60, $60, $60, $60, $71, $ff, $ff
; Tile mask 47
.byt $48, $58, $58, $58, $78, $78, $78, $78
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $43, $4f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 51
.byt $78, $7c, $7c, $7c, $78, $78, $7c, $7e
; Tile mask 52
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $60, $70
; Tile mask 54
.byt $5f, $ff, $5f, $4f, $47, $43, $43, $4f
; Tile mask 55
.byt $70, $70, $70, $70, $60, $60, $60, $60
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $70, $7e, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $43, $47, $47, $43, $43, $41, $40, $40
; Tile mask 61
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7e, $7e
; Tile mask 62
.byt $78, $60, $60, $40, $40, $40, $40, $40
; Tile mask 63
.byt $5f, $4f, $47, $43, $43, $43, $47, $4f
; Tile mask 64
.byt $7e, $7e, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 65
.byt $40, $40, $40, $40, $40, $60, $70, $70
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $4f, $4f, $4f, $5f, $5f, $5f, $5f, $5f
; Tile mask 69
.byt $70, $70, $70, $60, $40, $40, $40, $70
; Tile mask 70
.byt $40, $40, $41, $47, $43, $41, $41, $41
; Tile mask 71
.byt $40, $40, $40, $40, $40, $40, $70, $ff
; Tile mask 72
.byt $5f, $5f, $4f, $47, $43, $43, $4f, $ff
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $43, $41, $41, $40, $40, $40, $40, $40
res_end
.)

