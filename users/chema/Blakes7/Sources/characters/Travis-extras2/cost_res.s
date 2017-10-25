.(
.byt RESOURCE_COSTUME|$80
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
.byt 13, 14, 15, 16, 17
.byt 18, 19, 20, 21, 22
.byt 23, 24, 25, 26, 0
; Animatory state 1 (02-lookRight - 2.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 27, 28
.byt 13, 14, 15, 29, 30
.byt 18, 19, 20, 21, 31
.byt 23, 24, 25, 26, 0
; Animatory state 2 (02-lookRight - 3.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 32
.byt 13, 14, 15, 33, 34
.byt 18, 19, 20, 21, 22
.byt 23, 24, 25, 26, 0
; Animatory state 3 (02-lookRight - 4.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 35, 36
.byt 13, 14, 15, 37, 38
.byt 18, 19, 20, 21, 39
.byt 23, 24, 25, 26, 0
; Animatory state 4 (02-lookRight - 5.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 40, 41
.byt 13, 14, 15, 42, 43
.byt 18, 19, 20, 44, 45
.byt 23, 24, 25, 26, 0
; Animatory state 5 (02-lookRight - 6.png)
.byt 0, 0, 0, 0, 0
.byt 1, 2, 3, 4, 0
.byt 5, 6, 7, 8, 0
.byt 9, 10, 11, 12, 0
.byt 13, 14, 15, 16, 46
.byt 18, 19, 20, 47, 48
.byt 23, 24, 25, 26, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $0, $0, $5, $8, $0, $0, $a
; Tile graphic 3
.byt $0, $0, $0, $10, $a, $0, $0, $38
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 5
.byt $0, $0, $0, $0, $0, $0, $2, $6
; Tile graphic 6
.byt $15, $2, $0, $2, $5, $8, $4, $a
; Tile graphic 7
.byt $15, $3f, $1f, $f, $c, $b, $c, $a
; Tile graphic 8
.byt $10, $38, $38, $38, $c, $34, $1c, $2c
; Tile graphic 9
.byt $7, $7, $7, $7, $3, $0, $0, $0
; Tile graphic 10
.byt $4, $0, $20, $3f, $1f, $1f, $1f, $2f
; Tile graphic 11
.byt $1d, $1f, $3f, $3f, $31, $3f, $22, $3f
; Tile graphic 12
.byt $3c, $3c, $3c, $38, $38, $38, $30, $30
; Tile graphic 13
.byt $0, $1, $2, $4, $0, $0, $0, $1
; Tile graphic 14
.byt $7, $3, $10, $28, $8, $24, $24, $2
; Tile graphic 15
.byt $31, $3f, $3f, $0, $0, $12, $1c, $8
; Tile graphic 16
.byt $20, $28, $1, $a, $14, $1a, $29, $22
; Tile graphic 17
.byt $0, $0, $3f, $6, $0, $3, $6, $38
; Tile graphic 18
.byt $1, $1e, $1, $0, $12, $13, $8, $3
; Tile graphic 19
.byt $1, $1, $0, $20, $20, $35, $20, $0
; Tile graphic 20
.byt $d, $1, $22, $22, $14, $15, $0, $0
; Tile graphic 21
.byt $2, $2, $3, $0, $0, $10, $0, $0
; Tile graphic 22
.byt $20, $18, $20, $0, $0, $0, $0, $0
; Tile graphic 23
.byt $0, $0, $0, $0, $2, $0, $0, $0
; Tile graphic 24
.byt $0, $0, $0, $0, $20, $0, $0, $0
; Tile graphic 25
.byt $0, $10, $0, $0, $0, $0, $0, $0
; Tile graphic 26
.byt $0, $0, $0, $0, $14, $0, $0, $0
; Tile graphic 27
.byt $3c, $3c, $3c, $38, $38, $38, $30, $30
; Tile graphic 28
.byt $0, $0, $0, $0, $0, $0, $20, $20
; Tile graphic 29
.byt $20, $28, $1, $3, $13, $19, $28, $22
; Tile graphic 30
.byt $20, $20, $37, $38, $38, $33, $26, $28
; Tile graphic 31
.byt $20, $28, $0, $0, $0, $0, $0, $0
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 33
.byt $20, $28, $0, $a, $14, $1a, $29, $22
; Tile graphic 34
.byt $18, $3c, $3d, $18, $6, $1e, $1e, $2c
; Tile graphic 35
.byt $3c, $3c, $3c, $38, $38, $39, $33, $37
; Tile graphic 36
.byt $0, $0, $0, $0, $0, $30, $38, $3c
; Tile graphic 37
.byt $27, $27, $7, $7, $12, $18, $28, $22
; Tile graphic 38
.byt $3c, $3c, $21, $1c, $3e, $3e, $3e, $3e
; Tile graphic 39
.byt $1c, $0, $20, $0, $0, $0, $0, $0
; Tile graphic 40
.byt $3c, $3c, $3c, $38, $38, $38, $30, $31
; Tile graphic 41
.byt $0, $0, $0, $0, $0, $0, $30, $38
; Tile graphic 42
.byt $21, $29, $0, $a, $14, $1b, $27, $27
; Tile graphic 43
.byt $38, $38, $33, $2, $0, $1, $25, $21
; Tile graphic 44
.byt $3, $0, $3, $0, $2, $13, $0, $0
; Tile graphic 45
.byt $c, $1e, $1e, $1e, $2c, $20, $0, $0
; Tile graphic 46
.byt $0, $0, $33, $2, $0, $1, $5, $9
; Tile graphic 47
.byt $2, $2, $3, $0, $2, $13, $0, $0
; Tile graphic 48
.byt $20, $3, $2, $c, $30, $20, $0, $0
costume_masks
; Tile mask 1
.byt $ff, $ff, $ff, $7e, $7c, $7c, $78, $70
; Tile mask 2
.byt $ff, $70, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $ff, $47, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $ff, $ff, $ff, $5f, $4f, $4f, $47, $47
; Tile mask 5
.byt $70, $70, $60, $60, $60, $60, $60, $60
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $47, $43, $43, $43, $41, $41, $41, $41
; Tile mask 9
.byt $60, $60, $70, $70, $78, $7c, $7e, $7c
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $41, $41, $41, $43, $43, $43, $47, $47
; Tile mask 13
.byt $7e, $78, $78, $70, $70, $60, $60, $60
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $47, $43, $42, $40, $40, $40, $40, $40
; Tile mask 17
.byt $ff, $ff, $40, $40, $40, $40, $41, $43
; Tile mask 18
.byt $60, $60, $60, $40, $40, $40, $40, $60
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $47, $47, $47, $47
; Tile mask 22
.byt $43, $43, $43, $4f, $ff, $ff, $ff, $ff
; Tile mask 23
.byt $7c, $7c, $7e, $7c, $78, $70, $70, $70
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $41
; Tile mask 25
.byt $40, $40, $40, $50, $50, $50, $50, $7c
; Tile mask 26
.byt $47, $47, $47, $43, $41, $40, $40, $40
; Tile mask 27
.byt $41, $41, $41, $43, $43, $43, $46, $46
; Tile mask 28
.byt $ff, $ff, $5f, $5f, $5f, $5f, $4f, $4f
; Tile mask 29
.byt $46, $42, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $4f, $4f, $40, $40, $40, $40, $41, $43
; Tile mask 31
.byt $43, $43, $43, $4f, $5f, $5f, $ff, $ff
; Tile mask 32
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $63
; Tile mask 33
.byt $47, $42, $42, $40, $40, $40, $40, $40
; Tile mask 34
.byt $43, $41, $40, $40, $40, $40, $40, $41
; Tile mask 35
.byt $41, $41, $41, $43, $42, $40, $40, $40
; Tile mask 36
.byt $ff, $ff, $ff, $ff, $4f, $47, $43, $41
; Tile mask 37
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 38
.byt $41, $41, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $41, $43, $43, $4f, $ff, $ff, $ff, $ff
; Tile mask 40
.byt $41, $41, $41, $43, $43, $43, $46, $44
; Tile mask 41
.byt $ff, $ff, $ff, $ff, $ff, $4f, $47, $43
; Tile mask 42
.byt $44, $40, $42, $40, $40, $40, $40, $40
; Tile mask 43
.byt $43, $43, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $40, $40, $40, $40, $44, $44, $47, $47
; Tile mask 45
.byt $40, $40, $40, $40, $41, $53, $ff, $ff
; Tile mask 46
.byt $77, $77, $40, $40, $40, $40, $40, $40
; Tile mask 47
.byt $40, $40, $40, $40, $44, $44, $47, $47
; Tile mask 48
.byt $40, $40, $41, $43, $4f, $5f, $ff, $ff
res_end
.)

