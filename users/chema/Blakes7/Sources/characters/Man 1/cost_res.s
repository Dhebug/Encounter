.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 5
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
.byt 17, 18, 19, 20, 0
.byt 21, 22, 23, 24, 0
; Animatory state 1 (01-step1.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 2 (02-step2.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 3 (03-step3.png)
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
.byt 0, 0, 0, 0, 0
; Animatory state 4 (04-front.png)
.byt 0, 0, 0, 0, 0
.byt 25, 26, 27, 28, 0
.byt 29, 30, 30, 31, 0
.byt 32, 33, 34, 35, 0
.byt 36, 37, 38, 39, 0
.byt 40, 41, 42, 43, 44
.byt 45, 46, 47, 48, 0
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
.byt 25, 49, 50, 51, 0
.byt 52, 53, 54, 55, 0
.byt 56, 57, 58, 59, 0
.byt 36, 60, 61, 62, 0
.byt 63, 41, 41, 64, 44
.byt 65, 66, 67, 68, 0
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
.byt 9, 69, 70, 71, 0
.byt 13, 72, 73, 74, 0
.byt 17, 18, 19, 20, 0
.byt 21, 22, 23, 24, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 2
.byt $0, $0, $0, $4, $a, $11, $2b, $7
; Tile graphic 3
.byt $0, $0, $20, $0, $25, $3a, $3f, $3f
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $20, $38, $38
; Tile graphic 5
.byt $2, $0, $2, $0, $2, $0, $1, $1
; Tile graphic 6
.byt $2b, $7, $2b, $7, $3, $3, $20, $13
; Tile graphic 7
.byt $3f, $3f, $3f, $3, $3f, $3, $34, $3
; Tile graphic 8
.byt $3c, $3c, $3c, $20, $3c, $20, $14, $20
; Tile graphic 9
.byt $1, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 10
.byt $23, $31, $3d, $7, $1b, $b, $d, $4
; Tile graphic 11
.byt $3f, $3f, $3e, $3f, $3f, $38, $3f, $3e
; Tile graphic 12
.byt $3c, $3c, $1c, $3c, $38, $8, $38, $10
; Tile graphic 13
.byt $0, $0, $0, $0, $0, $0, $0, $3
; Tile graphic 14
.byt $1, $0, $0, $8, $0, $8, $0, $20
; Tile graphic 15
.byt $e, $20, $a, $0, $0, $0, $0, $0
; Tile graphic 16
.byt $10, $0, $20, $0, $8, $0, $0, $4
; Tile graphic 17
.byt $3, $3, $3, $7, $7, $7, $7, $0
; Tile graphic 18
.byt $20, $20, $20, $20, $30, $2, $35, $a
; Tile graphic 19
.byt $0, $0, $0, $0, $0, $2d, $14, $2a
; Tile graphic 20
.byt $4, $4, $4, $6, $6, $12, $16, $20
; Tile graphic 21
.byt $0, $0, $0, $0, $0, $0, $1, $0
; Tile graphic 22
.byt $15, $a, $15, $a, $3f, $7, $3f, $0
; Tile graphic 23
.byt $15, $22, $15, $22, $23, $23, $1, $0
; Tile graphic 24
.byt $10, $20, $10, $28, $3c, $30, $3e, $0
; Tile graphic 25
.byt $0, $0, $0, $0, $0, $1, $2, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $29, $1e, $3f, $3f
; Tile graphic 27
.byt $0, $0, $0, $0, $10, $2b, $3f, $3f
; Tile graphic 28
.byt $0, $0, $0, $0, $20, $10, $28, $20
; Tile graphic 29
.byt $2, $1, $2, $1, $2, $0, $2, $2
; Tile graphic 30
.byt $3f, $3f, $3f, $31, $3f, $31, $a, $31
; Tile graphic 31
.byt $28, $30, $28, $30, $28, $20, $8, $28
; Tile graphic 32
.byt $3, $1, $0, $0, $0, $0, $0, $0
; Tile graphic 33
.byt $3f, $3f, $3f, $3f, $3f, $1c, $1f, $f
; Tile graphic 34
.byt $3f, $3f, $f, $3f, $3f, $7, $3f, $e
; Tile graphic 35
.byt $38, $30, $20, $20, $20, $0, $0, $0
; Tile graphic 36
.byt $0, $0, $0, $1, $0, $1, $0, $e
; Tile graphic 37
.byt $13, $8, $2, $0, $0, $0, $0, $0
; Tile graphic 38
.byt $8, $1, $28, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $0, $0, $0, $10, $0, $10, $0, $e
; Tile graphic 40
.byt $e, $e, $e, $1e, $1a, $18, $1e, $0
; Tile graphic 41
.byt $0, $0, $0, $0, $0, $2a, $15, $2a
; Tile graphic 42
.byt $0, $0, $0, $0, $0, $32, $15, $2a
; Tile graphic 43
.byt $e, $e, $e, $f, $b, $23, $f, $20
; Tile graphic 44
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 45
.byt $0, $0, $0, $0, $3, $0, $7, $0
; Tile graphic 46
.byt $15, $2a, $15, $2a, $3e, $1e, $3c, $0
; Tile graphic 47
.byt $15, $a, $15, $a, $f, $f, $7, $0
; Tile graphic 48
.byt $0, $20, $0, $20, $30, $0, $38, $0
; Tile graphic 49
.byt $0, $0, $2, $0, $2a, $0, $22, $0
; Tile graphic 50
.byt $0, $0, $28, $0, $2a, $0, $a, $0
; Tile graphic 51
.byt $0, $0, $0, $0, $20, $10, $28, $0
; Tile graphic 52
.byt $2, $0, $2, $0, $2, $0, $0, $0
; Tile graphic 53
.byt $22, $0, $2a, $0, $8, $0, $8, $0
; Tile graphic 54
.byt $8, $0, $28, $0, $2a, $0, $22, $0
; Tile graphic 55
.byt $28, $0, $8, $0, $8, $0, $0, $0
; Tile graphic 56
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 57
.byt $0, $0, $0, $0, $10, $8, $15, $2
; Tile graphic 58
.byt $22, $0, $0, $0, $0, $2, $15, $28
; Tile graphic 59
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 60
.byt $0, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 61
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 62
.byt $0, $20, $0, $10, $0, $10, $0, $e
; Tile graphic 63
.byt $e, $a, $e, $1e, $1e, $18, $1e, $0
; Tile graphic 64
.byt $e, $a, $e, $f, $f, $23, $f, $20
; Tile graphic 65
.byt $0, $0, $0, $0, $3, $7, $7, $0
; Tile graphic 66
.byt $15, $28, $15, $2a, $3e, $3e, $3c, $0
; Tile graphic 67
.byt $15, $2, $15, $a, $f, $f, $7, $0
; Tile graphic 68
.byt $0, $20, $0, $20, $30, $38, $38, $0
; Tile graphic 69
.byt $23, $31, $3d, $7, $1b, $b, $9, $5
; Tile graphic 70
.byt $3f, $3f, $3e, $3f, $3f, $3c, $3c, $3f
; Tile graphic 71
.byt $3c, $3c, $1c, $3c, $38, $8, $18, $38
; Tile graphic 72
.byt $0, $2, $0, $8, $0, $8, $0, $20
; Tile graphic 73
.byt $3e, $e, $20, $5, $0, $0, $0, $0
; Tile graphic 74
.byt $10, $10, $0, $0, $8, $0, $0, $4
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $ff, $ff, $7e, $7c, $7c
; Tile mask 2
.byt $ff, $7e, $78, $60, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $41, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $5f, $4f, $47, $47, $43, $43
; Tile mask 5
.byt $78, $78, $78, $78, $78, $78, $78, $78
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile mask 9
.byt $78, $7c, $7e, $7e, $ff, $ff, $ff, $ff
; Tile mask 10
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $41, $41, $41, $41, $43, $43, $43, $47
; Tile mask 13
.byt $ff, $7e, $7c, $7c, $7c, $78, $78, $78
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $47, $47, $43, $43, $41, $41, $41, $41
; Tile mask 17
.byt $78, $78, $78, $70, $70, $70, $70, $78
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $41, $41, $41, $40, $40, $40, $40, $41
; Tile mask 21
.byt $ff, $ff, $ff, $ff, $7e, $7c, $7c, $7c
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $40, $40, $40, $48, $48, $48, $48, $7e
; Tile mask 24
.byt $47, $47, $47, $43, $41, $40, $40, $40
; Tile mask 25
.byt $ff, $ff, $ff, $ff, $7e, $7c, $78, $78
; Tile mask 26
.byt $ff, $78, $60, $40, $40, $40, $40, $40
; Tile mask 27
.byt $ff, $43, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $ff, $ff, $ff, $5f, $4f, $47, $43, $43
; Tile mask 29
.byt $78, $70, $70, $70, $70, $70, $70, $70
; Tile mask 30
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $43, $41, $41, $41, $41, $41, $41, $41
; Tile mask 32
.byt $78, $78, $78, $7c, $7e, $ff, $ff, $7e
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $43, $43, $43, $47, $4f, $5f, $5f, $4f
; Tile mask 36
.byt $7c, $78, $78, $70, $70, $60, $60, $60
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $47, $43, $43, $41, $41, $40, $40, $40
; Tile mask 40
.byt $60, $60, $60, $40, $40, $40, $40, $60
; Tile mask 41
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 45
.byt $7e, $7e, $7e, $7c, $78, $70, $70, $70
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 47
.byt $40, $40, $40, $60, $60, $60, $60, $78
; Tile mask 48
.byt $4f, $4f, $4f, $4f, $47, $43, $43, $43
; Tile mask 49
.byt $ff, $78, $60, $40, $40, $40, $40, $40
; Tile mask 50
.byt $ff, $43, $40, $40, $40, $40, $40, $40
; Tile mask 51
.byt $ff, $ff, $ff, $5f, $4f, $47, $43, $43
; Tile mask 52
.byt $78, $70, $70, $70, $70, $70, $70, $70
; Tile mask 53
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 55
.byt $43, $41, $41, $41, $41, $41, $41, $41
; Tile mask 56
.byt $78, $78, $78, $7c, $7e, $ff, $ff, $7e
; Tile mask 57
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 58
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 59
.byt $43, $43, $43, $47, $4f, $5f, $5f, $4f
; Tile mask 60
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 62
.byt $47, $43, $43, $41, $41, $40, $40, $40
; Tile mask 63
.byt $60, $60, $60, $40, $40, $40, $40, $60
; Tile mask 64
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $7e, $7e, $7e, $7c, $78, $70, $70, $70
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $40, $43
; Tile mask 67
.byt $40, $40, $40, $60, $60, $60, $60, $78
; Tile mask 68
.byt $4f, $4f, $4f, $4f, $47, $43, $43, $43
; Tile mask 69
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 70
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 71
.byt $41, $41, $41, $41, $43, $43, $43, $43
; Tile mask 72
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 73
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 74
.byt $47, $47, $43, $43, $41, $41, $41, $41
res_end
.)

