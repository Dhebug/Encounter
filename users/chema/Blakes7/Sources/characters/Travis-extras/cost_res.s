.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 250
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
.byt 0, 17, 18, 19, 20
.byt 21, 22, 23, 24, 25
; Animatory state 1 (01-test2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 13, 14, 26, 27, 28
.byt 0, 17, 29, 30, 20
.byt 21, 22, 23, 24, 25
; Animatory state 2 (02-test3.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 31, 0
.byt 13, 14, 26, 32, 33
.byt 0, 17, 29, 34, 20
.byt 21, 22, 23, 24, 25
; Animatory state 3 (03-test4.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 13, 14, 26, 35, 36
.byt 0, 17, 29, 37, 38
.byt 21, 22, 23, 24, 25
; Animatory state 4 (04-test5.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 13, 14, 39, 40, 41
.byt 0, 17, 18, 42, 20
.byt 21, 22, 23, 24, 25
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
.byt 9, 10, 43, 12, 0
.byt 13, 44, 45, 46, 0
.byt 0, 17, 18, 19, 20
.byt 21, 22, 23, 24, 25
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
.byt $3, $21, $8, $14, $7, $c, $0, $0
; Tile graphic 15
.byt $38, $3f, $1f, $0, $3c, $2, $5, $0
; Tile graphic 16
.byt $30, $34, $20, $4, $0, $20, $8, $20
; Tile graphic 17
.byt $20, $1f, $0, $0, $0, $a, $0, $0
; Tile graphic 18
.byt $5, $38, $11, $11, $a, $2a, $0, $0
; Tile graphic 19
.byt $10, $0, $0, $3, $3, $29, $3, $0
; Tile graphic 20
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 21
.byt $0, $0, $0, $0, $1, $0, $0, $0
; Tile graphic 22
.byt $0, $0, $0, $0, $10, $0, $0, $0
; Tile graphic 23
.byt $0, $8, $0, $0, $0, $0, $0, $0
; Tile graphic 24
.byt $0, $0, $0, $0, $a, $0, $0, $0
; Tile graphic 25
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 26
.byt $38, $3f, $1f, $0, $3f, $0, $0, $0
; Tile graphic 27
.byt $30, $34, $20, $4, $1f, $20, $20, $27
; Tile graphic 28
.byt $0, $0, $0, $0, $0, $20, $20, $0
; Tile graphic 29
.byt $0, $3f, $11, $11, $a, $2a, $0, $0
; Tile graphic 30
.byt $3c, $10, $0, $3, $3, $29, $3, $0
; Tile graphic 31
.byt $3e, $3e, $3e, $3c, $3c, $3c, $18, $38
; Tile graphic 32
.byt $32, $32, $22, $7, $1f, $27, $22, $22
; Tile graphic 33
.byt $0, $0, $0, $0, $30, $0, $20, $0
; Tile graphic 34
.byt $3a, $10, $0, $1, $3, $29, $3, $0
; Tile graphic 35
.byt $30, $33, $27, $f, $f, $2f, $2f, $27
; Tile graphic 36
.byt $0, $20, $30, $38, $38, $38, $38, $30
; Tile graphic 37
.byt $3b, $10, $0, $3, $3, $29, $3, $0
; Tile graphic 38
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $38, $3e, $1d, $3, $3b, $1, $4, $0
; Tile graphic 40
.byt $30, $4, $20, $33, $37, $27, $3, $20
; Tile graphic 41
.byt $0, $0, $0, $0, $20, $20, $0, $0
; Tile graphic 42
.byt $0, $38, $3c, $3d, $3b, $1, $3, $0
; Tile graphic 43
.byt $e, $f, $1f, $3f, $38, $3f, $30, $38
; Tile graphic 44
.byt $7, $23, $8, $14, $7, $c, $0, $0
; Tile graphic 45
.byt $3f, $38, $3f, $f, $3c, $2, $5, $0
; Tile graphic 46
.byt $38, $34, $30, $24, $0, $20, $8, $20
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
.byt $ff, $7c, $7c, $78, $78, $78, $7c, $7e
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $43, $41, $41, $41, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $ff, $ff, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 21
.byt $ff, $ff, $ff, $7e, $7c, $78, $78, $78
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $40, $40, $40, $48, $48, $48, $48, $7e
; Tile mask 24
.byt $43, $43, $43, $41, $40, $40, $40, $40
; Tile mask 25
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $5f
; Tile mask 26
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 27
.byt $43, $41, $41, $40, $40, $40, $40, $40
; Tile mask 28
.byt $ff, $ff, $ff, $ff, $ff, $5f, $5f, $ff
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $40, $40, $40, $41, $41, $41, $41, $41
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $ff, $ff, $ff, $4f, $47, $4f, $5f, $ff
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 36
.byt $5f, $47, $47, $43, $43, $43, $43, $47
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $47, $5f, $ff, $5f, $5f, $5f, $5f, $ff
; Tile mask 39
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $ff, $ff, $5f, $5f, $4f, $4f, $5f, $ff
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $43, $41, $41, $41, $40, $40, $40, $40
res_end
.)

