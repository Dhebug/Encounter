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
; Animatory state 0 (celldoor1-0.png)
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 8, 9
.byt 8, 10, 11, 8, 9
.byt 8, 8, 8, 12, 9
.byt 8, 8, 13, 14, 9
.byt 15, 16, 17, 8, 9
.byt 18, 19, 20, 21, 22
; Animatory state 1 (celldoor1-1.png)
.byt 23, 24, 25, 4, 5
.byt 0, 0, 26, 27, 9
.byt 28, 29, 0, 30, 9
.byt 8, 31, 32, 0, 9
.byt 33, 34, 0, 0, 9
.byt 35, 0, 36, 37, 9
.byt 38, 39, 40, 21, 22
; Animatory state 2 (celldoor1-2.png)
.byt 23, 41, 42, 43, 5
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 44, 0, 0, 0, 9
.byt 45, 0, 0, 0, 9
.byt 0, 0, 0, 36, 9
.byt 38, 46, 47, 48, 22
; Animatory state 3 (celldoor1-3.png)
.byt 23, 41, 42, 49, 5
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 0, 0, 0, 0, 9
.byt 38, 46, 47, 50, 22
costume_tiles
; Tile graphic 1
.byt $3f, $3f, $3f, $3c, $3, $3f, $1f, $2f
; Tile graphic 2
.byt $3f, $3f, $3f, $0, $3f, $3f, $3f, $3f
; Tile graphic 3
.byt $3f, $3f, $3e, $1, $3f, $3f, $3f, $3f
; Tile graphic 4
.byt $3f, $3f, $0, $3f, $3f, $3f, $3f, $3f
; Tile graphic 5
.byt $3e, $3e, $3e, $e, $16, $16, $16, $16
; Tile graphic 6
.byt $37, $3b, $3d, $3e, $3f, $3f, $3f, $3f
; Tile graphic 7
.byt $3f, $3f, $3f, $3f, $1f, $2f, $37, $3b
; Tile graphic 8
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 9
.byt $16, $16, $16, $16, $16, $16, $16, $16
; Tile graphic 10
.byt $3d, $3e, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 11
.byt $3f, $3f, $1f, $2f, $37, $3b, $3d, $3e
; Tile graphic 12
.byt $1f, $2f, $37, $3b, $3d, $3e, $3d, $3b
; Tile graphic 13
.byt $3f, $3f, $3f, $3e, $3d, $3b, $37, $2f
; Tile graphic 14
.byt $37, $2f, $1f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 15
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3e
; Tile graphic 16
.byt $3f, $3e, $3d, $3b, $37, $2f, $1f, $3f
; Tile graphic 17
.byt $1f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 18
.byt $3d, $3b, $37, $2f, $1f, $3f, $3e, $1
; Tile graphic 19
.byt $3f, $3f, $3f, $3f, $3f, $3c, $1, $3f
; Tile graphic 20
.byt $3f, $3f, $3f, $3f, $38, $7, $15, $3f
; Tile graphic 21
.byt $3f, $3f, $3f, $0, $15, $3f, $15, $3f
; Tile graphic 22
.byt $16, $16, $16, $16, $16, $26, $11, $3f
; Tile graphic 23
.byt $3f, $3f, $3f, $3c, $0, $0, $0, $0
; Tile graphic 24
.byt $3f, $3f, $3f, $0, $1, $0, $0, $0
; Tile graphic 25
.byt $3f, $3f, $3e, $1, $3f, $3f, $1f, $f
; Tile graphic 26
.byt $7, $3, $1, $0, $0, $0, $0, $0
; Tile graphic 27
.byt $3f, $3f, $3f, $3f, $1f, $f, $7, $3
; Tile graphic 28
.byt $0, $20, $30, $38, $3c, $3e, $3f, $3f
; Tile graphic 29
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 30
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 31
.byt $30, $38, $3c, $3e, $3f, $3f, $3f, $3e
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $20, $0, $0
; Tile graphic 33
.byt $3f, $3f, $3f, $3f, $3f, $3e, $3c, $38
; Tile graphic 34
.byt $3c, $38, $30, $20, $0, $0, $0, $0
; Tile graphic 35
.byt $30, $20, $0, $0, $0, $0, $0, $0
; Tile graphic 36
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 37
.byt $0, $1, $3, $7, $f, $1f, $3f, $3f
; Tile graphic 38
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 39
.byt $0, $0, $0, $0, $0, $0, $1, $3f
; Tile graphic 40
.byt $3, $7, $f, $1f, $38, $7, $15, $3f
; Tile graphic 41
.byt $3f, $3f, $3f, $0, $0, $0, $0, $0
; Tile graphic 42
.byt $3f, $3f, $3e, $0, $0, $0, $0, $0
; Tile graphic 43
.byt $3f, $3f, $0, $f, $7, $3, $1, $0
; Tile graphic 44
.byt $0, $0, $20, $30, $38, $3c, $38, $30
; Tile graphic 45
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 46
.byt $0, $0, $0, $0, $0, $0, $1, $3f
; Tile graphic 47
.byt $0, $0, $0, $0, $0, $7, $15, $3f
; Tile graphic 48
.byt $3, $7, $f, $0, $15, $3f, $15, $3f
; Tile graphic 49
.byt $3f, $3f, $0, $0, $0, $0, $0, $0
; Tile graphic 50
.byt $0, $0, $0, $0, $15, $3f, $15, $3f
costume_masks
; Tile mask 1
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 4
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 16
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 22
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 23
.byt $40, $40, $40, $40, $43, $ff, $ff, $ff
; Tile mask 24
.byt $40, $40, $40, $40, $7c, $7e, $ff, $ff
; Tile mask 25
.byt $40, $40, $40, $40, $40, $40, $40, $60
; Tile mask 26
.byt $70, $78, $7c, $7e, $ff, $ff, $ff, $ff
; Tile mask 27
.byt $40, $40, $40, $40, $40, $60, $70, $78
; Tile mask 28
.byt $5f, $4f, $47, $43, $41, $40, $40, $40
; Tile mask 29
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $4f
; Tile mask 30
.byt $7c, $7e, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 31
.byt $47, $43, $41, $40, $40, $40, $40, $40
; Tile mask 32
.byt $ff, $ff, $ff, $ff, $5f, $4f, $5f, $ff
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $41, $43
; Tile mask 34
.byt $41, $43, $47, $4f, $5f, $ff, $ff, $ff
; Tile mask 35
.byt $47, $4f, $5f, $ff, $ff, $ff, $ff, $ff
; Tile mask 36
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $7c
; Tile mask 37
.byt $7e, $7c, $78, $70, $60, $40, $40, $40
; Tile mask 38
.byt $ff, $ff, $ff, $ff, $ff, $ff, $7e, $40
; Tile mask 39
.byt $ff, $ff, $ff, $ff, $7e, $7c, $40, $40
; Tile mask 40
.byt $78, $70, $60, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 42
.byt $40, $40, $40, $41, $ff, $ff, $ff, $ff
; Tile mask 43
.byt $40, $40, $40, $60, $70, $78, $7c, $7e
; Tile mask 44
.byt $ff, $5f, $4f, $47, $43, $41, $43, $47
; Tile mask 45
.byt $4f, $5f, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 46
.byt $ff, $ff, $ff, $ff, $ff, $7c, $40, $40
; Tile mask 47
.byt $ff, $ff, $ff, $ff, $78, $40, $40, $40
; Tile mask 48
.byt $78, $70, $60, $40, $40, $40, $40, $40
; Tile mask 49
.byt $40, $40, $40, $ff, $ff, $ff, $ff, $ff
; Tile mask 50
.byt $ff, $ff, $ff, $40, $40, $40, $40, $40
res_end
.)

