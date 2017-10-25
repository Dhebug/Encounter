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
; Animatory state 0 (door0.png)
.byt 1, 2, 3, 0, 0
.byt 4, 5, 6, 0, 0
.byt 4, 7, 6, 0, 0
.byt 4, 8, 6, 0, 0
.byt 4, 5, 6, 0, 0
.byt 9, 10, 6, 0, 0
.byt 0, 11, 12, 0, 0
; Animatory state 1 (door1.png)
.byt 1, 13, 14, 0, 0
.byt 4, 15, 16, 0, 0
.byt 4, 17, 18, 0, 0
.byt 4, 19, 20, 0, 0
.byt 4, 21, 16, 0, 0
.byt 9, 22, 16, 0, 0
.byt 0, 11, 23, 0, 0
; Animatory state 2 (door2.png)
.byt 1, 24, 25, 0, 0
.byt 4, 26, 4, 0, 0
.byt 4, 27, 28, 0, 0
.byt 4, 29, 30, 0, 0
.byt 4, 26, 4, 0, 0
.byt 9, 31, 4, 0, 0
.byt 0, 11, 32, 0, 0
; Animatory state 3 (door4.png)
.byt 1, 33, 25, 0, 0
.byt 4, 33, 4, 0, 0
.byt 4, 33, 4, 0, 0
.byt 4, 33, 4, 0, 0
.byt 4, 33, 4, 0, 0
.byt 9, 34, 4, 0, 0
.byt 0, 11, 32, 0, 0
costume_tiles
; Tile graphic 1
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 2
.byt $0, $3e, $3e, $3e, $3e, $3e, $3e, $3e
; Tile graphic 3
.byt $0, $0, $3c, $3e, $3f, $3f, $3f, $3f
; Tile graphic 4
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 5
.byt $3e, $3e, $3e, $3e, $3e, $3e, $3e, $3e
; Tile graphic 6
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 7
.byt $3d, $3b, $37, $2f, $2f, $2f, $2f, $2f
; Tile graphic 8
.byt $2f, $2f, $2f, $2f, $2f, $37, $3b, $3d
; Tile graphic 9
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 10
.byt $3e, $3e, $3e, $3e, $3e, $e, $6, $0
; Tile graphic 11
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 12
.byt $3f, $f, $7, $1, $0, $0, $0, $0
; Tile graphic 13
.byt $0, $3c, $3c, $3c, $3c, $3c, $3c, $3c
; Tile graphic 14
.byt $0, $0, $4, $6, $7, $7, $7, $7
; Tile graphic 15
.byt $3c, $3c, $3c, $3c, $3c, $3c, $3c, $38
; Tile graphic 16
.byt $7, $7, $7, $7, $7, $7, $7, $7
; Tile graphic 17
.byt $30, $20, $20, $21, $21, $21, $21, $21
; Tile graphic 18
.byt $f, $1f, $3f, $3f, $3f, $3f, $3f, $3f
; Tile graphic 19
.byt $21, $21, $21, $21, $21, $20, $20, $30
; Tile graphic 20
.byt $3f, $3f, $3f, $3f, $3f, $3f, $1f, $f
; Tile graphic 21
.byt $38, $3c, $3c, $3c, $3c, $3c, $3c, $3c
; Tile graphic 22
.byt $3c, $3c, $3c, $3c, $3c, $c, $4, $0
; Tile graphic 23
.byt $7, $7, $7, $1, $0, $0, $0, $0
; Tile graphic 24
.byt $0, $30, $30, $30, $30, $30, $30, $30
; Tile graphic 25
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 26
.byt $30, $30, $30, $30, $30, $30, $30, $30
; Tile graphic 27
.byt $30, $30, $0, $10, $0, $10, $0, $10
; Tile graphic 28
.byt $1, $3, $7, $f, $f, $f, $f, $f
; Tile graphic 29
.byt $0, $10, $0, $10, $0, $10, $20, $30
; Tile graphic 30
.byt $f, $f, $f, $f, $f, $7, $3, $1
; Tile graphic 31
.byt $30, $30, $30, $30, $30, $0, $0, $0
; Tile graphic 32
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 33
.byt $0, $10, $0, $10, $0, $10, $0, $10
; Tile graphic 34
.byt $0, $10, $0, $10, $0, $0, $0, $0
costume_masks
; Tile mask 1
.byt $78, $60, $40, $40, $40, $40, $40, $40
; Tile mask 2
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $47, $40, $40, $40, $40, $40, $40, $40
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
.byt $40, $40, $40, $40, $40, $ff, $ff, $ff
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $70, $78
; Tile mask 11
.byt $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff
; Tile mask 12
.byt $40, $40, $70, $78, $7e, $ff, $ff, $ff
; Tile mask 13
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 14
.byt $47, $40, $40, $40, $40, $40, $40, $40
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
.byt $40, $40, $40, $40, $40, $40, $70, $78
; Tile mask 23
.byt $40, $40, $70, $78, $7e, $ff, $ff, $ff
; Tile mask 24
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 25
.byt $47, $40, $40, $40, $40, $40, $40, $40
; Tile mask 26
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 27
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 28
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $40, $40, $40, $40, $40, $40, $70, $78
; Tile mask 32
.byt $40, $40, $70, $78, $7e, $ff, $ff, $ff
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $70, $78
res_end
.)

