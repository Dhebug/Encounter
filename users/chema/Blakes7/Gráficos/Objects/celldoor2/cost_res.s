.(
.byt RESOURCE_COSTUME
.word (res_end - res_start + 4)
.byt 201
res_start
	; Pointers to tiles
	.byt <(costume_tiles-res_start-8), >(costume_tiles-res_start-8)
	.byt <(costume_masks-res_start-8), >(costume_masks-res_start-8)
	; Number of costumes included
	.byt 1
	;Offsets to animatory states for each costume
	.byt <(anim_states - res_start), >(anim_states - res_start)
anim_states
; Animatory state 0 (celldoor2-0.png)
.byt 1, 2, 3, 4, 5
.byt 6, 7, 8, 9, 10
.byt 6, 9, 11, 12, 10
.byt 6, 9, 9, 13, 10
.byt 6, 9, 14, 9, 10
.byt 6, 15, 16, 17, 18
.byt 19, 20, 21, 22, 23
; Animatory state 1 (celldoor2-1.png)
.byt 24, 25, 26, 4, 5
.byt 27, 0, 0, 28, 10
.byt 6, 29, 30, 0, 10
.byt 6, 31, 32, 0, 10
.byt 33, 34, 0, 35, 10
.byt 36, 0, 37, 38, 18
.byt 39, 40, 21, 22, 23
; Animatory state 2 (celldoor2-2.png)
.byt 24, 25, 41, 42, 5
.byt 36, 0, 0, 0, 10
.byt 43, 44, 0, 0, 10
.byt 45, 46, 0, 0, 10
.byt 36, 0, 0, 0, 10
.byt 36, 0, 47, 48, 18
.byt 39, 40, 21, 22, 23
; Animatory state 3 (celldoor2-3.png)
.byt 24, 25, 41, 49, 5
.byt 36, 0, 0, 0, 10
.byt 36, 0, 0, 0, 10
.byt 36, 0, 0, 0, 10
.byt 36, 0, 0, 0, 10
.byt 36, 0, 47, 50, 18
.byt 39, 40, 21, 22, 23
costume_tiles
; Tile graphic 1
.byt $20, $1f, $1f, $1f, $1f, $1e, $1c, $1d
; Tile graphic 2
.byt $7, $3f, $3f, $3f, $30, $f, $3f, $1f
; Tile graphic 3
.byt $3f, $3f, $3f, $3f, $0, $3f, $3f, $3f
; Tile graphic 4
.byt $3f, $3f, $3f, $0, $3f, $3f, $3f, $3f
; Tile graphic 5
.byt $3e, $3e, $3e, $e, $16, $16, $16, $16
; Tile graphic 6
.byt $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d
; Tile graphic 7
.byt $2f, $37, $3b, $3d, $3e, $3f, $3f, $3f
; Tile graphic 8
.byt $3f, $3f, $3f, $3f, $3f, $1f, $2f, $37
; Tile graphic 9
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 10
.byt $16, $16, $16, $16, $16, $16, $16, $16
; Tile graphic 11
.byt $3b, $3d, $3e, $3f, $3f, $3f, $3f, $3f
; Tile graphic 12
.byt $3f, $3f, $3f, $1f, $2f, $37, $3b, $3d
; Tile graphic 13
.byt $3e, $3d, $3d, $3b, $37, $2f, $2f, $1f
; Tile graphic 14
.byt $3e, $3d, $3d, $3b, $37, $37, $2f, $1f
; Tile graphic 15
.byt $3e, $3e, $3d, $3b, $37, $37, $2f, $1f
; Tile graphic 16
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3c
; Tile graphic 17
.byt $3f, $3f, $3f, $3f, $3f, $3f, $30, $f
; Tile graphic 18
.byt $16, $16, $16, $16, $16, $16, $16, $26
; Tile graphic 19
.byt $1c, $1c, $1c, $1d, $1d, $3, $15, $3f
; Tile graphic 20
.byt $3e, $1, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 21
.byt $1, $3f, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 22
.byt $15, $3f, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 23
.byt $11, $3f, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 24
.byt $20, $1f, $1f, $1f, $1f, $1e, $1c, $1c
; Tile graphic 25
.byt $7, $3f, $3f, $3f, $30, $0, $0, $0
; Tile graphic 26
.byt $3f, $3f, $3f, $3f, $0, $3, $1, $0
; Tile graphic 27
.byt $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
; Tile graphic 28
.byt $1f, $f, $7, $3, $1, $0, $0, $0
; Tile graphic 29
.byt $0, $20, $30, $38, $3c, $3e, $3f, $3f
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 31
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3e, $3e
; Tile graphic 32
.byt $30, $38, $30, $30, $20, $0, $0, $0
; Tile graphic 33
.byt $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1c
; Tile graphic 34
.byt $3c, $38, $38, $30, $20, $0, $0, $0
; Tile graphic 35
.byt $0, $0, $0, $0, $1, $3, $7, $7
; Tile graphic 36
.byt $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c
; Tile graphic 37
.byt $0, $0, $0, $0, $1, $3, $7, $4
; Tile graphic 38
.byt $f, $1f, $3f, $3f, $3f, $3f, $30, $f
; Tile graphic 39
.byt $1c, $1c, $1c, $1d, $1d, $3, $15, $3f
; Tile graphic 40
.byt $0, $1, $15, $3f, $15, $3f, $15, $3f
; Tile graphic 41
.byt $3f, $3f, $3f, $3f, $0, $0, $0, $0
; Tile graphic 42
.byt $3f, $3f, $3f, $0, $3, $1, $0, $0
; Tile graphic 43
.byt $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1d
; Tile graphic 44
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 45
.byt $1d, $1d, $1d, $1d, $1d, $1c, $1c, $1c
; Tile graphic 46
.byt $20, $30, $30, $20, $0, $0, $0, $0
; Tile graphic 47
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 48
.byt $0, $0, $0, $1, $1, $3, $0, $f
; Tile graphic 49
.byt $3f, $3f, $3f, $0, $0, $0, $0, $0
; Tile graphic 50
.byt $0, $0, $0, $0, $0, $0, $0, $f
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
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 25
.byt $40, $40, $40, $40, $40, $4f, $ff, $ff
; Tile mask 26
.byt $40, $40, $40, $40, $40, $78, $7c, $7e
; Tile mask 27
.byt $41, $41, $41, $41, $41, $41, $41, $40
; Tile mask 28
.byt $40, $60, $70, $78, $7c, $7e, $ff, $ff
; Tile mask 29
.byt $5f, $4f, $47, $43, $41, $40, $40, $40
; Tile mask 30
.byt $ff, $ff, $ff, $ff, $ff, $ff, $5f, $4f
; Tile mask 31
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 32
.byt $47, $43, $47, $47, $4f, $5f, $ff, $ff
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $41, $43, $43, $47, $4f, $5f, $5f, $ff
; Tile mask 35
.byt $ff, $ff, $7e, $7e, $7c, $78, $70, $70
; Tile mask 36
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile mask 37
.byt $ff, $ff, $7e, $7e, $7c, $78, $70, $70
; Tile mask 38
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $41, $41, $40, $40, $40, $40, $40, $40
; Tile mask 40
.byt $7e, $40, $40, $40, $40, $40, $40, $40
; Tile mask 41
.byt $40, $40, $40, $40, $40, $ff, $ff, $ff
; Tile mask 42
.byt $40, $40, $40, $40, $78, $7c, $7e, $ff
; Tile mask 43
.byt $41, $41, $41, $41, $41, $41, $40, $40
; Tile mask 44
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $5f
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $41, $41
; Tile mask 46
.byt $4f, $47, $47, $4f, $5f, $ff, $ff, $ff
; Tile mask 47
.byt $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7c
; Tile mask 48
.byt $ff, $ff, $7e, $7c, $7c, $78, $70, $40
; Tile mask 49
.byt $40, $40, $40, $40, $ff, $ff, $ff, $ff
; Tile mask 50
.byt $ff, $ff, $ff, $ff, $ff, $ff, $70, $40
res_end
.)

